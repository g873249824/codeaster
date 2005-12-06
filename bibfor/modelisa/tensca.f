      SUBROUTINE TENSCA(TABLCA,ICABL,NBNOCA,NBF0,F0,DELTA,RELAX,RJ,
     &                  XFLU,XRET,EA,RH1000,MU0,FPRG,FRCO,FRLI,SA)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 16/09/2003   AUTEUR JMBHH01 J.M.PROIX 
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
C  DESCRIPTION : CALCUL DE LA TENSION LE LONG D'UN CABLE
C  -----------   APPELANT : OP0180 , OPERATEUR DEFI_CABLE_BP
C
C                EN SORTIE ON COMPLETE LA TABLE RESULTAT
C                LES LIGNES COMPLETEES CORRESPONDENT AU DERNIER CABLE
C                LES CASES RENSEIGNEES CORRESPONDENT AU PARAMETRE
C                <TENSION>
C
C  IN     : TABLCA : CHARACTER*19
C                    NOM DE LA TABLE DECRIVANT LES CABLES
C  IN     : ICABL  : INTEGER , SCALAIRE
C                    NUMERO DU CABLE
C  IN     : NBNOCA : INTEGER , VECTEUR DE DIMENSION NBCABL
C                    CONTIENT LES NOMBRES DE NOEUDS DE CHAQUE CABLE
C  IN     : NBF0   : INTEGER , SCALAIRE
C                    NOMBRE D'ANCRAGES ACTIFS DU CABLE (0, 1 OU 2)
C  IN     : F0     : REAL*8 , SCALAIRE
C                    VALEUR DE LA TENSION APPLIQUEE A L'UN OU AUX DEUX
C                    ANCRAGES ACTIFS DU CABLE
C  IN     : DELTA  : REAL*8 , SCALAIRE
C                    VALEUR DU RECUL DE L'ANCRAGE
C  IN     : RELAX  : LOGICAL , SCALAIRE
C                    INDICATEUR DE PRISE EN COMPTE DES PERTES DE TENSION
C                    PAR RELAXATION DE L'ACIER
C  IN     : RJ     : REAL*8 , SCALAIRE
C                    VALEUR DE LA FONCTION CARACTERISANT L'EVOLUTION DE
C                    LA RELAXATION DE L'ACIER DANS LE TEMPS
C                    UTILE SI RELAX = .TRUE.
C  IN     : XFLU   : REAL*8 , SCALAIRE
C                    VALEUR DU TAUX DE PERTE DE TENSION PAR FLUAGE DU
C                    BETON, EN % DE LA TENSION INITIALE
C  IN     : XRET   : REAL*8 , SCALAIRE
C                    VALEUR DU TAUX DE PERTE DE TENSION PAR RETRAIT DU
C                    BETON, EN % DE LA TENSION INITIALE
C  IN     : EA     : REAL*8 , SCALAIRE
C                    VALEUR DU MODULE D'YOUNG DE L'ACIER
C  IN     : RH1000 : REAL*8 , SCALAIRE
C                    VALEUR DE LA RELAXATION A 1000 HEURES EN %
C  IN     : MU0    : REAL*8 , SCALAIRE
C                    VALEUR DU COEFFICIENT DE RELAXATION DE L'ACIER
C                    PRECONTRAINT
C  IN     : FPRG     : REAL*8 , SCALAIRE
C                    VALEUR DE LA CONTRAINTE LIMITE ELASTIQUE DE L'ACIER
C  IN     : FRCO   : REAL*8 , SCALAIRE
C                    VALEUR DU COEFFICIENT DE FROTTEMENT EN COURBE
C                    (CONTACT ENTRE LE CABLE ACIER ET LE MASSIF BETON)
C  IN     : FRLI   : REAL*8 , SCALAIRE
C                    VALEUR DU COEFFICIENT DE FROTTEMENT EN LIGNE
C                    (CONTACT ENTRE LE CABLE ACIER ET LE MASSIF BETON)
C  IN     : SA     : REAL*8 , SCALAIRE
C                    VALEUR DE L'AIRE DE LA SECTION DROITE DU CABLE
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNOM, JEXNUM, JEXATR
C     ----- FIN   COMMUNS NORMALISES  JEVEUX  --------------------------
C
C ARGUMENTS
C ---------
      CHARACTER*19  TABLCA
      INTEGER       ICABL, NBNOCA(*), NBF0
      REAL*8        F0, DELTA, RJ, XFLU, XRET, EA, RH1000, MU0, FPRG,
     &              FRCO, FRLI, SA
      LOGICAL       RELAX
C
C VARIABLES LOCALES
C -----------------
      INTEGER       IBID, IDECNO, INO, IPARA, JABSC, JALPH, JF, JTBLP,
     &              JTBNP, NBLIGN, NBNO, NBPARA
      REAL*8        DF, FLIM, KRELAX, ZERO
      COMPLEX*16    CBID
      LOGICAL       TROUV1, TROUV2
      CHARACTER*3   K3B
      CHARACTER*24  ABSCCA, ALPHCA
