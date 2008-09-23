      SUBROUTINE NMFPAS(FONACT,NUMEDD,SDDYNA,VALMOI,VALPLU,
     &                  SOLALG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      LOGICAL      FONACT(*)
      CHARACTER*24 VALMOI(8),VALPLU(8)
      CHARACTER*19 SOLALG(8)
      CHARACTER*19 SDDYNA 
      CHARACTER*24 NUMEDD      
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C MISE A JOUR DES CHAMPS D'INCONNUES POUR UN NOUVEAU PAS DE TEMPS
C      
C ----------------------------------------------------------------------
C
C
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  SDDYNA : SD DYNAMIQUE
C IN  NUMEDD : NOM DU NUME_DDL
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
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
      LOGICAL      NDYNLO,LDYNA
      CHARACTER*24 K24BID
      CHARACTER*24 DEPMOI,VARMOI,SIGMOI,COMMOI,VITMOI,ACCMOI
      CHARACTER*24 DEPPLU,VARPLU,SIGPLU,COMPLU,VITPLU,ACCPLU
      CHARACTER*24 DEPDEL,DEPOLD
      CHARACTER*19 NMCHEX      
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- FONCTIONNALITES ACTIVEES
C
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL DESAGG(VALMOI,DEPMOI,SIGMOI,VARMOI,COMMOI,
     &            VITMOI,ACCMOI,K24BID,K24BID)
      CALL DESAGG(VALPLU,DEPPLU,SIGPLU,VARPLU,COMPLU,
     &            VITPLU,ACCPLU,K24BID,K24BID) 
      DEPDEL = NMCHEX(SOLALG,'SOLALG','DEPDEL')
      DEPOLD = NMCHEX(SOLALG,'SOLALG','DEPOLD')           
C      
C --- POUR UNE PREDICTION PAR EXTRAP. DES INCREMENTS DU PAS D'AVANT
C
      CALL COPISD('CHAMP_GD','V',DEPDEL,DEPOLD)
C
C --- ETAT AU DEBUT DU NOUVEAU PAS DE TEMPS
C
      CALL COPISD('CHAMP_GD','V',DEPPLU,DEPMOI)
      CALL COPISD('CHAMP_GD','V',SIGPLU,SIGMOI)
      CALL COPISD('CHAMP_GD','V',VARPLU,VARMOI)
      CALL COPISD('VARI_COM','V',COMPLU,COMMOI)
C      
C --- ETAT AU DEBUT DU NOUVEAU PAS DE TEMPS EN DYNAMIQUE
C
      IF (LDYNA) THEN
        CALL COPISD('CHAMP_GD','V',VITPLU,VITMOI)
        CALL COPISD('CHAMP_GD','V',ACCPLU,ACCMOI)    
      ENDIF    
C
      CALL JEDEMA()      
C
      END
