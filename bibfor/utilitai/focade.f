      SUBROUTINE FOCADE ( METHOD, NOMFON, SORTIE, BASE )
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       METHOD, NOMFON, SORTIE
      CHARACTER*(1)                               BASE
C     ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 21/02/96   AUTEUR VABHHTS J.PELLET 
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
C     DERIVATION D'UNE FONCTION
C     ----------------------------------------------------------------
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
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8   CBID, NOMRES
      CHARACTER*19  NOMFI, NOMFS
      CHARACTER*24  VALE, PROL
C     ----------------------------------------------------------------
      CALL JEMARQ()
      NOMFI = NOMFON
      NOMFS = SORTIE
C
C     ---  NOMBRE DE POINTS ----
      VALE = NOMFI//'.VALE'
      CALL JELIRA(VALE,'LONUTI',NBVAL,CBID)
      CALL JEVEUO(VALE,'L',LVAR)
      NBPTS = NBVAL/2
      LFON  = LVAR + NBPTS
C
C     --- CREATION DU TABLEAU DES VALEURS ---
      CALL WKVECT(NOMFS//'.VALE',BASE//' V R',NBVAL,LRES)
C
C     --- RECOPIE DES VARIABLES ---
      DO 310 I = 0 , NBPTS-1
         ZR(LRES+I) = ZR(LVAR+I)
  310 CONTINUE
      LRES = LRES + NBPTS
C
C     --- DERIVATION ---
      IF ( METHOD .EQ. 'DIFF_CENTREE' .OR. METHOD .EQ. ' ' ) THEN
         WRITE(6,'(1X,A)')'DERIVATION D"ORDRE 2 (DIFFERENCE CENTREE)'
         WRITE(6,'(1X,A)')
     +     'POUR LA PREMIERE VALEUR, ON CALCULE LA DERIVEE A DROITE',
     +     'POUR LA DERNIERE VALEUR, ON CALCULE LA DERIVEE A GAUCHE'
C
         CALL FOC2DE(NBPTS,ZR(LVAR),ZR(LFON), ZR(LRES))
C
      ELSE
         CALL UTMESS('F',METHOD,'METHODE DE DERIVATION NON IMPLEMENTEE')
      ENDIF
C
C     --- AFFECTATION DU .PROL ---
      PROL = NOMFI//'.PROL'
      CALL JEVEUO(PROL,'L',LPRO)
      NOMRES = ZK8(LPRO+3)
      IF ( NOMRES(1:4) .EQ. 'DEPL' ) THEN
         NOMRES = 'VITE'
      ELSEIF ( NOMRES(1:4) .EQ. 'VITE' ) THEN
         NOMRES = 'ACCE'
      ELSE
         NOMRES      = 'TOUTRESU'
      ENDIF
      PROL = NOMFS//'.PROL'
      CALL WKVECT(PROL,'G V K8',5,LPROS)
      ZK8(LPROS  ) = 'FONCTION'
      IF (ZK8(LPRO+1)(1:3).EQ.'INT') THEN
         ZK8(LPROS+1) = 'LIN LIN '
      ELSE
         ZK8(LPROS+1) = ZK8(LPRO+1)
      ENDIF
      ZK8(LPROS+2) = ZK8(LPRO+2)
      ZK8(LPROS+3) = NOMRES
      IF (ZK8(LPRO+4)(1:1).EQ.'I' .OR. ZK8(LPRO+4)(2:2).EQ.'I') THEN
         ZK8(LPROS+4) = 'EE      '
      ELSE
         ZK8(LPROS+4) = ZK8(LPRO+4)
      ENDIF
C
      CALL JEDEMA()
      END
