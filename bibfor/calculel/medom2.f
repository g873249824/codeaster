      SUBROUTINE MEDOM2(MODELE,MATE,CARA,KCHA,NCHA,CTYP,
     &                  RESULT,NUORD,NBORDR,BASE,NPASS,LIGREL)
      IMPLICIT NONE
      INTEGER       NCHA,NUORD
      CHARACTER*1   BASE
      CHARACTER*4   CTYP
      CHARACTER*8   MODELE,CARA,RESULT
      CHARACTER*24  MATE
      CHARACTER*(*) KCHA
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 15/11/2011   AUTEUR DELMAS J.DELMAS 
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
C
C     CHAPEAU DE LA ROUTINE MEDOM1
C     ON DETERMINE LE BON LIGREL DANS LE CAS OU ON PASSE POUR LA
C     PREMIERE FOIS
C
C ----------------------------------------------------------------------
C
C OUT : MODELE : NOM DU MODELE
C OUT : MATE   : CHAMP MATERIAU
C OUT : CARA   : NOM DU CHAMP DE CARACTERISTIQUES
C IN  : KCHA   : NOM JEVEUX POUR STOCKER LES CHARGES
C OUT : NCHA   : NOMBRE DE CHARGES
C OUT : CTYP   : TYPE DE CHARGE
C IN  : RESULT : NOM DE LA SD RESULTAT
C IN  : NUORD  : NUMERO D'ORDRE
C IN  : NBORDR : NOMBRE TOTAL DE NUMEROS D'ORDRE
C IN  : BASE   : 'G' OU 'V' POUR LA CREATION DU LIGREL
C IN/OUT : NPASS  : NOMBRE DE PASSAGE DANS LA ROUTINE
C OUT : LIGREL   : NOM DU LIGREL
C
C ----------------------------------------------------------------------
C
C --------- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C
C ----------------------------------------------------------------------
C
      INTEGER NBMXBA
      PARAMETER (NBMXBA=2)
      
      INTEGER NBORDR,NPASS,NBLIGR,I,KMOD
      INTEGER ILIGRS,IMODLS,INDIK8,IBASES

      CHARACTER*1  BASLIG
      CHARACTER*24 LIGREL, LIGR1
C
C ----------------------------------------------------------------------
C
C PERSISTANCE PAR RAPPORT A OP0058
      SAVE NBLIGR, ILIGRS, IMODLS, IBASES
C
      CALL JEMARQ()

C     RECUPERATION DU MODELE, CARA, CHARGES A PARTIR DU RESULTAT ET DU
C     NUMERO ORDRE
      CALL MEDOM1(MODELE,MATE,CARA,KCHA,NCHA,CTYP,RESULT,NUORD)

C     RECUPERATION DU LIGREL DU MODELE

C     POUR LE PREMIER PASSAGE ON INITIALISE LES TABLEAUX SAUVES
      IF (NPASS.EQ.0) THEN
        NPASS=NPASS+1
        NBLIGR=0
        CALL JEDETR('&&MEDOM2.LIGRS    ')
        CALL JEDETR('&&MEDOM2.MODELS   ')
        CALL JEDETR('&&MEDOM2.BASES    ')
        CALL WKVECT('&&MEDOM2.LIGRS    ','V V K24',NBORDR*NBMXBA,ILIGRS)
        CALL WKVECT('&&MEDOM2.MODELS   ','V V K8' ,NBORDR,IMODLS)
        CALL WKVECT('&&MEDOM2.BASES    ','V V K8' ,NBORDR*NBMXBA,IBASES)
        CALL JEVEUT('&&MEDOM2.LIGRS    ','L',ILIGRS)
        CALL JEVEUT('&&MEDOM2.MODELS   ','L',IMODLS)
        CALL JEVEUT('&&MEDOM2.BASES    ','L',IBASES)
      END IF

C     ON REGARDE SI LE MODELE A DEJA ETE RENCONTRE
      KMOD=INDIK8(ZK8(IMODLS-1),MODELE,1,NBLIGR+1)
      BASLIG=' '
      DO 10,I = 1,NBLIGR
        IF (ZK8(IMODLS-1+I).EQ.MODELE) THEN
          KMOD=1
          BASLIG=ZK8(IBASES-1+I)(1:1)
        ENDIF
   10 CONTINUE

C     SI OUI, ON REGARDE SI LE LIGREL A ETE CREE SUR LA MEME BASE 
C     QUE LA BASE DEMANDEE
      IF ((KMOD.GT.0).AND.(BASLIG.EQ.BASE)) THEN
C
C     SI OUI ALORS ON LE REPREND
        LIGREL=ZK24(ILIGRS-1+NBLIGR)
        
C     SI NON ON CREE UN NOUVEAU LIGREL
      ELSE
        CALL EXLIMA(' ',0,BASE,MODELE,LIGR1)
        NBLIGR=NBLIGR+1
        ZK24(ILIGRS-1+NBLIGR)=LIGR1
        ZK8( IMODLS-1+NBLIGR)=MODELE
        ZK8( IBASES-1+NBLIGR)=BASE
        LIGREL=LIGR1
      END IF
C      
      CALL JEDEMA()
      END
