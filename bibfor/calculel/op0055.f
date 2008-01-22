      SUBROUTINE OP0055 ( IER )
      IMPLICIT   NONE
      INTEGER             IER
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 22/01/2008   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C      OPERATEUR :     DEFI_FOND_FISS
C
C-----------------------------------------------------------------------
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      CHARACTER*8        KBID
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER       NBV, IFM, IRET,IRETEX,IRETNO,IRETOR,JEXTR,JNORM
      INTEGER       JORIG,NIV,N1,N2, IOC, ILEV,NBNO,JSUP,IRETS,IRETI
      INTEGER       NBMA,JLIMA,IM
      REAL*8        PS1, PS2, R8PREM, ZERO,DDOT,VALR(6)
      CHARACTER*8   K8B, RESU, NOMA, ENTIT1, ENTIT2,FONLEV(2)
      CHARACTER*16  TYPE, OPER, TYPFON, MOTCLE(2), TYPMCL(2)
      CHARACTER*24  NCNCIN,MSUP,FONNOE
      DATA FONLEV /'FOND_INF','FOND_SUP'/
C DEB-------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL INFMAJ
      CALL INFNIV ( IFM, NIV )
C
C ---  RECUPERATION DES ARGUMENTS DE LA COMMANDE
C
      CALL GETRES (RESU,TYPE,OPER)
C
C ---  MAILLAGE
C      --------
C
      CALL GETVID (' ', 'MAILLAGE', 0, 1, 1, NOMA, NBV)
C
C ---  MOTS CLES FACTEUR : FOND, FOND_INF, FOND_SUP, FOND_FERME
C      --------------------------------------------------------
C
      ENTIT1 = 'NOEUD'
      ENTIT2 = 'MAILLE'
      CALL GETFAC ( 'FOND_FISS', NBV )
      IF (NBV.GT.0) TYPFON = 'FOND_FISS'
      CALL GETFAC ( 'FOND_FERME', NBV )
      IF (NBV.GT.0) TYPFON = 'FOND_FERME'
      CALL GETFAC ( 'FOND_INF',NBV)
      ILEV=0
