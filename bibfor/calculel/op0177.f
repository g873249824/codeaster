      SUBROUTINE OP0177()
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 25/06/2012   AUTEUR ABBAS M.ABBAS 
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
C
C     COMMANDE:  TEST_TABLE
C
C ----------------------------------------------------------------------
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
C
C 0.2. ==> COMMUNS
C 0.3. ==> VARIABLES LOCALES
C
      INCLUDE 'jeveux.h'
      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='OP0177')
C
      INTEGER IBID, N1, N2, N3, IRET, IUNIFI, IFIC, NPARFI
      INTEGER VALI,IREFR,IREFI,IREFC,NREF
      INTEGER LXLGUT,NL1,NL2,NL11,NL22
      LOGICAL       ULEXIS
C
      REAL*8       R8B, VALR, PREC
C
      COMPLEX*16   CBID, VALC, C16B
C
      CHARACTER*1  TYPR
      CHARACTER*3  SSIGNE
      CHARACTER*8  K8B, CRIT, CTYPE, TYPTES, LATABL
      CHARACTER*8  MOTCLE
      CHARACTER*16 NOMFI,TBTXT(2)
      CHARACTER*19 NEWTAB, NEWTA1
      CHARACTER*24 PARA
      CHARACTER*24 TRAVR,TRAVI,TRAVC
      CHARACTER*80 VALK
      CHARACTER*200 LIGN1,LIGN2
      INTEGER      IARG
C     ------------------------------------------------------------------
C
C====
C 1. PREALABLES
C====
C
      CALL JEMARQ()
      CALL INFMAJ()
C
      TRAVR  = '&&'//NOMPRO//'_TRAVR          '
      TRAVI  = '&&'//NOMPRO//'_TRAVI          '
      TRAVC  = '&&'//NOMPRO//'_TRAVC          '
      MOTCLE = 'TABLE'
C
      NOMFI = ' '
      IFIC  = IUNIFI('RESULTAT')
      IF ( .NOT. ULEXIS( IFIC ) ) THEN
         CALL ULOPEN ( IFIC, ' ', NOMFI, 'NEW', 'O' )
      ENDIF
      WRITE(IFIC,1000)
C
      CALL GETVID ( ' ', 'TABLE' ,1,IARG,1,LATABL, N1 )
C
      CALL GETFAC ( 'FILTRE' , NPARFI )
C
      CALL GETVTX ( ' ', 'VALE_ABS' , 1,IARG,1, SSIGNE, N1 )
      CALL GETVR8 ( ' ', 'PRECISION', 1,IARG,1, PREC  , N1 )
      CALL GETVTX ( ' ', 'CRITERE'  , 1,IARG,1, CRIT  , N1 )
C
      CALL GETVR8(' ','VALE'    , 1,IARG,0,R8B   ,N1)
      CALL GETVIS(' ','VALE_I'  , 1,IARG,0,IBID  ,N2)
      CALL GETVC8(' ','VALE_C'  , 1,IARG,0,C16B  ,N3)
      IF( N1 .NE. 0) THEN
        NREF=-N1
        TYPR = 'R'
        CALL JEDETR(TRAVR)
        CALL WKVECT(TRAVR,'V V R',NREF,IREFR)
        CALL GETVR8(' ','VALE', 1,IARG,NREF,ZR(IREFR),IRET)
      ELSEIF( N2 .NE. 0) THEN
        NREF=-N2
        TYPR = 'I'
        CALL JEDETR(TRAVI)
        CALL WKVECT(TRAVI,'V V I',NREF,IREFI)
        CALL GETVIS(' ','VALE_I', 1,IARG,NREF,ZI(IREFI),IRET)
      ELSEIF( N3 .NE. 0) THEN
        NREF=-N3
        TYPR = 'C'
        CALL JEDETR(TRAVC)
        CALL WKVECT(TRAVC,'V V C',NREF,IREFC)
        CALL GETVC8(' ','VALE_C', 1,IARG,NREF,ZC(IREFC),IRET)
      ENDIF


      CALL GETVTX ( ' ', 'NOM_PARA', 1,IARG,1, PARA, N1 )
C
      CALL GETVTX ( ' ', 'TYPE_TEST', 1,IARG,1, TYPTES, N1 )

      LIGN1  = ' '
      LIGN2  = ' '

C
C     ------------------------------------------------------------------
C
C                 --- TRAITEMENT DU MOT CLE "FILTRE" ---
C
C     ------------------------------------------------------------------
      NEWTAB = LATABL

      LIGN1(1:21)='---- '//MOTCLE
      LIGN1(22:22)='.'
      LIGN2(1:21)='     '//LATABL
      LIGN2(22:22)='.'
      NL1 = LXLGUT(LIGN1)
      NL2 = LXLGUT(LIGN2)
      LIGN1(1:NL1+16)=LIGN1(1:NL1-1)//' NOM_PARA'
      LIGN2(1:NL2+16)=LIGN2(1:NL2-1)//' '//PARA(1:16)
      LIGN1(NL1+17:NL1+17)='.'
      LIGN2(NL2+17:NL2+17)='.'


      IF ( NPARFI .NE. 0 ) THEN
         NEWTA1 = '&&'//NOMPRO//'.FILTRE '
         CALL TBIMFI ( NPARFI, NEWTAB, NEWTA1, IRET )
         IF ( IRET .NE. 0 )  CALL U2MESS('F','CALCULEL6_7')
         NEWTAB = NEWTA1
      ENDIF
