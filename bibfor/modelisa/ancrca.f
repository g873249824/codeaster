      SUBROUTINE ANCRCA(ICABL,NBNO,S,ALPHA,F0,DELTA,EA,FRCO,FRLI,SA,D,F)
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
C  -----------   COMPTE LES PERTES PAR RECUL DE L'ANCRAGE
C                APPELANT : TENSK1, TENSK2
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
C                    VALEUR DE LA TENSION APPLIQUEE A L'UN OU AUX DEUX
C                    ANCRAGES ACTIFS DU CABLE
C  IN     : DELTA  : REAL*8 , SCALAIRE
C                    VALEUR DU RECUL DE L'ANCRAGE
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
C  OUT    : D      : REAL*8 , SCALAIRE
C                    VALEUR DE LA LONGUEUR SUR LAQUELLE ON DOIT
C                    PRENDRE EN COMPTE LES PERTES DE TENSION
C                    PAR RECUL DE L'ANCRAGE
C  OUT    : F      : REAL*8 , VECTEUR DE DIMENSION NBNO
C                    CONTIENT LES VALEURS DE LA TENSION LE LONG DU CABLE
C                    APRES PRISE EN COMPTE DES PERTES PAR FROTTEMENT ET
C                    DES PERTES PAR RECUL DE L'ANCRAGE
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER       ICABL, NBNO
      REAL*8        S(*), ALPHA(*), F0, DELTA, EA, FRCO, FRLI, SA,
     &              D, F(*)
C
C VARIABLES LOCALES
C -----------------
      INTEGER       IINF, INO, ISUP
      REAL*8        ALPHAD, ALPHAI, ALPHAS, DF, DS, EPSW, F2, PENTE,
     &              WCR, WDEF, WINF, WSUP
      CHARACTER*3   K3B
C
      REAL*8        WDEFCA
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      IF ( DELTA.EQ.0.0D0 ) THEN
         D = 0.0D0
         GO TO 9999
      ENDIF
C
      EPSW = 1.0D-04
      WDEF = EA * SA * DELTA
      WCR = WDEFCA(NBNO,S,ALPHA,F0,FRCO,FRLI)
C
      IF ( WCR.LT.WDEF ) THEN
C
         WRITE(K3B,'(I3)') ICABL
         CALL UTMESS('A','ANCRCA','CALCUL DE LA TENSION LE LONG DU '//
     &               'CABLE NO'//K3B//' : LA LONGUEUR SUR LAQUELLE '//
     &               'ON DEVRAIT PRENDRE EN COMPTE LES PERTES DE '//
     &               'TENSION PAR RECUL DE L ANCRAGE EST SUPERIEURE '//
     &               'A LA LONGUEUR DU CABLE')
C
         D = S(NBNO)
         IF ( WCR/WDEF.LT.EPSW ) THEN
            DF = WDEF / D
            DO 10 INO = 1, NBNO
               F(INO) = F(INO) - DF
  10        CONTINUE
         ELSE
            DF = ( WDEF - WCR ) / D
            F2 = F(NBNO)
            F2 = F2 * F2
            DO 20 INO = 1, NBNO
               F(INO) = F2/F(INO) - DF
  20        CONTINUE
         ENDIF
C
      ELSE IF ( WCR.EQ.WDEF ) THEN
C
         WRITE(K3B,'(I3)') ICABL
         CALL UTMESS('A','ANCRCA','CALCUL DE LA TENSION LE LONG DU '//
     &               'CABLE NO'//K3B//' : LA LONGUEUR SUR LAQUELLE '//
     &               'ON DOIT PRENDRE EN COMPTE LES PERTES DE '//
     &               'TENSION PAR RECUL DE L ANCRAGE EST EGALE A LA '//
     &               'LONGUEUR DU CABLE')
C
         D = S(NBNO)
         F2 = F(NBNO)
         F2 = F2 * F2
         DO 30 INO = 1, NBNO
            F(INO) = F2/F(INO)
  30     CONTINUE
C
      ELSE
C
         IINF = 1
         ISUP = NBNO
  40     CONTINUE
         INO = (IINF+ISUP)/2
         IF ( WDEFCA(INO,S,ALPHA,F0,FRCO,FRLI).GT.WDEF ) THEN
            ISUP = INO
         ELSE
            IINF = INO
         ENDIF
         IF ( ISUP-IINF.GT.1 ) GO TO 40
C
         WINF = WDEFCA(IINF,S,ALPHA,F0,FRCO,FRLI)
         WSUP = WDEFCA(ISUP,S,ALPHA,F0,FRCO,FRLI)
         DS = S(ISUP) - S(IINF)
         PENTE = ( WSUP - WINF ) / DS
         D = S(IINF) + ( WDEF - WINF ) / PENTE
C
         ALPHAI = ALPHA(IINF)
         ALPHAS = ALPHA(ISUP)
         PENTE = ( ALPHAS - ALPHAI ) / DS
         ALPHAD = ALPHAI + PENTE * ( D - S(IINF) )
C
         F2 = F0 * DBLE ( EXP ( - FRCO * ALPHAD - FRLI * D ) )
         F2 = F2 * F2
         DO 50 INO = 1, IINF
            F(INO) = F2/F(INO)
  50     CONTINUE
C
      ENDIF
C
9999  CONTINUE
C
C --- FIN DE ANCRCA.
      END
