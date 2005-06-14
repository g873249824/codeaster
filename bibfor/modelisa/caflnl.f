      SUBROUTINE CAFLNL ( CHAR, LIGRMO, NBCA, NBET, NOMA )
      IMPLICIT NONE
      INTEGER             NBCA, NBET
      CHARACTER*8         CHAR, NOMA
      CHARACTER*(*)       LIGRMO
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 17/11/2003   AUTEUR VABHHTS J.PELLET 
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
C BUT : STOCKAGE DES FLUX NON LINEAIRE  DANS UNE CARTE ALLOUEE SUR LE
C       LIGREL DU MODELE
C
C ARGUMENTS D'ENTREE:
C      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
C      LIGRMO : NOM DU LIGREL DE MODELE
C      NBCA   : NOMBRE D'APPEL A NOCART
C      NBET   : NOMBRE TOTAL DE MAILLES
C      NOMA   : NOM DU MAILLAGE
C      NDIM   : DIMENSION DU PROBLEME (2D OU 3D)
C      FONREE : FONC OU REEL
C
C-----------------------------------------------------------------------
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
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      INTEGER       NFLUX, JVALV, JNCMP,NF, IOCC, NBTOU, NBMA,JMA, NCMP
      CHARACTER*8   K8B, TYPMCL(2)
      CHARACTER*16  MOTCLF, MOTCLE(2)
      CHARACTER*19  CARTE
      CHARACTER*24  MESMAI
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      MOTCLF = 'FLUX_NL'
      CALL GETFAC ( MOTCLF , NFLUX )
C
      CARTE = CHAR//'.CHTH.FLUNL'
      CALL ALCART ( 'G', CARTE, NOMA, 'FLUN_F', NBCA+1, NBET )
      CALL JEVEUO ( CARTE//'.NCMP', 'E', JNCMP )
      CALL JEVEUO ( CARTE//'.VALV', 'E', JVALV )
C
C --- STOCKAGE DE FLUX NULS SUR TOUT LE MAILLAGE
C
      NCMP = 3
      ZK8(JNCMP-1+1) = 'FLUN'
      ZK8(JNCMP-1+2) = 'FLUN_INF'
      ZK8(JNCMP-1+3) = 'FLUN_SUP'
      ZK8(JVALV-1+1) = '&FOZERO'
      ZK8(JVALV-1+2) = '&FOZERO'
      ZK8(JVALV-1+3) = '&FOZERO'
      CALL NOCART ( CARTE, 1, ' ', 'NOM', 0, ' ', 0, LIGRMO, NCMP)
C
      MESMAI = '&&CAFLNL.MES_MAILLES'
      MOTCLE(1) = 'GROUP_MA'
      MOTCLE(2) = 'MAILLE'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'MAILLE'
C
C --- STOCKAGE DANS LES CARTES
C
      DO 10 IOCC = 1, NFLUX
C
         CALL GETVID ( MOTCLF, 'FLUN', IOCC,1,1, ZK8(JVALV), NF )
C
         CALL GETVTX ( MOTCLF, 'TOUT', IOCC, 1, 1, K8B, NBTOU )
         IF ( NBTOU .NE. 0 ) THEN
            CALL NOCART (CARTE,1,' ','NOM',0,' ', 0,LIGRMO,NCMP)
C
         ELSE
            CALL RELIEM(LIGRMO, NOMA, 'NU_MAILLE', MOTCLF, IOCC, 2,
     +                                  MOTCLE, TYPMCL, MESMAI, NBMA )
            CALL JEVEUO ( MESMAI, 'L', JMA )
            CALL NOCART ( CARTE,3,K8B,'NUM',NBMA,K8B,ZI(JMA),' ',NCMP)
            CALL JEDETR ( MESMAI )
         ENDIF
C
 10   CONTINUE
C
      CALL TECART(CARTE)
      CALL JEDEMA()
C
      END
