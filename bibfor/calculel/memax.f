      SUBROUTINE MEMAX(TYPMX,CHAMP,NCP,LONG,VR,NBMAIL,NUMAIL)
      IMPLICIT NONE
      CHARACTER*3 TYPMX
      CHARACTER*(*) CHAMP
      INTEGER NCP,LONG,NBMAIL,NUMAIL(*)
      REAL*8 VR(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/05/2006   AUTEUR MASSIN P.MASSIN 
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
C ----------------------------------------------------------------------
C     BUT :  EXTRAIRE LE "MIN/MAX" SUR LA COMPOSANTE NCP D'UN
C            CHAM_ELEM/ELEM REEL ET RECUPERER LES COMPOSANTES ASSOCIEES.
C            LA SEULE CONTRAINTE EST QUE TOUS LES TYPE_ELEMENT DU LIGREL
C            CONNAISSENT LA GRANDEUR AVEC LA MEME LONGUEUR CUMULEE :
C
C IN  : TYPMX  :  'MIN'/'MAX'
C IN  : CHAMP  :  NOM DU CHAMP A SCRUTER
C IN  : NCP    :  NUMERO DE COMPOSANTE SUR LEQUEL ON FAIT LE TEST
C IN  : LONG   :  LONGUEUR DU VECTEUR VR
C IN  : NBMAIL :  = 0   , CALCUL SUR TOUT LE CHAM_ELEM
C                 SINON , CALCUL SUR UNE PARTIE DU CHAM_ELEM
C IN  : NUMAIL :  NUMEROS DES MAILLES (SI NBMAIL >0)
C OUT : VR     :  VECTEUR CONTENANT LE "MIN/MAX" DU CHAMP
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     ------------------------------------------------------------------
      INTEGER NBGREL,NBELEM,DIGDEL,IRET,IBID,IACELK,JCELD,NBGR
      INTEGER ICOEF,I,IAVALE,NEL,idecgr,k,jligr,im,inum,iel
      CHARACTER*8 SCALAI
      INTEGER LONGT,NCMPEL,MODE,J,IGD
      REAL*8 VALR,r8miem,r8maem
      CHARACTER*8 SCAL
      CHARACTER*19 CHAMP2,LIGREL
      LOGICAL FIRST
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CHAMP2 = CHAMP
C
C     -- ON RETROUVE LE NOM DU LIGREL:
C     --------------------------------
      CALL JEEXIN(CHAMP2//'.CELD',IRET)
      IF (IRET.EQ.0) CALL UTMESS('F','MEMAX',
     &                           'LE CHAMP DOIT ETRE UN CHAM_ELEM.')

C --- ON VERIFIE QUE LE CHAM_ELEM N'EST PAS TROP DYNAMIQUE :
      CALL CELVER(CHAMP2,'NBVARI_CST','STOP',IBID)
      CALL CELVER(CHAMP2,'NBSPT_1','STOP',IBID)

      CALL JEVEUO(CHAMP2//'.CELK','L',IACELK)
      LIGREL = ZK24(IACELK-1+1) (1:19)

      CALL JEVEUO(CHAMP2//'.CELD','L',JCELD)
      IGD = ZI(JCELD-1+1)
      SCAL = SCALAI(IGD)
      IF (SCAL(1:1).NE.'R') THEN
        CALL UTMESS('F','MEMAX','NE TRAITE QU''UN CHAM_ELEM REEL')
      END IF


C     -- ON VERIFIE LES LONGUEURS:
C     ----------------------------
      FIRST = .TRUE.
      NBGR = NBGREL(LIGREL)
      DO 10,J = 1,NBGR
        MODE = ZI(JCELD-1+ZI(JCELD-1+4+J)+2)
        IF (MODE.EQ.0) GO TO 10
        NCMPEL = DIGDEL(MODE)
        ICOEF = MAX(1,ZI(JCELD-1+4))
        NCMPEL = NCMPEL*ICOEF
        IF (FIRST) THEN
          LONGT = NCMPEL

        ELSE
          IF (LONGT.NE.NCMPEL) THEN
            CALL UTMESS('F','MEMAX','LONGUEURS DES MODES LOCAUX '//
     &                  'IMCOMPATIBLES ENTRE EUX.')
          END IF

        END IF

        FIRST = .FALSE.
   10 CONTINUE
      IF (LONGT.GT.LONG) THEN
        CALL UTMESS('F','MEMAX','LA LONGUEUR:LONG EST TROP PETITE.')
      END IF

      IF (NCP.GT.LONGT) THEN
        CALL UTMESS('F','MEMAX','IL N''Y A PAS AUTANT DE COMPOSANTES')
      END IF


C --- INITIALISATION DE VR :
C     ----------------------
      CALL ASSERT(TYPMX.EQ.'MAX' .OR. TYPMX.EQ.'MIN')
      DO 20,I = 1,LONGT
        IF (TYPMX.EQ.'MAX') THEN
          VR(I) = R8MIEM()

        ELSE
          VR(I) = R8MAEM()
        END IF

   20 CONTINUE


C --- ON CHERCHE LE MIN/MAX :
C     -----------------------
      CALL JEVEUO(CHAMP2//'.CELV','L',IAVALE)

C     -- CAS : LISTE DE MAILLES :
C     -------------------------------
      IF (NBMAIL.LE.0) THEN
        DO 60,J = 1,NBGR
          MODE = ZI(JCELD-1+ZI(JCELD-1+4+J)+2)
          IF (MODE.EQ.0) GO TO 60
          NEL = NBELEM(LIGREL,J)
          IDECGR = ZI(JCELD-1+ZI(JCELD-1+4+J)+8)
          DO 50,K = 1,NEL
            VALR = ZR(IAVALE-1+IDECGR+ (K-1)*LONGT+NCP-1)

            IF (TYPMX.EQ.'MAX' .AND. VALR.GT.VR(NCP)) THEN
              DO 30 I = 1,LONGT
                VR(I) = ZR(IAVALE-1+IDECGR+ (K-1)*LONGT+I-1)
   30         CONTINUE
            END IF

            IF (TYPMX.EQ.'MIN' .AND. VALR.LT.VR(NCP)) THEN
              DO 40 I = 1,LONGT
                VR(I) = ZR(IAVALE-1+IDECGR+ (K-1)*LONGT+I-1)
   40         CONTINUE
            END IF

   50     CONTINUE
   60   CONTINUE


C     -- CAS : TOUTES LES MAILLES :
C     -------------------------------
      ELSE
        CALL JEVEUO(LIGREL//'.LIEL','L',JLIGR)
        DO 110 IM = 1,NBMAIL
          INUM = 0
          DO 100 J = 1,NBGR
            MODE = ZI(JCELD-1+ZI(JCELD-1+4+J)+2)
            IF (MODE.EQ.0) GO TO 100
            NEL = NBELEM(LIGREL,J)
            IDECGR = ZI(JCELD-1+ZI(JCELD-1+4+J)+8)
            DO 90 K = 1,NEL
              IEL = ZI(JLIGR+INUM+K-1)
              IF (IEL.NE.NUMAIL(IM)) GO TO 90
              VALR = ZR(IAVALE-1+IDECGR+ (K-1)*LONGT+NCP-1)

              IF (TYPMX.EQ.'MAX' .AND. VALR.GT.VR(NCP)) THEN
                DO 70 I = 1,LONGT
                  VR(I) = ZR(IAVALE-1+IDECGR+ (K-1)*LONGT+I-1)
   70           CONTINUE
              END IF

              IF (TYPMX.EQ.'MIN' .AND. VALR.LT.VR(NCP)) THEN
                DO 80 I = 1,LONGT
                  VR(I) = ZR(IAVALE-1+IDECGR+ (K-1)*LONGT+I-1)
   80           CONTINUE
              END IF

              GO TO 110

   90       CONTINUE
            INUM = INUM + NEL + 1
  100     CONTINUE
  110   CONTINUE
      END IF
C
      CALL JEDEMA()
      END
