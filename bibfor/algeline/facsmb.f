      SUBROUTINE FACSMB(NBND,NBSN,SUPND,INVSUP,PARENT,XADJ,ADJNCY,ANC,
     +     NOUV,FILS,FRERE,LOCAL,GLOBAL,
     +     ADRESS,LFRONT,NBLIGN,LGSN,DEBFAC,DEBFSN,CHAINE,
     +     PLACE,NBASS,DELG,LGIND,IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
C RESPONSABLE JFBHHUC C.ROSE
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
C     TOLE CRP_21
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER NBND,NBSN,LGIND,NBND1
      INTEGER SUPND(NBSN+1),INVSUP(NBND),PARENT(NBSN)
      INTEGER XADJ(NBND+1),ADJNCY(*)
      INTEGER ANC(NBND),NOUV(NBND),FILS(NBSN),FRERE(NBSN),DELG(NBND)
      INTEGER GLOBAL(LGIND),LOCAL(LGIND),ADRESS(NBSN+1),DEBFSN(NBSN+1)
      INTEGER LFRONT(NBSN),NBLIGN(NBSN),LGSN(NBSN),DEBFAC(NBND+1),IER
C
C================================================================
C     FACTORISATION SYMBOLIQUE POUR LA MULTIFRONTALE
C     PRISE EN COMPTE DES DDL LAGRANGE  D'ASTER
C     UTILISATION D'UNE LISTE CHAINEE ORDONNEE
C     POUR RANGER LA LISTE  DES NOEUDS ET DES VOISINS D'UN  SUPERNOEUD
C----------------------------------------------
C
C     3 CAS
C     I) LE SND A SON PREMIER DDL NON LAGRANGE : CAS STANDARD ,
C     ON MET SES VOISINS DANS LA CHAINE. SI UN  DES NDS DU SND
C     EST DANS UNE RELATION LINEAIRE,ON MET LAMBDA2
C     DANS LA CHAINE (79)
C     II) LE PREMIER EST UN DDL LAGRANGE DE BLOQUAGE
C     ON MET DANS LA CHAINE
C     TOUS LES LAGRANGES DU SUPERNOEUD,
C     (LBD1 DE BLOCS ET TOUS LES LBD2)
C     ON CHERCHE PRMNDI 1ER ND NON LAGRANGE DU SND
C     ,ET ON MET PRMNDI ET SES VOISINS DANS LA CHAINE
C     III) C'EST UN SND LBD1 DE RELATION LINEAIRE:
C     IL EST MIS DANS LA CHAINE,
C     AINSI QUE LES NDS DE LA RELATION LINEAIRE ET LE LAMBDA2
C-------------------------------------------------------------
C     MODIFICATION DU 15/09/98
C     AMDBAR A L' AIR DE FAIRE DANS CERTAINS CAS DE L'AMALGAMME I.E.
C     CERTAINS SUPERNOEUDS SONT REGROUPES EN UN SEUL AU PRIX DE CERTAINS
C     ZEROS. IL FAUT ALORS METTRE DANS LA LISTE CHAINEE, LES VOISINS DE
C     TOUS LES NOEUDS DU SN ET NON PLUS CEUX DU PREMIER NOEUD COMME
C     AUPPARAVANT. (ON POUVAIT EN OUBLIER)
C     LE TABLEAU PLACE SERT DE FLAG DANS CETTE INSERTION
C     AFIN DE GAGNER UN PEU DE TEMPS, CAR LA PLUPART DES INSERTIONS
C     SONT REDONDANTES.
C---------------------------------------------------------------
C     SOUS-PROGRAMME APPELLE : INSCHN
C==================================================================
      INTEGER CHAINE(NBND),PLACE(NBND),NBASS(NBSN)
      INTEGER I,K,J,ND,NDJ,P,SNI,ANDI,SN,L,SUIV,COUR
      INTEGER IND,NDK,NDI,PRMNDI,IDDL2,NNDI,IANC,DLI
      INTEGER J1,J2,IFM,NIV,LONG,DECAL
      CALL INFNIV(IFM,NIV)
      IER =0
C     CALCUL DE INVSUP FILS ET FRERE
      DO 120 I = 1,NBSN
         PLACE(I) = 0
         FILS(I) = 0
         FRERE(I) = 0
         LGSN(I) = SUPND(I+1) - SUPND(I)
         DO 110 J = SUPND(I),SUPND(I+1) - 1
            INVSUP(J) = I
 110     CONTINUE
 120  CONTINUE
      DO 130 ND = 1,NBSN
         P = PARENT(ND)
         IF (P.NE.0) THEN
            IF (FILS(P).EQ.0) THEN
               FILS(P) = ND
               PLACE(P) = ND
            ELSE
               FRERE(PLACE(P)) = ND
               PLACE(P) = ND
            END IF
         END IF
 130  CONTINUE

C     
      DECAL = 0
      ADRESS(1) = 1
      DEBFAC(1) = 1
      DO 140 SNI = 1,NBSN
         LGSN(SNI) = SUPND(SNI+1) - SUPND(SNI)
 140  CONTINUE
C     
      ADRESS(1) = 1
      DEBFAC(1) = 1
      NBND1 = NBND+1
      DO 310 SNI = 1,NBSN
         NDI = SUPND(SNI)
         DO 311,I=NDI,NBND
            PLACE(I)=0
 311     CONTINUE
         ANDI = ANC(NDI)
         CHAINE(NDI) = NBND1
         DLI=NDI
