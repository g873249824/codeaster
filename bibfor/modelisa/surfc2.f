      SUBROUTINE SURFC2(CHAR,NOMA,IFM)
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*8 CHAR
      CHARACTER*8 NOMA
      INTEGER     IFM      
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - AFFICHAGE DONNEES)
C
C AFFICHAGE LES INFOS CONTENUES DANS LA SD CONTACT POUR LA FORMULATION
C CONTINUE
C      
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  IFM    : UNITE D'IMPRESSION
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32  JEXNUM
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
      INTEGER      CFDISI,MMINFI,NZOCO,NNOCO,NMACO
      REAL*8       MMINFR,TOLINT
      LOGICAL      MMINFL,LVERI
      INTEGER      IZONE   
      CHARACTER*24 NOEUMA,MAILMA,DEFICO
      INTEGER      INO,IMA,JDEC,JNOMNO,JNOMMA
      INTEGER      NUMRAC,NRACC,NUMFON,NFOND 
      CHARACTER*8  NOMMAE
      INTEGER      NUMMAE,POSMAE,IMAE,TYPBAR,TYPRAC,JDECME
      INTEGER      NBMAE
      INTEGER      NDEXFR,NPTM
C
      CHARACTER*24 PARACR,PARACI
      INTEGER      JPARCR,JPARCI 
      CHARACTER*24 CARACF  
      INTEGER      JCMCF            
      CHARACTER*24 CONTNO,CONTMA
      INTEGER      JNOCO,JMACO
      CHARACTER*24 BARSNO,PBARS ,BARSMA,PBARM ,RACCNO,PRACC  
      INTEGER      JBARS ,JPBARS,JBARM ,JPBARM,JRACC ,JPRACC      
      INTEGER      CFMMVD,ZCMCF
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ
C
C --- INITIALISATIONS
C
      DEFICO = CHAR(1:8)//'.CONTACT'        
C
C --- ACCES SD DU MAILLAGE
C
      NOEUMA = NOMA(1:8)//'.NOMNOE'
      MAILMA = NOMA(1:8)//'.NOMMAI'      
C   
C --- COMMUNS TOUTES FORMULATIONS 
C 
      PARACR = DEFICO(1:16)//'.PARACR'    
      PARACI = DEFICO(1:16)//'.PARACI'
      CALL JEVEUO(PARACR,'L',JPARCR)
      CALL JEVEUO(PARACI,'L',JPARCI)                
C   
C --- COMMUNS AVEC FORM. MAILLEES (DISCRET ET CONTINUE MAIS PAS XFEM)
C  
      CONTNO = DEFICO(1:16)//'.NOEUCO' 
      CONTMA = DEFICO(1:16)//'.MAILCO'
      CALL JEVEUO(CONTNO,'L',JNOCO )  
      CALL JEVEUO(CONTMA,'L',JMACO )     
C   
C --- SPECIFIQUES FORMULATION CONTINUE
C      
      BARSNO = DEFICO(1:16)//'.BANOCO'
      PBARS  = DEFICO(1:16)//'.PBANOCO'  
      BARSMA = DEFICO(1:16)//'.BAMACO'
      PBARM  = DEFICO(1:16)//'.PBAMACO'
      RACCNO = DEFICO(1:16)//'.RANOCO'
      PRACC  = DEFICO(1:16)//'.PRANOCO'    
      CARACF = DEFICO(1:16)//'.CARACF'      
C
      CALL JEVEUO(BARSNO,'L',JBARS )
      CALL JEVEUO(PBARS ,'L',JPBARS)
      CALL JEVEUO(BARSMA,'L',JBARM )
      CALL JEVEUO(PBARM ,'L',JPBARM)
      CALL JEVEUO(RACCNO,'L',JRACC )
      CALL JEVEUO(PRACC ,'L',JPRACC)  
      CALL JEVEUO(CARACF,'L',JCMCF)
C
      ZCMCF = CFMMVD('ZCMCF')     
