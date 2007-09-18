      SUBROUTINE XMOLIG(LIEL1,K8CONT,TRAV)
      IMPLICIT NONE

      CHARACTER*8  K8CONT
      CHARACTER*24 LIEL1,TRAV
      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 18/09/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PELLET J.PELLET
C
C      
C ----------------------------------------------------------------------
C
C ROUTINE XFEM APPELEE PAR MODI_MODELE_XFEM (OP0113)
C
C    MODIFICATION DU LIGREL X-FEM SUIVANT LE TYPE D'ENRICHISSMENT
C
C ----------------------------------------------------------------------
C
C
C IN      LIEL1  : LIGREL DU MODELE SAIN
C IN      K8CONT : PRISE EN COMPTE DU CONTACT ('OUI' OU 'NON')
C IN/OUT  TRAV   : TABLEAU DE TRAVAIL  CONTEANT LES TYPES
C                  D'ENRICHISSEMENT ET LE TYPE DES NOUVEAUX ELEMENTS
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
      CHARACTER*32 JEXNOM,JEXNUM,JEXATR
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER       IH8(3),IP6(3),IT4(3)
      INTEGER       IH20(3),IP15(3),IT10(3)
      INTEGER       ICPQ4(3),ICPT3(3),IDPQ4(3),IDPT3(3)
      INTEGER       ICPQ8(3),ICPT6(3),IDPQ8(3),IDPT6(3)
      INTEGER       IF4(3),IF3(3),IPF2(3)
      INTEGER       IF8(3),IF6(3),IPF3(3)
      INTEGER       ICH8(3),ICP6(3),ICT4(3)
      INTEGER       ICPCQ4(3),ICPCT3(3),IDPCQ4(3),IDPCT3(3)

      INTEGER       NH8(4),NH20(4),NP6(4),NP15(4),NT4(4),NT10(4)
      INTEGER       NCPQ4(4),NCPQ8(4),NCPT3(4),NCPT6(4), NDPQ4(4)
      INTEGER       NDPQ8(4),NDPT3(4),NDPT6(4),NF4(4),NF8(4),NF3(4)
      INTEGER       NF6(4),NPF2(4),NPF3(4),NCH8(4),NCP6(4),NCT4(4)
      INTEGER       NCPCQ4(4),NCPCT3(4),NDPCQ4(4),NDPCT3(4)

      INTEGER       NGR1,IGR1,J1,N1,NBELT,ITYPEL,IEL,IMA,JJ,JTAB
      CHARACTER*8   K8BID
      CHARACTER*16  NOTYPE,NOBID

C ----------------------------------------------------------------------
C
      CALL JEMARQ()

C     INITIALISATIONS DE TOUS LES COMPTEURS
      CALL XMOINI(NH8,NH20,NP6,NP15,NT4,NT10,NCPQ4,NCPQ8,NCPT3,NCPT6,
     &            NDPQ4,NDPQ8,NDPT3,NDPT6,NF4,NF8,NF3,NF6,NPF2,NPF3,
     &            NCH8,NCP6,NCT4,NCPCQ4,NCPCT3,NDPCQ4,NDPCT3)
C
C     ------------------------------------------------------------------
C                        ELEMENTS SANS CONTACT
C     ------------------------------------------------------------------

