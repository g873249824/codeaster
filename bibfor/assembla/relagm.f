      SUBROUTINE RELAGM(MO,MA,NM,NL,NEWN,OLDN)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 10/07/2007   AUTEUR PELLET J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     ARGUMENTS:
C     ----------
      CHARACTER*8 MO,MA
      INTEGER NM,NL,NEWN(*),OLDN(*)
C ----------------------------------------------------------------------
C     BUT:
C           RENUMEROTER  LES NOEUDS TARDIFS DU MAILLAGE
C           (NOEUDS DE LAGRANGE PROVENANT DES SOUS_STRUCTURES)
C           (CES NOEUDS DOIVENT EN EFFET TOUJOURS ENCADRER LES
C            NOEUDS PHYSIQUES CONTRAINTS)
C
C     IN/OUT:     CF. ROUTINE RENUNO
C     ------
C
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      INTEGER NBNOMA,NBNTT,NBNORE
      CHARACTER*8 KBID
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL,EXILAG
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C
C
C
C     -- SI LE MODELE N'A PAS DE SOUS-STRUCTURES ON RESSORT :
C     --------------------------------------------------------
      CALL JEMARQ()
      CALL DISMOI('F','NB_SS_ACTI',MO,'MODELE',NBSSA,KBID,IERD)
      CALL DISMOI('F','NB_SM_MAILLA',MO,'MODELE',NBSMA,KBID,IERD)
      IF (NBSSA.GT.0) THEN
        CALL JEVEUO(MO//'.MODELE    .SSSA','L',IASSSA)
        CALL JEEXIN(MA//'.TYPL',IRET)
        IF (IRET.GT.0) CALL JEVEUO(MA//'.TYPL','L',IATYPL)
      ELSE
        GO TO 9999
      END IF
C
C     -- L'OBJET SUIVANT CONTIENDRA EN REGARD DES NUMEROS DE NOEUDS
C        PHYSIQUES DU MAILLAGE UN ENTIER (+1, OU 0) POUR DIRE
C        SI CE NOEUD EST PRECEDE OU SUIVI (+1) DE NOEUDS DE LAGRANGE :
      CALL WKVECT('&&RELAGM.AVAP','V V I',NM,IAAVAP)
C
C
C     -- .OLDT EST UN .OLDN TEMPORAIRE QUE L'ON RECOPIERA A LA FIN
      NBNOMA= NM+NL
      CALL WKVECT('&&RELAGM.OLDT','V V I',NBNOMA,IAOLDT)
C
C
C     -- BOUCLE SUR LES (SUPER)MAILLES
C     --------------------------------
      ICOL= 0
      DO 21, IMA = 1, NBSMA
        EXILAG=.FALSE.
        IF(ZI(IASSSA-1+IMA).EQ.1) THEN
          CALL JEVEUO(JEXNUM(MA//'.SUPMAIL',IMA),'L',IAMAIL)
          CALL JELIRA(JEXNUM(MA//'.SUPMAIL',IMA),'LONMAX',NBNM,KBID)
C
C         -- ON REGARDE LES NUMEROS PHYSIQUES MAX ET MIN DE LA MAILLE:
          IPREM =0
          DO 22, I=1,NBNM
            INO=ZI(IAMAIL-1+I)
            IF ((INO.GT.0).AND.(INO.LE.NM)) THEN
              IPREM=IPREM+1
              IF (IPREM.EQ.1) THEN
                INOMAX=INO
                INOMIN=INO
              END IF
              IF (NEWN(INO).GT.NEWN(INOMAX)) THEN
                 INOMAX=INO
              END IF
              IF (NEWN(INO).LT.NEWN(INOMIN)) THEN
                 INOMIN=INO
              END IF
            ELSE
              ICOL=ICOL+1
            END IF
 22       CONTINUE
C
C
C         -- ON SE SERT DE LA FIN DU VECTEUR .NEWN POUR STOCKER EN FACE
C         DE CHAQUE LAGRANGE LE NUMERO DU NOEUD PHYSIQUE PRES DUQUEL
C         ON DOIT LE DEPLACER (+INOMAX : DERRIERE) (-INOMIN : DEVANT)
C
          DO 23, I=1,NBNM
            INO=ZI(IAMAIL-1+I)
            IF (INO.GT.NM) THEN
              EXILAG=.TRUE.
              ITYPI=ZI(IATYPL-1+INO-NM)
              IF (ITYPI.EQ.-1) THEN
                NEWN(INO)=-INOMIN
              ELSE IF (ITYPI.EQ.-2) THEN
                NEWN(INO)= INOMAX
              ELSE
                CALL U2MESS('F','ASSEMBLA_17')
              END IF
            END IF
 23       CONTINUE
C
          IF (EXILAG) THEN
            ZI(IAAVAP-1+INOMIN)= 1
            ZI(IAAVAP-1+INOMAX)= 1
          END IF
C
        END IF
C
 21   CONTINUE
C
      IF (ICOL.EQ.0) GO TO 9999
C
C
C     -- ON REMPLIT .OLDT AVEC LES NOEUDS DE .OLDN ET LES LAGRANGES:
C     -------------------------------------------------------------
      ICO= 0
      DO 31, I=1,NM
        IOLD=OLDN(I)
        IF (IOLD.EQ.0) GO TO 32
        IF (ZI(IAAVAP-1+IOLD).EQ.1) THEN
C
          DO 33,IL=1,NL
            IF (NEWN(NM+IL).EQ.-IOLD) THEN
              ICO = ICO+1
              ZI(IAOLDT-1+ICO)=NM+IL
            END IF
 33       CONTINUE
C
          ICO = ICO+1
          ZI(IAOLDT-1+ICO)=IOLD
C
          DO 34,IL=1,NL
            IF (NEWN(NM+IL).EQ.+IOLD) THEN
              ICO = ICO+1
              ZI(IAOLDT-1+ICO)=NM+IL
            END IF
 34       CONTINUE
C
        ELSE
          ICO = ICO+1
          ZI(IAOLDT-1+ICO)=IOLD
        END IF
 31   CONTINUE
 32   CONTINUE
      NBNORE= ICO
C
C     -- ON RECOPIE .OLDT DANS .OLDN ET ON REMET .NEWN A JOUR :
C     ---------------------------------------------------------
      DO 41, I=1,NBNOMA
        NEWN(I) =0
        OLDN(I) =0
 41   CONTINUE
C
      DO 42, I=1,NBNORE
        OLDN(I) = ZI(IAOLDT-1+I)
        NEWN(ZI(IAOLDT-1+I)) =I
 42   CONTINUE
C
C
 9999 CONTINUE
C
      CALL JEDETR('&&RELAGM.AVAP')
      CALL JEDETR('&&RELAGM.OLDT')
C
      CALL JEDEMA()
      END
