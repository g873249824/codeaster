      SUBROUTINE CRSVMF(MOTFAC,SOLVEU,ISTOP,NPREC,SYME,EPSMAT,MIXPRE,
     &                  KMD)
      IMPLICIT NONE
      INTEGER      ISTOP,NPREC
      REAL*8       EPSMAT
      CHARACTER*3  SYME,MIXPRE,KMD
      CHARACTER*16 MOTFAC
      CHARACTER*19 SOLVEU
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
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
C ----------------------------------------------------------
C  BUT : REMPLISSAGE SD_SOLVEUR MULT_FRO
C
C IN K19 SOLVEU  : NOM DU SOLVEUR DONNE EN ENTREE
C OUT    SOLVEU  : LE SOLVEUR EST CREE ET INSTANCIE
C IN  IN ISTOP   : PARAMETRE LIE AUX MOT-CLE STOP_SINGULIER
C IN  IN NPREC   :                           NPREC
C IN  K3 SYME    :                           SYME
C IN  R8 EPSMAT  :                           FILTRAGE_MATRICE
C IN  K3 MIXPRE  :                           MIXER_PRECISION
C IN  K3 KMD     :                           MATR_DISTRIBUEE
C ----------------------------------------------------------

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------

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

C --- FIN DECLARATIONS NORMALISEES JEVEUX --------------------

      INTEGER      ISLVK,ISLVR,ISLVI,IBID
      CHARACTER*8  RENUM
      INTEGER      IARG

C------------------------------------------------------------------
      CALL JEMARQ()
      

C --- LECTURES PARAMETRES DEDIES AU SOLVEUR
      CALL GETVTX(MOTFAC,'RENUM',1,IARG,1,RENUM,IBID)
      CALL ASSERT(IBID.EQ.1)
      
C --- ON REMPLIT LA SD_SOLVEUR
      CALL JEVEUO(SOLVEU//'.SLVK','E',ISLVK)
      CALL JEVEUO(SOLVEU//'.SLVR','E',ISLVR)
      CALL JEVEUO(SOLVEU//'.SLVI','E',ISLVI)

      ZK24(ISLVK-1+1) = 'MULT_FRO'
      ZK24(ISLVK-1+2) = 'XXXX'
      ZK24(ISLVK-1+3) = 'XXXX'
      ZK24(ISLVK-1+4) = RENUM
      ZK24(ISLVK-1+5) = SYME
      ZK24(ISLVK-1+6) = 'XXXX'
      ZK24(ISLVK-1+7) = 'XXXX'
      ZK24(ISLVK-1+8) = 'XXXX'
      ZK24(ISLVK-1+9) = 'XXXX'
      ZK24(ISLVK-1+10)= 'XXXX'
      ZK24(ISLVK-1+11)= 'XXXX'
      ZK24(ISLVK-1+12)= 'XXXX'

      ZR(ISLVR-1+1) = 0.D0
      ZR(ISLVR-1+2) = 0.D0
      ZR(ISLVR-1+3) = 0.D0
      ZR(ISLVR-1+4) = 0.D0

      ZI(ISLVI-1+1) = NPREC
      ZI(ISLVI-1+2) = -9999
      ZI(ISLVI-1+3) = ISTOP
      ZI(ISLVI-1+4) = -9999
      ZI(ISLVI-1+5) = -9999
      ZI(ISLVI-1+6) = -9999
      ZI(ISLVI-1+7) = -9999
                  
      CALL JEDEMA()
      END
