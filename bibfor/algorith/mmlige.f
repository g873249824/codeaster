      SUBROUTINE MMLIGE(NOMA  ,DEFICO,RESOCO,TYPELT,NBTYP ,
     &                  COMPTC,COMPTF,NNDTOT,NBGREL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 TYPELT
      INTEGER      NBTYP
      INTEGER      COMPTC(NBTYP),COMPTF(NBTYP)
      INTEGER      NNDTOT,NBGREL
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - CREATION OBJETS - LIGREL)
C
C LISTE DES ELEMENTS DE CONTACT TARDIF
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DU CONTACT
C OUT TYPELT : LISTE DES NOUVELLES MAILLES
C                 * NUMERO DU TYPE DE MAILLE
C                 * NOMBRE DE NOEUDS DU TYPE DE MAILLE
C IN  NBTYP  : NOMBRE DE TYPE D'ELEMENTS DE CONTACT DISPONIBLES
C OUT COMPTC : VECTEUR DU NOMBRE D'ELEMENT POUR CHAQUE TYPE
C OUT COMPTF : VECTEUR TYPE CONTACT OU FROTTEMENT POUR CHAQUE TYPE
C                SI COMPTF(IELT) = 0 CONTACT
C                SI COMPTF(IELT) = 1 FROTTEMENT
C OUT NNDTOT : NOMBRE DE NOEUDS TOTAL
C OUT NBGREL : NOMBRE DE GREL
C
C
C
C
      INTEGER      CFMMVD,ZTABF
      INTEGER      IPTC,NTPC,ITYP
      INTEGER      JTYMAI,JTYNMA
      INTEGER      NUMMAM,NUMMAE,IZONE
      INTEGER      CFDISI,NDIMG
      INTEGER      NNDEL,NUMTYP,MMELTN
      CHARACTER*8  NTYMAE,NTYMAM
      INTEGER      ITYMAE,ITYMAM
      CHARACTER*24 TABFIN
      INTEGER      JTABF
      INTEGER      IFM,NIV
      LOGICAL      MMINFL,LFROTT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- ACCES OBJETS
C
      TABFIN = RESOCO(1:14)//'.TABFIN'
      CALL JEVEUO(TABFIN,'L',JTABF)
      CALL JEVEUO(NOMA//'.TYPMAIL','L',JTYMAI)
      ZTABF = CFMMVD('ZTABF')
C
C --- INITIALISATIONS
C
      DO 10 ITYP = 1,NBTYP
        COMPTC(ITYP) = 0
        COMPTF(ITYP) = 0
   10 CONTINUE
      NTPC   = CFDISI(DEFICO,'NTPC')
      NDIMG  = CFDISI(DEFICO,'NDIM')
      NNDTOT = 0
      NBGREL = 0
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ... NOMBRE TOTAL D''ELEMENTS :',NTPC
      ENDIF
C
C --- CREATION DU VECTEUR
C --- DEUX ENTIERS PAR NOUVELLE MAILLE :
C       * NUMERO DU TYPE DE MAILLE
C       * NOMBRE DE NOEUDS DU TYPE DE MAILLE
C
      CALL WKVECT(TYPELT,'V V I',2*NTPC,JTYNMA)
C
C --- BOUCLE SUR LES POINTS DE CONTACT (ESCLAVE)
C
      DO 20 IPTC = 1,NTPC
C
C --- TYPE MAILLES MAITRE/ESCLAVE
C
        NUMMAE  = NINT(ZR(JTABF+ZTABF*(IPTC-1)+1))
        NUMMAM  = NINT(ZR(JTABF+ZTABF*(IPTC-1)+2))
C
C --- INFOS MAILLES MAITRE/ESCLAVE
C
        IZONE   = NINT(ZR(JTABF+ZTABF*(IPTC-1)+13))
        LFROTT  = MMINFL(DEFICO,'FROTTEMENT_ZONE',IZONE )
        ITYMAE  = ZI(JTYMAI-1+NUMMAE)
        ITYMAM  = ZI(JTYMAI-1+NUMMAM)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYMAE),NTYMAE)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYMAM),NTYMAM)
C
C --- TYPE MAILLE DE CONTACT CREEE
C
        CALL MMELEL(NDIMG ,NTYMAE,NTYMAM,ITYP  ,NNDEL ,
     &              NUMTYP)
        ZI(JTYNMA-1+2*(IPTC-1)+1) = NUMTYP
        ZI(JTYNMA-1+2*(IPTC-1)+2) = NNDEL
C
C --- COMPTEUR DE TYPE D'ELEMENT DE CONTACT OU FROTTEMENT
C
        IF (LFROTT)  THEN
          COMPTF(ITYP) = COMPTF(ITYP) + 1
        ELSE
          COMPTC(ITYP) = COMPTC(ITYP) + 1
        ENDIF

   20 CONTINUE
C
C --- ON COMPTE LE NOMBRE DE NOEUDS A STOCKER AU TOTAL
C
      DO 170 ITYP = 1,NBTYP
        NNDEL  = MMELTN(ITYP)
        NNDTOT = NNDTOT + (COMPTC(ITYP)+COMPTF(ITYP))*(NNDEL+1)
  170 CONTINUE
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ... NOMBRE TOTAL DE NOEUDS :',NNDTOT
      ENDIF
C
C --- ON COMPTE LE NOMBRE DE GREL
C
      DO 60 ITYP = 1,NBTYP
        IF (COMPTC(ITYP).GT.0) THEN
          NBGREL = NBGREL + 1
        ENDIF
        IF (COMPTF(ITYP).GT.0) THEN
          NBGREL = NBGREL + 1
        ENDIF
   60 CONTINUE
C
      CALL JEDEMA()
      END
