      SUBROUTINE PJ2DTR(CORTR3,CORRES,NUTM2D,ELRF2D)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 CORRES,CORTR3
      CHARACTER*8 ELRF2D(5),NOTM
      INTEGER NUTM2D(5)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/11/2004   AUTEUR VABHHTS J.PELLET 
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
C     BUT :
C       TRANSFORMER CORTR3 EN CORRES EN UTILISANT LES FONC. DE FORME
C       DES MAILLES DU MAILLAGE1 (EN 2D ISOPARAMETRIQUE)

C
C  IN/JXIN   CORTR3   K16 : NOM DU CORRESP_2_MAILLA FAIT AVEC LES TRIA3
C  IN/JXOUT  CORRES   K16 : NOM DU CORRESP_2_MAILLA FINAL
C  IN        NUTM2D(5) I  : NUMEROS DES 5 TYPES DE MAILLES 2D
C  IN        ELRF2D(5) K8 : NOMS DES 5 TYPES DE MAILLES 2D
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      CHARACTER*8  M1, M2, KB, ELREFA, FAPG(10)
      INTEGER      NBPG(10), CNQUAD(3,2)
      REAL*8       CRREFE(81), KSI, ETA, X(2), FF(27)
C --- DEB --------------------------------------------------------------

      CALL JEMARQ()

C     0. DECOUPAGE DES QUADRANGLES EN 2 TRIANGLES (VOIR PJ2DCO)
C     ----------------------------------------------------------

      CNQUAD(1,1)=1
      CNQUAD(2,1)=2
      CNQUAD(3,1)=3

      CNQUAD(1,2)=1
      CNQUAD(2,2)=3
      CNQUAD(3,2)=4

