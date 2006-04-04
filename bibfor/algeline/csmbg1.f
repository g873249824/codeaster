      SUBROUTINE CSMBG1(MAT,VSMB,VCINE)
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8 VSMB,VCINE
      CHARACTER*(*) MAT
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 04/04/2006   AUTEUR VABHHTS J.PELLET 
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
C-----------------------------------------------------------------------
C BUT : CALCUL DE LA CONTRIBUTION AU SECOND MEMBRE DES DDLS IMPOSEES
C       LORSQU'ILS SONT TRAITEES PAR ELIMINATION
C
C        ! K    K   ! L POUR NON IMPOSE I POUR IMPOSE
C K  =   !  LL   LI !
C        !  T       !
C        ! K    K   !
C        !  LI   II !
C
C  LE TRAITEMENT PAR ELIMINATION CONSISTE A RESOUDRE
C
C    ! K    0 !   ! X  !   ! 1  -K   !   ! F  !
C    !  LL    !   !  L !   !      IL !   !  I !
C    !        ! * !    ! = !         ! * !    ! <=> K' X = F'
C    ! 0    1 !   ! X  !   ! 0    1  !   ! U  !
C    !        !   !  I !   !         !   !  0 !
C  ON A LMAT  :DESCRIPTEUR DE K' CAR DANS L'ASSEMBLAGE ON ASSEMBLE
C              DIRECTEMENT K'   KIL SE TROUVE DANS .CCVA DE K'
C       VSMB  :EN IN (FI,0)  EN OUT = F'
C       VCINE : (0,U0)
C REMARQUES :
C  SI LMAT (7) = 0  ALORS GOTO 9999
C-----------------------------------------------------------------------
C !!!ATTENTION!!! LA MATRICE LE VECTEUR SECOND MEMBRE ET LE VECTEUR
C !!!ATTENTION!!! CINEMATIQUE DOIVENT TOUS LES TROIS ETRE DE MEME TYPE
C-----------------------------------------------------------------------
C IN  MAT   K19 : NOM DE LA MATRICE SUR LAQUELLE ON A EFFECTUE
C                 LES ELIMINATIONS
C VAR VSMB  SCA : VECTEUR SECOND MEMBRE
C IN  VCINE SCA : VECTEUR DE CHARGEMENT CINEMATIQUE ( LE U0 DE U = U0
C                 SUR G AVEC VCINE = 0 EN DEHORS DE G )
C-----------------------------------------------------------------------
C     FONCTIONS JEVEUX
C-----------------------------------------------------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
C-----------------------------------------------------------------------
C     COMMUNS JEVEUX
C-----------------------------------------------------------------------
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
C-----------------------------------------------------------------------
C     VARIABLES LOCALES
C-----------------------------------------------------------------------
      INTEGER NEQ,NIMPO,JCCLL,JCCJJ
      CHARACTER*19 KMAT,KSTOC,KBID
      COMPLEX*16 CBID
C-----------------------------------------------------------------------
C     DEBUT
C-----------------------------------------------------------------------
      CALL JEMARQ()
      KMAT = MAT
      CALL JEVEUO(KMAT//'.REFA','L',JREFA)
      KSTOC = ZK24(JREFA-1+2) (1:14)//'.SMOS'
      CALL JEEXIN(KSTOC//'.SMDE',IER)
      IF (IER.NE.0) THEN
        CALL JEVEUO(KSTOC//'.SMDE','L',JSMDE)
        NEQ = ZI(JSMDE-1+1)

      ELSE
        CALL JEVEUO(KSTOC//'.SCDE','L',JSCDE)
        NEQ = ZI(JSCDE-1+1)
      END IF

      CALL JEEXIN(KMAT//'.CCLL',IRET)
      IF (IRET.EQ.0) GO TO 10

      CALL JEVEUO(KMAT//'.CCLL','L',JCCLL)
      CALL JEVEUO(KMAT//'.CCJJ','L',JCCJJ)
      CALL JELIRA(KMAT//'.CCLL','LONMAX',NIMPO,KBID)
      NIMPO=NIMPO/3
      CALL ASSERT(NIMPO.GT.0)

      CALL JELIRA(KMAT//'.VALM','TYPE',IBID,KBID)
      CALL ASSERT(KBID.EQ.'R')
      CALL CSMBR8(KMAT,ZI(JCCLL),ZI(JCCJJ),NEQ,VCINE,VSMB)

 10   CONTINUE
      CALL JEDEMA()
      END
