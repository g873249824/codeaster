      SUBROUTINE MLNCMJ
     %           (NB,N,P,FRONTL,FRONTU,FRNL,FRNU,ADPER,T1,T2,CL,CU)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 28/06/2004   AUTEUR ROSE C.ROSE 
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
C
C     VERSION AVEC APPEL A DGEMV POUR LES PRODUITS MATRICE-VECTEUR
C     AU DELA D' UN CERTAIN SEUIL
C     DGEMV EST APPEL A T1ERS LA FONCTION C DGEMW POUR CAR DGEMV
C     NECESSITE  DES ARGUMENTS ENTIER INTEGER*4 REFUSES PAR ASTER
C
      IMPLICIT NONE
      INTEGER N,P,ADPER(*),RESTM,DECAL
      COMPLEX*16  FRONTL(*),FRONTU(*),FRNL(*),FRNU(*)
      INTEGER SEUIN,SEUIK,LDA,NMB
      CHARACTER*1 TRANSA, TRANSB
      INTEGER I1,J1,K,M,IT,NB,NUMPRC,MLNUMP
      COMPLEX*16  T1(P,NB,*),T2(P,NB,*)
      COMPLEX*16   CL(NB, NB, *),CU(NB, NB, *)
      INTEGER SNI,I,KB,J,IB,IA,IND,ADD
      M=N-P
      NMB=M/NB
      RESTM = M -(NB*NMB)
      DECAL = ADPER(P+1) - 1
C
C$OMP PARALLEL DO DEFAULT(PRIVATE)
C$OMP+SHARED(N,M,P,NMB,NB,RESTM,FRONTL,FRONTU,ADPER,DECAL,FRNL,FRNU)
C$OMP+SHARED(T1,T2,CL,CU)
C$OMP+SCHEDULE(STATIC,1)
      DO 1000 KB = 1,NMB
      NUMPRC=MLNUMP()
C     K : INDICE DE COLONNE DANS LA MATRICE FRONTALE (ABSOLU DE 1 A N)
         K = NB*(KB-1) + 1 +P
         DO 100 I=1,P
            ADD= N*(I-1) + K
            DO 50 J=1,NB
               T1(I,J,NUMPRC) = FRONTU(ADD)
               T2(I,J,NUMPRC) = FRONTL(ADD)
               ADD = ADD + 1
 50         CONTINUE
 100     CONTINUE
C     BLOC DIAGONAL

C     SOUS LE BLOC DIAGONAL
C     2EME ESSAI : DES PRODUITS DE LONGUEUR NB
C
         DO 500 IB = KB,NMB
            IA = K + NB*(IB-KB)
            IT=1
            CALL CGEMX( NB,NB,P,FRONTL(IA),N, T1(IT,1,NUMPRC), P,
     %                   CL(1,1,NUMPRC), NB)
            CALL CGEMX( NB,NB,P,FRONTU(IA),N, T2(IT,1,NUMPRC), P,
     %                   CU(1,1,NUMPRC), NB)
C     RECOPIE

C
            DO 501 I=1,NB
               I1=I-1
C     IND = ADPER(K +I1) - DECAL  + NB*(IB-KB-1) +NB - I1
               IF(IB.EQ.KB) THEN
                  J1= I
                  IND = ADPER(K + I1) - DECAL
               ELSE
                  J1=1
                  IND = ADPER(K + I1) - DECAL + NB*(IB-KB)  - I1
               ENDIF
               DO 502J=J1,NB
                  FRNL(IND) = FRNL(IND) +CL(J,I,NUMPRC)
                  FRNU(IND) = FRNU(IND) +CU(J,I,NUMPRC)
                  IND = IND +1
 502           CONTINUE
 501        CONTINUE
 500     CONTINUE
C
         IF(RESTM.GT.0) THEN
            IB = NMB + 1
            IA = K + NB*(IB-KB)
            IT=1
            CALL CGEMX( RESTM,NB,P,FRONTL(IA),N, T1(IT,1,NUMPRC), P,
     %                   CL(1,1,NUMPRC), NB)
            CALL CGEMX( RESTM,NB,P,FRONTU(IA),N, T2(IT,1,NUMPRC), P,
     %                   CU(1,1,NUMPRC), NB)
C     RECOPIE

C
            DO 801 I=1,NB
               I1=I-1
C     IND = ADPER(K +I1) - DECAL  + NB*(IB-KB-1) +NB - I1
               J1=1
               IND = ADPER(K + I1) - DECAL + NB*(IB-KB)  - I1
               DO 802 J=J1,RESTM
                  FRNL(IND) = FRNL(IND) +CL(J,I,NUMPRC)
                  FRNU(IND) = FRNU(IND) +CU(J,I,NUMPRC)
                  IND = IND +1
 802              CONTINUE
 801           CONTINUE
C
C
         ENDIF
 1000 CONTINUE
C$OMP END PARALLEL DO
      NUMPRC=1
      IF(RESTM.GT.0 ) THEN
         KB = 1+NMB
C     K : INDICE DE COLONNE DANS LA MATRICE FRONTLALE (ABSOLU DE 1 A N)
         K = NB*(KB-1) + 1 +P
         DO 101 I=1,P
            ADD= N*(I-1) + K
            DO 51 J=1,RESTM
              T1(I,J,1) = FRONTU(ADD)
              T2(I,J,1) = FRONTL(ADD)
               ADD = ADD + 1
 51         CONTINUE
 101     CONTINUE
C     BLOC DIAGONAL

         IB = KB
         IA = K + NB*(IB-KB)
         IT=1
           CALL CGEMX( RESTM,RESTM,P,FRONTL(IA),N, T1(IT,1,1),P,
     %                   CL(1,1,NUMPRC), NB)
           CALL CGEMX( RESTM,RESTM,P,FRONTU(IA),N, T2(IT,1,1),P,
     %                   CU(1,1,NUMPRC), NB)
C     RECOPIE

C
         DO 902 I=1,RESTM
            I1=I-1
C     IND = ADPER(K +I1) - DECAL  + NB*(IB-KB-1) +NB - I1
            J1= I
            IND = ADPER(K + I1) - DECAL

            DO 901 J=J1,RESTM

               FRNL(IND) = FRNL(IND) +CL(J,I,NUMPRC)
               FRNU(IND) = FRNU(IND) +CU(J,I,NUMPRC)
               IND = IND +1
 901        CONTINUE
 902     CONTINUE

      ENDIF
      END
