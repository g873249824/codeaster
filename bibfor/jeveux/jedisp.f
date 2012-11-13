      SUBROUTINE JEDISP ( N , TAB )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 13/11/2012   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE LEFEBVRE J-P.LEFEBVRE
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
      IMPLICIT NONE
      INCLUDE 'jeveux_private.h'
      INTEGER             N , TAB(*)
C ----------------------------------------------------------------------
C RENVOIE DANS LE TABLEAU TAB LES LONGUEURS MAX DISPONIBLES DANS LA
C PARTITION MEMOIRE NUMERO 1
C
C IN  N      : TAILLE DU TABLEAU TAB
C IN  TAB    : TAILLE DE SEGMENT DE VALEURS DISPONIBLE
C
C SI L'ALLOCATION DYNAMIQUE EST UTILISEE LA ROUTINE RENVOIE L'ENTIER
C MAXIMUM DANS LES N VALEURS DU TABLEAU TAB
C
C
C ----------------------------------------------------------------------
      INTEGER          LK1ZON , JK1ZON , LISZON , JISZON 
      COMMON /IZONJE/  LK1ZON , JK1ZON , LISZON , JISZON
C ----------------------------------------------------------------------
      INTEGER          LBIS , LOIS , LOLS , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOR8 , LOC8
      INTEGER          ISTAT
      COMMON /ISTAJE/  ISTAT(4)
      INTEGER          LDYN , LGDYN , NBDYN , NBFREE
      COMMON /IDYNJE/  LDYN , LGDYN , NBDYN , NBFREE
      REAL *8         MXDYN, MCDYN, MLDYN, VMXDYN, VMET, LGIO
      COMMON /R8DYJE/ MXDYN, MCDYN, MLDYN, VMXDYN, VMET, LGIO(2)
C ----------------------------------------------------------------------
      INTEGER          K
C
C DEB ------------------------------------------------------------------
      DO 1 K = 1,N
         TAB(K) = 0
 1    CONTINUE
C
C --- ON DONNE LA VALEUR ASSOCIEE A LA MEMOIRE DYNAMIQUE DISPONIBLE
C
      IF ( LDYN .EQ. 1 ) THEN
        TAB(1) = NINT((VMXDYN-MCDYN)/LOIS)
      ENDIF
C FIN-------------------------------------------------------------------
      END
