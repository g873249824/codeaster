      SUBROUTINE DLNEW0 ( RESULT,FORCE0,FORCE1,
     &                    IINTEG, NEQ, ISTOC,
     &                    IARCHI, IFM, NBEXCI, NONDP, NMODAM, LAMORT,
     &                    LIMPED, LMODST, IMAT, MASSE, RIGID, AMORT,
     &                    NCHAR, NVECA, LIAD, LIFO, MODELE, MATE,
     &                    CARELE, CHARGE, INFOCH, FOMULT, NUMEDD, DEPLA,
     &                    VITEA, ACCEA, DEP0, VIT0, ACC0, FEXTE, FAMOR,
     &                    FLIAI, DEPL1, VITE1, ACCE1, PSDEL, FAMMO,
     &                    FIMPE, FONDE, VIEN, VITE, VITA1, MLTAP, A0,
     &                    A2, A3, A4, A5, A6, A7, A8, C0, C1, C2, C3,
     &                    C4, C5, NODEPL, NOVITE, NOACCE, MATRES,
     &                    MAPREC, SOLVEU, CRITER, CHONDP, ENER, VITINI,
     &                    VITENT, VALMOD, BASMOD, VEANEC, VAANEC,
     &                    VAONDE, VEONDE, DT, THETA, TEMPM, TEMPS,
     &                    IFORC2, TABWK1, TABWK2, ARCHIV,NBTYAR,TYPEAR )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/11/2012   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_21
C ----------------------------------------------------------------------
C     CALCUL MECANIQUE TRANSITOIRE PAR INTEGRATION DIRECTE
C     AVEC METHODES IMPLICITES :                  - THETA-WILSON
C                                                 - NEWMARK
C ----------------------------------------------------------------------
C  IN  : IINTEG    : ENTIER INDIQUANT LA METHODE D'INTEGRATION
C  IN  : NEQ       : NOMBRE D'EQUATIONS
C  IN  : ISTOC     : PILOTAGE DU STOCKAGE DES RESULTATS
C  IN  : IARCHI    : PILOTAGE DE L'ARCHIVAGE DES RESULTATS
C  IN  : NBEXCI    : NOMBRE D'EXCITATIONS
C  IN  : NONDP     : NOMBRE D'ONDES PLANES
C  IN  : NMODAM    : NOMBRE D'AMORTISSEMENTS MODAUX
C  IN  : LAMORT    : LOGIQUE INDIQUANT SI IL Y A AMORTISSEMENT
C  IN  : LIMPED    : LOGIQUE INDIQUANT SI
C  IN  : LMODST    : LOGIQUE INDIQUANT SI MODE STATIQUE
C  IN  : IMAT      : TABLEAU D'ADRESSES POUR LES MATRICES
C  IN  : MASSE     : MATRICE DE MASSE
C  IN  : NCHAR     : NOMBRE D'OCCURENCES DU MOT CLE CHARGE
C  IN  : NVECA     : NOMBRE D'OCCURENCES DU MOT CLE VECT_ASSE
C  IN  : LIAD      : LISTE DES ADRESSES DES VECTEURS CHARGEMENT (NVECT)
C  IN  : LIFO      : LISTE DES NOMS DES FONCTIONS EVOLUTION (NVECT)
C  IN  : MODELE    : NOM DU MODELE
C  IN  : MATE      : NOM DU CHAMP DE MATERIAU
C  IN  : CARELE    : CARACTERISTIQUES DES POUTRES ET COQUES
C  IN  : CHARGE    : LISTE DES CHARGES
C  IN  : INFOCH    : INFO SUR LES CHARGES
C  IN  : FOMULT    : LISTE DES FONC_MULT ASSOCIES A DES CHARGES
C  IN  : NUMEDD    : NUME_DDL DE LA MATR_ASSE RIGID
C  IN  : SOLVEU    : NOM DU SOLVEUR
C  IN  : CRITER    :
C  IN  : CHONDP    : NOMS DES ONDES PLANES
C  VAR : DEP0      : TABLEAU DES DEPLACEMENTS A L'INSTANT N
C  VAR : VIT0      : TABLEAU DES VITESSES A L'INSTANT N
C  VAR : ACC0      : TABLEAU DES ACCELERATIONS A L'INSTANT N
C  IN  : DT        : PAS DE TEMPS
C  IN  : THETA     : PARAMETRE DU SCHEMA TEMPOREL
C  IN  : TEMPM     : INSTANT PRECEDENT
C  IN  : TEMPS     : INSTANT COURANT
C
C CORPS DU PROGRAMME
      IMPLICIT NONE
