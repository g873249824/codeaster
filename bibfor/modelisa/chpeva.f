      SUBROUTINE CHPEVA(CHOU)
      IMPLICIT  NONE
C     -----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/02/2008   AUTEUR MACOCCO K.MACOCCO 
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
C RESPONSABLE VABHHTS J.PELLET
C     BUT : TRAITER :
C      -  OPTION:'EVAL' DE LA COMMANDE CREA_CHAMP
C      -  COMMANDE CALC_CHAMP
C     ATTENTION: CETTE ROUTINE N'EST PAS UN UTILITAIRE :
C                ELLE FAIT DES CALL GETVXX.
C     -----------------------------------------------------------------
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER N1,IB,JPARA1,NPARA,JPARA2,K,NNCP,IBID
      CHARACTER*4 TYP1,TYP2,KNUM
      CHARACTER*8 KBID,CHIN,CHOU,NOMGD
      CHARACTER*19 LIGREL,CHS1,CHS2,CHINS
C     -----------------------------------------------------------------

      CALL JEMARQ()


      CHINS = '&&CHPEVA.CHINS'
      CHS2 = '&&CHPEVA.CHS2'


C 1. CALCUL DE:
C      CHIN  : CHAMP A EVALUER (DE FONCTIONS)
C      NOMGD : GRANDEUR ASSOCIEE A CHIN
C      .LPARA1: NOMS DES CHAMPS PARAMETRES POUR LES FONCTIONS
C ------------------------------------------------------------------

      CALL GETVID(' ','CHAM_F',0,1,1,CHIN,IB)

      CALL DISMOI('F','NOM_GD',CHIN,'CHAMP',IB,NOMGD,IB)
      IF (NOMGD.NE.'NEUT_F') CALL U2MESS('F','MODELISA4_13')

      CALL GETVID(' ','CHAM_PARA',0,1,0,KBID,N1)
      NPARA = -N1
      CALL WKVECT('&&CHPEVA.LPARA1','V V K8',NPARA,JPARA1)
      CALL GETVID(' ','CHAM_PARA',0,1,NPARA,ZK8(JPARA1),N1)


C 2.  ON VERIFIE QUE LES CHAMPS PARA ONT LA MEME DISCRETISATION:
C     ET ON LES TRANSFORME EN CHAMPS SIMPLES
C     CALCUL DE .LPARA2: NOMS DES CHAMP_S PARAMETRES POUR LES FONCTIONS
C ------------------------------------------------------------
      CALL WKVECT('&&CHPEVA.LPARA2','V V K24',NPARA,JPARA2)
      CALL DISMOI('F','TYPE_CHAMP',CHIN,'CHAMP',IB,TYP1,IB)
      DO 10,K = 1,NPARA
        CALL DISMOI('F','TYPE_CHAMP',ZK8(JPARA1-1+K),'CHAMP',IB,TYP2,IB)
        IF (TYP1.NE.TYP2) CALL U2MESS('F','MODELISA4_14')

        CALL CODENT(K,'G',KNUM)
        CHS1 = '&&CHPEVA.'//KNUM
        IF (TYP1.EQ.'NOEU') THEN
          CALL CNOCNS(ZK8(JPARA1-1+K),'V',CHS1)

        ELSEIF (TYP1.EQ.'CART') THEN
          CALL CARCES(ZK8(JPARA1-1+K),'ELEM',' ','V',CHS1,IB)

        ELSEIF (TYP1(1:2).EQ.'EL') THEN
          CALL CELCES(ZK8(JPARA1-1+K),'V',CHS1)
        ENDIF
        ZK24(JPARA2-1+K) = CHS1
   10 CONTINUE


C 3.  -- ON APPELLE LA ROUTINE D'EVAL APPROPRIEE :
C ------------------------------------------------------------
      CALL ASSERT((TYP1.EQ.'NOEU').OR.(TYP1(1:2).EQ.'EL'))
      IF (TYP1.EQ.'NOEU') THEN
        CALL CNOCNS(CHIN,'V',CHINS)
        CALL CNSEVA(CHINS,NPARA,ZK24(JPARA2),CHS2)
        CALL CNSCNO(CHS2,' ','NON','G',CHOU,'F',IBID)
        CALL DETRSD('CHAM_NO_S',CHINS)
        CALL DETRSD('CHAM_NO_S',CHS2)

      ELSEIF (TYP1(1:2).EQ.'EL') THEN
        CALL CELCES(CHIN,'V',CHINS)
        CALL CESEVA(CHINS,NPARA,ZK24(JPARA2),CHS2)
        CALL DISMOI('F','NOM_LIGREL',CHIN,'CHAMP',IB,LIGREL,IB)
        CALL CESCEL(CHS2,LIGREL,' ',' ','NON',NNCP,'G',CHOU,'F',IBID)
        CALL DETRSD('CHAM_ELEM_S',CHINS)
        CALL DETRSD('CHAM_ELEM_S',CHS2)

      ENDIF


C 7. MENAGE :
C -----------------------------------------------------
      CALL JEDETR('&&CHPEVA.LPARA1')
      DO 20,K = 1,NPARA
        IF (TYP1.EQ.'NOEU') THEN
          CALL DETRSD('CHAM_NO_S',ZK24(JPARA2-1+K))

        ELSE
          CALL DETRSD('CHAM_ELEM_S',ZK24(JPARA2-1+K))
        ENDIF
   20 CONTINUE
      CALL JEDETR('&&CHPEVA.LPARA2')

   30 CONTINUE
      CALL JEDEMA()

      END
