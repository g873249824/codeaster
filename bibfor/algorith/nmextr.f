      SUBROUTINE NMEXTR(NOMA  ,NOMO  ,SDEXTR,SDIETO,SDSENS,
     &                  MOTFAC,NBOCC ,NTEXTR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/06/2011   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*8  NOMA,NOMO
      CHARACTER*19 SDEXTR
      CHARACTER*24 SDIETO,SDSENS
      INTEGER      NBOCC,NTEXTR
      CHARACTER*16 MOTFAC
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (STRUCTURES DE DONNES - EXTRACTION)
C
C LECTURE DES DONNEES
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE 
C IN  NOMO   : NOM DU MODELE
C IN  SDEXTR : NOM DE LA SD POUR EXTRACTION
C IN  SDIETO : SD GESTION IN ET OUT
C IN  SDSENS : SD SENSIBILITE
C IN  MOTFAC : MOT-FACTEUR POUR LIRE 
C IN  NBOCC  : NOMBRE D'OCCURRENCES DE MOTFAC
C OUT NTEXTR : NOMBRE TOTAL D'EXTRACTIONS
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
      INTEGER      IOCC,IOC2,ICHAM,IBID
      INTEGER      NBEXT,NBCHAM
      INTEGER      NBNO,NBMA,NBPI,NBSPI,NBCMP
      CHARACTER*2  CHAINE
      CHARACTER*24 OLDCHA,NOMCHA,NOMCHS,NOMCHX
      CHARACTER*4  TYPCHA
      LOGICAL      LEXTR,TROUVE
      CHARACTER*24 LISTNO,LISTMA,LISTPI,LISTSP,LISTCP
      CHARACTER*24 EXTINF,EXTCHA,EXTTYP,EXTACT
      INTEGER      JEXTIN,JEXTCH,JEXTTY,JEXTAC
      CHARACTER*19 CHAMP
      CHARACTER*8  EXTRCP,EXTRCH,EXTRGA
      CHARACTER*24 LIST
      INTEGER      JLIST
C      
C ----------------------------------------------------------------------
C      
      CALL JEMARQ()                       
C
C --- INITIALISATIONS
C
      NTEXTR  = 0
      LIST    = '&&NMEXTR.LIST'
      NBCHAM  = 0
C
C --- SD PRINCIPALE (INFO)
C
      EXTINF = SDEXTR(1:14)//'     .INFO'
      CALL WKVECT(EXTINF,'V V I'  ,7*NBOCC+3,JEXTIN)
      ZI(JEXTIN+1-1) = NBOCC
      ZI(JEXTIN+2-1) = 0
      ZI(JEXTIN+3-1) = 1
      IF (NBOCC.EQ.0) GOTO 99
C
C --- SD TYPE D'EXTRACTION (CHAMP, GAUSS, COMPOSANTES)
C     
      EXTTYP = SDEXTR(1:14)//'     .EXTR'
      CALL WKVECT(EXTTYP,'V V K8' ,3*NBOCC  ,JEXTTY)
C
C --- SD ACTIVATION EXTRACTION
C     
      EXTACT = SDEXTR(1:14)//'     .ACTI'
      CALL WKVECT(EXTACT,'V V L'  ,NBOCC    ,JEXTAC)
C
C --- LISTE DES CHAMPS A EXTRAIRE
C
      CALL WKVECT(LIST  ,'V V K24',NBOCC,JLIST)
      DO 5 IOCC = 1 , NBOCC
C   
C ----- CE CHAMP EST-IL OBSERVABLE ?
C
        CALL NMEXTC(SDIETO,MOTFAC,IOCC  ,NOMCHA,LEXTR )
        IF (.NOT.LEXTR) NOMCHA = 'NONE'
C   
C ----- CE CHAMP EXISTE-T-IL DEJA ?
C
        TROUVE = .FALSE.
        DO 6 IOC2 = 1 , NBOCC - 1
          OLDCHA = ZK24(JLIST-1+IOC2)
          IF (OLDCHA.EQ.NOMCHA) THEN
            ICHAM  = IOC2
            TROUVE = .TRUE.
          ENDIF
  6     CONTINUE
        IF (.NOT.TROUVE) THEN
          NBCHAM = NBCHAM + 1
          ICHAM  = NBCHAM
          ZK24(JLIST-1+ICHAM) = NOMCHA
        ENDIF
        ZI(JEXTIN+3+7*(IOCC-1)+7-1) = ICHAM
  5   CONTINUE
C
C --- SD LISTE DES CHAMPS: CHAMP DE REFERENCE ET CHAMP SIMPLE
C
      EXTCHA = SDEXTR(1:14)//'     .CHAM'
      CALL WKVECT(EXTCHA,'V V K24',2*NBCHAM,JEXTCH)
      DO 20 ICHAM = 1,NBCHAM
        NOMCHA = ZK24(JLIST-1+ICHAM)
        NOMCHS = NOMCHA(1:18)//'S'
        ZK24(JEXTCH+2*(ICHAM-1)+1-1) = NOMCHA
        ZK24(JEXTCH+2*(ICHAM-1)+2-1) = NOMCHS
  20  CONTINUE
C
      DO 10 IOCC = 1 , NBOCC
C      
        NBEXT  = 0
        EXTRGA = 'NONE'
        EXTRCP = 'NONE'
        EXTRCH = 'NONE'
C
C ----- GENERATION DU NOM DES SD
C
        CALL IMPFOI(0,2,IOCC,CHAINE)
        LISTNO = SDEXTR(1:14)//CHAINE(1:2)//'   .NOEU'
        LISTMA = SDEXTR(1:14)//CHAINE(1:2)//'   .MAIL'
        LISTPI = SDEXTR(1:14)//CHAINE(1:2)//'   .POIN'
        LISTSP = SDEXTR(1:14)//CHAINE(1:2)//'   .SSPI'
        LISTCP = SDEXTR(1:14)//CHAINE(1:2)//'   .CMP '
C
C ----- NOM DU CHAMP
C
        ICHAM  = ZI(JEXTIN+3+7*(IOCC-1)+7-1)
        NOMCHA = ZK24(JEXTCH+2*(ICHAM-1)+1-1)
        NOMCHS = ZK24(JEXTCH+2*(ICHAM-1)+2-1)
        IF (NOMCHA.EQ.'NONE') THEN
          CALL GETVTX(MOTFAC,'NOM_CHAM',IOCC,1,1,NOMCHX,IBID)
          CALL U2MESK('A','EXTRACTION_99',1,NOMCHX)
          GOTO 999
        ENDIF
C
C ----- TYPE DU CHAMP (NOEU OU ELGA)
C
        CALL NMEXTT(SDIETO,NOMCHA,TYPCHA)
C
C ----- RECUPERATION DU CHAMP TEST POUR VERIF. COMPOSANTES
C
        CALL NMEXTD(NOMCHA,SDIETO,SDSENS,CHAMP )
C
C ----- LECTURE DE L'ENDROIT POUR EXTRACTION (MAILLE/NOEUD)
C
        CALL NMEXTL(NOMA  ,NOMO  ,MOTFAC,IOCC  ,NOMCHA,
     &              TYPCHA,LISTNO,LISTMA,NBNO  ,NBMA  ,
     &              EXTRCH)
C
C ----- LECTURE INFO. SI CHAM_ELGA/CHAM_ELEM
C
        IF (TYPCHA.EQ.'ELGA') THEN
          CALL NMEXTP(MOTFAC,IOCC  ,NOMCHA,CHAMP ,NOMCHS,
     &                LISTPI,LISTSP,NBPI  ,NBSPI ,EXTRGA)
        ENDIF
C
C ----- LECTURE ET VERIF DES COMPOSANTES
C
        CALL NMEXTK(NOMA  ,MOTFAC,IOCC  ,CHAMP ,NOMCHA,
     &              NOMCHS,TYPCHA,LISTNO,LISTMA,LISTPI,
     &              LISTSP,NBNO  ,NBMA  ,NBPI  ,NBSPI ,
     &              LISTCP,NBCMP )
C
C ----- TYPE EXTRACTION SUR LES COMPOSANTES
C
        CALL NMEXTF(MOTFAC,IOCC  ,EXTRCP)
C
C ----- DECOMPTE DES POINTS D'EXTRACTION
C
        CALL NMEXTN(TYPCHA,EXTRCP,EXTRGA,EXTRCH,NBNO  ,
     &              NBMA  ,NBCMP ,NBPI  ,NBSPI ,NBEXT )
C
C ----- SAUVEGARDE
C
        ZK8(JEXTTY+3*(IOCC-1)+1-1)  = EXTRCH 
        ZK8(JEXTTY+3*(IOCC-1)+2-1)  = EXTRGA 
        ZK8(JEXTTY+3*(IOCC-1)+3-1)  = EXTRCP
        ZI(JEXTIN+3+7*(IOCC-1)+1-1) = NBCMP
        ZI(JEXTIN+3+7*(IOCC-1)+2-1) = NBNO
        ZI(JEXTIN+3+7*(IOCC-1)+3-1) = NBMA
        ZI(JEXTIN+3+7*(IOCC-1)+4-1) = NBPI
        ZI(JEXTIN+3+7*(IOCC-1)+5-1) = NBSPI
        ZI(JEXTIN+3+7*(IOCC-1)+6-1) = NBEXT
C
  999   CONTINUE
C
        NTEXTR = NTEXTR + NBEXT
C
 10   CONTINUE
C
      ZI(JEXTIN+2-1) = NTEXTR
C
C --- DESTRUCTION DES CHAM_ELEM_S
C
      DO 45 ICHAM = 1,NBCHAM
        NOMCHS = ZK24(JEXTCH+2*(ICHAM-1)+2-1)
        CALL JEDETR(NOMCHS)
  45  CONTINUE
 99   CONTINUE
C
      CALL JEDETR(LIST)
      CALL JEDEMA()
      END
