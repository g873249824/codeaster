      SUBROUTINE DXELAS(OPTION,NOMTE,DEPL,VECLOC,MATLOC,EFFINT,CODRET)
      IMPLICIT  NONE 
      INTEGER      CODRET
      REAL*8       DEPL(24), VECLOC(24), MATLOC(300), EFFINT(32)
      CHARACTER*16 OPTION, NOMTE
C     ------------------------------------------------------------------
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
C     CALCUL POUR LES ELEMENTS DE PLAQUE DKT, DST, DKQ, DSQ ET Q4G,
C     POUR UN COMPORTEMENT ELASTIQUE LINEAIRE 
C            .DU VECTEUR DES EFFORTS INTERNES VECLOC
C            .DE LA MATRICE DE RIGIDITE MATLOC
C            .DU VECTEUR DES EFFORTS GENERALISES EFFINT 
C     DANS LE REPERE LOCAL A L'ELEMENT
C
C           SI OPTION = 'FULL_MECA', CALCUL DE
C                   .MATLOC
C                   .VECLOC
C                   .EFFINT
C
C           SI OPTION = 'RAPH_MECA', CALCUL DE
C                   .VECLOC
C                   .EFFINT
C
C           SI OPTION = 'RIGI_MECA_TANG', CALCUL DE
C                   .MATLOC
C
C
C     IN   K16   OPTION     : OPTION (FAUSSEMENT) NON LINEAIRE TRAITEE
C                             I.E. 'FULL_MECA'
C                             OU   'RAPH_MECA'
C                             OU   'RIGI_MECA_TANG'
C
C     IN   K16   NOMTE      : NOM DU TYPE DE L'ELEMENT
C
C     IN   R8    DEPL(24)   : VECTEUR DES DEPLACEMENTS NODAUX
C
C     OUT  R8    VECLOC(24) : VECTEUR DES EFFORTS INTERNES 
C                             BT*SIGMA
C
C     OUT  R8   MATLOC(300) : MATRICE DE RIGIDITE ELEMENTAIRE
C                             MATLOC DE TAILLE 300 CAR
C     ---> POUR DKT/DST MATELEM = 3 * 6 DDL = 171 TERMES STOCKAGE SYME
C     ---> POUR DKQ/DSQ MATELEM = 4 * 6 DDL = 300 TERMES STOCKAGE SYME
C
C     OUT  R8   EFFINT(32) : VECTEUR DES EFFORTS GENERALISES
C     ---> POUR DKT/DST EFFINT = 24
C     ---> POUR DKQ/DSQ EFFINT = 32
C
C     ------------------------------------------------------------------
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
      INTEGER   LZR, NNO, JGEOM
      REAL*8    PGL(3,3),XYZL(3,4),VECLO1(24)
C     ------------------------------------------------------------------
C
      CODRET = 0
C
      CALL JEVECH('PGEOMER','L',JGEOM)
C
      IF (NOMTE(1:8).EQ.'MEDKTR3 ' .OR. NOMTE(1:8).EQ.'MEDSTR3 ' .OR.
     +    NOMTE(1:8).EQ.'MEGRDKT'  .OR. NOMTE(1:8).EQ.'MEDKTG3 ') THEN
         NNO = 3
         CALL DXTPGL(ZR(JGEOM),PGL)

      ELSE IF (NOMTE(1:8).EQ.'MEDKQU4 ' .OR.
     +         NOMTE(1:8).EQ.'MEDKQG4 ' .OR.
     +         NOMTE(1:8).EQ.'MEDSQU4 ' .OR.
     +         NOMTE(1:8).EQ.'MEQ4QU4 ') THEN
        NNO = 4
        CALL DXQPGL(ZR(JGEOM),PGL)

      ELSE
          CALL UTMESS('F','DXELAS','LE TYPE D''ELEMENT : '//NOMTE(1:8)//
     +                'N''EST PAS PREVU.')
      END IF
C
      CALL JEVETE('&INEL.'//NOMTE(1:8)//'.DESR','L',LZR)
C
C ---  CALCUL DES COORDONNEES LOCALES DES CONNECTIVITES :
C      ------------------------------------------------
      CALL UTPVGL(NNO,3,PGL,ZR(JGEOM),XYZL)
C
C ---  CALCUL DE LA MATRICE DE RIGIDITE ELASTIQUE LOCALE :
C      =================================================
      IF (OPTION.EQ.'FULL_MECA'.OR.OPTION.EQ.'RIGI_MECA_TANG') THEN
        CALL DXRIG(NOMTE, MATLOC)
C
C ---  CALCUL DES EFFORTS GENERALISES LOCAUX ET 
C ---  DES EFFORTS INTERNES LOCAUX :
C      ===========================
      ELSEIF (OPTION.EQ.'FULL_MECA'.OR.OPTION.EQ.'RAPH_MECA') THEN
        CALL DXEFIN(NOMTE, DEPL, EFFINT)
        CALL DXBSIG(NOMTE, XYZL, PGL, EFFINT, VECLO1)
C
C ---    ON REMET VECLOC DANS LE REPERE LOCAL :
C        ------------------------------------
        CALL UTPVGL(NNO,6,PGL,VECLO1,VECLOC)
C
      ENDIF
C
      END
