      SUBROUTINE UTCH19(CHAM19,NOMMA,NOMAIL,NONOEU,NUPO,NUSP,IVARI,
     &                  NOCMP,TYPRES,VALR,VALC,IER)
      IMPLICIT   NONE
      INTEGER NUPO,IVARI,IER,NUSP
      REAL*8 VALR
      COMPLEX*16 VALC
      CHARACTER*(*) CHAM19,NOMMA,NOMAIL,NONOEU,NOCMP,TYPRES
C ----------------------------------------------------------------------
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C     EXTRAIRE UNE VALEUR DANS UN CHAM_ELEM.
C ----------------------------------------------------------------------
C IN  : CHAM19 : NOM DU CHAM_ELEM DONT ON DESIRE EXTRAIRE 1 COMPOSANTE
C IN  : NOMMA  : NOM DU MAILLAGE
C IN  : NOMAIL : NOM DE LA MAILLE A EXTRAIRE
C IN  : NONOEU : NOM D'UN NOEUD (POUR LES CHAM_ELEM "AUX NOEUDS").
C                  (SI CE NOM EST BLANC : ON UTILISE NUPO)
C IN  : NUPO   : NUMERO DU POINT A EXTRAIRE SUR LA MAILLE NOMAIL
C IN  : NUSP   : NUMERO DU SOUS_POINT A TESTER SUR LA MAILLE NOMAIL
C                (SI NUSP=0 : IL N'Y A PAS DE SOUS-POINT)
C IN  : IVARI  : NUMERO DE LA CMP (POUR VARI_R)
C IN  : NOCMP : NOM DU DDL A EXTRAIRE SUR LE POINT NUPO
C IN  : TYPRES : TYPE DU CHAMP ET DU RESULTAT (R/C).
C OUT : VALR   : VALEUR REELLE EXTRAITE SUR LE DDL DU POINT.
C OUT : VALC   : VALEUR COMPLEXE EXTRAITE SUR LE DDL DU POINT.
C OUT : IER    : CODE RETOUR.
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
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------

      INTEGER IBID,IDDL,IAVALE
      REAL*8 R8VIDE
      CHARACTER*1 TYPREZ
      CHARACTER*4 TYPE
      CHARACTER*19 CHM19Z
C     ------------------------------------------------------------------

      CALL JEMARQ()
      IER = 0

      CHM19Z = CHAM19(1:19)
      TYPREZ = TYPRES(1:1)
      CALL JELIRA(CHM19Z//'.CELV','TYPE',IBID,TYPE)

      IF (TYPE.NE.TYPREZ) CALL U2MESS('F','CALCULEL_13')

      IF (TYPE.NE.'R' .AND. TYPE.NE.'C')
     &  CALL U2MESK('E','UTILITAI5_29',1,TYPE)

      CALL UTCHDL(CHAM19,NOMMA,NOMAIL,NONOEU,NUPO,NUSP,IVARI,NOCMP,IDDL)

C     SI TEST_RESU, IDDL PEUT ETRE = 0 :
      IF (IDDL.EQ.0) THEN
         IER=1
         VALR=R8VIDE()
         VALC=DCMPLX(R8VIDE(),R8VIDE())
         GO TO 10
      END IF

      CALL JEVEUO(CHM19Z//'.CELV','L',IAVALE)
      IF (TYPREZ.EQ.'R') THEN
        VALR = ZR(IAVALE-1+IDDL)
      ELSE IF (TYPREZ.EQ.'C') THEN
        VALC = ZC(IAVALE-1+IDDL)
      END IF

   10 CONTINUE
      CALL JEDEMA()
      END
