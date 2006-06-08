      SUBROUTINE QIRES1(MODELE,LIGREL,CHTIME,
     &                SIGMAP,SIGMAD,LCHARP,LCHARD,NCHARP,NCHARD,CHS,
     &                MATE,CHVOIS,IATYMA,IAGD,IACMP,ICONX1,ICONX2,RESU)
      IMPLICIT NONE
      INTEGER       NCHARP,NCHARD,IATYMA,IAGD,IACMP,ICONX1,ICONX2
      CHARACTER*8   MODELE,LCHARP(1),LCHARD(1)
      CHARACTER*24  CHTIME,SIGMAP,SIGMAD,CHS,CHVOIS,RESU
      CHARACTER*(*) LIGREL,MATE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 04/04/2006   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C
C     BUT:
C         CALCUL DE L'ESTIMATEUR D'ERREUR QUANTITE D'INTERET AVEC LES 
C         RESIDUS EXPLICITES.
C
C                 OPTION : 'QIRE_ELEM_SIGM'
C
C         COPIE DE RESLOC.F AVEC AJOUT DES DONNEES DU PROBLEME DUAL.
C
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   MODELE : NOM DU MODELE
C IN   LIGREL : NOM DU LIGREL
C IN   CHTIME : NOM DU CHAMP DES INSTANTS
C IN   SIGMAP : CHAMP DE CONTRAINTES DU PB. PRIMAL (CHAM_ELEM_SIEF_R)
C IN   SIGMAD : CHAMP DE CONTRAINTES DU PB. DUAL (CHAM_ELEM_SIEF_R)
C IN   LCHARP : LISTE DES CHARGEMENTS DU PROBLEME PRIMAL
C IN   LCHARD : LISTE DES CHARGEMENTS DU PROBLEME DUAL
C IN   NCHARP : NOMBRE DE CHARGEMENTS DU PROBLEME PRIMAL
C IN   NCHARD : NOMBRE DE CHARGEMENTS DU PROBLEME DUAL
C IN   CHS    : CARTE CONSTANTE DU COEFFICIENT DE PONDERATION S
C IN   MATE   : NOM DU CHAMP MATERIAU
C IN   CHVOIS : NOM DU CHAMP DES VOISINS
C IN   IATYMA : ADRESSE DU VECTEUR TYPE MAILLE (NUMERO <-> NOM)
C IN   IAGD   : ADRESSE DU VECTEUR GRANDEUR (NUMERO <-> NOM)
C IN   IACMP  : ADRESSE DU VECTEUR NOMBRE DE COMPOSANTES 
C                     (NUMERO DE GRANDEUR <-> NOMBRE DE COMPOSANTES)
C IN   ICONX1 : ADRESSE DE LA COLLECTION CONNECTIVITE
C IN   ICONX2 : ADRESSE DU POINTEUR DE LONGUEUR DE LA CONNECTIVITE
C
C      SORTIE :
C-------------
C OUT  RESU   : NOM DU CHAM_ELEM_ERREUR PRODUIT
C               SI RESU EXISTE DEJA, ON LE DETRUIT.
C
C ......................................................................

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER      I,IRET,IRET1,IRET2,IRET3,IRET4,IRET5,IRET6,IRET7
      INTEGER      IRET8,IRET9,IRET10,IRET11,IRET12,IRET13,IRET14
      INTEGER      IBID,IER,IAREPE
      INTEGER      IADEP1,IADEP2,IAVAP1,IAVAP2
      INTEGER      IADED1,IADED2,IAVAD1,IAVAD2
      INTEGER      JCELDP,JCELVP,JCELDD,JCELVD
      INTEGER      IPTMP1,IPTMP2,NUMGP1,NUMGP2
      INTEGER      IPTMD1,IPTMD2,NUMGD1,NUMGD2
      INTEGER      ICMPP(12),ICMPD(12),TIME

      REAL*8       R8BID

      CHARACTER*1  BASE
      CHARACTER*8  LPAIN(17),LPAOUT(1),MA,K8BID
      CHARACTER*8  LICMPP(12),LICMPD(12)
      CHARACTER*16 OPTION,OPT
      CHARACTER*19 CARTP1,CARTP2,NOMGP1,NOMGP2
      CHARACTER*19 CARTD1,CARTD2,NOMGD1,NOMGD2
      CHARACTER*24 LCHIN(17),LCHOUT(1),MOD,CHGEOM
      CHARACTER*24 CFORP1,CFORP2,CFORP3,CFORD1,CFORD2,CFORD3

      COMPLEX*16   C16BID

      LOGICAL      EXIGEO,EXIMAT

