      SUBROUTINE CESPRJ(CES1Z,CORREZ,BASEZ,CES2Z,IRET)
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
C RESPONSABLE VABHHTS J.PELLET
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*(*) CES1Z,CORREZ,BASEZ,CES2Z
      INTEGER IRET
C ------------------------------------------------------------------
C BUT : PROJETER UN CHAM_ELEM_S  SUR UN AUTRE MAILLAGE
C       SI CES1 EST ELEM : CES2 SERA ELEM
C       SI CES1 EST ELNO : CES2 SERA ELNO
C       LES CMPS PORTEES PAR CES2 SERONT CELLES PORTEES PAR TOUS LES
C       NOEUDS DES MAILLES CONTENANT LES NOEUDS DES MAILLES DE CES2
C ------------------------------------------------------------------
C     ARGUMENTS:
C CES1Z  IN/JXIN  K19 : CHAM_ELEM_S A PROJETER
C CORREZ IN/JXIN  K16 : NOM DE LA SD CORRESP_2_MAILLA
C BASEZ  IN       K1  : BASE DE CREATION POUR CES2Z : G/V/L
C CES2Z  IN/JXOUT K19 : CHAM_ELEM_S RESULTAT DE LA PROJECTION
C                       S'IL EXISTE DEJA, ON LE DETRUIT
C IRET   OUT      I   : CODE RETOUR :
C                       0 -> OK
C                       1 -> ECHEC DE LA PROJECTION
C ------------------------------------------------------------------
C  RESTRICTIONS :
C    ON NE TRAITE QUE LES CHAMPS 'ELEM' ET 'ELNO'
C    ON NE TRAITE QUE LES CHAMPS REELS (R8) OU COMPLEXES (C16)

C     ------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*1 KBID,BASE
      CHARACTER*3 TSCA
      CHARACTER*4 TYPCES
      CHARACTER*8 MA1,MA2,NOMGD
      CHARACTER*16 CORRES
      CHARACTER*19 CES1,CES2
      INTEGER JCE1C,JCE1L,JCE1V,JCE1K,JCE1D
      INTEGER JCE2C,JCE2L,JCE2V,JCE2D,IFM,NIV
      INTEGER NBNO1,IBID,JXXK1,IACONB,IACONU,IACOCF,GD,NBNO2
      INTEGER NCMPMX,IAD1,IAD2,IMA1,IMA2,JDECAL,NBMAM2,IACOM1
      INTEGER IDECAL,INO2,ICMP,ICO,INO1,NUNO2,IACNX2,ILCNX2
      REAL*8 V1,V2,COEF1
      COMPLEX*16 V1C,V2C
C     ------------------------------------------------------------------

      CALL JEMARQ()
      IRET = 0
      CES1 = CES1Z
      CES2 = CES2Z
      BASE = BASEZ
      CORRES = CORREZ
      CALL INFNIV(IFM,NIV)


