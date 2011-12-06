      SUBROUTINE PEVOLU(RESU, MODELE, CARA, NBOCC)
      IMPLICIT   NONE
      INTEGER           NBOCC
      CHARACTER*8       MODELE,CARA
      CHARACTER*19      RESU
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
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
C
C     OPERATEUR :  POST_ELEM
C     TRAITEMENT DU MOT CLE-FACTEUR : "VOLUMOGRAMME"
C     ------------------------------------------------------------------
C
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER NR,ND,NP,NC,NI,NO,NLI,NLO,IRET,IBID,NBMA,NBORDR,JNO,NN
      INTEGER NBPAR,NBPMAX,IOCC,INUM,NUMO,JIN,NBMATO,IRESMA,NCMPM,IFM
      INTEGER NBCMP,NBINT,JBPCT,IVALR,II,I,IB,JVALR,JVALI,JVALK,NIV
      INTEGER JLICMP,JLICM2,JLICM1,NUCMP,INDIK8,IVALI,BFIX,IVOL(2)
      PARAMETER(NBPMAX=13)
      CHARACTER*4 TYCH,KI
      CHARACTER*8 MAILLA,CRIT,K8B,RESUCO,CHAMG,TYPPAR(NBPMAX),NOMGD
      CHARACTER*8 TYPMCL(1),TOUT,NOMCMP,INFOMA,GROUMA,TMPRES,NCPINI
      CHARACTER*8 NOPAR2,NOPAR,NORME
      REAL*8 R8B,PREC,INST,BORNE(2),VOLTOT
      COMPLEX*16 C16B
      CHARACTER*19 KNUM,KINS,LISINS,CHAM,CHAM2,CHAMTM,CELMOD,LIGREL
      CHARACTER*19 TMPCHA
      CHARACTER*16 NOMPAR(NBPMAX),MOCLES(1),OPTIO2,NOMCHA,VALK
      CHARACTER*24 MESMAI,MESMAF,MESMAE,BORPCT,VALR,VALI
      LOGICAL EXIORD,TONEUT  
      INTEGER      IARG
C     ------------------------------------------------------------------
C
      CALL JEMARQ ( )
      CALL INFNIV(IFM,NIV)
C
C --- 1- RECUPERATION DU MAILLAGE ET DU NOMBRE DE MAILLES
C     ===================================================
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,MAILLA,IRET)
      CALL DISMOI('F','NB_MA_MAILLA',MAILLA,'MAILLAGE',NBMATO,K8B,IRET)


C --- 2- RECUPERATION DU RESULTAT ET DES NUMEROS D'ORDRE
C     ==================================================
      CALL GETVID( ' ', 'RESULTAT' , 0,IARG,1, RESUCO, NR)
      CALL GETVID( ' ', 'CHAM_GD'   ,0,IARG,1, CHAMG,  ND)

      CALL GETVR8( ' ', 'PRECISION', 0,IARG,1, PREC, NP)
      CALL GETVTX( ' ', 'CRITERE'  , 0,IARG,1, CRIT, NC)
      CALL GETVR8( ' ', 'INST'      ,0,IARG,0, R8B, NI)
      CALL GETVIS( ' ', 'NUME_ORDRE',0,IARG,0, IBID, NO)
      CALL GETVID( ' ', 'LIST_INST' ,0,IARG,0, K8B, NLI)
      CALL GETVID( ' ', 'LIST_ORDRE',0,IARG,0, K8B, NLO)

      VALR   = '&&PEVOLU.VALR'
      VALI   = '&&PEVOLU.VALI'
      VALK   = '&&PEVOLU.VALK'
      KNUM   = '&&PEVOLU.NUME_ORDRE'
      KINS   = '&&PEVOLU.INST'
      MESMAI = '&&PEVOLU.MES_MAILLES'
      MESMAF = '&&PEVOLU.MAILLES_FILTRE'
      BORPCT = '&&PEVOLU_BORNES_PCT'

      EXIORD=.FALSE.
      TONEUT=.FALSE.

      IF (ND.NE.0) THEN

        NBORDR = 1
        CALL WKVECT(KNUM,'V V I',NBORDR,JNO)
        ZI(JNO) = 1
        EXIORD=.TRUE.

      ELSE

