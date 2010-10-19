      SUBROUTINE CFJEIN(NOMA  ,DEFICO,RESOCO,RESU  ,LMAT  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/10/2010   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 RESU
      INTEGER      LMAT
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE DISCRETE - ALGORITHME)
C
C CALCUL DES JEUX INITIAUX
C DETECTION DES COUPLES DE NOEUDS INTERPENETRES
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  LMAT   : DESCRIPTEUR DE LA MATR_ASSE DU SYSTEME MECANIQUE
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  RESU   : INCREMENT "DDEPLA" DE DEPLACEMENT DEPUIS L'ITERATION
C              DE NEWTON PRECEDENTE (CORRIGEE PAR LE CONTACT)
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
      INTEGER      NBLIAI,NEQ,NBDDL,NTPC,NDIM
      INTEGER      ILIAI,IEQ,IALARM,BTOTAL,LLIAC
      INTEGER      JRESU,JLIAI,JDECAL
      CHARACTER*19 DELTA,DELT0,LIOT,LIAC,TYPL
      INTEGER      JDELTA,JDELT0,JLIOT,JLIAC,JTYPL
      CHARACTER*24 ATMU,AFMU,RESU0,MU,APJEFX
      INTEGER      JATMU,JAFMU,JMU,JAPJFX
      CHARACTER*24 APDDL,APCOEF,APJEU,CLREAC
      INTEGER      JAPDDL,JAPCOE,JAPJEU,JCLREA
      CHARACTER*24 APPOIN
      INTEGER      JAPPTR
      INTEGER      CFDISD,CFDISI
      LOGICAL      CFDISL,LGCP,LGLISS,LPENAC,LCTFD,LPENAF,LCOACT
      LOGICAL      JEUACT,LLAGRC,LLAGRF,REAPRE,REAGEO
      REAL*8       CFDISR,AJEU,VAL,ALJEU,JEUMIN,VDIAGM,JEU
      REAL*8       R8PREM
      CHARACTER*1  TYPEAJ
      CHARACTER*2  TYPEC0,TYPEF0
      INTEGER      INDIC,POSIT,NBLIAC,LLF,LLF1,LLF2,AJLIAI,SPLIAI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      LIOT   = RESOCO(1:14)//'.LIOT'
      APPOIN = RESOCO(1:14)//'.APPOIN'
      APDDL  = RESOCO(1:14)//'.APDDL'
      APCOEF = RESOCO(1:14)//'.APCOEF'
      DELT0  = RESOCO(1:14)//'.DEL0'
      DELTA  = RESOCO(1:14)//'.DELT'
      ATMU   = RESOCO(1:14)//'.ATMU'
      AFMU   = RESOCO(1:14)//'.AFMU'
      APJEU  = RESOCO(1:14)//'.APJEU'
      LIAC   = RESOCO(1:14)//'.LIAC'
      TYPL   = RESOCO(1:14)//'.TYPL'
      MU     = RESOCO(1:14)//'.MU'
      CLREAC = RESOCO(1:14)//'.REAL'
      APJEFX = RESOCO(1:14)//'.APJEFX'
      CALL JEVEUO(LIOT  ,'E',JLIOT )
      CALL JEVEUO(APPOIN,'L',JAPPTR)
      CALL JEVEUO(APDDL ,'L',JAPDDL)
      CALL JEVEUO(APCOEF,'L',JAPCOE)
      CALL JEVEUO(APJEU ,'E',JAPJEU)
      CALL JEVEUO(LIAC  ,'E',JLIAC )
      CALL JEVEUO(TYPL  ,'E',JTYPL )
      CALL JEVEUO(CLREAC,'L',JCLREA)
      CALL JEVEUO(MU,    'E',JMU   )
      CALL JEVEUO(RESU(1:19)//'.VALE','E',JRESU)
C
C --- INITIALISATIONS
C
      RESU0  = '&&CFJEIN.RESU0'
      NBLIAI = CFDISD(RESOCO,'NBLIAI'  )
      NEQ    = CFDISD(RESOCO,'NEQ'     )
      NDIM   = CFDISD(RESOCO,'NDIM'    )
      NTPC   = CFDISI(DEFICO,'NTPC'   )
      LGCP   = CFDISL(DEFICO,'CONT_GCP')
      LGLISS = CFDISL(DEFICO,'CONT_DISC_GLIS')
      LCOACT = CFDISL(DEFICO,'CONT_ACTI'   )
      LPENAC = CFDISL(DEFICO,'CONT_PENA'   )
      LPENAF = CFDISL(DEFICO,'FROT_PENA'   )
      LLAGRC = CFDISL(DEFICO,'CONT_LAGR'   )
      LLAGRF = CFDISL(DEFICO,'FROT_LAGR'   )
      ALJEU  = CFDISR(DEFICO,'ALARME_JEU'  )
      LCTFD  = CFDISL(DEFICO,'FROT_DISCRET')
      JEUMIN = 0.D0
      INDIC  = 0
      POSIT  = 0
      AJLIAI = 0
      SPLIAI = 0
      IALARM = 0
      TYPEAJ = 'A'
      TYPEC0 = 'C0'
      TYPEF0 = 'F0'
      REAPRE = ZL(JCLREA+3-1)
      REAGEO = ZL(JCLREA+1-1)
C
C --- INITIALISATIONS DES SD POUR LA DETECTION DES PIVOTS NULS
C
      IF (LLAGRC) THEN
        IF (REAGEO) THEN
          DO 100 ILIAI = 1,NTPC
            ZI(JLIOT+0*NTPC-1+ILIAI) = 0
            ZI(JLIOT+1*NTPC-1+ILIAI) = 0
            ZI(JLIOT+2*NTPC-1+ILIAI) = 0
            ZI(JLIOT+3*NTPC-1+ILIAI) = 0
 100      CONTINUE
          ZI(JLIOT+4*NTPC  ) = 0
          ZI(JLIOT+4*NTPC+1) = 0
          ZI(JLIOT+4*NTPC+2) = 0
          ZI(JLIOT+4*NTPC+3) = 0
        ENDIF
      ELSE
        ZI(JLIOT+4*NBLIAI  ) = 0
        ZI(JLIOT+4*NBLIAI+1) = 0
        ZI(JLIOT+4*NBLIAI+2) = 0
        ZI(JLIOT+4*NBLIAI+3) = 0
      ENDIF
C
C --- INITIALISATIONS DES LAGRANGES
C
      IF (LLAGRC.AND.LCTFD.AND.REAPRE) THEN
        CALL JEVEUO(APJEFX,'E',JAPJFX)
        DO 331 ILIAI = 1,NTPC
          ZR(JMU+3*NTPC+ILIAI-1) = 0.D0
          ZR(JMU+2*NTPC+ILIAI-1) = 0.D0
          ZR(JMU+NTPC+ILIAI-1)   = 0.D0
          ZR(JMU+ILIAI-1)         = 0.D0
          IF ((NDIM.EQ.2).AND.LLAGRF) THEN
            ZR(JAPJFX-1+ILIAI)      = 0.D0
          ENDIF
 331    CONTINUE
      ENDIF
      IF (LPENAC.AND.LPENAF.AND.REAPRE) THEN
        DO 332 ILIAI = 1,NTPC
          ZR(JMU+2*NTPC+ILIAI-1) = 0.D0
          ZR(JMU+NTPC+ILIAI-1)   = 0.D0
 332    CONTINUE
      ENDIF
C
C --- AFFICHAGE
C
      IF (NIV.EQ.2) THEN
        WRITE(IFM,*)'<CONTACT> LIAISONS INITIALES '
        WRITE(IFM,1000) NBLIAI
      ENDIF
C
C --- SAUVEGARDE DU DEPLACEMENT INITIAL POUR GCP
C
      IF (LGCP) THEN
        CALL JEDUPO(RESU//'.VALE','V',RESU0,.FALSE.)
      ENDIF
C
C --- LIAISONS ACTIVEES POUR GCP
C
      IF (LGCP) THEN
C ----- TOUTES LES LIAISONS SONT DES LIAISONS DE CONTACT
C ----- ET PORTENT LEUR NUMERO "NATUREL"
        DO 31 ILIAI = 1,NBLIAI
          ZK8(JTYPL-1+ILIAI) = TYPEC0
          ZI(JLIAC-1+ILIAI)  = ILIAI
 31     CONTINUE
        GOTO 9999
      ENDIF
C
C --- RECOPIE DANS DELT0 DU CHAMP DE DEPLACEMENTS OBTENU SANS
C --- TRAITER LE CONTACT (LE DDEPLA DONNE PAR STAT_NON_LINE)
C --- CREATION DE DELTA0 = C-1.B
C
      IF ((.NOT.(LPENAC.AND.(.NOT.LCTFD)))) THEN
        CALL JEVEUO(DELT0 ,'E',JDELT0)
        DO 10 IEQ = 1, NEQ
          ZR(JDELT0-1+IEQ) = ZR(JRESU-1+IEQ)
 10     CONTINUE
      ENDIF
      IF (LPENAC.AND.LPENAF) THEN
        CALL JEVEUO(DELT0 ,'E',JDELT0)
        DO 17 IEQ = 1, NEQ
          ZR(JDELT0-1+IEQ) = ZR(JRESU-1+IEQ)
 17     CONTINUE
      ENDIF
C
C --- SI CONTACT NON PENALISE, INITIALISATION DU D_U
C
      IF (.NOT.LPENAC) THEN
        CALL R8INIR(NEQ,0.D0,ZR(JRESU),1)
      ENDIF
C
C --- INITIALISATION DES FORCES DE CONTACT
C
      IF (LLAGRF) THEN
        CALL JEVEUO(ATMU  ,'E',JATMU )
        CALL R8INIR(NEQ,0.D0,ZR(JATMU),1)
      ENDIF
C
C --- INITIALISATION DES FORCES DE FROTTEMENT
C
      IF (LCTFD) THEN
        CALL JEVEUO(AFMU  ,'E',JAFMU )
        CALL R8INIR(NEQ,0.D0,ZR(JAFMU),1)
      ENDIF
C
C --- CAS DE LA METHODE PENALISEE: ON UTILISE AFMU
C
      IF (LPENAC) THEN
        CALL JEVEUO(AFMU  ,'E',JAFMU )
        CALL R8INIR(NEQ,0.D0,ZR(JAFMU),1)
      ENDIF
C
C --- SAUVEGARDE DE LA VALEUR MAXI SUR LA DIAGONALE DE LA
C --- MATR_ASSE DU SYSTEME
C --- POUR VALEUR DE LA PSEUDO-PENALISATION EN FROT. LAGR. 3D
C
      IF (LLAGRF.AND.(NDIM.EQ.3).AND.REAPRE) THEN
        CALL CFDIAG(LMAT  ,VDIAGM)
        ZR(JMU+6*NTPC-1) = VDIAGM ** 0.25D0
      ENDIF
C
C --- NOMBRE DE LIAISONS INITIALES
C --- GLUTE INFAME: POUR LES METHODES LAGRANGIENNES, ON GARDE
C --- LA MEMOIRE DES LIAISONS PRECEDEMMENT ACTIVES
C
      IF (LLAGRC) THEN
        IF (REAPRE) THEN
          NBLIAC = 0
          LLF    = 0
          LLF1   = 0
          LLF2   = 0
        ELSEIF (REAGEO) THEN
          NBLIAC = 0
          LLF    = 0
          LLF1   = 0
          LLF2   = 0
        ELSE
          NBLIAC = CFDISD(RESOCO,'NBLIAC'  )
          IF (LPENAF) THEN
            LLF    = 0
            LLF1   = 0
            LLF2   = 0
          ELSE
            LLF    = CFDISD(RESOCO,'LLF'     )
            LLF1   = CFDISD(RESOCO,'LLF1'    )
            LLF2   = CFDISD(RESOCO,'LLF2'    )
          ENDIF
        ENDIF
      ELSE
        NBLIAC = 0
        LLF    = 0
        LLF1   = 0
        LLF2   = 0
      ENDIF
C
C --- DETECTION DES COUPLES DE NOEUDS INTERPENETRES
C --- ON CALCULE LE NOUVEAU JEU : AJEU+ = AJEU/I/N - A.DDEPLA
C --- (IL EST NEGATIF LORSQU'IL Y A INTERPENETRATION -> LIAISON ACTIVE)
C
      BTOTAL = NBLIAC + LLF + LLF1 + LLF2
      DO 30 ILIAI = 1,NBLIAI
C
C --- CALCUL DU JEU
C
        JDECAL = ZI(JAPPTR+ILIAI-1)
        NBDDL  = ZI(JAPPTR+ILIAI)  - ZI(JAPPTR+ILIAI-1)
        IF (LPENAC) THEN
          CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &                ZR(JRESU),VAL)

        ELSEIF (LCOACT) THEN
          CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &                ZR(JDELT0),VAL)

        ELSEIF (LLAGRC) THEN
          IF (LPENAF) THEN
            CALL JEVEUO(DELTA ,'L',JDELTA)
            CALL CALADU(NEQ,NBDDL,ZR(JAPCOE+JDECAL),ZI(JAPDDL+JDECAL),
     &                  ZR(JDELTA),VAL)
          ELSE
            VAL  = 0.D0
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)

        ENDIF
        JEU  = ZR(JAPJEU+ILIAI-1)
        AJEU = JEU - VAL
