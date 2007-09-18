      SUBROUTINE CNSPRJ(CNS1Z,CORREZ,BASEZ,CNS2Z,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 18/09/2007   AUTEUR DURAND C.DURAND 
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
C RESPONSABLE VABHHTS J.PELLET
C A_UTIL
      IMPLICIT NONE
      CHARACTER*(*) CNS1Z,CORREZ,BASEZ,CNS2Z
      INTEGER IRET
C ------------------------------------------------------------------
C BUT : PROJETER UN CHAM_NO_S  SUR UN AUTRE MAILLAGE
C ------------------------------------------------------------------
C     ARGUMENTS:
C CNS1Z  IN/JXIN  K19 : CHAM_NO_S A PROJETER
C CORREZ IN/JXIN  K16 : NOM DE LA SD CORRESP_2_MAILLA
C BASEZ  IN       K1  : BASE DE CREATION POUR CNS2Z : G/V/L
C CNS2Z  IN/JXOUT K19 : CHAM_NO_S RESULTAT DE LA PROJECTION
C ------------------------------------------------------------------
C    ON NE TRAITE QUE LES CHAMPS REELS (R8) OU COMPLEXES (C16)
C
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
C     ------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*1 KBID,BASE
      CHARACTER*3 TSCA
      CHARACTER*8 MA1,MA2,NOMGD
      CHARACTER*16 CORRES
      CHARACTER*19 CNS1,CNS2
      INTEGER JCNS1C,JCNS1L,JCNS1V,JCNS1K,JCNS1D
      INTEGER JCNS2C,JCNS2L,JCNS2V,JCNS2K,JCNS2D
      INTEGER NBNO1,NCMP,IBID,IACONO,IACONB,IACONU,IACOCF,GD,NBNO2
      INTEGER IDECAL,INO2,ICMP,ICO,INO1,NUNO1
      REAL*8 V1,V2,COEF1
      COMPLEX*16 V1C,V2C
C     ------------------------------------------------------------------

      CALL JEMARQ()
      CNS1 = CNS1Z
      CNS2 = CNS2Z
      BASE = BASEZ
      CORRES=CORREZ
      IRET=0


C------------------------------------------------------------------
C     1- RECUPERATION DES OBJETS ET INFORMATIONS DE CNS1 :
C     ----------------------------------------------------

      CALL JEVEUO(CNS1//'.CNSK','L',JCNS1K)
      CALL JEVEUO(CNS1//'.CNSD','L',JCNS1D)
      CALL JEVEUO(CNS1//'.CNSC','L',JCNS1C)
      CALL JEVEUO(CNS1//'.CNSV','L',JCNS1V)
      CALL JEVEUO(CNS1//'.CNSL','L',JCNS1L)

      MA1 = ZK8(JCNS1K-1+1)
      NOMGD = ZK8(JCNS1K-1+2)
      NBNO1 = ZI(JCNS1D-1+1)
      NCMP  = ZI(JCNS1D-1+2)

      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)


C------------------------------------------------------------------
C     2- RECUPERATION DES OBJETS ET INFORMATIONS DE CORRES :
C     ----------------------------------------------------
      CALL JEVEUO(CORRES//'.PJEF_NO','L',IACONO)
      CALL JEVEUO(CORRES//'.PJEF_NB','L',IACONB)
      CALL JEVEUO(CORRES//'.PJEF_NU','L',IACONU)
      CALL JEVEUO(CORRES//'.PJEF_CF','L',IACOCF)

      MA2=ZK8(IACONO-1+2)


C------------------------------------------------------------------
C     3- QUELQUES VERIFS :
C     ------------------------
      IF (TSCA.NE.'R'.AND.TSCA.NE.'C') THEN
C        -- ON NE TRAITE QUE LES CHAMPS R/C :
         IRET=0
         GO TO 9999
      END IF
C     TEST SUR IDENTITE DES 2 MAILLAGES
      CALL ASSERT(ZK8(IACONO-1+1).EQ.MA1)

      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD),GD)
      IF (GD.EQ.0) CALL U2MESK('F','CALCULEL_67',1,NOMGD)


C------------------------------------------------------------------
C     4- ALLOCATION DE CNS2 :
C     ------------------------
      CALL DETRSD('CHAM_NO_S',CNS2)
      CALL CNSCRE(MA2,NOMGD,NCMP,ZK8(JCNS1C),BASE,CNS2)
      CALL JEVEUO(CNS2//'.CNSK','L',JCNS2K)
      CALL JEVEUO(CNS2//'.CNSD','L',JCNS2D)
      CALL JEVEUO(CNS2//'.CNSC','L',JCNS2C)
      CALL JEVEUO(CNS2//'.CNSV','E',JCNS2V)
      CALL JEVEUO(CNS2//'.CNSL','E',JCNS2L)

      NBNO2 = ZI(JCNS2D-1+1)

C------------------------------------------------------------------
C     5- CALCUL DES VALEURS DE CNS2 :
C     -------------------------------
      IDECAL=0
      DO 1,INO2=1,NBNO2
        NBNO1=ZI(IACONB-1+INO2)
        IF (NBNO1 .EQ. 0) GOTO 1
        DO 3,ICMP=1,NCMP
C ================================================================
C --  UNE CMP SERA PRESENTE SUR UN NOEUD (N2) SI :
C --  1) ELLE EST PRESENTE SUR TOUS LES NOEUDS DE LA MAILLE SOUS-JACENTE
C --  2) OU SI ELLE EST PRESENTE SUR UN NOEUD DE LA MAILE SOUS-JACENTE
C --     ET QUE CE NOEUD EST "PILE POIL" CONFONDU AVEC N2
C --     CE CAS DE FIGURE PERMET DE PROJETER LES COMPOSANTES PORTEES
C --     SEULEMENT PAR LES NOEUDS SOMMETS (MODELISATIONS THM PAR EX.)
C --     ON PROJETTE LA SD RESULTAT SUR UN MAILLAGE LINEAIRE
C ================================================================
           ICO=0
           DO 4,INO1=1,NBNO1
              NUNO1=ZI(IACONU+IDECAL-1+INO1)
              COEF1=ZR(IACOCF+IDECAL-1+INO1)
              IF (ZL(JCNS1L-1+ (NUNO1-1)*NCMP+ICMP)) THEN
                 ICO=ICO+1
              ELSE
                 IF (COEF1.LT.1.0D-6) THEN
                    ICO = ICO + 1
                 ENDIF
              ENDIF
 4         CONTINUE
           IF (ICO.LT.NBNO1) GO TO 3

           IF (TSCA.EQ.'R') THEN
              V2=0.D0
              DO 2,INO1=1,NBNO1
                NUNO1=ZI(IACONU+IDECAL-1+INO1)
                COEF1=ZR(IACOCF+IDECAL-1+INO1)
                IF (ZL(JCNS1L-1+ (NUNO1-1)*NCMP+ICMP)) THEN
                   V1=ZR(JCNS1V-1+ (NUNO1-1)*NCMP+ICMP)
                ELSE
                   IF (COEF1.LT.1.0D-6) THEN
                      V1 = 0.0D0
                   ENDIF
                ENDIF
                V2=V2+COEF1*V1
 2            CONTINUE
              ZL(JCNS2L-1+ (INO2-1)*NCMP+ICMP)=.TRUE.
              ZR(JCNS2V-1+ (INO2-1)*NCMP+ICMP)=V2
           ELSE IF (TSCA.EQ.'C') THEN
              V2C=DCMPLX(0.D0,0.D0)
              DO 21,INO1=1,NBNO1
                NUNO1=ZI(IACONU+IDECAL-1+INO1)
                COEF1=ZR(IACOCF+IDECAL-1+INO1)
                IF (ZL(JCNS1L-1+ (NUNO1-1)*NCMP+ICMP)) THEN
                   V1C=ZC(JCNS1V-1+ (NUNO1-1)*NCMP+ICMP)
                ELSE
                   IF (COEF1.LT.1.0D-6) THEN
                      V1C = 0.0D0
                   ENDIF
                ENDIF
                V2C=V2C+COEF1*V1C
 21           CONTINUE
              ZL(JCNS2L-1+ (INO2-1)*NCMP+ICMP)=.TRUE.
              ZC(JCNS2V-1+ (INO2-1)*NCMP+ICMP)=V2C
           END IF
 3      CONTINUE
        IDECAL=IDECAL+NBNO1
 1    CONTINUE

 9999 CONTINUE
      CALL JEDEMA()
      END
