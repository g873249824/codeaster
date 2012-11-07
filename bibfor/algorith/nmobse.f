      SUBROUTINE NMOBSE(NOMA  ,SDOBSE,RESOCO,NUMINS,INSTAN,
     &                  DEPPLU,VITPLU,ACCPLU,SIGPLU,VARPLU,
     &                  DEPENT,VITENT,ACCENT,CNFINT,TEMP  )
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
      IMPLICIT      NONE
      CHARACTER*8   NOMA
      CHARACTER*19  SDOBSE
      CHARACTER*24  RESOCO
      CHARACTER*19  DEPPLU,SIGPLU,VARPLU,ACCPLU,VITPLU
      CHARACTER*19  DEPENT,VITENT,ACCENT,CNFINT
      CHARACTER*19  TEMP
      INTEGER       NUMINS
      REAL*8        INSTAN
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (OBSERVATION)
C
C REALISER LES OBSERVATIONS
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  SDOBSE : SD OBSERVATION
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  DEPPLU : DEPLACEMENT
C IN  VITPLU : VITESSE
C IN  ACCPLU : ACCELERATION
C IN  SIGPLU : CONTRAINTES
C IN  VARPLU : VARIABLES INTERNES
C IN  DEPENT : DEPLACEMENT D'ENTRAINEMENT (MULTI-APPUI)
C IN  VITENT : VITESSE D'ENTRAINEMENT (MULTI-APPUI)
C IN  ACCENT : ACCELERATION D'ENTRAINEMENT (MULTI-APPUI)
C IN  CNFINT : VECT_ASSE DES FORCES INTERNES
C IN  TEMP   : TEMPERATURE
C IN  NUMINS : NUMERO DE L'INSTANT COURANT
C IN  INSTAN : INSTANT COURANT
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
      CHARACTER*24 OBSINF,OBSCHA,OBSTYP,OBSACT
      INTEGER      JOBSIN,JOBSCH,JOBSTY,JOBSAC
      CHARACTER*24 OBSTAB
      INTEGER      JOBST      
      CHARACTER*19 NOMTAB
      INTEGER      NBCMP,NBNO,NBMA,NBCHAM
      INTEGER      NBPI,NBSPI
      INTEGER      IOCC,NBOCC
      INTEGER      NOBSEF,ICHAM
      CHARACTER*2  CHAINE
      CHARACTER*24 NOMCHA,NOMCHS
      CHARACTER*4  TYPCHA
      CHARACTER*19 CHAMP
      CHARACTER*8  EXTRCP,EXTRCH,EXTRGA,K8BID
      CHARACTER*19 CHGAUS,CHNOEU,CHELGA
      LOGICAL      LOBSV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- SD POUR LE NOM DE LA TABLE
C 
      OBSTAB = SDOBSE(1:14)//'     .TABL'
      CALL JEVEUO(OBSTAB,'L',JOBST )
      NOMTAB = ZK24(JOBST)(1:19)
C
C --- SD PRINCIPALE (INFO)
C
      OBSINF = SDOBSE(1:14)//'     .INFO'
      CALL JEVEUO(OBSINF,'L',JOBSIN)
      NBOCC  = ZI(JOBSIN-1+1)
      CALL ASSERT(NBOCC.LE.99)
C
C --- SD LISTE DES CHAMPS
C     
      OBSCHA = SDOBSE(1:14)//'     .CHAM'
      CALL JEVEUO(OBSCHA,'L',JOBSCH)
      CALL JELIRA(OBSCHA,'LONMAX',NBCHAM,K8BID)
      NBCHAM = NBCHAM / 2      
C
C --- SD TYPE D'EXTRACTIONS
C     
      OBSTYP = SDOBSE(1:14)//'     .EXTR'
      CALL JEVEUO(OBSTYP,'L',JOBSTY)
C
C --- SD ACTIVATION EXTRACTION
C     
      OBSACT = SDOBSE(1:14)//'     .ACTI'
      CALL JEVEUO(OBSACT,'L',JOBSAC)
C      
      NOBSEF  = 0
C
      DO 10 IOCC = 1 , NBOCC
C
C ----- OBSERVATION
C
        LOBSV  = ZL(JOBSAC+IOCC-1)
        IF (.NOT.LOBSV) GOTO 99
