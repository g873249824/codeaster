      SUBROUTINE FOCRMS ( METHOD,NOMFON,CRIT,EPSI,TINI,LTINI,
     &                                            TFIN,LTFIN,CENT,RMS )
      IMPLICIT  NONE
      INTEGER             LTINI, LTFIN
      REAL*8              EPSI, TINI, TFIN, CENT, RMS
      CHARACTER*(*)       METHOD, NOMFON, CRIT
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 31/03/2003   AUTEUR MCOURTOI M.COURTOIS 
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
C     ------------------------------------------------------------------
C
C     CALCUL DE LA RACINE CAREE DE LA MOYENNE QUADRATIQUE  
C     D'UNE FONCTION ENTRE LES INSTANTS T0 ET T1
C     (ROOT MEAN SQUARE)
C
C IN      METHOD : K : METHODE D'INTEGRATION (TRAPEZE OU SIMPSON)
C IN      NOMFON : K : NOM DE LA FONCTION A MOYENNER
C IN      CRIT   : K : CRITER D'ERREEUR (ABSOLUE OU RELATIF)
C IN      EPSI   : R : TOLERENCE SUR LA PRECISION DES REELS 
C IN_OUT  TINI   : R : BORNE INFERIEURE DE L'INTEGRATION
C IN      LTINI  : I : VAUT 0 SI T0 EST DONNEE PAR L'UTILISATEUR 
C                      ET DIFFERENTE DE 0 DANS LE CAS CONTRAIRE.
C IN_OUT  TFIN   : R : BORNE SUPERIEURE DE L'INTEGRATION
C IN      LTFIN  : I : VAUT 0 SI T1 EST DONNEE PAR L'UTILISATEUR 
C                      ET DIFFERENTE DE 0 DANS LE CAS CONTRAIRE.
C IN      CENT   : R : PERMET DE "DECENTRER" LE CALCUL
C                      CENT=0 : MOYENNE QUADRATIQUE
C                      CENT=MOYENNE DE LA FONCTION INITIALE : ECART-TYPE
C OUT RMS    : R : MOYENNE QUADRATIQUE DE LA FONCTION
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER        NBVAL, LVAR, LFON, LPRO, NBPTS, IER
      INTEGER        INTRP0, INTRP1, IDEB, IFIN, IABSS
      INTEGER        NBVALU, LABSS, LORDO , LRMS , I
      REAL*8         T0, T1, FT0, FT1
      REAL*8         SIGN, AUX, CSTE
      CHARACTER*1    K1BID  
      CHARACTER*19   NOMFI
      CHARACTER*24   VALE,PROL
C     ----------------------------------------------------------------
C
      CALL JEMARQ()
      NOMFI = NOMFON
C
      PROL = NOMFI//'.PROL'
      CALL JEVEUO(PROL,'L',LPRO)
      IF ( ZK16(LPRO) .NE. 'FONCTION' ) THEN
         CALL UTMESS('F','FONFFT',
     +      'SEULE LE CALCUL DU RMS D UNE FONCTION EST IMPLEMENTE')
      ENDIF
C
C     ---  NOMBRE DE POINTS ----
      VALE = NOMFI//'.VALE'
      CALL JELIRA(VALE,'LONUTI',NBVAL,K1BID)
      CALL JEVEUO(VALE,'L',LVAR)
      NBPTS = NBVAL/2
      LFON  = LVAR + NBPTS
C
C     ----------------------------------------------------------------
C
      IF (METHOD.EQ.'SIMPSON' .OR. METHOD.EQ.'TRAPEZE'
     &                        .OR. METHOD.EQ.'  ')      THEN
C
         SIGN = 1.D0
C MC JE NE VOIS PAS A QUOI SERVENT CES LIGNES
C    T0 ET T1 SONT AFFECTES PAR FONOC0 
C         IF ( T0 .GT. T1 ) THEN
C            AUX = T1
C            T1  = T0
C            T0  = AUX
C            SIGN = - SIGN 
C         ENDIF
C
         CALL FONOC0 ( ZR(LVAR), TINI, LTINI, TFIN, LTFIN, CRIT, EPSI,
     &                     NBPTS, T0, IDEB, INTRP0, T1, IFIN, INTRP1 )
