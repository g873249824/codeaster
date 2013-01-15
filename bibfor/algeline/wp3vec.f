      SUBROUTINE WP3VEC (APPR,OPT,NBFREQ,NBVECT,NEQ,SHIFT,VPR,VPI,
     &                   VECP,MXRESF,RESUFI,RESUFR,LAGR,VAUC,OMECOR)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*1   APPR
      CHARACTER*(*) OPT
      INTEGER       MXRESF,NEQ,NBFREQ,NBVECT,LAGR(*),RESUFI(MXRESF,*)
      COMPLEX*16    VECP(NEQ,*),SHIFT,VAUC(2*NEQ,*)
      REAL*8        RESUFR(MXRESF,*),VPR(*),VPI(*),OMECOR
C     -----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 14/01/2013   AUTEUR BRIE N.BRIE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C     RESTITUTION DES VALEURS PROPRES ET DES MODES DU PB QUADRATIQUE
C     AVEC TRI SUIVANT LES PARTIES IMMAGINAIRES CROISANTES
C     ET NORMALISATION A LA PLUS GRANDE CMP NON LAGRANGE
C
C --> EN PUS ON MET UN TEST DE CONJUGAISON
C --> STOCKAGE D'UN SEUL COUPLE PARMI 2 CONJUGUES
C     -----------------------------------------------------------------
C IN  APPR   : K : INDICATEUR D' APPROCHE 'R' OU 'I'
C IN  OPT    : K : OPTION : 'CENTRE' OU 'PLUS_PETITE'
C IN  NBFREQ : I : NOMBRE DE MODES DEMANDES
C IN  NBVECT : I : NOMBRE DE VECTEURS DE LANCZOS
C IN  NEQ    : I : TAILLE DES MATRICES DU PB QUADRATIQUE
C IN  SHIFT  : C : VALEUR DU DECALAGE
C IN  LAGR   : I : INDICATEUR DES NON-LAGRANGE
C IN  VAUC   : C : MODES DU PB QUADRATIQUE COMPLET
C VAR VPR    : R : IN  : PARTIE REELLE DES VALEURS PROPRE DU PB REDUIT
C            :   : OUT : PARTIE REELLE DES VALEURS PROPRE DU PB QUAD
C VAR VPI    : R : IN  : PARTIE IMMAGI DES VALEURS PROPRE DU PB REDUIT
C            :   : OUT : PARTIE IMMAGI DES VALEURS PROPRE DU PB QUAD
C OUT VECP   : C : MODES DU PB QUADRATIQUE
C OUT RESUFR : C : TABLEAU DE POST-TRAITEMENT
C IN  OMECOR : R : "ZERO MODAL", SEUIL EN DECA DUQUEL DEUX MODES SONT
C                  CONSIDERES COMME IDENTIQUES
C     -----------------------------------------------------------------
C
C
C     ------------------------------------------------------------------
      REAL*8     SI,MOD2,A,B,NMABP,NMABM,AM,OM,RBID,
     &           EPS,SEUILR,SEUILP,C1,AUXRJ,SEUILC,
     &           AUXIJ,AUXRK,AUXIK
      INTEGER    I,J,K,AV1,AV2,IADIND,NBREEL,NBCMPP,NBCMPC,NBFRGA,
     &           VALI(5),NBFR,IBID
      COMPLEX*16 DES,VPQ,MHU,VPP,VPM
      LOGICAL    TROUVE,LCONJ
      CHARACTER*1 KMSG
      CHARACTER*16 VALK, TYPRES

C     -----------------------------------------------------------------
      CALL JEMARQ()
      SI    = DIMAG(SHIFT)
