      SUBROUTINE MMGLIS(DEFICO,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/01/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*24 DEFICO,RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES CONTINUES - ALGORITHME)
C
C GESTION DE LA GLISSIERE
C
C ----------------------------------------------------------------------
C
C     ON MET LE POINT EN GLISSIERE SI LGLISS=.TRUE. ET
C     SI LA CONVERGENCE EN CONTRAINTE ACTIVE EST ATTEINTE
C
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE RESOLUTION DU CONTACT
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
      INTEGER      IFM,NIV
      INTEGER      CFMMVD,ZTABF
      CHARACTER*24 TABFIN
      INTEGER      JTABF
      INTEGER      CFDISI,MMINFI
      INTEGER      NZOCO,NBMAE,NPTM
      LOGICAL      MMINFL,LVERI,LGLISS
      INTEGER      IZONE,IMAE,IPTC,IPTM
      INTEGER      XS
      INTEGER      POSMAE,JDECME
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ... GESTION GLISSIERE'
      ENDIF
C
C --- ACCES SD CONTACT
C
      TABFIN = RESOCO(1:14)//'.TABFIN'
      CALL JEVEUO(TABFIN,'L',JTABF)
      ZTABF  = CFMMVD('ZTABF')
C
C --- INITIALISATIONS
C
      NZOCO  = CFDISI(DEFICO,'NZOCO')
      IPTC   = 1
C
C --- BOUCLE SUR LES ZONES
C
      DO 10 IZONE = 1,NZOCO
C
C ----- MODE VERIF: ON SAUTE LES POINTS
C
        LVERI  = MMINFL(DEFICO,'VERIF' ,IZONE )
        IF (LVERI) THEN
          GOTO 25
        ENDIF
C
C --- OPTIONS SUR LA ZONE DE CONTACT
C
        LVERI  = MMINFL(DEFICO,'VERIF'            ,IZONE )
        NBMAE  = MMINFI(DEFICO,'NBMAE'            ,IZONE )
        JDECME = MMINFI(DEFICO,'JDECME'           ,IZONE )
        LGLISS = MMINFL(DEFICO,'GLISSIERE_ZONE'   ,IZONE )
C
C ----- BOUCLE SUR LES MAILLES ESCLAVES
C
        DO 20 IMAE = 1,NBMAE
C
C ------- NUMERO ABSOLU DE LA MAILLE ESCLAVE
C
          POSMAE = JDECME + IMAE
C
C ------- NOMBRE DE POINTS SUR LA MAILLE ESCLAVE
C
          CALL MMINFM(POSMAE,DEFICO,'NPTM',NPTM  )
C
C ------- BOUCLE SUR LES POINTS
C
          IF (LGLISS) THEN
            DO 30 IPTM = 1,NPTM
              XS = NINT(ZR(JTABF+ZTABF*(IPTC-1)+22))
              IF (XS.EQ.1) THEN
                ZR(JTABF+ZTABF*(IPTC-1)+17) = 1.D0
              ENDIF
C
C --------- LIAISON DE CONTACT SUIVANTE
C
              IPTC   = IPTC + 1
  30        CONTINUE
          ELSE
            IPTC   = IPTC + NPTM
          ENDIF
  20    CONTINUE
  25    CONTINUE
  10  CONTINUE
C
      CALL JEDEMA()
      END
