      SUBROUTINE TRJEVE ( IFIC, NOCC )
      IMPLICIT   NONE
      INTEGER    IFIC, NOCC
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 10/10/2012   AUTEUR COURTOIS M.COURTOIS 
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
C ----------------------------------------------------------------------
C     COMMANDE:  TEST_RESU
C                MOT CLE FACTEUR "OBJET"
C ----------------------------------------------------------------------
      INTEGER      IOCC, REFI, REFIR, N1, N2, N2R, IRET
      REAL*8       EPSI, EPSIR, REFR, REFRR
      CHARACTER*3  SSIGNE
      CHARACTER*8  CRIT
      CHARACTER*16 TBTXT(2),TBREF(2)
      CHARACTER*24 NOMOBJ
      INTEGER      IARG
      LOGICAL      LREF
C     ------------------------------------------------------------------
C
      DO 100 IOCC = 1,NOCC
        CALL GETVTX('OBJET','NOM',       IOCC,IARG,1, NOMOBJ, N1 )
        CALL GETVTX('OBJET','VALE_ABS' , IOCC,IARG,1, SSIGNE, N1 )
        CALL GETVR8('OBJET','TOLE_MACHINE', IOCC,IARG,1, EPSI,   N1 )
        CALL GETVTX('OBJET','CRITERE',   IOCC,IARG,1, CRIT,   N1 )

        CALL UTEST3('OBJET',IOCC,TBTXT)
        LREF=.FALSE.
        CALL GETVR8('OBJET','PRECISION',IOCC,IARG,1,EPSIR,IRET)
        IF (IRET.NE.0) THEN
          LREF=.TRUE.
          TBREF(1)=TBTXT(1)
          TBREF(2)=TBTXT(2)
          TBTXT(1)='NON_REGRESSION'
        END IF

        WRITE (IFIC,*) '---- OBJET '
        WRITE (IFIC,*) '     ',NOMOBJ

        CALL GETVIS('OBJET','VALE_CALC_I',IOCC,IARG,1,REFI,N2)
        IF (N2.EQ.1) THEN
          CALL UTESTO(NOMOBJ,'I',TBTXT,REFI,REFR,
     &                EPSI,CRIT,IFIC,.TRUE.,SSIGNE)
          IF (LREF) THEN
            CALL GETVIS('OBJET','VALE_REFE_I',IOCC,IARG,1,REFIR,N2R)
            CALL ASSERT(N2.EQ.N2R)
            CALL UTESTO(NOMOBJ,'I',TBREF,REFIR,REFRR,
     &                  EPSIR,CRIT,IFIC,.FALSE.,SSIGNE)
          ENDIF
        END IF

        CALL GETVR8('OBJET','VALE_CALC',IOCC,IARG,1,REFR,N2)
        IF (N2.EQ.1) THEN
          CALL UTESTO(NOMOBJ,'R',TBTXT,REFI,REFR,
     &                EPSI,CRIT,IFIC,.TRUE.,SSIGNE)
          IF (LREF) THEN
            CALL GETVR8('OBJET','VALE_REFE',IOCC,IARG,1,REFRR,N2R)
            CALL ASSERT(N2.EQ.N2R)
            CALL UTESTO(NOMOBJ,'R',TBREF,REFIR,REFRR,
     &                  EPSIR,CRIT,IFIC,.FALSE.,SSIGNE)
          ENDIF
        END IF
        WRITE (IFIC,*)' '
 100  CONTINUE
C

      END
