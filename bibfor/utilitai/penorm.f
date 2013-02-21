      SUBROUTINE PENORM(RESU, MODELE)
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8       MODELE
      CHARACTER*19      RESU
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 12/02/2013   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ------------------------------------------------------------------
C     OPERATEUR :  POST_ELEM
C     TRAITEMENT DU MOT CLE-FACTEUR : "NORME"
C     ------------------------------------------------------------------
C
C TOLE CRS_512
C TOLE CRP_20
      INTEGER IBID,IRET,NBMATO,NR,ND,NP,NC,NI,NO,NLI,NLO,JNO,JIN,JCOEF
      INTEGER NBPAR,NBPMAX,INUM,NUMO,IRESMA,NBORDR,JLICMP,JLICM1,JMA,NN
      INTEGER JLICM2,I,NNCP,NBMA,JVALK,JVALR,JVALI,NCMPM,NCP,IFM,NIV
      INTEGER JLICMX,NB30,NCMPT
      PARAMETER(NBPMAX=13,NB30=30)
      REAL*8 R8B,PREC,INST,VNORM(1)
      COMPLEX*16 C16B
      LOGICAL EXIORD
      CHARACTER*4 TYCH,KI,EXIRDM
      CHARACTER*8 MAILLA,K8B,RESUCO,CHAMG,NOPAR2,TYPMCL(1),TOUT
      CHARACTER*8 TMPRES,TYPPAR(NBPMAX),NOMGD,LPAIN(3),LPAWPG(1),CRIT
      CHARACTER*8 NOPAR,INFOMA,LPAOUT(1),TYNORM
      CHARACTER*19 KNUM,KINS,LISINS,CHAM2,CHAMTM,CELMOD,LIGREL
      CHARACTER*19 TMPCHA,CHAM1
      CHARACTER*16 OPTIO2,NOMCHA,VALK,NOMPAR(NBPMAX),MOCLES(1),OPTION
      CHARACTER*24 MESMAI,MESMAF,VALR,VALI,LCHIN(3),LCHWPG(1),LCHOUT(1)
      CHARACTER*24  CHGEOM,COEFCA,VALK2(5),GROUMA
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
      CALL GETVID( 'NORME', 'RESULTAT' , 1,IARG,1, RESUCO, NR)
      CALL GETVID( 'NORME', 'CHAM_GD'   ,1,IARG,1, CHAMG,  ND)

      CALL GETVR8( 'NORME', 'PRECISION', 1,IARG,1, PREC, NP)
      CALL GETVTX( 'NORME', 'CRITERE'  , 1,IARG,1, CRIT, NC)
      CALL GETVR8( 'NORME', 'INST'      ,1,IARG,0, R8B, NI)
      CALL GETVIS( 'NORME', 'NUME_ORDRE',1,IARG,0, IBID, NO)
      CALL GETVID( 'NORME', 'LIST_INST' ,1,IARG,0, K8B, NLI)
      CALL GETVID( 'NORME', 'LIST_ORDRE',1,IARG,0, K8B, NLO)
      CALL GETVTX( 'NORME', 'TYPE_NORM', 1,IARG,1, TYNORM, IRET)

      VALR   = '&&PENORM.VALR'
      VALI   = '&&PENORM.VALI'
      VALK   = '&&PENORM.VALK'
      KNUM   = '&&PENORM.NUME_ORDRE'
      KINS   = '&&PENORM.INST'
      MESMAI = '&&PENORM.MES_MAILLES'
      MESMAF = '&&PENORM.MAIL_FILTRE'
      CHAM1  = '&&PENORM.CHAM1'
      CHAM2  = '&&PENORM.CHAM2'
      CHAMTM = '&&PENORM.CHAMTM'
      LIGREL = '&&PENORM.LIGREL'
      COEFCA = '&&PENORM.CARTE_COEF'

      EXIORD=.FALSE.
      NCMPT =0

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
          CALL GETVIS('NORME','NUME_ORDRE',1,IARG,NBORDR,ZI(JNO),IRET)
        ENDIF

