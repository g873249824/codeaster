      SUBROUTINE DISMLG(QUESTI,NOMOBZ,REPI,REPKZ,IERD)
      IMPLICIT NONE
      INTEGER REPI,IERD
      CHARACTER*(*) QUESTI,REPKZ,NOMOBZ
C ----------------------------------------------------------------------
C MODIF UTILITAI  DATE 29/08/2011   AUTEUR DESROCHE X.DESROCHES 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C     --     DISMOI(LIGREL)
C    IN:
C       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
C       NOMOBZ : NOM D'UN OBJET DE TYPE LIGREL
C    OUT:
C       REPI   : REPONSE ( SI ENTIERE )
C       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
C       IERD   : CODE RETOUR (0--> OK, 1 --> PB)

C ----------------------------------------------------------------------
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
      CHARACTER*32 JEXNUM
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER DIMGE(3)
      LOGICAL MELANG,LTEATT
      CHARACTER*1  K1BID
      CHARACTER*8  KBID,CALCRI,MAILLA,NOMACR
      CHARACTER*16 NOMTE,PHENOM,NOMODL,TYVOIS
      CHARACTER*19 NOMOB
      CHARACTER*32 REPK
      INTEGER JLGRF,IRET,NBGREL,IGREL,JLIEL,NEL,ITYPEL,JSSSA,N1
      INTEGER IGE2,IGR,IAGREL,ITE,IGE1,IGE3,IRET2,NBGR
      INTEGER JNOMAC,NBSM,ISM,IANBNO,IANOMO,IBID,DIMGE1
C DEB ------------------------------------------------------------------

      CALL JEMARQ()
      NOMOB = NOMOBZ
      REPK = ' '

C     --------------------------------
      IF (QUESTI.EQ.'NOM_MAILLA') THEN
