      SUBROUTINE REGEGL ( NOMRES, RESGEN, MAILSK, PROFNO )
      IMPLICIT  NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM
      CHARACTER*8         NOMRES, RESGEN, MAILSK
      CHARACTER*19                                PROFNO
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C
C  BUT : < RESTITUTION GENERALISEE GLOBALE >
C
C  RESTITUER EN BASE PHYSIQUE SUR UN MAILLAGE SQUELETTE LES RESULTATS
C  ISSUS DE LA SOUS-STRUCTURATION GENERALE.
C  LE CONCEPT RESULTAT EST UN RESULTAT COMPOSE "MODE_MECA"
C
C-----------------------------------------------------------------------
C
C NOMRES  /I/ : NOM K8 DU CONCEPT MODE_MECA RESULTAT
C RESGEN  /I/ : NOM K8 DU RESULTAT GENERALISE AMONT
C MAILSK  /I/ : NOM K8 DU MAILLAGE SQUELETTE SUPPORT
C PROFNO  /I/ : NOM K19 DU PROF_CHNO DU SQUELETTE
C
C
C
C
C
      INTEGER      I,IAD,IAR,IBID,IDEP,IEQ,IER,IORD,IRET,J,JBID,K,L,
     &             LDNEW,LLCHAB,LLCHOL,LLIND,LLINER,LLINSK,LLMASS,
     &             I1,K1,LLNUEQ,LLORS,LLPRS,LLROT,LREFE,LTROTX,
     &             LTROTY,LTROTZ,LTVEC,LTYPE,NBBAS,NBCMP,NBCOU,NBMAS,
     &             NBMAX,NBMOD,NBNOT,NBSST,NEQ, NEQS,NNO,NUMO,NUTARS,
     &             LLREF1,LLREF2,LLREF3,ELIM,LMOET,NEQET,LMAPRO,
     &             NEQRED,LSILIA,NUMSST,LSST
      INTEGER      IADPAR(9)
      INTEGER VALI(2)
      REAL*8       COMPX,COMPY,COMPZ,EFMASX,EFMASY,EFMASZ,FREQ,GENEK,
     &             GENEM,MAT(3,3),OMEG2,RBID
      CHARACTER*8  BASMOD,MACREL,MODGEN,SOUTR,KBID
      CHARACTER*16 DEPL,NOMPAR(9)
      CHARACTER*19 RAID,NUMDDL,NUMGEN,CHAMNE
      CHARACTER*24 CREFE(2),CHAMOL,CHAMBA,INDIRF,SELIAI,SIZLIA,SST
      CHARACTER*24 VALK,NOMSST
      COMPLEX*16   CBID
      CHARACTER*1 K1BID
      INTEGER      IARG
C
C-----------------------------------------------------------------------
      DATA DEPL   /'DEPL            '/
      DATA SOUTR  /'&SOUSSTR'/
      DATA NOMPAR /'FREQ','RIGI_GENE','MASS_GENE','OMEGA2','NUME_MODE',
     &             'MASS_EFFE_DX','MASS_EFFE_DY','MASS_EFFE_DZ',
     &             'TYPE_MODE'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()

      INDIRF='&&REGEGL.INDIR.SST'
C
C-----ECRITURE DU TITRE-------------------------------------------------
C
      CALL TITRE
