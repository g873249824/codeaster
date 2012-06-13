      SUBROUTINE CFCRSD(NOMA  ,NUMEDD,DEFICO,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INCLUDE 'jeveux.h'
      CHARACTER*8  NOMA
      CHARACTER*24 NUMEDD
      CHARACTER*24 DEFICO,RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES)
C
C CREATION DES STRUCTURES DE DONNEES NECESSAIRES AU TRAITEMENT
C DU CONTACT/FROTTEMENT
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NUMEDD : NOM DU NUME_DDL
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C OUT RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C
C
C
C
      INTEGER      IFM,NIV
      INTEGER      CFMMVD,ZTACF
      INTEGER      CFDISI,NDIMG,NTPC,NNOCO,NEQ
      INTEGER      NBLIAI,II
      REAL*8       R8VIDE
      CHARACTER*8  K8BID
      CHARACTER*19 MU ,ATMU ,AFMU,COPO
      INTEGER      JMU,JATMU,JAFMU,JCOPO
      CHARACTER*19 DDEPL0,DDEPLC,DDELT,DEPL0,DEPLC
      CHARACTER*19 CM1A,ENAT,FRO1,FRO2
      CHARACTER*19 SECMBR,CNCIN0
      CHARACTER*19 SGRADM,SGRADP,SGRPRM,SGRPRP,DIRECT,MUM   ,SVMU
      INTEGER      JSGRAM,JSGRAP,JSGPRM,JSGPRP,JDIREC,JMUM  ,JSVMU
      CHARACTER*19 PCRESI,PCDIRE,PCDEPL
      INTEGER      JPCRES,JPCDIR,JPCDEP
      INTEGER      NBCM1A,NBENAT,NBFRO1,NBFRO2
      CHARACTER*24 AUTOC1,AUTOC2
      CHARACTER*24 CLREAC,TACFIN,TANGCO
      INTEGER      JCLREA,JTACF ,JTANGO
      LOGICAL      LCTFD ,LPENAC,LPENAF,LMATRC,LGCP  ,LCTF3D,LDIRIC
      LOGICAL      CFDISL
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... CREATION DE LA SD RESULTAT'//
     &                ' CONTACT DISCRET'
      ENDIF
C
C --- INFOS SUR LA CHARGE DE CONTACT
C
      LCTFD  = CFDISL(DEFICO,'FROT_DISCRET'      )
      LPENAC = CFDISL(DEFICO,'CONT_PENA'         )
      LPENAF = CFDISL(DEFICO,'FROT_PENA'         )
      LMATRC = CFDISL(DEFICO,'MATR_CONT'         )
      LGCP   = CFDISL(DEFICO,'CONT_GCP'          )
      LCTF3D = CFDISL(DEFICO,'FROT_3D'           )
      LDIRIC = CFDISL(DEFICO,'PRE_COND_DIRICHLET')
C
C --- SD POUR APPARIEMENT
C
      ZTACF = CFMMVD('ZTACF')
C
C --- INFORMATIONS
C
      NDIMG = CFDISI(DEFICO,'NDIM' )
      NTPC  = CFDISI(DEFICO,'NTPC' )
      NNOCO = CFDISI(DEFICO,'NNOCO')
C
C --- PARAMETRES DE REACTUALISATION GEOMETRIQUE
C CLREAC(1) = TRUE  SI REACTUALISATION A FAIRE
C CLREAC(2) = TRUE  SI ATTENTE POINT FIXE CONTACT
C CLREAC(3) = TRUE  SI PREMIERE REACTUALISATION DU PAS DE TEMPS
C
      AUTOC1 = RESOCO(1:14)//'.REA1'
      AUTOC2 = RESOCO(1:14)//'.REA2'
      CALL VTCREB(AUTOC1,NUMEDD,'V','R',NEQ)
      CALL VTCREB(AUTOC2,NUMEDD,'V','R',NEQ)
      CLREAC = RESOCO(1:14)//'.REAL'
      CALL WKVECT(CLREAC,'V V L',4,JCLREA)
      ZL(JCLREA+1-1) = .FALSE.
      ZL(JCLREA+2-1) = .FALSE.
      ZL(JCLREA+3-1) = .FALSE.
      ZL(JCLREA+4-1) = .FALSE.
C
C --- INFORMATIONS POUR METHODES "PENALISATION" ET "LAGRANGIEN"
C
      TACFIN = RESOCO(1:14)//'.TACFIN'
      CALL WKVECT(TACFIN,'V V R',NTPC*ZTACF,JTACF)
C
C --- TANGENTES RESULTANTES
C
      TANGCO = RESOCO(1:14)//'.TANGCO'
      CALL WKVECT(TANGCO,'V V R',6*NTPC,JTANGO)
