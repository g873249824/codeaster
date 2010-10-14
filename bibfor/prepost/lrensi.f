      SUBROUTINE LRENSI(FICH,LONG,LINOCH,NDIM,NOMO,NOMA,RESU)
      IMPLICIT  NONE
      INTEGER      LONG,NDIM
      CHARACTER*8  RESU,NOMA,NOMO
      CHARACTER*16 FICH,LINOCH(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 11/10/2010   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRS_512
C
C     BUT:
C       LECTURE DES RESULTATS PRESENTS DANS LES FICHIERS ENSIGHT
C       ET STOCKAGE DANS LA SD RESULTAT
C
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   FICH     : NOM DU FICHIER ENSIGHT
C IN   LONG     : LONGUEUR DU NOM DU FICHIER ENSIGHT
C IN   LINOCH   : LISTE DES NOMS DE CHAMPS A LIRE
C                 ICI IL N'Y EN A QU'UN ET C'EST 'PRES'
C IN   NDIM     : DIMENSION DE LA GEOMETRIE
C IN   NOMO     : NOM DU MODELE
C IN   NOMA     : NOM DU MAILLAGE
C IN   RESU     : NOM DE LA SD_RESULTAT
C
C ......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)

      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='LRENSI')

      INTEGER IU99,IU98,IU97,ULNUME
      INTEGER VALI(2)
      INTEGER LXLGUT
      INTEGER NPAS
      INTEGER IRET,LL
      INTEGER I,IO,NSCAL,NVECT,NFLAG
      INTEGER IPAS,I1,I2,NBNO,INOPR,NCARLU
      INTEGER I21,NLIG,IPRES,NBGR,NFACHA
      INTEGER IDEC,JCELD,NBELGR,IEL,IMA,LIEL
      INTEGER INO,NNO,II,IADNO,IAD,JCELV
      INTEGER INDIIS
      INTEGER IBID,NSTAR,J,IREST
      INTEGER TE,TYPELE,NBGREL,NBELEM,IGR
      INTEGER JINST,ITPS

      CHARACTER*1 KBID
      CHARACTER*8 K8B,CHAINE
      CHARACTER*8 LPAIN(1),LPAOUT(1)
      CHARACTER*16 DIR,NOMTE
      CHARACTER*19 NOMCH,LIGRMO,CHPRES
      CHARACTER*24 LCHIN(1),LCHOUT(1)
      CHARACTER*24 VALK(2)
      CHARACTER*24 NOLIEL
      CHARACTER*80 K80B,FIRES,FIPRES,FIGEOM,FIC80B
      CHARACTER*24 CHGEOM,OPTION,CONNEX
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C            1234567890123456
      DIR = 'DONNEES_ENSIGHT/'
      FIC80B = FICH
      FIRES = DIR//FICH(1:LONG)
      IU99 = ULNUME ()
      CALL ULOPEN(IU99,FIRES,' ','OLD','O')

