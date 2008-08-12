      SUBROUTINE CRESOL(SOLVEU,KBID)
      IMPLICIT   NONE

      CHARACTER*19 SOLVEU
      CHARACTER*(*) KBID
C ----------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/08/2008   AUTEUR DESOZA T.DESOZA 
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
C     CREATION D'UNE SD_SOLVEUR PAR LECTURE DU MOT CLE SOLVEUR

C IN/JXOUT K19 SOLVEU  : SD_SOLVEUR
C IN       K*  KBID    : INUTILISE
C ----------------------------------------------------------------------
C RESPONSABLE VABHHTS J.PELLET
C TOLE CRP_20

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------

      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)

C --- FIN DECLARATIONS NORMALISEES JEVEUX --------------------

      INTEGER NMAXIT,ISTOP,NSOLVE,NBRPAS,IBID,NIREMP,IFM,
     &        NIV,NBMA,NBREOR,NPREC,INUMSD,IMAIL,NBREOI,
     &        REACRE
      REAL*8 RESIRE,TBLOC,JEVTBL,EPS,TESTCO
      CHARACTER*3 SYME
      CHARACTER*8 KSTOP,K8BID
      CHARACTER*8 METHOD,RENUM,PRECO,VERIF
      CHARACTER*8 TYREOR,SCALIN,STOGI,ACSM,ACMA
      CHARACTER*16 NOMSOL
      CHARACTER*24 SDFETI,INFOFE
      LOGICAL EXISYM,GETEXM,TESTOK
C------------------------------------------------------------------
      CALL JEMARQ()


      NOMSOL='SOLVEUR'
      METHOD='MULT_FRO'
      PRECO='SANS'
      RENUM='MDA'
      SYME='NON'
      EXISYM=.FALSE.
      RESIRE=1.D-6
      EPS=0.D0
      NPREC=8
      NMAXIT=0
      ISTOP=0
      NIREMP=0
      TBLOC=JEVTBL()
      SDFETI='????'
      VERIF='????'
      TESTCO=0.D0
      NBREOR=0
      NBREOI=0
      TYREOR='SANS'
      SCALIN='SANS'
      STOGI='????'
      ACSM='NON'
      ACMA='NON'
      REACRE=0
      INFOFE='FFFFFFFFFFFFFFFFFFFFFFFF'


C     RECUPERATION ET MAJ DU NIVEAU D'IMPRESSION
      CALL INFNIV(IFM,NIV)

      CALL GETFAC(NOMSOL,NSOLVE)
      IF (NSOLVE.EQ.0) GOTO 10


      CALL GETVTX(NOMSOL,'METHODE',1,1,1,METHOD,IBID)



      IF (METHOD.EQ.'MUMPS') THEN
C     -----------------------------
        CALL CRSVMU(NOMSOL,SOLVEU)


      ELSEIF (METHOD.EQ.'FETI') THEN
C     -----------------------------
        CALL CRSVFE(NOMSOL,SOLVEU)


      ELSEIF (METHOD.EQ.'PETSC') THEN
C     -----------------------------
        CALL CRSVPE(NOMSOL,SOLVEU)


      ELSE
C     -----------------------------
C       LDLT, MULT_FRO, GCPC :

C       -- CALCUL DE ISTOP, NBRPAS, SYME, NPREC
        KSTOP=' '
        CALL GETVTX(NOMSOL,'STOP_SINGULIER',1,1,1,KSTOP,IBID)
        CALL GETVIS(NOMSOL,'NPREC',1,1,1,NPREC,IBID)
        IF (KSTOP.EQ.'NON') THEN
          ISTOP=1
        ELSEIF (KSTOP.EQ.'DECOUPE') THEN
          CALL GETVIS('INCREMENT','SUBD_PAS',1,1,1,NBRPAS,IBID)
          IF (NBRPAS.LE.1) THEN
            CALL U2MESS('F','ALGORITH11_81')
          ELSE
            ISTOP=1
          ENDIF
        ENDIF

        EXISYM=GETEXM(NOMSOL,'SYME')
        IF (EXISYM) THEN
          CALL GETVTX(NOMSOL,'SYME',1,1,1,SYME,IBID)
        ENDIF


        IF (METHOD.EQ.'LDLT') THEN
C     -----------------------------
          CALL GETVTX(NOMSOL,'RENUM',1,1,1,RENUM,IBID)
          IF (IBID.EQ.0)RENUM='RCMK'

          IF (RENUM(1:4).NE.'RCMK' .AND.
     &        RENUM(1:4).NE.'SANS') CALL U2MESK('F','ALGORITH2_35',1,
     &        RENUM)


        ELSEIF (METHOD.EQ.'GCPC') THEN
C     -----------------------------
          CALL GETVTX(NOMSOL,'RENUM',1,1,1,RENUM,IBID)
          IF (IBID.EQ.0)RENUM='RCMK'
          IF (RENUM(1:4).NE.'RCMK' .AND.
     &        RENUM(1:4).NE.'SANS') CALL U2MESK('F','ALGORITH2_36',1,
     &        RENUM)
          PRECO='LDLT_INC'

          CALL GETVIS(NOMSOL,'NMAX_ITER',1,1,1,NMAXIT,IBID)
          CALL GETVR8(NOMSOL,'RESI_RELA',1,1,1,RESIRE,IBID)
          CALL GETVIS(NOMSOL,'NIVE_REMPLISSAGE',1,1,1,NIREMP,IBID)


        ELSEIF (METHOD.EQ.'MULT_FRO') THEN
C     --------------------------------------------------------------
          CALL GETVTX(NOMSOL,'RENUM',1,1,1,RENUM,IBID)
          IF (RENUM(1:2).NE.'MD' .AND. RENUM(1:2).NE.'ME') THEN
            CALL U2MESK('F','ALGORITH2_37',1,RENUM)
          ENDIF
        ENDIF


C     -- CREATION DU SOLVEUR :
C     --------------------------------------------------------------
        CALL CRESO1(SOLVEU,METHOD,PRECO,RENUM,SYME,SDFETI,EPS,RESIRE,
     &              TBLOC,NPREC,NMAXIT,ISTOP,NIREMP,IFM,0,NBMA,VERIF,
     &              TESTCO,NBREOR,TYREOR,SCALIN,INUMSD,IMAIL,K8BID,
     &              INFOFE,STOGI,TESTOK,NBREOI,ACMA,ACSM,REACRE)


      ENDIF

   10 CONTINUE

      CALL JEDEMA()
      END
