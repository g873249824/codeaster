      SUBROUTINE DLNEW0 ( NRORES, NBPASE, INPSCO,
     &                    IINTEG, NEQ, ISTOC, IARCHI, IFM,
     &                    NBEXCI, NONDP, NMODAM,
     &                    LAMORT, LIMPED, LMODST, IMAT, MASSE,
     &                    NCHAR, NVECA, LIAD, LIFO, MODELE,
     &                    MATE, CARELE, CHARGE, INFOCH, FOMULT, NUMEDD,
     &                    DEPLA, VITEA, ACCEA,
     &                    DEP0, VIT0, ACC0,
     &                    DEPL1, VITE1, ACCE1,
     &                    PSDEL, FAMMO, FIMPE, FONDE,
     &                    VIEN, VITE, VITA1, MLTAP,
     &                    A0, A2, A3, A4, A5, A6, A7, A8,
     &                    C0, C1, C2, C3, C4, C5,
     &                    NODEPL, NOVITE, NOACCE,
     &                    MATRES, MAPREC, SOLVEU, CRITER, CHONDP,
     &                    VITINI, VITENT, VALMOD, BASMOD,
     &                    VEANEC, VAANEC, VAONDE, VEONDE,
     &                    DT, THETA, TEMPM, TEMPS, IFORC2,
     &                    TABWK1, TABWK2, ARCHIV, NBTYAR, TYPEAR )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 04/10/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C  IN  : NRORES    : NUMERO DE LA RESOLUTION
C                  0 : CALCUL STANDARD
C                 >0 : CALCUL DE LA DERIVEE NUMERO NRORES
C  IN  : NBPASE    : NOMBRE DE PARAMETRES SENSIBLES
C  IN  : INPSCO    : STRUCTURE CONTENANT LA LISTE DES NOMS
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
      INTEGER NRORES, NBPASE
      INTEGER IINTEG, NEQ, ISTOC, IARCHI, IFM
      INTEGER NBEXCI, NONDP
      INTEGER NMODAM
      INTEGER IMAT(3)
      INTEGER NCHAR, NVECA, LIAD(*)
      INTEGER IFORC2
      INTEGER ARCHIV, NBTYAR
      INTEGER MLTAP(NBEXCI)

C
      REAL*8 DEPLA(NEQ), VITEA(NEQ), ACCEA(NEQ),RBID
      REAL*8 DEP0(*), VIT0(*), ACC0(*)
      REAL*8 DEPL1(NEQ), VITE1(NEQ), ACCE1(NEQ)
      REAL*8 PSDEL(NEQ), FAMMO(NEQ), FIMPE(NEQ), FONDE(NEQ)
      REAL*8 VIEN(NEQ), VITE(NEQ), VITA1(NEQ)
      REAL*8 A0, A2, A3, A4, A5, A6, A7, A8
      REAL*8 C0, C1, C2, C3, C4, C5
      REAL*8 TABWK1(NEQ), TABWK2(NEQ)
      REAL*8 DT, THETA, TEMPM, TEMPS
C
      LOGICAL LAMORT, LIMPED, LMODST
C
      CHARACTER*8 NODEPL(NBEXCI), NOVITE(NBEXCI), NOACCE(NBEXCI)
      CHARACTER*8 MASSE
      CHARACTER*8 CHONDP(NONDP)
      CHARACTER*8 MATRES
      CHARACTER*13 INPSCO
      CHARACTER*16 TYPEAR(NBTYAR)
      CHARACTER*19 SOLVEU
      CHARACTER*19 MAPREC
      CHARACTER*24 CRITER
      CHARACTER*24 MODELE, MATE, CARELE, CHARGE, INFOCH, FOMULT, NUMEDD
      CHARACTER*24 VITINI, VITENT, VALMOD, BASMOD
      CHARACTER*24 LIFO(*)
      CHARACTER*24 VEANEC, VAANEC, VAONDE, VEONDE

C    ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
C DECLARATION VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'DLNEW0' )
C
      INTEGER IFORC0, IFORC1
      INTEGER IAUX, JAUX
      INTEGER LRESU,LCRRE,IRESU,NBEXRE,ITEM2,IRET,LVALE,IBID,IBI2,I
      INTEGER LVAL1,LVAL2,LTPS0,LTPS1,NBINST
C
      REAL*8 COEFD, COEFV, COEFA
      REAL*8 PREC, EPS0, ALPHA

      CHARACTER*8 RESULT,K8BID
      CHARACTER*16 TYPA(3)
      CHARACTER*19 CHSOL, CHAM19, CHAMNO, CHAMN2
      CHARACTER*19 FORCE0, FORCE1
      CHARACTER*24 CINE
      CHARACTER*24 VECCOR, VECOND
      COMPLEX*16   CBID

