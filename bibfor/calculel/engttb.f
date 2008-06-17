      SUBROUTINE ENGTTB ( IFIC, NOMSD, TYPTES, PRECI, FORMR )
      IMPLICIT NONE
      INTEGER      IFIC
      CHARACTER*8  TYPTES
      CHARACTER*10 PRECI, FORMR
      CHARACTER*19 NOMSD
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/12/2006   AUTEUR VIVAN L.VIVAN 
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
C     COMMANDE:  ENGENDRE_TEST
C                TRAITEMENT DES SD TABLE
C
C IN  : IFIC   : NUMERO D'UNITE IMPRESSION
C IN  : NOMSD : NOM D'UNE SD RESULTAT
C IN  : TYPTES : TYPE DU TEST = SOMM_ABS, SOMM
C IN  : PRECI  : PRECISION POUR LE TEST_TABLE
C IN  : FORMR  : FORMAT D'IMPRESSION DU CHAMP VALE REEL
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER      IBID, NBPARA, NBLIGN, VALI, NBNOSY, IPAR, LG, LG1,
     +             LG2, LXLGUT, I, JVALE, JVALL, JTBLP, JTBNP, ISMAEM
      REAL*8       R8B, VALR, R8PREM, R8MAEM
      LOGICAL      EXIST
      CHARACTER*3  TYPE
      CHARACTER*8  K8B
      CHARACTER*16 NOMSYM
      CHARACTER*19 CHEXTR
      CHARACTER*90 FORM1, FORM2, FORM3
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      LG1 = LXLGUT( FORMR  )
      LG2 = LXLGUT( TYPTES )
      FORM1 = '(''            TYPE_TEST= '''''//TYPTES(1:LG2)//
     +          ''''', VALE= '','//FORMR(1:LG1)//','' )'')'
      FORM2 = '(''            TYPE_TEST= '''''//TYPTES(1:LG2)//
     +          ''''', VALE_I= '',I9,'' )'')'
C
      CALL JEVEUO ( NOMSD//'.TBLP' , 'L', JTBLP )
      CALL JEVEUO ( NOMSD//'.TBNP' , 'L', JTBNP )
      NBPARA = ZI(JTBNP  )
      NBLIGN = ZI(JTBNP+1)
C
      DO 400 IPAR = 1,NBPARA
C
         NOMSYM = ZK24(JTBLP+4*(IPAR-1))
         CALL TBEXIP ( NOMSD, NOMSYM, EXIST, TYPE )
         IF ( .NOT. EXIST ) GOTO 400
C
         LG = LXLGUT( NOMSYM )
         CALL JEVEUO ( ZK24(JTBLP+4*(IPAR-1)+2) , 'L', JVALE )
         CALL JEVEUO ( ZK24(JTBLP+4*(IPAR-1)+3) , 'L', JVALL )
C
         FORM3 = '(''TEST_TABLE( TABLE= '',A8,'', NOM_PARA= '''''//
     +           NOMSYM(1:LG)//''''', '')'
C
         IF ( TYPE .EQ. 'I' ) THEN
C             -------------
            WRITE(IFIC,FORM3) NOMSD(1:8)
            WRITE(IFIC,4020) PRECI
C
            IF ( TYPTES .EQ. 'SOMM_ABS' ) THEN
               VALI = 0
               DO 410 I = 1 , NBLIGN
               IF (ZI(JVALL+I-1).EQ.1) VALI = VALI+ABS(ZI(JVALE+I-1))
 410           CONTINUE
            ELSEIF ( TYPTES .EQ. 'SOMM' ) THEN
               VALI = 0
               DO 412 I = 1 , NBLIGN
                  IF (ZI(JVALL+I-1).EQ.1) VALI = VALI + ZI(JVALE+I-1)
 412           CONTINUE
            ELSEIF ( TYPTES .EQ. 'MAX' ) THEN
               VALI = -ISMAEM()
               DO 414 I = 1 , NBLIGN
                  IF (ZI(JVALL+I-1).EQ.1) VALI = MAX(VALI,ZI(JVALE+I-1))
 414           CONTINUE
            ELSEIF ( TYPTES .EQ. 'MIN' ) THEN
               VALI = ISMAEM()
               DO 416 I = 1 , NBLIGN
                  IF (ZI(JVALL+I-1).EQ.1) VALI = MIN(VALI,ZI(JVALE+I-1))
 416           CONTINUE
            ENDIF
            IF ( VALI .EQ. 0 ) WRITE(IFIC,4010)
            WRITE(IFIC,FORM2) VALI
C
         ELSEIF ( TYPE .EQ. 'R' ) THEN
C                 -------------
            WRITE(IFIC,FORM3) NOMSD(1:8)
            WRITE(IFIC,4020) PRECI
C
            IF ( TYPTES .EQ. 'SOMM_ABS' ) THEN
               VALR = 0.D0
               DO 420 I = 1 , NBLIGN
               IF (ZI(JVALL+I-1).EQ.1) VALR = VALR+ABS(ZR(JVALE+I-1))
 420           CONTINUE
            ELSEIF ( TYPTES .EQ. 'SOMM' ) THEN
               VALR = 0.D0
               DO 422 I = 1 , NBLIGN
                  IF (ZI(JVALL+I-1).EQ.1) VALR = VALR + ZR(JVALE+I-1)
 422           CONTINUE
            ELSEIF ( TYPTES .EQ. 'MAX' ) THEN
               VALR = -R8MAEM()
               DO 424 I = 1 , NBLIGN
                  IF (ZI(JVALL+I-1).EQ.1) VALR = MAX(VALR,ZR(JVALE+I-1))
 424           CONTINUE
            ELSEIF ( TYPTES .EQ. 'MIN' ) THEN
               VALR = R8MAEM()
               DO 426 I = 1 , NBLIGN
                  IF (ZI(JVALL+I-1).EQ.1) VALR = MIN(VALR,ZR(JVALE+I-1))
 426           CONTINUE
            ENDIF
            IF ( ABS(VALR) .LE. R8PREM() ) WRITE(IFIC,4010)
            WRITE(IFIC,FORM1) VALR
         ENDIF
 400  CONTINUE
C
      CALL JEDEMA()
C
 4010 FORMAT ('            CRITERE= ''ABSOLU'', ')
C
 4020 FORMAT ('            REFERENCE= ''NON_REGRESSION'', ',
     +                    'PRECISION= ',A10,',')
C
      END
