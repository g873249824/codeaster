      SUBROUTINE CESIMP(CESZ,UNITE,NBMAT,NUMMAI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 18/09/2007   AUTEUR DURAND C.DURAND 
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
C RESPONSABLE VABHHTS J.PELLET
      IMPLICIT NONE
      CHARACTER*(*) CESZ
      INTEGER       UNITE,NBMAT,NUMMAI(*)
C ---------------------------------------------------------------------
C BUT: IMPRIMER UN CHAM_ELEM_S
C ---------------------------------------------------------------------
C     ARGUMENTS:
C CESZ   IN/JXIN  K19 : SD CHAM_ELEM_S A IMPRIMER
C UNITE  IN       I   : NUMERO DE L'UNITE LOGIQUE D'IMPRESSION
C NBMAT  IN       I   : /0 : ON IMPRIME TOUTES LES MAILLES
C NBMAT  IN       I   : >0 : ON N'IMPRIME QUE LES MAILLES DE NUMMAI(*)
C                            DE 1 A NBMAT
C NUMMAI IN      V(I) : NUMEROS DES MAILLES A IMPRIMER (SI NBMAT >0)

C REMARQUE :
C  - POUR L'INSTANT ON IMPRIME AU FORMAT "RESULTAT" LES CHAMPS DE R8
C-----------------------------------------------------------------------

C---- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*32 ZK32,JEXNOM,JEXNUM,JEXATR
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      INTEGER JCESK,JCESD,JCESV,JCESL,JCESC,IAD,JCONX1,JCONX2
      INTEGER NBMA,IBID,K,IMA,NCMP,JLVAL,IPT,ISP,NBPT,NBSP,INO,IRET
      INTEGER IK,NCMPU,LICMPU(997), NBMAI, IM
      CHARACTER*1 KBID
      CHARACTER*8 MA,NOMGD,NOMMA,POIN,SPOIN,TYPCES
      CHARACTER*3 TSCA
      CHARACTER*19 CES
      CHARACTER*40 FMT
      LOGICAL EXICMP
C     ------------------------------------------------------------------
      CALL JEMARQ()

      CES = CESZ

      CALL JEVEUO(CES//'.CESK','L',JCESK)
      CALL JEVEUO(CES//'.CESD','L',JCESD)
      CALL JEVEUO(CES//'.CESC','L',JCESC)
      CALL JEVEUO(CES//'.CESV','L',JCESV)
      CALL JEVEUO(CES//'.CESL','L',JCESL)

      MA = ZK8(JCESK-1+1)
      NOMGD = ZK8(JCESK-1+2)
      TYPCES = ZK8(JCESK-1+3)
      NBMA = ZI(JCESD-1+1)
      NCMP = ZI(JCESD-1+2)

      CALL JEEXIN(MA//'.CONNEX',IRET)
      CALL ASSERT(IRET.NE.0)
      CALL JEVEUO(MA//'.CONNEX','L',JCONX1)
      CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',JCONX2)


C     1- CALCUL DE NCMPU  : NB CMPS UTILISEES DANS LE CHAMP
C            ET DE LICMPU : NUMEROS DES CMPS UTILISEES
C     ------------------------------------------------------------
      NCMPU = 0
      DO 50,K = 1,NCMP
        DO 30,IMA = 1,NBMA
          NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
          NBSP = ZI(JCESD-1+5+4* (IMA-1)+2)
          DO 20,IPT = 1,NBPT
            DO 10,ISP = 1,NBSP
              CALL CESEXI('C',JCESD,JCESL,IMA,IPT,ISP,K,IAD)
              IF (IAD.GT.0) GO TO 40
   10       CONTINUE
   20     CONTINUE
   30   CONTINUE
        GO TO 50
   40   CONTINUE
        NCMPU = NCMPU + 1
        LICMPU(NCMPU) = K
   50 CONTINUE


      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)
      IF ((TSCA.EQ.'I').OR.(TSCA.EQ.'K8')) THEN
        FMT = '(A12,XXX(''|'',A12))'
      ELSEIF (((TSCA.EQ.'R').OR.TSCA.EQ.'K16')) THEN
        FMT = '(A12,XXX(''|'',A16))'
      ELSE
C       ON ATTEND UN TYPE PARMI : I/R/K8/K16
        CALL ASSERT(.FALSE.)
      END IF


C     1- ALLOCATION D'UN TABLEAU DE K16 QUI CONTIENDRA LES VALEURS
C        D'UNE LIGNE A ECRIRE
C     ------------------------------------------------------------
      CALL WKVECT('&&CESIMP.LVALEURS','V V K16',MAX(NCMPU,1),JLVAL)


C     2- FORMAT DES LIGNES :
C     ----------------------
      CALL ASSERT(NCMPU.LE.997)
      CALL CODENT(NCMPU+2,'D',FMT(6:8))


C     3- ECRITURE DE L'ENTETE DU CHAMP :
C     ---------------------------------------
      WRITE (UNITE,*) ' '
      WRITE (UNITE,*) ' GRANDEUR: ',NOMGD
      WRITE (UNITE,*) ' '
      WRITE (UNITE,FMT) 'MAILLE','POINT','SOUS-POINT',
     &  (ZK8(JCESC-1+LICMPU(IK)),IK=1,NCMPU)


C     4- ECRITURE DES VALEURS :
C     ---------------------------------------
      IF ( NBMAT .EQ. 0 ) THEN
         NBMAI = NBMA
      ELSE
         NBMAI = NBMAT
      ENDIF
      DO 110,IM = 1,NBMAI
        IMA = IM
        IF ( NBMAT .NE. 0 ) IMA = NUMMAI(IM)
        CALL JENUNO(JEXNUM(MA//'.NOMMAI',IMA),NOMMA)
        NBPT = ZI(JCESD-1+5+4* (IMA-1)+1)
        NBSP = ZI(JCESD-1+5+4* (IMA-1)+2)
        DO 100,IPT = 1,NBPT
          DO 90,ISP = 1,NBSP

C       -- ON N'ECRIT UN SOUS-POINT QUE S'IL EXISTE AU MOINS 1 CMP :
            EXICMP = .FALSE.
            DO 60,IK = 1,NCMPU
              K = LICMPU(IK)
              CALL CESEXI('C',JCESD,JCESL,IMA,IPT,ISP,K,IAD)
              IF (IAD.GT.0) THEN
                EXICMP = .TRUE.
                GO TO 70
              END IF
   60       CONTINUE
   70       CONTINUE
            IF (.NOT.EXICMP) GO TO 110



C       -- ON MET LES VALEURS NON AFFECTEES A " " :
            DO 80,IK = 1,NCMPU
              K = LICMPU(IK)
              CALL CESEXI('C',JCESD,JCESL,IMA,IPT,ISP,K,IAD)
              IF (IAD.GT.0) THEN

                IF (TSCA.EQ.'R') THEN
                  WRITE (ZK16(JLVAL-1+K),'(1PE16.9)') ZR(JCESV-1+IAD)

                ELSE IF (TSCA.EQ.'I') THEN
                  WRITE (ZK16(JLVAL-1+K),'(I12,A4)') ZI(JCESV-1+IAD),' '

                ELSE IF (TSCA.EQ.'K8') THEN
                  WRITE (ZK16(JLVAL-1+K),'(A8,A8)') ZK8(JCESV-1+IAD),' '

                ELSE IF (TSCA.EQ.'K16') THEN
                  WRITE (ZK16(JLVAL-1+K),'(A16)') ZK16(JCESV-1+IAD)
                END IF
              ELSE
                WRITE (ZK16(JLVAL-1+K),'(A16)') ' '
              END IF
   80       CONTINUE

            IF (TYPCES.EQ.'ELNO') THEN
              INO = ZI(JCONX1-1+ZI(JCONX2+IMA-1)+IPT-1)
              CALL JENUNO(JEXNUM(MA//'.NOMNOE',INO),POIN)
            ELSE
              WRITE (POIN,'(I8)') IPT
            END IF

            WRITE (SPOIN,'(I8)') ISP
            WRITE (UNITE,FMT) NOMMA,POIN,SPOIN,
     &        (ZK16(JLVAL-1+LICMPU(IK)),IK=1,NCMPU)

   90     CONTINUE
  100   CONTINUE
  110 CONTINUE

      CALL JEDETR('&&CESIMP.LVALEURS')
      CALL JEDEMA()
      END
