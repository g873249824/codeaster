      SUBROUTINE CFINIT(NOMA  ,FONACT,DEFICO,RESOCO,NUMINS,
     &                  SDDYNA,VALINC)
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
      IMPLICIT     NONE
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      INTEGER      NUMINS
      INTEGER      FONACT(*)
      CHARACTER*19 VALINC(*)
      CHARACTER*19 SDDYNA
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATION CONTACT)
C
C INITIALISATION DES PARAMETRES DE CONTACT POUR LE NOUVEAU PAS DE
C TEMPS
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  DEFICO : SD DEFINITION DU CONTACT
C IN  RESOCO : SD RESOLUTION DU CONTACT
C IN  SDDYNA : SD DYNAMIQUE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  NUMINS : NUMERO INSTANT COURANT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      LOGICAL      LREAC(3)
      CHARACTER*24 CLREAC
      INTEGER      JCLREA
      CHARACTER*24 AUTOC1,AUTOC2
      LOGICAL      ISFONC,CFDISL,LELTC,LCTCD,LALLV
      INTEGER      MMITGO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- FONCTIONNALITES ACTIVEES
C
      LCTCD  = ISFONC(FONACT,'CONT_DISCRET')
      LELTC  = ISFONC(FONACT,'ELT_CONTACT')
      LALLV  = CFDISL(DEFICO,'ALL_VERIF')
      IF (LALLV) GOTO 99
C
C --- INITIALISATIONS POUR CONTACT DISCRET
C
      IF (LCTCD) THEN
C
C ----- ACCES OBJETS
C
        AUTOC1 = RESOCO(1:14)//'.REA1'
        AUTOC2 = RESOCO(1:14)//'.REA2'
        CLREAC = RESOCO(1:14)//'.REAL'
        CALL JEVEUO(CLREAC,'E',JCLREA)
C
C ----- PARAMETRES DE REACTUALISATION GEOMETRIQUE
C
        LREAC(1) = .TRUE.
        LREAC(2) = .FALSE.
        LREAC(3) = .TRUE.
        IF (CFDISL(DEFICO,'REAC_GEOM_SANS')) THEN
          IF (NUMINS.NE.1) THEN
            LREAC(1) = .FALSE.
            LREAC(3) = .FALSE.
          ENDIF
        ENDIF
C
        CALL MMBOUC(RESOCO,'GEOM','INIT',MMITGO)
        CALL MMBOUC(RESOCO,'GEOM','INCR',MMITGO)
C
C ----- INITIALISATION DES VECTEURS POUR REAC_GEOM
C
        CALL VTZERO(AUTOC1)
        CALL VTZERO(AUTOC2)
C
C ----- SAUVEGARDE
C
        ZL(JCLREA-1+1) = LREAC(1)
        ZL(JCLREA-1+2) = LREAC(2)
        ZL(JCLREA-1+3) = LREAC(3)
      ENDIF
C
C --- INITIALISATIONS POUR CONTACT CONTINU ET XFEM
C
      IF (LELTC) THEN
        CALL MMINIT(NOMA  ,DEFICO,RESOCO,SDDYNA,VALINC)
      ENDIF
C
  99  CONTINUE
C
      CALL JEDEMA()

      END
