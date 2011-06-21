      SUBROUTINE EXCHML(IMODAT,IPARG)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 21/06/2011   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE                            VABHHTS J.PELLET
C     ARGUMENTS:
C     ----------
      INTEGER IPARG,IMODAT
C ----------------------------------------------------------------------
C     ENTREES:
C        IMODAT : MODE LOCAL ATTENDU
C        IPARG  : NUMERO DU PARAMETRE DANS L'OPTION

C ----------------------------------------------------------------------
      INTEGER IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO
      INTEGER ILCHLO,ITYPGD
      COMMON /CAII01/IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO,
     &       ILCHLO,ITYPGD
      COMMON /CAKK02/TYPEGD
      CHARACTER*8 TYPEGD
      COMMON /CAII04/IACHII,IACHIK,IACHIX
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      INTEGER        NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      COMMON /CAII06/NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------

C     FONCTIONS EXTERNES:
C     ------------------

C     VARIABLES LOCALES:
C     ------------------
      INTEGER JCELD,MODE,DEBGR2,LGGRE2,IAUX1
      INTEGER ITYPL1,MODLO1,NBPOI1,LGCATA
      INTEGER ITYPL2,MODLO2,NBPOI2
      INTEGER ILOPMO,IAOPMO,ILOPNO,IAOPDS,IAOPPA,NPARIO,NPARIN,IAMLOC
      INTEGER ILMLOC,IADSGD,IEL
      INTEGER IACHII
      INTEGER NCMP1,NCMP2,VALI(3)
      INTEGER IACHIK,IACHIX,IAOPTT,LGCO,IAOPNO,IRET,DEBUGR,LGGREL
      INTEGER JEC,NCMP,JAD1,JAD2,JEL,IPT2,K,IPT1,LONG2,DIGDE2,JPARAL
      INTEGER NBPOI,ICMP1,ICMP2,KCMP,IPT
      LOGICAL ETENDU,LPARAL,LVEREC,EXISDG
      CHARACTER*8 TYCH,CAS
C DEB-------------------------------------------------------------------

C     PARALLELE OR NOT ?
C     -------------------------
      CALL JEEXIN('&CALCUL.PARALLELE',IRET)
      IF (IRET.NE.0) THEN
        LPARAL=.TRUE.
        CALL JEVEUO('&CALCUL.PARALLELE','L',JPARAL)
      ELSE
        LPARAL=.FALSE.
      ENDIF

      TYCH=ZK8(IACHIK-1+2*(IICHIN-1)+1)
      CALL ASSERT(TYCH(1:4).EQ.'CHML')

      JCELD=ZI(IACHII-1+11*(IICHIN-1)+4)
      LGGRE2=ZI(JCELD-1+ZI(JCELD-1+4+IGR)+4)
      DEBGR2=ZI(JCELD-1+ZI(JCELD-1+4+IGR)+8)

      MODE=ZI(JCELD-1+ZI(JCELD-1+4+IGR)+2)

      LGCATA=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR-1)+2)
      LGGREL=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR-1)+4)
      DEBUGR=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR-1)+5)


C     -- SI MODE=0 : IL FAUT METTRE CHAMP_LOC.EXIS A .FALSE.
      IF (MODE.EQ.0) THEN
        DO 30,K=1,LGGREL
          ZL(ILCHLO-1+DEBUGR-1+K)=.FALSE.
   30   CONTINUE
        GOTO 170
      ENDIF


C     -- SI LE CHAMP A LE MODE ATTENDU : ON RECOPIE
C     ----------------------------------------------------
      IF (MODE.EQ.IMODAT) THEN
        CALL JACOPO(LGGREL,TYPEGD,IACHIN-1+DEBGR2,IACHLO+DEBUGR-1)
        GOTO 9998
      ENDIF


C     -- SI LE CHAMP N'A PAS LE MODE ATTENDU ...
C     ----------------------------------------------------
      CALL CHLOET(IPARG,ETENDU,JCELD)
      IF (ETENDU)  CALL U2MESS('F','CALCULEL2_51')


      MODLO1=IAMLOC-1+ZI(ILMLOC-1+MODE)
      MODLO2=IAMLOC-1+ZI(ILMLOC-1+IMODAT)
      ITYPL1=ZI(MODLO1-1+1)
      ITYPL2=ZI(MODLO2-1+1)
      CALL ASSERT(ITYPL1.LE.3)
      CALL ASSERT(ITYPL2.LE.3)
      NBPOI1=ZI(MODLO1-1+4)
      NBPOI2=ZI(MODLO2-1+4)

      NCMP1=LGGRE2/(NBPOI1*NBELGR)
      NCMP2=LGCATA/NBPOI2

C     -- ON VERIFIE QUE LES POINTS NE SONT PAS "DIFF__" :
      CALL ASSERT(NBPOI1.LT.10000)
      CALL ASSERT(NBPOI2.LT.10000)




C     -- DANS QUEL CAS DE FIGURE SE TROUVE-T-ON ?
C     --------------------------------------------
      LVEREC=.TRUE.
      IF (NBPOI1.EQ.NBPOI2) THEN
        IF (NCMP1.EQ.NCMP2) THEN
          CAS='COPIE'
        ELSE
          CAS='TRICMP'
          LVEREC=.FALSE.
        ENDIF
      ELSE
        CALL ASSERT(NCMP1.EQ.NCMP2)
        NCMP=NCMP1

        IF (NBPOI1.EQ.1) THEN
          CAS='EXPAND'
        ELSEIF (NBPOI2.EQ.1) THEN
          CAS='MOYENN'
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF

      IF (LVEREC) THEN
