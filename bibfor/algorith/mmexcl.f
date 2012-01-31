      SUBROUTINE MMEXCL(RESOCO,TYPINT,IPTC  ,IPTM  ,NDEXCL,
     &                  NDEXFR,TYPAPP,LEXFRO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/01/2012   AUTEUR DESOZA T.DESOZA 
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
      CHARACTER*24 RESOCO
      INTEGER      TYPINT
      INTEGER      NDEXCL(9)
      INTEGER      NDEXFR
      INTEGER      IPTC,IPTM
      INTEGER      TYPAPP
      LOGICAL      LEXFRO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
C
C REMPLIT LA SD APPARIMENT POUR LES CAS D'EXCLUSION
C
C ----------------------------------------------------------------------
C
C
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  TYPINT : TYPE D'INTEGRATION
C IN  TYPAPP : TYPE D'APPARIEMENT
C                -1 EXCLU - SANS_NOEUD
C                -2 EXCLU - TOLE_APPA
C                -3 EXCLU - TOLE_PROJ_EXT
C                 1 APPARIEMENT MAIT/ESCL
C                 2 APPARIEMENT NODAL
C IN  IPTM   : NUMERO DU POINT D'INTEGRATION DANS LA MAILLE
C IN  IPTC   : NUMERO DE LA LIAISON DE CONTACT
C I/O NDEXCL : NOEUDS EXCLUS SUR LA MAILLE
C IN  NDEXFR : ENTIER CODE POUR LES NOEUDS INTERDITS DANS
C              SANS_GROUP_NO_FR OU SANS_NOEUD_FR
C OUT LEXFRO : .TRUE. SI LE POINT D'INTEGRATION DOIT ETRE EXCLUS DU
C                     FROTTEMENT
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
      INTEGER      CFMMVD,ZTABF
      CHARACTER*24 TABFIN
      INTEGER      JTABF
      INTEGER      LNEXFR(9)
      LOGICAL      PRTOLE,PROJIN
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES SD CONTACT
C
      TABFIN = RESOCO(1:14)//'.TABFIN'
      CALL JEVEUO(TABFIN,'E',JTABF)
C
      ZTABF = CFMMVD('ZTABF')
C
C --- INITIALISATIONS
C
      PRTOLE = .TRUE.
      PROJIN = .TRUE.
C
C --- TRAITEMENT DES NOEUDS EXCLUS
C
      IF (TYPAPP.EQ.-2) THEN
        PRTOLE = .FALSE.
      ELSEIF   (TYPAPP.EQ.-3) THEN
        PROJIN = .FALSE.
      ENDIF
C
C --- NOEUD EXCLUS PAR SANS_GROUP_NO (TYPAPP=-1)
C
      IF (TYPAPP.EQ.-1) THEN
        CALL ASSERT(TYPINT.EQ.1)
        NDEXCL(IPTM) = 1
      ENDIF
C
C --- PAS DE NOEUDS EXCLU
C
      ZR(JTABF+ZTABF*(IPTC-1)+18) = 0.D0
C
C --- POINTS DE CONTACT EXCLUS PAR TOLE_APPA
C
      IF (.NOT.PRTOLE) THEN
        ZR(JTABF+ZTABF*(IPTC-1)+18) = 1.D0
      ENDIF
C
C --- POINTS DE CONTACT EXCLUS PAR PROJECTION HORS ZONE
C
      IF (.NOT. PROJIN) THEN
        ZR(JTABF+ZTABF*(IPTC-1)+18) = 1.D0
      ENDIF
C
C --- NOEUDS EXCLUS PAR SANS_GROUP_NO OU EXCL_PIV_NUL
C
      IF (TYPINT.EQ.1) THEN
        IF (NDEXCL(IPTM).EQ.1) THEN
          ZR(JTABF+ZTABF*(IPTC-1)+18) = 1.D0
        ENDIF
      ENDIF
C
C --- NOEUDS EXCLUS PAR SANS_GROUP_NO_FR
C
      LEXFRO = .FALSE.
      ZR(JTABF+ZTABF*(IPTC-1)+19) = 0.D0
C     -- SEULS LES 9 PREMIERS NOEUDS EXISTENT DANS LA MAILLE
      IF (IPTM.LE.9) THEN
        CALL ISDECO(NDEXFR,LNEXFR,9)
        IF (LNEXFR(IPTM).EQ.1) THEN
          LEXFRO = .TRUE.
          ZR(JTABF+ZTABF*(IPTC-1)+19) = NDEXFR
        ENDIF
      ENDIF
C
      CALL JEDEMA()
C
      END
