      SUBROUTINE RCVARC(ARRET,NOVRC,POUM,FAMI,KPG,KSP,VALVRC,IRET)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE VABHHTS J.PELLET
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
      INCLUDE 'jeveux.h'
      CHARACTER*(*) NOVRC,POUM,FAMI
      CHARACTER*1 ARRET
      INTEGER  IRET,KPG,KSP
      REAL*8 VALVRC
C-----------------------------------------------------------------------
C BUT: RECUPERER LA VALEUR D'UNE VARIABLE DE COMMANDE SUR UN SOUS-POINT
C      DE GAUSS (KPG,KSP) ET POUR UNE VALEUR D'INSTANT ('+','-','REF')
C
C ARGUMENTS :
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

      CHARACTER*8 NOVR8
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
      INTEGER NFPG,JFPGL,DECALA(NFPGMX),KM,KP,KR,IREDEC,NB2VRC
      COMMON /CAII17/NFPG,JFPGL,DECALA,KM,KP,KR,IREDEC
      REAL*8 TIMED1,TIMEF1,TD1,TF1
      COMMON /CARR01/TIMED1,TIMEF1,TD1,TF1

      INTEGER KCVRC,IBID,NBSP,KPGVRC,INDIK8
      INTEGER IADZI,IAZK24,KPGMAT,VALI(3),IISNAN,IPREM
      INTEGER K ,ITABM(7),ITABP(7),ITABR(7)
      CHARACTER*24 VALK(4)
      CHARACTER*8 NOMAIL
      REAL*8 R8NNEM,VALVRM,VALVRP,VALR(3),TDEF,INST,RUNDF
      SAVE ITABM,ITABP,ITABR,RUNDF
      DATA IPREM /0/
C ---------------------------------------------------------------
      IF (IPREM.EQ.0) THEN
        RUNDF=R8NNEM()
        IPREM=1
      ENDIF

C     -- S'IL N'Y A PAS DE VARC, ON NE PEUT PAS LES TROUVER !
      IF (NBCVRC.EQ.0)  GOTO 9998
      
      IF(IACTIF.EQ.2) THEN
C        ON VIENT DE CALC_POINT_MAT      
         CALL ASSERT(FAMI.EQ.'PMAT')
         CALL RCVARP(ARRET,NOVRC,POUM,VALVRC,IRET)
         GOTO 9999
      ENDIF

      TDEF=RUNDF


C     1) CALCUL DE KPGMAT (FAMI,KPG) : NUMERO DU PG DANS LA
C        FAMILLE "MATER" (ASSOCIEE A PVARCMR ET PVARCPR) :
C     -----------------------------------------------------------
C     CALL ASSERT(FAMI.NE.'MATER')
C     CALL ASSERT(NFPG.NE.0)
      K=INDIK8(ZK8(JFPGL),FAMI,1,NFPG)
      IF (K.EQ.0) THEN
        IF (ARRET.EQ.' ') THEN
          GOTO 9998
        ELSE
          VALK(1)=NOVRC
          VALK(2)=FAMI
          VALK(3)=OPTION
          VALK(4)=NOMTE
          CALL U2MESK('F','CALCULEL6_58',4,VALK)
        ENDIF
      ENDIF
      KPGMAT=DECALA(K)+KPG


C     2) CALCUL DE KCVCRC :
C     ----------------------
      NOVR8=NOVRC
      KCVRC=INDIK8(ZK8(JVCNOM),NOVR8,1,NBCVRC)

C     -- SI LA CVRC N'EST PAS FOURNIE, ON REND "R8NNEM"

      IF (KCVRC.EQ.0) THEN
        IRET=1
        IF (ARRET.EQ.' ') THEN
          VALVRC=RUNDF
          GO TO 9999
        ELSE
          CALL TECAEL(IADZI,IAZK24)
          NOMAIL=ZK24(IAZK24-1+3)(1:8)
          VALK(1) = NOVR8
          VALK(2) = NOMAIL
          VALK(3) = POUM
          IF (POUM.EQ.'+') THEN
            INST=TIMEF1
          ELSEIF (POUM.EQ.'-') THEN
            INST=TIMED1
          ELSE
            INST=0.D0
          ENDIF
          CALL U2MESG('F','CALCULEL4_69',3,VALK,0,0,1,INST)
        END IF
      END IF



