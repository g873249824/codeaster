      SUBROUTINE NMIMPM(UNITM,PHASE,NATURZ,ARGZ,ARGR,ARGI)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/08/2005   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C
      IMPLICIT      NONE
      INTEGER       UNITM
      CHARACTER*4   PHASE
      CHARACTER*(*) NATURZ
      CHARACTER*(*) ARGZ(*)
      REAL*8        ARGR(*)
      INTEGER       ARGI(*)

C ----------------------------------------------------------------------
C  GESTION DES IMPRESSIONS DE LA COMMANDE STAT_NON_LINE
C  DERIVEE DE L'ANCIENNE ROUTINE NMIMPR
C ----------------------------------------------------------------------
C IN  PHASE  : 'INIT' INITIALISATION
C              'TITR' AFFICHAGE DE L'EN TETE DES PAS DE TEMPS
C              'IMPR' IMPRESSION
C IN  NATURE : NATURE DE L'IMPRESSION
C              'MATR_ASSE' -> ASSEMBLAGE DE LA MATRICE
C              'ARCH_INIT' -> TITRE ARCHIVAGE ETAT INITIAL
C              'ARCHIVAGE' -> STOCKAGE DES CHAMPS
C              'ITER_MAXI' -> MAXIMUM ITERATIONS ATTEINT
C              'SUBDIVISE' -> SUBDIVISION DU PAS DE TEMPS
C              'CONV_OK  ' -> CONVERGENCE ATTEINTE
C              'GEOM_MIN'  -> BOUCLE EN MOINS
C              'GEOM_MAX'  -> BOUCLE SUPPLEMENTAIRE
C              'FIXE_NON'  -> BOUCLE SUPPLEMENTAIRE SUR POINT FIXE
C                             DU CONTACT-FROTTEMENT
C              'ETAT_CONV' -> PARAMETRES DE CONVERGENCE
C              'ECHEC_LDC' -> ECHEC DE L'INTEGRATION DE LA LDC
C              'ECHEC_PIL' -> ECHEC DU PILOTAGE
C              'ECHEC_CON' -> ECHEC DE TRAITEMENT DU CONTACT
C              'CONT_SING' -> MATRICE DE CONTACT SINGULIERE
C              'MATR_SING' -> MATRICE DU SYSTEME SINGULIERE
C              'MAXI_RELA' -> CONVERGENCE SUR RESI_GLOB_MAXI
C                             QUAND RESI_GLOB_RELA & CHARGEMENT=0
C              'BCL_SEUIL' -> NUMERO BOUCLE SEUIL CONTACT ECP
C              'BCL_GEOME' -> NUMERO BOUCLE GEOMETRIE CONTACT ECP
C              'BCL_CTACT' -> NUMERO BOUCLE CONTRAINTE ACTIVE
C                             CONTACT ECP
C              'CNV_SEUIL' -> CONVERGENCE BOUCLE SEUIL CONTACT ECP
C              'CNV_GEOME' -> CONVERGENCE BOUCLE GEOMETRIE CONTACT ECP
C              'CNV_CTACT' -> CONVERGENCE BOUCLE CONTRAINTE ACTIVE
C                             CONTACT ECP
C              'LIGNE    ' -> SIMPLE LIGNE DE SEPARATION DANS LE TABLEAU
C IN  ARGZ   : ARGUMENTS EVENTUELS DE TYPE TEXTE
C IN  ARGR   : ARGUMENTS EVENTUELS DE TYPE REEL
C IN  ARGI   : ARGUMENTS EVENTUELS DE TYPE ENTIER
C ----------------------------------------------------------------------
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER          ZCOL,ZLIG,ZTIT,ZLAR
      PARAMETER       (ZCOL = 16,ZLIG = 255,ZTIT = 3,ZLAR=16)
      INTEGER          MESS,IUNIFI
      REAL*8           R8BID
      INTEGER          POS,POSFIN,POSMAR
      INTEGER          I,K,ICOL,IBID
      INTEGER          UNIBID,R8LONG,R8PREC
      CHARACTER*24     IMPRCO
      CHARACTER*16     ARG16,K16BID,OPTASS
      CHARACTER*9      NATURE
      CHARACTER*2      ARG2
      CHARACTER*1      MARQ
      CHARACTER*4      ARG4
      INTEGER          LONGR,PRECR,LONGI,LONGK,FORCOL
      INTEGER          VALI
      REAL*8           VALR
      CHARACTER*16     VALK
      CHARACTER*(ZLIG) LIGNE,COLONN,TITRE(ZTIT),TAMPON
      CHARACTER*(ZLAR) TITCOL(ZTIT)
      INTEGER          LIGMAX,TITMAX,NBCOL,LARMAX,LARGE,COLMAX
      SAVE             COLONN,TITRE,LARGE,LIGNE
      SAVE             LIGMAX,TITMAX,NBCOL
      CHARACTER*24     IMPCNT,IMPCNL,IMPCNV,IMPCNA
      INTEGER          JIMPCT,JIMPCL,JIMPCV,JIMPCA
      DATA IMPRCO      /'&&OP0070.IMPR.          '/
