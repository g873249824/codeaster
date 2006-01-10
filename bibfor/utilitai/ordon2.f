      SUBROUTINE ORDON2(VALE,NB)
      IMPLICIT NONE
      INTEGER      NB
      REAL*8       VALE(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 09/01/2006   AUTEUR NICOLAS O.NICOLAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ----------------------------------------------------------------------
C RESPONSABLE MCOURTOI M.COURTOIS
C ----------------------------------------------------------------------
C     APPELEE PAR ORDONN : ON SAIT DEJA QU'IL FAUT INVERSER L'ORDRE
C     ORDON2 POUR LES FONCTIONS A VALEURS COMPLEXES
C IN/OUT : VALE : ABSCISSES, PARTIE REELLE, PARTIE IMAGINAIRE
C                 SOUS LA FORME X1,Y1,Z1, X2,Y2,Z2, ...
C IN     : NB   : NBRE DE POINTS
C ----------------------------------------------------------------------
      INTEGER      I, IORD(NB)
      REAL*8       XBID(NB), YRBID(NB), YIBID(NB)
C     ------------------------------------------------------------------
C
      CALL DCOPY(NB,VALE,1,XBID,1)
      CALL DCOPY(NB,VALE(NB+1),2,YRBID,1)
      CALL DCOPY(NB,VALE(NB+2),2,YIBID,1)
      CALL ORDR8(XBID,NB,IORD)
      DO 101 I=1,NB
        VALE(I)=XBID(IORD(I))
        VALE(NB+1+2*(I-1))=YRBID(IORD(I))
        VALE(NB+2+2*(I-1))=YIBID(IORD(I))
 101  CONTINUE

      END
