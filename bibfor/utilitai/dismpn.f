      SUBROUTINE DISMPN(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
C     --     DISMOI(PROF_CHNO)
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI
      CHARACTER*(*) NOMOBZ,REPKZ
      CHARACTER*32 REPK
      CHARACTER*19 NOMOB
C ----------------------------------------------------------------------
C     IN:
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE TYPE PROF_CHNO
C     OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
C
C     LISTE DES QUESTIONS ADMISSIBLES:
C        'NB_DDLACT'
C ----------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      CHARACTER*19 NOLIGR
      CHARACTER*8 KBID
C
C
C
C-----------------------------------------------------------------------
      INTEGER I ,IAREFE ,NBDDLB ,NBNOS ,NEQU ,NLILI 
C-----------------------------------------------------------------------
      CALL JEMARQ()
      NOMOB = NOMOBZ
      REPK  = ' '

      IF (QUESTI.EQ.'NB_DDLACT') THEN
C     --------------------------------
         CALL JELIRA(NOMOB//'.NUEQ','LONMAX',NEQU,KBID)
         CALL JELIRA(NOMOB//'.LILI','NUTIOC',NLILI,KBID)
         NBDDLB=0
         DO 10 I=2,NLILI
            CALL JENUNO(JEXNUM(NOMOB//'.LILI',I),NOLIGR)
            CALL DISMLG('NB_NO_SUP',NOLIGR,NBNOS,REPK,IERD)
            NBDDLB=NBDDLB+ NBNOS
 10      CONTINUE
         REPI=NEQU-3*(NBDDLB/2)


      ELSE IF (QUESTI.EQ.'NB_EQUA') THEN
C     --------------------------------
        CALL JELIRA(NOMOB//'.NUEQ','LONMAX',REPI,KBID)


      ELSE IF (QUESTI.EQ.'NOM_GD') THEN
C     --------------------------------
C       QUESTION POURRIE !! (VALABLE SUR NUME_EQUA)
C       CETTE QUESTION NE DEVRAIT PAS ETRE UTILISEE
        CALL JEVEUO(NOMOB//'.REFN','L',IAREFE)
        REPK = ZK24(IAREFE+1) (1:8)


      ELSE IF (QUESTI.EQ.'NOM_MODELE') THEN
C     --------------------------------
C       QUESTION POURRIE !!
C       CETTE QUESTION NE DEVRAIT PAS ETRE UTILISEE
        CALL JENUNO(JEXNUM(NOMOB//'.LILI',2),NOLIGR)
        IF (NOLIGR(1:8).EQ.'LIAISONS') THEN
          REPK = QUESTI
          IERD = 1
        ELSE
          CALL DISMLG(QUESTI,NOLIGR,REPI,REPK,IERD)
        END IF


      ELSE
         IERD=1
      END IF
C
      REPKZ = REPK
      CALL JEDEMA()
      END