C
C ----------------------------------------------------------------------
C
      MESS   = IUNIFI ('MESSAGE')
      NATURE = NATURZ
C
C --- FORMAT D'AFFICHAGE D'INFO NON CONTENUES DANS LE TABLEAU 
C
      UNIBID = 0
      R8LONG = 16
      R8PREC = 9

C ======================================================================
C                   INITIALISATION DE L'IMPRESSION
C                   NB: UNE COLONNE FAIT ZLARG
C ======================================================================

      IF (PHASE.EQ.'INIT') THEN
C
C --- RECUPERATION ET VERIFICATION DES PARAMETRES
C
         CALL IMPINF(IMPRCO(1:14),
     &               IBID,COLMAX,LIGMAX,TITMAX,NBCOL,LARGE,
     &               IBID,IBID,LARMAX)
C
C --- SI CE MESSAGE SE DECLENCHE, VERIFIER LA COHERENCE ENTRE
C --- ZTIT, ZCOL, ZLIG DANS IMPINI ET LES DONNEES LOCALES
C --- ELLES DOIVENT ETRE STRICTEMENT IDENTIQUES
C
         IF ((ZCOL.NE.COLMAX).OR.
     &       (ZTIT.NE.TITMAX).OR.
     &       (ZLAR.NE.LARMAX).OR.
     &       (ZLIG.NE.LIGMAX)) THEN
           CALL UTMESS('F',
     &                 'NMIMPR',
     &                 'INCOHERENCE DE TAILLE (DVLP)')
         ENDIF
C
C --- INITIALISATIONS
C
         DO 21 I = 1,LIGMAX
           TITRE(1)(I:I)  = ' '
           TITRE(2)(I:I)  = ' '
           TITRE(3)(I:I)  = ' '
           COLONN(I:I)    = ' '
           LIGNE(I:I)     = ' '
 21      CONTINUE
C
C --- LIGNE DE SEPARATION
C --- STOCKEE ET SAUVEE (SAVE) DANS LIGNE
C
         DO 22 I = 1,LARGE
           LIGNE(I:I) = '-'
 22      CONTINUE
