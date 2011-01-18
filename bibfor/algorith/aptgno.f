      SUBROUTINE APTGNO(SDAPPA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/01/2011   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*19 SDAPPA
C
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT - TANGENTES
C
C CALCUL DES VECTEURS TANGENTS EN CHAQUE NOEUD (MOYENNE)
C
C ----------------------------------------------------------------------
C
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
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
      INTEGER      NBZONE,NDIMG
      INTEGER      IFM,NIV
      INTEGER      IZONE ,ITYPE
      INTEGER      JDECNM,NBNOM
      INTEGER      JDECNE,NBNOE
      LOGICAL      APCALD
      REAL*8       VECTOR(3)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('APPARIEMENT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<APPARIEMENT> ...... TANGENTES SUR' //
     &  ' LES NOEUDS'
      ENDIF
C
C --- INITIALISATIONS
C
      CALL APPARI(SDAPPA,'APPARI_NDIMG' ,NDIMG )
      CALL APPARI(SDAPPA,'APPARI_NBZONE',NBZONE)
C
C --- BOUCLE SUR LES ZONES
C
      DO 10 IZONE = 1,NBZONE
C
C ----- INFORMATION SUR LA ZONE MAITRE
C
        CALL APZONI(SDAPPA,IZONE ,'NBNOM' ,NBNOM )
        CALL APZONI(SDAPPA,IZONE ,'JDECNM',JDECNM)
        CALL APZONI(SDAPPA,IZONE ,'TYPE_NORM_MAIT',ITYPE )
        CALL APZONV(SDAPPA,IZONE ,'VECT_MAIT'     ,VECTOR)
C
C ----- CALCUL SUR LA ZONE MAITRE
C
        CALL APZONL(SDAPPA,IZONE ,'CALC_NORM_MAIT',APCALD)
        IF (APCALD) THEN
          CALL APTGNN(SDAPPA,NDIMG ,JDECNM,NBNOM ,ITYPE ,VECTOR)
        ENDIF
C
C ----- INFORMATION SUR LA ZONE ESCLAVE
C
        CALL APZONI(SDAPPA,IZONE ,'NBNOE' ,NBNOE )
        CALL APZONI(SDAPPA,IZONE ,'JDECNE',JDECNE)
        CALL APZONI(SDAPPA,IZONE ,'TYPE_NORM_ESCL',ITYPE )
        CALL APZONV(SDAPPA,IZONE ,'VECT_ESCL'     ,VECTOR)
C
C ----- CALCUL SUR LA ZONE ESCLAVE
C
        CALL APZONL(SDAPPA,IZONE ,'CALC_NORM_ESCL',APCALD)
        IF (APCALD) THEN
          CALL APTGNN(SDAPPA,NDIMG ,JDECNE,NBNOE ,ITYPE ,VECTOR)
        ENDIF
 10   CONTINUE
C
      CALL JEDEMA()
      END
