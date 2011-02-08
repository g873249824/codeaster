      FUNCTION JJPREM ( NOMBRE , IRET )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 08/02/2011   AUTEUR TARDIEU N.TARDIEU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER  JJPREM , NOMBRE , IRET
C     ==================================================================
      INTEGER          NPRE
      PARAMETER      ( NPRE = 281 )
      INTEGER          JPREM
      COMMON /JPREJE/  JPREM(NPRE)
C     ==================================================================
      REAL*8           PREM(NPRE) , FACT , R8NOMB
      SAVE             PREM
      PARAMETER      ( FACT = 1.3D0 )
      INTEGER          IPAS , I, IPREM, J, VALI(2)
      INTEGER          NPR1,NPR2,NPR3,NPR4
      PARAMETER      ( NPR1 = 81, NPR2 = 90, NPR3 = 90, NPR4 =  20)
      INTEGER          IPR1(NPR1),IPR2(NPR2),IPR3(NPR3),IPR4(NPR4)
C
      DATA IPAS /   0 /
      DATA IPR1/   11,         17,         23,         37,         53,
     &             71,         97,        127,        167,        223,
     &            293,        383,        499,        547,        647,
     &            757,        853,        941,       1031,       1109,
     &           1223,       1327,       1447,       1549,       1657,
     &           1759,       1889,       1987,       2459,       3203,
     &           4177,       5431,       6121,       7069,       8111,
     &           9199,      10271,      11959,      15551,      20219,
     &          26293,      34183,      44449,      57787,      66179,
     &          75133,      86113,      97673,     126989,     165089,
     &         214631,     279029,     362741,     471571,     540703,
     &         611957,    1000003,    1299827,    2015179,    5023309,
     &        5800139,   10000019,   12500003,   15000017,   17500013,
     &       20000003,   22500011,   25000009,   27500003,   30000001,
     &       32500001,   35000011,   37500007,   40000003,   42500023,
     &       45000017,   47500001,   50000017,   61500059,   70000027,
     &       80000023/
      DATA IPR2/         85000103,   90000121,   95000123,  100000123,
     &      105000121,  110000117,  115000099,  120000121,  125000089,
     &      130000099,  135000101,  140000099,  145000117,  150000113,
     &      155000107,  160000117,  165000119,  170000099,  175000109,
     &      180000113,  185000119,  190000103,  195000119,  200000123,
     &      205000079,  210000113,  215000117,  220000073,  225000107,
     &      230000117,  235000123,  240000113,  245000101,  250000123,
     &      255000113,  260000093,  265000117,  270000119,  275000113,
     &      280000109,  285000119,  290000107,  295000103,  300000119,
     &      305000123,  310000099,  315000121,  320000113,  325000121,
     &      330000109,  335000123,  340000081,  345000107,  350000113,
     &      355000073,  360000103,  365000113,  370000123,  375000121,
     &      380000087,  385000123,  390000103,  395000119,  400000109,
     &      405000053,  410000117,  415000097,  420000109,  425000101,
     &      430000099,  435000107,  440000107,  445000123,  450000121,
     &      455000123,  460000043,  465000079,  470000117,  475000067,
     &      480000121,  485000041,  490000117,  495000113,  500000117,
     &      505000123,  510000121,  515000089,  520000111,  525000107,
     &      530000101/
      DATA IPR3/        535000121,  540000119,  545000101,  550000103,
     &      555000109,  560000107,  565000109,  570000113,  575000123,
     &      580000217,  585000223,  590000221,  595000199,  600000217,
     &      605000191,  610000219,  615000209,  620000219,  625000171,
     &      630000193,  635000213,  640000223,  645000199,  650000209,
     &      655000211,  660000151,  665000213,  670000207,  675000217,
     &      680000203,  685000223,  690000211,  695000161,  700000207,
     &      705000203,  710000209,  715000219,  720000217,  725000191,
     &      730000199,  735000223,  740000179,  745000211,  750000221,
     &      755000143,  760000223,  765000199,  770000173,  775000211,
     &      780000223,  785000221,  790000219,  795000197,  800000209,
     &      805000223,  810000199,  815000201,  820000177,  825000217,
     &      830000219,  835000223,  840000223,  845000209,  850000219,
     &      855000221,  860000203,  865000219,  870000223,  875000197,
     &      880000211,  885000223,  890000149,  895000217,  900000223,
     &      905000189,  910000219,  915000223,  920000219,  925000217,
     &      930000191,  935000177,  940000199,  945000211,  950000179,
     &      955000213,  960000221,  965000173,  970000211,  975000211,
     &      980000213/
      DATA IPR4/        985000207,  990000217,  995000221, 1000000223,
     &     1005000223, 1010000207, 1015000211, 1020000217, 1025000191,
     &     1030000211, 1035000221, 1040000201, 1045000219, 1050000199,
     &     1055000183, 1060000217, 1065000187, 1070000221, 1300000003,
     &     2147483647/

C    Nom du site www.prime-numbers.org

C
C     ------------------------------------------------------------------
      ITER=0
      IRET = 0
      IF ( FACT * NOMBRE .GT. IPR4(NPR4) ) THEN
         VALI(1) = NINT(IPR4(NPR4)/FACT)
         VALI(2) = NOMBRE
         CALL U2MESI('F','JEVEUX_39',2,VALI)
      ENDIF
      IF ( IPAS .EQ. 0 ) THEN
         DO 1 I = 1 , NPR1
            JPREM(I) = IPR1(I)
            PREM (I) = IPR1(I)
    1    CONTINUE
         DO 2 I = 1 , NPR2
            JPREM(NPR1+I) = IPR2(I)
            PREM (NPR1+I) = IPR2(I)
    2    CONTINUE
         DO 3 I = 1 , NPR3
            JPREM(NPR1+NPR2+I) = IPR3(I)
            PREM (NPR1+NPR2+I) = IPR3(I)
    3    CONTINUE
         DO 4 I = 1 , NPR4
            JPREM(NPR1+NPR2+NPR3+I) = IPR4(I)
            PREM (NPR1+NPR2+NPR3+I) = IPR4(I)
    4    CONTINUE
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
           J = (J + 1) / 2
           I = MAX(I - J,1)
        ENDIF
        ITER=ITER+1
        IF ( J .GT. 1 ) GOTO 5
        IPREM = I
        IF ( R8NOMB .GT. PREM(I) ) THEN
          IPREM = IPREM + 1
        ENDIF
      ENDIF
      JJPREM = JPREM(IPREM)
      IF ( IPREM .EQ. NPRE ) IRET = 1

      END
