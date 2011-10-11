      SUBROUTINE TE0119(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/10/2011   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C  BUT:  CALCUL DE L'OPTION VERI_CARA_ELEM
C ......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------
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
C --------- FIN  DECLARATIONS NORMALISEES JEVEUX -----------------------

      CHARACTER*8 ALIAS8
      CHARACTER*24 VALK(3)
      INTEGER J1,IBID,IADZI,IAZK24
      REAL*8 EXCENT
      CHARACTER*3 CMOD
C     ------------------------------------------------------------------


C     1. RECUPERATION DU CODE DE LA MODELISATION (CMOD) :
C     ---------------------------------------------------
      CALL TEATTR(' ','S','ALIAS8',ALIAS8,IBID)
      CMOD=ALIAS8(3:5)


C     2. VERIFICATION QUE L'EXCENTREMENT EST NUL POUR
C        CERTAINES MODELISATIONS:
C     --------------------------------------------------
      IF (CMOD.EQ.'Q4G' .OR. CMOD.EQ.'DTG' .OR. CMOD.EQ.'CQ3') THEN
        CALL JEVECH('PCACOQU','L',J1)
        IF (CMOD.EQ.'Q4G' .OR. CMOD.EQ.'DTG') THEN
          EXCENT=ZR(J1-1+5)
        ELSE
          EXCENT=ZR(J1-1+6)
        ENDIF
        IF (EXCENT.NE.0.D0) THEN
          CALL TECAEL(IADZI,IAZK24)
          VALK(1)=ZK24(IAZK24-1+3)(1:8)
          CALL U2MESK('F','CALCULEL2_30',1,VALK)
        ENDIF
      ENDIF


      END
