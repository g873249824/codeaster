      SUBROUTINE EXTRA1(NIN,LCHIN,LPAIN,OPT,NUTE,LIGREL)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 28/07/2008   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PELLET J.PELLET
      INTEGER NIN,OPT,NUTE
      CHARACTER*(*) LCHIN(*)
      CHARACTER*8 LPAIN(*)
      CHARACTER*19 LIGREL
C ----------------------------------------------------------------------
C     BUT: PREPARER LES CHAMPS LOCAUX "IN"

C ----------------------------------------------------------------------
      CHARACTER*16 OPTION,NOMTE,NOMTM,PHENO,MODELI
      COMMON /CAKK01/OPTION,NOMTE,NOMTM,PHENO,MODELI
      INTEGER IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO,ILCHLO
      COMMON /CAII01/IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO,
     &       ILCHLO
      COMMON /CAKK02/TYPEGD
      INTEGER IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,IAOPPA,
     &        NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      INTEGER IACHII,IACHIK,IACHIX,DEBUGR,LGGREL
      COMMON /CAII04/IACHII,IACHIK,IACHIX
      INTEGER        NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      COMMON /CAII06/NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      CHARACTER*8 TYPEGD
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
      CHARACTER*19 CHIN
      CHARACTER*4 TYPE
      CHARACTER*8 NOMPAR,NOPARA
      INTEGER K,INDIK8,IPARG,IMODAT,LGCATA
      INTEGER IPAR,NBPARA,NPIN,IPARIN
      LOGICAL EXICH


C DEB-------------------------------------------------------------------


      NPIN=NBPARA(OPT,NUTE,'IN ')
      DO 90 IPAR=1,NPIN
        NOMPAR=NOPARA(OPT,NUTE,'IN ',IPAR)
        IPARG=INDIK8(ZK8(IAOPPA),NOMPAR,1,NPARIO)
        IPARIN=INDIK8(LPAIN,NOMPAR,1,NIN)
        EXICH=((IPARIN.GT.0) .AND. ZL(IACHIX-1+IPARIN))
        IF (.NOT.EXICH) THEN
          ZI(IAWLOC-1+3*(IPARG-1)+1)=-1
          ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR-1)+2)=0
          GOTO 90
        ENDIF

        CALL ASSERT(IPARIN.NE.0)
        CHIN=LCHIN(IPARIN)
        IF (CHIN(1:1).EQ.' ') CALL U2MESK('E','CALCULEL2_56',1,NOMPAR)



C       -- MISE A JOUR DES COMMON CAII01 ET CAKK02:
        IICHIN=IPARIN
        IGD=ZI(IACHII-1+11*(IPARIN-1)+1)
        NEC=ZI(IACHII-1+11*(IPARIN-1)+2)
        NCMPMX=ZI(IACHII-1+11*(IPARIN-1)+3)
        IACHIN=ZI(IACHII-1+11*(IPARIN-1)+5)
        IANUEQ=ZI(IACHII-1+11*(IPARIN-1)+10)
        LPRNO=ZI(IACHII-1+11*(IPARIN-1)+11)
        IPARG=INDIK8(ZK8(IAOPPA),NOMPAR,1,NPARIO)
        IACHLO=ZI(IAWLOC-1+3*(IPARG-1)+1)
        ILCHLO=ZI(IAWLOC-1+3*(IPARG-1)+2)
        IMODAT=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR-1)+1)
        CALL ASSERT((IACHLO.LT.-2) .OR. (IACHLO.GT.0))
        CALL ASSERT(ILCHLO.NE.-1)
        TYPE=ZK8(IACHIK-1+2*(IPARIN-1)+1)(1:4)
        TYPEGD=ZK8(IACHIK-1+2*(IPARIN-1)+2)



C       1- MISE A .FALSE. DU CHAMP_LOC.EXIS
C       -----------------------------------------------------
        LGGREL=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR-1)+4)
        DEBUGR=ZI(IAWLO2-1+5*(NBGR*(IPARG-1)+IGR-1)+5)
        DO 30,K=1,LGGREL
          ZL(ILCHLO-1+DEBUGR-1+K)=.FALSE.
   30   CONTINUE


C       2- ON LANCE L'EXTRACTION:
C       -------------------------------------------
        IF (TYPE.EQ.'CART') CALL EXCART(IMODAT,IPARG)
        IF (TYPE.EQ.'CHML') CALL EXCHML(IMODAT,IPARG)
        IF (TYPE.EQ.'CHNO') CALL EXCHNO(IMODAT,IPARG)
        IF (TYPE.EQ.'RESL') CALL EXRESL(IMODAT,IPARG,CHIN)
   90 CONTINUE


   40 CONTINUE

      END
