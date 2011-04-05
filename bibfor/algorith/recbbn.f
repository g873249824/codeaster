      SUBROUTINE RECBBN ( BASMOD, NBMOD, NBDDR, NBDAX, TETGD, IORD,
     +                    IORG, IORA, CMODE, VECMOD, NEQ, BETA )
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
      INTEGER       NBMOD, NBDDR, NBDAX, IORD(NBDDR), IORG(NBDDR),
     +              IORA(NBDAX), NEQ
      REAL*8        BETA
      COMPLEX*16    CMODE(NBMOD+NBDDR+NBDAX), VECMOD(NEQ)
      CHARACTER*8   BASMOD
      CHARACTER*24  TETGD
C-----------------------------------------------------------------------
C MODIF ALGORITH  DATE 15/01/2002   AUTEUR CIBHHLV L.VIVAN 
C
C  BUT:        < RESTITUTION CRAIG_BAMPTON BAS NIVEAU >
C
C    CALCUL DU VECTEUR COMPLEXE EN DDL PHYSIQUES A PARTIR DU MODE
C   COMPLEXE ISSU DU CALCUL CYCLIQUE ET DES VECTEURS DES NUMERO ORDRE
C  DES DEFORMEES RELATIVES AUX INTERFACES DROITE GAUCHE ET AXE DE TYPE
C   CRAIG-BAMPTON
C  AINSI QUE DE LA MATRICE TETGD
C
C-----------------------------------------------------------------------
C
C BASMOD   /I/: NOM UT DE LA BASE MODALE EN AMONT
C NBMOD    /I/: NOMBRE DE MODES PROPRES UTILISES POUR CALCUL CYCLIQUE
C NBDDR    /I/: NOMBRE DE DEFORMEES INTERFACE DROITE (ET GAUCHE)
C NBDAX    /I/: NOMBRE DE DEFORMEES INTERFACE AXE
C TETGD    /I/: NOM K24 DE MATRICE DE PASSAGE GAUCHE-DROITE
C IORD     /I/: VECTEUR DES NUMEROS ORDRE DEFORMEES DE DROITE
C IORG     /I/: VECTEUR DES NUMEROS ORDRE DES DEFORMEES DE GAUCHE
C IORA     /I/: VECTEUR DES NUMEROS ORDRE DES DEFORMEES  AXE
C CMODE    /I/: MODE COMPLEXES ISSU DU CALCUL CYCLIQUE
C VECMOD   /I/: VECTEUR MODAL COMPLEXE EN DDL PHYSIQUE
C NEQ      /I/: NOMBRE DE DDL PHYSIQUES ASSEMBLES
C BETA     /I/: DEPHASAGE INTER-SECTEUR
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
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER       I, J, IAD, LLCHAM, LLTGD
      REAL*8        ABETA, BBETA
      COMPLEX*16    DEPHC, CFACT, CMULT
      CHARACTER*24  CHAVAL
C
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- MISE A ZERO DU MODE PROPRES RESULTAT
C
      DO 10 I = 1,NEQ
        VECMOD(I) = DCMPLX( 0.D0,0.D0 )
 10   CONTINUE
C
      ABETA = COS(BETA)
      BBETA = SIN(BETA)
      DEPHC = DCMPLX( ABETA,BBETA )
C
C --- CONTRIBUTION DES MODES PROPRES
C
      DO 20 I = 1 , NBMOD
         CALL DCAPNO ( BASMOD, 'DEPL    ', I, CHAVAL )
         CALL JEVEUO ( CHAVAL, 'L', LLCHAM )
         DO 22 J = 1 , NEQ
            CFACT = DCMPLX( ZR(LLCHAM+J-1),0.D0 )
            VECMOD(J) = VECMOD(J) + CMODE(I)*CFACT
 22      CONTINUE
         CALL JELIBE ( CHAVAL )
 20   CONTINUE
C
C --- CONTRIBUTION DES DEFORMEES DE DROITE
C
      DO 30 I = 1, NBDDR
         CALL DCAPNO ( BASMOD, 'DEPL    ', IORD(I), CHAVAL )
         CALL JEVEUO ( CHAVAL, 'L', LLCHAM )
         DO 32 J = 1 , NEQ
            CFACT = DCMPLX( ZR(LLCHAM+J-1),0.D0 )
            VECMOD(J) = VECMOD(J) + CMODE(I+NBMOD)*CFACT
 32      CONTINUE
         CALL JELIBE ( CHAVAL )
 30   CONTINUE
C
C --- CONTRIBUTION DES DEFORMEES DE GAUCHE
C
      CALL JEVEUO ( TETGD , 'L', LLTGD )
C
      DO 40 I = 1 , NBDDR
         CALL DCAPNO ( BASMOD, 'DEPL    ', IORG(I), CHAVAL )
         CALL JEVEUO ( CHAVAL, 'L', LLCHAM )
C
         CMULT = DCMPLX( 0.D0,0.D0 )
         DO 42 J = 1 , NBDDR
            IAD   = LLTGD + ((J-1)*NBDDR) + I - 1
            CFACT = DCMPLX( ZR(IAD),0.D0 )*CMODE(J+NBMOD)
            CMULT = CMULT + CFACT
 42      CONTINUE
C
         DO 44 J = 1 , NEQ
            CFACT = DCMPLX( ZR(LLCHAM+J-1),0.D0 )
            VECMOD(J) = VECMOD(J) + DEPHC*CFACT*CMULT
 44      CONTINUE
C
         CALL JELIBE ( CHAVAL )
 40   CONTINUE
      CALL JELIBE ( TETGD  )
C
C --- EVENTUELLE CONTRIBUTION DE L'AXE
C
      IF ( NBDAX .GT. 0 ) THEN
         DO 50 I = 1 , NBDAX
            CALL DCAPNO ( BASMOD, 'DEPL    ', IORA(I), CHAVAL )
            CALL JEVEUO ( CHAVAL, 'L', LLCHAM )
            DO 52 J = 1 , NEQ
               CFACT = DCMPLX( 2*ZR(LLCHAM+J-1),0.D0 )
               VECMOD(J) = VECMOD(J) + CFACT*CMODE(I+NBMOD+NBDDR)
 52         CONTINUE
         CALL JELIBE ( CHAVAL )
 50      CONTINUE
      ENDIF
C
      CALL JEDEMA()
      END