C ----------------------------------------------------------------------
      BASE = 'V'
      CALL MEGEOM(MODELE,LCHARP(1),EXIGEO,CHGEOM)
      IF (.NOT.EXIGEO) CALL UTMESS('F','QIRES1','PAS DE CHGEOM')

C ------- DEBUT TEST SUR LE TYPE DE CHARGE DES BORDS POUR LE PB. PRIMAL

C   ATTENTION : POUR UN MEME CHARGEMENT (FORCE_FACE OU PRES_REP), SEULE
C   LA DERNIERE CHARGE EST CONSIDEREE (REGLE DE SURCHARGE ACTUELLEMENT)

      CARTP1 = ' '
      CARTP2 = ' '
      NOMGP1 = ' '
      NOMGP2 = ' '
      IRET1 = 0
      IRET2 = 0
      IRET3 = 0
      DO 10 I = 1,NCHARP
        CALL EXISD('CHAMP_GD',LCHARP(I)//'.CHME.F1D2D',IRET1)
        CALL EXISD('CHAMP_GD',LCHARP(I)//'.CHME.F2D3D',IRET2)
        CALL EXISD('CHAMP_GD',LCHARP(I)//'.CHME.PRESS',IRET3)
        IF (IRET1.NE.0) THEN
          CARTP1 = LCHARP(I)//'.CHME.F1D2D'
          CALL DISMOI('F','NOM_GD',CARTP1,'CARTE',IBID,NOMGP1,IER)
          CALL ETENCA(CARTP1,LIGREL,IRET)
          IF (IRET.NE.0) THEN
            CALL UTMESS('F','QIRES1','ERREUR DANS ETANCA POUR LE '//
     &                  'PROBLEME PRIMAL')
          END IF
        ELSE IF (IRET2.NE.0) THEN
          CARTP1 = LCHARP(I)//'.CHME.F2D3D'
          CALL DISMOI('F','NOM_GD',CARTP1,'CARTE',IBID,NOMGP1,IER)
          CALL ETENCA(CARTP1,LIGREL,IRET)
          IF (IRET.NE.0) THEN
            CALL UTMESS('F','QIRES1','ERREUR DANS ETANCA POUR LE '//
     &                  'PROBLEME PRIMAL')
          END IF
        END IF
        IF (IRET3.NE.0) THEN
          CARTP2 = LCHARP(I)//'.CHME.PRESS'
          CALL DISMOI('F','NOM_GD',CARTP2,'CARTE',IBID,NOMGP2,IER)
          CALL ETENCA(CARTP2,LIGREL,IRET)
          IF (IRET.NE.0) THEN
            CALL UTMESS('F','QIRES1','ERREUR DANS ETANCA POUR LE '//
     &                  'PROBLEME PRIMAL')
          END IF
        END IF
   10 CONTINUE

C ------- FIN TEST SUR LE TYPE DE CHARGE DES BORDS POUR LE PB. PRIMAL

C ------- DEBUT TEST SUR LE TYPE DE CHARGE DES BORDS POUR LE PB. DUAL

C   ATTENTION : POUR UN MEME CHARGEMENT (FORCE_FACE OU PRES_REP), SEULE
C   LA DERNIERE CHARGE EST CONSIDEREE (REGLE DE SURCHARGE ACTUELLEMENT)

      CARTD1 = ' '
      CARTD2 = ' '
      NOMGD1 = ' '
      NOMGD2 = ' '
      IRET4 = 0
      IRET5 = 0
      IRET6 = 0
      DO 11 I = 1,NCHARD
        CALL EXISD('CHAMP_GD',LCHARD(I)//'.CHME.F1D2D',IRET4)
        CALL EXISD('CHAMP_GD',LCHARD(I)//'.CHME.F2D3D',IRET5)
        CALL EXISD('CHAMP_GD',LCHARD(I)//'.CHME.PRESS',IRET6)
        IF (IRET4.NE.0) THEN
          CARTD1 = LCHARD(I)//'.CHME.F1D2D'
          CALL DISMOI('F','NOM_GD',CARTD1,'CARTE',IBID,NOMGD1,IER)
          CALL ETENCA(CARTD1,LIGREL,IRET)
          IF (IRET.NE.0) THEN
            CALL UTMESS('F','QIRES1','ERREUR DANS ETANCA POUR LE '//
     &                  'PROBLEME DUAL')
          END IF
        ELSE IF (IRET5.NE.0) THEN
          CARTD1 = LCHARD(I)//'.CHME.F2D3D'
          CALL DISMOI('F','NOM_GD',CARTD1,'CARTE',IBID,NOMGD1,IER)
          CALL ETENCA(CARTD1,LIGREL,IRET)
          IF (IRET.NE.0) THEN
            CALL UTMESS('F','QIRES1','ERREUR DANS ETANCA POUR LE '//
     &                  'PROBLEME DUAL')
          END IF
        END IF
        IF (IRET6.NE.0) THEN
          CARTD2 = LCHARD(I)//'.CHME.PRESS'
          CALL DISMOI('F','NOM_GD',CARTD2,'CARTE',IBID,NOMGD2,IER)
          CALL ETENCA(CARTD2,LIGREL,IRET)
          IF (IRET.NE.0) THEN
            CALL UTMESS('F','QIRES1','ERREUR DANS ETANCA POUR LE '//
     &                  ' PROBLEME DUAL')
          END IF
        END IF
   11 CONTINUE

C ------- FIN TEST SUR LE TYPE DE CHARGE DES BORDS POUR LE PB. DUAL


C ------- CREATION DE 2 CARTES CONTENANT DES ADRESSES D'OBJETS JEVEUX --
C ------------------------- PROBLEME PRIMAL ----------------------------

      LICMPP(1) = 'X1'
      LICMPP(2) = 'X2'
      LICMPP(3) = 'X3'
      LICMPP(4) = 'X4'
      LICMPP(5) = 'X5'
      LICMPP(6) = 'X6'
      LICMPP(7) = 'X7'
      LICMPP(8) = 'X8'
      LICMPP(9) = 'X9'
      LICMPP(10) = 'X10'
      LICMPP(11) = 'X11'
      LICMPP(12) = 'X12'

      CALL JEVEUO(LIGREL(1:19)//'.REPE','L',IAREPE)
      CALL JEVEUO(SIGMAP(1:19)//'.CELD','L',JCELDP)
      CALL JEVEUO(SIGMAP(1:19)//'.CELV','L',JCELVP)
C
      IF (CARTP1 .NE. ' ') THEN
        CALL JEVEUO (CARTP1//'.DESC','L',IADEP1)
        CALL JEVEUO (CARTP1//'.VALE','L',IAVAP1)
        CALL JEEXIN (CARTP1//'.PTMA',IRET)
        IF (IRET .EQ. 0) THEN
          IPTMP1 = 0
        ELSE
C            LA CARTE A ETE ETENDUE
          CALL JEVEUO (CARTP1//'.PTMA','L',IPTMP1)
        ENDIF
        CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGP1),NUMGP1)
      ELSE
        IADEP1 = 0
        IAVAP1 = 0
      ENDIF
C
      IF (CARTP2 .NE. ' ') THEN
        CALL JEVEUO (CARTP2//'.DESC','L',IADEP2)
        CALL JEVEUO (CARTP2//'.VALE','L',IAVAP2)
        CALL JEEXIN (CARTP2//'.PTMA',IRET)
        IF (IRET .EQ. 0) THEN
          IPTMP2 = 0
        ELSE
C            LA CARTE A ETE ETENDUE
          CALL JEVEUO (CARTP2//'.PTMA','L',IPTMP2)
        ENDIF
        CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGP2),NUMGP2)
      ELSE
        IADEP2 = 0
        IAVAP2 = 0
      ENDIF
C
      ICMPP(1)  = IAREPE
      ICMPP(2)  = JCELDP
      ICMPP(3)  = JCELVP
      ICMPP(4)  = IATYMA
      ICMPP(5)  = IAGD
      ICMPP(6)  = IACMP
      ICMPP(11) = ICONX1
      ICMPP(12) = ICONX2
C      
      ICMPP(7)  = IADEP1
      ICMPP(8)  = IAVAP1
      ICMPP(9)  = IPTMP1
      ICMPP(10) = NUMGP1

      CALL MECACT(BASE,'&&QIRES1.CH_FORCEP','MODELE',LIGREL,'NEUT_I',12,
     &            LICMPP,ICMPP,R8BID,C16BID,K8BID)

      ICMPP(7)  = IADEP2
      ICMPP(8)  = IAVAP2
      ICMPP(9)  = IPTMP2
      ICMPP(10) = NUMGP2

      CALL MECACT(BASE,'&&QIRES1.CH_PRESSP','MODELE',LIGREL,'NEUT_I',12,
     &            LICMPP,ICMPP,R8BID,C16BID,K8BID)

C ------- FIN CREATION CARTES PB. PRIMAL--------------------------------

C ------- CREATION DE 2 CARTES CONTENANT DES ADRESSES D'OBJETS JEVEUX --
C --------------------------- PROBLEME DUAL ----------------------------
C
      LICMPD(1) = 'X1'
      LICMPD(2) = 'X2'
      LICMPD(3) = 'X3'
      LICMPD(4) = 'X4'
      LICMPD(5) = 'X5'
      LICMPD(6) = 'X6'
      LICMPD(7) = 'X7'
      LICMPD(8) = 'X8'
      LICMPD(9) = 'X9'
      LICMPD(10) = 'X10'
      LICMPD(11) = 'X11'
      LICMPD(12) = 'X12'
C
      CALL JEVEUO(LIGREL(1:19)//'.REPE','L',IAREPE)
      CALL JEVEUO(SIGMAD(1:19)//'.CELD','L',JCELDD)
      CALL JEVEUO(SIGMAD(1:19)//'.CELV','L',JCELVD)
C
      IF (CARTD1 .NE. ' ') THEN
        CALL JEVEUO (CARTD1//'.DESC','L',IADED1)
        CALL JEVEUO (CARTD1//'.VALE','L',IAVAD1)
        CALL JEEXIN (CARTD1//'.PTMA',IRET)
        IF (IRET .EQ. 0) THEN
          IPTMD1 = 0
        ELSE
C            LA CARTE A ETE ETENDUE
          CALL JEVEUO (CARTD1//'.PTMA','L',IPTMD1)
        ENDIF
        CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD1),NUMGD1)
      ELSE
        IADED1 = 0
        IAVAD1 = 0
      ENDIF
C
      IF (CARTD2 .NE. ' ') THEN
        CALL JEVEUO (CARTD2//'.DESC','L',IADED2)
        CALL JEVEUO (CARTD2//'.VALE','L',IAVAD2)
        CALL JEEXIN (CARTD2//'.PTMA',IRET)
        IF (IRET .EQ. 0) THEN
          IPTMD2 = 0
        ELSE
C            LA CARTE A ETE ETENDUE
          CALL JEVEUO (CARTD2//'.PTMA','L',IPTMD2)
        ENDIF
        CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGD2),NUMGD2)
      ELSE
        IADED2 = 0
        IAVAD2 = 0
      ENDIF
C
      ICMPD(1)  = IAREPE
      ICMPD(2)  = JCELDD
      ICMPD(3)  = JCELVD
      ICMPD(4)  = IATYMA
      ICMPD(5)  = IAGD
      ICMPD(6)  = IACMP
      ICMPD(11) = ICONX1
      ICMPD(12) = ICONX2
C      
      ICMPD(7)  = IADED1
      ICMPD(8)  = IAVAD1
      ICMPD(9)  = IPTMD1
      ICMPD(10) = NUMGD1

      CALL MECACT(BASE,'&&QIRES1.CH_FORCED','MODELE',LIGREL,'NEUT_I',12,
     &            LICMPD,ICMPD,R8BID,C16BID,K8BID)

      ICMPD(7)  = IADED2
      ICMPD(8)  = IAVAD2
      ICMPD(9)  = IPTMD2
      ICMPD(10) = NUMGD2

      CALL MECACT(BASE,'&&QIRES1.CH_PRESSD','MODELE',LIGREL,'NEUT_I',12,
     &            LICMPD,ICMPD,R8BID,C16BID,K8BID)

C ------- FIN CREATION CARTES PB. DUAL----------------------------------



C ------- DEBUT TEST SUR LES CHARGEMENTS VOLUMIQUES POUR LE PB. PRIMAL -
C  CHARGEMENTS VOLUMIQUES : PESANTEUR, ROTATION OU FORCES DE VOLUME
C       ATTENTION : SEULE LA DERNIERE CHARGE EST CONSIDEREE

      IRET7 = 0
      IRET8 = 0
      IRET9 = 0
      IRET10 = 0
      DO 20 I = 1,NCHARP
        CALL EXISD('CHAMP_GD',LCHARP(I)//'.CHME.PESAN',IRET7)
        CALL EXISD('CHAMP_GD',LCHARP(I)//'.CHME.ROTAT',IRET8)
        CALL EXISD('CHAMP_GD',LCHARP(I)//'.CHME.F2D2D',IRET9)
        CALL EXISD('CHAMP_GD',LCHARP(I)//'.CHME.F3D3D',IRET10)
        IF (IRET7.NE.0) THEN
          CFORP1 = LCHARP(I)//'.CHME.PESAN.DESC'
        END IF
        IF (IRET8.NE.0) THEN
          CFORP2 = LCHARP(I)//'.CHME.ROTAT.DESC'
        END IF
        IF (IRET9.NE.0) THEN
          CFORP3 = LCHARP(I)//'.CHME.F2D2D.DESC'
        END IF
        IF (IRET10.NE.0) THEN
          CFORP3 = LCHARP(I)//'.CHME.F3D3D.DESC'
        END IF
   20 CONTINUE

C    SI ABSENCE D'UN CHAMP DE FORCES, CREATION D'UN CHAMP NUL

      IF (IRET7.EQ.0) THEN
        CFORP1 = ' '
      END IF

      IF (IRET8.EQ.0) THEN
        CFORP2 = ' '
      END IF

      IF (IRET9.EQ.0 .AND. IRET10.EQ.0) THEN
        CFORP3 = '&&QIRES1.CH_NULLEP'
        CALL MEFOR0(MODELE,CFORP3,.FALSE.)
      END IF
C ------- FIN TEST SUR LES CHARGEMENTS VOLUMIQUES POUR LE PB. PRIMAL ---

C ------- DEBUT TEST SUR LES CHARGEMENTS VOLUMIQUES POUR LE PB. DUAL ---
C  CHARGEMENTS VOLUMIQUES : PESANTEUR, ROTATION OU FORCES DE VOLUME
C       ATTENTION : SEULE LA DERNIERE CHARGE EST CONSIDEREE

      IRET11 = 0
      IRET12 = 0
      IRET13 = 0
      IRET14 = 0

      DO 21 I = 1,NCHARD
        CALL EXISD('CHAMP_GD',LCHARD(I)//'.CHME.PESAN',IRET11)
        CALL EXISD('CHAMP_GD',LCHARD(I)//'.CHME.ROTAT',IRET12)
        CALL EXISD('CHAMP_GD',LCHARD(I)//'.CHME.F2D2D',IRET13)
        CALL EXISD('CHAMP_GD',LCHARD(I)//'.CHME.F3D3D',IRET14)
        IF (IRET11.NE.0) THEN
          CFORD1 = LCHARD(I)//'.CHME.PESAN.DESC'
        END IF
        IF (IRET12.NE.0) THEN
          CFORD2 = LCHARD(I)//'.CHME.ROTAT.DESC'
        END IF
        IF (IRET13.NE.0) THEN
          CFORD3 = LCHARD(I)//'.CHME.F2D2D.DESC'
        END IF
        IF (IRET14.NE.0) THEN
          CFORD3 = LCHARD(I)//'.CHME.F3D3D.DESC'
        END IF
   21 CONTINUE

C    SI ABSENCE D'UN CHAMP DE FORCES, CREATION D'UN CHAMP NUL

      IF (IRET11.EQ.0) THEN
        CFORD1 = ' '
      END IF

      IF (IRET12.EQ.0) THEN
        CFORD2 = ' '
      END IF

      IF (IRET13.EQ.0 .AND. IRET14.EQ.0) THEN
        CFORD3 = '&&QIRES1.CH_NULLED'
        CALL MEFOR0(MODELE,CFORD3,.FALSE.)
      END IF
C ------- FIN TEST SUR LES CHARGEMENTS VOLUMIQUES POUR LE PB. DUAL ---

      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = CHGEOM
      LPAIN(2)  = 'PCONTNOP'
      LCHIN(2)  = SIGMAP
      LPAIN(3)  = 'PCONTNOD'
      LCHIN(3)  = SIGMAD
      LPAIN(4)  = 'PFRVOLUP'
      LCHIN(4)  = CFORP3
      LPAIN(5)  = 'PFRVOLUD'
      LCHIN(5)  = CFORD3
      LPAIN(6)  = 'PPESANRP'
      LCHIN(6)  = CFORP1
      LPAIN(7)  = 'PPESANRD'
      LCHIN(7)  = CFORD1
      LPAIN(8)  = 'PROTATRP'
      LCHIN(8)  = CFORP2
      LPAIN(9)  = 'PROTATRD'
      LCHIN(9)  = CFORD2
      LPAIN(10) = 'PMATERC'
      LCHIN(10) = MATE
      LPAIN(11) = 'PFORCEP'
      LCHIN(11) = '&&QIRES1.CH_FORCEP'
      LPAIN(12) = 'PFORCED'
      LCHIN(12) = '&&QIRES1.CH_FORCED'
      LPAIN(13) = 'PPRESSP'
      LCHIN(13) = '&&QIRES1.CH_PRESSP'
      LPAIN(14) = 'PPRESSD'
      LCHIN(14) = '&&QIRES1.CH_PRESSD'
      LPAIN(15) = 'PVOISIN'
      LCHIN(15) = CHVOIS
      LPAIN(16) = 'PTEMPSR'
      LCHIN(16) = CHTIME
      LPAIN(17) = 'PCONSTR'
      LCHIN(17) = CHS

      LPAOUT(1) = 'PERREUR'
      LCHOUT(1) = RESU

      OPTION = 'QIRE_ELEM_SIGM'
      CALL CALCUL('C',OPTION,LIGREL,17,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'G')
      CALL EXISD('CHAMP_GD',LCHOUT(1),IRET)
      IF (IRET.EQ.0) THEN
          CALL UTMESS('A','CALC_ERREUR','OPTION '//OPTION//' NON '//
     &         'DISPONIBLE SUR LES ELEMENTS DU MODELE'//
     &         '- PAS DE CHAMP CREE ')
           GOTO 9999
      END IF

      CALL JEDETR(CARTP1//'.PTMA')
      CALL JEDETR(CARTP2//'.PTMA')
      CALL JEDETR(CARTD1//'.PTMA')
      CALL JEDETR(CARTD2//'.PTMA')

      CALL DETRSD('CHAMP_GD','&&QIRES1.CH_FORCEP')
      CALL DETRSD('CHAMP_GD','&&QIRES1.CH_PRESSP')
      CALL DETRSD('CHAMP_GD','&&QIRES1.CH_FORCED')
      CALL DETRSD('CHAMP_GD','&&QIRES1.CH_PRESSD')

      IF (IRET9.EQ.0 .AND. IRET10.EQ.0) THEN
        CALL DETRSD('CHAMP_GD',CFORP3)
      END IF
      
      IF (IRET13.EQ.0 .AND. IRET14.EQ.0) THEN
        CALL DETRSD('CHAMP_GD',CFORD3)
      END IF

9999  CONTINUE
      END
