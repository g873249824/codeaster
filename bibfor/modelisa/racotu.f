      SUBROUTINE RACOTU(IPRNO,LONLIS,KLISNO,NOEPOU,NOMA,LIGREL,MOD,CARA,
     &                  NUMDDL,TYPLAG,LISREL,COORIG)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER LONLIS,IPRNO(*)
      CHARACTER*2 TYPLAG
      CHARACTER*8 KLISNO(LONLIS),NOEPOU,NOMA,CARA,MOD
      CHARACTER*14 NUMDDL
      CHARACTER*19 LIGREL,LISREL
      REAL*8 COORIG(3)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C -------------------------------------------------------
C     RACCORD COQUE_TUYAU PAR DES RELATIONS LINEAIRES

      INTEGER NBCMP,NBMODE,NUMNO1,JCOOR
      PARAMETER (NBMODE=3,NBCMP=6* (NBMODE-1))
      CHARACTER*1 K1BID
      CHARACTER*8 NOCMP(NBCMP),LPAIN(6),LPAOUT(3),NOMDDL(4)
      CHARACTER*24 LCHIN(6),LCHOUT(3),VALECH
      REAL*8 RBID,COEF(4),EG1(3),EG2(3),EG3(3)
      REAL*8 RAYON,COORI1(3),GP1(3)
      COMPLEX*16 CBID
      INTEGER IMOD,INFO,IFM
      INTEGER NBCOEF,IDEC

      CALL JEMARQ()
      CALL INFNIV(IFM,INFO)

