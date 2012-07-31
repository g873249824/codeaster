      SUBROUTINE NMNOLI(RESULT,SDIMPR,SDDISC,SDERRO,CARCRI,
     &                  SDCRIT,FONACT,SDDYNA,SDPOST,MODELE,
     &                  MATE  ,CARELE,LISCH2,SDPILO,SDTIME,
     &                  SDENER,SDIETO,SDCRIQ)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/07/2012   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*19 SDDISC,SDCRIT,LISCH2,SDDYNA,SDPOST,SDPILO,SDENER
      CHARACTER*24 SDERRO,CARCRI,SDIMPR
      CHARACTER*24 MODELE,MATE,CARELE
      CHARACTER*24 SDIETO,SDTIME,SDCRIQ
      CHARACTER*8  RESULT
      INTEGER      FONACT(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (SD EVOL_NOLI)
C
C PREPARATION DE LA SD EVOL_NOLI
C
C ----------------------------------------------------------------------
C
C
C IN  RESULT : NOM DE LA SD RESULTAT
C IN  NOMA   : NOM DU MAILLAGE
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  SDIMPR : SD AFFICHAGE
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_STAB ET MODE_VIBR)
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDIETO : SD GESTION IN ET OUT
C IN  SDCRIT : INFORMATIONS RELATIVES A LA CONVERGENCE
C IN  SDPILO : SD PILOTAGE
C IN  SDTIME : SD TIMER
C IN  SDERRO : SD ERREUR
C IN  SDENER : SD ENERGIE
C IN  SDCRIQ : SD CRITERE QUALITE
C IN  MODELE : NOM DU MODELE
C IN  MATE   : CHAMP DE MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  LISCH2 : NOM DE LA SD INFO CHARGE POUR STOCKAGE DANS LA SD
C              RESULTAT
C
C ----------------------------------------------------------------------
C
      CHARACTER*24 ARCINF
      INTEGER      JARINF
      CHARACTER*19 SDARCH
      INTEGER      NUMARC,NUMINS
      INTEGER      IFM,NIV
      CHARACTER*24 NOOBJ
      LOGICAL      ISFONC,LREUSE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> PREPARATION DE LA SD EVOL_NOLI'
      ENDIF
C
C --- FONCTIONNALITES ACTIVEES
C
      LREUSE = ISFONC(FONACT,'REUSE')
C
C --- INSTANT INITIAL
C
      NUMINS = 0
C
C --- DETERMINATION DU NOM DE LA SD INFO_CHARGE STOCKEE
C --- DANS LA SD RESULTAT
C
      NOOBJ  = '12345678'//'.1234'//'.EXCIT'
      CALL GNOMSD(NOOBJ,10,13)
      LISCH2 = NOOBJ(1:19)
C
C --- ACCES SD ARCHIVAGE
C
      SDARCH = SDDISC(1:14)//'.ARCH'
      ARCINF = SDARCH(1:19)//'.AINF'
C
C --- NUMERO ARCHIVAGE COURANT
C
      CALL JEVEUO(ARCINF,'L',JARINF)
      NUMARC = ZI(JARINF+1-1)
C
C --- CREATION DE LA SD EVOL_NOLI OU NETTOYAGE DES ANCIENS NUMEROS
C
      IF (LREUSE) THEN
        CALL ASSERT(NUMARC.NE.0)
        CALL RSRUSD(RESULT,NUMARC)
      ELSE
        CALL ASSERT(NUMARC.EQ.0)
        CALL RSCRSD('G',RESULT,'EVOL_NOLI',100)
      ENDIF
C
C --- ARCHIVAGE ETAT INITIAL
C
      IF (.NOT.LREUSE) THEN
        CALL NMIMPR(SDIMPR,'IMPR','ARCH_INIT',' ',0.D0,0)
        CALL NMARCH(RESULT,NUMINS,MODELE,MATE  ,CARELE,
     &              FONACT,CARCRI,SDIMPR,SDDISC,SDPOST,
     &              SDCRIT,SDTIME,SDERRO,SDDYNA,SDPILO,
     &              SDENER,SDIETO,SDCRIQ,LISCH2)
      ENDIF
C
C --- AU PROCHAIN ARCHIVAGE, SAUVEGARDE DES CHAMPS AU TEMPS T+
C
      CALL NMETPL(SDIETO)
C
      CALL JEDEMA()

      END
