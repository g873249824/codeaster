      SUBROUTINE RC32MA ( MATER )
      IMPLICIT   NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8       MATER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ------------------------------------------------------------------
C     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3200
C     TRAITEMENT DU CHAM_MATER
C     RECUPERATION POUR CHAQUE ETAT STABILISE
C          DE  E, NU, ALPHA    SOUS ELAS
C          DE  E_REFE          SOUS FATIGUE
C          DE  M_KE, N_KE, SM  SOUS RCCM
C
C     ------------------------------------------------------------------
C
      INTEGER       NBCMP, NBPA, NBPB, IOCC, NBSITU, NA, NB, NDIM,
     &              JVALA, JVALB, I,NBCMP2
      PARAMETER    ( NBCMP = 7, NBCMP2=NBCMP+1 )
      REAL*8        PARA(NBCMP), TEMPA, TEMPB,TKE
      INTEGER ICODRE(NBCMP)
      CHARACTER*8   NOPA, NOPB, TYPEKE, NOCMP(NBCMP)
      CHARACTER*16  PHENOM, MOTCLF
      INTEGER      IARG
C DEB ------------------------------------------------------------------
      CALL JEMARQ()
C
C    RECUP TYPE KE
      CALL GETVTX (' ', 'TYPE_KE', 0,IARG,1, TYPEKE, NB )
      IF (TYPEKE.EQ.'KE_MECA')THEN
         TKE=-1.D0
      ELSE
         TKE=1.D0
      ENDIF

      MOTCLF = 'SITUATION'
      CALL GETFAC ( MOTCLF, NBSITU )
C
      CALL RCCOME ( MATER, 'ELAS', PHENOM, ICODRE )
      IF (ICODRE(1).EQ.1) CALL U2MESK('F','POSTRCCM_7',1,'ELAS')
C
      CALL RCCOME ( MATER, 'FATIGUE', PHENOM, ICODRE )
      IF (ICODRE(1).EQ.1) CALL U2MESK('F','POSTRCCM_7',1,'FATIGUE')
C
      CALL RCCOME ( MATER, 'RCCM', PHENOM, ICODRE )
      IF (ICODRE(1).EQ.1) CALL U2MESK('F','POSTRCCM_7',1,'RCCM')
C
      NOCMP(1) = 'E'
      NOCMP(2) = 'NU'
      NOCMP(3) = 'ALPHA'
      NOCMP(4) = 'E_REFE'
      NOCMP(5) = 'SM'
      NOCMP(6) = 'M_KE'
      NOCMP(7) = 'N_KE'
C
C --- ON STOCKE 7 VALEURS : E, NU, ALPHA, E_REFE, SM, M_KE, N_KE
C     POUR LES 2 ETATS STABILISES DE CHAQUE SITUATION
C
      NDIM = NBCMP2 * NBSITU
      CALL WKVECT ( '&&RC3200.MATERIAU_A', 'V V R8', NDIM, JVALA )
      CALL WKVECT ( '&&RC3200.MATERIAU_B', 'V V R8', NDIM, JVALB )
C
      DO 10, IOCC = 1, NBSITU, 1
C
C ------ ETAT STABILISE "A"
C        ------------------
C
         CALL GETVR8 ( MOTCLF, 'TEMP_REF_A', IOCC,IARG,1, TEMPA, NA )
         IF ( NA .EQ. 0 ) THEN
            NBPA  = 0
            NOPA = ' '
            TEMPA = 0.D0
         ELSE
            NBPA  = 1
            NOPA = 'TEMP'
         ENDIF
C
         CALL RCVALE ( MATER, 'ELAS', NBPA, NOPA, TEMPA, 3,
     &                              NOCMP(1), PARA(1), ICODRE, 2)
C
         CALL RCVALE ( MATER, 'FATIGUE', NBPA, NOPA, TEMPA, 1,
     &                              NOCMP(4), PARA(4), ICODRE, 2)
C
         CALL RCVALE ( MATER, 'RCCM', NBPA, NOPA, TEMPA, 3,
     &                              NOCMP(5), PARA(5), ICODRE, 2)
C
         DO 12 I = 1 , NBCMP
            ZR(JVALA-1+NBCMP2*(IOCC-1)+I) = PARA(I)
 12      CONTINUE
         ZR(JVALA-1+NBCMP2*(IOCC-1)+8) = TKE
C
C ------ ETAT STABILISE "B"
C        ------------------
C
         CALL GETVR8 ( MOTCLF, 'TEMP_REF_B', IOCC,IARG,1, TEMPB, NB )
         IF ( NA .EQ. 0 ) THEN
            NBPB  = 0
            NOPB = ' '
            TEMPB = 0.D0
         ELSE
            NBPB  = 1
            NOPB = 'TEMP'
         ENDIF
C
         CALL RCVALE ( MATER, 'ELAS', NBPB, NOPB, TEMPB, 3,
     &                              NOCMP(1), PARA(1), ICODRE, 2)
C
         CALL RCVALE ( MATER, 'FATIGUE', NBPB, NOPB, TEMPB, 1,
     &                              NOCMP(4), PARA(4), ICODRE, 2)
C
         CALL RCVALE ( MATER, 'RCCM', NBPB, NOPB, TEMPB, 3,
     &                              NOCMP(5), PARA(5), ICODRE, 2)
C
         DO 14 I = 1 , NBCMP
            ZR(JVALB-1+NBCMP2*(IOCC-1)+I) = PARA(I)
 14      CONTINUE
         ZR(JVALB-1+NBCMP2*(IOCC-1)+8) = TKE
C
 10   CONTINUE
C
      CALL JEDEMA( )
      END