C
C --- INITIALISATIONS
C    
      NZOCO  = CFDISI(DEFICO,'NZOCO') 
      NMACO  = CFDISI(DEFICO,'NMACO') 
      NNOCO  = CFDISI(DEFICO,'NNOCO')     
C
C --- CREATION VECTEURS TEMPORAIRES
C      
      CALL WKVECT('&&SURFC2.TRAVNO','V V K8',NZOCO*NNOCO,JNOMNO)
      CALL WKVECT('&&SURFC2.TRAVMA','V V K8',NZOCO*NMACO,JNOMMA)
C
C --- IMPRESSIONS POUR L'UTILISATEUR
C 
      WRITE (IFM,*)      
      WRITE (IFM,*) '<CONTACT> INFOS SPECIFIQUES SUR LA FORMULATION'//
     &              ' CONTINUE'
      WRITE (IFM,*)   
C 
C --- IMPRESSIONS POUR LES PARAMETRES CONSTANTS
C      
      WRITE (IFM,*) '<CONTACT> ... PARAMETRES CONSTANTS SUR TOUTES '//
     &              ' LES ZONES' 
    
      WRITE (IFM,1070) 'AXISYMETRIE     ',ZI(JPARCI+16-1)        
C
 1070 FORMAT (' <CONTACT> ...... PARAM. : ',A16,' - VAL. : ',I5)
 1071 FORMAT (' <CONTACT> ...... PARAM. : ',A16,' - VAL. : ',E12.5)   
C
C --- IMPRESSIONS POUR LES PARAMETRES VARIABLES
C
      WRITE (IFM,*) '<CONTACT> ... PARAMETRES VARIABLES SUIVANT '//
     &              ' LES ZONES' 
      DO 320 IZONE = 1,NZOCO
        WRITE (IFM,*) '<CONTACT> ...... ZONE : ',IZONE 
        LVERI  = MMINFL(DEFICO,'VERIF',IZONE )
        IF (LVERI) THEN
          WRITE (IFM,*) '<CONTACT> ...... ZONE DE VERIFICATION'
          TOLINT = MMINFR(DEFICO,'TOLE_INTERP',IZONE)           
          WRITE (IFM,1071) 'TOLE_INTERP     ',TOLINT          
        ELSE
          WRITE (IFM,*) '<CONTACT> ...... ZONE DE CALCUL'       
          WRITE (IFM,1071) 'INTEGRATION     ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+1-1)
          WRITE (IFM,1071) 'COEF_REGU_CONT  ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+2-1)
          WRITE (IFM,1071) 'COEF_REGU_FROT  ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+3-1)
          WRITE (IFM,1071) 'COULOMB         ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+4-1)
          WRITE (IFM,1071) 'FROTTEMENT      ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+5-1)
          WRITE (IFM,1071) 'SEUIL_INIT      ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+6-1)
          WRITE (IFM,1071) 'COMPLIANCE      ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+7-1)
          WRITE (IFM,1071) 'ASPERITE        ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+8-1)
          WRITE (IFM,1071) 'E_N             ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+9-1)
          WRITE (IFM,1071) 'E_V             ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+10-1)
          WRITE (IFM,1071) 'FOND_FISSURE    ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+11-1)
          WRITE (IFM,1071) 'RACCORD_LINE_QUA',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+12-1)
          WRITE (IFM,1071) 'USURE           ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+13-1)
          WRITE (IFM,1071) 'K               ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+14-1)
          WRITE (IFM,1071) 'H               ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+15-1)
          WRITE (IFM,1071) 'COEF_STAB_CONT  ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+17-1)
          WRITE (IFM,1071) 'COEF_PENA_CONT  ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+18-1)
          WRITE (IFM,1071) 'COEF_STAB_FROT  ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+20-1)
          WRITE (IFM,1071) 'COEF_PENA_CONT  ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+21-1)
          WRITE (IFM,1071) 'EXCLUSION_PIV_NU',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+22-1)
          WRITE (IFM,1071) 'SANS_NOEUD      ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+23-1)
          WRITE (IFM,1071) 'SANS_NOEUD_FR   ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+24-1)
          WRITE (IFM,1071) 'EXCL_FROT_x     ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+25-1)
          WRITE (IFM,1071) 'CONTACT_INIT    ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+26-1)
          WRITE (IFM,1071) 'GLISSIERE       ',
     &                      ZR(JCMCF+ZCMCF*(IZONE-1)+27-1)
        ENDIF
      
 320  CONTINUE  
