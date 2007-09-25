      SUBROUTINE MAPPAR(PREMIE,NOMA  ,NUMEDD,NEQ   ,DEFICO,
     &                  RESOCO)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/09/2007   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT NONE
      INTEGER      NEQ
      LOGICAL      PREMIE
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 NUMEDD
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE)
C
C REALISE L'APPARIEMENT ENTRE SURFACE ESCLAVE ET SURFACE MAITRE POUR 
C LE CONTACT METHODE CONTINUE
C      
C ----------------------------------------------------------------------
C
C
C METHODE : POUR CHAQUE POINT DE CONTACT (SUR UNE MAILLE ESCLAVE ET
C AVEC UN SCHEMA D'INTEGRATION DONNE), ON RECHERCHE LE NOEUD MAITRE LE
C PLUS PROCHE ET ON PROJETTE SUR LES MAILLES QUI L'ENTOURE
C
C STOCKAGE DES POINTS  DE CONTACT DES SURFACES  ESCLAVES ET APPARIEMENT
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  PREMIE : VAUT .TRUE. SI PREMIER INSTANT DE STAT/DYNA_NON_LINE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  NUMEDD : NOM DE LA NUMEROTATION MECANIQUE
C IN  NEQ    : NOMBRE D'EQUATIONS DU SYSTEME
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER IFM,NIV
      INTEGER ZTABF,CFMMVD,ZMAES
      INTEGER IMAE,IPC
      INTEGER NTMAE,NDIM,NTPC,NBPC
      INTEGER NPEX,INI1,INI2,INI3
      INTEGER IZONE,TYCO
      INTEGER POSMAE,POSNOM,POSMIN
      INTEGER NUMMAE,NUMMIN
      INTEGER ITEMAX,IBID
      REAL*8       XIMIN,YIMIN,T1MIN(3),T2MIN(3),COORPC(3),LAMBDA
      REAL*8       KSIPC1,KSIPC2,WPC
      REAL*8       DIR(3),TOLEOU,NMIN(3),JEUMIN
      REAL*8       R8BID(3),EPSMAX
      CHARACTER*8  ALIAS
      CHARACTER*24 COTAMA,MAESCL,TABFIN,NDIMCO
      INTEGER      JMACO,JMAESC,JTABF,JDIM
      CHARACTER*24 K24BLA,K24BID
      LOGICAL      PROJIN,LISSS,LBID,VECPOU,LFROTT,LSSRAC
      LOGICAL      COMPLI,CTCINI,DIRAPP,LPIVAU,LFFISS,LSSCON
      LOGICAL      EXNOEC,EXNOEF,EXNOER,EXNOEB
      INTEGER      TYPBAR
      INTEGER      NUNOBA(3),NUNFBA(2)   
      CHARACTER*24 DEPGEO,OLDGEO,NEWGEO    
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV) 
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> APPARIEMENT' 
      ENDIF             
C      
C --- RECUPERATION DE QUELQUES DONNEES      
C
      COTAMA = DEFICO(1:16)//'.MAILCO'
      MAESCL = DEFICO(1:16)//'.MAESCL'
      TABFIN = DEFICO(1:16)//'.TABFIN'
      NDIMCO = DEFICO(1:16)//'.NDIMCO'
      CALL JEVEUO(COTAMA,'L',JMACO)
      CALL JEVEUO(MAESCL,'L',JMAESC)
      CALL JEVEUO(TABFIN,'E',JTABF)
      CALL JEVEUO(NDIMCO,'E',JDIM)
C
      ZTABF = CFMMVD('ZTABF')  
      ZMAES = CFMMVD('ZMAES')
C
C --- INITIALISATIONS
C
      NPEX   = 0
      EXNOEB = .FALSE.
      EXNOER = .FALSE.
      NTMAE  = ZI(JMAESC)
      NTPC   = 0
      NDIM   = ZI(JDIM)
      K24BLA = ' '  
      OLDGEO = NOMA(1:8)//'.COORDO'
      DEPGEO = RESOCO(1:14)//'.DEPG' 
      NEWGEO = '&&MAPPAR.ACTUGEO'         
C
C --- INFOS GENERIQUES POUR L'ALGORITHME D'APPARIEMENT
C      
      CALL MMINFP(0,DEFICO,K24BLA,'PROJ_NEWT_ITER',
     &            ITEMAX,R8BID,K24BID,LBID)
      CALL MMINFP(0,DEFICO,K24BLA,'PROJ_NEWT_EPSI',
     &            IBID,EPSMAX,K24BID,LBID)   
      CALL MMINFP(0,DEFICO,K24BLA,'TOLE_PROJ_EXT',
     &            IBID,TOLEOU,K24BID,LBID)
