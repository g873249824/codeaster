      SUBROUTINE ADHC01 ( NBOPT, TABENT, TABREE, TABCAR, LGCAR )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2004   AUTEUR MCOURTOI M.COURTOIS 
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
C RESPONSABLE GNICOLAS G.NICOLAS
C-----------------------------------------------------------------------
C TOLE CRP_20
C-----------------------------------------------------------------------
C      ADAPTATION PAR HOMARD - DECODAGE DE LA COMMANDE - PHASE 01
C      --             -                       -                --
C      ECRITURE DU FICHIER DE CONFIGURATION
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER NBOPT
      INTEGER TABENT(NBOPT), LGCAR(NBOPT)
C
      REAL*8 TABREE(NBOPT)
C
      CHARACTER*(*) TABCAR(NBOPT)
C
C 0.2. ==> COMMUNS
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
      INTEGER      ZI
      COMMON /IVARJE/ZI(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'ADHC01' )
C
      INTEGER LXLGUT
C
      INTEGER IAUX, JAUX, KAUX
      INTEGER CODRET
      INTEGER NUFIHO
      INTEGER MODHOM, TYPRAF, TYPDER, TYPBIL
      INTEGER TYPCRR, TYPCRD
      INTEGER NIVMIN, NIVMAX
      INTEGER NUMORD, NUMPT
      INTEGER NITER
      INTEGER CVSOLU
      INTEGER ADCHNO, ADCHNU
      INTEGER NBGRMA
      INTEGER NOSMPX
      INTEGER LOMN, LOMNP1
      INTEGER LNCPIN
      INTEGER LNMMN, LNMMN1
      INTEGER LNMDIN
      INTEGER LNMDFR
      INTEGER LMMN, LMMNP1
      INTEGER LHMN, LHMNP1
      INTEGER LLISTE
      INTEGER LLANGU
      INTEGER BILNBR, BILQUA, BILINT, BILCXT, BILTAI
C
      REAL*8 CRITDE, CRITRA
C
      CHARACTER*8 OMN, OMNP1
      CHARACTER*8 NCPIN
      CHARACTER*24 LIGRMA
      CHARACTER*24 NCHNOM, NCHNUM
      CHARACTER*32 NMDMN, NMDMN1
      CHARACTER*32 NMDIN
      CHARACTER*32 NMDFR
      CHARACTER*72 FMMN, FMMNP1
      CHARACTER*72 FHMN, FHMNP1
      CHARACTER*72 FLISTE
      CHARACTER*100 LIGBLA, LIGCOM, LIGNE
      CHARACTER*128 LANGUE
C
C====
C 1. RECUPERATION DES ARGUMENTS
C====
C
      CODRET = 0
C
C 1.1. ==> ENTIERS
C
      NUFIHO = TABENT(1)
      MODHOM = TABENT(2)
      NITER  = TABENT(3)
      TYPRAF = TABENT(4)
      TYPDER = TABENT(5)
      TYPCRR = TABENT(6)
      TYPCRD = TABENT(7)
      CVSOLU = TABENT(8)
      NBGRMA = TABENT(9)
      NOSMPX = TABENT(10)
      NIVMAX = TABENT(11)
      NIVMIN = TABENT(12)
      NUMPT  = TABENT(15)
      NUMORD = TABENT(16)
      BILNBR = TABENT(31)
      BILQUA = TABENT(32)
      BILCXT = TABENT(33)
      BILTAI = TABENT(34)
      BILINT = TABENT(35)
C
C 1.2. ==> CARACTERES
C
      LLISTE = LGCAR(1)
      FLISTE(1:LLISTE) = TABCAR(1)(1:LLISTE)
C
      LNCPIN = LGCAR(6)
      IF ( LNCPIN.GT.0 ) THEN
        NCPIN(1:LNCPIN) = TABCAR(6)(1:LNCPIN)
      ENDIF
C
C               123456789012345678901234
      NCHNOM = '                        '
      NCHNUM = '                        '
      IAUX = LGCAR(7)
      NCHNOM(1:IAUX) = TABCAR(7)(1:IAUX)
      IAUX = LGCAR(8)
      NCHNUM(1:IAUX) = TABCAR(8)(1:IAUX)
C
      LMMN = LGCAR(11)
      IF ( LMMN.GT.0 ) THEN
        FMMN(1:LMMN) = TABCAR(11)(1:LMMN)
      ENDIF