C     --------------------------------
        CALL JEVEUO(NOMOB//'.LGRF','L',JLGRF)
        REPK = ZK8(JLGRF-1+1)

C     --------------------------------
      ELSEIF (QUESTI.EQ.'PARTITION') THEN
C     --------------------------------
        CALL JEVEUO(NOMOB//'.LGRF','L',JLGRF)
        REPK = ZK8(JLGRF-1+2)

C     -----------------------------------
      ELSE IF (QUESTI.EQ.'EXI_ELEM') THEN
C     -----------------------------------
        CALL JEEXIN(NOMOB//'.LIEL',IRET)
        REPK = 'NON'
        IF (IRET.GT.0) REPK = 'OUI'


C     -----------------------------------------------------------------
      ELSEIF ((QUESTI.EQ.'EXI_VF') ) THEN
C     -----------------------------------------------------------------
        REPK = 'NON'
        CALL JEEXIN(NOMOB//'.LIEL',IRET)
        IF (IRET.GT.0) THEN
          CALL JELIRA(NOMOB//'.LIEL','NUTIOC',NBGREL,K1BID)
          DO 11,IGREL = 1,NBGREL
            CALL JEVEUO(JEXNUM(NOMOB//'.LIEL',IGREL),'L',JLIEL)
            CALL JELIRA(JEXNUM(NOMOB//'.LIEL',IGREL),'LONMAX',NEL,K1BID)
            ITYPEL = ZI(JLIEL-1+NEL)
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOMTE)
            IF (LTEATT (NOMTE,'VF_AVEC_VOISIN','OUI')) THEN
              REPK = 'OUI'
              GO TO 11
            END IF
 11       CONTINUE
        END IF

C     -----------------------------------------------------------------
      ELSEIF ((QUESTI.EQ.'BESOIN_VOISIN') ) THEN
C     -----------------------------------------------------------------
        REPK = 'NON'
        CALL JEEXIN(NOMOB//'.LIEL',IRET)
        IF (IRET.GT.0) THEN
          CALL JELIRA(NOMOB//'.LIEL','NUTIOC',NBGREL,K1BID)
          DO 12,IGREL = 1,NBGREL
            CALL JEVEUO(JEXNUM(NOMOB//'.LIEL',IGREL),'L',JLIEL)
            CALL JELIRA(JEXNUM(NOMOB//'.LIEL',IGREL),'LONMAX',NEL,K1BID)
            ITYPEL = ZI(JLIEL-1+NEL)
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOMTE)
            CALL TEATTR (NOMTE,'C','TYPE_VOISIN',TYVOIS,IRET)
            IF (IRET.EQ.0) THEN
              REPK = 'OUI'
              GO TO 12
            END IF
 12       CONTINUE
        END IF



C     -----------------------------------------------------------------
      ELSEIF ((QUESTI.EQ.'EXI_RDM')    .OR. (QUESTI.EQ.'EXI_POUX')  .OR.
     &        (QUESTI(1:7).EQ.'EXI_THM') .OR.
     &        (QUESTI.EQ.'EXI_TUYAU')  .OR. (QUESTI.EQ.'EXI_COQ3D') .OR.
     &        (QUESTI.EQ.'EXI_COQ1D')  .OR. (QUESTI.EQ.'EXI_GRILLE').OR.
     &        (QUESTI.EQ.'EXI_PLAQUE') .OR. (QUESTI.EQ.'EXI_COQUE') .OR.
     &        (QUESTI.EQ.'CALC_RIGI')
     &        ) THEN
C     -----------------------------------------------------------------
        CALL JEEXIN(NOMOB//'.LIEL',IRET)
        IF (IRET.GT.0) THEN
          CALL JELIRA(NOMOB//'.LIEL','NUTIOC',NBGREL,K1BID)
          REPK = 'NON'
          DO 10,IGREL = 1,NBGREL
            CALL JEVEUO(JEXNUM(NOMOB//'.LIEL',IGREL),'L',JLIEL)
            CALL JELIRA(JEXNUM(NOMOB//'.LIEL',IGREL),'LONMAX',NEL,K1BID)
            ITYPEL = ZI(JLIEL-1+NEL)
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOMTE)

            IF (QUESTI.EQ.'EXI_RDM') THEN
              CALL DISMTE('MODELISATION',NOMTE,REPI,NOMODL,IERD)
              IF ((NOMODL(1:3).EQ.'DKT').OR.(NOMODL(1:3).EQ.'DST') .OR.
     &            (NOMODL(1:3).EQ.'Q4G').OR.(NOMODL(1:5).EQ.'CABLE').OR.
     &            (NOMODL(1:4).EQ.'POU_').OR.(NOMODL(1:5).EQ.'BARRE')
     &            .OR. (NOMODL(1:4).EQ.'DIS_')
     &            .OR. (NOMODL(1:5).EQ.'TUYAU')
     &            .OR. (NOMODL(3:7).EQ.'_DIS_')
     &            .OR. (NOMODL(1:6).EQ.'GRILLE')
     &            .OR. (NOMODL(1:5).EQ.'COQUE')) THEN
                REPK = 'OUI'
                GO TO 40
              END IF

            ELSEIF (QUESTI.EQ.'CALC_RIGI') THEN
              REPK='NON'
              CALL DISMTE(QUESTI,NOMTE,REPI,CALCRI,IERD)
              IF ( CALCRI.EQ.'OUI' ) THEN
                REPK = 'OUI'
                GO TO 40
              END IF

            ELSEIF (QUESTI.EQ.'EXI_COQUE') THEN
              CALL DISMTE('MODELISATION',NOMTE,REPI,NOMODL,IERD)
              IF ( NOMODL(1:5).EQ.'COQUE' ) THEN
                REPK = 'OUI'
                GO TO 40
              END IF

            ELSEIF (QUESTI.EQ.'EXI_GRILLE') THEN
              CALL DISMTE('MODELISATION',NOMTE,REPI,NOMODL,IERD)
              REPK = 'NON'
              IF ( NOMODL(1:6).EQ.'GRILLE' ) THEN
                REPK = 'OUI'
                GO TO 40
              END IF

            ELSE IF ((QUESTI.EQ.'EXI_COQ3D') .OR.
     &               (QUESTI.EQ.'EXI_COQ1D')) THEN
              CALL DISMTE('MODELISATION',NOMTE,REPI,NOMODL,IERD)
              IF (NOMODL(1:8).EQ.'COQUE_3D') THEN
                REPK = 'OUI'
                GO TO 40
              END IF

            ELSE IF (QUESTI.EQ.'EXI_PLAQUE') THEN
              CALL DISMTE('MODELISATION',NOMTE,REPI,NOMODL,IERD)
              IF ((NOMODL(1:3).EQ.'DKT') .OR. (NOMODL(1:3).EQ.'DST')
     &             .OR.(NOMODL(1:3).EQ.'Q4G')) THEN
                REPK = 'OUI'
                GO TO 40
              END IF

            ELSE IF (QUESTI.EQ.'EXI_TUYAU') THEN
              IF ((NOMTE.EQ.'MET3SEG3') .OR. (NOMTE.EQ.'MET3SEG4') .OR.
     &            (NOMTE.EQ.'MET6SEG3')) THEN
                REPK = 'OUI'
                GO TO 40
              END IF

            ELSE IF (QUESTI.EQ.'EXI_POUX') THEN
              IF ((NOMTE.EQ.'MECA_POU_D_E') .OR.
     &            (NOMTE.EQ.'MECA_POU_D_EM') .OR.
     &            (NOMTE.EQ.'MECA_POU_D_T') .OR.
     &            (NOMTE.EQ.'MECA_POU_D_TG') .OR.
     &            (NOMTE.EQ.'MECA_POU_D_TGM') .OR.
     &            (NOMTE.EQ.'MECA_POU_C_T')) THEN
                REPK = 'OUI'
                GO TO 40
              END IF

            ELSE IF (QUESTI.EQ.'EXI_THM') THEN
              IF  (LTEATT (NOMTE,'THM','OUI')) THEN
                REPK='OUI'
                IF ( (NOMTE.EQ.'HM_D_PLAN_SE3_P').OR.
     &               (NOMTE.EQ.'HM_DPQ8_P').OR.
     &               (NOMTE.EQ.'HM_DPTR6_P')) THEN
                  REPK='OUI_P'
                ENDIF
                GO TO 40
              ENDIF

            ELSE
              CALL ASSERT(.FALSE.)
            END IF
   10     CONTINUE
        ELSE
          REPK = 'NON'
        END IF

C     ------------------------------------------
      ELSE IF( (QUESTI.EQ.'NB_SM_MAILLA') .OR.
     &         (QUESTI.EQ.'NB_SS_ACTI'  ) .OR.
     &         (QUESTI.EQ.'NB_NL_MAILLA') ) THEN
C     ------------------------------------------
         CALL JEEXIN(NOMOB//'.SSSA',IRET)
         IF (IRET.EQ.0) THEN
           REPI=0
         ELSE
           CALL JEVEUO(NOMOB//'.SSSA','L',JSSSA)
           CALL JELIRA(NOMOB//'.SSSA','LONMAX',N1,KBID)
           IF (QUESTI.EQ.'NB_SM_MAILLA') THEN
             REPI= ZI(JSSSA-1+N1-2)
           ELSE IF (QUESTI.EQ.'NB_SS_ACTI') THEN
             REPI= ZI(JSSSA-1+N1-1)
           ELSE IF (QUESTI.EQ.'NB_NL_MAILLA') THEN
             REPI= ZI(JSSSA-1+N1)
           END IF
         END IF

C     ---------------------------------------
      ELSE IF (QUESTI.EQ.'NB_NO_MAILLA') THEN
C     ---------------------------------------
        CALL JEVEUO(NOMOB//'.LGRF','L',JLGRF)
        CALL DISMMA(QUESTI,ZK8(JLGRF),REPI,REPK,IERD)

C     ---------------------------------------
      ELSE IF (QUESTI.EQ.'NB_MA_MAILLA') THEN
C     ---------------------------------------
        CALL JEVEUO(NOMOB//'.LGRF','L',JLGRF)
        CALL DISMMA(QUESTI,ZK8(JLGRF),REPI,REPK,IERD)

C     -----------------------------------
      ELSE IF (QUESTI.EQ.'DIM_GEOM') THEN
C     -----------------------------------
        REPI = 0
        IGE2 = 0
        CALL JEEXIN(NOMOB//'.LIEL',IRET)
        IF (IRET.GT.0) THEN
          CALL JELIRA(NOMOB//'.LIEL','NUTIOC',NBGR,K1BID)
          DIMGE(1) = 0
          DIMGE(2) = 0
          DIMGE(3) = 0
          MELANG = .FALSE.
          DO 20,IGR = 1,NBGR
            CALL JEVEUO(JEXNUM(NOMOB//'.LIEL',IGR),'L',IAGREL)
            CALL JELIRA(JEXNUM(NOMOB//'.LIEL',IGR),'LONMAX',N1,K1BID)
            ITE = ZI(IAGREL-1+N1)
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITE),NOMTE)
            CALL DISMTE(QUESTI,NOMTE,IGE1,REPK,IERD)
            CALL ASSERT((IGE1.GE.0) .AND. (IGE1.LE.3))
            IF ((IGE2.EQ.0) .AND. (IGE1.NE.0)) IGE2 = IGE1
            IF ((IGE1*IGE2.GT.0) .AND. (IGE1.NE.IGE2)) MELANG = .TRUE.
            IF (IGE1.GT.0) DIMGE(IGE1) = 1
   20     CONTINUE
          IF (MELANG) THEN
            IGE3 = +100*DIMGE(1)
            IGE3 = IGE3 + 10*2*DIMGE(2)
            IGE3 = IGE3 + 1*3*DIMGE(3)
            IGE2 = IGE3
          END IF
        END IF
C        -- SI IL EXISTE DES MACRO-ELEMENTS, IL FAUT EN TENIR COMPTE :
        CALL JEEXIN(NOMOB//'.SSSA',IRET2)
        IF (IRET2.GT.0) THEN
          CALL JELIRA(NOMOB//'.SSSA','LONMAX',N1,KBID)
          CALL JEVEUO(NOMOB//'.SSSA','L',JSSSA)
          CALL JEVEUO(NOMOB//'.LGRF','L',JLGRF)
          MAILLA = ZK8(JLGRF-1+1)
          CALL JEVEUO(MAILLA//'.NOMACR','L',JNOMAC)
          NBSM=N1-3
          DO 777, ISM=1,NBSM
            IF (ZI(JSSSA-1+ISM).EQ.1) THEN
              NOMACR=ZK8(JNOMAC-1+ISM)
              CALL DISMML(QUESTI,NOMACR,IGE1,REPK,IERD)
              CALL ASSERT(IGE1.GE.0 .AND. IGE1.LE.123)
              IF (IGE2.NE.IGE1) THEN
                 IGE2=DIMGE1(IGE2,IGE1)
              ENDIF
            ENDIF
777       CONTINUE
        ENDIF
        REPI = IGE2


C     ----------------------------------
      ELSE IF (QUESTI.EQ.'NB_GREL') THEN
C     ----------------------------------
        CALL JEEXIN(NOMOB//'.LIEL',IRET)
        IF (IRET.GT.0) THEN
          CALL JELIRA(NOMOB//'.LIEL','NUTIOC',REPI,K1BID)
        ELSE
          REPI = 0
        END IF

C     ------------------------------------
      ELSE IF (QUESTI.EQ.'NB_MA_SUP') THEN
C     ------------------------------------
        CALL JEEXIN(NOMOB//'.NEMA',IRET)
        IF (IRET.GT.0) THEN
          CALL JELIRA(NOMOB//'.NEMA','NUTIOC',REPI,K1BID)
        ELSE
          REPI = 0
        END IF

C     -----------------------------------------
      ELSE IF (QUESTI.EQ.'NB_NO_SUP') THEN
C     -----------------------------------------
        CALL JEVEUO(NOMOB//'.NBNO','L',IANBNO)
        REPI = ZI(IANBNO)

C     -------------------------------------
      ELSE IF (QUESTI.EQ.'NOM_MODELE') THEN
C     -------------------------------------

C        -- DANGER : CETTE QUESTION EST RESOLUE DE FACON SALE
C           ON UTILISE UNE CONVENTION DE NOM NON ECRITE ..

        IF (NOMOB(9:19).EQ.'.MODELE') THEN
C           -- C'EST UN LIGREL DE MODELE
          REPK = NOMOB(1:8)
        ELSE IF (NOMOB(14:19).EQ.'.LIGRE') THEN
C           -- C'EST UN LIGREL DE CHARGE
          CALL JEVEUO(NOMOB(1:13)//'.MODEL.NOMO','L',IANOMO)
          REPK = ZK8(IANOMO)
        ELSE
C           -- CE N'EST NI UN LIGREL DE CHARGE, NI UN LIGREL DE MODELE
          REPK = ' '
        END IF

C     ------------------------------------
      ELSE IF (QUESTI.EQ.'PHENOMENE') THEN
C     ------------------------------------
        CALL JELIRA(NOMOB//'.LGRF','DOCU',IBID,PHENOM)
        IF (PHENOM(1:4).EQ.'MECA') THEN
          REPK = 'MECANIQUE'
        ELSE IF (PHENOM(1:4).EQ.'THER') THEN
          REPK = 'THERMIQUE'
        ELSE IF (PHENOM(1:4).EQ.'ACOU') THEN
          REPK = 'ACOUSTIQUE'
        ELSE
          CALL U2MESK('F','UTILITAI_63',1,PHENOM)
        END IF

C     ----
      ELSE
C     ----
        IERD = 1
      END IF

   40 CONTINUE
      REPKZ = REPK
      CALL JEDEMA()
      END
