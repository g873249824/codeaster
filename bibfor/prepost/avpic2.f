      SUBROUTINE AVPIC2(METHOD, NBVEC, NBORDR, RTRV, ITRV, NPOIN,
     &                  VALPOI, VALORD, NPIC, PIC, ORDPIC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 21/11/2005   AUTEUR F1BHHAJ J.ANGLES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE F1BHHAJ J.ANGLES
      IMPLICIT      NONE
      INTEGER       NBVEC, NBORDR, NPOIN(NBVEC), VALORD(NBVEC*NBORDR)
      INTEGER       NPIC(NBVEC), ORDPIC(NBVEC*(NBORDR+2))
      INTEGER       ITRV(2*(NBORDR+2))
      REAL*8        RTRV(NBORDR+2), VALPOI(NBVEC*NBORDR)
      REAL*8        PIC(NBVEC*(NBORDR+2))
      CHARACTER*8  METHOD
C ----------------------------------------------------------------------
C BUT: EXTRACTION DES PICS POUR RAINFLOW <=> REARANGEMENT DES PICS,
C      PIC LE PLUS GRAND AU DEBUT ET A LA FIN.
C ----------------------------------------------------------------------
C ARGUMENTS:
C METHOD    IN   K  : METHODE D'EXTRACTION DES PICS, PAR EXEMPLE :
C                     RAINFLOW.
C NBVEC     IN   I  : NOMBRE DE VECTEURS NORMAUX.
C NBORDR    IN   I  : NOMBRE DE NUMERO D'ORDRE.
C RTRV      IN   R  : VECTEUR DE TRAVAIL REEL (POUR LES POINTS)
C ITRV      IN   I  : VECTEUR DE TRAVAIL ENTIER (POUR LES NUME_ORDRE)
C NPOIN     IN   I  : NOMBRE DE PICS DETECTES POUR TOUS LES VECTEURS
C                     NORMAUX.
C VALPOI    IN   R  : VALEUR DES PICS DETECTES POUR TOUS LES VECTEURS
C                     NORMAUX.
C VALORD    IN   I  : NUMEROS D'ORDRE ASSOCIES AUX PICS DETECTES POUR
C                     TOUS LES VECTEURS NORMAUX.
C NPIC      OUT  I  : NOMBRE DE PICS DETECTES POUR TOUS LES VECTEURS
C                     NORMAUX APRES REARANGEMENT DES PICS.
C PIC       OUT  R  : VALEUR DES PICS DETECTES POUR TOUS LES VECTEURS
C                     NORMAUX APRES REARANGEMENT DES PICS.
C ORDPIC    OUT  I  : NUMEROS D'ORDRE ASSOCIES AUX PICS DETECTES POUR
C                     TOUS LES VECTEURS NORMAUX APRES REARANGEMENT
C                     DES PICS.
C
C-----------------------------------------------------------------------
C---- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*32 ZK32,JEXNOM,JEXNUM,JEXATR
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ------------------------------------------------------------------
      INTEGER       IVECT, ADRS, I, NMAX, NTRV, OINTER
      REAL*8        EPSILO, PMAX, PINTER, DP1, DP2
      CHARACTER*8   K8B
C-----------------------------------------------------------------------
C234567                                                              012
C-----------------------------------------------------------------------
      EPSILO = 1.0D-7
C-----------------------------------------------------------------------

      CALL JEMARQ()

      IF (METHOD .NE. 'RAINFLOW') THEN
          K8B = METHOD(1:8)
          CALL UTMESS('F','AVPIC2','METHODE '//K8B//' ILLICITE')
      ENDIF

      DO 10 IVECT=1, NBVEC

C LE TEST SI (NPOIN(IVECT) .EQ. 0) EST EQUIVALENT
C AU TEST SI (IFLAG(IVECT) .EQ. 3).
         IF (NPOIN(IVECT) .EQ. 0) THEN
            GOTO 10
         ENDIF

C ----- RECHERCHE DU POINT LE PLUS GRAND EN VALEUR ABSOLUE -----

         CALL ASSERT(NBORDR .GE. NPOIN(IVECT))
         ADRS = (IVECT-1)*(NBORDR+2)

         PMAX = ABS(VALPOI((IVECT-1)*NBORDR + 1))
         NMAX = 1
         DO 20 I=2, NPOIN(IVECT)
            IF ( ABS(VALPOI((IVECT-1)*NBORDR + I)) .GT. 
     &           PMAX*(1.0D0+EPSILO) ) THEN
               PMAX = ABS(VALPOI((IVECT-1)*NBORDR + I))
               NMAX = I
            ENDIF
 20      CONTINUE
         PMAX = VALPOI((IVECT-1)*NBORDR + NMAX)
         NTRV = NPOIN(IVECT)

C ----- REARANGEMENT AVEC POINT LE PLUS GRAND AU DEBUT
C       ET A LA FIN                                    -----

         DO 30 I=NMAX, NPOIN(IVECT)
            RTRV(I-NMAX+1) = VALPOI((IVECT-1)*NBORDR + I)
            ITRV(I-NMAX+1) = VALORD((IVECT-1)*NBORDR + I)
 30      CONTINUE
         DO 40 I=1, NMAX-1
            RTRV(NPOIN(IVECT)+I-NMAX+1) = VALPOI((IVECT-1)*NBORDR + I)
            ITRV(NPOIN(IVECT)+I-NMAX+1) = VALORD((IVECT-1)*NBORDR + I)
 40      CONTINUE

C ----- EXTRACTION DES PICS SUR LE VECTEUR REARANGE -----

C 1. LE PREMIER POINT EST UN PIC

         NPIC(IVECT) = 1
         PIC(ADRS + 1) = RTRV(1)
         PINTER = RTRV(2)
         ORDPIC(ADRS + 1) = ITRV(1)
         OINTER = ITRV(2)

C 2. RECHERCHE DE TOUS LES PICS

         DO 50 I=3, NTRV
            DP1 = PINTER - PIC(ADRS + NPIC(IVECT))
            DP2 = RTRV(I) - PINTER

C 2.1 ON CONSERVE LE POINT INTERMEDIAIRE COMME UN PIC

            IF ( DP1*DP2 .LT. -EPSILO ) THEN
               NPIC(IVECT) = NPIC(IVECT) + 1
               PIC(ADRS + NPIC(IVECT)) = PINTER
               ORDPIC(ADRS + NPIC(IVECT)) = OINTER
            ENDIF

C 2.2 LE DERNIER POINT DEVIENT POINT INTERMEDIAIRE

            PINTER = RTRV(I)
            OINTER = ITRV(I)
 50      CONTINUE

C 3. LE DERNIER POINT EST UN PIC

         NPIC(IVECT) = NPIC(IVECT) + 1
         PIC(ADRS + NPIC(IVECT)) = RTRV(NTRV)
         ORDPIC(ADRS + NPIC(IVECT)) = ITRV(NTRV)

 10   CONTINUE

      CALL JEDEMA()

      END