C
C --- 1. PARTITION ,TEST DE CONJUGAISON, ELIMINATION DES CONJUGUES
C        REMARQUE : SI QR N' A PAS EU DE PB ALORS LES MODES REDUITS :
C                   * COMPLEXES ET 2 A 2 CONJUGUES,LES CONJUGUES
C                     APPARAISSENT LES UNS A LA SUITE DES AUTRES
C                   * REELS
C
C        IMPLEMENTATION : DANS UN TABLEAU D' ENTIER (ZI(IADIND))
C        INVARIANT      : T(I) = -2 VP(I) NON CLASSEE
C                         T(I) =  1 <=> VP(I) COMPLEXE AVEC CONJUGUEE
C                                             SELECTIONNEE
C                         T(I) = -1 <=> VP(I) COMPLEXE AVEC CONJUGUEE
C                                             ELIMINEE
C                         T(I) =  0 <=> VP(I) COMPLEXE SANS CONJUGUEE
C                                             OU REELLE
C                                             ELIMINEE
C     -----------------------------------------------------------------
C --- 1.1. PARTITION (OPERATEUR REEL)
      NBCMPP = 0
      NBCMPC = 0
      NBREEL = 0
C*****************************************************************
C     SI IM(VP)<SEUILR: VP EST CONSIDEREE COMME REELLE
      SEUILR=1.D-7
C     SI MODULE(VPK-VPJ) < SEUILP: VPK = CONJUGEE DE VPJ
      SEUILP=OMECOR
C     SEUIL POUR LE COUPLAGE HAUT-BAS DES VECTEURS PROPRES
      SEUILC=1.D-4      
      CALL WKVECT('&&WP3VEC.INDIC.PART.VP','V V I',NBVECT,IADIND)
      DO 1 J = 1, NBVECT
         ZI(IADIND + J-1) = -2
1     CONTINUE
      DO 2 J = 1, NBVECT
         AUXRJ=VPR(J)
         AUXIJ=VPI(J)
         IF ( ZI(IADIND + J-1).EQ.-2 ) THEN
            IF ( ABS(AUXIJ).LT.SEUILR ) THEN
               ZI(IADIND+J-1) = -3
               NBREEL=NBREEL+1
            ELSE
               IF (ABS(AUXRJ).LT.SEUILR) AUXRJ=0.D0
               K      = J + 1
               TROUVE = .FALSE.
3              CONTINUE
               IF ((.NOT. TROUVE ) .AND. ( K .LE. NBVECT) ) THEN
                  AUXRK=VPR(K)
                  AUXIK=VPI(K)
                  IF (ABS(AUXRK).LT.SEUILR) AUXRK=0.D0
                  IF (ABS(AUXIK).LT.SEUILR) AUXIK=0.D0
                  C1=SQRT((AUXRJ-AUXRK)**2+(AUXIJ+AUXIK)**2)
                  IF (C1.LT.SEUILP) THEN
                    LCONJ=.TRUE.
                  ELSE
                    LCONJ=.FALSE.
                  ENDIF

                  IF ((ZI(IADIND+K-1).EQ.-2).AND.LCONJ.AND.
     &                (AUXIJ*AUXIK.LE.0.D0)) THEN
                      TROUVE = .TRUE.
                      NBCMPC = NBCMPC + 1
                      IF ( AUXIJ.GT.0.D0) THEN
                         ZI(IADIND + J-1) =  1
                         ZI(IADIND + K-1) = -1
                      ELSE
                         ZI(IADIND + J-1) = -1
                         ZI(IADIND + K-1) =  1
                      ENDIF
                   ELSE
                      K = K + 1
                   ENDIF
                   GOTO 3
                ENDIF
                IF ( .NOT. TROUVE ) THEN
                   NBCMPP           = NBCMPP + 1
                   ZI(IADIND + J-1) = 0
                ENDIF
             ENDIF
          ENDIF
2     CONTINUE

      IF ( ZI(IADIND + NBVECT-1) .EQ. -2) THEN
         ZI(IADIND + NBVECT-1) = 0
         NBCMPP                = NBCMPP +1
      ENDIF

      IF ( NBCMPP .GT. 0 ) THEN
         VALI (1) = NBREEL
         VALI (2) = NBCMPC
         VALI (3) = NBCMPP
         CALL U2MESI('A', 'ALGELINE4_87',3,VALI)
      ENDIF

      IF ( NBREEL .GT. 0 ) THEN
         VALI (1) = NBREEL
         VALI (2) = NBCMPC
         VALI (3) = NBCMPP
         CALL U2MESI('I', 'ALGELINE4_88',3,VALI)
      ENDIF

