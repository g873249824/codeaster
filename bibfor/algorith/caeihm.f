      SUBROUTINE CAEIHM(NOMTE ,AXI   ,PERMAN,MECANI,PRESS1,PRESS2,
     >                  TEMPE ,DIMDEF,DIMCON,NDIM  ,NNO1  ,NNO2  ,
     >                  NPI   ,NPG   ,DIMUEL,IW    ,IVF1  ,IDF1  ,
     >                  IVF2  ,IDF2  ,JGANO1,IU    ,IP    ,IPF   ,
     >                  IQ    ,MODINT)

C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/06/2010   AUTEUR GRANET S.GRANET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C TOLE CRP_21
C TOLE CRP_20
C ======================================================================


C ======================================================================
C --- BUT : PREPARATION DU CALCUL SUR UN ELEMENT DE JOINT HM -----------
C ======================================================================
C
C IN NOMTE   : NOM DU TYPE D'ELEMENT 
C IN AXI     : AXI ?
C OUT PERMAN : MODELISATION HM PERMAMENTE ?
C OUT MECANI : TABLEAU INFO SUR MECANIQUE
C OUT PRESS1 : TABLEAU INFO SUR HYDRAULIQUE CONSTITUANT 1
C OUT PRESS2 : TABLEAU INFO SUR HYDRAULIQUE CONSTITUANT 2
C OUT TEMPE  : TABLEAU INFO SUR THERMIQUE
C OUT DIMDEF : DIMENSION DES DEFORMATIONS GENERALISEES
C OUT DIMCON : DIMENSION DES CONTRAINTES GENERALISEES
C OUT NDIM   : DIMENSION DU PROBLEME (2 OU 3)
C OUT NNO1   : NOMBRE DE NOEUDS DES BORDS INF ET DUP DE L'ELEMENT
C OUT NNO2   : NOMBRE DE NOEUDS DU SEGMENT CENTRAL
C OUT NPI    : NOMBRE DE POINTS D'INTEGRATION DE L'ELEMENT
C OUT NPG    : NOMBRE DE POINTS DE GAUSS   
C OUT DIMUEL : NOMBRE DE DDL TOTAL DE L'ELEMENT
C OUT IW     : ADRESSE DU TABLEAU POIDS POUR FONCTION DE FORME P2
C OUT IVF1   : ADRESSE DU TABLEAU DES FONCTIONS DE FORME P2
C OUT IDF1   : ADRESSE DU TABLEAU DES DERIVESS DES FONCTIONS DE FORME P2
C OUT IVF2   : ADRESSE DU TABLEAU DES FONCTIONS DE FORME P1
C OUT IDF2 : ADRESSE DU TABLEAU DES DERIVESS DES FONCTIONS DE FORME P1
C OUT JGANO1  : ADRESSE DANS ZR DE LA MATRICE DE PASSAGE
C              GAUSS -> NOEUDS
C OUT IU     : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE DEPLACEMENT
C OUT IP     : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE PRESSION MILIEU
C OUT IPF    : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE PRESSION FACES
C OUT IQ     : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE LAGRANGE HYDRO
C OUT MODINT : MODE D'INTEGRATION

C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      LOGICAL       AXI, PERMAN,LTEATT
      INTEGER       MECANI(8),PRESS1(9),PRESS2(9),TEMPE(5),DIMUEL
      INTEGER       NDIM,NNOS,NNO1,NNO2,NTROU
      INTEGER       DIMDEF,DIMCON
      INTEGER       NPG,NPI,N,I
      INTEGER       IVF1,IDF1,IVF2,IDF2,JGANO1,JGANO2,IW
      INTEGER       IU(3,18),IP(2,9),IPF(2,2,9),IQ(2,2,9)
      INTEGER       F1Q8(6),F2Q8(2),F3Q8(2),F4Q8(2)
      CHARACTER*3   MODINT
      CHARACTER*8   LIELRF(10)
      CHARACTER*16  NOMTE

C --- INITIALISATIONS --------------------------------------------------

       PERMAN= .FALSE.
       NDIM=2
       AXI=.FALSE.
C ======================================================================
C --- INITIALISATION DES GRANDEURS GENERALISEES SELON MODELISATION -----
C ======================================================================
      CALL GREIHM(NOMTE,PERMAN,NDIM,MECANI,PRESS1,PRESS2,TEMPE,
     >            DIMDEF,DIMCON)


      CALL MODTHM(NOMTE,MODINT)
      
      IF ( LTEATT(' ','AXIS','OUI') ) THEN
        AXI       = .TRUE.
      END IF
C ======================================================================
C --- ADAPTATION AU MODE D'INTEGRATION ---------------------------------
C --- DEFINITION DE L'ELEMENT (NOEUDS, SOMMETS, POINTS DE GAUSS) -------
C ======================================================================
      CALL ELREF2(NOMTE,2,LIELRF,NTROU)
      CALL ELREF4(LIELRF(1),'RIGI',NDIM,NNO1,NNOS,NPI,IW,
     >            IVF1,IDF1,JGANO1)
      CALL ELREF4(LIELRF(2),'RIGI',NDIM,NNO2,NNOS,NPI,IW,
     >            IVF2,IDF2,JGANO2)

      IF (MODINT .EQ. 'RED') THEN
        NPG= NPI-NNOS
      END IF
      IF (MODINT .EQ. 'CLA') THEN
        NPG= NPI
      END IF

      NDIM   = NDIM + 1

C ======================================================================
C --- DETERMINATION DES DECALAGES D'INDICE POUR ACCEDER AUX DDL --------
C ======================================================================

      DATA F1Q8  /1,2,5,4,3,7/
      DATA F2Q8 /8,6/
      DATA F3Q8 /1,2/
      DATA F4Q8 /4,3/

      IF ((NOMTE(1:9).EQ.'HM_J_DPQ8').OR.(NOMTE(1:9).EQ.'HM_J_AXQ8'))
     &  THEN
        DIMUEL = 2*NNO1*NDIM+NNO2*3*(PRESS1(1)+PRESS2(1))+2
        DO 10 N = 1,5
          DO 11 I = 1,2
          IU(I,N) = I + (F1Q8(N)-1)*3
 11       CONTINUE
 10     CONTINUE
        DO 12 I = 1,2
          IU(I,6) = IU(I,3) + 4
 12     CONTINUE

        DO 20 N = 1,2
          IP(1,N) = 16 + (F2Q8(N)-6)*2
 20     CONTINUE

        DO 30 N = 1,2
          IPF(1,1,N) = 3+(F4Q8(N)-1)*3
 30     CONTINUE

        DO 40 N = 1,2
          IPF(1,2,N) = 3+(F3Q8(N)-1)*3   
 40     CONTINUE
        IQ(1,1,1)=IU(2,6)+1
        IQ(1,2,1)=IU(2,3)+1
      END IF

C ======================================================================
      END