C
      CHARACTER*24  PARAM, PARCR(2)
      DATA          PARAM /'TENSION                 '/
      DATA          PARCR /'ABSC_CURV               ',
     &                     'ALPHA                   '/
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      CALL JEMARQ()
C
      ZERO = 0.0D0
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 1   TRAITEMENT DES CAS PARTICULIERS F0 = 0 OU PAS D'ANCRAGE ACTIF
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      NBNO = NBNOCA(ICABL)
C
      CALL JEVEUO(TABLCA//'.TBNP','L',JTBNP)
      NBLIGN = ZI(JTBNP+1)
      IDECNO = NBLIGN - NBNO
C
      IF ( (F0.EQ.0.0D0).OR.(NBF0.EQ.0) ) THEN
         DO 10 INO = 1, NBNO
            CALL TBAJLI(TABLCA,1,PARAM,IBID,ZERO,CBID,K3B,IDECNO+INO)
  10     CONTINUE
         GO TO 9999
      ENDIF
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 2   RECUPERATION DE L'ABSCISSE CURVILIGNE ET DE LA DEVIATION ANGULAIRE
C     CUMULEE LE LONG DU CABLE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      NBPARA = ZI(JTBNP)
      CALL JEVEUO(TABLCA//'.TBLP','L',JTBLP)
      TROUV1 = .FALSE.
      TROUV2 = .FALSE.
      DO 20 IPARA = 1, NBPARA
         IF ( ZK24(JTBLP+4*(IPARA-1)).EQ.PARCR(1) ) THEN
            TROUV1 = .TRUE.
            ABSCCA = ZK24(JTBLP+4*(IPARA-1)+2)
            CALL JEVEUO(ABSCCA,'L',JABSC)
         ENDIF
         IF ( ZK24(JTBLP+4*(IPARA-1)).EQ.PARCR(2) ) THEN
            TROUV2 = .TRUE.
            ALPHCA = ZK24(JTBLP+4*(IPARA-1)+2)
            CALL JEVEUO(ALPHCA,'L',JALPH)
         ENDIF
         IF ( TROUV1 .AND. TROUV2 ) GO TO 30
  20  CONTINUE
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 4   CALCUL DE LA TENSION LE LONG DU CABLE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
  30  CONTINUE
C
      CALL WKVECT('&&TENSCA.F' ,'V V R',NBNO,JF )
C
C 4.1 CALCUL DE LA TENSION LE LONG DU CABLE EN PRENANT EN COMPTE LES
C --- PERTES PAR FROTTEMENT ET PAR RECUL DU(DES) ANCRAGE(S)
C
      IF ( NBF0.EQ.1 ) THEN
         CALL TENSK1(ICABL,NBNO,ZR(JABSC+IDECNO),ZR(JALPH+IDECNO),
     &               F0,DELTA,EA,FRCO,FRLI,SA,ZR(JF))
      ELSE
         CALL TENSK2(ICABL,NBNO,ZR(JABSC+IDECNO),ZR(JALPH+IDECNO),
     &               F0,DELTA,EA,FRCO,FRLI,SA,ZR(JF))
      ENDIF
C
C 4.2 PRISE EN COMPTE LE CAS ECHEANT DES PERTES DE TENSION PAR
C --- RELAXATION DE L'ACIER
C
      IF ( RELAX ) THEN
         KRELAX = RJ * 5.0D-02 * RH1000
         FLIM = FPRG * SA
         DO 40 INO = 1, NBNO
            ZR(JF+INO-1) = ZR(JF+INO-1)
     &                   * ( 1.0D0 - KRELAX * (ZR(JF+INO-1)/FLIM-MU0) )
  40     CONTINUE
      ENDIF
C
C 4.3 PRISE EN COMPTE LE CAS ECHEANT DES PERTES DE TENSION PAR
C --- FLUAGE ET RETRAIT DU BETON
C
      IF ( XFLU+XRET.NE.0.0D0 ) THEN
         DF = ( XFLU + XRET ) * F0
         DO 50 INO = 1, NBNO
            ZR(JF+INO-1) = ZR(JF+INO-1) - DF
  50     CONTINUE
      ENDIF
C
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C 5   MISE A JOUR DES OBJETS DE SORTIE
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C
      DO 60 INO = 1, NBNO
         CALL TBAJLI(TABLCA,1,PARAM,
     &               IBID,ZR(JF+INO-1),CBID,K3B,IDECNO+INO)
  60  CONTINUE
C
9999  CONTINUE
      CALL JEDETC('V','&&TENSCA',1)
      CALL JEDEMA()
C
C --- FIN DE TENSCA.
      END
