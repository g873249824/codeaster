      SUBROUTINE SSVAU1(NOMACR,IAVEIN,IAVEOU)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 01/02/2000   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)

C     ARGUMENTS:
C     ----------
      CHARACTER*8 NOMACR
      INTEGER IAVEIN,IAVEOU
C ----------------------------------------------------------------------
C     BUT:
C         "CONDENSER" UN  VECTEUR CHARGEMENT D'UN MACR_ELEM_STAT :
C          EN ENTREE :
C            VECIN  (     1,NDDLI      )  =  F_I (EVENT. TOURNE)
C            VECIN  (NDDLI+1,NDDLI+NDDLE) =  F_E (EVENT. TOURNE)

C          EN SORTIE :
C            VECOUT(       1,NDDLI      ) = (KII**-1)*F_I
C            VECOUT(NDDLI+1,NDDLI+NDDLE)  =  FP_E
C            OU FP_E = F_E - K_EI*(KII**-1)*F_I

C     IN: NOMACR : NOM DU MACR_ELEM_STAT
C         IAVEIN : ADRESSE DANS ZR DU VECTEUR A CONDENSER.(VECIN)
C         IAVEOU : ADRESSE DANS ZR DU VECTEUR CONDENSE.(VECOUT)

C         IMPORTANT : LES 2 ADRESSES IAVEIN ET IAVEOU PEUVENT ETRE
C                     IDENTIQUES (CALCUL EN PLACE).

C     OUT:   LE VECTEUR VECOUT EST CALCULE.
C ----------------------------------------------------------------------


      CHARACTER*8 KBID
      CHARACTER*8 NOMO
      INTEGER I,ADIA,HCOL,IBLO
C --------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR,EPSI
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16,OPTIO2
      CHARACTER*19 MATAS,STOCK,NU
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------

      CALL JEMARQ()

      MATAS = NOMACR//'.RIGIMECA'
      NU = NOMACR
      NU = NU(1:14)//'.NUME'
      STOCK = NU(1:14)//'.SLCS'
      CALL JEVEUO(STOCK//'.IABL','L',IAIABL)


      CALL JEVEUO(NOMACR//'.DESM','L',IADESM)
      NDDLE = ZI(IADESM-1+4)
      NDDLI = ZI(IADESM-1+5)
      NDDLT = NDDLI + NDDLE


C     -- ON RECOPIE VECIN DANS VECOUT POUR EVITER LES EFFETS DE BIAIS:
C     ---------------------------------------------------------------
      DO 10,KK = 1,NDDLT
        ZR(IAVEOU-1+KK) = ZR(IAVEIN-1+KK)
   10 CONTINUE


C     -- ON COMMENCE PAR CONDITIONNER LE SECOND MEMBRE INITIAL (.CONL)
C     ------------------- -------------------------------------------
      CALL MTDSCR(MATAS)
      CALL JEVEUO(MATAS(1:19)//'.&INT','E',LMAT)
      CALL MRCONL(LMAT,NDDLT,'R',ZR(IAVEOU),1)


C     -- CALCUL DE QI0 = (K_II**(-1))*F_I DANS : VECOUT(1->NDDLI):
C     ------------------- ----------------------------------------
      CALL JEVEUO(ZK24(ZI(LMAT+1)) (1:19)//'.REFA','L',IDREFE)
      CALL JEVEUO(ZK24(IDREFE+2) (1:19)//'.HCOL','L',IAHCOL)
      CALL MTDSC2(ZK24(ZI(LMAT+1)),'ADIA','L',IAADIA)
      CALL MTDSC2(ZK24(ZI(LMAT+1)),'ABLO','L',IAABLO)
      NBBLOC = ZI(LMAT+13)

      CALL RLDLR8(ZK24(ZI(LMAT+1)),ZI(IAHCOL),ZI(IAADIA),ZI(IAABLO),
     &            NDDLI,NBBLOC,ZR(IAVEOU),1)


C     -- CALCUL DE FP_E = F_E-K_EI*QI0 DANS : VECOUT(NDDLI+1,NDDLT):
C     -----------------------------------------------------------------
      IBLOLD = 0
      DO 30,J = 1,NDDLE
        IBLO = ZI(IAIABL-1+NDDLI+J)
        ADIA = ZI(IAADIA-1+NDDLI+J)
        HCOL = ZI(IAHCOL-1+NDDLI+J)
        IF (IBLO.NE.IBLOLD) THEN
          IF (IBLOLD.GT.0) CALL JELIBE(JEXNUM(MATAS//'.VALE',IBLOLD))
          CALL JEVEUO(JEXNUM(MATAS//'.VALE',IBLO),'L',IAVALM)
        END IF
        IBLOLD = IBLO
        KK = 0
        DO 20,K = NDDLI + J + 1 - HCOL,NDDLI
          KK = KK + 1
          ZR(IAVEOU-1+NDDLI+J) = ZR(IAVEOU-1+NDDLI+J) -
     &                           ZR(IAVEOU-1+K)*ZR(IAVALM-1+ADIA-HCOL+
     &                           KK)
   20   CONTINUE
   30 CONTINUE
      IF (IBLOLD.GT.0) CALL JELIBE(JEXNUM(MATAS//'.VALE',IBLOLD))


   40 CONTINUE
      CALL JEDETR(MATAS(1:19)//'.&VDI')
      CALL JELIBE(ZK24(IDREFE+2) (1:19)//'.HCOL')

      CALL JEDEMA()
      END
