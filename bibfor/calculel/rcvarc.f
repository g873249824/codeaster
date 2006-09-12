      SUBROUTINE RCVARC(ARRET,NOVRC,POUM,FAMI,KPG,KSP,VALVRC,IRET)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/09/2006   AUTEUR VABHHTS J.PELLET 
C RESPONSABLE VABHHTS J.PELLET
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
      CHARACTER*(*) NOVRC,POUM,FAMI
      CHARACTER*1 ARRET
      INTEGER  IRET,KPG,KSP
      REAL*8 VALVRC
C-----------------------------------------------------------------------
C BUT: RECUPERER LA VALEUR D'UNE VARIABLE DE COMMANDE SUR UN SOUS-POINT
C      DE GAUSS (KPG,KSP) ET POUR UNE VALEUR D'INSTANT ('+','-','REF')
C
C ARGUMENTS :
C  IN   ARRET  (K2) : /'FM'
C  IN   ARRET (K1)  : CE QU'IL FAUT FAIRE EN CAS DE PROBLEME
C              = ' ' : ON REMPLIT CODRET ET ON SORT SANS MESSAGE.
C              = 'F' : SI LA VARIABLE N'EST PAS TROUVEE, ON ARRETE
C                       EN FATAL.
C  IN   NOVRC  (K8) : NOM DE LA VARIABLE DE COMMANDE SOUHAITEE
C  IN   POUM   (K*) : /'+', /'-', /'REF'
C  IN   FAMI   (K8) : NOM DE LA FAMILLE DE POINTS DE GAUSS ('RIGI',...)
C  IN   KPG    (I)  : NUMERO DU POINT DE GAUSS
C  IN   KSP    (I)  : NUMERO DU SOUS-POINT DE GAUSS (1 SINON)
C  OUT  VALVRC (R)  : VALEUR DE LA VARIABLE DE COMMANDE
C  OUT  IRET   (I)  : CODE RETOUR : 0 -> OK
C                                   1 -> VARIABLE NON TROUVEE

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
      CHARACTER*8 ZK8,NOVR8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
      INTEGER NBCVRC,JVCNOM
      COMMON /CAII14/NBCVRC,JVCNOM

      CHARACTER*16 OPTION,NOMTE,NOMTM,PHENO,MODELI
      COMMON /CAKK01/OPTION,NOMTE,NOMTM,PHENO,MODELI

      INTEGER NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG
      COMMON /CAII11/NUTE,JNBELR,JNOELR,IACTIF,JPNLFP,JNOLFP,NBLFPG

      INTEGER        IEL
      COMMON /CAII08/IEL

      INTEGER NFPGMX
      PARAMETER (NFPGMX=10)
      INTEGER NFPG,JFPGL,DECALA(NFPGMX),KM,KP,KR,IREDEC
      COMMON /CAII17/NFPG,JFPGL,DECALA,KM,KP,KR,IREDEC
      REAL*8 TIMED1,TIMEF1,TD1,TF1
      COMMON /CARR01/TIMED1,TIMEF1,TD1,TF1

      INTEGER KCVRC,IBID,NBSP,NBPG,KPGVRC,INDIK8
      INTEGER IADZI,IAZK24,KPGMAT
      INTEGER K ,ITABM(7),ITABP(7),ITABR(7)
      CHARACTER*8 NOMAIL
      REAL*8 R8NNEM,VALVRM,VALVRP
      SAVE ITABM,ITABP,ITABR
C ---------------------------------------------------------------


C     1) CALCUL DE KPGMAT (FAMI,KPG) : NUMERO DU PG DANS LA
C        FAMILLE "MATER" (ASSOCIEE A PVARCMR ET PVARCPR) :
C     -----------------------------------------------------------
      CALL ASSERT(FAMI.NE.'MATER')
      CALL ASSERT(NFPG.NE.0)
      K=INDIK8(ZK8(JFPGL),FAMI,1,NFPG)
      CALL ASSERT(K.GT.0)
      KPGMAT=DECALA(K)+KPG


C     2) CALCUL DE KCVCRC :
C     ----------------------
      NOVR8=NOVRC
      KCVRC=INDIK8(ZK8(JVCNOM),NOVR8,1,NBCVRC)

C     -- SI LA CVRC N'EST PAS FOURNIE, ON REND "R8NNEM" :
      IF (KCVRC.EQ.0) THEN
        IRET=1
        IF (ARRET.EQ.' ') THEN
          VALVRC=R8NNEM()
          GO TO 9999
        ELSE
          CALL TECAEL(IADZI,IAZK24)
          NOMAIL=ZK24(IAZK24-1+3)(1:8)
          CALL UTMESS('F','RCVARC','PAS DE VARIABLE: '//NOVR8//
     &    ' POUR LA MAILLE: '//NOMAIL)
        END IF
      END IF


C     3) CALCUL DE ITABX : ON CHERCHE A ECONOMISER L'APPEL A TECACH
C     ------------------------------------------------------------
      IF (POUM.EQ.'-' .OR. (POUM.EQ.'+' .AND. IREDEC.EQ.1)) THEN
        IF (IEL.NE.KM) THEN
          CALL TECACH ('OOO','PVARCMR',7,ITABM,IBID)
          KM=IEL
        END IF
      END IF

      IF (POUM.EQ.'+' .OR. (POUM.EQ.'-' .AND. IREDEC.EQ.1)) THEN
        IF (IEL.NE.KP) THEN
          CALL TECACH ('OOO','PVARCPR',7,ITABP,IBID)
          KP=IEL
        END IF
      END IF

      IF (POUM.EQ.'REF') THEN
        IF (IEL.NE.KR) THEN
          CALL TECACH ('OOO','PVARCRR',7,ITABR,IBID)
          KR=IEL
        END IF
      END IF


C     4) CALCUL DE VALVRC :
C     ----------------------

      IF (POUM.EQ.'REF') THEN
        CALL ASSERT(ITABR(6).EQ.NBCVRC)
        NBPG=ITABR(3)
        NBSP=ITABR(7)
        CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
        CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRC=ZR(ITABR(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

      ELSE IF (POUM.EQ.'+' .AND. IREDEC.EQ.0) THEN
        CALL ASSERT(ITABP(6).EQ.NBCVRC)
        NBPG=ITABP(3)
        NBSP=ITABP(7)
        CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
        CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRC=ZR(ITABP(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

      ELSE IF (POUM.EQ.'-' .AND. IREDEC.EQ.0) THEN
        CALL ASSERT(ITABM(6).EQ.NBCVRC)
        NBPG=ITABM(3)
        NBSP=ITABM(7)
        CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
        CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRC=ZR(ITABM(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

      ELSE IF (IREDEC.EQ.1) THEN
        CALL ASSERT(ITABM(6).EQ.NBCVRC)
        NBPG=ITABM(3)
        NBSP=ITABM(7)
        CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
        CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRM=ZR(ITABM(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

        CALL ASSERT(ITABP(6).EQ.NBCVRC)
        NBPG=ITABP(3)
        NBSP=ITABP(7)
        CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
        CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRP=ZR(ITABP(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

        IF (POUM.EQ.'-') THEN
          VALVRC=VALVRM+(TD1-TIMED1)*(VALVRP-VALVRM)/(TIMEF1-TIMED1)
        ELSE IF (POUM.EQ.'+') THEN
          VALVRC=VALVRM+(TF1-TIMED1)*(VALVRP-VALVRM)/(TIMEF1-TIMED1)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF

      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

      IRET=0

9999  CONTINUE
      END