C       -- ON VERIFIE QUE LES CMPS SONT LES MEMES:
C          (SINON IL FAUDRAIT TRIER ... => A FAIRE (TRIGD) )
        DO 40,JEC=1,NEC
          CALL ASSERT(ZI(MODLO1-1+4+JEC).EQ.ZI(MODLO2-1+4+JEC))
   40   CONTINUE
      ENDIF



C     -- CAS "EXPAND" OU "COPIE":
C     ---------------------------
      IF (CAS.EQ.'EXPAND'.OR.CAS.EQ.'COPIE') THEN
        DO 60,JEL=1,NBELGR
          IF (LPARAL) THEN
            IF (.NOT.ZL(JPARAL-1+JEL))GOTO 60
          ENDIF
          JAD1=IACHIN-1+DEBGR2+(JEL-1)*NCMP
          DO 50,IPT2=1,NBPOI2
            JAD2=IACHLO+DEBUGR-1+((JEL-1)*NBPOI2+IPT2-1)*NCMP
            CALL JACOPO(NCMP,TYPEGD,JAD1,JAD2)
   50     CONTINUE
   60   CONTINUE


C     -- CAS "TRICMP":
C     ---------------------------
      ELSEIF (CAS.EQ.'TRICMP') THEN
        NBPOI=NBPOI1
        ICMP1=0
        ICMP2=0
        DO 52,KCMP=1,NCMPMX
          IF (EXISDG(ZI(MODLO2-1+5),KCMP)) THEN
            ICMP2=ICMP2+1
            IF (EXISDG(ZI(MODLO1-1+5),KCMP)) THEN
              ICMP1=ICMP1+1
            ELSE
C             -- A FAIRE ... (GESTION DE ZL)
              CALL ASSERT(.FALSE.)
            ENDIF
          ELSE
            GOTO 52
          ENDIF
          CALL ASSERT(ICMP1.GE.1 .AND. ICMP1.LE.NCMP1)
          CALL ASSERT(ICMP2.GE.1 .AND. ICMP2.LE.NCMP2)
          DO 61,JEL=1,NBELGR
            IF (LPARAL) THEN
              IF (.NOT.ZL(JPARAL-1+JEL))GOTO 61
            ENDIF

            DO 51,IPT=1,NBPOI
              JAD1=IACHIN+DEBGR2-1+((JEL-1)*NBPOI+IPT-1)*NCMP1
              JAD2=IACHLO+DEBUGR-1+((JEL-1)*NBPOI+IPT-1)*NCMP2
              JAD1=JAD1-1+ICMP1
              JAD2=JAD2-1+ICMP2
              CALL JACOPO(1,TYPEGD,JAD1,JAD2)
   51       CONTINUE
   61     CONTINUE
   52   CONTINUE


C     -- CAS "MOYENN" :
C     ------------------------
      ELSEIF (NBPOI2.EQ.1) THEN

        IF (TYPEGD.EQ.'R') THEN
          IF (LPARAL) THEN
            DO 80 IEL=1,NBELGR
              IF (ZL(JPARAL-1+IEL)) THEN
                IAUX1=IACHLO+DEBUGR-1+(IEL-1)*NCMP
                DO 70 K=1,NCMP
                  ZR(IAUX1-1+K)=0.D0
   70           CONTINUE
              ENDIF
   80       CONTINUE
          ELSE
            DO 90,K=1,NBELGR*NCMP
              ZR(IACHLO+DEBUGR-1-1+K)=0.D0
   90       CONTINUE
          ENDIF
        ELSEIF (TYPEGD.EQ.'C') THEN
          IF (LPARAL) THEN
            DO 110 IEL=1,NBELGR
              IF (ZL(JPARAL-1+IEL)) THEN
                IAUX1=IACHLO+DEBUGR-1+(IEL-1)*NCMP
                DO 100 K=1,NCMP
                  ZC(IAUX1-1+K)=(0.D0,0.D0)
  100           CONTINUE
              ENDIF
  110       CONTINUE
          ELSE
            DO 120,K=1,NBELGR*NCMP
              ZC(IACHLO+DEBUGR-1-1+K)=(0.D0,0.D0)
  120       CONTINUE
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF

        DO 150,JEL=1,NBELGR
          IF (LPARAL) THEN
            IF (.NOT.ZL(JPARAL-1+JEL))GOTO 150
          ENDIF
          JAD2=IACHLO+DEBUGR-1+(JEL-1)*NCMP
          DO 140,IPT1=1,NBPOI1
            JAD1=IACHIN-1+DEBGR2+((JEL-1)*NBPOI1+IPT1-1)*NCMP
            DO 130,K=0,NCMP-1
              IF (TYPEGD.EQ.'R') THEN
                ZR(JAD2+K)=ZR(JAD2+K)+ZR(JAD1+K)/DBLE(NBPOI1)
              ELSEIF (TYPEGD.EQ.'C') THEN
                ZC(JAD2+K)=ZC(JAD2+K)+ZC(JAD1+K)/DBLE(NBPOI1)
              ENDIF
  130       CONTINUE
  140     CONTINUE
  150   CONTINUE


C     -- AUTRES CAS PAS ENCORE PROGRAMMES :
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF


9998  CONTINUE
      DO 160,K=1,LGGREL
        ZL(ILCHLO-1+DEBUGR-1+K)=.TRUE.
  160 CONTINUE

  170 CONTINUE
      END