C
C --- MARQUAGE DES COLONNES PAR LES TRAITS VERTICAUX 
C --- (LARGEUR D'UNE COLONNE FIXEE PAR ZLAR)
C --- STOCKEE ET SAUVEE (SAVE) DANS COLONN
C
         DO 23 I = 1,LARGE
          IF (MOD(I-1,ZLAR+1) .EQ. 0) THEN
            COLONN(I:I) = '|'
          ELSE
            COLONN(I:I) = ' '
          END IF
 23      CONTINUE
C
C --- TITRE DES COLONNES
C
         POS = 2
         DO 30 ICOL = 1,NBCOL
           CALL IMPSDA(IMPRCO(1:14),'LIRE',ICOL,
     &                 IBID,TITCOL,IBID,
     &                 IBID,IBID,IBID,IBID)
           DO 32 K = 1,TITMAX
             TITRE(K)(POS:POS+ZLAR-1) = TITCOL(K)
 32        CONTINUE
           POS = POS+ZLAR+1
 30      CONTINUE

         DO 35 I = 1,LARGE
           IF (MOD(I-1,ZLAR+1) .EQ. 0) THEN
             DO 34 K = 1,TITMAX
               TITRE(K)(I:I) = '|'
 34          CONTINUE
           END IF
 35      CONTINUE
C
C --- PREPARATION DU FICHIER DE SORTIE
C         
         IF (UNITM.NE.MESS) THEN
           CALL NMIMPF(UNITM) 
         ENDIF
         
         GOTO 9999
      ENDIF


C ======================================================================
C                        AFFICHAGE DE L'EN-TETE
C ======================================================================

      IF (PHASE .EQ. 'TITR') THEN
C
C --- AFFICHAGE DE L'INSTANT DE CALCUL
C
        CALL IMPFOR(UNIBID,R8LONG,R8PREC,ARGR(1),ARG16)

        IF (UNITM.EQ.MESS) THEN
          WRITE(UNITM,*)
          WRITE(UNITM,'(A)') LIGNE  (1:LARGE)
          WRITE(UNITM,*)
          CALL IMPFOK('INSTANT DE CALCUL : '//ARG16,UNITM)
          WRITE(UNITM,*)
          WRITE(UNITM,'(A)') LIGNE  (1:LARGE)

          DO 39 K = 1,TITMAX
            CALL IMPFOK(TITRE(K),UNITM)
 39       CONTINUE

          WRITE(UNITM,'(A)') LIGNE  (1:LARGE)
        ELSE
          

          WRITE(UNITM,*)
          WRITE(UNITM,*)

          CALL IMPFOK('INSTANT DE CALCUL : '//ARG16,UNITM)
          WRITE(UNITM,*)
          WRITE(UNITM,'(A)') LIGNE  (1:LARGE)

          DO 33 K = 1,TITMAX
            CALL IMPFOK(TITRE(K),UNITM)
 33       CONTINUE
  
          WRITE(UNITM,'(A)') LIGNE  (1:LARGE)
        ENDIF

        GOTO 9999
      END IF


C ======================================================================
C                       GESTION DES IMPRESSIONS
C ======================================================================


C --- LIGNE

      IF (NATURE(1:5) .EQ. 'LIGNE') THEN
        WRITE(UNITM,'(A)') LIGNE(1:LARGE)

C --- ASSEMBLAGE MATRICE

      ELSE IF (NATURE .EQ. 'MATR_ASSE') THEN

        IF (ARGI(1).EQ.0) THEN
          OPTASS = ARGZ(1)
        ELSE
          OPTASS = ARGZ(2)
        ENDIF

        CALL IMPSDR(IMPRCO(1:14),
     &              'MATR_ASSE',OPTASS,R8BID,IBID)


C --- ARCHIVAGE ETAT INITIAL

      ELSE IF (NATURE .EQ. 'ARCH_INIT') THEN
        WRITE(UNITM,*)
        CALL IMPFOK('ARCHIVAGE DE L''ETAT INITIAL',
     &               UNITM)

C --- ARCHIVAGE DES CHAMPS

      ELSE IF (NATURE .EQ. 'ARCHIVAGE') THEN

 1000   FORMAT(1P,3X,'CHAMP STOCKE : ',A16,' INSTANT : ',1PE12.5,
     &         '  NUMERO D''ORDRE : ',I5)
        IF (UNITM.EQ.MESS) THEN    
          ARG16 = ARGZ(1)
          WRITE (UNITM,1000) ARG16,ARGR(1),ARGI(1)
        ENDIF

      ELSE IF (NATURE .EQ. 'TPS_PAS') THEN
        IF (UNITM.EQ.MESS) THEN
          WRITE(UNITM,*)
          WRITE(UNITM,666) ARGR(1)
          IF (ARGI(1).EQ.1) THEN
            WRITE(UNITM,667) ARGR(2)
            WRITE(UNITM,668) ARGR(3)
          ENDIF
          WRITE(UNITM,*)
        ENDIF
 666    FORMAT ('TEMPS CPU CONSOMME DANS CE PAS DE TEMPS : ',1PE16.9)
 667    FORMAT ('DONT CONTACT-GEOMETRIE : ',1PE16.9)
 668    FORMAT ('  ET CONTACT-RESOLUTION: ',1PE16.9)
C
C --- ERREUR
C
      ELSE IF (NATURE(1:6) .EQ. 'ERREUR') THEN
        WRITE(UNITM,'(A)') LIGNE(1:LARGE)
        WRITE(UNITM,*)
        CALL NMIMPA(UNITM,ARGZ(1),ARGI(1))
        WRITE(UNITM,*)
C
C --- SUBDIVISION DU PAS DE TEMPS
C
      ELSE IF (NATURE .EQ. 'SUBDIVISE') THEN
        IF (UNITM.EQ.MESS) THEN    
          WRITE(UNITM,'(A)') LIGNE(1:LARGE)
          WRITE(UNITM,*)
          CALL IMPFOI(0,2,ARGI(1),ARG2)
          CALL IMPFOK('SUBDIVISION DU PAS DE TEMPS EN '//ARG2//
     &              ' SOUS PAS',UNITM)
          WRITE(UNITM,*)
        ENDIF
C
C --- RECAPITULATIF DES INFOS DE CONVERGENCE
C
      ELSE IF (NATURE .EQ. 'CONV_RECA') THEN

        IMPCNT = IMPRCO(1:14)//'CONV.TYPE'
        IMPCNL = IMPRCO(1:14)//'CONV.LIEU'
        IMPCNV = IMPRCO(1:14)//'CONV.VAL'
        IMPCNA = IMPRCO(1:14)//'CONV.ACT'
        CALL JEVEUO(IMPCNT,'L',JIMPCT)
        CALL JEVEUO(IMPCNL,'L',JIMPCL)
        CALL JEVEUO(IMPCNV,'L',JIMPCV)
        CALL JEVEUO(IMPCNA,'L',JIMPCA)



        IF (UNITM.EQ.MESS) THEN  
          DO 10 I = 1,5 
            IF (ZL(JIMPCA-1+I)) THEN

              TAMPON = 'RESIDU '
              TAMPON(8:23)  =  ZK16(JIMPCT-1+I)    
  
              CALL IMPFOR(UNIBID,R8LONG,R8PREC,ZR(JIMPCV-1+I),ARG16)
          
              TAMPON(24:49) = ' VAUT '//ARG16

              IF (ARGZ(1)(1:7).NE.'INCONNU') THEN
                TAMPON(46:50) = ' SUR '
                TAMPON(51:66) = ZK16(JIMPCL-1+I)
              ENDIF

              CALL IMPFOK(TAMPON,UNITM)

            ENDIF
  10      CONTINUE
        ENDIF
C
C --- CRITERES DE CONVERGENCE ATTEINTS
C
      ELSE IF (NATURE .EQ. 'CONV_OK  ') THEN
        WRITE(UNITM,'(A)') LIGNE(1:LARGE)
        IF (UNITM.EQ.MESS) THEN
          WRITE(UNITM,*)
          CALL IMPFOK('<*> CRITERE(S) DE CONVERGENCE ATTEINT(S)',UNITM)
          WRITE(UNITM,*)
        ENDIF
C
C --- RESI_GLOB_RELA ET CHARGEMENT = 0, CONVERGENCE SUR RESI_GLOB_MAXI
C
      ELSE IF (NATURE .EQ. 'MAXI_RELA') THEN
        IF (UNITM.EQ.MESS) THEN
          WRITE(UNITM,'(A)') LIGNE(1:LARGE)
          WRITE(UNITM,*)
          CALL IMPFOK('ATTENTION : CONVERGENCE ATTEINTE AVEC',UNITM)
          CALL IMPFOR(UNIBID,R8LONG,R8PREC,ARGR(1),ARG16)

          CALL IMPFOK('CRITERE RESI_GLOB_MAXI='//ARG16,UNITM)
          CALL IMPFOK('POUR CAUSE DE CHARGEMENT PRESQUE NUL',UNITM)
        ENDIF
C
C --- INFO SUR LA CONVERGENCE DU CONTACT
C
      ELSE IF (NATURE .EQ. 'CONV_CONT') THEN
        IF (UNITM.EQ.MESS) THEN        
          WRITE(UNITM,*)
          CALL IMPFOK('<*> CONTACT - CRITERE(S) DE CONVERGENCE'//
     &              ' ATTEINT(S)',UNITM)
          WRITE(UNITM,*)

          IF (ARGI(1).EQ.0) THEN
            CALL IMPFOK('SUR GEOMETRIE INITIALE',UNITM)
          ELSE IF (ARGI(1).EQ.1) THEN
            TAMPON = 'AVEC '
            CALL IMPFOI(0,4,ARGI(1),ARG4)
            TAMPON(6:9)   = ARG4
            TAMPON(10:37) = ' REACTUALISATION GEOMETRIQUE'
            CALL IMPFOK(TAMPON,UNITM)
          ELSE
            TAMPON = 'AVEC '
            CALL IMPFOI(0,4,ARGI(1),ARG4)
            TAMPON(6:9)   = ARG4
            TAMPON(10:39) = ' REACTUALISATIONS GEOMETRIQUES'
            CALL IMPFOK(TAMPON,UNITM)
          ENDIF
          TAMPON = 'AVEC '
          CALL IMPFOI(0,4,ARGI(2),ARG4)
          TAMPON(6:9)   = ARG4
          TAMPON(10:32) = ' ITERATIONS DE CONTACT'

          CALL IMPFOK(TAMPON,UNITM)
          WRITE(UNITM,*)
      ENDIF
C
C -- BOUCLE DE GEOMETRIE CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'BCL_GEOME') THEN
         CALL IMPSDR(IMPRCO(1:14),
     &               'CTCC_GEOM',K16BID,R8BID,ARGI(1))
         CALL IMPSDM(IMPRCO(1:14),'CTCC_GEOM','X')
C
C --- BOUCLE DE SEUIL CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'BCL_SEUIL') THEN
         CALL IMPSDR(IMPRCO(1:14),
     &               'CTCC_FROT',K16BID,R8BID,ARGI(1))
         CALL IMPSDM(IMPRCO(1:14),'CTCC_FROT','X')
C
C --- BOUCLE DE CONTRAINTES ACTIVES CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'BCL_CTACT') THEN
         CALL IMPSDR(IMPRCO(1:14),
     &               'CTCC_CONT',K16BID,R8BID,ARGI(1))
         CALL IMPSDM(IMPRCO(1:14),'CTCC_CONT','X')
C
C -- CONVERGENCE BOUCLE DE SEUIL CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'CNV_SEUIL') THEN
         CALL IMPSDM(IMPRCO(1:14),'CTCC_FROT',' ')
