      SUBROUTINE MMINIT(NOMA,DEFICO,CMD,
     &                  DEPMOI,DEPGEO,VITINI,VITPLU,ACCINI,ACCPLU,
     &                  OLDGEO,MAXB)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/09/2006   AUTEUR MABBAS M.ABBAS 
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
      IMPLICIT NONE
      CHARACTER*24 DEFICO
      CHARACTER*8  NOMA
      CHARACTER*16 CMD      
      CHARACTER*24 ACCPLU,VITPLU,ACCINI,VITINI
      CHARACTER*24 DEPMOI,DEPGEO,OLDGEO     
      INTEGER      MAXB(4)
C
C ----------------------------------------------------------------------
C ROUTINE APPELLEE PAR : NMIBLE
C ----------------------------------------------------------------------
C
C INITIALISATIONS POUR LA METHODE CONTINUE
C
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  NOMA   : NOM DU MAILLAGE
C IN  CMD    : COMMANDE COURANTE (STAT_NON_LINE,
C                                 DYNA_NON_LINE,DYNA_TRAN_EXPLI)
C IN  DEPMOI : DEPLACEMENTS A L'INSTANT MOINS
C IN  DEPGEO : DEPLACEMENTS SAUVEGARDES
C IN  VITINI : VITESSES INITIALES
C IN  VITPLU : VITESSES A L'INSTANT PLUS
C IN  VITINI : ACCELERATIONS INITIALES
C IN  VITPLU : ACCELERATIONS A L'INSTANT PLUS
C OUT OLDGEO : COORDONNEES INITALES DES NOEUDS
C OUT MAXB   : INFOS SUR BOUCLES CONTACT
C                MAXB(1): ITER_CONT_MAXI
C                MAXB(2): ITER_FROT_MAXI
C                MAXB(3): ITER_GEOM_MAXI
C                MAXB(4): 1 FROTTEMENT = 'SANS'
C                         3 FROTTEMENT = 'COULOMB'
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
      LOGICAL      LBID
      REAL*8       R8BID
      CHARACTER*24 K24BID,K24BLA
      DATA K24BLA /' '/   
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)     
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> <> INITIALISATIONS' 
      ENDIF 
C
C --- AFIN QUE LE VECTEUR DES FORCES D'INERTIE NE SOIT PAS MODIFIE AU
C --- COURS DE LA BOUCLE DES CONTRAINTES ACTIVES PAR L'APPEL A OP0070
C --- ON LE DUPLIQUE ET ON UTILISE CETTE COPIE FIXE (VITINI,ACCINI)
C
      IF (CMD(1:4) .EQ. 'DYNA') THEN
        CALL COPISD('CHAMP_GD','V',VITPLU,VITINI)
        CALL COPISD('CHAMP_GD','V',ACCPLU,ACCINI)
      END IF
C
C --- COORDONNEES INITALES DES NOEUDS
C      
      OLDGEO = NOMA//'.COORDO'
C
C --- SAUVEGARDE DEPLACEMENTS
C
      CALL COPISD('CHAMP_GD','V',DEPMOI,DEPGEO)
C
C --- INFOS BOUCLES CONTACT
C      
      CALL MMINFP(0,DEFICO,K24BLA,'ITER_CONT_MAXI',
     &            MAXB(1),R8BID,K24BID,LBID)
      CALL MMINFP(0,DEFICO,K24BLA,'ITER_FROT_MAXI',
     &            MAXB(2),R8BID,K24BID,LBID)
      CALL MMINFP(0,DEFICO,K24BLA,'ITER_GEOM_MAXI',
     &            MAXB(3),R8BID,K24BID,LBID) 
      CALL MMINFP(0,DEFICO,K24BLA,'FROTTEMENT',
     &            MAXB(4),R8BID,K24BID,LBID)    
C
      CALL JEDEMA()      
      END
