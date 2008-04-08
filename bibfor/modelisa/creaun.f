      SUBROUTINE CREAUN(CHAR,NOMA,NOMO,NBOCC,
     &                  LISNOE,POINOE,
     &                  DIMECU,NBGDCU,
     &                  COEFCU,CMPGCU,MULTCU)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/04/2008   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT      NONE
      CHARACTER*8   CHAR
      CHARACTER*8   NOMA
      CHARACTER*8   NOMO
      INTEGER       NBOCC
      CHARACTER*24  LISNOE
      CHARACTER*24  POINOE
      CHARACTER*24  DIMECU
      CHARACTER*24  NBGDCU
      CHARACTER*24  COEFCU
      CHARACTER*24  CMPGCU
      CHARACTER*24  MULTCU
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CALIUN
C ----------------------------------------------------------------------
C
C CONSTRUCTION FINALE DES VECTEURS
C ON OUBLIE LE CONCEPT DE ZONES
C
C IN  CHAR   : NOM DU CONCEPT CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  NBOCC  : NOMBRE D'OCCURRENCES MOT-CLEF FACTEUR
C IN  POINOE : NOM DE L'OBJET CONTENANT LE VECTEUR D'INDIRECTION
C               DES NOEUDS
C IN  LISNOE : NOM DE L'OBJET CONTENANT LES NOEUDS
C IN  DIMECU : NOM JEVEUX DE LA SD INFOS GENERALES
C IN  NBGDCU : NOM JEVEUX DE LA SD INFOS POINTEURS GRANDEURS DU MEMBRE
C              DE GAUCHE
C IN  COEFCU : NOM JEVEUX DE LA SD CONTENANT LES VALEURS DU MEMBRE
C              DE DROITE
C IN  CMPGCU : NOM JEVEUX DE LA SD CONTENANT LES GRANDEURS DU MEMBRE
C              DE GAUCHE
C IN  MULTCU : NOM JEVEUX DE LA SD CONTENANT LES COEFFICIENTS DU MEMBRE
C              DE GAUCHE
C
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXNUM
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
       INTEGER        NBGAU,TYPCMP
       INTEGER        JDIM,JMULT,JNOE,JPOI,JNBGD,JCOMPG
       INTEGER        JCOEFG,JCOEFD,JCOEF,JCMPG
       INTEGER        IOCC,INO,ICMP,I
       CHARACTER*24   NOEUCU,NOEUMA,POICU
       CHARACTER*24 VALK(2)
       INTEGER        JNOEU,JINDIR,JPOIN
       INTEGER        NBNOE,NBND,NBCP,NUMND,EXIST,NBSUP
       INTEGER        JDEBCP,JDEBND
       CHARACTER*8    CMP,K8BID,NOMNO
       INTEGER        CPTD,CPTG,CPTND
       CHARACTER*24   CMPCU,DIME
       INTEGER        JCPG,JCOEG,JCOED,JDIME
       INTEGER        IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
C ======================================================================
C
C --- INITIALISATIONS
C
      NOEUMA = NOMA // '.NOMNOE'
      CALL JEVEUO(DIMECU,'L',JDIM)
      CALL JEVEUO(MULTCU,'L',JMULT)
      CALL JEVEUO(POINOE,'L',JPOI)
      CALL JEVEUO(LISNOE,'L',JNOE)
      CALL JEVEUO(NBGDCU,'L',JNBGD)
      CALL JEVEUO(CMPGCU,'L',JCMPG)
      CALL JEVEUO(COEFCU,'L',JCOEF)
C
C --- CALCUL DU NOMBRE TOTAL DE GRANDEURS A GAUCHE
C
      NBGAU = 0
      DO 20 IOCC = 1,NBOCC
        NBGAU  = NBGAU + ZI(JDIM+2*(IOCC-1)+4)*ZI(JDIM+2*(IOCC-1)+5)
  20  CONTINUE
C
C --- NOMBRE DE NOEUDS ET TYPE DES COMPOSANTES (REEL OU FONCTION)
C
      NBNOE  = ZI(JDIM+2)
      TYPCMP = ZI(JDIM+1)
C
C --- CREATION DES VECTEURS DEFINITIFS
C
      NOEUCU = CHAR(1:8)//'.UNILATE.LISNOE'
      CALL WKVECT(NOEUCU,'G V I',NBNOE,JNOEU)
C
C --- CREATION DES VECTEURS TEMPORAIRES
C
      CALL WKVECT('&&CREAUN.INDIR','V V I',NBNOE+1,JINDIR)
      CALL WKVECT('&&CREAUN.CMPG','V V K8',NBGAU,JCOMPG)
      IF (TYPCMP.EQ.1) THEN
        CALL WKVECT('&&CREAUN.COEFG','V V R',NBGAU,JCOEFG)
        CALL WKVECT('&&CREAUN.COEFD','V V R',NBNOE,JCOEFD)
      ELSE IF (TYPCMP.EQ.2) THEN
        CALL WKVECT('&&CREAUN.COEFG','V V K8',NBGAU,JCOEFG)
        CALL WKVECT('&&CREAUN.COEFD','V V K8',NBNOE,JCOEFD)
      ELSE
        CALL U2MESS('F','MODELISA3_39')
      ENDIF
      ZI(JINDIR) = 1
C
C ---
C
      CPTND  = 1
      CPTD   = 1
      CPTG   = 1
C
      DO 1000 IOCC = 1,NBOCC
