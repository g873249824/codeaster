      SUBROUTINE HARM75(NOMRES,TYPRES,NOMIN,NOMCMD,BASEMO)
      IMPLICIT REAL*8 (A-H,O-Z)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/09/2005   AUTEUR NICOLAS O.NICOLAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C     ------------------------------------------------------------------
C     OPERATEUR DE RETOUR A LA BASE PHYSIQUE A PARTIR DE DONNEES
C     GENERALISEES DANS LE CAS D'UN CALCUL HARMONIQUE
C     ------------------------------------------------------------------
C IN  : NOMRES : NOM UTILISATEUR POUR LA COMMANDE REST_BASE_PHYS
C IN  : TYPRES : TYPE DE RESULTAT : 'DYNA_HARMO'
C IN  : NOMIN  : NOM UTILISATEUR DU CONCEPT HARM_GENE AMONT
C IN  : NOMCMD : NOM DE LA COMMANDE : 'REST_BASE_PHYS'
C IN  : BASEMO : NOM UTILISATEUR DU CONCEPT MODE_MECA AMONT
C                (SI CALCUL MODAL PAR SOUS-STRUCTURATION)
C                K8BID SINON
C ----------------------------------------------------------------------
C
C     ----DEBUT DES COMMUNS JEVEUX--------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C     ----FIN DES COMMUNS JEVEUX----------
C
      INTEGER       ITRESU(3),IBID,NBMODE,ITYPE
      REAL*8        EPSI,RBID
      COMPLEX*16    CBID
      CHARACTER*4   TYPE(3)
      CHARACTER*8   K8B,K8BID,BASEMO,CRIT,CHAMP(3),INTERP,NOMRES,
     &              NOMIN,MODE,TOUCH
      CHARACTER*8   NOMMOT,MATPRO
      CHARACTER*14  NUMDDL
      CHARACTER*16  TYPRES,NOMCMD,TYPBAS
      CHARACTER*19  KREFE,KNUME,KINST,HRANGE
      CHARACTER*24  MATRIC,CHAMNO,NOMCHA,CREFE(2)
      LOGICAL PROMES
C
C     ------------------------------------------------------------------
      DATA K8BID    /'        '/
      DATA CHAMNO   /'&&HARM75.CHAMNO'/
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      MODE = BASEMO
      HRANGE = NOMIN
      CALL GETVTX ( ' ', 'TOUT_CHAM', 0,1,1, TOUCH, N1 )
      IF (TOUCH(1:3).EQ.'OUI') THEN
         NBCHAM = 3
         TYPE(1) = 'DEPL'
         TYPE(2) = 'VITE'
         TYPE(3) = 'ACCE'
      ELSE
         CALL GETVTX ( ' ', 'NOM_CHAM', 1,1,3, CHAMP, N1 )
         NBCHAM = N1
         DO 11 I = 1 , NBCHAM
         IF (CHAMP(I)(1:4).EQ.'DEPL') THEN
            TYPE(I) = 'DEPL'
         ELSEIF (CHAMP(I)(1:4).EQ.'VITE') THEN
            TYPE(I) = 'VITE'
         ELSE
            TYPE(I) = 'ACCE'
         ENDIF
  11     CONTINUE
      ENDIF
C
C     --- RECUPERATION DE LA BASE MODALE ---
C ON SUPPOSE QU ELLE EST ISSUE D UN MODE_MECA OU BASE_MODALE
C
      PROMES = .FALSE.
