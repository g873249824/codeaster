      SUBROUTINE CFALGO(NOMA  ,RESIGR,DEFICO,RESOCO,MATASS,
     &                  DDEPLA,DEPDEL,REAGEO,REAPRE,CTCCVG,
     &                  CTCFIX)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/10/2009   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT     NONE
      LOGICAL      REAGEO,CTCFIX,REAPRE
      CHARACTER*8  NOMA
      REAL*8       RESIGR
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*19 DDEPLA,DEPDEL
      CHARACTER*19 MATASS
      INTEGER      CTCCVG(2)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
C
C ROUTINE D'AIGUILLAGE POUR LA RESOLUTION DU CONTACT
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  ITERAT : ITERATION DE NEWTON
C IN  RESIGR : RESI_GLOB_RELA
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  MATASS : NOM DE LA MATRICE DU PREMIER MEMBRE ASSEMBLEE
C IN  DDEPLA : INCREMENT DE DEPLACEMENTS CALCULE EN IGNORANT LE CONTACT
C IN  DEPDEL : INCREMENT DE DEPLACEMENT CUMULE
C IN  REAGEO : VAUT .TRUE. SI REACTUALISATION GEOMETRIQUE
C IN  REAPRE : VAUT .TRUE. SI PREMIERE BOUCLE GEOMETRIQUE ET PREMIERE
C               ITERATION (PREDICTION)
C OUT CTCFIX : .TRUE.  SI ATTENTE POINT FIXE CONTACT
C OUT CTCCVG : CODES RETOURS D'ERREUR DU COTNACT
C                (1) NOMBRE MAXI D'ITERATIONS
C                (2) MATRICE SINGULIERE
C
C
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
      INTEGER      CFDISI
      CHARACTER*19 MATR
      INTEGER      LDSCON,LMAT
      CHARACTER*24 APPARI
      INTEGER      IFM,NIV,ICONTA,IZONE,IMETH
C
C ----------------------------------------------------------------------
C
      CALL INFNIV (IFM,NIV)
      CALL JEMARQ ()
C
C --- METHODE DE CONTACT
C
      IZONE  = 1
      IMETH = CFDISI(DEFICO,'METHODE',IZONE)
C
C --- APPARIEMENT SANS CALCUL
C
      IF (IMETH.EQ.-2) THEN
        GOTO 999
      ENDIF     
C
C --- INITIALISATION DES VARIABLES DE CONVERGENCE DU CONTACT
C
      CTCCVG(1) = 0
      CTCCVG(2) = 0
C
C --- RECUPERATION DU DESCRIPTEUR DE LA MATRICE DE CONTACT
C --- SI LA METHODE N'EST PAS 'PENALISATION' OU 'GCP'
C
      IF ((IMETH.NE.-1).AND.(IMETH.NE.5).AND.(IMETH.NE.9)) THEN
        MATR = RESOCO(1:14)//'.MATR'
        CALL MTDSC3 ( MATR )
        CALL JEVEUO ( MATR(1:19)//'.&INT', 'E', LDSCON )
      ENDIF
C
C --- RECUPERATION DU DESCRIPTEUR DE LA MATRICE MECANIQUE
C
      CALL JEVEUO(MATASS//'.&INT', 'E', LMAT)
C
C --- INITIALISATION POUR LA DETERMINATION DE POINTS FIXE
C
      CTCFIX = .FALSE.
C
C --- ARRET OU NON SI MATRICE DE CONTACT SINGULIERE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ALGORITHME DE RECHERCHE DE CONTACT'
      ENDIF
C
C --- LE CONTACT DOIT-IL ETRE MODELISE ?
C
      APPARI = RESOCO(1:14)//'.APPARI'
      CALL JEEXIN(APPARI,ICONTA)
      IF (ICONTA.EQ.0) THEN
        GO TO 999
      ENDIF
C
C --- CHOIX DE L'ALGO DE CONTACT/FROTTEMENT
C
      IF (IMETH.EQ.-1) THEN
         CALL ALGOCP(DEFICO,RESOCO,LMAT  ,NOMA  ,DDEPLA)
      ELSE IF (IMETH.EQ.0) THEN
         CALL ALGOCO(DEFICO,RESOCO,LMAT  ,LDSCON,NOMA  ,
     &               DDEPLA,CTCCVG)
      ELSE IF (IMETH.EQ.1) THEN
         CALL ALGOCL(DEFICO,RESOCO,LMAT  ,LDSCON,NOMA  ,
     &               REAGEO,REAPRE,DDEPLA,CTCCVG,CTCFIX)
      ELSE IF (IMETH.EQ.2) THEN
         CALL FRO2GD(DEFICO,RESOCO,LMAT  ,LDSCON,NOMA  ,
     &               REAGEO,REAPRE,DEPDEL,DDEPLA,CTCCVG)
      ELSE IF (IMETH.EQ.3) THEN
         CALL FROPGD(DEFICO,RESOCO,LMAT  ,LDSCON,NOMA  ,
     &               DDEPLA,RESIGR,REAGEO,REAPRE,DEPDEL,
     &               CTCCVG,CTCFIX)
      ELSE IF (IMETH.EQ.4) THEN
         CALL FROLGD(DEFICO,RESOCO,LMAT  ,LDSCON,NOMA  ,
     &               DDEPLA,RESIGR,REAGEO,REAPRE,DEPDEL,
     &               CTCCVG)
      ELSE IF (IMETH.EQ.5) THEN
         CALL FROGDP(DEFICO,RESOCO,LMAT  ,NOMA  ,DDEPLA,
     &               RESIGR,REAPRE,DEPDEL)
      ELSE IF (IMETH.EQ.7) THEN
         CALL ALGOGL(DEFICO,RESOCO,LMAT  ,LDSCON,NOMA  ,
     &               DDEPLA,CTCCVG)
      ELSE IF (IMETH.EQ.9) THEN
         CALL ALGOCG(DEFICO,RESOCO,LMAT  ,NOMA  ,DDEPLA,
     &               CTCCVG)
      ELSE
         CALL ASSERT(.FALSE.)
      ENDIF


  999 CONTINUE

      CALL JEDEMA()
      END
