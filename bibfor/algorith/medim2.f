      SUBROUTINE MEDIM2(MODELE,LISCHA,MEDIRI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
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
      IMPLICIT NONE
      CHARACTER*24 MODELE,MEDIRI
      CHARACTER*19 LISCHA
C ----------------------------------------------------------------------
C     CALCUL DES MATRICES ELEMENTAIRES DES ELEMENTS DE LAGRANGE
C DUPLICATION DE MEDIME POUR OP0175 (POST_ZAC)
C A RESORBER DQP
C IN  MODELE  : NOM DU MODELE
C IN  LISCHA  : SD L_CHARGES
C OUT MEDIRI  : MATRICES ELEMENTAIRES

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
      CHARACTER*8 NOMCHA,LPAIN(1),LPAOUT(1),K8BID
      CHARACTER*16 OPTION
      CHARACTER*19 MATEL
      CHARACTER*24 LIGRMO,LIGRCH,LCHIN(1),LCHOUT(1)
      INTEGER IRET,NCHAR,ILIRES,JMED,JCHAR,JINF,ICHA

      CALL JEMARQ()
      CALL JEEXIN(LISCHA//'.LCHA',IRET)
      IF (IRET.EQ.0) GO TO 20
      CALL JELIRA(LISCHA//'.LCHA','LONMAX',NCHAR,K8BID)
      CALL JEVEUO(LISCHA//'.LCHA','L',JCHAR)

      CALL JEEXIN(MEDIRI,IRET)
      IF (IRET.EQ.0) THEN
        MATEL = '&&MEMDIR           '
        MEDIRI = MATEL//'.RELR'
        CALL MEMARE('V',MATEL,MODELE(1:8),' ',' ','RIGI_MECA')
        CALL WKVECT(MEDIRI,'V V K24',NCHAR,JMED)
      ELSE
        CALL JEVEUO(MEDIRI,'E',JMED)
      END IF

      LPAOUT(1) = 'PMATUUR'
      LCHOUT(1) = MEDIRI(1:8)//'.ME001'

      IF (ZK24(JCHAR).NE.'        ') THEN
        ILIRES = 0
        CALL JEVEUO(LISCHA//'.INFC','L',JINF)
        DO 10 ICHA = 1,NCHAR
          IF (ZI(JINF+ICHA).NE.0) THEN
            NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
            LIGRCH = NOMCHA//'.CHME.LIGRE'

            CALL JEEXIN(NOMCHA//'.CHME.LIGRE.LIEL',IRET)
            IF (IRET.LE.0) GO TO 10
            LCHIN(1) = NOMCHA//'.CHME.CMULT'
            CALL EXISD('CHAMP_GD',NOMCHA//'.CHME.CMULT',IRET)
            IF (IRET.LE.0) GO TO 10

            LPAIN(1) = 'PDDLMUR'
            CALL CODENT(ILIRES+1,'D0',LCHOUT(1) (12:14))
            OPTION = 'MECA_DDLM_R'
            CALL CALCUL('S',OPTION,LIGRCH,1,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &                  'V')
            ZK24(JMED+ILIRES) = LCHOUT(1)
            ILIRES = ILIRES + 1
          END IF
   10   CONTINUE
        CALL JEECRA(MEDIRI,'LONUTI',ILIRES,K8BID)
      END IF
   20 CONTINUE
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
