      SUBROUTINE TE0510(OPTION,NOMTE)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C.......................................................................
C
C       CALCUL DES DONN�ES TOPOLOGIQUES CONCERNANT LES INTERSECTIONS
C              DES �L�MENTS ENRICHIS ET DU PLAN DE LA FISSURE
C
C
C  OPTION : 'TOPOFA' (X-FEM TOPOLOGIE DES FACETTES DE CONTACT)
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C......................................................................
      REAL*8 DDOT


      CHARACTER*8   ELP,TYPMA
      INTEGER       IGEOM,JLSN,JLST,JGRLSN,JGRLST
      INTEGER       JOUT1,JOUT2,JOUT3,JOUT4,JOUT5,JOUT6,JOUT7
      INTEGER       IADZI,IAZK24
      INTEGER       NINTER,NFACE,CFACE(5,3),AR(12,3),NBAR
      INTEGER       I,J,K,JJ,NNOP
      REAL*8        ND(3),GRLT(3),TAU1(3),TAU2(3),NORME,PS
      REAL*8        NORM2,PTREE(3),PTREF(3),RBID,RBID6(6),RBID3(3,3)
      REAL*8        FF(20), DFDI(20,3),LSN
      INTEGER       NDIM,IBID,NPTF,NBTOT,NFISS,JTAB(7),IRET
      LOGICAL       LBID,ISELLI,ELIM,ELIM2
      INTEGER       ZXAIN,XXMMVD,IFISS,NCOMPP,NCOMPA,NCOMPB,NCOMPC
      INTEGER       JFISCO,JFISS,KFISS,KCOEF,NCOMPH,HE,HESCL,HMAIT
      INTEGER       NFISC,IFISC,NFISC2,NN,VALI(2)
      CHARACTER*16  ENR

C     ALLOCATION DES OBJETS TEMPORAIRES A UNE TAILLE SUFFISANTE
C     (N'EST PAS EXACTEMENT LA TAILLE DES OBJETS EN SORTIE)
      INTEGER       PTMAXI
      PARAMETER    (PTMAXI=7)
      REAL*8        PINTER(PTMAXI*3)
C
      INTEGER       ZXAINX
      PARAMETER    (ZXAINX=5)
      REAL*8        AINTER(PTMAXI*ZXAINX)
C
      INTEGER       NFIMAX
      PARAMETER    (NFIMAX=10)
      INTEGER       FISC(2*NFIMAX),FISCO(2*NFIMAX)
C
      INTEGER       NBMAX
      PARAMETER    (NBMAX=18)
      INTEGER       PTHEA(NFIMAX*NBMAX)

C......................................................................
C     LES TABLEAUX FISC, FISCO, PTHEA, PINTER, AINTER ONT ETE ALLOUE DE
C     FACON STATIQUE POUR OPTIMISER LE CPU (CAR LES APPELS A WKVECT
C     DANS LES TE SONT COUTEUX).
C
      CALL ASSERT(OPTION.EQ.'TOPOFA')

      CALL JEMARQ()

      ZXAIN = XXMMVD('ZXAIN')
      CALL ASSERT(ZXAIN.EQ.ZXAINX)

      CALL ELREF1(ELP)
      CALL ELREF4(ELP,'RIGI',NDIM,NNOP,IBID,IBID,IBID,IBID,IBID,IBID)
C
C     RECUPERATION DES ENTR�ES / SORTIE
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PLSN','L',JLSN)
      CALL JEVECH('PLST','L',JLST)
      CALL JEVECH('PGRADLN','L',JGRLSN)
      CALL JEVECH('PGRADLT','L',JGRLST)

      CALL JEVECH('PPINTER','E',JOUT1)
      CALL JEVECH('PAINTER','E',JOUT2)
      CALL JEVECH('PCFACE' ,'E',JOUT3)
      CALL JEVECH('PLONCHA','E',JOUT4)
      CALL JEVECH('PBASECO','E',JOUT5)
      CALL JEVECH('PGESCLA','E',JOUT6)

      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)(1:8)
      CALL CONARE(TYPMA,AR,NBAR)
      CALL TEATTR(NOMTE,'S','XFEM',ENR,IBID)
      IF (ENR.EQ.'XH1'.OR.ENR.EQ.'XH2'.OR.
     &    ENR.EQ.'XH3'.OR.ENR.EQ.'XH4') THEN
