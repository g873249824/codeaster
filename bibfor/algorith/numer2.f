      SUBROUTINE NUMER2(NUPOSS,NBLIGR,VLIGR,MOLOC,SOLVEU,BASE,NU)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/09/2002   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE VABHHTS J.PELLET
      IMPLICIT NONE
      CHARACTER*(*) MOLOC,VLIGR(*),SOLVEU,BASE,NU,NUPOSS
      INTEGER NBLIGR
C ----------------------------------------------------------------------
C BUT CREER UN NUME_DDL POUR UNE LISTE DE LIGRELS ET UNE GRANDEUR DONNEE
C ----------------------------------------------------------------------
C IN  K14  NUPOSS  : NOM D'UN NUME_DDL CANDIDAT (OU ' ')
C                    SI NUPOSS != ' ', ON  REGARDE SI LE PROF_CHNO
C                    DE NUPOSS EST CONVENABLE.
C IN      I    NBLIGR: NOMBRE DE LIGRELS DANS VLIGR
C IN/JXIN V(K19) VLIGR : LISTE DES NOMS DES LIGRELS
C IN      K8   MOLOC : MODE_LOCAL PERMETTANT DE CHOISIR LES DDLS
C                      A NUMEROTER.
C              SI MOLOC=' ', ON DEDUIT MOLOC DU PHENOMENE
C                      ATTACHE AUX LIGRELS (USAGE D'UN DISMOI TORDU)
C              SINON ON UTILISE LE MOLOC DONNE EN ARGUMENT
C IN/JXIN K19  SOLVEU: SOLVEUR
C IN      K2   BASE  : BASE(1:1) : BASE POUR CREER LE NUME_DDL
C                      (SAUF LE NUME_EQUA)
C                    : BASE(2:2) : BASE POUR CREER LE NUME_EQUA
C VAR/JXOUT K14 NU : NOM DU NUME_DDL.
C                    SI NUPOSS !=' ', NU PEUT ETRE MODIFIE (NU=NUPOSS)
C ----------------------------------------------------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER ISLVK,I,JLLIGR

      LOGICAL IDENOB,L1,L2,L3,L4,L5
      CHARACTER*19 SOLVE2
      CHARACTER*2 BAS2
      CHARACTER*8 K8BID
      CHARACTER*14 NU1,NU2
      CHARACTER*24 LLIGR,METHOD,TYPRES

C DEB ------------------------------------------------------------------

      CALL JEMARQ()
      SOLVE2 = SOLVEU
      BAS2 = BASE
      NU1=NU
      NU2=NUPOSS

      CALL DETRSD('NUME_DDL',NU1)

      CALL JEVEUO(SOLVE2//'.SLVK','L',ISLVK)
      TYPRES = ZK24(ISLVK)
      METHOD = ZK24(ISLVK+3)


      LLIGR = '&&NUMER2.LISTE_LIGREL'
      CALL WKVECT(LLIGR,'V V K24',NBLIGR,JLLIGR)
      DO 10 I = 1,NBLIGR
        ZK24(JLLIGR-1+I) = VLIGR(I)
   10 CONTINUE


      CALL NUEFFE(LLIGR,BAS2(2:2),NU1,METHOD,TYPRES,MOLOC)

C     -- ON ESSAYE D'ECONOMISER LE PROF_CHNO :
      IF (NU2.NE.' ') THEN

         L1=IDENOB(NU1//'.NUME.DEEQ',NU2//'.NUME.DEEQ')
         L2=IDENOB(NU1//'.NUME.LILI',NU2//'.NUME.LILI')
         L3=IDENOB(NU1//'.NUME.LPRN',NU2//'.NUME.LPRN')
         L4=IDENOB(NU1//'.NUME.NUEQ',NU2//'.NUME.NUEQ')
         L5=IDENOB(NU1//'.NUME.PRNO',NU2//'.NUME.PRNO')

         IF(L1.AND.L2.AND.L3.AND.L4.AND.L5)  THEN
           CALL DETRSD('NUME_DDL',NU1)
           CALL JEDUPO(NU1//'     .ADNE','V',NU2//'     .ADNE',.FALSE.)
           CALL JEDUPO(NU1//'     .ADLI','V',NU2//'     .ADLI',.FALSE.)
           CALL JEDETR(NU1//'     .ADLI')
           CALL JEDETR(NU1//'     .ADNE')
           NU1=NU2
         END IF
      END IF

      CALL PROFMA(NU1,SOLVEU,BAS2(1:1))
      CALL JEDETR(NU1//'     .ADLI')
      CALL JEDETR(NU1//'     .ADNE')
      NU=NU1

      CALL JEDETR(LLIGR)
      CALL JEDEMA()
      END
