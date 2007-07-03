      SUBROUTINE TE0439 ( OPTION, NOMTE )
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16        OPTION, NOMTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2007   AUTEUR FERNANDES R.FERNANDES 
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
C ----------------------------------------------------------------------
C
C     BUT:       POUR LES ELEMENTS QUASI-INCOMPRESSIBLES 2D , CALCUL DES
C                GRANDEURS EQUIVALENTES SUIVANTES
C                AUX NOEUDS :
C                    POUR LES DEFORMATIONS A PARTIR DE EPSI_ELNO_DEPL
C
C                DANS CET ORDRE :
C
C               . DEFORMATIONS EQUIVALENTES  :
C                        . SECOND INVARIANT             (= 1 VALEUR)
C                        . DEFORMATIONS PRINCIPALES     (= 3 VALEURS)
C                        . 2EME INV. * SIGNE (1ER.INV.) (= 1 VALEUR)
C
C     OPTION :  'EQUI_ELNO_EPSI'
C
C ----------------------------------------------------------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C     ------------------------------------------------------------------
      PARAMETER         ( NNOMAX = 27 , NEQMAX = 6 , NPGMAX = 27 )
      INTEGER            NNO, NPG, NNOS
      REAL*8             EQNO(NEQMAX*NNOMAX), SIGMA(6), DEFORM(6)
      REAL*8             EQPG(NEQMAX*NPGMAX)
C     ------------------------------------------------------------------

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
C
      IF ( OPTION(11:14) .EQ. 'EPSI' )  THEN
          NCEQ = 5
      ENDIF

      DO 10 I  = 1,NCEQ*NNO
          EQNO(I) = 0.0D0
 10   CONTINUE

C -   DEFORMATIONS EQUIVALENTES AUX NOEUDS :
C     ------------------------------------

      IF ( OPTION(11:14) .EQ. 'EPSI' )  THEN

         CALL JEVECH ( 'PDEFORR', 'L', IDEFO  )
         CALL JEVECH ( 'PDEFOEQ', 'E', IEQUIF )

         DO 100 INO = 1,NNO
            IDCP = (INO-1) * NCEQ
            DO 102 I = 1,4
               DEFORM(I) = ZR(IDEFO+(INO-1)*4+I-1)
 102        CONTINUE
            DEFORM(5) = 0.0D0
            DEFORM(6) = 0.0D0
            CALL FGEQUI ( DEFORM, 'EPSI', 2, EQNO(IDCP+1) )
 100     CONTINUE
       ELSE
         CALL U2MESK('F','CALCULEL6_10',1,OPTION)
C
      ENDIF
C
C
C -   STOCKAGE :
C     --------
        DO 300 INO = 1,NNO
           DO 310 J   = 1,NCEQ
              ZR(IEQUIF-1+(INO-1)*NCEQ+J) = EQNO((INO-1)*NCEQ+J)
 310       CONTINUE
 300    CONTINUE

      END
