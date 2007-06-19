      SUBROUTINE MPINV2 ( NBMESU , NBMODE , NBABS  , 
     &                    PHI    , RMESU  , COEF   , 
     &                    XABS   , 
     &                    LFONCT , 
     &                    RETA   , RETAP  , RETA2P )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/06/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
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
C     PROJ_MESU_MODAL : RESOLUTION DU SYSTEME PAR SVD OU PAR LU
C                       (DONNEES TEMPORELLES)
C
C     IN  : NBMESU : NOMBRE DE NOEUDS DE MESURE
C     IN  : NBMODE : NOMBRE DE MODES 
C     IN  : NBABS : NOMBRE D ABSCISSES
C     IN  : PHI    : MATRICE MODALE REDUITE AUX NOEUDS DE MESURE
C     IN  : RMESU  : VALEURS DE MESURE
C     IN  : COEF   : COEFFICIENTS DE PONDERATION
C     IN  : XABS  : LISTE REELLE D ABSCISSES
C     IN  : LFONCT : =.TRUE. SI COEFFICIENTS DE PONDERATION 
C                    DEPENDENT DE T
C     OUT : RETA    : DEPLACEMENT GENERALISE   ( MATRICE )
C     OUT : RETAP   : VITESSE  GENERALISEE     ( MATRICE )
C     OUT : RETA2P  : ACCELERATION GENERALISE  ( MATRICE )
C
      IMPLICIT NONE
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER NBMESU, NBMODE, NBABS
      INTEGER VALI
      REAL*8  PHI(NBMESU, NBMODE)
      REAL*8 VALR
      REAL*8 RMESU(NBMESU, NBABS),RETA(NBMODE, NBABS)
      REAL*8 RETAP(NBMODE, NBABS), RETA2P(NBMODE, NBABS) 
      REAL*8  XABS(NBABS)
      REAL*8  COEF(*)
      LOGICAL LFONCT
C ----------------------------------------------------------------------
      INTEGER       IMOD, JMOD, IMES, IABS, IERR, IBID, JMES
      INTEGER LSCDMB,LWKS,LPHIPH,LPHITP,LMATSY,LWORK,LETA,LVALS,LU,LV
      REAL*8        ALPHA, R8PREM,EPS
      LOGICAL       NUL
      CHARACTER*3   METHOD
      CHARACTER*8   REGUL
      CHARACTER*16  NOMCHA
      CHARACTER*16  SCDMBR,WKS,PHIPHT,PHITPH,MATSYS,WORK,ETA,VALS,U,V
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()

C CREATION DES VECTEURS DE TRAVAIL
      SCDMBR = '&SCDMBR'
      WKS = '&WKS'
      PHIPHT = '&PHIPHT'
      PHITPH = '&PHITPH'
      MATSYS = '&MATSYS'
      WORK = '&WORK'
      ETA = '&ETA'
      VALS = '&VALS'
      U = '&U'
      V = '&V'

      CALL WKVECT(SCDMBR,'V V R',NBMODE,LSCDMB)
      CALL WKVECT(WKS,'V V R',NBMODE,LWKS)
      CALL WKVECT(PHIPHT,'V V R',NBMESU*NBMESU,LPHIPH)
      CALL WKVECT(PHITPH,'V V R',NBMODE*NBMODE,LPHITP)
      CALL WKVECT(MATSYS,'V V R',NBMODE*NBMODE,LMATSY)
      CALL WKVECT(WORK,'V V R',NBMODE,LWORK)
      CALL WKVECT(ETA,'V V R',NBMODE,LETA)
      CALL WKVECT(VALS,'V V R',NBMODE,LVALS)
      CALL WKVECT(U,'V V R',NBMODE*NBMODE,LU)
      CALL WKVECT(V,'V V R',NBMODE*NBMODE,LV)

C METHODE DE RESOLUTION : LU / SVD
      CALL GETVTX ('RESOLUTION', 'METHODE',1,1,1, METHOD, IBID)
      IF (IBID .EQ. 0) METHOD = 'LU'

      IF (METHOD .EQ. 'SVD') THEN
        CALL GETVR8 ('RESOLUTION', 'EPS',1,1,1, EPS, IBID)
        IF (IBID .EQ. 0) EPS = 0.D0
      END IF

C REGULARISATION : NON / NORM_MIN / TIK_RELA
      CALL GETVTX ('RESOLUTION', 'REGUL',1,1,1, REGUL, IBID)
      IF (IBID .EQ. 0) REGUL = 'NON'

      CALL GETVTX ('MODELE_MESURE','NOM_CHAM',1,1,1,NOMCHA,IBID)
