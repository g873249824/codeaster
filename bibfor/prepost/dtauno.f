      SUBROUTINE DTAUNO(JRWORK, LISNOE, NBNOT, NBORDR, NNOINI, NBNOP,
     &                  NUMPAQ, TSPAQ, NOMMET, NOMCRI,NOMFOR,GRDVIE, 
     &                  FORVIE, NOMMAI, CNSR)
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
C TOLE  CRP_20
      IMPLICIT     NONE
      INTEGER      JRWORK, NBNOT, LISNOE(NBNOT), NBORDR, NNOINI, NBNOP
      INTEGER      NUMPAQ, TSPAQ
      CHARACTER*8  NOMMAI, GRDVIE
      CHARACTER*16 NOMCRI, NOMMET, NOMFOR, FORVIE
      CHARACTER*19 CNSR
C ---------------------------------------------------------------------
C BUT: DETERMINER LE PLAN INCLINE POUR LEQUEL DELTA_TAU EST MAXIMUM
C      POUR CHAQUE NOEUD D'UN <<PAQUET>> DE NOEUDS.
C ---------------------------------------------------------------------
C ARGUMENTS:
C JRWORK     IN    I  : ADRESSE DU VECTEUR DE TRAVAIL CONTENANT
C                       L'HISTORIQUE DES TENSEURS DES CONTRAINTES
C                       ATTACHES A CHAQUE POINT DE GAUSS DES MAILLES
C                       DU <<PAQUET>> DE MAILLES.
C LISNOE     IN    I  : LISTE COMPLETE DES NOEUDS A TRAITER.
C NBNOT      IN    I  : NOMBRE TOTAL DE NOEUDS A TRAITER.
C NBORDR     IN    I  : NOMBRE DE NUMERO D'ORDRE STOCKE DANS LA
C                       STRUCTURE DE DONNEES RESULTAT.
C NNOINI     IN    I  : NUMERO DU 1ER NOEUD DU <<PAQUET>> DE
C                       NOEUDS COURANT.
C NBNOP      IN    I  : NOMBRE DE NOEUDS DANS LE <<PAQUET>> DE
C                       NOEUDS COURANT.
C NUMPAQ     IN    I  : NUMERO DU PAQUET DE NOEUDS COURANT.
C TSPAQ      IN    I  : TAILLE DU SOUS-PAQUET DU <<PAQUET>> DE NOEUDS
C                       COURANT.
C NOMMET     IN    K16: NOM DE LA METHODE DE CALCUL DU CERCLE
C                       CIRCONSCRIT.
C NOMCRI     IN    K16: NOM DU CRITERE AVEC PLANS CRITIQUES.
C NOMMAI     IN    K8 : NOM UTILISATEUR DU MAILLAGE.
C CNSR       IN    K19: NOM DU CHAMP SIMPLE DESTINE A RECEVOIR LES
C                       RESULTATS.
C
C REMARQUE :
C  - LA TAILLE DU SOUS-PAQUET EST EGALE A LA TAILLE DU <<PAQUET>> DE
C    NOEUDS DIVISEE PAR LE NOMBRE DE NUMERO D'ORDRE (NBORDR).
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
C     ------------------------------------------------------------------
      INTEGER      I, J, K, L, N, JCNRD, JCNRL, JCNRV, IBIDNO
      INTEGER      IRET, NBMA, ADRMA, ICESD, ICESL, ICESV
      INTEGER      IBID, TNECES, TDISP, JVECNO
      INTEGER      JVECTN, JVECTU, JVECTV, NGAM, IDEB, DIM
      INTEGER      TAB2(18), INOP, NUNOE, JDTAUM, JRESUN
      INTEGER      LOR8EM, LOISEM, JTYPMA
      INTEGER      ICMP, KWORK, SOMNOW, CNBNO
      INTEGER      VALI(2), JAD, IARG
C
      REAL*8       DGAM, PI, R8PI, DPHI, TAB1(18)
      REAL*8       PHI0, COEPRE, VALA, VALB, GAMMA
      REAL*8       COEFPA, VRESU(24)
C
      INTEGER      ICODWO
      CHARACTER*8  CHMAT1, NOMMAT, K8B
      CHARACTER*10 OPTIO
      CHARACTER*19 CHMAT, CESMAT, NCNCIN
      CHARACTER*24 TYPMA
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

      CALL JEMARQ()

C CONSTRUCTION DU VECTEUR CONTENANT DELTA_TAU_MAX
C CONSTRUCTION DU VECTEUR CONTENANT LA VALEUR DU POINTEUR PERMETTANT
C              DE RETROUVER LE VECTEUR NORMAL ASSOCIE A DELTA_TAU_MAX

      CALL WKVECT('&&DTAUNO.DTAU_MAX', 'V V R', 209, JDTAUM)
      CALL WKVECT('&&DTAUNO.RESU_N', 'V V I', 209, JRESUN)

C CONSTRUCTION DU VECTEUR NORMAL SUR UNE DEMI SPHERE
C CONSTRUCTION DU VECTEUR U DANS LE PLAN TANGENT, SUR UNE DEMI SPHERE
C CONSTRUCTION DU VECTEUR V DANS LE PLAN TANGENT, SUR UNE DEMI SPHERE

      CALL WKVECT( '&&DTAUNO.VECT_NORMA', 'V V R', 630, JVECTN )
      CALL WKVECT( '&&DTAUNO.VECT_TANGU', 'V V R', 630, JVECTU )
      CALL WKVECT( '&&DTAUNO.VECT_TANGV', 'V V R', 630, JVECTV )

