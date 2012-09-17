      SUBROUTINE RETRGL(NOMRES,RESGEN,MAILSK,PROFNO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2012   AUTEUR LADIER A.LADIER 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C***********************************************************************
      IMPLICIT NONE
C  C. VARE     DATE 16/11/94
C TOLE CRP_20
C-----------------------------------------------------------------------
C
C  BUT : < RESTITUTION TRANSITOIRE GLOBALE >
C
C        RESTITUER EN BASE PHYSIQUE SUR UN MAILLAGE SQUELETTE LES
C        RESULTATS ISSUS D'UN CALCUL TRANSITOIRE PAR SOUS-STRUCTURATION
C        CLASSIQUE
C
C        LE CONCEPT RESULTAT EST UN RESULTAT COMPOSE "DYNA_TRANS"
C
C-----------------------------------------------------------------------
C
C NOMRES /I/ : NOM K8 DU CONCEPT DYNA_TRANS RESULTAT
C RESGEN /I/ : NOM K8 DU RESULTAT GENERALISE AMONT (TRAN_GENE)
C MAILSK /I/ : NOM K8 DU MAILLAGE SQUELETTE SUPPORT
C PROFNO /I/ : NOM K19 DU PROF_CHNO DU SQUELETTE
C
C
C
      INCLUDE 'jeveux.h'
C
C
      REAL*8       EPSI
      CHARACTER*6  PGC
      CHARACTER*8  CHMP(3),K8REP,CRIT,INTERP,K8B,NOMRES,BASMOD,
     &             MAILSK,MODGEN,RESGEN,SOUTR,KBID,K8BID
      CHARACTER*19 NUMDDL,NUMGEN,KNUME,KINST,TRANGE,PROFNO
      CHARACTER*24 CREFE(2),CHAMBA,INDIRF,CHAMNO,SELIAI,SIZLIA,SST,
     &             VALK,NOMSST,K24BID
      INTEGER      ITRESU(3),ELIM,NEQET,NEQRED,LMAPRO,LSILIA,LSST,
     &             LMOET
      INTEGER      IARG
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,I1 ,IAD ,IAR ,IARCHI ,IBID ,ICH 
      INTEGER IDEP ,IDINSG ,IDRESU ,IDVECG ,IEQ ,IER ,IRE1 
      INTEGER IRE2 ,IRE3 ,IRET ,IRETOU ,J ,JINST ,JNUME 
      INTEGER K ,K1 ,L ,LDNEW ,LINST ,LLCHAB ,LLIND 
      INTEGER LLINSK ,LLNEQU ,LLNUEQ ,LLORS ,LLPRS ,LLREF1 ,LLREF2 
      INTEGER LLROT ,LREFE ,LTROTX ,LTROTY ,LTROTZ ,LTVEC ,N1 
      INTEGER NBBAS ,NBCHAM ,NBCMP ,NBCOU ,NBINSG ,NBINST ,NBNOT 
      INTEGER NBSST ,NEQ ,NEQGEN ,NEQS ,NUMSST ,NUTARS 
C-----------------------------------------------------------------------
      DATA PGC   /'RETRGL'/
      DATA SOUTR /'&SOUSSTR'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      INDIRF = '&&'//PGC//'.INDIR.SST'
C
C --- ECRITURE DU TITRE
      CALL TITRE
C
C --- VERIFICATION SQUELETTE
      CALL JEEXIN(MAILSK//'.INV.SKELETON',IRET)
      IF (IRET.EQ.0) THEN
        VALK = MAILSK
        CALL U2MESG('F', 'ALGORITH14_27',1,VALK,0,0,0,0.D0)
      ENDIF
      CALL JEVEUO(MAILSK//'.INV.SKELETON','L',LLINSK)
C
C --- DETERMINATION DES CHAMPS A RESTITUER, PARMI DEPL, VITE ET ACCE
      TRANGE = RESGEN
      CALL JEEXIN(RESGEN//'           .DEPL',IRE1)
      CALL JEEXIN(RESGEN//'           .VITE',IRE2)
      CALL JEEXIN(RESGEN//'           .ACCE',IRE3)
      IF (IRE1.EQ.0.AND.IRE2.EQ.0.AND.IRE3.EQ.0.D0) THEN
        VALK = RESGEN
        CALL U2MESG('F', 'ALGORITH14_35',1,VALK,0,0,0,0.D0)
      ENDIF
C
      CALL GETVTX(' ','TOUT_CHAM',0,IARG,1,K8REP,N1)
      IF (K8REP(1:3).EQ.'OUI') THEN
        IF (IRE1.EQ.0) THEN
          CALL U2MESS('F','ALGORITH10_44')
        ENDIF
        IF (IRE2.EQ.0) THEN
          CALL U2MESS('F','ALGORITH10_45')
        ENDIF
        IF (IRE3.EQ.0) THEN
          CALL U2MESS('F','ALGORITH10_46')
        ENDIF
        NBCHAM = 3
        CHMP(1) = 'DEPL'
        CHMP(2) = 'VITE'
        CHMP(3) = 'ACCE'
        CALL JEVEUO(TRANGE//'.DEPL','L',ITRESU(1))
        CALL JEVEUO(TRANGE//'.VITE','L',ITRESU(2))
        CALL JEVEUO(TRANGE//'.ACCE','L',ITRESU(3))
      ELSE
        CALL GETVTX(' ','NOM_CHAM',0,IARG,1,K8REP,N1)
        IF (K8REP(1:4).EQ.'DEPL'.AND.IRE1.EQ.0) THEN
          CALL U2MESS('F','ALGORITH10_44')
        ELSEIF (K8REP(1:4).EQ.'DEPL'.AND.IRE1.NE.0) THEN
          NBCHAM = 1
          CHMP(1) = 'DEPL'
          CALL JEVEUO(TRANGE//'.DEPL','L',ITRESU(1))
        ELSEIF (K8REP(1:4).EQ.'VITE'.AND.IRE2.EQ.0) THEN
          CALL U2MESS('F','ALGORITH10_45')
        ELSEIF (K8REP(1:4).EQ.'VITE'.AND.IRE2.NE.0) THEN
          NBCHAM = 1
          CHMP(1) = 'VITE'
          CALL JEVEUO(TRANGE//'.VITE','L',ITRESU(1))
        ELSEIF (K8REP(1:4).EQ.'ACCE'.AND.IRE3.EQ.0) THEN
          CALL U2MESS('F','ALGORITH10_46')
        ELSEIF (K8REP(1:4).EQ.'ACCE'.AND.IRE3.NE.0) THEN
          NBCHAM = 1
          CHMP(1) = 'ACCE'
          CALL JEVEUO(TRANGE//'.ACCE','L',ITRESU(1))
        ENDIF
      ENDIF
C
C --- RECUPERATION DE LA NUMEROTATION ET DU MODELE GENERALISE
      CALL JEVEUO(TRANGE//'.REFD','L',LLREF1)
      K24BID=ZK24(LLREF1+4)
      NUMGEN(1:14)=K24BID(1:14)
      NUMGEN(15:19) = '.NUME'
      CALL JEVEUO(NUMGEN//'.REFN','L',LLREF2)
      K24BID=ZK24(LLREF2)
      MODGEN = K24BID(1:8)
      CALL JEVEUO(NUMGEN//'.NEQU','L',LLNEQU)
      NEQGEN = ZI(LLNEQU)
C
      CALL JELIRA(MODGEN//'      .MODG.SSNO','NOMMAX',NBSST,K8BID)
      KBID = '  '
      CALL MGUTDM(MODGEN,KBID,1,'NB_CMP_MAX',NBCMP,K8BID)
C
C --- RECUPERATION DES ROTATIONS
      CALL WKVECT('&&'//PGC//'ROTX','V V R',NBSST,LTROTX)
      CALL WKVECT('&&'//PGC//'ROTY','V V R',NBSST,LTROTY)
      CALL WKVECT('&&'//PGC//'ROTZ','V V R',NBSST,LTROTZ)
      DO 15 I = 1,NBSST
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSOR',I),'L',LLROT)
        ZR(LTROTZ+I-1) = ZR(LLROT)
        ZR(LTROTY+I-1) = ZR(LLROT+1)
        ZR(LTROTX+I-1) = ZR(LLROT+2)
15    CONTINUE
C
C --- CREATION DU PROF-CHAMNO
      CALL GENUGL(PROFNO,INDIRF,MODGEN,MAILSK)
      CALL JELIRA(PROFNO//'.NUEQ','LONMAX',NEQ,K8BID)
C
C --- RECUPERATION DU NOMBRE DE NOEUDS
      CALL DISMOI('F','NB_NO_MAILLA',MAILSK,'MAILLAGE',NBNOT,K8BID,IRET)
C
C --- INFORMATIONS POUR CREATION DES CHAMNO A PARTIR DES .REFE
      CREFE(1) = MAILSK
      CREFE(2) = PROFNO
C
C --- RECUPERATION DES INSTANTS
      CALL GETVTX(' ','CRITERE'  ,0,IARG,1,CRIT,N1)
      CALL GETVR8(' ','PRECISION',0,IARG,1,EPSI,N1)
      CALL GETVTX(' ','INTERPOL' ,0,IARG,1,INTERP,N1)
C
      KNUME = '&&RETREC.NUM_RANG'
      KINST = '&&RETREC.INSTANT'
      CALL RSTRAN(INTERP,TRANGE,' ',1,KINST,KNUME,NBINST,IRETOU)
      IF (IRETOU.NE.0) THEN
        CALL U2MESS('F','ALGORITH10_47')
      ENDIF
      CALL JEEXIN(KINST,IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(KINST,'E',JINST)
        CALL JEVEUO(KNUME,'E',JNUME)
      END IF
C
C --- ALLOCATION DE LA STRUCTURE DE DONNEES RESULTAT-COMPOSE
C
      CALL RSCRSD('G',NOMRES,'DYNA_TRANS',NBINST)
C
C-- ON TESTE SI ON A EU RECOURS A L'ELIMINATION
C
      SELIAI=NUMGEN(1:14)//'.ELIM.BASE'
      SIZLIA=NUMGEN(1:14)//'.ELIM.TAIL'
      SST=   NUMGEN(1:14)//'.ELIM.NOMS'

      CALL JEEXIN(SELIAI,ELIM)
      IF (ELIM .NE. 0) THEN
        NEQET=0
        CALL JEVEUO(NUMGEN//'.NEQU','L',IBID)
        NEQRED=ZI(IBID)
        NOMSST=MODGEN//'      .MODG.SSNO'
        CALL JEVEUO(SELIAI,'L',LMAPRO)
        CALL JEVEUO(SIZLIA,'L',LSILIA)
        CALL JEVEUO(SST,'L',LSST)
        DO 10 I=1,NBSST
          NEQET=NEQET+ZI(LSILIA+I-1)
  10    CONTINUE
        CALL WKVECT('&&MODE_ETENDU_REST_ELIM','V V R',NEQET,LMOET)    
      ENDIF      
C
C -------------------------------------
C --- RESTITUTION SUR BASE PHYSIQUE ---
C -------------------------------------
C
      CALL JEVEUO(NUMGEN//'.NUEQ','L',LLNUEQ)
      CALL JENONU(JEXNOM(NUMGEN//'.LILI',SOUTR),IBID)
      CALL JEVEUO(JEXNUM(NUMGEN//'.ORIG',IBID),'L',LLORS)
      CALL JENONU(JEXNOM(NUMGEN//'.LILI',SOUTR),IBID)
      CALL JEVEUO(JEXNUM(NUMGEN//'.PRNO',IBID),'L',LLPRS)
C
      IARCHI = 0     
       
      IF (INTERP(1:3).NE.'NON') THEN
      
        CALL JEVEUO(TRANGE//'.DISC','L',IDINSG)
        CALL JELIRA(TRANGE//'.DISC','LONMAX',NBINSG,K8B)
        IF (ELIM .EQ. 0) THEN
           CALL WKVECT('&&RETREC.VECTGENE','V V R',NEQGEN,IDVECG)
        ELSE
           CALL WKVECT('&&RETREC.VECTGENE','V V R',NEQET,IDVECG)        
        ENDIF
C
        DO 30 I=0,NBINST-1
          IARCHI = IARCHI + 1
C
          DO 32 ICH=1,NBCHAM
          
            IDRESU = ITRESU(ICH)
            CALL RSEXCH(' ',NOMRES,CHMP(ICH),IARCHI,CHAMNO,IRET)
            IF (IRET.EQ.0) THEN
              CALL U2MESK('A','ALGORITH2_64',1,CHAMNO)
            ELSEIF (IRET.EQ.100) THEN
              CALL VTCREA(CHAMNO,CREFE,'G','R',NEQ)
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF
            CHAMNO(20:24) = '.VALE'
            CALL JEVEUO(CHAMNO,'E',LDNEW)
            CALL EXTRAC(INTERP,EPSI,CRIT,NBINSG,ZR(IDINSG),ZR(JINST+I),
     &                  ZR(IDRESU),NEQGEN,ZR(IDVECG),IER)

C-- SI ELIMINATION, ON RESTITUE D'ABORD LES MODES GENERALISES       
            IF (ELIM .NE. 0) THEN              
              DO 21 I1=1,NEQET
                ZR(LMOET+I1-1)=0.D0
                DO 31 K1=1,NEQRED
                  ZR(LMOET+I1-1)=ZR(LMOET+I1-1)+
     &              ZR(LMAPRO+(K1-1)*NEQET+I1-1)*
     &              ZR(IDVECG+K1-1)
  31            CONTINUE
  21          CONTINUE
            ENDIF
C
C --- BOUCLE SUR LES SOUS-STRUCTURESs
C
            DO 34 K=1,NBSST
              CALL JEEXIN(JEXNUM(INDIRF,K),IRET)
C
C --- TEST SI LA SST GENERE DES DDL GLOBAUX
C
              IF (IRET.NE.0) THEN
C
C --- RECUPERATION DU NUMERO TARDIF DE LA SST
C
                IF (ELIM .NE. 0) THEN
                  CALL JENONU(JEXNOM(NOMSST,ZK8(LSST+K-1)),NUMSST)
                  IEQ=0
                  DO 41 I1=1,K-1
                    IEQ=IEQ+ZI(LSILIA+I1-1)
  41              CONTINUE 
                ELSE
                  NUMSST=K
C  RECUPERATION DU NUMERO TARDIF DE LA SST
                  DO 42 J=1,NBSST
                    IF(ZI(LLORS+J-1).EQ.NUMSST) NUTARS=J
  42              CONTINUE
                  IEQ=ZI(LLPRS+(NUTARS-1)*2)
                ENDIF
                
                KBID = '  '
                CALL MGUTDM(MODGEN,KBID,NUMSST,'NOM_BASE_MODALE',
     &                      IBID,BASMOD)
                CALL DISMOI('F','NB_MODES_TOT',BASMOD,'RESULTAT',
     &                      NBBAS,KBID,IER)
                KBID = '  '
                CALL MGUTDM(MODGEN,KBID,NUMSST,'NOM_NUME_DDL',IBID,
     &                      NUMDDL)
                CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQS,KBID,
     &                      IRET)
                CALL WKVECT('&&'//PGC//'.TRAV','V V R',NEQS,LTVEC)
C
C --- BOUCLE SUR LES MODES PROPRES DE LA BASE
C
                DO 38 J=1,NBBAS
                  CALL DCAPNO(BASMOD,'DEPL',J,CHAMBA)
                  CALL JEVEUO(CHAMBA,'L',LLCHAB)
                  
                  IF (ELIM .NE. 0) THEN
                    IAD=LMOET+IEQ+J-1
                  ELSE
                    IAD=IDVECG+ZI(LLNUEQ+IEQ+J-2)-1
                  ENDIF                                    
C
C --- BOUCLE SUR LES EQUATIONS PHYSIQUES
C
                  DO 40 L=1,NEQS
                    ZR(LTVEC+L-1)=ZR(LTVEC+L-1)+ZR(LLCHAB+L-1)*ZR(IAD)
40                CONTINUE
                  CALL JEDETR('&&'//PGC//'.VECTA')
38              CONTINUE

                CALL JEVEUO(JEXNUM(INDIRF,NUMSST),'L',LLIND)
                CALL JELIRA(JEXNUM(INDIRF,NUMSST),'LONMAX',NBCOU,
     &                      K8BID)
                NBCOU = NBCOU/2
                DO 45 L=1,NBCOU
                  IDEP = ZI(LLIND+(L-1)*2)
                  IAR = ZI(LLIND+(L-1)*2+1)
                  ZR(LDNEW+IAR-1) = ZR(LTVEC+IDEP-1)
45              CONTINUE
                CALL JEDETR('&&'//PGC//'.TRAV')
              ENDIF
C
34          CONTINUE
            CALL RSNOCH(NOMRES,CHMP(ICH),IARCHI)
C
C --- ROTATION DU CHAMP AUX NOEUDS
C
            CALL ROTCHM(PROFNO,ZR(LDNEW),ZR(LTROTZ),NBSST,ZI(LLINSK),
     &                  NBNOT,NBCMP,3)
            CALL ROTCHM(PROFNO,ZR(LDNEW),ZR(LTROTY),NBSST,ZI(LLINSK),
     &                  NBNOT,NBCMP,2)
            CALL ROTCHM(PROFNO,ZR(LDNEW),ZR(LTROTX),NBSST,ZI(LLINSK),
     &                  NBNOT,NBCMP,1)
C
32        CONTINUE
          CALL RSADPA(NOMRES,'E',1,'INST',IARCHI,0,LINST,K8B)
          ZR(LINST) = ZR(JINST+I)
30      CONTINUE
C
      ELSE

        CALL JEEXIN(TRANGE//'.ORDR',IRET)
        IF (IRET.NE.0.AND.ZI(JNUME).EQ.1) IARCHI=-1
C
        DO 50 I=0,NBINST-1
          IARCHI = IARCHI + 1
C
          DO 52 ICH=1,NBCHAM
            IDRESU = ITRESU(ICH)
C-- SI ELIMINATION, ON RESTITUE D'ABORD LES MODES GENERALISES       
            IF (ELIM .NE. 0) THEN      
              DO 22 I1=1,NEQET
                ZR(LMOET+I1-1)=0.D0
                DO 33 K1=1,NEQRED
                  ZR(LMOET+I1-1)=ZR(LMOET+I1-1)+
     &              ZR(LMAPRO+(K1-1)*NEQET+I1-1)*
     &              ZR(IDRESU+K1-1+(ZI(JNUME+I)-1)*NEQRED)
  33            CONTINUE
  22          CONTINUE             
            ENDIF        

            CALL RSEXCH(' ',NOMRES,CHMP(ICH),IARCHI,CHAMNO,IRET)
            IF (IRET.EQ.0) THEN
              CALL U2MESK('A','ALGORITH2_64',1,CHAMNO)
            ELSEIF (IRET.EQ.100) THEN
              CALL VTCREA(CHAMNO,CREFE,'G','R',NEQ)
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF
            CHAMNO(20:24) = '.VALE'
            CALL JEVEUO(CHAMNO,'E',LDNEW)
C
C --- BOUCLE SUR LES SOUS-STRUCTURES
C
            DO 54 K=1,NBSST
              CALL JEEXIN(JEXNUM(INDIRF,K),IRET)
C
C --- TEST SI LA SST GENERE DES DDL GLOBAUX
C
              IF (IRET.NE.0) THEN
C
C --- RECUPERATION DU NUMERO TARDIF DE LA SST
C
                IF (ELIM .NE. 0) THEN
                  CALL JENONU(JEXNOM(NOMSST,ZK8(LSST+K-1)),NUMSST)
                  IEQ=0
                  DO 43 I1=1,K-1
                    IEQ=IEQ+ZI(LSILIA+I1-1)
  43              CONTINUE 
                ELSE
                  NUMSST=K
C  RECUPERATION DU NUMERO TARDIF DE LA SST
                  DO 44 J=1,NBSST
                    IF(ZI(LLORS+J-1).EQ.NUMSST) NUTARS=J
  44              CONTINUE
                  IEQ=ZI(LLPRS+(NUTARS-1)*2)
                ENDIF
                KBID = '  '
                CALL MGUTDM(MODGEN,KBID,NUMSST,'NOM_BASE_MODALE',
     &                      IBID,BASMOD)
                CALL DISMOI('F','NB_MODES_TOT',BASMOD,'RESULTAT',
     &                      NBBAS,KBID,IER)
                KBID = '  '
                CALL MGUTDM(MODGEN,KBID,NUMSST,'NOM_NUME_DDL',IBID,
     &                      NUMDDL)
                CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQS,KBID,
     &                      IRET)
                CALL WKVECT('&&'//PGC//'.TRAV','V V R',NEQS,LTVEC)

C
C --- BOUCLE SUR LES MODES PROPRES DE LA BASE
C
                DO 58 J=1,NBBAS
                  CALL DCAPNO(BASMOD,'DEPL',J,CHAMBA)
                  CALL JEVEUO(CHAMBA,'L',LLCHAB)

                  IF (ELIM .NE. 0) THEN
                    IAD=LMOET+IEQ+J-1
                  ELSE
                    IAD=IDRESU+(ZI(JNUME+I)-1)*NEQGEN+
     &                  ZI(LLNUEQ+IEQ+J-2)-1
                  ENDIF
C
C --- BOUCLE SUR LES EQUATIONS PHYSIQUES
C
                  DO 60 L=1,NEQS
                    ZR(LTVEC+L-1)=ZR(LTVEC+L-1)+ZR(LLCHAB+L-1)*ZR(IAD)
60                CONTINUE
58              CONTINUE
                CALL JEVEUO(JEXNUM(INDIRF,NUMSST),'L',LLIND)
                CALL JELIRA(JEXNUM(INDIRF,NUMSST),'LONMAX',NBCOU,
     &                      K8BID)
                NBCOU = NBCOU/2
                DO 65 L=1,NBCOU
                  IDEP = ZI(LLIND+(L-1)*2)
                  IAR = ZI(LLIND+(L-1)*2+1)
                  ZR(LDNEW+IAR-1) = ZR(LTVEC+IDEP-1)
65              CONTINUE
                CALL JEDETR('&&'//PGC//'.TRAV')
              ENDIF
C
54          CONTINUE
            CALL RSNOCH(NOMRES,CHMP(ICH),IARCHI)
C
C --- ROTATION DU CHAMP AUX NOEUDS
C
            CALL ROTCHM(PROFNO,ZR(LDNEW),ZR(LTROTZ),NBSST,ZI(LLINSK),
     &                  NBNOT,NBCMP,3)
            CALL ROTCHM(PROFNO,ZR(LDNEW),ZR(LTROTY),NBSST,ZI(LLINSK),
     &                  NBNOT,NBCMP,2)
            CALL ROTCHM(PROFNO,ZR(LDNEW),ZR(LTROTX),NBSST,ZI(LLINSK),
     &                  NBNOT,NBCMP,1)
C
52        CONTINUE
          CALL RSADPA(NOMRES,'E',1,'INST',IARCHI,0,LINST,K8B)
          ZR(LINST) = ZR(JINST+I)
50      CONTINUE
C
      ENDIF
C
      CALL WKVECT(NOMRES//'           .REFD','G V K24',7,LREFE)

      ZK24(LREFE  ) = ZK24(LLREF1)
      ZK24(LREFE+1) = ZK24(LLREF1+1)
      ZK24(LREFE+2) = ZK24(LLREF1+2)
      ZK24(LREFE+3) = ZK24(LLREF1+3)
      ZK24(LREFE+4) = '        '
      ZK24(LREFE+5) = ZK24(LLREF1+4)
      ZK24(LREFE+6) = '        '
C
C --- MENAGE
      CALL JEDETR('&&'//PGC//'ROTX')
      CALL JEDETR('&&'//PGC//'ROTY')
      CALL JEDETR('&&'//PGC//'ROTZ')
      CALL JEDETR('&&'//PGC//'.INDIR.SST')

      CALL JEDEMA()
      END
