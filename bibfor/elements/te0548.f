      SUBROUTINE TE0548(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 12/05/2009   AUTEUR MAZET S.MAZET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C                CONTACT X-FEM M�THODE CONTINUE : 
C             MISE � JOUR DU SEUIL DE FROTTEMENT
C
C
C  OPTION : 'XREACL' (X-FEM MISE � JOUR DU SEUIL DE FROTTEMENT)

C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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

C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------

      INTEGER      I,J,IFA,IPGF,ISSPG,NI,PLI,AR(12,2),NBAR
      INTEGER      IDEPPL,JAINT,JCFACE,JLONCH,JSEUIL,IPOIDF,IVFF,IDFDEF
      INTEGER      IADZI,IAZK24,IPOIDS,IVF,IDFDE,JGANO,JDONCO
      INTEGER      NDIM,NNO,NNOS,NPG,DDLH,DDLC,NNOM,INTEG,NINTER,NFE
      INTEGER      NFACE,CFACE(5,3),IBID,NNOF,NPGF,XOULA,JPTINT
      CHARACTER*8  ELREF,TYPMA,FPG,ELC,LAG
      REAL*8       SEUIL,FFI,E,G(3),RBID,FFP(27),ND(3)
      INTEGER      DDLS,NDDL,NNOL,LACT(27),NOLA(27),IGEOM
      LOGICAL      MALIN
C......................................................................

      CALL JEMARQ()
C
      CALL ELREF1(ELREF)
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,DDLH,NFE,IBID,DDLC,NNOM,DDLS,NDDL)

C     DEP ACTUEL (DEPPLU) : 'PDEPL_P'
      CALL JEVECH('PDEPL_P','L',IDEPPL)
      CALL JEVECH('PDONCO','L',JDONCO)
      CALL JEVECH('PAINTER','L',JAINT)
      CALL JEVECH('PCFACE' ,'L',JCFACE)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PPINTER','L',JPTINT)
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PSEUIL' ,'E',JSEUIL)
      
C     RECUPERATIONS DES DONNEES SUR LE CONTACT ET
C     SUR LA TOPOLOGIE DES FACETTES
      NINTER=ZI(JLONCH-1+1)
      IF (NINTER.LT.NDIM)  GOTO 9999

      NFACE=ZI(JLONCH-1+2)
      DO 15 I=1,NFACE
        DO 16 J=1,NDIM
          CFACE(I,J)=ZI(JCFACE-1+NDIM*(I-1)+J)
   16   CONTINUE
 15   CONTINUE
C
C     SCHEMA D'INTEGRATION NUMERIQUE ET ELEMENT DE REFERENCE DE CONTACT
      INTEG = NINT(ZR(JDONCO-1+4))
      IF (NDIM .EQ. 3) THEN
        IF (INTEG.EQ.1) FPG='NOEU'
        IF (INTEG.EQ.2) FPG='GAUSS'
        IF (INTEG.EQ.3) FPG='SIMP'
        IF (INTEG.EQ.4) FPG='SIMP1'
        IF (INTEG.EQ.6) FPG='COTES'
        IF (INTEG.EQ.10) FPG='XCON'
        IF (INTEG.EQ.14) FPG='FPG4'
        IF (INTEG.EQ.16) FPG='FPG6'
        IF (INTEG.EQ.17) FPG='FPG7'
        ELC='TR3'
      ELSEIF (NDIM.EQ.2) THEN
        IF (INTEG.EQ.1) FPG='NOEU'
        IF (INTEG.EQ.2) FPG='GAUSS'
        IF (INTEG.EQ.3) FPG='SIMP'
        IF (INTEG.EQ.4) FPG='SIMP1'
        IF (INTEG.EQ.6) FPG='COTES'
        IF (INTEG.EQ.7) FPG='COTES1'
        IF (INTEG.EQ.8) FPG='COTES2'
        IF (INTEG.EQ.12) FPG='FPG2'
        IF (INTEG.EQ.13) FPG='FPG3'
        IF (INTEG.EQ.14) FPG='FPG4'
        ELC='SE2'
        ELC='SE2'
      ENDIF
      CALL ELREF4(ELC,FPG,IBID,NNOF,IBID,NPGF,IPOIDF,IVFF,IDFDEF,IBID)

C     RECUPERATION DU COEFFICIENT DE MISE � L'ECHELLE DES PRESSIONS
      E=ZR(JDONCO-1+5)

      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)

C
C     L'ELEMENT EST-IL LINEAIRE OU QUADRATIQUE
C
      CALL TEATTR (NOMTE,'C','XLAG',LAG,IBID)
      IF (IBID.EQ.0.AND.LAG.EQ.'NOEUD') THEN
        MALIN=.TRUE.
      ELSE
        MALIN=.FALSE.
      ENDIF
C
C     LISTE DES LAMBDAS ACTIFS
C
      IF (MALIN) THEN
        CALL CONARE(TYPMA,AR,NBAR)
        CALL XLACTI(NDIM,NFACE,NNO,NNOM,CFACE,JAINT,AR,LACT)

        NNOL=0
        DO 17 I=1,NNO
          IF (LACT(I).NE.0) THEN
            NNOL=NNOL+1
            NOLA(NNOL)=I
          ENDIF
 17     CONTINUE
      ELSE
        NNOL=NNOF
      ENDIF
C
C     BOUCLE SUR LES FACETTES
      DO 100 IFA=1,NFACE
C
C       BOUCLE SUR LES POINTS DE GAUSS DES FACETTES
        DO 110 IPGF=1,NPGF
C
C         INDICE DE CE POINT DE GAUSS DANS PSEUIL
          ISSPG=NPGF*(IFA-1)+IPGF

C
C         CALCUL DE JAC (PRODUIT DU JACOBIEN ET DU POIDS)
C         ET DES FF DE L'ELEMENT PARENT AU POINT DE GAUSS
C         ET LA NORMALE ND ORIENT�E DE ESCL -> MAIT
          IF (NDIM.EQ.3) THEN
            CALL XJACFF(ELREF,FPG,JPTINT,IFA,CFACE,IPGF,NNO,IGEOM,G,
     &                                         'NON',RBID,FFP,RBID,ND)
          ELSEIF (NDIM.EQ.2) THEN
            CALL XJACF2(ELREF,FPG,JPTINT,IFA,CFACE,IPGF,NNO,IGEOM,G,
     &                                         'NON',RBID,FFP,RBID,ND)
          ENDIF

C         CALCUL DU NOUVEAU SEUIL A PARTIR DES LAMBDA DE DEPPLU
C         RQ : LA VALEUR DANS IDEPPL EST LA PRESSION DIVIS�E PAR E
          SEUIL = 0.D0
          DO 120 I = 1,NNOL
            IF (MALIN) THEN
              NI=NOLA(I)
              FFI=FFP(NI)
            ELSE
              NI=XOULA(CFACE,IFA,I,JAINT,TYPMA)
              FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
            ENDIF
            CALL XPLMAT(NDIM,DDLH,NFE,DDLC,NNO,NNOM,NI,PLI)
            SEUIL = SEUIL + FFI * ZR(IDEPPL-1+PLI) * E
 120      CONTINUE

          ZR(JSEUIL-1+ISSPG)=SEUIL

 110    CONTINUE
 100  CONTINUE

 9999 CONTINUE

      CALL JEDEMA()
      END