C
C --- SD POUR LES JEUX
C
      CALL CFCRJE(DEFICO,RESOCO)
C
C --- SD POUR LES LIAISONS LINEAIRES
C
      CALL CFCRLI(NOMA  ,NUMEDD,DEFICO,RESOCO)
C
C --- LAGRANGES DE CONTACT/FROTTEMENT
C
      MU     = RESOCO(1:14)//'.MU'
      CALL WKVECT(MU    ,'V V R',4*NTPC  ,JMU  )
C
C --- VALEUR DE LA PSEUDO-PENALISATION EN FROT. LAGR.
C
      COPO   = RESOCO(1:14)//'.COPO'
      CALL WKVECT(COPO  ,'V V R',1       ,JCOPO)
      ZR(JCOPO) = R8VIDE()
C
C --- FORCES NODALES DE CONTACT
C
      ATMU   = RESOCO(1:14)//'.ATMU'
      CALL WKVECT(ATMU  ,'V V R',NEQ     ,JATMU)
C
C --- FORCES NODALES DE FROTTEMENT
C
      IF (LCTFD) THEN
        AFMU   = RESOCO(1:14)//'.AFMU'
        CALL WKVECT(AFMU  ,'V V R',NEQ     ,JAFMU )
      ENDIF
C
C --- FORCES NODALES DE CONTACT DANS LE CAS DE LA METHODE PENALISEE
C --- ON UTILISE AFMU
C
      IF (LPENAC.AND.(.NOT.LCTFD)) THEN
        AFMU   = RESOCO(1:14)//'.AFMU'
        CALL WKVECT(AFMU  ,'V V R',NEQ,JAFMU)
      ENDIF
C
C --- INCREMENT DE SOLUTION SANS CORRECTION DU CONTACT
C
      DDEPL0 = RESOCO(1:14)//'.DEL0'
      CALL VTCREB(DDEPL0,NUMEDD,'V','R',NEQ)
C
C --- INCREMENT DE SOLUTION ITERATION DE CONTACT
C
      DDELT  = RESOCO(1:14)//'.DDEL'
      CALL VTCREB(DDELT ,NUMEDD,'V','R',NEQ)
C
C --- INCREMENT DE SOLUTION APRES CORRECTION DU CONTACT
C
      DDEPLC = RESOCO(1:14)//'.DELC'
      CALL VTCREB(DDEPLC,NUMEDD,'V','R',NEQ)
C
C --- INCREMENT DE DEPLACEMENT CUMULE DEPUIS DEBUT DU PAS DE TEMPS
C --- SANS CORRECTION DU CONTACT
C
      IF (LCTFD) THEN
        DEPL0  = RESOCO(1:14)//'.DEP0'
        CALL VTCREB(DEPL0 ,NUMEDD,'V','R',NEQ)
      ENDIF
C
C --- INCREMENT DE DEPLACEMENT CUMULE DEPUIS DEBUT DU PAS DE TEMPS
C --- AVEC CORRECTION DU CONTACT
C
      IF (LCTFD) THEN
        DEPLC  = RESOCO(1:14)//'.DEPC'
        CALL VTCREB(DEPLC ,NUMEDD,'V','R',NEQ)
      ENDIF
C
C --- CHARGEMENT CINEMATIQUE NUL
C
      CNCIN0 = RESOCO(1:14)//'.CIN0'
      CALL VTCREB(CNCIN0,NUMEDD,'V','R',NEQ)
C
C --- CHAMPS POUR GCP
C
      IF (LGCP) THEN
        SGRADM = RESOCO(1:14)//'.SGDM'
        SGRADP = RESOCO(1:14)//'.SGDP'
        DIRECT = RESOCO(1:14)//'.DIRE'
        SGRPRM = RESOCO(1:14)//'.SGPM'
        SGRPRP = RESOCO(1:14)//'.SGPP'
        MUM    = RESOCO(1:14)//'.MUM'
        SECMBR = RESOCO(1:14)//'.SECM'
        CALL VTCREB(SECMBR,NUMEDD,'V','R',NEQ)
        CALL WKVECT(SGRADM,'V V R',NTPC  ,JSGRAM)
        CALL WKVECT(SGRADP,'V V R',NTPC  ,JSGRAP)
        CALL WKVECT(SGRPRM,'V V R',NTPC  ,JSGPRM)
        CALL WKVECT(SGRPRP,'V V R',NTPC  ,JSGPRP)
        CALL WKVECT(DIRECT,'V V R',NTPC  ,JDIREC)
        CALL WKVECT(MUM   ,'V V R',NTPC  ,JMUM  )
        IF (LDIRIC) THEN
          PCRESI = RESOCO(1:14)//'.PCRS'
          CALL WKVECT(PCRESI,'V V R',NTPC  ,JPCRES)
          PCDIRE = RESOCO(1:14)//'.PCDR'
          CALL WKVECT(PCDIRE,'V V R',NTPC  ,JPCDIR)
          PCDEPL = RESOCO(1:14)//'.PCUU'
          CALL WKVECT(PCDEPL,'V V R',NEQ   ,JPCDEP)
        ENDIF
      ENDIF
