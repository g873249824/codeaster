      SUBROUTINE NMLEOP(RESULT,MODELE,MATE  ,CARELE,COMPOR,
     &                  LISCHA,SOLVEU,SDSENS)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8   RESULT
      CHARACTER*19  LISCHA,SOLVEU
      CHARACTER*24  MODELE,MATE  ,CARELE,COMPOR
      CHARACTER*24  SDSENS
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (LECTURE)
C
C LECTURE DONNEES GENERALES
C
C ----------------------------------------------------------------------
C
C
C OUT RESULT : NOM UTILISATEUR DU RESULTAT DE MECA_NON_LINE
C OUT MODELE : NOM DU MODELE
C OUT MATE   : NOM DU CHAMP DE MATERIAU
C OUT CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C OUT COMPOR : CARTE DECRIVANT LE TYPE DE COMPORTEMENT
C OUT LISCHA : SD L_CHARGES
C OUT SOLVEU : NOM DU SOLVEUR
C IN  SDSENS : SD SENSIBILITE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER       NBPASE
      CHARACTER*8   BASENO
      CHARACTER*16  INPSCO
      CHARACTER*24  SENSNB,SENSBA,SENSIN
      INTEGER       JSENSN,JSENSB,JSENSI
      INTEGER       IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... LECTURE DONNEES GENERALES'
      ENDIF
C
C --- ACCES SD SENSIBILITE
C
      SENSBA = SDSENS(1:16)//'.BASENO '
      SENSIN = SDSENS(1:16)//'.INPSCO '
      SENSNB = SDSENS(1:16)//'.NBPASE '
      CALL JEVEUO(SENSNB,'E',JSENSN)
      CALL JEVEUO(SENSBA,'L',JSENSB)
      CALL JEVEUO(SENSIN,'L',JSENSI)
      BASENO = ZK8(JSENSB+1-1)
      INPSCO = ZK16(JSENSI+1-1)
C
C --- LECTURE DONNEES GENERALES
C
      CALL NMLECT(RESULT,MODELE,MATE  ,CARELE,COMPOR,
     &            LISCHA,SOLVEU,NBPASE,BASENO,INPSCO)
      ZI(JSENSN+1-1)  = NBPASE
C
      CALL JEDEMA()
      END
