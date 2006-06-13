      SUBROUTINE TRVPMD(NP1,N,M,RR,LOC,INDXF,NPOINT,LPOINT,TP,RTP)
C
C----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/05/96   AUTEUR KXBADNG T.FRIOU 
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
C----------------------------------------------------------------------
      IMPLICIT NONE
C
C ARGUMENTS
C ---------
      INTEGER NP1,N,M
      INTEGER INDXF(*),NPOINT(*),LPOINT(*)
      REAL*8 RR(*),TP(*),RTP(*)
      LOGICAL LOC(*)
C
C VARIABLES LOCALES
C -----------------
      INTEGER IDEB,IFIN,LL,I,J,JMAX,NPDEB,NPFIN,LSOM,NSAUT
C
C**********************************************************************
C                DEBUT DU CODE EXECUTABLE
C**********************************************************************
C
C --- INITIALISATION
C
      IDEB=1
      IFIN=0
      LL=0
      J=0
      JMAX=0
      NSAUT = 0
      CALL INITVE(NP1,TP)
      CALL INITVE(NP1,RTP)
      DO 100 I=1,NP1
        NPOINT(I) = 0
        LPOINT(I) = 0
 100  CONTINUE
C
C --- RECHERCHE DU POSITIONNEMENT DES MODES SELECTIONNES 
C
      IF (IDEB .LT. N) THEN
C
 1    CONTINUE
        IDEB = IDEB + LL
C
      J = J + 1
C
      DO 2 I=IDEB,N
       IF (LOC(I)) THEN
         IDEB = I
         GO TO 3   
       ENDIF
 2    CONTINUE
C
 3    CONTINUE
C
      DO 4 I=IDEB,N
       IF (LOC(I)) THEN
         IFIN = N+1
       ELSE
         IFIN = I
         GO TO 5
       ENDIF
 4    CONTINUE
C
 5    CONTINUE
C
      LL = IFIN - IDEB 
      NPOINT(J) = IDEB
      LPOINT(J) = LL
C
      IF (LL .EQ. 0) THEN
        GO TO 6
      ELSE
        GO TO 1
      ENDIF
C
      ENDIF
C
 6    CONTINUE
C
      IF (J .EQ. 1) THEN
        JMAX = J
      ELSE
        JMAX = J-1
      ENDIF
C
C --- VERIFICATION DU NOMBRE DE MODES SELECTIONNES
C
      LSOM=0
C
      DO 7 J=1,JMAX
        LSOM = LSOM + LPOINT(J)
 7    CONTINUE
C
      IF (LSOM .NE. M) THEN
      WRITE(6,*) 'ERREUR SUR LE NOMBRE DE MODES SELECTIONNES'
      GO TO 9999
      ENDIF
C
C --- REMPLISSAGE DU TABLEAU RTP COMPORTANT UNIQUEMENT 
C     LES MODES SELECTIONNES  
C
C
      DO 8 J=1, JMAX
C
      IF (J .GT. 1) THEN
        NSAUT = NSAUT + LPOINT(J-1)
      ENDIF
C
      NPDEB = NPOINT(J)
      NPFIN = NPOINT(J) + LPOINT(J) - 1
C
        DO 9 I=NPDEB, NPFIN
          TP(I-NPDEB+NSAUT+1) = RR(I)
 9      CONTINUE
C
 8    CONTINUE
C
      DO 10 I=1,M
        RTP(I) = TP(I)
 10   CONTINUE
C
C --- TRI DES MODES SELECTIONNES PAR VALEURS PROPRES CROISSANTES
C
      CALL INDEXX(M,RTP,INDXF)
      DO 11 I=1,M
        TP(I) = RTP(INDXF(I))
 11   CONTINUE
C
      DO 12 I=1,N
        RR(I) = 0.0D0
 12   CONTINUE
C
      DO 13 I=1,M
        RR(I) = TP(I)
 13   CONTINUE
C
 9999 CONTINUE
      END
