      SUBROUTINE PASCOM(MECA  ,SDDYNA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 06/07/2009   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8  MECA
      CHARACTER*19 SDDYNA
C 
C ----------------------------------------------------------------------
C
C ROUTINE DYNA_NON_LINE (UTILITAIRE)
C
C EVALUATION DU PAS DE TEMPS DE COURANT POUR LE MODELE
C PRISE EN COMPTE D'UNE BASE MODALE
C      
C ----------------------------------------------------------------------
C
C         
C
C IN  MECA   : BASE MODALE (MODE_MECA)
C IN  SDDYNA : SD DEDIEE A LA DYNAMIQUE (CF NDLECT)
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER      ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8       ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16   ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL      ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16    ZK16
      CHARACTER*24        ZK24
      CHARACTER*32            ZK32
      CHARACTER*80                ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      N1,I
      INTEGER      IAD,JPAS,NBDT
      INTEGER      NBMODE
      INTEGER      IOROL,JORDM
      REAL*8       DTCOU,PHI,DT,NDYNRE,R8PREM
      CHARACTER*8  K8BID,STOCFL
      CHARACTER*19 LISINS
      LOGICAL      NDYNLO
C
C ---------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C

C     INITIALISATION DE DTCOU

      DTCOU = -1.D0

C     --- RECUPERATION DES FREQUENCES PROPRES

      CALL JELIRA(  MECA//'           .ORDR','LONUTI',NBMODE,K8BID)
      CALL JEVEUO(  MECA//'           .ORDR','L',JORDM)
      IOROL = ZI(JORDM)
      CALL RSADPA(  MECA, 'L',1,'OMEGA2',IOROL,0, IAD,K8BID)
      IF (ZR(IAD).LT.0.D0.OR.ABS(ZR(IAD)).LT.R8PREM( )) THEN
        DTCOU = 1.D0 / R8PREM( ) 
      ELSE
        DTCOU = 1.D0 / SQRT(ZR(IAD))
      ENDIF
      DO 21 I = 1,NBMODE-1
       IOROL = ZI(JORDM+I)
       CALL RSADPA(  MECA, 'L',1,'OMEGA2',IOROL,0, IAD,K8BID)
       IF (ZR(IAD).LT.0.D0.OR.ABS(ZR(IAD)).LT.R8PREM( )) THEN
         DT = 1.D0 / R8PREM( ) 
       ELSE
         DT = 1.D0 / SQRT(ZR(IAD))
       ENDIF
C       DT = 1.D0 / SQRT(ZR(IAD))
       IF (DT.LT.DTCOU) DTCOU = DT
   21 CONTINUE

      CALL GETVTX('SCHEMA_TEMPS','STOP_CFL',1,1,1,STOCFL,N1)

C     VERIFICATION DE LA CONFORMITE DE LA LISTE D'INSTANTS

      CALL GETVID('INCREMENT','LIST_INST',1,1,1,LISINS,N1)
      CALL JEVEUO(LISINS//'.LPAS','L',JPAS)

      CALL JELIRA(LISINS//'.LPAS','LONMAX',NBDT,K8BID)

      IF (NDYNLO(SDDYNA,'DIFF_CENT')) THEN
        DTCOU =DTCOU/(2.D0)
        CALL U2MESR('I','DYNAMIQUE_7',1,DTCOU)
      ELSE
        IF (NDYNLO(SDDYNA,'TCHAMWA')) THEN
          PHI=NDYNRE(SDDYNA,'PHI')
          DTCOU = DTCOU/(PHI*2.D0)
          CALL U2MESR('I','DYNAMIQUE_8',1,DTCOU)
        ELSE
          CALL U2MESS('F','DYNAMIQUE_1')
        ENDIF
      ENDIF

      DO 20 I=1,NBDT
        IF (ZR(JPAS-1+I).GT.DTCOU) THEN
          IF (STOCFL(1:3).EQ.'OUI') THEN
            CALL U2MESS('F','DYNAMIQUE_2')
          ELSE
            CALL U2MESS('A','DYNAMIQUE_2')
          ENDIF
        ENDIF
 20   CONTINUE

      CALL JEDEMA()

      END
