      SUBROUTINE GILIO2(NFIC,IOBJ,NBELE,NIV)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 23/10/2006   AUTEUR MCOURTOI M.COURTOIS 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     ARGUMENTS:
C     ----------
      INTEGER NFIC,IOBJ,NBELE,NIV
C ----------------------------------------------------------------------
C     BUT: LIRE LES N LIGNES REPRESENTANT UN OBJET (AU SENS GIBI).
C                  (PROCEDURE SAUVER)
C
C     IN: NFIC : UNITE DE LECTURE.
C         IOBJ : NUMERO DE L'OBJET QUE L'ON VA LIRE.
C         NIV  : NIVEAU GIBI
C     OUT:NBELE: NOMBRE DE MAILLES CONTENUES DANS L'OBJET.
C
C ----------------------------------------------------------------------
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------
C     VARIABLES LOCALES:
      INTEGER ITYPEL
      CHARACTER*50 KBID
      CHARACTER*4 K4BID,TYPMAI
      CHARACTER*5 K5BID
      CHARACTER*16 K16OBJ
      INTEGER      NBNUM, VALI(5)
C
C
      CALL JEMARQ()
      IF(NIV.EQ.3) THEN
        NBNUM = 16
        READ (NFIC,1008) ITYPEL,NBSOOB,NBREF,NBNO,NBELE
      ELSE
        NBNUM = 10
        READ (NFIC,1009) ITYPEL,NBSOOB,NBREF,NBNO,NBELE
      ENDIF
C
      IF ((ITYPEL.EQ.0) .AND. (NBSOOB.EQ.0)) THEN
        CALL U2MESS('F','PREPOST4_95')
      END IF
C ---------------------------------
      CALL JEVEUO('&&GILIRE.NOMOBJ','E',IANOOB)
      CALL JEVEUO('&&GILIRE.DESCOBJ','E',IADSOB)
      CALL CODENT(IOBJ,'D',K5BID)
      ZK8(IANOOB-1+2* (IOBJ-1)+1) = '.OB'//K5BID
C
C -- CONVERSION NUMERO TYPE MAILLE AVEC CODE TYPE MAILLE --
C
      TYPMAI = 'INCONNU'
      
      IF (ITYPEL.EQ.1) THEN
        TYPMAI = 'POI1'

      ELSE IF (ITYPEL.EQ.2) THEN
        TYPMAI = 'SEG2'

      ELSE IF (ITYPEL.EQ.3) THEN
        TYPMAI = 'SEG3'

      ELSE IF (ITYPEL.EQ.4) THEN
        TYPMAI = 'TRI3'

      ELSE IF (ITYPEL.EQ.6) THEN
        TYPMAI = 'TRI6'

      ELSE IF (ITYPEL.EQ.8) THEN
        TYPMAI = 'QUA4'

      ELSE IF (ITYPEL.EQ.10) THEN
        TYPMAI = 'QUA8'

      ELSE IF (ITYPEL.EQ.11) THEN
        TYPMAI = 'QUA9'

      ELSE IF (ITYPEL.EQ.14) THEN
        TYPMAI = 'CUB8'

      ELSE IF (ITYPEL.EQ.15) THEN
        TYPMAI = 'CU20'

      ELSE IF (ITYPEL.EQ.33) THEN
        TYPMAI = 'CU27'

      ELSE IF (ITYPEL.EQ.16) THEN
        TYPMAI = 'PRI6'

      ELSE IF (ITYPEL.EQ.17) THEN
        TYPMAI = 'PR15'

      ELSE IF (ITYPEL.EQ.23) THEN
        TYPMAI = 'TET4'

      ELSE IF (ITYPEL.EQ.24) THEN
        TYPMAI = 'TE10'

      ELSE IF (ITYPEL.EQ.25) THEN
        TYPMAI = 'PYR5'

      ELSE IF (ITYPEL.EQ.26) THEN
        TYPMAI = 'PY13'
      
C --- SI ITYPEL = 0, ON S'EST ASSURE QUE NBSOOB > 0
      ELSE IF (ITYPEL.NE.0) THEN
         VALI(1) = ITYPEL
         VALI(2) = NBSOOB
         VALI(3) = NBREF
         VALI(4) = NBNO
         VALI(5) = NBELE
         CALL U2MESI('F', 'PREPOST4_94', 5, VALI)
      END IF
C
      ZK8(IANOOB-1+2* (IOBJ-1)+2) = TYPMAI
      ZI(IADSOB-1+4* (IOBJ-1)+1) = NBSOOB
      ZI(IADSOB-1+4* (IOBJ-1)+2) = NBREF
      ZI(IADSOB-1+4* (IOBJ-1)+3) = NBNO
      ZI(IADSOB-1+4* (IOBJ-1)+4) = NBELE
C
C ---------------------------------
      K16OBJ = '&&GILIRE'//'.OB'//K5BID
      IF (NBSOOB.GT.0) THEN
