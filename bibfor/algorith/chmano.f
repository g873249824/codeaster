      SUBROUTINE CHMANO(NOMA  ,IZONE ,NEWGEO,DEFICO,RESOCO,
     &                  IESCL0,NFESCL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/11/2009   AUTEUR DESOZA T.DESOZA 
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_20
C
      IMPLICIT     NONE
      INTEGER      IZONE
      INTEGER      IESCL0,NFESCL
      CHARACTER*8  NOMA
      CHARACTER*24 NEWGEO
      CHARACTER*24 DEFICO,RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT - MAIT/ESCL)
C
C RECHERCHE DE LA MAILLE LA PLUS PROCHE CONNAISSANT LE NOEUD LE PLUS
C PROCHE
C
C ----------------------------------------------------------------------
C
C
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT ACTUELLE
C IN  IESCL0 : INDICE DU PREMIER NOEUD ESCLAVE A EXAMINER
C IN  NOMA   : NOM DU MAILLAGE
C IN  NEWGEO : GEOMETRIE ACTUALISEE EN TENANT COMPTE DU CHAMP DE
C              DEPLACEMENTS COURANT
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C I/O NFESCL : NOMBRE DE NOEUDS DE LA ZONE
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*24 APPARI,APMEMO,APPOIN
      INTEGER      JAPPAR,JAPMEM,JAPPTR
      INTEGER      CFMMVD,ZAPME,ZAPPA
      INTEGER      CFDISI,ITEMAX
      REAL*8       CFDISR,EPSMAX,TOLEOU
      INTEGER      IFM,NIV
      INTEGER      TYPALC,TYPALF,FROT3D,MATTAN
      INTEGER      NESMAX,NBNOM,NBDDLE,NBDDLT,NDIMG,NESCL
      INTEGER      IBID
      INTEGER      POSNOM
      INTEGER      NUMMAM,TYPSUP
      INTEGER      POSNSM(9),DDL(30)
      CHARACTER*24 K24BID,K24BLA
      REAL*8       JEUPM,JEU
      REAL*8       NORM(3),TAU1(3),TAU2(3)
      REAL*8       COEF(30),COFX(30),COFY(30)
      REAL*8       COORDE(3),COORDP(3)
      REAL*8       TAU1M(3),TAU2M(3),KSI1,KSI2
      REAL*8       COEFNO(9),NOOR,R8PREM
      CHARACTER*4  TYPNOE
      CHARACTER*8  NOMNOE
      INTEGER      POSMAM,POSNOE,IESCL
      LOGICAL      DIRAPP,LDIST
      REAL*8       DIR(3)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C
      CALL CFIMPE(IFM,NIV,'CHMANO',1)
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      APMEMO = RESOCO(1:14)//'.APMEMO'
      APPARI = RESOCO(1:14)//'.APPARI'
      APPOIN = RESOCO(1:14)//'.APPOIN'
      CALL JEVEUO(APMEMO,'L',JAPMEM)
      CALL JEVEUO(APPARI,'L',JAPPAR)
      CALL JEVEUO(APPOIN,'E',JAPPTR)
      ZAPME  = CFMMVD('ZAPME')
      ZAPPA  = CFMMVD('ZAPPA')
C
C --- INFOS SUR LA CHARGE DE CONTACT
C
      CALL CFDISC(DEFICO,RESOCO(1:14),TYPALC,TYPALF,FROT3D,MATTAN)
C
C --- INITIALISATION DE VARIABLES
C
      K24BLA = ' '
      NESMAX = CFDISI(DEFICO,'NESMAX'        ,IZONE)
      NDIMG  = CFDISI(DEFICO,'NDIM'          ,IZONE)
      NESCL  = CFDISI(DEFICO,'NESCL_ZONE'    ,IZONE)
C
C --- INFOS GENERIQUES POUR L'ALGORITHME D'APPARIEMENT
C
      TOLEOU = CFDISR(DEFICO,'TOLE_PROJ_EXT' ,IZONE)
      EPSMAX = CFDISR(DEFICO,'PROJ_NEWT_RESI',IZONE)
      ITEMAX = CFDISI(DEFICO,'PROJ_NEWT_ITER',IZONE)
      CALL MMINFP(IZONE ,DEFICO,K24BLA,'TYPE_APPA',
     &            IBID  ,DIR   ,K24BID,DIRAPP)
C
C --- BOUCLE SUR LES NOEUDS ESCLAVES
C
      CALL CFIMPE(IFM,NIV,'CHMANO',2)
C
C --- PREMIER NOEUD ESCLAVE DE LA ZONE
C
      IESCL    = IESCL0
C
C --- BOUCLAGE SUR LES NOEUDS ESCLAVES
C
  70  CONTINUE
C
C --- INDICE DU NOEUD ESCLAVE ET INDICE DU NOEUD MAITRE LE PLUS PROCHE
C
        POSNOE = ZI(JAPPAR+ZAPPA*(IESCL-1)+1)
        POSNOM = ZI(JAPMEM+ZAPME*(POSNOE-1)+1)
