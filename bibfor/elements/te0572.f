      SUBROUTINE TE0572(OPTION,NOMTE)
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
C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
C          CORRESPONDANT A UN CHARGEMENT EN PRESSION SUIVEUSE
C          SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 2D
C          (LA PRESSION EST DONNEE SOUS FORME D'UNE FONCTION)
C
C          OPTION : 'CHAR_MECA_PRSU_F '
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      IMPLICIT NONE
      LOGICAL       AXI
      CHARACTER*8   ELREFE,NOMPAR(4)
      CHARACTER*16  NOMTE,OPTION
      CHARACTER*24  CHVAL,CHCTE,CHTRAV
      INTEGER       IER
      INTEGER       DIMGEO,NNO,NPG
      INTEGER       JIN,JVAL,JTRAV
      INTEGER       IPOIDS,IVF,IDF,IGEOM,IPRES,ITEMPS,IRES
      INTEGER       IDEPM,IDEPP
      INTEGER       KPG,KDEC,N,I
      REAL*8        VALPAR(3),X,Y,PR(2,4),MATNS(0:35)


C
C
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
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
      IF (NNO.GT.3) CALL UTMESS('F','TE0572','MATNS() SOUS-DIMENSIONNE')
      IF (NPG.GT.4) CALL UTMESS('F','TE0572','PR() SOUS-DIMENSIONNE')

C    TABLEAUX DES FONCTIONS DE FORME
      CHVAL = '&INEL.'//ELREFE//'.FF'
      CALL JEVETE(CHVAL,'L',JVAL)
      IPOIDS = JVAL
      IVF    = IPOIDS + NPG
      IDF    = IVF    + NPG * NNO
C
C    AUTRES VARIABLES DE L'OPTION
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEPLMR','L',IDEPM)
      CALL JEVECH('PDEPLPR','L',IDEPP)
      CALL JEVECH('PPRESSF','L',IPRES)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PVECTUR','E',IRES)
C
C    REACTUALISATION DE LA GEOMETRIE PAR LE DEPLACEMENT
      DO 10 I = 0,NNO*DIMGEO-1
        ZR(IGEOM+I) = ZR(IGEOM+I) + ZR(IDEPM+I) + ZR(IDEPP+I)
 10   CONTINUE
C
C    CALCUL DE LA PRESSION AUX PTS DE GAUSS (FONCTION DE T ET/OU X,Y,Z)
      VALPAR(3) = ZR(ITEMPS)
      NOMPAR(3) = 'INST'
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
C
      DO 100 KPG=1,NPG
        KDEC = (KPG-1)*NNO
C
C      COORDONNEES DU POINT DE GAUSS
        X = 0.D0
        Y = 0.D0
        DO 105 N = 0,NNO-1
          X = X + ZR(IGEOM+DIMGEO*N  ) * ZR(IVF+KDEC+N)
          Y = Y + ZR(IGEOM+DIMGEO*N+1) * ZR(IVF+KDEC+N)
 105    CONTINUE

C      VALEUR DE LA PRESSION
        VALPAR(1) = X
        VALPAR(2) = Y
        CALL FOINTE('FM',ZK8(IPRES)  ,3,NOMPAR,VALPAR,PR(1,KPG),IER)
        CALL FOINTE('FM',ZK8(IPRES+1),3,NOMPAR,VALPAR,PR(2,KPG),IER)
100   CONTINUE
C
C    CALCUL EFFECTIF DU SECOND MEMBRE
      CALL NMPR2D(AXI,1,NNO,NPG,ZR(IPOIDS),ZR(IVF),ZR(IDF),ZR(IGEOM),PR,
     &            ZR(IRES),MATNS)
C
      END