C
        NBND   = ZI(JPOI+IOCC) - ZI(JPOI+IOCC-1)
        JDEBND = ZI(JPOI+IOCC-1)
        NBCP   = ZI(JNBGD+IOCC) - ZI(JNBGD+IOCC-1)
        JDEBCP = ZI(JNBGD+IOCC-1)
C
        DO 2000 INO = 1,NBND

          NUMND = ZI(JNOE-1+JDEBND+INO-1)
          NBSUP = 0

          DO 3000 ICMP = 1,NBCP

            CMP = ZK8(JCMPG-1+JDEBCP+ICMP-1)

            CALL EXISCP(CMP,CHAR,NOMO,
     &                  1,'NUM',K8BID,NUMND,
     &                  EXIST)

            IF (EXIST.EQ.1) THEN
              IF(NIV.GE.2) THEN
                CALL JENUNO(JEXNUM(NOEUMA,NUMND),NOMNO)
                VALK (1) = NOMNO
                VALK (2) = CMP
                CALL U2MESG('I', 'MODELISA8_58',2,VALK,0,0,0,0.D0)
              END IF

              ZK8(JCOMPG-1+CPTG) = CMP
              IF (TYPCMP.EQ.1) THEN
                ZR(JCOEFG-1+CPTG)  = ZR(JMULT-1+JDEBCP+ICMP-1)
              ELSE
                ZK8(JCOEFG-1+CPTG) = ZK8(JMULT-1+JDEBCP+ICMP-1)
              ENDIF
              CPTG  = CPTG  + 1
            ELSE
              NBSUP = NBSUP + 1
              CALL JENUNO(JEXNUM(NOEUMA,NUMND),NOMNO)
              VALK (1) = NOMNO
              VALK (2) = CMP
              CALL U2MESG('I', 'UNILATER_75',2,VALK,0,0,0,0.D0)
            ENDIF

 3000     CONTINUE

          ZI(JNOEU-1+CPTND)  = NUMND
          

          IF (TYPCMP.EQ.1) THEN
            ZR(JCOEFD-1+CPTD)  = ZR(JCOEF+IOCC-1)
          ELSE
            ZK8(JCOEFD-1+CPTD) = ZK8(JCOEF+IOCC-1)
          ENDIF

          ZI(JINDIR+CPTND) = ZI(JINDIR+CPTND-1) + NBCP - NBSUP

          CPTD  = CPTD  + 1
          CPTND = CPTND + 1

 2000   CONTINUE


 1000 CONTINUE

      CPTD  = CPTD  - 1
      CPTND = CPTND - 1
      CPTG  = CPTG  - 1 

      CALL ASSERT(CPTD.EQ.NBNOE)
      CALL ASSERT(CPTND.EQ.NBNOE)
C
C --- CREATIONS DES VECTEURS DEFINITIFS
C
C
C --- QUELQUES INFOS DIMENSIONS
C
      DIME   = CHAR(1:8)//'.UNILATE.DIMECU'
      CALL WKVECT(DIME,'G V I',3,JDIME)
      ZI(JDIME)   =  NBNOE
      ZI(JDIME+1) =  CPTG
      ZI(JDIME+2) =  TYPCMP
C
C --- LISTE DES POINTEURS VERS LE MEMBRE DE GAUCHE
C
      POICU  = CHAR(1:8)//'.UNILATE.POINOE'
      CALL WKVECT(POICU,'G V I',NBNOE+1,JPOIN)
      DO 4000 INO = 1,NBNOE+1
        ZI(JPOIN-1+INO) = ZI(JINDIR-1+INO)
 4000 CONTINUE
C
C --- LISTE DES NOMS DE COMPOSANTES A GAUCHE
C
      CMPCU = CHAR(1:8)//'.UNILATE.CMPGCU'
      CALL WKVECT(CMPCU,'G V K8',CPTG,JCPG)
      DO 4001 I = 1,CPTG
        ZK8(JCPG-1+I) = ZK8(JCOMPG-1+I)
 4001 CONTINUE
C
C --- LISTE DES COEFFICIENTS A DROITE ET A GAUCHE
C
      IF (TYPCMP.EQ.1) THEN
        CALL WKVECT(CHAR(1:8)//'.UNILATE.COEFG','G V R',CPTG,JCOEG)
        CALL WKVECT(CHAR(1:8)//'.UNILATE.COEFD','G V R',CPTD,JCOED)
      ELSE
        CALL WKVECT(CHAR(1:8)//'.UNILATE.COEFG','G V K8',CPTG,JCOEG)
        CALL WKVECT(CHAR(1:8)//'.UNILATE.COEFD','G V K8',CPTD,JCOED)
      ENDIF

      DO 4003 I = 1,CPTG
        IF (TYPCMP.EQ.1) THEN
          ZR(JCOEG-1+I)  = ZR(JCOEFG-1+I)
        ELSE
          ZK8(JCOEG-1+I) = ZK8(JCOEFG-1+I)
        ENDIF
 4003 CONTINUE

      DO 4004 I = 1,CPTD
        IF (TYPCMP.EQ.1) THEN
          ZR(JCOED-1+I)  = ZR(JCOEFD-1+I)
        ELSE
          ZK8(JCOED-1+I) = ZK8(JCOEFD-1+I)
        ENDIF
 4004 CONTINUE
C
C --- NETTOYAGE
C
      CALL JEDETR('&&CREAUN.INDIR')
      CALL JEDETR('&&CREAUN.CMPG')
      CALL JEDETR('&&CREAUN.COEFG')
      CALL JEDETR('&&CREAUN.COEFD')
C
C ======================================================================
      CALL JEDEMA()
C
      END
