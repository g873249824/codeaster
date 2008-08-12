      SUBROUTINE ARLPAR(NOMARL,BASE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/08/2008   AUTEUR MEUNIER S.MEUNIER 
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      CHARACTER*1  BASE
      CHARACTER*8  NOMARL
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C LECTURE DE QUELQUES PARAMETRES
C
C ----------------------------------------------------------------------
C
C
C I/O  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
C IN   BASE   : TYPE DE BASE ('V' OU 'G')
C
C SD EN SORTIE :
C ==============
C
C .INFOI : PARAMETRES GENERAUX DE LA METHODE ARLEQUIN DE TYPE
C          ENTIER
C .INFOR : PARAMETRES GENERAUX DE LA METHODE ARLEQUIN DE TYPE
C          REEL
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      IFM,NIV
C
      INTEGER      NI,NR,NK
      PARAMETER   ( NI = 4 , NR = 4 , NK = 1 )
      INTEGER      VALI(NI)
      REAL*8       VALR(NR)
      CHARACTER*24 VALK(NK)
C
      INTEGER      NH
      INTEGER      JARLII,JARLIR
C
      INTEGER      NHAPP,NHINT,NHQUA
      PARAMETER   (NHAPP = 4,NHINT = 2,NHQUA = 8)
C
      INTEGER      IMAX,NMIN
      PARAMETER   (IMAX = 15,NMIN = 8)
      REAL*8       GAMMA0,GAMMA1,PRECAR
      PARAMETER   (GAMMA0 = 0.17D0,GAMMA1 = 0.90D0,PRECAR = 1.D-8)
C
      REAL*8       PRECBO
      PARAMETER   (PRECBO = 1.D-8)
C
      REAL*8       PRECCP
      PARAMETER   (PRECCP = 1.D-8)
      INTEGER      ITEMCP
      PARAMETER   (ITEMCP = 200)
C
      REAL*8       PRECTR,PRECIT,PRECVM
      INTEGER      NCMAX,NTMAX
      PARAMETER   (PRECTR = 1D-7,PRECIT = 5D-6,PRECVM = 1.D-2)
      PARAMETER   (NCMAX  = 4,NTMAX = 4)
C
      REAL*8       PRECFR,PRECVV
      PARAMETER   (PRECFR = 1D-2,PRECVV=5.D-3)
C
      REAL*8       PRECBB
      PARAMETER   (PRECBB = 1D-12)
C
      CHARACTER*6  NOMPRO
      PARAMETER   (NOMPRO='ARLPAR')
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('ARLEQUIN',IFM,NIV)
C
C --- INFO DBG
C
      VALI(1) = NHAPP
      VALI(2) = NHINT
      VALI(3) = IMAX
      VALI(4) = NHQUA
C
      VALR(1) = GAMMA0
      VALR(2) = GAMMA1
      VALR(3) = PRECAR
      VALR(4) = PRECBO
C
      CALL ARLDBG(NOMPRO,NIV,IFM,1,NI,VALI,NR,VALR,NK,VALK)
C
C --- CREATION VECTEURS JEVEUX
C
      CALL WKVECT(NOMARL(1:8)//'.INFOI',BASE//' V I',9 ,JARLII )
      CALL WKVECT(NOMARL(1:8)//'.INFOR',BASE//' V R',11,JARLIR )
C
C --- PARAMETRES GENERAUX
C --- NHAPP: ECHANTILLONNAGE DE LA FRONTIERE
C --- NHINT: (?)
C
      ZI(JARLII  ) = NHAPP
      ZI(JARLII+1) = NHINT
      NH = MAX(NHAPP,NHINT)**2
      IF (NHINT.GT.NHAPP) CALL ASSERT(.FALSE.)
C
C --- PARAMETRES POUR L'ARBRE DE PARTITION BINAIRE
C --- IMAX  : NOMBRE DE CANDIDATS POUR ETRE L'HYPERPLAN SEPARATEUR
C --- NMIN  : NOMBRE MAXIMUM DE MAILLES DANS UNE FEUILLE DE L'ARBRE
C --- GAMMA0: CRITERE GLOBAL DE QUALITE DE SEPARATION DE L'ARBRE
C --- GAMMA1: AUTRE CRITERE DE QUALITE DE L'ARBRE (?)
C --- PRECAR: PRECISION RELATIVE POUR DECIDER SI FEUILLE SUR PLAN
C             MEDIATEUR OU NON
C
      ZI(JARLII+2) = NH
      ZI(JARLII+3) = IMAX
      ZI(JARLII+4) = NMIN
      ZR(JARLIR  ) = GAMMA0
      ZR(JARLIR+1) = GAMMA1
      ZR(JARLIR+2) = PRECAR
C
C --- PARAMETRES POUR LA MISE EN BOITE
C --- PRECBO: PRECISION RELATIVE POUR AGRANDIR OU TESTER LA BOITE
C             ENGLOBANTE D'UNE MAILLE
C --- NHQUA : ECHANTILLONNAGE FACES POUR MISE EN BOITE ELTS QUADRATIQUES
C
      ZR(JARLIR+3) = PRECBO
      ZI(JARLII+5) = NHQUA
C
C --- PARAMETRES POUR COUPLAGE
C --- PRECCP : PRECISION ABSOLUE POUR NEWTON (PROJECTION NOEUD SUR
C              ELEMENT DE REFERENCE). PRECISION MISE A L'ECHELLE PAR
C              DIMENSION DE L'ELEMENT. REGLE LES CAS D'INTERSECTION
C              DE MESURE QUASI-NULLE
C --- ITEMCP : NOMBRE MAX ITERATIONS NEWTON (PROJECTION NOEUD SUR
C              ELEMENT DE REFERENCE).
C
      ZR(JARLIR+4) = PRECCP
      ZI(JARLII+6) = ITEMCP
C
C --- PARAMETRES POUR TRIANGULATION
C --- PRECTR : PRECISION ABSOLUE POUR TRIANGULATION.
C              PRECISION MISE A L'ECHELLE PAR DIMENSION DE L'ELEMENT
C --- PRECIT : BRUITAGE DES SOMMETS POUR EVITER CAS DE COINCIDENCE
C              PRECISION MISE A L'ECHELLE PAR DIMENSION DE L'ELEMENT
C --- PRECVM : VOLUME MINIMUM: EN DESSOUS PAS DE DECOUPE
C              PRECISION MISE A L'ECHELLE PAR DIMENSION DE L'ELEMENT
C --- NCMAX  : NOMBRE MAX DE COMPOSANTES CONNEXES LORS DE LA
C              TRIANGULARISATION
C --- NTMAX  : NOMBRE MAX TRIANGLES/COMP. CONNEXE LORS DE LA
C              TRIANGULARISATION
C
      ZR(JARLIR+5) = PRECTR
      ZR(JARLIR+6) = PRECIT
      ZR(JARLIR+7) = PRECVM
      ZI(JARLII+7) = NCMAX
      ZI(JARLII+8) = NTMAX
C
C --- PARAMETRES POUR PONDERATION
C --- PRECFR : PRECISION ABSOLUE POUR DETECTION NOEUD FRONTIERE
C --- PRECVV : PRECISION POUR INTMAM
C
      ZR(JARLIR+8) = PRECFR
      ZR(JARLIR+9) = PRECVV
C
C --- PARAMETRES POUR CREATION CHARGE
C --- PRECBB : PRECISION POUR ELIMINATION TERMES NULS DANS MATRICE
C              COUPLAGE
C
      ZR(JARLIR+10) = PRECBB
C
      CALL JEDEMA()
      END
