      SUBROUTINE RCTREF ( CHMAT, NOMAIL, NOMODE )
      IMPLICIT   NONE
      CHARACTER*8         CHMAT, NOMAIL, NOMODE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 16/10/2007   AUTEUR SALMONA L.SALMONA 
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
C
C  IN : CHMAT  : CHAMP MATERIAU PRODUIT
C  IN : NOMAIL : NOM DU MAILLAGE
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
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C ----------------------------------------------------------------------
C
      INTEGER       IBID, NOCC, I, NM, NT, JNCMP, JVALV, NBMA, JMAIL
      REAL*8        TREF, R8VIDE
      CHARACTER*4   OUI
      CHARACTER*8   K8B, TYPMCL(2)
      CHARACTER*16  MOTCLE(2)
      CHARACTER*24  CHTREF,  MESMAI
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CHTREF = CHMAT//'.TEMPE_REF'
C
C
      CALL ALCART ( 'G', CHTREF, NOMAIL, 'TEMP_R' )
C
      CALL JEVEUO ( CHTREF(1:19)//'.NCMP', 'E', JNCMP )
      CALL JEVEUO ( CHTREF(1:19)//'.VALV', 'E', JVALV )
C
      ZK8(JNCMP  ) = 'TEMP'
C
      CALL GETFAC ( 'AFFE' , NOCC )
C
      MOTCLE(1) = 'GROUP_MA'
      MOTCLE(2) = 'MAILLE'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'
C
      MESMAI = '&&RCTREF.MES_MAILLES'
C
      DO 10 I = 1 , NOCC
         CALL GETVR8 ( 'AFFE', 'TEMP_REF', I,1,1, TREF, NM )
         IF ( NM .NE. 0 ) THEN
            ZR(JVALV) = TREF
         ELSE
            ZR(JVALV) = R8VIDE()
         ENDIF

         CALL GETVTX ( 'AFFE', 'TOUT'  , I,1,1, OUI   , NT )

         IF ( NT .NE. 0 ) THEN
            CALL NOCART ( CHTREF, 1, K8B, K8B, 0, K8B, IBID, ' ', 1 )
         ELSE
            CALL RELIEM(NOMODE, NOMAIL, 'NU_MAILLE', 'AFFE', I, 2,
     +                    MOTCLE(1), TYPMCL(1), MESMAI, NBMA )
            IF ( NBMA .NE. 0 ) THEN
               CALL JEVEUO ( MESMAI, 'L', JMAIL )
               CALL NOCART ( CHTREF, 3, K8B, 'NUM', NBMA, K8B,
     +                                           ZI(JMAIL), ' ', 1 )
               CALL JEDETR ( MESMAI )
            ENDIF
         ENDIF
C
 10   CONTINUE
C
      CALL JEDETR ( CHTREF(1:19)//'.VALV' )
      CALL JEDETR ( CHTREF(1:19)//'.NCMP' )
C
      CALL JEDEMA()
      END