10    CONTINUE
      IF (NBV.GT.0)THEN
         ILEV=ILEV+1
         TYPFON=FONLEV(ILEV)
      ENDIF
      CALL GETVID ( TYPFON, 'NOEUD_ORIG'   , 1,1,0, K8B, N1 )
      CALL GETVID ( TYPFON, 'GROUP_NO_ORIG', 1,1,0, K8B, N2 )
      IF ( N1+N2 .EQ. 0 ) THEN
         CALL GVERIF ( RESU, NOMA, TYPFON, ENTIT2 )
      ELSE
         IOC = 1
         MOTCLE(1) = 'GROUP_MA'
         MOTCLE(2) = 'MAILLE'
         TYPMCL(1) = 'GROUP_MA'
         TYPMCL(2) = 'MAILLE'
         CALL FONFIS ( RESU, NOMA, TYPFON, IOC,
     &                    2, MOTCLE, TYPMCL, 'G')
      ENDIF
      CALL GVERIF(RESU,NOMA,TYPFON,ENTIT1)
      IF(ILEV.EQ.1)GOTO 10
      IF (ILEV.EQ.0) THEN
        CALL JELIRA (RESU//'.FOND      .NOEU' , 'LONMAX', NBNO, K8B)
      ELSE
        CALL JELIRA (RESU//'.FOND_INF  .NOEU' , 'LONMAX', NBNO, K8B)
      ENDIF
C
 490  CONTINUE

C CAS 3D
      IF (NBNO .GT. 1) THEN
C
C ---  MOT CLE FACTEUR : LEVRE_SUP
C      ---------------------------
C
        CALL GVERIF(RESU,NOMA,'LEVRE_SUP',ENTIT2)
C
C ---  MOT CLE FACTEUR : LEVRE_INF
C      ---------------------------
C
        CALL GVERIF(RESU,NOMA,'LEVRE_INF',ENTIT2)
C
C ---  MOT CLE FACTEUR : NORMALE
C      -------------------------
C
        CALL GVERIF(RESU,NOMA,'NORMALE',KBID)
C
C ---  MOT CLE FACTEUR : DTAN_ORIG
C      ------------------------------
C
        CALL GVERIF(RESU,NOMA,'DTAN_ORIG'   ,KBID)
C
C ---  MOT CLE FACTEUR : DTAN_EXTR
C      --------------------------------
C
        CALL GVERIF(RESU,NOMA,'DTAN_EXTR'     ,KBID)
C
C ---  MOT CLE FACTEUR : VECT_GRNO_ORIG
C      --------------------------------
C
        CALL GVERIF(RESU,NOMA,'VECT_GRNO_ORIG',KBID)
C
C ---  MOT CLE FACTEUR : VECT_GRNO_EXTR
C      --------------------------------
C
        CALL GVERIF(RESU,NOMA,'VECT_GRNO_EXTR',KBID)
C
C VERIFICATION DE L'ORTHOGONALITE DE LA NORMALE AU PLAN DES LEVRES
C  ET DES 2 DIRECTIONS TANGENTES
C
          CALL JEEXIN(RESU//'.NORMALE',IRETNO)
          CALL JEEXIN(RESU//'.DTAN_ORIGINE',IRETOR)
          CALL JEEXIN(RESU//'.DTAN_EXTREMITE',IRETEX)
          IF(IRETOR.NE.0.AND.IRETEX.NE.0) THEN
            CALL JEVEUO(RESU//'.DTAN_ORIGINE','L',JORIG)
            CALL JEVEUO(RESU//'.DTAN_EXTREMITE','L',JEXTR)
          ENDIF
          IF(IRETNO.NE.0.AND.IRETOR.NE.0.AND.IRETEX.NE.0) THEN
            CALL JEVEUO(RESU//'.NORMALE','L',JNORM)
            CALL JEVEUO(RESU//'.DTAN_ORIGINE','L',JORIG)
            CALL JEVEUO(RESU//'.DTAN_EXTREMITE','L',JEXTR)
            PS1=DDOT(3,ZR(JNORM),1,ZR(JORIG),1)
            PS2=DDOT(3,ZR(JNORM),1,ZR(JEXTR),1)
            ZERO = R8PREM()
            IF(ABS(PS1).GT.ZERO) THEN
               VALR(1) = ZR(JNORM)
               VALR(2) = ZR(JNORM+1)
               VALR(3) = ZR(JNORM+2)
               VALR(4) = ZR(JORIG)
               VALR(5) = ZR(JORIG+1)
               VALR(6) = ZR(JORIG+2)
               CALL U2MESR('F','RUPTURE0_78',6,VALR)
            ENDIF
            IF(ABS(PS2).GT.ZERO) THEN
               VALR(1) = ZR(JNORM)
               VALR(2) = ZR(JNORM+1)
               VALR(3) = ZR(JNORM+2)
               VALR(4) = ZR(JEXTR)
               VALR(5) = ZR(JEXTR+1)
               VALR(6) = ZR(JEXTR+2)
               CALL U2MESR('F','RUPTURE0_79',6,VALR)
            ENDIF
          ENDIF
C
C   EXTRACTION DES NOEUDS DES LEVRES SUR DIRECTON NORMALE
C
        CALL JEEXIN(RESU//'.LEVRESUP  .MAIL',IRETS)
        IF(IRETS.NE.0) THEN
          CALL  GNORMF ( NBNO,NOMA,RESU,ILEV,TYPFON )
        ENDIF

C CAS 2D
      ELSE
C
C ---  MOT CLE FACTEUR : LEVRE_SUP
C      ---------------------------
C
        CALL GVERI1(RESU,NOMA,'LEVRE_SUP',ILEV)
C
C ---  MOT CLE FACTEUR : LEVRE_INF
C      ---------------------------
C
        CALL GVERI1(RESU,NOMA,'LEVRE_INF',ILEV)
C
C ---  MOT CLE FACTEUR : NORMALE
C      -------------------------
C
        CALL GVERI1(RESU,NOMA,'NORMALE',ILEV)
        CALL JEEXIN(RESU//'.LEVRESUP  .MAIL',IRETS)
        IRETNO = 1
        IRETOR = 0
        IRETEX = 0

      ENDIF

C
C IMPRESSION DES OBJETS
C
      IF ( NIV .GT. 1 ) THEN
        CALL JEEXIN(RESU//'.FOND      .NOEU',IRET)
        IF(IRET.NE.0) THEN
           CALL JEIMPO(IFM,RESU//'.FOND      .NOEU',' ',
     &          'OBJET POUR LE MOT CLE FOND')
        ELSE
           CALL JEIMPO(IFM,RESU//'.FOND_INF  .NOEU',' ',
     &          'OBJET POUR LE MOT CLE FOND_FISS_INF')
           CALL JEIMPO(IFM,RESU//'.FOND_SUP  .NOEU',' ',
     &          'OBJET POUR LE MOT CLE FOND_FISS_SUP')
        ENDIF
C
        IF(IRETS.NE.0) THEN
          CALL JEIMPO(IFM,RESU//'.LEVRESUP  .MAIL',' ',
     &                  'OBJET POUR LE MOT CLE LEVRE_SUP')
        ENDIF
C
        CALL JEEXIN(RESU//'.LEVREINF  .MAIL',IRETI)
        IF(IRETI.NE.0) THEN
            CALL JEIMPO(IFM,RESU//'.LEVREINF  .MAIL',' ',
     &                'OBJET POUR LE MOT CLE LEVRE_INF')
        ENDIF
C
        IF(IRETNO.NE.0) THEN
          CALL JEIMPO(IFM,RESU//'.NORMALE',' ',
     &                  'OBJET POUR LE MOT CLE NORMALE')
        ENDIF
C
        IF(IRETOR.NE.0) THEN
          CALL JEIMPO(IFM,RESU//'.DTAN_ORIGINE',' ',
     &                  'OBJET POUR LE MOT CLE DTAN_ORIG')
        ENDIF
C
        IF(IRETEX.NE.0) THEN
          CALL JEIMPO(IFM,RESU//'.DTAN_EXTREMITE',' ',
     &                  'OBJET POUR LE MOT CLE DTAN_EXTR')
        ENDIF
C
        IF(IRETS.NE.0) THEN
          CALL JEIMPO(IFM,RESU//'.SUPNORM   .NOEU',' ',
     &                  'NOEUDS SUR NORMALE AU FOND : LEVRE_SUP')
        ENDIF
C
        IF(IRETI.NE.0) THEN
          CALL JEIMPO(IFM,RESU//'.INFNORM   .NOEU',' ',
     &                  'NOEUDS SUR NORMALE AU FOND : LEVRE_INF')
        ENDIF

      ENDIF
C

      CALL JEDEMA()
      END
