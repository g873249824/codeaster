      SUBROUTINE RCTYPE(IMATE,NBPU,NOMPU,VALPU,RESU,TYPE)
C -----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 17/12/2002   AUTEUR CIBHHGB G.BERTRAND 
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
C ----------------------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           IMATE,NBPU
      REAL*8                              VALPU(*),RESU
      CHARACTER*(*)                 NOMPU(*),       TYPE
C ----------------------------------------------------------------------
C     DETERMINATION DU TYPE DES VARIABLES DONT DEPEND LA COURBE DE
C     TRACTION
C IN  IMATE  : ADRESSE DU MATERIAU CODE
C IN  NBPU  : NOMBRE DE PARAMETRES DANS NOMPU ET VALPU
C IN  NOMPU : NOMS DES PARAMETRES "UTILISATEUR"
C IN  VALPU : VALEURS DES PARAMETRES "UTILISATEUR"
C OUT RESU  : VALEUR DU PARAMETRE DE LA FONCTION
C OUT TYPE  : TYPE DU PARAMETRE DE LA FONCTION
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM
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
      INTEGER       ICOMP, IPI, IDF, NBF, IVALK, IK, IPIF, IPIFC, JPRO
      INTEGER       JVALF1, NBVF1, K, NPAR(2)
      CHARACTER*16  NOMPF(2)
C ----------------------------------------------------------------------
C PARAMETER ASSOCIE AU MATERIAU CODE
      PARAMETER        ( LMAT = 7 , LFCT = 9 )
C DEB ------------------------------------------------------------------
      DO 10 ICOMP=1,ZI(IMATE+1)
        IF ( 'TRACTION' .EQ. ZK16(ZI(IMATE)+ICOMP-1)(1:8) ) THEN
          IPI = ZI(IMATE+2+ICOMP-1)
          GOTO 11
        ENDIF
 10   CONTINUE
      CALL UTMESS ('F','RCTYPE_01','COMPORTEMENT NON TROUVE')
 11   CONTINUE
      IDF   = ZI(IPI)+ZI(IPI+1)
      NBF   = ZI(IPI+2)
      IVALK = ZI(IPI+3)
      DO 20 IK = 1,NBF
        IF ('SIGM    ' .EQ. ZK8(IVALK+IDF+IK-1)) THEN
          IPIF = IPI+LMAT-1+LFCT*(IK-1)
          GOTO 21
        ENDIF
 20   CONTINUE
      CALL UTMESS ('F','RCTYPE_02','FONCTION SIGM NON TROUVEE')
 21   CONTINUE
C
      JPRO = ZI(IPIF+1)
C
      IF (ZK16(JPRO).EQ.'NAPPE') THEN
        NBPARA = 2
        NOMPF(1) = ZK16(JPRO+2)
        NOMPF(2) = ZK16(JPRO+5)
      ELSE
        NBPARA = 1
        NOMPF(1) = ZK16(JPRO+2)
        IF(NOMPF(1).EQ.'EPSI') THEN
           RESU = VALPU(1)
           TYPE = NOMPU(1)
           GOTO 9999
        ELSE
           CALL UTDEBM('F','RCTYPE','ERREUR DE PROGRAMMATION')
           CALL UTIMPK('L','TYPE DE FONCTION NON VALIDE',1,ZK16(JPRO))
           CALL UTFINM()
        ENDIF
      ENDIF
C
      DO 30 I=1,NBPARA
        IF(NOMPF(I).NE.'EPSI') THEN
          DO 31 NUPAR=1,NBPU
            IF (NOMPU(NUPAR).EQ.NOMPF(I)) THEN
              RESU = VALPU(NUPAR)
              TYPE = NOMPU(NUPAR)
              GOTO 9999
            ENDIF
  31      CONTINUE
        ENDIF
  30  CONTINUE
C
      CALL UTDEBM('F','RCTYPE','ERREUR A L''INTERPOLATION' //
     &                ' PARAMETRES NON TROUVE')
C
 9999 CONTINUE
C
      END