C     1. RECUPERATION DES INFORMATIONS GENERALES :
C     -----------------------------------------------
      CALL JEVEUO(CORTR3//'.PJEF_NO','L',I1CONO)
      CALL JEVEUO(CORTR3//'.PJEF_NB','L',I1CONB)
      CALL JEVEUO(CORTR3//'.PJEF_NU','L',I1CONU)
      CALL JEVEUO(CORTR3//'.PJEF_CF','L',I1COCF)
      CALL JEVEUO(CORTR3//'.PJEF_TR','L',I1COTR)

      M1=ZK8(I1CONO-1+1)
      M2=ZK8(I1CONO-1+2)
      CALL DISMOI('F','NB_NO_MAILLA', M1,'MAILLAGE',NNO1,KB,IE)
      CALL DISMOI('F','NB_NO_MAILLA', M2,'MAILLAGE',NNO2,KB,IE)
      CALL DISMOI('F','NB_MA_MAILLA', M1,'MAILLAGE',NMA1,KB,IE)
      CALL DISMOI('F','NB_MA_MAILLA', M2,'MAILLAGE',NMA2,KB,IE)

      CALL JEVEUO('&&PJXXCO.LIMA1','L',IALIM1)
      CALL JEVEUO('&&PJXXCO.LINO1','L',IALIN1)
      CALL JEVEUO('&&PJXXCO.LINO2','L',IALIN2)
      CALL JEVEUO('&&PJXXCO.TRIA3','L',IATR3)

      CALL JEVEUO(M1//'.CONNEX','L',IACNX1)
      CALL JEVEUO(JEXATR(M1//'.CONNEX','LONCUM'),'L',ILCNX1)
      CALL JEVEUO(M1//'.TYPMAIL','L',IATYMA)


C     2. ALLOCATION DE CORRES :
C     -----------------------------------------------
      CALL WKVECT(CORRES//'.PJEF_NO','V V K8',2,I2CONO)
      ZK8(I2CONO-1+1)=M1
      ZK8(I2CONO-1+2)=M2


C     2.1 REMPLISSAGE DE .PJEF_NB ET .PJEF_M1:
C     -----------------------------
      CALL WKVECT(CORRES//'.PJEF_NB','V V I',NNO2,I2CONB)
      CALL WKVECT(CORRES//'.PJEF_M1','V V I',NNO2,I2COM1)
      IDECA2=0
      DO 10, INO2=1,NNO2
C       ITR : TRIA3 ASSOCIE A INO2
        ITR=ZI(I1COTR-1+INO2)
        IF (ITR.EQ.0) GO TO 10
C       IMA1 : MAILLE DE M1 ASSOCIE AU TRIA3 ITR
        IMA1=ZI(IATR3+4*(ITR-1)+4)
        NBNO=ZI(ILCNX1+IMA1)-ZI(ILCNX1-1+IMA1)
        ZI(I2CONB-1+INO2)=NBNO
        ZI(I2COM1-1+INO2)=IMA1
        IDECA2=IDECA2+NBNO
10    CONTINUE


C     2.2 ALLOCATION DE .PJEF_NU ET .PJEF_CF:
C         (ET REMPLISSAGE DE CES 2 OBJETS)
C     ------------------------------------------------------
      CALL WKVECT(CORRES//'.PJEF_NU','V V I',IDECA2,I2CONU)
      CALL WKVECT(CORRES//'.PJEF_CF','V V R',IDECA2,I2COCF)
      IDECA1=0
      IDECA2=0
      DO 20, INO2=1,NNO2
C       ITR : TRIA3 ASSOCIE A INO2
        ITR = ZI(I1COTR-1+INO2)
        IF (ITR.EQ.0) GO TO 20
C       IMA1 : MAILLE DE M1 ASSOCIE AU TRIA3 ITR
        IMA 1= ZI(IATR3+4*(ITR-1)+4)
C       ITYPM : TYPE DE LA MAILLE IMA1
        ITYPM = ZI(IATYMA-1+IMA1)
        NUTM   = INDIIS(NUTM2D,ITYPM,1,5)
        ELREFA = ELRF2D(NUTM)
        NBNO   = ZI(ILCNX1+IMA1)-ZI(ILCNX1-1+IMA1)

        CALL ELRACA(ELREFA,NDIM,NNO,NNOS,NBFPG,FAPG,NBPG,CRREFE,VOL)

        IF ( NBNO .NE. NNO ) CALL UTMESS('F','PJ2DTR','BUG')

C       2.2.1 DETERMINATION DES COORDONEES DE INO2 DANS L'ELEMENT
C             DE REFERENCE : KSI , ETA
C     -----------------------------------------------------------
        KSI=0.D0
        ETA=0.D0
C       -- NUMERO DU 2EME NOEUD DE IMA1 : NUNO2
        NUNO2=ZI(IACNX1+ ZI(ILCNX1-1+IMA1)-2+2)
C       SI NUNO2 EST IDENTIQUE AU 2EME NOEUD DU TRIA3
C       C'EST QUE LE TRIA3 EST EN "DESSOUS" :

        IF (ELREFA.EQ.'TR3' .OR. ELREFA.EQ.'TR6') THEN

          DO 771,KK=1,3
            X1 = CRREFE(NDIM*(KK-1)+1)
            X2 = CRREFE(NDIM*(KK-1)+2)
            KSI = KSI + ZR(I1COCF-1+IDECA1+KK)*X1
            ETA = ETA + ZR(I1COCF-1+IDECA1+KK)*X2
771       CONTINUE

        ELSE IF (ELREFA.EQ.'QU4' .OR. ELREFA.EQ.'QU8' .OR.
     +                                ELREFA.EQ.'QU9' ) THEN
          IF (NUNO2.EQ.ZI(IATR3+4*(ITR-1)+2)) THEN
C         -- SI 1ER TRIANGLE :
            DO 772,KK=1,3
              X1 = CRREFE(NDIM*(CNQUAD(KK,1)-1)+1)
              X2 = CRREFE(NDIM*(CNQUAD(KK,1)-1)+2)
              KSI = KSI + ZR(I1COCF-1+IDECA1+KK)*X1
              ETA = ETA + ZR(I1COCF-1+IDECA1+KK)*X2
772         CONTINUE
          ELSE
C         -- SI 2EME TRIANGLE :
            DO 773,KK=1,3
              X1 = CRREFE(NDIM*(CNQUAD(KK,2)-1)+1)
              X2 = CRREFE(NDIM*(CNQUAD(KK,2)-1)+2)
              KSI = KSI + ZR(I1COCF-1+IDECA1+KK)*X1
              ETA = ETA + ZR(I1COCF-1+IDECA1+KK)*X2
773         CONTINUE
          END IF

        ELSE
           CALL UTMESS('F','PJ2DTR','ELREFA INCONNU: '//ELREFA)
        END IF

        X(1) = KSI
        X(2) = ETA

        CALL ELRFVF ( ELREFA, X, 27, FF, NNO )

C       2.2.2 :
C       CALCUL DES F. DE FORME AUX NOEUDS POUR LE POINT KSI,ETA
C       -------------------------------------------------------
        DO 22,INO=1,NBNO
          NUNO = ZI(IACNX1+ ZI(ILCNX1-1+IMA1)-2+INO)
          ZI(I2CONU-1+IDECA2+INO) = NUNO
          ZR(I2COCF-1+IDECA2+INO) = FF(INO)
22      CONTINUE

        IDECA1=IDECA1+3
        IDECA2=IDECA2+NBNO

20    CONTINUE

9999  CONTINUE
      CALL JEDEMA()
      END
