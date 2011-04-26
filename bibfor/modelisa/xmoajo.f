      SUBROUTINE XMOAJO(JJ,NFISS,ITYPX,NTYPX)
      IMPLICIT NONE

      INTEGER  JJ,NFISS,ITYPX(*),NTYPX(*)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 26/04/2011   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE GENIAUT
C
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM APPELEE PAR MODI_MODELE_XFEM (OP0113)
C
C    BUT : AJOUT DANS LE LIGREL D'UN ELEMENT X-FEM
C
C ----------------------------------------------------------------------
C
C
C IN/OUT  JJ     : ADRESSE DU TABLEAU DE TRAVAIL
C IN      NFISS : NOMBRE DE FISSURES "VUES" PAR L'�L�MENT
C IN      ITYPX  : NUMERO DU TYPE D'ELEMENT X-FEM A AJOUTER
C IN      ITYPCX  : NUMERO DU TYPE D'ELEMENT X-FEM CONTACT A AJOUTER
C IN      ITYPEL : NUMERO DU TYPE D'ELEMENT CLASSIQUE
C IN/OUT  NTYPX  : NOMBRE DE NOUVEAUX ELEMENTS DE TYPE ITYPX
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
C
      CALL JEMARQ()

      IF (NFISS.EQ.1) THEN
        IF (ZI(JJ+1).EQ.-1)  THEN
          ZI(JJ+5) = ITYPX(1)
          NTYPX(1) = NTYPX(1) + 1
          NTYPX(7) = NTYPX(7) + 1
        ELSEIF (ZI(JJ+2).EQ.-1) THEN
          ZI(JJ+5) = ITYPX(2)
          NTYPX(2) = NTYPX(2) + 1
          NTYPX(7) = NTYPX(7) + 1
        ELSEIF (ZI(JJ+3).EQ.-1) THEN
          ZI(JJ+5) = ITYPX(3)
          NTYPX(3) = NTYPX(3) + 1
          NTYPX(7) = NTYPX(7) + 1
        ELSEIF (ZI(JJ+1).EQ.1)  THEN
          ZI(JJ+5) = ITYPX(4)
          NTYPX(4) = NTYPX(4) + 1
          NTYPX(7) = NTYPX(7) + 1
        ELSEIF (ZI(JJ+2).EQ.1) THEN
          ZI(JJ+5) = ITYPX(5)
          NTYPX(5) = NTYPX(5) + 1
          NTYPX(7) = NTYPX(7) + 1
        ELSEIF (ZI(JJ+3).EQ.1) THEN
          ZI(JJ+5)=ITYPX(6)
          NTYPX(6) = NTYPX(6) + 1
          NTYPX(7) = NTYPX(7) + 1
        ELSE
          CALL ASSERT (.FALSE.)
        ENDIF
      ELSEIF (NFISS.GT.1) THEN
        ZI(JJ+5)= ITYPX(6+ABS(ZI(JJ+1)))
        NTYPX(7+ABS(ZI(JJ+1))) = NTYPX(7+ABS(ZI(JJ+1))) + 1
        NTYPX(7) = NTYPX(7) + 1
      ENDIF

      CALL JEDEMA()
      END
