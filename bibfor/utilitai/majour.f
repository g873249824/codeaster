      SUBROUTINE MAJOUR(NEQ   ,LGROT ,LENDO ,SDNUME,CHAINI,
     &                  CHADEL,COEF  ,CHAMAJ,ORDRE)
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 15/02/2011   AUTEUR FLEJOU J-L.FLEJOU 
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
C
      IMPLICIT NONE
      CHARACTER*19  SDNUME
      LOGICAL       LGROT,LENDO
      INTEGER       NEQ,ORDRE
      REAL*8        CHAINI(*),CHADEL(*),CHAMAJ(*),COEF                  
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - UTILITAIRE - STATIQUE)
C
C MET A JOUR LES CHAM_NO DES DEPLACEMENTS 
C      
C ----------------------------------------------------------------------
C 
C
C CHAMAJ = CHAINI + COEF*CHADEL.
C   POUR LES TRANSLATIONS ET LES PETITES ROTATIONS, ON APPLIQUE
C   LA FORMULE PRECEDENTE A LA LETTRE.
C   POUR LES GRANDES ROTATIONS, LE VECTEUR-ROTATION DE CHAMAJ
C   EST CELUI DU PRODUIT DE LA ROTATION DEFINIE DANS CHAINI PAR
C   COEF FOIS L'INCREMENT DE ROTATION DEFINI DANS CHADEL.
C
C IN  NEQ    : LONGUEUR DES CHAM_NO
C IN  SDNUME : SD NUMEROTATION
C IN  LGROT  : TRUE  S'IL Y A DES DDL DE GRDE ROTATION
C                       FALSE SINON
C IN  CHAINI : CHAM_NO DONNE
C IN  CHADEL : CHAM_NO DONNE
C IN  COEF   : REEL DONNE
C IN  ORDRE  : 0 -> MAJ INCREMENTS
C              1 -> MAJ DEPL
C OUT CHAMAJ : CHAM_NO MIS A JOUR
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      IRAN(3),I,ICOMP,INDRO,ENDO
      REAL*8       THETA(3),DELDET(3)
      INTEGER      PTDO,INDIC1,INDIC2
      REAL*8       STOK
      REAL*8       ZERO
      PARAMETER   (ZERO = 0.0D+0)      
C      
C ----------------------------------------------------------------------
C	  
      PTDO = 0
      INDIC1 = 0
      INDIC2 = 0      
C
      CALL JEMARQ()
C      
      IF (LGROT) THEN
        CALL JEVEUO(SDNUME//'.NDRO','L',INDRO)
      ENDIF      
C      
      IF (LENDO) THEN
        CALL JEVEUO(SDNUME(1:19)//'.ENDO','E',ENDO)
      ENDIF                    
C
      IF (.NOT.LGROT .AND. LENDO) THEN
        DO 10 I=1,NEQ
          STOK      = CHAINI(I)
          CHAMAJ(I) = CHAINI(I) + COEF*CHADEL(I)
          IF (ZI(ENDO+I-1) .NE. 0) THEN
C
C           ON IMPOSE L'ACCROISSEMENT DE L'ENDO
C            
            IF (ORDRE.EQ.0) THEN
              IF (CHAMAJ(I).LE.ZERO) THEN
                INDIC1 = INDIC1+1
                CHAMAJ(I) = 0.D0
                CHADEL(I) = - STOK/COEF
                ZI(ENDO+I-1)=2
              ELSE
                ZI(ENDO+I-1)=1
                PTDO = PTDO+1
              ENDIF
            ENDIF
C
C           ON IMPOSE L'ENDO <= 1
C              
            IF (ORDRE.EQ.1) THEN
              IF (CHAMAJ(I).GE.1.D0) THEN
                INDIC2 = INDIC2+1
                CHAMAJ(I) = 1.D0
                CHADEL(I) = (1.D0-STOK)/COEF
              ENDIF
            ENDIF
C
          ENDIF
C          
10      CONTINUE

C        IF (ORDRE.EQ.0) THEN
C          WRITE(6,*) 'NB_NO_ENDO=', PTDO
C          WRITE(6,*) 'INDIC1=', INDIC1
C          WRITE(6,*) 'INDIC2=', INDIC2
C        ENDIF  
C
      ELSEIF (.NOT.LGROT) THEN
        DO 20 I=1,NEQ
          CHAMAJ(I) = CHAINI(I) + COEF*CHADEL(I)
20      CONTINUE
      ELSE
        ICOMP = 0
        DO 30 I=1,NEQ
          IF (ZI(INDRO+I-1).EQ.0) THEN
            CHAMAJ(I)     = CHAINI(I) + COEF*CHADEL(I)
          ELSE IF (ZI(INDRO+I-1).EQ.1) THEN     
            ICOMP         = ICOMP + 1
            IRAN(ICOMP)   = I
            THETA(ICOMP)  = CHAINI(I)
            DELDET(ICOMP) = COEF*CHADEL(I)
            IF (ICOMP.EQ.3) THEN
              ICOMP = 0
              CALL NMGROT(IRAN  ,DELDET,THETA ,CHAMAJ)
            ENDIF
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
30      CONTINUE
      ENDIF
      
      CALL JEDEMA()
      END
