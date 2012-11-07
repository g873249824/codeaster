      SUBROUTINE NMSUIV(NOMA  ,SDSUIV,SDIMPR,SDDYNA,VALINC,
     &                  VEASSE,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/11/2012   AUTEUR LADIER A.LADIER 
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
      IMPLICIT     NONE
      CHARACTER*24 SDIMPR
      CHARACTER*8  NOMA
      CHARACTER*19 SDDYNA,SDSUIV
      CHARACTER*19 VALINC(*),VEASSE(*)
      CHARACTER*24 RESOCO   
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (STRUCTURES DE DONNES - SUIVI_DDL)
C
C REALISER UN SUIVI_DDL
C
C ----------------------------------------------------------------------
C
C
C IN  SDIMPR : SD AFFICHAGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  SDSUIV : NOM DE LA SD POUR SUIVI_DDL
C IN  SDDYNA : SD DYNAMIQUE
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER      ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8       ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16   ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL      ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16    ZK16
      CHARACTER*24        ZK24
      CHARACTER*32            ZK32
      CHARACTER*80                ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      CHARACTER*24 LISTNO,LISTMA,LISTPI,LISTSP,LISTCP
      INTEGER      JNO   ,JMA   
      CHARACTER*24 SUIINF,SUICHA,SUITYP
      INTEGER      JSUIIN,JSUICH,JSUITY
      INTEGER      NBCMP,NBNO,NBMA,NBCHAM
      INTEGER      NBPI,NBSPI
      INTEGER      IOCC,NBOCC
      INTEGER      ISUIV,ICHAM
      CHARACTER*2  CHAINE
      CHARACTER*24 NOMCHA,NOMCHS
      CHARACTER*4  TYPCHA
      CHARACTER*19 CHAMP,K19BLA
      CHARACTER*8  EXTRCP,EXTRCH,EXTRGA,K8BID 
      CHARACTER*19 CHGAUS,CHNOEU,CHELGA 
      CHARACTER*19 DEPPLU,SIGPLU,VARPLU,ACCPLU,VITPLU
      CHARACTER*19 DEPENT,VITENT,ACCENT,CNFINT
      LOGICAL      NDYNLO,LMUAP      
C      
C ----------------------------------------------------------------------
C      
      CALL JEMARQ()
C
C --- FONCTIONNALITES ACTIVEES
C     
      LMUAP  = NDYNLO(SDDYNA,'MULTI_APPUI')
C
C --- INITIALISATIONS
C      
      DEPENT = ' '
      VITENT = ' '
      ACCENT = ' '
      K19BLA = ' '
      ISUIV  = 1
C
C --- VARIABLES CHAPEAUX
C       
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU)
      CALL NMCHEX(VALINC,'VALINC','VITPLU',VITPLU)
      CALL NMCHEX(VALINC,'VALINC','ACCPLU',ACCPLU)
      CALL NMCHEX(VALINC,'VALINC','SIGPLU',SIGPLU)
      CALL NMCHEX(VALINC,'VALINC','VARPLU',VARPLU)
      CALL NMCHEX(VEASSE,'VEASSE','CNFINT',CNFINT) 
      IF (LMUAP) THEN
        CALL NDYNKK(SDDYNA,'DEPENT',DEPENT)
        CALL NDYNKK(SDDYNA,'VITENT',VITENT)
        CALL NDYNKK(SDDYNA,'ACCENT',ACCENT) 
      ENDIF      
C
C --- SD PRINCIPALE (INFO)
C
      SUIINF = SDSUIV(1:14)//'     .INFO'
      CALL JEVEUO(SUIINF,'L',JSUIIN)
      NBOCC  = ZI(JSUIIN-1+1)
      CALL ASSERT(NBOCC.LE.99)
      IF (NBOCC.EQ.0) GOTO 999
C
C --- SD LISTE DES CHAMPS
C     
      SUICHA = SDSUIV(1:14)//'     .CHAM'
      CALL JEVEUO(SUICHA,'L',JSUICH)
      CALL JELIRA(SUICHA,'LONMAX',NBCHAM,K8BID)
      NBCHAM = NBCHAM / 2
C
C --- SD TYPE D'EXTRACTIONS
C     
      SUITYP = SDSUIV(1:14)//'     .EXTR'
      CALL JEVEUO(SUITYP,'L',JSUITY)     
C
      DO 10 IOCC = 1 , NBOCC