C
C ----- GENERATION NOM DES SD
C      
        CALL IMPFOI(0,2,IOCC,CHAINE)
        LISTNO = SDOBSE(1:14)//CHAINE(1:2)//'   .NOEU'
        LISTMA = SDOBSE(1:14)//CHAINE(1:2)//'   .MAIL'
        LISTPI = SDOBSE(1:14)//CHAINE(1:2)//'   .POIN'
        LISTSP = SDOBSE(1:14)//CHAINE(1:2)//'   .SSPI'
        LISTCP = SDOBSE(1:14)//CHAINE(1:2)//'   .CMP '
C
C ----- NOM DU CHAMP
C  
        ICHAM  = ZI(JOBSIN-1+4+7*(IOCC-1)+7-1)
        NOMCHA = ZK24(JOBSCH+2*(ICHAM-1)+1-1)
        NOMCHS = ZK24(JOBSCH+2*(ICHAM-1)+2-1)
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
     &              TEMP  ,CNFINT,CHAMP )
C
C ----- NOMBRE DE COMPOSANTES/NOEUDS/MAILLES
C
        NBCMP  = ZI(JOBSIN-1+4+7*(IOCC-1)-1+1)
        NBNO   = ZI(JOBSIN-1+4+7*(IOCC-1)-1+2)
        NBMA   = ZI(JOBSIN-1+4+7*(IOCC-1)-1+3)
        NBPI   = ZI(JOBSIN-1+4+7*(IOCC-1)-1+4)
        NBSPI  = ZI(JOBSIN-1+4+7*(IOCC-1)-1+5)
C
C ----- ACCES LISTES
C
        IF (TYPCHA.EQ.'NOEU') CALL JEVEUO(LISTNO,'L',JNO)
        IF (TYPCHA.EQ.'ELGA') CALL JEVEUO(LISTMA,'L',JMA)
C
C ----- TYPES D'EXTRACTION
C
        EXTRCH = ZK8(JOBSTY+3*(IOCC-1)+1-1)
        EXTRGA = ZK8(JOBSTY+3*(IOCC-1)+2-1)
        EXTRCP = ZK8(JOBSTY+3*(IOCC-1)+3-1)
C
C ----- CREATION SD DONNEES TEMPORAIRES
C
        CHELGA = '&&NMOBSE.VALE.ELGA'
        CHGAUS = '&&NMOBSE.VALE.GAUS'
        CHNOEU = '&&NMOBSE.VALE.NOEU'
        CALL NMEXT0(TYPCHA,NBMA  ,NBNO  ,NBPI  ,NBSPI ,
     &              NBCMP ,CHNOEU,CHGAUS,CHELGA,EXTRGA,
     &              EXTRCH)
C
C ----- EXTRAIRE LES VALEURS ET STOCKAGE DANS VECTEURS TEMPORAIRES
C
        CALL NMEXT1(NOMA  ,CHAMP ,TYPCHA,NOMCHA,NOMCHS,
     &              NBMA  ,NBNO  ,NBPI  ,NBSPI ,NBCMP ,
     &              EXTRGA,EXTRCH,EXTRCP,LISTNO,LISTMA,
     &              LISTPI,LISTSP,LISTCP,CHNOEU,CHGAUS,
     &              CHELGA)
C
C ----- SAUVER LES VALEURS DANS LA TABLE
C
        CALL NMOBS2(NOMA  ,SDOBSE,NOMTAB,NUMINS,INSTAN,
     &              TYPCHA,NOMCHA,NOMCHS,NBMA  ,NBNO  ,
     &              NBPI  ,NBSPI ,NBCMP ,EXTRGA,EXTRCH,
     &              EXTRCP,LISTNO,LISTMA,LISTPI,LISTSP,
     &              LISTCP,CHAMP ,CHNOEU,CHELGA,NOBSEF)
C
        CALL JEDETR(CHGAUS)
        CALL JEDETR(CHNOEU)        
        CALL JEDETR(CHELGA)
C
 99     CONTINUE

 10   CONTINUE
C
      IF (NOBSEF.NE.0) CALL U2MESI('I','OBSERVATION_37',1,NOBSEF) 
C
C --- DESTRUCTION DES CHAM_ELEM_S
C
      DO 45 ICHAM = 1,NBCHAM
        NOMCHS = ZK24(JOBSCH+2*(ICHAM-1)+2-1)
        CALL JEDETR(NOMCHS)
  45  CONTINUE 
C
      CALL JEDEMA()
C
      END
