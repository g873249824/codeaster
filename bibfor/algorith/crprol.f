      SUBROUTINE CRPROL ( )
      IMPLICIT NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2001   AUTEUR CIBHHLV L.VIVAN 
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
C
C     COMMANDE:  PROL_RTZ
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
      CHARACTER*32       JEXNUM , JEXNOM
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER       IBID  , NDIMF , NBNOI , NBNOF , NBINST, IAD
      INTEGER       JINST , IORD  , JCNSVL, JCNSLE, NBVAL
      INTEGER       JCNSVE, AXYZMF, JTBCOR, JTBRES
      INTEGER       IMIN  , IMAX  , INOI  , INOF  , INDICE, JTBPDG
      INTEGER       JTBNOE, ORDEF , INO   , INOMIN, INOMAX
      REAL*8        XNORMR, PREC  , R8PREM, RMIN  , RMAX
      REAL*8        RVAL  , MAX   , MIN   , PROSCA, RREF  , RPRO
      REAL*8        LAMBDA, ORIG(3), AXER(3), AXET(3), AXEZ(3)
      REAL*8        DINST
      COMPLEX*16    CBID
      CHARACTER*8   PDROIT, PGAUCH, NOMMAI, NOMMAF, K8B   , NOMGD
      CHARACTER*8   NOM1  , CRIT  , LICMPR, TABLE , RESU 
      CHARACTER*16  MOTFAC, TYPRES, NOMCMD
      CHARACTER*19  TABCOR, TABVAL, TABPDG, TABRES, TABNOE 
      CHARACTER*19  CNOINR, CNSINR
      CHARACTER*24  KNUM  , TABL2 
C
      CALL JEMARQ()
C
      MOTFAC = 'PROL_RTZ'
      CALL GETRES ( RESU, TYPRES, NOMCMD )
      IF (TYPRES.NE.'EVOL_THER') THEN
         CALL UTMESS ('F','RS1D3D','CETTE COMMANDE DOIT '//
     +        'NECESSAIREMENT AVOIR LE TYPE EVOL_THER.')
      ENDIF
C
C --- RECUPERATION DES DONNEES UTILISATEUR :
C     ------------------------------------
C
      CALL GETVID ( MOTFAC, 'MAILLAGE_FINAL', 1,1,1, NOMMAF, IBID )
      CALL GETVID ( MOTFAC, 'TABLE'         , 1,1,1, TABLE , IBID )
      CALL GETVTX ( MOTFAC, 'PROL_DROITE'   , 1,1,1, PDROIT, IBID )
      CALL GETVTX ( MOTFAC, 'PROL_GAUCHE'   , 1,1,1, PGAUCH, IBID )
      CALL GETVR8 ( MOTFAC, 'ORIGINE'       , 1,1,3, ORIG  , IBID )
      CALL GETVR8 ( MOTFAC, 'AXE_Z'         , 1,1,3, AXEZ  , IBID )
