      SUBROUTINE NMIMPA(ERROR )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/09/2011   AUTEUR ABBAS M.ABBAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
      IMPLICIT      NONE
      CHARACTER*(*) ERROR
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (AFFICHAGE)
C
C IMPRESSION DES MESSAGES D'ERREUR
C      
C ----------------------------------------------------------------------
C      
C
C IN  ERROR  : CODE ERREUR
C              'ECHEC_LDC' -> ECHEC DE L'INTEGRATION DE LA LDC
C              'ECHEC_PIL' -> ECHEC DU PILOTAGE
C              'ECHEC_CON' -> ECHEC DE TRAITEMENT DU CONTACT
C              'CONT_SING' -> MATRICE DE CONTACT SINGULIERE
C              'MATR_SING' -> MATRICE DU SYSTEME SINGULIERE
C              'CPU_NEWT'  -> TEMPS CPU POUR NEWTON
C              'EVEN_COLL' -> ECHEC DANS LE TRAITEMENT DE LA COLLISION
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C

      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C

C
C --- ECHEC DANS L'INTEGRATION DE LA LOI DE COMPORTEMENT
C
      IF (ERROR .EQ. 'ECHEC_LDC') THEN
        CALL U2MESS('I','MECANONLINE6_29')
C
C --- ECHEC DANS LE PILOTAGE
C
      ELSE IF (ERROR .EQ. 'ECHEC_PIL') THEN
        CALL U2MESS('I','MECANONLINE6_30')
C
C --- NOMBRE MAX D'ITERATIONS ATTEINT
C
      ELSE IF (ERROR .EQ. 'ITER_MAXI') THEN
        CALL U2MESS('I','MECANONLINE6_31')
C
C --- ECHEC DE TRAITEMENT DU CONTACT
C
      ELSE IF (ERROR .EQ. 'CONT_ERR') THEN
        CALL U2MESS('I','MECANONLINE6_32')
C
C --- MATRICE DE CONTACT SINGULIERE
C
      ELSE IF (ERROR .EQ. 'CONT_SING') THEN
        CALL U2MESS('I','MECANONLINE6_33')
C
C --- MATRICE DU SYSTEME SINGULIERE
C
      ELSE IF (ERROR .EQ. 'MATR_SING') THEN
        CALL U2MESS('I','MECANONLINE6_34')
C
C --- TEMPS CPU POUR NEWTON
C        
      ELSE IF (ERROR .EQ. 'CPU_NEWT') THEN
        CALL U2MESS('I','MECANONLINE6_35')
C
C --- ECHEC DANS LE DECOUPAGE COLLISION
C        
      ELSE IF (ERROR .EQ. 'EVEN_COLL') THEN
        CALL U2MESS('I','MECANONLINE6_38')
C      
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C

      END
