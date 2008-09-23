      SUBROUTINE NMCOFR(NOMA  ,DEPPLU,DEPDEL,DDEPLA,MATASS,
     &                  DEFICO,RESOCO,CNCINE,INSTAN,RESIGR,
     &                  SDTIME,CTCCVG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*8  NOMA
      CHARACTER*24 DEPPLU
      CHARACTER*19 DEPDEL,DDEPLA      
      CHARACTER*24 DEFICO,RESOCO,SDTIME
      CHARACTER*19 CNCINE
      CHARACTER*19 MATASS
      REAL*8       INSTAN
      REAL*8       RESIGR
      INTEGER      CTCCVG(2)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES)
C
C TRAITEMENT DU CONTACT AVEC OU SANS FROTTEMENT DANS STAT_NON_LINE.
C BRANCHEMENT SUR LES ROUTINES DE RESOLUTION
C
C ----------------------------------------------------------------------
C
C 
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEPPLU : CHAMP DE DEPLACEMENTS A L'ITERATION DE NEWTON PRECEDENTE
C IN  DEPDEL : INCREMENT DE DEPLACEMENT CUMULE
C IN  DEPPLA : INCREMENT DE DEPLACEMENTS CALCULE EN IGNORANT LE CONTACT
C IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  SDTIME : SD TIMER
C IN  CNCINE : CHAM_NO CINEMATIQUE
C IN  RESIGR : RESI_GLOB_RELA
C IN  INSTAN : VALEUR DE L'INSTANT DE CALCUL
C OUT CTCCVG : CODES RETOURS D'ERREUR DU CONTACT
C                       (1) NOMBRE MAXI D'ITERATIONS
C                       (2) MATRICE SINGULIERE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL      PREMIE
      INTEGER      ICONTA,JPREM,TYPALC
      REAL*8       TPSGEO,TPSALG,R8BID
      INTEGER      IFM,NIV  
      INTEGER      IBID 
      LOGICAL      LBID
      CHARACTER*24 CLREAC
      INTEGER      JCLREA
      LOGICAL      REAGEO,CTCFIX,REAPRE           
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()      
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- TRAITEMENT DU CONTACT ?
C
      CALL JEEXIN ( RESOCO(1:14)//'.APREAC', ICONTA )
      IF (ICONTA.EQ.0) THEN
        GOTO 999
      ENDIF
C
C --- TYPE DE CONTACT
C
      CALL CFDISC(DEFICO,' ',TYPALC,IBID,IBID,IBID)
C
C --- ACCES OBJETS
C          
      CLREAC = RESOCO(1:14)//'.REAL'             
      CALL JEVEUO(CLREAC,'E',JCLREA)
C
C --- PARAMETRES POUR BOUCLES GEOMETRIQUE/PT FIXE
C      
      REAGEO   = ZL(JCLREA+1-1)  
      CTCFIX   = ZL(JCLREA+2-1)  
      REAPRE   = ZL(JCLREA+3-1)     
C
      CALL CFIMPE(IFM,NIV,'NMCOFR',1)
C
C --- PREMIERE UTILISATION DU CONTACT OU NON
C
      CALL JEVEUO ( RESOCO(1:14) // '.PREM', 'E', JPREM )

      PREMIE = ZL(JPREM)
      IF ( PREMIE )  THEN 
        ZL(JPREM) = .FALSE.
      ENDIF
C 
C --- APPARIEMENT
C
      CALL NMTIME('INIT' ,'TMP',SDTIME,LBID  ,R8BID )
      CALL NMTIME('DEBUT','TMP',SDTIME,LBID  ,R8BID )      
      CALL CFGEOM(PREMIE,REAGEO,REAPRE,INSTAN,NOMA  ,
     &            DEFICO,RESOCO,DEPPLU,DDEPLA,DEPDEL)
      CALL NMTIME('FIN ' ,'TMP',SDTIME,LBID  ,TPSGEO)          
C
C -- MODE VERIF: PAS D'ALGO DE CONTACT, ON SORT APRES L'APPARIEMENT
C
      IF (TYPALC.EQ.5) THEN
        GOTO 998
      ENDIF
C
C --- ALGORITHMES DE CONTACT
C
      CALL NMTIME('INIT' ,'TMP',SDTIME,LBID  ,R8BID )
      CALL NMTIME('DEBUT','TMP',SDTIME,LBID  ,R8BID )
      CALL CFALGO(NOMA  ,RESIGR,DEFICO,RESOCO,MATASS,
     &            DEPPLU,DDEPLA,DEPDEL,CNCINE,REAGEO,
     &            REAPRE,CTCCVG,CTCFIX)
      CALL NMTIME('FIN ' ,'TMP',SDTIME,LBID  ,TPSALG)    
C
C --- STOCKAGE DU TEMPS
C      
      CALL CFITER(RESOCO,'E','TIMA',IBID,TPSALG)
      CALL CFITER(RESOCO,'E','TIMG',IBID,TPSGEO)
C
  998 CONTINUE
C  
      CALL CFIMPE(IFM,NIV,'NMCOFR',4) 
C
C --- DESACTIVATION REAC_GEOM
C
      REAGEO = .FALSE. 
      REAPRE = .FALSE.
C
C --- SAUVEGARDE
C        
      ZL(JCLREA+1-1) = REAGEO
      ZL(JCLREA+2-1) = CTCFIX  
      ZL(JCLREA+3-1) = REAPRE                
C
  999 CONTINUE
C
      CALL JEDEMA()
      END
