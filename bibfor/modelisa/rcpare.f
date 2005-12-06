      SUBROUTINE RCPARE(NOMMAT,PHENO,PARA,CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 10/03/98   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)     NOMMAT,PHENO,PARA
      CHARACTER*2                         CODRET
C ----------------------------------------------------------------------
C     VERIFICATION DE LA PRESENCE D'UNE CARACTERISTIQUE DANS UN
C     COMPORTEMENT DONNE
C
C     ARGUMENTS D'ENTREE:
C        NOMMAT  : NOM DU MATERIAU
C        PHENO   : NOM DE LA LOI DE COMPORTEMENT
C        PARA    : NOM DU PARAMETRE
C     ARGUMENTS DE SORTIE:
C     CODRET : POUR CHAQUE RESULTAT, 'OK' SI ON A TROUVE, 'NO' SINON
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
C ----------------------------------------------------------------------
C DEB ------------------------------------------------------------------
      CHARACTER*8    K8BID,NOMMA2
      CHARACTER*10   PHENO2
      CHARACTER*32   NCOMR,NCOMC,NCOMK
      INTEGER        NBPAR,NBR,NBC,NBK
C
      CODRET = 'OK'
      PHENO2=PHENO
      NOMMA2=NOMMAT

      NCOMR = NOMMA2//'.'//PHENO2//'.VALR        '
      NCOMC = NOMMA2//'.'//PHENO2//'.VALC        '
      NCOMK = NOMMA2//'.'//PHENO2//'.VALK        '
      CALL JELIRA(NCOMR,'LONUTI',NBR,K8BID)
      CALL JELIRA(NCOMC,'LONUTI',NBC,K8BID)
      CALL JELIRA(NCOMK,'LONUTI',NBK,K8BID)
      CALL JEVEUO(NCOMK,'L',IPAR)
      NBPAR = NBR + NBC + NBK/2
      DO 10 I=1,NBPAR
        IF ( PARA .EQ. ZK8(IPAR+I-1)(1:LEN(PARA)) ) THEN
          GOTO 999
        ENDIF
 10   CONTINUE
      CODRET = 'NO'
      GOTO 999
C
  999 CONTINUE
C FIN ------------------------------------------------------------------
      END
