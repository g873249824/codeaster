      SUBROUTINE NMCONV(MAILLA,MATE  ,NUMEDD,FONACT,SDDYNA,
     &                  SDIMPR,SDDISC,SDCRIT,SDERRO,SDTIME,
     &                  PARMET,COMREF,MATASS,METHOD,NUMINS,
     &                  ITERAT,CONV  ,ETA   ,PARCRI,DEFICO,
     &                  RESOCO,LICCVG,VALMOI,VALPLU,SOLALG,
     &                  MEASSE,VEASSE,ITEMAX,CONVER,ERROR ,
     &                  FINPAS,MAXREL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/10/2008   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_21
C TOLE CRP_20
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT     NONE
      LOGICAL      FONACT(*)
      LOGICAL      ITEMAX,CONVER,FINPAS
      LOGICAL      ERROR
      LOGICAL      MAXREL
      INTEGER      ITERAT, LICCVG(*), NUMINS
      REAL*8       ETA, CONV(*), PARCRI(*), PARMET(*)
      CHARACTER*19 SDCRIT,SDDISC,MATASS
      CHARACTER*19 SDDYNA
      CHARACTER*24 VALMOI(8),VALPLU(8)
      CHARACTER*19 MEASSE(*),VEASSE(*)
      CHARACTER*19 SOLALG(*)
      CHARACTER*24 COMREF,MATE
      CHARACTER*8  MAILLA
      CHARACTER*24 NUMEDD
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 SDIMPR,SDERRO,SDTIME
      CHARACTER*16 METHOD(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C VERIFICATION DES CRITERES D'ARRET
C
C ----------------------------------------------------------------------
C
C
C IN  MAILLA : NOM DU MAILLAGE
C IN  DEFICO : SD POUR LA DEFINITION DU CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DU CONTACT
C IN  SDIMPR : SD AFFICHAGE
C IN  NUMEDD : NUMEROTATION NUME_DDL
C IN  COMREF : VARI_COM REFE
C IN  METHOD : DESCRIPTION DE LA METHODE DE RESOLUTION
C IN  MATASS : MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  ITERAT : NUMERO D'ITERATION
C IN  NUMINS : NUMERO D'INSTANT
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
C IN  ETA    : COEFFICIENT DE PILOTAGE
C I/O CONV   : INFORMATIONS SUR LA CONVERGENCE DU CALCUL
C               1 - RESI_DUAL_ABSO      (LAGRANGIEN AUGMENTE)
C               2 - RESI_PRIM_ABSO      (LAGRANGIEN AUGMENTE)
C               3 - NOMBRE D'ITERATIONS DUAL (LAGRANGIEN AUGMENTE)
C               4 - NUMERO ITERATION BFGS (LAGRANGIEN AUGMENTE)
C              10 - NOMBRE D'ITERATIONS (RECHERCHE LINEAIRE)
C              11 - RHO                 (RECHERCHE LINEAIRE)
C              20 - RESI_GLOB_RELA
C              21 - RESI_GLOB_MAXI
C IN  LICCVG : CODES RETOURS D'ERREUR
C              (1) : PILOTAGE
C                  =  0 CONVERGENCE
C                  =  1 PAS DE CONVERGENCE
C                  = -1 BORNE ATTEINTE
C              (2) : INTEGRATION DE LA LOI DE COMPORTEMENT
C                  = 0 OK
C                  = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
C                  = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
C              (3) : TRAITEMENT DU CONTACT UNILATERAL EN GD. DEPL.
C                  = 0 OK
C                  = 1 ECHEC DANS LE TRAITEMENT DU CONTACT
C              (4) : TRAITEMENT DU CONTACT UNILATERAL EN GD. DEPL.
C                  = 0 OK
C                  = 1 MATRICE DE CONTACT SINGULIERE
C              (5) : MATRICE DU SYSTEME (MATASS)
C                  = 0 OK
C                  = 1 MATRICE SINGULIERE
C                  = 3 ON NE SAIT PAS SI SINGULIERE
C IN  PARCRI : CRITERES DE CONVERGENCE
C               1 : ITER_GLOB_MAXI
C               2 : RESI_GLOB_RELA
C               3 : RESI_GLOB_MAXI
C               4 : ARRET
C               5 : ITER_GLOB_ELAS
C               6 : RESI_REFE_RELA
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SDERRO : GESTION DES ERREURS
C IN  SDTIME : GESTION DES TIMERS ET DES STATS
C IN  PARMET : PARAMETRES DE LA METHODE DE RESOLUTION
C                       3 - PAS_MINI_ELAS
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C OUT ITEMAX : .TRUE. SI ITERATION MAXIMUM ATTEINTE
C OUT CONVER : .TRUE. SI CONVERGENCE REALISEE
C OUT ERROR  : .TRUE. SI ERREUR DETECTEE
C OUT FINPAS : .TRUE. SI ON NE FAIT PLUS D'AUTRES PAS DE TEMPS
C OUT MAXREL : .TRUE. SI CRITERE RESI_GLOB_RELA ET CHARGEMENT = 0,
C                             ON UTILISE RESI_GLOB_MAXI
C IN  SDIMPR : SD AFFICHAGE
C IN  SDCRIT : SYNTHESE DES RESULTATS DE CONVERGENCE POUR
C                   ARCHIVAGE
C IN  COMREF : VARI_COM REFE
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
      LOGICAL      LCTCD,LCTCV,LCTCC,LTABL,LEXPL,LCTCG
      LOGICAL      ISFONC,NDYNLO
      INTEGER      IBID,IRET,MMITGO
      REAL*8       R8VIDE,R8BID,PASMIN
      REAL*8       RESIGR
      REAL*8       DIINST,INSTAM,INSTAP
      CHARACTER*16 K16BID
      INTEGER      JCRI,JCRR
      CHARACTER*24 IMPCNA,CRITER
      INTEGER      JIMPCA
      REAL*8       VRELA,VMAXI,VREFE,VRESI,VCHAR,VINIT
      CHARACTER*24 CLREAC
      INTEGER      JCLREA
      LOGICAL      CTCFIX
      INTEGER      CTCITE
      LOGICAL      CBORST,BORCVG,CTCGEO,CVNEWT,CTCCVG
      LOGICAL      ECHLDC,ECHEQU,ECHCON(2),ECHPIL  
      LOGICAL      LBID          
      INTEGER      IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> EVALUATION DE LA CONVERGENCE'
      ENDIF
C
C --- INITIALISATIONS
C
      FINPAS = .FALSE.
      ITEMAX = .FALSE.
      ERROR  = .FALSE.
      CBORST = LICCVG(2).EQ.3
      BORCVG = .TRUE.
      CTCGEO = .TRUE.
      CTCFIX = .FALSE.
      CTCCVG = .TRUE.
      RESIGR = PARCRI(2) 
C
C --- FONCTIONNALITES ACTIVEES
C      
      LCTCD  = ISFONC(FONACT,'CONT_DISCRET')
      LCTCV  = ISFONC(FONACT,'CONT_VERIF')
      LCTCC  = ISFONC(FONACT,'CONT_CONTINU') 
      LEXPL  = NDYNLO(SDDYNA,'EXPLICITE')
      LCTCG  = ISFONC(FONACT,'CONT_GEOM')
C
C --- ACCES SDIMPR
C
      IMPCNA = SDIMPR(1:14)//'CONV.ACT'
      CALL JEVEUO(IMPCNA,'E',JIMPCA)
C
C --- INSTANTS
C
      INSTAM = DIINST(SDDISC,NUMINS-1)
      INSTAP = DIINST(SDDISC,NUMINS  )
C
C --- ERREUR SUR LOI DE COMPORTEMENT
C
      ECHLDC = LICCVG(2).EQ.1
      CALL NMERGE('SET','LDC',ECHLDC,SDERRO)
C
C --- ERREUR SUR PILOTAGE
C
      ECHPIL = LICCVG(1).EQ.1
      CALL NMERGE('SET','PIL',ECHPIL,SDERRO)
C
C --- ERREUR SUR MATRICE DU SYSTEME
C
      ECHEQU = .NOT. (LICCVG(5).EQ.0 .OR. LICCVG(5).EQ.3)
      CALL NMERGE('SET','FAC',ECHEQU,SDERRO)
C
C --- ERREUR SUR CONTACT DISCRET - NOMBRE D'ITERATIONS
C
      ECHCON(1) = LICCVG(3) .NE. 0
      CALL NMERGE('SET','CC1',ECHCON(1),SDERRO)      
C
C --- ERREUR SUR CONTACT DISCRET - MATRICE CONTACT SINGULIERE
C
      ECHCON(2) = LICCVG(4) .NE. 0
      CALL NMERGE('SET','CC2',ECHCON(2),SDERRO)  
C
C --- EXAMEN DU NOMBRE D'ITERATIONS
C
      PASMIN = PARMET(3)
      IF (ABS(INSTAP-INSTAM) .LT. PASMIN) THEN
        ITEMAX = ITERAT .GE. PARCRI(5)
      ELSE
        ITEMAX = ITERAT .GE. PARCRI(1)
      ENDIF   
C
C --- LE PILOTAGE A ATTEINT LES BORNES
C
      IF (LICCVG(1) .EQ. -1) THEN
        FINPAS = .TRUE.
      ELSE
        FINPAS = .FALSE.
      END IF              
C
C --- ERREUR OU PAS
C
      CALL NMERGE('GET','ALL',ERROR,SDERRO)
      IF (ERROR) THEN
        CALL NMERGE('PRT','ALL',ERROR,SDERRO)
        CONVER = .FALSE.
        GOTO 9999
      ENDIF
C
C --- EXPLICITE: PAS DE CALCUL DES RESIDUS
C
      IF (LEXPL) THEN
        CONVER = .TRUE.
        GOTO 9999
      ENDIF      
C
C --- CALCUL DES RESIDUS
C
      CALL NMRESI(MAILLA,MATE  ,NUMEDD,FONACT,SDDYNA,
     &            SDIMPR,MATASS,METHOD,NUMINS,CONV  ,
     &            RESIGR,ETA   ,DEFICO,COMREF,VALMOI,
     &            VALPLU,VEASSE,MEASSE,VRELA ,VMAXI ,
     &            VCHAR ,VRESI ,VREFE ,VINIT )
C
C --- AFFICHAGE DE L'INSTANT
C
      CALL IMPSDR(SDIMPR,'INCR_TPS ',K16BID,INSTAP,IBID)
C
C --- AFFICHAGE DE NUMERO ITERATION NEWTON
C
      CALL IMPSDR(SDIMPR,'ITER_NEWT',K16BID,R8BID,ITERAT)
C
C --- AFFICHAGE DE CRITERES RECHERCHE LINEAIRE
C
      IF (ITERAT.EQ.0) THEN
        CONV(10) = 0
      ENDIF
      CALL IMPSDR(SDIMPR,'RELI_ITER',K16BID,R8BID,INT(CONV(10)))
      CALL NMTIME('RECH_LINE',' ',SDTIME,LBID  ,CONV(10))
C
      IF (NINT(CONV(10)).EQ.0) THEN
        CALL IMPSDR(SDIMPR,'RELI_COEF',K16BID,1.D0    ,IBID)
      ELSE
        CALL IMPSDR(SDIMPR,'RELI_COEF',K16BID,CONV(11),IBID)
      ENDIF
C
C --- AFFICHAGE DE CRITERES PILOTAGE
C
      CALL IMPSDR(SDIMPR,'PILO_PARA',K16BID,ETA,IBID)
C
C --- AFFICHAGE DE NUMERO ITERATION FETI
C
      CRITER = '&FETI.CRITER.CRTI'
      CALL JEEXIN(CRITER,IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(CRITER,'L',JCRI)
        CALL IMPSDR(SDIMPR,'ITER_FETI',K16BID,R8BID,ZI(JCRI))
        R8BID = DBLE(ZI(JCRI))
        CALL NMTIME('ITER_FETI',' ',SDTIME,LBID  ,R8BID)
        CALL JEDETR(CRITER)
      ENDIF
C
C ======================================================================
C
C    EXAMEN DE LA CONVERGENCE
C
C ======================================================================

C
C --- VERIFICATION DES CRITERES D'ARRET SUR RESIDUS
C       
      CALL NMCORE(SDIMPR,SDCRIT,NUMINS,PARCRI,VRESI ,
     &            VRELA ,VMAXI ,VCHAR ,VREFE ,CVNEWT,
     &            MAXREL)
C
C --- MARQUE DE CONVERGENCE DE NEWTON
C
      IF (CVNEWT) THEN
        CALL IMPSDM(SDIMPR,'ITER_NEWT',' ')
      ELSE
        CALL IMPSDM(SDIMPR,'ITER_NEWT','X')
      ENDIF 
C
C --- LE PILOTAGE A ATTEINT LES BORNES
C
      IF (FINPAS) THEN
        CALL IMPSDM(SDIMPR,'PILO_PARA','B')
      ELSE
        CALL IMPSDM(SDIMPR,'PILO_PARA',' ')
      END IF           
C 
C --- CONVERGENCE ADAPTEE AU CONTACT DISCRET
C 
      IF (LCTCD.AND.(.NOT.LCTCV)) THEN
C
C --- ATTENTE POINT FIXE ?
C
        CLREAC = RESOCO(1:14)//'.REAL'
        CALL JEVEUO(CLREAC,'L',JCLREA)
        CTCFIX = ZL(JCLREA+2-1)
        IF (CTCFIX) THEN
          CALL IMPSDM(SDIMPR,'CTCD_ITER','X')
          CALL IMPSDR(SDIMPR,'CTCD_NOEU',' ',R8BID   ,IBID)
          CALL IMPSDR(SDIMPR,'CTCD_GEOM',' ',R8VIDE(),IBID)          
        ELSE
          CALL IMPSDM(SDIMPR,'CTCD_ITER',' ')            
        ENDIF
C
C --- NOMBRE ITERATIONS INTERNES DE CONTACT POUR L'ITERATION COURANTE
C
        CALL CFITER(RESOCO,'L','CONT',CTCITE,R8BID)
        CALL IMPSDR(SDIMPR,'CTCD_ITER',K16BID,R8BID,CTCITE) 
C
C --- EVALUATION DE LA REACUALISATION GEOMETRIQUE POUR CONTACT DISCRET
C       
        IF (CVNEWT) THEN
          IF (.NOT.CTCFIX) THEN 
            CALL CFCONV(MAILLA,NUMEDD,SDIMPR,RESOCO,SOLALG,
     &                  MAXREL,CTCGEO)
          ENDIF
          CTCCVG = (.NOT.CTCFIX).AND.CTCGEO
        ELSE
          CALL IMPSDR(SDIMPR,'CTCD_NOEU',' ',R8BID   ,IBID)
          CALL IMPSDR(SDIMPR,'CTCD_GEOM',' ',R8VIDE(),IBID) 
          CTCCVG = .FALSE.           
        ENDIF    
        IF (.NOT.LCTCG) THEN  
          CALL IMPSDR(SDIMPR,'CTCD_NOEU',' ',R8BID   ,IBID)
          CALL IMPSDR(SDIMPR,'CTCD_GEOM',' ',R8VIDE(),IBID)         
        ENDIF    
      ELSE 
        CTCCVG = .TRUE.         
      ENDIF
C
C --- CONVERGENCE ADAPTEE A LA METHODE DE DE BORST
C
      IF (CBORST) THEN
        IF (CVNEWT) THEN
          CALL IMPSDR(SDIMPR,'ITER_DEBO',' DE BORST...    ',R8BID,IBID)
          CALL U2MESS('I','MECANONLINE2_3')
          BORCVG = .FALSE.
        ELSE
          CALL IMPSDR(SDIMPR,'ITER_DEBO','                ',R8BID,IBID)
        ENDIF
      ELSE
        BORCVG = .TRUE.  
      ENDIF
C
C --- CONVERGENCE FINALE
C
      CONVER = CVNEWT.AND.BORCVG.AND.CTCCVG
C
C --- AFFICHAGE TABLEAU CONVERGENCE ?
C
      IF (LCTCC) THEN
        IF (CONVER) THEN
          LTABL = .FALSE.
        ELSE
          LTABL = .TRUE.
        ENDIF   
      ELSEIF (LCTCD) THEN
        IF (CVNEWT.AND.BORCVG) THEN
          IF (CTCFIX) THEN
            LTABL = .TRUE.
          ELSE
            IF (LCTCG) THEN
              LTABL = .FALSE.         
              IF (.NOT.CTCGEO) THEN   
                CALL NMIMPR('IMPR','LIGN_TABL',' ',0.D0,0)    
                CALL NMIMPR('IMPR','LIGNE    ',' ',0.D0,0)  
              ELSE
                CALL MMBOUC(RESOCO,'GEOM','INCR',MMITGO)
                CALL NMIMPR('IMPR','BCL_GEOME',' ',0.D0,MMITGO) 
              ENDIF
            ELSE
              LTABL = .TRUE.
            ENDIF                  
          ENDIF 
         
        ELSE
          LTABL = .TRUE.
        ENDIF          
      ELSE
        LTABL = .TRUE.
      ENDIF
C
C --- AFFICHAGE LIGNE DU TABLEAU DE CONVERGENCE
C
      IF (LTABL) THEN
        CALL NMIMPR('IMPR','LIGN_TABL',' ',0.D0,0)     
        IF (CONVER) THEN
          CALL NMCVGI('CVG' ,MAXREL)  
        ENDIF
      ENDIF      
C
C --- DEPASSEMENT ITERATIONS
C      
      IF (ITEMAX) THEN
        CALL NMIMPR('IMPR','ERREUR','ITER_MAXI',0.D0,0)
      ENDIF
C
C --- SAUVEGARDES INFOS CONVERGENCE
C
      CALL JEVEUO(SDCRIT //'.CRTR','E',JCRR)
      ZR(JCRR+1-1) = ITERAT
      ZR(JCRR+2-1) = CONV(10)
      ZR(JCRR+3-1) = VRELA
      ZR(JCRR+4-1) = VMAXI
      ZR(JCRR+5-1) = ETA
      IF ((NUMINS.EQ.1) .AND. (ITERAT.EQ.0)) THEN
        ZR(JCRR+6-1) = VCHAR
      ELSE
        IF ((CONVER).AND.(.NOT.MAXREL)) THEN
          ZR(JCRR+6-1) = MIN(VCHAR, ZR(JCRR+6-1))
        ENDIF
      ENDIF
      IF (CONVER) THEN
        ZR(JCRR+7-1) = VRESI
      ENDIF
      ZR(JCRR+8-1) = VREFE     
C
 9999 CONTINUE
C
C --- ENREGISTRE LES ERREURS A CETTE ITERATION
C
      CALL DIERRE(SDDISC,SDCRIT,ITERAT)
C      
      CALL JEDEMA()
      END
