      SUBROUTINE AFFDEF(TMP,NOM,NEL,NTEL,TAB,IER)
      IMPLICIT       NONE
      INCLUDE       'jeveux.h'

      CHARACTER*32   JEXNOM
      INTEGER        NTEL(*)
      CHARACTER*8    TAB(*)
      CHARACTER*24   NOM,TMP
C       ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/04/2013   AUTEUR FLEJOU J-L.FLEJOU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C  - VERIFICATION DE LA COMPLETUDE DES DONNES OBLIGATOIRES A
C    ENTRER , ET DE LA POSITIVITE DE CERTAINES VALEURS
C  - AFFECTATION DES VALEURS PAR DEFAUT AUX CARACTERISTIQUES
C    GENERALES ET GEOMETRIQUES ABSENTES
C  - NTEL(I)  = NUMERO DU TYPE ELEMENT
C       I = 1 : MECA_POU_D_T
C           2 : MECA_POU_D_E
C           4 : MECA_POU_C_T
C           5 : MEFS_POU_D_T
C           6 : MECA_POU_D_TG
C          12 : MECA_POU_D_EM
C          13 : MECA_POU_D_TGM
C
C --- ------------------------------------------------------------------
C     TAB  1      2      3      4      5     6     7     8    9    10
C     0    A1     IY1    IZ1    AY1    AZ1   EY1   EZ1   JX1  RY1  RZ1
C     1    RT1    A2     IY2    IZ2    AY2   AZ2   EY2   EZ2  JX2  RY2
C     2    RZ2    RT2    TVAR   HY1    HZ1   EPY1  EPZ1  HY2  HZ2  EPY2
C     3    EPZ2   R1     E1     R2     E2    TSEC  AI1   AI2  JG1  JG2
C     4    IYR21  IYR22  IZR21  IZR22
C--- -------------------------------------------------------------------
      INTEGER        IER ,ISEC ,J ,JDGE ,NC ,ND ,NE
      INTEGER        NEL ,NG ,NR ,NT ,NX ,NY ,NZ
C--- -------------------------------------------------------------------
      PARAMETER       ( NR = 4 , NC = 2, NG = 8 )
      PARAMETER       ( NT = 4 , NE =12, ND = 6 )
      PARAMETER       ( NX = 10, NY = 8, NZ = 4 )
      INTEGER         OGEN(NG), OREC(NR), OCER(NC), OTPE(NT)
      INTEGER         DEXC(NE), DDFX(ND), DREC(NR), DCER(NC)
      INTEGER         PGEN(NX), PREC(NY), PCER(NZ)
      CHARACTER*24    VALK(3)
      REAL*8          R8MAEM,TST
C--- -------------------------------------------------------------------
      DATA OGEN      /1,2,3,8,12,13,14,19/
      DATA OREC      /24,25,28,29/
      DATA OCER      /32,34/
      DATA OTPE      /4,5,15,16/
      DATA DEXC      /6,7,17,18,37,38,39,40,41,42,43,44/
      DATA DDFX      /9,10,11,20,21,22/
      DATA DREC      /26,27,30,31/
      DATA DCER      /33,35/
      DATA PGEN      /1,9,10,11,12,20,21,22,37,38/
      DATA PREC      /24,25,26,27,28,29,30,31/
      DATA PCER      /32,33,34,35/
C--- -------------------------------------------------------------------
C
      CALL JEMARQ()
      TST = R8MAEM()
C
      CALL JEVEUO(JEXNOM(TMP,NOM),'E',JDGE)
      ISEC = NINT(ZR(JDGE+35))
C
C     COMPLETUDE DES DONNES GENERALES
C
      IF(ISEC.EQ.0)THEN
         DO 20 J = 1 , NG
            IF(ZR(JDGE+OGEN(J)-1).EQ.TST)THEN
               VALK(1) = NOM
               VALK(2) = TAB(OGEN(J))
               CALL U2MESK('A','MODELISA_77', 2 ,VALK)
               IER = IER + 1
            ENDIF
20       CONTINUE
C        1:MECA_POU_D_T     4:MECA_POU_C_T
C        5:MEFS_POU_D_T     6:MECA_POU_D_TG
C       13:MECA_POU_D_TGM
         IF ((NEL.EQ.NTEL(1) ).OR.(NEL.EQ.NTEL(4) ).OR.
     &       (NEL.EQ.NTEL(5) ).OR.(NEL.EQ.NTEL(6) ).OR.
     &       (NEL.EQ.NTEL(13)) )THEN
            DO 50 J = 1 , NT
               IF(ZR(JDGE+OTPE(J)-1).EQ.TST)THEN
                  VALK(1) = NOM
                  VALK(2) = TAB(OTPE(J))
                  CALL U2MESK('A','MODELISA_78', 2 ,VALK)
               ENDIF
50          CONTINUE
         ENDIF
      ENDIF
C
C     COMPLETUDE DES DONNES GEOMETRIQUES RECTANGLE
C
      IF(ISEC.EQ.1)THEN
         DO 30 J = 1 , NR
            IF(ZR(JDGE+OREC(J)-1).EQ.TST)THEN
               VALK(1) = NOM
               VALK(2) = TAB(OREC(J))
               CALL U2MESK('A','MODELISA_79', 2 ,VALK)
               IER = IER + 1
            ENDIF
