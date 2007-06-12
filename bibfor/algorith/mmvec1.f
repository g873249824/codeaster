      SUBROUTINE MMVEC1(NDIM,NNE,NNM,
     &                  IMA,IMABAR,INDNOB,INDRAC,
     &                  HPG,FFPC,FFPR,JACOBI, 
     &                  JDEPM,JDEPP,DEPLE,
     &                  TYALGC,COEFCA,COEFCS,COEFCP,ICOMPL,
     &                  IFORM,COEASP,ASPERI,JEU,NORM,VTMP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/02/2007   AUTEUR TORKHANI M.TORKHANI 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21
      IMPLICIT NONE
      INTEGER  NDIM,NNE,NNM
      INTEGER  ICOMPL,IFORM,TYALGC
      INTEGER  IMA,IMABAR,INDRAC,INDNOB
      REAL*8   HPG,FFPC(9),JACOBI,FFPR(9)
      REAL*8   DEPLE(6),JEU,NORM(3)
      REAL*8   JDEPP,JDEPM      
      REAL*8   ASPERI,COEFCA,COEFCS,COEFCP,COEASP   
      REAL*8   VTMP(81)   
C
C ----------------------------------------------------------------------
C ROUTINE APPELLEE PAR : TE0365
C ----------------------------------------------------------------------
C
C VECTEUR SECOND MEMBRE SI CONTACT AVEC COMPLIANCE
C
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
C IN  IMA    : NUMERO DE LA MAILLE ESCLAVE
C IN  IMABAR : NUMERO DE LA MAILLE ESCLAVE DE L'ELEMENT DE BARSOUM
C IN  INDNOB : NUMERO DU NOEUD A EXCLURE DANS LA MAILLE POUR BARSOUM
C IN  INDRAC : NUMERO DU NOEUD EN FACE DU NOEUD A EXCLURE POUR BARSOUM
C IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFPC   : FONCTIONS DE FORME DU POINT DE CONTACT
C IN  FFPR   : FONCTIONS DE FORME DE LA PROJECTION DU POINT DE CONTACT
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  JDEPP  : JEU SUR DEPLACEMENT FINAL
C IN  JDEPM  : JEU SUR DEPLACEMENT INITIAL
C IN  DEPLE  : DEPLACEMENTS DE LA SURFACE ESCLAVE
C IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFPC   : FONCTIONS DE FORME DU POINT DE CONTACT
C IN  FFPR   : FONCTIONS DE FORME DE LA PROJECTION DU POINT DE CONTACT
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  COEFCA : COEF_REGU_CONT
C IN  COEFFS : COEF_STAB_CONT
C IN  COEFFP : COEF_PENA_CONT
C IN  TYALGC : TYPE D'ALGORITHME DE CONTACT
C IN  ICOMPL : INDICATEUR DE COMPLIANCE 
C IN  IFORM  : TYPE DE FORMUALTIOn (DEPL/VITE)
C IN  COEASP : PARAMETRE E_N POUR LA COMPLIANCE
C IN  ASPERI : VALEUR DE L'ASPERITE 
C IN  JEU    : VALEUR DU JEU
C IN  NORM   : VALEUR DE LA NORMALE AU POINT DE CONTACT
C I/O VTMP   : VECTEUR SECOND MEMBRE ELEMENTAIRE DE CONTACT/FROTTEMENT
C
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER I,J,II
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      IF (IFORM .EQ. 1) THEN
C  
C --- DDL DE DEPLACEMENT DE LA SURFACE CINEMATIQUE
C 
        DO 70 I = 1,NNE
          DO 60 J = 1,NDIM
            II = (I-1)*(2*NDIM)+J
            IF (TYALGC .EQ. 1) THEN
            VTMP(II) = -HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-COEFCA*JEU-(COEASP*ICOMPL*
     &                 (JEU-ASPERI)**2))*FFPC(I)*NORM(J)
            ELSEIF (TYALGC .EQ. 2) THEN
            VTMP(II) = -HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-(COEASP*ICOMPL*
     &                 (JEU-ASPERI)**2))*FFPC(I)*NORM(J)
            ELSEIF (TYALGC .EQ. 3) THEN
            VTMP(II) = -HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-COEFCP*JEU-(COEASP*ICOMPL*
     &                 (JEU-ASPERI)**2))*FFPC(I)*NORM(J)
            END IF
   60     CONTINUE
   70   CONTINUE
