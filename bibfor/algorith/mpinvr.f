      SUBROUTINE MPINVR ( NBMESU,NBMODE,NBABS, 
     &                    PHI,RMESU,COEF,XABS, 
     &                    LFONCT,RETA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/02/2005   AUTEUR NICOLAS O.NICOLAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C     PROJ_MESU_MODAL : RESOLUTION DU SYSTEME PAR SVD OU PAR LU
C                       (DONNEES FREQUENTIELLES REELLES)
C
C     IN  : NBMESU : NOMBRE DE MESURE
C     IN  : NBMODE : NOMBRE DE MODES 
C     IN  : NBABS  : NOMBRE D ABSCISSES
C     IN  : PHI    : BASE DE PROJECTION
C     IN  : RMESU  : VALEURS MESUREES
C     IN  : COEF   : COEFFICIENTS DE PONDERATION
C     IN  : XABS   : LISTE REELLE D ABSCISSES
C     IN  : LFONCT : .TRUE. SI COEFFICIENTS DE PONDERATION 
C                    DEPENDENT DE LA FREQUENCE
C     OUT : RETA   : DEPLACEMENT GENERALISE   ( MATRICE )
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
      INTEGER       NBMESU,NBMODE,NBABS
      REAL*8        PHI(NBMESU,NBMODE),XABS(NBABS),COEF(*)
      REAL*8        RMESU(NBMESU,NBABS),RETA(NBMODE,NBABS)
      LOGICAL       LFONCT

      INTEGER       IMOD,JMOD,IMES,IABS,IERR,IBID,JMES
      INTEGER LSECMB,LWKS,LPHIPH,LPHITP,LMATSY,LWORK,LETA,LVALS,LU,LV
      REAL*8        ALPHA,R8PREM,EPS
      REAL*8        RVAL,CVAL
      LOGICAL       NUL
      CHARACTER*3   METHOD
      CHARACTER*6   NOMROU
      CHARACTER*8   REGUL
      CHARACTER*16  NOMCMD,NOMCHA
      CHARACTER*16  SECMB,WKS,PHIPHT,PHITPH,MATSYS,WORK,ETA,VALS,U,V
C
      DATA NOMCMD/'PROJ_MESU_MODAL'/
      DATA NOMROU/'MPINVR'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()

C CREATION DES VECTEURS DE TRAVAIL
      SECMB = '&SECMB'
      WKS = '&WKS'
      PHIPHT = '&PHIPHT'
      PHITPH = '&PHITPH'
      MATSYS = '&MATSYS'
      WORK = '&WORK'
      ETA = '&ETA'
      VALS = '&VALS'
      U = '&U'
      V = '&V'

      CALL WKVECT(SECMB,'V V R',NBMODE,LSECMB)
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
      CALL GETVTX ('RESOLUTION','METHODE',1,1,1,METHOD,IBID)
      IF (IBID .EQ. 0) METHOD = 'LU'

      IF (METHOD .EQ. 'SVD') THEN
        CALL GETVR8 ('RESOLUTION','EPS',1,1,1,EPS,IBID)
        IF (IBID .EQ. 0) EPS = 0.D0
      END IF

C REGULARISATION : NON / NORM_MIN / TIK_RELA
      CALL GETVTX ('RESOLUTION','REGUL',1,1,1,REGUL,IBID)
      IF (IBID .EQ. 0) REGUL = 'NON'

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
C DEBUT DE LA BOUCLE SUR LES ABSCISSES (FREQUENCE)
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
              CALL UTDEBM ('F',NOMROU,'AU MOINS UN TERME DE ALPHA '//
     &             'EST NEGATIF ')
              CALL UTIMPI ('S','A L''ABSCISSE : ',1,IABS)
              CALL UTFINM
            ELSE IF (ALPHA .GT. R8PREM()) THEN
              NUL=.FALSE.
          ENDIF
C
C DETERMINATION DE LA MATRICE A INVERSER :
C MATSYS(IABS) = PHI_T*PHI + ALPHA(IABS)
C ****************************************
          DO 80 JMOD = 1,NBMODE
            ZR(LMATSY-1 +IMOD+NBMODE*(JMOD-1)) = 
     &                 ZR(LPHITP-1 +IMOD+NBMODE*(JMOD-1))
 80       CONTINUE
C
          ZR(LMATSY-1 +IMOD+NBMODE*(IMOD-1)) = 
     &                 ZR(LMATSY-1 +IMOD+NBMODE*(IMOD-1)) + ALPHA
C
C DETERMINATION DU SECOND MEMBRE :
C SCDMB(IABS) = PHI_T*Q + ALPHA(IABS)*RETA(IABS-1)
C RQ : A IABS=1, RETA(0)=0 (LA SOLUTION A PRIORI EST NULLE)
C ********************************************************
          ZR(LSECMB-1 +IMOD) = 0.D0
C
          DO 70 IMES = 1,NBMESU
            CVAL = RMESU(IMES,IABS)
            ZR(LSECMB-1 +IMOD) = ZR(LSECMB-1 +IMOD)
     &                          +PHI(IMES,IMOD)*CVAL
 70       CONTINUE
C
          IF ((REGUL .EQ. 'TIK_RELA') .AND. (IABS .GT. 1)) THEN
            CVAL = RETA(IMOD,IABS-1)
            ZR(LSECMB-1 +IMOD) = ZR(LSECMB-1 +IMOD)+ALPHA*CVAL
          ENDIF
C
C FIN DE LA BOUCLE SUR LES MODES
C ******************************
 90     CONTINUE


C RESOLUTION DU SYSTEME : 
C MATSYS(IABS) * ETA(IABS) = SCDMB(IABS)
C **************************************
C       -> ALARME SI ALPHA NUL ET NBMESU<NBMODE : MOINDRE NORME
        IF ((NBMESU .LT. NBMODE) .AND. (NUL)) THEN
          CALL UTDEBM ('A',NOMROU,'ALPHA EST NUL ET '//
     &         'LE NOMBRE DE MESURES EST STRICTEMENT INFERIEUR '//
     &         'AU NOMBRE DE MODES : RISQUE DE MATRICE SINGULIERE')
          CALL UTFINM

          IF (REGUL .EQ. 'NON') THEN
C CALCUL MOINDRE NORME
            CALL UTDEBM('A',NOMROU,'CALCUL MOINDRE NORME ')
            CALL UTFINM
            DO 71 IMES = 1,NBMESU
              CVAL = RMESU(IMES,IABS)
              ZR(LSECMB-1 +IMES) =  CVAL
              DO 77 JMES = 1,NBMESU
                ZR(LMATSY-1 +IMES+NBMODE*(JMES-1)) = 
     &                     ZR(LPHIPH-1 +IMES+NBMESU*(JMES-1))
 77           CONTINUE
 71         CONTINUE
C
C CHOIX POUR LA METHODE D INVERSION
            IF (METHOD .EQ. 'SVD') THEN
C METHODE SVD
C CREATION DU VECTEUR SECOND MEMBRE
              DO 75 JMES = 1,NBMESU
                ZR(LETA-1 +JMES) = ZR(LSECMB-1 +JMES)
 75           CONTINUE
C
              CALL RSLSVD (NBMODE, NBMESU, NBMESU,ZR(LMATSY),ZR(LVALS),
     &                   ZR(LU),ZR(LV),1,ZR(LETA),EPS,IERR,ZR(LWORK) )
              IF ( IERR . NE. 0 ) THEN
                CALL UTDEBM('F',NOMCMD,'PB CALCUL VALEURS SINGULIERES')
                CALL UTIMPI('S', ' PAS =  ',1, IABS )
                CALL UTIMPR('S', ' ABSCISSE =   ',1, XABS ( IABS ) )
                CALL UTFINM
              END IF
C
            ELSE
C METHODE DE CROUT
              CALL MTCROG (ZR(LMATSY), ZR(LSECMB), NBMODE, NBMESU, 1,
     &                           ZR(LETA), ZR(LWKS), IERR)
              IF ( IERR . NE. 0 ) THEN
                CALL UTDEBM('F',NOMCMD,' MATRICE (PHI)T*PHI + ALPHA '//
     &             'N EST PAS INVERSIBLE ' )
                CALL UTIMPI('S', ' PAS =  ',1, IABS )
                CALL UTIMPR('S', ' ABSCISSE =   ',1, XABS ( IABS ) )
                CALL UTFINM
              END IF
            END IF
C
C COPIE DES RESULTATS DANS RETA
            DO 76 JMOD = 1,NBMODE
              DO 74 JMES = 1,NBMESU
                RETA(JMOD,IABS) = PHI(JMES,JMOD)*ZR(LETA-1 +JMES)
 74           CONTINUE
 76         CONTINUE
C
            GO TO 100
          END IF
        END IF
C FIN CALCUL MOINDRE NORME

C
C RESOLUTION EN FONCTION DE LA METHODE DE RESOLUTION
        IF (METHOD .EQ. 'SVD') THEN
C METHODE SVD
C CREATION DU VECTEUR SECOND MEMBRE
          DO 81 JMOD = 1,NBMODE
             ZR(LETA-1 +JMOD) = ZR(LSECMB-1 +JMOD)
 81       CONTINUE
C
          CALL RSLSVD ( NBMODE, NBMODE, NBMODE, ZR(LMATSY), ZR(LVALS), 
     &                  ZR(LU),ZR(LV),1,ZR(LETA),EPS,IERR,ZR(LWORK) )
          IF ( IERR . NE. 0 ) THEN
            CALL UTDEBM('F', NOMCMD , ' PB CALCUL VALEURS SINGULIERES')
            CALL UTIMPI('S', ' PAS =  ',1, IABS )
            CALL UTIMPR('S', ' ABSCISSE =   ',1, XABS ( IABS ) )
            CALL UTFINM
          END IF
C
        ELSE
C METHODE DE CROUT
          CALL MTCROG ( ZR(LMATSY), ZR(LSECMB), NBMODE, NBMODE, 1,
     &                           ZR(LETA), ZR(LWKS), IERR )
          IF ( IERR . NE. 0 ) THEN
            CALL UTDEBM('F', NOMCMD , ' MATRICE (PHI)T*PHI + ALPHA ' //
     &         'N EST PAS INVERSIBLE ' )
            CALL UTIMPI('S', ' PAS =  ',1, IABS )
            CALL UTIMPR('S', ' ABSCISSE =   ',1, XABS ( IABS ) )
            CALL UTFINM
          END IF
        END IF
C
C RECUPERATION DES RESULTATS
        DO 73 JMOD = 1,NBMODE
          RETA(JMOD,IABS)=ZR(LETA-1+JMOD)
 73     CONTINUE
C
C FIN DE LA BOUCLE SUR LES ABSCISSES (FREQUENCE)
C ***************************
100   CONTINUE

C
C DESTRUCTION DES VECTEURS DE TRAVAIL

      CALL JEDETR (SECMB)
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
      END
