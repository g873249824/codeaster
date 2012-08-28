      SUBROUTINE RFHGE2 ( HARMGE )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*)       HARMGE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 27/08/2012   AUTEUR ALARCON A.ALARCON 
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
C     OPERATEUR "RECU_FONCTION"  MOT CLE "HARM_GENE"
C     ------------------------------------------------------------------
      INTEGER      LXLGUT
      CHARACTER*1  TYPE
      CHARACTER*4  INTERP(2)
      CHARACTER*8  K8B, CRIT, NOEUD, CMP, NOMA, BASEMO
      CHARACTER*8   NOGNO, MATPRO, INTRES
      CHARACTER*14 NUME
      CHARACTER*16 NOMCMD, TYPCON, NOMCHA, NOMSY
      CHARACTER*19 NOMFON, KNUME, KINST, RESU, MATRAS
      CHARACTER*24 VALK(2)
      COMPLEX*16   CREP
      INTEGER      IARG
C     ------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER IAGNO ,IAREF2 ,IBID ,IDBASE ,IDDL ,IDINSG ,IDVECG
      INTEGER IE ,IERD ,IGN2 ,II ,INO ,INOEUD ,IORDR, LDESC
      INTEGER IRET ,ITRESU ,JINST ,JJ ,LFON ,LG1 ,LG2
      INTEGER LORDR ,LPRO ,LREFE ,LVAR ,MXMODE ,N1 ,N2
      INTEGER N3 ,NBINSG ,NBMODE ,NBORDR ,NBPARI ,NBPARK ,NBPARR
      INTEGER NEQ ,NGN, NUMCMP
      REAL*8 EPSI
C-----------------------------------------------------------------------
      CALL JEMARQ()
C
      CALL GETRES ( NOMFON , TYPCON , NOMCMD )
C
      RESU = HARMGE
      INTERP(1) = 'NON '
      INTERP(2) = 'NON '
      INTRES    = 'NON '
C
      CALL GETVTX ( ' ', 'CRITERE'     ,1,IARG,1, CRIT  , N1 )
      CALL GETVR8 ( ' ', 'PRECISION'   ,1,IARG,1, EPSI  , N1 )
      CALL GETVTX ( ' ', 'INTERP_NUME' ,1,IARG,1, INTRES, N1 )
      CALL GETVTX ( ' ', 'INTERPOL'    ,1,IARG,2, INTERP, N1 )
      IF ( N1 .EQ. 1 ) INTERP(2) = INTERP(1)
C
      NOEUD = ' '
      CMP   = ' '
      CALL GETVTX ( ' ', 'NOM_CMP',  1,IARG,1, CMP,    N1  )
      CALL GETVTX ( ' ', 'NOM_CHAM', 1,IARG,1, NOMCHA, N2  )
      CALL GETVTX ( ' ', 'NOEUD',    1,IARG,1, NOEUD,  N3  )
      CALL GETVTX ( ' ', 'GROUP_NO', 1,IARG,1, NOGNO,  NGN )
