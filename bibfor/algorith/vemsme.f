      SUBROUTINE VEMSME(MODELE,MATE  ,CARCRI,CARELE,COMPOR,
     &                  INST  ,SDSENS,NRPASE,TYPESE,VEMASE)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT NONE
      CHARACTER*24 SDSENS      
      CHARACTER*24 MATE,MODELE,COMPOR,CARELE,CARCRI
      CHARACTER*8  VEMASE
      REAL*8       INST(*)      
      INTEGER      TYPESE,NRPASE
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - SENSIBILITE)
C
C CALCUL DES TERMES ELEMENTAIRES DU PSEUDO-CHARGEMENT
C  DU A LA DERIVATION (PARTIE COMPORTEMENT)
C       OPTION MECA_SENS_MATE : DERIVEE PAR RAPPORT AUX PARAM MATERIAUX
C       OPTION MECA_SENS_CHAR : DERIVEE PAR RAPPORT AU CHARGEMENT
C       OPTION MECA_SENS_EPAI : DERIVEE PAR RAPPORT A L'EPAISSEUR    
C
C ----------------------------------------------------------------------
C
C        
C IN  MODELE : MODELE
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  COMPOR : COMPORTEMENT  
C IN  INST   : PARAMETRES INTEGRATION EN TEMPS (T+, DT, THETA)
C IN  SDSENS : STRUCTURE DE DONNEES SENSIBILITE
C IN  NRPASE : NUMERO DU PARAMETRE SENSIBLE (0=CALCUL CLASSIQUE)
C IN  TYPESE : TYPE DE DERIVATION
C          -1 : DERIVATION EULERIENNE (VIA UN CHAMP THETA)
C           1 : CALCUL INSENSIBLE
C           2 : DEPLACEMENT IMPOSE
C           3 : PARAMETRE MATERIAU
C           4 : CARACTERISTIQUE ELEMENTAIRE (COQUES, ...)
C           5 : FORCE
C OUT VEMASE : VECTEURS ELEMENTAIRES DU PSEUDO-CHARGEMENT
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
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
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=2, NBIN=18)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      INTEGER      IBID,IAUX,JDUTMP,JDEPMO,NEQ,JVEMSM
      INTEGER      IRET,IRET1
      REAL*8       R8BID
      COMPLEX*16   C16BID
      CHARACTER*7  NOMCMP(3)      
      CHARACTER*8  NOMA,K8BID,MATERS
      CHARACTER*24 DEPPLU,DEPMOI,SIGMOI,VARMOI
      CHARACTER*24 SIGPLU,VARPLU,MATERI,MATSEN
      CHARACTER*24 DEPMOS,SIGPLS,SIGMOS,VARMOS,DUTMP,CACO3D,CHCARA(15)
      CHARACTER*19 LIGRMO,CHDERI,CHTIME
      CHARACTER*19 CHGEOM,CANBSP
      INTEGER      NBPASE
      CHARACTER*8  NOPASE
      CHARACTER*13 INPSCO    
      CHARACTER*24 STYPSE   
      CHARACTER*24 SENSNB,SENSIN
      INTEGER      JSENSN,JSENSI       
      LOGICAL      DEBUG,EXICAR
      CHARACTER*16 OPTION
      INTEGER      IFMDBG,NIVDBG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()  
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG)  
C    
      IF (NRPASE.EQ.0) GO TO 9999      
C
C --- INITIALISATIONS
C
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF 
C     
      IF ((TYPESE.EQ.2).OR.(TYPESE.EQ.5)) THEN
        OPTION='MECA_SENS_CHAR'
      ENDIF
      IF (TYPESE.EQ.3) THEN
        OPTION='MECA_SENS_MATE'
      ENDIF 
      IF (TYPESE.EQ.4) THEN
        OPTION='MECA_SENS_EPAI'
      ENDIF      
      DUTMP  = '&&VEMSME.DUTMP'
      CHDERI = VEMASE//'.PARSENS'
      CHTIME = '&&VEMSME.CH_INST_R'
      CANBSP = '&&VEMSME.NBSP'
      CACO3D = '&&MERIMO.CARA_ROTA_FICTIF'
C      
C --- DETERMINATION DU CHAMP DE GEOMETRIE
C
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,NOMA  ,IBID)
      CHGEOM = NOMA//'.COORDO'
C
C --- DETERMINATION DU LIGREL DU MODELE
C
      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IBID,LIGRMO,IBID)