C       -- NUME_ORDRE --
        IF(NO.NE.0)THEN
          EXIORD=.TRUE.
          NBORDR=-NO
          CALL WKVECT(KNUM,'V V I',NBORDR,JNO)
          CALL GETVIS(' ','NUME_ORDRE',0,IARG,NBORDR,ZI(JNO),IRET)
        ENDIF

C       -- LIST_ORDRE --
        IF(NLO.NE.0)THEN
         EXIORD=.TRUE.
         CALL GETVID(' ', 'LIST_ORDRE',0,IARG,1,LISINS,IRET)
         CALL JEVEUO(LISINS // '.VALE', 'L', JNO)
         CALL JELIRA(LISINS // '.VALE', 'LONMAX', NBORDR, K8B)
        ENDIF

C       -- INST --
        IF(NI.NE.0)THEN
         NBORDR=-NI
         CALL WKVECT(KINS,'V V R',NBORDR,JIN)
         CALL GETVR8(' ','INST',0,IARG,NBORDR,ZR(JIN),IRET)
        ENDIF

C       -- LIST_INST --
        IF(NLI.NE.0)THEN
         CALL GETVID(' ', 'LIST_INST',0,IARG,1,LISINS,IRET)
         CALL JEVEUO(LISINS // '.VALE', 'L', JIN)
         CALL JELIRA(LISINS // '.VALE', 'LONMAX', NBORDR, K8B)
        ENDIF

C       -- TOUT_ORDRE --
        NN=NLI+NI+NO+NLO
        IF(NN.EQ.0)THEN
          EXIORD=.TRUE.
          CALL RSUTNU(RESUCO,' ',0,KNUM,NBORDR,PREC,CRIT,IRET)
          CALL JEVEUO(KNUM, 'L', JNO )
        ENDIF

      ENDIF

C
C --- 3- CREATION DE LA TABLE
C     =======================
      CALL TBCRSD(RESU, 'G' )
      IF(NR.NE.0) THEN
         NBPAR=11
         NOMPAR(1) ='RESULTAT'
         NOMPAR(2) ='NOM_CHAM'
         NOMPAR(3) ='NUME_ORDRE'
         NOMPAR(4) ='INST'
         NOMPAR(5) ='NOM_CMP'
         NOMPAR(6) ='GROUP_MA'
         NOMPAR(7) ='RESTRICTION'
         NOMPAR(8) ='INTERVALLE'
         NOMPAR(9) ='BORNE_INF'
         NOMPAR(10)='BORNE_SUP'
         NOMPAR(11)='DISTRIBUTION'
         TYPPAR(1) ='K8'
         TYPPAR(2) ='K16'
         TYPPAR(3) ='I'
         TYPPAR(4) ='R'
         TYPPAR(5) ='K8'
         TYPPAR(6) ='K8'
         TYPPAR(7) ='K8'
         TYPPAR(8) ='I'
         TYPPAR(9) ='R'
         TYPPAR(10)='R'
         TYPPAR(11)='R'
      ELSE 
         NBPAR=8
         NOMPAR(1)='CHAM_GD'
         NOMPAR(2)='NOM_CMP'
         NOMPAR(3)='GROUP_MA'
         NOMPAR(4)='RESTRICTION'
         NOMPAR(5)='INTERVALLE'
         NOMPAR(6)='BORNE_INF'
         NOMPAR(7)='BORNE_SUP'
         NOMPAR(8)='DISTRIBUTION'
         TYPPAR(1)='K8'
         TYPPAR(2)='K8'         
         TYPPAR(3)='K8'
         TYPPAR(4)='K8'
         TYPPAR(5)='I'
         TYPPAR(6)='R'
         TYPPAR(7)='R'
         TYPPAR(8)='R'
      ENDIF
      CALL TBAJPA(RESU,NBPAR,NOMPAR,TYPPAR)
      CHAM='&&CHPCHD.CHAM'

C
C --- 4- REMPLISSAGE DE LA TABLE
C     ==========================

C     --- ON PARCOURT LES OCCURENCES DU MOT CLE 'VOLUMOGRAMME':
C     ---------------------------------------------------------
      IF (NR.NE.0) THEN
          TMPRES='TMP_RESU'
          CALL COPISD('RESULTAT','V',RESUCO,TMPRES)
      ELSE
          TMPCHA='TMP_CHAMP_GD'
          CALL COPISD('CHAMP','V',CHAMG,TMPCHA)
      ENDIF

      DO 10 IOCC = 1 , NBOCC



C     --- BOUCLE SUR LES NUMEROS D'ORDRE:
C     ----------------------------------

      DO 5 INUM=1,NBORDR

C      -- 4.1 RECUPERATION DU CHAMP --

          IF (NR.NE.0) THEN
C         --  RESULTAT --
            IF(EXIORD) THEN
C           - ORDRE -
              NUMO=ZI(JNO+INUM-1)
              CALL RSADPA(RESUCO,'L',1,'INST',NUMO,0,JIN,K8B)
              INST=ZR(JIN)
            ELSE
C           - INST -
              INST=ZR(JIN+INUM-1)
              CALL RSORAC(RESUCO,'INST',0,ZR(JIN+INUM-1),K8B,
     &                    C16B,PREC,CRIT,NUMO,NBORDR,IRET)
            ENDIF
            CALL GETVTX('VOLUMOGRAMME','NOM_CHAM',IOCC,IARG,1,
     &                  NOMCHA,IRET)
            IF (IRET.EQ.0) CALL U2MESS('F','POSTELEM_4')
            CHAM2='&&PEVOLU.CHAM_2'
            CALL RSEXCH(TMPRES,NOMCHA,NUMO,CHAM2,IRET)

          ELSE
C         -- CHAM_GD --
            NUMO = NBORDR
            CHAM2 = TMPCHA
            NOMCHA= CHAMG
          ENDIF

          CALL DISMOI('C','TYPE_CHAMP',CHAM2,'CHAMP',IBID,TYCH,IRET)
          CALL DISMOI('C','NOM_GD',CHAM2,'CHAMP',IBID,NOMGD,IRET)

          IF(NOMGD(6:6).EQ.'C')GOTO 10

          IF (TYCH(1:2).NE.'EL') THEN

C          --- 1. TRANSFORMATION DU CHAMP EN CHAMP NEUTRE:
C              - CHANGEMENT DE LA GRANDEUR EN NEUT_R
C              - CHAMGEMENT DES COMPOSANTES EN X1,X2,X3,...
               TONEUT=.TRUE.
               CHAMTM='&&PEVOLU.CHS1'
               CALL CNOCNS(CHAM2,'V',CHAMTM)
               CALL JEVEUO(CHAMTM//'.CNSC','L',JLICMP)
               CALL JELIRA(CHAMTM//'.CNSC','LONMAX',NCMPM,K8B)
               CALL JEDETR('&&PEVOLU.CMP1')
               CALL WKVECT('&&PEVOLU.CMP1','V V K8',NCMPM,JLICM1)
               CALL JEDETR('&&PEVOLU.CMP2')
               CALL WKVECT('&&PEVOLU.CMP2','V V K8',NCMPM,JLICM2)
               DO 15 I=1,NCMPM
                   CALL CODENT(I,'G',KI)
                   ZK8(JLICM2+I-1)='X'//KI(1:LEN(KI))
                   ZK8(JLICM1+I-1)=ZK8(JLICMP+I-1)
 15            CONTINUE
               CALL CHSUT1(CHAMTM,'NEUT_R',NCMPM,ZK8(JLICM1),
     &                     ZK8(JLICM2),'V',CHAMTM)
               CALL CNSCNO(CHAMTM,' ','NON','V',CHAM2,'F',IBID)
               CALL DETRSD('CHAM_NO_S',CHAMTM)

C           --- 2. CHANGEMENT DE DISCRETISATION : NOEU -> ELGA
               OPTIO2 ='TOU_INI_ELGA'
               CALL DISMOI('C','NOM_GD',CHAM2,'CHAMP',IBID,NOMGD,IRET)
               NOPAR = NOPAR2(OPTIO2,NOMGD,'OUT')
               CELMOD = '&&PEVOLU.CELMOD'
               LIGREL = MODELE//'.MODELE'
               CALL ALCHML(LIGREL,OPTIO2,NOPAR,'V',CELMOD,IB,' ')
               IF (IB.NE.0) CALL U2MESK('F','UTILITAI3_23',1,OPTIO2)
               CALL CHPCHD(CHAM2,'ELGA',CELMOD,'OUI','V',CHAM)
               CALL DETRSD('CHAMP',CELMOD)
C
          ELSE
               CHAM=CHAM2
          ENDIF

         CALL DISMOI('C','TYPE_CHAMP',CHAM,'CHAMP',IBID,TYCH,IRET)

C      -- 4.2 RECUPERATION DE LA COMPOSANTE --

          CALL GETVTX('VOLUMOGRAMME','NOM_CMP',IOCC,IARG,1,NOMCMP,NBCMP)
          NCPINI=NOMCMP
          IF(TONEUT)THEN
              NUCMP=INDIK8(ZK8(JLICM1),NOMCMP,1,NCMPM)
              NOMCMP=ZK8(JLICM2+NUCMP-1)
          ENDIF

C      -- 4.3 RECUPERATION DES MAILLES --

          CALL GETVTX('VOLUMOGRAMME','TOUT',IOCC,IARG,1,TOUT,IRET)
          IF(IRET.NE.0) THEN
            MOCLES(1) = 'TOUT'
            TYPMCL(1) = 'TOUT'
            GROUMA='-'
          ELSE
            MOCLES(1) = 'GROUP_MA'
            TYPMCL(1) = 'GROUP_MA'
            CALL GETVTX('VOLUMOGRAMME','GROUP_MA',IOCC,IARG,1,
     &                  GROUMA,IRET)
          ENDIF

C         - MAILLES FOURNIES PAR L'UTILISATEUR -              
          CALL RELIEM(MODELE,MAILLA,'NU_MAILLE','VOLUMOGRAMME',IOCC,
     &                1,MOCLES,TYPMCL,MESMAI,NBMA)

          MESMAE=MESMAI
C         - MAILLES EVENTUELLEMENT FILTREES EN FONCTION DE LA DIMENSION
C           GEOMETRIQUE (2D OU 3D)              
          CALL GETVTX('VOLUMOGRAMME','TYPE_MAILLE',IOCC,IARG,1,
     &                INFOMA,IRET)
          IF (IRET.NE.0) THEN
             MESMAE=MESMAF
             IF (INFOMA.EQ.'2D') THEN 
               IRESMA=2
             ELSE IF (INFOMA.EQ.'3D') THEN 
               IRESMA=3
             ELSE
               CALL ASSERT(.FALSE.)
             ENDIF
             CALL UTFLMD(MAILLA,MESMAI,IRESMA,NBMA,MESMAF)
          ELSE
             INFOMA='-'
          ENDIF

C      -- 4.4 CALCUL DES INTERVALLES ET DE LA DISTRIBUTION --

C        - ON RECUPERE LE NOMBRE D'INTERVALLES ET LA NORME
C        - POUR CALCUL RELATIF OU ABSOLU
          CALL GETVIS('VOLUMOGRAMME','NB_INTERV',IOCC,IARG,1,NBINT,IRET)
          CALL GETVTX('VOLUMOGRAMME','NORME'    ,IOCC,IARG,1,NORME,IRET)
          CALL GETVR8('VOLUMOGRAMME','BORNES'   ,IOCC,IARG,2,BORNE,IRET)
          IF (IRET.NE.0) THEN 
              BFIX=1
              CALL ASSERT(BORNE(1).LT.BORNE(2))
          ELSE
              BORNE(1)=0.D0
              BORNE(2)=0.D0
              BFIX=0
          ENDIF
C        - ON CREE UN TABLEAU POUR RECUEILLIR POUR CHAQUE INTERVALLE
C         LES 3 VALEURS SUIVANTES:
C             . LA BORNE INF,
C             . LA BORNE SUP,
C             . LE VALEUR DE REPARTITION DE LA COMPOSANTE
          CALL WKVECT(BORPCT,'V V R',3*NBINT,JBPCT)
          CALL PEBPCT(MODELE,NBMA,MESMAE,CHAM,NOMCMP,3*NBINT,
     &                BFIX,BORNE,NORME,ZR(JBPCT),VOLTOT)

C      -- 4.5 ON REMPLIT LA TABLE --

          IF(NOMPAR(1).EQ.'RESULTAT')THEN
            CALL WKVECT(VALK,'V V K16',5,JVALK)
            ZK16(JVALK)  =RESUCO
            ZK16(JVALK+1)=NOMCHA
            ZK16(JVALK+2)=NCPINI
            ZK16(JVALK+3)=GROUMA
            ZK16(JVALK+4)=INFOMA
            CALL WKVECT(VALR,'V V R',4,JVALR)
            ZR(JVALR)=INST
            IVALR=1
            CALL WKVECT(VALI,'V V I',2,JVALI)
            ZI(JVALI)=NUMO
            IVALI=1
          ELSE
            CALL WKVECT(VALK,'V V K16',4,JVALK)
            ZK16(JVALK)  =NOMCHA
            ZK16(JVALK+1)=NCPINI
            ZK16(JVALK+2)=GROUMA
            ZK16(JVALK+3)=INFOMA
            CALL WKVECT(VALR,'V V R',3,JVALR)
            IVALR=0
            CALL WKVECT(VALI,'V V I',1,JVALI)
            IVALI=0
          ENDIF

C        - POUR CHAQUE INTERVALLE, ON AJOUTE UNE LIGNE A LA TABLE :
          DO 20 II=1,NBINT
             ZR(JVALR+IVALR)  =ZR(JBPCT+3*(II-1))
             ZR(JVALR+IVALR+1)=ZR(JBPCT+3*(II-1)+1)
             ZR(JVALR+IVALR+2)=ZR(JBPCT+3*(II-1)+2)
             ZI(JVALI+IVALI)=II
             CALL TBAJLI(RESU,NBPAR,NOMPAR,ZI(JVALI),ZR(JVALR),C16B,
     &                   ZK16(JVALK),0)
 20       CONTINUE

C     IMPRESSION DU VOLUME TOTAL CONCERNE PAR LE CALCUL :
C      - SOIT LE VOLUME TOTAL DEFINI PAR L ENTITE TOPOLOGIQUE
C      - SOIT POUR CELUI DONT LES VALEURS SONT COMPRISES DANS LES 
C        BORNES SI CELLES-CI SONT RENSEIGNEES PAR L UTILISATEUR
          IVOL(1)=IOCC
          IVOL(2)=INUM
          CALL U2MESG('I','UTILITAI7_14',0,' ',2,IVOL,1,VOLTOT)

C      -- 4.5 NETTOYAGE POUR L'OCCURRENCE SUIVANTE --
CCC          CALL DETRSD('CHAMP',CHAM2)       
          CALL JEDETR(VALR)
          CALL JEDETR(VALI)
          CALL JEDETR(VALK)
          CALL JEDETR(MESMAF)
          CALL JEDETR(MESMAI)
          CALL JEDETR(BORPCT)
          CALL JEDETR(MESMAF)

C     --- FIN DE LA BOUCLE SUR LES NUMEROS D'ORDRE:
C     ---------------------------------------------
 5    CONTINUE

C     --- FIN DE LA BOUCLE SUR LES OCCURRENCES DU MOT-CLE VOLUMOGRAMME
C     ----------------------------------------------------------------
 10   CONTINUE
      
      IF (NR.NE.0) THEN
          CALL DETRSD('RESULTAT',TMPRES)
      ELSE
          CALL DETRSD('CHAMP',TMPCHA)
      ENDIF


      CALL JEDEMA()

      END
