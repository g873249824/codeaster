      SUBROUTINE PRMONO ( CHAMP, IOC, SOM, NBCMP, NOCMP )
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
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
C     COMMANDE : POST_RELEVE_T
C                DETERMINE LA MOYENNE SUR DES ENTITES POUR UN CHAM_NO
C
C ----------------------------------------------------------------------
      IMPLICIT   NONE
      INTEGER             IOC, NBCMP
      REAL*8              SOM(1)
C ----- DEBUT COMMUNS NORMALISES  JEVEUX  ------------------------------
      CHARACTER*8         NOCMP(1)
      CHARACTER*(*)       CHAMP
      INTEGER           ZI
      COMMON / IVARJE / ZI(1)
      REAL*8            ZR
      COMMON / RVARJE / ZR(1)
      COMPLEX*16        ZC
      COMMON / CVARJE / ZC(1)
      LOGICAL           ZL
      COMMON / LVARJE / ZL(1)
      CHARACTER*8       ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                       ZK24
      CHARACTER*32                                ZK32
      CHARACTER*80                                         ZK80
      COMMON / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C ----- FIN COMMUNS NORMALISES  JEVEUX  -------------------------------
C
      INTEGER      JCNSK, JCNSD, JCNSV, JCNSL, JCNSC, NBNO, NCMP, NBN
      INTEGER      IBID, NBNOEU, INDIK8, IDNOEU, NBC, JCMP
      INTEGER      I100, I110, ICP, INO
      REAL*8       X
      CHARACTER*8  K8B, MA
      CHARACTER*16 MOTCLE(4), TYPMCL(4)
      CHARACTER*19 CHAMS1
      CHARACTER*24 MESNOE
      INTEGER      IARG
C ---------------------------------------------------------------------
C
      MOTCLE(1) = 'GROUP_NO'
      MOTCLE(2) = 'NOEUD'
      MOTCLE(3) = 'GROUP_MA'
      MOTCLE(4) = 'MAILLE'
      TYPMCL(1) = 'GROUP_NO'
      TYPMCL(2) = 'NOEUD'
      TYPMCL(3) = 'GROUP_MA'
      TYPMCL(4) = 'MAILLE'
      MESNOE = '&&PRMONO.MES_NOEUDS'
C
      CHAMS1 = '&&PRMONO.CHAMS1'
      CALL CNOCNS ( CHAMP,'V', CHAMS1 )
C
      CALL JEVEUO ( CHAMS1//'.CNSK', 'L', JCNSK )
      CALL JEVEUO ( CHAMS1//'.CNSD', 'L', JCNSD )
      CALL JEVEUO ( CHAMS1//'.CNSC', 'L', JCNSC )
      CALL JEVEUO ( CHAMS1//'.CNSV', 'L', JCNSV )
      CALL JEVEUO ( CHAMS1//'.CNSL', 'L', JCNSL )
      MA    = ZK8(JCNSK-1+1)
      NBNO  =  ZI(JCNSD-1+1)
      NCMP  =  ZI(JCNSD-1+2)
C
      CALL RELIEM(' ',MA,'NU_NOEUD','ACTION',IOC,4,MOTCLE,TYPMCL,
     +                                                   MESNOE,NBN)
      IF (NBN.GT.0) THEN
        NBNOEU = NBN
        CALL JEVEUO ( MESNOE, 'L', IDNOEU )
      ELSE
        NBNOEU = NBNO
      ENDIF
C
      CALL GETVTX ( 'ACTION', 'NOM_CMP', IOC,IARG,0,K8B, NBC )
      IF (NBC.NE.0) THEN
         NBCMP = -NBC
         CALL WKVECT('&&PRMONO.NOM_CMP','V V K8',NBCMP,JCMP)
         CALL GETVTX('ACTION','NOM_CMP',IOC,IARG,NBCMP,ZK8(JCMP),IBID)
      ELSE
         NBCMP = NCMP
      ENDIF
C
      DO 100 I100 = 1, NBCMP
         IF (NBC.NE.0) THEN
            NOCMP(I100) = ZK8(JCMP+I100-1)
            ICP = INDIK8( ZK8(JCNSC), NOCMP(I100), 1, NCMP )
            IF (ICP.EQ.0) GOTO 100
         ELSE
            ICP = I100
            NOCMP(I100) = ZK8(JCNSC+I100-1)
         ENDIF
         SOM(I100) = 0.D0
C
         DO 110 I110 = 1 , NBNOEU
            IF (NBN.GT.0) THEN
               INO = ZI(IDNOEU+I110-1)
            ELSE
               INO = I110
            ENDIF
C
            IF ( ZL(JCNSL-1+(INO-1)*NCMP+ICP) ) THEN
C
               X = ZR(JCNSV-1+(INO-1)*NCMP+ICP)
               SOM(I100) = SOM(I100) + X
C
            ENDIF
C
 110     CONTINUE
         SOM(I100) = SOM(I100)/NBNOEU
C
 100  CONTINUE
C
      CALL DETRSD ( 'CHAM_NO_S', CHAMS1 )
      CALL JEDETC ( 'V','&&PRMONO',1 )
C
      END
