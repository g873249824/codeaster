      SUBROUTINE PJFUCO(C1,C2,BASE,C3)
      IMPLICIT NONE
      CHARACTER*16 C1,C2,C3
      CHARACTER*1 BASE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C       FUSIONNER 2 SD CORRESP_2_MAILLA C1 ET C2 POUR FABRIQUER C3

C  IN/JXIN   C1  : SD CORRESP_2_MAILLA
C  IN/JXIN   C2  : SD CORRESP_2_MAILLA
C  IN/JXOUT  C3  : SD CORRESP_2_MAILLA RESULTAT DE LA FUSION
C  IN        BASE: NOM DE LA BASE POUR CREER C3

C  REMARQUE :  C2 "SURCHARGE" C1 :
C     SI UN NOEUD INO2 APPARTIENT A C1 ET C2,
C     IL AURA DANS C3 LA MEME DESCRIPTION QUE DANS C2
C----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

      CHARACTER*8 MA1,MA2,KBID
      INTEGER I1,I2,I3,J1,J2,J3,K
      INTEGER INO2,IATMP1,DECA1,DECA2,DECA3,NBNO,LONT,NBNO2
      INTEGER I1NB,I2NB,I3NB,I1NU,I2NU,I3NU,I1CF,I2CF,I3CF,I1OU2



C DEB ------------------------------------------------------------------
      CALL JEMARQ()


C     1- OBJET '.PJEF_NO' :
C     ----------------------
      CALL JEVEUO(C1//'.PJEF_NO','L',I1)
      CALL JEVEUO(C2//'.PJEF_NO','L',I2)
      DO 10,K = 1,2
        MA1 = ZK8(I1-1+K)
        MA2 = ZK8(I2-1+K)
        IF (MA1.NE.MA2) CALL UTMESS('F','PJFUCO',
     &                              ' MAILLAGES NON IDENTIQUES : '//
     &                              MA1//' ET '//MA2)
C        CALL U2MESK('F','CALCULEL4_65', 2 ,VALK)
   10 CONTINUE
      CALL JEDUPO(C1//'.PJEF_NO',BASE,C3//'.PJEF_NO',.FALSE.)


C     2- OBJETS  .PJEF_NB et .PJEF_M1 :
C     ---------------------------------
      CALL JELIRA(C1//'.PJEF_NB','LONMAX',NBNO2,KBID)
      CALL JEVEUO(C1//'.PJEF_NB','L',I1)
      CALL JEVEUO(C2//'.PJEF_NB','L',I2)
      CALL JEVEUO(C1//'.PJEF_M1','L',J1)
      CALL JEVEUO(C2//'.PJEF_M1','L',J2)
      CALL WKVECT(C3//'.PJEF_NB',BASE//' V I',NBNO2,I3)
      CALL WKVECT(C3//'.PJEF_M1',BASE//' V I',NBNO2,J3)

C     2.1 CREATION D'UN OBJET DE TRAVAIL '&&PJFUCO.TMP1'
C        QUI DIRA DANS QUEL CORRESP_2_MAILLA A ETE PRIS LE NOEUD INO2
C     ----------------------------------------------------------------
      CALL WKVECT('&&PJFUCO.TMP1','V V I',NBNO2,IATMP1)

      DO 20,INO2 = 1,NBNO2
        IF (ZI(I1-1+INO2).NE.0) THEN
          ZI(IATMP1-1+INO2) = 1
          ZI(I3-1+INO2) = ZI(I1-1+INO2)
          ZI(J3-1+INO2) = ZI(J1-1+INO2)
        END IF
        IF (ZI(I2-1+INO2).NE.0) THEN
          ZI(IATMP1-1+INO2) = 2
          ZI(I3-1+INO2) = ZI(I2-1+INO2)
          ZI(J3-1+INO2) = ZI(J2-1+INO2)
        END IF
   20 CONTINUE


C     -- OBJETS '.PJEF_NU' ET '.PJEF_CF' :
C     -------------------------------------
      CALL JEVEUO(C1//'.PJEF_NB','L',I1NB)
      CALL JEVEUO(C2//'.PJEF_NB','L',I2NB)
      CALL JEVEUO(C3//'.PJEF_NB','L',I3NB)
      CALL JEVEUO(C1//'.PJEF_NU','L',I1NU)
      CALL JEVEUO(C2//'.PJEF_NU','L',I2NU)
      CALL JEVEUO(C1//'.PJEF_CF','L',I1CF)
      CALL JEVEUO(C2//'.PJEF_CF','L',I2CF)
      LONT = 0
      DO 30,K = 1,NBNO2
        LONT = LONT + ZI(I3NB-1+K)
   30 CONTINUE
      CALL WKVECT(C3//'.PJEF_NU',BASE//' V I',LONT,I3NU)
      CALL WKVECT(C3//'.PJEF_CF',BASE//' V R',LONT,I3CF)

      DECA1 = 0
      DECA2 = 0
      DECA3 = 0
      DO 60,INO2 = 1,NBNO2
        I1OU2 = ZI(IATMP1-1+INO2)
        IF (I1OU2.EQ.1) THEN
          NBNO = ZI(I3NB-1+INO2)
          DO 40,K = 1,NBNO
            ZI(I3NU-1+DECA3+K) = ZI(I1NU-1+DECA1+K)
            ZR(I3CF-1+DECA3+K) = ZR(I1CF-1+DECA1+K)
   40     CONTINUE
        ELSE IF (I1OU2.EQ.2) THEN
          NBNO = ZI(I3NB-1+INO2)
          DO 50,K = 1,NBNO
            ZI(I3NU-1+DECA3+K) = ZI(I2NU-1+DECA2+K)
            ZR(I3CF-1+DECA3+K) = ZR(I2CF-1+DECA2+K)
   50     CONTINUE
        END IF
        DECA1 = DECA1 + ZI(I1NB-1+INO2)
        DECA2 = DECA2 + ZI(I2NB-1+INO2)
        DECA3 = DECA3 + ZI(I3NB-1+INO2)
   60 CONTINUE



      CALL JEDETR('&&PJFUCO.TMP1')
      CALL JEDEMA()
      END