C
C --- ALARME SI DECOLLEMENT ALORS QUE GLISSIERE
C
        IF (LGLISS) THEN
          IF (AJEU.GT.ALJEU) THEN
            IALARM = IALARM+1
            IF (IALARM.EQ.1) THEN
              CALL U2MESS('A','CONTACT_9')
            ENDIF
            CALL CFIMP2(DEFICO,RESOCO,NOMA  ,IFM   ,ILIAI,
     &                  TYPEC0,'N'   ,'ALJ' ,AJEU  )
          ENDIF
        ENDIF
C
C --- JEU ACTIF ?
C --- INFAME GLUTE DUE AU COMPORTEMENT DIFFERENT DES ALGOS
C --- CONTRAINTE ET LAGRANGE
C
        JEUACT = .FALSE.
C
        IF (LPENAC) THEN
          IF (AJEU.LT.JEUMIN) THEN
            JEUACT = .TRUE.
          ENDIF
        ELSEIF (LCOACT) THEN
          IF (AJEU.LT.JEUMIN) THEN
            JEUACT = .TRUE.
          ENDIF
        ELSEIF (LLAGRC) THEN
          IF (LLAGRF) THEN
            IF (NDIM.EQ.3) THEN
              IF (JEU.LT.R8PREM()) THEN
                JEUACT = .TRUE.
              ENDIF
            ELSEIF (NDIM.EQ.2) THEN
              IF (JEU.LT.JEUMIN) THEN
                JEUACT = .TRUE.
              ENDIF
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF
          ELSE
            IF (JEU.LT.JEUMIN) THEN
              JEUACT = .TRUE.
            ENDIF
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C
C --- DEUXIEME GLUTE INFAME: POUR LES METHODES LAGRANGIENNES, ON GARDE
C --- MEMOIRE DES LIAISONS PRECEDEMMENT ACTIVES
C
        POSIT  = NBLIAC + LLF + LLF1 + LLF2 + 1
        IF (LPENAC) THEN
          ZR(JAPJEU+ILIAI-1) = AJEU
          IF (JEUACT) THEN
            CALL CFTABL(INDIC ,NBLIAC,AJLIAI,SPLIAI,LLF   ,
     &                  LLF1  ,LLF2  ,RESOCO,TYPEAJ,POSIT ,
     &                  ILIAI ,TYPEC0)
          ENDIF
        ELSEIF (LCOACT) THEN
          IF (JEUACT.OR.LGLISS) THEN
            CALL CFTABL(INDIC ,NBLIAC,AJLIAI,SPLIAI,LLF   ,
     &                  LLF1  ,LLF2  ,RESOCO,TYPEAJ,POSIT ,
     &                  ILIAI ,TYPEC0)
          ENDIF
        ELSEIF (LLAGRC) THEN
          IF (REAPRE) THEN
            IF (JEUACT) THEN
              CALL CFTABL(INDIC ,NBLIAC,AJLIAI,SPLIAI,LLF   ,
     &                    LLF1  ,LLF2  ,RESOCO,TYPEAJ,POSIT ,
     &                    ILIAI ,TYPEC0)
            ENDIF
          ELSEIF (REAGEO) THEN
            IF (JEUACT) THEN
              CALL CFTABL(INDIC ,NBLIAC,AJLIAI,SPLIAI,LLF   ,
     &                    LLF1  ,LLF2  ,RESOCO,TYPEAJ,POSIT ,
     &                    ILIAI ,TYPEC0)
            ENDIF
          ENDIF
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
   30 CONTINUE
