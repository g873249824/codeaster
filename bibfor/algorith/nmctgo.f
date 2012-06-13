      SUBROUTINE NMCTGO(NOMA  ,SDIMPR,SDERRO,DEFICO,RESOCO,
     &                  VALINC,MMCVGO)
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
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 SDIMPR,SDERRO
      CHARACTER*19 VALINC(*)
      LOGICAL      MMCVGO
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGO - BOUCLE CONTACT)
C
C SEUIL DE GEOMETRIE
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  SDIMPR : SD AFFICHAGE
C IN  SDERRO : GESTION DES ERREURS
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C OUT MMCVCA : INDICATEUR DE CONVERGENCE POUR BOUCLE DE
C              GEOMETRIE
C               .TRUE. SI LA BOUCLE A CONVERGE
C
C
C
C
      INTEGER      IFM,NIV
      LOGICAL      CFDISL,LCTCC,LCTCD,LXFCM
      LOGICAL      LSANS,LMANU,LAUTO
      INTEGER      CFDISI,NBREAG,MAXGEO
      INTEGER      MMITGO
      CHARACTER*19 DEPPLU,DEPGEO,DEPMOI
      CHARACTER*16 CVGNOE
      REAL*8       CVGVAL,EPSGEO
      CHARACTER*24 CLREAC
      INTEGER      JCLREA
      LOGICAL      CTCGEO,LERROG
      REAL*8       CFDISR,R8BID,R8VIDE
      INTEGER      IBID
      CHARACTER*16 K16BLA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECANONLINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> MISE A JOUR DU SEUIL DE GEOMETRIE'
      ENDIF
C
C --- INITIALISATIONS
C
      K16BLA = ' '
      CVGNOE = ' '
      CVGVAL = R8VIDE()
      MMCVGO = .FALSE.
      DEPGEO = RESOCO(1:14)//'.DEPG'
      LERROG = .FALSE.
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C
      CALL NMCHEX(VALINC,'VALINC','DEPMOI',DEPMOI)
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU)
C
C --- INFOS BOUCLE GEOMETRIQUE
C
      CALL MMBOUC(RESOCO,'GEOM','READ',MMITGO)
      MAXGEO  = CFDISI(DEFICO,'ITER_GEOM_MAXI')
      NBREAG  = CFDISI(DEFICO,'NB_ITER_GEOM'  )
      EPSGEO  = CFDISR(DEFICO,'RESI_GEOM'     )
C
C --- TYPE DE CONTACT
C
      LCTCC  = CFDISL(DEFICO,'FORMUL_CONTINUE')
      LCTCD  = CFDISL(DEFICO,'FORMUL_DISCRETE')
      LXFCM  = CFDISL(DEFICO,'FORMUL_XFEM')
C
      LMANU  = CFDISL(DEFICO,'REAC_GEOM_MANU')
      LSANS  = CFDISL(DEFICO,'REAC_GEOM_SANS')
      LAUTO  = CFDISL(DEFICO,'REAC_GEOM_AUTO')
C
C --- MISE A JOUR DES SEUILS
C
      IF (LCTCC.OR.LXFCM) THEN
        CALL MMMCRI('GEOM',NOMA  ,DEPMOI,DEPGEO,DEPPLU,
     &              RESOCO,EPSGEO,CVGNOE,CVGVAL,MMCVGO)
C
C ----- CAS MANUEL
C
        IF (LMANU) THEN
          IF (MMITGO.EQ.NBREAG) THEN
            IF ((.NOT.MMCVGO).AND.(NBREAG.GT.1)) THEN
              CALL U2MESS('A','CONTACT3_96')
            ENDIF
            MMCVGO = .TRUE.
          ELSE
            MMCVGO = .FALSE.
          ENDIF
        ENDIF
C
C ----- CAS SANS
C
        IF (LSANS) THEN
          MMCVGO = .TRUE.
        ENDIF
C
C ----- CAS AUTO
C
        IF (LAUTO) THEN
          IF ((.NOT.MMCVGO).AND.(MMITGO.EQ.MAXGEO)) THEN
            CALL CFVERL(DEFICO,RESOCO)
            LERROG = .TRUE.
          ENDIF
        ENDIF
C
        IF (.NOT.MMCVGO) THEN
          CALL COPISD('CHAMP_GD','V',DEPPLU,DEPGEO)
        ENDIF
      ELSEIF (LCTCD) THEN
C
        CLREAC = RESOCO(1:14)//'.REAL'
        CALL JEVEUO(CLREAC,'L',JCLREA)
C
C ----- CTCGEO : TRUE. SI BOUCLE GEOMETRIQUE CONVERGEE
C
        CTCGEO = ZL(JCLREA+1-1)
        LERROG = ZL(JCLREA+4-1)
C
C ----- IMPRESSIONS
C
        IF (CTCGEO) THEN
          MMCVGO = .FALSE.
        ELSE
          MMCVGO = .TRUE.
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- SAUVEGARDE DES EVENEMENTS
C
      CALL NMCREL(SDERRO,'ERRE_CTCG',LERROG)
      CALL NMCREL(SDERRO,'DIVE_FIXG',.NOT.MMCVGO)
C
C --- VALEUR ET ENDROIT OU SE REALISE L'EVALUATION DE LA BOUCLE
C
      IF (LCTCC.OR.LXFCM) THEN
        CALL IMPSDR(SDIMPR,'BOUC_NOEU',CVGNOE,R8BID ,IBID)
        CALL IMPSDR(SDIMPR,'BOUC_VALE',K16BLA,CVGVAL,IBID)
      ENDIF
C
      CALL JEDEMA()
      END