C DECLARATION PARAMETRES D'APPELS
C
      INCLUDE 'jeveux.h'
      INTEGER NBEXCI, NONDP, NMODAM, IINTEG, NEQ
      INTEGER ISTOC, IARCHI, IFM, IMAT(3), NCHAR, NVECA, LIAD(*)
      INTEGER IFORC2, ARCHIV, NBTYAR, MLTAP(NBEXCI)
C
      REAL*8 DEPLA(NEQ), VITEA(NEQ), ACCEA(NEQ), RBID, DEP0(*), VIT0(*)
      REAL*8 ACC0(*), FEXTE(*), FAMOR(*), FLIAI(*), DEPL1(NEQ)
      REAL*8 VITE1(NEQ), ACCE1(NEQ), PSDEL(NEQ), FAMMO(NEQ), FIMPE(NEQ)
      REAL*8 FONDE(NEQ), VIEN(NEQ), VITE(NEQ), VITA1(NEQ), A0, A2, A3
      REAL*8 A4, A5, A6, A7, A8, C0, C1, C2, C3, C4, C5, TABWK1(NEQ)
      REAL*8 TABWK2(NEQ), DT, THETA, TEMPM, TEMPS
C
      LOGICAL LAMORT, LIMPED, LMODST, ENER
C
      CHARACTER*8 NODEPL(NBEXCI), NOVITE(NBEXCI), NOACCE(NBEXCI)
      CHARACTER*8 MASSE, RIGID, AMORT
      CHARACTER*8 RESULT
      CHARACTER*19 FORCE0,FORCE1
      CHARACTER*8 CHONDP(NONDP)
      CHARACTER*8 MATRES
      CHARACTER*16 TYPEAR(NBTYAR)
      CHARACTER*19 SOLVEU
      CHARACTER*19 MAPREC
      CHARACTER*24 CRITER
      CHARACTER*24 MODELE, MATE, CARELE, CHARGE, INFOCH, FOMULT, NUMEDD
      CHARACTER*24 VITINI, VITENT, VALMOD, BASMOD
      CHARACTER*24 LIFO(*)
      CHARACTER*24 VEANEC, VAANEC, VAONDE, VEONDE

C
C DECLARATION VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'DLNEW0' )
C
      INTEGER IFORC0, IFORC1
      INTEGER LRESU,LCRRE,NBEXRE,ITEM2,IRET,LVALE,IBID,I
      INTEGER LVAL1,LVAL2,LTPS0,LTPS1,NBINST,IFNOBI,IFCIBI,ALARM
      INTEGER IEXCI,IEQ,IRESU
C
      REAL*8 COEFD, COEFV, COEFA, PREC, EPS0, ALPHA
      INTEGER       NUMREU
      CHARACTER*8  K8BID
      CHARACTER*16 TYPA(6)
      CHARACTER*19 CHSOL, CHAM19, CHAMNO, CHAMN2,SDENER,K19BID
      CHARACTER*19 MASSE1,AMORT1,RIGID1
      CHARACTER*24 CINE, VECCOR, VECOND
      COMPLEX*16   CBID
C     -----------------------------------------------------------------
C
C
C --- NUMERO DE REUSE (PAS DE REUSE AVEC DYNA_VIBRA)
C
      NUMREU = 0