C
C ----- GENERATION NOM DES SD
C      
        CALL IMPFOI(0,2,IOCC,CHAINE)
        LISTNO = SDSUIV(1:14)//CHAINE(1:2)//'   .NOEU'
        LISTMA = SDSUIV(1:14)//CHAINE(1:2)//'   .MAIL'
        LISTPI = SDSUIV(1:14)//CHAINE(1:2)//'   .POIN'
        LISTSP = SDSUIV(1:14)//CHAINE(1:2)//'   .SSPI'
        LISTCP = SDSUIV(1:14)//CHAINE(1:2)//'   .CMP '
C
C ----- NOM DU CHAMP
C  
        ICHAM  = ZI(JSUIIN+3+7*(IOCC-1)+7-1)
        NOMCHA = ZK24(JSUICH+2*(ICHAM-1)+1-1)
        NOMCHS = ZK24(JSUICH+2*(ICHAM-1)+2-1)
        IF (NOMCHA.EQ.'NONE') GOTO 99
C
C ----- TYPE DE CHAMP      
C
        CALL NMEXTT(NOMCHA,TYPCHA)
C
C ----- RECUPERATION DU CHAMP
C
        CALL NMEXTD(NOMCHA,RESOCO,DEPPLU,VITPLU,ACCPLU,
     &              SIGPLU,VARPLU,DEPENT,VITENT,ACCENT,
     &              K19BLA,CNFINT,CHAMP )
C
C ----- NOMBRE DE COMPOSANTES/NOEUDS/MAILLES
C
        NBCMP  = ZI(JSUIIN-1+4+7*(IOCC-1)-1+1)
        NBNO   = ZI(JSUIIN-1+4+7*(IOCC-1)-1+2)
        NBMA   = ZI(JSUIIN-1+4+7*(IOCC-1)-1+3)
        NBPI   = ZI(JSUIIN-1+4+7*(IOCC-1)-1+4)
        NBSPI  = ZI(JSUIIN-1+4+7*(IOCC-1)-1+5)
C
C ----- ACCES LISTES
C
        IF (TYPCHA.EQ.'NOEU') CALL JEVEUO(LISTNO,'L',JNO)
        IF (TYPCHA.EQ.'ELGA') CALL JEVEUO(LISTMA,'L',JMA)
C
C ----- TYPES D'EXTRACTION
C
        EXTRCH = ZK8(JSUITY+3*(IOCC-1)+1-1)
        EXTRGA = ZK8(JSUITY+3*(IOCC-1)+2-1)
        EXTRCP = ZK8(JSUITY+3*(IOCC-1)+3-1)
C
C ----- SD DONNEES TEMPORAIRES
C 
        CHELGA = '&&NMSUIV.VALE.ELGA'
        CHGAUS = '&&NMSUIV.VALE.GAUS' 
        CHNOEU = '&&NMSUIV.VALE.NOEU'
        CALL NMEXT0(TYPCHA,NBMA  ,NBNO  ,NBPI  ,NBSPI ,
     &              NBCMP ,CHNOEU,CHGAUS,CHELGA,EXTRGA,
     &              EXTRCH)
C
C ----- EXTRAIRE LES VALEURS
C   
        CALL NMEXT1(NOMA  ,CHAMP ,TYPCHA,NOMCHA,NOMCHS,
     &              NBMA  ,NBNO  ,NBPI  ,NBSPI ,NBCMP ,
     &              EXTRGA,EXTRCH,EXTRCP,LISTNO,LISTMA,
     &              LISTPI,LISTSP,LISTCP,CHNOEU,CHGAUS,
     &              CHELGA) 
C
C ----- LES ECRIRE DANS LE TABLEAU
C
        CALL NMSUI3(SDIMPR,TYPCHA,NBMA  ,NBNO  ,NBPI  ,
     &              NBSPI ,NBCMP ,EXTRCH,EXTRCP,EXTRGA,
     &              LISTMA,CHNOEU,CHELGA,CHAMP ,ISUIV )
C
        CALL JEDETR(CHGAUS)
        CALL JEDETR(CHNOEU)        
        CALL JEDETR(CHELGA)
C
 99     CONTINUE

 10   CONTINUE
C
C --- DESTRUCTION DES CHAM_ELEM_S
C
      DO 45 ICHAM = 1,NBCHAM
        NOMCHS = ZK24(JSUICH+2*(ICHAM-1)+2-1)
        CALL JEDETR(NOMCHS)
  45  CONTINUE
 999  CONTINUE  
C
      CALL JEDEMA()
      END
