      SUBROUTINE OP0075 (IER)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER            IER
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/06/2005   AUTEUR NICOLAS O.NICOLAS 
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
C-----------------------------------------------------------------------
C
C     OPERATEUR REST_BASE_PHYS
C
C ----------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ---------------------------
C
      CHARACTER*8  K8B, NOMRES, RESIN, NOMSST, MAILSK, MATGEN, MODE 
      CHARACTER*8  K8BID,BID,RESULT,BLANC
      CHARACTER*14 NUMGEN
      CHARACTER*16 CONCEP, NOMCMD, TYPRES, TYPMAT, TYPREP, CHAMP(4)
      CHARACTER*19 PROFNO
      LOGICAL      PROMES
C
C     -----------------------------------------------------------------
      DATA K8B    /'        '/
      CALL JEMARQ()
      CALL INFMAJ()
      K8BID =  '        '
      BLANC =  '        '
C
C     -----------------------------------------------------------------
C
C
      CALL GETRES(NOMRES,CONCEP,NOMCMD)
C
      CALL GETVTX(' ','NOM_CHAM',1,1,4,CHAMP,NBCHAM)
      IF (NBCHAM .LT.0 ) THEN
         CALL UTMESS('E',NOMCMD,'TROP D''ARGUMENTS POUR "NOM_CHAM"')
      ELSE
         DO 1 I=1,NBCHAM
            DO 2 J=I+1,NBCHAM
               IF ( CHAMP(I).EQ. CHAMP(J) ) THEN
                  CALL UTMESS('E',NOMCMD,'ARGUMENT EN DOUBLE POUR'//
     +                                    ' "NOM_CHAM"')
               ENDIF
    2       CONTINUE
            IF ( CHAMP(I).EQ. 'ACCE_ABSOLU' ) THEN
               CALL GETVID(' ','ACCE_MONO_APPUI',1,1,1,K8B,N1)
               IF ( N1 .EQ. 0 ) THEN
                  CALL UTMESS('E',NOMCMD,'POUR CALCULER UNE '//
     +                    'ACCE_ABSOLU, IL FAUT "ACCE_MONO_APPUI"')
               ENDIF
            ENDIF
    1    CONTINUE
      ENDIF
