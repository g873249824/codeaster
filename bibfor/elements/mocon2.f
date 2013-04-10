      SUBROUTINE MOCON2(DIR,SIGB,SIGA,HH,NLIT,OM,RR,NUFSUP,NUFINF,
     &                  NUFSD1,NUFID1,NUFSD2,NUFID2,PREC)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/04/2013   AUTEUR SFAYOLLE S.FAYOLLE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
C TOLE CRS_1404

      INCLUDE 'jeveux.h'

      CHARACTER*8 NUFSUP,NUFINF,NUFSD1,NUFID1,NUFSD2,NUFID2,K8BID
      CHARACTER   DIR
      INTEGER      NLIT
      REAL*8       SIGB,SIGA(NLIT),HH,OM(NLIT),RR(NLIT),PREC,E1,SIGMA
      INTEGER   ORDLU
      PARAMETER (ORDLU=2)
      REAL*8     POLY(ORDLU+1),XX
      INTEGER    I, J, NPT
      INTEGER    ORDOK,JVALE,JFON,JPROL,JTAB,LMAX

C --- POSITIVE BENDING
      CALL JEVEUO(NUFSUP//'           .VALE','L',JTAB)
      CALL JELIRA(NUFSUP//'           .VALE','LONMAX', LMAX, K8BID)

C--- INTERPOLATION DE LA FONCTION ET CALCUL DES DERIVEES
      E1=0.D0
      NPT = LMAX/2
      CALL LSQPOL(ORDLU,E1,NPT,ZR(JTAB),ZR(JTAB+NPT),
     &            ORDOK,POLY,SIGMA)

      CALL WKVECT ( NUFSD1//'           .VALE', 'G V R', 2*NPT, JVALE )
      JFON = JVALE + NPT
      DO 74 I = 0, NPT-1
        XX = ZR(JTAB) + (ZR(JTAB-1+NPT)-ZR(JTAB))*I/(NPT-1)
        ZR(JVALE+I) = XX
        ZR(JFON +I) = 0.0D0
        DO 75, J = 1,ORDOK
          ZR(JFON +I) = ZR(JFON +I) + J*POLY(J+1)*(XX**(J-1))
 75     CONTINUE
 74   CONTINUE

      CALL WKVECT ( NUFSD2//'           .VALE', 'G V R', 2*NPT, JVALE )
      JFON = JVALE + NPT
      DO 76 I = 0, NPT-1
        XX = ZR(JTAB) + (ZR(JTAB-1+NPT)-ZR(JTAB))*I/(NPT-1)
        ZR(JVALE+I) = XX
        ZR(JFON +I) = 0.0D0
        DO 77, J = 2,ORDOK-1
          ZR(JFON +I) = ZR(JFON +I)+ J*(J-1)*POLY(J+1)*(XX**(J-2))
 77     CONTINUE
 76   CONTINUE

C     --- CREATION ET REMPLISSAGE DE L'OBJET NUFSUP.PROL ---
      CALL JEVEUO(NUFSUP//'           .PROL','L',JPROL)
      ZK24(JPROL)   = 'FONCTION                '
      ZK24(JPROL+1) = 'LIN LIN                 '
      ZK24(JPROL+2) = 'X                       '
      ZK24(JPROL+3) = 'FME'//DIR//'1                   '
      ZK24(JPROL+4) = 'LL                      '

      CALL WKVECT ( NUFSD1//'           .PROL', 'G V K24', 6, JPROL )
      ZK24(JPROL)   = 'FONCTION                '
      ZK24(JPROL+1) = 'LIN LIN                 '
      ZK24(JPROL+2) = 'X                       '
      ZK24(JPROL+3) = 'DFME'//DIR//'1                  '
      ZK24(JPROL+4) = 'CC                      '

      CALL WKVECT ( NUFSD2//'           .PROL', 'G V K24', 6, JPROL )
      ZK24(JPROL)   = 'FONCTION                '
      ZK24(JPROL+1) = 'LIN LIN                 '
      ZK24(JPROL+2) = 'X                       '
      ZK24(JPROL+3) = 'DDFME'//DIR//'1                 '
      ZK24(JPROL+4) = 'CC                      '

C--- NEGATIVE BENDING
      CALL JEVEUO(NUFINF//'           .VALE','L',JTAB)
      CALL JELIRA(NUFINF//'           .VALE','LONMAX', LMAX, K8BID)

C--- INTERPOLATION DE LA FONCTION ET CALCUL DES DERIVEES
      E1=0.D0
      NPT = LMAX/2
      CALL LSQPOL(ORDLU,E1,NPT,ZR(JTAB),ZR(JTAB+NPT),
     &            ORDOK,POLY,SIGMA)

      CALL WKVECT ( NUFID1//'           .VALE', 'G V R', 2*NPT, JVALE )
      JFON = JVALE + NPT
      DO 104 I = 0, NPT-1
        XX = ZR(JTAB) + (ZR(JTAB-1+NPT)-ZR(JTAB))*I/(NPT-1)
        ZR(JVALE+I) = XX
        ZR(JFON +I) = 0.0D0
        DO 105, J = 1,ORDOK
          ZR(JFON +I) = ZR(JFON +I) + J*POLY(J+1)*(XX**(J-1))
 105    CONTINUE
 104  CONTINUE

      CALL WKVECT ( NUFID2//'           .VALE', 'G V R', 2*NPT, JVALE )
      JFON = JVALE + NPT
      DO 106 I = 0, NPT-1
        XX = ZR(JTAB) + (ZR(JTAB-1+NPT)-ZR(JTAB))*I/(NPT-1)
        ZR(JVALE+I) = XX
        ZR(JFON +I) = 0.0D0
        DO 107, J = 2,ORDOK-1
          ZR(JFON +I) = ZR(JFON +I)+ J*(J-1)*POLY(J+1)*(XX**(J-2))
 107    CONTINUE
 106  CONTINUE

C     --- CREATION ET REMPLISSAGE DE L'OBJET NUFSUP.PROL ---
      CALL JEVEUO(NUFINF//'           .PROL','L',JPROL)
      ZK24(JPROL)   = 'FONCTION                '
      ZK24(JPROL+1) = 'LIN LIN                 '
      ZK24(JPROL+2) = 'X                       '
      ZK24(JPROL+3) = 'FME'//DIR//'2                   '
      ZK24(JPROL+4) = 'LL                      '

      CALL WKVECT ( NUFID1//'           .PROL', 'G V K24', 6, JPROL )
      ZK24(JPROL)   = 'FONCTION                '
      ZK24(JPROL+1) = 'LIN LIN                 '
      ZK24(JPROL+2) = 'X                       '
      ZK24(JPROL+3) = 'DFME'//DIR//'2                  '
      ZK24(JPROL+4) = 'CC                      '

      CALL WKVECT ( NUFID2//'           .PROL', 'G V K24', 6, JPROL )
      ZK24(JPROL)   = 'FONCTION                '
      ZK24(JPROL+1) = 'LIN LIN                 '
      ZK24(JPROL+2) = 'X                       '
      ZK24(JPROL+3) = 'DDFME'//DIR//'2                 '
      ZK24(JPROL+4) = 'CC                      '

      END
