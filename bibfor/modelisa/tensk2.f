      SUBROUTINE TENSK2(ICABL,NBNO,S,ALPHA,F0,DELTA,EA,FRCO,FRLI,SA,F)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/05/98   AUTEUR H1BAXBG M.LAINET 
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
C-----------------------------------------------------------------------
C  DESCRIPTION : CALCUL DE LA TENSION LE LONG D'UN CABLE EN PRENANT EN
C  -----------   COMPTE LES PERTES PAR FROTTEMENT ET LES PERTES PAR
C                RECUL DES ANCRAGES
C                CAS DE DEUX ANCRAGES ACTIFS
C                APPELANT : TENSCA
C
C  IN     : ICABL  : INTEGER , SCALAIRE
C                    NUMERO DU CABLE
C  IN     : NBNO   : INTEGER , SCALAIRE
C                    NOMBRE DE NOEUDS DU CABLE
C  IN     : S      : REAL*8 , VECTEUR DE DIMENSION NBNO
C                    CONTIENT LES VALEURS DE L'ABSCISSE CURVILIGNE
C                    LE LONG DU CABLE
C  IN     : ALPHA  : REAL*8 , VECTEUR DE DIMENSION NBNO
C                    CONTIENT LES VALEURS DE LA DEVIATION ANGULAIRE
C                    CUMULEE LE LONG DU CABLE
C  IN     : F0     : REAL*8 , SCALAIRE
C                    VALEUR DE LA TENSION APPLIQUEE AUX DEUX ANCRAGES
C                    ACTIFS DU CABLE
C  IN     : DELTA  : REAL*8 , SCALAIRE
C                    VALEUR DU RECUL DES DEUX ANCRAGES
C  IN     : EA     : REAL*8 , SCALAIRE
C                    VALEUR DU MODULE D'YOUNG DE L'ACIER
C  IN     : FRCO   : REAL*8 , SCALAIRE
C                    VALEUR DU COEFFICIENT DE FROTTEMENT EN COURBE
C                    (CONTACT ENTRE LE CABLE ACIER ET LE MASSIF BETON)
C  IN     : FRLI   : REAL*8 , SCALAIRE
C                    VALEUR DU COEFFICIENT DE FROTTEMENT EN LIGNE
C                    (CONTACT ENTRE LE CABLE ACIER ET LE MASSIF BETON)
C  IN     : SA     : REAL*8 , SCALAIRE
C                    VALEUR DE L'AIRE DE LA SECTION DROITE DU CABLE
C  OUT    : F      : REAL*8 , VECTEUR DE DIMENSION NBNO
C                    CONTIENT LES VALEURS DE LA TENSION LE LONG DU CABLE
C                    APRES PRISE EN COMPTE DES PERTES PAR FROTTEMENT ET
C                    DES PERTES PAR RECUL DES DEUX ANCRAGES
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
      CHARACTER*32 JEXNOM, JEXNUM, JEXATR
C     ----- FIN   COMMUNS NORMALISES  JEVEUX  --------------------------
C
C ARGUMENTS
C ---------
      INTEGER       ICABL, NBNO
      REAL*8        S(*), ALPHA(*), F0, DELTA, EA, FRCO, FRLI, SA, F(*)
C
C VARIABLES LOCALES
C -----------------
      INTEGER       INO, JABSC2, JALPH2, JF1, JF2, JFMAX
      REAL*8        ALPHAL, D1, D2, DF, LONG, WCR
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      CALL JEMARQ()
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 1   CREATION DES OBJETS DE TRAVAIL
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      CALL WKVECT('&&TENSK2.ABSC2' ,'V V R',NBNO,JABSC2)
      CALL WKVECT('&&TENSK2.ALPHA2','V V R',NBNO,JALPH2)
      CALL WKVECT('&&TENSK2.F1'    ,'V V R',NBNO,JF1   )
      CALL WKVECT('&&TENSK2.F2'    ,'V V R',NBNO,JF2   )
      CALL WKVECT('&&TENSK2.FMAX'  ,'V V R',NBNO,JFMAX )
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 2   CREATION DES DISCRETISATIONS DE L'ABSCISSE CURVILIGNE ET DE LA
C     DEVIATION ANGULAIRE CUMULEE CORRESPONDANT AU SENS DE PARCOURS
C     INVERSE LE LONG DU CABLE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      LONG = S(NBNO)
      ZR(JABSC2) = 0.0D0
      DO 10 INO = 2, NBNO
         ZR(JABSC2+INO-1) = LONG - S(NBNO-INO+1)
  10  CONTINUE