C
C --- REACTUALISATION DE LA GEOMETRIE
C       
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ... REACTUALISATION DES DEPLACEMENTS' 
      ENDIF      
      CALL VTGPLD(OLDGEO,1.D0,DEPGEO,'V',NEWGEO)       
C
C --- GESTION AUTOMATIQUE DES RELATIONS REDONDANTES     
C     
      CALL REDNEX(NUMEDD,NEQ   ,RESOCO)                 
C
C --- LISSAGE DES NORMALES 
C      
      CALL LISSAG(NOMA  ,DEFICO,NEWGEO,ITEMAX,EPSMAX)
C    
C --- BOUCLE SUR LES MAILLES ESCLAVES
C
      DO 20 IMAE = 1,NTMAE
C
C --- OPTIONS SUR LA ZONE DE CONTACT
C    
        IZONE  = ZI(JMAESC+ZMAES*(IMAE-1)+2)
        CALL MMINFP(IZONE,DEFICO,K24BLA,'SEUIL_INIT',
     &              IBID,LAMBDA,K24BID,LBID)
        LAMBDA = -ABS(LAMBDA)
        CALL MMINFP(IZONE,DEFICO,K24BLA,'INTEGRATION',
     &              TYCO,R8BID,K24BID,LBID)
        CALL MMINFP(IZONE,DEFICO,K24BLA,'LISSAGE',
     &              IBID,R8BID,K24BID,LISSS)        
        CALL MMINFP(IZONE,DEFICO,K24BLA,'DIRE_APPA',
     &              IBID,DIR,K24BID,DIRAPP)
        CALL MMINFP(IZONE,DEFICO,K24BLA,'VECT_ORIE_POU',
     &              IBID,R8BID,K24BID,VECPOU)         
        CALL MMINFP(IZONE,DEFICO,K24BLA,'COMPLIANCE',
     &              IBID,R8BID,K24BID,COMPLI)  
        CALL MMINFP(IZONE,DEFICO,K24BLA,'CONTACT_INIT',
     &              IBID,R8BID,K24BID,CTCINI)
        CALL MMINFP(IZONE,DEFICO,K24BLA,'EXCLUSION_PIV_NUL',
     &              IBID,R8BID,K24BID,LPIVAU)
        CALL MMINFP(IZONE,DEFICO,K24BLA,'FOND_FISSURE',
     &              IBID,R8BID,K24BID,LFFISS)     
        CALL MMINFP(IZONE,DEFICO,K24BLA,'FROTTEMENT',
     &              IBID,R8BID,K24BID,LFROTT)   
        CALL MMINFP(IZONE,DEFICO,K24BLA,'SANS_GROUP_NO',
     &              IBID,R8BID,K24BID,LSSCON) 
        CALL MMINFP(IZONE,DEFICO,K24BLA,'RACCORD_LINE_QUAD',
     &              IBID,R8BID,K24BID,LSSRAC)                          
C
C --- INFOS SUR LA MAILLE ESCLAVE COURANTE
C       
        POSMAE = ZI(JMAESC+ZMAES*(IMAE-1)+1)
        NUMMAE = ZI(JMACO+POSMAE-1)
        NBPC   = ZI(JMAESC+ZMAES*(IMAE-1)+3)      
        CALL MMELTY(NOMA,NUMMAE,ALIAS,IBID,IBID)      
C
C --- ON TESTE SI LA MAILLE ESCLAVE CONTIENT DES NOEUDS INTERDITS DANS
C --- SANS_GROUP_NO_FR OU SANS_NOEUD_FR
C
        IF (LFROTT) THEN
          CALL MMEXCL(DEFICO,NOMA  ,IZONE ,POSMAE ,NBPC   ,
     &                NPEX  ,INI1  ,INI2  ,INI3)
        ENDIF
C
C --- ON TESTE SI LA MAILLE EST UNE MAILLE DE FISSURE
C --- GROUP_MA_FOND OU MAILLE_FOND
C
        IF (LFFISS) THEN
          CALL MMFOND(NOMA  ,DEFICO,IZONE ,NBPC  ,POSMAE,
     &                TYPBAR,NUNOBA,NUNFBA,EXNOEB)
        ENDIF        
C
C --- APPARIEMENT - BOUCLE SUR LES POINTS DE CONTACT
C              
        DO 10 IPC = 1,NBPC    
C
C --- COORDONNEES DANS ELEMENT DE REFERENCE ET POIDS DU POINT DE CONTACT
C
          CALL MMGAUS(ALIAS ,TYCO  ,IPC   ,KSIPC1,KSIPC2,
     &                WPC)
C
C --- CALCUL DES COORDONNEES REELLES DU POINT DE CONTACT          
C 
          CALL MCOPCO(NOMA  ,NEWGEO,NUMMAE,KSIPC1,KSIPC2,
     &                COORPC)
