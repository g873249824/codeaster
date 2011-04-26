      SUBROUTINE CAFOND(CHAR,LIGRMO,IALLOC,NOMA,FONREE)
      IMPLICIT   NONE
      INTEGER IALLOC
      CHARACTER*4 FONREE
      CHARACTER*8 CHAR,NOMA
      CHARACTER*(*) LIGRMO
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

C BUT : STOCKAGE DE EFFE_FOND DANS LA CARTE PRES ALLOUEE SUR LE
C       LIGREL DU MODELE

C ARGUMENTS D'ENTREE:
C      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
C      LIGRMO : NOM DU LIGREL DE MODELE
C      IALLOC : 1 SI LA CARTE DE PRESSION ALLOUE PAR CAPRES, 0 SINON
C      NOMA   : NOM DU MAILLAGE
C      FONREE : FONC OU REEL

C-----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      INTEGER NPRES,JNCMP,JVALV,NCMP,IOCC,NPR,IATYMA,I,J,IMA,IADTYP,
     &        JMAI,JMAP,IBID,IFM,NIV,LVAL1,NBPT,NBMAI,NBMAP
      REAL*8 AIRE,LONG,EFF,PINT,SMAT,INER(10),CMULT
      COMPLEX*16 CBID
      CHARACTER*1 K1BID
      CHARACTER*3 KOCC
      CHARACTER*8 K8B,MAILLE,TYPE,LPAIN(2),LPAOUT(2),TYPMCL(3)
      CHARACTER*8 FPINT,FOEFF
      CHARACTER*16 MOTCLF,MOTCLE(3)
      CHARACTER*19 CARTE,LIGREL
      CHARACTER*24 LCHIN(2),LCHOUT(2),MESMAI,MESMAP,VALE
      CHARACTER*24 VALK(4)
