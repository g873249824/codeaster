      SUBROUTINE CFSUPM(NOMA  ,IZONE ,IESCL ,JDIM  ,JNOCO,
     &                  JMACO ,JAPMEM,JAPPAR,POSSUP,TYPSUP)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/03/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      CHARACTER*8  NOMA
      INTEGER      IZONE,IESCL
      INTEGER      JDIM,JNOCO,JMACO
      INTEGER      JAPMEM,JAPPAR
      INTEGER      POSSUP
      INTEGER      TYPSUP
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
C
C EXCLUSION D'UN NOEUD ESCLAVE CAR:
C - IL APPARTIENT AU GROUP_MA 'SANS_NO' ET 'SANS-GROUP_NO'
C - IL EST HORS ZONE DE PROJECTION (TOLE_PROJ_EXT)
C - RISQUE DE PIVOT NUL POUR APPARIEMENT SYMETRIQUE
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT COURANTE
C IN  JDIM   : POINTEUR VERS DEFICO(1:16)//'.NDIMCO'
C IN  JNOCO  : POINTEUR VERS DEFICO(1:16)//'.NOEUCO'
C IN  JMACO  : POINTEUR VERS DEFICO(1:16)//'.MAILCO'
C IN  JAPMEM : POINTEUR VERS RESOCO(1:14)//'.APMEMO'
C IN  JAPPAR : POINTEUR VERS RESOCO(1:14)//'.APPARI'
C IN  IESCL  : INDICE ABSOLU A SUPPRIMER
C IN  POSSUP : POSITION DU NOEUD A SUPPRIMER DANS CONTNO
C IN  TYPSUP : RAISON DE LA SUPPRESSION DU NOEUD ESCLAVE
C               -1 : FAIT PARTIE DE SANS_GROUP_NO OU SANS_NOEUD
C               -2 : PIVOT NUL DANS APPARIEMENT SYMETRIQUE
C               -3 : PROJECTION HORS DE LA MAILLE INTERDITE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXNUM
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      CFMMVD,ZAPME,ZAPPA
      INTEGER      IFM,NIV
      INTEGER      NUMSUP,NUMAPP,POSAPP
      CHARACTER*8  NOMSUP,NOMAPP,VALK(2)
      INTEGER      IBID
      REAL*8       R8BID
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()      
      CALL INFDBG('CONTACT',IFM,NIV)
C
      ZAPME = CFMMVD('ZAPME')
      ZAPPA = CFMMVD('ZAPPA')
      
      IF ((TYPSUP.LT.-3).OR.(TYPSUP.GT.-1)) THEN
        CALL CFIMPA('CFSUPM',1)
      ELSE  
        ZI(JDIM+8+IZONE) = ZI(JDIM+8+IZONE) - 1
        ZI(JAPMEM+ZAPME*(POSSUP-1)) = TYPSUP
      ENDIF  
C
      IF (NIV.GE.2) THEN
        NUMSUP = ZI(JNOCO+POSSUP-1)
        CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMNOE',NUMSUP),NOMSUP)
          
        IF (TYPSUP.EQ.-3) THEN
          POSAPP = ZI(JAPPAR+ZAPPA*(IESCL-1)+2)
          NUMAPP = ZI(JMACO+POSAPP-1)
          CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMMAI',NUMAPP),NOMAPP)
          VALK(1) = NOMSUP
          VALK(2) = NOMAPP        
          CALL CFIMPD(IFM,NIV,'CFSUPM',1, 
     &                IBID,R8BID,VALK)
        ELSEIF (TYPSUP.EQ.-2) THEN
          CALL CFIMPD(IFM,NIV,'CFSUPM',2, 
     &                IBID,R8BID,NOMSUP)
        ELSEIF (TYPSUP.EQ.-1) THEN
          CALL CFIMPD(IFM,NIV,'CFSUPM',3, 
     &                IBID,R8BID,NOMSUP)
        ELSE
          CALL CFIMPA('CFSUPM',2)
        ENDIF
      ENDIF 
C
      CALL JEDEMA()

      END
