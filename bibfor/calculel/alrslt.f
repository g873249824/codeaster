      SUBROUTINE ALRSLT(IOPT,LIGREL,NOUT,LCHOUT,LPAOUT,BASE,LDIST,LFETI)
      IMPLICIT NONE

C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C RESPONSABLE PELLET J.PELLET

C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'
      INTEGER IOPT,NOUT
      CHARACTER*19 LIGREL
      CHARACTER*(*) BASE,LCHOUT(*)
      CHARACTER*8 LPAOUT(*)
      LOGICAL LDIST,LFETI
C ----------------------------------------------------------------------
C     ENTREES:
C      IOPT : OPTION
C     LIGREL : NOM DE LIGREL
C     LCHOUT : LISTE DES NOMS DES CHAMPS DE SORTIE
C     LPAOUT : LISTE DES PARAMETRES ASSOCIES AUX CHAMPS DE SORTIE
C       NOUT : NOMBRE DE CHAMPS DE SORTIE
C       BASE : 'G', 'V' OU 'L'
C     LDIST : CALCUL DISTRIBUE
C     LFETI : CALCUL FETI
C     SORTIES:
C      CREATION DES CHAMPS GLOBAUX RESULTATS

C ----------------------------------------------------------------------
      COMMON /CAII05/IANOOP,IANOTE,NBOBTR,IAOBTR,NBOBMX
      COMMON /CAII07/IACHOI,IACHOK
      INTEGER EVFINI,CALVOI,JREPE,JPTVOI,JELVOI
      COMMON /CAII19/EVFINI,CALVOI,JREPE,JPTVOI,JELVOI

C     FONCTIONS EXTERNES:
C     -------------------
      INTEGER GRDEUR,IANOOP,IANOTE,NBOBTR,IAOBTR,NBOBMX,IACHOI,IACHOK

C     VARIABLES LOCALES:
C     ------------------
      INTEGER GD,DESCGD,CODE,I,IRET1,IRET2,IBID,IRET,JCELK,JNOLI
      CHARACTER*19 NOCHOU,DCEL
      CHARACTER*8 NOMPAR
      CHARACTER*8 KBI1,KBI2
      CHARACTER*16 NOMOPT


      CALL JENUNO(JEXNUM('&CATA.OP.NOMOPT',IOPT),NOMOPT)


C     -- ALLOCATION DES CHAMPS RESULTATS :
      DO 10 I = 1,NOUT
        NOMPAR = LPAOUT(I)
        NOCHOU = LCHOUT(I)
        GD = GRDEUR(NOMPAR)
        CALL JEVEUO(JEXNUM('&CATA.GD.DESCRIGD',GD),'L',DESCGD)
        CODE = ZI(DESCGD-1+1)

        CALL DETRSD('CHAMP',NOCHOU)
C        -- SI GD EST 1 GRANDEUR_SIMPLE --> CHAM_ELEM
        IF (CODE.EQ.1) THEN
          CALL EXISD('CHAM_ELEM_S',NOCHOU,IRET)
          IF (IRET.GT.0) THEN
            DCEL = NOCHOU
          ELSE
            DCEL = ' '
          END IF
          CALL ALCHML(LIGREL,NOMOPT,NOMPAR,BASE,NOCHOU,IRET,DCEL)
C        -- LES CHAM_ELEMS SONT INCOMPLETS AVEC FETI OU LDIST
          IF (LDIST.OR.LFETI) THEN
            CALL JEVEUO(NOCHOU//'.CELK','E',JCELK)
            ZK24(JCELK-1+7)='MPI_INCOMPLET'
          ENDIF

        ELSE
C        -- SINON --> RESUELEM
          CALL ASSERT((CODE.GE.3).AND.(CODE.LE.5))
          CALL ALRESL(IOPT,LIGREL,NOCHOU,NOMPAR,BASE)
C        -- LES RESU_ELEMS SONT COMPLETS AVEC FETI (MATRICE/ SM LOCAUX)
C           MAIS INCOMPLETS EN LDIST (BLOCS DE MATRICE/SM GLOBAUX)
          IF (LDIST) THEN
            CALL JEVEUO(NOCHOU//'.NOLI','E',JNOLI)
            ZK24(JNOLI-1+3)='MPI_INCOMPLET'
          ENDIF
        END IF
   10 CONTINUE

   20 CONTINUE

C     --MISE A JOUR DE CAII07 :
      CALL WKVECT('&&CALCUL.LCHOU_I','V V I',MAX(3*NOUT,3),IACHOI)
      NBOBTR = NBOBTR + 1
      ZK24(IAOBTR-1+NBOBTR) = '&&CALCUL.LCHOU_I'
      CALL WKVECT('&&CALCUL.LCHOU_K8','V V K8',MAX(2*NOUT,2),IACHOK)
      NBOBTR = NBOBTR + 1
      ZK24(IAOBTR-1+NBOBTR) = '&&CALCUL.LCHOU_K8'

      DO 30 I = 1,NOUT
        NOMPAR = LPAOUT(I)
        NOCHOU = LCHOUT(I)
        GD = GRDEUR(NOMPAR)
        CALL JEVEUO(JEXNUM('&CATA.GD.DESCRIGD',GD),'L',DESCGD)
        CODE = ZI(DESCGD-1+1)
        CALL JEEXIN(NOCHOU//'.DESC',IRET1)
        CALL JEEXIN(NOCHOU//'.CELD',IRET2)
        IF ((IRET1+IRET2).EQ.0) GO TO 30

        CALL DISMOI('F','NOM_GD',NOCHOU,'CHAMP',IBID,KBI1,IBID)
        CALL DISMOI('F','TYPE_SCA',KBI1,'GRANDEUR',IBID,KBI2,IBID)
        ZK8(IACHOK-1+2* (I-1)+2) = KBI2
        CALL DISMOI('F','TYPE_CHAMP',NOCHOU,'CHAMP',IBID,KBI1,IBID)
C        -- SI C'EST UN CHAM_ELEM:
C           ON DOIT FAIRE UN JEVEUO EN ECRITURE POUR RECUPERER
C           L'ADRESSE DU .CELV
        IF (KBI1(1:2).EQ.'EL') THEN
          CALL JEVEUO(NOCHOU//'.CELD','E',ZI(IACHOI-1+3* (I-1)+1))
          CALL JEVEUO(NOCHOU//'.CELV','E',ZI(IACHOI-1+3* (I-1)+2))
          ZK8(IACHOK-1+2* (I-1)+1) = 'CHML'
        ELSE
          CALL JEVEUO(NOCHOU//'.DESC','E',ZI(IACHOI-1+3* (I-1)+1))
          IF (EVFINI.EQ.1.AND.CODE.GT.3) THEN
            CALL ASSERT(CODE.EQ.5)
            CALL JEVEUO(NOCHOU//'.RSVI','L',ZI(IACHOI-1+3* (I-1)+2))
            CALL JEVEUO(JEXATR(NOCHOU//'.RSVI','LONCUM'),'L',
     &                ZI(IACHOI-1+3* (I-1)+3))
          ENDIF
          ZK8(IACHOK-1+2* (I-1)+1) = 'RESL'
        END IF
   30 CONTINUE

      END
