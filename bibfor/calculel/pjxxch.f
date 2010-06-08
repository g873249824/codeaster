      SUBROUTINE PJXXCH(CORREZ,CH1Z,CH2Z,PRFCHZ,PROL0,LIGREZ,BASE,IRET)
      IMPLICIT NONE
      CHARACTER*(*) CORREZ,CH1Z,CH2Z,PRFCHZ,LIGREZ
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 02/02/2010   AUTEUR PELLET J.PELLET 
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
C-------------------------------------------------------------------
C     BUT : PROJETER UN CHAMP "CH1" SUIVANT "CORRES"
C           POUR CREER "CH2" SUR LA BASE "BASE"
C-------------------------------------------------------------------
C  IRET (OUT)  : = 0    : OK
C                = 1    : PB : ON N' A PAS PU PROJETER LE CHAMP
C                = 10   : ON NE SAIT PAS ENCORE FAIRE
C-------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
C     ------------------------------------------------------------------
      CHARACTER*19 CH1,CH2,PRFCHN,LIGREL
      CHARACTER*16 CORRES,METHOD
      CHARACTER*8 KBID
      CHARACTER*1 BASE
      CHARACTER*(*) PROL0
      INTEGER IRET,IBID,JXXK1


      CALL JEMARQ()
      CORRES=CORREZ
      CH1=CH1Z
      CH2=CH2Z
      PRFCHN=PRFCHZ
      LIGREL=LIGREZ


C     -- GLUTE MODIFICATION STRUCTURALE : (SI CORRES=' ')
      IF (CORRES.NE.' ') THEN
        CALL JEVEUO(CORRES//'.PJXX_K1','L',JXXK1)
        METHOD=ZK24(JXXK1-1+3)
      ELSE
        METHOD='ELEM'
      ENDIF


      IF (METHOD.EQ.'ELEM') THEN
        CALL PJEFCH(CORRES,CH1,CH2,PRFCHN,PROL0,LIGREL,BASE,IRET)
      ELSE IF (METHOD(1:10).EQ.'NUAGE_DEG_') THEN
        CALL PJNGCH(CH1,CH2,CORRES,BASE)
        IRET=0
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

   10 CONTINUE
      CALL JEDEMA()
      END
