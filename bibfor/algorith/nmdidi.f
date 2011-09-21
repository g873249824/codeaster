      SUBROUTINE NMDIDI(MODELE,LISCHA,DEPMOI,VEDIDI)
C
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
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*19  LISCHA,VEDIDI
      CHARACTER*24  MODELE
      CHARACTER*19  DEPMOI
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL)
C
C CALCUL DES VECT_ELEM POUR DIRICHLET DIFFERENTIEL
C      
C ----------------------------------------------------------------------
C
C
C IN  MODELE : MODELE
C IN  LISCHA : SD L_CHARGES
C IN  DEPMOI : DEPLACEMENTS EN T-
C IN  VEDIDI : VECT_ELEM DES DIDI
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      NUMREF, N1, NEVO, IRET
      CHARACTER*19 DEPDID
      CHARACTER*24 EVOL
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()                         
C
C --- CONSTRUCTION DE LA CONFIGURATION DE REFERENCE
C 
      DEPDID = DEPMOI
      CALL GETVIS('ETAT_INIT','NUME_DIDI',1,IARG,1,NUMREF,N1)
      CALL GETVID('ETAT_INIT','EVOL_NOLI',1,IARG,1,EVOL,NEVO)
      IF ((N1.GT.0) .AND. (NEVO.GT.0)) THEN
        CALL RSEXCH(EVOL,'DEPL',NUMREF,DEPDID,IRET)
        IF (IRET.NE.0) CALL U2MESK('F','ALGORITH7_20',1,EVOL)
      END IF
C
C --- CALCUL DES VECT_ELEM
C
      CALL VECDID(MODELE,LISCHA,DEPDID,VEDIDI)
C
      CALL JEDEMA()
      END