C     LES TERMES INITIAUX DE LA MATRICE SONT MIS DANS LA CHAINE
C     QUE LE DDL ORDINAIRE OU LAGRANGE
         CALL INSCHN(ANDI,DLI,XADJ,ADJNCY,CHAINE,NOUV,PLACE)
         IF (DELG(ANDI).EQ.0) THEN
C--------------------------------------------------------------
C     1 .....................................   NDI EST UN DDL ORDINAIRE
C     
C     ON INSERE AUSSI DANS LA CHAINE LES VOISINS INITIAUX DE TOUTES
C     INCONNNUES DU SUPERNOEUD, AU CAS OU LA RENUMEROTATION
C     FASSE DE L'AMALGAME.
C--------------------------------------------------------------
            DO 152 DLI=NDI+1, SUPND(SNI+1)-1
               ANDI = ANC(DLI)
               IF(DELG(ANDI).NE.0) GOTO 151
               CALL INSCHN(ANDI,DLI,XADJ,ADJNCY,CHAINE,NOUV,PLACE)
 152        CONTINUE
 151        CONTINUE
         ENDIF
C-------------------------------------------------------------
C     
C     LES NOEUDS VOISINS DES FILS SONT MIS DANS LA CHAINE
C-------------------------------------------------------------
         SN = FILS(SNI)
 230     CONTINUE
C        DO WHILE (SN.NE.0)
         IF (SN.NE.0) THEN
C           K = ADRESS(SN) + LGSN(SN) + 1 CORRECTION DU 15/03/02
            K = ADRESS(SN) + LGSN(SN) 
            IND = 1
            ND = NDI
 240        CONTINUE
C     DO WHILE (K.LT.ADRESS(SN+1))
            IF (K.LT.ADRESS(SN+1)) THEN
               NDK = GLOBAL(K)
               IF(NDK.GT.NDI) THEN
                  SUIV= ND
 235              CONTINUE
                  IF(SUIV.LT.NDK) THEN
C     DO WHILE(SUIV.LT.NDK)
                     COUR = SUIV
                     SUIV = CHAINE(COUR)
                     GOTO 235
                  ENDIF
                  IF( SUIV.GT.NDK) THEN
                     CHAINE(COUR) = NDK
                     CHAINE(NDK) = SUIV
                     PLACE(NDK) = 1
                  ENDIF
                  ND = NDK
               ENDIF
               K = K + 1
               GO TO 240
C     FIN DO WHILE
            END IF
            SN = FRERE(SN)
            GO TO 230
C     FIN DO WHILE
         END IF
         K = 0
         IND = NDI
C     DO WHILE (IND.NE.NBND1) ( FIN DE LA CHAINE)
 280     CONTINUE
         IF (IND.NE.NBND1) THEN
C-------------------------------------------------------------
C     VERIFICATION DE LA LONGUEUR DE GLOBAL
C-------------------------------------------------------------
            IF ((ADRESS(SNI)+K).GT.LGIND) THEN
               IER = LGIND*2
               IF(NIV.GE.1) THEN
               WRITE(IFM,*) 'LONGUEUR DE GLOBAL PEUT ETRE INSUFFISANTE '
               WRITE(IFM,*) 'LONGUEUR ALLOUEE :',LGIND
               WRITE(IFM,*) 'ON REITERE AVEC :',IER
               ENDIF
               GOTO 999
            END IF
            GLOBAL(K+ADRESS(SNI)) = IND
            PLACE(GLOBAL(K+ADRESS(SNI))) = K + 1
            K = K + 1
            IND = CHAINE(IND)
            GO TO 280
C     FIN DO WHILE
         END IF
         ADRESS(SNI+1) = K + ADRESS(SNI)
C...........................................
         SN = FILS(SNI)
C     DO WHILE (SN.NE.0)
 290     CONTINUE
         IF (SN.NE.0) THEN
            CALL MLTALC(LOCAL,GLOBAL,ADRESS,SN,LGSN,PLACE,SNI,SUPND,
     +           NBASS(SN))

            SN = FRERE(SN)
            GO TO 290
C     FIN DO WHILE
         END IF
         NBLIGN(SNI) = ADRESS(SNI+1) - ADRESS(SNI)
         LFRONT(SNI) = NBLIGN(SNI) - LGSN(SNI)
         LONG = NBLIGN(SNI)
C     ANCIENNE VERSION SANS DGEMV
C     DO 300 K = SUPND(SNI),SUPND(SNI+1) - 1
C     DEBFAC(K+1) = DEBFAC(K) + L
C     L = L - 1
C     300     CONTINUE
C     MODIFS POUR DGEMV
         DO 300 K = 1,LGSN(SNI)
            ND=SUPND(SNI) + K-1
            DEBFAC( ND ) = DECAL +K
            DECAL = DECAL+LONG
 300     CONTINUE
         DEBFSN(SNI) = DEBFAC(SUPND(SNI))
 310  CONTINUE
      DEBFAC(NBND+1)=DECAL+1
      DEBFSN(NBSN+1) = DEBFAC(NBND+1)
      IF (NIV.GE.1) THEN
         WRITE(IFM,*)'   --- LONGUEUR DE LA MATRICE FACTORISEE ',DECAL
      ENDIF
 999  CONTINUE
      END
