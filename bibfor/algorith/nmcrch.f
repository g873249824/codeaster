      SUBROUTINE NMCRCH(NUMEDD,SDDYNA,SDSENS,POUGD ,DEPALG,
     &                  VEELEM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21
C
      IMPLICIT NONE
      CHARACTER*19     SDDYNA 
      CHARACTER*24     SDSENS,NUMEDD
      CHARACTER*24     POUGD(8),DEPALG(8)     
      CHARACTER*19     VEELEM(30)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - INITIALISATIONS)
C
C CREATION DES VECTEURS D'INCONNUS
C      
C ----------------------------------------------------------------------
C 
C IN  SDSENS : SD SENSIBILITE
C IN  SDDYNA : SD DYNAMIQUE
C IN  NUMEDD : NUME_DDL
C IN  POUGD  : INFOS POUTRES EN GRANDES ROTATIONS
C IN  DEPALG : VARIABLE CHAPEAU POUR DEPLACEMENTS   
C IN  VEELEM : VECTEURS ELEMENTAIRES
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      IFM,NIV
      LOGICAL      NDYNLO,LMUAP,LDYNA
      INTEGER      NRPASE,NBPASE,NEQ
      CHARACTER*24 SENSNB
      INTEGER      JSENSN 
      CHARACTER*24 K24BID,NDYNKK
      CHARACTER*24 DEPPLU,VITPLU,ACCPLU
      CHARACTER*24 DEPMOI,VITMOI,ACCMOI
      CHARACTER*24 DEPDEL,DEPOLD,DDEPLA,DEPPRE(2)
      CHARACTER*24 DEPKM1,VITKM1,ACCKM1,ROMKM1,ROMK     
      CHARACTER*24 DEPENT,VITENT,ACCENT   
      CHARACTER*24 DEPENM,VITENM,ACCENM,CNINER 
      CHARACTER*19 VEINER,VEHYST,VEMODA                       
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CREATION VECTEURS INCONNUES' 
      ENDIF   
C
C --- FONCTIONNALITES ACTIVEES
C
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE') 
      LMUAP  = NDYNLO(SDDYNA,'MULTI_APPUI')           
C
C --- ACCES SD SENSIBILITE
C    
      SENSNB = SDSENS(1:16)//'.NBPASE '
      CALL JEVEUO(SENSNB,'E',JSENSN) 
      NBPASE = ZI(JSENSN+1-1)
C
C --- EXTRACTION VARIABLES CHAPEAUX
C       
      CALL DESAGG(POUGD ,DEPKM1,VITKM1,ACCKM1,ROMKM1,
     &            ROMK  ,K24BID,K24BID,K24BID)
      CALL DESAGG(DEPALG,DDEPLA,DEPDEL,DEPOLD,DEPPRE(1),
     &            DEPPRE(2),K24BID,K24BID,K24BID)                     
C
C --- CREATION DES CHAMPS DANS LE CAS OU SENSIBILITE
C
      DO 6 NRPASE = NBPASE,0,-1
        CALL NMNSLE(SDSENS,NRPASE,'DEPPLU',DEPPLU)
        CALL NMNSLE(SDSENS,NRPASE,'DEPMOI',DEPMOI)        
        CALL VTCREB(DEPPLU,NUMEDD,'V','R',NEQ)
        CALL VTCREB(DEPMOI,NUMEDD,'V','R',NEQ)   
        IF (LDYNA) THEN
          CALL NMNSLE(SDSENS,NRPASE,'VITPLU',VITPLU)
          CALL NMNSLE(SDSENS,NRPASE,'ACCPLU',ACCPLU)
          CALL NMNSLE(SDSENS,NRPASE,'VITMOI',VITMOI)
          CALL NMNSLE(SDSENS,NRPASE,'ACCMOI',ACCMOI)
          CALL VTCREB(VITPLU,NUMEDD,'V','R',NEQ)   
          CALL VTCREB(ACCPLU,NUMEDD,'V','R',NEQ) 
          CALL VTCREB(VITMOI,NUMEDD,'V','R',NEQ)
          CALL VTCREB(ACCMOI,NUMEDD,'V','R',NEQ) 
        ENDIF
 6    CONTINUE
C
C --- CREATION DES AUTRES CHAMPS (PAS DE SENSIBILITE)
C
      CALL VTCREB(DEPDEL,NUMEDD,'V','R',NEQ)
      CALL VTCREB(DDEPLA,NUMEDD,'V','R',NEQ)
      CALL VTCREB(DEPOLD,NUMEDD,'V','R',NEQ)
      CALL VTCREB(DEPPRE(1),NUMEDD,'V','R',NEQ)
      CALL VTCREB(DEPPRE(2),NUMEDD,'V','R',NEQ)
      CALL VTCREB(DEPKM1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(VITKM1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(ACCKM1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(ROMKM1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(ROMK  ,NUMEDD,'V','R',NEQ)
      IF (LDYNA) THEN
        DEPENT = NDYNKK(SDDYNA,'DEPENT')
        VITENT = NDYNKK(SDDYNA,'VITENT')
        ACCENT = NDYNKK(SDDYNA,'ACCENT')
        CALL VTCREB(DEPENT,NUMEDD,'V','R',NEQ)
        CALL VTCREB(VITENT,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCENT,NUMEDD,'V','R',NEQ) 
        CNINER = NDYNKK(SDDYNA,'CNINER')
        CALL VTCREB(CNINER,NUMEDD,'V','R',NEQ)               
      ENDIF
      IF (LMUAP) THEN
        DEPENM = NDYNKK(SDDYNA,'DEPENM')
        VITENM = NDYNKK(SDDYNA,'VITENM')
        ACCENM = NDYNKK(SDDYNA,'ACCENM')           
        CALL VTCREB(DEPENM,NUMEDD,'V','R',NEQ)
        CALL VTCREB(VITENM,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCENM,NUMEDD,'V','R',NEQ)
      ENDIF      
C
C
C --- CREATION DE CHAMPS NODAUX PARTAGES (PASSES EN SOUTERRAIN)
C      OBJECTIFS :
C         NE PAS FRAGMENTER LA MEMOIRE
C      REGLES :
C         CNZERO : LECTURE SEULE -> IL VAUT TJRS 0
C         CNTMPX : NE TRANSITENT PAS D'UNE ROUTINE A L'AUTRE

      CALL VTCREB('&&CNPART.ZERO',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNPART.CHP1',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNPART.CHP2',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNPART.CHP3',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNREPL.CHP1',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNREPL.CHP2',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCETA.CHP0',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCETA.CHP1',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCETA.CHP2',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&NMDESC.SOLU',NUMEDD,'V','R',NEQ) 
C     
C --- PAS VRAIMENT DES VECT_ELEM MAIS DES CHAM_NO A CREER
C 
      VEINER = VEELEM(12) 
      VEHYST = VEELEM(13)  
      VEMODA = VEELEM(14) 
      CALL VTCREB(VEINER,NUMEDD,'V','R',NEQ)
      CALL VTCREB(VEHYST,NUMEDD,'V','R',NEQ) 
      CALL VTCREB(VEMODA,NUMEDD,'V','R',NEQ)                   
C
      CALL JEDEMA()
      END
