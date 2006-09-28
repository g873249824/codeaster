      SUBROUTINE IMPSDR(IMPRCO,
     &                  COLONN,VALK,VALR,VALI)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*14  IMPRCO
      CHARACTER*9   COLONN
      CHARACTER*(*) VALK
      REAL*8        VALR
      INTEGER       VALI
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : NMCONV
C ----------------------------------------------------------------------
C
C OPERATIONS ELEMENTAIRES SUR LA SD AFFICHAGE DE COLONNES
C AFFECTATION DES VALEURS POUR LA COLONNE
C SI LA COLONNE A UN CODE INCORRECT: ERREUR FATALE
C SI LA COLONNE N'EXISTE PAS POUR L'AFFICHAGE COURANT: ON IGNORE
C
C IN IMPRCO : SD SUR L'AFFICHAGE DES COLONNES
C IN COLONN : CODE TYPE DE LA COLONNE (VOIR LISTE DANS IMPREF)
C IN VALK   : VALEUR DE TYPE K16 POUR LES COLONNES DE TYPE CHAINE
C IN VALR   : VALEUR DE TYPE REAL POUR LES COLONNES DE TYPE REEL
C IN VALI   : VALEUR DE TYPE ENTIER POUR LES COLONNES DE TYPE ENTIER
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
      INTEGER      JIMPCO,JIMPTY,JIMPIN,JIMPMA
      CHARACTER*24 IMPCOL,IMPTYP,IMPINF,IMPMAR
      INTEGER      JIMPRR,JIMPRK,JIMPRI
      CHARACTER*24 IMPRER,IMPREK,IMPREI
      INTEGER      I,ICOL,ICOD
      INTEGER      NBCOL,FORCOL
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C ---
C
      IMPINF = IMPRCO(1:14)//'INFO'
      IMPTYP = IMPRCO(1:14)//'DEFI.TYP'
      IMPCOL = IMPRCO(1:14)//'DEFI.COL'
      IMPRER = IMPRCO(1:14)//'DEFI.RER'
      IMPREI = IMPRCO(1:14)//'DEFI.REI'
      IMPREK = IMPRCO(1:14)//'DEFI.REK'
      IMPMAR = IMPRCO(1:14)//'DEFI.MAR'

      CALL JEVEUO(IMPINF,'L',JIMPIN)
      CALL JEVEUO(IMPTYP,'L',JIMPTY)
      CALL JEVEUO(IMPCOL,'L',JIMPCO)
      CALL JEVEUO(IMPRER,'E',JIMPRR)
      CALL JEVEUO(IMPREI,'E',JIMPRI)
      CALL JEVEUO(IMPREK,'E',JIMPRK)
      CALL JEVEUO(IMPMAR,'E',JIMPMA)
C
C --- NOMBRE DE COLONNES
C
      ICOL  = 0
      NBCOL = ZI(JIMPIN-1+4)
C
C --- RECHERCHE DE LA COLONNE AYANT CE TYPE
C
      CALL IMPCOD(COLONN,ICOD)
      IF (ICOD.EQ.0) THEN
          CALL U2MESS('F','ALGORITH4_27')
      ENDIF
      DO 10 I = 1,NBCOL
       IF (ZI(JIMPCO-1+I).EQ.ICOD) THEN
         ICOL = I
C
C --- RECUPERATION DU FORMAT DE LA COLONNE
C
         FORCOL    = ZI(JIMPTY-1+ICOL)
C
C --- ECRITURE DE LA VALEUR DE LA COLONNE
C
         IF (FORCOL.EQ.1) THEN
           ZI(JIMPRI-1+ICOL)   = VALI
         ELSE IF (FORCOL.EQ.2) THEN
           ZR(JIMPRR-1+ICOL)   = VALR
         ELSE IF (FORCOL.EQ.3) THEN
           ZK16(JIMPRK-1+ICOL) = VALK(1:16)
         ELSE
           CALL U2MESS('F','ALGORITH4_29')
         ENDIF
       ENDIF
  10  CONTINUE
      CALL JEDEMA()

      END