C
C --- NOEUDS/MAILLES EXCLUS SPECIFIQUES
C
      WRITE (IFM,*) '<CONTACT> ... NOEUDS/MAILLES EXCLUS SPECIFIQUES'
      DO 800 IZONE = 1,NZOCO
C
        WRITE (IFM,*) '<CONTACT> ...... ZONE : ',IZONE 
C              
        NRACC  = ZI(JPRACC+IZONE) - ZI(JPRACC+IZONE-1)
        IF (NRACC.EQ.0) THEN
          WRITE (IFM,*) '<CONTACT> ...... PAS DE NOEUDS DE TYPE '//
     &                  'GROUP_NO_RACC A EXCLURE'
        ELSE
          WRITE (IFM,*) '<CONTACT> ...... NOMBRE DE NOEUDS DE TYPE '//
     &                 'GROUP_NO_RACC A EXCLURE: ',NRACC
C        
          JDEC = ZI(JPRACC+IZONE-1)
          DO 801 INO = 1,NRACC
            NUMRAC = ZI(JRACC+JDEC+INO-1)
            CALL JENUNO(JEXNUM(NOEUMA,NUMRAC),ZK8(JNOMNO+INO-1))
  801     CONTINUE   
C  
          WRITE (IFM,1040) '     LISTE DES NOEUDS  : '
          WRITE (IFM,1050) (ZK8(JNOMNO+INO-1), INO = 1,NRACC)          
        ENDIF
C
        NFOND  = ZI(JPBARS+IZONE) - ZI(JPBARS+IZONE-1)
        IF (NFOND.EQ.0) THEN
          WRITE (IFM,*) '<CONTACT> ...... PAS DE NOEUDS DE TYPE '//
     &                  'GROUP_NO_FOND A EXCLURE'
        ELSE
          WRITE (IFM,*) '<CONTACT> ...... NOMBRE DE NOEUDS DE TYPE '//
     &                 'GROUP_NO_FOND A EXCLURE: ',NFOND
C        
          JDEC = ZI(JPBARS+IZONE-1)
          DO 802 INO = 1,NFOND
            NUMFON = ZI(JBARS+JDEC+INO-1)
            CALL JENUNO(JEXNUM(NOEUMA,NUMFON),ZK8(JNOMNO+INO-1))
  802     CONTINUE   
C  
          WRITE (IFM,1040) '     LISTE DES NOEUDS  : '
          WRITE (IFM,1050) (ZK8(JNOMNO+INO-1), INO = 1,NFOND)
        ENDIF  
C
        NFOND  = ZI(JPBARM+IZONE) - ZI(JPBARM+IZONE-1)
        IF (NFOND.EQ.0) THEN
          WRITE (IFM,*) '<CONTACT> ...... PAS DE MAILLES DE TYPE '//
     &                  'GROUP_MA_FOND A EXCLURE'
        ELSE
          WRITE (IFM,*) '<CONTACT> ...... NOMBRE DE MAILLES DE TYPE '//
     &                 'GROUP_MA_FOND A EXCLURE: ',NFOND
C        
          JDEC = ZI(JPBARM+IZONE-1)
          DO 803 IMA = 1,NFOND
            NUMFON = ZI(JBARM+JDEC+IMA-1)
            CALL JENUNO(JEXNUM(MAILMA,NUMFON),ZK8(JNOMMA+IMA-1))
  803     CONTINUE   