C
      ALPHAL = ALPHA(NBNO)
      ZR(JALPH2) = 0.0D0
      DO 20 INO = 2, NBNO
         ZR(JALPH2+INO-1) = ALPHAL - ALPHA(NBNO-INO+1)
  20  CONTINUE
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 3   PRISE EN COMPTE DES PERTES DE TENSION PAR FROTTEMENT
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C 3.1 TENSION APPLIQUEE AU PREMIER ANCRAGE ACTIF
C ---
      DO 30 INO = 1, NBNO
         ZR(JF1+INO-1) = F0 * DBLE(EXP(-FRCO*ALPHA(INO)-FRLI*S(INO)))
  30  CONTINUE
C
C 3.2 TENSION APPLIQUEE AU SECOND ANCRAGE ACTIF
C ---
      DO 40 INO = 1, NBNO
         ZR(JF2+INO-1) = F0 * DBLE ( EXP ( -FRCO*ZR(JALPH2+INO-1)
     &                                     -FRLI*ZR(JABSC2+INO-1) ) )
  40  CONTINUE
C
C 3.3 VALEUR MAXIMALE INDUITE PAR LES TENSIONS APPLIQUEES AUX DEUX
C --- ANCRAGES ACTIFS APRES PRISE EN COMPTE DES PERTES PAR FROTTEMENT
C
      DO 50 INO = 1, NBNO
         ZR(JFMAX+INO-1) = DBLE(MAX(ZR(JF1+INO-1),ZR(JF2+NBNO-INO)))
  50  CONTINUE
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 4   PRISE EN COMPTE DES PERTES DE TENSION PAR RECUL DES DEUX ANCRAGES
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
C 4.1 TENSION APPLIQUEE AU PREMIER ANCRAGE ACTIF
C ---
      CALL ANCRCA(ICABL,NBNO,S,ALPHA,
     &            F0,DELTA,EA,FRCO,FRLI,SA,D1,ZR(JF1))
C
C 4.2 TENSION APPLIQUEE AU SECOND ANCRAGE ACTIF
C ---
      CALL ANCRCA(ICABL,NBNO,ZR(JABSC2),ZR(JALPH2),
     &            F0,DELTA,EA,FRCO,FRLI,SA,D2,ZR(JF2))
C
C 4.3 VALEUR MAXIMALE INDUITE PAR LES TENSIONS APPLIQUEES AUX DEUX
C --- ANCRAGES ACTIFS APRES PRISE EN COMPTE DES PERTES PAR RECUL
C     DES DEUX ANCRAGES
C
      DO 60 INO = 1, NBNO
         F(INO) = DBLE ( MAX ( ZR(JF1+INO-1) , ZR(JF2+NBNO-INO) ) )
  60  CONTINUE
C
C 4.4 CORRECTION SI RECOUVREMENT DES LONGUEURS D'APPLICATION DES PERTES
C --- DE TENSION PAR RECUL DES DEUX ANCRAGES
C
      IF ( D1+D2.GT.LONG ) THEN
         WCR = 0.0D0
         DO 70 INO = 1, NBNO-1
            WCR = WCR + ( ( ZR(JFMAX+INO-1) - F(INO) )
     &                  + ( ZR(JFMAX+INO) - F(INO+1) ) )
     &                * ( S(INO+1) - S(INO) ) / 2.0D0
  70     CONTINUE
         DF = ( EA * SA * 2.0D0 * DELTA - WCR ) / LONG
         DO 80 INO = 1, NBNO
            F(INO) = F(INO) - DF
  80     CONTINUE
      ENDIF
C
      CALL JEDETC('V','&&TENSK2',1)
      CALL JEDEMA()
C
C --- FIN DE TENSK2.
      END
