      SUBROUTINE RVVSUP ( )
      IMPLICIT   NONE
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     ------------------------------------------------------------------
C     VERIFICATION SUPPLEMENTAIRE OP0051
C     ------------------------------------------------------------------
C
      INCLUDE 'jeveux.h'
      INTEGER      N1, N2, N3, N4, IOCC, NBPOST
      REAL*8       R8B
      CHARACTER*8  K8B, RESU, NOMRES
      CHARACTER*24 VALK(4)
      CHARACTER*16 NOMCMD, CONCEP, TYPRES
      INTEGER      IARG
C
C=======================================================================
C
      CALL JEMARQ()
      CALL GETRES(RESU,CONCEP,NOMCMD)
C
C     --- VERIFICATION SUR "OPERATION" ---
C
      CALL GETFAC ( 'ACTION', NBPOST )
C
      DO 10, IOCC = 1, NBPOST, 1
C
C     /* QUANTITE (IE : SOMME) */
         CALL GETVTX('ACTION','RESULTANTE',IOCC,IARG,0,K8B,N1)
         N1 = -N1
         IF ( N1 .GT. 0 ) THEN
            CALL GETVTX('ACTION','RESULTANTE',IOCC,IARG,0,K8B,N1)
            CALL GETVTX('ACTION','MOMENT    ',IOCC,IARG,0,K8B,N2)
            N1 = -N1
            N2 = -N2
            IF ( N2 .NE. 0 ) THEN
               IF (((N1.NE.2).AND.(N1.NE.3)) .OR. (N1.NE.N2)) THEN
                  CALL U2MESI('F','POSTRELE_42',1,IOCC)
               ENDIF
               CALL GETVR8('ACTION','POINT',IOCC,IARG,0,R8B,N1)
               N1 = -N1
               IF ( (N1.NE.2) .AND. (N1.NE.3) ) THEN
                  CALL U2MESI('F','POSTRELE_43',1,IOCC)
               ENDIF
            ENDIF
         ENDIF
C
C     /* COHERENCE ACCES DANS RESULTAT */
         CALL GETVID('ACTION','RESULTAT',IOCC,IARG,0,NOMRES,N1)
         N1 = -N1
         IF ( N1 .GT. 0 ) THEN
            CALL GETVID('ACTION','RESULTAT',IOCC,IARG,1,NOMRES,N1)
            CALL GETTCO(NOMRES,TYPRES)
            CALL GETVID('ACTION','LIST_FREQ',IOCC,IARG,0,K8B,N1)
            CALL GETVR8('ACTION','FREQ'     ,IOCC,IARG,0,ZR, N2)
            N1 = MAX(-N1,-N2)
            CALL GETVID('ACTION','LIST_INST',IOCC,IARG,0,K8B,N2)
            CALL GETVR8('ACTION','INST'     ,IOCC,IARG,0,ZR, N3)
            N2 = MAX(-N3,-N2)
            CALL GETVID('ACTION','LIST_MODE',IOCC,IARG,0,K8B,N3)
            CALL GETVIS('ACTION','NUME_MODE',IOCC,IARG,0,ZI, N4)
            N3 = MAX(-N3,-N4)
            N4 = MAX(N1,N2,N3)
            IF ( N4 .GT. 0 ) THEN
               IF ( ((N1 .NE. 0).OR.(N3 .NE. 0)) .AND.
     +             ((TYPRES(1:4) .EQ. 'EVOL') .OR.
     +              (TYPRES(6:10) .EQ. 'TRANS') .OR.
     +              (TYPRES(11:15) .EQ. 'TRANS') ) ) THEN
                  VALK (1) = NOMRES
                  VALK (2) = TYPRES
                  VALK (3) = 'FREQ'
                  VALK (4) = 'MODE'
                  CALL U2MESG('F','POSTRELE_44',4,VALK,1,IOCC,0,0.D0)
               ENDIF
               IF ( (N2 .NE. 0) .AND.
     +             ((TYPRES(1:4)   .EQ. 'MODE' ) .OR.
     +              (TYPRES(1:4)   .EQ. 'BASE' ) .OR.
     +              (TYPRES(6:10)  .EQ. 'HARMO') .OR.
     +              (TYPRES(11:15) .EQ. 'HARMO') ) ) THEN
                  VALK (1) = NOMRES
                  VALK (2) = TYPRES
                  VALK (3) = 'INSTANT'
                  CALL U2MESG('F','POSTRELE_45',3,VALK,1,IOCC,0,0.D0)
               ENDIF
            ENDIF
         ENDIF
C
 10   CONTINUE
C
      CALL JEDEMA()
      END
