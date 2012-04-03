      SUBROUTINE NMTBLE(MODELE,NOMA  ,MATE  ,DEFICO,RESOCO,
     &                  NIVEAU,FONACT,SDIMPR,SDSTAT,SDTIME,
     &                  SDDYNA,SDERRO,VALINC,SOLALG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/04/2012   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT NONE
      INTEGER      NIVEAU
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 SDSTAT,SDIMPR,SDTIME,SDERRO
      CHARACTER*24 MODELE,MATE
      CHARACTER*19 SDDYNA,VALINC(*),SOLALG(*)
      INTEGER      FONACT(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C GESTION DEBUT DE BOUCLE POINTS FIXES
C
C ----------------------------------------------------------------------
C
C
C LES ITERATIONS ONT LIEU ENTRE CETTE ROUTINE ET SA COUSINE
C (NMIBLE) QUI COMMUNIQUENT PAR LA VARIABLE NIVEAU
C
C I/O NIVEAU : INDICATEUR D'UTILISATION DE LA BOUCLE DE POINT FIXE
C                  0     ON N'UTILISE PAS CETTE BOUCLE
C                  3     BOUCLE GEOMETRIE
C                  2     BOUCLE SEUILS DE FROTTEMENT
C                  1     BOUCLE CONTRAINTES ACTIVES
C IN  MODELE : NOM DU MODELE
C IN  NOMA   : NOM DU MAILLAGE
C IN  MATE   : SD MATERIAU
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  SDIMPR : SD AFFICHAGE
C IN  SDTIME : SD TIMER
C IN  SDSTAT : SD STATISTIQUES
C IN  SDDYNA : SD POUR DYNAMIQUE
C IN  SDERRO : SD ERREUR
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
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
      LOGICAL      MMCVCA,MMCVFR,MMCVGO
      LOGICAL      ISFONC,LBOUCF,LBOUCG,LBOUCC
      INTEGER      MMITGO,MMITFR,MMITCO
      CHARACTER*4  ETNEWT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- NEWTON A NECESSAIREMENT CONVERGE
C
      CALL NMLEEB(SDERRO,'NEWT',ETNEWT)
      IF ((NIVEAU.EQ.0).OR.(ETNEWT.NE.'CONV')) THEN
        GOTO 9999
      ENDIF
C
C --- INFOS SUR LES BOUCLES
C
      LBOUCF = ISFONC(FONACT,'BOUCLE_EXT_FROT')
      LBOUCG = ISFONC(FONACT,'BOUCLE_EXT_GEOM')
      LBOUCC = ISFONC(FONACT,'BOUCLE_EXT_CONT')
C
C --- INITIALISATIONS
C
      MMCVCA = .FALSE.
      MMCVFR = .FALSE.
      MMCVGO = .FALSE.
C
      GO TO (101,102,103) NIVEAU
C
C --- NIVEAU: 1   BOUCLE CONTRAINTES ACTIVES
C
 101  CONTINUE
C
C --- EVALUATION STATUTS DU CONTACT
C
      IF (LBOUCC) THEN
        NIVEAU = 1
        CALL NMTIME(SDTIME,'INI','CTCC_CONT')
        CALL NMTIME(SDTIME,'RUN','CTCC_CONT')
        CALL NMCTCC(NOMA  ,MODELE,MATE  ,SDDYNA,SDIMPR,
     &              SDERRO,DEFICO,RESOCO,VALINC,SOLALG,
     &              MMCVCA)
        CALL NMTIME(SDTIME,'END','CTCC_CONT')
        CALL NMRINC(SDSTAT,'CTCC_CONT')
C
C ----- ON CONTINUE LA BOUCLE
C
        IF (.NOT.MMCVCA) THEN
          CALL MMBOUC(RESOCO,'CONT','INCR',MMITCO)
          NIVEAU = 1
          GOTO 999
        ENDIF
      ENDIF
C
C --- NIVEAU: 2   BOUCLE SEUILS DE FROTTEMENT
C
 102  CONTINUE
C
C --- CALCUL SEUILS DE FROTTEMENT
C
      IF (LBOUCF) THEN
        NIVEAU = 2
        CALL NMTIME(SDTIME,'INI','CTCC_FROT')
        CALL NMTIME(SDTIME,'RUN','CTCC_FROT')
        CALL NMCTCF(NOMA  ,MODELE,SDIMPR,SDERRO,DEFICO,
     &              RESOCO,VALINC,MMCVFR)
        CALL NMTIME(SDTIME,'END','CTCC_FROT')
        CALL NMRINC(SDSTAT,'CTCC_FROT')
C
C ----- ON CONTINUE LA BOUCLE
C
        IF (.NOT.MMCVFR) THEN
          CALL MMBOUC(RESOCO,'FROT','INCR',MMITFR)
          NIVEAU = 2
          GOTO 999
        ENDIF
      ENDIF
C
C --- NIVEAU: 3   BOUCLE GEOMETRIE
C
 103  CONTINUE
C
C --- CALCUL SEUILS DE GEOMETRIE
C
      IF (LBOUCG) THEN
        NIVEAU = 3
        CALL NMCTGO(NOMA  ,SDIMPR,SDERRO,DEFICO,RESOCO,
     &              VALINC,MMCVGO)
C
C ----- ON CONTINUE LA BOUCLE
C
        IF (.NOT.MMCVGO) THEN
          CALL MMBOUC(RESOCO,'GEOM','INCR',MMITGO)
          NIVEAU = 3
          GOTO 999
        ENDIF
      ENDIF
C
 999  CONTINUE
C
C --- REMISE A ZERO DES COMPTEURS DE CYCLE
C
      IF (MMCVCA.OR.MMCVFR.OR.MMCVGO) CALL MMCYCZ(DEFICO,RESOCO)
C
 9999 CONTINUE
C
C --- ETAT DE LA CONVERGENCE POINT FIXE
C
      CALL NMEVCV(SDERRO,FONACT,'FIXE')
C
      CALL JEDEMA()
      END