C
C --- TOUTES LES LIAISONS DE CONTACT SONT CONSIDEREES ADHERENTES
C
      BTOTAL = NBLIAC + LLF + LLF1 + LLF2
      IF (LLAGRC.AND.
     &   (REAPRE.OR.(REAGEO.AND.(NDIM.EQ.3))).AND.LLAGRF) THEN
        DO 7 JLIAI = 1, BTOTAL
          LLIAC  = ZI(JLIAC-1+JLIAI)
          POSIT  = NBLIAC + LLF + LLF1 + LLF2 + 1
          CALL CFTABL(INDIC ,NBLIAC,AJLIAI,SPLIAI,LLF   ,
     &                LLF1  ,LLF2  ,RESOCO,TYPEAJ,POSIT ,
     &                LLIAC ,TYPEF0)
   7    CONTINUE
      ENDIF
C
C --- STOCKAGE DES VARIABLES DE CONTROLE DU CONTACT
C
      CALL CFECRD(RESOCO,'INDIC' ,INDIC )
      CALL CFECRD(RESOCO,'AJLIAI',AJLIAI)
      CALL CFECRD(RESOCO,'SPLIAI',SPLIAI)
      CALL CFECRD(RESOCO,'NBLIAC',NBLIAC)
      CALL CFECRD(RESOCO,'LLF'   ,LLF   )
      CALL CFECRD(RESOCO,'LLF1'  ,LLF1  )
      CALL CFECRD(RESOCO,'LLF2'  ,LLF2  )
