      SUBROUTINE REDETR(MATELZ)
      IMPLICIT NONE
      CHARACTER*(*) MATELZ
C RESPONSABLE PELLET J.PELLET
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/03/2010   AUTEUR PELLET J.PELLET 
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
C ======================================================================
C
C      BUT: DETRUIRE DANS LE MATR_ELEM  MATELZ LES RESUELEM NULS
C           MAIS EN PRENANT GARDE QU'IL RESTE QUELQUE CHOSE
C
C     IN/OUT  : MATELZ = NOM DE LA SD MATR_ELEM A NETTOYER
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER JRELR,IRET1,IRET2,IEXI
      INTEGER IZERO,ADETR(20),ICO,K,NB1,NBDET
      REAL*8 RBID
      LOGICAL ZEROSD
      CHARACTER*4 CBID
      CHARACTER*19 MATELE,RESUEL,TEMPOR(20)

      CALL JEMARQ()

      MATELE=MATELZ

C     -- SI LE MATR_ELEM NE CONTIENT QUE DES MACRO-ELEMENTS,
C        L'OBJET .RELR N'EXISTE PAS ET IL N'Y A RIEN A FAIRE :
      CALL JEEXIN(MATELE//'.RELR',IEXI)
      IF (IEXI.EQ.0) GOTO 60


      CALL JEVEUO(MATELE//'.RELR','E',JRELR)
      CALL JELIRA(MATELE//'.RELR','LONUTI',NB1,CBID)
      CALL ASSERT(NB1.LE.20)


C     -- ON EXAMINE LES RESUELEM CANDIDATS A LA DESTRUCTION :
C        ADETR(K)=1 : LE NOM EST ' '
C        ADETR(K)=2 : LE NOM EST NON ' ' MAIS LA SD N'EXISTE PAS
C        ADETR(K)=3 : LA SD EXISTE ET ELLE EST NULLE
C        ADETR(K)=0 : LA SD EXISTE ET ELLE EST NON NULLE
      DO 10,K=1,NB1
        ADETR(K)=0
        RESUEL=ZK24(JRELR-1+K)
        IF (RESUEL.EQ.' ') THEN
          CALL ASSERT(.FALSE.)
          ADETR(K)=1
          GOTO 10
        ENDIF

C       -- EXISTENCE DU RESU_ELEM ?
        CALL EXISD('RESUELEM',RESUEL,IRET1)
        IF (IRET1.EQ.0) THEN
          ADETR(K)=2
          CALL ASSERT(.FALSE.)
          GOTO 10
        ENDIF


C       -- SI LE RESU_ELEM EST NUL SUR TOUS LES PROCS,
C          ON PEUT LE DETRUIRE:
        IZERO=1
        IF (ZEROSD('RESUELEM',RESUEL))IZERO=0
        CALL MPICM1('MPI_MAX','I',1,IZERO,RBID)
        IF (IZERO.EQ.0) THEN
          ADETR(K)=3
        ELSE
          ADETR(K)=0
        ENDIF
   10 CONTINUE


C     -- ON COMPTE LES RESUELEM A DETRUIRE :
      NBDET=0
      DO 20,K=1,NB1
        IF (ADETR(K).EQ.3)NBDET=NBDET+1
   20 CONTINUE
      IF (NBDET.EQ.0)GOTO 60

C     -- ON DETRUIT LES RESULEM NULS (ON EN GARDE AU MOINS 1) :
C        ON PART DE LA FIN CAR LA MATRICE NON SYMETRIQUE EST
C        EN GENERAL STOCKEE APRES LA SYMETRIQUE
      NBDET=MIN(NBDET,NB1-1)
      ICO=0
      DO 30,K=NB1,1,-1
        IF (ADETR(K).EQ.3) THEN
          ICO=ICO+1
          IF (ICO.GT.NBDET) GOTO 31
          RESUEL=ZK24(JRELR-1+K)
          CALL DETRSD('RESUELEM',RESUEL)
          ZK24(JRELR-1+K)=' '
        ENDIF
   30 CONTINUE
   31 CONTINUE

C     -- ON COMPACTE LE MATR_ELEM POUR QUE TOUS SES RESUELEM
C        SOIENT "VRAIS"
      ICO=0
      DO 40,K=1,NB1
        RESUEL=ZK24(JRELR-1+K)
        IF (RESUEL.NE.' ') THEN
          ICO=ICO+1
          TEMPOR(ICO)=RESUEL
        ENDIF
   40 CONTINUE
      CALL ASSERT(ICO.GT.0)

      CALL JEECRA(MATELE//'.RELR','LONUTI',ICO,CBID)
      DO 50,K=1,ICO
        ZK24(JRELR-1+K)=TEMPOR(K)
   50 CONTINUE


   60 CONTINUE

      CALL JEDEMA()

      END