C
C ===============================
C CALCUL DE PHI_TRANSPOSEE * PHI 
C ===============================
      DO 30 IMOD = 1,NBMODE
        DO 20 JMOD = 1,NBMODE
          ZR(LPHITP-1 +IMOD+NBMODE*(JMOD-1)) = 0.D0
          DO 10 IMES = 1,NBMESU
            ZR(LPHITP-1 +IMOD+NBMODE*(JMOD-1)) = 
     &                             ZR(LPHITP-1 +IMOD+NBMODE*(JMOD-1)) 
     &                           + PHI(IMES,IMOD)*PHI(IMES,JMOD)
 10       CONTINUE
 20     CONTINUE
 30   CONTINUE

      IF (NBMESU .LT. NBMODE) THEN
C ===============================
C CALCUL DE PHI * PHI_TRANSPOSEE 
C ===============================
        DO 40 IMES = 1,NBMESU
          DO 50 JMES = 1,NBMESU
            ZR(LPHIPH-1 +IMES+NBMESU*(JMES-1)) = 0.D0
            DO 60 IMOD = 1,NBMODE
              ZR(LPHIPH-1 +IMES+NBMESU*(JMES-1)) = 
     &                             ZR(LPHIPH-1 +IMES+NBMESU*(JMES-1)) 
     &                           + PHI(IMES,IMOD)*PHI(JMES,IMOD)
 60         CONTINUE
 50       CONTINUE
 40     CONTINUE
      END IF
C
C =======================================
C CALCUL DE LA REPONSE GENERALISEE : RETA
C =======================================
C
C DEBUT DE LA BOUCLE SUR LES ABSCISSES
C *****************************
      DO 100 IABS = 1,NBABS
C
        NUL = .TRUE.
C
C DEBUT DE LA BOUCLE SUR LES MODES
C ********************************
        DO 90 IMOD = 1,NBMODE
C
C RECHERCHE DU COEFFICIENT DE PONDERATION
C ***************************************
          IF (LFONCT) THEN
C             -> ALPHA DEPENDANT DES ABSCISSES
              ALPHA = COEF (NBMODE*(IABS-1)+IMOD)
            ELSE
C             -> ALPHA INDEPENDANT DES ABSCISSES
              ALPHA = COEF (IMOD)
          ENDIF
C
C         -> ON VERIFIE QUE ALPHA > 0, SINON ARRET
          IF (ALPHA .LT. 0.D0) THEN
              VALI = IABS
              CALL U2MESG('F','ALGORITH15_24',0,' ',1,VALI,0,0.D0)
            ELSE IF (ALPHA .GT. R8PREM()) THEN
              NUL=.FALSE.
          ENDIF
C
C DETERMINATION DE LA MATRICE A INVERSER :
C MATSYS(IABS) = PHI_T*PHI + ALPHA(IABS)
C ****************************************
          DO 80 JMOD = 1,NBMODE
            ZR(LMATSY-1 +IMOD+NBMODE*(JMOD-1)) = 
     &                    ZR(LPHITP-1 +IMOD+NBMODE*(JMOD-1))
 80       CONTINUE
C
          ZR(LMATSY-1 +IMOD+NBMODE*(IMOD-1)) = 
     &                 ZR(LMATSY-1 +IMOD+NBMODE*(IMOD-1)) + ALPHA
C
C DETERMINATION DU SECOND MEMBRE :
C SCDMB(IABS) = PHI_T*Q + ALPHA(IABS)*RETA(IABS-1)
C RQ : A IABS=1, RETA(0)=0 (LA SOLUTION A PRIORI EST NULLE)
C ********************************************************
          ZR(LSCDMB-1 +IMOD) = 0.D0
C
          DO 70 IMES = 1,NBMESU
             ZR(LSCDMB-1 +IMOD) = ZR(LSCDMB-1 +IMOD) + 
     &           PHI(IMES,IMOD)*RMESU(IMES,IABS)
 70       CONTINUE
C
          IF ((REGUL .EQ. 'TIK_RELA') .AND. (IABS .GT. 1)) THEN
             ZR(LSCDMB-1 +IMOD) = ZR(LSCDMB-1 +IMOD) + 
     &                       ALPHA*RETA(IMOD,IABS-1)
          ENDIF
C
C FIN DE LA BOUCLE SUR LES MODES
C ******************************
 90     CONTINUE


C
C RESOLUTION DU SYSTEME : 
C MATSYS(IABS) * ETA(IABS) = SCDMB(IABS)
C **************************************

