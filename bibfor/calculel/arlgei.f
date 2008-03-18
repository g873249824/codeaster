      INTEGER FUNCTION ARLGEI(NOMARL,NOMDAT)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 18/03/2008   AUTEUR CNGUYEN C.NGUYEN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*6 NOMDAT
      CHARACTER*8 NOMARL
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C RECUPERATION INFORMATIONS GENERALES SUR ARLEQUIN - LECTURE ENTIER
C
C ----------------------------------------------------------------------
C
C
C IN  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
C IN  NOMDAT : QUESTION
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      CHARACTER*6  NOMDA1
      CHARACTER*24 INFOI
      INTEGER      JARLII,IRET,DIMQUE,LXLGUT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      INFOI = NOMARL(1:8)//'.INFOI'
C
      CALL JEEXIN(INFOI,IRET)
      IF (IRET.EQ.0) THEN
        CALL U2MESK('F','ARLEQUIN_40',1,INFOI)
      ELSE
        CALL JEVEUO(INFOI,'L',JARLII )
      ENDIF
C
      DIMQUE = LXLGUT(NOMDAT)
      print *,'DIMQUE = ',DIMQUE
      NOMDA1 = NOMDAT(1:DIMQUE)
      print *,'NOMDA1 = ',NOMDA1
C
      IF (NOMDA1.EQ.'NHAPP') THEN
        ARLGEI = ZI(JARLII  )
      ELSE IF (NOMDA1.EQ.'NHINT') THEN
        ARLGEI = ZI(JARLII+1)
      ELSE IF (NOMDA1.EQ.'NH') THEN
        ARLGEI = ZI(JARLII+2)
      ELSE IF (NOMDA1.EQ.'IMAX') THEN
        ARLGEI = ZI(JARLII+3)
      ELSE IF (NOMDA1.EQ.'NMIN') THEN
        ARLGEI = ZI(JARLII+4)
      ELSE IF (NOMDA1.EQ.'NHQUA') THEN
        ARLGEI = ZI(JARLII+5)
      ELSE IF (NOMDA1.EQ.'ITEMCP') THEN
        ARLGEI = ZI(JARLII+6)
      ELSE IF (NOMDA1.EQ.'NCMAX') THEN
        ARLGEI = ZI(JARLII+7)
      ELSE IF (NOMDA1.EQ.'NTMAX') THEN
        ARLGEI = ZI(JARLII+8)
      ELSE IF (NOMDA1.EQ.'ULPMAI') THEN
        ARLGEI = ZI(JARLII+9)
      ELSE IF (NOMDA1.EQ.'METHOD') THEN
        ARLGEI = ZI(JARLII+10)
      ELSE
        CALL U2MESK('F','ARLEQUIN_15',1,NOMDA1)
      ENDIF
C
      CALL JEDEMA()
      END
