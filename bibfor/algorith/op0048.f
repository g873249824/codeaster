      SUBROUTINE OP0048 ( IERR )
      IMPLICIT  REAL*8  (A-H,O-Z)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/06/2002   AUTEUR GNICOLAS G.NICOLAS 
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
C     CALCUL MECANIQUE TRANSITOIRE PAR INTEGRATION DIRECTE
C     DIFFERENTS TYPES D'INTEGRATION SONT POSSIBLES:
C     - IMPLICITES :  THETA-WILSON
C                     NEWMARK
C     - EXPLICITE  :  DIFFERENCES CENTREES
C     ------------------------------------------------------------------
C
C  HYPOTHESES :                                                "
C  ----------   SYSTEME CONSERVATIF DE LA FORME  K.U    +    M.U = F
C           OU                                           '     "
C               SYSTEME DISSIPATIF  DE LA FORME  K.U + C.U + M.U = F
C
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'OP0048' )
C
      INTEGER NBPASE
      INTEGER       IMAT(3), NUME
      CHARACTER*8   K8B, NOMRES, MASSE, RIGID, AMORT
      CHARACTER*8   MATREI, MAPREI, MATERI
      CHARACTER*13 INPSCO
      CHARACTER*16  TYPRES, NOMCMD
      CHARACTER*19  CHANNO, SOLVEU, INFCHA, CHSOL
      CHARACTER*19  NOMMAT(3), FORCE1
      CHARACTER*24  MODELE, CARELE, CHARGE, FOMULT, MATE
      CHARACTER*24  NUMEDD, CINE
      CHARACTER*24  INFOCH, CRITER
      LOGICAL       LAMORT, LCREA
C     -----------------------------------------------------------------
      DATA SOLVEU   /'&&OP0048.SOLVEUR'/
      DATA INFCHA   /'&&OP0048.INFCHA'/
      DATA CHSOL    /'&&OP0048.SOLUTION'/
      DATA MODELE   /' '/
      DATA CINE     /'                      '/
C     -----------------------------------------------------------------
C
      CALL JEMARQ()
C               12   345678   90123
      INPSCO = '&&'//NOMPRO//'_PSCO'
      NBPASE = 0
      LAMORT=.TRUE.
      AMORT = ' '
      CRITER = '&&RESGRA_GCPC'
C
C-----RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL GETVIS (' ','INFO',0,1,1,NIV,IBID)
      CALL INFMAJ
C
      CALL INFNIV(IFM,NIV)
C----------------------------------------------------------------------
      CALL GETRES(NOMRES,TYPRES,NOMCMD)
