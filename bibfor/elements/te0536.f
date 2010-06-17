      SUBROUTINE TE0536(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE

C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/06/2010   AUTEUR CARON A.CARON 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C    - FONCTION REALISEE:  CALCUL DE L'OPTION "RIGI_MECA_GE" POUR LES
C                          ELEMENTS X-FEM
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
      CHARACTER*8 TYPMOD(2),ELREFP,LAG,ENR
      CHARACTER*16 K16BID
      INTEGER JGANO,NNO,NPG,IMATUU,LGPG,NDIM,IRET
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,ICONT
      INTEGER CODRET,NNOS
      INTEGER JPINTT,JCNSET,JHEAVT,JLONCH,JBASLO,JLSN,JLST,JSTNO,JPMILT
      INTEGER DDLH,DDLC,NDDL,NNOM,NFE,IBID,DDLS,DDLM
      LOGICAL LTEATT
      REAL*8  R8BID

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

C - FONCTIONS DE FORMES ET POINTS DE GAUSS
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C      FAMI='RIGI'
C     MATNS MAL DIMENSIONNEE
      CALL ASSERT(NNO.LE.27) 

C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,DDLH,NFE,IBID,DDLC,NNOM,DDLS,NDDL,DDLM)

C - TYPE DE MODELISATION
      IF (NDIM .EQ. 3) THEN
        TYPMOD(1) = '3D      '
        TYPMOD(2) = '        '
      ELSE
         IF (LTEATT(' ','AXIS','OUI')) THEN
           TYPMOD(1) = 'AXIS    '
         ELSE IF (NOMTE(3:4).EQ.'CP') THEN
           TYPMOD(1) = 'C_PLAN  '
         ELSE IF (NOMTE(3:4).EQ.'DP') THEN
           TYPMOD(1) = 'D_PLAN  '
         ELSE
C          NOM D'ELEMENT ILLICITE
           CALL ASSERT(NOMTE(3:4).EQ.'CP')
         END IF
         IF (NOMTE(1:2).EQ.'MD') THEN
           TYPMOD(2) = 'ELEMDISC'
         ELSE IF (NOMTE(1:2).EQ.'MI') THEN
           TYPMOD(2) = 'INCO    '
         ELSE
           TYPMOD(2) = '        '
         END IF
         CODRET=0
      ENDIF

C - PARAMETRES EN ENTREE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCONTRR','L',ICONT)
      CALL JEVECH('PPINTTO','L',JPINTT)
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PHEAVTO','L',JHEAVT)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PBASLOR','L',JBASLO)
      CALL JEVECH('PLSN'   ,'L',JLSN)
      CALL JEVECH('PLST'   ,'L',JLST)
      CALL JEVECH('PSTANO' ,'L',JSTNO)
      CALL TEATTR (NOMTE,'S','XFEM',ENR,IBID)
      IF (IBID.EQ.0 .AND.(ENR.EQ.'XH'.OR.ENR.EQ.'XHC').AND. NDIM.LE.2)
     &  CALL JEVECH('PPMILTO','L',JPMILT)


      CALL JEVECH('PMATUUR','E',IMATUU)

      CALL XRIGEL(NNO,IPOIDS,IVF,DDLH,NFE,DDLC,DDLM,IGEOM,TYPMOD,
     &            NOMTE,LGPG,JPINTT,
     &            ZI(JCNSET),ZI(JHEAVT), ZI(JLONCH),ZR(JBASLO),
     &            ZR(JLSN),ZR(JLST),ZR(ICONT),ZR(IMATUU),CODRET,
     &            JPMILT)

C
C     SUPPRESSION DES DDLS SUPERFLUS
      CALL TEATTR (NOMTE,'C','XLAG',LAG,IBID)
      IF (IBID.EQ.0.AND.LAG.EQ.'ARETE') THEN
        NNO = NNOS
      ENDIF
      CALL XTEDDL(NDIM,DDLH,NFE,DDLS,NDDL,NNO,NNOS,ZI(JSTNO),
     &                  .FALSE.,.TRUE.,OPTION,NOMTE,
     &                  ZR(IMATUU),R8BID,DDLM)
      

      END
