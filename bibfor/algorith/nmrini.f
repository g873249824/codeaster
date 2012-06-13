      SUBROUTINE NMRINI(SDTIME,SDSTAT,PHASE )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24  SDTIME,SDSTAT
      CHARACTER*1   PHASE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C MESURE DE STATISTIQUES - REMISE A ZERO
C
C ----------------------------------------------------------------------
C
C
C IN  SDSTAT : SD STATISTIQUES
C IN  SDTIME : SD TIMER
C IN  PHASE  : PHASE
C               'N' SUR L'ITERATION DE NEWTON COURANTE
C               'P' SUR LE PAS COURANT
C               'T' SUR TOUT LE TRANSITOIRE   
C
C
C
C
      CHARACTER*24 TIMET,TIMEP,TIMEN
      INTEGER      JTIMET,JTIMEP,JTIMEN
      CHARACTER*24 STVIP,STVIT,STVIN
      INTEGER      JSTVIP,JSTVIT,JSTVIN
      INTEGER      I,NMAXT,NMAXS
      CHARACTER*8  K8BID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES SDTIME
C
      TIMET  = SDTIME(1:19)//'.TIMT'
      TIMEP  = SDTIME(1:19)//'.TIMP'
      TIMEN  = SDTIME(1:19)//'.TIMN'
      CALL JEVEUO(TIMET ,'E',JTIMET)
      CALL JEVEUO(TIMEP ,'E',JTIMEP)
      CALL JEVEUO(TIMEN ,'E',JTIMEN) 
      CALL JELIRA(TIMET ,'LONMAX',NMAXT,K8BID)
C
C --- ACCES SDSTAT
C      
      STVIP  = SDSTAT(1:19)//'.VLIP'
      STVIT  = SDSTAT(1:19)//'.VLIT'
      STVIN  = SDSTAT(1:19)//'.VLIN'
      CALL JEVEUO(STVIP ,'E',JSTVIP)
      CALL JEVEUO(STVIT ,'E',JSTVIT)
      CALL JEVEUO(STVIN ,'E',JSTVIN)
      CALL JELIRA(STVIT ,'LONMAX',NMAXS,K8BID)
C
C --- ENREGISTREMENT DES TEMPS
C      
      IF (PHASE.EQ.'T') THEN
        DO 10 I = 1,NMAXT
          ZR(JTIMET+I-1) = 0.D0
          ZR(JTIMEP+I-1) = 0.D0
          ZR(JTIMEN+I-1) = 0.D0
   10   CONTINUE
        DO 20 I = 1,NMAXS
          ZI(JSTVIT+I-1) = 0
          ZI(JSTVIP+I-1) = 0
          ZI(JSTVIN+I-1) = 0
   20   CONTINUE   
      ELSEIF (PHASE.EQ.'P') THEN
        DO 11 I = 1,NMAXT
          ZR(JTIMEP+I-1) = 0.D0
          ZR(JTIMEN+I-1) = 0.D0
   11   CONTINUE       
        DO 21 I = 1,NMAXS
          ZI(JSTVIP+I-1) = 0
          ZI(JSTVIN+I-1) = 0
   21   CONTINUE
      ELSEIF (PHASE.EQ.'N') THEN
        DO 12 I = 1,NMAXT
          ZR(JTIMEN+I-1) = 0.D0
   12   CONTINUE      
        DO 22 I = 1,NMAXS
          ZI(JSTVIN+I-1) = 0
   22   CONTINUE      
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF    
C
      CALL JEDEMA()
      END
