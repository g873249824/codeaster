      SUBROUTINE ASCOVA(DETR,VACHAR,FOMULZ,NPARA,VPARA,TYPRES,CNCHAR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C
C ======================================================================
      IMPLICIT NONE
      CHARACTER*(*) FOMULZ,NPARA,TYPRES,CNCHAR,DETR
      CHARACTER*24 VACHAR
      REAL*8 VPARA
C ----------------------------------------------------------------------
C  BUT :   AJOUTER / COMBINER DES VECTEURS ASSEMBLES (CHAM_NO)

C IN  DETR    : / 'D' : ON DETRUIT  LE VACHAR  (CONSEILLE)
C               / 'G' : ON NE DETRUIT PAS LE VACHAR
C IN/JXVAR  VACHAR  : LISTE DES VECTEURS ASSEMBLES
C IN  FOMULT  : LISTE DES FONCTIONS MULTIPLICATIVES
C IN  NPARA   : NOM DU PARAMETRE
C IN  VPARA   : VALEUR DU PARAMETRE
C IN  TYPRES  : TYPE DES VECTEURS ET DU CHAM_NO RESULTANT 'R' OU 'C'
C VAR/JXOUT  CNCHAR  : CHAM_NO RESULTAT

C REMARQUES :
C --------------
C CETTE ROUTINE SERT A COMBINER LES CHAM_NO D'UN "VACHAR"
C UN VACHAR EST UN VECTEUR DE K24 CONTENANT UNE LISTE DE CHAM_NO.
C ON PEUT OBTENIR UN VACHAR PAR ASASVE PAR EXEMPLE.

C ATTENTION: SI DETR='D', CETTE ROUTINE DETRUIT LES CHAM_NO DU VACHAR
C =========  APRES LES AVOIR COMBINES. ELLE DETRUIT EGALEMENT LE VACHAR.

C POUR TENIR EVENTUELLEMENT COMPTE D'UNE FONC_MULT, ASCOVA
C UTILISE SYSTEMATIQUEMENT LA ROUTINE CORICH SUR LES CHAM_NO
C A COMBINER. IL FAUT QUE LES CHAM_NO DU VACHAR AIENT ETE
C RENSEIGNES PAR CORICH.


C SI CNCHAR=' ' LE NOM DU CHAMP RESULTAT SERA :
C   CNCHAR=VACHAR(1:8)//'.ASCOVA'

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER KK,NBVEC,NCHAR,IRET,JVEC,JFONCT,JCOEF,JTYPE,K
      INTEGER ICHA,IER,N1,NPUIS,N2,IBID
      REAL*8 VALRES,VALRE,VALIM,DGRD,R8DGRD,OMEGA,R8DEPI,PHASE
      LOGICAL FCT
      CHARACTER*8 K8BID
      CHARACTER*19 CHAMNO
      CHARACTER*24 FOMULT
      COMPLEX*16 CALPHA

      CALL JEMARQ()
      FOMULT = FOMULZ
      DGRD = R8DGRD()


C     -- ON VERIFIE QUE LE VACHAR A LES BONNES PROPRIETES:
C     ----------------------------------------------------
      CALL JEEXIN(VACHAR,IRET)
      IF (IRET.EQ.0) CALL U2MESS('F','CALCULEL_2')
      CALL JELIRA(VACHAR,'LONMAX',NBVEC,K8BID)
      IF (NBVEC.EQ.0) CALL U2MESS('F','CALCULEL_8')
      CALL JEVEUO(VACHAR,'L',JVEC)


      CALL JEEXIN(FOMULT,IRET)
      IF (IRET.EQ.0) THEN
        FCT = .FALSE.
        NCHAR = 0
      ELSE
        FCT = .TRUE.
        CALL JELIRA(FOMULT,'LONMAX',NCHAR,K8BID)
        IF (NCHAR.EQ.0) CALL U2MESS('F','CALCULEL_13')
        CALL JEVEUO(FOMULT,'L',JFONCT)
      END IF



C     -- CAS DES CHAM_NO REELS :
C     ----------------------------------------------------
      IF (TYPRES(1:1).EQ.'R') THEN
        CALL WKVECT('&&ASCOVA.COEF','V V R8',NBVEC,JCOEF)
        CALL WKVECT('&&ASCOVA.TYPE','V V K8',NBVEC,JTYPE)
        DO 10 K = 1,NBVEC

          CHAMNO = ZK24(JVEC+K-1) (1:19)
C         CALL UTIMS2('ASCOVA 1',K,CHAMNO,1,' ')
          CALL CORICH('L',CHAMNO,IBID,ICHA)

          IF (ICHA.EQ.0) THEN
            CALL U2MESK('F','ALGORITH_14',1,CHAMNO)
          ELSE IF (ICHA.LT.-2) THEN
            CALL U2MESS('F','ALGORITH_15')
          ELSE IF (ICHA.EQ.-1) THEN
            VALRES = 1.D0
          ELSE IF (ICHA.EQ.-2) THEN
            VALRES = 0.D0
          ELSE
            IF (ICHA.GT.NCHAR) CALL U2MESS('F','ALGORITH_19')
            VALRES = 1.D0
            IF (FCT) CALL FOINTE('F ',ZK24(JFONCT+ICHA-1) (1:8),1,NPARA,
     &                           VPARA,VALRES,IER)
          END IF

          ZR(JCOEF+K-1) = VALRES
          ZK8(JTYPE+K-1) = 'R'
   10   CONTINUE


C     -- CAS DES CHAM_NO COMPLEXES :
C     ----------------------------------------------------
      ELSE
        OMEGA = R8DEPI()*VPARA
        KK = 0
        CALL WKVECT('&&ASCOVA.COEF','V V R8',2*NBVEC,JCOEF)
        CALL WKVECT('&&ASCOVA.TYPE','V V K8',NBVEC,JTYPE)
        DO 20 K = 1,NBVEC

          PHASE = 0.D0
          CALL GETVR8('EXCIT','PHAS_DEG',K,1,1,PHASE,N1)
          CALL GETVIS('EXCIT','PUIS_PULS',K,1,1,NPUIS,N2)
          CALPHA = EXP(DCMPLX(0.D0,PHASE*DGRD))
          IF (NPUIS.NE.0) CALPHA = CALPHA*OMEGA**NPUIS

          CHAMNO = ZK24(JVEC+K-1) (1:19)
          CALL CORICH('L',CHAMNO,IBID,ICHA)

          IF (ICHA.EQ.0) THEN
            CALL U2MESK('F','ALGORITH_14',1,CHAMNO)
          ELSE IF (ICHA.LT.-2) THEN
            CALL U2MESS('F','ALGORITH_15')
          ELSE IF (ICHA.EQ.-1) THEN
            VALRE = 1.D0
            VALIM = 0.D0
          ELSE IF (ICHA.EQ.-2) THEN
            VALRE = 0.D0
            VALIM = 0.D0
          ELSE
            IF (ICHA.GT.NCHAR) CALL U2MESS('F','CALCULEL_9')
            VALRE = 1.D0
            VALIM = 0.D0
            IF (FCT) CALL FOINTC(ZK24(JFONCT+ICHA-1)(1:8),1,NPARA,
     &                           VPARA,VALRE,VALIM,IER)
          END IF

          ZK8(JTYPE+K-1) = 'C'
          KK = KK + 1
          ZR(JCOEF+KK-1) = VALRE*DBLE(CALPHA)-VALIM*DIMAG(CALPHA)
          KK = KK + 1
          ZR(JCOEF+KK-1) = VALIM*DBLE(CALPHA)+VALRE*DIMAG(CALPHA)
   20   CONTINUE
      END IF


C     COMBINAISON LINEAIRES DES CHAM_NO :
C     -----------------------------------
      IF (CNCHAR.EQ.' ') CNCHAR = VACHAR(1:8)//'.ASCOVA'
      CALL VTCMBL(NBVEC,ZK8(JTYPE),ZR(JCOEF),ZK8(JTYPE),ZK24(JVEC),
     &            ZK8(JTYPE),CNCHAR)
      CALL JEDETR('&&ASCOVA.COEF')
      CALL JEDETR('&&ASCOVA.TYPE')


C     DESTRUCTION DU VACHAR :
C     -----------------------------------
      IF (DETR.EQ.'D') THEN
        DO 30 K = 1,NBVEC
          CALL CORICH('S',ZK24(JVEC+K-1) (1:19),IBID,IBID)
          CALL DETRSD('CHAMP_GD',ZK24(JVEC+K-1))
   30   CONTINUE
        CALL JEDETR(VACHAR)
      ELSE IF (DETR.EQ.'G') THEN
C       -- EN PRINCIPE UTILISE PAR DYNA_LINE_HARM
      ELSE
        CALL ASSERT(.FALSE.)
      END IF


      CALL JEDEMA()
      END
