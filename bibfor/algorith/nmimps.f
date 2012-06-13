      SUBROUTINE NMIMPS(SDCONV,SDIMPR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24  SDIMPR,SDCONV
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (AFFICHAGE - ACCES SD)
C
C IMPRESSION DES RESIDUS (RECAP FIN DE PAS)
C
C ----------------------------------------------------------------------
C
C
C IN  SDIMPR : SD AFFICHAGE
C IN  SDCONV : SD GESTION DE LA CONVERGENCE
C
C
C
C
      INTEGER      ZCOL
      PARAMETER    (ZCOL = 16)
      CHARACTER*16 RESNOM(ZCOL)
      REAL*8       RESVAL(ZCOL)
      CHARACTER*16 RESNOE(ZCOL)
C
      CHARACTER*24 CNVTYP,CNVLIE,CNVVAL,CNVACT,CNVNCO
      INTEGER      JCNVTY,JCNVLI,JCNVVA,JCNVAC,JCNVNC
      INTEGER      JIMPCO,JIMPIN
      CHARACTER*24 IMPCOL,IMPINF
      INTEGER      ICOL,IRESI,ICOD,IARG
      INTEGER      NCOL,IBID,NRESI
      CHARACTER*9  COLONN
      CHARACTER*8  K8BID
      REAL*8       VALR(1)
      CHARACTER*16 VALK(2)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES SD CONVERGENCE
C
      CNVTYP = SDCONV(1:19)//'.TYPE'
      CNVLIE = SDCONV(1:19)//'.LIEU'
      CNVVAL = SDCONV(1:19)//'.VALE'
      CNVACT = SDCONV(1:19)//'.ACTI'
      CNVNCO = SDCONV(1:19)//'.NCOL'
      CALL JEVEUO(CNVTYP,'L',JCNVTY)
      CALL JEVEUO(CNVLIE,'L',JCNVLI)
      CALL JEVEUO(CNVVAL,'L',JCNVVA)
      CALL JEVEUO(CNVACT,'L',JCNVAC)
      CALL JEVEUO(CNVNCO,'L',JCNVNC)
      CALL JELIRA(CNVTYP,'LONMAX',NRESI,K8BID)
C
C --- ACCES SD AFFICHAGE
C
      IMPINF = SDIMPR(1:14)//'.INFO'
      IMPCOL = SDIMPR(1:14)//'.DEFI.COL'
      CALL JEVEUO(IMPINF,'L',JIMPIN)
      CALL JEVEUO(IMPCOL,'L',JIMPCO)
      NCOL   = ZI(JIMPIN-1+1)
C
C --- INITIALISATIONS
C
      IARG   = 0
      CALL ASSERT(ZCOL.EQ.16)
C
C --- BOUCLE SUR LES RESIDUS
C
      DO 10 IRESI = 1,NRESI
        COLONN = ZK16(JCNVNC-1+IRESI)(1:9)
        CALL IMPCOD(COLONN,ICOD)
        IF (ICOD.EQ.0) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
        DO 15 ICOL = 1,NCOL
          IF (ZI(JIMPCO-1+ICOL).EQ.ICOD) THEN
            IF (ZL(JCNVAC-1+IRESI)) THEN
              IARG = IARG + 1
              RESNOM(IARG) = ZK16(JCNVTY-1+IRESI)
              RESVAL(IARG) = ZR(JCNVVA-1+IRESI)
              RESNOE(IARG) = ZK16(JCNVLI-1+IRESI)
            ENDIF
          ENDIF
 15     CONTINUE
 10   CONTINUE
C
C --- AFFICHAGE
C
      IARG = 0
      DO 20 IRESI = 1,NRESI
        IF (ZL(JCNVAC-1+IRESI)) THEN
          IARG = IARG + 1
          VALK(1) = RESNOM(IARG)
          VALK(2) = RESNOE(IARG)
          VALR(1) = RESVAL(IARG)
          CALL U2MESG('I','MECANONLINE6_70',2,VALK,0,IBID,1,VALR)
        ENDIF
  20  CONTINUE
C
      CALL JEDEMA()

      END