C     ------------------------------------------------------------------

      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

      CALL JEVEUO(NOMA//'.TYPMAIL','L',IATYMA)

      MOTCLF = 'EFFE_FOND'
      CALL GETFAC(MOTCLF,NPRES)

      CARTE = CHAR//'.CHME.PRESS'
      IF (IALLOC.EQ.0) THEN
        IF (FONREE.EQ.'REEL') THEN
          CALL ALCART('G',CARTE,NOMA,'PRES_R')
        ELSEIF (FONREE.EQ.'FONC') THEN
          CALL ALCART('G',CARTE,NOMA,'PRES_F')
        ELSE
          CALL U2MESK('F','MODELISA2_37',1,FONREE)
        END IF
      ENDIF

      CALL JEVEUO(CARTE//'.NCMP','E',JNCMP)
      CALL JEVEUO(CARTE//'.VALV','E',JVALV)

C --- STOCKAGE DE PRESSIONS NULLES SUR TOUT LE MAILLAGE

      NCMP = 1
      ZK8(JNCMP) = 'PRES'
      IF (IALLOC.EQ.0) THEN
        IF (FONREE.EQ.'REEL') THEN
          ZR(JVALV) = 0.D0
        ELSE
          ZK8(JVALV) = '&FOZERO'
        ENDIF
        CALL NOCART(CARTE,1,' ','NOM',0,' ',0,LIGRMO,NCMP)
      END IF

      MESMAI = '&&CAFOND.MAILLES_INTE'
      MESMAP = '&&CAFOND.MAILLES_PRES'
      MOTCLE(1) = 'GROUP_MA_INT'
      MOTCLE(2) = 'GROUP_MA'
      MOTCLE(3) = 'MAILLE'
      TYPMCL(1) = 'GROUP_MA'
      TYPMCL(2) = 'GROUP_MA'
      TYPMCL(3) = 'MAILLE'

      LIGREL = '&&CAFOND.LIGREL'
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = NOMA//'.COORDO'
      LPAOUT(1) = 'PCASECT'
      LCHOUT(1) = '&&CAFOND.PSECT'

      DO 20 IOCC = 1,NPRES

C ------ ENSEMBLE DES MAILLES MODELISANT LE CONTOUR DE TUYAUTERIE
C        POUR CALCULER L'AIRE DU TROU

        CALL RELIEM(' ',NOMA,'NU_MAILLE',MOTCLF,IOCC,1,MOTCLE(1),
     &              TYPMCL(1),MESMAI,NBMAI)
        CALL JEVEUO(MESMAI,'L',JMAI)

C ------ ENSEMBLE DES MAILLES MODELISANT LA SECTION DE TUYAUTERIE
C        POUR APPLIQUER LA PRESSION

        CALL RELIEM(LIGRMO,NOMA,'NU_MAILLE',MOTCLF,IOCC,2,MOTCLE(2),
     &              TYPMCL(2),MESMAP,NBMAP)
        CALL JEVEUO(MESMAP,'L',JMAP)

        CALL EXLIM1(ZI(JMAP),NBMAP,LIGRMO,'V',LIGREL)

C ------ CALCUL DE L'EFFET DE FOND POUR CHAQUE OCCURENCE

        IF (FONREE.EQ.'REEL') THEN
          CALL GETVR8(MOTCLF,'PRES',IOCC,1,1,PINT,NPR)
        ELSE
          CALL GETVID(MOTCLF,'PRES',IOCC,1,1,FPINT,NPR)
        ENDIF

C ------ BORD DU TROU : CALCUL DE L'AIRE

        CALL PEAIR1(LIGRMO,NBMAI,ZI(JMAI),AIRE,LONG)

C ------ CALCUL SUR CHAQUE ELEMENT DES CARACTERISTIQUES GEOMETRIQUES :
C        SOMME/S_ELEMENT(1,X,Y,Z,X*X,Y*Y,Z*Z,X*Y,X*Z,Y*Z)DS

        CALL CALCUL('S','CARA_SECT_POUT3',LIGREL,1,LCHIN,LPAIN,1,LCHOUT,
     &              LPAOUT,'V','OUI')

C ------ VECTEUR DES QUANTITES GEOMETRIQUES PRECITEES SOMMEES
C        SUR LA SURFACE, CES QUANTITES SERONT NOTEES :
C        A1 = S,AX,AY,AZ,AXX,AYY,AZZ,AXY,AXZ,AYZ

C ------ SOMMATION DES QUANTITES GEOMETRIQUES ELEMENTAIRES

        CALL MESOMM(LCHOUT(1),10,IBID,INER,CBID,0,IBID)

        SMAT = INER(1)
        IF (FONREE.EQ.'REEL') THEN
          EFF = -PINT/SMAT*AIRE
          ZR(JVALV) = EFF
          IF (NIV.EQ.2) THEN
            WRITE (IFM,*) 'SURFACE DU TROU    ',AIRE
            WRITE (IFM,*) 'SURFACE DE MATIERE ',SMAT
            WRITE (IFM,*) 'EFFET DE FOND ',EFF
          END IF
        ELSE
          CALL CODENT(IOCC,'G',KOCC)
          FOEFF = '&FOEF'//KOCC
          CMULT = -1.D0/SMAT*AIRE
          CALL FOC1SU(FOEFF,1,FPINT,CMULT,CBID,'FONCTION',
     &               .FALSE.,.FALSE.,' ','G')
          ZK8(JVALV) = FOEFF
          IF (NIV.EQ.2) THEN
            WRITE (IFM,*) 'SURFACE DU TROU    ',AIRE
            WRITE (IFM,*) 'SURFACE DE MATIERE ',SMAT
            WRITE (IFM,*) 'EFFET DE FOND ',FOEFF,':'
            VALE(1:19) = FOEFF
            VALE(20:24) = '.VALE'
            CALL JELIRA(VALE,'LONUTI',NBPT,K1BID)
            CALL JEVEUO(VALE,'L',LVAL1)
            NBPT = NBPT/2
            DO 5 I=1,NBPT
              WRITE(IFM,*) '  ',ZR(LVAL1+I-1),',',ZR(LVAL1+NBPT+I-1)
    5       CONTINUE
          END IF
        ENDIF

        CALL JEDETR('&&CAFOND.LISTE_MAILLES')
        CALL JEDETC('V','&&CAFOND.LIGREL',1)

C ------ AFFECTATION DE LA PRESSION CORRESPONDANTE AUX MAILLES

        DO 10 J = 1,NBMAP
          IMA = ZI(JMAP-1+J)
          IADTYP = IATYMA - 1 + IMA
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(IADTYP)),TYPE)
          IF ((TYPE(1:4).NE.'QUAD') .AND. (TYPE(1:4).NE.'TRIA')) THEN
            CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',IMA),MAILLE)
            VALK (1) = MAILLE
            VALK (2) = 'QUAD'
            VALK (3) = 'TRIA'
            VALK (4) = MOTCLF
            CALL U2MESG('A', 'MODELISA8_40',4,VALK,0,0,0,0.D0)
          END IF
   10   CONTINUE
        CALL NOCART(CARTE,3,K8B,'NUM',NBMAP,K8B,ZI(JMAP),' ',NCMP)

        CALL JEDETR(MESMAI)
        CALL JEDETR(MESMAP)

   20 CONTINUE

      CALL JEDETR(CHAR//'.PRES.GROUP')
      CALL JEDETR(CHAR//'.PRES.LISTE')
C-----------------------------------------------------------------------
      CALL JEDEMA()
      END
