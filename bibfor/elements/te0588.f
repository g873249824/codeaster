      SUBROUTINE TE0588(OPTION,NOMTE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 12/05/2009   AUTEUR MAZET S.MAZET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE
C
C ----------------------------------------------------------------------
C  CONTACT XFEM GRANDS GLISSEMENTS
C  MISE └ JOUR DU SEUIL DE FROTTEMENT
C
C  OPTION : 'XREACL' (X-FEM MISE └ JOUR DU SEUIL DE FROTTEMENT)
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
      CHARACTER*8  TYPMA,ESC,MAIT,ELC
      INTEGER      NDIM,NDDL,NNE,NNES,NNM,NNC
      INTEGER      JPCPO,JPCAI,IDEPL,JSEUIL
      INTEGER      NFAES
      REAL*8       LAMBDA
      REAL*8       FFPC(8),COOR(2),COORE(3)
      INTEGER      I,J,INI,PLI
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
C --- INITIALISATION DE LA VARIABLE DE TRAVAIL
      LAMBDA=0.D0
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT POINT (VOIR XMCART)
C
      CALL JEVECH('PCAR_PT','L',JPCPO)
C --- LES COORDONNEES ESCLAVE DANS L'ELEMENT DE CONTACT
      COOR(1)  = ZR(JPCPO-1+1)
      COOR(2)  = ZR(JPCPO-1+10)
C --- LE NUMERO DE FACETTE DE CONTACT ESCLAVE      
      NFAES    = NINT(ZR(JPCPO-1+22))
C --- LES COORDONNEES ESCLAVE  DANS L'ELEMENT PARENT
      COORE(1)  = ZR(JPCPO-1+24)
      COORE(2)  = ZR(JPCPO-1+25)
      COORE(3)  = ZR(JPCPO-1+26)
C
C --- RECUPERATION DES DONNEES DE LA CARTE CONTACT AINTER (VOIR XMCART)
C
      CALL JEVECH('PCAR_AI','L',JPCAI)
C
C --- RECUPERATION DE LA GEOMETRIE ET DU CHAMP DE DEPLACEMENT ESCLAVE
C
      CALL JEVECH('PDEPL_P','L',IDEPL)
C
C --- NOMBRE DE NOEUDS ESCLAVES SOMMETS
C
      IF (MALIN) THEN
C --- ON EST EN LINEAIRE
        NNES=NNE
      ELSE
C --- ON EST EN QUADRATIQUE     
        NNES=NNE/2
      ENDIF
C
C --- ON CONSTRUIT LA MATRICE DE CONNECTIVIT╔ CFACE (MAILLE ESCLAVE)
C --- CE QUI SUIT N'EST VALABLE QU'EN 2D POUR LA FORMULATION
C --- QUADRATIQUE, EN 3D ON UTILISE SEULEMENT LA FORMULATION AUX NOEUDS
C --- SOMMETS, CETTE MATRICE EST DONC INUTILE, ON NE LA CONSTRUIT PAS !!
C
      CFACE(1,1)=1
      CFACE(1,2)=2
C
C --- FONCTIONS DE FORMES POUR LE POINT DE CONTACT, 
C --- DANS L'ELEMENT PARENT POUR LA FORMULATION NOEUDS SOMMETS
C      
      IF (MALIN) THEN
        CALL ELRFVF(ESC,COORE,NNES,FFPC,NNES)
        NNC=NNE
      ELSE
        CALL ELRFVF(ELC,COOR,NNC,FFPC,NNC)
      ENDIF
C
C --- CALCUL DU SEUIL DE FROTEMENT LAMBDA
C 
      DO 100 I = 1,NNC
C --- XOULA NE SERT PLUS A RIEN AVEC LA NOUVELLE FORMULATION
C --- NOEUDS SOMMETS !!!
        INI=XOULA(CFACE,NFAES,I,JPCAI,TYPMA)
        CALL XPLMA2(NDIM,NNE,NNES,INI,PLI)
        LAMBDA = LAMBDA + FFPC(I) * ZR(IDEPL-1+PLI)
 100  CONTINUE
C
C --- RECUPERATION ET ENREGISTREMENT DU CHAMP DE SORTIE
C
      CALL JEVECH('PSEUIL','E',JSEUIL)
      ZR(JSEUIL)=LAMBDA
C
      CALL JEDEMA()
      END
