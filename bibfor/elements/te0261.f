      SUBROUTINE TE0261(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 20/09/2011   AUTEUR MICOL A.MICOL 
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
C RESPONSABLE GENIAUT S.GENIAUT
C.......................................................................

C     BUT: CALCUL DES CONTRAINTES AUX POINTS DE GAUSS
C          EN X-FEM

C          OPTION : 'SIEF_ELGA'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 NOMTE,OPTION
      CHARACTER*8 ENR,TYPMOD(2)
      CHARACTER*16 COMPOR(4)
      INTEGER NDIM,NFH,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO
      INTEGER JPINTT,JCNSET,JHEAVT,JLONCH,JBASLO,JLSN,JLST,JSTNO,JPMILT
      INTEGER IGEOM,IDEPL,IMATE,JFISNO,ICONT
      INTEGER DDLC,NDDL,NNOM,NFE,IBID,DDLS,DDLM,NFISS
      INTEGER IDIM
      LOGICAL LTEATT

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
C     MATNS MAL DIMENSIONNEE
      CALL ASSERT(NNO.LE.27)
C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,NFH,NFE,IBID,DDLC,NNOM,DDLS,NDDL,
     &            DDLM,NFISS,IBID)

C - TYPE DE MODELISATION
      IF (NDIM .EQ. 3) THEN
        TYPMOD(1) = '3D      '
        TYPMOD(2) = '        '
      ELSE
         IF (LTEATT(' ','AXIS','OUI')) THEN
           TYPMOD(1) = 'AXIS    '
         ELSE IF (LTEATT(' ','C_PLAN','OUI')) THEN
           TYPMOD(1) = 'C_PLAN  '
         ELSE IF ( LTEATT(' ','D_PLAN','OUI')) THEN
           TYPMOD(1) = 'D_PLAN  '
         ELSE
C          NOM D'ELEMENT ILLICITE
           CALL ASSERT( LTEATT(' ','C_PLAN','OUI'))
         END IF
         IF (NOMTE(1:2).EQ.'MD') THEN
           TYPMOD(2) = 'ELEMDISC'
         ELSE IF (NOMTE(1:2).EQ.'MI') THEN
           TYPMOD(2) = 'INCO    '
         ELSE
           TYPMOD(2) = '        '
         END IF
      ENDIF


C - PARAMETRES EN ENTREE
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      COMPOR(1)=' '
      COMPOR(2)=' '
      COMPOR(3)=' '
      COMPOR(4)=' '


C     PARAMETRES PROPRES Á X-FEM
      CALL JEVECH('PPINTTO','L',JPINTT)
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PHEAVTO','L',JHEAVT)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PBASLOR','L',JBASLO)
      CALL JEVECH('PLSN'   ,'L',JLSN)
      CALL JEVECH('PLST'   ,'L',JLST)
      CALL JEVECH('PSTANO' ,'L',JSTNO)
C     PROPRES AUX ELEMENTS 1D ET 2D (QUADRATIQUES)
      CALL TEATTR (NOMTE,'S','XFEM',ENR,IBID)
      IF ((ENR.EQ.'XH'.OR.ENR.EQ.'XHC').AND. NDIM.LE.2)
     &  CALL JEVECH('PPMILTO','L',JPMILT)
      IF (NFISS.GT.1) CALL JEVECH('PFISNO','L',JFISNO)

      CALL JEVECH('PCONTRR','E',ICONT)

      CALL XSIDEP(NNO,NFH,NFE,DDLC,DDLM,IGEOM,TYPMOD,
     &               ZI(IMATE),COMPOR,JPINTT,ZI(JCNSET),
     &               ZI(JHEAVT),ZI(JLONCH),ZR(JBASLO),IDEPL,ZR(JLSN),
     &               ZR(JLST),ZR(ICONT),JPMILT,NFISS,JFISNO)
      END