C
      CALL JEEXIN(RESU//'.'//NOMCHA(1:4),IRET)
      IF (IRET.EQ.0)  THEN
         CALL U2MESK('F','UTILITAI4_23',1,NOMCHA)
      ENDIF
      CALL JEVEUO(RESU//'.'//NOMCHA(1:4),'L',ITRESU)
C
      KNUME = '&&RFHGE2.NUME_ORDR'
      KINST = '&&RFHGE2.FREQUENCE'
      CALL RSTRAN ( INTRES, RESU, ' ', 1, KINST, KNUME, NBORDR, IE )
      IF (IE.NE.0) THEN
         CALL U2MESS('F','UTILITAI4_15')
      ENDIF
      CALL JEEXIN(KINST,IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(KINST,'L',JINST)
        CALL JEVEUO(KNUME,'L',LORDR)
      END IF
C
C     --- CREATION DE LA FONCTION ---
C
      CALL ASSERT(LXLGUT(NOMFON).LE.24)
      CALL WKVECT ( NOMFON//'.PROL', 'G V K24', 6, LPRO )
      ZK24(LPRO)   = 'FONCT_C         '
      ZK24(LPRO+1) = INTERP(1)//INTERP(2)
      ZK24(LPRO+2) = 'FREQ            '
      ZK24(LPRO+3) = NOMCHA
      ZK24(LPRO+4) = 'EE              '
      ZK24(LPRO+5) = NOMFON(1:19)
C
C --- LA FONCTION EST LA CONCATENATION DE DEUX VECTEURS:
C --- ABSCISSES +  ( PARTIE REELLE | PARTIE IMAGINAIRE )
      CALL WKVECT ( NOMFON//'.VALE', 'G V R', 3*NBORDR, LVAR )

C
      CALL JEVEUO(RESU//'.DESC','L',LDESC)
      NBMODE = ZI(LDESC+1)
      CALL GETVIS ( ' ', 'NUME_CMP_GENE', 1,IARG,1, NUMCMP, N1 )
      LFON = LVAR + NBORDR
C
C --- CAS OU D'UNE VARIABLE GENERALISEE
C
      IF (N1.NE.0) THEN
        IF (NUMCMP.GT.NBMODE) CALL U2MESS('F','UTILITAI4_14')
C
        JJ = 0
        IF ( INTRES(1:3) .NE. 'NON' ) THEN
C ---   CAS OU ON INTERPOLE      
           CALL JEVEUO(RESU//'.DISC','L',IDINSG)
           CALL JELIRA(RESU//'.DISC','LONMAX',NBINSG,K8B)
           CALL WKVECT('&&RFHGE2.VECTGENE','V V C',NBMODE,IDVECG)
           DO 40 IORDR = 0, NBORDR-1
C             INTERPOLATION         
              CALL ZXTRAC(INTRES,EPSI,CRIT,NBINSG,ZR(IDINSG),
     &                    ZR(JINST+IORDR),ZC(ITRESU),NBMODE,
     &                    CREP,IERD)
C             REMPLISSAGE DES TROIS VECTEURS DE LA FONCTION           
              ZR(LVAR+IORDR) = ZR(JINST+IORDR)
              ZR(LFON+JJ) = DBLE(CREP)
              JJ = JJ +1
              ZR(LFON+JJ) = DIMAG(CREP)
              JJ = JJ +1
 40        CONTINUE
           CALL JEDETR('&&RFHGE2.VECTGENE')
C  
        ELSE
C ---   CAS OU ON N'INTERPOLE PAS         
           DO 41 IORDR = 0, NBORDR-1
              II = ZI(LORDR+IORDR)
              ZR(LVAR+IORDR) = ZR(JINST+IORDR)
              CREP = ZC(ITRESU+NBMODE*(II-1)+NUMCMP-1)
              ZR(LFON+JJ) = DBLE(CREP)
              JJ = JJ +1
              ZR(LFON+JJ) = DIMAG(CREP)
              JJ = JJ +1
 41        CONTINUE
        ENDIF
      ELSE      
C
C --- CAS D'UNE VARIABLE PHYSIQUE
C
        CALL JEVEUO(RESU//'.REFD','L',LREFE)
        MATPRO = ZK24(LREFE)(1:8)
        CALL JEVEUO(MATPRO//'           .REFA','L',IAREF2)
        BASEMO = ZK24(IAREF2)(1:8)
        CALL JEVEUO(BASEMO//'           .REFD','L',LREFE)
        MATRAS = ZK24(LREFE)(1:19)
      
        NOMSY = 'DEPL'
C ---   RECUPERATION DE LA BASE MODALE DANS UN VECTEUR DE TRAVAIL
        IF (MATRAS.NE.' ') THEN
          CALL VPRECU ( BASEMO, NOMSY,-1,IBID, '&&RFHGE2.VECT.PROPRE',
     &                  0, K8B, K8B,  K8B, K8B,
     &                  NEQ, MXMODE, TYPE, NBPARI, NBPARR, NBPARK )
          CALL JEVEUO('&&RFHGE2.VECT.PROPRE','L',IDBASE)
          IF ( TYPE .NE. 'R' ) THEN
             CALL U2MESK('F','UTILITAI4_16',1,TYPE)
          ENDIF
          CALL DISMOI('F','NOM_NUME_DDL',MATRAS,'MATR_ASSE',IBID,NUME,
     &                IE)
          CALL DISMOI('F','NOM_MAILLA'  ,MATRAS,'MATR_ASSE',IBID,NOMA,
     &                IE)
        ELSE
          NUME = ZK24(LREFE+3)(1:14)
          CALL DISMOI('F','NOM_MAILLA',NUME,'NUME_DDL',IBID,NOMA,IE)
          CALL DISMOI('F','NB_EQUA'   ,NUME,'NUME_DDL',NEQ ,K8B ,IE)
          CALL WKVECT('&&RFHGE2.VECT.PROPRE','V V R',NEQ*NBMODE,IDBASE)
          CALL COPMO2(BASEMO,NEQ,NUME,NBMODE,ZR(IDBASE))
        ENDIF
C --- TRAITEMENT D'UN GROUP DE NOEUDS SEUELEMENT  
        IF (NGN.NE.0) THEN
          CALL JENONU(JEXNOM(NOMA//'.GROUPENO',NOGNO),IGN2)
          IF (IGN2.LE.0)  CALL U2MESK('F','ELEMENTS_67',1,NOGNO)
          CALL JEVEUO(JEXNUM(NOMA//'.GROUPENO',IGN2),'L',IAGNO)
          INO = ZI(IAGNO)
          CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',INO),NOEUD)
        ENDIF
        CALL POSDDL('NUME_DDL',NUME,NOEUD,CMP,INOEUD,IDDL)
        IF ( INOEUD .EQ. 0 ) THEN
           LG1 = LXLGUT(NOEUD)
           CALL U2MESK('F','UTILITAI_92',1,NOEUD(1:LG1))
        ELSEIF ( IDDL .EQ. 0 ) THEN
           LG1 = LXLGUT(NOEUD)
           LG2 = LXLGUT(CMP)
            VALK(1) = CMP(1:LG2)
            VALK(2) = NOEUD(1:LG1)
            CALL U2MESK('F','UTILITAI_93', 2 ,VALK)
        ENDIF
C --- INTERPOLATION PROPREMENT DITE (ESPACE PHYSIQUE)
        JJ = 0
        IF ( INTRES(1:3) .NE. 'NON' ) THEN
C ---   CAS OU ON INTERPOLE     
           CALL JEVEUO(RESU//'.DISC','L',IDINSG)
           CALL JELIRA(RESU//'.DISC','LONMAX',NBINSG,K8B)
           CALL WKVECT('&&RFHGE2.VECTGENE','V V C',NBMODE,IDVECG)
           DO 50 IORDR = 0, NBORDR-1
C             EXTRACTION ET INTERPOLATION         
              CALL ZXTRAC(INTRES,EPSI,CRIT,NBINSG,ZR(IDINSG),
     &                    ZR(JINST+IORDR),ZC(ITRESU),NBMODE,
     &                    ZC(IDVECG),IERD)
C             PASSAGE EN BASE PHYSIQUE            
              CALL MDGEP5(NEQ,NBMODE,ZR(IDBASE),ZC(IDVECG),IDDL,CREP)
C             REMPLISSAGE DES TROIS VECTEURS DE LA FONCTION           
              ZR(LVAR+IORDR) = ZR(JINST+IORDR)
              ZR(LFON+JJ) = DBLE(CREP)
              JJ = JJ +1
              ZR(LFON+JJ) = DIMAG(CREP)
              JJ = JJ +1
 50        CONTINUE
           CALL JEDETR('&&RFHGE2.VECTGENE')
C  
        ELSE
C ---   CAS OU ON N'INTERPOLE PAS         
           DO 51 IORDR = 0, NBORDR-1
              II = ZI(LORDR+IORDR)
C             PASSAGE EN BASE PHYSIQUE               
              CALL MDGEP5(NEQ,NBMODE,ZR(IDBASE),ZC(ITRESU+NBMODE*(II-1))
     &                    ,IDDL,CREP)
              ZR(LVAR+IORDR) = ZR(JINST+IORDR)
              ZR(LFON+JJ) = DBLE(CREP)
              JJ = JJ +1
              ZR(LFON+JJ) = DIMAG(CREP)
              JJ = JJ +1
 51        CONTINUE
        
        ENDIF
      ENDIF

      CALL JEDETR( '&&RFHGE2.VECT.PROPRE' )
C
C     ---------------------------------------------------------------
      CALL JEDETR( KNUME )
      CALL JEDETR( KINST )
C
      CALL JEDEMA()
      END