C
C --- RECHERCHE DU NOEUD MAITRE LE PLUS PROCHE DU POINT DE CONTACT
C
          CALL MMREND(DEFICO,NEWGEO,IZONE,COORPC,DIRAPP,
     &                DIR   ,POSNOM)
C
C --- PROJECTION DU POINT DE CONTACT SUR LA MAILLE MAITRE
C
          CALL MMREMA(NOMA  ,DEFICO,NEWGEO,IZONE ,COORPC,
     &                POSNOM,ITEMAX,EPSMAX,TOLEOU,DIRAPP,
     &                DIR   ,POSMIN,NUMMIN,JEUMIN,NMIN  ,
     &                T1MIN ,T2MIN ,XIMIN ,YIMIN ,PROJIN)
C          
C --- RE-DEFINITION BASE TANGENTE SUIVANT OPTIONS    
C          
          CALL MMTANR(NOMA  ,NDIM  ,NEQ   ,DEFICO,RESOCO,
     &                IZONE ,LISSS ,VECPOU,LPIVAU,LFROTT,
     &                LSSCON,LSSRAC,POSMAE,POSMIN,IPC   ,
     &                XIMIN ,YIMIN ,NPEX  ,INI1  ,INI2  ,
     &                T1MIN ,T2MIN ,EXNOEC,EXNOEF,EXNOER)
C          
C --- STOCKAGE DES VALEURS DANS LA CARTE (VOIR MMCART)
C   
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+1)  = NUMMAE
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+2)  = NUMMIN
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+3)  = KSIPC1
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+12) = KSIPC2          
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+4)  = XIMIN
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+5)  = YIMIN
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+6)  = T1MIN(1)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+7)  = T1MIN(2)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+8)  = T1MIN(3)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+9)  = T2MIN(1)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+10) = T2MIN(2)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+11) = T2MIN(3)
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+15) = IZONE
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+16) = WPC
          ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+23) = IMAE 
          IF (PREMIE) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+14) = LAMBDA
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+21) = 0.D0
          END IF
C          
C --- CONTACT_INIT
C 
          IF (PREMIE) THEN
            IF (CTCINI) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13) = 1.D0
            ELSE
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+13) = 0.D0
            END IF
          ENDIF  
C
C --- COMPLIANCE
C          
          IF (.NOT.COMPLI) THEN 
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+21) = 1.D0
          END IF
C
C --- NOEUDS EXCLUS PAR PROJECTION HORS ZONE
C              
          IF (.NOT. PROJIN) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+22) = 1.D0
          ELSE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+22) = 0.D0
          ENDIF
C
C --- NOEUDS EXCLUS PAR SANS_GROUP_NO_FR
C           
          IF (EXNOEF) THEN
            IF (NPEX.EQ.1) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+17) = 1.D0
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+18) = INI1
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+19) = 0.D0
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+20) = 0.D0
            ELSEIF (NPEX.EQ.2) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+17) = 2.D0
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+18) = INI1
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+19) = INI2
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+20) = 0.D0
            ELSEIF (NPEX.EQ.3) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+17) = 3.D0
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+18) = INI1
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+19) = INI2
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+20) = INI3
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF
          ELSE  
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+17) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+18) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+19) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+20) = 0.D0
          END IF
C
C --- NOEUDS EXCLUS PAR GROUP_NO_FOND
C     
          IF (EXNOEB) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+24) = IMAE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+27) = TYPBAR
            IF (IPC .EQ. NUNOBA(1)) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = NUNOBA(1)
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = NUNFBA(1)
            ELSEIF (IPC .EQ. NUNOBA(2)) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = NUNOBA(2)
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = NUNFBA(2)
            ELSEIF (IPC .EQ. NUNOBA(3)) THEN
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = NUNOBA(3)
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = (NUNOBA(1)*
     &                                                NUNOBA(2))
            ELSE
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = 0.D0
              ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = 0.D0      
            ENDIF            
          ELSE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+24) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+25) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+26) = 0.D0
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+27) = 0.D0
          END IF
C
C --- NOEUDS EXCLUS PAR GROUP_NO_RACC
C   
          IF (EXNOER) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+28) = IPC
          ELSE
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+28) = 0.D0
          END IF   
C
C --- NOEUDS EXCLUS PAR GESTION AUTOMATIQUE DES 
C --- RELATIONS SURABONDANTES AVEC LE CONTACT OU SANS_GROUP_NO
C
          IF (EXNOEC) THEN
            ZR(JTABF+ZTABF*NTPC+ZTABF*(IPC-1)+29) = 1.D0
          END IF
                                
 10     CONTINUE
        NTPC = NTPC + NBPC
 20   CONTINUE
      ZR(JTABF-1+1) = NTPC
C
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        CALL MMIMP1(IFM   ,NOMA  ,DEFICO)
      ENDIF   
      CALL JEDETR(NEWGEO)    
C      
      CALL JEDEMA()
      END