C
      CALL DISMOI ('F', 'NB_NO_MAILLA', NOMMAF, 'MAILLAGE', NBNOF,
     +                                            K8B,IBID )
      CALL DISMOI ('F','Z_CST',NOMMAF,'MAILLAGE',NDIMF,K8B,IBID )
      NDIMF = 3
      IF ( K8B.EQ.'OUI' ) NDIMF = 2
      IF ( NDIMF.NE.3 ) THEN
         CALL UTDEBM('F','RS1D3D','LE MAILLAGE FINAL N''EST PAS 3D')
         CALL UTIMPK('L',' MAILLAGE : ',1,NOMMAF)
         CALL UTFINM()
      ENDIF
      CALL JEVEUO ( NOMMAF//'.COORDO    .VALE', 'L', AXYZMF )
C
      CALL NORMEV ( AXEZ , XNORMR )
C
      KNUM  = '&&RS1D3D.INSTANT'
      CALL TBUTNU ( MOTFAC, 1, KNUM, NBINST, TABLE, PREC, CRIT )
      CALL JEVEUO ( KNUM, 'L', JINST )
C
      CALL RSCRSD ( RESU, TYPRES, NBINST )
C
      TABCOR = '&&RS1D3D.COORMA'
      TABVAL = '&&RS1D3D.VALTEM'
      TABRES = '&&RS1D3D.COORES'
      TABPDG = '&&RS1D3D.TABPDG'
      TABNOE = '&&RS1D3D.TABNOE'
C     
      CALL WKVECT ( TABPDG , 'V V R' , NBNOF , JTBPDG )
      CALL WKVECT ( TABNOE , 'V V I' , NBNOF , JTBNOE )
C
      TABL2  = '&&RS1D3D.TABL2'
      CNSINR = '&&RS1D3D.CNSINR'
C
      DO 1 IORD = 1 , NBINST
C
C ------ ON EXTRAIT LA SOUS-TABLE POUR L'INSTANT COURANT
C
         DINST = ZR(JINST+IORD-1)
         CALL TBEXTB ( TABLE, 'V', TABL2, 1, 'INST', 'EQ',
     +                    IBID, DINST, CBID, K8B, PREC, CRIT )
C
C ------ ON RECUPERE LES COORCONNEES DES NOEUDS POUR L'INSTANT COURANT
C
         CALL TBEXVE ( TABL2, 'COOR_X', TABCOR, 'V', NBNOI, K8B )
         CALL JEVEUO ( TABCOR, 'L', JTBCOR )
         CALL WKVECT ( TABRES , 'V V I' , NBNOI , JTBRES )
C
C ------ ON RECUPERE LES VALEURS DE TEMPERATURE AUX NOEUDS
C
         CALL TBEXVE ( TABL2, 'TEMP'  , TABVAL, 'V', NBVAL, K8B )
         CALL JEVEUO ( TABVAL, 'L', JCNSVL )
C
C ------ ON VERIFIE QUE LE MAILLAGE 1D COMMENCE A 0.
C
         RMAX = 0.0D0
         RMIN = 1.D0/R8PREM()
         DO 2 INOI = 1 , NBNOI
            RVAL = ZR(JTBCOR - 1 + INOI)
            RMAX = MAX(RVAL,RMAX)
            RMIN = MIN(RVAL,RMIN)
            IF ( RMIN.NE.0.0D0 ) THEN
               CALL UTDEBM('F','RS1D3D','L ORIGINE DU MAILLAGE 1D '//
     +                                  'N EST PAS 0')
               CALL UTFINM()
            ENDIF
 2       CONTINUE
C
C ------ ON TRIE PAR ORDRE CROISSANT
C
         CALL TBTRIR ( NBNOI, ZR(JTBCOR), ZI(JTBRES) )
C
         CALL PSCAL ( 3 , ORIG , AXEZ , PROSCA )
         AXER(1) = ORIG(1) - PROSCA*AXEZ(1)
         AXER(2) = ORIG(2) - PROSCA*AXEZ(2)
         AXER(3) = ORIG(3) - PROSCA*AXEZ(3)
         CALL NORMEV ( AXER, XNORMR )
         CALL PSCAL ( 3 , ORIG , AXER , RREF )
         RREF = ABS( RREF )
C
         NOMGD = 'TEMP_R'
         LICMPR = 'TEMP'
         CALL CNSCRE ( NOMMAF, NOMGD, 1, LICMPR, 'V', CNSINR )
         CALL JEVEUO ( CNSINR//'.CNSV', 'E', JCNSVE )
         CALL JEVEUO ( CNSINR//'.CNSL', 'E', JCNSLE )
C
         INDICE = 0
         DO 3 INOF = 1 , NBNOF
            ZL(JCNSLE-1+(INOF-1)+1) = .FALSE.
            AXET(1) = ZR( AXYZMF + 3*(INOF-1) - 1 + 1 )
            AXET(2) = ZR( AXYZMF + 3*(INOF-1) - 1 + 2 )
            AXET(3) = ZR( AXYZMF + 3*(INOF-1) - 1 + 3 )
            CALL PSCAL ( 3 , AXET , AXEZ , PROSCA )
            AXER(1) = AXET(1) - PROSCA*AXEZ(1)
            AXER(2) = AXET(2) - PROSCA*AXEZ(2)
            AXER(3) = AXET(3) - PROSCA*AXEZ(3)
            CALL NORMEV(AXER,XNORMR)
            CALL PSCAL ( 3 , AXET , AXER , RPRO )
            RVAL = RPRO - RREF
            IF (RVAL.LT.0.0D0) THEN
               INDICE = INDICE + 1
               ZR(JTBPDG-1+INDICE) = RVAL
               ZI(JTBNOE-1+INDICE) = INOF
               GOTO 3
            ENDIF
            DO 4 INOI = 1, NBNOI
               IF (RVAL.LE.ZR(JTBCOR-1+ZI(JTBRES-1+INOI))) THEN
                  IMIN = ZI(JTBRES-1+INOI-1)
                  RMIN = ZR(JTBCOR-1+IMIN)
                  IMAX = ZI(JTBRES-1+INOI)
                  RMAX = ZR(JTBCOR-1+IMAX)
                  GOTO 5
               ENDIF
 4          CONTINUE
            INDICE = INDICE + 1
            ZR(JTBPDG-1+INDICE) = RVAL
            ZI(JTBNOE-1+INDICE) = INOF
            GOTO 3
 5          CONTINUE
            IF ((RMAX-RMIN).EQ.0.0D0) THEN
               CALL UTDEBM('F','RS1D3D','LES NOEUDS DU MAILLAGE SONT '//
     +                      'CONFONDUS')
               CALL UTFINM()
            ENDIF
            LAMBDA = ( RVAL - RMIN )/( RMAX - RMIN )
            ZR(JCNSVE-1+(INOF-1)+1)=(1-LAMBDA)*ZR(JCNSVL-1+(IMIN-1)+1)+
     +                               LAMBDA*ZR(JCNSVL-1+(IMAX-1)+1)
            ZL(JCNSLE-1+(INOF-1)+1) = .TRUE.
 3       CONTINUE
         DO 6 ORDEF = 1,INDICE
            INO  = ZI(JTBNOE-1+ORDEF)
            RVAL = ZR(JTBPDG-1+ORDEF)
            IF (RVAL.LT.0.0D0) THEN
               IF (PGAUCH.EQ.'EXCLU') THEN
                  CALL JENUNO(JEXNUM(NOMMAF//'.NOMNOE',INO),NOM1)
                  CALL UTDEBM('F','RS1D3D','LE NOEUD SE TROUVE EN'//
     +                        ' DEHORS DU DOMAINE DE DEFINITION AVEC'//
     +                        ' UN PROFIL GAUCHE DE TYPE EXCLU')
                  CALL UTIMPK('L',' NOEUD : ',1,NOM1)
                  CALL UTFINM()
               ELSE IF (PGAUCH.EQ.'CONSTANT') THEN
                  INOMIN = ZI(JTBRES)
                  ZR(JCNSVE-1+(INO-1)+1) = ZR(JCNSVL-1+(INOMIN-1)+1)
                  ZL(JCNSLE-1+(INO-1)+1) = .TRUE.
               ELSE
                  INOMIN = ZI(JTBRES)
                  INOMAX = ZI(JTBRES+1)
                  RMIN = ZR(JTBCOR-1+INOMIN)
                  RMAX = ZR(JTBCOR-1+INOMAX)
                  LAMBDA = (RMIN - RVAL)/(RMAX - RVAL)
                  ZR(JCNSVE-1+(INO-1)+1) = (ZR(JCNSVL-1+(INOMIN-1)+1)-
     +                    ZR(JCNSVL-1+(INOMAX-1)+1)*LAMBDA)/(1-LAMBDA)
                  ZL(JCNSLE-1+(INO-1)+1) = .TRUE.
               ENDIF
            ELSE
               IF (PDROIT.EQ.'EXCLU') THEN
                  CALL JENUNO(JEXNUM(NOMMAF//'.NOMNOE',INO),NOM1)
                  CALL UTDEBM('F','RS1D3D','LE NOEUD SE TROUVE EN'//
     +                        ' DEHORS DU DOMAINE DE DEFINITION AVEC'//
     +                        ' UN PROFIL DROIT DE TYPE EXCLU')
                  CALL UTIMPK('L',' NOEUD : ',1,NOM1)
                  CALL UTFINM()
               ELSE IF (PDROIT.EQ.'CONSTANT') THEN
                  INOMAX = ZI(JTBRES-1+NBNOI)
                  ZR(JCNSVE-1+(INO-1)+1) = ZR(JCNSVL-1+(INOMAX-1)+1)
                  ZL(JCNSLE-1+(INO-1)+1) = .TRUE.
               ELSE
                  INOMIN = ZI(JTBRES-1+NBNOI-1)
                  INOMAX = ZI(JTBRES-1+NBNOI)
                  RMIN = ZR(JTBCOR-1+INOMIN)
                  RMAX = ZR(JTBCOR-1+INOMAX)
                  LAMBDA = (RMAX - RMIN)/(RVAL - RMIN)
                  ZR(JCNSVE-1+(INO-1)+1) = (ZR(JCNSVL-1+(INOMAX-1)+1)-
     +                    ZR(JCNSVL-1+(INOMIN-1)+1)*(1-LAMBDA))/LAMBDA
                  ZL(JCNSLE-1+(INO-1)+1) = .TRUE.
               ENDIF
            ENDIF
 6       CONTINUE
C
         CALL RSEXCH (RESU, 'TEMP', IORD, CNOINR, IBID)
         IF (IBID.NE.100) THEN
            CALL UTDEBM('F','RS1D3D','PROBLEME POUR STOKER LE CHAMP ')
            CALL UTIMPK('S','DANS LE RESULTAT : ',1,RESU)
            CALL UTIMPI('S',', POUR LE NUME_ORDRE : ',1,IORD)
            CALL UTFINM()
         ENDIF
         CALL CNSCNO ( CNSINR, ' ', 'G', CNOINR )
         CALL RSNOCH ( RESU, 'TEMP', IORD, ' ')
         CALL DETRSD ( 'CHAM_NO_S', CNSINR )
C
         CALL RSADPA ( RESU, 'E', 1, 'INST', IORD, 0, IAD, K8B )
         ZR(IAD) = DINST
C
         CALL DETRSD ( 'TABLE', TABL2 )
         CALL JEDETR ( TABCOR )
         CALL JEDETR ( TABRES )
         CALL JEDETR ( TABVAL )
C
 1    CONTINUE
      CALL JEDETR ( KNUM   )
      CALL JEDETR ( TABPDG )
      CALL JEDETR ( TABNOE )
C FIN ------------------------------------------------------------------
 9999 CONTINUE
      CALL JEDEMA()
      END
