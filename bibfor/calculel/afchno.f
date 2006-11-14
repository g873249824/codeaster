      SUBROUTINE AFCHNO ( CHAMN, BASE, GRAN, NOMA, NBNOEU, NBCPNO,
     +                    DESC, LONVAL, TYPVAL, RVAL, CVAL, KVAL )
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER           NBCPNO(*), DESC(*)
      REAL*8            RVAL(*)
      COMPLEX*16        CVAL(*)
      CHARACTER*(*)     CHAMN, GRAN, NOMA, BASE, TYPVAL, KVAL(*)
C--------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 14/11/2006   AUTEUR SALMONA L.SALMONA 
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
C--------------------------------------------------------------------
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
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*8  K8B
      CHARACTER*19 CHAMNO
      CHARACTER*1  K1BID
C
      CALL JEMARQ()
      CHAMNO = CHAMN
C
      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',GRAN),NUMGD)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',NUMGD),'LONMAX',NCMPMX,K1BID)
      CALL DISMOI('F','NB_EC',GRAN,'GRANDEUR',NEC,K8B,IE)
C
C     --- CREATION DU CHAMP ---
C
      CALL CRCHNO ( CHAMNO,CHAMNO,GRAN,NOMA,BASE,TYPVAL,NBNOEU,LONVAL)
C
C     --- CONSTRUCTION DU PROF_CHNO ---
C
      CALL CRPRNO ( CHAMNO,BASE,NBNOEU,LONVAL)
C
C     --- AFFECTATION DU .PRNO DE L'OBJET PROF_CHNO ---
C
      CALL JEVEUO(CHAMNO//'.PRNO','E',LPRNO)
      II = 0
      IDEC = 1
      DO 100 INO = 1 , NBNOEU
         ZI(LPRNO-1+ (NEC+2)*(INO-1)+1) = IDEC
         ZI(LPRNO-1+ (NEC+2)*(INO-1)+2) = NBCPNO(INO)
         DO 102 INEC = 1 , NEC
            II = II + 1
            ZI(LPRNO-1+ (NEC+2)*(INO-1)+2+INEC) = DESC(II)
 102     CONTINUE
         IDEC = IDEC + NBCPNO(INO)
 100  CONTINUE
C
C     --- AFFECTATION DU .VALE DE L'OBJET CHAMNO ---
C
      CALL JEVEUO(CHAMNO//'.VALE','E',LVALE)
      CALL JEVEUO(CHAMNO//'.NUEQ','E',LNUEQ)
      DO 110 INO = 1,NBNOEU
         I1 = ZI(LPRNO-1+ (NEC+2)*(INO-1)+1) + LNUEQ - 1
         DO 112 IC = 1 , NCMPMX
            IEC = ( IC - 1 ) / 30  + 1
            JJ = IC -  30 * ( IEC - 1 )
            II = 2**JJ
            NN = IAND( DESC((INO-1)*NEC+IEC) , II )
            IF ( NN .GT. 0 ) THEN
               IF ( TYPVAL(1:1).EQ.'R') THEN
                  ZR(LVALE-1+ZI(I1)) = RVAL((INO-1)*NCMPMX+IC)
               ELSEIF ( TYPVAL(1:1).EQ.'C') THEN
                  ZC(LVALE-1+ZI(I1)) = CVAL((INO-1)*NCMPMX+IC)
               ELSEIF ( TYPVAL(1:2).EQ.'K8') THEN
                  ZK8(LVALE-1+ZI(I1)) = KVAL((INO-1)*NCMPMX+IC)
               ENDIF
               I1 = I1 + 1
            ENDIF
 112     CONTINUE
 110  CONTINUE
C
C     --- AFFECTATION DU .DEEQ DE L'OBJET PROF_CHNO ---
C
      CALL PTEEQU ( CHAMNO, BASE, LONVAL, NUMGD )
C
      CALL JEDEMA()
      END
