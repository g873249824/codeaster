      SUBROUTINE FOCINV ( NOMFON, SORTIE, BASE )
      IMPLICIT   NONE
      CHARACTER*1         BASE
      CHARACTER*19        NOMFON, SORTIE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/03/2003   AUTEUR DURAND C.DURAND 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C      CALCUL F(X)=G-1(X)
C
C IN  : NOMFON : NOM DE LA FONCTION A TRAITER
C IN  : BASE   : BASE OU EST STOCKEE LA FONCTION PRODUITE
C OUT : SORTIE : NOM DE LA FONCTION PRODUITE
C
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32     JEXNUM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       LVAR, NBPTS, LPRO, NBVAL, LRES, LPROS, I
      REAL*8        Y1, YN, ABSMOI, ABSPLU
      CHARACTER*8   CBID
      CHARACTER*16  TYPREF
      CHARACTER*16  NOMRES
      CHARACTER*19  NOMFI, NOMFS
      CHARACTER*24  PROL, VALE
C DEB ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      PROL(20:24) = '.PROL'
      VALE(20:24) = '.VALE'
C
      PROL( 1:19) = NOMFON
      VALE( 1:19) = NOMFON
      CALL JEVEUO(PROL,'L',LPRO)
      TYPREF =  ZK16(LPRO)
      IF ( TYPREF .NE. 'FONCTION' ) THEN
         CALL UTMESS('F','FOCINV','INVERSE D UNE FONCTION UNIQUEMENT')
      ENDIF

C     ---  NOMBRE DE POINTS ----
      CALL JELIRA(VALE,'LONUTI',NBVAL,CBID)
      CALL JEVEUO(VALE,'L',LVAR)
      NBPTS = NBVAL/2
C
C     --- CREATION DU TABLEAU DES VALEURS ---
      CALL WKVECT(SORTIE//'.VALE',BASE//' V R',NBVAL,LRES)
C
C     --- RECOPIE DES VARIABLES ---
C     COMPARAISON PREMIERE ET DERNIERE VALEURS Y
      Y1 = ZR(LVAR+NBPTS+1-1)
      YN = ZR(LVAR+NBVAL  -1)
      IF (Y1.LT.YN) THEN
         ABSMOI = Y1
         ZR(LRES)       = ABSMOI
         ZR(LRES+NBPTS) = ZR(LVAR)
         DO 100 I = 1 , NBPTS-1
            ABSPLU           = ZR(LVAR+I+NBPTS)
            IF ( ABSPLU .LE. ABSMOI ) THEN
               CALL UTMESS('F','FOCINV','FONCTION NON BIJECTIVE')
            ENDIF
            ZR(LRES+I)       = ABSPLU
            ZR(LRES+I+NBPTS) = ZR(LVAR+I)
            ABSMOI           = ABSPLU
  100    CONTINUE
      ELSE
         ABSMOI = YN
         ZR(LRES)       = ABSMOI
         ZR(LRES+NBPTS) = ZR(LVAR+NBPTS-1)
         DO 120 I = 1 , NBPTS-1
            ABSPLU           = ZR(LVAR+NBVAL-I-1)
            IF ( ABSPLU .LE. ABSMOI ) THEN
               CALL UTMESS('F','FOCINV','FONCTION NON BIJECTIVE')
            ENDIF
            ZR(LRES+I)       = ABSPLU
            ZR(LRES+I+NBPTS) = ZR(LVAR+NBPTS-I-1)
            ABSMOI           = ABSPLU
  120    CONTINUE
      ENDIF
C
C
C     --- AFFECTATION DU .PROL ---
      CALL JEVEUO(PROL,'L',LPRO)
      NOMRES = ZK16(LPRO+3)
      IF ( NOMRES(1:4) .EQ. 'DEPL' ) THEN
         NOMRES = 'VITE'
      ELSEIF ( NOMRES(1:4) .EQ. 'VITE' ) THEN
         NOMRES = 'ACCE'
      ELSE
         NOMRES      = 'TOUTRESU'
      ENDIF
      CALL WKVECT(SORTIE//'.PROL','G V K16',5,LPROS)
      ZK16(LPROS  ) = 'FONCTION'
      IF (ZK16(LPRO+1)(1:3).EQ.'INT') THEN
         ZK16(LPROS+1) = 'LIN LIN '
      ELSE
         ZK16(LPROS+1) = ZK16(LPRO+1)
      ENDIF
      ZK16(LPROS+2) = ZK16(LPRO+2)
      ZK16(LPROS+3) = NOMRES
      IF (ZK16(LPRO+4)(1:1).EQ.'I' .OR. ZK16(LPRO+4)(2:2).EQ.'I') THEN
         ZK16(LPROS+4) = 'EE      '
      ELSE
         ZK16(LPROS+4) = ZK16(LPRO+4)
      ENDIF
      CALL JEDEMA()
C
      END