C
C     --- LES MATRICES ---
      NBMAT = 3
      CALL GETVID(' ','MATR_RIGI',0,1,1,RIGID,NR)
      CALL GETVID(' ','MATR_MASS',0,1,1,MASSE,NM)
      CALL GETVID(' ','MATR_AMOR',0,1,1,AMORT,NA)
      IF (NA.LE.0) THEN
         WRITE(IFM,*)'PAS DE MATRICE D''AMORTISSEMENT'
         LAMORT = .FALSE.
         NBMAT = 2
      ENDIF
      NOMMAT(1) = RIGID
      NOMMAT(2) = MASSE
      NOMMAT(3) = AMORT
      CALL MTDSCR(RIGID)
      CALL JEVEUO(RIGID//'           .&INT','E',IMAT(1))
      CALL MTDSCR(MASSE)
      CALL JEVEUO(MASSE//'           .&INT','E',IMAT(2))
      IF ( LAMORT ) THEN
         CALL MTDSCR(AMORT)
         CALL JEVEUO(AMORT//'           .&INT','E',IMAT(3))
      END IF
      NEQ = ZI(IMAT(1)+2)
C
C ------- LE CHARGEMENT
C
      CALL GETFAC('EXCIT',NVECT)
      IF (NVECT.GT.0) THEN
        NVECA = 0
        NCHAR = 0
        DO 120 IVEC=1,NVECT
          CALL GETVID('EXCIT','VECT_ASSE',IVEC,1,1,CHANNO,L)
          IF ( L.EQ.1 ) NVECA = NVECA + 1
          CALL GETVID('EXCIT','CHARGE',   IVEC,1,1,CHANNO,L)
          IF ( L.EQ.1 ) NCHAR = NCHAR + 1
 120    CONTINUE
C        IF ( NVECA .NE. 0 .AND. NCHAR .NE. 0 ) THEN
C          CALL UTMESS ('F','NOMCMD','IMPOSSIBLE DE COMBINER LES MOTS'
C     &                 //' CLES CHARGE ET VECT_ASSE')
C        ENDIF
        IF ( NVECA .NE. 0 ) THEN
C
C ------- LISTE DE VECT_ASSE DECRIVANT LE CHARGEMENT
C
          CALL WKVECT('&&OP0048.LIFONCT'   ,'V V K24',NVECA,IALIFO)
          CALL WKVECT('&&OP0048.ADVECASS','V V I  ',NVECA,IAADVE)
          INDIC = 0
          DO 20 IVEC= 1, NVECA
            INDIC = INDIC + 1
  12        CONTINUE  
            CALL GETVID('EXCIT','VECT_ASSE',INDIC,1,1,CHANNO,L)
            IF (L.EQ.0) THEN
               INDIC = INDIC + 1
               GOTO 12 
            ENDIF
            CALL JEVEUO(CHANNO//'.VALE','L',ZI(IAADVE+IVEC-1))
            CALL GETVID('EXCIT','FONC_MULT',INDIC,1,1
     &                  ,ZK24(IALIFO+IVEC-1),L)
            IF (L.EQ.0 ) THEN
              CALL GETVID('EXCIT','ACCE',INDIC,1,1
     &                  ,ZK24(IALIFO+IVEC-1),L)
              IF (L.EQ.0) THEN
                 RVAL = 1.D0
                 CALL GETVR8('EXCIT','COEF_MULT',INDIC,1,1,RVAL,L)
                 ZK24(IALIFO+IVEC-1) = '&&OP0048.F_'
                 CALL CODENT(IVEC,'G',ZK24(IALIFO+IVEC-1)(12:19))
                 CALL FOCSTE(ZK24(IALIFO+IVEC-1),'INST',RVAL,'V')
              ENDIF
            ENDIF
  20      CONTINUE
        ENDIF
        IF ( NCHAR .NE. 0 ) THEN
C
C ------- LISTE DES CHARGES
C
          CALL GETVID(' ','MODELE',0,1,1,K8B,N1)
          IF ( N1 .EQ. 0 ) THEN
            CALL UTMESS('F',NOMCMD,'LE MODELE EST OBLIGATOIRE')
          ENDIF
          CALL NMDOME ( MODELE, MATE, CARELE, INFCHA,
     >              NBPASE, INPSCO )
          FOMULT = INFCHA//'.FCHA'
          INFOCH = INFCHA//'.INFC'
          CHARGE = INFCHA//'.LCHA'
        ENDIF
      ELSE      
        NVECT=0
        NVECA=0
        NCHAR=0
      ENDIF

C --- TEST DE LA PRESENCE DE CHARGES DE TYPE 'ONDE_PLANE'
      NONDP = 0
      IF (NCHAR.NE.0) THEN
         CALL JEVEUO(INFOCH,'L',JINF)
         CALL JEVEUO(CHARGE,'L',IALICH)
         DO 15 ICH = 1,NCHAR
            IF (ZI(JINF+NCHAR+ICH).EQ.6) THEN
               NONDP = NONDP + 1
            ENDIF
15       CONTINUE
      ENDIF

      IF (NVECA.NE.0.AND.NCHAR.NE.0) THEN
         IF (NCHAR.NE.NONDP) CALL UTMESS ('F','NOMCMD','IMPOSSIBLE DE' 
     &                 //' COMBINER LES MOTS CLES CHARGE ET'
     &                 //' VECT_ASSE EN DEHORS DES ONDES PLANES')
      ENDIF

C --- RECUPERATION DES DONNEES DE CHARGEMENT PAR ONDE PLANE
      IF(NONDP.EQ.0) THEN
         CALL WKVECT('&&OP0048.ONDP','V V K8',1,IONDP)
      ELSE
        CALL WKVECT('&&OP0048.ONDP','V V K8',NONDP,IONDP)
        NOND = 0
        DO 16 ICH = 1,NCHAR
           IF (ZI(JINF+NCHAR+ICH).EQ.6) THEN
              NOND = NOND + 1
              ZK8(IONDP+NOND-1) = ZK24(IALICH+ICH-1)(1:8)
           ENDIF
16      CONTINUE
      ENDIF     
         
      CALL DISMOI('F','NOM_NUME_DDL',RIGID,'MATR_ASSE',IBID,NUMEDD,IE)
      CALL DISMOI('F','NOM_MODELE',RIGID,'MATR_ASSE',IBID,MODELE,IE)
      MATERI = ' '
      CALL DISMOI('F','CHAM_MATER',RIGID,'MATR_ASSE',IBID,MATERI,IE)
      IF (MATERI.NE.' ') CALL RCMFMC( MATERI , MATE )
C
C     --- LECTURE DES PARAMETRES DU MOT CLE FACTEUR SOLVEUR ---
C*+*      CALL CRESOL (SOLVEU,K5BID)
      CALL CRESO2 (NBMAT,NOMMAT,SOLVEU)
C
C ------- CREATION DES VECTEURS DE TRAVAIL SUR BASE VOLATILE
C
      CALL WKVECT('&&OP0048.DEPL0' ,'V V R',NEQ,IDEPL0)
      CALL WKVECT('&&OP0048.VITE0' ,'V V R',NEQ,IVITE0)
      CALL WKVECT('&&OP0048.ACCE0' ,'V V R',NEQ,IACCE0)
      CALL WKVECT('&&OP0048.FORCE0','V V R',NEQ,IFORC0)
      CALL WKVECT('&&OP0048.F'     ,'V V R',NEQ,IWK)
      FORCE1 = '&&OP0048.FORCE1'
      CALL VTCREB (FORCE1, NUMEDD, 'V', 'R', NEQ)
      CALL JEVEUO (FORCE1(1:19)//'.VALE', 'E', IFORC1)
C
C     --- INITIALISATION DE L'ALGORITHME ---
C
      INCHAC = 0
      LCREA = .TRUE.
      CALL DLTINI (NEQ,ZR(IDEPL0),ZR(IVITE0),ZR(IACCE0),LCREA,
     +             NUME , NUMEDD, INCHAC )
      CALL DLTP0(T0)
C
C      --- CHARGEMENT A L'INSTANT INITIAL OU DE REPRISE ---
C
      CALL DLFEXT (NVECA,NCHAR,T0,NEQ,ZI(IAADVE),ZK24(IALIFO),
     +             CHARGE,INFOCH,FOMULT,MODELE,MATE,CARELE,
     +             NUMEDD,ZR(IFORC0))
C
C     --- CALCUL DU CHAMP D'ACCELERATION INITIAL ---
C
      IF ( INCHAC .NE. 0 ) THEN
C
C        --- RESOLUTION AVEC FORCE1 COMME SECOND MEMBRE ---
         CALL JEVEUO (FORCE1(1:19)//'.VALE', 'E', IFORC1)
         CALL R8COPY (NEQ,ZR(IFORC0),1,ZR(IFORC1),1)
         CALL DLFDYN (IMAT(1),IMAT(3),LAMORT,NEQ,
     +                ZR(IDEPL0),ZR(IVITE0),ZR(IFORC1),ZR(IWK))
C
         MATREI = '&&MASSI'
         CALL AJLAGR ( RIGID , MASSE , MATREI )
C
C        --- DECOMPOSITION OU CALCUL DE LA MATRICE DE PRECONDITIONEMENT
         CALL PRERES (SOLVEU,'V',ICODE,MAPREI,MATREI)
C                                       ..          .
C        --- RESOLUTION DU PROBLEME:  M.X  =  F - C.X - K.X
         CALL RESOUD(MATREI,MAPREI,FORCE1,SOLVEU,CINE,'V',CHSOL,CRITER)
         CALL COPISD('CHAMP_GD','V',CHSOL(1:19),FORCE1(1:19))
         CALL JEVEUO (FORCE1(1:19)//'.VALE', 'L', IFORC1)
         CALL DETRSD('CHAMP_GD',CHSOL)
         CALL R8COPY(NEQ,ZR(IFORC1),1,ZR(IACCE0),1)
      ENDIF
C
C ------- INTEGRATION SELON LE TYPE SPECIFIE
C
      CALL GETFAC('NEWMARK',NBOCC)
      IF (NBOCC.EQ.1) THEN
         IINTEG = 1
         CALL DLNEWI(LCREA,LAMORT,IINTEG,NEQ,IMAT,
     &               MASSE,RIGID,AMORT,
     &               ZR(IDEPL0),ZR(IVITE0),ZR(IACCE0),
     &               NCHAR,NVECA,ZI(IAADVE),ZK24(IALIFO),
     &               MODELE,MATE,CARELE,
     &               CHARGE,INFOCH,FOMULT,NUMEDD,NUME,SOLVEU,
     &               ZR(IFORC0),FORCE1,ZK8(IONDP),NONDP)
      ELSE
         CALL GETFAC('WILSON',NBOCC)
         IF (NBOCC.EQ.1) THEN
            IINTEG=2
          CALL DLNEWI(LCREA,LAMORT,IINTEG,NEQ,IMAT,
     &                MASSE,RIGID,AMORT,
     &                ZR(IDEPL0),ZR(IVITE0),ZR(IACCE0),
     &                NCHAR,NVECA,ZI(IAADVE),ZK24(IALIFO),
     &                MODELE,MATE,CARELE,
     &                CHARGE,INFOCH,FOMULT,NUMEDD,NUME,SOLVEU,
     &                ZR(IFORC0),FORCE1,ZK8(IONDP),NONDP)
         ELSE
            CALL GETFAC('DIFF_CENTRE',NBOCC)
            IF (NBOCC.EQ.1) THEN
               IINTEG=3
               CALL DLDIFF(T0,LCREA,LAMORT,NEQ,IMAT,
     &                MASSE,RIGID,AMORT,
     &                ZR(IDEPL0),ZR(IVITE0),ZR(IACCE0),
     &                NCHAR,NVECA,ZI(IAADVE),ZK24(IALIFO),
     &                MODELE,MATE,CARELE,
     &                CHARGE,INFOCH,FOMULT,NUMEDD,NUME)
            ELSE
              CALL GETFAC('ADAPT',NBOCC)
              IF (NBOCC.EQ.1) THEN
                IINTEG=4
                CALL DLADAP(T0,LCREA,LAMORT,NEQ,IMAT,
     &                MASSE,RIGID,AMORT,
     &                ZR(IDEPL0),ZR(IVITE0),ZR(IACCE0),
     &                NCHAR,NVECA,ZI(IAADVE),ZK24(IALIFO),
     &                MODELE,MATE,CARELE,
     &                CHARGE,INFOCH,FOMULT,NUMEDD,NUME)
             ENDIF
           ENDIF
         ENDIF
      ENDIF
      CALL JEDETC('V','&&',1)
      CALL JEDETC('V','.CODI',20)
      CALL JEDETC('V','.MATE_CODE',9)
      CALL JEDEMA()
      END
