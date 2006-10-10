      SUBROUTINE JXLIR1 (IC , CARALU )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 10/10/2006   AUTEUR VABHHTS J.PELLET 
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
C TOLE CRP_6
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER             IC , CARALU(*)
C ----------------------------------------------------------------------
C RELECTURE DU PREMIER ENREGISTREMENT D UNE BASE JEVEUX
C ROUTINE AVEC ADHERENCE SYSTEME    CRAY
C                                   OPENDR READDR CLOSDR
C
C IN  IC    : CLASSE ASSOCIEE
C OUT CARALU: CARACTERISTIQUES DE LA BASE
C ----------------------------------------------------------------------
      INTEGER          N
      PARAMETER      ( N = 5 )
      CHARACTER*2      DN2
      CHARACTER*5      CLASSE
      CHARACTER*8                  NOMFIC    , KSTOUT    , KSTINI
      COMMON /KFICJE/  CLASSE    , NOMFIC(N) , KSTOUT(N) , KSTINI(N) ,
     &                 DN2(N)
      CHARACTER*8      NOMBAS
      COMMON /KBASJE/  NOMBAS(N)
      INTEGER          LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
      COMMON /IENVJE/  LBIS , LOIS , LOLS , LOUA , LOR8 , LOC8
C     ------------------------------------------------------------------
      INTEGER          LINDEX , NPAR
      PARAMETER      ( LINDEX = 11, NPAR = 11, NP2 = NPAR+3 )
      INTEGER          INDEX(LINDEX),TAMPON(NP2)
      LOGICAL          LEXIST
      CHARACTER*8      NOM
C DEB ------------------------------------------------------------------
      IERR = 0
      NOM = NOMFIC(IC)(1:4)//'.   '
      CALL CODENT(1,'G',NOM(6:7))
      INQUIRE (FILE=NOM,EXIST=LEXIST)
      IF ( .NOT. LEXIST) THEN
        CALL U2MESK('F','JEVEUX_12',1,NOMBAS(IC))
      ENDIF
      CALL OPENDR ( NOM , INDEX , LINDEX , 0 , IERR )
C
C   SUR CRAY L'APPEL A READDR EST EFFECTUE AVEC UNE LONGUEUR EN
C   ENTIER, A MODIFIER LORSQUE L'ON PASSERA AUX ROUTINES C
C
      CALL READDR ( NOM , TAMPON, NP2*LOIS/LOUA , 1 , IERR )
      IF ( IERR .NE. 0 ) THEN
         CALL U2MESK('F','JEVEUX_13',1,NOMBAS(IC))
      ENDIF
      CALL CLOSDR ( NOM , IERR )
      IF ( IERR .NE. 0 ) THEN
         CALL U2MESK('F','JEVEUX_14',1,NOMBAS(IC))
      ENDIF
      DO 1 K=1,NPAR
        CARALU(K) = TAMPON(K+3)
 1    CONTINUE
C FIN ------------------------------------------------------------------
      END