C       -> ALARME SI ALPHA NUL ET NBMESU<NBMODE : MOINDRE NORME
        IF ((NBMESU .LT. NBMODE) .AND. (NUL)) THEN
          CALL U2MESG('A','ALGORITH15_25',0,' ',0,0,0,0.D0)

          IF (REGUL .EQ. 'NON') THEN
C CALCUL MOINDRE NORME
            CALL U2MESG('A','ALGORITH15_26',0,' ',0,0,0,0.D0)
            DO 82 IMES = 1,NBMESU
              ZR(LSCDMB-1 +IMES) = RMESU(IMES,IABS)
              DO 81 JMES = 1,NBMESU
                ZR(LMATSY-1 +IMES+NBMODE*(JMES-1)) = 
     &                    ZR(LPHIPH-1 +IMES+NBMESU*(JMES-1))
 81           CONTINUE
 82         CONTINUE

C CHOIX POUR LA METHODE D INVERSION
            IF (METHOD .EQ. 'SVD') THEN
C METHODE SVD
C CREATION DU VECTEUR SECOND MEMBRE
              DO 83 JMES = 1,NBMESU
                ZR(LETA-1 +JMES) = ZR(LSCDMB-1 +JMES)
 83           CONTINUE
C
              CALL RSLSVD (NBMODE, NBMESU, NBMESU,ZR(LMATSY),ZR(LVALS), 
     &                   ZR(LU),ZR(LV),1,ZR(LETA),EPS,IERR,ZR(LWORK) )
              IF ( IERR . NE. 0 ) THEN
              VALI = IABS
              VALR = XABS ( IABS )
              CALL U2MESG('F','ALGORITH15_27',0,' ',1,VALI,1,VALR)
              END IF
C
            ELSE
C METHODE DE CROUT
              CALL MTCROG (ZR(LMATSY),ZR(LSCDMB),NBMODE,NBMESU,1,
     &                           ZR(LETA), ZR(LWKS), IERR)
              IF ( IERR . NE. 0 ) THEN
              VALI = IABS
              VALR = XABS ( IABS )
              CALL U2MESG('F','ALGORITH15_28',0,' ',1,VALI,1,VALR)
              END IF
            END IF
C
C COPIE DES RESULTATS DANS RETA
            DO 84 JMOD = 1,NBMODE
              DO 85 JMES = 1,NBMESU
                RETA(JMOD,IABS) = ZR(LETA-1 +JMES)*PHI(JMES,JMOD)
 85           CONTINUE
 84         CONTINUE
C
            GO TO 100 
          END IF
        END IF
C FIN CALCUL MOINDRE NORME

C
C CHOIX POUR LA METHODE DE RESOLUTION
        IF (METHOD .EQ. 'SVD') THEN
C METHODE SVD
C CREATION DU VECTEUR SECOND MEMBRE
          DO 71 JMOD = 1,NBMODE
             ZR(LETA-1 +JMOD) = ZR(LSCDMB-1 +JMOD)
 71       CONTINUE
C
          CALL RSLSVD (NBMODE, NBMODE, NBMODE, ZR(LMATSY), ZR(LVALS), 
     &                   ZR(LU),ZR(LV),1,ZR(LETA),EPS,IERR,ZR(LWORK) )
          IF ( IERR . NE. 0 ) THEN
          VALI = IABS
          VALR = XABS ( IABS )
          CALL U2MESG('F','ALGORITH15_29',0,' ',1,VALI,1,VALR)
          END IF
C
        ELSE
C METHODE DE CROUT
C
          CALL MTCROG (ZR(LMATSY),ZR(LSCDMB),NBMODE,NBMODE,1,
     &                           ZR(LETA), ZR(LWKS), IERR)
          IF ( IERR . NE. 0 ) THEN
          VALI = IABS
          VALR = XABS ( IABS )
          CALL U2MESG('F','ALGORITH15_30',0,' ',1,VALI,1,VALR)
          END IF
        END IF
C
C COPIE DES RESULTATS DANS RETA
        DO 73 JMOD = 1,NBMODE
           RETA(JMOD,IABS) = ZR(LETA-1 +JMOD)
 73     CONTINUE
