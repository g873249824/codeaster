      SUBROUTINE JETYPR( RECH , CAND , ISEG , ITAIL , RVAL)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 26/07/2010   AUTEUR LEFEBVRE J-P.LEFEBVRE 
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
C RESPONSABLE LEFEBVRE J-P.LEFEBVRE
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER *(*) RECH, CAND
      INTEGER        ISEG
C ----------------------------------------------------------------------
C MODIFIE L'ALGORITHME DE RECHERCHE DE PLACE POUR CHARGER EN MEMOIRE
C LES SEGMENTS DE VALEURS
C
C IN  RECH : 'DEBUT'     DEPUIS LE DEBUT DE LA ZONE MEMOIRE
C            'DERRIERE'  DERRIERE LE DERNIER SEGMENT ALLOUE (DEFAUT)
C            'LIBERE'    DERRIERE LE DERNIER SEGMENT LIBERE
C            'DEFAUT'    MET A DEFAUT LE TYPE DE RECHERCHE
C
C IN CAND :  CANDIDAT A LA LIBERATION
C            'XX'  PREMIERE ZONE LIBRE EN FIN DE SEGMENTATION (DEFAUT)
C                  PUIS
C            'XA'  PREMIERE ZONE CONSTITUEE DE SEGMENTS LIBRES OU
C                  AMOVIBLES, PUIS
C            'XD'  PREMIERE ZONE CONSTITUEE DE SEGMENTS LIBRES,
C                  AMOVIBLES OU DECHARGEABLES
C
C IN ISEG :  TYPE D'ALLOCATION DES SEGMENTS DE VALEURS
C            1 PAS DE DISTINCTION PARTICULIERE (DEFAUT)
C            2 OBJETS SYSTEME DE COLLECTION ALLOUES A PARTIR
C              DE LA FIN DE ZONE MEMOIRE DE FACON RETROGRADE
C
C IN ITAIL:  TAILLE EN MOTS ENTIERS DES SEGMENTS DE VALEURS
C            A PARTIR DE LAQUELLE ILS SONT PRIS EN COMPTE POUR UNE
C            ALLOCATION EN FIN DE ZONE MEMOIRE DE FACON RETROGRADE
C
C IN RVAL:  TAILLE DE LA PARTITION (EN POURCENTAGE DE LA ZONE MEMOIRE
C           GEREE PAR JEVEUX)
C ----------------------------------------------------------------------
      INTEGER          IDINIT   ,IDXAXD   ,ITRECH,ITIAD,ITCOL,LMOTS,IDFR
      COMMON /IXADJE/  IDINIT(2),IDXAXD(2),ITRECH,ITIAD,ITCOL,LMOTS,IDFR
C ----------------------------------------------------------------------
      CHARACTER*8      CHR8
      CHARACTER*2      CHC2
C DEB ------------------------------------------------------------------
      CHR8 = RECH
      CHC2 = CAND
      IF ( CHR8(1:6) .EQ. 'DEFAUT' ) THEN
        ITRECH = 1
        ITIAD  = 1
        GOTO 100
      ENDIF
      IF ( CHR8 .EQ. 'DERRIERE' ) THEN
        ITIAD = 1
      ELSE IF ( CHR8 .EQ. 'DEBUT   ' ) THEN
        ITIAD = 2
      ELSE IF ( CHR8 .EQ. 'LIBERE  ' ) THEN
        ITIAD = 3
      ELSE
        CALL U2MESK('F','JEVEUX1_23',1,CHR8)
      ENDIF
C
      IF ( CHC2 .EQ. 'XX' ) THEN
        ITRECH = 1
      ELSE IF ( CHC2 .EQ. 'XA' ) THEN
        ITRECH = 2
      ELSE IF ( CHC2 .EQ. 'XD' ) THEN
        ITRECH = 3
      ELSE
        CALL U2MESK('F','JEVEUX1_23',1,CHC2)
      ENDIF
C
 100  CONTINUE
      IF ( ISEG .EQ. 1 ) THEN
        ITCOL = 1
      ELSE IF ( ISEG .EQ. 2 ) THEN
        ITCOL = 2
      ELSE IF ( ISEG .EQ. 3 ) THEN
        ITCOL = 3
        LMOTS = ITAIL
        IF (LMOTS .LE. 0) THEN
           CALL U2MESI('F','JEVEUX1_24',1,LMOTS)
        ENDIF
      ELSE IF ( ISEG .EQ. 4 ) THEN
        ITCOL = 4
        LMOTS = ITAIL
        IF (LMOTS .LE. 0) THEN
           CALL U2MESI('F','JEVEUX1_24',1,LMOTS)
        ENDIF
        RPAR  = RVAL
        IF (RPAR .LE. 0.D0 .OR. RPAR .GE. 1.D0) THEN
           CALL U2MESR('F','JEVEUX1_25',1,RPAR)
        ENDIF
        CALL JJCPSG( RPAR, 1 )
      ELSE
        CALL U2MESI('F','JEVEUX1_26',1,ISEG)
      ENDIF
C FIN ------------------------------------------------------------------
      END
