      SUBROUTINE REGEEC ( NOMRES, RESGEN, NOMSST )
      IMPLICIT NONE
      CHARACTER*8         NOMRES, RESGEN, NOMSST
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/03/2011   AUTEUR CORUS M.CORUS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C  BUT : < RESTITUTION GENERALISEE ECLATEE >
C
C  RESTITUER EN BASE PHYSIQUE SUR UNE SOUS-STRUCTURE LES RESULTATS
C  ISSUS DE LA SOUS-STRUCTURATION GENERALE
C  LE CONCEPT RESULTAT EST UN RESULTAT COMPOSE "MODE_MECA"
C-----------------------------------------------------------------------
C
C NOMRES /I/ : NOM K8 DU CONCEPT MODE MECA RESULTAT
C RESGEN /I/ : NOM K8 DU MODE_GENE AMONT
C NOMSST /I/ : NOM K8 DE LA SOUS-STRUCTURE SUR LAQUELLE ON RESTITUE
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      INTEGER VALI(2)
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32 JEXNUM,JEXNOM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER      I, IAD, IBID, IEQ, IER, IORD, IRET, J, JBID, K,
     +             LDNEW, LLCHAB, LLCHOL, LLNUEQ, LLORS, LLPRS,
     +             NBBAS, NBDDG, NBMOD, NBSST, NEQ, NNO, NUMO, NUSST,
     +             NUTARS, IADPAR(6), LLREF1, LLREF2, LLREF3, LLREF4,
     +             ELIM,NEQET,NEQRED,LMAPRO,LSILIA,LSST,LMOET,I1,K1
      REAL*8       FREQ, GENEK, GENEM, OMEG2, RBID
      CHARACTER*1  K1BID
      CHARACTER*8  KBID, BASMOD, MAILLA, LINT, MODGEN, SOUTR
      CHARACTER*16 DEPL,NOMPAR(6)
      CHARACTER*19 RAID,NUMDDL,NUMGEN,CHAMNE
      CHARACTER*24 CREFE(2),CHAMOL,CHAMBA
      CHARACTER*24 VALK(2),SELIAI,SIZLIA,SST
      COMPLEX*16   CBID
C
C-----------------------------------------------------------------------
      DATA DEPL   /'DEPL            '/
      DATA SOUTR  /'&SOUSSTR'/
      DATA NOMPAR /'FREQ','RIGI_GENE','MASS_GENE','OMEGA2','NUME_MODE',
     &              'TYPE_MODE'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL TITRE
