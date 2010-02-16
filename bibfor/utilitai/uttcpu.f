      SUBROUTINE UTTCPU (NOMMES,ACTION,NOMLON)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 16/02/2010   AUTEUR PELLET J.PELLET 
C RESPONSABLE PELLET J.PELLET
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
      CHARACTER *(*)  NOMMES,ACTION,NOMLON
C ----------------------------------------------------------------------
C  ROUTINE DE MESURE DU TEMPS CPU.
C
C IN  NOMMES (K24)   : NOM (COURT) IDENTIFIANT LA MESURE
C
C IN  ACTION :  ACTION = 'INIT'  LA MESURE DE TEMPS EST (RE)MIS A ZERO
C               ACTION = 'DEBUT' LA MESURE DE TEMPS COMMENCE
C               ACTION = 'FIN'   LA MESURE DE TEMPS S'ARRETE
C IN  NOMLON (K80)   : NOM (LONG) ASSOCIE A LA MESURE (OU ' ').
C              CE NOM EST STOCKE POUR ACTION='INIT'
C              CE NOM SERA EVENTUELLENT IMPRIME PAR UTTCPI
C ----------------------------------------------------------------------
C ON ACCUMULE 7 VALEURS MESUREES POUR CHAQUE MESURE (NOMMES) :
C    TEMPS(1) TEMPS CPU RESTANT EN SECONDES
C    TEMPS(2) NOMBRE D'APPEL A DEBUT/FIN
C    TEMPS(3) TEMPS CPU TOTAL
C    TEMPS(4) TEMPS CPU MOYEN
C    TEMPS(5) TEMPS CPU USER TOTAL
C    TEMPS(6) TEMPS CPU SYSTEME
C    TEMPS(7) TEMPS ELAPSED
C LES VALEURS STOCKEES SONT RECUPERABLES VIA UTTCPR
C ----------------------------------------------------------------------
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
      CHARACTER*32 ZK32,JEXNOM
      CHARACTER*80 ZK80
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER INDI ,IEXI,IBID,JVALMS,JNOML,JVALMI,K
      CHARACTER*8 KBID

C     -- COMMONS POUR MESURE DE TEMPS :
      INTEGER  MTPNIV ,INDMAX
      PARAMETER (INDMAX=5)
      CHARACTER*80 SNOLON(INDMAX)
      REAL*8 VALMES(INDMAX*7),VALMEI(INDMAX*7)
      COMMON /MESTP1/  MTPNIV
      COMMON /MESTP2/ SNOLON
      COMMON /MESTP3/ VALMES,VALMEI
C ----------------------------------------------------------------------

C     -- POUR CERTAINES MESURES, ON NE PEUT PAS FAIRE DE JEVEUX :
C        ON GARDE ALORS LES INFOS DANS LES COMMON MESTPX
      IF (NOMMES.EQ.'CPU.MEMD.1') THEN
         INDI=1
      ELSEIF (NOMMES.EQ.'CPU.MEMD.2') THEN
         INDI=2
      ELSE
         GOTO 9998
      ENDIF
      CALL ASSERT(INDI.LE.INDMAX)

      IF (ACTION.EQ.'INIT') THEN
        SNOLON(INDI)=NOMLON
C       -- IL FAUT REMETTRE LES COMMON A ZERO :
        DO 3, K=1,7
          VALMES(K)=0.D0
          VALMEI(K)=0.D0
 3      CONTINUE
      ENDIF

      CALL UTTCP0(INDI,ACTION,7,VALMES(7*(INDI-1)+1))
      GOTO 9999



 9998 CONTINUE
C     -- INITIALISATION DES OBJETS JEVEUX :
      CALL JEEXIN('&&UTTCPU.NOMMES',IEXI)
      IF (IEXI.EQ.0) THEN
        CALL JECREO('&&UTTCPU.NOMMES','V N K24')
        CALL JEECRA('&&UTTCPU.NOMMES','NOMMAX',100,KBID)
        CALL WKVECT('&&UTTCPU.VALMES','V V R',7*100,JVALMS)
        CALL WKVECT('&&UTTCPU.VALMEI','V V R',7*100,JVALMI)
        CALL WKVECT('&&UTTCPU.NOMLON','V V K80',100,JNOML)
      ELSE
        CALL JEVEUO('&&UTTCPU.VALMES','E',JVALMS)
      ENDIF

      CALL JENONU(JEXNOM('&&UTTCPU.NOMMES',NOMMES),INDI)
      IF (INDI.EQ.0) THEN
        IF (ACTION.EQ.'INIT') THEN
          CALL JECROC(JEXNOM('&&UTTCPU.NOMMES',NOMMES))
          CALL JENONU(JEXNOM('&&UTTCPU.NOMMES',NOMMES),INDI)
          CALL ASSERT(INDI.GT.0)
          CALL ASSERT(INDI.LT.100)
          CALL JEVEUO('&&UTTCPU.NOMLON','E',JNOML)
          ZK80(JNOML-1+INDI)=NOMLON
        ELSE
C         -- LA MESURE N'A PAS ETE INITIALISEE: ON NE LA FAIT PAS
          GOTO 9999
        ENDIF
      ENDIF

      CALL UTTCP0(100+INDI,ACTION,7,ZR(JVALMS-1+7*(INDI-1)+1))

9999  CONTINUE
      END
