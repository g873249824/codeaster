      SUBROUTINE IRGNT2 ( IFI, NBORDR, COORD, CONNEX, POINT, NOCMP, 
     +                    NJVTRI, NBTRI, CNSC, CNSL, CNSV, CNSD )
      IMPLICIT NONE
C
      INTEGER        NBTRI, IFI, NBORDR, CONNEX(*), POINT(*),
     +               CNSC(*), CNSL(*), CNSV(*), CNSD(*)
      REAL*8         COORD(*)
      CHARACTER*8    NOCMP
      CHARACTER*(*)  NJVTRI
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 05/02/2002   AUTEUR JMBHH01 J.M.PROIX 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C
C     IMPRESSION D'UN CHAM_NO AU FORMAT GMSH :
C     ELEMENT : TRIA3
C     CHAMP   : SCALAIRE POUR LA COMPOSANTE NOCMP
C
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                     ZK24
      CHARACTER*32                              ZK32
      CHARACTER*80                                       ZK80
      COMMON /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER      ITRI, IMA, IPOIN, LISTNO(3), J, JCNSC, JCNSL, JCNSV,
     +             JCNSD, NCMP, K, JTRI, IOR, INOE
      REAL*8       VALE
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL JEVEUO ( NJVTRI, 'L', JTRI )
C
      DO 10 ITRI = 1 , NBTRI

         IMA = ZI(JTRI-1+ITRI)

         IPOIN = POINT(IMA)

         LISTNO(1) = CONNEX(IPOIN  )
         LISTNO(2) = CONNEX(IPOIN+1)
         LISTNO(3) = CONNEX(IPOIN+2)

         DO 12 J = 1 , 3          
            WRITE(IFI,1000) (COORD(3*(LISTNO(INOE)-1)+J),INOE=1,3)
 12      CONTINUE
C
         DO 14 IOR = 1 , NBORDR

            JCNSC = CNSC(IOR)
            JCNSL = CNSL(IOR)
            JCNSV = CNSV(IOR)
            JCNSD = CNSD(IOR)
            NCMP  = ZI(JCNSD-1+2)        

            DO 16 INOE = 1 , 3

               VALE = 0.D0

               DO 18 K = 1 , NCMP

                  IF ( ZK8(JCNSC-1+K) .EQ. NOCMP ) THEN
                     IF (ZL(JCNSL-1+(LISTNO(INOE)-1)*NCMP+K)) THEN
                        VALE = ZR(JCNSV-1+(LISTNO(INOE)-1)*NCMP+K)
                        GOTO 20
                     ENDIF
                  ENDIF

 18            CONTINUE
 20            CONTINUE

               WRITE(IFI,1000) VALE

 16         CONTINUE

 14      CONTINUE
                 
 10   CONTINUE
C
      CALL JELIBE ( NJVTRI )
C
      CALL JEDEMA()
C
 1000 FORMAT(1P,3(E15.8,1X))
C
      END