C
C --- ACCES SD SENSIBILITE
C
      SENSIN = SDSENS(1:16)//'.INPSCO '     
      SENSNB = SDSENS(1:16)//'.NBPASE '
      CALL JEVEUO(SENSNB,'L',JSENSN)
      CALL JEVEUO(SENSIN,'L',JSENSI) 
      INPSCO = ZK16(JSENSI+1-1)       
      NBPASE = ZI(JSENSN+1-1) 
C
C --- NOM DU PARAMETRE SENSIBLE
C            
      CALL NMNSLE(SDSENS,NRPASE,'NOPASE',NOPASE) 
C
C --- TYPE DE SENSIBILITE
C
      CALL METYSE(NBPASE,INPSCO,NOPASE,TYPESE,STYPSE)    
      IF((TYPESE.NE.2).AND.(TYPESE.NE.3).AND.
     &   (TYPESE.NE.4).AND.(TYPESE.NE.5)) THEN
        CALL U2MESI('A','SENSIBILITE_1', 1 , TYPESE)
        CALL U2MESK('F','UTILITAI7_99' , 1 ,'VEMSME')
      ENDIF 
C      
C --- DETERMINATION DU CHAMP DE CARACTERISTIQUES ELEMENTS DE STRUCTURE
C
      CALL MECARA(CARELE,EXICAR,CHCARA)   
C
C --- DETERMINATION DES INSTANTS DE CALCUL
C
      NOMCMP(1) = 'INST   '
      NOMCMP(2) = 'DELTAT '
      NOMCMP(3) = 'THETA  '
      CALL MECACT('V'   ,CHTIME,'LIGREL',LIGRMO,'INST_R  ',
     &            3     ,NOMCMP,IBID    ,INST  ,C16BID    ,
     &            K8BID )              
C      
C --- CREATION D'UNE CARTE UNIFORME CONTENANT STYPSE
C    
      CALL MECACT('V'   ,CHDERI,'MAILLAGE',NOMA  ,'NEUT_K24',
     &            1     ,'Z1'  ,IBID      ,R8BID ,C16BID    ,
     &            STYPSE)                      
