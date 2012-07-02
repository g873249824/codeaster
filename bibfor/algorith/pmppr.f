      SUBROUTINE PMPPR(AMAT,NA1,NA2,KA,BMAT,NB1,NB2,KB,
     &                 CMAT,NC1,NC2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C***********************************************************************
C    P. RICHARD     DATE 12/03/91
C-----------------------------------------------------------------------
C  BUT:  PRODUIT DE DEUX MATRICES STOCKEE PLEINE AVEC PRISE EN COMPTE
C DE TRANSPOSITION PAR L'INTERMEDIAIRE D'INDICATEUR K
      IMPLICIT NONE
C
C-----------------------------------------------------------------------
C
C AMAT     /I/: PREMIERE MATRICE
C NA1      /I/: NOMBRE DE LIGNE DE LA PREMIERE MATRICE
C NA2      /I/: NOMBRE DE COLONNE DE LA PREMIERE MATRICE
C KB       /I/: INDICATEUR TRANSPOSITION PREMIERE MATRICE
C BMAT     /I/: DEUXIEME MATRICE
C NB1      /I/: NOMBRE DE LIGNE DE LA DEUXIEME MATRICE
C NB2      /I/: NOMBRE DE COLONNE DE LA DEUXIEME MATRICE
C KB       /I/: INDICATEUR TRANSPOSITION DEUXIEME MATRICE
C CMAT     /I/: MATRICE RESULTAT
C NC1      /I/: NOMBRE DE LIGNE DE LA MATRICE RESULTAT
C NC2      /I/: NOMBRE DE COLONNE DE LA MATRICE RESULTAT
C
C-----------------------------------------------------------------------
C
      REAL*8  AMAT(NA1,NA2),BMAT(NB1,NB2),CMAT(NC1,NC2)
C
C-----------------------------------------------------------------------
C
C
C   CAS SANS TRANSPOSITION
C
C-----------------------------------------------------------------------
      INTEGER I ,J ,K ,KA ,KB ,NA1 ,NA2 
      INTEGER NB1 ,NB2 ,NC1 ,NC2 
C-----------------------------------------------------------------------
      IF(KA.EQ.1.AND.KB.EQ.1) THEN
        IF(NA2.NE.NB1) THEN
          CALL U2MESG('F', 'ALGORITH13_91',0,' ',0,0,0,0.D0)
        ENDIF
        IF(NC1.NE.NA1.OR.NC2.NE.NB2) THEN
          CALL U2MESG('F', 'ALGORITH13_92',0,' ',0,0,0,0.D0)
        ENDIF
        DO 10 I=1,NA1
          DO 20 J=1,NB2
            CMAT(I,J)=0.D0
            DO 30 K=1,NB1
               CMAT(I,J)=CMAT(I,J)+AMAT(I,K)*BMAT(K,J)
 30         CONTINUE
 20       CONTINUE
 10     CONTINUE
C
      ENDIF
C
      IF(KA.EQ.-1.AND.KB.EQ.1) THEN
        IF(NA1.NE.NB1) THEN
          CALL U2MESG('F', 'ALGORITH13_91',0,' ',0,0,0,0.D0)
        ENDIF
        IF(NC1.NE.NA2.OR.NC2.NE.NB2) THEN
           CALL U2MESG('F', 'ALGORITH13_92',0,' ',0,0,0,0.D0)
        ENDIF
        DO 40 I=1,NA2
          DO 50 J=1,NB2
            CMAT(I,J)=0.D0
            DO 60 K=1,NB1
               CMAT(I,J)=CMAT(I,J)+AMAT(K,I)*BMAT(K,J)
 60         CONTINUE
 50       CONTINUE
 40     CONTINUE
C
      ENDIF
C
C
      IF(KA.EQ.1.AND.KB.EQ.-1) THEN
        IF(NA2.NE.NB2) THEN
          CALL U2MESG('F', 'ALGORITH13_91',0,' ',0,0,0,0.D0)
        ENDIF
        IF(NC1.NE.NA1.OR.NC2.NE.NB1) THEN
          CALL U2MESG('F', 'ALGORITH13_92',0,' ',0,0,0,0.D0)
        ENDIF
        DO 70 I=1,NA1
          DO 80 J=1,NB1
            CMAT(I,J)=0.D0
            DO 90 K=1,NA2
               CMAT(I,J)=CMAT(I,J)+AMAT(I,K)*BMAT(J,K)
 90         CONTINUE
 80       CONTINUE
 70     CONTINUE
C
      ENDIF
C
C
      IF(KA.EQ.-1.AND.KB.EQ.-1) THEN
        IF(NA1.NE.NB2) THEN
          CALL U2MESG('F', 'ALGORITH13_91',0,' ',0,0,0,0.D0)
        ENDIF
        IF(NC1.NE.NA2.OR.NC2.NE.NB1) THEN
          CALL U2MESG('F', 'ALGORITH13_92',0,' ',0,0,0,0.D0)
        ENDIF
        DO 100 I=1,NA2
          DO 110 J=1,NB1
            CMAT(I,J)=0.D0
            DO 120 K=1,NB2
               CMAT(I,J)=CMAT(I,J)+AMAT(K,I)*BMAT(J,K)
 120         CONTINUE
 110       CONTINUE
 100     CONTINUE
C
      ENDIF
C
      END