C
C --- RECUPERATION DU MODELE GENERALISE
C
      CALL JEVEUO ( RESGEN//'           .REFD','L',LLREF1)
      RAID = ZK24(LLREF1)
      CALL JELIBE ( RESGEN//'           .REFD')
C
      CALL JEVEUO ( RAID//'.REFA','L',LLREF2)
      NUMGEN(1:14)  = ZK24(LLREF2+1)
      NUMGEN(15:19) = '.NUME'
      CALL JELIBE ( RAID//'.REFA')
C
      CALL JEVEUO ( NUMGEN//'.REFN','L',LLREF3)
      MODGEN = ZK24(LLREF3)
      CALL JELIBE ( NUMGEN//'.REFN')
C
C --- RECUPERATION NUMERO DE SOUS-STRUCTURE
C     ET DU NOEUD TARDIF CORRESPONDANT
C
      CALL JENONU(JEXNOM(MODGEN//'      .MODG.SSNO',NOMSST),NUSST)
      IF(NUSST.EQ.0) THEN
        VALK (1) = MODGEN
        VALK (2) = NOMSST
        CALL U2MESG('F', 'ALGORITH14_25',2,VALK,0,0,0,0.D0)
      ENDIF
C
C
C-- ON TESTE SI ON A EU RECOURS A L'ELIMINATION
C
      SELIAI=NUMGEN(1:14)//'.ELIM.BASE'
      SIZLIA=NUMGEN(1:14)//'.ELIM.TAIL'
      SST=   NUMGEN(1:14)//'.ELIM.NOMS'

      CALL JEEXIN(SELIAI,ELIM)
      
      IF (ELIM .EQ. 0) THEN
            
        CALL JENONU(JEXNOM(NUMGEN//'.LILI',SOUTR),IBID)
        CALL JEVEUO(JEXNUM(NUMGEN//'.ORIG',IBID),'L',LLORS)
        CALL JENONU(JEXNOM(NUMGEN//'.LILI',SOUTR),IBID)
        CALL JELIRA(JEXNUM(NUMGEN//'.ORIG',IBID),'LONMAX',NBSST,KBID)
C
        NUTARS=0
        DO 10 I=1,NBSST
          IF(ZI(LLORS+I-1).EQ.NUSST) NUTARS=I
  10    CONTINUE
C
C
        CALL JENONU(JEXNOM(NUMGEN//'.LILI',SOUTR),IBID)
        CALL JEVEUO(JEXNUM(NUMGEN//'.PRNO',IBID),'L',LLPRS)
        NBDDG=ZI(LLPRS+(NUTARS-1)*2+1)
        IEQ=ZI(LLPRS+(NUTARS-1)*2)

      ELSE
      
        CALL JELIRA(MODGEN//'      .MODG.SSNO','NOMMAX',NBSST,K1BID)
        CALL JEVEUO(SST,'L',IBID)
        DO 12 I1=1,NBSST
          IF (NOMSST .EQ. ZK8(IBID+I1-1)) THEN
            NUSST=I1
          ENDIF
  12    CONTINUE      
        NEQET=0
        IEQ=0
        
        CALL JEVEUO(NUMGEN//'.NEQU','L',IBID)
        NEQRED=ZI(IBID)
        CALL JEVEUO(SELIAI,'L',LMAPRO)
        CALL JEVEUO(SIZLIA,'L',LSILIA)
        CALL JEVEUO(SST,'L',LSST)
        IBID=1
        DO 11 I=1,NBSST
          NEQET=NEQET+ZI(LSILIA+I-1)
  11    CONTINUE

        IEQ=0
        DO 41 I1=1,NUSST-1
            IEQ=IEQ+ZI(LSILIA+I1-1)
  41    CONTINUE
        CALL WKVECT('&&MODE_ETENDU_REST_ELIM','V V R',NEQET,LMOET)
           
      ENDIF
C
C --- RECUPERATION DE LA BASE MODALE
C
      CALL MGUTDM(MODGEN,NOMSST,IBID,'NOM_BASE_MODALE',IBID,BASMOD)
C
      CALL DISMOI('F','NB_MODES_TOT',BASMOD,'RESULTAT',
     &                      NBBAS,KBID,IER)
     
      IF (ELIM .EQ. 0) THEN
        IF(NBBAS.NE.NBDDG) THEN
          VALK (1) = BASMOD
          VALI (1) = NBBAS
          VALI (2) = NBDDG
          CALL U2MESG('F', 'ALGORITH14_26',1,VALK,2,VALI,0,0.D0)
        ENDIF
      ENDIF  
C
      CALL JEVEUO(BASMOD//'           .REFD','L',LLREF4)
      LINT=ZK24(LLREF4+4)
      CALL JELIBE(BASMOD//'           .REFD')
C
      CALL DISMOI('F','NOM_MAILLA',LINT,'INTERF_DYNA',IBID,
     &             MAILLA,IRET)
      CALL DISMOI('F','NOM_NUME_DDL',LINT,'INTERF_DYNA',IBID,
     &             NUMDDL,IRET)
      CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,
     &             KBID,IRET)
C
      CREFE(1)=MAILLA
      CREFE(2)=NUMDDL
C
C --- RECUPERATION NOMBRE DE MODES PROPRES CALCULES
C
      CALL RSORAC(RESGEN,'LONUTI',IBID,RBID,KBID,CBID,RBID,
     &            KBID,NBMOD,1,IBID)
C
C --- ON RESTITUE SUR TOUS LES MODES OU SUR QUELQUES MODES:
C
      CALL GETVIS ( ' ', 'NUME_ORDRE', 1,1,0, IBID, NNO )
      IF ( NNO .NE. 0 ) THEN
        NBMOD = -NNO
        CALL WKVECT ( '&&REGEEC.NUME', 'V V I', NBMOD, JBID )
        CALL GETVIS ( ' ', 'NUME_ORDRE', 1,1,NBMOD, ZI(JBID), NNO )
      ELSE
        CALL WKVECT ( '&&REGEEC.NUME', 'V V I', NBMOD, JBID )
        DO 2 I = 1 , NBMOD
           ZI(JBID+I-1) = I
 2      CONTINUE
      ENDIF
C
C --- ALLOCATION STRUCTURE DE DONNEES RESULTAT
C
      CALL RSCRSD('G',NOMRES,'MODE_MECA',NBMOD)
C
C --- RESTITUTION PROPREMENT DITE
C
      CALL JEVEUO(NUMGEN//'.NUEQ','L',LLNUEQ)
C
C --- BOUCLE SUR LES MODES A RESTITUER
      DO 20 I = 1 , NBMOD
        IORD = ZI(JBID+I-1)
C
C ----- REQUETTE NOM ET ADRESSE CHAMNO GENERALISE
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
C ----- REQUETTE NOM ET ADRESSE NOUVEAU CHAMNO
        CALL RSEXCH ( NOMRES, DEPL, I, CHAMNE, IER )
        CALL VTCREA ( CHAMNE, CREFE, 'G', 'R', NEQ )
        CALL JEVEUO ( CHAMNE//'.VALE', 'E', LDNEW )
C
        CALL RSADPA ( RESGEN, 'L', 5,NOMPAR, IORD,0, IADPAR,KBID)
        FREQ  = ZR(IADPAR(1))
        GENEK = ZR(IADPAR(2))
        GENEM = ZR(IADPAR(3))
        OMEG2 = ZR(IADPAR(4))
        NUMO  = ZI(IADPAR(5))
C
C ----- BOUCLE SUR LES MODES PROPRES DE LA BASE
        IF (ELIM .NE. 0) THEN
          IBID=NBBAS
        ELSE
          IBID=NBDDG
        ENDIF
        DO 30 J = 1,IBID        
          CALL DCAPNO ( BASMOD, DEPL, J, CHAMBA )
          CALL JEVEUO ( CHAMBA, 'L', LLCHAB )          
C
C ------- BOUCLE SUR LES EQUATIONS PHYSIQUES
          DO 40 K = 1,NEQ
              IF (ELIM .NE. 0) THEN
                IAD=LLCHOL+IEQ+J-1
              ELSE
                IAD=LLCHOL+ZI(LLNUEQ+IEQ+J-2)-1
              ENDIF
             ZR(LDNEW+K-1) = ZR(LDNEW+K-1) + ZR(LLCHAB+K-1)*ZR(IAD)
40        CONTINUE
          CALL JELIBE(CHAMBA)
30      CONTINUE
        CALL RSNOCH ( NOMRES, DEPL, I, ' ' )
        CALL RSADPA ( NOMRES, 'E', 6, NOMPAR, I, 0, IADPAR, KBID )
        ZR(IADPAR(1)) = FREQ
        ZR(IADPAR(2)) = GENEK
        ZR(IADPAR(3)) = GENEM
        ZR(IADPAR(4)) = OMEG2
        ZI(IADPAR(5)) = NUMO
        ZK16(IADPAR(6)) = 'MODE_DYN'
C
        CALL JELIBE(CHAMOL)
20    CONTINUE
C
      CALL JELIBE(NUMGEN//'.NUEQ')
      CALL JEDETR ( '&&REGEEC.NUME' )
C
 9999 CONTINUE
      CALL JEDEMA()
      END
