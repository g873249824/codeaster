      SUBROUTINE PLTRI3(NOMMA1,NOMMA2,SC    ,NBNO  ,FS    ,
     &                  NFAC  ,VOLMIN,TRAVL ,TET   ,NTET)
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8  NOMMA1,NOMMA2       
      INTEGER      TET(4,*) 
      INTEGER      NBNO
      INTEGER      NTET   
      INTEGER      NFAC   
      LOGICAL      TRAVL(*)
      REAL*8       SC(3,*)
      REAL*8       VOLMIN
      INTEGER      FS(3,*)
C      
C ----------------------------------------------------------------------
C
C APPARIEMENT DE DEUX GROUPES DE MAILLE PAR LA METHODE
C BOITES ENGLOBANTES + ARBRE BSP
C
C TETRAEDRISATION D'UN POLYEDRE ETOILE EN SON CENTRE DE GRAVITE
C
C ----------------------------------------------------------------------
C 
C
C IN  NOMMA1 : NOM DE LA PREMIERE MAILLE
C IN  NOMMA2 : NOM DE LA SECONDE MAILLE
C I/O SC     : IN  - COORDONNEES DES SOMMETS DU POLYEDRE
C              OUT - COORDONNEES DES SOMMETS DES TETRAEDRES 
C                     SOMMETS INITIAUX DU POLYEDRE +
C                     CENTRE DE GRAVITE DU POLYEDRE
C IN  FS     : NOEUDS DEFINISSANT LES FACETTES DE L'INTERSECTION
C                       RANGES PAR COMPOSANTES CONNEXES
C                (FACE1.ND1,FACE1.ND2,FACE1.ND3,
C                 FACE2.ND1,FACE2.ND2,FACE2.ND3,...)
C                  SENS DE PARCOURS, NORMALE SORTANTE A DROITE
C IN  NFAC   : NOMBRE DE FACES TRIANGLES DU POLYEDRE
C IN  VOLMIN : VOLUME MINIMUM DU TETRAEDRE 
C I/O NBNO   : IN  - NOMBRE DE SOMMETS DU POLYEDRE
C              OUT - NOMBRE DE SOMMETS DES TETRAEDRES 
C               NBNO(OUT) = NBNO(IN)+1 (CDG)
C I/O TRAVL  : VECTEUR DE TRAVAIL DE BOOLEENS 
C              SOMMET APPARTENANT AU POLYEDRE (INUTILE POUR LA SUITE)
C                     DIM: NBNO
C OUT TET    : CONNECTIVITE TETRAEDRISATION (UNE LIGNE PAR TETRA)
C                (SOMMET.1.1,SOMMET.1.2,SOMMET.1.3,SOMMET.1.4,
C                 SOMMET.2.1,SOMMET.2.2,SOMMET.2.3,SOMMET.2.4,)
C              L'INDEX DU SOMMET SE REFERE A SC
C OUT NTET   : NOMBRE DE TETRAEDRES
C
C ----------------------------------------------------------------------
C
      REAL*8  DDOT,PLVOL3
      INTEGER NS0,ITET,IFACE,A,B,C,S
      REAL*8  SI(3),N(3),V(3),R0,R1,R2
      LOGICAL IR
      CHARACTER*16 VALK(2)
      REAL*8       VALR(3)
C
C ----------------------------------------------------------------------
C
      NTET = 0
      NS0  = NBNO
      IR   = .FALSE.
C
C --- SOMMET APPARTENANT AU POLYEDRE
C
      DO 10 S = 1, NS0
        TRAVL(S) = .TRUE.
 10   CONTINUE

      DO 20 IFACE = 1, NFAC
        TRAVL(FS(1,IFACE)) = .FALSE.
        TRAVL(FS(2,IFACE)) = .FALSE.
        TRAVL(FS(3,IFACE)) = .FALSE.
 20   CONTINUE