C --- PAS D'ELEMENTS COUP�ES PLUSIEURS FOIS SANS CONTACT POUR L'INSTANT
        GOTO 999
      ENDIF
      CALL TECACH('NOO','PLST',7,JTAB,IRET)
C     NOMBRE DE FISSURES
      NFISS = JTAB(7)
      VALI(1)=NFIMAX
      VALI(2)=NFISS
      IF(NFISS.GT.NFIMAX)CALL U2MESI('F','XFEM2_6',2,VALI)
      DO 70 I=1,2*NFIMAX
         FISCO(I)=0
         FISC(I)=0
 70   CONTINUE
      NN=NFIMAX*NBMAX
      DO 72 I=1,NN
        PTHEA(I)=0
  72  CONTINUE
      IF (NFISS.GT.1) THEN
        CALL JEVECH('PFISCO','L',JFISCO)
        DO 73 I=1,2*NFISS
           FISCO(I)=ZI(JFISCO-1+I)
 73     CONTINUE
        CALL JEVECH('PHEAVFA','E',JOUT7)
        CALL TECACH('OOO','PHEAVFA',2,JTAB,IRET)
        NCOMPH = JTAB(2)
      ENDIF

C     DIMENSSION DES GRANDEURS DANS LA CARTE
      CALL TECACH('OOO','PPINTER',2,JTAB,IRET)
      NCOMPP = JTAB(2)
      CALL TECACH('OOO','PGESCLA',2,JTAB,IRET)
      CALL ASSERT(JTAB(2).EQ.NCOMPP)
      CALL TECACH('OOO','PAINTER',2,JTAB,IRET)
      NCOMPA = JTAB(2)
      CALL TECACH('OOO','PBASECO',2,JTAB,IRET)
      NCOMPB = JTAB(2)
      CALL TECACH('OOO','PCFACE',2,JTAB,IRET)
      NCOMPC = JTAB(2)
C
C --- BOUCLE SUR LES FISSURES
C
      DO 10 IFISS=1,NFISS
C ----------------------------------------------------------------------
C       RECHERCHE DES INTERSECTIONS ARETES-FISSURE
C       ET D�COUPAGE EN FACETTES
        DO 81 I=1,2*NFISS
            FISC(I)=0
 81     CONTINUE
        IFISC = IFISS
        NFISC = 0
  80    CONTINUE
        IF (FISCO(2*IFISC-1).GT.0) THEN
C       STOCKAGE DES FISSURES SUR LESQUELLES IFISS SE BRANCHE
          NFISC = NFISC+1
          FISC(2*(NFISC-1)+2) = FISCO(2*IFISC)
          IFISC = FISCO(2*IFISC-1)
          FISC(2*(NFISC-1)+1) = IFISC
          GOTO 80
        ENDIF

        NFISC2 = 0
        DO 20 JFISS = IFISS+1,NFISS
C       STOCKAGE DES FISSURES QUI SE BRANCHENT SUR IFISS
          KFISS = FISCO(2*JFISS-1)
          DO 30 I = NFISC+1,NFISC+NFISC2
            IF (FISC(2*(I-1)+1).EQ.KFISS) THEN
              NFISC2 = NFISC2 + 1
              FISC(2*(NFISC+NFISC2-1)+1) = JFISS
            ENDIF
  30      CONTINUE
          IF (KFISS.EQ.IFISS)  THEN
            NFISC2 = NFISC2 + 1
            FISC(2*(NFISC+NFISC2-1)+1) = JFISS
          ENDIF
  20    CONTINUE

        IF (.NOT.ISELLI(ELP) .AND. NDIM.LE.2) THEN
          CALL XCFAQ2(JLSN,JLST,JGRLSN,IGEOM,PINTER,NINTER,
     &                AINTER,NFACE,NPTF,CFACE,NBTOT)
        ELSE
          CALL XCFACE(ELP,ZR(JLSN),ZR(JLST),JGRLSN,IGEOM,ENR,
     &                NFISS,IFISS,FISC,NFISC,
     &                PINTER,NINTER,AINTER,NFACE,NPTF,CFACE)
          NBTOT=NINTER
        ENDIF
        IF (NFISS.GT.1.AND.NBTOT.GT.0)THEN
           DO 109 I=1,NBTOT*NFISS
              PTHEA(I)=0
 109       CONTINUE
        ENDIF