C  LECTURE DU FICHIER RESULTS (PAS DE TEMPS
C                              ET FICHIERS GEOM ET PRES)
      READ (IU99,'(3I8)',ERR=50,END=50,IOSTAT=IO) NSCAL,NVECT,NFLAG
      READ (IU99,'(1I8)',ERR=50,END=50,IOSTAT=IO) NPAS

      CALL WKVECT('&&'//NOMPRO//'.INST','V V R',NPAS,IPAS)
      READ (IU99,'(6(E12.5))',ERR=50,END=50,
     &    IOSTAT=IO) (ZR(IPAS-1+I),I=1,NPAS)
      I1 = 0
      I2 = 0
      IF (NFLAG.GT.0) THEN
        READ (IU99,'(2I8)',ERR=50,END=50,IOSTAT=IO) I1,I2
      ELSE
        IF (NPAS.NE.1) THEN
          CALL ASSERT(.FALSE.)
        END IF
      END IF
      READ (IU99,'(A80)',ERR=50,END=50,IOSTAT=IO) FIGEOM
      LONG = LXLGUT(FIGEOM)
      FIGEOM(1:16+LONG) = DIR//FIGEOM(1:LONG)
      READ (IU99,'(A80)',ERR=50,END=50,IOSTAT=IO) FIPRES
      CALL ULOPEN(-IU99,' ',' ',' ',' ')
      LONG = LXLGUT(FIGEOM)
      FIPRES(1:16+LONG) = DIR//FIPRES(1:LONG)

      FIC80B = FIGEOM
      IU98 = ULNUME ()
      CALL ULOPEN(IU98,FIGEOM,' ','OLD','O')
C  LECTURE DU FICHIER GEOM (NUMEROS DE NOEUDS)
      READ (IU98,'(A80)',ERR=50,END=50,IOSTAT=IO) K80B
      READ (IU98,'(A80)',ERR=50,END=50,IOSTAT=IO) K80B
      READ (IU98,'(1I8)',ERR=50,END=50,IOSTAT=IO) NBNO
      CALL WKVECT('&&'//NOMPRO//'.NUMNOEU','V V I',NBNO,INOPR)
      DO 10 I = 1,NBNO
        READ (IU98,'(1I8)',ERR=50,IOSTAT=IO) ZI(INOPR-1+I)
   10 CONTINUE
      CALL ULOPEN(-IU98,' ',' ',' ',' ')

      NSTAR = 0
      NCARLU = 0
      LL = LEN(FIPRES)
      DO 20 I = 1,LL
        IF (FIPRES(I:I).EQ.'*') THEN
          NSTAR = NSTAR + 1
        END IF
        IF (NSTAR.GT.0 .AND. FIPRES(I:I).EQ.' ') GO TO 30
        NCARLU = NCARLU + 1
   20 CONTINUE
   30 CONTINUE
      LL = NCARLU
      IF (NSTAR.GE.8) THEN
        VALI (1) = NSTAR
        CALL U2MESG('F','UTILITAI8_25',0,' ',1,VALI,0,0.D0)
      END IF

      CHGEOM = NOMA//'.COORDO'

      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM

      LPAOUT(1) = 'PPRES_R'
      CHPRES = '&&CHPRES'
      LCHOUT(1) = CHPRES
      LIGRMO = NOMO//'.MODELE'
      OPTION = 'TOU_INI_ELNO'
      CALL CALCUL('S',OPTION,LIGRMO,1,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')


C     -- ON VERIFIE QUE LE CHAM_ELEM N'EST PAS TROP DYNAMIQUE :
      CALL CELVER(CHPRES,'NBVARI_CST','STOP',IBID)
      CALL CELVER(CHPRES,'NBSPT_1','STOP',IBID)

      CALL JEVEUO(CHPRES//'.CELD','L',JCELD)
      CALL JEVEUO(CHPRES//'.CELV','E',JCELV)

C  BOUCLE SUR LES PAS DE TEMPS ET LECTURE DES PRESSIONS
C  ----------------------------------------------------

      DO 40 ITPS = 1,NPAS

        I21 = I1 + (ITPS-1)*I2
        CALL CODENT(I21,'D0',CHAINE)
        IF (NSTAR.GT.0) THEN
          FIPRES = FIPRES(1:LL-NSTAR)//CHAINE(9-NSTAR:8)
        END IF
        FIC80B = FIPRES
        IU97 = ULNUME ()
        CALL ULOPEN(IU97,FIPRES,' ','OLD','O')
        READ (IU97,'(A80)',ERR=50,END=50,IOSTAT=IO) K80B
        CALL WKVECT('&&'//NOMPRO//'.PRES.'//CHAINE,'V V R',NBNO,IPRES)
        NLIG = NBNO/6
        DO 410 I = 1,NLIG
          READ (IU97,'(6(E12.5))') (ZR(IPRES-1+6* (I-1)+J),J=1,6)
  410   CONTINUE
        IREST = NBNO - 6*NLIG
        IF (IREST.GT.0) THEN
          READ (IU97,'(6(E12.5))',ERR=50,END=50,
     &        IOSTAT=IO) (ZR(IPRES-1+6*NLIG+J),J=1,IREST)
        END IF
        CALL ULOPEN (-IU97,' ',' ',' ',' ')

C  REMPLISSAGE DU .VALE DU CHAM_ELEM DE PRES_R

        CONNEX = NOMA//'.CONNEX'
        NOLIEL = LIGRMO//'.LIEL'
        NBGR = NBGREL(LIGRMO)

        IF (NDIM.GE.3) THEN
          NFACHA = 0
          DO 411 IGR = 1,NBGR
            IDEC = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+8)
            TE = TYPELE(LIGRMO,IGR)
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)

            IF (NOMTE.EQ.'MECA_FACE3'.OR.NOMTE.EQ.'MECA_FACE4'.OR.
     &          NOMTE.EQ.'MECA_FACE6'.OR.NOMTE.EQ.'MECA_FACE8'.OR.
     &          NOMTE.EQ.'MECA_FACE9'.OR.NOMTE.EQ.'MEQ4QU4'   .OR.
     &          NOMTE.EQ.'MEDSQU4'   .OR.NOMTE.EQ.'MEDSTR3'   ) THEN
              NBELGR = NBELEM(LIGRMO,IGR)
              CALL JEVEUO(JEXNUM(NOLIEL,IGR),'L',LIEL)
              DO 412 IEL = 1,NBELGR
                IMA = ZI(LIEL-1+IEL)
                CALL JEVEUO(JEXNUM(CONNEX,IMA),'L',IADNO)
                CALL JELIRA(JEXNUM(CONNEX,IMA),'LONMAX',NNO,KBID)
                DO 413 INO = 1,NNO
                  II = INDIIS(ZI(INOPR),ZI(IADNO-1+INO),1,NBNO)
                  IF (II.EQ.0) GO TO 415
  413           CONTINUE

C   LA MAILLE IMA EST CHARGEE EN PRESSION

                NFACHA = NFACHA + 1
                IAD = JCELV - 1 + IDEC - 1 + NNO* (IEL-1)
                DO 414 I = 1,NNO
                  II = INDIIS(ZI(INOPR),ZI(IADNO-1+I),1,NBNO)
                  ZR(IAD+I) = ZR(IPRES-1+II)
  414           CONTINUE
                GO TO 412
  415           CONTINUE

C   LA MAILLE IMA N'EST PAS CHARGEE EN PRESSION

                IAD = JCELV - 1 + IDEC - 1 + NNO* (IEL-1)
                DO 416 I = 1,NNO
                  ZR(IAD+I) = 0.0D0
  416           CONTINUE

  412         CONTINUE
            ELSE
              CALL U2MESK('A','UTILITAI2_91',1,NOMTE)
            END IF
  411     CONTINUE
        END IF

        IF (NDIM.EQ.2 .OR. (NDIM.GE.3.AND.NFACHA.EQ.0)) THEN
          DO 417 IGR = 1,NBGR
            IDEC = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+8)
            TE = TYPELE(LIGRMO,IGR)
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)

            IF (NOMTE.EQ.'MEPLSE2'.OR.NOMTE.EQ.'MEAXSE2'.OR.
     &          NOMTE.EQ.'MEPLSE3'.OR.NOMTE.EQ.'MEAXSE3') THEN
              NBELGR = NBELEM(LIGRMO,IGR)
              CALL JEVEUO(JEXNUM(NOLIEL,IGR),'L',LIEL)
              DO 418 IEL = 1,NBELGR
                IMA = ZI(LIEL-1+IEL)
                CALL JEVEUO(JEXNUM(CONNEX,IMA),'L',IADNO)
                CALL JELIRA(JEXNUM(CONNEX,IMA),'LONMAX',NNO,KBID)
                DO 419 INO = 1,NNO
                  II = INDIIS(ZI(INOPR),ZI(IADNO-1+INO),1,NBNO)
                  IF (II.EQ.0) GO TO 421
  419           CONTINUE

C   LA MAILLE IMA EST CHARGEE EN PRESSION

                IAD = JCELV - 1 + IDEC - 1 + 2*NNO* (IEL-1)
                DO 420 I = 1,NNO
                  II = INDIIS(ZI(INOPR),ZI(IADNO-1+I),1,NBNO)
                  ZR(IAD+2*I-1) = ZR(IPRES-1+II)
                  ZR(IAD+2*I) = 0.0D0
  420           CONTINUE
                GO TO 418
  421           CONTINUE

C   LA MAILLE IMA N'EST PAS CHARGEE EN PRESSION

                IAD = JCELV - 1 + IDEC - 1 + 2*NNO* (IEL-1)
                DO 422 I = 1,2*NNO
                  ZR(IAD+I) = 0.0D0
  422           CONTINUE

  418         CONTINUE
            END IF
  417     CONTINUE

        END IF

        CALL RSEXCH(RESU,LINOCH(1),ITPS,NOMCH,IRET)
        IF (IRET.EQ.100) THEN
        ELSE IF (IRET.EQ.110) THEN
          CALL RSAGSD(RESU,0)
          CALL RSEXCH(RESU,LINOCH(1),ITPS,NOMCH,IRET)
        ELSE
          VALK (1) = RESU
          VALK (2) = NOMCH
          VALI (1) = ITPS
          VALI (2) = IRET
          CALL U2MESG('F','UTILITAI8_26',2,VALK,2,VALI,0,0.D0)
        END IF
        CALL COPISD('CHAMP_GD','G',CHPRES,NOMCH)
        CALL RSNOCH(RESU,LINOCH(1),ITPS,' ')
        CALL RSADPA(RESU,'E',1,'INST',ITPS,0,JINST,K8B)
        ZR(JINST) = ZR(IPAS-1+ITPS)

        CALL JEDETR('&&'//NOMPRO//'.PRES.'//CHAINE)

  40  CONTINUE

      GO TO 60
      
  50  CONTINUE

C     -- MESSAGE D'ERREUR DE LECTURE :
C     --------------------------------------------
      IF (IO.LT.0) THEN
        CALL U2MESG('F+','UTILITAI8_28',0,' ',0,0,0,0.D0)
      ELSE IF (IO.GT.0) THEN
        CALL U2MESG('F+','UTILITAI8_29',0,' ',0,0,0,0.D0)
      END IF
      VALK (1) = FIC80B(1:24)
      CALL U2MESG('F','UTILITAI8_30',1,VALK,0,0,0,0.D0)

  60  CONTINUE
C
      CALL JEDEMA()
C
      END
