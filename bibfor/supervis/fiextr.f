      SUBROUTINE FIEXTR(LPLACE,JCLASS,IVAL,RVAL,CVAL,NOM,IPRIOR,IARITE)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           LPLACE,JCLASS,IVAL,              IPRIOR,IARITE
      REAL*8                               RVAL
      COMPLEX*16                                CVAL
      CHARACTER*(*)                                  NOM
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 04/01/95   AUTEUR G8BHHAC A.Y.PORTABILITE 
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
C     EXTRACTION D'UN ITEM CONNU PAR SA PLACE DANS LES TABLES
C     ------------------------------------------------------------------
C IN  LPLACE : I : NUMERO (PLACE) DE L'ITEM DONT ON VEUT LES CARAC.
C OUT JCLASS : I :
C OUT IVAL   : I :
C OUT RVAL   : R :
C OUT NOM    : K8:
C     ------------------------------------------------------------------
C
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
C
C     DEBUT INCLUDE($INCLUDE) ------------------------------------------
      CHARACTER*24
     +   KNOMOP, KARITE, KPRIOR, KCLASS, KVALIS, KVALR8, KVALC8
      INTEGER
     +   LNOMOP, LARITE, LPRIOR, LCLASS, LVALIS, LVALR8, LVALC8
C     ------------------------------------------------------------------
      COMMON /FICK01/
     +   KNOMOP, KARITE, KPRIOR, KCLASS, KVALIS, KVALR8, KVALC8
      COMMON /FICI01/
     +   LNOMOP, LARITE, LPRIOR, LCLASS, LVALIS, LVALR8, LVALC8
C     ------------------------------------------------------------------
C     ICSTE  : NOMBRE D'INFORMATION ARCHIVES
C     IOPE1  : NOMBRE D'OPERATEURS UNAIRES
C     IOPE2  : NOMBRE D'OPERATEURS BINAIRES
C     LOPE1  : PREMIER NUMERO D'ORDRE DES OPERATEURS UNAIRES
C     LOPE2  : PREMIER NUMERO D'ORDRE DES OPERATEURS BINAIRES
      COMMON /FICL01/ ICSTE , IOPE1, IOPE2, LOPE1, LOPE2
      COMMON /FISY01/ IPARG,IPARD,IVIRG,IEGAL,IPTVI,ILOAD,IPLUS,IFONC
C     FIN INCLUDE($INCLUDE) --------------------------------------------
C
C     ---- RECHERCHE DANS LES TABLES ----
      JCLASS   = ZI(LCLASS-1+LPLACE)
      NOM      = ZK8(LNOMOP-1+LPLACE)
      IVAL     = ZI(LVALIS-1+LPLACE)
      RVAL     = ZR(LVALR8-1+LPLACE)
      CVAL     = ZC(LVALC8-1+LPLACE)
      IPRIOR   = ZI(LPRIOR-1+LPLACE)
      IARITE   = ZI(LARITE-1+LPLACE)
      END