C
      LMMNP1 = LGCAR(12)
      IF ( LMMNP1.GT.0 ) THEN
        FMMNP1(1:LMMNP1) = TABCAR(12)(1:LMMNP1)
      ENDIF
C
      LHMN = LGCAR(19)
      IF ( LHMN.GT.0 ) THEN
        FHMN(1:LHMN) = TABCAR(19)(1:LHMN)
      ENDIF
C
      LHMNP1 = LGCAR(20)
      IF ( LHMNP1.GT.0 ) THEN
        FHMNP1(1:LHMNP1) = TABCAR(20)(1:LHMNP1)
      ENDIF
C
      LOMN = LGCAR(21)
      IF ( LOMN.GT.0 ) THEN
        OMN(1:LOMN) = TABCAR(21)(1:LOMN)
      ENDIF
C
      LOMNP1 = LGCAR(22)
      IF ( LOMNP1.GT.0 ) THEN
        OMNP1(1:LOMNP1) = TABCAR(22)(1:LOMNP1)
      ENDIF
C
      LNMMN = LGCAR(31)
      IF ( LNMMN.NE.0 ) THEN
        NMDMN(1:LNMMN) = TABCAR(31)(1:LNMMN)
      ENDIF
C
      LNMMN1 = LGCAR(32)
      IF ( LNMMN1.NE.0 ) THEN
        NMDMN1(1:LNMMN1) = TABCAR(32)(1:LNMMN1)
      ENDIF
C
      LNMDIN = LGCAR(33)
      IF ( LNMDIN.GT.0 ) THEN
        NMDIN(1:LNMDIN) = TABCAR(33)(1:LNMDIN)
      ENDIF
C
      LNMDFR = LGCAR(34)
      IF ( LNMDFR.GT.0 ) THEN
        NMDFR(1:LNMDFR) = TABCAR(34)(1:LNMDFR)
      ENDIF
C
      LLANGU = LGCAR(38)
      IF ( LLANGU.NE.0 ) THEN
        LANGUE(1:LLANGU) = TABCAR(38)(1:LLANGU)
      ENDIF
C
      IF ( NBGRMA.GT.0 ) THEN
        IAUX = LGCAR(39)
        LIGRMA = TABCAR(39)(1:IAUX)
      ENDIF
C
C 1.3. ==> REELS
C
      CRITRA = TABREE(1)
      CRITDE = TABREE(2)
C
C====
C 2. MISE EN FORME
C====
C
      TYPBIL = 1
      IF ( BILNBR.EQ.1 ) THEN
        TYPBIL = TYPBIL * 7
      ENDIF
      IF ( BILQUA.EQ.1 ) THEN
        TYPBIL = TYPBIL * 5
      ENDIF
      IF ( BILCXT.EQ.1 ) THEN
        TYPBIL = TYPBIL * 11
      ENDIF
      IF ( BILTAI.EQ.1 ) THEN
        TYPBIL = TYPBIL * 13
      ENDIF
      IF ( BILINT.EQ.1 ) THEN
        TYPBIL = TYPBIL * 3
      ENDIF
C
      IF ( TYPBIL.EQ.1 ) THEN
        TYPBIL = 0
      ENDIF
C
C====
C 3. ECRITURE DU FICHIER, LIGNE APRES LIGNE
C====
C
C 3.1. ==> LIGNE BLANCHE ET DE COMMENTAIRE
C
      JAUX = LEN(LIGBLA)
      DO 31 , IAUX = 1 , JAUX
        LIGBLA(IAUX:IAUX) = ' '
 31   CONTINUE
      LIGCOM = LIGBLA
      LIGCOM(1:1) = '#'
C
C 3.2. ==> L'INDISPENSABLE
C
      LIGNE = LIGCOM
      LIGNE(3:13) = 'Generalites'
      WRITE (NUFIHO,30000) LIGNE
C
      LIGNE = LIGBLA
      LIGNE(1:8) = 'ListeStd'
      LIGNE(10:9+LLISTE) = FLISTE(1:LLISTE)
      WRITE (NUFIHO,30000) LIGNE
C
      LIGNE(1:8) = 'ModeHOMA'
      WRITE (NUFIHO,30010) LIGNE(1:8), MODHOM
C
      LIGNE(1:8) = 'NumeIter'
      WRITE (NUFIHO,30010) LIGNE(1:8), NITER
C
      LIGNE(1:8) = 'TypeBila'
      WRITE (NUFIHO,30010) LIGNE(1:8), TYPBIL
