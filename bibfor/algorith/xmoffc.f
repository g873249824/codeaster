      SUBROUTINE XMOFFC(LACT,NLACT,NNO,FFE,FFC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/04/2010   AUTEUR PELLET J.PELLET 
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
C RESPONSABLE PELLET J.PELLET
      IMPLICIT NONE
      INTEGER      LACT(8),NLACT,NNO
      REAL*8       FFE(8),FFC(8)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT AVEC XFEM
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C
C POUR LA FORMULATION AUX NOEUDS SOMMET,  SI UN NOEUD N'EST PAS ACTIF, 
C ON REPARTI SES FF EQUITABLEMENT SUR LES NOEUDS ACTIF
C
C ----------------------------------------------------------------------
C
C IN  NNO    : NOMBRE DE NOEUD DE L'ELEMENT PARENT
C IN LACT    : LITE DES LAGRANGES ACTIFS
C IN NLACT   : NOMBRE TOTAL DE LAGRANGES ACTIFS
C IN FFE     : FONCTION DE FORMES DE L'ELEMENT ESCLAVE PARENT
C OUT FFC    : FONCTION DE FORMES DU POINT DE CONTACT
C
C ----------------------------------------------------------------------
C
      INTEGER  I,J
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      DO 10 I=1,NNO
        FFC(I)=FFE(I)
 10   CONTINUE
      IF (NLACT.LT.NNO) THEN
        DO 20 I=1,NNO
          IF (LACT(I).EQ.0) THEN
            DO 30 J=1,NNO
              IF (I.NE.J.AND.LACT(J).NE.0) THEN
                FFC(J)=FFC(J)+FFC(I)/NLACT
              ENDIF
 30         CONTINUE
            FFC(I)= 0.D0
          ENDIF
 20     CONTINUE
      ENDIF
C
      CALL JEDEMA()
      END