C
C-----VERIF SQUELETTE---------------------------------------------------
C
      CALL JEEXIN(MAILSK//'.INV.SKELETON',IRET)
      IF(IRET.EQ.0) THEN
             VALK = MAILSK
        CALL U2MESG('F', 'ALGORITH14_27',1,VALK,0,0,0,0.D0)
      ENDIF
      CALL JEVEUO(MAILSK//'.INV.SKELETON','L',LLINSK)
C
C-----RECUPERATION DU MODELE GENERALISE--------------------------------
C
      CALL JEVEUO(RESGEN//'           .REFD','L',LLREF1)
      RAID=ZK24(LLREF1)
      CALL JELIBE(RESGEN//'           .REFD')
C
      CALL JEVEUO(RAID//'.REFA','L',LLREF2)
      NUMGEN(1:14)=ZK24(LLREF2+1)
      NUMGEN(15:19)='.NUME'
      CALL JELIBE(RAID//'.REFA')
C
      CALL JEVEUO(NUMGEN//'.REFN','L',LLREF3)
      MODGEN=ZK24(LLREF3)
      CALL JELIBE(NUMGEN//'.REFN')
C
      CALL JELIRA(MODGEN//'      .MODG.SSNO','NOMMAX',NBSST,K1BID)
      KBID='  '
      CALL MGUTDM(MODGEN,KBID,1,'NB_CMP_MAX',NBCMP,KBID)
C
C-----RECUPERATION DES ROTATIONS----------------------------------------
C
      CALL WKVECT('&&REGEGL.ROTX','V V R',NBSST,LTROTX)
      CALL WKVECT('&&REGEGL.ROTY','V V R',NBSST,LTROTY)
      CALL WKVECT('&&REGEGL.ROTZ','V V R',NBSST,LTROTZ)
      DO 15 I=1,NBSST
        CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSOR',I),'L',LLROT)
        ZR(LTROTZ+I-1)=ZR(LLROT)
        ZR(LTROTY+I-1)=ZR(LLROT+1)
        ZR(LTROTX+I-1)=ZR(LLROT+2)
15    CONTINUE
C
C-----CREATION DU PROF-CHAMNO-------------------------------------------
C
      CALL GENUGL(PROFNO,INDIRF,MODGEN,MAILSK)
      CALL JELIRA(PROFNO//'.NUEQ','LONMAX',NEQ,K1BID)
C
C-----RECUPERATION DU NOMBRE DE NOEUDS----------------------------------
C
      CALL DISMOI('F','NB_NO_MAILLA',MAILSK,'MAILLAGE',NBNOT,KBID,IRET)
C
C-----RECUPERATION DE LA BASE MODALE------------------------------------
C
      CREFE(1)=MAILSK
      CREFE(2)=PROFNO
C
C-----RECUPERATION NOMBRE DE MODES PROPRES CALCULES---------------------
C
      CALL RSORAC(RESGEN,'LONUTI',IBID,RBID,KBID,CBID,RBID,
     &            KBID,NBMOD,1,IBID)

C
C --- ON RESTITUE SUR TOUS LES MODES OU SUR QUELQUES MODES:
C
      CALL GETVIS ( ' ', 'NUME_ORDRE', 1,IARG,0, IBID, NNO )
      IF ( NNO .NE. 0 ) THEN
        NBMOD = -NNO
        CALL WKVECT ( '&&REGEGL.NUME', 'V V I', NBMOD, JBID )
        CALL GETVIS ( ' ', 'NUME_ORDRE', 1,IARG,NBMOD, ZI(JBID), NNO )
      ELSE
        CALL WKVECT ( '&&REGEGL.NUME', 'V V I', NBMOD, JBID )
        DO 2 I = 1 , NBMOD
           ZI(JBID+I-1) = I
 2      CONTINUE
      ENDIF
C
C-----ALLOCATION STRUCTURE DE DONNEES RESULTAT--------------------------
C
      CALL RSCRSD('G',NOMRES,'MODE_MECA',NBMOD)
C
C-- ON TESTE SI ON A EU RECOURS A L'ELIMINATION
C

C      SELIAI= '&&'//NUMGEN(1:8)//'PROJ_EQ_LIAI'
C      SIZLIA='&&'//NUMGEN(1:8)//'VECT_SIZE_SS'
C      SST=    '&&'//NUMGEN(1:8)//'VECT_NOM_SS'
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
CC
CCC---RESTITUTION PROPREMENT DITE---------------------------------------
CC
C
      CALL JEVEUO(NUMGEN//'.NUEQ','L',LLNUEQ)
      CALL JENONU(JEXNOM(NUMGEN//'.LILI',SOUTR),IBID)
      CALL JEVEUO(JEXNUM(NUMGEN//'.ORIG',IBID),'L',LLORS)
      CALL JENONU(JEXNOM(NUMGEN//'.LILI',SOUTR),IBID)
      CALL JEVEUO(JEXNUM(NUMGEN//'.PRNO',IBID),'L',LLPRS)
C
C  BOUCLE SUR LES MODES A RESTITUER
C
      DO 20 I = 1,NBMOD
        IORD = ZI(JBID+I-1)
C
C  REQUETTE NOM ET ADRESSE CHAMNO GENERALISE
C
        CALL DCAPNO ( RESGEN, DEPL, IORD, CHAMOL )
        CALL JEVEUO ( CHAMOL, 'L', LLCHOL )

C-- SI ELIMINATION, ON RESTITUE D'ABORD LES MODES GENERALISES
        IF (ELIM .NE. 0) THEN
          DO 21 I1=1,NEQET
            ZR(LMOET+I1-1)=0.D0
            DO 31 K1=1,NEQRED
              ZR(LMOET+I1-1)=ZR(LMOET+I1-1)+
     &          ZR(LMAPRO+(K1-1)*NEQET+I1-1)*
     &          ZR(LLCHOL+K1-1)
  31        CONTINUE
  21      CONTINUE
          LLCHOL=LMOET
        ENDIF
C
C  REQUETTE NOM ET ADRESSE NOUVEAU CHAMNO
C
        CALL RSEXCH(' ',NOMRES, DEPL, I, CHAMNE, IER )
        CALL VTCREA ( CHAMNE, CREFE, 'G', 'R', NEQ )
        CALL JEVEUO ( CHAMNE//'.VALE', 'E', LDNEW )
C
        CALL RSADPA ( RESGEN, 'L', 8,NOMPAR, IORD,0,IADPAR,KBID)
        FREQ   = ZR(IADPAR(1))
        GENEK  = ZR(IADPAR(2))
        GENEM  = ZR(IADPAR(3))
        OMEG2  = ZR(IADPAR(4))
        NUMO   = ZI(IADPAR(5))
        EFMASX = 0.D0
        EFMASY = 0.D0
        EFMASZ = 0.D0
C
C  BOUCLE SUR LES SOUS-STRUCTURES
C
        DO 30 K = 1,NBSST
          CALL JEEXIN(JEXNUM(INDIRF,K),IRET)

C
C  TEST SI LA SST GENERE DES DDL GLOBAUX
C
          IF(IRET.NE.0) THEN
            KBID='  '
            IF (ELIM .NE. 0) THEN
              CALL JENONU(JEXNOM(NOMSST,ZK8(LSST+K-1)),NUMSST)
              IEQ=0
              DO 41 I1=1,NUMSST-1
                IEQ=IEQ+ZI(LSILIA+I1-1)
  41          CONTINUE
            ELSE
              NUMSST=K
C  RECUPERATION DU NUMERO TARDIF DE LA SST
              DO 40 J=1,NBSST
                IF(ZI(LLORS+J-1).EQ.NUMSST) NUTARS=J
  40          CONTINUE
              IEQ=ZI(LLPRS+(NUTARS-1)*2)
            ENDIF

            CALL MGUTDM(MODGEN,KBID,K,'NOM_BASE_MODALE',IBID,
     &                  BASMOD)
            CALL JEVEUO(BASMOD//'           .REFD','L',LREFE)
            CALL JEVEUO(ZK24(LREFE+4)(1:8)//'.IDC_TYPE','L',
     &                  LTYPE)
            IF (ZK8(LTYPE).EQ.'AUCUN') THEN
             VALI (1) = K
             VALI (2) = K
             CALL U2MESG('A', 'ALGORITH14_28',0,' ',2,VALI,0,0.D0)
            ENDIF
            CALL MGUTDM(MODGEN,KBID,K,'NOM_MACR_ELEM',IBID,MACREL)
            CALL JEVEUO(MACREL//'.MAEL_MASS_VALE','L',LLMASS)
            CALL JELIRA(MACREL//'.MAEL_MASS_VALE','LONMAX',NBMAX,
     &                  K1BID)
            CALL JELIRA(MACREL//'.MAEL_MASS_VALE','LONUTI',NBMAS,
     &                  K1BID)
            CALL JEVEUO(MACREL//'.MAEL_INER_VALE','L',LLINER)
C
C           --- CALCUL DE LA MATRICE DE ROTAION ---
            CALL JEVEUO(JEXNUM(MODGEN//'      .MODG.SSOR',K),
     &                  'L',LLROT)
            CALL MATROT(ZR(LLROT),MAT)
C
            CALL DISMOI('F','NB_MODES_TOT',BASMOD,'RESULTAT',
     &                      NBBAS,KBID,IER)
            KBID='  '
            CALL MGUTDM(MODGEN,KBID,K,'NOM_NUME_DDL',IBID,NUMDDL)
            CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQS,KBID,IRET)
            CALL WKVECT('&&REGEGL.TRAV','V V R',NEQS,LTVEC)
C
C  BOUCLE SUR LES MODES PROPRES DE LA BASE
C
            DO 50 J=1,NBBAS
              CALL DCAPNO(BASMOD,DEPL,J,CHAMBA)
              CALL JEVEUO(CHAMBA,'L',LLCHAB)
C
C  BOUCLE SUR LES EQUATIONS PHYSIQUES
C
              IF (ELIM .NE. 0) THEN
                IAD=LLCHOL+IEQ+J-1
              ELSE
                IAD=LLCHOL+ZI(LLNUEQ+IEQ+J-2)-1
              ENDIF

C-- DANS LE CAS ELIM, CHANGER LE IAD, le ZI(LLNUEQ EST PAS BON)

C           --- CALCUL DES MASSES EFFECTIVES ---
              COMPX = ZR(LLINER+J-1)
              COMPY = ZR(LLINER+NBBAS+J-1)
              COMPZ = ZR(LLINER+2*NBBAS+J-1)
C             --- UTILISATION DE MAT TRANSPOSEE (TRANSFORMATION INVERSE)
              EFMASX = EFMASX + ZR(IAD)*(COMPX*MAT(1,1) + COMPY*MAT(2,1)
     &                                   + COMPZ*MAT(3,1))
              EFMASY = EFMASY + ZR(IAD)*(COMPX*MAT(1,2) + COMPY*MAT(2,2)
     &                                   + COMPZ*MAT(3,2))
              EFMASZ = EFMASZ + ZR(IAD)*(COMPX*MAT(1,3) + COMPY*MAT(2,3)
     &                                   + COMPZ*MAT(3,3))
C
C  BOUCLE SUR LES DDL DE LA BASE
C
              DO 60 L=1,NEQS
                ZR(LTVEC+L-1)=ZR(LTVEC+L-1)+ZR(LLCHAB+L-1)*
     &                        ZR(IAD)
60            CONTINUE

              CALL JELIBE(CHAMBA)
50          CONTINUE
            CALL JEVEUO(JEXNUM(INDIRF,K),'L',LLIND)
            CALL JELIRA(JEXNUM(INDIRF,K),'LONMAX',NBCOU,K1BID)
            NBCOU=NBCOU/2
            DO 70 L=1,NBCOU
              IDEP=ZI(LLIND+(L-1)*2)
              IAR=ZI(LLIND+(L-1)*2+1)
              ZR(LDNEW+IAR-1)=ZR(LTVEC+IDEP-1)
70          CONTINUE
            CALL JELIBE(JEXNUM(INDIRF,K))
            CALL JEDETR('&&REGEGL.TRAV')
          ENDIF
30      CONTINUE
C
        EFMASX = EFMASX*EFMASX/GENEM
        EFMASY = EFMASY*EFMASY/GENEM
        EFMASZ = EFMASZ*EFMASZ/GENEM
        CALL RSNOCH ( NOMRES,DEPL,I)
        CALL RSADPA ( NOMRES,'E',9,NOMPAR,I,0,IADPAR,KBID)
        ZR(IADPAR(1)) = FREQ
        ZR(IADPAR(2)) = GENEK
        ZR(IADPAR(3)) = GENEM
        ZR(IADPAR(4)) = OMEG2
        ZI(IADPAR(5)) = NUMO
        ZR(IADPAR(6)) = EFMASX
        ZR(IADPAR(7)) = EFMASY
        ZR(IADPAR(8)) = EFMASZ
        ZK16(IADPAR(9)) = 'MODE_DYN'
C
        CALL JELIBE(CHAMOL)
C
C  ROTATION DU CHAMPS AUX NOEUDS
C
        CALL ROTCHM(PROFNO,ZR(LDNEW),ZR(LTROTZ),NBSST,ZI(LLINSK),NBNOT,
     &              NBCMP,3)
        CALL ROTCHM(PROFNO,ZR(LDNEW),ZR(LTROTY),NBSST,ZI(LLINSK),NBNOT,
     &              NBCMP,2)
        CALL ROTCHM(PROFNO,ZR(LDNEW),ZR(LTROTX),NBSST,ZI(LLINSK),NBNOT,
     &              NBCMP,1)
20    CONTINUE
C
C --- MENAGE
      CALL JEDETR('&&REGEGL.ROTX')
      CALL JEDETR('&&REGEGL.ROTY')
      CALL JEDETR('&&REGEGL.ROTZ')
C
      CALL JEDETR ('&&MODE_ETENDU_REST_ELIM')
      CALL JEDETR ( INDIRF )
      CALL JELIBE ( NUMGEN//'.NUEQ' )
      CALL JEDETR ( '&&REGEGL.NUME' )
C
      CALL JEDEMA()
      END
