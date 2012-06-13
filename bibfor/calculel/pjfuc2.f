      SUBROUTINE PJFUC2(C1,C2,BASE,C3)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE GREFFET N.GREFFET
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 C1,C2,C3
      CHARACTER*1 BASE
C ======================================================================
C     BUT : VARIANTE DE PJFUCO POUR LE COUPLAGE IFS VIA YACS
C       FUSIONNER 2 SD CORRESP_2_MAILLA C1 ET C2 POUR FABRIQUER C3

C  IN/JXIN   C1  : SD CORRESP_2_MAILLA
C  IN/JXIN   C2  : SD CORRESP_2_MAILLA
C  IN/JXOUT  C3  : SD CORRESP_2_MAILLA RESULTAT DE LA FUSION
C  IN        BASE: NOM DE LA BASE POUR CREER C3

C----------------------------------------------------------------------


      INTEGER     II, INO, ILENGT, IDECA1, IDECA2
      INTEGER     JNO1,NBNO1,JNB1,JM11,JCF1,JNU1
      INTEGER     JNO2,NBNO2,JNB2,JM12,JCF2,JNU2
      INTEGER                JNB3,JM13,JCF3,JNU3
      CHARACTER*8 MA1,MA2,KBID
      CHARACTER*24 VALK(2)

C DEB ------------------------------------------------------------------
      CALL JEMARQ()


C     1- OBJET '.PJEF_NO' :
C     ----------------------
C 
C PJEF_NO : DEVIENT PJXX_K1 DEPUIS 10.1.9
C      CALL JEVEUO(C1//'.PJEF_NO','L',JNO1)
C      CALL JEVEUO(C2//'.PJEF_NO','L',JNO2)
      CALL JEVEUO(C1//'.PJXX_K1','L',JNO1)
      CALL JEVEUO(C2//'.PJXX_K1','L',JNO2)
      DO 10 II = 1,2
        MA1 = ZK24(JNO1-1+II)(1:8)
        MA2 = ZK24(JNO2-1+II)(1:8)
        IF (MA1.NE.MA2) THEN
           VALK(1) = MA1
           VALK(2) = MA2
           CALL U2MESK('F','CALCULEL4_65', 2 ,VALK)
        ENDIF
 10   CONTINUE
      CALL JEDUPO(C1//'.PJXX_K1',BASE,C3//'.PJXX_K1',.FALSE.)

C     2- RECUPERATION DES POINTEURS
C     -----------------------------
      CALL JELIRA(C1//'.PJEF_NB','LONMAX',NBNO1,KBID)
      CALL JELIRA(C2//'.PJEF_NB','LONMAX',NBNO2,KBID)
      CALL JEVEUO(C1//'.PJEF_NB','L',JNB1)
      CALL JEVEUO(C2//'.PJEF_NB','L',JNB2)
      CALL JEVEUO(C1//'.PJEF_M1','L',JM11)
      CALL JEVEUO(C2//'.PJEF_M1','L',JM12)
      CALL JEVEUO(C1//'.PJEF_CF','L',JCF1)
      CALL JEVEUO(C2//'.PJEF_CF','L',JCF2)
      CALL JEVEUO(C1//'.PJEF_NU','L',JNU1)
      CALL JEVEUO(C2//'.PJEF_NU','L',JNU2)

C     3- AFFECTATION DE PJEF_NB ET PJEF_M1
C     ------------------------------------
      CALL WKVECT(C3//'.PJEF_NB',BASE//' V I',NBNO1+NBNO2,JNB3)
      CALL WKVECT(C3//'.PJEF_M1',BASE//' V I',NBNO1+NBNO2,JM13)
      
      ILENGT = 0
      DO 20 INO = 1, NBNO1
        ZI(JNB3-1+INO) = ZI(JNB1-1+INO)
        ZI(JM13-1+INO) = ZI(JM11-1+INO)
        ILENGT = ILENGT + ZI(JNB1-1+INO)
 20   CONTINUE
      DO 30 INO = 1, NBNO2
        ZI(JNB3-1+NBNO1+INO) = ZI(JNB2-1+INO)
        ZI(JM13-1+NBNO1+INO) = ZI(JM12-1+INO)
        ILENGT = ILENGT + ZI(JNB2-1+INO)
 30   CONTINUE

C     4 - AFFECTATION DE PJEF_CF ET PJEF_NU
C     -------------------------------------
      CALL WKVECT(C3//'.PJEF_CF',BASE//' V R',ILENGT,JCF3)
      CALL WKVECT(C3//'.PJEF_NU',BASE//' V I',ILENGT,JNU3)

      IDECA1 = 0
      DO 40 INO = 1, NBNO1
        DO 50 II = 1, ZI(JNB1-1+INO)
          ZR(JCF3-1+IDECA1+II) = ZR(JCF1-1+IDECA1+II)
          ZI(JNU3-1+IDECA1+II) = ZI(JNU1-1+IDECA1+II)
 50     CONTINUE
        IDECA1 = IDECA1 + ZI(JNB1-1+INO)
 40   CONTINUE
      IDECA2 = 0
      DO 60 INO = 1, NBNO2
        DO 70 II = 1, ZI(JNB2-1+INO)
          ZR(JCF3-1+IDECA1+II) = ZR(JCF2-1+IDECA2+II)
          ZI(JNU3-1+IDECA1+II) = ZI(JNU2-1+IDECA2+II)
 70     CONTINUE
        IDECA1 = IDECA1 + ZI(JNB2-1+INO)
        IDECA2 = IDECA2 + ZI(JNB2-1+INO)
 60   CONTINUE

C     5 - LIBERATION DE LA MEMOIRE
C     ----------------------------
      CALL JEDEMA()

C FIN ------------------------------------------------------------------
      END
