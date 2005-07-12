      SUBROUTINE EXCART(IMODAT,IPARG)
      IMPLICIT REAL*8 (A-H,O-Z)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/07/2005   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE                            VABHHTS J.PELLET
C     ARGUMENTS:
C     ----------
      INTEGER IMODAT,IPARG
C ----------------------------------------------------------------------
C     ENTREES:
C       IGR   : NUMERO DU GREL A TRAITER (COMMON)
C       IMODAT : INDICE DANS LA COLLECTION MODELOC
C ----------------------------------------------------------------------
      COMMON /CAII01/IGD,NEC,NCMPMX,IACHIN,IACHLO,IICHIN,IANUEQ,LPRNO,
     &       ILCHLO
      COMMON /CAKK02/TYPEGD
      CHARACTER*8 TYPEGD
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     &       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      COMMON /CAII03/IAMACO,ILMACO,IAMSCO,ILMSCO,IALIEL,ILLIEL
      COMMON /CAII04/IACHII,IACHIK,IACHIX
      INTEGER        IAWLOC,IAWTYP,NBELGR,IGR,JCTEAT,LCTEAT
      COMMON /CAII06/IAWLOC,IAWTYP,NBELGR,IGR,JCTEAT,LCTEAT
      COMMON /CAII08/IEL

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
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER DESC,IGD,MODLOC,NBPOIN,DEC1,DEC2,LGCATA

C DEB-------------------------------------------------------------------

C     RECUPERATION DE LA CARTE:
C     -------------------------
      DESC = ZI(IACHII-1+11* (IICHIN-1)+4)
      NGRMX = ZI(DESC-1+2)
      MODLOC = IAMLOC - 1 + ZI(ILMLOC-1+IMODAT)
      ITYPLO = ZI(MODLOC-1+1)
      NBPOIN = ZI(MODLOC-1+4)
      LGCATA = ZI(IAWLOC-1+7* (IPARG-1)+4)


C     1-  CAS: CART -> ELNO (OU ELGA) : "EXPAND"
C     -------------------------------------------
      IF ((ITYPLO.EQ.2).OR.(ITYPLO.EQ.3)) THEN

        IF ((ITYPLO.EQ.2).AND.(NBPOIN.GT.10000)) THEN
          CALL UTMESS('F',' EXCART','A FAIRE ...')
        ELSE
          NCMP=LGCATA/NBPOIN
          CALL EXCAR2(NGRMX,DESC,ZI(MODLOC-1+5),LGCATA)
C         ON DUPPLIQUE LES VALEURS PAR LA FIN POUR NE PAS
C         LES ECRASER :
          DO 77,IEL=NBELGR,1,-1
            DO 78,IPT=NBPOIN,1,-1
              DEC1=(IEL-1)*NCMP
              DEC2=(IEL-1)*NCMP*NBPOIN +NCMP*(IPT-1)
              CALL JACOPO(NCMP,TYPEGD,IACHLO+DEC1,IACHLO+DEC2)
              CALL JACOPO(NCMP,'L',ILCHLO+DEC1,ILCHLO+DEC2)
78          CONTINUE
77        CONTINUE
        END IF


C     2-  CAS: CART -> ASSE :
C     -----------------------
      ELSE IF (ITYPLO.GE.4) THEN
        CALL UTMESS('F',' EXCART','IMPOSSIBLE')


C     3-  CAS: CART -> ELEM :
C     -----------------------
      ELSE IF (ITYPLO.EQ.1) THEN
        CALL EXCAR2(NGRMX,DESC,ZI(MODLOC-1+5),LGCATA)


      END IF

   40 CONTINUE
      END