C
      LIGNE = LIGBLA
      LIGNE(1:12) = 'CCAssoci MED'
      WRITE (NUFIHO,30000) LIGNE
C
C 3.3. ==> LES OBJETS ET FICHIERS HOMARD
C
      LIGNE = LIGCOM
      LIGNE(3:12) = 'Les objets'
      WRITE (NUFIHO,30000) LIGNE
C
      IF ( LOMN.GT.0 ) THEN
        LIGNE = LIGBLA
        LIGNE(1:8) = 'HOMaiN__'
        LIGNE(10:9+LOMN) = OMN(1:LOMN)
        LIGNE(11+LOMN:10+LOMN+LHMN) = FHMN(1:LHMN)
        WRITE (NUFIHO,30000) LIGNE
      ENDIF
C
      IF ( LOMNP1.GT.0 ) THEN
        LIGNE = LIGBLA
        LIGNE(1:8) = 'HOMaiNP1'
        LIGNE(10:9+LOMNP1) = OMNP1(1:LOMNP1)
        LIGNE(11+LOMNP1:10+LOMNP1+LHMNP1) = FHMNP1(1:LHMNP1)
        WRITE (NUFIHO,30000) LIGNE
      ENDIF
C
C 3.4. ==> LES FICHIERS EXTERNES
C
      IF ( LMMN.GT.0 ) THEN
        LIGNE = LIGBLA
        LIGNE(1:8) = 'CCMaiN__'
        LIGNE(10:9+LMMN) = FMMN(1:LMMN)
        WRITE (NUFIHO,30000) LIGNE
      ENDIF
C
      IF ( LNMMN.NE.0 ) THEN
        LIGNE = LIGBLA
        LIGNE(1:10) = 'CCNoMN__ "'
        LIGNE(11:10+LNMMN) = NMDMN(1:LNMMN)
        LIGNE(11+LNMMN:11+LNMMN) = '"'
        WRITE (NUFIHO,30000) LIGNE
      ENDIF
C
      IF ( LMMNP1.GT.0 ) THEN
        LIGNE = LIGBLA
        LIGNE(1:8) = 'CCMaiNP1'
        LIGNE(10:9+LMMNP1) = FMMNP1(1:LMMNP1)
        WRITE (NUFIHO,30000) LIGNE
      ENDIF
C
      IF ( LNMMN1.NE.0 ) THEN
        LIGNE = LIGBLA
        LIGNE(1:10) = 'CCNoMNP1 "'
        LIGNE(11:10+LNMMN1) = NMDMN1(1:LNMMN1)
        LIGNE(11+LNMMN1:11+LNMMN1) = '"'
        WRITE (NUFIHO,30000) LIGNE
      ENDIF
C
      LIGNE = LIGBLA
      LIGNE(1:8) = 'PPBasFic'
      LIGNE(10:13) = 'INFO'
      WRITE (NUFIHO,30000) LIGNE
C
C 3.5. ==> PILOTAGE DE L'ADAPTATION
C
      IF ( MODHOM.EQ.1 ) THEN
C
C 3.5.1. ==> L'INDICATEUR D'ERREUR
C            SI LE NUMERO D'ORDRE EST INCONNU, ON VA CHERCHER CELUI QUI
C            EST PRESENT DANS LA STRUCTURE DU RESULTAT
C
      IF ( LNCPIN.GT.0 ) THEN
C
        LIGNE = LIGBLA
        LIGNE(1:8) = 'CCIndica'
        LIGNE(10:9+LMMN) = FMMN(1:LMMN)
        WRITE (NUFIHO,30000) LIGNE
C
        LIGNE = LIGBLA
        LIGNE(1:8) = 'CCNoChaI'
        LIGNE(10:9+LNCPIN) = NCPIN(1:LNCPIN)
        LIGNE(11+LNCPIN:10+LNCPIN+LNMDIN) = NMDIN(1:LNMDIN)
        WRITE (NUFIHO,30000) LIGNE
C
        LIGNE(1:8) = 'CCNumPTI'
        WRITE (NUFIHO,30010) LIGNE(1:8), NUMPT
C
        LIGNE(1:8) = 'CCNumOrI'
        WRITE (NUFIHO,30010) LIGNE(1:8), NUMORD
C
      ENDIF
