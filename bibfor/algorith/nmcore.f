      SUBROUTINE NMCORE(SDCRIT,SDERRO,SDCONV,DEFICO,NUMINS,
     &                  ITERAT,FONACT,RELITE,ETA   ,PARCRI,
     &                  VRESI ,VRELA ,VMAXI ,VCHAR ,VREFE ,
     &                  VCOMP ,VFROT ,VGEOM )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/04/2013   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER      FONACT(*)
      REAL*8       PARCRI(*)
      INTEGER      NUMINS,ITERAT,RELITE
      CHARACTER*24 SDERRO,SDCONV,DEFICO
      CHARACTER*19 SDCRIT
      REAL*8       ETA
      REAL*8       VRESI,VRELA,VMAXI,VCHAR,VREFE,VCOMP,VFROT,VGEOM
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - CONVERGENCE)
C
C VERIFICATION DES CRITERES D'ARRET SUR RESIDUS
C
C ----------------------------------------------------------------------
C
C
C IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
C IN  SDCONV : SD GESTION DE LA CONVERGENCE
C IN  SDERRO : GESTION DES ERREURS
C IN  SDCRIT : SYNTHESE DES RESULTATS DE CONVERGENCE POUR ARCHIVAGE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  NUMINS : NUMERO DU PAS DE TEMPS
C IN  ITERAT : NUMERO D'ITERATION
C IN  ETA    : COEFFICIENT DE PILOTAGE
C IN  RELITE : NOMBRE D'ITERATIONS DE RECHERCHE LINEAIRE
C IN  PARCRI : CRITERES DE CONVERGENCE (VOIR NMDOCN)
C IN  VRESI  : RESIDU D'EQUILIBRE
C IN  VRELA  : RESI_GLOB_RELA MAXI
C IN  VMAXI  : RESI_GLOB_MAXI MAXI
C IN  VCOMP  : RESI_COMP_RELA MAXI
C IN  VCHAR  : CHARGEMENT EXTERIEUR MAXI
C IN  VREFE  : RESI_GLOB_REFE MAXI
C IN  VFROT  : RESI_FROT MAXI
C IN  VGEOM  : RESI_GEOM MAXI
C
C ----------------------------------------------------------------------
C
      INTEGER      NRESI
      PARAMETER    (NRESI=6)
C
      CHARACTER*24 CNVACT
      INTEGER      JCNVAC
      CHARACTER*24 CRITCR
      INTEGER      JCRR
      REAL*8       VALR(2),DETECT,R8VIDE
      REAL*8       CHMINI
      INTEGER      IRESI
      REAL*8       CFDISR
      LOGICAL      CONVOK(NRESI),CONVNO(NRESI)
      REAL*8       RESI(NRESI),RESID(NRESI)
      LOGICAL      LRELA,LMAXI,LREFE,LCOMP,LFROT,LGEOM
      LOGICAL      CVRESI,MAXREL,MAXNOD
      LOGICAL      ISFONC,LCONT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES SD CONVERGENCE
C
      CNVACT = SDCONV(1:19)//'.ACTI'
      CALL JEVEUO(CNVACT,'E',JCNVAC)
      CRITCR = SDCRIT(1:19)//'.CRTR'
      CALL JEVEUO(CRITCR,'E',JCRR  )
C
C --- INITIALISATIONS
C
      LCONT  = ISFONC(FONACT,'CONTACT')
      CVRESI = .TRUE.
      MAXREL = .FALSE.
      MAXNOD = .FALSE.
      CHMINI = ZR(JCRR+6-1)
C
C --- RESIDUS A TESTER POUR LE CRITERE D'ARRET
C
      LRELA = (PARCRI(2) .NE. R8VIDE())
      LMAXI = (PARCRI(3) .NE. R8VIDE())
      LREFE = (PARCRI(6) .NE. R8VIDE())
      LCOMP = (PARCRI(7) .NE. R8VIDE())
      LFROT = ZL(JCNVAC-1+5)
      LGEOM = ZL(JCNVAC-1+6)
C
C --- VALEURS CALCULEES ET REFERENCES
C
      RESI(1)  = VRELA
      RESI(2)  = VMAXI
      RESI(3)  = VREFE
      RESI(4)  = VCOMP
      RESI(5)  = VFROT
      RESI(6)  = VGEOM
      RESID(1) = PARCRI(2)
      RESID(2) = PARCRI(3)
      RESID(3) = PARCRI(6)
      RESID(4) = PARCRI(7)
      IF (LCONT) RESID(5) = CFDISR(DEFICO,'RESI_FROT')
      IF (LCONT) RESID(6) = CFDISR(DEFICO,'RESI_GEOM')
      CALL NMCREL(SDERRO,'DIVE_RELA',.FALSE.)
      CALL NMCREL(SDERRO,'DIVE_MAXI',.FALSE.)
      CALL NMCREL(SDERRO,'DIVE_REFE',.FALSE.)
      CALL NMCREL(SDERRO,'DIVE_COMP',.FALSE.)
      CALL NMCREL(SDERRO,'DIVE_FROT',.FALSE.)
      CALL NMCREL(SDERRO,'DIVE_GEOM',.FALSE.)
