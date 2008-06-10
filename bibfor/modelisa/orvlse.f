      SUBROUTINE ORVLSE ( NOMA, LISTMA, NBMAIL, NORIEN,
     &                    VECT, NOEUD, PREC )
      IMPLICIT NONE
      INTEGER             LISTMA(*), NBMAIL, NOEUD, NORIEN
      CHARACTER*8         NOMA
      REAL*8              VECT(*), PREC
C.======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 06/05/2008   AUTEUR KHAM M.KHAM 
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
C
C   ORVLSE  --  LE BUT EST QUE TOUTES LES MAILLES DE TYPE SEG 
C               DE LA LISTE SOIENT
C               ORIENTEES SUIVANT LE VECTEUR DIRECTEUR.
C
C   ARGUMENT        E/S  TYPE         ROLE
C    NOMA           IN    K8      NOM DU MAILLAGE
C    LISTMA         IN    I       LISTE DES MAILLES A REORIENTER
C    NBMAIL         IN    I       NB DE MAILLES DE LA LISTE
C    NORIEN        VAR            NOMBRE DE MAILLES REORIENTEES
C    VECT           IN    R       VECTEUR DIRECTEUR
C    NOEUD          IN    I       NOEUD D'ORIENTATION
C    PREC           IN    R       PRECISION
C.========================= DEBUT DES DECLARATIONS ====================
C ----- COMMUNS NORMALISES  JEVEUX
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32     JEXNUM, JEXATR
C -----  VARIABLES LOCALES
      INTEGER       IDTYMA, NUTYMA, LORI, JORI, NORI, KORI, ILISTE
      INTEGER       IMA, NUMAIL, NUMA, NORIEG, LLISTE, ZERO, IBID
      INTEGER       IM1, IM2, ICO, IORIM1, IORIM2
      INTEGER       P1, P2, IFM , NIV, P3, P4
      INTEGER       JDESM1, JDESM2
      INTEGER       NBMAVO, INDIIS, INDI, IM3, JCOOR
      INTEGER       IORIV3, NBMAOR, II, KDEB
      LOGICAL       PASORI, REORIE
      CHARACTER*2   KDIM
      CHARACTER*8   TYPEL, NOMAIL
      CHARACTER*24  MAILMA, NOMAVO
      CHARACTER*24 VALK(2)
C
      PASORI(IMA) = ZI(LORI-1+IMA).EQ.0
C
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
      CALL JEMARQ ( )
C
      CALL INFNIV ( IFM , NIV )
      MAILMA = NOMA//'.NOMMAI'
      REORIE = .TRUE.
      ZERO   = 0
