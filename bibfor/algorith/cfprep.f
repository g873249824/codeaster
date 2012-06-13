      SUBROUTINE CFPREP(NOMA  ,DEFICO,RESOCO,MATASS,DDEPLA,
     &                  DEPDEL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.
C
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.
C
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 MATASS
      CHARACTER*19 DDEPLA,DEPDEL
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE DISCRETE - ALGORITHME)
C
C PREPARATION DES CALCULS
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  DDEPLA : INCREMENT DE DEPLACEMENT DEPUIS L'ITERATION
C              DE NEWTON PRECEDENTE
C IN  DEPDEL : INCREMENT DE DEPLACEMENT CUMULE DEPUIS DEBUT DU PAS
C
C
C
C
      INTEGER      IFM,NIV
      INTEGER      NBLIAI,NTPC,NDIM
      INTEGER      ILIAI
      INTEGER      LMAT
      CHARACTER*19 LIOT,LIAC
      INTEGER      JLIOT,JLIAC
      CHARACTER*19 MU,COPO
      INTEGER      JMU,JCOPO
      CHARACTER*24 CLREAC
      INTEGER      JCLREA
      INTEGER      CFDISD,CFDISI
      LOGICAL      CFDISL,LPENAC,LCTFD,LPENAF
      LOGICAL      LLAGRC,LLAGRF,REAPRE,REAGEO
      REAL*8       VDIAGM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ...... PREPARATION DU CALCUL'
      ENDIF
C
C --- PARAMETRES
C
      NBLIAI = CFDISD(RESOCO,'NBLIAI'  )
      NDIM   = CFDISD(RESOCO,'NDIM'    )
      NTPC   = CFDISI(DEFICO,'NTPC'    )
      LPENAC = CFDISL(DEFICO,'CONT_PENA'   )
      LPENAF = CFDISL(DEFICO,'FROT_PENA'   )
      LLAGRC = CFDISL(DEFICO,'CONT_LAGR'   )
      LLAGRF = CFDISL(DEFICO,'FROT_LAGR'   )
      LCTFD  = CFDISL(DEFICO,'FROT_DISCRET')
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      LIOT   = RESOCO(1:14)//'.LIOT'
      LIAC   = RESOCO(1:14)//'.LIAC'
      MU     = RESOCO(1:14)//'.MU'
      CLREAC = RESOCO(1:14)//'.REAL'
      COPO   = RESOCO(1:14)//'.COPO'
      CALL JEVEUO(LIOT  ,'E',JLIOT )
      CALL JEVEUO(LIAC  ,'E',JLIAC )
      CALL JEVEUO(MU,    'E',JMU   )
      CALL JEVEUO(CLREAC,'L',JCLREA)
      CALL JEVEUO(COPO  ,'E',JCOPO )
C
C --- RECUPERATION DU DESCRIPTEUR DE LA MATRICE GLOBALE
C
      CALL JEVEUO(MATASS//'.&INT','E',LMAT)
C
C --- PARAMETRES DE REACTUALISATION
C
      REAGEO = ZL(JCLREA-1+1)
      REAPRE = ZL(JCLREA-1+3)
C
C --- INITIALISATIONS DES SD POUR LA DETECTION DES PIVOTS NULS
C
      IF (LLAGRC) THEN
        IF (REAGEO) THEN
          DO 100 ILIAI = 1,NTPC
            ZI(JLIOT+0*NTPC-1+ILIAI) = 0
            ZI(JLIOT+1*NTPC-1+ILIAI) = 0
            ZI(JLIOT+2*NTPC-1+ILIAI) = 0
            ZI(JLIOT+3*NTPC-1+ILIAI) = 0
 100      CONTINUE
          ZI(JLIOT+4*NTPC  ) = 0
          ZI(JLIOT+4*NTPC+1) = 0
          ZI(JLIOT+4*NTPC+2) = 0
          ZI(JLIOT+4*NTPC+3) = 0
        ENDIF
      ELSE
        ZI(JLIOT+4*NBLIAI  ) = 0
        ZI(JLIOT+4*NBLIAI+1) = 0
        ZI(JLIOT+4*NBLIAI+2) = 0
        ZI(JLIOT+4*NBLIAI+3) = 0
      ENDIF
C
C --- INITIALISATIONS DES LAGRANGES
C
      IF (LLAGRC.AND.LCTFD.AND.REAGEO) THEN
        DO 331 ILIAI = 1,NTPC
          ZR(JMU+3*NTPC+ILIAI-1) = 0.D0
          ZR(JMU+2*NTPC+ILIAI-1) = 0.D0
          ZR(JMU+  NTPC+ILIAI-1) = 0.D0
          ZR(JMU+       ILIAI-1) = 0.D0
 331    CONTINUE
      ENDIF
      IF (LPENAC.AND.LPENAF.AND.REAPRE) THEN
        DO 332 ILIAI = 1,NTPC
          ZR(JMU+2*NTPC+ILIAI-1) = 0.D0
          ZR(JMU+  NTPC+ILIAI-1) = 0.D0
 332    CONTINUE
      ENDIF
C
      IF (LPENAC) THEN
        DO 40 ILIAI = 1,NTPC
          ZR(JMU+       ILIAI-1) = 0.D0
          IF (LPENAF) THEN
            ZR(JMU+3*NTPC+ILIAI-1) = 0.D0
          ENDIF
 40     CONTINUE
      ENDIF
C
C --- RESTAURATION DU LAGRANGE DE CONTACT
C --- APRES UN APPARIEMENT
C
      IF (REAGEO) THEN
        CALL CFRSMU(DEFICO,RESOCO,REAPRE)
      ENDIF
C
C --- PREPARATION DES CHAMPS
C
      CALL CFPRCH(DEFICO,RESOCO,DDEPLA,DEPDEL)
C
C --- SAUVEGARDE DE LA VALEUR MAXI SUR LA DIAGONALE DE LA
C --- MATR_ASSE DU SYSTEME
C --- POUR VALEUR DE LA PSEUDO-PENALISATION EN FROT. LAGR. 3D
C
      IF (LLAGRF.AND.(NDIM.EQ.3).AND.REAPRE) THEN
        CALL CFDIAG(LMAT  ,VDIAGM)
        ZR(JCOPO) = VDIAGM ** 0.25D0
      ENDIF
C
C --- CALCUL DES JEUX INITIAUX
C
      CALL CFJEIN(NOMA  ,DEFICO,RESOCO,DEPDEL)
C
C --- LIAISONS INITIALES
C
      CALL CFLIIN(NOMA  ,DEFICO,RESOCO)
C
      CALL JEDEMA()
C
      END