C --- 1.2. DETERMINATION DE NB FREQUENCES GARDEES
C      NBFRGA = NBREEL + NBCMPP + NBCMPC
      NBFRGA = NBCMPC

C --- 1.3. ELIMINATION DES CONJUGUES (OPERATEUR REEL) -- COMPACTAGE --
      K = 1
      DO 4 J = 1, NBVECT
         IF (ZI(IADIND + J-1).GT.0) THEN
            IF ( K .NE. J ) THEN
               VPR(K)           = VPR(J)
               VPI(K)           = VPI(J)
               ZI(IADIND + K-1) = ZI(IADIND + J-1)
               DO 5, I = 1, NEQ, 1
                  VECP(I,K) = VECP(I,J)
                  VAUC(I,K) = VAUC(I,J)
                  VAUC(I+NEQ,K) = VAUC(I+NEQ,J)
5              CONTINUE
            ENDIF
            K = K + 1
         ENDIF
4     CONTINUE
      NBFRGA=K-1
C NBRE DE VP RECOMPACTEES
      NBFR=K-1

C     ---------- FIN DE PARTITION TEST ET ELIMINATION -----------------
C     ----------    AU NIVEAU DE L' OPERATEUR REEL    -----------------

C --- 2. CALCUL DES SOLUTIONS PROPRES DU PB QUADRATIQUE ---
      IF ( OPT .EQ. 'CENTRE' ) THEN
         CALL WKVECT('&&WP3VEC.VEC.AUX.C1','V V C',NEQ,AV1)
         CALL WKVECT('&&WP3VEC.VEC.AUX.C2','V V C',NEQ,AV2)
      ENDIF
      DO 10 J = 1, NBFR
      IF (ZI(IADIND + J-1).GT.0) THEN
         A    = VPR(J)
         B    = VPI(J)
         MHU  = DCMPLX(A,B)
         MOD2 = A*A + B*B
         MOD2 = 1.D0/MOD2
         IF ( OPT .EQ. 'PLUS_PETITE' ) THEN
            A      =  A*MOD2
            B      = -B*MOD2
         ELSE IF ( OPT .EQ. 'CENTRE' ) THEN
            DES=DCMPLX(0.D0,0.D0)
            IF ( APPR .EQ. 'R' ) THEN
               DES = DCMPLX(1.D0,0.D0)-DCMPLX(4.D0*SI*SI,0.D0)*MHU*MHU
               DES = SQRT(DES)
               VPQ = .5D0*(DCMPLX(1.D0,0.D0)-DCMPLX(0.D0,2.D0*SI)*MHU +
     &                                                         DES)/MHU
               VPP = VPQ + SHIFT
               CALL WPTEST(LAGR,VAUC(1,J),VAUC(NEQ+1,J),VPP,NEQ,NMABP)
               VPQ = .5D0*(DCMPLX(1.D0,0.D0)-DCMPLX(0.D0,2.D0*SI)*MHU -
     &                                                         DES)/MHU
               VPM = VPQ + SHIFT
               CALL WPTEST(LAGR,VAUC(1,J),VAUC(NEQ+1,J),VPM,NEQ,NMABM)
            ELSE
               DES = -DCMPLX(SI*SI,0.D0)*MHU*MHU + DCMPLX(SI,0.D0)*MHU
               DES =  SQRT(DES)
               VPQ = -DCMPLX(0.D0,SI) + DES/MHU
               VPP =  VPQ + SHIFT
               CALL WPTEST(LAGR,VAUC(1,J),VAUC(NEQ+1,J),VPP,NEQ,NMABP)
               VPQ = -DCMPLX(0.D0,SI) - DES/MHU
               VPM =  VPQ + SHIFT
               CALL WPTEST(LAGR,VAUC(1,J),VAUC(NEQ+1,J),VPM,NEQ,NMABM)
            ENDIF
            IF (NMABM .LT. NMABP ) THEN
               A = DBLE (VPM)
               B = DIMAG(VPM)
               EPS=NMABM
            ELSE
               A = DBLE (VPP)
               B = DIMAG(VPP)
               EPS=NMABP
            ENDIF
            IF (EPS.GT.SEUILC) THEN
              ZI(IADIND + J-1)=0
              NBFRGA=NBFRGA-1
            ENDIF
         ENDIF
         VPR(J) = A
         VPI(J) = B
      ENDIF
