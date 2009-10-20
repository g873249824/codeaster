      SUBROUTINE IMPSDA(SDIMPZ,OPER  ,ICOL  ,ICOD  ,TITCOL,
     &                  FORCOL,LONGR ,PRECR ,LONGI ,LONGK )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/10/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      CHARACTER*(*) SDIMPZ
      INTEGER       ICOL,ICOD
      CHARACTER*4   OPER
      CHARACTER*16  TITCOL(3)
      INTEGER       FORCOL
      INTEGER       LONGR,PRECR,LONGI,LONGK
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (AFFICHAGE - ACCES SD)
C
C AFFECTATION PROPRIETES POUR LA COLONNE
C
C ----------------------------------------------------------------------
C
C
C IN SDIMPR : SD SUR L'AFFICHAGE DES COLONNES
C IN OPER   : OPERATION SUR LA COLONNE
C              'AJOU': AJOUTER UNE COLONNE A LA FIN (ICOL=0 OBLIGATOIRE)
C              'LIRE': LIRE UNE COLONNE
C IN ICOL   : NUMERO DE LA COLONNE
C IN ICOD   : CODE TYPE DE LA COLONNE (VOIR LISTE DANS IMPREF)
C IN TITCOL : TITRE DE LA COLONNE
C IN FORCOL : FORMAT DE LA COLONNE
C              1: ENTIER
C              2: REEL
C              3: CHAINE
C IN LONGR  : LONGUEUR D'AFFICHAGE DU REEL
C IN PRECR  : LONGUEUR D'AFFICHAGE DE LA PRECISION DU REEL
C IN LONGI  : LONGUEUR D'AFFICHAGE DE L'ENTIER
C IN LONGK  : LONGUEUR D'AFFICHAGE DE LA CHAINE
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
      INTEGER      JIMPCO,JIMPTI,JIMPFO,JIMPTY,JIMPIN
      CHARACTER*24 IMPCOL,IMPTIT,IMPFOR,IMPTYP,IMPIN
      CHARACTER*1  OPEJEV
      CHARACTER*14 SDIMPR
      INTEGER      IBID
      INTEGER      COLMAX,TITMAX,LARMAX,COLUTI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C ---
C
      IF (OPER.EQ.'LIRE') THEN
        OPEJEV = 'L'
      ELSE IF (OPER.EQ.'AJOU') THEN
        OPEJEV = 'E'
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- ACCES SD
C
      SDIMPR = SDIMPZ
      IMPIN  = SDIMPR(1:14)//'INFO'
      IMPCOL = SDIMPR(1:14)//'DEFI.COL'
      IMPTIT = SDIMPR(1:14)//'DEFI.TIT'
      IMPFOR = SDIMPR(1:14)//'DEFI.FOR'
      IMPTYP = SDIMPR(1:14)//'DEFI.TYP'
      CALL JEVEUO(IMPIN,'E',JIMPIN)
      CALL JEVEUO(IMPCOL,OPEJEV,JIMPCO)
      CALL JEVEUO(IMPTIT,OPEJEV,JIMPTI)
      CALL JEVEUO(IMPFOR,OPEJEV,JIMPFO)
      CALL JEVEUO(IMPTYP,OPEJEV,JIMPTY)


      CALL IMPINF(SDIMPR,IBID  ,COLMAX,IBID  ,TITMAX,
     &            COLUTI,IBID  ,IBID  ,IBID  ,LARMAX)

C
C --- VERIFICATION FORMAT/LARGEUR COLONNE
C --- ON PREVOIT LA PLACE POUR UNE MARQUE D'UN CARACTERE
C --- AVEC UN ESPACE AVANT ET UN ESPACE APRES LA MARQUE POUR LES
C --- FORMATS REELS ET ENTIERS
C
      IF (OPER.NE.'LIRE') THEN
        IF ((LONGR.GT.(LARMAX - 3)).OR.
     &      (LONGI.GT.(LARMAX - 3)).OR.
     &      (LONGK.GT.LARMAX)) THEN
          CALL U2MESS('F','MECANONLINE4_21')
        ENDIF
      ENDIF


      IF (OPER.EQ.'AJOU') THEN
        IF (ICOL.NE.0) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
        IF (COLUTI.EQ.COLMAX) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSE IF (OPER.EQ.'LIRE') THEN
        IF ((ICOL.LE.0).OR.(ICOL.GT.COLUTI)) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF


      IF (OPER.EQ.'LIRE') THEN
        ICOD      = ZI(JIMPCO-1+ICOL)
        TITCOL(1) = ZK16(JIMPTI+TITMAX*(ICOL-1))
        TITCOL(2) = ZK16(JIMPTI+TITMAX*(ICOL-1)+1)
        TITCOL(3) = ZK16(JIMPTI+TITMAX*(ICOL-1)+2)
        FORCOL    = ZI(JIMPTY-1+ICOL)
        LONGR     = ZI(JIMPFO+4*(ICOL-1))
        PRECR     = ZI(JIMPFO+4*(ICOL-1)+1)
        LONGI     = ZI(JIMPFO+4*(ICOL-1)+2)
        LONGK     = ZI(JIMPFO+4*(ICOL-1)+3)
      ELSE IF (OPER.EQ.'AJOU') THEN
        ICOL      = COLUTI+1
        ZI(JIMPCO-1+ICOL)              = ICOD
        ZK16(JIMPTI+TITMAX*(ICOL-1))   = TITCOL(1)
        ZK16(JIMPTI+TITMAX*(ICOL-1)+1) = TITCOL(2)
        ZK16(JIMPTI+TITMAX*(ICOL-1)+2) = TITCOL(3)
        ZI(JIMPTY-1+ICOL)              = FORCOL
        ZI(JIMPFO+4*(ICOL-1))   = LONGR
        ZI(JIMPFO+4*(ICOL-1)+1) = PRECR
        ZI(JIMPFO+4*(ICOL-1)+2) = LONGI
        ZI(JIMPFO+4*(ICOL-1)+3) = LONGK
      ELSE
        CALL ASSERT(.FALSE.)   
      ENDIF

      IF (OPER.EQ.'AJOU') THEN
        COLUTI = COLUTI + 1
      ENDIF

      ZI(JIMPIN-1+4) = COLUTI
C
C ---
C
      CALL JEDEMA()

      END