C       ARCHIVAGE DE PINTER, AINTER, GESCLA, GMAITR ET BASECO

        DO 110 I=1,NBTOT
          DO 111 J=1,NDIM
            PTREE(J)=PINTER(NDIM*(I-1)+J)
            ZR(JOUT6-1+NCOMPP*(IFISS-1)+NDIM*(I-1)+J) = PTREE(J)
 111      CONTINUE
C    ON TRANFORME LES COORDONN�ES R�ELES EN COORD. DANS L'�L�MENT DE REF
          CALL REEREF(ELP,LBID,NNOP,IBID,ZR(IGEOM),PTREE,1,LBID,
     &              NDIM,RBID, RBID,
     &              RBID,IBID,IBID,IBID,IBID,IBID,IBID,RBID,RBID3,'NON',
     &              PTREF,FF,DFDI,RBID3,RBID6,RBID3)

          DO 112 JJ=1,NDIM
            ZR(JOUT1-1+NCOMPP*(IFISS-1)+NDIM*(I-1)+JJ) = PTREF(JJ)
 112      CONTINUE
          DO 113 J=1,ZXAIN-1
            ZR(JOUT2-1+NCOMPA*(IFISS-1)+ZXAIN*(I-1)+J)=
     &                                         AINTER(ZXAIN*(I-1)+J)
 113      CONTINUE

C     CALCUL DE LA BASE COVARIANTE AUX POINTS D'INTERSECTION
C     ND EST LA NORMALE � LA SURFACE : GRAD(LSN)
C     TAU1 EST LE PROJET� DE GRAD(LST) SUR LA SURFACE
C     TAU2 EST LE PRODUIT VECTORIEL : ND ^ TAU1

C       INITIALISATION TAU1 POUR CAS 2D
          TAU1(3)=0.D0
          CALL VECINI(3,0.D0,ND)
          CALL VECINI(3,0.D0,GRLT)

          DO 114 J=1,NDIM
            DO 115 K=1,NNOP
              ND(J)   = ND(J) +
     &                   FF(K)*ZR(JGRLSN-1+NDIM*(NFISS*(K-1)+IFISS-1)+J)
              GRLT(J) = GRLT(J) +
     &                   FF(K)*ZR(JGRLST-1+NDIM*(NFISS*(K-1)+IFISS-1)+J)
 115        CONTINUE
 114      CONTINUE

          CALL NORMEV(ND,NORME)
          PS=DDOT(NDIM,GRLT,1,ND,1)
          DO 116 J=1,NDIM
            TAU1(J)=GRLT(J)-PS*ND(J)
 116      CONTINUE

          CALL NORMEV(TAU1,NORME)

          IF (NORME.LT.1.D-12) THEN
C           ESSAI AVEC LE PROJETE DE OX
            TAU1(1)=1.D0-ND(1)*ND(1)
            TAU1(2)=0.D0-ND(1)*ND(2)
            IF (NDIM .EQ. 3) TAU1(3)=0.D0-ND(1)*ND(3)
            CALL NORMEV(TAU1,NORM2)
            IF (NORM2.LT.1.D-12) THEN
C             ESSAI AVEC LE PROJETE DE OY
              TAU1(1)=0.D0-ND(2)*ND(1)
              TAU1(2)=1.D0-ND(2)*ND(2)
              IF (NDIM .EQ. 3) TAU1(3)=0.D0-ND(2)*ND(3)
              CALL NORMEV(TAU1,NORM2)
            ENDIF
            CALL ASSERT(NORM2.GT.1.D-12)
          ENDIF
          IF (NDIM .EQ. 3) THEN
           CALL PROVEC(ND,TAU1,TAU2)
          ENDIF
C
          DO 117 J=1,NDIM
            ZR(JOUT5-1+NCOMPB*(IFISS-1)+NDIM*NDIM*(I-1)+J)  =ND(J)
            ZR(JOUT5-1+NCOMPB*(IFISS-1)+NDIM*NDIM*(I-1)+J+NDIM)=TAU1(J)
            IF (NDIM .EQ. 3)
     &     ZR(JOUT5-1+NCOMPB*(IFISS-1)+NDIM*NDIM*(I-1)+J+2*NDIM)=TAU2(J)
 117      CONTINUE

          IF (NFISS.GT.1) THEN
