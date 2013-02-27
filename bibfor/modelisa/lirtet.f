        SUBROUTINE LIRTET(IFL,ILEC,INOM,CNL,NOM,ICL,IV,RV,CV,DEBLIG)
      IMPLICIT NONE
C       ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/02/2013   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C       ----------------------------------------------------------------
C       BUT: SAUT D'UNE EVENTUELLE ENTETE AVEC LECTURE DE "NOM="
C       IN: IFL : FICHIER OU ON LIT
C          ILEC: 1=> PREMIERE LECTURE, 2=> SECONDE LECTURE
C          INOM: 1=> LECTURE DU NOM,   0=> NOM IGNORE
C          CNL : NUMERO DE LA LIGNE DANS UNE CHAINE
C          DEBLIG : IN ET OUT DANS LIRITM
C       OUT:
C          NOM : ITEM DERRIERE "NOM="
C          ICL, IV, RV, CV, DEBLIG : COMME LIRITM
C       EN SORTIE DE CETTE ROUTINE, ON A LU LA PREMIERE LIGNE
C       D'INFORMATIONS
C       ----------------------------------------------------------------
C
      COMMON/OPMAIL/CMD
      CHARACTER*16  CMD
      CHARACTER*14  CNL
      CHARACTER*80  LIG
      CHARACTER*8   CVZ
      CHARACTER*24  NOM
      CHARACTER*(*) CV
      INTEGER DEBLIG
      REAL*8 RV
      LOGICAL LNOM,LENT
C
C-----------------------------------------------------------------------
      INTEGER I ,ICL ,IFL ,ILEC ,INOM ,IV
      INTEGER LCV ,NBIGNO
C-----------------------------------------------------------------------
      LNOM=.FALSE.
      LENT=.FALSE.
      NBIGNO=0
      NOM='INDEFINI'
C
      CALL ASSERT (INOM.EQ.0.OR.INOM.EQ.1)
C
      IF (INOM.EQ.0) THEN
    1 CONTINUE
      CV=' '
      IV=0
      RV=0.D0
      CALL LIRITM(IFL,ICL,IV,RV,CV(1:8),CNL,DEBLIG,ILEC)
        IF (DEBLIG.EQ.0) THEN
C -     IL Y A UNE ENTETE
          IF (ICL.EQ.3) THEN
            IF (CV(1:6).EQ.'NBLIGE') THEN
            CALL LIRITM(IFL,ICL,IV,RV,CV(1:8),CNL,DEBLIG,ILEC)
                IF (ICL.EQ.1) THEN
                  NBIGNO=IV
                ELSE
                  CALL ASSERT(.FALSE.)
                ENDIF
            GOTO 9
            ELSE
C -         L'IDENTIFICATEUR LU N'EST PAS "NBLIGE"
            GOTO 1
            END IF
          ELSE
C -       L'ITEM LU N'EST PAS UN IDENTIFICATEUR
          GOTO 1
          END IF
        ELSE
C -     PAS D'ENTETE
        GOTO 9
        END IF
C
      ELSE IF (INOM.EQ.1) THEN
  2   CONTINUE
      CV=' '
      IV=0
      RV=0.D0
      CALL LIRITM(IFL,ICL,IV,RV,CV(1:8),CNL,DEBLIG,ILEC)
        IF (DEBLIG.EQ.0) THEN
C -     IL Y A UNE ENTETE
          IF (ICL.EQ.3) THEN
C -       L'ITEM LU EST UN IDENTIFICATEUR
             IF (CV(1:3).EQ.'NOM') THEN
             CALL LIRITM(IFL,ICL,IV,RV,CV(1:24),CNL,DEBLIG,ILEC)
                IF (ICL.EQ.3) THEN
                   IF (IV.GT.24) THEN
                   CVZ = CV
                   CALL U2MESK('A','MODELISA4_97',1,CVZ(1:IV))
                   ENDIF
                LCV=MIN(IV,24)
                CALL ASSERT(LEN(CV).GE.LCV)
                NOM=CV(1:LCV)
                ELSE
                CALL U2MESS('F','MODELISA4_98')
                ENDIF
             LNOM=.TRUE.
             ELSE IF (CV(1:6).EQ.'NBLIGE') THEN
             CV=' '
             IV=0
             RV=0.D0
             CALL LIRITM(IFL,ICL,IV,RV,CV(1:8),CNL,DEBLIG,ILEC)
                IF (ICL.EQ.1) THEN
                  NBIGNO=IV
                ELSE
                  CALL ASSERT(.FALSE.)
                END IF
             LENT=.TRUE.
             ELSE
C -          L'IDENTIFICATEUR LU N'EST NI "NBLIGE", NI "NOM"
             GOTO 2
             ENDIF
                IF (LNOM.AND.LENT) THEN
                GOTO 9
                ELSE
                GOTO 2
                ENDIF
          ELSE
C -       L'ITEM LU N'EST PAS UN IDENTIFICATEUR
          GOTO 2
          ENDIF
       ELSE
          IF (LENT) THEN
            CALL ASSERT(.NOT.LNOM)
            NBIGNO = NBIGNO - 1
            GOTO 9
          ELSE
C -       PAS D'ENTETE
            GOTO 9
          ENDIF
        END IF
      END IF
C
 9    CONTINUE
      IF (NBIGNO.GT.0) THEN
         DO 99 I = 1,NBIGNO-1
         CALL LIRLIG(IFL,CNL,LIG,ILEC)
   99    CONTINUE
      DEBLIG=-1
      CALL LIRITM(IFL,ICL,IV,RV,CV(1:8),CNL,DEBLIG,ILEC)
      END IF
C
      END
