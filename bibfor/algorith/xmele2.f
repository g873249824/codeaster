      SUBROUTINE XMELE2(NOMA  ,MODELE,DEFICO,LIGREL,NFISS ,
     &                  CHELEM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/04/2007   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT      NONE
      CHARACTER*8   NOMA
      CHARACTER*8   MODELE 
      INTEGER       NFISS    
      CHARACTER*19  CHELEM      
      CHARACTER*19  LIGREL
      CHARACTER*24  DEFICO
C 
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM - CREATION CHAM_ELEM)
C
C CREATION DU CHAM_ELEM PDONCO (DONNEES DU CONTACT)
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  MODELE : NOM DU MODELE
C IN  NFISS  : NOMBRE TOTAL DE FISSURES
C IN  LIGREL : NOM DU LIGREL DES MAILLES TARDIVES
C IN  CHELEM : NOM DU CHAM_ELEM CREEE
C IN  DEFICO : SD CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER       NBCMP
      PARAMETER     (NBCMP = 5)
      CHARACTER*8   LICMP(NBCMP)
C
      INTEGER       IFM,NIV  
      INTEGER       IBID,IAD,IGRP,I,IMA,IFIS,IZONE,XXCONI
      INTEGER       NMAENR
      CHARACTER*8   NOMFIS
      INTEGER       JCESL,JCESV,JCESD,JMOFIS
      CHARACTER*24  GRP(3),XINDIC
      INTEGER       JGRP,JINDIC   
      CHARACTER*19  CHELSI    
      CHARACTER*24  K24BLA
      LOGICAL       LBID
      REAL*8        COCAUR,COEFRO,COFAUR,INTEGR,COECHE
      CHARACTER*19  VALK(2)
      INTEGER       VALI(1)      
C
      DATA LICMP    /'RHON','MU','RHOTK','INTEG','COECH'/       
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)     
C
C --- AFFICHAGE
C      
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<XFEM  > CREATION DU CHAM_ELEM PDONCO' 
      ENDIF 
C
C --- INITIALISATIONS
C 
      CHELSI = '&&XMELE2.CES' 
      K24BLA = ' '       
C
C --- CREATION DU CHAM_ELEM_S
C        
      CALL CESCRE('V',CHELSI,'ELEM',NOMA,'XCONTAC',NBCMP,LICMP,
     &            -1,-1,-NBCMP)
C     
C --- ACCES AU CHAM_ELEM_S
C
      CALL JEVEUO(CHELSI//'.CESD','L',JCESD)
      CALL JEVEUO(CHELSI//'.CESL','E',JCESL)
      CALL JEVEUO(CHELSI//'.CESV','E',JCESV)
C
C --- ACCES AUX FISSURES
C      
      CALL JEVEUO(MODELE//'.FISS','L',JMOFIS)      
C 
C --- ENRICHISSEMENT DU CHAM_ELEM POUR LA MULTIFISSURATION
C
      DO 110 IFIS = 1,NFISS
C
C --- ACCES FISSURE COURANTE
C        
        NOMFIS = ZK8(JMOFIS-1 + IFIS)      
C
C --- INFORMATIONS SUR LA FISSURE
C            
        GRP(1) = NOMFIS(1:8)//'.MAILFISS  .HEAV'
        GRP(2) = NOMFIS(1:8)//'.MAILFISS  .CTIP'
        GRP(3) = NOMFIS(1:8)//'.MAILFISS  .HECT'
C
C --- ZONE DE CONTACT IZONE CORRESPONDANTE
C
        IZONE  = XXCONI(DEFICO,NOMFIS,'MAIT')          
C
C --- CARACTERISTIQUES DU CONTACT POUR LA FISSURE EN COURS
C
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'COEF_REGU_CONT',
     &              IBID  ,COCAUR,K24BLA,LBID)        
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'COEF_COULOMB',
     &              IBID  ,COEFRO,K24BLA,LBID) 
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'COEF_REGU_FROT',
     &              IBID  ,COFAUR,K24BLA,LBID) 
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'INTEGRATION',
     &              IBID  ,INTEGR,K24BLA,LBID)
        CALL MMINFP(IZONE ,DEFICO,K24BLA,'COEF_ECHELLE',
     &              IBID  ,COECHE,K24BLA,LBID)