C    CALCUL DES FONCTIONS HEAVISIDE AUX POINTS D'INTER
            DO 130 JFISS = 1,NFISS
              LSN = 0
              DO 131 K = 1,NNOP
                LSN = LSN + FF(K) * ZR(JLSN-1+NFISS*(K-1)+JFISS)
 131          CONTINUE
              IF (ABS(LSN).GT.1.D-11) THEN
                PTHEA(NFISS*(I-1)+JFISS) = NINT(SIGN(1.D0,LSN))
              ENDIF
 130        CONTINUE
          ENDIF

 110    CONTINUE

C     ARCHIVAGE DE CFACE ET DE HEAVFA
        DO 120 I=1,NFACE
          DO 121 J=1,NPTF
            ZI(JOUT3-1+NCOMPC*(IFISS-1)+NPTF*(I-1)+J)=CFACE(I,J)
 121      CONTINUE
          IF (NFISS.GT.1) THEN
            ELIM = .FALSE.
            ELIM2= .FALSE.
            DO 122 JFISS = 1,NFISS
              IF (JFISS.EQ.IFISS) THEN
C    ESCLAVE = -1, MAITRE = +1
                HESCL = -1
                HMAIT = +1
              ELSE
                HE = 0
                DO 123 J=1,NPTF
                  IF (PTHEA(NFISS*(CFACE(I,J)-1)+JFISS).NE.0.AND.
     &                 PTHEA(NFISS*(CFACE(I,J)-1)+JFISS).NE.HE.AND.
     &                 HE.NE.0) THEN
                    ELIM = .TRUE.
                  ENDIF
                  IF (HE.EQ.0)HE=PTHEA(NFISS*(CFACE(I,J)-1)+JFISS)

 123            CONTINUE

C    ESCLAVE = HE, MAITRE = HE
                HESCL = HE
                HMAIT = HE
C    ON MODIFIE LA VALEUR DANS LE CAS DE FONCTION JONCTION
                KFISS = JFISS
 124            CONTINUE
                IF (FISCO(2*(KFISS-1)+1).GT.0.AND.HE.NE.0) THEN
                  KCOEF = FISCO(2*(KFISS-1)+2)
                  KFISS = FISCO(2*(KFISS-1)+1)
                  IF (KFISS.EQ.IFISS) THEN
C    SI ON SE BRANCHE DU COT� MAITRE, MISE � Z�RO DU COT� ESCLAVE
                    IF (KCOEF.EQ.-1) HESCL = 0
C    SI ON SE BRANCHE DU COT� ESCLAVE, MISE � Z�RO DU COT� MAITRE
                    IF (KCOEF.EQ.1) HMAIT = 0
                  ELSE
C    SI PAS BRANCH� ET PAS DU BON C�T�, MISE � Z�RO DES DEUX C�T�S
                    HE = 0
                    DO 125 J=1,NPTF
                      IF (HE.EQ.0)
     &                        HE=PTHEA(NFISS*(CFACE(I,J)-1)+KFISS)
 125                CONTINUE
                    IF (KCOEF*HE.EQ.1) THEN
                      HESCL = 0
                      HMAIT = 0
                      ELIM = .FALSE.
                    ENDIF
                  ENDIF
                  GOTO 124
                ENDIF
                ELIM2 = ELIM2.OR.ELIM
              ENDIF
              ZI(JOUT7-1+NCOMPH*(NFISS*(IFISS-1)+JFISS-1)+2*I-1) = HESCL
              ZI(JOUT7-1+NCOMPH*(NFISS*(IFISS-1)+JFISS-1)+2*I)   = HMAIT
 122        CONTINUE
            IF (ELIM2) THEN
              CALL U2MESK('A','XFEM_45', 1 ,NOMTE)
              GOTO 998
            ENDIF
          ENDIF
 120    CONTINUE

C     ARCHIVAGE DE LONCHAM

        ZI(JOUT4+3*(IFISS-1)-1+2)=NFACE
 998    CONTINUE
        ZI(JOUT4+3*(IFISS-1)-1+1)=NINTER

        ZI(JOUT4+3*(IFISS-1)-1+3)=NPTF

        IF (NFISS.EQ.1)THEN
          DO 710 I=1,2*NFIMAX
            FISCO(I)=0
 710      CONTINUE
        ENDIF


  10  CONTINUE
C
 999  CONTINUE
C
      CALL JEDEMA()
      END
