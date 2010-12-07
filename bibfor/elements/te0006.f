      SUBROUTINE TE0006(OPTION,NOMTE)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/05/2007   AUTEUR FERNANDES R.FERNANDES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
      IMPLICIT      NONE
      CHARACTER*16  OPTION,NOMTE
C ======================================================================
C --- BUT : ROUTINE ELEMENTAIRE DE CALCUL DU MODELE --------------------
C ---       SECOND GRADIENT --------------------------------------------
C ======================================================================
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
C ======================================================================
C --- VARIABLES LOCALES ------------------------------------------------
C ======================================================================
      LOGICAL       AXI
      INTEGER       I,J,IVF,IVF2,IDFDE,IDFDE2,JGANO,NDIM,IPOIDS,NPI
      INTEGER       IPOID2,DIMDEF,ICOMPO,ICHG,ICHN,NCMP,REGULA(6),IDEFO
      INTEGER       ICONTM,IDEPLM,IDEPLP,IGEOM,IMATE,JCRET,NDDLS,NDDLM
      INTEGER       IMATUU,IVECTU,ICONTP,NNO,NNOS,NNOM,DIMUEL,DIMCON
      INTEGER       CODRET,IVARIP
      CHARACTER*8   TYPMOD(2)
C ======================================================================
C --- INITIALISATION DU CODE RETOUR ------------------------------------
C ======================================================================
      CODRET = 0
C ======================================================================
C --- RECUPERATION DES ADRESSES DES CHAMPS DE LA CARTE DE L'ELEMENT ----
C ======================================================================
      CALL DILCAR(OPTION,ICOMPO,ICONTM,IDEPLM,IDEPLP,IGEOM,IMATE,IMATUU,
     +            IVECTU,ICONTP,IVARIP,ICHG,ICHN,JCRET,IDEFO)
C ======================================================================
C --- INITIALISATION DES VARIABLES DE L'ELEMENT ------------------------
C ======================================================================
      CALL REGINI(OPTION,NOMTE,IVF,IVF2,IDFDE,IDFDE2,JGANO,NDIM,IPOIDS,
     +            IPOID2,NPI,DIMDEF,NDDLS,NDDLM,DIMCON,TYPMOD,DIMUEL,
     +            NNO,NNOM,NNOS,REGULA,AXI)
C ======================================================================
C --- CALCUL ELEMENTAIRE -----------------------------------------------
C ======================================================================
      IF (OPTION(1:9).EQ.'RIGI_MECA') THEN
         CALL REGELE(OPTION,TYPMOD,NPI,NDIM,DIMUEL,NDDLS,NDDLM,NNO,NNOS,
     +               NNOM,AXI,REGULA,DIMCON,IPOIDS,IPOID2,IVF,IVF2,
     +               IDFDE,IDFDE2,ZK16(ICOMPO),ZR(IGEOM),ZR(IDEPLM),
     +               ZR(ICONTM),ZI(IMATE),DIMDEF,ZR(IMATUU),ZR(IVECTU))

      ELSE IF (OPTION(1:9).EQ.'RAPH_MECA' .OR.
     +         OPTION(1:9).EQ.'FULL_MECA' ) THEN
         DO 10 I=1,DIMUEL
            ZR(IDEPLP-1+I)=ZR(IDEPLM-1+I)+ZR(IDEPLP-1+I)
 10      CONTINUE
         CALL REGELE(OPTION,TYPMOD,NPI,NDIM,DIMUEL,NDDLS,NDDLM,NNO,NNOS,
     +               NNOM,AXI,REGULA,DIMCON,IPOIDS,IPOID2,IVF,IVF2,
     +               IDFDE,IDFDE2,ZK16(ICOMPO),ZR(IGEOM),ZR(IDEPLP),
     +               ZR(ICONTP),ZI(IMATE),DIMDEF,ZR(IMATUU),ZR(IVECTU))
         ZI(JCRET) = CODRET
C ======================================================================
C --- PHASE D'INITIALISATION DU PAS DE TEMPS A PARTIR DE L'INSTANT - ---
C ======================================================================
      ELSE IF (OPTION.EQ.'FORC_NODA') THEN
         CALL FNOREG(DIMUEL,DIMDEF,NNO,NNOS,NNOM,NDIM,NPI,DIMCON,
     +               ZR(IGEOM),IPOIDS,IPOID2,IVF,IVF2,IDFDE,IDFDE2,
     +               NDDLS,NDDLM,AXI,REGULA,ZR(IDEPLM),ZR(ICONTM),
     +               ZI(IMATE),ZR(IVECTU))
C ======================================================================
C --- OPTION : SIEF_ELNO_ELGA ------------------------------------------
C ======================================================================
      ELSE IF (OPTION.EQ.'SIEF_ELNO_ELGA') THEN
         NCMP = DIMCON
         CALL PPGAN2(JGANO,NCMP,ZR(ICHG),ZR(ICHN))
C ======================================================================
C --- OPTION : VARI_ELNO_ELGA ------------------------------------------
C ======================================================================
      ELSE IF (OPTION.EQ.'VARI_ELNO_ELGA') THEN
         READ (ZK16(ICOMPO+1),'(I16)') NCMP
         CALL PPGAN2(JGANO,NCMP,ZR(ICHG),ZR(ICHN))
C ======================================================================
C --- OPTION : EPSI_ELGA_DEPL ------------------------------------------
C ======================================================================
      ELSE IF (OPTION.EQ.'EPSI_ELGA_DEPL') THEN
         CALL EPSREG(NPI,IPOIDS,IPOID2,IVF,IVF2,IDFDE,IDFDE2,
     +               ZR(IGEOM),DIMDEF,DIMUEL,NDIM,NDDLS,NDDLM,NNO,NNOS,
     +               NNOM,AXI,REGULA,ZR(IDEPLP),ZR(IDEFO))
      ENDIF
C ======================================================================
      END
