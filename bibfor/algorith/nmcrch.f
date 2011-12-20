      SUBROUTINE NMCRCH(NUMEDD,FONACT,SDDYNA,SDSENS,DEFICO,
     &                  VALINC,SOLALG,VEASSE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/10/2011   AUTEUR MACOCCO K.MACOCCO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER       FONACT(*)
      CHARACTER*19  SDDYNA 
      CHARACTER*24  SDSENS,NUMEDD,DEFICO    
      CHARACTER*19  SOLALG(*),VEASSE(*)
      CHARACTER*19  VALINC(*)
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
C IN  DEFICO : DEFINITION CONTACT
C IN  NUMEDD : NUME_DDL
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES 
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
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
      LOGICAL      LDYNA,LAMMO,LMPAS,LREFE,LMACR
      LOGICAL      LELTC,LELTF
      LOGICAL      LUNIL,LCTCD,LCTFD,LPENAC,LALLV
      LOGICAL      NDYNLO,ISFONC,CFDISL
      LOGICAL      LSSTF,LIMPE
      LOGICAL      LDIDI,LPILO
      INTEGER      NRPASE,NBPASE,NEQ
      CHARACTER*24 SENSNB
      INTEGER      JSENSN 
      CHARACTER*19 DEPPLU,VITPLU,ACCPLU
      CHARACTER*19 DEPMOI,VITMOI,ACCMOI
      CHARACTER*19 DEPSO1,DEPSO2
      CHARACTER*19 DEPDEL,DEPOLD,DDEPLA,DEPPR1,DEPPR2
      CHARACTER*19 VITDEL,VITOLD,DVITLA,VITPR1,VITPR2
      CHARACTER*19 ACCDEL,ACCOLD,DACCLA,ACCPR1,ACCPR2      
      CHARACTER*19 DEPKM1,VITKM1,ACCKM1,ROMKM1,ROMK
      CHARACTER*19 CNDYNA,CNMODP,CNMODC
      CHARACTER*19 CNFEXT,CNVCF1
      CHARACTER*19 CNFEDO,CNFSDO,CNDIDI,CNFINT
      CHARACTER*19 CNDIDO,CNCINE,CNDIRI
      CHARACTER*19 CNONDP,CNLAPL 
      CHARACTER*19 CNSSTF,CNSSTR  
      CHARACTER*19 CNCTDC,CNCTDF,CNUNIL   
      CHARACTER*19 CNELTC,CNELTF
      CHARACTER*19 CNIMPP,CNIMPC
      CHARACTER*19 CNFEPI,CNDIPI,CNREFE    
      CHARACTER*19 DEPENT,VITENT,ACCENT
      CHARACTER*19 DEPABS,VITABS,ACCABS
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
      LMACR  = ISFONC(FONACT,'MACR_ELEM_STAT')       
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE') 
      LAMMO  = NDYNLO(SDDYNA,'AMOR_MODAL') 
      LMPAS  = NDYNLO(SDDYNA,'MULTI_PAS')
      LCTCD  = ISFONC(FONACT,'CONT_DISCRET')
      LCTFD  = ISFONC(FONACT,'FROT_DISCRET')
      LALLV  = ISFONC(FONACT,'CONT_ALL_VERIF')
      LUNIL  = ISFONC(FONACT,'LIAISON_UNILATER')
      LDIDI  = ISFONC(FONACT,'DIDI')
      LPILO  = ISFONC(FONACT,'PILOTAGE')  
      LSSTF  = ISFONC(FONACT,'SOUS_STRUC')    
      LREFE  = ISFONC(FONACT,'RESI_REFE') 
      LIMPE  = NDYNLO(SDDYNA,'IMPE_ABSO')
            
      IF (LCTCD) THEN
        LPENAC = CFDISL(DEFICO,'CONT_PENA'   )
      ELSE
        LPENAC = .FALSE.  
      ENDIF  
      LELTC  = ISFONC(FONACT,'ELT_CONTACT')
      LELTF  = ISFONC(FONACT,'ELT_FROTTEMENT')
C
C --- ACCES SD SENSIBILITE
C    
      SENSNB = SDSENS(1:16)//'.NBPASE '
      CALL JEVEUO(SENSNB,'E',JSENSN) 
      NBPASE = ZI(JSENSN+1-1)
C
C --- CREATION DES CHAMPS DE BASE - ETAT EN T-
C
      CALL NMCHEX(VALINC,'VALINC','DEPMOI',DEPMOI) 
      CALL NMCHEX(VALINC,'VALINC','VITMOI',VITMOI)
      CALL NMCHEX(VALINC,'VALINC','ACCMOI',ACCMOI) 
      CALL VTCREB(DEPMOI,NUMEDD,'V','R',NEQ) 
      IF (LDYNA) THEN
        CALL VTCREB(VITMOI,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCMOI,NUMEDD,'V','R',NEQ)      
      ENDIF
C
C --- CREATION DES CHAMPS DE BASE - ETAT EN T+
C   
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU) 
      CALL NMCHEX(VALINC,'VALINC','VITPLU',VITPLU)
      CALL NMCHEX(VALINC,'VALINC','ACCPLU',ACCPLU)
      CALL VTCREB(DEPPLU,NUMEDD,'V','R',NEQ) 
      IF (LDYNA) THEN
        CALL VTCREB(VITPLU,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCPLU,NUMEDD,'V','R',NEQ)      
      ENDIF               
