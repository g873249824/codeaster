      SUBROUTINE INIVEC(VEC,NEQ,ID,NBCP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/10/95   AUTEUR GIBHHAY A.Y.PORTABILITE 
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
C***********************************************************************
C    P. RICHARD     DATE 27/11/90
C-----------------------------------------------------------------------
C  BUT:  INITIALISER TOUTES LES COMPOSANTES D'UN VECTEUR A ZERO SAUF
C   CELLES D'UNE LISTE EGALES A UN
      IMPLICIT REAL*8 (A-H,O-Z)
C
C-----------------------------------------------------------------------
C
C VEC      /M/: VECTEUR A INITIALISER
C NEQ      /I/: DIMENSION DU VECTEUR
C ID       /I/: LISTE DES RANGS DES COMPOSANTES NON NULLES
C NBCP     /I/: NOMBRE DE COMPOSANTES A INITIALISER A UN
C
C-----------------------------------------------------------------------
C
      REAL*8 VEC(NEQ)
      INTEGER ID(NBCP)
      CHARACTER*6   PGC
C
C-----------------------------------------------------------------------
      DATA PGC /'INIVEC'/
C-----------------------------------------------------------------------
C
      DO 10 I=1,NEQ
        VEC(I)=0.D0
 10   CONTINUE
C
      DO 20 J=1,NBCP
        IF(ID(J).GT.NEQ) THEN
          CALL UTMESS('A',PGC,'RANG SUPERIEUR A DIMENSION VECTEUR')
        ELSE
          VEC(ID(J))=1.D0
        ENDIF
 20   CONTINUE
C
 9999 CONTINUE
      END
