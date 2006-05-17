      SUBROUTINE MEDOM1(MODELE,MATE,CARA,KCHA,NCHA,CTYP,
     &                  RESULT,NUORD)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER                                 NCHA
      INTEGER                  NUORD
      CHARACTER*4                                       CTYP
      CHARACTER*8       MODELE, CARA 
      CHARACTER*8       RESULT
      CHARACTER*24      MATE
      CHARACTER*(*)                      KCHA
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 16/05/2006   AUTEUR REZETTE C.REZETTE 
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
C     SAISIE ET VERIFICATION DE LA COHERENCE DES DONNEES MECANIQUES
C     DU PROBLEME
C     COPIE DE MEDOME POUR LES COMMANDES CALC_ELEM, CALC_CHAM_ELEM
C                                        ET POST_ZAC
C ----------------------------------------------------------------------
C OUT : MODELE : NOM DU MODELE
C OUT : MATE   : CHAMP MATERIAU
C OUT : CARA   : NOM DU CHAMP DE CARACTERISTIQUES
C IN  : KCHA   : NOM JEVEUX POUR STOCKER LES CHARGES
C OUT : NCHA   : NOMBRE DE CHARGES
C OUT : CTYP   : TYPE DE CHARGE
C IN  : RESULT : NOM DE LA SD RESULTAT
C IN  : NUORD  : NUMERO D'ORDRE
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM, JEXATR
C     ------------------------------------------------------------------
      INTEGER     NBORDR, IRET, NP, NC, JORDR
      INTEGER     IEXCIT, IERD
      REAL*8      PREC
      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='MEDOM1')
      CHARACTER*8  K8B, NOMO, MATERI
      CHARACTER*8  CRIT, BLAN8
      CHARACTER*16 CONCEP, NOMCMD, PHENOM
      CHARACTER*19 CH19 , CCARTE, CHAREP, CHPESA
      CHARACTER*19 EXCIT, KNUM, KFON
      CHARACTER*24 CH24 , CHCHAR
      CHARACTER*8 K8BID
C
      CALL JEMARQ()
C              12345678
      BLAN8 = '        '
      NCHA   = 0
      CTYP   = ' '
      MODELE = ' '
      CARA   = ' '
      MATERI = ' '
      IEXCIT = 1
C
      CALL GETRES(K8B,CONCEP,NOMCMD)
C    
      IF ( (NOMCMD.EQ.'CALC_ELEM'     ).OR.
     &     (NOMCMD.EQ.'CALC_NO'       ).OR.
     &     (NOMCMD.EQ.'POST_ELEM'     ).OR.
     &     (NOMCMD.EQ.'CALC_G'        )) THEN
C
C     RECUPERATION DU MODELE, MATERIAU, CARA_ELEM et EXCIT
C     POUR LE NUMERO d'ORDRE NUORD
C
        CALL RSLESD(RESULT,NUORD,MODELE,MATERI,CARA,EXCIT,IEXCIT)
        IF ( MATERI .NE. BLAN8) THEN
          CALL RCMFMC (MATERI , MATE )
        ELSE
          MATE = ' '
        ENDIF
      ELSE