C OBTENTION DES ADRESSES '.CESD', '.CESL' ET '.CESV' DU CHAMP SIMPLE
C DESTINE A RECEVOIR LES RESULTATS : DTAUM, ....

      CALL JEVEUO(CNSR//'.CNSD','L',JCNRD)
      CALL JEVEUO(CNSR//'.CNSL','E',JCNRL)
      CALL JEVEUO(CNSR//'.CNSV','E',JCNRV)

C RECUPERATION DU COEFFICIENT DE PRE-ECROUISSAGE DONNE PAR L'UTILISATEUR

      CALL GETVR8(' ','COEF_PREECROU',1,IARG,1,COEPRE,IRET)

C RECUPERATION MAILLE PAR MAILLE DU MATERIAU DONNE PAR L'UTILISATEUR

      CALL GETVID(' ','CHAM_MATER',1,IARG,1,CHMAT1,IRET)
      CHMAT = CHMAT1//'.CHAMP_MAT'
      CESMAT = '&&DTAUNO.CESMAT'
      CALL CARCES(CHMAT,'ELEM',' ','V',CESMAT,IRET)
      CALL JEVEUO(CESMAT//'.CESD','L',ICESD)
      CALL JEVEUO(CESMAT//'.CESL','L',ICESL)
      CALL JEVEUO(CESMAT//'.CESV','L',ICESV)

      TNECES = 209*NBORDR*2
      CALL JEDISP(1, TDISP)
      TDISP =  (TDISP * LOISEM()) / LOR8EM()
      IF (TDISP .LT. TNECES ) THEN
            VALI (1) = TDISP
            VALI (2) = TNECES
         CALL U2MESG('F', 'PREPOST5_8',0,' ',2,VALI,0,0.D0)
      ELSE
         CALL WKVECT( '&&DTAUNO.VECTNO', 'V V R', TNECES, JVECNO )
         CALL JERAZO( '&&DTAUNO.VECTNO', TNECES, 1 )
      ENDIF

      DGAM = 10.0D0

      N = 0
      K = 1
      IDEB = 1
      DIM = 627
      DO 300 J=1, 18
         GAMMA=(J-1)*DGAM*(PI/180.0D0)
         DPHI=TAB1(J)*(PI/180.0D0)
         PHI0=DPHI/2.0D0
         NGAM=TAB2(J)

         CALL VECNUV(IDEB, NGAM, GAMMA, PHI0, DPHI, N, K, DIM,
     &               ZR(JVECTN), ZR(JVECTU), ZR(JVECTV))

 300  CONTINUE

C CONSTRUCTION DU VECTEUR : CONTRAINTE = F(NUMERO D'ORDRE) EN CHAQUE
C NOEUDS DU PAQUET DE MAILLES.
      L = 1
      CNBNO = 0
      KWORK = 0
      SOMNOW = 0

      NCNCIN = '&&DTAUNO.CNCINV'
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

         
         CALL RCPARE( NOMMAT, 'FATIGUE', 'WOHLER', ICODWO )
         IF ( ICODWO .EQ. 1 ) THEN
            CALL U2MESK('F','FATIGUE1_90',1,NOMCRI(1:16))
         ENDIF

         IF (K .EQ. 0) THEN
            VALI (1) = NUNOE
            VALI (2) = NBMA
            CALL U2MESG('A', 'PREPOST5_10',0,' ',2,VALI,0,0.D0)
         ENDIF

         CALL JERAZO('&&DTAUNO.VECTNO', TNECES, 1)

C C  IBIDNO JOUE LE ROLE DE IPG DNAS TAURLO      
         IBIDNO = 1
  
C REMPACER PAR ACMATA                  
            CALL ACGRDO ( JVECTN, JVECTU, JVECTV, NBORDR, KWORK,
     &                    SOMNOW, JRWORK, TSPAQ, IBIDNO, JVECNO,JDTAUM, 
     &                    JRESUN, NOMMET, NOMMAT, NOMCRI,VALA,
     &                    COEFPA, NOMFOR, GRDVIE, FORVIE, VRESU)
  
C AFFECTATION DES RESULTATS DANS UN CHAM_ELEM SIMPLE

         DO 550 ICMP=1, 24
               JAD = 24*(NUNOE-1) + ICMP
               ZL(JCNRL - 1 + JAD) = .TRUE.
               ZR(JCNRV - 1 + JAD) = VRESU(ICMP)

 550     CONTINUE

 400  CONTINUE

C MENAGE

      CALL DETRSD('CHAM_ELEM_S',CESMAT)

      CALL JEDETR('&&DTAUNO.DTAU_MAX')
      CALL JEDETR('&&DTAUNO.RESU_N')
      CALL JEDETR('&&DTAUNO.VECT_NORMA')
      CALL JEDETR('&&DTAUNO.VECT_TANGU')
      CALL JEDETR('&&DTAUNO.VECT_TANGV')
      CALL JEDETR('&&DTAUNO.VECTNO')
      CALL JEDETR('&&DTAUNO.CNCINV')
C
      CALL JEDEMA()
      END