C
C FIN DE LA BOUCLE SUR LES ABSCISSES
C ***************************
100   CONTINUE
C
C ========================================
C CALCUL DE LA VITESSE GENERALISEE : RETAP
C ========================================
C
      DO 200 IABS = 1,NBABS
        IF (IABS .NE. NBABS) THEN
          DO 210 IMOD = 1,NBMODE
            RETAP(IMOD,IABS) = (RETA(IMOD,IABS+1) - RETA(IMOD,IABS))
     &                           / (XABS(IABS+1) - XABS(IABS))
 210      CONTINUE
        ELSE
          DO 220 IMOD = 1,NBMODE
            RETAP(IMOD,IABS) = RETAP(IMOD,IABS-1)
 220      CONTINUE
        ENDIF
200   CONTINUE
C
C =============================================
C CALCUL DE L'ACCELERATION GENERALISEE : RETA2P
C =============================================
C
      DO 300 IABS = 1,NBABS
        IF (IABS .NE. NBABS) THEN
          DO 310 IMOD = 1,NBMODE
            RETA2P(IMOD,IABS) = (RETAP(IMOD,IABS+1) - RETAP(IMOD,IABS))
     &                             / (XABS(IABS+1) - XABS(IABS))
 310      CONTINUE
        ELSE
          DO 320 IMOD = 1,NBMODE
            RETA2P(IMOD,IABS) = RETA2P(IMOD,IABS-1)
 320      CONTINUE
        ENDIF
300   CONTINUE
C
      IF (NOMCHA .EQ. 'VITE') THEN
        DO 101 IABS = 1,NBABS
          DO 102 IMOD = 1,NBMODE
            RETAP(IMOD,IABS) = RETA(IMOD,IABS)
 102      CONTINUE
101     CONTINUE
        DO 103 IABS = 1,NBABS
          IF (IABS .NE. NBABS) THEN
            DO 104 IMOD = 1,NBMODE
              RETA2P(IMOD,IABS) = (RETAP(IMOD,IABS+1)-RETAP(IMOD,IABS))
     &                             / (XABS(IABS+1) - XABS(IABS))
 104        CONTINUE
          ELSE
            DO 105 IMOD = 1,NBMODE
              RETA2P(IMOD,IABS) = RETA2P(IMOD,IABS-1)
 105        CONTINUE
          ENDIF
103     CONTINUE
C ON FAIT L HYPOTHESE QUE LE DEPLACEMENT INITIAL EST NUL
        DO 106 IMOD = 1,NBMODE
          RETA(IMOD,1) = 0.D0
106    CONTINUE
        DO 107 IABS = 2,NBABS
          DO 108 IMOD = 1,NBMODE
            RETA(IMOD,IABS) = RETAP(IMOD,IABS)*(XABS(IABS)-XABS(IABS-1))
     &                            + RETA(IMOD,(IABS-1))
 108      CONTINUE
107     CONTINUE
      ENDIF
C
      IF (NOMCHA .EQ. 'ACCE') THEN
        DO 201 IABS = 1,NBABS
          DO 202 IMOD = 1,NBMODE
            RETA2P(IMOD,IABS) = RETA(IMOD,IABS)
 202      CONTINUE
201     CONTINUE
C ON FAIT L HYPOTHESE QUE VITESSE INITIALE EST NULLE
        DO 203 IMOD = 1,NBMODE
          RETAP(IMOD,1) = 0.D0
203    CONTINUE
        DO 204 IABS = 2,NBABS
          DO 205 IMOD = 1,NBMODE
            RETAP(IMOD,IABS)=RETA2P(IMOD,IABS)*(XABS(IABS)-XABS(IABS-1))
     &                            + RETAP(IMOD,(IABS-1))
 205      CONTINUE
204     CONTINUE
C ON FAIT L HYPOTHESE QUE DEPLACEMENT INITIAL EST NUL
        DO 206 IMOD = 1,NBMODE
          RETA(IMOD,1) = 0.D0
206    CONTINUE
        DO 207 IABS = 2,NBABS
          DO 208 IMOD = 1,NBMODE
            RETA(IMOD,IABS) = RETAP(IMOD,IABS)*(XABS(IABS)-XABS(IABS-1))
     &                            + RETA(IMOD,(IABS-1))
 208      CONTINUE
207     CONTINUE
      ENDIF
C
C DESTRUCTION DES VECTEURS DE TRAVAIL

      CALL JEDETR (SCDMBR)
      CALL JEDETR (WKS)
      CALL JEDETR (PHIPHT)
      CALL JEDETR (PHITPH)
      CALL JEDETR (MATSYS)
      CALL JEDETR (WORK)
      CALL JEDETR (ETA)
      CALL JEDETR (VALS)
      CALL JEDETR (U)
      CALL JEDETR (V)

      CALL JEDEMA ()
C
      END
