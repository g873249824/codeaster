      SUBROUTINE MDEXCV ( NOFIMD,
     &                    NOCHMD, NOMAMD, NUMPT, NUMORD, TYPENT, TYPGEO,
     &                    NBVAL, CODRET )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 08/03/2011   AUTEUR SELLENET N.SELLENET 
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
C RESPONSABLE SELLENET N.SELLENET
C_____________________________________________________________________
C        FORMAT MED : EXISTENCE D'UN CHAMP DANS UN FICHIER : VALEURS
C               - -   --             -                       -
C ______________________________________________________________________
C .        .     .        .                                            .
C .  NOM   . E/S . TAILLE .           DESCRIPTION                      .
C .____________________________________________________________________.
C . NOFIMD .  E  .   1    . NOM DU FICHIER MED                         .
C . NOCHMD .  E  .   1    . NOM DU CHAMP MED VOULU                     .
C . NOMAMD .  E  .   1    . NOM DU MAILLAGE MED ASSOCIE                .
C . NUMPT  .  E  .   1    . NUMERO DU PAS DE TEMPS DU CHAMP            .
C . NUMORD .  E  .   1    . NUMERO D'ORDRE DU CHAMP                    .
C . TYPENT .  E  .   1    . TYPE D'ENTITE AU SENS MED                  .
C . TYPGEO .  E  .   1    . TYPE DE SUPPORT AU SENS MED                .
C . NBVAL  .  S  .   1    . NOMBRE DE VALEURS DANS LE FICHIER          .
C . CODRET .  S  .    1   . CODE DE RETOUR DES MODULES                 .
C ______________________________________________________________________
C
C====
C 0. DECLARATIONS ET DIMENSIONNEMENT
C====
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      CHARACTER*(*) NOFIMD, NOCHMD, NOMAMD
C
      INTEGER NUMPT, NUMORD, TYPENT, TYPGEO, NBVAL
C
      INTEGER CODRET
C
C 0.2. ==> COMMUNS
C
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      INTEGER EDLECT
      PARAMETER (EDLECT=0)
      INTEGER EDCOMP
      PARAMETER (EDCOMP=2)
C
      INTEGER IDFIMD
      INTEGER IAUX
C
      CHARACTER*8 SAUX08
      LOGICAL FICEXI
C ______________________________________________________________________
C
C====
C 1. ON OUVRE LE FICHIER EN LECTURE
C    ON PART DU PRINCIPE QUE SI ON N'A PAS PU OUVRIR, C'EST QUE LE
C    FICHIER N'EXISTE PAS, DONC SANS CHAMP A FORTIORI
C====
C
      NBVAL = 0
      CODRET = 0
      INQUIRE(FILE=NOFIMD,EXIST=FICEXI)
C
      IF ( .NOT. FICEXI ) THEN
C
      NBVAL = 0
      CODRET = 0
C
      ELSE
      CALL MFOUVR ( IDFIMD, NOFIMD, EDLECT, IAUX )
      IF ( IAUX.EQ.0 ) THEN
C
C====
C 2. COMBIEN DE VALEURS ?
C====
C
      CALL MFNVAL ( IDFIMD, NOCHMD, TYPENT, TYPGEO,
     &              NUMPT,  NUMORD, NOMAMD, EDCOMP,
     &              NBVAL,  CODRET )
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFNVAL  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
C====
C 3. FERMETURE DU FICHIER
C====
C
      CALL MFFERM ( IDFIMD, CODRET )
      IF ( CODRET.NE.0 ) THEN
        SAUX08='MFFERM  '
        CALL U2MESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
      ENDIF
C
      ENDIF
      ENDIF
C
      END