C     -----------------------------------------------------------------
C
CCC        PRINT *,'ENTREE DANS ', NOMPRO,' POUR NRORES = ',NRORES
C====
C 1. PREALABLES
C====
C 1.1. ==> NOM DES STRUCTURES ASSOCIEES AUX DERIVATIONS
C                3. LE NOM DU RESULTAT
C               10. VARIABLE COMPLEMENTAIRE NUMERO 2 INSTANT N

      IAUX = NRORES

      JAUX = 3
      CALL PSNSLE ( INPSCO, IAUX, JAUX, RESULT )
CCC      PRINT *,'NRORES = ',NRORES,' ==> RESULT = ', RESULT
C
      JAUX = 8
      CALL PSNSLE ( INPSCO, IAUX, JAUX, FORCE0 )
CCC      PRINT *,'NRORES = ',NRORES,' ==> FORCE0 = ', FORCE0
C
      JAUX = 10
      CALL PSNSLE ( INPSCO, IAUX, JAUX, FORCE1 )
CCC      PRINT *,'NRORES = ',NRORES,' ==> FORCE1 = ', FORCE1
C
C 1.2. ==> NOM DES STRUCTURES DE TRAVAIL
C
C               12   345678   9012345678901234
      CHSOL  = '&&'//NOMPRO//'.SOLUTION  '
C               123456789012345678901234
      VECCOR = '&&VECCOR                '
      VECOND = '&&VECOND                '
      CINE   = '                        '
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

      DO 21 , IAUX = 1,NEQ
        DEPLA(IAUX) = 0.D0
        VITEA(IAUX) = 0.D0
        ACCEA(IAUX) = 0.D0
   21 CONTINUE
C
      IF ( LMODST ) THEN
C
        DO 22 , JAUX = 1 , NBEXCI
C
          IF ( MLTAP(JAUX).EQ.1 ) THEN
            CALL FOINTE('F ',NODEPL(JAUX),1,'INST',TEMPS,COEFD,IAUX)
            CALL FOINTE('F ',NOVITE(JAUX),1,'INST',TEMPS,COEFV,IAUX)
            CALL FOINTE('F ',NOACCE(JAUX),1,'INST',TEMPS,COEFA,IAUX)
            DO 221 , IAUX = 1,NEQ
              DEPLA(IAUX) = DEPLA(IAUX) + PSDEL(IAUX)*COEFD
              VITEA(IAUX) = VITEA(IAUX) + PSDEL(IAUX)*COEFV
              ACCEA(IAUX) = ACCEA(IAUX) + PSDEL(IAUX)*COEFA
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

      DO 31 , IAUX = 1,NEQ
        VITE(IAUX) = VIT0(IAUX)
   31 CONTINUE
      IF ( LMODST ) THEN
        DO 32 , IAUX = 1,NEQ
          VIEN(IAUX) = VITEA(IAUX)
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
          DO 33 , IAUX = 1,NEQ
            VITA1(IAUX) = VIT0(IAUX) + VITEA(IAUX)
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
      CALL DLFEXT ( NVECA, NCHAR, TEMPS, NEQ,
     &              LIAD, LIFO, CHARGE, INFOCH, FOMULT,
     &              MODELE, MATE, CARELE, NUMEDD,
     &              NBPASE, NRORES, INPSCO, ZR(IFORC1) )
