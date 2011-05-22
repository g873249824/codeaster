      SUBROUTINE DIDECO(SDDISC,NUMINS,ITERAT,IECHEC,RETOUR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/05/2011   AUTEUR ABBAS M.ABBAS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT       NONE
      INTEGER        NUMINS,RETOUR,ITERAT,IECHEC
      CHARACTER*19   SDDISC
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C DECOUPAGE DU PAS DE TEMPS
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC   : SD DISCRETISATION
C IN  NUMINS   : NUMERO D'INSTANTS
C IN  ITERAT   : NUMERO D'ITERATION DE NEWTON
C IN  IECHEC   : NUMERO DE LA CAUSE DE L'ECHEC
C OUT RETOUR   : CODE RETOUR
C     0 - SUBDIVISION DEMANDEE - OK
C     1 - SUBDIVISION NON DEMANDEE
C     2 - SUBDIVISION DEMANDEE - NOOK
C     3 - ON AUTORISE DES ITERATIONS EN PLUS
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      NBNIVO,IBID,DININS,NBRPAS,NBITER
      REAL*8       PASMIN,RATIO,INSTAM,INSTAP,DELTAT,DIINST,R8BID
      CHARACTER*16 METHOD
      INTEGER      LENIVO
      REAL*8       VALRM(4)
      INTEGER      VALIM(2)
      CHARACTER*40 VALKM(1)
      CHARACTER*8  K8BID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CALL ASSERT (IECHEC.GT.0 )
      RETOUR = 0
C
C --- NOM DE LA METHODE DE SUBDIVISION (CF. NMCRSU)
C
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IECHEC,'SUBD_METH',
     &            R8BID ,IBID  ,METHOD)
C
      CALL ASSERT(METHOD.EQ.'AUCUNE'.OR.
     &            METHOD.EQ.'UNIFORME'.OR.
     &            METHOD.EQ.'EXTRAP_IGNO'.OR.
     &            METHOD.EQ.'EXTRAP_FIN')
C
C --- AUCUNE SUBDIVISION AUTORISEE : ON SORT
C
      IF (METHOD .EQ. 'AUCUNE' ) THEN
        RETOUR = 1
        GOTO 9999
      ENDIF
C
C --- LECTURE DES INFOS SUR LE PAS DE TEMPS
C
      INSTAM = DIINST(SDDISC,NUMINS-1)
      INSTAP = DIINST(SDDISC,NUMINS)
      DELTAT = INSTAP-INSTAM
C
C --- NOMBRE MAXIMUM D'ITERATION
C
      CALL NMLERR(SDDISC,'L','NBITER',ITERAT,R8BID ,NBITER)
C
C --- ARGUMENTS DE LA SUBDIVISION
C
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IECHEC,'SUBD_PAS',
     &            R8BID ,NBRPAS,K8BID )
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IECHEC,'SUBD_PAS_MINI',
     &            PASMIN,IBID  ,K8BID )
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IECHEC,'SUBD_COEF_PAS_1',
     &            RATIO ,IBID  ,K8BID )
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IECHEC,'SUBD_NIVEAU',
     &            R8BID ,NBNIVO,K8BID )
C
C --- NIVEAU DE REDECOUPAGE ACTUEL
C
      LENIVO = DININS(SDDISC,NUMINS)
C
C --- NIVEAU MAXIMUM DE REDECOUPAGE ATTEINT
C
      IF (( NBNIVO .GT. 1 ).AND.(LENIVO.GT.NBNIVO) ) THEN
        VALIM(1) = LENIVO
        VALIM(2) = NBNIVO
        CALL U2MESI('I','SUBDIVISE_12',2,VALIM)
        RETOUR = 2
        GOTO 9999
      ENDIF
C
C --- METHODE EXTRAPOLE
C     DEPASSE T'ON LE NOMBRE MAXIMAL D'ITERATION, QUI VAUT
C     MAX(ITER_GLOB_MAXI,ITER_GLOB_ELAS) + NB INCR AUTORISES EN PLUS
C !!! ON CHANGE DE METHODE SI C'EST LE CAS, ON BASCULE EN "UNIFORME"
      IF (METHOD(1:7).EQ.'EXTRAP_') THEN
         IF (ITERAT .GE. NBITER) THEN
            METHOD = 'UNIFORME'
            RATIO  = 24.0D0/((3.0D0*NBRPAS+1.D0)**2 - 1.D0)
            VALIM(1) = NBRPAS
            VALIM(2) = LENIVO
            VALRM(1) = RATIO
            VALRM(2) = DELTAT
            CALL U2MESG('I','SUBDIVISE_10',0,VALKM,2,VALIM,2,VALRM)
         ENDIF
      ENDIF
C
C --- AUTORISE T-ON DES ITERATIONS DE NEWTON EN PLUS ?
C
      IF (METHOD(1:7).EQ.'EXTRAP_') THEN
        CALL NMDCEX(SDDISC,IECHEC,ITERAT,DELTAT,LENIVO,
     &              NBRPAS,RATIO ,RETOUR)
        CALL ASSERT(RETOUR.GE.0)
        IF (RETOUR.EQ.3) GOTO 9999
      ENDIF
C
C --- SUBDIVISION
C
      CALL U2MESI('I','MECANONLINE6_24',1,NBRPAS)
C
C --- EXTENSION DE LA LISTE D'INSTANTS
C
      CALL NMDCEI(SDDISC,METHOD,NUMINS,INSTAM,DELTAT,
     &            LENIVO,PASMIN,NBRPAS,RATIO ,RETOUR)
      IF (RETOUR.EQ.2) GOTO 9999
C
9999  CONTINUE
C
      CALL JEDEMA()

      END