C
C --- VECTEUR DU TYPE DES MAILLES DU MAILLAGE :
C     ---------------------------------------
      CALL JEVEUO(NOMA//'.TYPMAIL','L',IDTYMA)
C
C --- COORDONNEES DES NOEUDS DU MAILLAGE :
C     ----------------------------------
      CALL JEVEUO ( NOMA//'.COORDO    .VALE', 'L', JCOOR )
C
C --- APPEL A LA CONNECTIVITE :
C     -----------------------
      CALL JEVEUO ( JEXATR(NOMA//'.CONNEX','LONCUM'), 'L', P2 )
      CALL JEVEUO ( NOMA//'.CONNEX', 'E', P1 )
C
C     ALLOCATIONS :
C     -----------
      CALL WKVECT('&&ORVLMA.ORI1','V V I',NBMAIL,LORI)
      CALL WKVECT('&&ORVLMA.ORI2','V V I',NBMAIL,JORI)
      CALL WKVECT('&&ORVLMA.ORI3','V V I',NBMAIL,NORI)
      CALL WKVECT('&&ORVLMA.ORI4','V V I',NBMAIL,KORI)
      CALL WKVECT('&&ORVLMA.ORI5','V V I',NBMAIL,KDEB)
C
C --- VERIFICATION DU TYPE DES MAILLES
C --- (ON DOIT AVOIR DES MAILLES DE PEAU) :
C     -----------------------------------
      DO 10 IMA = 1, NBMAIL
        ZI(LORI-1+IMA) = 0
        NUMA = LISTMA(IMA)
        ZI(NORI-1+IMA) = ZI(P2+NUMA)-ZI(P2-1+NUMA)
        ZI(KORI-1+IMA) = ZI(P2+NUMA-1)
C
C ---   TYPE DE LA MAILLE COURANTE :
C       --------------------------
        NUTYMA = ZI(IDTYMA+NUMA-1)
        CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',NUTYMA),TYPEL)
C
        IF (TYPEL(1:3).NE.'SEG') THEN
          CALL JENUNO(JEXNUM(MAILMA,NUMA),NOMAIL)
          VALK(1) = NOMAIL
          VALK(2) = TYPEL
          CALL U2MESK('F','MODELISA5_94', 2 ,VALK)
        ENDIF
  10  CONTINUE
Cok --- on teste le type de maille de la liste
C       si ce n'est pas un seg => erreur
C
C --- RECUPERATION DES MAILLES VOISINES DU GROUP_MA :
C     ---------------------------------------------
      KDIM ='1D'
      NOMAVO = '&&ORVLMA.MAILLE_VOISINE '
      CALL UTMAVO ( NOMA, KDIM, LISTMA, NBMAIL, 'V', NOMAVO,ZERO,IBID )
      CALL JEVEUO ( JEXATR(NOMAVO,'LONCUM'), 'L', P4 )
      CALL JEVEUO ( NOMAVO, 'L', P3 )


C --- ON TESTE SI LA POUTRE CONTIENT UN EMBRANCHEMENT
       DO 11 IMA = 1, NBMAIL
         NUMAIL = ZI(P4+IMA) - ZI(P4+IMA-1)
         IF (NUMAIL.GE.3) THEN
           NORIEG =0
           DO 12 II = 1, NUMAIL
             NUMA = ZI(P3+ZI(P4+IMA-1)-1+II-1)
             DO 13 ICO = 1, NBMAIL
               IF (NUMA.EQ.LISTMA(ICO)) THEN
                 NORIEG = NORIEG +1
                 GOTO 12
               ENDIF
  13           CONTINUE             
  12         CONTINUE
           IF (NORIEG.GE.3) CALL U2MESS('F','MODELISA4_84')
         ENDIF
  11     CONTINUE

C
C --- PREMIER PASSAGE: METTRE LES MAILLES AYANT LE NOEUD DANS
C     LA BONNE ORIENTATION
C
      NORIEG = 0
C
      NBMAOR = 0
      DO 20 IMA = 1 , NBMAIL
         NUMA = LISTMA(IMA)
         JDESM1  =  ZI(KORI-1+IMA)
C
C ------ VERIFICATION QUE LE NOEUD EST DANS LA MAILLE
         ICO = IORIV3( ZI(P1+JDESM1-1), NOEUD, VECT, ZR(JCOOR) )
C
C ------ LA MAILLE NE CONTIENT PAS LE NOEUD
         IF ( ICO .EQ. 0 ) THEN
C
C ------ LA MAILLE A ETE REORIENTEE
         ELSEIF ( ICO .LT. 0 ) THEN
            NBMAOR = NBMAOR + 1
            ZI(KDEB+NBMAOR-1) = IMA
            ZI(LORI-1+IMA) = 1
            IF ( NIV .EQ. 2 ) THEN
               CALL JENUNO(JEXNUM(MAILMA,NUMA),NOMAIL)
               WRITE(IFM,*) 'LA MAILLE '//NOMAIL//
     &                       ' A ETE ORIENTEE PAR RAPPORT AU VECTEUR'
            ENDIF
            NORIEG = NORIEG + 1
C
C ------ LA MAILLE A LA BONNE ORIENTATION
         ELSE
            NBMAOR = NBMAOR + 1
            ZI(KDEB+NBMAOR-1) = IMA
            ZI(LORI-1+IMA) = 1
            IF ( NIV .EQ. 2 ) THEN
               CALL JENUNO(JEXNUM(MAILMA,NUMA),NOMAIL)
               WRITE(IFM,*) 'LA MAILLE '//NOMAIL//
     &                       ' EST ORIENTEE PAR RAPPORT AU VECTEUR'
            ENDIF
         ENDIF

 20   CONTINUE
      IF ( NBMAOR .EQ. 0 )
     & CALL U2MESS('F','MODELISA6_1')
C
      DO 300 II = 1 , NBMAOR
      LLISTE = 0
      ILISTE = 0
      ZI(JORI+LLISTE) = ZI(KDEB+II-1)
C
C --- ON ORIENTE TOUTES LES MAILLES DU CONNEXE
C
 200  CONTINUE
C
      IM1 = ZI(JORI+ILISTE)
      JDESM1 =  ZI(KORI-1+IM1)
C --- ON ESSAYE D'ORIENTER LES MAILLES VOISINES
      NBMAVO = ZI(P4+IM1)-ZI(P4-1+IM1)
      DO 210 IM3 = 1, NBMAVO
         INDI = ZI(P3+ZI(P4+IM1-1)-1+IM3-1)
         IM2 = INDIIS ( LISTMA, INDI, 1, NBMAIL )
         IF ( IM2 .EQ. 0 ) GOTO 210
         NUMAIL = LISTMA(IM2)
         IF ( PASORI(IM2) ) THEN
            JDESM2 = ZI(KORI-1+IM2)
C           VERIFICATION DE LA CONNEXITE ET REORIENTATION EVENTUELLE
            ICO = IORIM1 ( ZI(P1+JDESM1-1),
     &                                  ZI(P1+JDESM2-1), REORIE )
C           SI MAILLES CONNEXES
            IF (ICO.NE.0) THEN
               ZI(LORI-1+IM2) = 1
               LLISTE = LLISTE + 1
               ZI(JORI+LLISTE) = IM2
               IF ( REORIE .AND. NIV. EQ. 2 ) THEN
                  CALL JENUNO(JEXNUM(MAILMA,NUMAIL),NOMAIL)
                  IF (ICO.LT.0) THEN
                  WRITE (IFM,*) 'LA MAILLE ',NOMAIL,' A ETE REORIENTEE'
                  ELSE
                    WRITE (IFM,*) 'LA MAILLE ',NOMAIL,' EST ORIENTEE'
                  ENDIF
               ENDIF
            ENDIF
C
C           SI ORIENTATIONS CONTRAIRES
            IF (ICO.LT.0)  NORIEG = NORIEG + 1
C
         ENDIF
 210  CONTINUE
      ILISTE = ILISTE + 1
      IF (ILISTE.LE.LLISTE) GOTO 200
 300  CONTINUE
C
C --- ON VERIFIE QU'ON A BIEN TRAITE TOUTES LES MAILLES
C
      DO 100 IMA = 1 , NBMAIL
         IF ( PASORI(IMA) ) CALL U2MESS('F','MODELISA6_2')
 100  CONTINUE
C
      NORIEN = NORIEN + NORIEG
C
      CALL JEDETR('&&ORVLMA.ORI1')
      CALL JEDETR('&&ORVLMA.ORI2')
      CALL JEDETR('&&ORVLMA.ORI3')
      CALL JEDETR('&&ORVLMA.ORI4')
      CALL JEDETR('&&ORVLMA.ORI5')
      CALL JEDETR(NOMAVO)
C
      CALL JEDEMA()
      END
