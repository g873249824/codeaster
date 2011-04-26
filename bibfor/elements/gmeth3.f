      SUBROUTINE GMETH3(MODELE,NNOFF,FOND,
     &                 GTHI,MILIEU,GS,OBJCUR,GI,NUM,GXFEM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
C
      INTEGER         NNOFF,NUM
      REAL*8          GTHI(1),GS(1),GI(1),OBJCUR(*)
      CHARACTER*8     MODELE
      CHARACTER*24    FOND
      LOGICAL         MILIEU,GXFEM
C
C ......................................................................
C      METHODE THETA-LAGRANGE ET G-LAGRANGE POUR LE CALCUL DE G(S)
C
C ENTREE
C
C     MODELE   --> NOM DU MODELE
C     NNOFF    --> NOMBRE DE NOEUDS DU FOND DE FISSURE
C     FOND     --> NOMS DES NOEUDS DU FOND DE FISSURE
C     GTHI     --> VALEURS DE G POUR LES CHAMPS THETAI
C     MILIEU   --> .TRUE.  : ELEMENT QUADRATIQUE
C                  .FALSE. : ELEMENT LINEAIRE
C     OBJCUR  --> ABSCISSES CURVILIGNES S
C
C  SORTIE
C
C      GS      --> VALEUR DE G(S)
C      GI      --> VALEUR DE GI
C      NUM     --> 3 (LAGRANGE-LAGRANGE)
C              --> 4 (NOEUD-NOEUD)
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
C
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
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER      I,KK,IADRNO
      INTEGER      IMATR,IVECT,IBID
C
      REAL*8       DELTA,S1,S2,S3
C
      CHARACTER*24 VECT,MATR,LISSG
C
      LOGICAL      CONNEX
C
C OBJET DECRIVANT LE MAILLAGE
C
C SI LE FOND DE FISSURE EST FERME (DERNIER NOEUD = PREMIER NOEUD)
C CONNEX = TRUE
C
      CONNEX = .FALSE.
      IF (.NOT. GXFEM) THEN
        CALL JEVEUO (FOND,'L',IADRNO)
        IF (ZK8(IADRNO+1-1).EQ.ZK8(IADRNO+NNOFF-1))  CONNEX = .TRUE.
      ENDIF
C
      CALL GETVTX('LISSAGE', 'LISSAGE_G',1,1,1,LISSG,IBID)
C
      IF (LISSG.EQ.'LAGRANGE_NO_NO') THEN
        VECT = '&&METHO3.VECT'
        CALL WKVECT(VECT,'V V R8',NNOFF,IVECT)
        NUM = 4
C
        IF (MILIEU) THEN
          DO 10 I=1,NNOFF-2,2
            S1 = OBJCUR(I)
            S3 = OBJCUR(I+2)
            DELTA = (S3-S1)/6.D0
            ZR(IVECT+I  -1)= ZR(IVECT+I-1) + DELTA
            ZR(IVECT+I+1-1)= 4.D0*DELTA
            ZR(IVECT+I+2-1)= DELTA
10        CONTINUE
          IF (CONNEX) THEN
            ZR(IVECT+NNOFF-1)= ZR(IVECT+NNOFF-1) + ZR(IVECT+1-1)
            ZR(IVECT+1    -1)= ZR(IVECT+NNOFF-1)
          ENDIF
        ELSE
          DO 20 I=1,NNOFF-1
            S1 = OBJCUR(I)
            S2 = OBJCUR(I+1)
            DELTA = (S2-S1)/3.D0
            ZR(IVECT+I  -1)= ZR(IVECT+I-1) + DELTA
            ZR(IVECT+I+1-1)= 2.D0*DELTA
20        CONTINUE
          IF (CONNEX) THEN
            ZR(IVECT+NNOFF-1)= ZR(IVECT+NNOFF-1) + ZR(IVECT+1-1)
            ZR(IVECT+1    -1)= ZR(IVECT+NNOFF-1)
          ENDIF
        ENDIF
        DO 30 I=1,NNOFF
          GI(I) = GTHI(I)/ZR(IVECT+I-1 )
30      CONTINUE
C
      ELSEIF (LISSG.EQ.'LAGRANGE') THEN
        MATR = '&&METHO3.MATRI'
        CALL WKVECT(MATR,'V V R8',NNOFF*NNOFF,IMATR)
        NUM = 3
C
        IF (MILIEU) THEN
          DO 100 I=1,NNOFF-2,2
            S1 = OBJCUR(I)
            S3 = OBJCUR(I+2)
            DELTA = (S3-S1)/30.D0
C
            KK = IMATR+(I-1  )*NNOFF+I-1
            ZR(KK )= ZR(KK) +               4.D0*DELTA
            ZR(IMATR+(I-1+1)*NNOFF+I-1  )=  2.D0*DELTA
            ZR(IMATR+(I-1+2)*NNOFF+I-1  )= -1.D0*DELTA
C
            ZR(IMATR+(I-1  )*NNOFF+I-1+1)=  2.D0*DELTA
            ZR(IMATR+(I-1+1)*NNOFF+I-1+1)= 16.D0*DELTA
            ZR(IMATR+(I-1+2)*NNOFF+I-1+1)=  2.D0*DELTA
C
            ZR(IMATR+(I-1  )*NNOFF+I-1+2)= -1.D0*DELTA
            ZR(IMATR+(I-1+1)*NNOFF+I-1+2)=  2.D0*DELTA
            ZR(IMATR+(I-1+2)*NNOFF+I-1+2)=  4.D0*DELTA
100       CONTINUE
          IF (CONNEX) THEN
            KK = IMATR+(1-1  )*NNOFF+1-1
            ZR(KK )= ZR(KK) + 5.D0*DELTA
            S1 = OBJCUR(1)
            S3 = OBJCUR(3)
            DELTA = (S3-S1)/30.D0
            KK = IMATR+(NNOFF-1)*NNOFF+NNOFF-1
            ZR(KK )= ZR(KK) + 5.D0*DELTA
          ENDIF
        ELSE
          DO 120 I=1,NNOFF-1
            S1 = OBJCUR(I)
            S2 = OBJCUR(I+1)
            DELTA = (S2-S1)/6.D0
C
            KK = IMATR+(I-1  )*NNOFF+I-1
            ZR(KK )= ZR(KK) +               2.D0*DELTA
            ZR(IMATR+(I-1+1)*NNOFF+I-1  )=  1.D0*DELTA
C
            ZR(IMATR+(I-1  )*NNOFF+I-1+1)=  1.D0*DELTA
            ZR(IMATR+(I-1+1)*NNOFF+I-1+1)=  2.D0*DELTA
120       CONTINUE
          IF (CONNEX) THEN
            KK = IMATR+(1-1  )*NNOFF+1-1
            ZR(KK )= ZR(KK) + 3.D0*DELTA
            S1 = OBJCUR(1)
            S3 = OBJCUR(3)
            DELTA = (S3-S1)/6.D0
            KK = IMATR+(NNOFF-1)*NNOFF+NNOFF-1
            ZR(KK )= ZR(KK) + 3.D0*DELTA
          ENDIF
        ENDIF
C
C  SYSTEME LINEAIRE:  MATR*GI = GTHI
C
        CALL GSYSTE(MATR,NNOFF,NNOFF,GTHI,GI)
      ENDIF
C
      DO 200 I=1,NNOFF
        GS(I) = GI(I)
200   CONTINUE
C
      CALL JEDETR('&&METHO3.MATRI')
      CALL JEDETR('&&METHO3.VECT')
C
      END