C
C --- CREATION DES CHAMPS SENSIBILITE - ETAT EN T-
C
      DO 6 NRPASE = NBPASE,1,-1
        CALL NMNSLE(SDSENS,NRPASE,'DEPMOI',DEPMOI)        
        CALL VTCREB(DEPMOI,NUMEDD,'V','R',NEQ)   
        IF (LDYNA) THEN
          CALL NMNSLE(SDSENS,NRPASE,'VITMOI',VITMOI)
          CALL NMNSLE(SDSENS,NRPASE,'ACCMOI',ACCMOI)
          CALL VTCREB(VITMOI,NUMEDD,'V','R',NEQ)
          CALL VTCREB(ACCMOI,NUMEDD,'V','R',NEQ) 
        ENDIF
 6    CONTINUE
C
C --- CREATION DES CHAMPS SENSIBILITE - ETAT EN T+
C
      DO 7 NRPASE = NBPASE,1,-1
        CALL NMNSLE(SDSENS,NRPASE,'DEPPLU',DEPPLU)        
        CALL VTCREB(DEPPLU,NUMEDD,'V','R',NEQ)   
        IF (LDYNA) THEN
          CALL NMNSLE(SDSENS,NRPASE,'VITPLU',VITPLU)
          CALL NMNSLE(SDSENS,NRPASE,'ACCPLU',ACCPLU)
          CALL VTCREB(VITPLU,NUMEDD,'V','R',NEQ)   
          CALL VTCREB(ACCPLU,NUMEDD,'V','R',NEQ) 
        ENDIF
 7    CONTINUE 
