      SUBROUTINE TE0573(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2002   AUTEUR VABHHTS J.PELLET 
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
C.......................................................................
C
C     BUT: CALCUL DES RIGIDITES ELEMENTAIRES EN MECANIQUE
C          CORRESPONDANT A UN CHARGEMENT EN PRESSION SUIVEUSE
C          SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 2D
C
C          OPTION : 'RIGI_MECA_PRSU_R '
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      IMPLICIT NONE
      LOGICAL       AXI
      CHARACTER*8   ELREFE
      CHARACTER*16  NOMTE,OPTION
      CHARACTER*24  CHVAL,CHCTE,CHTRAV
      INTEGER       DIMGEO,NNO,NPG
      INTEGER       JIN,JVAL,JTRAV
      INTEGER       IPOIDS,IVF,IDF,IGEOM,IPRES,IMAT
      INTEGER       IDEPM,IDEPP
      INTEGER       KPG,KDEC,N,I,J,KK,COTE
      REAL*8        PR(2,4),RBID(6),MATNS(0:35)

C
C
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      COMMON /NOMAJE/PGC
      CHARACTER*6 PGC
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CALL ELREF1(ELREFE)
      DIMGEO = 2
      AXI    = NOMTE(3:4).EQ.'AX'

C    DIMENSIONS CARACTERISTIQUES DE L'ELEMENT
      CHCTE = '&INEL.'//ELREFE//'.CARAC'
      CALL JEVETE(CHCTE,'L',JIN)
      NNO  = ZI(JIN)
      NPG  = ZI(JIN+2)
      IF (NNO.GT.3) CALL UTMESS('F','TE0573','MATNS() SOUS-DIMENSIONNE')
      IF (NPG.GT.4) CALL UTMESS('F','TE0573','PR() SOUS-DIMENSIONNE')

C    TABLEAUX DES FONCTIONS DE FORME
      CHVAL = '&INEL.'//ELREFE//'.FF'
      CALL JEVETE(CHVAL,'L',JVAL)
      IPOIDS = JVAL
      IVF    = IPOIDS + NPG
      IDF    = IVF    + NPG * NNO

C    AUTRES VARIABLES DE L'OPTION
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEPLMR','L',IDEPM)
      CALL JEVECH('PDEPLPR','L',IDEPP)
      CALL JEVECH('PPRESSR','L',IPRES)
      CALL JEVECH('PMATUUR','E',IMAT )


C    REACTUALISATION DE LA GEOMETRIE PAR LE DEPLACEMENT
      DO 10 I = 0,NNO*DIMGEO-1
        ZR(IGEOM+I) = ZR(IGEOM+I) + ZR(IDEPM+I) + ZR(IDEPP+I)
 10   CONTINUE

C    CALCUL DE LA PRESSION AUX POINTS DE GAUSS (A PARTIR DES NOEUDS)
      DO 100 KPG = 1,NPG
        KDEC = (KPG-1)*NNO
        PR(1,KPG) = 0.D0
        PR(2,KPG) = 0.D0
        DO 105 N = 0,NNO-1
          PR(1,KPG) = PR(1,KPG) + ZR(IPRES+2*N)  * ZR(IVF+KDEC+N)
          PR(2,KPG) = PR(2,KPG) + ZR(IPRES+2*N+1)* ZR(IVF+KDEC+N)
105     CONTINUE
100   CONTINUE

C    CALCUL EFFECTIF DE LA RIGIDITE
      CALL NMPR2D(AXI,2,NNO,NPG,ZR(IPOIDS),ZR(IVF),ZR(IDF),ZR(IGEOM),
     &            PR,RBID,MATNS)


C    ON SYMETRISE LA RIGIDITE TANGENTE  (STOCKAGE COLONNES SUPERIEURES)
      KK = 0
      COTE = NNO*2
      DO 200 J = 0,COTE-1
       DO 210 I=0,J
          ZR(IMAT+KK) = (MATNS(J*COTE+I) + MATNS(I*COTE+J))/2
          KK = KK+1
 210    CONTINUE
 200  CONTINUE

      END