C
      IF ( LIMPED ) THEN
        DO 41 ,  IAUX = 1,NEQ
          ZR(IFORC1+IAUX-1) = ZR(IFORC1+IAUX-1) - FIMPE(IAUX)
   41   CONTINUE
      ENDIF

      IF ( NMODAM.NE.0 ) THEN
        DO 42 , IAUX = 1,NEQ
          ZR(IFORC1+IAUX-1) = ZR(IFORC1+IAUX-1) - FAMMO(IAUX)
   42   CONTINUE
      ENDIF

      IF ( NONDP.NE.0 ) THEN
        DO 43 , IAUX = 1,NEQ
          ZR(IFORC1+IAUX-1) = ZR(IFORC1+IAUX-1) - FONDE(IAUX)
   43   CONTINUE
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
            CALL RSEXCH(ZK8(LRESU+IRESU-1),'DEPL',ITEM2,CHAM19,IRET)
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
                CALL RSEXCH(ZK8(LRESU+IRESU-1),'DEPL',I,CHAM19,IRET)
                CALL VTCOPY(CHAM19,CHAMNO)
                CALL JEVEUO(CHAMNO//'.VALE','L',LVALE)
                GOTO 213
              ENDIF
              IF ( TEMPS.GE.ZR(LTPS0).AND.TEMPS.LT.ZR(LTPS1)) THEN
                ALPHA = (TEMPS - ZR(LTPS0)) / (ZR(LTPS1) - ZR(LTPS0))
                CALL RSEXCH(ZK8(LRESU+IRESU-1),'DEPL',I,CHAM19,IRET)
                CALL VTCOPY(CHAM19,CHAMNO)
                CALL JEVEUO(CHAMNO//'.VALE','L',LVAL1)
                CALL RSEXCH(ZK8(LRESU+IRESU-1),'DEPL',I+1,CHAM19,IRET)
                CALL VTCOPY(CHAM19,CHAMN2)
                CALL JEVEUO(CHAMN2//'.VALE','L',LVAL2)
                CALL DCOPY(NEQ,ZR(LVAL1),1,ZR(LVALE),1)
                CALL DSCAL(NEQ,(1.D0-ALPHA),ZR(LVALE),1)
                CALL DAXPY(NEQ,ALPHA,ZR(LVAL2),1,ZR(LVALE),1)
                GOTO 213
              ENDIF
              IF ( I.EQ.NBINST-1 .AND. TEMPS.GE.ZR(LTPS1) ) THEN
                CALL RSEXCH(ZK8(LRESU+IRESU-1),'DEPL',I+1,CHAM19,IRET)
                CALL VTCOPY(CHAM19,CHAMNO)
                CALL JEVEUO(CHAMNO//'.VALE','L',LVALE)
                GOTO 213
              ENDIF
 211        CONTINUE
 213        CONTINUE
          ENDIF
          DO 212 IAUX = 1,NEQ
            ZR(IFORC2+IAUX-1) = ZR(LVALE+IAUX-1)*ZR(LCRRE+IRESU-1)
            ZR(IFORC1+IAUX-1) = ZR(IFORC1+IAUX-1) +
     &                          ZR(LVALE+IAUX-1)*ZR(LCRRE+IRESU-1)
  212     CONTINUE
          IF (IBID.GT.0) THEN
            CALL JELIBE(CHAM19//'.VALE')
          ELSE
            CALL JELIBE(CHAM19//'.VALE')
            CALL JEDETR('&&DLNEW0.XTRAC')
          ENDIF
  210   CONTINUE
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

      CALL RESOUD(MATRES,MAPREC,FORCE1,SOLVEU,CINE,'V',CHSOL,CRITER,0,
     &            RBID,CBID)
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
C 8. TRANSFERT DES NOUVELLES VALEURS DANS LES ANCIENNES
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
C 9. DANS LE CAS DE CALCUL AVEC SENSIBILITE ET POUR LE CALCUL
C          NOMINALE, SAUVEGARDE DU CHAMP SOLUTION
C====
C
      IF ( NRORES.EQ.0 .AND. NBPASE.GT.0 ) THEN
C
        IAUX = 6
        CALL SENS01 ( INPSCO,
     &                NEQ, MASSE,
     &                IAUX, DEPL1, ACCE1 )
C
      ENDIF

C====
C 10. ARCHIVAGE EVENTUEL DANS L'OBJET SOLUTION
C====
C
      IF ( ARCHIV.EQ.1 ) THEN
C
        ISTOC = 0
        JAUX = 1
C
        IF ( LMODST ) THEN
C
          TYPA(1) = 'DEPL_ABSOLU'
          TYPA(2) = 'VITE_ABSOLU'
          TYPA(3) = 'ACCE_ABSOLU'
          DO 101 , IAUX = 1,NEQ
            DEPLA(IAUX) = DEPLA(IAUX) + DEP0(IAUX)
            VITEA(IAUX) = VITEA(IAUX) + VIT0(IAUX)
            ACCEA(IAUX) = ACCEA(IAUX) + ACC0(IAUX)
  101     CONTINUE
          CALL DLARCH ( NRORES, INPSCO,
     &                  NEQ, ISTOC, IARCHI, ' ',
     &                  JAUX, IFM, TEMPS,
     &                  NBTYAR, TYPA, MASSE,
     &                  DEPLA, VITEA, ACCEA )
C
        ENDIF
C
        CALL DLARCH ( NRORES, INPSCO,
     &                NEQ, ISTOC, IARCHI, ' ',
     &                JAUX, IFM, TEMPS,
     &                NBTYAR, TYPEAR, MASSE,
     &                DEP0, VIT0, ACC0 )
C
      ENDIF
C
      END
