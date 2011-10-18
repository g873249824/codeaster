      SUBROUTINE NMIBLE(NIVEAU,
     &                  NUMINS,MODELE,NOMA  ,DEFICO,RESOCO,
     &                  FONACT,NUMEDD,SDIMPR,SDSTAT,SDTIME,
     &                  SDDYNA,SDDISC,ITERAT,VALINC,SOLALG,
     &                  LNOPRE)
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/10/2011   AUTEUR ABBAS M.ABBAS 
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
C
      IMPLICIT NONE
      INTEGER      NIVEAU,NUMINS,ITERAT
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 SDIMPR,SDSTAT,SDTIME
      CHARACTER*24 MODELE,NUMEDD
      CHARACTER*19 SOLALG(*),VALINC(*)
      CHARACTER*19 SDDYNA,SDDISC
      INTEGER      FONACT(*)
      LOGICAL      LNOPRE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C ROUTINE D'AIGUILLAGE DES ITERATIONS SE SITUANT ENTRE LES PAS DE TEMPS
C ET L'EQUILIBRE
C
C ----------------------------------------------------------------------
C
C POUR LE MOMENT, SERT:
C  - A LA METHODE CONTINUE DE CONTACT (Y COMPRIS XFEM)
C  - AUX METHODES DISCRETES AVEC BOUCLE GEOMETRIE
C
C
C
C LES ITERATIONS ONT LIEU ENTRE CETTE ROUTINE ET SA COUSINE
C (NMTBLE) QUI COMMUNIQUENT PAR LA VARIABLE NIVEAU
C
C IN  NIVEAU : INDICATEUR D'UTILISATION DE LA BOUCLE
C                 -1     ON N'UTILISE PAS CETTE BOUCLE
C                  4     BOUCLE CONTACT
C                         INITIALISATION
C                  3     BOUCLE CONTACT
C                         BOUCLE GEOMETRIE
C                  2     BOUCLE CONTACT METHODE CONTINUE
C                         BOUCLE SEUILS DE FROTTEMENT
C                  1     BOUCLE CONTACT METHODE CONTINUE
C                         BOUCLE CONTRAINTES ACTIVES
C IN  MODELE : NOM DU MODELE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NUMINS : NUMERO D'INSTANT
C IN  ITERAT : NUMERO D'ITERATION DE NEWTON
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  SDDYNA : SD DEDIEE A LA DYNAMIQUE
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SDIMPR : SD AFFICHAGE
C IN  SDTIME : SD TIMER
C IN  SDSTAT : SD STATISTIQUES
C IN  NUMEDD : NOM DU NUME_DDL
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  LNOPRE : .TRUE. SI ON DOIT SAUTER LA PREDICTION
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
      INTEGER      MMITGO,MMITCA,MMITFR
      LOGICAL      ISFONC,LBOUCF,LBOUCG,LBOUCC,LAPINI,LELTC
      LOGICAL      CFDISL,LTFCM,LXFCM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECANONLINE',IFM,NIV)
C
C --- INITIALISATIONS
C
      LNOPRE = .FALSE.
      LAPINI = .FALSE.
C
      IF (NIVEAU.LT.0) THEN
        GOTO 9999
      ENDIF
C
      LXFCM  = CFDISL(DEFICO,'FORMUL_XFEM')
C
C --- INFOS SUR LES BOUCLES
C
      LBOUCF = ISFONC(FONACT,'BOUCLE_EXT_FROT')
      LBOUCG = ISFONC(FONACT,'BOUCLE_EXT_GEOM')
      LBOUCC = ISFONC(FONACT,'BOUCLE_EXT_CONT')
      LELTC  = ISFONC(FONACT,'ELT_CONTACT')
C
C --- APPARIEMENT INITIAL
C
      IF ((NUMINS.EQ.1).AND.(ITERAT.EQ.0)) THEN
        LAPINI = .TRUE.
        IF (LXFCM) THEN
          LTFCM  = CFDISL(DEFICO,'CONT_XFEM_GG')
          IF (.NOT.LTFCM) LAPINI = .FALSE.
        ENDIF
      ENDIF
C
C --- BRANCHEMENT
C
      GOTO (101,102,103,104) NIVEAU
C
C --- NIVEAU: 4   INITIALISATION
C
 104  CONTINUE

      NIVEAU = 4
      CALL NMCTCI(DEFICO,RESOCO,SDDYNA,VALINC)
      CALL MMBOUC(RESOCO,'GEOM','INIT',MMITGO)
C
C --- NIVEAU: 3   BOUCLE GEOMETRIE
C
 103  CONTINUE
C
C --- NOUVELLE ITERATION DE GEOMETRIE
C
      IF (LBOUCG.OR.LAPINI) THEN
        NIVEAU = 3
        CALL MMBOUC(RESOCO,'GEOM','INCR',MMITGO)
        CALL NMIMPR(SDIMPR,'IMPR','BCL_GEOME',' ',0.D0,MMITGO)
        CALL NMTIME(SDTIME,'INI','CONT_GEOM')
        CALL NMTIME(SDTIME,'RUN','CONT_GEOM')
        CALL NMCTCG(MODELE,NOMA  ,DEFICO,RESOCO,SDDISC,
     &              NUMEDD,LNOPRE)
        CALL NMTIME(SDTIME,'END','CONT_GEOM')
        CALL NMRINC(SDSTAT,'CONT_GEOM')
      ENDIF
C
      CALL MMBOUC(RESOCO,'FROT','INIT',MMITFR)
C
C --- NIVEAU: 2   BOUCLE SEUILS DE FROTTEMENT
C
 102  CONTINUE
C
C --- NOUVELLE ITERATION DE FROTTEMENT
C
      IF (LBOUCF) THEN
        NIVEAU = 2
        CALL MMBOUC(RESOCO,'FROT','INCR',MMITFR)
        CALL NMIMPR(SDIMPR,'IMPR','BCL_SEUIL',' ',0.D0,MMITFR)
      ENDIF
C
      CALL MMBOUC(RESOCO,'CONT','INIT',MMITCA)
C
C --- NIVEAU: 1   BOUCLE CONTRAINTES ACTIVES
C
 101  CONTINUE
C
C --- NOUVELLE ITERATION DE CONTACT
C
      IF (LBOUCC) THEN
        NIVEAU = 1
        CALL MMBOUC(RESOCO,'CONT','INCR',MMITCA)
        CALL NMIMPR(SDIMPR,'IMPR','BCL_CTACT',' ',0.D0,MMITCA)
      ENDIF
C
 9999 CONTINUE
C
C --- CREATION OBJETS POUR CONTACT CONTINU
C
      IF (LELTC) THEN
        CALL NMNBLE(NUMINS,MODELE,NOMA  ,NUMEDD,SDSTAT,
     &              SDTIME,SDDYNA,SDDISC,DEFICO,RESOCO,
     &              VALINC,SOLALG)
      ENDIF
C
      CALL JEDEMA()
      END
