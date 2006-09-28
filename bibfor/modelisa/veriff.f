      SUBROUTINE VERIFF(NBFONC,NOMFON,NBP1,NBP2,LONG)
      IMPLICIT REAL*8 (A-H,O-Z)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C     VERIFICATION DE LA COHERENCE DES DISCRETISATIONS SPATIALES DES
C     FONCTIONS DE FORME
C     CARACTERISATION DES DISCRETISATIONS
C     APPELANT : SPECFF
C-----------------------------------------------------------------------
C IN  : NBFONC : NOMBRE DE FONCTIONS
C IN  : NOMFON : LISTE DES NOMS DES CONCEPTS DE TYPE FONCTION
C OUT : NBP1   : NOMBRE DE POINTS DE DISCRETISATION DES FONCTIONS SUR
C                L'INTERVALLE 0,L
C OUT : NBP2   : NOMBRE DE POINTS DE DISCRETISATION DES FONCTIONS SUR
C                L'INTERVALLE L,2L
C OUT : LONG   : LONGUEUR EXCITEE  LONG = L
C
C
C REMARQUE : DICRETISATION ATTENDUE DES FONCTIONS
C
C LES FONCTIONS SONT DISCRETISEES SUR UN INTERVALLE 0,2L.
C LA PREMIERE MOITIE DE L'INTERVALLE 0,L DONNE LES VALEURS DE LA
C FONCTION DE FORME SUIVANT LA PREMIERE DIRECTION D'ESPACE DU REPERE
C GLOBAL ORTHOGONALE A LA POUTRE (SENS DIRECT).
C
C LA SECONDE MOITIE DE L'INTERVALLE L,2L DONNE LES VALEURS DE LA
C FONCTION DE FORME SUIVANT LA SECONDE DIRECTION D'ESPACE DU REPERE
C GLOBAL ORTHOGONALE A LA POUTRE (SENS DIRECT).
C
C LE VECTEUR .VALE DE CHACUNE DES FONCTIONS DOIT ETRE CONSTITUE DE LA
C MANIERE SUIVANTE :
C
C       0    ....   L        L    ....   2L
C     FD1(0) .... FD1(L)   FD2(0) .... FD2(L)
C     !________________!   !________________!
C             !!                   !!
C         NBP1 POINTS          NBP2 POINTS
C
C     DIMENSION : 2 * ( NBP1 + NBP2 )
C
C     NBP1 , NBP2 ET L SONT COMMUNS A TOUTES LES FONCTIONS.
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER      NBFONC,NBP1,NBP2
      CHARACTER*8  NOMFON(NBFONC)
      REAL*8       LONG
C
      CHARACTER*8  K8BID
      CHARACTER*19 FONC
      CHARACTER*24 VALE
      REAL*8       LONG2
C
C-----------------------------------------------------------------------
      CALL JEMARQ()
C
C-----VECTEURS DE TRAVAIL POUR LE STOCKAGE DES VALEURS DE L, NBP1 ET
C-----NBP2 POUR CHAQUE FONCTION
C
      CALL WKVECT('&&VERIFF.TEMP.LEXC','V V R',NBFONC,ILEXC)
      CALL WKVECT('&&VERIFF.TEMP.NBP1','V V I',NBFONC,INBP1)
      CALL WKVECT('&&VERIFF.TEMP.NBP2','V V I',NBFONC,INBP2)
C
C-----BOUCLE SUR LE NOMBRE DE FONCTIONS
C
      DO 10 IFO = 1,NBFONC
C
        FONC = NOMFON(IFO)
        VALE = FONC//'.VALE'
        CALL JELIRA(VALE,'LONUTI',NBP,K8BID)
        NBP = NBP/2
C
C-------ON VERIFIE QUE L'ON A AU MOINS 4 VALEURS DE PARAMETRE
C------- ( 0 , L , L , 2L )
C
        IF (NBP.LT.4) THEN
          CALL U2MESS('F','MODELISA7_67')
        ENDIF
        CALL JEVEUO(VALE,'L',IVALE)
C
C-------ON VERIFIE QUE LA PREMIERE VALEUR DU PARAMETRE EST 0
C
        IF (ZR(IVALE).NE.0.D0) THEN
          CALL U2MESS('F','MODELISA7_68')
        ENDIF
C
C-------ON VERIFIE QUE LA DISCRETISATION EST STRICTEMENT CROISSANTE
C-------AVEC UNE EXCEPTION POUR LE PARAMETRE L QUI DOIT ETRE REPETE
C
        IEXCEP = 0
        DO 20 IP = 1,NBP-1
          IF (ZR(IVALE+IP-1).GT.ZR(IVALE+IP)) THEN
            CALL U2MESS('F','MODELISA7_68')
          ELSE IF (ZR(IVALE+IP-1).EQ.ZR(IVALE+IP)) THEN
            IEXCEP = IEXCEP + 1
            IF (IEXCEP.EQ.1) THEN
              ZR(ILEXC+IFO-1) = ZR(IVALE+IP-1)
              ZI(INBP1+IFO-1) = IP
              ZI(INBP2+IFO-1) = NBP - IP
            ELSE
              CALL U2MESS('F','MODELISA7_69')
            ENDIF
          ENDIF
  20    CONTINUE
        IF (IEXCEP.EQ.0) THEN
          CALL U2MESS('F','MODELISA7_70')
        ENDIF
C
C-------ERREUR FATALE SI ABSCENCE DE DISCRETISATION
C
        IF (ZI(INBP1+IFO-1).EQ.1 .OR. ZI(INBP2+IFO-1).EQ.1) THEN
          CALL U2MESS('F','MODELISA7_71')
        ENDIF
C
C-------ERREUR FATALE SI LE PARAMETRE REPETE NE CORRESPOND PAS A L
C
        LONG2 = ZR(IVALE+NBP-1)/2.D0
        IF (ZR(ILEXC+IFO-1).NE.LONG2) THEN
          CALL U2MESS('F','MODELISA7_72')
        ENDIF
C
        CALL JELIBE(VALE)
C
  10  CONTINUE
C
C-----VERIFICATION DE LA COHERENCE DES DISCRETISATIONS DE TOUTES LES
C-----FONCTIONS :  - LA LONGUEUR EXCITEE L DOIT ETRE COMMUNE
C-----             - NBP1 ET NBP2 DOIVENT ETRE COMMUNS
C
      IF (NBFONC.GT.1) THEN
        DO 30 IFO = 1,NBFONC-1
          IF (ZR(ILEXC+IFO-1).NE.ZR(ILEXC+IFO)) THEN
            CALL U2MESS('F','MODELISA7_73')
          ENDIF
          IF (ZI(INBP1+IFO-1).NE.ZI(INBP1+IFO) .OR.
     &        ZI(INBP2+IFO-1).NE.ZI(INBP2+IFO)) THEN
            CALL U2MESS('F','MODELISA7_74')
          ENDIF
  30    CONTINUE
      ENDIF
C
C-----ON RENVOIE LES GRANDEURS CARACTERISTIQUES COMMUNES AUX
C-----DISCRETISATIONS DES FONCTIONS
C
      LONG = ZR(ILEXC)
      NBP1 = ZI(INBP1)
      NBP2 = ZI(INBP2)
C
      CALL JEDETR('&&VERIFF.TEMP.LEXC')
      CALL JEDETR('&&VERIFF.TEMP.NBP1')
      CALL JEDETR('&&VERIFF.TEMP.NBP2')
      CALL JEDEMA()
      END
