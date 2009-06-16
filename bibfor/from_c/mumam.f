      SUBROUTINE MUMAM(OPTMPI,IFM,NIV,ACH24,ARGI1,ARGI2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF FROM_C  DATE 16/06/2009   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  APPELS MPI POUR MUMPS (AVEC LIB MPI)
C
C ARGUMENTS D'APPELS
C IN OPTMPI   : IN  : OPTION DE LA ROUTINE
C    =0        DISTRIBUTION DE LA CHARGE SD/PROC
C    =1        DIFFUSION DU VECTEUR (REEL/INTEGER) ACH24 DE LONGUEUR
C              ARGI1 DE PROC 0 A TOUS LES PROCS
C    =2       DETERMINATION DU RANG DANS ARGI1
C    =3       DETERMINATION DU NBRE DE PROCS DANS ARGI1
C    =4       REDUCTION DU VECTEUR ACH24 DE LONGUEUR ARGI1 AU PROC 0
C    =5       REDUCTION+DIFFUSION DE ACH24 DE LONGUEUR ARGI1
C    =6       IDEM 5 SAUF :
C               - ON NE DONNE PAS LA LONGUEUR
C               - CA MARCHE AUSSI POUR LES COLLECTIONS
C
C IN IFM,NIV  : IN  : AFFICHAGE
C IN    ACH24 : K24 : NOM JEVEUX DU VECTEUR A COMMUNIQUER
C INOUT ARGI1 : IN  : 1ERE ARGUMENT ENTIER
C INOUT ARGI2 : IN  : 2ND ARGUMENT ENTIER
C----------------------------------------------------------------------
C TOLE CRS_200
C TOLE CRS_505
C TOLE CRS_506
C TOLE CRS_507
C RESPONSABLE BOITEAU O.BOITEAU
C CORPS DU PROGRAMME
      IMPLICIT NONE
      INCLUDE 'mpif.h'
C DECLARATION PARAMETRES D'APPELS
      INTEGER      OPTMPI,IFM,NIV,ARGI1,ARGI2
      CHARACTER*24 ACH24

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
      INTEGER*4          ZI4
      COMMON  / I4VAJE / ZI4(1)
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

C DECLARATION VARIABLES LOCALES
      INTEGER      VALI(2),IACH,IEXIST,ILIST,NBPROC,RANG,NBSDP0,IAUX1
      INTEGER      IBID,NBSD,NBSD1,IAUX4,IPROC2,IDD,NBPRO1,IPROC
      INTEGER      IPROC1,IAUX2,IAUX3,DECAL,ILOG,LOISEM,K,NLONG
      INTEGER      IOBJ,NBOBJ
      INTEGER*4    RANG4,IERMPI,LR8,LINT,NBPRO4,N4,LC8
      CHARACTER*1  TYPSCA,XOUS
      CHARACTER*8  K8BID
      CHARACTER*24 NOMLOG
      LOGICAL      FIRST
      SAVE         LR8,LINT,FIRST,LC8
      DATA         FIRST /.TRUE./

C CORPS DU PROGRAMME
      CALL JEMARQ()
C INITS.
      IF (FIRST) THEN
C POUR LA GESTION DES ERREURS PAR LE DEVELOPPEUR
        CALL MPI_ERRHANDLER_SET(MPI_COMM_WORLD,MPI_ERRORS_RETURN,IERMPI)
        CALL FETMER(IERMPI)
        IF (LOISEM().EQ.8) THEN
          LINT=MPI_INTEGER8
        ELSE
          LINT=MPI_INTEGER
        ENDIF
        LR8 = MPI_DOUBLE_PRECISION
        LC8 = MPI_DOUBLE_COMPLEX
        FIRST= .FALSE.
      ENDIF

C FILTRE POUR EVITER DU TRAVAIL SUPPLEMENTAIRE SI NBPROC=1
      IF ((OPTMPI.NE.0).AND.(OPTMPI.NE.2).AND.(OPTMPI.NE.3)) THEN
        CALL MPI_COMM_SIZE(MPI_COMM_WORLD,NBPRO4,IERMPI)
        CALL FETMER(IERMPI)
        IF (NBPRO4.EQ.1) GOTO 999
      ENDIF
C---------------------------------------------- OPTION = 0
      IF (OPTMPI.EQ.0) THEN
C REPARTITION DE LA CHARGE SD/PROC. ON REPREND LA MEME HEURISTIQUE
C QUE CELLE DE FETI (CF. BIBFOR/FROM_C/FETAM.F)
        NBSDP0=ARGI2
        NBSD=ARGI1
        NBSD1=NBSD+1
C OBJET TEMPORAIRE POUR PARALLELISME MPI:
C ZI(ILIST+I)=1 IEME SOUS-DOMAINE CALCULE PAR PROCESSEUR COURANT
C            =0 ELSE
        NOMLOG='&MUMPS.LISTE.SD.MPI'
        CALL JEEXIN(NOMLOG,IEXIST)
        IF (IEXIST.NE.0) CALL U2MESS('F','APPELMPI_7')
        CALL WKVECT(NOMLOG,'V V I',NBSD1,ILIST)

        CALL MPI_COMM_SIZE(MPI_COMM_WORLD,NBPRO4,IERMPI)
        CALL FETMER(IERMPI)
        NBPROC=NBPRO4
        CALL MPI_COMM_RANK(MPI_COMM_WORLD,RANG4,IERMPI)
        CALL FETMER(IERMPI)
        RANG=RANG4

C DECOUPAGE DU TRAVAIL PAR PROCESSEUR. COMME ON SE SERT DE L'HEURISTIQUE
C DEVELOPPEE POUR FETI, ON GROUPE LES SD PAR SOUS-DOMAINES CONTIGUS
C D'AUTRE PART, ON SOULAGE D'UN POINT DE VUE MEMOIRE, SI POSSIBLE, LE
C PROCESSEUR DE RANG 0 . DONC, SI NBPROC < NBSD, ON REDISTRIBUE LES SD
C EXCEDENTAIRES EN COMMENCANT PAR LE PROC 1
C EXEMPLE: 8 SD ET 4 PROC
C PROC 0 : SD1/SD2
C PROC 1 : SD3/SD4
C ...
C EXEMPLE: 9 SD ET 4 PROC
C PROC 0 : SD1/2
C PROC 1 : SD3/SD4/SD5
C PROC 2 : SD6/SD7
C...
C DOMAINE GLOBALE (IDD=0) CONCERNE TOUS LES PROCESSEURS
        ZI(ILIST)=1
        DO 90 IDD=1,NBSD
          ZI(ILIST+IDD)=0
   90   CONTINUE
        IF (NBSDP0.EQ.0) THEN
          IAUX1=NBSD/NBPROC
          IAUX4=NBSD-(NBPROC*IAUX1)
          IPROC2=0
        ELSE
C ATTRIBUTIONS DU PROC 0
          DO 92 IDD=1,NBSDP0
            IF (RANG.EQ.0) ZI(ILIST+IDD)=1
   92     CONTINUE
C RESTE AUX AUTRES PROC
          IAUX1=(NBSD-NBSDP0)/(NBPROC-1)
          IAUX4=(NBSD-NBSDP0)-((NBPROC-1)*IAUX1)
          IPROC2=1
        ENDIF
        NBPRO1=NBPROC-1
        DO 100 IPROC=IPROC2,NBPRO1
C INDICE RELATIF DU PROCESSEUR A EQUILIBRER
          IPROC1=IPROC-IPROC2
C BORNES DES SDS A LUI ATTRIBUER
          IAUX2=1+NBSDP0+IPROC1*IAUX1
          IAUX3=NBSDP0+(IPROC1+1)*IAUX1
C CALCUL D'UN DECALAGE EVENTUEL DU AU RELIQUAT DE SD
          IF (IAUX4.LT.IPROC1) THEN
            DECAL=IAUX4
          ELSE
            IF (IPROC1.EQ.0) THEN
              DECAL=0
            ELSE
              DECAL=IPROC1-1
              IAUX3=IAUX3+1
            ENDIF
          ENDIF
C ATTRIBUTIONS SD/PROC
          DO 95 IDD=IAUX2,IAUX3
            IF (IPROC.EQ.RANG) ZI(ILIST+DECAL+IDD)=1
   95     CONTINUE
  100   CONTINUE






C---------------------------------------------- OPTION = 1
      ELSE IF (OPTMPI.EQ.1) THEN
C DIFFUSION DU VECTEUR DE REELS ACH24 DE 0 A TOUS LES PROCS
        CALL JELIRA(ACH24,'TYPE',IBID,TYPSCA)
        CALL JEVEUO(ACH24,'E',IACH)
        N4=ARGI1
        IF (TYPSCA.EQ.'R') THEN
          CALL MPI_BCAST(ZR(IACH),N4,LR8,0,MPI_COMM_WORLD,IERMPI)
        ELSE IF(TYPSCA.EQ.'I') THEN
          CALL MPI_BCAST(ZI(IACH),N4,LINT,0,MPI_COMM_WORLD,IERMPI)
        ELSE IF(TYPSCA.EQ.'C') THEN
          CALL MPI_BCAST(ZC(IACH),N4,LC8,0,MPI_COMM_WORLD,IERMPI)
        ENDIF
        CALL FETMER(IERMPI)


C
C---------------------------------------------- OPTION = 2
      ELSE IF (OPTMPI.EQ.2) THEN
C DETERMINATION DU RANG D'UN PROCESSUS
        CALL MPI_COMM_RANK(MPI_COMM_WORLD,RANG4,IERMPI)
        CALL FETMER(IERMPI)
        ARGI1=RANG4


C
C---------------------------------------------- OPTION = 3
      ELSE IF (OPTMPI.EQ.3) THEN
C DETERMINATION DU NBRE DE PROCESSEURS
        CALL MPI_COMM_SIZE(MPI_COMM_WORLD,NBPRO4,IERMPI)
        CALL FETMER(IERMPI)
        ARGI1=NBPRO4


C
C---------------------------------------------- OPTION = 4
      ELSE IF (OPTMPI.EQ.4) THEN
C REDUCTION DU VECTEUR ACH24 POUR LE PROCESSEUR MAITRE
        CALL JELIRA(ACH24,'TYPE',IBID,TYPSCA)
        CALL JEVEUO(ACH24,'E',IACH)
        CALL GCNCON('.',K8BID)
        NOMLOG='&REDUCE_MUMMPI_'//K8BID
        N4=ARGI1

        IF (TYPSCA.EQ.'R') THEN
          CALL WKVECT(NOMLOG,'V V R',ARGI1,ILOG)
          CALL DCOPY(N4,ZR(IACH),1,ZR(ILOG),1)
          CALL MPI_REDUCE(ZR(ILOG),ZR(IACH),N4,LR8,MPI_SUM,0,
     &                    MPI_COMM_WORLD,IERMPI)
        ELSE IF (TYPSCA.EQ.'I') THEN
          CALL WKVECT(NOMLOG,'V V I',ARGI1,ILOG)
          DO 1, K=1,N4
            ZI(ILOG-1+K)=ZI(IACH-1+K)
 1        CONTINUE
          CALL MPI_REDUCE(ZI(ILOG),ZI(IACH),N4,LINT,MPI_SUM,0,
     &                    MPI_COMM_WORLD,IERMPI)
        ELSE IF (TYPSCA.EQ.'C') THEN
          CALL WKVECT(NOMLOG,'V V C',ARGI1,ILOG)
          CALL ZCOPY(N4,ZC(IACH),1,ZC(ILOG),1)
          CALL MPI_REDUCE(ZC(ILOG),ZC(IACH),N4,LC8,MPI_SUM,0,
     &                    MPI_COMM_WORLD,IERMPI)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
        CALL FETMER(IERMPI)
        CALL JEDETR(NOMLOG)



C---------------------------------------------- OPTION = 5
      ELSE IF (OPTMPI.EQ.5) THEN
C       REDUCTION + DIFFUSION DU VECTEUR ACH24
        CALL JELIRA(ACH24,'TYPE',IBID,TYPSCA)
        CALL JEVEUO(ACH24,'E',IACH)
        CALL GCNCON('.',K8BID)
        NOMLOG='&ALLRED_MUMMPI_'//K8BID
        N4=ARGI1

        IF (TYPSCA.EQ.'R') THEN
          CALL WKVECT(NOMLOG,'V V R',ARGI1,ILOG)
          CALL DCOPY(N4,ZR(IACH),1,ZR(ILOG),1)
          CALL MPI_ALLREDUCE(ZR(ILOG),ZR(IACH),N4,LR8,MPI_SUM,
     &                    MPI_COMM_WORLD,IERMPI)
        ELSE IF (TYPSCA.EQ.'I') THEN
          CALL WKVECT(NOMLOG,'V V I',ARGI1,ILOG)
          DO 2, K=1,N4
            ZI(ILOG-1+K)=ZI(IACH-1+K)
 2        CONTINUE
          CALL MPI_ALLREDUCE(ZI(ILOG),ZI(IACH),N4,LINT,MPI_SUM,
     &                    MPI_COMM_WORLD,IERMPI)
        ELSE IF (TYPSCA.EQ.'C') THEN
          CALL WKVECT(NOMLOG,'V V C',ARGI1,ILOG)
          CALL ZCOPY(N4,ZC(IACH),1,ZC(ILOG),1)
          CALL MPI_ALLREDUCE(ZC(ILOG),ZC(IACH),N4,LC8,MPI_SUM,
     &                    MPI_COMM_WORLD,IERMPI)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
        CALL FETMER(IERMPI)
        CALL JEDETR(NOMLOG)



C---------------------------------------------- OPTION = 6
      ELSE IF (OPTMPI.EQ.6) THEN
C       REDUCTION + DIFFUSION DE L'OBJET JEVEURX ACH24
C       REMARQUE : ACH24 PEUT ETRE UNE COLLECTION
        CALL JELIRA(ACH24,'TYPE',IBID,TYPSCA)
        CALL JELIRA(ACH24,'XOUS',IBID,XOUS)
        IF (XOUS.EQ.'X') THEN
          CALL JELIRA(ACH24,'NMAXOC',NBOBJ,K8BID)
        ELSE
          NBOBJ=1
        ENDIF

        DO 10, IOBJ=1,NBOBJ
          IF (XOUS.EQ.'S') THEN
            CALL JEVEUO(ACH24,'E',IACH)
            CALL JELIRA(ACH24,'LONMAX',NLONG,K8BID)
          ELSE
            CALL JEVEUO(JEXNUM(ACH24,IOBJ),'E',IACH)
            CALL JELIRA(JEXNUM(ACH24,IOBJ),'LONMAX',NLONG,K8BID)
          ENDIF

          CALL GCNCON('.',K8BID)
          NOMLOG='&ALLRED_MUMMPI_'//K8BID
          N4=NLONG

          IF (TYPSCA.EQ.'R') THEN
            CALL WKVECT(NOMLOG,'V V R',NLONG,ILOG)
            CALL DCOPY(N4,ZR(IACH),1,ZR(ILOG),1)
            CALL MPI_ALLREDUCE(ZR(ILOG),ZR(IACH),N4,LR8,MPI_SUM,
     &                      MPI_COMM_WORLD,IERMPI)
          ELSE IF (TYPSCA.EQ.'I') THEN
            CALL WKVECT(NOMLOG,'V V I',NLONG,ILOG)
            DO 3, K=1,N4
              ZI(ILOG-1+K)=ZI(IACH-1+K)
 3          CONTINUE
            CALL MPI_ALLREDUCE(ZI(ILOG),ZI(IACH),N4,LINT,MPI_SUM,
     &                      MPI_COMM_WORLD,IERMPI)
          ELSE IF (TYPSCA.EQ.'C') THEN
            CALL WKVECT(NOMLOG,'V V C',NLONG,ILOG)
            CALL ZCOPY(N4,ZC(IACH),1,ZC(ILOG),1)
            CALL MPI_ALLREDUCE(ZC(ILOG),ZC(IACH),N4,LC8,MPI_SUM,
     &                      MPI_COMM_WORLD,IERMPI)
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
          CALL JEDETR(NOMLOG)
 10     CONTINUE
        CALL FETMER(IERMPI)


C
C---------------------------------------------- MAUVAISE OPTION
      ELSE
        CALL MPI_COMM_RANK(MPI_COMM_WORLD,RANG4,IERMPI)
        CALL FETMER(IERMPI)
        VALI(1)=RANG4
        VALI(2)=OPTMPI
        CALL U2MESI('F','APPELMPI_6',2,VALI)
      ENDIF
  999 CONTINUE
      CALL JEDEMA()
      END