C
C --- ALLOCATION DU VECT_ELEM RESULTAT 
C    
      CALL DETRSD('VECT_ELEM',VEMASE)
      CALL MEMARE('V',VEMASE,MODELE,MATE,K8BID,'CHAR_MECA')
      CALL WKVECT(VEMASE//'.LISTE_RESU','V V K24',1,JVEMSM)
      CALL JEECRA(VEMASE//'.LISTE_RESU','LONUTI',1,K8BID)
      ZK24(JVEMSM-1+1) = VEMASE//'.SECOND'
C
C --- LECTURE DES CHAMPS DIRECTS
C
      IAUX = 0    
      CALL NMNSLE(SDSENS,IAUX  ,'DEPPLU',DEPPLU)
      CALL NMNSLE(SDSENS,IAUX  ,'DEPMOI',DEPMOI)
      CALL NMNSLE(SDSENS,IAUX  ,'SIGPLU',SIGPLU)
      CALL NMNSLE(SDSENS,IAUX  ,'SIGMOI',SIGMOI)
      CALL NMNSLE(SDSENS,IAUX  ,'VARPLU',VARPLU)
      CALL NMNSLE(SDSENS,IAUX  ,'VARMOI',VARMOI)   
C
C --- LECTURE DES CHAMPS DERIVES
C
      CALL NMNSLE(SDSENS,NRPASE,'DEPMOI',DEPMOS)
      CALL NMNSLE(SDSENS,NRPASE,'SIGPLU',SIGPLS)
      CALL NMNSLE(SDSENS,NRPASE,'SIGMOI',SIGMOS)
      CALL NMNSLE(SDSENS,NRPASE,'VARMOI',VARMOS)    
C
C --- CALCUL DE L'INCREMENT DE DEPLACEMENT
C
      CALL JELIRA(DEPMOI(1:19)//'.VALE','LONMAX',NEQ,K8BID)
      CALL COPISD('CHAMP_GD','V',DEPPLU,DUTMP)
      CALL JEVEUO(DUTMP(1:19)//'.VALE', 'E',JDUTMP)
      CALL JEVEUO(DEPMOI(1:19)//'.VALE','L',JDEPMO)
      CALL DAXPY (NEQ,-1.D0,ZR(JDEPMO),1,ZR(JDUTMP),1)
C
C --- DEFINITION DU MATERIAU DERIVE CODE
C
      IF (TYPESE.EQ.3) THEN
C      DETERMINATION DU CHAMP MATERIAU A PARTIR DE LA CARTE CODEE
        MATERI = MATE(1:8)
C      DETERMINATION DU CHAMP MATERIAU DERIVE NON CODE MATSEN
        CALL PSGENC(MATERI,NOPASE,MATERS,IRET)
        IF (IRET.NE.0) THEN
          CALL U2MESK('F','CALCULEL2_87',1,MATERI)
        END IF
C      TRANSFORMATION EN CHAMP MATERIAU DERIVE CODE
        MATSEN = '                        '
        MATSEN(1:24) = MATERS(1:8)//MATE(9:24)
      ELSE
        MATSEN = '                        '
      ENDIF
C
C --- CHAMPS D'ENTREE
C --- POUR SECOND MEMBRE ET DE LA DERIVEE DU CHAMP DE DEPL
C    
      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = CHGEOM
      LPAIN(2)  = 'PMATERC'
      LCHIN(2)  = MATE(1:19)
      LPAIN(3)  = 'PCOMPOR'
      LCHIN(3)  = COMPOR(1:19)
      LPAIN(4)  = 'PCONTMR'
      LCHIN(4)  = SIGMOI(1:19)
      LPAIN(5)  = 'PCONTMS'
      LCHIN(5)  = SIGMOS(1:19)
      LPAIN(6)  = 'PVARIMS'
      LCHIN(6)  = VARMOS(1:19)
      LPAIN(7)  = 'PDEPLMR'
      LCHIN(7)  = DEPMOI(1:19)
      LPAIN(8)  = 'PDEPLPR'
      LCHIN(8)  = DUTMP(1:19)
      LPAIN(9)  =  'PVARIMR'
      LCHIN(9)  =  VARMOI(1:19)
      LPAIN(10) = 'PARSENS'
      LCHIN(10) = CHDERI
      LPAIN(11) =  'PVARIPR'
      LCHIN(11) =  VARPLU(1:19)
      LPAIN(12) = 'PCONTPR'
      LCHIN(12) = SIGPLU(1:19)
      LPAIN(13) = 'PMATSEN'
      LCHIN(13) = MATSEN(1:19)
      LPAIN(14) = 'PCACOQU'
      IF(EXICAR) THEN
        LCHIN(14) = CHCARA(7)
      ELSE
        LCHIN(14) = ' '
      ENDIF
      LPAIN(15) = 'PNBSP_I'
      IF(EXICAR) THEN
        LCHIN(15) = CHCARA(1)(1:8)//'.CANBSP'
      ELSE
        LCHIN(15) = ' '
      ENDIF
      LPAIN(16) = 'PCARCRI'
      LCHIN(16) = CARCRI
      LPAIN(17) = 'PTEMPSR'
      LCHIN(17) = CHTIME
      LPAIN(18) = 'PCACO3D'
      LCHIN(18) = CACO3D          
C
C --- CHAMPS DE SORTIE
C
      LPAOUT(1) = 'PVECTUR'
      LCHOUT(1) = VEMASE//'.SECOND'
      LPAOUT(2) = 'PCONTPS'
      LCHOUT(2) = SIGPLS(1:19)
C      
C ---DANS LE CAS DES COQUES ON ETEND LE CHAMP DE CONTRAINTES SENSIBLES
C    
      IF(EXICAR) THEN
        
        CALL EXISD('CHAM_ELEM_S',CANBSP,IRET1)
        IF (IRET1.NE.1) CALL CESVAR(CHCARA(1),' ',LIGRMO,CANBSP)
        CALL COPISD('CHAM_ELEM_S','V',CANBSP,SIGPLS)
      ENDIF      
C
C --- CALCUL DU PSEUDO-CHARGEMENT
C   
      CALL CALCUL('S',OPTION,LIGRMO,NBIN ,LCHIN ,LPAIN ,
     &                              NBOUT,LCHOUT,LPAOUT,'V')
C
      IF (DEBUG) THEN
        CALL DBGCAL(OPTION,IFMDBG,
     &              NBIN  ,LPAIN ,LCHIN ,
     &              NBOUT ,LPAOUT,LCHOUT)
        WRITE (IFMDBG,*) '<SENSIBILITE> <VEMSME> CALCUL DU '//
     &                'PSEUDO-CHARGEMENT PAR RAPPORT A ',NOPASE
      END IF
C
C --- MENAGE
C  
      CALL JEDETR(DUTMP)

9999  CONTINUE

      CALL JEDEMA()
      END