C
C         -- CAS OBJET DECOMPOSE:
C         -----------------------
        CALL WKVECT(K16OBJ//'.SOUSOB','V V I',NBSOOB,IASOOB)
        NBFOIS = NBSOOB/NBNUM
        NBREST = NBSOOB - NBNUM*NBFOIS
        ICOJ = 0
C
C        -- ON LIT LES NUMEROS DES SOUS-OBJETS:
C        --------------------------------------
        DO 1,I = 1,NBFOIS
          IF(NIV.EQ.3) THEN
            READ(NFIC,1011) (ZI(IASOOB-1+J),J=ICOJ+1,ICOJ+NBNUM)
          ELSE
            READ(NFIC,1010) (ZI(IASOOB-1+J),J=ICOJ+1,ICOJ+NBNUM)
          ENDIF
          ICOJ = ICOJ + NBNUM
    1   CONTINUE
        IF (NBREST.GT.0) THEN
          IF(NIV.EQ.3) THEN
            READ(NFIC,1011) (ZI(IASOOB-1+J),J=ICOJ+1,ICOJ+NBREST)
          ELSE
            READ(NFIC,1010) (ZI(IASOOB-1+J),J=ICOJ+1,ICOJ+NBREST)
          ENDIF
        END IF
C
C        -- ON LIT LES REFERENCES:
C        -------------------------
        IF (NBREF.GT.0) THEN
          CALL WKVECT(K16OBJ//'.REFE  ','V V I',NBREF,IAREFE)
          NBFOIS = NBREF/NBNUM
          NBREST = NBREF - NBNUM*NBFOIS
          ICOJ = 0
          DO 2,I = 1,NBFOIS
            IF(NIV.EQ.3) THEN
              READ (NFIC,1011) (ZI(IAREFE-1+J),J=ICOJ+1,ICOJ+NBNUM)
            ELSE
              READ (NFIC,1010) (ZI(IAREFE-1+J),J=ICOJ+1,ICOJ+NBNUM)
            ENDIF
            ICOJ = ICOJ + NBNUM
    2     CONTINUE
          IF (NBREST.GT.0) THEN
            IF(NIV.EQ.3) THEN
              READ (NFIC,1011) (ZI(IAREFE-1+J),J=ICOJ+1,ICOJ+NBREST)
            ELSE
              READ (NFIC,1010) (ZI(IAREFE-1+J),J=ICOJ+1,ICOJ+NBREST)
            ENDIF
          END IF
        END IF
C
      ELSE
C
C        -- CAS "OBJET SIMPLE":
C        ----------------------
C        -- ON LIT LES REFERENCES:
C        -------------------------
        IF (NBREF.GT.0) THEN
          CALL WKVECT(K16OBJ//'.REFE  ','V V I',NBREF,IAREFE)
          NBFOIS = NBREF/NBNUM
          NBREST = NBREF - NBNUM*NBFOIS
          ICOJ = 0
          DO 3,I = 1,NBFOIS
            IF(NIV.EQ.3) THEN
              READ(NFIC,1011) (ZI(IAREFE-1+J),J=ICOJ+1,ICOJ+NBNUM)
            ELSE
              READ(NFIC,1010) (ZI(IAREFE-1+J),J=ICOJ+1,ICOJ+NBNUM)
            ENDIF
            ICOJ = ICOJ + NBNUM
    3     CONTINUE
          IF (NBREST.GT.0) THEN
            IF(NIV.EQ.3) THEN
              READ (NFIC,1011) (ZI(IAREFE-1+J),J=ICOJ+1,ICOJ+NBREST)
            ELSE
              READ (NFIC,1010) (ZI(IAREFE-1+J),J=ICOJ+1,ICOJ+NBREST)
            ENDIF
          END IF
        END IF
C
C        -- ON LIT LES COULEURS DES ELEMENTS:
C        ------------------------------------
        IF (NBELE.GT.0) THEN
          CALL WKVECT(K16OBJ//'.COULEU','V V I ',NBELE,IACOUL)
          NBFOIS = NBELE/NBNUM
          NBREST = NBELE - NBNUM*NBFOIS
          ICOJ = 0
          DO 4,I = 1,NBFOIS
            IF(NIV.EQ.3) THEN
              READ (NFIC,1011) (ZI(IACOUL-1+J),J=ICOJ+1,ICOJ+NBNUM)
            ELSE
              READ (NFIC,1010) (ZI(IACOUL-1+J),J=ICOJ+1,ICOJ+NBNUM)
            ENDIF
            ICOJ = ICOJ + NBNUM
    4     CONTINUE
          IF (NBREST.GT.0) THEN
            IF(NIV.EQ.3) THEN
              READ (NFIC,1011) (ZI(IACOUL-1+J),J=ICOJ+1,ICOJ+NBREST)
            ELSE
              READ (NFIC,1010) (ZI(IACOUL-1+J),J=ICOJ+1,ICOJ+NBREST)
            ENDIF
          END IF
C
C          -- ON LIT LA CONNECTIVITE DES ELEMENTS:
C          ----------------------------------------
          CALL WKVECT(K16OBJ//'.CONNEX','V V I',NBELE*NBNO,IACNEX)
          NBFOIS = NBELE*NBNO/NBNUM
          NBREST = NBELE*NBNO - NBNUM*NBFOIS
          ICOJ = 0
          DO 5,I = 1,NBFOIS
            IF(NIV.EQ.3) THEN
              READ (NFIC,1011) (ZI(IACNEX-1+J),J=ICOJ+1,ICOJ+NBNUM)
            ELSE
              READ (NFIC,1010) (ZI(IACNEX-1+J),J=ICOJ+1,ICOJ+NBNUM)
            ENDIF
            ICOJ = ICOJ + NBNUM
    5     CONTINUE
          IF (NBREST.GT.0) THEN
            IF(NIV.EQ.3) THEN
              READ (NFIC,1011) (ZI(IACNEX-1+J),J=ICOJ+1,ICOJ+NBREST)
            ELSE
              READ (NFIC,1010) (ZI(IACNEX-1+J),J=ICOJ+1,ICOJ+NBREST)
            ENDIF
          END IF
        END IF
C
      END IF
C
 9999 CONTINUE
C
 1008 FORMAT (I5,I5,I5,I5,I5)
 1009 FORMAT (I8,I8,I8,I8,I8)
 1010 FORMAT (10 (I8))
 1011 FORMAT (16 (I5))
C
      CALL JEDEMA()
      END
