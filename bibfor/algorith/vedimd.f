      SUBROUTINE VEDIMD(NOMO  ,LISCHA,INSTAN,TYPESE,NOPASE,
     &                  VECELE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/01/2012   AUTEUR ABBAS M.ABBAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C
      IMPLICIT      NONE
      CHARACTER*19  LISCHA,VECELE
      INTEGER       TYPESE
      CHARACTER*(*) NOPASE
      CHARACTER*8   NOMO
      REAL*8        INSTAN
C
C ----------------------------------------------------------------------
C
C CALCUL DES VECTEURS ELEMENTAIRES
C
C MECANIQUE - DIRICHLET
C
C ----------------------------------------------------------------------
C
C
C IN  NOMO   : NOM DU MODELE
C IN  LISCHA : SD LISTE DES CHARGES
C IN  INSTAN : INSTANT DE CALCUL
C IN  TYPESE : TYPE DE SENSIBILITE
C               0 : CALCUL STANDARD, NON DERIVE
C               SINON : DERIVE (VOIR METYSE)
C IN  NOPASE : NOM DU PARAMETRE SENSIBLE
C OUT VECELE : VECT_ELEM RESULTAT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=1, NBIN=3)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      CHARACTER*8  NOMCH0,NOMCHS
      CHARACTER*8  K8BID,NEWNOM
      CHARACTER*16 OPTION
      CHARACTER*19 LIGRMO,LIGRCS,LIGCAL
      CHARACTER*13 PREFOB
      CHARACTER*19 CHGEOM,CHTIME
      CHARACTER*19 CARTE,CARTES
      CHARACTER*8  PARAIN,PARAOU,TYPECH
      INTEGER      JNOLI,NBNOLI
      INTEGER      IAUX,IBID,IRET
      INTEGER      ICHAR,NBCHAR,CODCHA
      INTEGER      EXICHA
      LOGICAL      LISICO,LDUAL
      CHARACTER*24 NOMLIS
      INTEGER      JLISCI,NBCH,INDXCH
      COMPLEX*16   C16BID
      INTEGER      LISNBG,NBDUAL
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      NEWNOM    = '.0000000'
      NOMLIS    = '&&NOMLIS'
      CALL DETRSD('VECT_ELEM',VECELE)
C
C --- RECUPERATION DU MODELE
C
      LIGRMO = NOMO(1:8)//'.MODELE'
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)
C
C --- NOMBRE DE CHARGES
C
      CALL LISNNB(LISCHA,NBCHAR)
      IF (NBCHAR.EQ.0) GOTO 99
C
C --- PRESENCE DE CE GENRE DE CHARGEMENT
C
      NBDUAL = LISNBG(LISCHA,'DIRI_DUAL')
      IF (NBDUAL.EQ.0) GOTO 99
C
C --- ALLOCATION DU VECT_ELEM RESULTAT
C
      CALL MEMARE('V',VECELE,NOMO  ,' ',' ','CHAR_MECA')
      CALL REAJRE(VECELE,' ','V')
C
C --- CHAMP DE GEOMETRIE
C
      CALL MECOOR(NOMO  ,CHGEOM)
C
C --- CARTE DE L'INSTANT
C
      CHTIME = '&&VEDIMD.CH_INST_R'
      CALL MECACT('V'   ,CHTIME,'MODELE',LIGRMO,'INST_R',
     &            1     ,'INST',IBID    ,INSTAN,C16BID  ,
     &            K8BID )
C
C --- CHAMPS D'ENTREES STANDARDS
C
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PTEMPSR'
      LCHIN(2) = CHTIME
C
C --- LISTE DES INDEX DES CHARGES
C
      CALL LISNOL(LISCHA,'DIRI_DUAL',NOMLIS,NBCH  )
      CALL ASSERT(NBCH.EQ.1)
      CALL JEVEUO(NOMLIS,'L',JLISCI)
      INDXCH = ZI(JLISCI-1+1)
C
C --- CALCUL
C
      DO 30 ICHAR = 1,NBCHAR
        CALL LISLCO(LISCHA,ICHAR ,CODCHA)
        LDUAL  = LISICO('DIRI_DUAL',CODCHA)
        IF (LDUAL) THEN
C
C ------- PREFIXE DE L'OBJET DE LA CHARGE
C
          CALL LISLLC(LISCHA,ICHAR ,PREFOB)
C
C ------- TYPE DE LA CHARGE
C
          CALL LISLTC(LISCHA,ICHAR ,TYPECH)
C
C ------- NOM DE LA CHARGE
C
          CALL LISLCH(LISCHA,ICHAR ,NOMCH0)
          IF (TYPESE.NE.0) THEN
            CALL PSGENC(NOMCH0,NOPASE,NOMCHS,EXICHA)
          ELSE
            EXICHA = 0
          ENDIF
C
C ------- CALCUL SI CHARGE EXISTANTE
C
          IF (EXICHA.EQ.0) THEN
            CALL LISOPT(PREFOB,NOMO  ,TYPECH,INDXCH,OPTION,
     &                  PARAIN,PARAOU,CARTE ,LIGCAL)
C
C --------- CARTE SENSIBLE
C
            CARTES      = CARTE
            IF (TYPESE.NE.0) CARTES(1:8) = NOMCHS
C
C --------- SENSIBILITE -> ON UTILISE LIGCAL
C
            IF (TYPESE.NE.0) THEN
              CALL JELIRA(CARTES(1:19)//'.NOLI','LONMAX',NBNOLI,
     &                    K8BID)
              CALL JEVEUO(CARTES(1:19)//'.NOLI','E',JNOLI)
              LIGRCS = ZK24(JNOLI)(1:19)
              DO 10 IAUX = 1,NBNOLI
                ZK24(JNOLI-1+IAUX) = LIGCAL
   10         CONTINUE
            ENDIF
C
C --------- CARTE D'ENTREE
C
            LPAIN(3)  = PARAIN
            LCHIN(3)  = CARTES
C
C --------- CARTE DE SORTIE
C
            LPAOUT(1) = PARAOU
            CALL GCNCO2(NEWNOM)
            LCHOUT(1) = '&&VEDIMD.'//NEWNOM(2:8)
            CALL CORICH('E',LCHOUT(1),ICHAR,IBID)
C
C --------- CALCUL
C
            CALL CALCUL('S',OPTION,LIGCAL,NBIN  ,LCHIN ,LPAIN ,
     &                                    NBOUT ,LCHOUT,LPAOUT,
     &                                    'V'   ,'OUI' )
C
C --------- RESU_ELEM DANS LE VECT_ELEM
C
            CALL EXISD('CHAMP_GD',LCHOUT(1),IRET)
            CALL ASSERT(IRET.GT.0)
            CALL REAJRE(VECELE,LCHOUT(1),'V')
C
C --------- SENSIBILITE -> ON REMET LIGRCS
C
            IF (TYPESE.NE.0) THEN
              DO 20 IAUX = 1,NBNOLI
                ZK24(JNOLI-1+IAUX) = LIGRCS
   20         CONTINUE
            ENDIF
          ENDIF
        ENDIF
   30 CONTINUE
C
   99 CONTINUE
C
      CALL JEDETR(NOMLIS)
C
      CALL JEDEMA()
      END