C
C --- NOM DES STRUCTURES DE TRAVAIL
C
      CHSOL  = '&&'//NOMPRO//'.SOLUTION '
      VECCOR = '&&VECCOR'
      VECOND = '&&VECOND'
      CINE   = '  '
      CHAMNO  = '&&'//NOMPRO//'.CHAMNO'
      CALL JEEXIN(CHAMNO(1:19)//'.REFE',IRET)
      IF (IRET.EQ.0) THEN
        CALL VTCREB(CHAMNO,NUMEDD,'V','R',NEQ)
      END IF
      CHAMN2  = '&&'//NOMPRO//'.CHAMN2'
      CALL JEEXIN(CHAMN2(1:19)//'.REFE',IRET)
      IF (IRET.EQ.0) THEN
        CALL VTCREB(CHAMN2,NUMEDD,'V','R',NEQ)
      END IF
C====
C 2. DEPLACEMENT, VITESSE ET ACCELERATIONS A
C====
      DO 21 , IEQ = 1,NEQ
        DEPLA(IEQ) = 0.D0
        VITEA(IEQ) = 0.D0
        ACCEA(IEQ) = 0.D0
   21 CONTINUE
C
      IF ( LMODST ) THEN
C
        DO 22 IEXCI = 1 , NBEXCI
C
          IF ( MLTAP(IEXCI).EQ.1 ) THEN
            CALL FOINTE('F ',NODEPL(IEXCI),1,'INST',TEMPS,COEFD,IEQ)
            CALL FOINTE('F ',NOVITE(IEXCI),1,'INST',TEMPS,COEFV,IEQ)
            CALL FOINTE('F ',NOACCE(IEXCI),1,'INST',TEMPS,COEFA,IEQ)
            DO 221 IEQ = 1,NEQ
              DEPLA(IEQ) = DEPLA(IEQ) + PSDEL(IEQ)*COEFD
              VITEA(IEQ) = VITEA(IEQ) + PSDEL(IEQ)*COEFV
              ACCEA(IEQ) = ACCEA(IEQ) + PSDEL(IEQ)*COEFA
  221       CONTINUE
          ENDIF
C
   22   CONTINUE
C
      ENDIF
C
C====
C 3.
C====
      DO 31 , IEQ = 1,NEQ
        VITE(IEQ) = VIT0(IEQ)
   31 CONTINUE
      IF ( LMODST ) THEN
        DO 32 , IEQ = 1,NEQ
          VIEN(IEQ) = VITEA(IEQ)
   32   CONTINUE
      ENDIF
      IF (LIMPED) THEN
        CALL FIMPED(MODELE,MATE,NUMEDD,NEQ,VITINI,VITENT,VECCOR,
     &              VEANEC,VAANEC,TEMPM,FIMPE)
      ENDIF
      IF ( NONDP.NE.0 ) THEN
        CALL FONDPL(MODELE,MATE,NUMEDD,NEQ,CHONDP,NONDP,VECOND,
     &              VEONDE,VAONDE,TEMPM,FONDE)
      ENDIF

      IF ( NMODAM.NE.0 ) THEN
        IF ( LMODST ) THEN
          DO 33 , IEQ = 1,NEQ
            VITA1(IEQ) = VIT0(IEQ) + VITEA(IEQ)
   33     CONTINUE
          CALL FMODAM(NEQ,VITA1,VALMOD,BASMOD,FAMMO)
        ELSE
          CALL FMODAM(NEQ,VIT0,VALMOD,BASMOD,FAMMO)
        ENDIF
      ENDIF

C====
C 4. CALCUL DU SECOND MEMBRE F*
C====
      CALL JEVEUO(FORCE0(1:19)//'.VALE','E',IFORC0)
      CALL JEVEUO(FORCE1(1:19)//'.VALE','E',IFORC1)
C
      CALL DLFEXT ( NVECA, NCHAR, TEMPS, NEQ,LIAD,
     &               LIFO, CHARGE, INFOCH, FOMULT,MODELE,
     &               MATE, CARELE, NUMEDD,
     &              ZR(IFORC1) )
C
      IF ( NONDP.NE.0 ) THEN
        DO 43 , IEQ = 1,NEQ
          ZR(IFORC1+IEQ-1) = ZR(IFORC1+IEQ-1) - FONDE(IEQ)
   43   CONTINUE
      ENDIF
      IF (ENER) THEN
        DO 433, IEQ =1,NEQ
          FEXTE(IEQ)=FEXTE(IEQ+NEQ)
          FEXTE(IEQ+NEQ)=ZR(IFORC1+IEQ-1)
  433   CONTINUE
      ENDIF

      IF ( LIMPED ) THEN
        DO 41 ,  IEQ = 1,NEQ
          ZR(IFORC1+IEQ-1) = ZR(IFORC1+IEQ-1) - FIMPE(IEQ)
   41   CONTINUE
        IF (ENER) THEN
          DO 411 IEQ=1,NEQ
            FLIAI(IEQ)=FLIAI(IEQ+NEQ)
            FLIAI(IEQ+NEQ)=FIMPE(IEQ)
  411     CONTINUE
        ENDIF
      ENDIF

      IF ( NMODAM.NE.0 ) THEN
        DO 42 , IEQ = 1,NEQ
          ZR(IFORC1+IEQ-1) = ZR(IFORC1+IEQ-1) - FAMMO(IEQ)
   42   CONTINUE
        IF (ENER) THEN
          DO 421 IEQ=1,NEQ
            FAMOR(IEQ)=FAMOR(IEQ+NEQ)
            FAMOR(IEQ+NEQ)=FAMMO(IEQ)
  421     CONTINUE
        ENDIF
      ENDIF

C
C   Chargement venant d'un RESU a TEMPS
C
      CALL GETFAC('EXCIT_RESU',NBEXRE)
      IF ( NBEXRE .NE. 0 ) THEN
        CALL JEVEUO('&&OP0048.COEF_RRE','L',LCRRE)
        CALL JEVEUO('&&OP0048.LISTRESU','L',LRESU)
        PREC=1.D-9
        EPS0 =1.D-12
        DO 210 IRESU = 1, NBEXRE
          IF (ABS(TEMPS).GT.EPS0) THEN
            CALL RSORAC(ZK8(LRESU+IRESU-1),'INST',IBID,TEMPS,K8BID,
     &                  CBID,PREC,'RELATIF',ITEM2,1,IBID)
          ELSE
            CALL RSORAC(ZK8(LRESU+IRESU-1),'INST',IBID,TEMPS,K8BID,
     &                  CBID,EPS0,'ABSOLU',ITEM2,1,IBID)
          ENDIF
          IF (IBID.GT.0) THEN
            CALL RSEXCH('F',ZK8(LRESU+IRESU-1),'DEPL',ITEM2,CHAM19,IRET)
            CALL VTCOPY(CHAM19,CHAMNO)
            CALL JEVEUO(CHAMNO//'.VALE','L',LVALE)

          ELSE
            CALL WKVECT('&&DLNEW0.XTRAC','V V R8',NEQ,LVALE)
            CALL JELIRA(ZK8(LRESU+IRESU-1)//'           .ORDR','LONUTI',
     &                  NBINST,K8BID)
C
C        --- INTERPOLATION LINEAIRE ---
            DO 211 I = 1, NBINST-1

              CALL RSADPA(ZK8(LRESU+IRESU-1),'L',1,'INST',I,0,
     &                    LTPS0,K8BID)
              CALL RSADPA(ZK8(LRESU+IRESU-1),'L',1,'INST',I+1,0,
     &                    LTPS1,K8BID)
              IF ( I.EQ.1 .AND. TEMPS.LT.ZR(LTPS0) ) THEN
                CALL RSEXCH('F',ZK8(LRESU+IRESU-1),'DEPL',I,CHAM19,IRET)
                CALL VTCOPY(CHAM19,CHAMNO)
                CALL JEVEUO(CHAMNO//'.VALE','L',LVALE)
                GOTO 213
              ENDIF
              IF ( TEMPS.GE.ZR(LTPS0).AND.TEMPS.LT.ZR(LTPS1)) THEN
                ALPHA = (TEMPS - ZR(LTPS0)) / (ZR(LTPS1) - ZR(LTPS0))
                CALL RSEXCH('F',ZK8(LRESU+IRESU-1),'DEPL',I,CHAM19,IRET)
                CALL VTCOPY(CHAM19,CHAMNO)
                CALL JEVEUO(CHAMNO//'.VALE','L',LVAL1)
                CALL RSEXCH('F',ZK8(LRESU+IRESU-1),'DEPL',I+1,CHAM19,
     &                      IRET)
                CALL VTCOPY(CHAM19,CHAMN2)
                CALL JEVEUO(CHAMN2//'.VALE','L',LVAL2)
                CALL DCOPY(NEQ,ZR(LVAL1),1,ZR(LVALE),1)
                CALL DSCAL(NEQ,(1.D0-ALPHA),ZR(LVALE),1)
                CALL DAXPY(NEQ,ALPHA,ZR(LVAL2),1,ZR(LVALE),1)
                GOTO 213
              ENDIF
              IF ( I.EQ.NBINST-1 .AND. TEMPS.GE.ZR(LTPS1) ) THEN
                CALL RSEXCH('F',ZK8(LRESU+IRESU-1),'DEPL',I+1,CHAM19,
     &                      IRET)
                CALL VTCOPY(CHAM19,CHAMNO)
                CALL JEVEUO(CHAMNO//'.VALE','L',LVALE)
                GOTO 213
              ENDIF
 211        CONTINUE
 213        CONTINUE
          ENDIF
          DO 212 IEQ = 1,NEQ
            ZR(IFORC2+IEQ-1) = ZR(LVALE+IEQ-1)*ZR(LCRRE+IRESU-1)
            ZR(IFORC1+IEQ-1) = ZR(IFORC1+IEQ-1) +
     &                          ZR(LVALE+IEQ-1)*ZR(LCRRE+IRESU-1)
  212     CONTINUE
          IF (IBID.GT.0) THEN
            CALL JELIBE(CHAM19//'.VALE')
          ELSE
            CALL JELIBE(CHAM19//'.VALE')
            CALL JEDETR('&&DLNEW0.XTRAC')
          ENDIF
  210   CONTINUE
        IF (ENER) THEN
          DO 23 IEQ = 1,NEQ
            FEXTE(IEQ+NEQ)=FEXTE(IEQ+NEQ)+ ZR(IFORC2+IEQ-1)
   23     CONTINUE
        ENDIF
      ENDIF

      IF ( IINTEG.EQ.2 ) THEN
        CALL DCOPY(NEQ,ZR(IFORC1),1,ZR(IFORC2),1)
        CALL FTETA(THETA,NEQ,ZR(IFORC0),ZR(IFORC1))
      ENDIF

C====
C 5. FORCE DYNAMIQUE F*
C====
      CALL FORCDY ( IMAT(2),IMAT(3),LAMORT,NEQ,C0,C1,C2,C3,C4,C5,
     &              DEP0, VIT0, ACC0,
     &              TABWK1, TABWK2, ZR(IFORC1) )
C
C====
C 6.  RESOLUTION DU PROBLEME K*  . U*  =  P*
C           --- RESOLUTION AVEC FORCE1 COMME SECOND MEMBRE ---
C====
      CALL RESOUD(MATRES,MAPREC,SOLVEU,CINE  ,0     ,
     &            FORCE1,CHSOL ,'V'   ,RBID  ,CBID  ,
     &            CRITER,.TRUE.,0     ,IRET  )
      CALL COPISD('CHAMP_GD','V',CHSOL(1:19),FORCE1(1:19))
      CALL JEVEUO(FORCE1(1:19)//'.VALE','E',IFORC1)
      CALL DETRSD('CHAMP_GD',CHSOL)
      CALL DCOPY(NEQ,ZR(IFORC1),1,DEPL1,1)

C====
C 7. CALCUL DES DEPLACEMENTS,VITESSES ET ACCELERATIONS
C====
      IF ( IINTEG.EQ.2 ) THEN
C
        CALL NEWACC ( NEQ, A4, A5, A6,
     &                DEP0, VIT0, ACC0, DEPL1, ACCE1)
        CALL NEWVIT ( NEQ, A7, A7,
     &                VIT0, ACC0, VITE1 , ACCE1)
        CALL NEWDEP ( NEQ, A8, DT,
     &                DEP0, VIT0, ACC0, DEPL1, ACCE1)
C
      ELSE IF ( IINTEG.EQ.1 ) THEN
C
        CALL NEWACC ( NEQ, A0, -A2, -A3,
     &                DEP0, VIT0, ACC0, DEPL1, ACCE1)
        CALL NEWVIT ( NEQ, A6, A7,
     &                VIT0, ACC0, VITE1, ACCE1)
C
      ENDIF

C====
C 8. CALCUL DES ENERGIES
C====
C
      SDENER=SOLVEU(1:8)//'.ENER      '
      IF (ENER) THEN
        MASSE1=MASSE//'           '
        AMORT1=AMORT//'           '
        RIGID1=RIGID//'           '
        CALL WKVECT('FNODABID','V V R',2*NEQ,IFNOBI)
        CALL WKVECT('FCINEBID','V V R',2*NEQ,IFCIBI)
        CALL ENERCA(K19BID, DEP0,VIT0,DEPL1,VITE1,MASSE1,
     &             AMORT1,RIGID1,FEXTE ,FAMOR ,FLIAI ,
     &             ZR(IFNOBI) ,ZR(IFCIBI), LAMORT,.TRUE.,.FALSE.,
     &             SDENER,'&&DLNEWI')
        CALL JEDETR('FNODABID')
        CALL JEDETR('FCINEBID')
      ENDIF

C====
C 9. TRANSFERT DES NOUVELLES VALEURS DANS LES ANCIENNES
C====
C
      CALL DCOPY ( NEQ ,DEPL1, 1, DEP0, 1)
      CALL DCOPY ( NEQ ,VITE1, 1, VIT0, 1)
      CALL DCOPY ( NEQ ,ACCE1, 1, ACC0, 1)
C
      IF ( IINTEG.EQ.2 ) THEN
        CALL DCOPY ( NEQ, ZR(IFORC2), 1, ZR(IFORC0), 1 )
      ELSE
        CALL DCOPY ( NEQ, ZR(IFORC1), 1, ZR(IFORC0), 1 )
      ENDIF


C====
C 11. ARCHIVAGE EVENTUEL DANS L'OBJET SOLUTION
C====
      IF ( ARCHIV.EQ.1 ) THEN
C
        ISTOC = 0
        ALARM = 1
C
        IF ( LMODST ) THEN
C
          TYPA(1) = 'DEPL_ABSOLU'
          TYPA(2) = 'VITE_ABSOLU'
          TYPA(3) = 'ACCE_ABSOLU'
          TYPA(4) = '    '
          TYPA(5) = '    '
          TYPA(6) = '    '
          DO 101 , IEQ = 1,NEQ
            DEPLA(IEQ) = DEPLA(IEQ) + DEP0(IEQ)
            VITEA(IEQ) = VITEA(IEQ) + VIT0(IEQ)
            ACCEA(IEQ) = ACCEA(IEQ) + ACC0(IEQ)
  101     CONTINUE
          CALL DLARCH ( RESULT,NEQ, ISTOC, IARCHI, ' ',
     &                  ALARM, IFM, TEMPS,
     &                  NBTYAR, TYPA, MASSE,
     &                  DEPLA, VITEA, ACCEA,
     &                  FEXTE(NEQ+1), FAMOR(NEQ+1), FLIAI(NEQ+1))
C
        ENDIF
C
        CALL DLARCH ( RESULT,NEQ, ISTOC, IARCHI, ' ',
     &                ALARM, IFM, TEMPS,
     &                NBTYAR, TYPEAR, MASSE,
     &                DEP0, VIT0, ACC0,
     &                FEXTE(NEQ+1),FAMOR(NEQ+1),FLIAI(NEQ+1))
C
      ENDIF
C
      CALL NMARPC(RESULT,SDENER,NUMREU,TEMPS)
C
      END