C     CALCUL DU RAYON DU MAILLAGE COQUE A L'AIDE DU PREMIER N

      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
      CALL JENONU(JEXNOM(NOMA//'.NOMNOE',KLISNO(1)),NUMNO1)
      COORI1(1) = ZR(JCOOR-1+3* (NUMNO1-1)+1)
      COORI1(2) = ZR(JCOOR-1+3* (NUMNO1-1)+2)
      COORI1(3) = ZR(JCOOR-1+3* (NUMNO1-1)+3)
      CALL VDIFF(3,COORIG,COORI1,GP1)
      CALL NORMEV(GP1,RAYON)

C     CREATION D'UNE CARTE CONTENANT LE POINT P ORIGINE DE PHI

      CALL RAORFI(NOMA,LIGREL,NOEPOU,CARA,COORIG,EG1,EG2,
     &            EG3,'&&RACOTU',RAYON)

C --- DETERMINATION DE 3 LISTES  DE VECTEURS PAR ELEMENT PRENANT
C --- LEURS VALEURS AUX NOEUDS DES ELEMENTS. CES VALEURS SONT :
C     VECT_COEF_UM
C --- 1/PI* SOMME/S_ELEMENT(COS(M.PHI).P(1,J).NI)DS
C --- 1/PI* SOMME/S_ELEMENT(SIN(M.PHI).P(1,J).NI)DS
C     VECT_COEF_VM
C --- 1/PI* SOMME/S_ELEMENT(COS(M.PHI).P(2,J).NI)DS
C --- 1/PI* SOMME/S_ELEMENT(SIN(M.PHI).P(2,J).NI)DS
C     VECT_COEF_WM
C --- 1/PI* SOMME/S_ELEMENT(COS(M.PHI).P(3,J).NI)DS
C --- 1/PI* SOMME/S_ELEMENT(SIN(M.PHI).P(3,J).NI)DS

C --- OU P EST LA MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
C --- (E1,E2,E3) DEFINI SUR LE BORD ORIENTE DE LA COQUE
C     ------------------------------
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = NOMA//'.COORDO'
      LPAIN(2) = 'PORIGIN'
      LCHIN(2) = '&&RAPOCO.CAORIGE'
      LPAIN(3) = 'PCACOQU'
      LCHIN(3) = CARA//'.CARCOQUE'
      LPAIN(4) = 'PCAORIE'
      LCHIN(4) = '&&RACOTU.CAXE_TUY'
      LPAIN(5) = 'PORIGFI'
      LCHIN(5) = '&&RACOTU.CAORIFI'
      LPAIN(6) = 'PNUMMOD'
      LCHIN(6) = '&&RAPOTU.NUME_MODE'
      LPAOUT(1) = 'PVECTU1'
      LCHOUT(1) = '&&RAPOTU.COEF_UM'
      LPAOUT(2) = 'PVECTU2'
      LCHOUT(2) = '&&RAPOTU.COEF_VM'
      LPAOUT(3) = 'PVECTU3'
      LCHOUT(3) = '&&RAPOTU.COEF_WM'

C --- CREATION DES .RERR DES VECTEURS EN SORTIE DE CALCUL
      CALL MEMARE('V','&&RAPOTU',MOD,' ',' ','CHAR_MECA')

C --- CREATION DU .RELR
      CALL JEDETR('&&RAPOTU           .RELR')
      CALL REAJRE('&&RAPOTU',' ','V')

C     RELATIONS ENTRE LES NOEUDS DE COQUE ET LE NOEUD POUTRE DDL WO

      IMOD = 0
      CALL MECACT('V',LCHIN(6),'LIGREL',LIGREL,'NUMMOD',1,'NUM',IMOD,
     &            RBID,CBID,K1BID)
      CALL CALCUL('S','CARA_SECT_POUT5',LIGREL,6,LCHIN,LPAIN,3,LCHOUT,
     &            LPAOUT,'V','OUI')
      CALL JEDETR('&&RAPOTU           .RELR')
      CALL REAJRE('&&RAPOTU',LCHOUT(3),'V')
      CALL ASSVEC('V','CH_DEPL_3',1,'&&RAPOTU           .RELR',
     &             1.D0,NUMDDL,' ','ZERO',1)
      VALECH = 'CH_DEPL_3          .VALE'
      NBCOEF = 1
      IDEC = 0
      NOMDDL(1) = 'WO'
      COEF(1) = -2.D0
      CALL AFRETU(IPRNO,LONLIS,KLISNO,NOEPOU,NOMA,VALECH,NBCOEF,IDEC,
     &            COEF,NOMDDL,TYPLAG,LISREL)
C        FIN IMOD=0

C   RELATIONS ENTRE LES NOEUDS DE COQUE ET LE NOEUD POUTRE
C   DDL UIM, UOM, VIM, VOM, WIM, WOM, M VARIANT DE 2 A NBMODE

      NOCMP(1) = 'UI2'
      NOCMP(2) = 'VI2'
      NOCMP(3) = 'WI2'
      NOCMP(4) = 'UO2'
      NOCMP(5) = 'VO2'
      NOCMP(6) = 'WO2'
      NOCMP(7) = 'UI3'
      NOCMP(8) = 'VI3'
      NOCMP(9) = 'WI3'
      NOCMP(10) = 'UO3'
      NOCMP(11) = 'VO3'
      NOCMP(12) = 'WO3'

      DO 10 IMOD = 1,NBMODE
        IF (INFO.EQ.2) THEN
          WRITE (IFM,*) 'RELATIONS SUR LE MODE ',IMOD
        END IF
        CALL MECACT('V',LCHIN(6),'LIGREL',LIGREL,'NUMMOD',1,'NUM',IMOD,
     &              RBID,CBID,K1BID)
        CALL CALCUL('S','CARA_SECT_POUT5',LIGREL,6,LCHIN,LPAIN,3,LCHOUT,
     &              LPAOUT,'V','OUI')
        CALL JEDETR('&&RAPOTU           .RELR')
        CALL REAJRE('&&RAPOTU',LCHOUT(1),'V')
        CALL ASSVEC('V','CH_DEPL_1',1,'&&RAPOTU           .RELR',
     &              1.D0,NUMDDL,' ','ZERO',1)
        VALECH = 'CH_DEPL_1          .VALE'

C        RELATIONS ENTRE LES NOEUDS DE COQUE ET LE NOEUD POUTRE DDL UIM

        IDEC = 0
        IF (IMOD.NE.1) THEN
          NBCOEF = 1
          NOMDDL(1) = NOCMP(6* (IMOD-2)+1)
          COEF(1) = -1.D0
          CALL AFRETU(IPRNO,LONLIS,KLISNO,NOEPOU,NOMA,VALECH,NBCOEF,
     &                IDEC,COEF,NOMDDL,TYPLAG,LISREL)

        END IF

C        RELATIONS ENTRE LES NOEUDS DE COQUE ET LE NOEUD POUTRE DDL UOM

        IDEC = 3
        IF (IMOD.NE.1) THEN
          NBCOEF = 1
          NOMDDL(1) = NOCMP(6* (IMOD-2)+4)
          COEF(1) = -1.D0
          CALL AFRETU(IPRNO,LONLIS,KLISNO,NOEPOU,NOMA,VALECH,NBCOEF,
     &                IDEC,COEF,NOMDDL,TYPLAG,LISREL)
        END IF

C        RELATIONS ENTRE LES NOEUDS DE COQUE ET LE NOEUD POUTRE DDL VOM
        CALL JEDETR('&&RAPOTU           .RELR')
        CALL REAJRE('&&RAPOTU',LCHOUT(2),'V')
        CALL ASSVEC('V','CH_DEPL_2',1,'&&RAPOTU           .RELR',
     &               1.D0,NUMDDL,' ','ZERO',1)
        VALECH = 'CH_DEPL_2          .VALE'
        IDEC = 0
        IF (IMOD.NE.1) THEN
          NBCOEF = 1
          NOMDDL(1) = NOCMP(6* (IMOD-2)+5)
CCCC            COEF(1)  =  -1.D0
          COEF(1) = -1.D0
          CALL AFRETU(IPRNO,LONLIS,KLISNO,NOEPOU,NOMA,VALECH,NBCOEF,
     &                IDEC,COEF,NOMDDL,TYPLAG,LISREL)
        END IF

C        RELATIONS ENTRE LES NOEUDS DE COQUE ET LE NOEUD POUTRE DDL VIM
C        IDEC=3 SIGNIFIE QUE ON UTILISE LES TERMES EN SIN(M*PHI)

        IDEC = 3
        IF (IMOD.NE.1) THEN
          NBCOEF = 1
          NOMDDL(1) = NOCMP(6* (IMOD-2)+2)
CCCC            COEF(1)  =  1.D0
          COEF(1) = -1.D0
          CALL AFRETU(IPRNO,LONLIS,KLISNO,NOEPOU,NOMA,VALECH,NBCOEF,
     &                IDEC,COEF,NOMDDL,TYPLAG,LISREL)
        END IF

C        RELATIONS ENTRE LES NOEUDS DE COQUE ET LE NOEUD POUTRE DDL WIM
C        OU SI IMOD=1 LE DDL DZ DANS REPERE LOCAL DU TUYAU ET WI1
C        IDEC=0 SIGNIFIE QUE ON UTILISE LES TERMES EN COS(M*PHI)

        CALL JEDETR('&&RAPOTU           .RELR')
        CALL REAJRE('&&RAPOTU',LCHOUT(3),'V')
        CALL ASSVEC('V','CH_DEPL_3',1,'&&RAPOTU           .RELR',
     &               1.D0,NUMDDL,' ','ZERO',1)
        VALECH = 'CH_DEPL_3          .VALE'
        IDEC = 0

        IF (IMOD.EQ.1) THEN
          NBCOEF = 4
          NOMDDL(1) = 'DX'
          NOMDDL(2) = 'DY'
          NOMDDL(3) = 'DZ'
          NOMDDL(4) = 'WI1'
          COEF(1) = EG3(1)
          COEF(2) = EG3(2)
          COEF(3) = EG3(3)
          COEF(4) = -1.D0
        ELSE
C         IF (IMOD.NE.1) THEN
          NBCOEF = 1
          NOMDDL(1) = NOCMP(6* (IMOD-2)+3)
          COEF(1) = -1.D0
        END IF
        CALL AFRETU(IPRNO,LONLIS,KLISNO,NOEPOU,NOMA,VALECH,NBCOEF,IDEC,
     &              COEF,NOMDDL,TYPLAG,LISREL)
C         ENDIF

C        RELATIONS ENTRE LES NOEUDS DE COQUE ET LE NOEUD POUTRE DDL WOM
C        OU SI IMOD=1 LE DDL DY DANS REPERE LOCAL DU TUYAU ET WO1
C        IDEC=3 SIGNIFIE QUE ON UTILISE LES TERMES EN SIN(M*PHI)

        IDEC = 3
        IF (IMOD.EQ.1) THEN
          NBCOEF = 4
          NOMDDL(1) = 'DX'
          NOMDDL(2) = 'DY'
          NOMDDL(3) = 'DZ'
          NOMDDL(4) = 'WO1'
          COEF(1) = EG2(1)
          COEF(2) = EG2(2)
          COEF(3) = EG2(3)
          COEF(4) = -1.D0
        ELSE
C         IF (IMOD.NE.1) THEN
          NBCOEF = 1
          NOMDDL(1) = NOCMP(6* (IMOD-2)+6)
          COEF(1) = -1.D0
        END IF
        CALL AFRETU(IPRNO,LONLIS,KLISNO,NOEPOU,NOMA,VALECH,NBCOEF,IDEC,
     &              COEF,NOMDDL,TYPLAG,LISREL)
C         ENDIF

C     FIN DE LA BOUCLE SUR LES MODES

   10 CONTINUE

C --- DESTRUCTION DES OBJETS DE TRAVAIL

      CALL JEDETC('V','&&RAPOTU           ',1)
      CALL JEDETC('V','&&RACOTU           ',1)
      CALL JEDETC('V','CH_DEPL_1',1)
      CALL JEDETC('V','CH_DEPL_2',1)
      CALL JEDETC('V','CH_DEPL_3',1)

      CALL JEDEMA()
      END