30       CONTINUE
      ENDIF
C
C     COMPLETUDE DES DONNES GEOMETRIQUES CERCLE
C
      IF(ISEC.EQ.2)THEN
         DO 40 J = 1 , NC
            IF(ZR(JDGE+OCER(J)-1).EQ.TST)THEN
               VALK(1) = NOM
               VALK(2) = TAB(OCER(J))
               CALL U2MESK('A','MODELISA_80', 2 ,VALK)
               IER = IER + 1
            ENDIF
40       CONTINUE
      ENDIF
C
C     VERIFICATION DE LA STRICTE POSITIVITE DE  VALEURS GENERALE
C
      IF(ISEC.EQ.0)THEN
         DO 130 J = 1 , NX
            IF(ZR(JDGE+PGEN(J)-1).NE.TST)THEN
               IF(ZR(JDGE+PGEN(J)-1).LE.0.D0)THEN
                  VALK(1) = NOM
                  VALK(2) = TAB(PGEN(J))
                  CALL U2MESK('A','MODELISA_81', 2 ,VALK)
                  IER = IER + 1
               ENDIF
            ENDIF
130      CONTINUE
      ENDIF
C
C     VERIFICATION DE LA STRICTE POSITIVITE DE VALEURS RECTANGLE
C
      IF(ISEC.EQ.1)THEN
         DO 110 J = 1 , NY
            IF(ZR(JDGE+PREC(J)-1).NE.TST)THEN
               IF(ZR(JDGE+PREC(J)-1).LE.0.D0)THEN
                  VALK(1) = NOM
                  VALK(2) = TAB(PREC(J))
                  CALL U2MESK('A','MODELISA_82', 2 ,VALK)
                  IER = IER + 1
               ENDIF
            ENDIF
110      CONTINUE
      ENDIF
C
C     VERIFICATION DE LA STRICTE POSITIVITE DE VALEURS CERCLE
C
      IF(ISEC.EQ.2)THEN
         DO 120 J = 1 , NZ
            IF(ZR(JDGE+PCER(J)-1).NE.TST)THEN
               IF(ZR(JDGE+PCER(J)-1).LE.0.D0)THEN
                  VALK(1) = NOM
                  VALK(2) = TAB(PCER(J))
                  CALL U2MESK('A','MODELISA_83', 2 ,VALK)
                  IER = IER + 1
               ENDIF
            ENDIF
120      CONTINUE
      ENDIF
C
      IF (IER.NE.0) GOTO 9999
C
C     AFFECTATION DES VALEURS PAR DEFAUT POUR LES DONNEES GENERALES
C
      IF(ISEC.EQ.0)THEN
C        EXCENTREMENTS, AIRES INTERIEURES, CONSTANTES DE GAUCHISSEMENT
         DO 60 J = 1 , NE
            IF(ZR(JDGE+DEXC(J)-1).EQ.TST)ZR(JDGE+DEXC(J)-1) = 0.D0
60       CONTINUE
C        DIST. FIBRE EXT.+ RAYON TORSION
         DO 70 J = 1 , ND
            IF(ZR(JDGE+DDFX(J)-1).EQ.TST)ZR(JDGE+DDFX(J)-1) = 1.D0
70       CONTINUE
C        EULER
         IF(NEL.EQ.NTEL(2))THEN
            DO 80 J = 1 , NT
               ZR(JDGE+OTPE(J)-1) = 0.D0
80          CONTINUE
         ENDIF
      ENDIF
C
C     AFFECTATION DES VALEURS PAR DEFAUT POUR LES DONNEES RECTANGLE
C
      IF(ISEC.EQ.1)THEN
         DO 90 J = 1 , NR
            IF(ZR(JDGE+DREC(J)-1).EQ.TST)THEN
               ZR(JDGE+DREC(J)-1) = ZR(JDGE+OREC(J)-1) / 2.D0
            ELSE
               IF(ZR(JDGE+DREC(J)-1).GT.(ZR(JDGE+OREC(J)-1)/2.D0))THEN
                  VALK(1) = NOM
                  VALK(2) = TAB(DREC(J))
                  VALK(3) = TAB(OREC(J))
                  CALL U2MESK('A','MODELISA_84', 3 ,VALK)
                  IER = IER + 1
               ENDIF
            ENDIF
90       CONTINUE
      ENDIF
C
C     AFFECTATION DES VALEURS PAR DEFAUT POUR LES DONNEES CERCLE
C
      IF(ISEC.EQ.2)THEN
         DO 100 J = 1 , NC
            IF(ZR(JDGE+DCER(J)-1).EQ.TST)THEN
               ZR(JDGE+DCER(J)-1) = ZR(JDGE+OCER(J)-1)
            ELSE
               IF(ZR(JDGE+DCER(J)-1).GT.ZR(JDGE+OCER(J)-1))THEN
                  VALK(1) = NOM
                  VALK(2) = TAB(DCER(J))
                  VALK(3) = TAB(OCER(J))
                  CALL U2MESK('A','MODELISA_85', 3 ,VALK)
                  IER = IER + 1
               ENDIF
            ENDIF
100      CONTINUE
      ENDIF
C
9999  CONTINUE
      CALL JEDEMA()
      END
