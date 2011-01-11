      SUBROUTINE TE0120(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/01/2011   AUTEUR SFAYOLLE S.FAYOLLE 
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
      IMPLICIT NONE

      CHARACTER*16 OPTION,NOMTE


C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
C                          EN 2D (CPLAN ET DPLAN) ET 3D
C                          POUR ELEMENTS MIXTES A DEUX CHAMPS
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      INTEGER DLNS
      INTEGER NNO,NNOS,NPG,IMATUU
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER JGANO
      INTEGER NDIM

      CHARACTER*2 CODRT1
      CHARACTER*4 FAMI
      CHARACTER*16 PHENOM

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


      FAMI = 'MASS'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C - PARAMETRES EN ENTREE

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)

      IF (OPTION(1:9).EQ.'MASS_MECA') THEN
C---------------- CALCUL MATRICE DE MASSE ------------------------

        CALL JEVECH('PMATUUR','E',IMATUU)

        IF (NDIM.EQ.2) THEN
C - 2 DEPLACEMENTS + 1 PRES
          IF (NOMTE(1:6).EQ.'MIAXUP' .OR.
     &        NOMTE(1:6).EQ.'MIPLUP') THEN
            DLNS = 3
          ELSEIF (NOMTE(1:5).EQ.'MIAX_' .OR.
     &            NOMTE(1:5).EQ.'MIPL_') THEN
            DLNS = 4
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSEIF (NDIM.EQ.3) THEN
C - 3 DEPLACEMENTS + 1 PRES
          IF (NOMTE(1:6).EQ.'MINCUP') THEN
            DLNS = 4
          ELSEIF (NOMTE(1:5).EQ.'MINC_') THEN
            DLNS = 5
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF

        CALL MASSUP(OPTION,NDIM,DLNS,NNO,NNOS,ZI(IMATE),PHENOM,
     &              NPG,IPOIDS,IDFDE,ZR(IGEOM),
     &              ZR(IVF),IMATUU,CODRT1,IGEOM,IVF)

C--------------- FIN CALCUL MATRICE DE MASSE -----------------------
      END IF
      END