C
C --- CREATION DES CHAMPS DE BASE - POUTRES EN GRANDES ROTATIONS
C 
      CALL NMCHEX(VALINC,'VALINC','DEPKM1',DEPKM1)
      CALL NMCHEX(VALINC,'VALINC','VITKM1',VITKM1)
      CALL NMCHEX(VALINC,'VALINC','ACCKM1',ACCKM1)
      CALL NMCHEX(VALINC,'VALINC','ROMKM1',ROMKM1)
      CALL NMCHEX(VALINC,'VALINC','ROMK  ',ROMK  )
      CALL VTCREB(DEPKM1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(VITKM1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(ACCKM1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(ROMKM1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(ROMK  ,NUMEDD,'V','R',NEQ) 
C
C --- CREATION DES CHAMPS DE BASE - INCREMENTS SOLUTIONS
C
      CALL NMCHEX(SOLALG,'SOLALG','DEPDEL',DEPDEL)
      CALL NMCHEX(SOLALG,'SOLALG','DDEPLA',DDEPLA)
      CALL NMCHEX(SOLALG,'SOLALG','DEPPR1',DEPPR1)
      CALL NMCHEX(SOLALG,'SOLALG','DEPPR2',DEPPR2)
      CALL NMCHEX(SOLALG,'SOLALG','DEPOLD',DEPOLD)
      CALL VTCREB(DEPDEL,NUMEDD,'V','R',NEQ)
      CALL VTCREB(DDEPLA,NUMEDD,'V','R',NEQ)
      CALL VTCREB(DEPOLD,NUMEDD,'V','R',NEQ)
      CALL VTCREB(DEPPR1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(DEPPR2,NUMEDD,'V','R',NEQ)
      IF (LDYNA) THEN
        CALL NMCHEX(SOLALG,'SOLALG','VITDEL',VITDEL)
        CALL NMCHEX(SOLALG,'SOLALG','DVITLA',DVITLA)
        CALL NMCHEX(SOLALG,'SOLALG','VITPR1',VITPR1)
        CALL NMCHEX(SOLALG,'SOLALG','VITPR2',VITPR2)
        CALL NMCHEX(SOLALG,'SOLALG','VITOLD',VITOLD)
        CALL VTCREB(VITDEL,NUMEDD,'V','R',NEQ)
        CALL VTCREB(DVITLA,NUMEDD,'V','R',NEQ)
        CALL VTCREB(VITOLD,NUMEDD,'V','R',NEQ)
        CALL VTCREB(VITPR1,NUMEDD,'V','R',NEQ)
        CALL VTCREB(VITPR2,NUMEDD,'V','R',NEQ)      
        CALL NMCHEX(SOLALG,'SOLALG','ACCDEL',ACCDEL)
        CALL NMCHEX(SOLALG,'SOLALG','DACCLA',DACCLA)
        CALL NMCHEX(SOLALG,'SOLALG','ACCPR1',ACCPR1)
        CALL NMCHEX(SOLALG,'SOLALG','ACCPR2',ACCPR2)
        CALL NMCHEX(SOLALG,'SOLALG','ACCOLD',ACCOLD)
        CALL VTCREB(ACCDEL,NUMEDD,'V','R',NEQ)
        CALL VTCREB(DACCLA,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCOLD,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCPR1,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCPR2,NUMEDD,'V','R',NEQ)       
      ENDIF
C
C --- REACTIONS D'APPUI BT.LAMBDA
C
      CALL NMCHEX(VEASSE,'VEASSE','CNDIRI',CNDIRI) 
      CALL VTCREB(CNDIRI,NUMEDD,'V','R',NEQ)       
C
C --- VECTEURS SOLUTION
C 
      CALL NMCHEX(SOLALG,'SOLALG','DEPSO1',DEPSO1)    
      CALL NMCHEX(SOLALG,'SOLALG','DEPSO2',DEPSO2)
      CALL VTCREB(DEPSO1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(DEPSO2,NUMEDD,'V','R',NEQ)
C
C --- FORCES D'IMPEDANCES (PREDICTION ET CORRECTION)
C
      IF (LIMPE) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNIMPP',CNIMPP)
        CALL VTCREB(CNIMPP,NUMEDD,'V','R',NEQ) 
        CALL NMCHEX(VEASSE,'VEASSE','CNIMPC',CNIMPC) 
        CALL VTCREB(CNIMPC,NUMEDD,'V','R',NEQ)          
      ENDIF           
C
C --- SECOND MEMBRE
C
      CALL NMCHEX(VEASSE,'VEASSE','CNFEDO',CNFEDO)
      CALL VTCREB(CNFEDO,NUMEDD,'V','R',NEQ) 
      CALL NMCHEX(VEASSE,'VEASSE','CNFSDO',CNFSDO) 
      CALL VTCREB(CNFSDO,NUMEDD,'V','R',NEQ)
      CALL NMCHEX(VEASSE,'VEASSE','CNDIDO',CNDIDO)
      IF (LDIDI) THEN     
        CALL NMCHEX(VEASSE,'VEASSE','CNDIDI',CNDIDI) 
        CALL VTCREB(CNDIDI,NUMEDD,'V','R',NEQ) 
      ENDIF      
      IF (LPILO) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNFEPI',CNFEPI)
        CALL VTCREB(CNFEPI,NUMEDD,'V','R',NEQ) 
        CALL NMCHEX(VEASSE,'VEASSE','CNDIPI',CNDIPI)  
        CALL VTCREB(CNDIPI,NUMEDD,'V','R',NEQ)      
      ENDIF     
C     
C --- PAS VRAIMENT DES VECT_ELEM MAIS DES CHAM_NO A CREER
C 
      CALL NMCHEX(VEASSE,'VEASSE','CNFEXT',CNFEXT)
      CALL NMCHEX(VEASSE,'VEASSE','CNFINT',CNFINT) 
      CALL NMCHEX(VEASSE,'VEASSE','CNVCF1',CNVCF1)    
      CALL VTCREB(CNFEXT,NUMEDD,'V','R',NEQ)  
      CALL VTCREB(CNFINT,NUMEDD,'V','R',NEQ)   
      CALL VTCREB(CNVCF1,NUMEDD,'V','R',NEQ)       
          
      IF (LDYNA) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNDYNA',CNDYNA)
        CALL VTCREB(CNDYNA,NUMEDD,'V','R',NEQ) 
        IF (LMPAS) THEN
          CALL NDYNKK(SDDYNA,'OLDP_CNFEDO',CNFEDO)
          CALL VTCREB(CNFEDO,NUMEDD,'V','R',NEQ) 
          CALL NDYNKK(SDDYNA,'OLDP_CNFSDO',CNFSDO) 
          CALL VTCREB(CNFSDO,NUMEDD,'V','R',NEQ)
          CALL NDYNKK(SDDYNA,'OLDP_CNDIDO',CNDIDO)
          CALL VTCREB(CNDIDO,NUMEDD,'V','R',NEQ)  
          CALL NDYNKK(SDDYNA,'OLDP_CNDIDI',CNDIDI) 
          CALL VTCREB(CNDIDI,NUMEDD,'V','R',NEQ)
          CALL NDYNKK(SDDYNA,'OLDP_CNFINT',CNFINT)
          CALL VTCREB(CNFINT,NUMEDD,'V','R',NEQ)  
          CALL NDYNKK(SDDYNA,'OLDP_CNONDP',CNONDP) 
          CALL VTCREB(CNONDP,NUMEDD,'V','R',NEQ)
          CALL NDYNKK(SDDYNA,'OLDP_CNLAPL',CNLAPL) 
          CALL VTCREB(CNLAPL,NUMEDD,'V','R',NEQ)
          CALL NDYNKK(SDDYNA,'OLDP_CNSSTF',CNSSTF)
          CALL VTCREB(CNSSTF,NUMEDD,'V','R',NEQ)
          CALL NDYNKK(SDDYNA,'OLDP_CNCINE',CNCINE) 
          CALL VTCREB(CNCINE,NUMEDD,'V','R',NEQ) 
        ENDIF
      ENDIF
C
C --- FORCES ISSUES DES MACRO-ELEMENTS STATIQUES
C      
      IF (LMACR) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNSSTR',CNSSTR) 
        CALL VTCREB(CNSSTR,NUMEDD,'V','R',NEQ)
      ENDIF      
C
C --- CALCUL PAR SOUS-STRUCTURATION
C
      IF (LSSTF) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNSSTF',CNSSTF)
        CALL VTCREB(CNSSTF,NUMEDD,'V','R',NEQ)        
      ENDIF
C
C --- AMORTISSEMENT MODAL
C      
      IF (LAMMO) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNMODP',CNMODP)
        CALL NMCHEX(VEASSE,'VEASSE','CNMODC',CNMODC)
        CALL VTCREB(CNMODP,NUMEDD,'V','R',NEQ)
        CALL VTCREB(CNMODC,NUMEDD,'V','R',NEQ)             
      ENDIF            
C
C --- CONTACT/FROTTEMENT DISCRET
C
      IF (LCTCD.AND.(.NOT.LALLV)) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNCTDC',CNCTDC)
        CALL VTCREB(CNCTDC,NUMEDD,'V','R',NEQ)
      ENDIF    
      IF ((LCTFD.OR.LPENAC).AND.(.NOT.LALLV)) THEN 
        CALL NMCHEX(VEASSE,'VEASSE','CNCTDF',CNCTDF)
        CALL VTCREB(CNCTDF,NUMEDD,'V','R',NEQ)      
      ENDIF
C
C --- LIAISON UNILATERALE
C
      IF (LUNIL) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNUNIL',CNUNIL)
        CALL VTCREB(CNUNIL,NUMEDD,'V','R',NEQ)      
      ENDIF      
C
C --- CONTACT AVEC DES ELEMENTS FINIS (CONTINUE/XFEM)
C --- POUR USURE ACHARD, VECT_ELEM ET VECT_ASSE BIDONS !
C
      IF (LELTC.AND.(.NOT.LALLV)) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNELTC',CNELTC)  
        CALL VTCREB(CNELTC,NUMEDD,'V','R',NEQ)    
      ENDIF
C
C --- FROTTEMENT AVEC DES ELEMENTS FINIS (CONTINUE/XFEM)
C --- POUR USURE ACHARD, VECT_ELEM ET VECT_ASSE BIDONS !
C
      IF (LELTF.AND.(.NOT.LALLV)) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNELTF',CNELTF)  
        CALL VTCREB(CNELTF,NUMEDD,'V','R',NEQ)    
      ENDIF         
C
C --- RESIDU DE REFERENCE
C
      IF (LREFE) THEN
        CALL NMCHEX(VEASSE,'VEASSE','CNREFE',CNREFE)
        CALL VTCREB(CNREFE,NUMEDD,'V','R',NEQ)      
      ENDIF
C
C --- MULTI-APPUIS
C
      IF (LDYNA) THEN
        CALL NDYNKK(SDDYNA,'DEPENT',DEPENT)
        CALL NDYNKK(SDDYNA,'VITENT',VITENT)
        CALL NDYNKK(SDDYNA,'ACCENT',ACCENT)
        CALL NDYNKK(SDDYNA,'DEPABS',DEPABS)
        CALL NDYNKK(SDDYNA,'VITABS',VITABS)
        CALL NDYNKK(SDDYNA,'ACCABS',ACCABS)
        CALL VTCREB(DEPENT,NUMEDD,'V','R',NEQ)
        CALL VTCREB(VITENT,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCENT,NUMEDD,'V','R',NEQ)
        CALL VTCREB(DEPABS,NUMEDD,'V','R',NEQ)
        CALL VTCREB(VITABS,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCABS,NUMEDD,'V','R',NEQ)
      ENDIF   
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
      CALL VTCREB('&&CNREPL.CHP3',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNREPL.CHP4',NUMEDD,'V','R',NEQ)            
      CALL VTCREB('&&CNCETA.CHP0',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCETA.CHP1',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCETA.CHP2',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCHAR.FFDO',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCHAR.FFPI',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCHAR.DFDO',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCHAR.DFPI',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCHAR.FVDO',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCHAR.FVDY',NUMEDD,'V','R',NEQ)      
      CALL VTCREB('&&CNCHAR.DUMM',NUMEDD,'V','R',NEQ)
      CALL VTCREB('&&CNCHAR.CINE',NUMEDD,'V','R',NEQ)      
      CALL VTCREB('&&CNCHAR.DONN',NUMEDD,'V','R',NEQ)      
      CALL VTCREB('&&CNCHAR.PILO',NUMEDD,'V','R',NEQ)
C
      CALL JEDEMA()
      END