C
C 3.5.2. ==> RAFFINEMENT
C            ATTENTION : LES CRITERES SONT EN POURCENTAGE DANS HOMARD
C
      LIGNE = LIGBLA
      LIGNE(1:8) = 'TypeRaff'
      IF ( TYPRAF.EQ.-1 ) THEN
        LIGNE(10:17) = 'uniforme'
      ELSEIF ( TYPRAF.EQ.0 ) THEN
        LIGNE(10:12) = 'non'
      ELSEIF ( TYPRAF.EQ.1 ) THEN
        LIGNE(10:14) = 'libre'
      ENDIF
      WRITE (NUFIHO,30000) LIGNE
C
      IF ( TYPRAF.GT.0 ) THEN
        LIGNE = LIGBLA
        IF ( TYPCRR.EQ.1 ) THEN
          LIGNE(1:8) = 'SeuilHau'
          WRITE (NUFIHO,30020) LIGNE(1:8), CRITRA
        ELSEIF ( TYPCRR.EQ.2 ) THEN
          LIGNE(1:8) = 'SeuilHRe'
          WRITE (NUFIHO,30020) LIGNE(1:8), CRITRA*100.D0
        ELSEIF ( TYPCRR.EQ.3 ) THEN
          LIGNE(1:8) = 'SeuilHPE'
          WRITE (NUFIHO,30020) LIGNE(1:8), CRITRA*100.D0
        ENDIF
      ENDIF
C
      IF ( NIVMAX.GE.0 ) THEN
        LIGNE(1:8) = 'NiveauMa'
        WRITE (NUFIHO,30010) LIGNE(1:8), NIVMAX
      ENDIF
C
C 3.5.3. ==> DERAFFINEMENT
C            ATTENTION : LES CRITERES SONT EN POURCENTAGE DANS HOMARD
C
      LIGNE = LIGBLA
      LIGNE(1:8) = 'TypeDera'
      IF ( TYPDER.EQ.-1 ) THEN
        LIGNE(10:17) = 'uniforme'
      ELSEIF ( TYPDER.EQ.0 ) THEN
        LIGNE(10:12) = 'non'
      ELSEIF ( TYPDER.EQ.1 ) THEN
        LIGNE(10:14) = 'libre'
      ENDIF
      WRITE (NUFIHO,30000) LIGNE
C
      IF ( TYPDER.GT.0 ) THEN
        LIGNE = LIGBLA
        IF ( TYPCRD.EQ.1 ) THEN
          LIGNE(1:8) = 'SeuilBas'
          WRITE (NUFIHO,30020) LIGNE(1:8), CRITDE
        ELSEIF ( TYPCRD.EQ.2 ) THEN
          LIGNE(1:8) = 'SeuilBRe'
          WRITE (NUFIHO,30020) LIGNE(1:8), CRITDE*100.D0
        ELSEIF ( TYPCRD.EQ.3 ) THEN
          LIGNE(1:8) = 'SeuilBPE'
          WRITE (NUFIHO,30020) LIGNE(1:8), CRITDE*100.D0
        ENDIF
      ENDIF
C
      IF ( NIVMIN.GE.0 ) THEN
        LIGNE(1:8) = 'NiveauMi'
        WRITE (NUFIHO,30010) LIGNE(1:8), NIVMIN
      ENDIF
C
      ENDIF
C
C 3.5.4. ==> CONVERSION DES CHAMPS
C
      IF ( CVSOLU.NE.0 ) THEN
C
C 3.5.4.1. ==> LES FICHIERS
C
        LIGNE = LIGBLA
        LIGNE(1:8) = 'CCSolN__'
        LIGNE(10:9+LMMN) = FMMN(1:LMMN)
        WRITE (NUFIHO,30000) LIGNE
C
        LIGNE = LIGBLA
        LIGNE(1:8) = 'CCSolNP1'
        LIGNE(10:9+LMMNP1) = FMMNP1(1:LMMNP1)
        WRITE (NUFIHO,30000) LIGNE
C
C 3.5.4.2. ==> LES CARACTERISTIQUES
C
        CALL JEVEUO ( NCHNOM, 'L', ADCHNO )
        CALL JEVEUO ( NCHNUM, 'L', ADCHNU )
C
C 3.5.4.3. ==> ECRITURES
C
        DO 354 , IAUX = 1 , CVSOLU
C
          LIGNE = LIGBLA
          LIGNE(1:8) = 'CCChaNom'
          JAUX = ZI(ADCHNU+3*IAUX-3)
          WRITE (NUFIHO,30030) LIGNE(1:8), IAUX,
     >                         ZK80(ADCHNO+IAUX-1)(1:JAUX)
