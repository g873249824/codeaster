      SUBROUTINE MECHDA (MODELE,NCHAR,LCHAR,EXITIM,TIME,CHEPSA)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER                   NCHAR
      REAL*8                                            TIME
      CHARACTER*(*)      MODELE,      LCHAR(*)
      CHARACTER*24                                           CHEPSA
      LOGICAL                                    EXITIM
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 10/09/97   AUTEUR CIBHHGB G.BERTRAND 
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
C        - ON VERIFIE LE CHAMP DE DEFORMATIONS ANELASTIQUES.
C     ------------------------------------------------------------------
C IN  : MODELE : MODELE
C IN  : NCHAR  : NOMBRE DE CHARGES
C IN  : LCHAR  : LISTE DES CHARGES
C IN  : EXITIM : VRAI SI L'INSTANT EST DONNE
C IN  : TIME   : INSTANT DE CALCUL
C OUT : CHTEMP : NOM DU CHAMP DE DEFORMATIONS ANELASTIQUES TROUVE
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8  K8B, NOMO, NOMA, EPSANE
      LOGICAL      EXITHE
C
      CALL JEMARQ()
      IF (MODELE(1:1).NE.' ') THEN
         NOMO = MODELE
      ELSEIF (NCHAR.LE.0) THEN
         CALL UTMESS('F','MECHDA','IL FAUT UN MODELE OU DES CHARGES.')
      ELSE
         CALL DISMOI('F','NOM_MODELE',LCHAR(1),'CHARGE',IBID,NOMO,IE)
      ENDIF
C
      CALL DISMOI('F','NOM_MAILLA',NOMO,'MODELE',IBID,NOMA,IE)
C
      EPSANE = ' '
      DO 10 ICHA = 1,NCHAR
         CALL JEEXIN(LCHAR(ICHA)(1:8)//'.CHME.EPSI.ANEL',IRET)
         IF (IRET.NE.0) THEN
            CALL JEVEUO(LCHAR(ICHA)(1:8)//'.CHME.EPSI.ANEL','L',JTEMP)
            EPSANE = ZK8(JTEMP)
            GOTO 20
         ENDIF
 10   CONTINUE
 20   CONTINUE
      CHEPSA = '&&MECHDA.CH_EPSA_R         '
      CALL MEPSAN(NOMA,EPSANE,EXITIM,TIME,EXITHE,CHEPSA)
C
      CALL JEDEMA()
      END
