      SUBROUTINE TEREFE(NOMREF,TYPELE,VALREF)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/11/2011   AUTEUR MACOCCO K.MACOCCO 
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
C RESPONSABLE MACOCCO K.MACOCCO
C
      IMPLICIT      NONE
      CHARACTER*(*) NOMREF,TYPELE
      REAL*8        VALREF
C
C ----------------------------------------------------------------------
C
C ROUTINE UTILITAIRE POUR ACCES AUX VALUERS *_REFE POUR L'OPTION
C REFE_FORC_NODA
C
C ----------------------------------------------------------------------
C
C IN  NOMREF : NOM DE LA COMPOSANTE DE REFERENCE
C IN  TYPELE : TYPE D'ELEMENT
C           'MECA_ISO' - MECANIQUE ISOPARAMETRIQUE (2D ET 3D)
C OUT VALREF : VALEUR DE REFERENCE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      JVREFE
      INTEGER      INDEX,IISNAN
      REAL*8       R8NNEM,VAL
      CHARACTER*16 KMESS(2)
C
C ----------------------------------------------------------------------
C
      CALL JEVECH('PREFCO','L',JVREFE)
      VALREF = R8NNEM()
      IF     (NOMREF.EQ.'SIGM_REFE') THEN
        IF (TYPELE.EQ.'MECA_ISO') THEN
          INDEX  = 1
        ELSEIF (TYPELE.EQ.'THM_JOINT') THEN 
          INDEX  = 1
        ELSEIF (TYPELE.EQ.'MECA_INTERFACE') THEN 
          INDEX  = 1
        ELSEIF (TYPELE.EQ.'MECA_COQUE3D') THEN
          INDEX  = 1
        ELSEIF (TYPELE.EQ.'MECA_GRADVARI') THEN
          INDEX  = 1
        ELSEIF (TYPELE.EQ.'MECA_TUYAU') THEN
          INDEX  = 1 
        ELSEIF (TYPELE.EQ.'THM') THEN
          INDEX  = 1
        ELSEIF (TYPELE.EQ.'MECA_INCO') THEN
          INDEX  = 1
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSEIF (NOMREF.EQ.'EPSI_REFE') THEN
        IF (TYPELE.EQ.'MECA_INCO') THEN
          INDEX  = 2
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSEIF (NOMREF.EQ.'FLUX_THER_REFE') THEN
        IF (TYPELE.EQ.'THM') THEN
          INDEX  = 4
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSEIF (NOMREF.EQ.'FLUX_HYD1_REFE') THEN
        IF (TYPELE.EQ.'THM_JOINT') THEN 
          INDEX  = 2
        ELSEIF (TYPELE.EQ.'THM') THEN
          INDEX  = 2
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSEIF (NOMREF.EQ.'FLUX_HYD2_REFE') THEN
        IF (TYPELE.EQ.'THM') THEN
          INDEX  = 3
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSEIF (NOMREF.EQ.'VARI_REFE') THEN
        IF (TYPELE.EQ.'MECA_GRADVARI') THEN
          INDEX  = 2
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSEIF (NOMREF.EQ.'EFFORT_REFE') THEN
        IF (TYPELE.EQ.'MECA_DISCRET') THEN
          INDEX  = 1
        ELSEIF (TYPELE.EQ.'MECA_BARRE') THEN
          INDEX  = 1        
        ELSEIF (TYPELE.EQ.'MECA_CABLE') THEN
          INDEX  = 1        
        ELSEIF (TYPELE.EQ.'MECA_POULIE') THEN
          INDEX  = 1
        ELSEIF (TYPELE.EQ.'MECA_POUTRE') THEN
          INDEX  = 1
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF  
      ELSEIF (NOMREF.EQ.'MOMENT_REFE') THEN
        IF (TYPELE.EQ.'MECA_DISCRET') THEN
          INDEX  = 2
        ELSEIF (TYPELE.EQ.'MECA_POUTRE') THEN
          INDEX  = 2
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF   
      ELSEIF (NOMREF.EQ.'DEPL_REFE') THEN
        IF (TYPELE.EQ.'MECA_INTERFACE') THEN 
          INDEX  = 2  
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSEIF (NOMREF.EQ.'LAGR_REFE') THEN
        IF (TYPELE.EQ.'MECA_GRADVARI') THEN
          INDEX  = 3
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      VAL   = ZR(JVREFE+INDEX-1)
      IF (IISNAN(VAL).EQ.1) THEN
        KMESS(1) = TYPELE
        KMESS(2) = NOMREF
        CALL U2MESK('F','MECANONLINE5_55',2,KMESS)
      ELSE
        VALREF = VAL
      ENDIF
C
      END
