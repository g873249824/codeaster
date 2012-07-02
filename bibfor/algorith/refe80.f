      SUBROUTINE REFE80(NOMRES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C
C***********************************************************************
C    P. RICHARD     DATE 07/03/91
C-----------------------------------------------------------------------
C
C  BUT:  REMPLIR L'OBJET REFE ASSOCIE AU CALCUL CYCLIQUE
C
C-----------------------------------------------------------------------
C
C NOM----- / /:
C
C NOMRES   /I/: NOM UTILISATEUR DU RESULTAT
C
C
C
C
C
      INCLUDE 'jeveux.h'
      CHARACTER*8 NOMRES,BASMOD,INTF,MAILLA
      CHARACTER*10 TYPBAS(3)
      CHARACTER*24 BLANC, IDESC
      CHARACTER*24 VALK(3)
      INTEGER      IARG
C
C-----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER IBID ,IOC1 ,IRET ,LDREF ,LLREF 
C-----------------------------------------------------------------------
      DATA TYPBAS/'CLASSIQUE','CYCLIQUE','RITZ'/
C
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      BLANC='   '
      BASMOD=BLANC
C
C------------RECUPERATION DU NOMBRE D'OCCURENCES DES MOT-CLE------------
C
      CALL GETVID(BLANC,'BASE_MODALE',1,IARG,1,BASMOD,IOC1)
C
C------------------CONTROLE SUR TYPE DE BASE MODALE---------------------
C
      CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
      IDESC=ZK24(LLREF+6)
C
        IF(IDESC(1:9).NE.'CLASSIQUE') THEN
          VALK (1) = BASMOD
          VALK (2) = IDESC
          VALK (3) = TYPBAS(1)
          CALL U2MESG('F', 'ALGORITH14_13',3,VALK,0,0,0,0.D0)
        ENDIF
C
C--------------------RECUPERATION DES CONCEPTS AMONTS-------------------
C
      INTF=ZK24(LLREF+4)
      CALL DISMOI('F','NOM_MAILLA',INTF,'INTERF_DYNA',IBID,
     &            MAILLA,IRET)
C
C--------------------ALLOCATION ET REMPLISSAGE DU REFE------------------
C
      CALL WKVECT(NOMRES//'.CYCL_REFE','G V K24',3,LDREF)
C
      ZK24(LDREF)=MAILLA
      ZK24(LDREF+1)=INTF
      ZK24(LDREF+2)=BASMOD
C
C
      CALL JEDEMA()
      END
