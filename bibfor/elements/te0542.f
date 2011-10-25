      SUBROUTINE TE0542(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 24/10/2011   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ----------------------------------------------------------------------
C FONCTION REALISEE:  CALCUL DES OPTION FORC_NODA ET REFE_FORC_NODA
C                     POUR LES �L�MENTS MECA X-FEM

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
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

      INTEGER    NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO,IGEOM,IVECTU
      INTEGER    JPINTT,JCNSET,JHEAVT,JLONCH,JBASLO,ICONTM,JLSN,JLST
      INTEGER    JPMILT,DDLM,NFISS,JFISNO
      INTEGER    NFH,DDLC,NFE,IBID,NBSIGM,DDLS,NBSIG,NDDL,JSTNO
      LOGICAL    LBID
      REAL*8     RBID
      CHARACTER*8 ENR,LAG
C DEB ------------------------------------------------------------------

C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,NFH,NFE,IBID,DDLC,IBID,DDLS,NDDL,
     &            DDLM,NFISS,IBID)
C
C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG = NBSIGM()

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PVECTUR','E',IVECTU)

C     PARAM�TRES PROPRES � X-FEM
      CALL JEVECH('PPINTTO','L',JPINTT)
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PHEAVTO','L',JHEAVT)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PBASLOR','L',JBASLO)
      CALL JEVECH('PLSN'   ,'L',JLSN)
      CALL JEVECH('PLST'   ,'L',JLST)
      CALL JEVECH('PSTANO' ,'L',JSTNO)
C     PROPRE AUX ELEMENTS 1D ET 2D (QUADRATIQUES)
      CALL TEATTR (NOMTE,'S','XFEM',ENR,IBID)
      IF (IBID.EQ.0 .AND.(ENR.EQ.'XH'.OR.ENR.EQ.'XHC').AND. NDIM.LE.2)
     &  CALL JEVECH('PPMILTO','L',JPMILT)
      IF (NFISS.GT.1) CALL JEVECH('PFISNO','L',JFISNO)

      IF (OPTION.EQ.'FORC_NODA') THEN
C      --------------------

        CALL JEVECH('PCONTMR','L',ICONTM)

C       CALCUL DU VECTEUR DES FORCES INTERNES (BT*SIGMA)
        CALL XBSIG(NDIM,NNO,NFH,NFE,DDLC,DDLM,IGEOM,JPINTT,
     &       ZI(JCNSET),ZI(JHEAVT),ZI(JLONCH),ZR(JBASLO),ZR(ICONTM),
     &       NBSIG,ZR(JLSN),ZR(JLST),IVECTU,JPMILT,NFISS,JFISNO)

C       SUPPRESSION DES DDLS SUPERFLUS
        CALL TEATTR (NOMTE,'C','XLAG',LAG,IBID)
        IF (IBID.EQ.0.AND.LAG.EQ.'ARETE') THEN
          NNO = NNOS
        ENDIF
        CALL XTEDDL(NDIM,NFH,NFE,DDLS,NDDL,NNO,NNOS,ZI(JSTNO),
     &              .FALSE.,LBID,OPTION,NOMTE,
     &              RBID,ZR(IVECTU),DDLM,NFISS,JFISNO)

      ELSE
        CALL ASSERT(.FALSE.)

      END IF
C FIN ------------------------------------------------------------------

      END
