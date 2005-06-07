      SUBROUTINE COPCOS(NOMA,POSMA,XPG,YPG,NEWGEO,GEOM,DEFICO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/08/2002   AUTEUR ADBHHPM P.MASSIN 
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
      IMPLICIT NONE
      INTEGER POSMA
      REAL*8 GEOM(3),XPG,YPG
      CHARACTER*8 NOMA
      CHARACTER*24 NEWGEO,DEFICO
C.......................................................................

C BUT: CALCUL DES COORDONNEES D'UN POINT DE CONTACT

C ENTREES  ---> NOMA   : NOM DU MAILLAGE
C          ---> POSMA  : INDICE DE LA MAILLE DANS CONTAMA
C          ---> GAUSS   : GAUSS CLASSIQUE, SOMMETS OU POINT INTERNE
C          ---> NORD   : L'ORDRE DE PT DE GAUSSE
C          ---> NEWGEO : LA NOUVELLE GEOMETRIE
C  SUR LAQUELLE ON FAIT L'APPARIEME

C SORTIES  <--- GEOM(3)   : COORDONNEES DU POINT DU CONTACT (EN 2D Z=0)
C ...............................................................
C   DECLARATION JEVEUX
C.......................................................................

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

C.......................................................................
C FIN DECLARATION JEVEUX
C.......................................................................
      INTEGER JZONE,JNOCO,JMACO,JNOMA,JPONO,NUMA,IATYMA,JCOOR
      INTEGER NUTYP,ITYP,NNO,JDEC,INO,NO(9),POSNNO(9),I,J
      REAL*8 FF(9)
      REAL*8 COOR(27)
      CHARACTER*8 ALIAS
      CHARACTER*24 PZONE,CONTMA,CONTNO,NOMACO,PNOMA
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      PZONE  = DEFICO(1:16)//'.PZONECO'
      CONTMA = DEFICO(1:16)//'.MAILCO'
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      NOMACO = DEFICO(1:16)//'.NOMACO'
      PNOMA  = DEFICO(1:16)//'.PNOMACO'

      CALL JEVEUO(PZONE,'L',JZONE)
      CALL JEVEUO(CONTNO,'L',JNOCO)
      CALL JEVEUO(CONTMA,'L',JMACO)
      CALL JEVEUO(NOMACO,'L',JNOMA)
      CALL JEVEUO(PNOMA,'L',JPONO)
      NUMA = ZI(JMACO+POSMA-1)

C --- TYPE DE LA MAILLE MAITRE DE NUMERO ABSOLU NUMA
C     SEG2=2  SEG3=4  TRIA3=7  TRIA6=9  QUAD4=12 QUAD8=14  QUAD9=16

      CALL JEVEUO(NOMA//'.TYPMAIL','L',IATYMA)
      ITYP = IATYMA - 1 + NUMA
      NUTYP = ZI(ITYP)
      IF (NUTYP.EQ.2) THEN
        ALIAS(1:3) = 'SG2'
        NNO = 2
      ELSE IF (NUTYP.EQ.4) THEN
        ALIAS(1:3) = 'SG3'
        NNO = 3
      ELSE IF (NUTYP.EQ.7) THEN
        ALIAS(1:3) = 'TR3'
        NNO = 3
      ELSE IF (NUTYP.EQ.9) THEN
        ALIAS(1:3) = 'TR6'
        NNO = 6
      ELSE IF (NUTYP.EQ.12) THEN
        ALIAS(1:3) = 'QU4'
        NNO = 4
      ELSE IF (NUTYP.EQ.14) THEN
        ALIAS(1:3) = 'QU8'
        NNO = 8
      ELSE IF (NUTYP.EQ.16) THEN
        ALIAS(1:3) = 'QU9'
        NNO = 9
      ELSE
       CALL UTMESS('F','COPCO','STOP_1')
      END IF

C   RECUPERATION DE LA GEOMETRIE DES NOEUDS


      CALL JEVEUO(NEWGEO(1:19)//'.VALE','L',JCOOR)
      JDEC = ZI(JPONO+POSMA-1)
      DO 10 INO = 1,NNO
        POSNNO(INO+1) = ZI(JNOMA+JDEC+INO-1)
        NO(INO) = ZI(JNOCO+POSNNO(INO+1)-1)
   10 CONTINUE

C --- COORDONNEES DES NOEUDS DE LA MAILLE ESCLAVE

      DO 30 INO = 1,NNO
        COOR(3* (INO-1)+1) = ZR(JCOOR+3* (NO(INO)-1))
        COOR(3* (INO-1)+2) = ZR(JCOOR+3* (NO(INO)-1)+1)
        COOR(3* (INO-1)+3) = ZR(JCOOR+3* (NO(INO)-1)+2)
   30 CONTINUE

C---- GEOMETRIE DU PT DE CONTACT  ---------------

      DO 40 I=1,3
          GEOM(I)=0.D0
   40 CONTINUE
      CALL CALFFX(ALIAS,XPG,YPG,FF)
      DO 60 I = 1,3
        DO 50 J = 1,NNO
          GEOM(I) = FF(J)*COOR((J-1)*3+I) + GEOM(I)
   50   CONTINUE
   60 CONTINUE
      CALL JEDEMA()
      END
