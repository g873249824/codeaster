      SUBROUTINE CFINAL(DEFICO,RESOCO,REAPRE,REAGEO,NBLIAC,
     &                  LLF   ,LLF1  ,LLF2  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/10/2011   AUTEUR DESOZA T.DESOZA 
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
      CHARACTER*24 DEFICO,RESOCO
      INTEGER      NBLIAC,LLF,LLF1,LLF2
      LOGICAL      REAPRE,REAGEO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE DISCRETE - ALGORITHME)
C
C ACTIVATION DES LIAISONS INITIALES
C
C ----------------------------------------------------------------------
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  REAPRE : .TRUE. SI PREMIERE ACTUALISATION
C IN  REAGEO : .TRUE. SI ON VIENT DE FAIRE UN NOUVEL APPARIEMENT
C I/O NBLIAC : NOMBRE DE LIAISONS ACTIVES
C I/O LLF    : NOMBRE DE LIAISON DE FROTTEMENT (DEUX DIRECTIONS)
C I/O LLF1   : NOMBRE DE LIAISON DE FROTTEMENT (1ERE DIRECTION )
C I/O LLF2   : NOMBRE DE LIAISON DE FROTTEMENT (2EME DIRECTION )
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
      LOGICAL      LIAACT,LIAEXI
      REAL*8       JEUINI,JEUOLD,JEUMIN
      REAL*8       R8PREM
      INTEGER      POSIT,AJLIAI,SPLIAI,INDIC,BTOTIN
      INTEGER      CFDISD,NBLIAI
      INTEGER      ILIAI,ILIAC
      LOGICAL      CFDISL,LGCP,LLAGRC,LLAGRF,LGLISS
      CHARACTER*1  TYPEAJ
      CHARACTER*2  TYPELI,TYPEC0
      CHARACTER*19 LIAC,TYPL
      INTEGER      JLIAC,JTYPL
      CHARACTER*24 JEUITE,JEUX
      INTEGER      JJEUIT,JJEUX
      CHARACTER*24 NUMLIA
      INTEGER      JNUMLI
      CHARACTER*19 STATFR
      INTEGER      JSTFR
      INTEGER      POSNOE
      CHARACTER*2  TYPLIA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      LIAC   = RESOCO(1:14)//'.LIAC'
      TYPL   = RESOCO(1:14)//'.TYPL'
      CALL JEVEUO(LIAC  ,'L',JLIAC )
      CALL JEVEUO(TYPL  ,'L',JTYPL )
      JEUITE = RESOCO(1:14)//'.JEUITE'
      JEUX   = RESOCO(1:14)//'.JEUX'
      CALL JEVEUO(JEUITE,'L',JJEUIT)
      CALL JEVEUO(JEUX  ,'L',JJEUX )
C
      NUMLIA = RESOCO(1:14)//'.NUMLIA'
      CALL JEVEUO(NUMLIA,'L',JNUMLI)
C
      IF (REAPRE) THEN
        STATFR = RESOCO(1:14)//'.STF0'
      ELSE
        STATFR = RESOCO(1:14)//'.STFR'
      ENDIF
C
C --- INITIALISATIONS
C
      JEUMIN = R8PREM()
      POSIT  = 0
      BTOTIN = NBLIAC + LLF + LLF1 + LLF2
      TYPEAJ = 'A'
      TYPEC0 = 'C0'
C
C --- PARAMETRES
C
      NBLIAI = CFDISD(RESOCO,'NBLIAI'  )
      LGCP   = CFDISL(DEFICO,'CONT_GCP')
      LLAGRC = CFDISL(DEFICO,'CONT_LAGR')
      LLAGRF = CFDISL(DEFICO,'FROT_LAGR')
      LGLISS = CFDISL(DEFICO,'CONT_DISC_GLIS')
C
C --- DETECTION DES COUPLES DE NOEUDS INTERPENETRES
C
      DO 10 ILIAI = 1,NBLIAI
C
C ----- JEU SANS CORRECTION DU CONTACT
C
        JEUINI = ZR(JJEUX+3*(ILIAI-1)+1-1)