C     ELEMENT PRINCIPAUX 3D LINEAIRES
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_HEXA8' ),IH8(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_HEXA8' ),IH8(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_HEXA8'),IH8(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_PENTA6' ),IP6(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_PENTA6' ),IP6(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_PENTA6'),IP6(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_TETRA4' ),IT4(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_TETRA4' ),IT4(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_TETRA4'),IT4(3))

C     ELEMENT PRINCIPAUX 3D QUADRATIQUES
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_HEXA20' ),IH20(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_HEXA20' ),IH20(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_HEXA20'),IH20(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_PENTA15' ),IP15(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_PENTA15' ),IP15(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_PENTA15'),IP15(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_TETRA10' ),IT10(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_TETRA10' ),IT10(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_TETRA10'),IT10(3))

C     ELEMENT PRINCIPAUX 2D (CP/DP) LINEAIRES
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPQU4_XH' ),ICPQ4(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPQU4_XT' ),ICPQ4(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPQU4_XHT'),ICPQ4(3))
      
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPTR3_XH' ),ICPT3(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPTR3_XT' ),ICPT3(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPTR3_XHT'),ICPT3(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPQU4_XH' ),IDPQ4(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPQU4_XT' ),IDPQ4(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPQU4_XHT'),IDPQ4(3))
      
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPTR3_XH' ),IDPT3(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPTR3_XT' ),IDPT3(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPTR3_XHT'),IDPT3(3))

C     ELEMENT PRINCIPAUX 2D (CP/DP) QUADRATIQUES
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPQU8_XH' ),ICPQ8(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPQU8_XT' ),ICPQ8(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPQU8_XHT'),ICPQ8(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPTR6_XH' ),ICPT6(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPTR6_XT' ),ICPT6(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPTR6_XHT'),ICPT6(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPQU8_XH' ),IDPQ8(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPQU8_XT' ),IDPQ8(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPQU8_XHT'),IDPQ8(3))
      
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPTR6_XH' ),IDPT6(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPTR6_XT' ),IDPT6(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPTR6_XHT'),IDPT6(3))

C     ELEMENT DE BORD 3D LINEAIRES
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_FACE4' ),IF4(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_FACE4' ),IF4(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_FACE4'),IF4(3))
      
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_FACE3' ),IF3(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_FACE3' ),IF3(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_FACE3'),IF3(3))

C     ELEMENT DE BORD 3D QUADRATIQUES
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_FACE8' ),IF8(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_FACE8' ),IF8(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_FACE8'),IF8(3))
      
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XH_FACE6' ),IF6(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XT_FACE6' ),IF6(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHT_FACE6'),IF6(3))

C     ELEMENT DE BORD 2D (QUE DP) LINEAIRES
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEPLSE2_XH' ),IPF2(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEPLSE2_XT' ),IPF2(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEPLSE2_XHT'),IPF2(3))

C     ELEMENT DE BORD 2D (QUE DP) QUADRATIQUES
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEPLSE3_XH' ),IPF3(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEPLSE3_XT' ),IPF3(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEPLSE3_XHT'),IPF3(3))

C     ------------------------------------------------------------------
C                        ELEMENTS AVEC CONTACT
C     ------------------------------------------------------------------

C     ELEMENT PRINCIPAUX 3D LINEAIRES AVEC CONTACT
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHC_HEXA8' ),ICH8(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XTC_HEXA8' ),ICH8(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHTC_HEXA8'),ICH8(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHC_PENTA6' ),ICP6(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XTC_PENTA6' ),ICP6(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHTC_PENTA6'),ICP6(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHC_TETRA4' ),ICT4(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XTC_TETRA4' ),ICT4(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECA_XHTC_TETRA4'),ICT4(3))

C     ELEMENT PRINCIPAUX 2D (CP/DP) LINEAIRES AVEC CONTACT
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPQU4_XHC' ),ICPCQ4(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPQU4_XTC' ),ICPCQ4(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPQU4_XHTC'),ICPCQ4(3))
      
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPTR3_XHC' ),ICPCT3(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPTR3_XTC' ),ICPCT3(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MECPTR3_XHTC'),ICPCT3(3))

      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPQU4_XHC' ),IDPCQ4(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPQU4_XTC' ),IDPCQ4(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPQU4_XHTC'),IDPCQ4(3))
      
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPTR3_XHC' ),IDPCT3(1))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPTR3_XTC' ),IDPCT3(2))
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDPTR3_XHTC'),IDPCT3(3))



C     RECUPERATION DE L'ADRESSE DU TABLEAU DE TRAVAIL
      CALL JEVEUO(TRAV,'E',JTAB)

C     REMPLISSAGE DE LA 5EME COLONNE DU TABLEAU AVEC LE TYPE D'ELEMENT
      CALL JELIRA(LIEL1,'NMAXOC',NGR1,K8BID)
      DO 200 IGR1=1,NGR1
        CALL JEVEUO(JEXNUM(LIEL1,IGR1),'L',J1)
        CALL JELIRA(JEXNUM(LIEL1,IGR1),'LONMAX',N1,K8BID)
        NBELT=N1-1
        ITYPEL=ZI(J1-1+N1)
        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOTYPE)

        DO 210 IEL=1,NBELT
          IMA=ZI(J1-1+IEL)
          JJ=JTAB-1+5*(IMA-1)

          IF (K8CONT .EQ. 'NON') THEN

