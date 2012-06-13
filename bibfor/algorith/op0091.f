      SUBROUTINE OP0091()
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
C---------------------------------------------------------------------C
C--                                                                 --C
C--   OPERATEUR CALC_CORR_SSD   M. CORUS - AOUT 2011                --C
C--                                                                 --C
C--    CALCUL DES TRAVAUX AUX INTERFACEs ET SUR L'INTERIEUR DES     --C
C--       SOUS STRUCTURES DANS LE CAS D'UN CALCUL MODAL AVEC UN     --C
C--       MODELE REDUIT                                             --C
C--    CALCUL DES ENRICHISSEMENTS ASSOCIES POUR AMELIORER LA        --C
C--       QUALITE DU MODELE REDUIT                                  --C
C--                                                                 --C
C---------------------------------------------------------------------C
C
C

      INCLUDE 'jeveux.h'
C
C
      CHARACTER*1  K1BID
      CHARACTER*4  K4BID,NUM4L
      CHARACTER*8  NOMRES,MODGEN,RESGEN,SST1,SST2,INTF1,INTF2,
     &             KB,REST1,MRAID,MMASS,VK(3)
      CHARACTER*16 NOMCMD,TYPRES
      CHARACTER*14 NUME14
      CHARACTER*19 IMPED,NUME91,SOLVEU,NOMPAR(4),TYPPAR(4)
      CHARACTER*24 INDIN1,INDIN2,LINO1,LINO2,TRAMO1,TRAMO2
      INTEGER      I1,L1,IBID,LMODGE,LRESGE,NBLIA,LLLIA,IRET,NBSST,
     &             LLIPR,J1,K1,IMAST1,IMAST2,NBEQ1,NBEQ2,DDLA1,DDLA2,
     &             NBMOD,LNOSST,LNUSST,ISST1,NL,NC,NBDDL1,TACH1,NBEXP,
     &             LOMEG,LMOD1,LMASS,LBID,LTRSST,NBSLA,
     &             LRAID,LEFF1,LEFF2,LTRAIN,LINTF,NBINT,
     &             LCOPY1,LSECME,LIMPED,UNIT,LMASST,NBMAS,
     &             LSLAST,NINDEP,
     &             LTRAMO,LMATRO,LOBSRO,KK1,LL1
      REAL*8       R8PI,TRVINT,RBID,VR(2),TEMP
      COMPLEX*16   CBID
      CHARACTER*24 LISINT,MODET
      INTEGER      IARG
C     -----------------------------------------------------------------
      CALL JEMARQ()
      CALL GETRES(NOMRES,TYPRES,NOMCMD)
      CALL GETVIS(' ','UNITE',1,IARG,1,UNIT,IBID)
      CALL GETVID(' ','MODELE_GENE',1,IARG,1,MODGEN,LMODGE)
      CALL GETVID(' ','RESU_GENE',1,IARG,1,RESGEN,LRESGE)
      
C-- INITIALISATION DE LA TABLE_CONTAINER
      CALL DETRSD('TABLE_CONTAINER',NOMRES)
      CALL TBCRSD(NOMRES,'G')
      NOMPAR(1)='NOM_SST'
      TYPPAR(1)='K8'
      NOMPAR(2)='INTERF'
      TYPPAR(2)='K8'
      NOMPAR(3)='NOM_SD'
      TYPPAR(3)='K8'
      CALL TBAJPA(NOMRES,3,NOMPAR,TYPPAR)