C
C ----- JEU AVANT L'ITERATION DE NEWTON
C
        JEUOLD = ZR(JJEUIT+3*(ILIAI-1)+1-1)
C
C ----- LIAISON ACTIVEE ?
C
        LIAACT = .FALSE.
        IF (LGCP) THEN
          LIAACT = .TRUE.
        ELSEIF (LLAGRC) THEN
          IF (JEUOLD.LT.JEUMIN) THEN
            LIAACT = .TRUE.
          ELSE
            LIAACT = .FALSE.
          ENDIF
        ELSE
          IF (JEUINI.LT.JEUMIN) THEN
            LIAACT = .TRUE.
          ELSE
            LIAACT = .FALSE.
          ENDIF
        ENDIF
C
C ----- LIAISON GLISSIERE -> TOUTES LES LIAISONS SONT ACTIVEES
C
        IF (LGLISS) THEN
          LIAACT = .TRUE.
        ENDIF
C
C ----- LA LIAISON EXISTE-T-ELLE DEJA ?
C
        LIAEXI = .FALSE.
        DO 20 ILIAC = 1,BTOTIN
          IF (ZI(JLIAC-1+ILIAC).EQ.ILIAI) THEN
            TYPELI = ZK8(JTYPL-1+ILIAC)(1:2)
            IF (TYPELI.EQ.TYPEC0) LIAEXI = .TRUE.
          ENDIF
  20    CONTINUE
C
C ----- SI LAGRANGIEN: ON ACTIVE UNE LIAISON QUE SI ON EST APRES
C ----- UN NOUVEL APPARIEMENT
C
        IF (LLAGRC.AND.LIAACT) THEN
          IF (REAGEO) THEN
C --------- LA LIAISON N'EXISTE PAS ENCORE, FORCEMENT
            IF (LIAEXI) CALL ASSERT(.FALSE.)
          ELSE
            LIAACT = .FALSE.
          ENDIF
        ENDIF
C
C ----- INDICE DE LA NOUVELLE LIAISON ACTIVE
C
        IF (LIAACT) THEN
          IF (LGCP) THEN
            POSIT  = ILIAI
          ELSE
            POSIT  = NBLIAC + LLF + LLF1 + LLF2 + 1
          ENDIF
        ENDIF
C
C ----- ACTIVATION DE LA LIAISON DE CONTACT
C
        IF (LIAACT) THEN
          CALL CFTABL(INDIC ,NBLIAC,AJLIAI,SPLIAI,LLF   ,
     &                LLF1  ,LLF2  ,RESOCO,TYPEAJ,POSIT ,
     &                ILIAI ,TYPEC0)
        ENDIF
C
  10  CONTINUE
C
C --- EN LAGRANGIEN
C --- L'ETAT DES LIAISONS DE FROTTEMENT EST CONSERVE
C --- APRES UN APPARIEMENT ON LE TRANSFERE
C
C --- ATTENTION IL FAUDRA GERER LE PB DU REDECOUPAGE
C
      IF (LLAGRF) THEN
        CALL JEVEUO(STATFR,'E',JSTFR)
        IF (REAGEO) THEN
          DO 30 ILIAC = 1,NBLIAC
            CALL ASSERT(ZK8(JTYPL-1+ILIAC).EQ.'C0')
            ILIAI  =  ZI(JLIAC -1+ILIAC)
            POSNOE =  ZI(JNUMLI-1+4*(ILIAI-1)+2)
            TYPLIA = ZK8(JSTFR -1+POSNOE)(1:2)
            IF (TYPLIA.NE.' ') THEN
              CALL ASSERT(TYPLIA.EQ.'F0'.OR.
     &                    TYPLIA.EQ.'F1'.OR.
     &                    TYPLIA.EQ.'F2')
              POSIT  = NBLIAC + LLF + LLF1 + LLF2 + 1
              CALL CFTABL(INDIC ,NBLIAC,AJLIAI,SPLIAI,LLF   ,
     &                    LLF1  ,LLF2  ,RESOCO,TYPEAJ,POSIT ,
     &                    ILIAI ,TYPLIA)
            ENDIF
  30      CONTINUE
        ENDIF
      ENDIF
C
      CALL JEDEMA()
C
      END
