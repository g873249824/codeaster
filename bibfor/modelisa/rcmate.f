      SUBROUTINE RCMATE ( CHMAT, NOMAIL, MXMATA, NBAPNO, NOMODE )
      IMPLICIT   NONE
      INTEGER             MXMATA, NBAPNO
      CHARACTER*8         CHMAT, NOMAIL, NOMODE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 16/07/2002   AUTEUR VABHHTS J.PELLET 
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
      INTEGER       IBID, NOCC, I, NM, NT, JNCMP, JVALV, NBMA, NBNO,
     +              JMAIL, JNOEU
      CHARACTER*4   OUI
      CHARACTER*8   K8B, NOMMAT, TYPMCL(4)
      CHARACTER*16  MOTCLE(4)
      CHARACTER*24  CHAMAT, LIGRMO, MESMAI, MESNOE
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CHAMAT = CHMAT//'.CHAMP_MAT'
C
      LIGRMO = NOMODE//'.MODELE         '
C
      CALL ALCART ( 'G', CHAMAT, NOMAIL, 'MATE_F', NBAPNO, MXMATA )
C
      CALL JEVEUO ( CHAMAT(1:19)//'.NCMP', 'E', JNCMP )
      CALL JEVEUO ( CHAMAT(1:19)//'.VALV', 'E', JVALV )
C
      ZK8(JNCMP) = 'MATE'
C
      CALL GETFAC ( 'AFFE' , NOCC )
C
      MOTCLE(1) = 'GROUP_MA'
      MOTCLE(2) = 'MAILLE'
      MOTCLE(3) = 'GROUP_NO'
      MOTCLE(4) = 'NOEUD'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'
      TYPMCL(3) = 'GROUP_NO'
      TYPMCL(4) = 'NOEUD'
C
      MESMAI = '&&RCMATE.MES_MAILLES'
      MESNOE = '&&RCMATE.MES_NOEUDS'
C
      DO 10 I = 1 , NOCC
C
         CALL GETVID ( 'AFFE', 'MATER' , I,1,1, NOMMAT, NM )
         ZK8(JVALV) = NOMMAT
C
         CALL GETVTX ( 'AFFE', 'TOUT'  , I,1,1, OUI   , NT )

         IF ( NT .NE. 0 ) THEN
            CALL NOCART ( CHAMAT, 1, K8B, K8B, 0, K8B, IBID, ' ', 1 )
C
         ELSE
            CALL RELIEM(NOMODE,NOMAIL,'NU_MAILLE','AFFE',I,2,MOTCLE(1),
     +                                      TYPMCL(1), MESMAI, NBMA )
            CALL RELIEM(NOMODE,NOMAIL,'NU_NOEUD','AFFE',I, 2,MOTCLE(3),
     +                                      TYPMCL(3), MESNOE, NBNO )
C
            IF ( NBMA .NE. 0 ) THEN
               CALL JEVEUO ( MESMAI, 'L', JMAIL )
               CALL NOCART ( CHAMAT, 3, K8B, 'NUM', NBMA, K8B,
     +                                              ZI(JMAIL), ' ', 1 )
               CALL JEDETR ( MESMAI )
            ENDIF
C
            IF ( NBNO .NE. 0 ) THEN
               CALL JEVEUO ( MESNOE, 'L', JNOEU )
               CALL NOCART ( CHAMAT, -3, K8B, 'NUM', NBNO, K8B,
     +                                           ZI(JNOEU), LIGRMO, 1 )
               CALL JEDETR ( MESNOE )
            ENDIF
         ENDIF
C
 10   CONTINUE
C
      CALL JEDETR ( CHAMAT(1:19)//'.VALV' )
      CALL JEDETR ( CHAMAT(1:19)//'.NCMP' )
C
      CALL JEDEMA()
      END
