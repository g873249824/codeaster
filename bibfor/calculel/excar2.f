      SUBROUTINE EXCAR2(CHIN,LIGREL,NGRMX,DESC,DG)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER NGRMX,DESC,DG(*)
      CHARACTER*19 LIGREL,CHIN

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 10/04/2002   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE VABHHTS J.TESELET

C BUT : RECOPIER DANS LE CHAMP LOCAL, LES CMPS DE LA CARTE CORRESPONDANT
C       AU DESCRIPTEUR-GRANDEUR DG

      COMMON /CAII01/IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO,
     &               ILCHLO
      COMMON /CAII03/IAMACO,ILMACO,IAMSCO,ILMSCO,IALIEL,ILLIEL
      COMMON /CAII04/IACHII,IACHIK,IACHIX
      COMMON /CAII06/IAWLOC,IAWTYP,NBELGR,IGR
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM
      CHARACTER*80 ZK80
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------

      CHARACTER*8 NOMA,NOMAIL
      INTEGER NEC,PTMA,PTMS,IENT,IMA,DEB2
      INTEGER IGD,DEBGD,IBID,INDVAL
C     -- FONCTIONS FORMULES :
C     NUMAIL(IGR,IEL)=NUMERO DE LA MAILLE ASSOCIEE A L'ELEMENT IEL
      NUMAIL(IGR,IEL) = ZI(IALIEL-1+ZI(ILLIEL-1+IGR)-1+IEL)

C DEB-------------------------------------------------------------------


C     SI LA CARTE EST CONSTANTE:
C     --------------------------
      IF (NGRMX.EQ.1 .AND. ZI(DESC-1+4).EQ.1) THEN
        DEBGD = 3 + 2*NGRMX + 1
        DEB2 = 1
        DO 10,IEL = 1,NBELGR
          CALL TRIGD(ZI(DESC-1+DEBGD),1,DG,DEB2,.FALSE.,0,0)
   10   CONTINUE
        GO TO 40
      END IF


C     SI LA CARTE N'EST PAS CONSTANTE :
C     ---------------------------------
      PTMA = ZI(IACHII-1+11* (IICHIN-1)+6)
      PTMS = ZI(IACHII-1+11* (IICHIN-1)+7)

      DEB2 = 1
      DO 20,IEL = 1,NBELGR
C       RECHERCHE DU NUMERO DE L'ENTITE CORRESPONDANT A LA MAILLE IMA:
        IMA = NUMAIL(IGR,IEL)
        IF (IMA.LT.0) THEN
          IENT = ZI(PTMS-1-IMA)
        ELSE
          IENT = ZI(PTMA-1+IMA)
        END IF
        IF (IENT.EQ.0) GO TO 20

C       RECOPIE:
C       -------
        DEBGD = 3 + 2*NGRMX + (IENT-1)*NEC + 1
        INDVAL = (IENT-1)*NCMPMX + 1

        CALL TRIGD(ZI(DESC-1+DEBGD),INDVAL,DG,DEB2,.FALSE.,0,0)
   20 CONTINUE

   40 CONTINUE

      END