C
C --- NOEUD ESCLAVE NON APPARIE
C
        IF (POSNOM.EQ.0) THEN
          LDIST = .FALSE.
          ZI(JAPPTR+IESCL) = ZI(JAPPTR+IESCL-1)
          GOTO 123
        ENDIF
C
C --- INFOS SUR NOEUD ESCLAVE
C
        CALL CFCARN(NOMA  ,DEFICO,RESOCO,NEWGEO,POSNOE,
     &              NBDDLE,COORDE,TYPNOE,NOMNOE)
        IF (TYPNOE.NE.'ESCL') THEN
          CALL ASSERT(.FALSE.)
        ENDIF
C
C --- PROJECTION SUR LA MAILLE MAITRE
C --- CALCUL DU JEU MINIMUM, DES COORDONNEES DU POINT PROJETE
C --- ET DES DEUX VECTEURS TANGENTS
C
        CALL CFPROJ(NOMA  ,DEFICO,NEWGEO,POSNOM,ITEMAX,
     &              EPSMAX,TOLEOU,DIRAPP,DIR   ,COORDE,
     &              POSMAM,NUMMAM,JEUPM ,KSI1  ,KSI2  ,
     &              TAU1M ,TAU2M ,LDIST )
C
C --- CARACTERISTIQUES DE LA MAILLE MAITRE
C
        CALL CFPOSN(NOMA  ,DEFICO,POSMAM,POSNSM,NBNOM )
C
C --- COORDONNEES PROJECTION DU NOEUD ESCLAVE SUR LA MAILLE MAITRE
C
        CALL CFCOOR(NOMA  ,DEFICO,NEWGEO,POSMAM,KSI1  ,
     &              KSI2  ,COORDP)
C
C --- RE-DEFINITION BASE TANGENTE SUIVANT OPTIONS
C
        CALL CFTANR(NOMA  ,NDIMG ,DEFICO,IZONE ,POSNOE,
     &              'MAIL',POSMAM,NUMMAM,KSI1  ,KSI2  ,
     &              TAU1M ,TAU2M ,TAU1  ,TAU2  )
C
C --- CALCUL DE LA NORMALE INTERIEURE
C
        CALL MMNORM(NDIMG ,TAU1  ,TAU2  ,NORM  ,NOOR)
        IF (NOOR.LE.R8PREM()) THEN
          CALL U2MESK('F','CONTACT3_26',1,NOMNOE)
        ENDIF
C
C --- CALCUL DES COEFFICIENTS DE LA RELATION LINEAIRE SUR NOEUDS MAITRES
C
        CALL CFRELI(NOMA  ,NUMMAM,NBNOM ,KSI1  ,KSI2  ,
     &              COEFNO)
C
C --- CALCULE LES COEFFICIENTS DES RELATIONS LINEAIRES ET DONNE LES
C --- NUMEROS DES DDL ASSOCIES
C
        CALL CFCOEF(NDIMG ,DEFICO,RESOCO,NBDDLE,NBNOM ,
     &              POSNSM,COEFNO,POSNOE,NORM  ,TAU1  ,
     &              TAU2  ,COEF  ,COFX  ,COFY  ,NBDDLT,
     &              DDL   )
C
C --- CALCUL DU JEU SUIVANT NORMALE
C
        CALL CFNEWJ(NDIMG ,COORDE,COORDP,NORM  ,JEU   )
C
C --- ON APPARIE TOUJOURS :
C --- DANS LE CAS DE LA SUPPRESSION ON INFORMERA LE VECTEUR
C --- RESOCO.APMEMO QUE CE NOEUD EST EXCLU VIA LA ROUTINE CFSUPM
C
        CALL CFADDM(DEFICO,RESOCO,TYPALF,FROT3D,POSNOE,
     &              IESCL ,NESMAX,NORM  ,TAU1  ,TAU2  ,
     &              COEF  ,COFX  ,COFY  ,JEU   ,NBNOM ,
     &              POSNSM,NBDDLT,DDL)
  123   CONTINUE
        CALL CFPARM(RESOCO,POSMAM,POSNOE,IESCL)
C
C --- LE NOEUD ESCLAVE EST EXCLU (VA AU COIN !)
C
        IF (.NOT.LDIST) THEN
          TYPSUP = -3
          CALL CFSUPM(NOMA  ,DEFICO,RESOCO,IZONE ,IESCL ,
     &                POSNOE,TYPSUP)
        ENDIF
C
C --- NOEUD ESCLAVE SUIVANT
C
        IESCL = IESCL + 1
C
C --- CHOIX DU BOUCLAGE
C
      IF (IESCL.LE.(IESCL0 + NESCL - 1)) THEN
C       ON CONTINUE LA BOUCLE
        GOTO 70
      ELSE
C       ON SORT DE LA BOUCLE
        GOTO 80
      ENDIF
C --- BOUCLAGE SUR LES NOEUDS ESCLAVES

  80  CONTINUE
C
C --- NOMBRE DE NOEUDS ESCLAVES SUR LA ZONE
C
      NFESCL = IESCL - IESCL0
C
C --- VERIFICATIONS
C
      IF (NFESCL.NE.NESCL) THEN
        CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEDEMA()
      END