C
C --- SI CRITERE RESI_COMP_RELA ET PREMIER INSTANT
C --- -> ON UTILISE RESI_GLOB_RELA
C
      IF (LCOMP) THEN
        IF (NUMINS.EQ.1) THEN
          LRELA     = .TRUE.
          LCOMP     = .FALSE.
          MAXNOD    = .TRUE.
          RESID(1)  = RESID(4)
          RESID(2)  = RESID(4)
          CALL U2MESS('I','MECANONLINE2_96')
        ENDIF
      ENDIF
C
C --- SI CRITERE RESI_GLOB_RELA ET CHARGEMENT NUL
C --- -> ON UTILISE RESI_GLOB_MAXI
C
      IF (LRELA) THEN
        DETECT  = 1.D-6 * CHMINI
        IF (VCHAR .LE. DETECT) THEN
          IF (NUMINS.GT.1) THEN
            LRELA    = .FALSE.
            LMAXI    = .TRUE.
            MAXREL   = .TRUE.
            RESID(2) = ZR(JCRR+7-1)
            VALR(1)  = DETECT
            VALR(2)  = RESID(2)
            CALL U2MESR('I','MECANONLINE2_98',2,VALR  )
          ENDIF
          IF ((PARCRI(7) .NE. R8VIDE()).AND.NUMINS.EQ.1) THEN
            LRELA    = .FALSE.
            LMAXI    = .TRUE.
            MAXREL   = .TRUE.
            VALR(1)  = DETECT
            VALR(2)  = RESID(2)
            CALL U2MESR('I','MECANONLINE2_98',2,VALR  )
          ENDIF
        ENDIF
      ENDIF
C
C --- NOUVEAUX CRITERES APRES BASCULEMENT(S) EVENTUEL(S)
C
      ZL(JCNVAC-1+1) = LRELA
      ZL(JCNVAC-1+2) = LMAXI
      ZL(JCNVAC-1+3) = LREFE
      ZL(JCNVAC-1+4) = LCOMP
      ZL(JCNVAC-1+5) = LFROT
      ZL(JCNVAC-1+6) = LGEOM
C
C --- CRITERES D'ARRET
C
      DO 10 IRESI = 1,NRESI
        IF (ZL(JCNVAC+IRESI-1)) THEN
          CALL NMCORU(RESI(IRESI),RESID(IRESI),CONVOK(IRESI))
        ELSE
          CONVOK(IRESI) = .TRUE.
        ENDIF
  10  CONTINUE
C
C --- ENREGISTREMENT DES EVENEMENTS
C
      CONVNO(1) = .NOT.CONVOK(1)
      CONVNO(2) = .NOT.CONVOK(2)
      CONVNO(3) = .NOT.CONVOK(3)
      CONVNO(4) = .NOT.CONVOK(4)
      CONVNO(5) = .NOT.CONVOK(5)
      CONVNO(6) = .NOT.CONVOK(6)
      IF (LRELA) CALL NMCREL(SDERRO,'DIVE_RELA',CONVNO(1))
      IF (LMAXI) CALL NMCREL(SDERRO,'DIVE_MAXI',CONVNO(2))
      IF (LREFE) CALL NMCREL(SDERRO,'DIVE_REFE',CONVNO(3))
      IF (LCOMP) CALL NMCREL(SDERRO,'DIVE_COMP',CONVNO(4))
      IF (LFROT) CALL NMCREL(SDERRO,'DIVE_FROT',CONVNO(5))
      IF (LGEOM) CALL NMCREL(SDERRO,'DIVE_GEOM',CONVNO(6))
      CALL NMCREL(SDERRO,'RESI_MAXR',MAXREL)
      CALL NMCREL(SDERRO,'RESI_MAXN',MAXNOD)
C
C --- EVALUATION DE LA CONVERGENCE DU RESIDU
C
      CALL NMEVCV(SDERRO,FONACT,'RESI')
      CALL NMLECV(SDERRO,'RESI',CVRESI)
C
C --- SAUVEGARDES INFOS CONVERGENCE
C
      ZR(JCRR+1-1) = ITERAT+1
      ZR(JCRR+2-1) = RELITE
      ZR(JCRR+3-1) = VRELA
      ZR(JCRR+4-1) = VMAXI
      ZR(JCRR+5-1) = ETA
      IF ((NUMINS.EQ.1) .AND. (ITERAT.EQ.0)) THEN
        ZR(JCRR+6-1) = VCHAR
      ELSE
        IF (CVRESI.AND.(.NOT.MAXREL)) THEN
          ZR(JCRR+6-1) = MIN(VCHAR, ZR(JCRR+6-1))
        ENDIF
      ENDIF
      IF (CVRESI) THEN
        ZR(JCRR+7-1) = VRESI
      ENDIF
      ZR(JCRR+8-1) = VREFE
      ZR(JCRR+9-1) = VCOMP
C
      CALL JEDEMA()
      END