C
C --- CREATION DU .REFN DU PROFIL :
C     ---------------------------
      PROFNO = NOMRES//'.PROFC.NUME'
      CALL WKVECT(PROFNO(1:19)//'.REFN','G V K24',2,LDREF)
      ZK24(LDREF+1)='DEPL_R'
C
      CALL GETVID(' ','RESULTAT',1,1,0,K8BID,IR)
      IF (IR .EQ. 0) THEN
         CALL GETVID(' ','RESU_GENE',1,1,1,RESIN,IBID)
         CALL GETTCO(RESIN,CONCEP)
      ELSE
C      --- PROJECTION RESULTAT SUR UN SQUELETTE ENRICHI ---
         CALL GETVID(' ','SQUELETTE',1,1,1,MAILSK,IBID)
         CALL GETVID(' ','RESULTAT',1,1,1,RESULT,IBID)
         ZK24(LDREF) = MAILSK
         CALL REGRES(NOMRES,MAILSK,RESULT)
         CALL JEVEUO(PROFNO(1:19)//'.REFN','E',LDREFB)
         ZK24(LDREFB) = MAILSK
         ZK24(LDREFB+1) = 'DEPL_R'
         CONCEP(1:9) = '         '
      ENDIF

C INDICATEUR CALCUL SANS MATRICE GENERALISEE (PROJ_MESU_MODAL)
      PROMES = .FALSE.
      IF (CONCEP(1:9).EQ.'TRAN_GENE') THEN
        CALL JEVEUO(RESIN//'           .REFD','L',J1REFE)
        MATGEN = ZK24(J1REFE)
        IF (MATGEN(1:8) .EQ. BLANC)
     &       PROMES = .TRUE.
      ELSEIF ((CONCEP(1:9).EQ.'MODE_GENE') .OR.
     &     (CONCEP(1:9).EQ.'HARM_GENE')) THEN
        CALL JEVEUO(RESIN//'           .REFD','L',J1REFE)
        MATGEN = ZK24(J1REFE)
        IF (MATGEN(1:8) .EQ. BLANC)
     &       PROMES = .TRUE.
      ENDIF
C
C     --- DYNAMIQUE TRANSITOIRE ---
C
      IF (CONCEP(1:9).EQ.'TRAN_GENE') THEN
        TYPRES = 'DYNA_TRANS'
        CALL JEVEUO(RESIN//'           .REFD','L',J1REFE)
        MATGEN = ZK24(J1REFE)
        IF (PROMES) THEN
          TYPMAT = ' '
        ELSE
          CALL GETTCO(MATGEN,TYPMAT)
        ENDIF
C
C --- CAS DU CALCUL TRANSITOIRE CLASSIQUE
CCC ASUPPRIMER DEPUISICI
        IF (TYPMAT.EQ.'MATR_GENE       ') THEN
            CALL TRAN75(NOMRES,TYPRES,RESIN,NOMCMD,K8B)
CCC ASUPPRIMER JUSQUELA
C
        ELSEIF (PROMES) THEN
            CALL TRAN75(NOMRES,TYPRES,RESIN,NOMCMD,K8B)
C
C --- CAS DE LA SOUS-STRUCTURATION TRANSITOIRE
        ELSEIF (TYPMAT.EQ.'MATR_ASSE_GENE_R') THEN
          CALL JEVEUO(MATGEN//'           .REFA','L',J2REFE)
          NUMGEN = ZK24(J2REFE+1)(1:14)
          CALL JEVEUO(NUMGEN//'.NUME.REFN','L',J3REFE)
          CALL GETTCO(ZK24(J3REFE),TYPREP)
          IF (TYPREP.EQ.'MODELE_GENE     ') THEN
            CALL GETVID(' ','SQUELETTE',1,1,0,K8B,ISK)
            IF (ISK.EQ.0) THEN
              CALL GETVTX(' ','SOUS_STRUC',1,1,1,NOMSST,IBID)
              CALL RETREC(NOMRES,RESIN,NOMSST)
            ELSE
              CALL GETVID(' ','SQUELETTE',1,1,1,MAILSK,IBID)
              PROFNO = NOMRES//'.PROFC.NUME'
              CALL RETRGL(NOMRES,RESIN,MAILSK,PROFNO)
              CALL JEVEUO(PROFNO(1:19)//'.REFN','E',LDREFB)
              ZK24(LDREFB) = MAILSK
              ZK24(LDREFB+1) = 'DEPL_R'
            ENDIF
          ELSEIF ((TYPREP(1:9).EQ.'MODE_MECA').OR.
     +           (TYPREP(1:9).EQ.'MODE_STAT')) THEN
            CALL TRAN75(NOMRES,TYPRES,RESIN,NOMCMD,K8BID)
C
          ELSEIF (TYPREP(1:11).EQ.'BASE_MODALE') THEN
            CALL TRAN75(NOMRES,TYPRES,RESIN,NOMCMD,K8BID)
C
          ELSEIF (TYPREP(1:9).EQ.'MODE_GENE') THEN
            CALL GETVTX(' ','SOUS_STRUC',1,1,1,NOMSST,N1)
            CALL GETVID(' ','SQUELETTE',1,1,1,MAILSK,N2)
            IF ((N1.NE.0.AND.N2.NE.0).OR.(N1.NE.0).OR.(N2.NE.0)) THEN
              CALL UTMESS('F',NOMCMD,'MOTS-CLES''SOUS_STRUC'' '//
     +                    'ET''SQUELETTE''INTERDITS')
            ENDIF
            CALL GETVID(' ','MODE_MECA',1,1,1,MODE,IBID)
            IF (IBID.EQ.0) THEN
              CALL UTMESS('F',NOMCMD,'MOTS-CLE''MODE_MECA'' '//
     +                    'DOIT ETRE PRESENT')
            ENDIF
            CALL TRAN75(NOMRES,TYPRES,RESIN,NOMCMD,MODE)
          ENDIF
        ENDIF
C
C     --- CALCUL MODAL PAR SOUS-STRUCTURATION CLASSIQUE ---
C                  OU SANS SOUS-STRUCTURATION
C
      ELSEIF(CONCEP(1:9).EQ.'MODE_GENE') THEN
        CALL JEVEUO(RESIN//'           .REFD','L',J1REFE)
        MATGEN = ZK24(J1REFE)
        IF (PROMES) THEN
          TYPMAT = ' '
          CALL REGENE(NOMRES,RESIN)
        ELSE
          CALL GETTCO(MATGEN,TYPMAT)
          CALL JEVEUO(MATGEN//'           .REFA','L',J2REFE)
          NUMGEN = ZK24(J2REFE+1)(1:14)
          CALL JEVEUO(NUMGEN//'.NUME.REFN','L',J3REFE)
          CALL GETTCO(ZK24(J3REFE),TYPREP)
          IF (TYPREP.EQ.'MODELE_GENE     ') THEN
             CALL GETVID(' ','SQUELETTE',1,1,0,K8B,ISK)
             IF (ISK.EQ.0) THEN
                CALL GETVTX(' ','SOUS_STRUC',1,1,1,NOMSST,IBID)
                CALL REGEEC(NOMRES,RESIN,NOMSST)
             ELSE
                CALL GETVID(' ','SQUELETTE',1,1,1,MAILSK,IBID)
                PROFNO = NOMRES//'.PROFC.NUME'
                CALL REGEGL(NOMRES,RESIN,MAILSK,PROFNO)
                CALL JEVEUO(PROFNO(1:19)//'.REFN','E',LDREFB)
                ZK24(LDREFB) = MAILSK
                ZK24(LDREFB+1) = 'DEPL_R'
             ENDIF
          ELSE
C     --- CALCUL MODAL SANS SOUS-STRUCTURATION ---
             CALL REGENE(NOMRES,RESIN)
          ENDIF
        ENDIF    
C
C     --- CALCUL MODAL PAR SOUS-STYRUCTURATION CYCLIQUE ---
C
      ELSEIF (CONCEP(1:9).EQ.'MODE_CYCL') THEN
         CALL GETVID(' ','SQUELETTE',1,1,0,K8B,ISK)
         IF (ISK.EQ.0) THEN
            CALL GETVIS(' ','SECTEUR',1,1,1,NUMSEC,IBID)
            CALL RECYEC(NOMRES,RESIN,NUMSEC,'MODE_MECA')
         ELSE
            CALL GETVID(' ','SQUELETTE',1,1,1,MAILSK,IBID)
            PROFNO = NOMRES//'.PROFC.NUME'
            CALL RECYGL(NOMRES,'MODE_MECA',RESIN,MAILSK,PROFNO)
            CALL JEVEUO(PROFNO(1:19)//'.REFN','E',LDREFB)
            ZK24(LDREFB) = MAILSK
            ZK24(LDREFB+1) = 'DEPL_R'
         ENDIF
C
C     --- CALCUL HARMONIQUE PAR PROJ_MESU_MODAL
C
      ELSEIF(CONCEP(1:9).EQ.'HARM_GENE' .AND. PROMES) THEN
        TYPRES = 'DYNA_HARMO'
        CALL HARM75(NOMRES,TYPRES,RESIN,NOMCMD,K8BID) 
C
C     --- CALCUL HARMONIQUE PAR SOUS-STRUCTURATION CLASSIQUE ---
C
      ELSEIF(CONCEP(1:9).EQ.'HARM_GENE' .AND. (.NOT. PROMES)) THEN
        TYPRES = 'DYNA_HARMO'
        CALL JEVEUO(RESIN//'           .REFD','L',J1REFE)
        MATGEN = ZK24(J1REFE)
        CALL JEVEUO(MATGEN//'           .REFA','L',J2REFE)
        NUMGEN = ZK24(J2REFE+1)(1:14)
        CALL JEVEUO(NUMGEN//'.NUME.REFN','L',J3REFE)
        CALL GETTCO(ZK24(J3REFE),TYPREP)
        IF (TYPREP.EQ.'MODELE_GENE     ') THEN
          CALL GETVID(' ','SQUELETTE',1,1,0,K8B,ISK)
          IF (ISK.EQ.0) THEN
             CALL GETVTX(' ','SOUS_STRUC',1,1,1,NOMSST,IBID)
             CALL REHAEC(NOMRES,RESIN,NOMSST)
          ELSE
            CALL GETVID(' ','SQUELETTE',1,1,1,MAILSK,IBID)
            PROFNO = NOMRES//'.PROFC.NUME'
            CALL REHAGL(NOMRES,RESIN,MAILSK,PROFNO)
            CALL JEVEUO(PROFNO(1:19)//'.REFN','E',LDREFB)
            ZK24(LDREFB) = MAILSK
            ZK24(LDREFB+1) = 'DEPL_R'
          ENDIF
        ELSEIF ((TYPREP(1:9).EQ.'MODE_MECA').OR.
     +          (TYPREP(1:9).EQ.'MODE_STAT')) THEN
          CALL HARM75(NOMRES,TYPRES,RESIN,NOMCMD,K8BID)
        ELSEIF (TYPREP(1:11).EQ.'BASE_MODALE') THEN
          CALL HARM75(NOMRES,TYPRES,RESIN,NOMCMD,K8BID)        
        ELSEIF (TYPREP(1:9).EQ.'MODE_GENE') THEN
          CALL GETVTX(' ','SOUS_STRUC',1,1,1,NOMSST,N1)
          CALL GETVID(' ','SQUELETTE',1,1,1,MAILSK,N2)
          IF ((N1.NE.0.AND.N2.NE.0)) THEN
            CALL UTMESS('F',NOMCMD,'MOTS-CLES''SOUS_STRUC'' '//
     +                'ET''SQUELETTE''INTERDITS')
          ENDIF
          CALL GETVID(' ','MODE_MECA',1,1,1,MODE,IBID)
          IF (IBID.EQ.0) THEN
            CALL UTMESS('F',NOMCMD,'MOTS-CLE''MODE_MECA'' '//
     +                'DOIT ETRE PRESENT')
          ENDIF
          CALL HARM75(NOMRES,TYPRES,RESIN,NOMCMD,MODE)
        ENDIF
C
      ENDIF
      CALL JEVEUO(PROFNO(1:19)//'.REFN','L',LDREFB)
C
      CALL JEDEMA()
      END
