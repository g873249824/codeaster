      SUBROUTINE AVGRNO(VWORK, TDISP, LISNOE, NBNOT, NBORDR, NNOINI,
     &                  NBNOP, NUMPAQ, TSPAQ, NOMCRI, NOMFOR,GRDVIE, 
     &                  FORVIE,FORDEF,NOMMAI,PROAXE, CNSR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 26/09/2011   AUTEUR TRAN V-X.TRAN 
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
C RESPONSABLE F1BHHAJ J.ANGLES
C 
      IMPLICIT     NONE
      INTEGER      TDISP, NBNOP, LISNOE(NBNOP), NBNOT, NBORDR, NNOINI
      INTEGER      NUMPAQ, TSPAQ
      LOGICAL      FORDEF
      REAL*8       VWORK(TDISP)
      CHARACTER*8  NOMMAI, GRDVIE
      CHARACTER*16 NOMCRI, PROAXE, NOMFOR, FORVIE
      CHARACTER*19 CNSR
C ---------------------------------------------------------------------
C BUT: DETERMINER LE PLAN DANS LEQUEL LE DOMMAGE EST MAXIMAL
C ---------------------------------------------------------------------
C ARGUMENTS:
C VWORK     IN    R  : VECTEUR DE TRAVAIL CONTENANT
C                      L'HISTORIQUE DES TENSEURS DES CONTRAINTES
C                      ATTACHES A CHAQUE POINT DE GAUSS DES MAILLES
C                      DU <<PAQUET>> DE MAILLES.
C TDISP     IN    I  : DIMENSION DU VECTEUR VWORK
C LISNOE    IN    I  : LISTE COMPLETE DES NOEUDS A TRAITER.
C NBNOT     IN    I  : NOMBRE TOTAL DE NOEUDS A TRAITER.
C NBORDR    IN    I  : NOMBRE DE NUMERO D'ORDRE STOCKE DANS LA
C                      STRUCTURE DE DONNEES RESULTAT.
C NNOINI    IN    I  : NUMERO DU 1ER NOEUD DU <<PAQUET>> DE
C                      NOEUDS COURANT.
C NBNOP     IN    I  : NOMBRE DE NOEUDS DANS LE <<PAQUET>> DE
C                      NOEUDS COURANT.
C NUMPAQ    IN    I  : NUMERO DU PAQUET DE MAILLES COURANT.
C TSPAQ     IN    I  : TAILLE DU SOUS-PAQUET DU <<PAQUET>> DE MAILLES
C                      COURANT.
C NOMCRI    IN    K16: NOM DU CRITERE AVEC PLANS CRITIQUES.
C NOMMAI    IN    K8 : NOM DU MAILLAGE.
C PROAXE    IN    K16: TYPE DE PROJECTION (UN OU DEUX AXES).
C CNSR      IN    K19: NOM DU CHAMP SIMPLE DESTINE A RECEVOIR LES
C                      RESULTATS.
C
C REMARQUE :
C  - LA TAILLE DU SOUS-PAQUET EST EGALE A LA TAILLE DU <<PAQUET>> DE
C    MAILLES DIVISEE PAR LE NOMBRE DE NUMERO D'ORDRE (NBORDR).
C-----------------------------------------------------------------------
C---- COMMUNS NORMALISES  JEVEUX
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
      CHARACTER*32 ZK32,JEXNUM
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C-----------------------------------------------------------------------
      INTEGER       I, IBID, JVECTN, JVECTU, JVECTV     
      INTEGER       JCNRD, JCNRL, JCNRV, IRET, ICESD, ICESL, ICESV
      INTEGER       TNECES, TDISP2, LOR8EM, LOISEM, JVECNO,  N, K
      INTEGER       NUNOE, IDEB, DIM, J, NGAM, TAB2(18), IFIN
      INTEGER       L, CNBNO, IBIDNO, KWORK, SOMNOW, INOP
      INTEGER       NBMA, ADRMA, JTYPMA
      INTEGER       ICMP, JAD, IARG
      INTEGER       VALI(2), NBVECM
C
      REAL*8        FATSOC, DGAM, GAMMA, PI, R8PI, DPHI, TAB1(18), PHI0
      REAL*8        VALA, VALB, COEFPA, CUDOMX
      REAL*8        NXM, NYM, NZM
      REAL*8        VRESU(24)
C
      CHARACTER*8  CHMAT1, NOMMAT, K8B
      CHARACTER*10 OPTIO
      CHARACTER*19 CHMAT, CESMAT, NCNCIN
      CHARACTER*24 TYPMA
C
C
C-----------------------------------------------------------------------
C234567                                                              012
C-----------------------------------------------------------------------
      DATA  TAB1/ 180.0D0, 60.0D0, 30.0D0, 20.0D0, 15.0D0, 12.857D0,
     &             11.25D0, 10.588D0, 10.0D0, 10.0D0, 10.0D0, 10.588D0,
     &             11.25D0, 12.857D0, 15.0D0, 20.0D0, 30.0D0, 60.0D0 /
C
      DATA  TAB2/ 1, 3, 6, 9, 12, 14, 16, 17, 18, 18, 18, 17, 16, 14,
     &           12, 9, 6, 3 /
C
      PI = R8PI()
C-----------------------------------------------------------------------
C
      CALL JEMARQ()

C CONSTRUCTION DU VECTEUR NORMAL SUR UNE DEMI SPHERE
C CONSTRUCTION DU VECTEUR U DANS LE PLAN TANGENT, SUR UNE DEMI SPHERE
C CONSTRUCTION DU VECTEUR V DANS LE PLAN TANGENT, SUR UNE DEMI SPHERE

      CALL WKVECT('&&AVGRNO.VECT_NORMA', 'V V R', 627, JVECTN)
      CALL WKVECT('&&AVGRNO.VECT_TANGU', 'V V R', 627, JVECTU)
      CALL WKVECT('&&AVGRNO.VECT_TANGV', 'V V R', 627, JVECTV)

C OBTENTION DES ADRESSES '.CNSD', '.CNSL' ET '.CNSV' DU CHAMP SIMPLE
C DESTINE A RECEVOIR LES RESULTATS : DOMMAGE_MAX, COORDONNEES VECTEUR
C NORMAL CORRESPONDANT

      CALL JEVEUO(CNSR//'.CNSD','L',JCNRD)
      CALL JEVEUO(CNSR//'.CNSL','E',JCNRL)
      CALL JEVEUO(CNSR//'.CNSV','E',JCNRV)

C RECUPERATION MAILLE PAR MAILLE DU MATERIAU DONNE PAR L'UTILISATEUR

      CALL GETVID(' ','CHAM_MATER',1,IARG,1,CHMAT1,IRET)
      CHMAT = CHMAT1//'.CHAMP_MAT'
      CESMAT = '&&AVGRNO.CESMAT'
      CALL CARCES(CHMAT,'ELEM',' ','V',CESMAT,IRET)
      CALL JEVEUO(CESMAT//'.CESD','L',ICESD)
      CALL JEVEUO(CESMAT//'.CESL','L',ICESL)
      CALL JEVEUO(CESMAT//'.CESV','L',ICESV)

C DEFINITION DU VECTEUR CONTENANT LES VALEURS DU CISAILLEMENT POUR TOUS
C LES INSTANTS ET TOUS LES PLANS

      TNECES = 209*NBORDR*2
      CALL JEDISP(1, TDISP2)
      TDISP2 =  (TDISP2 * LOISEM()) / LOR8EM()
      IF (TDISP2 .LT. TNECES ) THEN
            VALI (1) = TDISP2
            VALI (2) = TNECES
         CALL U2MESG('F', 'PREPOST5_8',0,' ',2,VALI,0,0.D0)
      ELSE
         CALL WKVECT( '&&AVGRNO.VECTNO', 'V V R', TNECES, JVECNO )
      ENDIF
      
      FATSOC = 1.0D0
      
      IF (( NOMCRI(1:16) .EQ. 'FATESOCI_MODI_AV' ) .OR. 
     &    FORDEF )   THEN
         FATSOC = 1.0D4
      ELSE
         FATSOC = 1.0D0
      ENDIF

C CONSTRUCTION DES VECTEURS N, U ET V

      DGAM = 10.0D0

      N = 0
      K = 1
      IDEB = 1
      DIM = 627
      DO 300 J=1, 18
         GAMMA=(J-1)*DGAM*(PI/180.0D0)
         DPHI=TAB1(J)*(PI/180.0D0)
         NGAM=TAB2(J)
         IFIN = NGAM
         PHI0 = DPHI/2.0D0

         CALL VECNUV(IDEB, IFIN, GAMMA, PHI0, DPHI, N, K, DIM,
     &               ZR(JVECTN), ZR(JVECTU), ZR(JVECTV))

 300  CONTINUE

C CONSTRUCTION DU VECTEUR : CONTRAINTE = F(NUMERO D'ORDRE) EN CHAQUE
C NOEUDS DU PAQUET DE MAILLES.
      L = 1
      CNBNO = 0
      KWORK = 0
      SOMNOW = 0
      IBIDNO = 1

      NCNCIN = '&&AVGRNO.CNCINV'
      CALL CNCINV ( NOMMAI, IBID, 0, 'V', NCNCIN )

      TYPMA = NOMMAI//'.TYPMAIL'
      CALL JEVEUO( TYPMA, 'L', JTYPMA )

      DO 400 INOP=NNOINI, NNOINI+(NBNOP-1)

         IF ( INOP .GT. NNOINI ) THEN
            KWORK = 1
            SOMNOW = SOMNOW + 1
         ENDIF

         CNBNO = CNBNO + 1
         IF ( (L*INT(NBNOT/10.0D0)) .LT. CNBNO ) THEN
           WRITE(6,*)NUMPAQ,'   ',(CNBNO-1)
           L = L + 1
         ENDIF

C RECUPERATION DU NOM DU MATERIAU AFFECTE A LA MAILLE OU AUX MAILLES
C QUI PORTENT LE NOEUD COURANT.

         NUNOE = LISNOE(INOP)
         CALL JELIRA( JEXNUM(NCNCIN,NUNOE), 'LONMAX', NBMA, K8B )
         CALL JEVEUO( JEXNUM(NCNCIN,NUNOE), 'L', ADRMA )

         K = 0
         OPTIO = 'DOMA_NOEUD'
         DO 410, I=1, NBMA
            CALL RNOMAT (ICESD, ICESL, ICESV, I, NOMCRI, ADRMA, JTYPMA,
     &                   K, OPTIO, VALA, VALB, COEFPA, NOMMAT)
 410     CONTINUE

         IF (K .EQ. 0) THEN
            VALI (1) = NUNOE
            VALI (2) = NBMA
            CALL U2MESG('A', 'PREPOST5_10',0,' ',2,VALI,0,0.D0)
         ENDIF
         
        NBVECM = 209
        
C REMPLACER PAR AVPLCR
      CALL AVPLCR (NBVECM, ZR(JVECTN), ZR(JVECTU), ZR(JVECTV), NBORDR, 
     &          KWORK, SOMNOW, VWORK, TDISP, TSPAQ,IBIDNO, NOMCRI, 
     &          NOMFOR,GRDVIE, FORVIE,FORDEF,FATSOC,PROAXE,NOMMAT,VALA,
     &          COEFPA, CUDOMX, NXM, NYM, NZM )

C 11. CONSTRUCTION D'UN CHAM_ELEM SIMPLE PUIS D'UN CHAM_ELEM CONTENANT
C     POUR CHAQUE POINT DE GAUSS DE CHAQUE MAILLE LE DOMMAGE_MAX ET LE
C     VECTEUR NORMAL ASSOCIE.

         DO 600 ICMP=1, 24
            VRESU(ICMP) = 0.0D0
 600     CONTINUE
         VRESU(2) = NXM
         VRESU(3) = NYM
         VRESU(4) = NZM
         VRESU(11) = CUDOMX

C 12. AFFECTATION DES RESULTATS DANS UN CHAM_ELEM SIMPLE

         DO 610 ICMP=1, 24
            JAD = 24*(NUNOE-1) + ICMP
            ZL(JCNRL - 1 + JAD) = .TRUE.
            ZR(JCNRV - 1 + JAD) = VRESU(ICMP)
 610     CONTINUE

 400  CONTINUE

C MENAGE

      CALL DETRSD('CHAM_ELEM_S',CESMAT)

      CALL JEDETR('&&AVGRNO.VECT_NORMA')
      CALL JEDETR('&&AVGRNO.VECT_TANGU')
      CALL JEDETR('&&AVGRNO.VECT_TANGV')
C
      CALL JEDEMA()
      END
