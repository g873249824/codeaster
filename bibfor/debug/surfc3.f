      SUBROUTINE SURFC3(CHAR  ,NOMA  ,IFM  )
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF DEBUG  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C 
      IMPLICIT NONE
      CHARACTER*8 NOMA,CHAR
      INTEGER     IFM      
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE XFEM   - AFFICHAGE DONNEES)
C
C AFFICHAGE LES INFOS CONTENUES DANS LA SD CONTACT POUR LA FORMULATION
C XFEM
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  IFM    : UNITE D'IMPRESSION
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C 
      CHARACTER*32 JEXNUM
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      CFMMVD,ZCMXF,ZMESX
      LOGICAL      LTFCM,CFDISL
      INTEGER      CFDISI
      INTEGER      NZOCO
      INTEGER      IZONE,STATUT
      CHARACTER*24 MAILMA,DEFICO 
      CHARACTER*8  NOMMAE,NOMZON
      INTEGER      IMAE,NTMAE,NUMMAE
C
      CHARACTER*24 PARACI
      INTEGER      JPARCI   
C
      CHARACTER*24 CARAXF,MAESCX  
      INTEGER      JCMXF ,JMAESX
C      
C      CHARACTER*24 XFIESC,XSIESC,XSIMAI
C      INTEGER      JFIESC,JSIESC,JSIMAI
      CHARACTER*24 XFIMAI
      INTEGER      JFIMAI      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ
C
C --- INITIALISATIONS
C
      DEFICO = CHAR(1:8)//'.CONTACT'      
      PARACI = DEFICO(1:16)//'.PARACI'    
      CALL JEVEUO(PARACI,'L',JPARCI)        
      NZOCO  = CFDISI(DEFICO,'NZOCO')  
      LTFCM  = CFDISL(DEFICO,'CONT_XFEM_GG')
      NTMAE  = CFDISI(DEFICO,'NTMAE')
C
C --- ACCES SD DU MAILLAGE
C
      MAILMA = NOMA(1:8)//'.NOMMAI'       
C   
C --- COMMUNS AVEC FORM. CONTINUE
C 
      CARAXF = DEFICO(1:16)//'.CARAXF'
      CALL JEVEUO(CARAXF,'L',JCMXF)      
C     
      ZCMXF = CFMMVD('ZCMXF')       
C
C --- SPECIFIQUES XFEM
C 
C     XFIESC = DEFICO(1:16)//'.XFIESC'   
C     XSIESC = DEFICO(1:16)//'.XSIESC'   
C     XSIMAI = DEFICO(1:16)//'.XSIMAI' 
      XFIMAI = DEFICO(1:16)//'.XFIMAI'  
C
      CALL JEVEUO(XFIMAI,'L',JFIMAI)  
C     CALL JEVEUO(XFIESC,'L',JFIESC)       
C     CALL JEVEUO(XSIESC,'L',JSIESC) 
C     CALL JEVEUO(XSIMAI,'L',JSIMAI)  
     
C
C --- IMPRESSIONS POUR L'UTILISATEUR
C 
      WRITE (IFM,*)      
      WRITE (IFM,*) '<CONTACT> INFOS SPECIFIQUES SUR LA FORMULATION'//
     &              ' XFEM'
      WRITE (IFM,*)
C      
      WRITE (IFM,*) '<CONTACT> ... ZONES XFEM.'
      DO 610 IZONE = 1,NZOCO
        WRITE (IFM,*) '<CONTACT> ...... ZONE : ',IZONE          
        WRITE (IFM,1010) ZK8(JFIMAI-1+IZONE) 
C        WRITE (IFM,1011) ZI(JSIMAI-1+IZONE) 
C       WRITE (IFM,1090) ZK8(JFIESC-1+IZONE) 
C       WRITE (IFM,1091) ZI(JSIESC-1+IZONE)         
 610  CONTINUE 
C      
 1010 FORMAT (' <CONTACT> ...... FISS. MAITRE : ',A18)             