C-- RECUPERATION DES INFOS      
      CALL JELIRA(MODGEN//'      .MODG.LIDF','NMAXOC',NBLIA,K1BID)
      CALL JEVEUO(MODGEN//'      .MODG.LIPR','L',LLIPR)
      CALL JELIRA(RESGEN//'           .ORDR','LONMAX',NBMOD,KB)
      CALL WKVECT('&&OP0091.PULSA_PROPRES','V V R',NBMOD,LOMEG)
      CALL JEVEUO(RESGEN//'           .RSPR','L',IBID)
      DO 30 I1=1,NBMOD
        ZR(LOMEG+I1-1)=(2*R8PI()*ZR(IBID+(I1-1)*18+8))
  30  CONTINUE
    
      CALL JELIRA(MODGEN//'      .MODG.SSNO','NOMMAX',NBSST,KB)
      CALL WKVECT('&&OP0091.NOM_SST','V V K8',NBSST,LNOSST)
      CALL WKVECT('&&OP0091.NUME_SST','V V I',NBSST+1,LNUSST)
      CALL WKVECT('&&OP0091.MATRICE_MASS','V V I',NBSST,LMASS)
      CALL WKVECT('&&OP0091.MATRICE_RAID','V V I',NBSST,LRAID)
      CALL WKVECT('&&OP0091.TRAV_INTERF','V V R',NBLIA*NBMOD,LTRAIN)
      CALL WKVECT('&&OP0091.TRAV_SST','V V R',NBSST*NBMOD,LTRSST)
      CALL WKVECT('&&OP0091.NUM_SST_ESCLAVE','V V I',NBLIA,LSLAST)
      CALL WKVECT('&&OP0091.NUM_SST_MAITRE','V V I',NBLIA,LMASST)
      
C----------------------------------------------------C
C--                                                --C
C--      CALCUL DES TRAVAUX SUR LES INTERFACES     --C
C--                                                --C
C----------------------------------------------------C
      DO 20 I1=1,NBLIA
C-- RECUPERATION DES INFOS DE LA LIAISON
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.LIDF',I1),'L',LLLIA)
        SST1=ZK8(LLLIA)
        INTF1=ZK8(LLLIA+1)
        SST2=ZK8(LLLIA+2)
        INTF2=ZK8(LLLIA+3)
        WRITE(UNIT,*)' LIAISON',I1,' : ',SST1,'/',SST2
        WRITE(UNIT,*)'     ->',INTF1,'/',INTF2
C-- GESTION DE L'INCOMPATIBILITE
        IRET=I1
        CALL VECOMO(MODGEN,SST1,SST2,INTF1,INTF2,IRET,'REDUIT  ')
C-- SOUS STRUCTURE 1
        LINO1='&&VECT_NOEUD_INTERF1'
        INDIN1='&&VEC_DDL_INTF_'//INTF1
        TRAMO1='&&MATR_TRACE_MODE_INT1'
        NBEQ1=ZI(LLIPR+(I1-1)*9+1)
C-- SOUS STRUCTURE 2
        LINO2='&&VECT_NOEUD_INTERF2'
        INDIN2='&&VEC_DDL_INTF_'//INTF2
        TRAMO2='&&MATR_TRACE_MODE_INT2'
        NBEQ2=ZI(LLIPR+(I1-1)*9+4)
C-- RECHERCHE DE LA SOUS STRUCTURE ESCLAVE DE LA LIAISON EN CHERCHANT LE
C-- FACTEUR MULTIPLICATEUR DANS LA MATRICE DE LIAISON LAGRANGE/LAGRANGE
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.LIMA',
     &              ZI(LLIPR+(I1-1)*9+8)),'L',IBID)
C-- L'INTERFACE MAITRE EST CELLE DONT LE NUMERO EST NEGATIF
        IF ( INT(ZR(IBID)) .EQ. -2) THEN
          IMAST1=1
          IMAST2=-2
        ELSE
          IMAST2=2
          IMAST1=-1
        ENDIF
C--                                                       
C-- CONSTRUCTION DES MATRICES D'OBSERVATION DE L'INTERFACE  
C--                                                         
C-- RECUPERATION DES MOUVEMENTS DE L'INTERFACE MAITRE, ET PROJECTION 
C--   SUR L'INTERFACE ESCLAVE POUR RELEVEMENT STATIQUE ULTERIEUR        
C-- POUR CONSTRUIRE C, IL FAUT D'ABORD CONSTRUIRE LA MATRICE 
C--   D'OBSERVATION A PARTIR D'UNE IDENTITE ET ENSUITE APPLIQUER 
C--   LA ROTATION
        CALL ROTLIR(MODGEN,SST1,INTF1,LINO1,0,INDIN1,
     &              TRAMO1,DDLA1,NBEQ1,MIN(IMAST1,0),I1)
        CALL ROTLIR(MODGEN,SST2,INTF2,LINO2,IRET,INDIN2,
     &              TRAMO2,DDLA2,NBEQ2,MIN(IMAST2,0),I1)
        KB='        '
        IF (IMAST1.EQ. -1) THEN
          IF (IRET .EQ. 0) THEN
            NBEQ1=DDLA1
            NC=DDLA1
            NL=DDLA2
            CALL LIPSRB(MODGEN,KB,SST1,SST2,INTF1,INTF2,LINO1,LINO2,
     &           INDIN1,INDIN2,DDLA1,DDLA2,NBEQ1,NBEQ2,-IMAST1,TRAMO1)
            CALL JEVEUO(TRAMO1,'E',LTRAMO)
          ENDIF
        ELSE
          IF (IRET .EQ. 0) THEN
            NBEQ2=DDLA2
            NC=DDLA2
            NL=DDLA1
            CALL LIPSRB(MODGEN,KB,SST1,SST2,INTF1,INTF2,LINO1,LINO2,
     &           INDIN1,INDIN2,DDLA2,DDLA1,NBEQ2,NBEQ1,-IMAST2,TRAMO2)
            CALL JEVEUO(TRAMO2,'E',LTRAMO)
          ENDIF
        ENDIF

        CALL WKVECT('&&OP0091.VEC_OBS_TEMP_RO','V V R',NL*NC,LOBSRO)
        CALL JEVEUO('&&ROTLIR.MATR_ROTATION','L',LMATRO)
        DO 455 J1=1,NC
          DO 465 K1=1,NL
            TEMP=ZR(LTRAMO+(J1-1)*NL + K1-1 )
            DO 475 L1=1,NL
               KK1=(K1-1)/3
               LL1=(L1-1)/3
              IF ( KK1 .EQ. LL1) THEN
                RBID=ZR(LMATRO+ (K1-KK1*3 -1)*3+ (L1-LL1*3 -1) )
                ZR(LOBSRO+(J1-1)*NL+ L1-1 )=
     &                ZR(LOBSRO+(J1-1)*NL+ L1-1 )+TEMP*RBID  
              ENDIF
 475        CONTINUE
 465      CONTINUE
 455    CONTINUE
        CALL LCEQVN(NL*NC,ZR(LOBSRO),ZR(LTRAMO))
        CALL JEDETR('&&OP0091.VEC_OBS_TEMP_RO')
        CALL JEDETR('&&ROTLIR.MATR_ROTATION')
C-- CALCUL DES TRAV. D'INTERF. ET DES EFFORTS POUR CORRECTION ULTERIEURE
        CALL TRAINT(RESGEN,MODGEN,I1,SST1,SST2,INTF1,INTF2,NBMOD,NL,NC)
C-- EXPANSION DES MODES ESCLAVES SUR L'INTERFACE MAITRE
        CALL CODENT(I1,'D0',K4BID)
        IF (IMAST1 .EQ. -1) THEN
          MODET='&&OP0091.MET'//K4BID//SST1
          CALL MODEXP(MODGEN,SST1,INDIN1,LINO1,NBMOD,I1,TRAMO1,MODET)
        ELSE
          MODET='&&OP0091.MET'//K4BID//SST2
          CALL MODEXP(MODGEN,SST2,INDIN2,LINO2,NBMOD,I1,TRAMO2,MODET)
        ENDIF
C-- DESTRUCTION DES CONCEPTS TEMPORAIRES
        CALL JEDETR(LINO1)
        CALL JEDETR(TRAMO1)
        CALL JEDETR(LINO2)
        CALL JEDETR(TRAMO2)
        CALL JEDETR('&&OP0091.MODE_SST1')
        CALL JEDETR('&&OP0091.MODE_SST2')
        CALL JEDETR('&&OP0091.MODE_SST1_EFF')
        CALL JEDETR('&&OP0091.MODE_SST2_EFF')
        CALL JEDETR('&&OP0091.MODE_SST1_EFFWI')
        CALL JEDETR('&&OP0091.MODE_SST2_EFFWI')
        CALL JEDETR('&&OP0091.MODE_SST1_COPY')
        CALL JEDETR('&&OP0091.MODE_SST2_COPY')
        CALL JEDETR('&&OP0091.OBS_01')
        CALL JEDETR('&&OP0091.OBS_02')
        CALL JEDETR('&&OP0091.LAGRANGES_1')
        CALL JEDETR('&&OP0091.LAGRANGES_2')                
        WRITE(UNIT,*)'  '
C-- FIN DE LA BOUCLE SUR LES LIAISONS        
  20  CONTINUE 

C-------------------------------------------------------------C
C--                                                         --C
C--      CALCUL DES TRAVAUX SUR LES SOUS STRUCTURES         --C
C--                                                         --C
C-------------------------------------------------------------C
      CALL WKVECT('&&OP0091.INTERFACES','V V K8',2*NBLIA,LINTF)
      DO 40 I1=1,NBSST
        NBINT=0
        SST1=ZK8(LNOSST+I1-1)
        CALL JENONU(JEXNOM(MODGEN//'      .MODG.SSNO',SST1),ISST1)
        WRITE(UNIT,*)' '
        WRITE(UNIT,*)' SOUS STRUCTURE : ',SST1
C-- RECHERCHE DES INTERFACES ASSOCIEES A CETTE SST
        DO 50 J1=1,NBLIA
          CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.LIDF',J1),'L',LLLIA)
          IF (ZK8(LLLIA).EQ.SST1) THEN
            ZK8(LINTF+NBINT)=ZK8(LLLIA+1)
            WRITE(UNIT,*)'   ->',ZK8(LINTF+NBINT)
            NBINT=NBINT+1
          ENDIF  
          IF (ZK8(LLLIA+2).EQ.SST1) THEN
            ZK8(LINTF+NBINT)=ZK8(LLLIA+3)
            WRITE(UNIT,*)'   ->',ZK8(LINTF+NBINT)
            NBINT=NBINT+1
          ENDIF
  50    CONTINUE
C-- RECUPERATION DES MODES        
        CALL JELIRA('&&VEC_DDL_INTF_'//ZK8(LINTF),'LONMAX',NBDDL1,KB)
        CALL CODENT(I1,'D0',K4BID)
        REST1='&&91'//K4BID
        CALL JEVEUO(JEXNUM(REST1//'           .TACH',1),'L',TACH1)
C-- CONSTRUCTION DES OBJETS TEMPORAIRES        
        CALL JELIRA(ZK24(TACH1)(1:19)//'.VALE','LONMAX',NBEQ1,KB)
        CALL WKVECT('&&OP0091.MODE_SST1','V V R',NBEQ1,LMOD1)
        CALL WKVECT('&&OP0091.MODE_SST1_EFF1','V V R',NBEQ1,LEFF1)
        CALL WKVECT('&&OP0091.MODE_SST1_EFF2','V V R',NBEQ1,LEFF2)
        CALL WKVECT('&&OP0091.MODE_SST1_COPY','V V R',NBEQ1,LCOPY1)
C-- ALLOCATION POUR PERMETTRE L'ACHIVAGE 
        NBSLA=0
        NBMAS=0
        CALL WKVECT('&&OP0091.ESCLAVE_LIASON','V V I',NBLIA,LBID)
        CALL WKVECT('&&OP0091.MAITRE_LIASON','V V I',NBLIA,IBID)
        DO 440 J1=1,NBLIA
          IF (ZI(LSLAST+J1-1) .EQ. I1) THEN
            NBSLA=NBSLA+1
            ZI(LBID+NBSLA-1)=J1
          ENDIF 
          IF (ZI(LMASST+J1-1) .EQ. I1) THEN
            NBMAS=NBMAS+1
            ZI(IBID+NBMAS-1)=J1
          ENDIF  
  440   CONTINUE
        CALL WKVECT('&&OP0091.MODE_INTF_DEPL','V V R',
     &              (2+NBSLA+NBMAS)*NBEQ1*NBMOD,LSECME)
C-- RECOPIE DES DEPLACEMENTS IMPOSES
        DO 460 J1=1,NBSLA
          CALL CODENT(ZI(LBID+J1-1),'D0',NUM4L)
          CALL JEVEUO('&&OP0091.DEPL_IMPO_'//NUM4L,'L',IBID)
          DO 470 K1=1,NBMOD
            CALL LCEQVN(NBEQ1,ZR(IBID+(K1-1)*NBEQ1),ZR(
     &      LSECME + (2+J1-1)*NBMOD*NBEQ1 + (K1-1)*NBEQ1 ))
  470     CONTINUE
  460   CONTINUE 
        CALL JEDETR('&&OP0091.ESCLAVE_LIASON')
        CALL JEDETR('&&OP0091.MAITRE_LIASON')
C-- CALCUL DES TRAVAUX POUR L'INTERIEUR DES SST ET EFFORTS ASSOCIES
        LISINT='&&OP0091.INTERFACES'
        CALL TRASST(MODGEN,I1,ISST1,LISINT,NBEQ1,NBMOD,NBINT)
        CALL JEDETR('&&OP0091.MODE_SST1')
        CALL JEDETR('&&OP0091.MODE_SST1_EFF1')
        CALL JEDETR('&&OP0091.MODE_SST1_EFF2')
        CALL JEDETR('&&OP0091.MODE_SST1_COPY')
C-- CALCUL DES LA REPONSE AUX EFFORTS "INTERIEURS"        
        CALL CODENT(I1,'D0',K4BID)
        IMPED='&&OP0091.IMPED'//K4BID
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSME',ISST1),'L',IBID)
        CALL JEVEUO(ZK8(IBID)//'.MAEL_MASS_REFE','L',LBID)
        MMASS=ZK24(LBID+1)(1:8)
        CALL JEVEUO(ZK8(IBID)//'.MAEL_RAID_REFE','L',LBID)
        MRAID=ZK24(LBID+1)(1:8)
        CALL DISMOI('F','SOLVEUR',MRAID,'MATR_ASSE',IBID,SOLVEU,IBID)
        CALL RESOUD(IMPED,' ',' ',SOLVEU,' ',' ',' ',
     &            ' ',NBMOD,ZR(LSECME),CBID,.TRUE.)
C-- CALCUL DE LA REPONSE AUX DEPLACEMENTS D'INTERFACE 
        DO 450 K1=1,NBSLA
          LBID=LSECME+2*NBEQ1*NBMOD        
          CALL RESOUD(IMPED,' ',' ',SOLVEU,' ',' ',' ',' ',NBMOD,
     &                ZR(LBID+NBEQ1*NBMOD*(K1-1)),CBID,.TRUE.)
  450   CONTINUE      
C-- "DEBLOQUAGE" DES DDL DE LAGRANGE ASSOCIES AUX INTERFACES DE LISINT
C--   DANS LA MATRICE IMPED     
        CALL DISMOI('F','NOM_NUME_DDL',MRAID,'MATR_ASSE',IBID,
     &              NUME91,IBID)
        CALL LIBINT(IMPED,NUME91,NBINT,LISINT,NBEQ1)
C-- FACTORISATION DE LA MATRICE INTERFACE LIBRE
        CALL MTDSCR(IMPED)
        CALL JEVEUO(IMPED(1:19)//'.&INT','E',LIMPED)
        CALL PRERES(SOLVEU,'V',IRET,'&&OP0091.MATPRE',IMPED,IBID,
     &              -9999)
        IF (IRET.EQ.2) CALL U2MESK('F', 'ALGELINE4_37',1,IMPED)
C-- CALCUL DE LA REPONSE AUX EFFORTS D'INTERFACE 
        CALL RESOUD(IMPED,' ',' ',SOLVEU,' ',' ',' ',' ',NBMOD,
     &              ZR(LSECME+NBEQ1*NBMOD),CBID,.TRUE.)
C-- RECOPIE DES MODES ETENDUS A LA SUITE DES CORRECTIONS A INTERF. LIBRE
        CALL JEDETC('V',IMPED,1)
        NBEXP=0
        DO 260 J1=1,NBLIA
          CALL CODENT(J1,'D0',K4BID)
          CALL JEEXIN('&&OP0091.MET'//K4BID//SST1,IRET)
          IF (IRET .GT. 0) THEN
             CALL JEVEUO('&&OP0091.MET'//K4BID//SST1,'L',LBID)
             CALL LCEQVN(NBEQ1*NBMOD,ZR(LBID),
     &            ZR(LSECME+(2+NBSLA+NBEXP)*NBEQ1*NBMOD))
             NBEXP=NBEXP+1
          ENDIF
  260   CONTINUE
C---------------C
C--           --C
C-- ARCHIVAGE --C
C--           --C
C---------------C
C--      
C-- VECTEURS A INTERFACE FIXE
C--
C-- ORTHONORMALISATION DES MODES A INTERFACE FIXE
        CALL MTDSCR(MMASS)      
        CALL VECIND(MMASS//'           ',LSECME,NBEQ1,NBMOD,1,NINDEP)
C-- RECOPIE DANS LA MATICE POUR ARCHIVAGE
        CALL WKVECT('&&MOIN93.MODE_INTF_DEPL','V V R',NBEQ1*NINDEP,LBID)
        CALL LCEQVN(NBEQ1*NINDEP,ZR(LSECME),ZR(LBID))
        CALL WKVECT('&&MOIN93.FREQ_INTF_DEPL','V V R',NINDEP,LBID)
        DO 270 J1=1,NINDEP
          ZR(LBID+J1-1)=J1
 270    CONTINUE
C  NOMMAGE AUTOMATIQUE DU CONCEPT RESULTAT
        VK(1)=SST1
        VK(2)='ENCAS'
        CALL GCNCON('_',VK(3))
        CALL VPCREA(0,VK(3),MMASS,' ',MRAID,NUME91,IBID)
        NUME14=NUME91(1:14)
        CALL ARCH93(VK(3),'MODE_MECA       ',NUME14,
     &               MRAID//'           ',0,0,0,0,NINDEP,0)
        CALL JEDETR('&&MOIN93.MODE_INTF_DEPL')
        CALL JEDETR('&&MOIN93.FREQ_INTF_DEPL')

        CALL TBAJLI(NOMRES,3,NOMPAR,IBID,RBID,CBID,VK,0)     
C--      
C-- VECTEURS A INTERFACE LIBRE
C--
C-- ORTHONORMALISATION DES MODES A INTERFACE LIBRE
        IBID=NBMOD*(1+NBSLA+NBMAS)
        CALL VECIND(MMASS//'           ',LSECME+NBEQ1*NBMOD,NBEQ1,
     &              IBID,1,NINDEP)
C-- RECOPIE DANS LA MATICE POUR ARCHIVAGE
        CALL WKVECT('&&MOIN93.MODE_INTF_DEPL','V V R',NBEQ1*NINDEP,LBID)
        CALL LCEQVN(NBEQ1*NINDEP,ZR(LSECME+NBEQ1*NBMOD),ZR(LBID))      
        
        CALL WKVECT('&&MOIN93.FREQ_INTF_DEPL','V V R',NINDEP,LBID)
        DO 370 J1=1,NINDEP
          ZR(LBID+J1-1)=J1
 370    CONTINUE
C--  NOMMAGE AUTOMATIQUE DU CONCEPT RESULTAT
        VK(1)=SST1
        VK(2)='LIBRE'
        CALL GCNCON('_',VK(3))
        CALL VPCREA(0,VK(3),MMASS,' ',MRAID,NUME91,IBID)
        CALL ARCH93(VK(3),'MODE_MECA       ',NUME14,
     &              MRAID//'           ',0,0,0,0,NINDEP,0)
        CALL TBAJLI(NOMRES,3,NOMPAR,IBID,RBID,CBID,VK,0)
C-- PETIT MENAGE        
        CALL JEDETR('&&MOIN93.MODE_INTF_DEPL')
        CALL JEDETR('&&MOIN93.FREQ_INTF_DEPL')
        CALL JEDETR('&&OP0091.MODE_INTF_DEPL')
C-- FIN DE LA BOUCLE SUR LES SOUS STRUCTURES
  40  CONTINUE       
C-- VERIFICATION D'UN TRAVAIL TOTAL NUL
      NOMPAR(1)='TRAV_TOTAL'
      TYPPAR(1)='R'
      NOMPAR(2)='NUM_MODE'
      TYPPAR(2)='I'
      CALL TBAJPA(NOMRES,2,NOMPAR,TYPPAR)
      WRITE(UNIT,*)' '
      DO 200 I1=1,NBMOD
        TRVINT=0
        DO 210 J1=1,NBSST
          TRVINT=TRVINT+ZR(LTRSST+NBMOD*(J1-1)+I1-1)
  210   CONTINUE
        DO 220 J1=1,NBLIA
          TRVINT=TRVINT+ZR(LTRAIN+NBMOD*(J1-1)+I1-1)
  220   CONTINUE
        WRITE(UNIT,*)'MODE ',I1,' - TRAVAIL TOTAL :',TRVINT
        CALL TBAJLI(NOMRES,2,NOMPAR,I1,TRVINT,CBID,KB,0)
  200 CONTINUE
C-- ARCHIVAGE DES TRAVAUX INTERFACES  
      NOMPAR(1)='TRAV_INTERF'
      TYPPAR(1)='R'
      NOMPAR(2)='NOM_INTERF'
      TYPPAR(2)='K8'
      NOMPAR(3)='NUM_MODE'
      TYPPAR(3)='I'
      CALL TBAJPA(NOMRES,3,NOMPAR,TYPPAR)
      DO 300 J1=1,NBMOD
        DO 310 I1=1,NBLIA
          CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.LIDF',I1),'L',LLLIA)
          INTF1=ZK8(LLLIA+1)
          INTF2=ZK8(LLLIA+3)
          VR(1)=ZR(LTRAIN+NBMOD*(I1-1)+J1-1)
          CALL TBAJLI(NOMRES,3,NOMPAR,J1,VR,CBID,INTF1,0)
          CALL TBAJLI(NOMRES,3,NOMPAR,J1,VR,CBID,INTF2,0)
  310   CONTINUE
  300 CONTINUE
C-- ARCHIVAGE DES TRAVAUX SOUS STRUCTURES
      NOMPAR(1)='TRAV_SST'
      TYPPAR(1)='R'
      NOMPAR(2)='NOM_SST'
      TYPPAR(2)='K8'
      NOMPAR(3)='NUM_MODE'
      TYPPAR(3)='I'
      CALL TBAJPA(NOMRES,3,NOMPAR,TYPPAR)
      DO 320J1=1,NBMOD
        DO 330 I1=1,NBSST
          VK(1)=ZK8(LNOSST+I1-1)
          VR(1)=ZR(LTRSST+NBMOD*(I1-1)+J1-1)
          CALL TBAJLI(NOMRES,3,NOMPAR,J1,VR,CBID,VK,0)
  330   CONTINUE        
  320 CONTINUE 
C-- MENAGE DANS LES CONCEPTS TEMPORAIRES  
      CALL JEDETR('&&OP0091.INTERFACES')
      CALL JEDETR('&&OP0091.NOM_SST')
      CALL JEDETR('&&OP0091.MATRICE_MASS')
      CALL JEDETR('&&OP0091.MATRICE_RAID')
      CALL JEDETR('&&OP0091.TRAV_INTERF')
      CALL JEDETR('&&OP0091.TRAV_SST')
      CALL JEDETR('&&OP0091.NUM_SST_ESCLAVE')
      CALL JEDETR('&&OP0091.PULSA_PROPRES')
C-- DESTRUCTION DES CONCEPTS "RESTITUTION" 
      DO 70 I1=1,ZI(LNUSST)
        CALL CODENT(I1,'D0',K4BID)
        CALL JEDETC('G','&&91'//K4BID,1)
  70  CONTINUE    
  
      CALL JEDETC('V','&&OP0091',1)
      CALL JEDETC('V','&&VEC_DDL_INTF',1)
      
      CALL TITRE
      CALL JEDEMA()
      END
