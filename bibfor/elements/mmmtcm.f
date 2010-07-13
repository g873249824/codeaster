      SUBROUTINE MMMTCM(PHASE ,NDIM  ,NNL   ,NNM   ,NORM  ,
     &                  HPG   ,FFL   ,FFM   ,JACOBI,COEFCR,
     &                  CWEAR ,DISSIP,TYPBAR,TYPRAC,MATRCM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/07/2010   AUTEUR MASSIN P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*4  PHASE
      INTEGER      NDIM,NNM,NNL,TYPBAR,TYPRAC
      REAL*8       FFM(9),FFL(9)
      REAL*8       HPG,JACOBI
      REAL*8       COEFCR
      REAL*8       NORM(3)
      REAL*8       MATRCM(9,27)
      REAL*8       DISSIP,CWEAR           
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C CALCUL DE LA MATRICE LAGR_C/DEPL_MAIT 
C
C ----------------------------------------------------------------------
C
C
C IN  PHASE  : PHASE DE CALCUL
C              'CONT' - CONTACT METHODE LAGRANGIENNE
C              'PCON' - CONTACT METHODE PENALISEE
C              'USUR' - USURE
C              'EXCL' - EXCLUSION D'UN NOEUD
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
C IN  NNL    : NOMBRE DE NOEUDS DE LAGRANGE 
C IN  NORM   : NORMALE AU POINT DE CONTACT
C IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFM    : FONCTIONS DE FORMES DEPL. MAIT.
C IN  FFL    : FONCTIONS DE FORMES LAGR.
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  TYPBAR : NUMERO DU NOEUD (MILIEU) EXCLU
C IN  COEFCR : COEF_REGU_CONT
C IN  CWEAR  : COEFFICIENT D'USURE (KWEAR/HWEAR)
C IN  DISSIP : DISSIPATION USURE
C OUT MATRCM : MATRICE ELEMENTAIRE LAGR_C/DEPL_M
C
C ----------------------------------------------------------------------
C
      INTEGER   INOC,INOM,IDIM,JJ
      INTEGER   IBID,NDEXCL(9),IEXCL
C
C ----------------------------------------------------------------------
C

C
C --- PARTIE CONTACT
C       
      IF ((PHASE.EQ.'CONT').OR.(PHASE.EQ.'PCON')) THEN    
        DO 200 INOC = 1,NNL
          DO 190 INOM = 1,NNM
            DO 180 IDIM = 1,NDIM
              JJ = NDIM*(INOM-1)+IDIM            
              MATRCM(INOC,JJ) = MATRCM(INOC,JJ) +
     &                       HPG*FFL(INOC)*FFM(INOM)*JACOBI*NORM(IDIM)
  180       CONTINUE
  190     CONTINUE
  200   CONTINUE
C
C --- PARTIE USURE
C       
      ELSEIF (PHASE.EQ.'USUR') THEN   
        DO 201 INOC = 1,NNL
          DO 191 INOM = 1,NNM
            DO 181 IDIM = 1,NDIM
              JJ = NDIM*(INOM-1)+IDIM            
              MATRCM(INOC,JJ) = MATRCM(INOC,JJ) +
     &                       HPG*FFL(INOC)*FFM(INOM)*JACOBI*NORM(IDIM)* 
     &                       ((CWEAR*DISSIP*COEFCR))
  181       CONTINUE
  191     CONTINUE
  201   CONTINUE      
      ELSEIF (PHASE.EQ.'EXCL') THEN    
        CALL MMEXNO(TYPBAR,IBID,NDEXCL)   
        DO 291 INOM = 1,NNM
          DO 281 IDIM = 1,NDIM
            JJ = NDIM*(INOM-1)+IDIM    
            DO 78 IEXCL = 1,9   
              IF (NDEXCL(IEXCL).EQ.1) THEN
                MATRCM(IEXCL,JJ) = 0.D0
              ENDIF  
   78       CONTINUE        
  281     CONTINUE
  291   CONTINUE
        CALL MMEXNO(IBID  ,TYPRAC,NDEXCL)   
        DO 299 INOM = 1,NNM
          DO 289 IDIM = 1,NDIM
            JJ = NDIM*(INOM-1)+IDIM    
            DO 79 IEXCL = 1,9   
              IF (NDEXCL(IEXCL).EQ.1) THEN
                MATRCM(IEXCL,JJ) = 0.D0
              ENDIF  
   79       CONTINUE        
  289     CONTINUE
  299   CONTINUE          
      ELSE
        CALL ASSERT(.FALSE.)      
      ENDIF
C
      END