C
        CALL GETVID(' ','MODELE'    ,0,1,1,MODELE,N1)
        IF(NOMCMD(1:8).NE.'POST_ZAC') THEN
           CALL GETVID(' ','CARA_ELEM' ,0,1,1,CARA  ,N2)
           CALL DISMOI('F','EXI_RDM',MODELE,'MODELE',IBID,K8B,IE)
           IF ((N2.EQ.0).AND.(K8B(1:3).EQ.'OUI'))
     &      CALL UTMESS('A','MEDOM1','LE MODELE CONTIENT DES ELEMENTS'
     &    //' DE STRUCTURE. IL FAUT PROBABLEMENT'
     &    //' UTILISER LE MOT-CLE CARA_ELEM.')
        ENDIF


        CALL GETVID(' ','CHAM_MATER',0,1,1,MATERI,N3)
        CALL DISMOI('F','BESOIN_MATER',MODELE,'MODELE',IBID,K8B,IE)
        IF ((N3.EQ.0).AND.(K8B(1:3).EQ.'OUI'))
     &      CALL UTMESS('A','MEDOM1','LE MODELE A PROBABLEMENT '
     &    //'BESOIN D UN CHAMP DE MATERIAUX (MOT-CLE CHAM_MATER).')
C
        IF ( N3 .NE. 0 ) THEN
          CALL RCMFMC ( MATERI , MATE )
        ELSE
          MATE = ' '
        ENDIF
C
      ENDIF
C
C
C   TRAITEMENT DU CHARGEMENT
C
C   SI IEXCIT=1 ON PREND LE CHARGEMENT DONNE PAR L'UTILISATEUR
C
      IF(IEXCIT.EQ.1) THEN
        CALL GETFAC('EXCIT',N5)
C
        IF ( N5 .NE. 0 ) THEN
          NCHA = N5
          CALL JEEXIN(KCHA,IRET)
          IF(IRET.NE.0) CALL JEDETR(KCHA)
          CALL WKVECT( KCHA ,'V V K8',N5,ICHA)
          DO 20 IEXCIT = 1, N5
            CALL GETVID('EXCIT','CHARGE',IEXCIT,1,1,
     &                  ZK8(ICHA+IEXCIT-1),N)
 20       CONTINUE
        ELSE
          CALL JEEXIN(KCHA,IRET)
          IF(IRET.NE.0) CALL JEDETR(KCHA)
          CALL WKVECT( KCHA ,'V V K8',1,ICHA)
        ENDIF

        IF ( NCHA .GT. 0 ) THEN
C
C     -- ON VERIFIE QUE LES CHARGES PORTENT TOUTES SUR LE MEME MODELE.
C
          CALL DISMOI('F','NOM_MODELE',ZK8(ICHA),'CHARGE',IBID,NOMO,IE)
          DO 30 I = 1,NCHA
            CALL DISMOI('F','NOM_MODELE',ZK8(ICHA-1+I),'CHARGE',IBID,
     +                                                        K8B,IE)
            IF ( K8B .NE. NOMO ) THEN
             CALL UTMESS('F','MEDOM1','LES CHARGES NE S''APPUIENT PAS'
     +                                 //' TOUTES SUR LE MEME MODELE.')
            ENDIF
 30       CONTINUE
C
C        --- ON VERIFIE QUE LES CHARGES PORTENT SUR LE MODELE
C                               EVENTUELEMENT DONNE EN ARGUMENT ---
          IF ( N1.NE.0 .AND. MODELE.NE.NOMO ) THEN
            CALL UTMESS('F','MEDOM1','LES CHARGES NE S''APUIENT PAS'//
     +                           ' SUR LE MODELE DONNE EN ARGUMENT.')
          ENDIF
C
C        --- VERIFICATION DU TYPE DE CHARGEMENT ---
          CALL DISMOI('F','TYPE_CHARGE',ZK8(ICHA),'CHARGE',IBID,CTYP,IE)
          DO 40 I = 1,NCHA
            CALL DISMOI('F','TYPE_CHARGE',ZK8(ICHA-1+I),'CHARGE',IBID,
     +                  K8B,IE)
            IF (K8B(1:4).NE.CTYP) THEN
               CALL UTMESS('F','MEDOM1','LES CHARGES SONT DE TYPE '//
     +                                 'DIFFERENT.')
            ENDIF
 40       CONTINUE
        ENDIF
C
C   SI IEXCIT=0 ON PREND LE CHARGEMENT PRESENT DANS LA SD ET ON 
C   LE FILTRE
C
      ELSE
        KFON='&&'//NOMPRO//'.FONC_MULT '
        CALL JEVEUO(EXCIT//'.INFC','L',JINFC)
        NCHA=ZI(JINFC)
        CALL JEVEUO(EXCIT//'.LCHA','L',JLCHA)
        CALL JEDETR(KCHA)
        CALL WKVECT(KCHA,'V V K8',NCHA,ICHA)
        CALL JEDETR(KFON)
        CALL WKVECT(KFON,'V V K8',NCHA,IKF)
        CALL JEVEUO(EXCIT//'.FCHA','L',JFCHA)
        CALL DISMOI('A','PHENOMENE',MODELE,'MODELE',IBID,PHENOM,IERD)
        CTYP=PHENOM(1:4)
        IN=0  
        DO 50 I=1,NCHA
C       ON STOCKE LES CHARGES DONT LE TYPE CORRESPOND A CTYP
          CALL DISMOI('F','TYPE_CHARGE',ZK24(JLCHA+I-1),
     &                'CHARGE',IBID,K8B,IE)
          IF(CTYP.EQ.K8B(1:4))THEN 
             ZK8(ICHA+IN)= ZK24(JLCHA+I-1)(1:8)
             ZK8(IKF+IN) = ZK24(JFCHA+I-1)(1:8)
             IN=IN+1
          ENDIF
 50     CONTINUE
        NCHA=IN

C
      ENDIF
C
      CALL JEDEMA()
      END