C INDICATEUR CALCUL SANS MATRICE GENERALISEE (PROJ_MESU_MODAL)
      IF (MODE.EQ.K8BID) THEN
         CALL JEVEUO(HRANGE//'.REFD','L',IAREFE)
         MATPRO = ZK24(IAREFE)(1:8)
         CALL GETTCO(MATPRO,TYPBAS)
         IF ((TYPBAS(1:9).NE.'MODE_MECA').AND.
     +      (TYPBAS(1:9).NE.'MODE_STAT').AND.
     +      (TYPBAS(1:11).NE.'BASE_MODALE')) THEN
           CALL JEVEUO(MATPRO//'           .REFA','L',IAREF2)
           BASEMO = ZK24(IAREF2)(1:8)
           CALL JEVEUO(MATPRO//'           .DESC','L',IADESC)
           NBMODE = ZI(IADESC+1)
         ELSE
           PROMES = .TRUE.
           BASEMO = MATPRO
           CALL RSORAC(MATPRO,'LONUTI',IBID,RBID,K8BID,CBID,RBID,
     &            'ABSOLU',NBMODE,1,IBID)
         ENDIF
         CALL JEVEUO(BASEMO//'           .REFD','L',IADRIF)
         CALL GETTCO(BASEMO,TYPBAS)
         MATRIC = ZK24(IADRIF)
         IF (MATRIC.NE.K8BID) THEN
           CALL DISMOI('F','NOM_NUME_DDL',MATRIC,'MATR_ASSE',IBID,
     +                NUMDDL,IRET)
         ELSE
           NUMDDL = ZK24(IADRIF+3)(1:14)
         ENDIF
         CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,K8B,IRET)
      ELSE
C
C --- BASE MODALE CALCULEE PAR SOUS-STRUCTURATION
C
         CALL RSORAC(MODE,'LONUTI',IBID,BID,K8BID,CBID,
     +               EBID,'ABSOLU',NBMODE,1,NBID)
         CALL RSEXCH(BASEMO,'DEPL',1,NOMCHA,IRET)
         NOMCHA = NOMCHA(1:19)//'.REFE'
         CALL JEVEUO(NOMCHA,'L',LLCHA)
         CREFE(1) = ZK24(LLCHA)
         CREFE(2) = ZK24(LLCHA+1)
         CALL JELIRA(CREFE(2)(1:19)//'.NUEQ','LONMAX',NEQ,K8B)
         NUMDDL = ZK24(LLCHA+1)
      ENDIF

      CALL WKVECT('&&HARM75.BASEMODE','V V R',NBMODE*NEQ,IDBASE)
      IF (MODE.EQ.K8BID.AND.MATRIC.EQ.K8BID) THEN
        CALL COPMO2(BASEMO,NEQ,NUMDDL,NBMODE,ZR(IDBASE))
      ELSE      
        CALL COPMOD(BASEMO,'DEPL',NEQ,NUMDDL,NBMODE,ZR(IDBASE))
      ENDIF
C
C
C     --- RECUPERATION DES FREQUENCES ---

      CALL GETVTX(' ','CRITERE'  ,0,1,1,CRIT,N1)
      CALL GETVR8(' ','PRECISION',0,1,1,EPSI,N1)
      CALL GETVTX(' ','INTERPOL' ,0,1,1,INTERP,N1)
C

      KNUME = '&&HARM75.NUM_RANG'
      KINST = '&&HARM75.FREQ'
      CALL RSHARM(INTERP,HRANGE,' ',1,KINST,KNUME,NBREC,IRETOU)
      CALL JEEXIN(KINST,IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(KINST,'E',JFRREC)
        CALL JEVEUO(KNUME,'E',JNUME)
      END IF

C
C
C     --- RESTITUTION SUR LA BASE REELLE ---
C
       IF (INTERP(1:3).NE.'NON') THEN
         CALL UTMESS('E','REST_BASE_PHYS','PAS D''INTERPOLATION '//
     +                                            'POSSIBLE POUR '//
     +                  ' LES FREQUENCES.')
       ELSE
         CALL JEVEUO(HRANGE//'.FREQ','L',JFREQ)
         CALL JELIRA(HRANGE//'.FREQ','LONMAX',NBFREQ,K8B)
         CALL RSCRSD(NOMRES,TYPRES,NBREC)
         CALL WKVECT('&&HARM75.VECTGENE','V V C',NBMODE,IDVECG)

         IF (.NOT. PROMES) THEN
           DO 40 ICH=1,NBCHAM
               CALL RSEXCH(NOMIN,TYPE(ICH),1,NOMCHA,IRE)
               CALL JEVEUO(NOMCHA(1:19)//'.VALE','L',ITRESU(ICH))
40         CONTINUE
         ENDIF

         IARCHI = 0
         DO 30 I = 0,NBREC-1
            IARCHI = IARCHI + 1
            DO 32 ICH = 1,NBCHAM
               CALL RSEXCH(NOMRES,TYPE(ICH),IARCHI,CHAMNO,IRET)
               IF ( IRET .EQ. 0 ) THEN
                 CALL UTMESS('A',NOMCMD,CHAMNO//'CHAM_NO DEJA EXISTANT')
               ELSEIF ( IRET .EQ. 100 ) THEN
                 IF (MODE.EQ.K8BID) THEN
                   CALL VTCREB(CHAMNO,NUMDDL,'G','C',NEQ)
                 ELSE
                   CALL VTCREA(CHAMNO,CREFE,'G','C',NEQ)
                 ENDIF
               ELSE
                  CALL UTMESS('F',NOMCMD,'APPEL ERRONE')
               ENDIF
               CHAMNO(20:24) = '.VALE'
               CALL JEVEUO(CHAMNO,'E',LVALE)
               IF (PROMES) THEN
                 CALL JEVEUO(HRANGE//'.'//TYPE(ICH),'L',ITYPE)
                 IDVECG = ITYPE + I*NBMODE
               ELSE
                 CALL ZXTRAC(INTERP,EPSI,CRIT,NBFREQ,ZR(JFREQ),
     +                 ZR(JFRREC+I),TYPE(ICH),NOMIN,NBMODE,ZC(IDVECG)
     +                   , IBID)
               ENDIF
               CALL MDGEPC(NEQ,NBMODE,ZR(IDBASE),
     +                 ZC(IDVECG),ZC(LVALE))
               CALL JELIBE(CHAMNO)
               CALL RSNOCH(NOMRES,TYPE(ICH),IARCHI,' ')
 32         CONTINUE
            CALL RSADPA(NOMRES,'E',1,'FREQ',IARCHI,0,LINST,K8B)
            ZR(LINST) = ZR(JFREQ+I)
 30      CONTINUE
       ENDIF
C
      KREFE  = NOMRES
      CALL WKVECT(KREFE//'.REFD','G V K24',6,LREFE)
      IF (MODE.EQ.K8BID) THEN
        ZK24(LREFE  ) = ZK24(IADRIF)
        ZK24(LREFE+1) = ZK24(IADRIF+1)
        ZK24(LREFE+2) = ZK24(IADRIF+2)
        ZK24(LREFE+3) = ZK24(IADRIF+3)
        ZK24(LREFE+4) = ZK24(IADRIF+4)
        ZK24(LREFE+5) = ZK24(IADRIF+5)
      ELSE
        ZK24(LREFE  ) = '  '
        ZK24(LREFE+1) = '  '
        ZK24(LREFE+2) = '  '
        ZK24(LREFE+3) = ZK24(LLCHA+1)
        ZK24(LREFE+4) = '  '
        ZK24(LREFE+5) = '  '
      ENDIF
      CALL JELIBE(KREFE//'.REFD')
C
 9999 CONTINUE
      CALL JEDETC(' ','&&HARM75',1)
      CALL TITRE
C
99999 CONTINUE
      CALL JEDEMA()
      END