C
C --- IMPRESSIONS POUR LES PARAMETRES VARIABLES
C
      WRITE (IFM,*) '<CONTACT> ... PARAMETRES VARIABLES SUIVANT '//
     &              ' LES ZONES' 
      DO 320 IZONE = 1,NZOCO
        WRITE (IFM,*) '<CONTACT> ...... ZONE : ',IZONE   
               
      WRITE (IFM,1071) 'INTEGRATION     ',ZR(JCMXF+ZCMXF*(IZONE-1)+1-1)
      WRITE (IFM,1071) 'COEF_REGU_CONT  ',ZR(JCMXF+ZCMXF*(IZONE-1)+2-1)
      WRITE (IFM,1071) 'COEF_REGU_FROT  ',ZR(JCMXF+ZCMXF*(IZONE-1)+3-1)
      WRITE (IFM,1071) 'COEF_STAB_CONT  ',ZR(JCMXF+ZCMXF*(IZONE-1)+11-1)
      WRITE (IFM,1071) 'COEF_PENA_CONT  ',ZR(JCMXF+ZCMXF*(IZONE-1)+12-1)
      WRITE (IFM,1071) 'COEF_STAB_FROT  ',ZR(JCMXF+ZCMXF*(IZONE-1)+13-1)
      WRITE (IFM,1071) 'COEF_PENA_CONT  ',ZR(JCMXF+ZCMXF*(IZONE-1)+14-1)
      WRITE (IFM,1071) 'FROTTEMENT      ',ZR(JCMXF+ZCMXF*(IZONE-1)+5-1)
      WRITE (IFM,1071) 'COULOMB         ',ZR(JCMXF+ZCMXF*(IZONE-1)+4-1)
      WRITE (IFM,1071) 'SEUIL_INIT      ',ZR(JCMXF+ZCMXF*(IZONE-1)+6-1)
      WRITE (IFM,1071) 'CONTACT_INIT    ',ZR(JCMXF+ZCMXF*(IZONE-1)+7-1)
      WRITE (IFM,1071) 'COEF_ECHELLE    ',ZR(JCMXF+ZCMXF*(IZONE-1)+8-1)
      WRITE (IFM,1071) 'ALGO_LAGR       ',ZR(JCMXF+ZCMXF*(IZONE-1)+9-1)
      WRITE (IFM,1071) 'GLISSIERE       ',ZR(JCMXF+ZCMXF*(IZONE-1)+10-1)
 320  CONTINUE  
C
C ---  MAILLES ESCLAVES SPECIFIQUES
C
      IF (LTFCM) THEN
        MAESCX = DEFICO(1:16)//'.MAESCX'
        ZMESX  = CFMMVD('ZMESX')
        CALL JEVEUO(MAESCX,'L',JMAESX) 
        WRITE (IFM,*) '<CONTACT> ... INFORMATIONS SUR MAILLES ESCLAVES' 
        DO 900 IZONE = 1,NZOCO
          NOMZON = ZK8(JFIMAI-1+IZONE)
          WRITE (IFM,*) '<CONTACT> ...... ZONE : ',IZONE 
          WRITE (IFM,1010) NOMZON
          DO 901 IMAE = 1,NTMAE

            NUMMAE = ZI(JMAESX+ZMESX*(IMAE-1)+1-1)
            CALL JENUNO(JEXNUM(MAILMA,NUMMAE),NOMMAE)
            WRITE (IFM,1080) NOMMAE
            
          
            WRITE (IFM,1070) 'ZONE            ',
     &           ZI(JMAESX+ZMESX*(IMAE-1)+2-1)
            WRITE (IFM,1070) 'NB. PTS. INT.   ',          
     &           ZI(JMAESX+ZMESX*(IMAE-1)+3-1)

            STATUT = ZI(JMAESX+ZMESX*(IMAE-1)+1-1)
     
            IF (STATUT.EQ.0) THEN
              WRITE (IFM,1040) 'PAS DE FOND. FISS.'
            ELSEIF (STATUT.EQ.1) THEN
              WRITE (IFM,1040) 'HEAVISIDE'
            ELSEIF (STATUT.EQ.-2) THEN
              WRITE (IFM,1040) 'CRACK-TIP'
            ELSEIF (STATUT.EQ.3) THEN
              WRITE (IFM,1040) 'HEAVISIDE + CRACK-TIP'     
            ELSE
              WRITE (IFM,1070) 'STATUT          ',STATUT
            ENDIF  
               
          

          
 901      CONTINUE
 900    CONTINUE  
      ENDIF
C 
 1040 FORMAT (' <CONTACT> ...... ',A25)    
 1070 FORMAT (' <CONTACT> ...... PARAM. : ',A16,' - VAL. : ',I5)
 1071 FORMAT (' <CONTACT> ...... PARAM. : ',A16,' - VAL. : ',E12.5) 
 1080 FORMAT (' <CONTACT> ... MAILLE : ',A8)
C
      CALL JEDEMA
      END
