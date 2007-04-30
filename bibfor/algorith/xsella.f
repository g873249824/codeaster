      SUBROUTINE XSELLA(LSN   ,NBNO  ,NARZ  ,TABNOZ,
     &                  PICKNO,NBPINO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/04/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE

      INTEGER    NBNO,NARZ
      INTEGER    TABNOZ(3,NARZ),PICKNO(NARZ),NBPINO
      REAL*8     LSN(*)
C      
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (PREPARATION)
C
C CHOIX DE L'ESPACE DES LAGRANGES POUR LE CONTACT: 
C                    (VOIR BOOK VI 15/07/05) 
C    - SELECTION DES NOEUDS POUR LES LAGRANGES
C
C ----------------------------------------------------------------------
C
C
C IN  LSN    : CHAM_NO DE LA LEVEL SET NORMALE
C IN  NBNO   : NOMBRE DE NOEUDS DU MAILLAGE
C IN  NARZ   : NOMBRE D'ARETES COUPEES
C IN  TABNOZ : TABLEAU DES NOEUDS EXTREMITES ET NOEUD MILIEU
C OUT PICKNO : NUMEROS DES NOEUDS SELECTIONNES
C OUT NBPINO : NOMBRE DE NOEUDS SELECTIONNES
C
C ----------------------------------------------------------------------
C
      INTEGER     I,J,K,IK,CPTNO,DEJA,NOEUD(NBNO),TABDIR(NARZ,2)
      INTEGER     SCORNO(2*NARZ),SCORAR(NARZ),IA,MAX,BESTAR,NO1,NO2
      INTEGER     BESTNO,NOCONN,NARCAS,LIARCA(NARZ),NAR,NI,NJ
      INTEGER     TABNO(NARZ,3),II,CPT
      REAL*8      SCORN2(2*NARZ),SCORA2(NARZ),LI,LJ,MAXR
C
C ----------------------------------------------------------------------
C

C
C --- INITIALISATIONS
C
      NAR    = NARZ
      DO 100 I=1,NAR
        DO 101 J=1,3
          TABNO(I,J) = TABNOZ(J,I)
 101    CONTINUE
 100  CONTINUE
      CPTNO  = 0
      DO 200 I=1,2*NAR
        SCORNO(I) = 0
 200  CONTINUE
      CPT    = 0
C
C --- CALCUL DE SCORNO : NB D'ARETES CONNECTESS AU NOEUD
C --- CALCUL DE SCORN2 : VALEUR ABSOLUE DE LA LEVEL SET NORMALE
C    
      DO 201 I=1,NAR
        DO 202 J=1,2
          DEJA=0
          DO 203 K=1,CPT
            IF (TABNO(I,J).EQ.NOEUD(K)) THEN
              DEJA   = 1
              IK     = K
            ENDIF
 203      CONTINUE
          IF (DEJA.EQ.0) THEN
             CPT         = CPT+1
             NOEUD(CPT)  = TABNO(I,J)
             TABDIR(I,J) = CPT
             SCORN2(CPT) = ABS(LSN(TABNO(I,J)))
          ELSE
            TABDIR(I,J)  = IK
          ENDIF
        SCORNO(TABDIR(I,J)) = SCORNO(TABDIR(I,J))+1
 202    CONTINUE
 201  CONTINUE
C
C --- BOUCLE TANT QUE TOUTES LES ARETES NE SONT PAS CASSEES
C
      DO 210 II=1,NBNO

        IF (NAR.EQ.0) GOTO 300
C
C --- CALCUL SCORAR : DIFF DE SCORE POUR CHAQUE NOEUD
C --- CALCUL SCOAR2 : RAPPORT DES LEVEL SETS
C
        DO 211 IA=1,NAR
          NI         = SCORNO(TABDIR(IA,1))
          NJ         = SCORNO(TABDIR(IA,2))
          SCORAR(IA) = ABS(NI-NJ)
          LI         = ABS(LSN(TABNO(IA,1)))
          LJ         = ABS(LSN(TABNO(IA,2)))
          IF (NI.GT.NJ) SCORA2(IA)=LI/(LI+LJ)
          IF (NI.LT.NJ) SCORA2(IA)=LJ/(LI+LJ)
          IF (NI.EQ.NJ) SCORA2(IA)=MIN(LI,LJ)/(LI+LJ)
 211    CONTINUE
C
C --- MEILLEURE ARETE : PICK MEILLEUR NOEUD
C
        MAX    = -1
        MAXR   = -1.D0
        DO 212 IA=1,NAR
          IF ((SCORAR(IA).GT.MAX) .OR.
     &        (SCORAR(IA).EQ.MAX.AND.SCORA2(IA).GE.MAXR)) THEN
            MAX    = SCORAR(IA)
            MAXR   = SCORA2(IA)
            BESTAR = IA
          ENDIF
 212    CONTINUE
C
        NO1    = TABDIR(BESTAR,1)
        NO2    = TABDIR(BESTAR,2)
        BESTNO = NO1
        IF ((SCORNO(NO2).GT.SCORNO(NO1)).OR.
     &      (SCORNO(NO2).GT.SCORNO(NO1).AND.
     &       SCORN2(NO2).LT.SCORN2(NO1)))  THEN
          BESTNO=NO2
        ENDIF  
        CPTNO         = CPTNO+1
        PICKNO(CPTNO) = NOEUD(BESTNO)
C
C --- UPDATE SCORE DES NOEUDS
C
        DO 220 I=1,NAR
          DO 221 J=1,2
            IF (TABDIR(I,J) .EQ. BESTNO) THEN
              SCORNO(BESTNO) = SCORNO(BESTNO)-1
              NOCONN         = TABDIR(I,3-J)
              SCORNO(NOCONN) = SCORNO(NOCONN)-1
            ENDIF
 221      CONTINUE
 220    CONTINUE
C
C --- ON LISTE LES ARETES CONNECTEES A�BESTNO PUIS ON LES CASSE
C
        NARCAS = 0
        DO 230 IA=1,NAR
          IF (TABDIR(IA,1).EQ.BESTNO.OR.TABDIR(IA,2).EQ.BESTNO) THEN
            NARCAS         = NARCAS+1
            LIARCA(NARCAS) = IA
          ENDIF
 230    CONTINUE
C
C --- FEINTE : ON LES SUPPRIME EN PARTANT PAR LA FIN !
C
        DO 231 IA=NARCAS,1,-1
C          TABNO(LIARCA(IA),:)=[]
C          TABDIR(LIARCA(IA),:)=[]
          DO 232 I=LIARCA(IA),NAR-1
            TABNO(I,1) = TABNO(I+1,1)
            TABNO(I,2) = TABNO(I+1,2)
            TABNO(I,3) = TABNO(I+1,3)
            TABDIR(I,1)= TABDIR(I+1,1)
            TABDIR(I,2)= TABDIR(I+1,2)
 232      CONTINUE
          TABNO(NAR,1)  = 0
          TABNO(NAR,2)  = 0
          TABNO(NAR,3)  = 0
          TABDIR(NAR,1) = 0
          TABDIR(NAR,2) = 0
          NAR           = NAR-1
 231    CONTINUE
 210  CONTINUE
 300  CONTINUE
C
C --- NOMBRE DE PICKED NODES
C
      NBPINO = CPTNO
C
      END