C       -- LIST_ORDRE --
        IF(NLO.NE.0)THEN
         EXIORD=.TRUE.
         CALL GETVID('NORME', 'LIST_ORDRE',1,IARG,1,LISINS,IRET)
         CALL JEVEUO(LISINS // '.VALE', 'L', JNO)
         CALL JELIRA(LISINS // '.VALE', 'LONMAX', NBORDR, K8B)
        ENDIF

C       -- INST --
        IF(NI.NE.0)THEN
         NBORDR=-NI
         CALL WKVECT(KINS,'V V R',NBORDR,JIN)
         CALL GETVR8('NORME','INST',1,IARG,NBORDR,ZR(JIN),IRET)
        ENDIF

C       -- LIST_INST --
        IF(NLI.NE.0)THEN
         CALL GETVID('NORME', 'LIST_INST',1,IARG,1,LISINS,IRET)
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

         NBPAR=8

         NOMPAR(1) ='RESULTAT'
         NOMPAR(2) ='NOM_CHAM'
         NOMPAR(3) ='NUME_ORDRE'
         NOMPAR(4) ='INST'
         NOMPAR(5) ='GROUP_MA'
         NOMPAR(6) ='TYPE_MAIL'
         NOMPAR(7) ='TYPE_NORM'
         NOMPAR(8) ='VALE_NORM'

         TYPPAR(1) ='K8'
         TYPPAR(2) ='K16'
         TYPPAR(3) ='I'
         TYPPAR(4) ='R'
         TYPPAR(5) ='K24'
         TYPPAR(6) ='K8'
         TYPPAR(7) ='K8'
         TYPPAR(8) ='R'
      ELSE

         NBPAR=5

         NOMPAR(1)='CHAM_GD'
         NOMPAR(2)='GROUP_MA'
         NOMPAR(3)='TYPE_MAIL'
         NOMPAR(4)='TYPE_NORM'
         NOMPAR(5)='VALE_NORM'

         TYPPAR(1)='K8'
         TYPPAR(2)='K24'
         TYPPAR(3)='K8'
         TYPPAR(4)='K8'
         TYPPAR(5)='R'

      ENDIF
      CALL TBAJPA(RESU,NBPAR,NOMPAR,TYPPAR)
C
C --- 4- REMPLISSAGE DE LA TABLE
C     ==========================
C
C  -- ON COPIE LE CHAMP POUR NE PAS MODIFIER LA DISCRETISATION
C     DU CHAMP INITIAL
      IF (NR.NE.0) THEN
          TMPRES='TMP_RESU'
          CALL COPISD('RESULTAT','V',RESUCO,TMPRES)
      ELSE
          TMPCHA='TMP_CHAMP_GD'
          CALL COPISD('CHAMP','V',CHAMG,TMPCHA)
      ENDIF

C  --- BOUCLE SUR LES NUMEROS D'ORDRE:
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
            CALL GETVTX('NORME','NOM_CHAM',1,IARG,1,NOMCHA,IRET)
            IF (IRET.EQ.0) CALL U2MESS('F','POSTELEM_4')
            CALL RSEXCH(' ',TMPRES,NOMCHA,NUMO,CHAM2,IRET)

          ELSE
C         -- CHAM_GD --
            NUMO = NBORDR
            CHAM2 = TMPCHA
            NOMCHA= CHAMG
          ENDIF

          CALL DISMOI('C','TYPE_CHAMP',CHAM2,'CHAMP',IBID,TYCH,IRET)
          CALL DISMOI('C','NOM_GD',CHAM2,'CHAMP',IBID,NOMGD,IRET)

C         ON RESTREINT LE CALCUL DE LA NORME AUX CHAMPS DE DEPLACEMENTS,
C         CONTRAINTES, DEFORMATION, TEMPERATURE, FLUX ...
          IF(NOMGD(6:6).EQ.'C')GOTO 999
          IF(NOMGD(1:4).NE.'DEPL'.AND.
     &       NOMGD(1:4).NE.'EPSI'.AND.
     &       NOMGD(1:4).NE.'TEMP'.AND.
     &       NOMGD(1:4).NE.'FLUX'.AND.
     &       NOMGD(1:4).NE.'SIEF')GOTO 999

C      -- 4.2 RECUPERATION DES MAILLES --

          CALL GETVTX('NORME','TOUT',1,IARG,1,TOUT,IRET)

          IF(IRET.NE.0)THEN
            MOCLES(1) = 'TOUT'
            TYPMCL(1) = 'TOUT'
            GROUMA    = '-'
          ELSE
            MOCLES(1) = 'GROUP_MA'
            TYPMCL(1) = 'GROUP_MA'
            CALL GETVTX('NORME','GROUP_MA',1,IARG,1,GROUMA,IRET)
          ENDIF

C       - MAILLES FOURNIES PAR L'UTILISATEUR -
          CALL RELIEM(MODELE,MAILLA,'NU_MAILLE','NORME',1,
     &                1,MOCLES,TYPMCL,MESMAI,NBMA)

C       - MAILLES EVENTUELLEMENT FILTREES EN FONCTION DE LA DIMENSION
C         GEOMETRIQUE (2D OU 3D)
          CALL GETVTX('NORME','TYPE_MAILLE',1,IARG,1,INFOMA,IRET)
          IF(IRET.NE.0)THEN
             IF (INFOMA(1:2).EQ.'2D') THEN
               IRESMA=2
             ELSE IF (INFOMA(1:2).EQ.'3D') THEN
               IRESMA=3
             ELSE
               CALL ASSERT(.FALSE.)
             ENDIF
             CALL UTFLMD(MAILLA,MESMAI,IRESMA,' ',NBMA,MESMAF)
             CALL JEDETR(MESMAI)
             MESMAI=MESMAF
          ELSE
             INFOMA='-'
          ENDIF

C       - VERIFICATION SI ON VA TRAITER DES ELEMENTS DE STRUCTURE
          CALL DISMLG('EXI_RDM',MESMAI,IBID,EXIRDM,IRET)
          IF (EXIRDM.EQ.'OUI') THEN
             CALL U2MESS('F','UTILITAI8_60')
          ENDIF

C       - INFOS
          IF (NIV.GT.1) THEN
            WRITE(6,*) '<PENORM> NOMBRE DE MAILLES A TRAITER : ',NBMA
          ENDIF

C      -- 4.3 CHANGEMENT DE LA GRANDEUR DU CHAMP (-> NEUT_R) --

          IF (TYCH(1:4).EQ.'NOEU') THEN
             CALL CNOCNS(CHAM2,'V',CHAMTM)
             CALL JEVEUO(CHAMTM//'.CNSC','L',JLICMP)
             CALL JELIRA(CHAMTM//'.CNSC','LONMAX',NCMPM,K8B)
          ELSEIF (TYCH(1:2).EQ.'EL') THEN
             CALL CELCES(CHAM2,'V',CHAMTM)
             CALL JEVEUO(CHAMTM//'.CESC','L',JLICMP)
             CALL JELIRA(CHAMTM//'.CESC','LONMAX',NCMPM,K8B)
          ENDIF
          CALL JEDETR('&&PENORM.CMP1')
          CALL WKVECT('&&PENORM.CMP1','V V K8',NCMPM,JLICM1)
          CALL JEDETR('&&PENORM.CMP2')
          CALL WKVECT('&&PENORM.CMP2','V V K8',NCMPM,JLICM2)
          DO 15 I=1,NCMPM
              CALL CODENT(I,'G',KI)
              ZK8(JLICM2+I-1)='X'//KI(1:LEN(KI))
              ZK8(JLICM1+I-1)=ZK8(JLICMP+I-1)
 15       CONTINUE
          LIGREL = MODELE//'.MODELE'
          CALL CHSUT1(CHAMTM,'NEUT_R',NCMPM,ZK8(JLICM1),ZK8(JLICM2),
     &                'V',CHAMTM)

C       - INFOS
          IF (NIV.GT.1) THEN
            WRITE(6,*) '<PENORM> NOMBRE DE COMPOSANTES : ',NCMPM
          ENDIF

C      -- 4.4 CREATION D'UNE CARTE DE COEFFICIENTS
C             (UTILE POUR LES TENSEURS) --

          CALL JEDETR('&&PENORM.COEF')
          CALL WKVECT('&&PENORM.COEF','V V R',NB30,JCOEF)
          CALL JEDETR('&&PENORM.CMPX')
          CALL WKVECT('&&PENORM.CMPX','V V K8',NB30,JLICMX)
          DO 19 I=1,NB30
              CALL CODENT(I,'G',KI)
              ZK8(JLICMX+I-1)='X'//KI(1:LEN(KI))
              ZR(JCOEF+I-1)=0.D0
 19       CONTINUE
          IF(NOMGD(1:4).EQ.'DEPL')THEN
            DO 20 I=1,NCMPM
              IF(ZK8(JLICM1+I-1).EQ.'DX      '.OR.
     &           ZK8(JLICM1+I-1).EQ.'DY      '.OR.
     &           ZK8(JLICM1+I-1).EQ.'DZ      ')THEN
                ZR(JCOEF+I-1)=1.D0
                NCMPT=NCMPT+1
              ELSE
                ZR(JCOEF+I-1)=0.D0
              ENDIF
 20         CONTINUE
          ELSEIF(NOMGD(1:4).EQ.'TEMP')THEN
            DO 21 I=1,NCMPM
              IF(ZK8(JLICM1+I-1).EQ.'TEMP    ')THEN
                ZR(JCOEF+I-1)=1.D0
                NCMPT=NCMPT+1
              ELSE
                ZR(JCOEF+I-1)=0.D0
              ENDIF
 21         CONTINUE
          ELSEIF(NOMGD(1:4).EQ.'FLUX')THEN
            DO 22 I=1,NCMPM
              IF(ZK8(JLICM1+I-1).EQ.'FLUX    '.OR.
     &           ZK8(JLICM1+I-1).EQ.'FLUY    '.OR.
     &           ZK8(JLICM1+I-1).EQ.'FLUZ    ')THEN
                ZR(JCOEF+I-1)=1.D0
                NCMPT=NCMPT+1
              ELSE
                ZR(JCOEF+I-1)=0.D0
              ENDIF
 22         CONTINUE
          ELSEIF(NOMGD(1:4).EQ.'EPSI')THEN
            DO 23 I=1,NCMPM
              IF(ZK8(JLICM1+I-1).EQ.'EPXX    '.OR.
     &           ZK8(JLICM1+I-1).EQ.'EPYY    '.OR.
     &           ZK8(JLICM1+I-1).EQ.'EPZZ    ')THEN
                ZR(JCOEF+I-1)=1.D0
                NCMPT=NCMPT+1
              ELSEIF(ZK8(JLICM1+I-1).EQ.'EPXY    '.OR.
     &               ZK8(JLICM1+I-1).EQ.'EPXZ    '.OR.
     &               ZK8(JLICM1+I-1).EQ.'EPYZ    ')THEN
                ZR(JCOEF+I-1)=2.D0
                NCMPT=NCMPT+1
              ELSE
                ZR(JCOEF+I-1)=0.D0
              ENDIF
 23         CONTINUE
          ELSEIF(NOMGD(1:4).EQ.'SIEF')THEN
            DO 24 I=1,NCMPM
              IF(ZK8(JLICM1+I-1).EQ.'SIXX    '.OR.
     &           ZK8(JLICM1+I-1).EQ.'SIYY    '.OR.
     &           ZK8(JLICM1+I-1).EQ.'SIZZ    ')THEN
                ZR(JCOEF+I-1)=1.D0
                NCMPT=NCMPT+1
              ELSEIF(ZK8(JLICM1+I-1).EQ.'SIXY    '.OR.
     &               ZK8(JLICM1+I-1).EQ.'SIXZ    '.OR.
     &               ZK8(JLICM1+I-1).EQ.'SIYZ    ')THEN
                ZR(JCOEF+I-1)=2.D0
                NCMPT=NCMPT+1
              ELSE
                ZR(JCOEF+I-1)=0.D0
              ENDIF
 24         CONTINUE
          ENDIF

C       - INFOS
          IF (NIV.GT.1) THEN
            WRITE(6,*) '<PENORM> NOMBRE DE COMPOSANTES TRAITEES: ',NCMPT
          ENDIF

          CALL MECACT('V',COEFCA,'MODELE',MODELE,'NEUT_R',NB30,
     &                ZK8(JLICMX),IBID,ZR(JCOEF),C16B,K8B)

          IF (TYCH(1:4).EQ.'NOEU') THEN
              CALL CNSCNO(CHAMTM,' ','OUI','V',CHAM2,'F',IRET)
              CALL CNOCNS(CHAM2,'V',CHAMTM)
              CALL DETRSD('CHAM_NO_S',CHAMTM)
          ELSEIF (TYCH(1:4).EQ.'ELNO') THEN
              OPTIO2 ='TOU_INI_ELNO'
              NOPAR = NOPAR2(OPTIO2,'NEUT_R','OUT')
              CALL CESCEL(CHAMTM,LIGREL,OPTIO2,NOPAR,'OUI',NNCP,'V',
     &                CHAM2,'F',IBID)
              CALL DETRSD('CHAM_ELEM_S',CHAMTM)
          ELSEIF (TYCH(1:4).EQ.'ELGA') THEN
              OPTIO2 ='TOU_INI_ELGA'
              NOPAR = NOPAR2(OPTIO2,'NEUT_R','OUT')
              CALL CESCEL(CHAMTM,LIGREL,OPTIO2,NOPAR,'OUI',NNCP,'V',
     &                CHAM1,'F',IBID)
              CALL DETRSD('CHAM_ELEM_S',CHAMTM)
          ELSE
               GOTO 999
          ENDIF

C      -- 4.4 CHANGEMENT DE DISCRETISATION DU CHAMP --

          IF (TYCH(1:4).NE.'ELGA') THEN
             OPTIO2 ='NORME_L2'
             NOPAR='PCHAMPG'
             CELMOD = '&&PENORM.CELMOD'
             CALL ALCHML(LIGREL,OPTIO2,NOPAR,'V',CELMOD,IBID,' ')
             IF (IBID.NE.0) THEN
               VALK2(1)=LIGREL
               VALK2(2)=NOPAR
               VALK2(3)=OPTIO2
               CALL U2MESK('F','UTILITAI3_23',3,VALK2)
             ENDIF
             CALL CHPCHD(CHAM2,'ELGA',CELMOD,'OUI','V',CHAM1)
             CALL DETRSD('CHAMP',CELMOD)
          ENDIF

C      -- 4.5 REDUCTION DU CHAMP EN FONCTION DES MAILLES --

          CALL CELCES(CHAM1,'V',CHAMTM)
          CALL JEVEUO(MESMAI,'L',JMA)
          CALL CESRED(CHAMTM,NBMA,ZI(JMA),0,K8B,'V',CHAMTM)
          OPTIO2 ='NORME_L2'
          NOPAR='PCHAMPG'
          CALL CESCEL(CHAMTM,LIGREL,OPTIO2,NOPAR,'OUI',NNCP,'V',
     &                     CHAM1,'F',IBID)
          CALL DETRSD('CHAM_ELEM_S',CHAMTM)

C      -- 4.6 CALCUL DES COORD. ET DES POIDS DES POINTS DE GAUSS

          CALL MEGEOM(MODELE,CHGEOM)
          LPAIN(1) = 'PGEOMER'
          LCHIN(1) = CHGEOM
          LCHWPG(1)='&&PEECAL.PGCOOR'
          LPAWPG(1)='PCOORPG'
          OPTION = 'COOR_ELGA'

          CALL CALCUL('S',OPTION,LIGREL,1,LCHIN,LPAIN,1,
     &                 LCHWPG,LPAWPG,'V','OUI')

C      -- 4.7 CALCUL DE LA NORME SUR CHAQUE ELEMENT --

          LPAOUT(1) = 'PNORME'
          LCHOUT(1) = '&&PNORME'
          LPAIN(1) = 'PCOORPG'
          LCHIN(1) = LCHWPG(1)
          LPAIN(2) = 'PCHAMPG'
          LCHIN(2) = CHAM1
          LPAIN(3) = 'PCOEFR'
          LCHIN(3) = COEFCA
          OPTION = 'NORME_L2'

          CALL CALCUL('S',OPTION,LIGREL,3,LCHIN,LPAIN,1,
     &                 LCHOUT,LPAOUT,'V','OUI')

C      -- 4.8 SOMMATION DE LA NORME SUR LES ELEMENTS DESIRES --

          CALL MESOMM(LCHOUT(1),1,IBID,VNORM,C16B,0,IBID)

C      -- 4.9 ON REMPLIT LA TABLE --

          IF(NOMPAR(1).EQ.'RESULTAT')THEN
            CALL WKVECT(VALK,'V V K24',4,JVALK)
            ZK24(JVALK)  =RESUCO
            ZK24(JVALK+1)=NOMCHA
            ZK24(JVALK+2)=GROUMA
            ZK24(JVALK+3)=INFOMA
            ZK24(JVALK+4)=TYNORM
            CALL WKVECT(VALR,'V V R',2,JVALR)
            ZR(JVALR)=INST
            ZR(JVALR+1)=SQRT(VNORM(1))
            CALL WKVECT(VALI,'V V I',1,JVALI)
            ZI(JVALI)=NUMO
            CALL TBAJLI(RESU,NBPAR,NOMPAR,ZI(JVALI),ZR(JVALR),C16B,
     &                ZK24(JVALK),0)
          ELSE
            CALL WKVECT(VALK,'V V K24',3,JVALK)
            ZK24(JVALK)  =NOMCHA
            ZK24(JVALK+1)=GROUMA
            ZK24(JVALK+2)=INFOMA
            ZK24(JVALK+3)=TYNORM
            CALL WKVECT(VALR,'V V R',1,JVALR)
            ZR(JVALR)=SQRT(VNORM(1))
            CALL TBAJLI(RESU,NBPAR,NOMPAR,IBID,ZR(JVALR),C16B,
     &                ZK24(JVALK),0)
          ENDIF

C      -- 4.10 NETTOYAGE POUR L'OCCURRENCE SUIVANTE --

          CALL DETRSD('CHAMP',CHAM1)
          CALL DETRSD('CHAMP',CHAM2)
          CALL JEDETR(VALR)
          CALL JEDETR(VALI)
          CALL JEDETR(VALK)
          CALL JEDETR(MESMAI)

C     --- FIN DE LA BOUCLE SUR LES NUMEROS D'ORDRE:
C     ---------------------------------------------
 5      CONTINUE

C     --- FIN DE LA BOUCLE SUR LES OCCURRENCES DU MOT-CLE NORME
C     ---------------------------------------------------------
 999  CONTINUE

      IF (NR.NE.0) THEN
          CALL DETRSD('RESULTAT',TMPRES)
      ELSE
          CALL DETRSD('CHAMP',TMPCHA)
      ENDIF

      CALL JEDEMA()
      END
