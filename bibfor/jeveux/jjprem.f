      FUNCTION JJPREM ( NOMBRE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 20/06/2002   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER  JJPREM , NOMBRE , IV
C     ==================================================================
      CHARACTER *6     PGME
      PARAMETER      ( PGME = 'JJPREM' )
      CHARACTER *75    CMESS
      INTEGER          NPRE
      PARAMETER      ( NPRE = 60 )
      INTEGER          JPREM
      COMMON /JPREJE/  JPREM(NPRE)
C     ==================================================================
      REAL*8           PREM(NPRE) , FACT , R8NOMB
      SAVE             PREM
      PARAMETER      ( FACT = 1.3D0 )
      INTEGER          IPAS , IPR(NPRE)
C
      DATA IPAS /   0 /
      DATA IPR/11,17,23,37,53,71,97,127,167,223,293,383,499,547,647,757
     &        ,853,941,1031,1109,1223,1327,1447,1549,1657,1759,1889,1987
     &        ,2459,3203,4177,5431,6121,7069,8111,9199,10271,11959,15551
     &        ,20219,26293,34183,44449,57787,66179,75133,86113,97673,
     &        126989,165089,214631,279029,362741,471571,540703,611957,
     &        1000003,1299827,2015179,5023309/
C     ------------------------------------------------------------------
      IF ( FACT * NOMBRE .GT. IPR(NPRE) ) THEN
         CMESS = 'TAILLE DE REPERTOIRE DEMANDEE TROP GRANDE'
         IV = IPR(NPRE)/FACT
         CALL JVDEBM ( 'S' , PGME//'01' , CMESS )
         CALL JVIMPI ( 'L' , 'LE MAXIMUM EST :' ,1, IV )
         CALL JVIMPI ( 'L' , 'LA VALEUR RECLAMEE EST :' ,1, NOMBRE )
         CALL JVFINM ()
      ENDIF
      IF ( IPAS .EQ. 0 ) THEN
         DO 1 I = 1 , NPRE
            JPREM(I) = IPR(I)
            PREM(I)  = IPR(I)
    1    CONTINUE
         IPAS = 1
      ENDIF
C
      R8NOMB  = FACT * NOMBRE
C
      I = NPRE / 2
      J = I
    5 CONTINUE
      IF ( R8NOMB .EQ. PREM(I) ) THEN
        IPREM = I
      ELSE
        IF ( R8NOMB .GT. PREM(I) ) THEN
           J = (J + 1) / 2
           I = MIN( I + J , NPRE)
        ELSE
           J = J / 2
           I = I - J
        ENDIF
        IF ( J .GT. 1 ) GOTO 5
        IPREM = I
        IF ( R8NOMB .GT. PREM(I) ) IPREM = IPREM + 1
      ENDIF
      JJPREM = JPREM(IPREM)
      END
