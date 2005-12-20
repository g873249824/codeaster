      SUBROUTINE OP0174 ( IER )
      IMPLICIT   NONE
      INTEGER             IER
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 11/03/2003   AUTEUR DURAND C.DURAND 
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
C
C     COMMANDE:  RECU_TABLE
C
C ----------------------------------------------------------------------
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
      INTEGER       IRET, LONORD, IORD, IPARA, I, N, NUMORD, IBID
      INTEGER       NBPARA, INOM, ITYP, ILONG, ITABI, ITABR, ITABC
      INTEGER       PI, PC, PR
      REAL*8        RBID
      COMPLEX*16    CBID
      CHARACTER*8   TABLE, CONCPT, TYP
      CHARACTER*16  NOMCMD, TYPCON, NOMSYM, K16B, NOM
      CHARACTER*24  NOMTAB, KBID

C     ------------------------------------------------------------------


      CALL JEMARQ()
      CALL INFMAJ()

      CALL GETRES ( TABLE, TYPCON, NOMCMD )
      CALL GETVID ( ' ', 'CO'      , 1,1,1, CONCPT, IRET )


C --------------------------
C   EXTRACTION D'UNE TABLE
C --------------------------

      CALL GETVTX ( ' ', 'NOM_TABLE', 0,1,1, NOMSYM, IRET )
      IF (IRET.NE.0) THEN
        CALL LTNOTB ( CONCPT , NOMSYM , NOMTAB )
        CALL COPISD ( 'TABLE', 'G', NOMTAB, TABLE )
        CALL TITRE
        GOTO 9999
      END IF
      
      
      
C ----------------------------
C   EXTRACTION DE PARAMETRES
C ----------------------------

C    NOMBRE DE PARAMETRES
      CALL GETVTX ( ' ', 'NOM_PARA', 0,1,0, K16B, NBPARA )
      IF (NBPARA.EQ.0) CALL UTMESS('F','OP0174','ERREUR DVP_1')
      NBPARA = -NBPARA
    
      
C -- LECTURE DES NUMEROS D'ORDRE

      CALL RSORAC(CONCPT, 'LONUTI', IBID, RBID, KBID, CBID, RBID,
     &            KBID, LONORD, 1, IBID)
      CALL WKVECT('&&OP0174.NUME_ORDRE','V V I',LONORD, IORD)
      CALL RSORAC(CONCPT, 'TOUT_ORDRE', IBID, RBID, KBID, CBID, RBID,
     &            KBID, ZI(IORD), LONORD, IBID)


C -- NOMS DES PARAMETRES A EXTRAIRE      

      CALL WKVECT('&&OP0174.NOM_PARA'     ,'V V K16',NBPARA+1,INOM)
      CALL WKVECT('&&OP0174.LONG_NOM_PARA','V V I'  ,NBPARA  ,ILONG)

      CALL GETLTX (' ', 'NOM_PARA', 0,1,NBPARA, ZI(ILONG), IBID)
      DO 10 I = 1, NBPARA
      IF (ZI(ILONG-1+I) .GT. 16) CALL UTMESS('F','OP0174',
     &   'LE NOM D''UN PARAMETRE NE PEUT PAS DEPASSER 16 CARACTERES')
 10   CONTINUE

      ZK16(INOM) = 'NUME_ORDRE'
      CALL GETVTX (' ', 'NOM_PARA', 0,1,NBPARA, ZK16(INOM+1), IBID)

      DO 20 I = 1, NBPARA 
      NOM = ZK16(INOM + I)
        CALL RSEXPA (CONCPT, 2, NOM, IRET)
        IF (IRET.EQ.0) CALL UTMESS('F','OP0174','LE PARAMETRE ' 
     &    // NOM // ' N ''EXISTE PAS')
 20    CONTINUE


C -- TYPES DES PARAMETRES A EXTRAIRE

      CALL WKVECT('&&OP0174.TYPE_PARA','V V K8 ',NBPARA+1,ITYP)
      ZK8(ITYP) = 'I'
      NUMORD = ZI(IORD)
      DO 30 I = 1, NBPARA
        NOM = ZK16(INOM + I)
        CALL RSADPA(CONCPT,'L',1,NOM,NUMORD,1,IPARA,TYP)
      IF (TYP(1:1).NE.'R' .AND. TYP(1:1).NE.'I' .AND. TYP(1:1).NE.'C') 
     &  CALL UTMESS('F','OP0174','SEULS LES PARAMETRES DE TYPES ' //
     &    'REEL, ENTIER OU COMPLEXE SONT TRAITES')
        ZK8(ITYP+I) = TYP(1:1)
 30   CONTINUE


C -- INITIALISATION DE LA TABLE

        CALL TBCRSD (TABLE, 'G' )
        CALL TITRE
        CALL TBAJPA (TABLE, 1+NBPARA, ZK16(INOM), ZK8(ITYP) )


C -- EXTRACTION DES PARAMETRES

      CALL WKVECT('&&OP0174.PARA_R','V V R',NBPARA+1,ITABR)
      CALL WKVECT('&&OP0174.PARA_I','V V I',NBPARA+1,ITABI)
      CALL WKVECT('&&OP0174.PARA_C','V V C',NBPARA+1,ITABC)

      DO 40 N = 1 , LONORD
        NUMORD = ZI(IORD-1+N)

        PI = 0
        PR = 0
        PC = 0

        ZI(ITABI+PI) = NUMORD
        PI = PI+1

        DO 50 I = 1,NBPARA
          NOM = ZK16(INOM + I)
          CALL RSADPA(CONCPT,'L',1,NOM,NUMORD,1,IPARA,TYP)
          IF (TYP(1:1).EQ.'R') THEN
            ZR(ITABR+PR) = ZR(IPARA)
            PR = PR+1
          ELSE IF (TYP(1:1).EQ.'I') THEN
            ZI(ITABI+PI) = ZI(IPARA)
            PI = PI+1
          ELSE IF (TYP(1:1).EQ.'C') THEN
            ZC(ITABC+PC) = ZC(IPARA)
            PC = PC+1
          ELSE
            CALL UTMESS('F','OP0174','ERREUR DVP_2')
          END IF
 50     CONTINUE    

        CALL TBAJLI (TABLE, 1+NBPARA, ZK16(INOM), 
     &    ZI(ITABI), ZR(ITABR), ZC(ITABC), KBID, 0 )
 40   CONTINUE



 9999 CONTINUE
      CALL JEDEMA ( )
      END