C
C        --- ALLOCATION DES TABLEAUX AUXILIARES ---
C
         NBVALU = IFIN - IDEB + 1
         IF( INTRP0 .EQ. 1)  NBVALU = NBVALU + 1
         IF( INTRP1 .EQ. 1)  NBVALU = NBVALU + 1
         IF(IDEB .EQ. 0 .AND. IFIN .EQ. 0)  NBVALU = 2
C
         CALL WKVECT('&&FOCRMS.ABSS', 'V V R',NBVALU,LABSS)
         CALL WKVECT('&&FOCRMS.ORDO', 'V V R',NBVALU,LORDO)
         CALL WKVECT('&&FOCRMS.RMS',  'V V R',NBVALU,LRMS)
C
C        --- STOKAGE DES INSTANTS COMPRIS ENTRE T0 ET T1 ---
C
         ZR(LABSS) = T0
         DO 55 IABSS = 2, NBVALU-1
            ZR(LABSS+IABSS-1) = ZR(LVAR+IDEB+IABSS-2) 
  55     CONTINUE        
         ZR(LABSS+NBVALU-1) = T1
C
C        --- STOKAGE DES CARRES DES VALEURS DE LA FONCTION POUR  ---
C        --- LES INSTANTS COMPRIS ENTRE T0 ET T1                 ---
C            EVENTUELLEMENT DECENTRER DE 'CENT'
C
         DO 66 IABSS = 2, NBVALU-1
            ZR(LORDO+IABSS-1) = (ZR(LFON+IDEB+IABSS-2)-CENT)**2 
  66     CONTINUE
         IF(INTRP0 .EQ. 0) THEN
             FT0 =  ZR(LFON+IDEB-1)    
         ELSE
             CALL FOINTE('F ',NOMFON, 1, 'INST', T0, FT0, IER )
         ENDIF
         ZR(LORDO) = (FT0-CENT)**2
C
         IF(INTRP1 .EQ. 0) THEN
             FT1 =  ZR(LFON+IFIN-1)   
         ELSE
             CALL FOINTE('F ',NOMFON, 1, 'INST', T1, FT1, IER )
         ENDIF
         ZR(LORDO+NBVALU-1) = (FT1-CENT)**2
C
C        -- CALCUL DE LA RMS --
C
         CSTE = 0.D0
         CALL FOC2IN(METHOD,NBVALU,ZR(LABSS),ZR(LORDO),CSTE,ZR(LRMS))
         RMS = ZR(LRMS+NBVALU-1) / (T1-T0)
         RMS = SIGN * SQRT(RMS)
C
         CALL JEDETR('&&FOCRMS.ABSS')
         CALL JEDETR('&&FOCRMS.ORDO')
         CALL JEDETR('&&FOCRMS.RMS')
      ENDIF
C
C     ----------------------------------------------------------------
C
C     --- INTEGRATION ---
      IF (METHOD.EQ.'SIMPSON') THEN
         WRITE(6,'(1X,A)') 'INTEGRATION D"ORDRE 2 (METHODE SIMPSON)'
         CALL UTMESS('I',METHOD,'METHODE D''INTEGRATION DE SIMPSON'
     &   //' PEUT PROVOQUER DES OSCILLATIONS SI LA COURBE A '
     &   //'INTEGRER N''EST PAS ASSEZ DISCRETISEE OU REGULIERE. '
     &   //' FAIRE ATTENTION AVEC LES ACCELEROGRAMMES.')
      ELSE IF ( METHOD .NE. 'TRAPEZE' .AND. METHOD .NE. '  ' ) THEN
         CALL UTMESS('F',METHOD,'METHODE D''INTEGRATION INEXISTANTE.')
      ENDIF
C
C
      CALL JEDEMA()
      END
