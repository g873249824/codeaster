      SUBROUTINE KAJGR2(IGRAP,VR,COKAJ1,COKAJ2)
      IMPLICIT REAL*8 (A-H,O-Z)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 16/07/2002   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C-----------------------------------------------------------------------
C CALCUL DES COEFFICIENTS ADIMENSIONNELS DE FORCE DE RAIDEUR
C GRAPPE2
C-----------------------------------------------------------------------
C  IN : IGRAP  : INDICE CARACTERISTIQUE DE LA CONFIGURATION
C                EXPERIMENTALE DE REFERENCE
C  IN : VR     : VITESSE REDUITE
C OUT : COKAJ1 : COEFFICIENT ADIMENSIONNEL DE FORCE DE RAIDEUR
C                POUR UN MOUVEMENT DE TRANSLATION
C OUT : COKAJ2 : COEFFICIENT ADIMENSIONNEL DE FORCE DE RAIDEUR
C                POUR UN MOUVEMENT DE ROTATION
C-----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER       IGRAP,NKAMAX,IFLAG,UNIT
      REAL*8        VR,COKAJ1,COKAJ2
      REAL*8       COECA1(20,11),COECA2(20,11)
      REAL*8       COEF1(20,11),COEF2(20,11)
      CHARACTER*24 NOM1, NOM2
      SAVE         COECA1, COECA2
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      NKAMAX = 11
      NBOMAX = 20
      ZERO   = 0.0D0
C      
      NOM1   = '&&KAJGR2.FLAG'
      NOM2   = '&&OP0143.UNIT_GRAPPES'
C
      CALL JEEXIN (NOM1,IRET)
      IF (IRET .EQ. 0) THEN
C
C --- LECTURE DU FICHIER DE DONNEES 
C     =============================
         CALL JEVEUO(NOM2,'L',IUNIT)
         UNIT = ZI(IUNIT-1+2)   
         CALL ASOPEN(UNIT, ' ' )
C
C ---    BLOC D'INITIALISATION
         DO 10 I = 1,NBOMAX
            DO 20 J = 1,NKAMAX
               COECA1(I,J) = ZERO
               COECA2(I,J) = ZERO
               COEF1(I,J)  = ZERO
               COEF2(I,J)  = ZERO
  20        CONTINUE
  10     CONTINUE                
C               
         READ (UNIT,*) NBLOC
         DO 30 I = 1,NBLOC
            READ (UNIT,*) (COEF1(I,J),J = 1,NKAMAX)
            READ (UNIT,*) (COEF2(I,J),J = 1,NKAMAX)            
            READ (UNIT,*)                                         
  30     CONTINUE   
         DO 40 I = 1,NBOMAX
            DO 50 J = 1,NKAMAX
               COECA1(I,J) = COEF1(I,J)
               COECA2(I,J) = COEF2(I,J)
  50        CONTINUE
  40     CONTINUE              
         CALL WKVECT(NOM1,'G V I',1,IFLAG) 
         ZI(IFLAG+1-1) = 1
C        FERMETURE DU FICHIER
         CALL ASOPEN(-UNIT, ' ' )
         GO TO 60
      ENDIF
C
  60  CONTINUE


C-----1.CONFIG. ECOULEMENT ASCENDANT TIGE DE COMMANDE CENTREE
C
      IF (IGRAP.EQ.1) THEN
C
        COKAJ1 = COECA1(1,8) + COECA1(1,7)/VR
        COKAJ2 = COECA2(1,8) + COECA2(1,7)/VR
C
C-----2.CONFIG. ECOULEMENT ASCENDANT TIGE DE COMMANDE EXCENTREE
C
      ELSE IF (IGRAP.EQ.2) THEN
C
        COKAJ1 = COECA1(2,8) + COECA1(2,7)/VR
        COKAJ2 = COECA2(2,8) + COECA2(2,7)/VR
C
C-----3.CONFIG. ECOULEMENT DESCENDANT TIGE DE COMMANDE CENTREE
C
      ELSE IF (IGRAP.EQ.3) THEN
C
        COKAJ1 = COECA1(3,8) + COECA1(3,7)/VR
        COKAJ2 = COECA2(3,8) + COECA2(3,7)/VR
C
C-----4.CONFIG. ECOULEMENT DESCENDANT TIGE DE COMMANDE EXCENTREE
C
      ELSE
C
        COKAJ1 = COECA1(4,8) + COECA1(4,7)/VR
        COKAJ2 = COECA2(4,8) + COECA2(4,7)/VR
C
      ENDIF
C
      CALL JEDEMA()
C      
      END
