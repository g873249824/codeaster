      SUBROUTINE ARLICP(ICPL  ,JQMAMA,JGRP1  ,JGRP2  ,
     &                  NUMMC1,NUMMC2,LINCL1,LINCL2)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
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
      INTEGER  JQMAMA
      INTEGER  JGRP1,JGRP2       
      INTEGER  ICPL,NUMMC1,NUMMC2 
      LOGICAL  LINCL1,LINCL2
C       
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C INFO. SUR COUPLE DE MAILLES 
C
C ----------------------------------------------------------------------
C
C
C ATTENTION - RETOUR D'INFO. SUR MAILLAGE ET NON PSEUDO-MAILLAGE !!!
C
C IN  ICPL   : NUMERO DU COUPLE
C IN  JQMAMA : POINTEUR SUR QUAD.MAMA 
C                 (LISTE DES COUPLES DE MAILLES A INTEGRER)
C IN  JGRP1  : POINTEUR SUR GROUPE 1 ARLEQUIN
C IN  JGRP2  : POINTEUR SUR GROUPE 2 ARLEQUIN 
C OUT NUMMC1 : NUMERO ABSOLU DE LA MAILLE COUPLEE 1 DANS MAILLAGE 
C OUT NUMMC2 : NUMERO ABSOLU DE LA MAILLE COUPLEE 2 DANS MAILLAGE 
C                VAUT ZERO SI UNE SEULE MAILLE COUPLEE 
C                SINON LA MAILLE SUPPORT EST UNE MAILLE
C                   DE DECOUPE 'VIRTUELLE'
C OUT LINCL1 : INCLUSION DANS LA MAILLE 1
C OUT LINCL2 : INCLUSION DANS LA MAILLE 2
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C   
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C      
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      IMA1,IMA2,AIMA
      LOGICAL      LBID,LINCLU
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      NUMMC1 = 0
      NUMMC2 = 0            
C
C --- ACCES AU COUPLE
C      
      IMA1 = ZI(JQMAMA+2*(ICPL-1))
      IMA2 = ZI(JQMAMA+2*(ICPL-1)+1)
C
C --- TYPE D'INTEGRATION
C         
      CALL ARLTII(IMA1  ,IMA2   ,
     &            LINCL1,LINCL2 ,LINCLU,LBID  ) 
C
C --- SOUS-INTEGRATION
C      
      IF (LINCLU) THEN
        IF (LINCL1) THEN
          AIMA   = ABS(IMA2) 
          NUMMC1 = ZI(JGRP2-1+AIMA )      
        ELSEIF (LINCL2) THEN
          AIMA   = ABS(IMA1) 
          NUMMC1 = ZI(JGRP1-1+AIMA )    
        ELSE
          CALL ASSERT(.FALSE.)        
        ENDIF
        NUMMC2 = 0  
      ELSE
        AIMA   = ABS(IMA1) 
        NUMMC1 = ZI(JGRP1-1+AIMA )  
        AIMA   = ABS(IMA2) 
        NUMMC2 = ZI(JGRP2-1+AIMA ) 
      ENDIF
C
      CALL JEDEMA()      
C
      END
