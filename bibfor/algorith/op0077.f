      SUBROUTINE OP0077()
      IMPLICIT REAL*8(A-H,O-Z)

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
C
C     OPERATEUR REST_SOUS_STRUC
C
C ----------------------------------------------------------------------
C
C
      INCLUDE 'jeveux.h'
C
C
      CHARACTER*8 K8B,NOMRES,RESIN,NOMSST,MAILSK,MODE
      CHARACTER*8 K8BID,RESULT,BLANC,PARAM(3)
      CHARACTER*16 CONCEP,NOMCMD,TYPRES,TYPREP,CHAMP(4)
      CHARACTER*19 PROFNO
      CHARACTER*24 MATGEN,NUMGEN
      INTEGER IOC1,JORD,NBORD,I,IORD,LPAOUT(3)
      INTEGER      IARG
C
C     -----------------------------------------------------------------
      DATA K8B/'        '/
      DATA PARAM/'MODELE','CHAMPMAT','CARAELEM'/

      CALL JEMARQ()
      CALL INFMAJ()
      K8BID='        '
      BLANC='        '
C
C     -----------------------------------------------------------------
C
C
      CALL GETRES(NOMRES,TYPRES,NOMCMD)
C
C --- PHASE DE TEST SUR LES CHAMPS A RESTITUER
      CALL GETVTX(' ','NOM_CHAM',1,IARG,4,CHAMP,NBCHAM)
      IF (NBCHAM.LT.0) THEN
        CALL U2MESS('E','ALGORITH9_44')
      ELSE
        DO 20 I=1,NBCHAM
          DO 10 J=I+1,NBCHAM
            IF (CHAMP(I).EQ.CHAMP(J)) THEN
              CALL U2MESS('E','ALGORITH9_30')
            ENDIF
   10     CONTINUE
   20   CONTINUE
      ENDIF
C