10    CONTINUE

C --- 1.3. ELIMINATION DES VALEURS FAUSSES -- RECOMPACTAGE --
      K = 1
      DO 44 J = 1, NBFR
         IF (ZI(IADIND + J-1).GT.0) THEN
            IF ( K .NE. J ) THEN
               VPR(K)           = VPR(J)
               VPI(K)           = VPI(J)
               ZI(IADIND + K-1) = ZI(IADIND + J-1)
               DO 55, I = 1, NEQ, 1
                  VECP(I,K) = VECP(I,J)
                  VAUC(I,K) = VAUC(I,J)
                  VAUC(I+NEQ,K) = VAUC(I+NEQ,J)
55              CONTINUE
            ENDIF
            K = K + 1
         ENDIF
44    CONTINUE
      NBFRGA=K-1

C --- 3. SELECTION DES VALEURS PROPRES (PB QUADRATIQUE)
      DO 20, J = 1, NBFRGA, 1
      IF ( (ZI(IADIND + J-1).EQ.1 ).AND.(VPI(J).LT.0.D0) ) THEN
            VPI(J) = -VPI(J)
            DO 21 I = 1, NEQ
               VECP(I,J) = DCONJG(VECP(I,J))
               VAUC(I,J) = DCONJG(VAUC(I,J))
               VAUC(I+NEQ,J) = DCONJG(VAUC(I+NEQ,J))
21          CONTINUE
         ENDIF
20    CONTINUE

C --- 4. PREPARATION DE RESUFR
       IF (NBFREQ.GT.NBFRGA) THEN
         VALI(1)=NBFREQ
         VALI(2)=NBFRGA
         NBFREQ=NBFRGA
         IF (NBFREQ.EQ.0) THEN
           KMSG='F'
         ELSE
           KMSG='A'
         ENDIF
         CALL GETVTX(' ','TYPE_RESU',1,IBID,1,TYPRES,IBID)
         VALK='FREQ'
         IF (TYPRES .NE. 'DYNAMIQUE') VALK='CHAR_CRIT'
         CALL U2MESG(KMSG//'+','ALGELINE5_79',1,VALK,2,VALI,0,0.D0)
         IF (KMSG .EQ. 'A') CALL U2MESK(KMSG//'+','ALGELINE5_80',1,VALK)
         CALL U2MESK(KMSG,'ALGELINE5_81',1,VALK)
       ENDIF  

C --- 5. TRI (DANS LE SPECTRE ET DE PRESENTATION) DES VALEURS PROPRES-
      CALL WPORDO(1,SHIFT,VPR,VPI,VECP,NBFRGA,NEQ)
      CALL WPORDO(0,SHIFT,VPR,VPI,VECP,NBFREQ,NEQ)

C --- 5. PREPARATION DE RESUFR
      DO 30 J = 1, NBFREQ
         AM          = VPR(J)**2
         OM          = VPI(J)**2
         RESUFI(J,1) = J
         RESUFR(J,2) = OM
         RESUFR(J,3) = -VPR(J)/SQRT(OM + AM)
30    CONTINUE

C --- 6. DESTRUCTION DES OJB TEMPORAIRES
      IF ( OPT .EQ. 'CENTRE' ) THEN
         CALL JEDETR('&&WP3VEC.VEC.AUX.C1')
         CALL JEDETR('&&WP3VEC.VEC.AUX.C2')
      ENDIF
      CALL JEDETR('&&WP3VEC.INDIC.PART.VP')

      CALL JEDEMA()
      END
