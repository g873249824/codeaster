      SUBROUTINE NXDOMT (PARMEI,PARMER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
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
      INTEGER            PARMEI(2)
      REAL*8                    PARMER(2)
C ----------------------------------------------------------------------
C     SAISIE DES DONNEES DE LA METHODE DE RESOLUTION
C
C OUT PARMEI  : PARAMETRES ENTIERS DE LA METHODE
C               PARMEI(1) = REAC_ITER
C               PARMEI(2) = ITER_LINE_MAXI
C OUT PARMER  : PARAMETRES REELS DE LA METHODE
C               PARMER(1) = PARM_THETA
C               PARMER(2) = RESI_LINE_RELA
C
C ----------------------------------------------------------------------
      INTEGER            IOCC,N1
      REAL*8             THETA
      INTEGER      IARG
C DEB ------------------------------------------------------------------
C
      CALL GETVR8(' ','PARM_THETA',0,IARG,1,THETA,N1)
      IF ( (THETA.LT.0.0D0).OR.(THETA.GT.1.0D0) ) THEN
        CALL U2MESS('F','ALGORITH9_4')
      ENDIF
      PARMER(1) = THETA
C
      CALL GETFAC('NEWTON',IOCC)
      IF ( IOCC .EQ. 1 ) THEN
        CALL GETVIS('NEWTON','REAC_ITER',1,IARG,1,PARMEI(1),N1)
        CALL ASSERT(PARMEI(1).GE.0)
C
        CALL GETVR8('NEWTON','RESI_LINE_RELA',1,IARG,1,PARMER(2),N1)
        CALL GETVIS('NEWTON','ITER_LINE_MAXI',1,IARG,1,PARMEI(2),N1)
      ENDIF
C FIN ------------------------------------------------------------------
      END
