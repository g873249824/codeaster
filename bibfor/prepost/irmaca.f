      SUBROUTINE IRMACA(IFC,NDIM,NNO,COORDO,NBMA,CONNEX,POINT,NOMA,
     +                  TYPMA,TYPEL,LMOD,TITRE,NBTITR,NBGRN,NOGN,NBGRM,
     +                  NOGM,NOMAI,NONOE,NIVE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*80 TITRE(*)
      CHARACTER*8  NOGN(*),NOGM(*),NOMAI(*),NONOE(*),NOMA
      REAL*8       COORDO(*)
      INTEGER      CONNEX(*),TYPMA(*),POINT(*),TYPEL(*),IFC,NIVE,NBTITR
      LOGICAL      LMOD
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 11/03/2003   AUTEUR DURAND C.DURAND 
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
C TOLE CRP_20
C
C     BUT :   ECRITURE DU MAILLAGE AU FORMAT CASTEM2000
C     ENTREE:
C       IFC    : NUMERO D'UNITE LOGIQUE DU FICHIER CASTEM2000
C       NDIM   : DIMENSION DU PROBLEME (2  OU 3)
C       NNO    : NOMBRE DE NOEUDS DU MAILLAGE
C       COORDO : VECTEUR DES COORDONNEES DES NOEUDS
C       NBMA   : NOMBRE DE MAILLES DU MAILLAGE
C       CONNEX : CONNECTIVITES
C       POINT  : POINTEUR DANS LES CONNECTIVITES
C       NOMA   : NOM DU MAILLAGE
C       TYPMA  : TYPES DES MAILLES
C       TYPEL  : TYPES DES ELEMENTS
C       LMOD   : LOGIQUE INDIQUANT SI IMPRESSION MODELE OU MAILLAGE
C                 .TRUE. MODELE
C       TITRE  : TITRE ASSOCIE AU MAILLAGE
C       TOUT CE QUI SUIT CONCERNE LES GROUPES:
C          NBGRN: NOMBRE DE GROUPES DE NOEUDS
C          NOGN : NOM DES GROUPES DE NOEUDS
C          NBGRM: NOMBRE DE GROUPES DE MAILLES
C          NOGM : NOM DES GROUPES DE MAILLES
C          NOMAI: NOMS DES MAILLES
C          NONOE: NOMS DES NOEUDS
C       NIVE    : NIVEAU IMPRESSION CASTEM 3 OU 10
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
      CHARACTER*32      JEXNUM, JEXNOM, JEXATR
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      INTEGER       IBID,IERR,NBTYMA
      REAL*8        RBID
      CHARACTER*8   KTYPE,KBID,NOMOB,GTYPE
      CHARACTER*9   TOTO
      CHARACTER*24  NOLILI, NOMJV
C     ------------------------------------------------------------------
C
      NOMJV = '&&OP0039.NOM_MODELE'
      CALL JEEXIN ( NOMJV , IRET )
      IF ( IRET .EQ. 0 ) THEN
         NBMODL = 0
      ELSE
         CALL JEVEUO ( NOMJV, 'L', JMODL )
         CALL JELIRA ( NOMJV, 'LONUTI', NBMODL, KBID )
      ENDIF
C
C     ECRITURE DES INFORMATIONS GENERALES DU MAILLAGE
      CALL JEMARQ()
      IBID = 4
      IERR = 0
      RBID = 0.D0
      WRITE (IFC,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IBID
      IF (NIVE.EQ.3) THEN
        IBID =  3
      ELSE IF (NIVE.EQ.10) THEN
        IBID = 10
      ENDIF
      WRITE (IFC,'(3(A,I4))')  ' NIVEAU',IBID,' NIVEAU ERREUR',IERR,
     +                    ' DIMENSION',NDIM
      WRITE (IFC,'(A,E12.5)')   ' DENSITE',RBID
C
      CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NBTYMA,KBID)
      CALL WKVECT('&&IRMACA.JM','V V I',NBTYMA,JJM)
      CALL WKVECT('&&IRMACA.LOGIQ','V V L',NBTYMA,JJL)
C
C     ECRITURE DES INFORMATIONS GENERALES CASTEM 2000
      IBID = 7
      IZERO = 0
      IMOIN = -1
      IPLU = 1
      IDEU = 2
      WRITE (IFC,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IBID
      IF (NIVE.EQ.10) IBID = 8
      WRITE (IFC,'(A,I4)')  ' NOMBRE INFO CASTEM2000',IBID
      IF (NDIM.EQ.2) THEN
        WRITE (IFC,'(7(A,I4))')   ' IFOUR',IMOIN,' NIFOUR',IZERO,
     +  ' IFOMOD',IMOIN,' IECHO',IPLU,' IIMPI',IZERO,' IOSPI',IZERO,
     +   ' ISOTYP',IPLU
        IF(NIVE.EQ.10) WRITE (IFC,'(A,I6)') ' NSDPGE',IZERO
      ELSEIF (NDIM.EQ.3) THEN
        WRITE (IFC,'(7(A,I4))')   ' IFOUR',IDEU,' NIFOUR',IZERO,
     +  ' IFOMOD',IDEU,' IECHO',IPLU,' IIMPI',IZERO,' IOSPI',IZERO,
     +   ' ISOTYP',IPLU
        IF(NIVE.EQ.10) WRITE (IFC,'(A,I6)') ' NSDPGE',IZERO
      ENDIF
C
C     LECTURE DES NOEUDS
      NBOBJN = 0
      IF (NBGRN.NE.0) THEN
        CALL WKVECT('&&IRMACA.NOEUD','V V I',NBGRN,JGN)
        CALL WKVECT('&&IRMACA.NNOEU','V V K8',NBGRN,JNN)
        DO 50 IGN=1,NBGRN
          CALL JEVEUO(JEXNUM(NOMA//'.GROUPENO',IGN),'L',IAGRNO)
          CALL JELIRA(JEXNUM(NOMA//'.GROUPENO',IGN),'LONMAX',NBN,KBID)
          IF(NBN.EQ.1) THEN
            NBOBJN = NBOBJN + 1
            ZI(JGN-1+NBOBJN) = ZI(IAGRNO-1+1)
            ZK8(JNN-1+NBOBJN) = NOGN(IGN)
          ENDIF
 50     CONTINUE
      ENDIF
C
C ECRITURE DES NOEUDS
C
      IF (NIVE.EQ.3) THEN
        IBID = 2
        WRITE (IFC,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IBID
        WRITE (IFC,'(A,I4,A,I5,A,I5)')  ' PILE NUMERO',IZERO,
     +     'NBRE OBJETS NOMMES',NBOBJN,'NBRE OBJETS',NNO
        IF (NBOBJN.NE.0)  THEN
          WRITE(IFC,1002) (ZK8(JNN-1+I),I=1,NBOBJN)
          WRITE(IFC,1003) (ZI(JGN-1+I),I=1,NBOBJN)
        ENDIF
        CALL WKVECT ('&&IRMACA.COOR','V V R',(NDIM+1)*NNO,JCOO)
        DO 1 INO = 1,NNO
         DO 2 IDI =1,NDIM
          ZR(JCOO-1+(INO-1)*(NDIM+1)+IDI) = COORDO(3*(INO-1)+IDI)
  2      CONTINUE
          ZR(JCOO-1+(INO-1)*(NDIM+1)+4) = RBID
  1     CONTINUE
        WRITE(IFC,1001) (ZR(JCOO-1+I),I=1,(NDIM+1)*NNO)
      ENDIF
C
C ECRITURE DES MAILLES
C
      NBGNO = NBGRN-NBOBJN
      NBTOT = NBGNO
      IPOG = 1
      CALL WKVECT('&&IRMACA.NBSOB','V V I' ,NBGRM+1+NBMODL  ,JNUM)
      CALL WKVECT('&&IRMACA.NBMAI','V V I' ,(NBGRM+1)*NBTYMA,JTY )
      CALL WKVECT('&&IRMACA.IPOSI','V V I' ,NBGRM+NBGNO+2   ,JPOS)
      CALL WKVECT('&&IRMACA.NOMOB','V V K8',NBGRM+NBGNO+2   ,JNOM)
      CALL WKVECT('&&IRMACA.NOMO2','V V K8',NBGRM+NBGNO+2   ,JNO2)
      CALL WKVECT('&&IRMACA.NBTO' ,'V V I ',NBGRM+1         ,JMT )
C
      IF (NBGRN.NE.0) THEN
        IJP = 0
        DO 51 IGN=1,NBGRN
          CALL JELIRA(JEXNUM(NOMA//'.GROUPENO',IGN),'LONMAX',NBN,KBID)
          IF (NBN.NE.1) THEN
            IJP =IJP+1
            ZI(JPOS-1+IJP) = IJP + 1
            IPOG = IJP+1
            ZK8(JNOM-1+IJP) = NOGN(IGN)
            ZK8(JNO2-1+IJP) = NOGN(IGN)
            CALL LXCAPS(ZK8(JNO2-1+IJP))
          ENDIF
 51     CONTINUE
      ENDIF
C
      NBGMA = 0
      NMAMAX = NBMA
      IF (NBGRM.NE.0) THEN
        DO 21 IGM = 1,NBGRM
          DO 15 I=1,NBTYMA
            ZL(JJL-1+I)= .FALSE.
 15       CONTINUE
          CALL JEVEUO(JEXNUM(NOMA//'.GROUPEMA',IGM),'L',IAGRMA)
          CALL JELIRA(JEXNUM(NOMA//'.GROUPEMA',IGM),'LONMAX',NBM,KBID)
          IF (NBM.EQ.0) GO TO 21
          NMAMAX = MAX(NMAMAX,NBM)
          NBGMA = NBGMA + 1
          ZI(JMT-1+IGM) = NBM
          ZK8(JNOM-1+NBGNO+NBGMA) = NOGM(IGM)
          ZK8(JNO2-1+NBGNO+NBGMA) = NOGM(IGM)
          CALL LXCAPS(ZK8(JNO2-1+NBGNO+NBGMA))
          NOMBRE = 0
          DO 22 JMAI =1,NBM
           IMA = ZI(IAGRMA-1+JMAI)
           ITYPE = TYPMA(IMA)
           IF(.NOT.ZL(JJL-1+ITYPE)) THEN
             CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPE),KBID)
             CALL WKVECT('&&IRMA.G.'//NOGM(IGM)//KBID(1:7),'V V I',
     +                    NBM,ZI(JJM-1+ITYPE))
             ZL(JJL-1+ITYPE) = .TRUE.
           ENDIF
           IBID = ZI(JTY-1+(NBGMA-1)*NBTYMA+ITYPE) + 1
           ZI(JTY-1+(NBGMA-1)*NBTYMA+ITYPE) = IBID
           ZI(ZI(JJM-1+ITYPE)-1+IBID) = IMA
 22       CONTINUE
          DO 23 ITY=1,NBTYMA
           IF(ZI(JTY-1+(NBGMA-1)*NBTYMA+ITY).NE.0) NOMBRE = NOMBRE+1
 23       CONTINUE
          ZI(JNUM-1+IGM) = NOMBRE
          IF ( NOMBRE.EQ.1) THEN
            IPOG = IPOG + 1
            ZI (JPOS-1+NBGNO+NBGMA) = IPOG
            NBTOT = NBTOT + NOMBRE
          ELSE
            IPOG = IPOG + NOMBRE + 1
            ZI (JPOS-1+NBGNO+IGM) = IPOG
            NBTOT = NBTOT + NOMBRE + 1
          ENDIF
  21     CONTINUE
       ENDIF
C
C TOUT LE MAILLAGE
C
      DO 16 I=1,NBTYMA
        ZL(JJL-1+I) = .FALSE.
 16   CONTINUE
      NOMBRE= 0
      DO 33 IMA=1,NBMA
        ITYPE = TYPMA(IMA)
         IF(.NOT.ZL(JJL-1+ITYPE)) THEN
           CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPE),KBID)
           CALL WKVECT('&&IRMA.M.'//NOMA//KBID(1:7),'V V I',
     +           NBMA,ZI(JJM-1+ITYPE))
           ZL(JJL-1+ITYPE)= .TRUE.
         ENDIF
         IBID = ZI(JTY-1+NBGMA*NBTYMA+ITYPE) + 1
         ZI(JTY-1+NBGMA*NBTYMA+ITYPE) = IBID
         ZI(ZI(JJM-1+ITYPE)-1+IBID) = IMA
  33  CONTINUE
      DO 34 ITY=1,NBTYMA
        IF(ZI(JTY-1+NBGMA*NBTYMA+ITY).NE.0) NOMBRE = NOMBRE+1
  34  CONTINUE
      IF (NOMBRE.EQ.1) THEN
        ZI(JPOS-1+NBGMA+NBGNO+1) = IPOG + NOMBRE
        NBTOT = NBTOT + NOMBRE
      ELSE
        NBTOT = NBTOT + NOMBRE + 1
        ZI(JPOS-1+NBGMA+NBGNO+1) = IPOG+NOMBRE+1
      ENDIF
      ZI(JNUM-1+NBGRM+1) = NOMBRE
      ZK8(JNOM-1+NBGMA+NBGNO+1) = NOMA
      ZK8(JNO2-1+NBGMA+NBGNO+1) = NOMA
      CALL LXCAPS(ZK8(JNO2-1+NBGMA+NBGNO+1))
      ZI(JMT-1+NBGMA+1) = NBMA
C
C IMPRESSION DU MODELE
C
      IF ( NBMODL .NE. 0 ) THEN
        CALL JEEXIN('&&OP0039.LIGREL',IRET)
        IF (IRET.NE.0) CALL JEDETR('&&OP0039.LIGREL')
        CALL JECREC ( '&&OP0039.LIGREL', 'V V I','NU','DISPERSE',
     +                                   'VARIABLE',NBMODL)
        DO 200 I = 1 ,NBMODL
          NOLILI = ZK24(JMODL+I-1)
          CALL JEVEUO(NOLILI(1:19)//'.LIEL','L',JLIGR)
          CALL JELIRA(NOLILI(1:19)//'.LIEL','NUTIOC',NBGREL,KBID)
          CALL JEVEUO(JEXATR(NOLILI(1:19)//'.LIEL','LONCUM'),'L',JLONGR)
C
          ILONG =  NBGREL*(NBGREL+4)+1
          CALL JEECRA(JEXNUM('&&OP0039.LIGREL',I),'LONMAX',ILONG,KBID)
          CALL JEVEUO(JEXNUM('&&OP0039.LIGREL',I),'E',JGRELE)
C
          DO 202 IGRE=1,NBGREL
            IPOIN1 = ZI(JLONGR-1+IGRE)
            IPOIN2 = ZI(JLONGR-1+IGRE+1)
            NBELGR = IPOIN2-IPOIN1-1
            IMA    = ZI(JLIGR-1+IPOIN1+1-1)
            IF( IMA .LE. 0 ) GO TO 202
            IPOIN  = POINT(IMA)
            NNOE   = POINT(IMA+1)-IPOIN
            ITYPE  = TYPMA(IMA)
            IF ( IGRE .EQ. 1 ) THEN
              ZI(JGRELE-1+1) = 1
              ZI(JGRELE-1+2) = ITYPE
              ZI(JGRELE-1+4) = 1
              ZI(JGRELE-1+5) = NBELGR
              ZI(JGRELE-1+6) = IGRE
            ELSE
              NBSMO = ZI(JGRELE-1+1)
              DO 210 ISO = 1,NBSMO
                IF (ITYPE.EQ.ZI(JGRELE+(ISO-1)*(4+NBGREL)+1)) THEN
                   NBR = ZI(JGRELE+(ISO-1)*(4+NBGREL)+3)
                   ZI(JGRELE+(ISO-1)*(4+NBGREL)+3) = NBR + 1
                   NBELT = ZI(JGRELE+(ISO-1)*(4+NBGREL)+4)
                   ZI(JGRELE+(ISO-1)*(4+NBGREL)+4) = NBELT + NBELGR
                   ZI(JGRELE+(ISO-1)*(4+NBGREL)+5+NBR) = IGRE
                   GO TO 202
                ENDIF
 210          CONTINUE
              NBSMO = NBSMO+1
              ZI(JGRELE-1+1) = NBSMO
              ZI(JGRELE+(NBSMO-1)*(4+NBGREL)+1) = ITYPE
              ZI(JGRELE+(NBSMO-1)*(4+NBGREL)+3) = 1
              ZI(JGRELE+(NBSMO-1)*(4+NBGREL)+4) = NBELGR
              ZI(JGRELE+(NBSMO-1)*(4+NBGREL)+5) = IGRE
            ENDIF
 202      CONTINUE
          NBOBJ = ZI(JGRELE-1+1)
          ZI(JNUM-1+NBGRM+1+I) = NBOBJ
          IF (I.EQ.1) ZK8(JNOM-1+NBGMA+NBGNO+2) = ZK24(JMODL+I-1)(1:8)
          IF ( NBOBJ.GT.1) THEN
            IF (I.EQ.1)
     +         ZI(JPOS-1+NBGMA+NBGNO+2)=ZI(JPOS-1+NBGMA+NBGNO+1)+NBOBJ+1
            NBTOT = NBTOT + NBOBJ + 1
          ELSE
            IF (I.EQ.1)
     +         ZI(JPOS-1+NBGMA+NBGNO+2) = ZI(JPOS-1+NBGMA+NBGNO+1)+1
            NBTOT = NBTOT + NBOBJ
          ENDIF
 200    CONTINUE
      ELSE
        NBOBJ=0
      ENDIF
C
C     ECRITURE DES MAILLES
C
      NBCOUL = MAX(NNO,NMAMAX)
      CALL WKVECT('&&IRMACA.COUL','V V I',NBCOUL,JCOUL)
      DO 12 I =1,NBCOUL
        ZI(JCOUL-1+I) = 0
  12  CONTINUE
      CALL WKVECT('&&IRMACA.PLACE','V V I',NMAMAX      ,JPLA)
      CALL WKVECT('&&IRMACA.MPOI1','V V I',NNO         ,JPOI)
      CALL WKVECT('&&IRMACA.NOEU' ,'V V I',NMAMAX*27   ,JNOE)
C
      IBID = 2
      WRITE (IFC,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IBID
      IF ( LMOD ) THEN
       IF(NIVE.EQ.3) THEN
        WRITE (IFC,'(A,I4,A,I5,A,I5)')  ' PILE NUMERO',IPLU,
     +   'NBRE OBJETS NOMMES',NBGMA+NBGNO+2,'NBRE OBJETS',NBTOT+1
        WRITE(IFC,1002) (ZK8(JNO2-1+I),I=1,NBGMA+NBGNO+2)
        WRITE(IFC,1003) (ZI(JPOS-1+I),I=1,NBGMA+NBGNO+2)
       ELSEIF(NIVE.EQ.10) THEN
        WRITE (IFC,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',IPLU,
     +   'NBRE OBJETS NOMMES',NBGMA+NBGNO+2,'NBRE OBJETS',NBTOT+1
        WRITE(IFC,1002) (ZK8(JNO2-1+I),I=1,NBGMA+NBGNO+2)
        WRITE(IFC,1005) (ZI(JPOS-1+I),I=1,NBGMA+NBGNO+2)
       ENDIF
      ELSE
       IF(NIVE.EQ.3) THEN
        WRITE (IFC,'(A,I4,A,I5,A,I5)')  ' PILE NUMERO',IPLU,
     +   'NBRE OBJETS NOMMES',NBGMA+NBGNO+1,'NBRE OBJETS',NBTOT+1
        WRITE(IFC,1002) (ZK8(JNO2-1+I),I=1,NBGMA+NBGNO+1)
        WRITE(IFC,1003) (ZI(JPOS-1+I),I=1,NBGMA+NBGNO+1)
       ELSEIF (NIVE.EQ.10) THEN
        WRITE (IFC,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',IPLU,
     +   'NBRE OBJETS NOMMES',NBGMA+NBGNO+1,'NBRE OBJETS',NBTOT+1
        WRITE(IFC,1002) (ZK8(JNO2-1+I),I=1,NBGMA+NBGNO+1)
        WRITE(IFC,1005) (ZI(JPOS-1+I),I=1,NBGMA+NBGNO+1)
       ENDIF
      ENDIF
C ECRITURE DES OBJETS NOMMES
C
C -- ECRITURE DE TOUS LES NOEUDS (MAILLES DE TYPE POINT) ---
C
      ITYCA = 1
      IF (NIVE.EQ.3) THEN
       WRITE(IFC,'(5(I5))') ITYCA,IZERO,IZERO,ITYCA,NNO
       WRITE(IFC,'(16(I5))') (ZI(JCOUL-1+I),I=1,NNO)
       WRITE(IFC,'(16(I5))') (I,I=1,NNO)
      ELSEIF (NIVE.EQ.10) THEN
       WRITE(IFC,'(5(I8))') ITYCA,IZERO,IZERO,ITYCA,NNO
       WRITE(IFC,'(10(I8))') (ZI(JCOUL-1+I),I=1,NNO)
       WRITE(IFC,'(10(I8))') (I,I=1,NNO)
      ENDIF
C
C -- ECRITURE DE TOUS LES GROUPES DE NOEUDS (MAILLES DE TYPE POINT) ---
C
      DO 155 IGN=1,NBGRN
        CALL JEVEUO(JEXNUM(NOMA//'.GROUPENO',IGN),'L',IAGRNO)
        CALL JELIRA(JEXNUM(NOMA//'.GROUPENO',IGN),'LONMAX',NBN,KBID)
        IF (NBN.NE.1) THEN
          DO 156 J=1,NBN
            ZI(JPOI-1+J) = ZI(IAGRNO-1+J)
 156      CONTINUE
          IF(NIVE.EQ.3) THEN
           WRITE(IFC,'(5(I5))') ITYCA,IZERO,IZERO,ITYCA,NBN
           WRITE(IFC,'(16(I5))') (ZI(JCOUL-1+I),I=1,NBN)
           WRITE(IFC,'(16(I5))') (ZI(JPOI-1+I),I=1,NBN)
          ELSEIF(NIVE.EQ.10) THEN
           WRITE(IFC,'(5(I8))') ITYCA,IZERO,IZERO,ITYCA,NBN
           WRITE(IFC,'(10(I8))') (ZI(JCOUL-1+I),I=1,NBN)
           WRITE(IFC,'(10(I8))') (ZI(JPOI-1+I),I=1,NBN)
          ENDIF
        ENDIF
 155  CONTINUE
C
      CALL GICOOR ()
C
      NBPO = NBGNO+1
      DO 120 I =1,NBCOUL
        ZI(JCOUL-1+I) = 7
 120  CONTINUE
      IJK =0
      DO 81 IGM = 1,NBGRM+1
        NBSOBJ = ZI(JNUM-1+IGM)
        IDEP =1
        IF (NBSOBJ.EQ.0) GO TO 81
        IJK = IJK + 1
        DO 82 IOBJ=1,NBSOBJ
          DO 85 I=IDEP,NBTYMA
           IF (ZI(JTY-1+(IJK-1)*NBTYMA+I).NE.0)  THEN
             ITYPE = I
             CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',I),KTYPE)
             IDEP=ITYPE+1
             GOTO 87
           ENDIF
  85      CONTINUE
  87    CONTINUE
        NOMOB =ZK8(JNOM-1+NBGNO+IJK)
        IF(IGM.LE.NBGRM)  THEN
           TOTO = '&&IRMA.G.'
        ELSE
           TOTO = '&&IRMA.M.'
        ENDIF
        CALL JEVEUO(TOTO//NOMOB//KTYPE(1:7),'L',IAD)
        IMA = ZI(IAD)
        IPOIN=POINT(IMA)
        NNOE=POINT(IMA+1)-IPOIN
        NBM =ZI(JTY-1+(IJK-1)*NBTYMA+ITYPE)
        CALL IRMAC2 ( KTYPE, ITYCA, GTYPE, NNOE )
        CALL JEVEUO(JEXNOM('&&GILIRE.CORR_ASTER_GIBI',GTYPE),'L',
     +         IACORR)
        IF (NIVE.EQ.3) THEN
          WRITE(IFC,'(5(I5))') ITYCA,IZERO,IZERO,NNOE,NBM
          WRITE(IFC,'(16(I5))') (ZI(JCOUL-1+I),I=1,NBM)
        ELSEIF (NIVE.EQ.10) THEN
          WRITE(IFC,'(5(I8))') ITYCA,IZERO,IZERO,NNOE,NBM
          WRITE(IFC,'(10(I8))') (ZI(JCOUL-1+I),I=1,NBM)
        ENDIF
        DO 55 I =1,NBM
         IPOIN = POINT(ZI(IAD-1+I))
         DO 56 J = 1,NNOE
           IJ = ZI(IACORR-1+J)
           ZI(JNOE-1+(I-1)*NNOE+J) = CONNEX(IPOIN-1+IJ)
  56     CONTINUE
  55    CONTINUE
        IF (NIVE.EQ.3) THEN
         WRITE(IFC,'(16(I5))') (((ZI(JNOE-1+(I-1)*NNOE+J))
     +       ,J=1,NNOE),I=1,NBM)
        ELSEIF (NIVE.EQ.10) THEN
         WRITE(IFC,'(10(I8))') (((ZI(JNOE-1+(I-1)*NNOE+J))
     +       ,J=1,NNOE),I=1,NBM)
        ENDIF
  82  CONTINUE
      IF (NBSOBJ.GT.1) THEN
        IF (NIVE.EQ.3) THEN
        WRITE(IFC,'(5(I5))') IZERO,NBSOBJ,IZERO,IZERO,IZERO
        ELSEIF (NIVE.EQ.10) THEN
        WRITE(IFC,'(5(I8))') IZERO,NBSOBJ,IZERO,IZERO,IZERO
        ENDIF
        DO 99 I=1,NBSOBJ
         ZI(JPLA-1+I) = NBPO + I
  99    CONTINUE
        NBPO = NBPO+NBSOBJ+1
        IF(NIVE.EQ.3) THEN
          WRITE(IFC,'(16(I5))') ((ZI(JPLA-1+I)),
     +      I=1,NBSOBJ)
        ELSEIF(NIVE.EQ.10) THEN
          WRITE(IFC,'(10(I8))') ((ZI(JPLA-1+I)),
     +      I=1,NBSOBJ)
        ENDIF
      ELSE
         NBPO = NBPO + 1
      ENDIF
 81   CONTINUE
C
C IMPRESSION DU MODELE
C
      IF ( NBMODL .NE. 0 ) THEN
        DO 300 IMODL = 1 ,NBMODL
          NOLILI = ZK24(JMODL+IMODL-1)
          CALL JEVEUO(NOLILI(1:19)//'.LIEL','L',JLIGR)
          CALL JELIRA(NOLILI(1:19)//'.LIEL','NUTIOC',NBGREL,KBID)
          CALL JEVEUO(JEXATR(NOLILI(1:19)//'.LIEL','LONCUM'),'L',JLONGR)
          CALL JEVEUO(JEXNUM('&&OP0039.LIGREL',IMODL),'E',JGRELE)
          NBSMO = ZI(JGRELE-1+1)
          DO 302 ISO = 1,NBSMO
            NBGR  = ZI(JGRELE+(ISO-1)*(4+NBGREL)+3)
            NBELT = ZI(JGRELE+(ISO-1)*(4+NBGREL)+4)
            IEL = 0
            DO 304 IGR = 1,NBGR
              IGREL  = ZI(JGRELE+(ISO-1)*(4+NBGREL)+4+IGR)
              IPOIN1 = ZI(JLONGR-1+IGREL)
              IPOIN2 = ZI(JLONGR-1+IGREL+1)
              NBELGR = IPOIN2-IPOIN1-1
              IMA    = ZI(JLIGR-1+IPOIN1+1-1)
              IPOIN  = POINT(IMA)
              NNOE   = POINT(IMA+1)-IPOIN
              ITYPE  = TYPMA(IMA)
              CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ITYPE),KTYPE)
              CALL IRMAC2 ( KTYPE, ITYCA, GTYPE, NNOE )
              CALL JEVEUO(JEXNOM('&&GILIRE.CORR_ASTER_GIBI',GTYPE),'L',
     +                             IACORR)
              DO 306 I = 1,NBELGR
                IEL = IEL +1
                IMA = ZI(JLIGR-1+IPOIN1+I-1)
                IF ( IMA .LE. 0 ) GO TO 306
                IPOIN = POINT(IMA)
                NNOE  = POINT(IMA+1) -IPOIN
                IF (KTYPE.EQ.'QUAD9' .OR. KTYPE.EQ.'TRIA7') NNOE=NNOE-1
                IF (KTYPE.EQ.'SEG4') NNOE=NNOE-2
                DO 308 J = 1,NNOE
                  IJ = ZI(IACORR-1+J)
                  ZI(JNOE-1+(IEL-1)*NNOE+J) = CONNEX(IPOIN-1+IJ)
 308            CONTINUE
 306          CONTINUE
 304        CONTINUE
            IF(NIVE.EQ.3) THEN
              WRITE(IFC,'(5(I5))') ITYCA,IZERO,IZERO,NNOE,NBELT
              WRITE(IFC,'(16(I5))') (ZI(JCOUL-1+I),I=1,NBELT)
              WRITE(IFC,'(16(I5))') (((ZI(JNOE-1+(I-1)*NNOE+J)),
     +                                            J=1,NNOE),I=1,NBELT)
            ELSEIF (NIVE.EQ.10) THEN
              WRITE(IFC,'(5(I8))') ITYCA,IZERO,IZERO,NNOE,NBELT
              WRITE(IFC,'(10(I8))') (ZI(JCOUL-1+I),I=1,NBELT)
              WRITE(IFC,'(10(I8))') (((ZI(JNOE-1+(I-1)*NNOE+J)),
     +                                            J=1,NNOE),I=1,NBELT)
            ENDIF
 302      CONTINUE
          IF (NBSMO.GT.1) THEN
            IF(NIVE.EQ.3) THEN
              WRITE(IFC,'(5(I5))') IZERO,NBSMO,IZERO,IZERO,IZERO
            ELSEIF(NIVE.EQ.10) THEN
              WRITE(IFC,'(5(I8))') IZERO,NBSMO,IZERO,IZERO,IZERO
            ENDIF
            DO 310 ISO=1,NBSMO
              ZI(JPLA-1+ISO) = NBPO + ISO
              ZI(JGRELE+(ISO-1)*(4+NBGREL)+2) = ZI(JPLA-1+ISO)
 310        CONTINUE
            NBPO = NBPO+NBSMO+1
            IF(NIVE.EQ.3) THEN
              WRITE(IFC,'(16(I5))') ((ZI(JPLA-1+I)), I=1,NBSMO)
            ELSEIF(NIVE.EQ.10) THEN
              WRITE(IFC,'(10(I8))') ((ZI(JPLA-1+I)), I=1,NBSMO)
            ENDIF
          ELSE
            NBPO = NBPO + 1
            ZI(JGRELE-1+3) = NBPO
          ENDIF
 300    CONTINUE
      ENDIF
C
C ECRITURE DES NOEUDS
C
      IF (NIVE.EQ.10) THEN
        IBID = 2
        ITRDEU = 32
        ITRTRO = 33
        WRITE (IFC,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IBID
        WRITE (IFC,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',ITRDEU,
     +     'NBRE OBJETS NOMMES',NBOBJN,'NBRE OBJETS',NNO
        IF (NBOBJN.NE.0)  THEN
          WRITE(IFC,1002) (ZK8(JNN-1+I),I=1,NBOBJN)
          WRITE(IFC,1005) (ZI(JGN-1+I),I=1,NBOBJN)
        ENDIF
        WRITE (IFC,'(I8)') NNO
        CALL WKVECT ('&&IRMACA.NUNN','V V I',NNO,INUMM)
        DO 442 I=1,NNO
          ZI(INUMM-1+I) = I
  442   CONTINUE
        WRITE(IFC,'(10(I8))') (ZI(INUMM-1+I),I=1,NNO)
C
        WRITE (IFC,'(A,I4)')   ' ENREGISTREMENT DE TYPE',IBID
        IUN = 1
        WRITE (IFC,'(A,I4,A,I8,A,I8)')  ' PILE NUMERO',ITRTRO,
     +     'NBRE OBJETS NOMMES',IZERO,'NBRE OBJETS',IUN
C
        CALL WKVECT ('&&IRMACA.COOR','V V R',(NDIM+1)*NNO,JCOO)
        WRITE (IFC,'(I8)')  NNO*(NDIM+1)
        DO 111 INO = 1,NNO
         DO 222 IDI =1,NDIM
          ZR(JCOO-1+(INO-1)*(NDIM+1)+IDI) = COORDO(3*(INO-1)+IDI)
  222    CONTINUE
         ZR(JCOO-1+(INO-1)*(NDIM+1)+4) = RBID
  111   CONTINUE
        WRITE(IFC,1001) (ZR(JCOO-1+I),I=1,(NDIM+1)*NNO)
      ENDIF
C
      CALL JEDETC ( 'V', '&&IRMACA', 1 )
      CALL JEDETC ( 'V', '&&IRMA.G', 1 )
      CALL JEDETC ( 'V', '&&IRMA.M', 1 )
      CALL JEDETR ( '&&GILIRE.CORR_ASTER_GIBI' )
C
 1001 FORMAT (3(1X,D21.14))
 1002 FORMAT (8(1X,A8))
 1003 FORMAT (16(I5))
 1004 FORMAT (9X,7(1X,A8))
 1005 FORMAT (10(I8))
 9999 CONTINUE
C
      CALL JEDEMA()
      END