C  
          WRITE (IFM,1040) '     LISTE DES MAILLES : '
          WRITE (IFM,1050) (ZK8(JNOMMA+IMA-1), IMA = 1,NFOND)      
C                  
        ENDIF
 800  CONTINUE
C
 1040 FORMAT (' <CONTACT> ...... ',A25)       
 1050 FORMAT ((' <CONTACT> ...... ',17X,4(A8,1X)))
C
C ---  MAILLES ESCLAVES SPECIFIQUES
C
      WRITE (IFM,*) '<CONTACT> ... INFORMATIONS SUR MAILLES ESCLAVES' 
C
      DO 900 IZONE = 1,NZOCO
        WRITE (IFM,*) '<CONTACT> ...... ZONE : ',IZONE    
        JDECME = MMINFI(DEFICO,'JDECME',IZONE )
        NBMAE  = MMINFI(DEFICO,'NBMAE' ,IZONE )
        DO 901 IMAE = 1,NBMAE
          POSMAE = JDECME + IMAE
          
          CALL MMINFM(POSMAE,DEFICO,'NPTM',NPTM  )
          CALL CFNUMM(DEFICO,1     ,POSMAE,NUMMAE)          
          CALL JENUNO(JEXNUM(MAILMA,NUMMAE),NOMMAE)
          WRITE (IFM,1080) NOMMAE
          
          WRITE (IFM,1070) 'ZONE            ',IZONE
          WRITE (IFM,1070) 'NB. PTS. INT.   ',NPTM
          
          CALL MMINFM(POSMAE,DEFICO,'TYPBAR',TYPBAR) 
          
          IF (TYPBAR.EQ.0) THEN
            WRITE (IFM,1040) 'PAS DE FOND. FISS.'
          ELSEIF (TYPBAR.EQ.1) THEN
            WRITE (IFM,1040) 'QUAD 8 - FOND. FISS. 1/2'
          ELSEIF (TYPBAR.EQ.2) THEN
            WRITE (IFM,1040) 'QUAD 8 - FOND. FISS. 2/3'
          ELSEIF (TYPBAR.EQ.3) THEN
            WRITE (IFM,1040) 'QUAD 8 - FOND. FISS. 3/4'
          ELSEIF (TYPBAR.EQ.4) THEN
            WRITE (IFM,1040) 'QUAD 8 - FOND. FISS. 4/1'
          ELSEIF (TYPBAR.EQ.5) THEN
            WRITE (IFM,1040) 'SEG  3 - FOND. FISS. 1'
          ELSEIF (TYPBAR.EQ.6) THEN
            WRITE (IFM,1040) 'SEG  3 - FOND. FISS. 2' 
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF   
               
          CALL MMINFM(POSMAE,DEFICO,'TYPRAC',TYPRAC)
          
          IF (TYPRAC.EQ.0) THEN
            WRITE (IFM,1040) 'PAS RACC. LINE. QUAD.'
          ELSEIF (TYPRAC.EQ.1) THEN
            WRITE (IFM,1040) 'NOEUD 5 EXCLU'
          ELSEIF (TYPRAC.EQ.2) THEN
            WRITE (IFM,1040) 'NOEUD 6 EXCLU'
          ELSEIF (TYPRAC.EQ.3) THEN
            WRITE (IFM,1040) 'NOEUD 7 EXCLU'
          ELSEIF (TYPRAC.EQ.4) THEN
            WRITE (IFM,1040) 'NOEUD 8 EXCLU'
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF 
          
          CALL MMINFM(POSMAE,DEFICO,'NDEXFR',NDEXFR)
          
          WRITE (IFM,1070) 'NDEXFR          ',NDEXFR          

          
 901    CONTINUE
 900  CONTINUE  
 1080 FORMAT (' <CONTACT> ... MAILLE : ',A8) 
C
C --- MENAGE
C
      CALL JEDETR('&&SURFC2.TRAVNO')
      CALL JEDETR('&&SURFC2.TRAVMA')      
C
      CALL JEDEMA
      END
