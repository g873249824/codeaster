      SUBROUTINE DIINIT(MAILLA,RESULT,MATE  ,CARELE,SDDYNA,
     &                  INSTAN,SDDISC,DERNIE,LISINS,SDOBSE,
     &                  SDSUIV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_20
C
      IMPLICIT      NONE
      INTEGER       DERNIE
      REAL*8        INSTAN
      CHARACTER*8   RESULT,MAILLA
      CHARACTER*19  SDDISC,SDDYNA,LISINS
      CHARACTER*24  CARELE,SDSUIV,MATE
      CHARACTER*14  SDOBSE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (STRUCTURES DE DONNES)
C
C CREATION SD DISCRETISATION, ARCHIVAGE ET OBSERVATION
C
C ----------------------------------------------------------------------
C
C
C IN  MATE   : NOM DU CHAMP DE MATERIAU
C IN  CARELE : NOM DU CHAMP DE CARACTERISTIQUES ELEMENTAIRES
C IN  SDDYNA : NOM DE LA SD DEDIEE A LA DYNAMIQUE (CF NDLECT)
C IN  RESULT : NOM UTILISATEUR DU RESULTAT
C IN  MAILLA : NOM DU MAILLAGE
C IN  INSTAN : PREMIER INSTANT DE CALCUL
C OUT SDDISC : SD DISCRETISATION
C OUT LISINS : NOM DE LA LISTE D'INSTANTS
C OUT SDSUIV : NOM DE LA SD POUR SUIVI DDL
C OUT SDOBSE : NOM DE LA SD POUR OBSERVATION
C OUT DERNIE : DERNIER NUMERO ARCHIVE (OU 0 SI NON REENTRANT)
C
C ----------------------------------------------------------------------
C
      INTEGER      N1,NM,NUMINI
      REAL*8       DELMIN
      LOGICAL      NDYNLO,LEXPL ,LPRMO
      CHARACTER*8  MECA,K8BID
      CHARACTER*16 NOMCMD,K16BID
C
C ----------------------------------------------------------------------
C
      CALL GETVID('INCREMENT','LIST_INST',1,1,1,LISINS,N1)
      IF (N1.EQ.0) THEN
        CALL ASSERT(.FALSE.)
      ENDIF 
C
C --- COMMANDE APPELANTE
C      
      CALL GETRES(K8BID ,K16BID,NOMCMD)  
C
C --- FONCTIONNALITES ACTIVEES
C
      LEXPL  = NDYNLO(SDDYNA,'EXPLICITE' )
      LPRMO  = NDYNLO(SDDYNA,'PROJ_MODAL')
C
C --- CREATION SD DISCRETISATION
C
      CALL NMCRLI(INSTAN,LISINS,SDDISC,NUMINI,DELMIN,
     &            NOMCMD)
C
C --- EVALUATION DE LA CONDITION DE COURANT EN EXPLICITE
C
      IF (LEXPL) THEN
        IF (LPRMO)THEN
          CALL GETVID('PROJ_MODAL','MODE_MECA',1,1,1,MECA,NM)
          CALL PASCOM(MECA  ,SDDYNA)
        ELSE
          CALL PASCOU(MATE  ,CARELE,SDDYNA)
        ENDIF
      ENDIF     
C
C --- CREATION SD ARCHIVAGE
C 
      CALL NMCRAR(RESULT,SDDISC,DERNIE,DELMIN,NOMCMD)
C     
C --- SUBDIVISION AUTOMATIQUE DU PAS DE TEMPS   
C 
      CALL NMCRSU(SDDISC,DELMIN,NOMCMD)
C
C --- CREATION SD OBSERVATION
C
      CALL NMCROB(MAILLA,RESULT,LISINS,NUMINI,SDSUIV,
     &            SDOBSE,NOMCMD)

      END