C
C --- ACCES AU CHAMP INDICATEUR    
C    
        XINDIC = NOMFIS(1:8)//'.MAILFISS .INDIC'
        CALL JEVEUO(XINDIC,'L',JINDIC)
C        
        DO 1000 IGRP = 1,3
C
C --- ON COPIE LES CHAMPS CORRESP. AUX ELEM. HEAV, CTIP ET HECT
C
          IF (ZI(JINDIC-1+2*(IGRP-1)+1).EQ.1) THEN
            CALL JEVEUO(GRP(IGRP),'L',JGRP)
            NMAENR = ZI(JINDIC-1+2*IGRP)
            DO 120 I = 1,NMAENR
              IMA = ZI(JGRP-1+I)
C              
              CALL CESEXI('C',JCESD,JCESL,IMA,1,1,1,IAD)
              IF (IAD.GE.0) THEN
                VALI(1) = 1
                VALK(1) = CHELSI(1:19)
                VALK(2) = 'ELEM'
                CALL U2MESG('F','CATAELEM_20',2,VALK,1,VALI,0,0.D0)
              ENDIF
              ZL(JCESL-1-IAD) = .TRUE.
              ZR(JCESV-1-IAD) = COCAUR
C
              CALL CESEXI('C',JCESD,JCESL,IMA,1,1,2,IAD)
              IF (IAD.GE.0) THEN
                VALI(1) = 2
                VALK(1) = CHELSI(1:19)
                VALK(2) = 'ELEM'
                CALL U2MESG('F','CATAELEM_20',2,VALK,1,VALI,0,0.D0)
              ENDIF
              ZL(JCESL-1-IAD) = .TRUE.
              ZR(JCESV-1-IAD) = COEFRO
C
              CALL CESEXI('C',JCESD,JCESL,IMA,1,1,3,IAD)
              IF (IAD.GE.0) THEN
                VALI(1) = 3
                VALK(1) = CHELSI(1:19)
                VALK(2) = 'ELEM'
                CALL U2MESG('F','CATAELEM_20',2,VALK,1,VALI,0,0.D0)
              ENDIF
              ZL(JCESL-1-IAD) = .TRUE.
              ZR(JCESV-1-IAD) = COFAUR
C
              CALL CESEXI('C',JCESD,JCESL,IMA,1,1,4,IAD)
              IF (IAD.GE.0) THEN
                VALI(1) = 4
                VALK(1) = CHELSI(1:19)
                VALK(2) = 'ELEM'
                CALL U2MESG('F','CATAELEM_20',2,VALK,1,VALI,0,0.D0)
              ENDIF
              ZL(JCESL-1-IAD) = .TRUE.
              ZR(JCESV-1-IAD) = INTEGR
C
              CALL CESEXI('C',JCESD,JCESL,IMA,1,1,5,IAD)
              IF (IAD.GE.0) THEN
                VALI(1) = 5
                VALK(1) = CHELSI(1:19)
                VALK(2) = 'ELEM'
                CALL U2MESG('F','CATAELEM_20',2,VALK,1,VALI,0,0.D0)
              ENDIF
              ZL(JCESL-1-IAD) = .TRUE.
              ZR(JCESV-1-IAD) = COECHE
 120       CONTINUE
          ENDIF
 1000    CONTINUE    

 110  CONTINUE
C
C --- CONVERSION CHAM_ELEM_S -> CHAM_ELEM
C
      CALL CESCEL(CHELSI,LIGREL,'RIGI_CONT','PDONCO','OUI',IBID,
     &            'V',CHELEM)
C
C --- DESTRUCTION DU CHAM_ELEM_S
C  
      CALL DETRSD('CHAM_ELEM_S',CHELSI)    
C
      CALL JEDEMA()
C   
      END