C
C --- DDL DES DEPLACEMENTS DE LA SURFACE GEOMETRIQUE
C
        DO 90 I = 1,NNM
          DO 80 J = 1,NDIM
            II = NNE*(2*NDIM)+(I-1)*(NDIM)+J           
            IF (TYALGC .EQ. 1) THEN
            VTMP(II) = HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-COEFCA*JEU-(COEASP*ICOMPL*
     &                 (JEU-ASPERI)**2))*FFPR(I)*NORM(J)
            ELSEIF (TYALGC .EQ. 2) THEN
            VTMP(II) = HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-(COEASP*ICOMPL*
     &                 (JEU-ASPERI)**2))*FFPR(I)*NORM(J)
            ELSEIF (TYALGC .EQ. 3) THEN
            VTMP(II) = HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-COEFCP*JEU-(COEASP*ICOMPL*
     &                 (JEU-ASPERI)**2))*FFPR(I)*NORM(J)
            END IF
   80     CONTINUE
   90   CONTINUE
C
C --- DDL DES MULTIPLICATEURS DE CONTACT (DE LA SURFACE CINEMATIQUE)
C
        DO 100 I = 1,NNE
          II = (I-1)*(2*NDIM)+NDIM+1
          VTMP(II) = -HPG*JACOBI*JEU*FFPC(I)
  100   CONTINUE
C
C --- TRAITEMENT DU FOND DE FISSURE 
C 
        IF (IMA .EQ. IMABAR) THEN
          IF (INDNOB .GT. 0) THEN
            DO 222 I = INDNOB,INDNOB
              II = (I-1)*(2*NDIM)+NDIM+1
              VTMP(II) = 0.D0
  222       CONTINUE
          END IF
        END IF  
C
C --- TRAITEMENT DU RACCORD SURFACIQUE 
C
        IF (INDRAC .GT. 0) THEN
          DO 223 I = INDRAC,INDRAC
            II = (I-1)*(2*NDIM)+NDIM+1          
            VTMP(II) = 0.D0
  223     CONTINUE
        END IF
      ELSE
C  
C --- DDL DE DEPLACEMENT DE LA SURFACE CINEMATIQUE
C 
        DO 71 I = 1,NNE
          DO 61 J = 1,NDIM
            II = (I-1)*(2*NDIM)+J          
            IF (TYALGC .EQ. 1) THEN
            VTMP(II) = -HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-COEFCA*(JDEPP-JDEPM))*
     &                  FFPC(I)*NORM(J)
            ELSEIF (TYALGC .EQ. 2) THEN
            VTMP(II) = -HPG*JACOBI*DEPLE(NDIM+1)*FFPC(I)*NORM(J)
            ELSEIF (TYALGC .EQ. 3) THEN
            VTMP(II) = -HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-COEFCP*(JDEPP-JDEPM))*
     &                  FFPC(I)*NORM(J)
            END IF
   61     CONTINUE
   71   CONTINUE
C
C --- DDL DES DEPLACEMENTS DE LA SURFACE GEOMETRIQUE
C
        DO 91 I = 1,NNM
          DO 81 J = 1,NDIM
            II = NNE*(2*NDIM)+(I-1)*(NDIM)+J           
            IF (TYALGC .EQ. 1) THEN
            VTMP(II) = HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-COEFCA*(JDEPP-JDEPM))*
     &                  FFPR(I)*NORM(J)
            ELSEIF (TYALGC .EQ. 2) THEN
            VTMP(II) = HPG*JACOBI*DEPLE(NDIM+1)*FFPR(I)*NORM(J)
            ELSEIF (TYALGC .EQ. 3) THEN
            VTMP(II) = HPG*JACOBI*
     &                 (DEPLE(NDIM+1)-COEFCP*(JDEPP-JDEPM))*
     &                  FFPR(I)*NORM(J)
            END IF
   81     CONTINUE
   91   CONTINUE
C
C --- DDL DES MULTIPLICATEURS DE CONTACT (DE LA SURFACE CINEMATIQUE)
C
        DO 105 I = 1,NNE
          II = (I-1)*(2*NDIM)+NDIM+1          
          VTMP(II) = -HPG*JACOBI*FFPC(I)*(JDEPP-JDEPM) 
  105   CONTINUE
      ENDIF           
C
      CALL JEDEMA()
C
      END