C     3) CALCUL DE ITABX : ON CHERCHE A ECONOMISER L'APPEL A TECACH
C     ------------------------------------------------------------
      IF (POUM.EQ.'-' .OR. (POUM.EQ.'+' .AND. IREDEC.EQ.1)) THEN
        IF (IEL.NE.KM) THEN
          IF (ARRET.NE.' ') THEN
            CALL TECACH ('OOO','PVARCMR',7,ITABM,IBID)
          ELSE
            CALL TECACH ('NNN','PVARCMR',7,ITABM,IRET)
            IF (IRET.NE.0) GOTO 9998
          ENDIF
          KM=IEL
        END IF
      END IF

      IF (POUM.EQ.'+' .OR. (POUM.EQ.'-' .AND. IREDEC.EQ.1)) THEN
        IF (IEL.NE.KP) THEN
          IF (ARRET.NE.' ') THEN
            CALL TECACH ('OOO','PVARCPR',7,ITABP,IBID)
          ELSE
            CALL TECACH ('NNN','PVARCPR',7,ITABP,IRET)
            IF (IRET.NE.0) GOTO 9998
          ENDIF
          KP=IEL
        END IF
      END IF

      IF (POUM.EQ.'REF') THEN
        IF (IEL.NE.KR) THEN
          IF (ARRET.NE.' ') THEN
            CALL TECACH ('OOO','PVARCRR',7,ITABR,IBID)
          ELSE
            CALL TECACH ('NNN','PVARCRR',7,ITABR,IRET)
            IF (IRET.NE.0) GOTO 9998
          ENDIF
          KR=IEL
        END IF
      END IF


C     4) CALCUL DE VALVRC :
C     ----------------------

      IF (POUM.EQ.'REF') THEN
        NB2VRC=ITABR(6)
        IF (NB2VRC.NE.NBCVRC) GOTO 9998
C       NBPG=ITABR(3)
        NBSP=ITABR(7)
C       CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
C       CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRC=ZR(ITABR(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

      ELSE IF (POUM.EQ.'+' .AND. IREDEC.EQ.0) THEN
        NB2VRC=ITABP(6)
        IF (NB2VRC.NE.NBCVRC) GOTO 9998
C       NBPG=ITABP(3)
        NBSP=ITABP(7)
C       CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
C       CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRC=ZR(ITABP(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

      ELSE IF (POUM.EQ.'-' .AND. IREDEC.EQ.0) THEN
        NB2VRC=ITABM(6)
        IF (NB2VRC.NE.NBCVRC) GOTO 9998
C       NBPG=ITABM(3)
        NBSP=ITABM(7)
C       CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
C       CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRC=ZR(ITABM(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

      ELSE IF (IREDEC.EQ.1) THEN
        NB2VRC=ITABM(6)
        IF (NB2VRC.NE.NBCVRC) GOTO 9998
C       NBPG=ITABM(3)
        NBSP=ITABM(7)
C       CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
C       CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRM=ZR(ITABM(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

        NB2VRC=ITABP(6)
        IF (NB2VRC.NE.NBCVRC) GOTO 9998
C       NBPG=ITABP(3)
        NBSP=ITABP(7)
C       CALL ASSERT((KPGMAT.GE.1).AND.(KPGMAT.LE.NBPG))
C       CALL ASSERT((KSP.GE.1).AND.(KSP.LE.NBSP))
        KPGVRC=(KPGMAT-1)*NBSP+KSP
        VALVRP=ZR(ITABP(1) -1 + (KPGVRC-1)*NBCVRC + KCVRC)

        IF ( (IISNAN(VALVRM).EQ.0).AND.(IISNAN(VALVRP).EQ.0) ) THEN
          IF (POUM.EQ.'-') THEN
            VALVRC=VALVRM+(TD1-TIMED1)*(VALVRP-VALVRM)/(TIMEF1-TIMED1)
          ELSE IF (POUM.EQ.'+') THEN
            VALVRC=VALVRM+(TF1-TIMED1)*(VALVRP-VALVRM)/(TIMEF1-TIMED1)
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSE
          VALVRC=RUNDF
        ENDIF

      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

      IRET=0
      IF (IISNAN(VALVRC).GT.0)  IRET=1


C     -- TRAITEMENT SI IRET=1
      IF (IRET.EQ.1) THEN
        IF (NOVR8.EQ.'TEMP') THEN
          VALVRC=TDEF
          IRET=1
          GO TO 9999
        ENDIF
        IF (ARRET.EQ.' ') THEN
          VALVRC=RUNDF
        ELSE
          CALL TECAEL(IADZI,IAZK24)
          NOMAIL=ZK24(IAZK24-1+3)(1:8)
          VALK(1) = NOVR8
          VALK(2) = NOMAIL
          CALL U2MESK('F','CALCULEL4_69', 2 ,VALK)
        END IF
      END IF
      GOTO 9999




9998  CONTINUE
      IF (ARRET.EQ.' ') THEN
        VALVRC=RUNDF
        IRET=1
        GO TO 9999
      ENDIF
      CALL TECAEL(IADZI,IAZK24)
      VALI(1)=NB2VRC
      VALI(2)=NBCVRC
      VALK(1)=ZK24(IAZK24-1+3)
      CALL U2MESG('F','CALCULEL6_67',1,VALK,2,VALI,0,VALR)


9999  CONTINUE


      END
