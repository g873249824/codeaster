      SUBROUTINE RCCOMA( JMAT,PHENO,PHENOM,CODRET )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/04/2004   AUTEUR JMBHH01 J.M.PROIX 
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
      IMPLICIT NONE
      INTEGER            JMAT
      CHARACTER*(*)      PHENO,PHENOM
      CHARACTER*2        CODRET
C ----------------------------------------------------------------------
C     OBTENTION DU COMPORTEMENT COMPLET D'UN MATERIAU DONNE A PARTIR
C     D'UN PREMISSE
C
C     ARGUMENTS D'ENTREE:
C        JMAT   : ADRESSE DE LA LISTE DE MATERIAU CODE
C        PHENO  : NOM DU PHENOMENE INCOMPLET
C     ARGUMENTS DE SORTIE:
C        PHENOM : NOM DU PHENOMENE COMPLET
C        CODRET : POUR CHAQUE RESULTAT, 'OK' SI ON A TROUVE, 'NO' SINON
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C 
      INTEGER            NBMAT,IM,IMAT,ICOMP
      CHARACTER*16       FENO
C DEB ------------------------------------------------------------------
      FENO = PHENO
      CODRET = 'NO'
      PHENOM = ' '
      NBMAT=ZI(JMAT)
      DO 20 IM=1,NBMAT
        IMAT = JMAT+ZI(JMAT+NBMAT+IM)
        DO 10 ICOMP=1,ZI(IMAT+1)
          IF ( PHENO .EQ. ZK16(ZI(IMAT)+ICOMP-1)(1:LEN(PHENO)) ) THEN
            IF ( PHENOM .EQ. ' ' ) THEN
              PHENOM=ZK16(ZI(IMAT)+ICOMP-1)
              CODRET = 'OK'
            ELSE  
              CALL UTMESS ('F','RCCOMA_01','PLUSIEURS COMPORTEMENTS DE '
     &                    //'TYPE '//FENO//' ONT ETE TROUVES')
            ENDIF
          ENDIF
 10     CONTINUE
 20   CONTINUE
      IF ( CODRET .EQ. 'NO' ) THEN
        CALL UTMESS ('F','RCCOMA_02','COMPORTEMENT DE TYPE '// 
     &              FENO//' NON TROUVE')
      ENDIF
C FIN ------------------------------------------------------------------
      END
