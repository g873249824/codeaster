      SUBROUTINE OP0156 ( IER )
      IMPLICIT  NONE
      INTEGER             IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 11/03/2003   AUTEUR DURAND C.DURAND 
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
C     ------------------------------------------------------------------
C
C     OPERATEUR :   PROD_MATR_CHAM
C
C     ------------------------------------------------------------------
C
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
      INTEGER       IBID, N1, IRET, NEQ
      INTEGER       LMAT, IAREFE, JCHIN, JCHOUT
      CHARACTER*1   TYPMAT, TYPRES
      CHARACTER*4   ETAMAT
      CHARACTER*14  NUMEM, NUMEC
      CHARACTER*16  TYPE, NOMCMD
      CHARACTER*19  MASSE, RESU, CHAMNO, CHAMN2, PRNO
      LOGICAL       CRCHNO
C     ------------------------------------------------------------------
      CALL JEMARQ ( )
      CALL INFMAJ()
C
C     --- RECUPERATION DES ARGUMENTS DE LA COMMANDE ---
C
      RESU = ' '
      CALL GETRES ( RESU, TYPE, NOMCMD )
C
C     --- MATRICE ---
C
      CALL GETVID(' ', 'MATR_ASSE', 0,1,1, MASSE, N1 )
      CALL MTDSCR ( MASSE )
      CALL JEVEUO ( MASSE(1:19)//'.&INT', 'E', LMAT )
      IF ( ZI(LMAT+3) .EQ. 1 ) THEN
         TYPMAT = 'R'
      ELSEIF ( ZI(LMAT+3) .EQ. 2 ) THEN
         TYPMAT = 'C'
      ELSE
         CALL UTMESS('F','OP0156','TYPE DE MATRICE INCONNU ')
      ENDIF
      CALL JELIRA ( MASSE//'.REFA', 'DOCU', IBID, ETAMAT )
      IF ( ETAMAT .NE. 'ASSE' ) THEN
         CALL UTMESS('F','OP0156',' PAS DE PRODUIT CAR LA MATRICE '//
     +                            MASSE(1:8)//' N''EST PAS ASSEMBLEE.')
      ENDIF
      CALL DISMOI('F','NOM_NUME_DDL',MASSE,'MATR_ASSE',IBID,NUMEM,IRET)
C
C     --- CHAM NO ---
C
      CALL GETVID (' ', 'CHAM_NO', 0,1,1, CHAMNO, N1 )
      CALL JELIRA ( CHAMNO//'.VALE', 'TYPE', IBID, TYPRES )
      IF ( TYPMAT .NE. TYPRES ) THEN
         CALL UTDEBM('F','OP0156','PAS DE PRODUIT CAR LES VALEURS ')
         CALL UTIMPK('S','DE LA MATRICE SONT ',1,TYPMAT)
         CALL UTIMPK('S','ET CELLES DU CHAM_NO SONT ',1,TYPRES)
         CALL UTFINM ( )
      ENDIF
      CRCHNO = .FALSE.
      CALL JEVEUO ( CHAMNO//'.REFE', 'L', IAREFE )
      PRNO = ZK24(IAREFE-1+2)(1:19)
      CALL JEEXIN ( PRNO//'.NEQU', IRET )
      IF ( IRET .EQ. 0 ) THEN
         CHAMN2 = '&&OP0156.CHAM_NO'
         CALL VTCREB ( CHAMN2, NUMEM, 'V', TYPRES, NEQ )
         CALL VTCOPY ( CHAMNO, CHAMN2, IRET )
         CHAMNO = CHAMN2
         CRCHNO = .TRUE.
      ENDIF
      CALL DISMOI('F','NOM_NUME_DDL',CHAMNO,'CHAM_NO',IBID,NUMEC,IRET)
      IF ( NUMEM .NE. NUMEC ) THEN
         CHAMN2 = '&&OP0156.CHAM_NO'
         CALL VTCREB ( CHAMN2, NUMEM, 'V', TYPRES, NEQ )
         CALL VTCOPY ( CHAMNO, CHAMN2, IRET )
         CHAMNO = CHAMN2
         CRCHNO = .TRUE.
      ENDIF
      CALL JEVEUO ( CHAMNO//'.VALE', 'L', JCHIN )
C
C     --- CREATION DU CHAM_NO RESULTAT ---
C
      CALL JEEXIN ( RESU//'.VALE', IRET )
      IF ( IRET .NE. 0 ) THEN
         CALL UTMESS('F','OP0156',' PAS DE PRODUIT CAR LE CHAM_NO '//
     +                              RESU(1:8)//' EXISTE DEJA.' )
      ENDIF
      CALL VTCREB ( RESU, NUMEM, 'G', TYPRES, NEQ )
      CALL JEVEUO ( RESU//'.VALE', 'E', JCHOUT )
C
      IF ( TYPRES .EQ. 'R' ) THEN
         CALL MRMULT ( 'ZERO', LMAT, ZR(JCHIN), TYPRES, ZR(JCHOUT), 1 )
      ELSEIF ( TYPRES .EQ. 'C' ) THEN
         CALL MCMULT ( 'ZERO', LMAT, ZC(JCHIN), TYPRES, ZC(JCHOUT), 1 )
      ENDIF
C
      IF ( CRCHNO ) THEN
         CALL JEDETR ( CHAMN2//'.DESC' )
         CALL JEDETR ( CHAMN2//'.REFE' )
         CALL JEDETR ( CHAMN2//'.VALE' )
      ENDIF
C
      CALL TITRE()
C
      CALL JEDEMA()
      END
