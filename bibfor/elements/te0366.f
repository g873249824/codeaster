       SUBROUTINE TE0366(OPTION,NOMTE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/08/2009   AUTEUR MEUNIER S.MEUNIER 
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
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE
C
C ----------------------------------------------------------------------
C  CONTACT XFEM GRANDS GLISSEMENTS
C  CALCUL DES MATRICES DE CONTACT ET DE FROTTEMENT
C
C  OPTION : 'RIGI_CONT' (CALCUL DES MATRICES DE CONTACT )
C           'RIGI_FROT' (CALCUL DES MATRICES DE FROTTEMENT)
C
C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
C
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
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------
C
      CHARACTER*8   TYPMA,ESC,MAIT,ELC
      INTEGER      NDIM,NDDL,NNE,NNES,NNM,NNC
      INTEGER      JPCPO,JPCPI,JPCAI,JPCCF
      INTEGER      IGEOM,IDEPL,IDEPM
      INTEGER      INDCO,INDNOR,IFROTT,NFAES
      INTEGER      IMATT
      REAL*8       COEFCA,LAMBDA,COEFFF,COEFFA,HPG
      REAL*8       TAU1(3),TAU2(3),NORM(3)
      REAL*8       MMAT(120,120)
      REAL*8       FFPC(8),DFFPC(3,3),JACOBI,COORE(3),COORM(3)
      REAL*8       FFES(8),FFMA(8),GEOPI(9),COOR(2)
      REAL*8       DPLM(3),DPLE(6),MPROJ(3,3),RESE(3)
      REAL*8       NOOR,R8PREM,NRESE
      INTEGER      INADH,NVIT
      INTEGER      I,J,IJ,IN,PL,IBID
      INTEGER      CFACE(5,3),XOULA
      LOGICAL      MALIN
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INFOS SUR LA MAILLE DE CONTACT
C
      CALL XMELET(NOMTE,TYPMA,ESC,MAIT,ELC,
     &            NDIM,NDDL,NNE,NNM,NNC,MALIN)
      CALL ASSERT (NDDL.LE.120)
C
C --- INITIALISATIONS
C
      CALL LCINVN(9,0.D0,GEOPI)
C --- INITIALISATION DE LA MATRICE DE TRAVAIL
      CALL MATINI(NDDL,NDDL,0.D0,MMAT)
C
C --RECUPERATION DES DONNEES DE LA CARTE CONTACT 'POINT' (VOIR XMCART)
C
      CALL JEVECH('PCAR_PT','L',JPCPO)
C --- LES COORDONNEES ESCLAVE DANS L'ELEMENT DE CONTACT
      COOR(1) = ZR(JPCPO-1+1)
      COOR(2) = ZR(JPCPO-1+10)
      TAU1(1)  = ZR(JPCPO-1+4)
      TAU1(2)  = ZR(JPCPO-1+5)
      TAU1(3)  = ZR(JPCPO-1+6)
      TAU2(1)  = ZR(JPCPO-1+7)
      TAU2(2)  = ZR(JPCPO-1+8)
      TAU2(3)  = ZR(JPCPO-1+9)
      INDCO    = NINT(ZR(JPCPO-1+11))
      LAMBDA   = ZR(JPCPO-1+12)
      COEFCA   = ZR(JPCPO-1+13)
      COEFFA   = ZR(JPCPO-1+14)
      COEFFF   = ZR(JPCPO-1+15)
      IFROTT   = NINT(ZR(JPCPO-1+16))
      INDNOR   = NINT(ZR(JPCPO-1+17))
      HPG      = ZR(JPCPO-1+19)
C --- LE NUMERO DE LA FACETTE DE CONTACT ESCLAVE
      NFAES    = NINT(ZR(JPCPO-1+22))
C --- LES COORDONNEES ESCLAVE ET MAITRES DANS L'ELEMENT PARENT
      COORE(1)  = ZR(JPCPO-1+24)
      COORE(2)  = ZR(JPCPO-1+25)
      COORE(3)  = ZR(JPCPO-1+26)
      COORM(1)  = ZR(JPCPO-1+27)
      COORM(2)  = ZR(JPCPO-1+28)
      COORM(3)  = ZR(JPCPO-1+29)
C --- POINT D'INTEGRATION VITAL OU PAS
      NVIT      = ZR(JPCPO-1+30)
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT PINTER (VOIR XMCART)
C
      CALL JEVECH('PCAR_PI','L',JPCPI)
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT AINTER (VOIR XMCART)
C
      CALL JEVECH('PCAR_AI','L',JPCAI)
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT CFACE (VOIR XMCART)
C
      CALL JEVECH('PCAR_CF','L',JPCCF)
C
C --- RECUPERATION DE LA GEOMETRIE ET DES CHAMPS DE DEPLACEMENT
C
      CALL JEVECH('PGEOMER','E',IGEOM)
      CALL JEVECH('PDEPL_P','E',IDEPL)
      CALL JEVECH('PDEPL_M','L',IDEPM)
C
C --- NOMBRE DE NOEUDS ESCLAVES SOMMETS
C
      IF (MALIN) THEN
C -- -ON EST EN LINEAIRE
        NNES=NNE
      ELSE
C --- ON EST EN QUADRATIQUE
        NNES=NNE/2
      ENDIF
C
C --- ON CONSTRUIT LA MATRICE DE CONNECTIVIT� CFACE (MAILLE ESCLAVE)
C --- CE QUI SUIT N'EST VALABLE QU'EN 2D POUR LA FORMULATION QUADRATIQUE
C --- EN 3D ON UTILISE SEULEMENT LA FORMULATION AUX NOEUDS SOMMETS,
C --- CETTE MATRICE EST DONC INUTILE, ON NE LA CONSTRUIT PAS !!!
C
      CFACE(1,1)=1
      CFACE(1,2)=2
C
C --- REACTUALISATION DE LA GEOMETRIE
C
      CALL XMREAC(NDIM,NNE,NNES,NNM,
     &            IGEOM,IDEPM)
C
C --- DERIVEES DES FONCTIONS DE FORMES POUR LE PT DE CONTACT DANS
C --- L'ELEMENT DE CONTACT
C
      CALL ELRFDF(ELC,COOR,NNC*NDIM,DFFPC,IBID,IBID)
C
C --- CALCUL DES COORDONN�ES R�ELES DES POINTS D'INTERSECTION ESCLAVES
C
      CALL XMPINT(ESC,NDIM,IGEOM,JPCPI,JPCCF,NFAES,NNES,
     &            GEOPI)
C
C --- JACOBIEN POUR LE POINT DE CONTACT
C
      CALL XMMJAC(ELC,GEOPI,DFFPC,
     &            JACOBI)
C
C --- FONCTIONS DE FORMES DU POINTS DE CONTACT DANS L'ELEMENT PARENT
C
      CALL ELRFVF(ESC,COORE,NNES,FFES,NNES)
C
C --- FONCTIONS DE FORMES DE LA PROJ DU PT DE CONTACT DANS L'ELE PARENT
C
      CALL ELRFVF(MAIT,COORM,NNM,FFMA,NNM)
C
C --- FONCTION DE FORMES POUR LES LAGRANGIENS
C --- SI ON EST EN LINEAIRE, ON IMPOSE QUE LE NB DE NOEUDS DE CONTACTS
C --- ET LES FFS LAGRANGES DE CONTACT SONT IDENTIQUES A CEUX
C --- DES DEPLACEMENTS DANS LA MAILLE ESCLAVE POUR LE CALCUL DES CONTRIB
C
      IF (MALIN) THEN
        NNC=NNE
        DO 50 I=1,NNE
          FFPC(I)=FFES(I)
 50     CONTINUE
      ELSE
        CALL ELRFVF(ELC,COOR,NNC,FFPC,NNC)
      ENDIF
C
C --- CALCUL DE LA NORMALE
C
      IF (NDIM.EQ.2) THEN
        CALL MMNORM(NDIM,TAU1,TAU2,NORM,NOOR)
      ELSEIF (NDIM.EQ.3) THEN
        CALL PROVEC(TAU1,TAU2,NORM)
        CALL NORMEV(NORM,NOOR)
      ENDIF
      IF (NOOR.LE.R8PREM()) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- NOEUDS EXCLUS PAR PROJECTION HORS ZONE
C
      IF (INDNOR .EQ. 1) THEN
        INDCO = 0
      ENDIF
C
C --- RECUPERATION DE LA MATRICE 'OUT' (A REMPLIR => MODE ECRITURE)
C
      CALL JEVECH('PMATUUR','E',IMATT)
C
C --- CALCUL DES MATRICES DE CONTACT
C
      IF (OPTION.EQ.'RIGI_CONT') THEN
        IF (INDCO.EQ.1) THEN
C
C --- CALCUL DES MATRICES A, AT, AU - CAS DU CONTACT
C
          CALL XMMAA1(NDIM,NNE,NNES,NNC,NNM,NFAES,CFACE,
     &                HPG,FFPC,FFES,FFMA,JACOBI,JPCAI,
     &                COEFCA,NORM,TYPMA,MMAT)
C
        ELSE IF (INDCO .EQ. 0) THEN
          IF (NVIT.EQ.1) THEN
C
C --- CALCUL DE LA MATRICE C - CAS SANS CONTACT
C
            CALL XMMAA0(NDIM,NNC,NNE,NNES,HPG,NFAES,CFACE,
     &              FFPC,JACOBI,JPCAI,COEFCA,TYPMA,MMAT)
          ENDIF
        ELSE
C             SI INDCO N'EST NI EGAL A 0 NI EGAL A 1
          CALL U2MESS('F','DVP_98')
        ENDIF
C
      ELSEIF (OPTION.EQ.'RIGI_FROT') THEN
C              ---------------------
        IF (COEFFF.EQ.0.D0) INDCO = 0
        IF (LAMBDA.EQ.0.D0) INDCO = 0
        IF (IFROTT.NE.3)    INDCO = 0
C
        IF (INDCO.EQ.0) THEN
          IF (NVIT.EQ.1) THEN
C
C --- CALCUL DE LA MATRICE F - CAS SANS FROTTEMENT
C
            CALL XMMAB0(NDIM,NNC,NNE,NNES,NFAES,JPCAI,
     &                HPG,FFPC,JACOBI,TYPMA,CFACE,
     &                TAU1,TAU2,MMAT)
C
          ENDIF
        ELSE IF (INDCO.EQ.1) THEN
C
C --- RECUPERATION DES DEPLACEMENTS DU POINT DE CONTACT, DE SON PROJETE
C --- ET DES REACTIONS DE CONTACT
C
          CALL LCINVN(NDIM,0.D0,DPLM)
          CALL LCINVN(2*NDIM,0.D0,DPLE)
          DO 180 I = 1,NDIM
            DO 190 J = 1,NNES
              DPLE(I)  = DPLE(I)
     &         + FFES(J)*ZR(IDEPL+(J-1)*(3*NDIM)+I-1)
     &         - FFES(J)*ZR(IDEPL+(J-1)*(3*NDIM)+I-1+NDIM)
 190        CONTINUE
 180      CONTINUE
C
          DO 200 I = 1,NDIM
            DO 210 J = 1,NNM
              DPLM(I)  = DPLM(I)
     &         + FFMA(J)*ZR(IDEPL+NNES*3*NDIM+(NNE-NNES)*NDIM
     &                      +2*NDIM*(J-1)+I-1)
     &         + FFMA(J)*ZR(IDEPL+NNES*3*NDIM+(NNE-NNES)*NDIM
     &                      +2*NDIM*(J-1)+I-1+NDIM)
 210        CONTINUE
 200      CONTINUE
C
          DO 220 I=1,NDIM
            DO 230 J=1,NNC
C --- XOULA NE SERT PLUS A RIEN AVEC LA FORMULATION NOEUDS SOMMETS !!!
              IN=XOULA(CFACE,NFAES,J,JPCAI,TYPMA)
              CALL XPLMA2(NDIM,NNE,NNES,IN,PL)
              DPLE(NDIM+I)=DPLE(NDIM+I)+FFPC(J)*ZR(IDEPL-1+PL+I-1)
 230        CONTINUE
 220      CONTINUE
C
C --- ON CALCULE L'ETAT DE CONTACT ADHERENT OU GLISSANT
C
          CALL TTPRSM (NDIM,DPLE,DPLM,1,COEFFA,0.D0,0.D0,
     &                 NORM,TAU1,TAU2,INADH,MPROJ,RESE,NRESE)
C
          IF (INADH.EQ.1) THEN
C
C --- CALCUL DE B, BT, BU - CAS ADHERENT
C
            CALL XMMAB1 (NDIM,NNE,NNES,NNC,NNM,NFAES,CFACE,
     &                   HPG,FFPC,FFES,FFMA,JACOBI,JPCAI,
     &                   LAMBDA,COEFFA,COEFFF,TAU1,TAU2,
     &                   MPROJ,TYPMA,MMAT)
C
          ELSE IF (INADH.EQ.0) THEN
C
C --- CALCUL DE B, BT, BU, F - CAS GLISSANT
C
            CALL XMMAB2 (NDIM,NNE,NNES,NNC,NNM,NFAES,CFACE,
     &                   HPG,FFPC,FFES,FFMA,JACOBI,JPCAI,
     &                   LAMBDA,COEFFA,COEFFF,TAU1,TAU2,
     &                   RESE,NRESE,MPROJ,TYPMA,MMAT)
          END IF
        ELSE
          CALL U2MESS('F','ELEMENTS3_80')
        END IF
      ELSE
C --- SI OPTION NI 'RIGI_CONT' NI 'RIGI_FROT'
        CALL ASSERT(OPTION.EQ.'RIGI_FROT' .OR.
     &              OPTION.EQ.'RIGI_CONT')
      ENDIF
C
C --- RECOPIE VALEURS FINALES
C
      DO 760 J = 1,NDDL
        DO 750 I = 1,J
          IJ = (J-1)*J/2 + I
          ZR(IMATT+IJ-1) = MMAT(I,J)
 750    CONTINUE
 760  CONTINUE
C
      CALL JEDEMA()
      END
