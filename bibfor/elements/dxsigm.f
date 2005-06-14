      SUBROUTINE DXSIGM (NOMTE,OPTION,XYZL,PGL,IC,INIV,DEPL,SIGM)
      IMPLICIT  NONE
      INTEGER            IC,INIV
      REAL*8             XYZL(3,1),PGL(3,1),DEPL(1),SIGM(1)
      CHARACTER*16       NOMTE, OPTION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/01/2004   AUTEUR CIBHHLV L.VIVAN 
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
C --- CONTRAINTES D'ORIGINE MECANIQUE AUX POINTS DE CALCUL
C --- POUR LES ELEMENTS COQUES A FACETTES PLANES :
C --- DST, DKT, DSQ, DKQ, Q4G
C     ------------------------------------------------------------------
C     IN  NOMTE        : NOM DU TYPE D'ELEMENT
C     IN  OPTION       : NOM DE L'OPTION
C     IN  XYZL(3,NNO)  : COORDONNEES DES CONNECTIVITES DE L'ELEMENT
C                        DANS LE REPERE LOCAL DE L'ELEMENT
C     IN  PGL(3,3)     : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
C                        LOCAL
C     IN  IC           : NUMERO DE LA COUCHE
C     IN  INIV         : NIVEAU DANS LA COUCHE (-1:INF , 0:MOY , 1:SUP)
C     IN  DEPL(1)      : VECTEUR DES DEPLACEMENTS AUX NOEUDS
C     OUT SIGM(1)      : CONTRAINTES D'ORIGINE MECANIQUE
C                        AUX POINTS DE CALCUL
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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

C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER       MULTIC, JMATE
      LOGICAL       GRILLE
      CHARACTER*2   CODRET(56)
      CHARACTER*10  PHENOM
C     ------------------------------------------------------------------

      CALL JEVECH('PMATERC','L',JMATE)
      CALL RCCOMA(ZI(JMATE),'ELAS',PHENOM,CODRET)

      IF ((PHENOM.EQ.'ELAS') .OR. (PHENOM.EQ.'ELAS_COQMU').OR.
     + (PHENOM.EQ.'ELAS_COQUE')) THEN

        IF (NOMTE(1:8).EQ.'MEGRDKT ') THEN
          GRILLE = .TRUE.
        ELSE
          GRILLE = .FALSE.
        END IF
        IF (NOMTE(1:8).EQ.'MEDKTR3 ' .OR. NOMTE(1:8).EQ.'MEGRDKT '.OR.
     +      NOMTE(1:8).EQ.'MEDKTG3 ' ) THEN
          CALL DKTCOL(NOMTE,XYZL,OPTION,PGL,IC,INIV,DEPL,SIGM,MULTIC,
     +                GRILLE)
        ELSE IF (NOMTE(1:8).EQ.'MEDSTR3 ') THEN
          CALL DSTCOL(NOMTE,XYZL,OPTION,PGL,IC,INIV,DEPL,SIGM)
        ELSE IF (NOMTE(1:8).EQ.'MEDKQU4 ' .OR.
     +           NOMTE(1:8).EQ.'MEDKQG4 ') THEN
          CALL DKQCOL(NOMTE,XYZL,OPTION,PGL,IC,INIV,DEPL,SIGM)
        ELSE IF (NOMTE(1:8).EQ.'MEDSQU4 ') THEN
          CALL DSQCOL(NOMTE,XYZL,OPTION,PGL,IC,INIV,DEPL,SIGM)
        ELSE IF (NOMTE(1:8).EQ.'MEQ4QU4 ') THEN
          CALL Q4GCOL(NOMTE,XYZL,OPTION,PGL,IC,INIV,DEPL,SIGM)
        ELSE
          CALL UTMESS('F','DXSIGM','LE TYPE D''ELEMENT : '//NOMTE(1:8)//
     +                'N''EST PAS PREVU.')
        END IF
      ELSE
        CALL UTMESS('A','DXSIGM',
     +           'LE TYPE DE COMPORTEMENT :   '
     +              //PHENOM(1:10)//'N''EST PAS PREVU.')
      END IF

      END