C
          LIGNE(1:8) = 'CCChaNuO'
          WRITE (NUFIHO,30010) LIGNE(1:8), IAUX, ZI(ADCHNU+3*IAUX-2)
C
          LIGNE(1:8) = 'CCChaPdT'
          WRITE (NUFIHO,30010) LIGNE(1:8), IAUX, ZI(ADCHNU+3*IAUX-1)
C
  354   CONTINUE
C
      ENDIF
C
C 3.5.5. ==> LE SUIVI DE LA FRONTIERE
C
      IF ( LNMDFR.GT.0 ) THEN
C
        LIGNE = LIGBLA
        LIGNE(1:8) = 'SuivFron'
        LIGNE(10:12) = 'OUI'
        WRITE (NUFIHO,30000) LIGNE
C
        LIGNE = LIGBLA
        LIGNE(1:8) = 'CCFronti'
        LIGNE(10:9+LMMN) = FMMN(1:LMMN)
        WRITE (NUFIHO,30000) LIGNE
C
        LIGNE = LIGBLA
        LIGNE(1:10) = 'CCNoMFro "'
        LIGNE(11:10+LNMDFR) = NMDFR(1:LNMDFR)
        LIGNE(11+LNMDFR:11+LNMDFR) = '"'
        WRITE (NUFIHO,30000) LIGNE
C
        IF ( NBGRMA.GT.0 ) THEN
          CALL JEVEUO ( LIGRMA, 'L', IAUX )
          DO 355 , JAUX = 1 , NBGRMA
            LIGNE = LIGBLA
            LIGNE(1:8) = 'CCGroFro'
            KAUX = LXLGUT(ZK8(IAUX+JAUX-1))
            LIGNE(10:9+KAUX) = ZK8(IAUX+JAUX-1)(1:KAUX)
            WRITE (NUFIHO,30000) LIGNE
  355     CONTINUE
        ENDIF
C
      ENDIF
C
C 3.6. ==> QUE FAIRE DES ELEMENTS NON SIMPLEXES ?
C
      LIGNE = LIGBLA
      LIGNE(1:8) = 'TypeElem'
      IF ( NOSMPX.EQ.0 ) THEN
C                        01234567
        LIGNE (10:17) = 'SIMPLEXE'
      ELSEIF ( NOSMPX.EQ.1 ) THEN
C                        01234
        LIGNE (10:14) = 'MIXTE'
      ELSE
        LIGNE (10:13) = 'TOUS'
      ENDIF
      WRITE (NUFIHO,30000) LIGNE
C
C 3.7. ==> OPTIONS PARTICULIERES
C
      LIGNE = LIGCOM
      LIGNE(3:24) = 'Options particulieres'
      WRITE (NUFIHO,30000) LIGNE
C
      LIGNE = LIGBLA
      LIGNE(1:10) = 'RepeTrav .'
      WRITE (NUFIHO,30000) LIGNE
C
      LIGNE = LIGBLA
      LIGNE(1:6) = 'Langue'
      LIGNE(8:7+LLANGU) = LANGUE(1:LLANGU)
      WRITE (NUFIHO,30000) LIGNE
C
      LIGNE = LIGBLA
      IF ( MODHOM.EQ.1 ) THEN
        LIGNE(1:12) = 'EcriFiHO oui'
      ELSE
        LIGNE(1:12) = 'EcriFiHO non'
      ENDIF
      WRITE (NUFIHO,30000) LIGNE
C
      LIGNE = LIGBLA
      LIGNE = 'DicoOSGM $HOME/HOMARD/V6.n/CONFIG/typobj.stu'
      WRITE (NUFIHO,30000) LIGNE
C
30000 FORMAT (A)
30010 FORMAT (A8,2X,I10,2X,I10)
30020 FORMAT (A8,2X,G15.7)
30030 FORMAT (A8,2X,I10,2X,A)
C
C====
C 4. MENAGE
C====
C
      CALL JEDETR(NCHNOM)
      CALL JEDETR(NCHNUM)
C
      IF ( NBGRMA.GT.0 ) THEN
        CALL JEDETR(LIGRMA)
      ENDIF
C
C====
C 5. ARRET SI PROBLEME
C====
C
      IF ( CODRET.NE.0 ) THEN
        CALL UTMESS
     > ('F',NOMPRO,'ERREURS CONSTATEES POUR IMPR_FICO_HOMA')
      ENDIF
C
      END