C --- CREATION DU .REFN DU PROFIL :
C     ---------------------------
      PROFNO=NOMRES//'.PROFC.NUME'
      CALL WKVECT(PROFNO//'.REFN','V V K24',4,JREFN)
      ZK24(JREFN+1)='DEPL_R'
C

C --- LE RESULTAT EST-IL GENERALISE OU PAS :
C     ---------------------------
      CALL GETVID(' ','RESULTAT',1,IARG,0,K8BID,IR)
      IF (IR.EQ.0) THEN
        CALL GETVID(' ','RESU_GENE',1,IARG,1,RESIN,IR1)
        CALL GETTCO(RESIN,CONCEP)
      ELSE
C      --- PROJECTION RESULTAT SUR UN SQUELETTE ENRICHI ---
        CALL GETVID(' ','SQUELETTE',1,IARG,1,MAILSK,IBID)
        CALL GETVID(' ','RESULTAT',1,IARG,1,RESULT,IBID)
        ZK24(JREFN)=MAILSK
        CALL GETFAC('CYCLIQUE',IOC1)
        IF (IOC1.GT.0) THEN
          CALL EXCYGL(NOMRES,TYPRES,RESULT,MAILSK,PROFNO)
          CALL JEVEUO(PROFNO//'.REFN','E',JREFNB)
          ZK24(JREFNB)=MAILSK
          ZK24(JREFNB+1)='DEPL_R'
          CONCEP(1:9)='         '
          RESIN=RESULT
          GOTO 30

        ELSE
          IF (TYPRES.EQ.'MODE_MECA') THEN
            CALL REGRES(NOMRES,MAILSK,RESULT,PROFNO)
            CALL JEVEUO(PROFNO//'.REFN','E',JREFNB)
            ZK24(JREFNB)=MAILSK
            ZK24(JREFNB+1)='DEPL_R'
            CONCEP(1:9)='         '
            RESIN=RESULT
            GOTO 30

          ELSE
            CALL U2MESS('E','ALGORITH9_46')
          ENDIF
        ENDIF
      ENDIF

C INDICATEUR CALCUL SANS MATRICE GENERALISEE (PROJ_MESU_MODAL)
C      PROMES=.FALSE.
      IF ((CONCEP(1:9).EQ.'TRAN_GENE') .OR.
     &    (CONCEP(1:9).EQ.'MODE_GENE') .OR.
     &    (CONCEP(1:9).EQ.'HARM_GENE')) THEN
        CALL JEVEUO(RESIN//'           .REFD','L',J1REFE)
        MATGEN=ZK24(J1REFE)
        NUMGEN=ZK24(J1REFE+3)
C LE RESU_GENE VIENT DE PROJ_MESU_MODAL
        IF ((MATGEN(1:8).EQ.BLANC) .AND. (NUMGEN(1:8).EQ.BLANC)) THEN
C          PROMES=.TRUE.
          TYPREP=BLANC
        ELSE
          IF (NUMGEN(1:8).EQ.BLANC) THEN
            CALL JEVEUO(MATGEN(1:8)//'           .REFA','L',J2REFE)
            NUMGEN=ZK24(J2REFE+1)(1:14)
          ENDIF
          CALL JEVEUO(NUMGEN(1:14)//'.NUME.REFN','L',J3REFE)
          CALL GETTCO(ZK24(J3REFE),TYPREP)
        ENDIF
      ENDIF
C
C     --- DYNAMIQUE TRANSITOIRE ---
C
      IF (CONCEP(1:9).EQ.'TRAN_GENE') THEN
C
        IF (TYPREP(1:11).EQ.'MODELE_GENE') THEN
          CALL GETVID(' ','SQUELETTE',1,IARG,0,K8B,ISK)
          IF (ISK.EQ.0) THEN
            CALL GETVTX(' ','SOUS_STRUC',1,IARG,1,NOMSST,IBID)
            CALL RETREC(NOMRES,RESIN,NOMSST)
          ELSE
            CALL GETVID(' ','SQUELETTE',1,IARG,1,MAILSK,IBID)
            CALL RETRGL(NOMRES,RESIN,MAILSK,PROFNO)
            CALL JEVEUO(PROFNO//'.REFN','E',JREFNB)
            ZK24(JREFNB)=MAILSK
            ZK24(JREFNB+1)='DEPL_R'
          ENDIF


C
        ELSEIF (TYPREP(1:9).EQ.'MODE_GENE') THEN
          CALL GETVTX(' ','SOUS_STRUC',1,IARG,1,NOMSST,N1)
          CALL GETVID(' ','SQUELETTE',1,IARG,1,MAILSK,N2)
          IF ((N1.NE.0.AND.N2.NE.0)) THEN
            CALL U2MESS('F','ALGORITH9_47')
          ENDIF
          CALL GETVID(' ','MODE_MECA',1,IARG,1,MODE,IBID)
          IF (IBID.EQ.0) THEN
            CALL U2MESS('F','ALGORITH9_48')
          ENDIF
          CALL TRAN77(NOMRES,TYPRES,RESIN,MODE)
        ENDIF

C
C     --- CALCUL MODAL PAR SOUS-STRUCTURATION CLASSIQUE ---
C                  OU SANS SOUS-STRUCTURATION
C
      ELSEIF (CONCEP(1:9).EQ.'MODE_GENE') THEN

C --- CAS DE LA SOUS-STRUCTURATION MODALE
        IF (TYPREP(1:11).EQ.'MODELE_GENE') THEN

          CALL GETVID(' ','SQUELETTE',1,IARG,0,K8B,ISK)
          IF (ISK.EQ.0) THEN
            CALL GETVTX(' ','SOUS_STRUC',1,IARG,1,NOMSST,IBID)
            CALL REGEEC(NOMRES,RESIN,NOMSST)
          ELSE
            CALL GETVID(' ','SQUELETTE',1,IARG,1,MAILSK,IBID)
            CALL REGEGL(NOMRES,RESIN,MAILSK,PROFNO)
            CALL JEVEUO(PROFNO//'.REFN','E',JREFNB)
            ZK24(JREFNB)=MAILSK
            ZK24(JREFNB+1)='DEPL_R'
          ENDIF
        ELSE

C     --- CALCUL MODAL SANS SOUS-STRUCTURATION ---
          CALL REGENE(NOMRES,RESIN)
        ENDIF
C
C     --- CALCUL MODAL PAR SOUS-STYRUCTURATION CYCLIQUE ---
C
      ELSEIF (CONCEP(1:9).EQ.'MODE_CYCL') THEN
        CALL GETVID(' ','SQUELETTE',1,IARG,0,K8B,ISK)
        IF (ISK.EQ.0) THEN
          CALL GETVIS(' ','SECTEUR',1,IARG,1,NUMSEC,IBID)
          CALL RECYEC(NOMRES,RESIN,NUMSEC,'MODE_MECA')
        ELSE
          CALL GETVID(' ','SQUELETTE',1,IARG,1,MAILSK,IBID)
          CALL RECYGL(NOMRES,'MODE_MECA',RESIN,MAILSK,PROFNO)
          CALL JEVEUO(PROFNO//'.REFN','E',JREFNB)
          ZK24(JREFNB)=MAILSK
          ZK24(JREFNB+1)='DEPL_R'
        ENDIF
C
C     --- CALCUL HARMONIQUE PAR SOUS-STRUCTURATION CLASSIQUE ---
C
      ELSEIF (CONCEP(1:9).EQ.'HARM_GENE') THEN

C --- CAS DE LA SOUS-STRUCTURATION HARMONIQUE
          IF (TYPREP(1:11).EQ.'MODELE_GENE') THEN
            CALL GETVID(' ','SQUELETTE',1,IARG,0,K8B,ISK)
            IF (ISK.EQ.0) THEN
              CALL GETVTX(' ','SOUS_STRUC',1,IARG,1,NOMSST,IBID)
              CALL REHAEC(NOMRES,RESIN,NOMSST)
            ELSE
              CALL GETVID(' ','SQUELETTE',1,IARG,1,MAILSK,IBID)
              CALL REHAGL(NOMRES,RESIN,MAILSK,PROFNO)
              CALL JEVEUO(PROFNO//'.REFN','E',JREFNB)
              ZK24(JREFNB)=MAILSK
              ZK24(JREFNB+1)='DEPL_R'
            ENDIF

          ELSEIF (TYPREP(1:9).EQ.'MODE_GENE') THEN
            CALL GETVTX(' ','SOUS_STRUC',1,IARG,1,NOMSST,N1)
            CALL GETVID(' ','SQUELETTE',1,IARG,1,MAILSK,N2)
            IF ((N1.NE.0.AND.N2.NE.0)) THEN
              CALL U2MESS('F','ALGORITH9_47')
            ENDIF
            CALL GETVID(' ','MODE_MECA',1,IARG,1,MODE,IBID)
            IF (IBID.EQ.0) THEN
              CALL U2MESS('F','ALGORITH9_48')
            ENDIF
            CALL HARM75(NOMRES,TYPRES,RESIN,NOMCMD,MODE)
          ENDIF
C
      ENDIF
C
   30 CONTINUE
C
C --- STOCKAGE
      CALL GETTCO(RESIN,CONCEP)
      IF ((CONCEP(1:9).NE.'TRAN_GENE') .AND.
     &    (CONCEP(1:9).NE.'MODE_CYCL') .AND.
     &    (CONCEP(1:9).NE.'HARM_GENE')) THEN
        CALL JEVEUO(NOMRES//'           .ORDR','L',JORD)
        CALL JELIRA(NOMRES//'           .ORDR','LONUTI',NBORD,K8B)
        CALL JELIRA(NOMRES//'           .ORDR','LONUTI',NBORD,K8B)
        
        CALL GETVID(' ','SQUELETTE',1,IARG,0,K8B,ISK)
        IF (ISK .EQ. 0) THEN
          CALL GETVTX(' ','SOUS_STRUC',1,IARG,1,NOMSST,IBID)

C-- RECUPERATION DU MACRO ELEMENT ASSOCIE A LA SOUS STRUCTURE
          CALL JEVEUO(RESIN//'           .REFD','L',LRAID)
          CALL JEVEUO ( ZK24(LRAID)(1:19)//'.REFA','L',LNUME)
          CALL JEVEUO ( ZK24(LNUME+1)(1:14)//'.NUME.REFN','L',LMODGE)
          CALL JENONU(JEXNOM(ZK24(LMODGE)(1:8)//'      .MODG.SSNO',
     &                NOMSST),IRET)
          CALL JEVEUO(JEXNUM(ZK24(LMODGE)(1:8)//'      .MODG.SSME',
     &                IRET),'L',LMACR)
C-- RECUPERATION DES INFOS CARA_ELEM / MATER / MODELE POUR LES SST
C-- DANS LE .REFM DANS LE MACRO ELEMENT CORRESPONDANT
          CALL JEVEUO(ZK8(LMACR)//'.REFM','L',LREFM)
          DO 50 IORD=1,NBORD
            CALL RSADPA(NOMRES,'E',3,PARAM,ZI(JORD+IORD-1),0,LPAOUT,K8B)
            ZK8(LPAOUT(1))=ZK8(LREFM)
            ZK8(LPAOUT(2))=ZK8(LREFM+2)
            ZK8(LPAOUT(3))=ZK8(LREFM+3)
   50     CONTINUE
        ENDIF

      ENDIF

C     -- CREATION DE L'OBJET .REFD SI NECESSAIRE:
C     -------------------------------------------
      CALL AJREFD(' ',NOMRES,'FORCE')


      CALL JEDEMA()
      END