C     1- ON TRANSFORME LE CHAM_ELEM_S INITIAL EN CHAM_ELEM_S/ELNO
C        (SI C'EST NECESSAIRE)
C     -------------------------------------------------------------
      CALL JEVEUO(CES1//'.CESK','L',JCE1K)
      TYPCES = ZK8(JCE1K-1+3)
      IF (TYPCES.EQ.'ELNO') THEN
        CES1 = CES1Z
        CES2 = CES2Z

      ELSEIF (TYPCES.EQ.'ELGA') THEN
C       -- ON NE PEUT PAS ENCORE TRAITER LES CHAMPS ELGA
        IRET = 1
        GOTO 80

      ELSEIF (TYPCES.EQ.'ELEM') THEN
        CES1 = '&&CESPRJ.CES1'
        CES2 = '&&CESPRJ.CES2'
        CALL CESCES(CES1Z,'ELNO',' ',' ',' ','V',CES1)

      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF


C     1- RECUPERATION D'INFORMATIONS DANS CES1 :
C     ------------------------------------------
      CALL JEVEUO(CES1//'.CESK','L',JCE1K)
      CALL JEVEUO(CES1//'.CESD','L',JCE1D)
      CALL JEVEUO(CES1//'.CESC','L',JCE1C)
      CALL JEVEUO(CES1//'.CESV','L',JCE1V)
      CALL JEVEUO(CES1//'.CESL','L',JCE1L)

      MA1 = ZK8(JCE1K-1+1)
      NOMGD = ZK8(JCE1K-1+2)
      NCMPMX = ZI(JCE1D-1+2)
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)


C------------------------------------------------------------------
C     2- RECUPERATION DES OBJETS ET INFORMATIONS DE CORRES :
C     ----------------------------------------------------
      CALL JEVEUO(CORRES//'.PJXX_K1','L',JXXK1)
      CALL JEVEUO(CORRES//'.PJEF_NB','L',IACONB)
      CALL JEVEUO(CORRES//'.PJEF_M1','L',IACOM1)
      CALL JEVEUO(CORRES//'.PJEF_NU','L',IACONU)
      CALL JEVEUO(CORRES//'.PJEF_CF','L',IACOCF)

      MA2 = ZK24(JXXK1-1+2)

C------------------------------------------------------------------
C     3- QUELQUES VERIFS :
C     ------------------------
      IF (ZI(JCE1D-1+4).GT.1) THEN
C       -- ON NE PEUT PAS TRAITER LES CHAMPS A SOUS-POINTS
        IRET = 1
        GOTO 80

      ENDIF

      IF (TSCA.NE.'R' .AND. TSCA.NE.'C') THEN
C       -- ON NE TRAITE POUR L'INSTANT QUE LES CHAMPS REELS
        IRET = 1
        GOTO 80

      ENDIF
C     TEST SUR IDENTITE DES 2 MAILLAGES
      CALL ASSERT(ZK24(JXXK1-1+1).EQ.MA1)

      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD),GD)
      IF (GD.EQ.0) CALL U2MESK('F','CALCULEL_67',1,NOMGD)


C------------------------------------------------------------------
C     4- ALLOCATION DE CES2 (ELNO):
C     -----------------------------
      CALL DETRSD('CHAM_ELEM_S',CES2)
      CALL CESCRE(BASE,CES2,'ELNO',MA2,NOMGD,NCMPMX,ZK8(JCE1C),IBID,-1,
     &            -NCMPMX)
      CALL JEVEUO(CES2//'.CESD','L',JCE2D)
      CALL JEVEUO(CES2//'.CESC','L',JCE2C)
      CALL JEVEUO(CES2//'.CESV','E',JCE2V)
      CALL JEVEUO(CES2//'.CESL','E',JCE2L)
      NBMAM2 = ZI(JCE2D-1+1)


C------------------------------------------------------------------
C     5- CALCUL DES VALEURS DE CES2 :
C     -------------------------------

C       -- IL FAUT FABRIQUER UN OBJET TEMPORAIRE POUR UTILISER CORRES
C          DANS UNE OPTIQUE "CHAM_ELEM" : UNE ESPECE DE POINTEUR DE
C          LONGUEUR CUMULEE SUR LES OBJETS .PJEF_NU ET .PJEF_CF
      CALL DISMOI('F','NB_NO_MAILLA',MA2,'MAILLAGE',NBNO2,KBID,IBID)
      CALL WKVECT('&&CESPRJ.IDECAL','V V I',NBNO2,JDECAL)
      IDECAL = 0

      DO 10,INO2 = 1,NBNO2
        NBNO1 = ZI(IACONB-1+INO2)
        ZI(JDECAL-1+INO2) = IDECAL
        IDECAL = IDECAL + NBNO1
   10 CONTINUE
      CALL JEVEUO(MA2//'.CONNEX','L',IACNX2)
      CALL JEVEUO(JEXATR(MA2//'.CONNEX','LONCUM'),'L',ILCNX2)


      DO 70,IMA2 = 1,NBMAM2
        NBNO2 = ZI(JCE2D-1+5+4* (IMA2-1)+1)
        DO 60,INO2 = 1,NBNO2
          NUNO2 = ZI(IACNX2+ZI(ILCNX2-1+IMA2)-2+INO2)
          NBNO1 = ZI(IACONB-1+NUNO2)
          IMA1 = ZI(IACOM1-1+NUNO2)
          IDECAL = ZI(JDECAL-1+NUNO2)
          DO 50 ICMP = 1,NCMPMX
C ================================================================
C --- ON NE PROJETTE UNE CMP QUE SI ELLE EST PORTEE
C     PAR TOUS LES NOEUDS DE LA MAILLE SOUS-JACENTE
C  EN PRINCIPE, C'EST TOUJOURS LE CAS POUR LES CHAM_ELEM
C ================================================================
            ICO = 0
            DO 20,INO1 = 1,NBNO1
              CALL CESEXI('C',JCE1D,JCE1L,IMA1,INO1,1,ICMP,IAD1)
              COEF1 = ZR(IACOCF+IDECAL-1+INO1)
              IF (IAD1.GT.0) ICO = ICO + 1
   20       CONTINUE
            IF (ICO.EQ.0) GOTO 50
            IF (ICO.LT.NBNO1) GOTO 50

            CALL CESEXI('S',JCE2D,JCE2L,IMA2,INO2,1,ICMP,IAD2)
            CALL ASSERT(IAD2.LT.0)
            ZL(JCE2L-1-IAD2) = .TRUE.

            IF (TSCA.EQ.'R') THEN
              V2 = 0.D0
              DO 30,INO1 = 1,NBNO1
                COEF1 = ZR(IACOCF+IDECAL-1+INO1)
                CALL CESEXI('C',JCE1D,JCE1L,IMA1,INO1,1,ICMP,IAD1)
                CALL ASSERT(IAD1.GT.0)
                V1 = ZR(JCE1V-1+IAD1)
                V2 = V2 + COEF1*V1
   30         CONTINUE
              ZR(JCE2V-1-IAD2) = V2

            ELSEIF (TSCA.EQ.'C') THEN
              V2C = DCMPLX(0.D0,0.D0)
              DO 40,INO1 = 1,NBNO1
                COEF1 = ZR(IACOCF+IDECAL-1+INO1)
                CALL CESEXI('C',JCE1D,JCE1L,IMA1,INO1,1,ICMP,IAD1)
                CALL ASSERT(IAD1.GT.0)
                V1C = ZC(JCE1V-1+IAD1)
                V2C = V2C + COEF1*V1C
   40         CONTINUE
              ZC(JCE2V-1-IAD2) = V2C
            ENDIF

   50     CONTINUE
   60   CONTINUE
   70 CONTINUE


C     -- VERIFICATION DE LA QUALITE DE CES2:
      IF (NIV.GT.1) CALL CESVER(CES2)


C     -- ON TRANSFORME LE CHAM_ELEM_S/ELNO EN ELEM SI NECESSAIRE:
      IF (TYPCES.EQ.'ELEM') THEN
        CALL CESCES(CES2,'ELEM',' ',' ',' ',BASE,CES2Z)
      ENDIF



C     -- MENAGE :
      IF (TYPCES.EQ.'ELEM') THEN
        CALL DETRSD('CHAM_ELEM_S',CES1)
        CALL DETRSD('CHAM_ELEM_S',CES2)
      ENDIF
      CALL JEDETR('&&CESPRJ.IDECAL')

   80 CONTINUE
      CALL JEDEMA()
      END