C
C --- CALCUL DU CENTRE DE GRAVITE (G)
C
      NBNO = NBNO + 1
      CALL PLCENT(3,SC,FS,NFAC,SC(1,NBNO))
C
C --- VERIFICATION QUE LE POLYEDRE EST ETOILE EN G
C
      DO 30 IFACE = 1, NFAC

        A = FS(1,IFACE)
        B = FS(2,IFACE)
        C = FS(3,IFACE)

        CALL PROVE3(SC(1,A),SC(1,B),SC(1,C),N)
        R0 = DDOT(3,N,1,SC(1,A),1)
        R1 = DDOT(3,N,1,SC(1,NBNO),1) - R0

        IF (ABS(R1).LT.VOLMIN) GOTO 30

        IF (R1.GT.0.D0) THEN
          IR = .TRUE.
          GOTO 50
        ENDIF

        DO 40 S = 1, NS0

          IF (TRAVL(S).OR.(S.EQ.A).OR.(S.EQ.B).OR.(S.EQ.C)) GOTO 40

          R2 = DDOT(3,N,1,SC(1,S),1) - R0
          IF (((R1.LT.0.D0).EQV.(R2.LT.0.D0)).OR.
     &         (ABS(R2).LT.VOLMIN)) THEN
            GOTO 40
          ENDIF
          R2 = R1/(R1 - R2)
          SI(1) = (1-R2)*SC(1,NBNO) + R2*SC(1,S)
          SI(2) = (1-R2)*SC(2,NBNO) + R2*SC(2,S)
          SI(3) = (1-R2)*SC(3,NBNO) + R2*SC(3,S)

          CALL PROVE3(SC(1,A),SC(1,B),SI,V)
          IF (DDOT(3,N,1,V,1).LT.0.D0) GOTO 40

          CALL PROVE3(SC(1,B),SC(1,C),SI,V)
          IF (DDOT(3,N,1,V,1).LT.0.D0) GOTO 40

          CALL PROVE3(SC(1,C),SC(1,A),SI,V)
          IF (DDOT(3,N,1,V,1).LT.0.D0) GOTO 40

          IR = .TRUE.

 40     CONTINUE

C ----- ECRITURE DES TETRAEDRES

 50     CONTINUE

        NTET = NTET + 1
        TET(1,NTET) = NBNO
        TET(2,NTET) = FS(1,IFACE)
        TET(3,NTET) = FS(2,IFACE)
        TET(4,NTET) = FS(3,IFACE)

 30   CONTINUE

C --- DIFFERENCE DE VOLUME
C SOLUTION : DECOUPER POLYEDRE PAR PLAN F A PARTIR DU VOISINAGE DE S
C            ITERER SUR LES COMPOSANTES CONNEXES

      IF (IR) THEN
        R0 = PLVOL3(SC,FS,NFAC)
        R1 = 0.D0
        DO 60 ITET = 1, NTET
          S = TET(1,ITET)
          A = TET(2,ITET)
          B = TET(3,ITET)
          C = TET(4,ITET)
          N(1) = SC(1,A)-SC(1,S)
          N(2) = SC(2,A)-SC(2,S)
          N(3) = SC(3,A)-SC(3,S)
          CALL PROVE3(SC(1,S),SC(1,B),SC(1,C),V)
          R1 = R1 + DDOT(3,N,1,V,1)
 60     CONTINUE
        R1 = R1/6.D0
C
        IF (R0.NE.0) THEN
          R2 = (R1-R0)/R0
        ELSE
          R2 = (R1-R0)
        ENDIF
        VALK(1) = NOMMA1
        VALK(2) = NOMMA2
        VALR(1) = R1
        VALR(2) = R0
        VALR(3) = R2                
        CALL U2MESG('F', 'UTILITAI7_2',2,VALK,0,0,3,VALR)
        CALL U2MESS('A','ARLEQUIN_25')
        WRITE(6,*) 'VOLUME :',R1,' AU LIEU DE',R0,' DIFFE',R1-R0
C
      ENDIF

      END
