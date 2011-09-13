      SUBROUTINE CFJEFI(NOMA  ,DEFICO,RESOCO,DDEPLA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/09/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 DDEPLA
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE DISCRETE - ALGORITHME)
C
C CALCUL DES JEUX FINAUX
C
C ----------------------------------------------------------------------
C 
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  DDEPLA : INCREMENT DE DEPLACEMENT DEPUIS L'ITERATION
C              DE NEWTON PRECEDENTE CORRIGEE PAR LE CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV
      INTEGER      JDDEPL
      INTEGER      ILIAI,JDECAL,NBDDL
      REAL*8       JEUINI,JEUOLD,JEUINC
      REAL*8       JEXNEW,JEXOLD,JEXINC      
      LOGICAL      CFDISL,LPENAC,LLAGRF,LCTFD
      CHARACTER*24 APCOEF,APDDL ,APPOIN
      INTEGER      JAPCOE,JAPDDL,JAPPTR
      CHARACTER*24 APCOFR
      INTEGER      JAPCOF
      CHARACTER*24 JEUITE,JEUX
      INTEGER      JJEUIT,JJEUX
      INTEGER      CFDISD,NBLIAI,NEQ,NDIMG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ...... CALCUL DES JEUX FINAUX'
      ENDIF
C
C --- PARAMETRES
C
      NBLIAI = CFDISD(RESOCO,'NBLIAI'  )             
      NEQ    = CFDISD(RESOCO,'NEQ'     )
      NDIMG  = CFDISD(RESOCO,'NDIM'    )    
      LPENAC = CFDISL(DEFICO,'CONT_PENA'   )
      LLAGRF = CFDISL(DEFICO,'FROT_LAGR'   )
      LCTFD  = CFDISL(DEFICO,'FROT_DISCRET')
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      APPOIN = RESOCO(1:14)//'.APPOIN'
      APDDL  = RESOCO(1:14)//'.APDDL'
      APCOEF = RESOCO(1:14)//'.APCOEF'
      CALL JEVEUO(APPOIN,'L',JAPPTR)
      CALL JEVEUO(APDDL ,'L',JAPDDL)
      CALL JEVEUO(APCOEF,'L',JAPCOE)
C
      IF (LCTFD) THEN
        APCOFR = RESOCO(1:14)//'.APCOFR'
        CALL JEVEUO(APCOFR,'L',JAPCOF)
      ENDIF
C
      JEUITE = RESOCO(1:14)//'.JEUITE'
      JEUX   = RESOCO(1:14)//'.JEUX'
      CALL JEVEUO(JEUX  ,'L',JJEUX )
      CALL JEVEUO(JEUITE,'E',JJEUIT)
C
C --- ACCES VECTEUR DEPLACEMENTS
C
      CALL JEVEUO(DDEPLA(1:19)//'.VALE','L',JDDEPL)
C      
C --- MISE A JOUR DES JEUX
C           
      DO 15 ILIAI = 1,NBLIAI
        JEUINI = ZR(JJEUX+3*(ILIAI-1)+1-1)
        IF (LPENAC) THEN
          ZR(JJEUIT+3*(ILIAI-1)+1-1) = JEUINI
        ELSE
          JDECAL = ZI(JAPPTR+ILIAI-1)
          NBDDL  = ZI(JAPPTR+ILIAI) - ZI(JAPPTR+ILIAI-1)
          CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &                ZR(JDDEPL),JEUINC)
          JEUOLD = ZR(JJEUIT+3*(ILIAI-1)+1-1)
          ZR(JJEUIT+3*(ILIAI-1)+1-1) = JEUOLD - JEUINC
          IF (LLAGRF.AND.NDIMG.EQ.2) THEN
            JEXOLD = ZR(JJEUIT+3*(ILIAI-1)+2-1)
            CALL CALADU(NEQ,NBDDL,ZR(JAPCOF+JDECAL),ZI(JAPDDL+JDECAL),
     &                  ZR(JDDEPL),JEXINC)
            JEXNEW = JEXOLD + JEXINC
            ZR(JJEUIT+3*(ILIAI-1)+2-1) = JEXNEW
          ENDIF
        ENDIF
  15  CONTINUE
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN     
        CALL CFIMP1('FIN',NOMA  ,DEFICO,RESOCO,IFM   )
      ENDIF
C  
      CALL JEDEMA()
C
      END
