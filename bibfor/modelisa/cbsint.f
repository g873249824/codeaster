      SUBROUTINE CBSINT ( CHAR, NOMA, LIGRMO, NDIM, FONREE )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'

      INTEGER           NDIM
      CHARACTER*4       FONREE
      CHARACTER*8       CHAR, NOMA
      CHARACTER*(*)     LIGRMO
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     ------------------------------------------------------------------
C
C BUT : STOCKAGE DES CHARGES DE DEFORMATIONS INITIALES REPARTIES
C       DANS UNE CARTE ALLOUEE SUR LE LIGREL DU MODELE
C
C ARGUMENTS D'ENTREE:
C      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
C      LIGRMO : NOM DU LIGREL DE MODELE
C      NOMA   : NOM DU MAILLAGE
C      FONREE : FONC OU REEL
C      PARAM  : NOM DU TROISIEME CHAMP DE LA CARTE (EPSIN)
C      MOTCL  : MOT-CLE FACTEUR
C
C-----------------------------------------------------------------------
C
      INTEGER       NBFAC
      CHARACTER*5   PARAM
      INTEGER       IBID, NCHEI, NCMP, JVALV, JNCMP
      CHARACTER*16  MOTCLF
      CHARACTER*19  CARTE
      CHARACTER*24  CHSIG
      INTEGER      IARG
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      IF (FONREE.EQ.'REEL') THEN
          MOTCLF = 'PRE_SIGM'
          CALL GETFAC ( 'PRE_SIGM' , NBFAC )
C
          IF ( NBFAC.NE.0 ) THEN
             PARAM = 'SIINT'

             CALL GETFAC ( 'PRE_SIGM' , NCHEI )
C
             CARTE  = CHAR//'.CHME.'//PARAM
C
C ---        MODELE ASSOCIE AU LIGREL DE CHARGE
C
             CALL ALCART ( 'G', CARTE , NOMA , 'NEUT_K8')
             CALL JEVEUO ( CARTE//'.NCMP', 'E', JNCMP )
             CALL JEVEUO ( CARTE//'.VALV', 'E', JVALV )
C
             NCMP = 1
             ZK8(JNCMP-1+1) = 'Z1'
             CALL GETVID ( MOTCLF, 'SIGM', 1,IARG,1, CHSIG, IBID )
             ZK8(JVALV-1+1) = CHSIG
             CALL NOCART (CARTE, 1, ' ', 'NOM', 0, ' ',0, LIGRMO, NCMP)
C
          ENDIF
      ENDIF
      CALL JEDEMA()
      END