C
C -- CONVERGENCE BOUCLE DE CONTRAINTES ACTIVES CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'CNV_CTACT') THEN
         CALL IMPSDM(IMPRCO(1:14),'CTCC_CONT',' ')
C
C -- CONVERGENCE BOUCLE DE GEOMETRIE CONTACT CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'CNV_GEOME') THEN
         CALL IMPSDM(IMPRCO(1:14),'CTCC_GEOM',' ')
C
C -- ETAT DE LA CONVERGENCE
C
      ELSE IF (NATURE .EQ. 'ETAT_CONV') THEN
        TAMPON = COLONN(1:LARGE)

        POS = 2
        DO 100 ICOL = 1, NBCOL
          CALL IMPSDA(IMPRCO(1:14),'LIRE',ICOL,
     &                IBID,TITCOL,FORCOL,
     &                LONGR,PRECR,LONGI,LONGK)

          IF (FORCOL.EQ.1) THEN
            POSFIN = POS+ZLAR-1
            CALL IMPSDV(IMPRCO(1:14),
     &                  ICOL,K16BID,R8BID,VALI,MARQ) 
            CALL IMPFOI(0,LONGI,VALI,
     &                  TAMPON(POS:POSFIN))
            IF (MARQ(1:1).NE.' ') THEN  
              POSMAR = POS + ZLAR - 2   
              TAMPON(POSMAR:POSMAR) = MARQ(1:1)
            ENDIF                               
          ELSE IF (FORCOL.EQ.2) THEN
            POSFIN = POS+ZLAR-1
            CALL IMPSDV(IMPRCO(1:14),
     &                  ICOL,K16BID,VALR,IBID,MARQ) 
     
            CALL IMPFOR(UNIBID,LONGR,PRECR,VALR,
     &                  TAMPON(POS:POSFIN))
            IF (MARQ(1:1).NE.' ') THEN  
              POSMAR = POS + ZLAR - 2   
              TAMPON(POSMAR:POSMAR) = MARQ(1:1)
            ENDIF
          ELSE IF (FORCOL.EQ.3) THEN
            POSFIN = POS+ZLAR-1
            CALL IMPSDV(IMPRCO(1:14),
     &                  ICOL,VALK,R8BID,IBID,MARQ) 
            TAMPON(POS:POSFIN) = VALK(1:16)
          ELSE
            CALL UTMESS('F','NMIMPR',
     &                  'FORMAT DE COLONNE INCONNU (DVLP)')
          ENDIF
          POS = POS + ZLAR + 1
 100    CONTINUE

        WRITE(UNITM,'(A)') TAMPON(1:LARGE)

      ELSE
C        CALL UTMESS('F','NMIMPR',
C     &              'NATURE DE MESSAGE ILLICITE (DVLP)')
      END IF

 9999 CONTINUE
      END