C
C --- OBJET DE SAUVEGARDE DU LAGRANGE DE CONTACT EN GCP
C
      IF (LGCP) THEN
C       ETAT CONVERGE
        SVMU = RESOCO(1:14)//'.SVM0'
        CALL WKVECT(SVMU,'V V R',NNOCO ,JSVMU)
C       ETAT COURANT AVANT APPARIEMENT
        SVMU = RESOCO(1:14)//'.SVMU'
        CALL WKVECT(SVMU,'V V R',NNOCO ,JSVMU)
      ENDIF
C
C --- SD DE DONNEES POUR LES MATRICES DE CONTACT
C
      IF (.NOT.LGCP) THEN
        NBLIAI = NTPC
C
C ---   DETERMINATION DES TAILLES DES DIFFERENTES MATRICES
C
        NBENAT = 0
        NBCM1A = 0
        NBFRO1 = 0
        NBFRO2 = 0
        IF (LPENAC) THEN
C         PENALISATION DU CONTACT
C         ENAT
          NBENAT = NBLIAI
        ELSEIF ((.NOT.LCTFD) .OR. LPENAF) THEN
C         DUALISATION DU CONTACT SEULEMENT
C         CM1A
          NBCM1A = NBLIAI
        ELSE
C         DUALISATION DU CONTACT ET DU FROTTEMENT
C         CM1A
          NBCM1A = NDIMG*NBLIAI
        ENDIF
C
C       FRO1
        NBFRO1 = (NDIMG-1)*NBLIAI
C
C       FRO2
        NBFRO2 = NBLIAI

C
C ---   CREATIONS DES MATRICES
C
        IF (LPENAC) THEN
C
C ---   MATRICE STOCKEE CREUSE E_N*AT (POUR CONTACT PENALISE)
C ---   TAILLE : NBENAT*30
C
           ENAT   = RESOCO(1:14)//'.ENAT'
           CALL JECREC(ENAT,'V V R','NU','DISPERSE','CONSTANT',NBENAT)
           CALL JEECRA(ENAT,'LONMAX',30,K8BID)
           DO 30 II = 1, NBENAT
             CALL JECROC(JEXNUM(ENAT,II))
 30        CONTINUE
        ELSE
C
C ---   MATRICE PRINCIPALE C-1*AT (POUR CONTACT DUALISE)
C ---   TAILLE : NBCM1A*NEQ
C
          CM1A   = RESOCO(1:14)//'.CM1A'
          CALL JECREC(CM1A,'V V R','NU','DISPERSE','CONSTANT',NBCM1A)
          CALL JEECRA(CM1A,'LONMAX',NEQ,K8BID)
          DO 40 II = 1, NBCM1A
            CALL JECROC(JEXNUM(CM1A,II))
 40       CONTINUE
C
        ENDIF
C
C ---   MATRICES STOCKEES CREUSES FRO1 ET FRO2
C ---   (POUR FROTTEMENT UNIQUEMENT)
C ---   TAILLE : NBFRO1*30 ET NBFRO2*30
C
        IF (LCTF3D) THEN
          FRO1 = RESOCO(1:14)//'.FRO1'
          FRO2 = RESOCO(1:14)//'.FRO2'
          CALL JECREC(FRO1,'V V R','NU','DISPERSE','CONSTANT',NBFRO1)
          CALL JECREC(FRO2,'V V R','NU','DISPERSE','CONSTANT',NBFRO2)
          CALL JEECRA(FRO1,'LONMAX',30,K8BID)
          CALL JEECRA(FRO2,'LONMAX',30,K8BID)
          DO 41 II = 1, NBFRO1
            CALL JECROC (JEXNUM(FRO1,II))
 41       CONTINUE
          DO 42 II = 1, NBFRO2
            CALL JECROC (JEXNUM(FRO2,II))
 42       CONTINUE
        ENDIF
      ENDIF
C
C --- MATRICE DE CONTACT ACM1AT
C
      IF (LMATRC) THEN
        CALL CFCRMA(NBCM1A,NOMA  ,RESOCO)
      ENDIF
C
      CALL JEDEMA()
      END
