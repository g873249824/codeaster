        SUBROUTINE FGPIC2( METHOD,RTRV,POINT,NPOINT,PIC,NPIC)
C       ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 21/11/2005   AUTEUR F1BHHAJ J.ANGLES 
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
C       ----------------------------------------------------------------
C       REARRANGEMENT ET EXTRACTION DES PICS
C       ----------------------------------------------------------------
C       IN  POINT VECTEUR DES POINTS
C           NPOINT NOMBRE DE POINTS
C           RTRV VECTEUR DE TRAVAIL REEL
C           METHOD METHODE DE DEXTRACTION DES PICS EMPLOYEE
C       OUT PIC VECTEUR DES PICS
C           NPIC NOMBRE DE PICS (NPIC = NPOINT AU MAXIMUM)
C       ----------------------------------------------------------------

      IMPLICIT       NONE
      INTEGER        I, NPOINT, NPIC, NMAX, NTRV
      REAL*8         POINT(*), PIC(*), RTRV(*), PMAX, PINTER
      REAL*8         DP1, DP2, EPSI
      CHARACTER*(*)  METHOD
      CHARACTER*16   K16B

      EPSI = 1.0D-6

C     ----------------------------------------------------------------
C -   EXTRACTION DES PICS POUR RAINFLOW=PIC LE PLUS GRAND EN DEBUT
C     ----------------------------------------------------------------
      IF ( METHOD.EQ.'RAINFLOW' ) THEN

C -     RECHERCHE DU POINT LE PLUS GRAND EN VALEUR ABSOLUE

         PMAX = ABS(POINT(1))
         NMAX = 1
         DO 10 I = 2 , NPOINT
            IF(ABS(POINT(I)).GT.PMAX*(1.0D0+EPSI))THEN
               PMAX = ABS(POINT(I))
               NMAX = I
            ENDIF
 10      CONTINUE
         PMAX = POINT(NMAX)

C -     REARANGEMENT AVEC POINT LE PLUS GRAND AU DEBUT ET A LA FIN

         DO 20 I=NMAX, NPOINT
            RTRV(I-NMAX+1) = POINT(I)
 20      CONTINUE
         DO 30 I=1, NMAX-1
            RTRV(NPOINT-NMAX+1+I) = POINT(I)
 30      CONTINUE
         NTRV = NPOINT

C -     EXTRACTION DES PICS SUR LE VECTEUR REARANGE

C -      LE PREMIER POINT EST UN PIC
         NPIC   = 1
         PIC(1) = RTRV(1)
         PINTER = RTRV(2)

C -     ON RECHERCHE TOUS LES PICS
         DO 40 I=3, NTRV
            DP1 = PINTER  - PIC(NPIC)
            DP2 = RTRV(I) - PINTER

C -         ON CONSERVE LE POINT INTERMEDIAIRE COMME UN PIC
            IF( DP2*DP1 .LT.  0.D0 )  THEN
               NPIC = NPIC+1
               PIC(NPIC) = PINTER
            ENDIF

C -         LE DERNIER POINT DEVIENT POINT INTERMEDIAIRE
            PINTER = RTRV(I)
 40      CONTINUE

C -      LE DERNIER POINT EST UN PIC
         NPIC = NPIC+1
         PIC(NPIC) = RTRV(NTRV)
      ELSE
         K16B = METHOD(1:16)
         CALL UTMESS('F','FGPIC2','METHODE '//K16B//' ILLICITE')
      ENDIF

      END
