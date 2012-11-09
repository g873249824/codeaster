      SUBROUTINE DEFCUR(VECR1,VECK1,NB,VECR2,NV,NOMMAI,NM,PROLGD,INTERP)
      IMPLICIT NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     LECTURE DE LA DEFINITION D'UNE FONCTION (ABSCISSE CURVILIGNE)
C     STOCKAGE DANS UN OBJET DE TYPE FONCTION
C ----------------------------------------------------------------------
C     IN  : VECR1  : VECTEUR DE LONG. NB, CONTIENT LES VALEURS DE LA
C                    FONCTION DEFINIE AUX NOEUDS.
C     IN  : VECK1  : VECTEUR DE LONG. NB, CONTIENT LES NOMS DES NOEUDS.
C     OUT : VECR2  : VECTEUR DE LONG. NV, CONTIENT LES VALEURS DE LA
C                    FONCTION.
C     IN  : MONMAI : NOM DU MAILLAGE.
C     IN  : NM     : NOMBRE DE MAILLES.
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      INTEGER      PTCH, PNOE
      REAL*8        VECR1(NB), VECR2(NV)
      CHARACTER*2  PROLGD
      CHARACTER*8  NOMMAI,K8BID,INTERP,VECK1(NB)
      CHARACTER*24 COOABS, NOMNOE, CONNEX, TYPMAI
      CHARACTER*8  TYPM
      CHARACTER*24 CONSEG, TYPSEG
C     ------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER I ,IACH ,IACNEX ,IAGM ,IAV1 ,IAV2 ,IEXI
      INTEGER II ,IM ,IMA1 ,IMA2 ,IND ,ING ,INO
      INTEGER ISEG2 ,ISENS ,ITYM ,ITYPM ,JGCNX ,JI ,JJ
      INTEGER JP ,KK ,KSEG ,LABS ,LNOE ,LVALI ,MI
      INTEGER NB ,NBCHM ,NBNOMA ,NBPOI1 ,NBRMA ,NBRMA1 ,NBRMA2
      INTEGER NBRSE1 ,NBRSE2 ,NBRSEG ,NBSEG2 ,NM ,NUMNO ,NV

C-----------------------------------------------------------------------
      CALL JEMARQ()
      NBRMA = NM
C
C     --- CONSTRUCTION DES OBJETS DU CONCEPT MAILLAGE ---
C
      NOMNOE = NOMMAI//'.NOMNOE'
      COOABS = NOMMAI//'.ABS_CURV  .VALE'
      CONNEX = NOMMAI//'.CONNEX'
      TYPMAI = NOMMAI//'.TYPMAIL'
C
C     --- VERIFICATION DE L EXISTENCE DE L ABSCISSE CURVILIGNE ---
C
      CALL JEEXIN (COOABS,IEXI)
        IF (IEXI .EQ. 0) THEN
          CALL U2MESS('F','UTILITAI_46')
        ENDIF
C     --- CREATION D OBJETS TEMPORAIRES ---
C
      CALL WKVECT('&&DEFOCU.TEMP      ','V V I',NBRMA,IAGM)
      DO 60 II=1,NBRMA
        ZI(IAGM+II-1) = II
  60  CONTINUE
        NBRMA2 = 2*NBRMA
        NBRMA1 = NBRMA + 1
      CALL WKVECT('&&DEFOCU.TEMP.VOIS1','V V I',NBRMA,IAV1)
      CALL WKVECT('&&DEFOCU.TEMP.VOIS2','V V I',NBRMA,IAV2)
      CALL WKVECT('&&DEFOCU.TEMP.CHM  ','V V I',NBRMA1,PTCH)
      CALL WKVECT('&&DEFOCU.TEMP.IACHM','V V I',NBRMA2,IACH)
      CALL WKVECT('&&DEFOCU.TEMP.LNOE' ,'V V I',NBRMA1,LNOE)
      CALL WKVECT('&&DEFOCU.TEMP.PNOE' ,'V V I',NV    ,PNOE)
      CALL WKVECT('&&DEFOCU.TEMP.IPOI1','V V I',NBRMA,IMA1)
      CALL WKVECT('&&DEFOCU.TEMP.ISEG2','V V I',NBRMA,IMA2)
C
C     TRI DES MAILLES POI1 ET SEG2
      NBSEG2=0
      NBPOI1=0
      KSEG=0
      DO 12 IM=1,NBRMA
        CALL JEVEUO (TYPMAI,'L',ITYPM)
        CALL JENUNO (JEXNUM('&CATA.TM.NOMTM',ZI(ITYPM+IM-1)),TYPM)
        IF      (TYPM .EQ. 'SEG2') THEN
           KSEG=ZI(ITYPM+IM-1)
           NBSEG2=NBSEG2+1
           ZI(IMA2+NBSEG2-1)=IM
        ELSE IF (TYPM .EQ. 'POI1') THEN
           NBPOI1=NBPOI1+1
           ZI(IMA1+NBPOI1-1)=IM
        ELSE
          CALL U2MESS('F','MODELISA_2')
        ENDIF
 12   CONTINUE
      CONSEG='&&DEFOCU.CONNEX'
      TYPSEG='&&DEFOCU.TYPMAI'
      CALL WKVECT(TYPSEG,'V V I',NBRMA,ITYM)
      DO 13 IM=1,NBRMA
        ZI(ITYM-1+IM)=KSEG
 13   CONTINUE