C
C --- AFFICHAGES
C
      IF (NIV.GE.2) THEN
        WRITE(IFM,1005) NBLIAC
        IF (LLAGRF) THEN
          IF (NDIM.EQ.2) THEN
            WRITE(IFM,1007) LLF
          ELSEIF (NDIM.EQ.3) THEN
            WRITE(IFM,1007) LLF
            WRITE(IFM,3006) LLF1
            WRITE(IFM,4006) LLF2
          ENDIF
        ENDIF
        CALL CFIMP1(NOMA  ,DEFICO,RESOCO,IFM   )
      END IF
C
 9999 CONTINUE
C
 1000 FORMAT (' <CONTACT> <> NOMBRE DE LIAISONS POSSIBLES: ',I8)
 1005 FORMAT (' <CONTACT> <> NOMBRE DE LIAISONS CONTACT INITIALES:',
     &       I6,')')
 1007 FORMAT (' <CONTACT> <> NOMBRE DE LIAISONS ADH. INITIALES:',
     &       I6,')')
 3006 FORMAT (' <CONTACT> <> NOMBRE DE LIAISONS ADH. '//
     &        'INITIALES (1 UNIQ.):',I6,')')
 4006 FORMAT (' <CONTACT> <> NOMBRE DE LIAISONS ADH. '//
     &        'INITIALES (2 UNIQ.):',I6,')')
C
      CALL JEDEMA()
C
      END
