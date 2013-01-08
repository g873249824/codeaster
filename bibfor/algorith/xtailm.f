      SUBROUTINE XTAILM(NDIM,VECDIR,NUMA,TYPMA,JCOOR,JCONX1,JCONX2,IPT,
     &                 JTAIL)
      IMPLICIT NONE

      INCLUDE 'jeveux.h'
      INTEGER       NDIM,NUMA,JCOOR,JCONX1,JCONX2,IPT,JTAIL
      REAL*8        VECDIR(NDIM)
      CHARACTER*8   TYPMA

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/01/2013   AUTEUR LADIER A.LADIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C       ----------------------------------------------------------------
C       DETERMINATION DE LA TAILLE MAXIMALE DE LA MAILLE CONNECTEE AU 
C       POINT DU FOND IPT SUIVANT LA DIRECTION DU VECTEUR VECDIR
C       ----------------------------------------------------------------
C    ENTREES
C       NDIM   : DIMENSION DU MODELE
C       VECDIR : VECTEUR TANGENT
C       NUMA   : NUMERO DE LA MAILLE COURANTE
C       TYPMA  : TYPE DE LA MAILLE COURANTE
C       JCOOR  : ADRESSE DU VECTEUR DES COORDONNEES DES NOEUDS
C       JCONX1 : ADRESSE DE LA CONNECTIVITE DU MAILLAGE
C       JCONX2 : LONGUEUR CUMULEE DE LA CONNECTIVITE DU MAILLAGE
C       IPT    : INDICE DU POINT DU FOND
C    SORTIE
C       JTAIL  : ADRESSE DU VECTEUR DES TAILLES MAXIMALES DES MAILLES
C                CONNECTEES AUX NOEUDS DU FOND DE FISSURE
C               
C
      INTEGER       AR(12,3)
      INTEGER       IAR,INO1,INO2,K,NBAR,NNO1,NNO2
      REAL*8        ARETE(3),DDOT,P
C     -----------------------------------------------------------------

      CALL JEMARQ()

      CALL CONARE(TYPMA,AR,NBAR)

C     BOUCLE SUR LE NOMBRE D'ARETES DE LA MAILLE NUMA
      DO 10 IAR=1,NBAR

        INO1 = AR(IAR,1)
        NNO1 = ZI(JCONX1-1 + ZI(JCONX2+NUMA-1) +INO1-1)
        INO2 = AR(IAR,2)
        NNO2 = ZI(JCONX1-1 + ZI(JCONX2+NUMA-1) +INO2-1)

C       VECTEUR REPRESENTANT L'ARETE IAR
        DO 11 K=1,NDIM
          ARETE(K)=ZR(JCOOR-1+(NNO1-1)*3+K)-ZR(JCOOR-1+(NNO2-1)*3+K)
 11     CONTINUE

C       PROJECTION DE L'ARETE IAR SUR LE VECTEUR TANGENT
        P = DDOT(NDIM,ARETE,1,VECDIR,1)
        P = ABS(P)

        IF (P.GT.ZR(JTAIL-1+IPT)) ZR(JTAIL-1+IPT) = P

 10   CONTINUE
C
      CALL JEDEMA()
      END