C     IL FAUT CREER UNE TABLE DE CONNECTIVITE POUR LES SEG2
C
      NBNOMA=2*NBSEG2
      NBRSEG=NBSEG2
      NBRSE1=NBSEG2+1
      NBRSE2=NBSEG2*2
      CALL JECREC(CONSEG,'V V I','NU','CONTIG','VARIABLE',NBSEG2)
      CALL JEECRA(CONSEG,'LONT',NBNOMA,' ')
      DO 14 ISEG2=1,NBSEG2
        IM=ZI(IMA2+ISEG2-1)
        CALL JELIRA(JEXNUM(CONNEX,IM   ),'LONMAX',NBNOMA,K8BID)
        CALL JEVEUO(JEXNUM(CONNEX,IM   ),'L',IACNEX)
        CALL JEECRA(JEXNUM(CONSEG,ISEG2),'LONMAX',NBNOMA,' ')
        CALL JEVEUO(JEXNUM(CONSEG,ISEG2),'E',JGCNX)
        DO 3 INO =1,NBNOMA
           NUMNO=ZI(IACNEX-1+INO)
           ZI(JGCNX+INO-1)=NUMNO
  3     CONTINUE
 14   CONTINUE

      CALL I2VOIS(CONSEG,TYPSEG,ZI(IAGM),NBRSEG,ZI(IAV1),ZI(IAV2))
      CALL I2TGRM(ZI(IAV1),ZI(IAV2),NBRSEG,ZI(IACH),ZI(PTCH),NBCHM)
      CALL I2SENS(ZI(IACH),NBRSE2,ZI(IAGM),NBRSEG,CONSEG,TYPSEG)
C
C     --- CREATION D UNE LISTE ORDONNEE DE NOEUDS ---
      DO 10 I = 1,NBRSEG
        ISENS = 1
        MI = ZI(IACH+I-1)
        IF (MI .LT. 0) THEN
          MI = -MI
          ISENS = -1
        ENDIF
        CALL I2EXTF(MI,1,CONSEG,TYPSEG,ING,IND)
        IF (ISENS .EQ. 1) THEN
          ZI(LNOE+I-1) = ING
          ZI(LNOE+I)   = IND
        ELSE
          ZI(LNOE+I)   = ING
          ZI(LNOE+I-1) = IND
        ENDIF
  10  CONTINUE
C
C
C     --- VERIFICATION DE LA DEFINITION DE LA FONCTION ---
C
      CALL VEFCUR(ZI(LNOE),NBRSE1,VECK1,ZI(PNOE),NB,NOMNOE)
C
C
      CALL JEVEUO(COOABS,'L',LABS)
      CALL WKVECT('&&DEFOCU.TEMP.VALE','V V R8',NV,LVALI)
C
      DO 30 I = 1,NBRSEG
        ZR(LVALI+2*(I-1)) = ZR(LABS+3*(I-1))
   30 CONTINUE
C
      ZR(LVALI+2*NBRSEG) = ZR(LABS+3*(NBRSEG-1)+1)
C
      DO 40 I = 1,NB
        KK = 2*(ZI(PNOE+I-1)-1)+1
        ZR(LVALI+KK) = VECR1(I)
   40 CONTINUE
C
      DO 80 I = 1,NB
        JP = ZI(PNOE+I-1)
        JI = I
        DO 70 JJ = I,NB
          IF (ZI(PNOE+JJ-1) .LT. JP) THEN
            JI = JJ
            JP = ZI(PNOE+JJ-1)
          ENDIF
   70   CONTINUE
        ZI(PNOE+JI-1) = ZI(PNOE+I-1)
        ZI(PNOE+I-1) = JP
   80 CONTINUE
C
C     ------------- INTERPOLATION DE LA FONCTION -------------
C     --- PROLONGEMENT DE LA FONCTION A GAUCHE ET A DROITE ---
C
      CALL PRFCUR(ZI(PNOE),NB,ZR(LVALI),NV,INTERP,PROLGD)
C
C     --- REMPLISSAGE DE L OBJET .VALE ---
C
      DO 50 I = 1,NBRSE1
        VECR2(I) = ZR(LVALI+2*(I-1))
        VECR2(NBRSE1+I) = ZR(LVALI+2*(I-1)+1)
  50  CONTINUE
C
C     --- MENAGE ---
      CALL JEDETR('&&DEFOCU.TEMP      ')
      CALL JEDETR('&&DEFOCU.TEMP.VOIS1')
      CALL JEDETR('&&DEFOCU.TEMP.VOIS2')
      CALL JEDETR('&&DEFOCU.TEMP.CHM  ')
      CALL JEDETR('&&DEFOCU.TEMP.IACHM')
      CALL JEDETR('&&DEFOCU.TEMP.LNOE')
      CALL JEDETR('&&DEFOCU.TEMP.PNOE')
      CALL JEDETR('&&DEFOCU.TEMP.IPOI1')
      CALL JEDETR('&&DEFOCU.TEMP.ISEG2')
      CALL JEDETR('&&DEFOCU.TEMP.VALE')
      CALL JEDETR('&&DEFOCU.CONNEX')
      CALL JEDETR('&&DEFOCU.TYPMAI')
C
      CALL JEDEMA()
      END
