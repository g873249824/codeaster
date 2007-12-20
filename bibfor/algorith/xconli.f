      SUBROUTINE XCONLI(NOMA  ,NOMO  ,PREMIE,DEFICO,RESOCO,
     &                  LISCHA,SOLVEU,NUMEDD,VALMOI,VALPLU,
     &                  DEPALG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
      LOGICAL       PREMIE
      CHARACTER*8   NOMA,NOMO
      CHARACTER*19  LISCHA,SOLVEU
      CHARACTER*24  VALMOI(8),VALPLU(8),DEPALG(8)
      CHARACTER*24  DEFICO,RESOCO,NUMEDD
C     
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM - CREATION OBJETS)
C
C CREATION DES OBJETS ELEMENTAIRES:
C  - CHAM_ELEM
C  - VECT_ELEM
C  - MATR_ELEM
C      
C ----------------------------------------------------------------------
C
C
C IN  VALMOI : ETAT EN T-
C IN  VALPLU : ETAT EN T+
C IN  PREMIE : VAUT .TRUE. SI PREMIER PAS DE TEMPS
C IN  NOMO   : NOM DE L'OBJET MOD�LE
C IN  NOMA   : NOM DE L'OBJET MAILLAGE 
C IN  RESOCO : SD CONTACT RESULTAT
C IN  DEFICO : SD CONTACT DEFINITION
C IN  LISCHA : L_CHARGES CONTENANT LES CHARGES APPLIQUEES
C IN  SOLVEU : OBJET SOLVEUR
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV   
      INTEGER      NEQ,ITERG
      INTEGER      JDEPDE,JDDEPL
      REAL*8       R8BID
      LOGICAL      LBID  
      CHARACTER*8  K8BID
      CHARACTER*24 DDEPLA,DEPDEL 
      CHARACTER*24 DEPMOI,DEPPLU      
      CHARACTER*24 K24BLA,K24BID
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)      
C
C --- AFFICHAGE
C      
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<XFEM   > CREATION ET INITIALISATION'//
     &        ' DES OBJETS *_ELEM' 
      ENDIF 
C
C --- INITIALISATIONS
C
      K24BLA = ' '      
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C       
      CALL DESAGG(VALMOI,DEPMOI,K24BID,K24BID,K24BID,
     &            K24BID,K24BID,K24BID,K24BID)
      CALL DESAGG(VALPLU,DEPPLU,K24BID,K24BID,K24BID,
     &            K24BID,K24BID,K24BID,K24BID) 
      CALL DESAGG(DEPALG,DDEPLA,DEPDEL,K24BID,K24BID,
     &            K24BID,K24BID,K24BID,K24BID)               
C 
C --- INITIALISATION DES CHAMPS DE DEPLACEMENT
C     
      CALL COPISD('CHAMP_GD','V',DEPMOI,DEPPLU) 
      CALL JEVEUO(DEPDEL(1:19)//'.VALE','E',JDEPDE)
      CALL JEVEUO(DDEPLA(1:19)//'.VALE','E',JDDEPL)
      CALL JELIRA(DEPDEL(1:19)//'.VALE','LONMAX',NEQ,K8BID)
      CALL ZZZERO(NEQ,JDEPDE)
      CALL ZZZERO(NEQ,JDDEPL)            
C
C --- CREATION DES CHAM_ELEM SI PREMIER PAS DE TEMPS
C  
      IF (PREMIE) THEN
        CALL XMELEM(NOMA  ,NOMO  ,DEFICO,RESOCO)
      ENDIF
      
C --- ON RECUPERE LE NOMBRE D'ITERATIONS GEOMETRIQUES
C---- POUR SAVOIR SI ON EST EN GRANDS GLISSEMENTS POUR XFEM

      CALL MMINFP(0,DEFICO,K24BLA,'ITER_GEOM_MAXI',
     &            ITERG,R8BID,K24BID,LBID)

      IF (ITERG.GT.0) THEN     
C --- CREATION DU LIGREL DES ELEMENTS DE CONTACT

        CALL XMLIGR(NOMA,DEFICO,RESOCO)
        CALL XMCART(NOMA,DEFICO,NOMO  ,RESOCO) 
C --- CREATION DU NOUVEAU NUME_DDL POUR LES ELEMENTS DE CONTACT 
        CALL NUMER3(NOMO,LISCHA,SOLVEU,NUMEDD)
C --- CREATION DES VECT_ELEM ET MATR_ELEM	     
        CALL XMTCME(NOMO  ,DEPMOI,DEPDEL,RESOCO)
      ELSEIF (ITERG.EQ.0) THEN      

        CALL XMMCME(NOMO  ,NOMA  ,DEPMOI,DEPDEL,RESOCO)

      ENDIF
C
      CALL JEDEMA()
      END
