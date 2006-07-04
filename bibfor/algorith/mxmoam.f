      SUBROUTINE MXMOAM(MASGEN,BASMOD,LMODAL,LSSTRU,ACCGEM,ACCGEP,
     &                  VITGEM,VITGEP,DEPGEM,DEPGEP,RIGGEN,AMOGEN,
     &                  FONGEN,FORGEN,RESULT,INSTAM,NUMA)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER      NUMA
      CHARACTER*24 MASGEN,BASMOD,ACCGEM,ACCGEP,VITGEM,VITGEP
      CHARACTER*24 DEPGEM,DEPGEP,RIGGEN,AMOGEN,FONGEN,FORGEN
      CHARACTER*19 RESULT
      REAL*8       INSTAM
      LOGICAL      LMODAL,LSSTRU

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2006   AUTEUR ACBHHCD G.DEVESA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE BOYERE E.BOYERE
C ======================================================================
C     ------------------------------------------------------------------
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
      CHARACTER*32     JEXNOM, JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      COMPLEX*16   CBID
      REAL*8       PREC
      CHARACTER*6  PGC
      CHARACTER*8  K8B
      CHARACTER*8  MODMEC, MAGENE, AMGENE, RIGENE
      CHARACTER*14 NUMDDL
      CHARACTER*19 RESU, RESU1, RESU2, LISINS
      CHARACTER*24 DEEQ
      CHARACTER*24 KBID, MATRIC, NOMCHA
      CHARACTER*80 TITRE
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      LMODAL = .FALSE.
      LSSTRU = .FALSE.
      CALL GETFAC('PROJ_MODAL',NMODA)
      IF (NMODA.EQ.0) GOTO 9999
      LMODAL = .TRUE.
      CALL GETVID('PROJ_MODAL','MODE_MECA',1,1,1,MODMEC,NBMD)
      CALL GETVID('PROJ_MODAL','MASS_GENE',1,1,1,MAGENE,NBMG)
      IF (NBMG.NE.0) THEN
        LSSTRU = .TRUE.
        GOTO 9998
      ENDIF
      CALL JEVEUO(MODMEC//'           .REFD','L',IADRIF)
      MATRIC =  ZK24(IADRIF)(1:8)
      CALL DISMOI('F','NOM_NUME_DDL',MATRIC,'MATR_ASSE',IBI,NUMDDL,IRET)
      DEEQ = NUMDDL//'.NUME.DEEQ'
      CALL JEVEUO(DEEQ,'L',IDDEEQ)
      CALL DISMOI('F','NB_EQUA',MATRIC,'MATR_ASSE',NEQ,K8B,IRET)
C
      CALL JELIRA(MODMEC//'           .ORDR','LONMAX',NBMODE,KBID)
      CALL GETVIS('PROJ_MODAL','NB_MODE',1,1,1,NBMAX,NM)
      NBMODE = MIN(NBMODE,NBMAX) 
      CALL WKVECT(MASGEN,'V V R',NBMODE,JVALMO)
      CALL WKVECT(BASMOD,'V V R',NBMODE*NEQ,JBASMO)

C --- ALLOCATION VECTEUR DE TRAVAIL
C
      DO 10 I=1,NBMODE
        CALL RSADPA(MODMEC,'L',1,'MASS_GENE',I,0,LPAR,K8B)
        ZR(JVALMO+I-1) = ZR(LPAR)
        CALL RSEXCH(MODMEC,'DEPL',I,NOMCHA,IRET)
        CALL JEVEUO(NOMCHA(1:19)//'.VALE','L',JVAL)
C
C ----- CALCUL PRODUIT MATRICE DEFORMEE
C
        CALL DCOPY(NEQ,ZR(JVAL),1,ZR(JBASMO+(I-1)*NEQ),1)
C
C     --- MISE A ZERO DES DDL DE LAGRANGE
        CALL ZERLAG(ZR(JBASMO+(I-1)*NEQ),NEQ,ZI(IDDEEQ))
 10   CONTINUE
      GOTO 9999
C
 9998 CONTINUE
C
      CALL JEVEUO(MODMEC//'           .REFD','L',IADRIF)
      NUMDDL =  ZK24(IADRIF+3)(1:14)
      DEEQ = NUMDDL//'.NUME.DEEQ'
      CALL JEVEUO(DEEQ,'L',IDDEEQ)
      CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,K8B,IRET)
C
      CALL JELIRA(MODMEC//'           .ORDR','LONMAX',NBMODE,KBID)
      CALL GETVIS('PROJ_MODAL','NB_MODE',1,1,1,NBMAX,NM)
      NBMODE = MIN(NBMODE,NBMAX)
      CALL GETVID('PROJ_MODAL','RIGI_GENE',1,1,1,RIGENE,NBRG)
      CALL GETVID('PROJ_MODAL','AMOR_GENE',1,1,1,AMGENE,NBAG)
      CALL GETFAC('EXCIT_GENE',NFONC)
      CALL WKVECT(MASGEN,'V V R',NBMODE,JVALMO)
      CALL WKVECT(ACCGEM,'V V R',NBMODE,JACCGM)
      CALL WKVECT(ACCGEP,'V V R',NBMODE,JACCGP)
      CALL WKVECT(VITGEM,'V V R',NBMODE,JVITGM)
      CALL WKVECT(VITGEP,'V V R',NBMODE,JVITGP)
      CALL WKVECT(DEPGEM,'V V R',NBMODE,JDEPGM)
      CALL WKVECT(DEPGEP,'V V R',NBMODE,JDEPGP)
      CALL WKVECT(RIGGEN,'V V R',NBMODE*NBMODE,JRIGGE)
      CALL WKVECT(AMOGEN,'V V R',NBMODE*NBMODE,JAMOGE)      
      CALL WKVECT(BASMOD,'V V R',NBMODE*NEQ,JBASMO)
      IF (NFONC.NE.0) THEN
        CALL WKVECT(FONGEN,'V V K24',NFONC,JFONGE)
        CALL WKVECT('&&LIFOGE','V V K24',NFONC,JLIFGE)
        CALL WKVECT(FORGEN,'V V R',NFONC*NBMODE,JFORGE)
        DO 11 N=1,NFONC
          CALL GETVID('EXCIT_GENE','FONC_MULT',N,1,1,
     &                ZK24(JFONGE+N-1),NF)
          CALL GETVID('EXCIT_GENE','VECT_GENE',N,1,1,
     &                ZK24(JLIFGE+N-1),NF)
          CALL JEVEUO(ZK24(JLIFGE+N-1)(1:19)//'.VALE','L',JFGE)
          DO 12 I=1,NBMODE          
            ZR(JFORGE+(N-1)*NBMODE+I-1) = ZR(JFGE+I-1)
 12       CONTINUE
 11     CONTINUE
      ENDIF
      CALL GETVID('ARCHIVAGE','LIST_INST',1,1,1,LISINS,NL)
      IF (NL.EQ.0) CALL GETVID('INCREMENT','LIST_INST',1,1,1,LISINS,NL)
      CALL JEVEUO(LISINS//'.VALE','L',JINST0)
      CALL JEVEUO(LISINS//'.NBPA','L',JNBPA)
      NBINST = ZI(JNBPA)
      CALL JEEXIN(RESULT//'.DGEN',IRET)
C      WRITE(6,*) 'INSTAM ',INSTAM
      IF (IRET.EQ.0) THEN
        NUMA = 0
        CALL WKVECT(RESULT//'.DGEN','G V R',NBINST*NBMODE,JRESTD)
        CALL WKVECT(RESULT//'.VGEN','G V R',NBINST*NBMODE,JRESTV)
        CALL WKVECT(RESULT//'.AGEN','G V R',NBINST*NBMODE,JRESTA)
        CALL R8INIR(NBMODE,0.D0,ZR(JACCGM),1)
        CALL R8INIR(NBMODE,0.D0,ZR(JACCGP),1)
        CALL R8INIR(NBMODE,0.D0,ZR(JVITGM),1)
        CALL R8INIR(NBMODE,0.D0,ZR(JVITGP),1)
        CALL R8INIR(NBMODE,0.D0,ZR(JDEPGM),1)
        CALL R8INIR(NBMODE,0.D0,ZR(JDEPGP),1)        
      ELSE
        PREC = 1.D-6
        EPS0 = 1.D-12
        IF (ABS(INSTAM).GT.EPS0) THEN
          CALL RSORAC(RESULT,'INST',IBID,INSTAM,K8B,CBID,PREC,'RELATIF',
     &                NUMA,1,NBR)
        ELSE      
          CALL RSORAC(RESULT,'INST',IBID,INSTAM,K8B,CBID,EPS0,'ABSOLU',
     &                NUMA,1,NBR)
        ENDIF
        CALL JUVECA(RESULT//'.DGEN',NBINST*NBMODE)
        CALL JUVECA(RESULT//'.VGEN',NBINST*NBMODE)
        CALL JUVECA(RESULT//'.AGEN',NBINST*NBMODE)
        CALL JEVEUO(RESULT//'.DGEN','L',JRESTD)
        CALL JEVEUO(RESULT//'.VGEN','L',JRESTV)
        CALL JEVEUO(RESULT//'.AGEN','L',JRESTA)
        CALL DCOPY(NBMODE,ZR(JRESTD+(NUMA-1)*NBMODE),1,ZR(JDEPGM),1)
        CALL DCOPY(NBMODE,ZR(JRESTD+(NUMA-1)*NBMODE),1,ZR(JDEPGP),1)
        CALL DCOPY(NBMODE,ZR(JRESTV+(NUMA-1)*NBMODE),1,ZR(JVITGM),1)
        CALL DCOPY(NBMODE,ZR(JRESTV+(NUMA-1)*NBMODE),1,ZR(JVITGP),1)
        CALL DCOPY(NBMODE,ZR(JRESTA+(NUMA-1)*NBMODE),1,ZR(JACCGM),1)
        CALL DCOPY(NBMODE,ZR(JRESTA+(NUMA-1)*NBMODE),1,ZR(JACCGP),1)
      ENDIF
C      WRITE(6,*) 'NUMA NBINST ',NUMA,NBINST

C --- ALLOCATION VECTEUR DE TRAVAIL
C
      RESU = MAGENE
      CALL JEVEUO(JEXNUM(RESU//'.VALM',1),'L',LDBLO)
      DO 20 I=1,NBMODE
        ZR(JVALMO+I-1) = ZR(LDBLO+I-1)
        CALL RSEXCH(MODMEC,'DEPL',I,NOMCHA,IRET)
        CALL JEVEUO(NOMCHA(1:19)//'.VALE','L',JVAL)
C
C ----- CALCUL PRODUIT MATRICE DEFORMEE
C
        CALL DCOPY(NEQ,ZR(JVAL),1,ZR(JBASMO+(I-1)*NEQ),1)
C
C     --- MISE A ZERO DES DDL DE LAGRANGE
        CALL ZERLAG(ZR(JBASMO+(I-1)*NEQ),NEQ,ZI(IDDEEQ))
 20   CONTINUE
C
C
C --- RECUPERATION DE LA STRUCTURE DE LA MATR_ASSE_GENE
C
      RESU1 = RIGENE
      CALL JEVEUO(JEXNUM(RESU1//'.VALM',1),'L',LDBLO1)
      IF (NBAG.NE.0) THEN
        RESU2 = AMGENE
        CALL JEVEUO(JEXNUM(RESU2//'.VALM',1),'L',LDBLO2)
      ELSE
        CALL R8INIR(NBMODE*NBMODE,0.D0,ZR(JAMOGE),1)
      ENDIF
C
C        BOUCLE SUR LES COLONNES DE LA MATRICE ASSEMBLEE
C
      DO 30 I = 1 , NBMODE
C
C --------- BOUCLE SUR LES INDICES VALIDES DE LA COLONNE I
C
        DO 40 J = 1 , I 
          ZR(JRIGGE+(I-1)*NBMODE+J-1)=ZR(LDBLO1+I*(I-1)/2+J-1)
          ZR(JRIGGE+(J-1)*NBMODE+I-1)=ZR(LDBLO1+I*(I-1)/2+J-1)
          IF (NBAG.NE.0) THEN          
            ZR(JAMOGE+(I-1)*NBMODE+J-1)=ZR(LDBLO2+I*(I-1)/2+J-1)
            ZR(JAMOGE+(J-1)*NBMODE+I-1)=ZR(LDBLO2+I*(I-1)/2+J-1)
          ENDIF
 40     CONTINUE
 30   CONTINUE
C
C      CALL JEDETC('V','&&MXMOAM',1)
C
 9999 CONTINUE
      CALL JEDEMA()
      END