C     ------------------------------------------------------------------
C
      CALL UTEST3(' ',1,TBTXT)
C
      IF ( N1. NE. 0 ) THEN

         NL1 = LXLGUT(LIGN1)
         NL2 = LXLGUT(LIGN2)
         LIGN1(1:NL1+16)=LIGN1(1:NL1-1)//' TYPE_TEST'
         LIGN2(1:NL2+16)=LIGN2(1:NL2-1)//' '//TYPTES
         LIGN1(NL1+17:NL1+17)='.'
         LIGN2(NL2+17:NL2+17)='.'

         NL1 = LXLGUT(LIGN1)
         NL11 = LXLGUT(LIGN1(1:NL1-1))
         NL2 = LXLGUT(LIGN2)
         NL22 = LXLGUT(LIGN2(1:NL2-1))
         IF(NL11.LT.80)THEN
            WRITE (IFIC,*) LIGN1(1:NL11)
         ELSEIF(NL11.LT.160)THEN
            WRITE (IFIC,1160) LIGN1(1:80),
     &                        LIGN1(81:NL11)
         ELSE
            WRITE (IFIC,1200) LIGN1(1:80),
     &                        LIGN1(81:160),
     &                        LIGN1(161:NL11)
         ENDIF
         IF(NL22.LT.80)THEN
            WRITE (IFIC,*) LIGN2(1:NL22)
         ELSEIF(NL22.LT.160)THEN
            WRITE (IFIC,1160) LIGN2(1:80),
     &                        LIGN2(81:NL22)
         ELSE
            WRITE (IFIC,1200) LIGN2(1:80),
     &                        LIGN2(81:160),
     &                        LIGN2(161:NL22)
         ENDIF

         CALL UTEST0 ( NEWTAB, PARA, TYPTES, TYPR, TBTXT,ZI(IREFI),
     +                ZR(IREFR), ZC(IREFC), PREC, CRIT, IFIC, SSIGNE )
         GOTO 9999
      ENDIF
C
      CALL TBLIVA ( NEWTAB, 0, K8B, IBID, R8B, CBID, K8B, K8B, R8B,
     +                      PARA, CTYPE, VALI, VALR, VALC, VALK, IRET )


      NL1 = LXLGUT(LIGN1)
      NL11 = LXLGUT(LIGN1(1:NL1-1))
      NL2 = LXLGUT(LIGN2)
      NL22 = LXLGUT(LIGN2(1:NL2-1))
      IF(NL11.LT.80)THEN
         WRITE (IFIC,*) LIGN1(1:NL11)
      ELSEIF(NL11.LT.160)THEN
         WRITE (IFIC,1160) LIGN1(1:80),
     &                     LIGN1(81:NL11)
      ELSE
         WRITE (IFIC,1200) LIGN1(1:80),
     &                     LIGN1(81:160),
     &                     LIGN1(161:NL11)
      ENDIF
      IF(NL22.LT.80)THEN
         WRITE (IFIC,*) LIGN2(1:NL22)
      ELSEIF(NL22.LT.160)THEN
         WRITE (IFIC,1160) LIGN2(1:80),
     &                     LIGN2(81:NL22)
      ELSE
         WRITE (IFIC,1200) LIGN2(1:80),
     &                     LIGN2(81:160),
     &                     LIGN2(161:NL22)
      ENDIF


      IF ( IRET .EQ. 0 ) THEN
      ELSEIF ( IRET .EQ. 1 ) THEN
         CALL U2MESS('F','CALCULEL6_3')
      ELSEIF ( IRET .EQ. 2 ) THEN
         CALL U2MESS('F','CALCULEL6_4')
      ELSEIF ( IRET .EQ. 3 ) THEN
         CALL U2MESS('F','CALCULEL6_5')
      ELSE
         CALL U2MESS('F','CALCULEL6_6')
      ENDIF
      IF ( CTYPE(1:1) .NE. TYPR ) CALL U2MESS('F','CALCULEL6_8')

      CALL UTITES ( TBTXT(1),TBTXT(2), TYPR, NREF, ZI(IREFI), ZR(IREFR),
     +        ZC(IREFC), VALI, VALR, VALC, PREC, CRIT, IFIC, SSIGNE )
C
 9999 CONTINUE
      IF ( NPARFI .NE. 0 )  CALL DETRSD ( 'TABLE' , NEWTA1 )
      WRITE (IFIC,*)' '


C
1000  FORMAT(/,80('-'))
1160  FORMAT(1X,A80,A)
1200  FORMAT(1X,2(A80),A)

      CALL JEDEMA ( )
C
      END