C           SI LE CONTACT N'EST PAS PRIS EN COMPTE
C           --------------------------------------

            IF (NOTYPE.EQ.'MECA_HEXA8') THEN
              CALL XMOAJO(JJ,IH8,ITYPEL,NH8)
            ELSEIF (NOTYPE.EQ.'MECA_HEXA20') THEN
              CALL XMOAJO(JJ,IH20,ITYPEL,NH20)
            ELSEIF (NOTYPE.EQ.'MECA_PENTA6') THEN
              CALL XMOAJO(JJ,IP6,ITYPEL,NP6)
            ELSEIF (NOTYPE.EQ.'MECA_PENTA15') THEN
              CALL XMOAJO(JJ,IP15,ITYPEL,NP15)
            ELSEIF (NOTYPE.EQ.'MECA_TETRA4') THEN
              CALL XMOAJO(JJ,IT4,ITYPEL,NT4)
            ELSEIF (NOTYPE.EQ.'MECA_TETRA10') THEN
              CALL XMOAJO(JJ,IT10,ITYPEL,NT10)
            ELSEIF (NOTYPE.EQ.'MECPQU4') THEN
              CALL XMOAJO(JJ,ICPQ4,ITYPEL,NCPQ4)
            ELSEIF (NOTYPE.EQ.'MECPQU8') THEN
              CALL XMOAJO(JJ,ICPQ8,ITYPEL,NCPQ8)
            ELSEIF (NOTYPE.EQ.'MECPTR3') THEN
              CALL XMOAJO(JJ,ICPT3,ITYPEL,NCPT3)
            ELSEIF (NOTYPE.EQ.'MECPTR6') THEN
              CALL XMOAJO(JJ,ICPT6,ITYPEL,NCPT6)
            ELSEIF (NOTYPE.EQ.'MEDPQU4') THEN
              CALL XMOAJO(JJ,IDPQ4,ITYPEL,NDPQ4)
            ELSEIF (NOTYPE.EQ.'MEDPQU8') THEN
              CALL XMOAJO(JJ,IDPQ8,ITYPEL,NDPQ8)
            ELSEIF (NOTYPE.EQ.'MEDPTR3') THEN
              CALL XMOAJO(JJ,IDPT3,ITYPEL,NDPT3)
            ELSEIF (NOTYPE.EQ.'MEDPTR6') THEN
              CALL XMOAJO(JJ,IDPT6,ITYPEL,NDPT6)
            ELSEIF (NOTYPE.EQ.'MECA_FACE4') THEN
              CALL XMOAJO(JJ,IF4,ITYPEL,NF4)
            ELSEIF (NOTYPE.EQ.'MECA_FACE8') THEN
              CALL XMOAJO(JJ,IF8,ITYPEL,NF8)
            ELSEIF (NOTYPE.EQ.'MECA_FACE3') THEN
              CALL XMOAJO(JJ,IF3,ITYPEL,NF3)
            ELSEIF (NOTYPE.EQ.'MECA_FACE6') THEN
              CALL XMOAJO(JJ,IF6,ITYPEL,NF6)
            ELSEIF (NOTYPE.EQ.'MEPLSE2') THEN
              CALL XMOAJO(JJ,IPF2,ITYPEL,NPF2)
            ELSEIF (NOTYPE.EQ.'MEPLSE3') THEN
              CALL XMOAJO(JJ,IPF3,ITYPEL,NPF3)
            ELSE
              ZI(JJ+5)=ITYPEL
            ENDIF

          ELSEIF (K8CONT .EQ. 'OUI') THEN

C           SI LE CONTACT EST PRIS EN COMPTE
C           --------------------------------

            IF (NOTYPE.EQ.'MECA_X_HEXA20') THEN
              CALL XMOAJO(JJ,ICH8,ITYPEL,NCH8)
            ELSEIF (NOTYPE.EQ.'MECA_X_PENTA15') THEN
              CALL XMOAJO(JJ,ICP6,ITYPEL,NCP6)
            ELSEIF (NOTYPE.EQ.'MECA_X_TETRA10') THEN
              CALL XMOAJO(JJ,ICT4,ITYPEL,NCT4)
            ELSEIF (NOTYPE.EQ.'MECPQU8_X') THEN
              CALL XMOAJO(JJ,ICPCQ4,ITYPEL,NCPCQ4)
            ELSEIF (NOTYPE.EQ.'MECPTR6_X') THEN
              CALL XMOAJO(JJ,ICPCT3,ITYPEL,NCPCT3)
            ELSEIF (NOTYPE.EQ.'MEDPQU8_X') THEN
              CALL XMOAJO(JJ,IDPCQ4,ITYPEL,NDPCQ4)
            ELSEIF (NOTYPE.EQ.'MEDPTR6_X') THEN
              CALL XMOAJO(JJ,IDPCT3,ITYPEL,NDPCT3)
            ELSEIF (NOTYPE.EQ.'MECA_X_FACE8') THEN
              CALL XMOAJO(JJ,IF4,ITYPEL,NF4)
            ELSEIF (NOTYPE.EQ.'MECA_X_FACE6') THEN
              CALL XMOAJO(JJ,IF3,ITYPEL,NF3)
            ELSEIF (NOTYPE.EQ.'MEPLSE3_X') THEN
              CALL XMOAJO(JJ,IPF3,ITYPEL,NPF2)
            ELSE
              ZI(JJ+5)=ITYPEL
            ENDIF

          ENDIF

        CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ZI(JJ+5)),NOBID)

 210    CONTINUE
 200  CONTINUE

C     IMPRESSIONS
      CALL XMOIMP(NH8,NH20,NP6,NP15,NT4,NT10,NCPQ4,NCPQ8,NCPT3,NCPT6,
     &            NDPQ4,NDPQ8,NDPT3,NDPT6,NF4,NF8,NF3,NF6,NPF2,NPF3,
     &            NCH8,NCP6,NCT4,NCPCQ4,NCPCT3,NDPCQ4,NDPCT3)

      CALL JEDEMA()
      END
