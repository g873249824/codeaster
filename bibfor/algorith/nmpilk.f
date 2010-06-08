      SUBROUTINE NMPILK(INCPR1,INCPR2,DDINCC,NEQ   ,ETA,
     &                  RHO   ,OFFSET)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER      NEQ
      REAL*8       ETA,RHO,OFFSET
      CHARACTER*19 INCPR1,INCPR2,DDINCC
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C AJUSTEMENT DE LA DIRECTION DE DESCENTE
C      
C ----------------------------------------------------------------------
C
C CORR = RHO * PRED(1) + (ETA-OFFSET) * PRED(2)
C
C IN  NEQ    : LONGUEUR DES CHAM_NO
C IN  INCPR1 : INCREMENT SOLUTION PHASE PREDICTION 1
C IN  INCPR2 : INCREMENT SOLUTION PHASE PREDICTION 2 (TERME PILOTAGE)
C OUT DDINNC : INCREMENT SOLUTION APRES PILOTAGE/RECH. LINE.
C IN  ETA    : PARAMETRE DE PILOTAGE
C IN  RHO    : PARAMETRE DE RECHERCHE LINEAIRE
C IN  OFFSET : DECALAGE DU PARMAETRE DE PILOTAGE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      I,JDU0,JDU1,JDDEPL      
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CALL JEVEUO(INCPR1(1:19)//'.VALE','L',JDU0)
      CALL JEVEUO(INCPR2(1:19)//'.VALE','L',JDU1)
      CALL JEVEUO(DDINCC(1:19)//'.VALE','E',JDDEPL)
C     
C --- CALCUL
C
      DO 10 I = 1, NEQ
        ZR(JDDEPL+I-1) = RHO*ZR(JDU0+I-1) + (ETA-OFFSET)*ZR(JDU1+I-1)
 10   CONTINUE
C
      CALL JEDEMA()
      END
