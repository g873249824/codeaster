      SUBROUTINE VERIFT(FAMI,KPG,KSP,POUM,IMATE,COMPOR,NDIM,EPSTH,IRET)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 16/10/2007   AUTEUR SALMONA L.SALMONA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*(*) FAMI,POUM,COMPOR  
      REAL*8  EPSTH(*)
      INTEGER KPG,KSP,NDIM,IRET,IMATE
C
C  FAMI : FAMILLE DE POINTS DE GAUSS
C  KPG  : NUMERO DU POINT DE GAUSS
C  KSP  : NUMERO DU SOUS-POINT DE GAUSS
C  POUM : '+' SI TEMPERATURE EN TEMPS +
C         '-' SI TEMPERATURE EN TEMPS -
C         'T' SI TEMPERATURE EN TEMPS + ET -
C IMATE : MATERIAU
C COMPOR : COMPORTEMENT 
C NDIM  : 1 SI ISOTROPE
C         2 SI ISOTROPE TRANSVERSE (OU METALLURGIQUE)
C         3 SI ORTHOTROPE
C EPSTH : DILATATION 
C IRET  : CODE RETOUR CONCERNANT LA TEMPERATURE 0 SI OK 
C                                               1 SI NOOK 


C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------


      CHARACTER*2 CODREM(3),CODREP(3),BL2
      CHARACTER*8 NOMRES(3),VALEK(2)
      INTEGER IRET1,IRET2,IRET3,IND,SOMIRE,IADZI,IAZK24
      REAL*8  TM,TREF,TP,VALREP(3),VALREM(3)
      IRET  = 0
      IRET2 = 0
      IRET3 = 0
      
      BL2 = '  '
      CALL RCVARC(' ','TEMP','REF',FAMI,KPG,KSP,TREF,IRET1)
      
      IF (COMPOR.EQ.'ELAS_META') THEN
        IF (NDIM.EQ.2) THEN
          NOMRES(1) = 'C_ALPHA'
          NOMRES(2) = 'F_ALPHA'
        ENDIF
      ELSE 
        IF (NDIM.EQ.1) THEN
          NOMRES(1) = 'ALPHA'
        ELSEIF (NDIM.EQ.2) THEN
          NOMRES(1) = 'ALPHA_L'
          NOMRES(2) = 'ALPHA_N'
        ELSE
          NOMRES(1) = 'ALPHA_L'
          NOMRES(2) = 'ALPHA_T'
          NOMRES(3) = 'ALPHA_N'
        ENDIF
      ENDIF

      
      
      
      
      IF (POUM.EQ.'T') THEN
      
          CALL RCVARC(' ','TEMP','-',FAMI,KPG,KSP,TM,IRET2)
          CALL RCVALB(FAMI,KPG,KSP,'-',IMATE,' ',COMPOR,0,' ',
     &                0.D0,NDIM,NOMRES,VALREM,CODREM, BL2 )
          CALL RCVARC(' ','TEMP','+',FAMI,KPG,KSP,TP,IRET3)
          CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,' ',COMPOR,0,' ',
     &                0.D0,NDIM,NOMRES,VALREP,CODREP, BL2 )

          SOMIRE = IRET2 + IRET3

          IF (SOMIRE.EQ.0) THEN

            IF (IRET1.EQ.1) THEN
              CALL TECAEL(IADZI,IAZK24)
              VALEK(1) = ZK24(IAZK24-1+3) (1:8)
              CALL U2MESK('F','CALCULEL_8',1,VALEK)
            ENDIF
            DO 5 IND=1,NDIM
              IF ((CODREM(IND).NE.'OK').OR.(CODREP(IND).NE.'OK'))  THEN
                CALL TECAEL(IADZI,IAZK24)
                VALEK(1)= ZK24(IAZK24-1+3) (1:8)
                VALEK(2)=NOMRES(IND)
                CALL U2MESK('F','CALCULEL_15',2,VALEK)
              ENDIF
   5        CONTINUE      

            DO 10 IND=1,NDIM
              EPSTH(IND) = VALREP(IND)*(TP-TREF)-VALREM(IND)*(TM-TREF)
   10       CONTINUE
   
          ELSE 

            DO 20 IND=1,NDIM
              EPSTH(IND) = 0.D0
   20       CONTINUE
   
          ENDIF
     
      ELSE 
          CALL RCVARC(' ','TEMP',POUM,FAMI,KPG,KSP,TM,IRET2)
          CALL RCVALB(FAMI,KPG,KSP,POUM,IMATE,' ',COMPOR,0,' ',
     &                0.D0,NDIM,NOMRES,VALREM,CODREM, BL2 )
          SOMIRE = IRET2 + IRET3

          IF (SOMIRE.EQ.0) THEN

            IF (IRET1.EQ.1) THEN
              CALL TECAEL(IADZI,IAZK24)
              VALEK(1) = ZK24(IAZK24-1+3) (1:8)
              CALL U2MESK('F','CALCULEL_8',1,VALEK)
            ENDIF
            DO 35 IND=1,NDIM
              IF (CODREM(IND).NE.'OK')  THEN
                CALL TECAEL(IADZI,IAZK24)
                VALEK(1)= ZK24(IAZK24-1+3) (1:8)
                VALEK(2)=NOMRES(IND)
                CALL U2MESK('F','CALCULEL_15',2,VALEK)
              ENDIF
   35       CONTINUE      
      
            DO 30 IND=1,NDIM
              EPSTH(IND) = VALREM(IND)*(TM-TREF)
   30       CONTINUE
    
          ELSE 

            DO 40 IND=1,NDIM
              EPSTH(IND) = 0.D0
   40       CONTINUE

          ENDIF
     
      ENDIF

      IF ((IRET2+IRET3).GE.1) IRET = 1
      
      END
