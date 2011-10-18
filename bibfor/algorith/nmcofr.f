      SUBROUTINE NMCOFR(NOMA  ,DEPPLU,DEPDEL,DDEPLA,SOLVEU,
     &                  NUMEDD,MATASS,DEFICO,RESOCO,ITERAT,
     &                  RESIGR,SDSTAT,SDTIME,CTCCVG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/10/2011   AUTEUR DESOZA T.DESOZA 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*8  NOMA
      CHARACTER*19 DEPPLU
      CHARACTER*19 DEPDEL,DDEPLA
      CHARACTER*14 NUMEDD
      CHARACTER*24 DEFICO,RESOCO,SDTIME,SDSTAT
      CHARACTER*19 SOLVEU,MATASS
      REAL*8       RESIGR
      INTEGER      ITERAT,CTCCVG
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
C IN  SOLVEU : SD SOLVEUR
C IN  NUMEDD : NUME_DDL
C IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  SDTIME : SD TIMER
C IN  SDSTAT : SD STATISTIQUES
C IN  RESIGR : RESI_GLOB_RELA
C OUT CTCCVG : CODE RETOUR CONTACT DISCRET
C                0 - OK
C                1 - NOMBRE MAXI D'ITERATIONS
C                2 - MATRICE SINGULIERE
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
      INTEGER      IFM,NIV
      CHARACTER*24 CLREAC
      INTEGER      JCLREA
      LOGICAL      REAGEO,CTCFIX,REAPRE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()      
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- ACCES OBJETS
C          
      CLREAC = RESOCO(1:14)//'.REAL'             
      CALL JEVEUO(CLREAC,'E',JCLREA)
C
C --- PARAMETRES POUR BOUCLES GEOMETRIQUE/PT FIXE
C      
      REAGEO = ZL(JCLREA+1-1)  
      CTCFIX = ZL(JCLREA+2-1)  
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> DEBUT DU TRAITEMENT '//
     &                'DES CONDITIONS DE CONTACT'
      ENDIF
C
C --- SAUVEGARDE AVANT APPARIEMENT
C
      IF (REAGEO) THEN
        CALL CFSVMU(DEFICO,RESOCO,.FALSE.)
        CALL CFSVFR(DEFICO,RESOCO,.FALSE.)
      ENDIF
C 
C --- APPARIEMENT
C
      CALL NMTIME(SDTIME,'INI','CONT_GEOM')
      CALL NMTIME(SDTIME,'RUN','CONT_GEOM')    
      CALL CFGEOM(REAGEO,ITERAT,NOMA  ,DEFICO,RESOCO,
     &            DEPPLU)
      CALL NMTIME(SDTIME,'END','CONT_GEOM')
C                               
C --- ALGORITHMES DE CONTACT     
C
      CALL NMTIME(SDTIME,'INI','CTCD_ALGO')
      CALL NMTIME(SDTIME,'RUN','CTCD_ALGO')
      CALL CFALGO(NOMA  ,SDSTAT,RESIGR,ITERAT,DEFICO,
     &            RESOCO,SOLVEU,NUMEDD,MATASS,DDEPLA,
     &            DEPDEL,CTCCVG,CTCFIX)
      CALL NMTIME(SDTIME,'END','CTCD_ALGO')   
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> FIN DU TRAITEMENT '//
     &                'DES CONDITIONS DE CONTACT'
      ENDIF
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
      CALL JEDEMA()
      END
