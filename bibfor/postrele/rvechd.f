      SUBROUTINE RVECHD(DIM,EPSI,SSCH19,NBCP,NBCO,NBSP,ROR,REX,
     +                  MA1,MA2,FOR,FEX,N,PTADR,VAL)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 17/01/97   AUTEUR VABHHTS J.PELLET 
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
C
      CHARACTER*19 SSCH19
      CHARACTER*2  DIM
      INTEGER     MA1(*),MA2(*),FOR(*),FEX(*),N,NBCP,PTADR
      REAL*8      ROR(*),REX(*),VAL(*),EPSI
C
C***********************************************************************
C
C  OPERATION REALISEE
C  ------------------
C
C     OPERATION EXTRACTION DU POST-TRAITEMENT LE LONG D' UN SGT EN UN
C     MORCEAU
C
C  ARGUMENTS EN ENTREE
C  -------------------
C
C     EPSI   : PRECISION
C     DIM    : DIMENSION DU PROBLEME ( '1D' OU '2D' OU '3D')
C     SSCH19 : NOM DELA SD SOUS_CHAMP_GD
C     NBCP   : NOMBRE DE CMP A EXTRAIRE
C     NBCO   : NOMBRE DE COUCHES CONSIDEREES
C     NBSP   : NOMBRE DE SOUS-PT CONSIDEREES
C     ROR    : TABLEAU DE ORIGINE DES SGT ELEMENTAIRES
C     REX    : TABLEAU DES POSITIONS DES EXTREMITES SUR LES FACES
C     FOR    : TABLEAU DES FACES DONNANT LES ORIGINES
C     FEX    : TABLEAU DES FACES DONNANT LES EXTREMITES
C     MA1    : TABLEAU DES 1ERE MAILLES 2D DONNANT LES SGT ELEMENTAIRES
C     MA2    : TABLEAU DES 2IEMEMAILLES 2D DONNANT LES SGT ELEMENTAIRES
C     N      : NBR DE SGTS ELEMENTAIRES A TRAITER
C
C  ARGUMENTS EN SORTIE
C  -------------------
C
C     PTADR : (IN/OUT) POINTEUR SUR LE PREMIER ELEMENT LIBRE DE VAL
C     VAL   : TABLEAU DES VALEUR DE LA CMP (POUR TOUT LE CHAMP)
C
C***********************************************************************
C
C  DECLARATION DES COMMUNS NORMALISES JEVEUX
C  -----------------------------------------
C
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16    ZK16
      CHARACTER*24    ZK24
      CHARACTER*32    ZK32
      CHARACTER*80    ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C  FIN DES COMMUNS NORMALISES JEVEUX
C  ---------------------------------
C
C  VARIABLES LOCALES
C  -----------------
C
      CHARACTER*24 NTABV,NTABF,NTABR
      CHARACTER*8  NMAILA
      CHARACTER*4  DOCU
C
      INTEGER ATABV,ATABF,ATABR,APNCO,APNSP,APNBN
      INTEGER M,F,I,ADR,J,NBPARA,NBPT
C
C==================== CORPS DE LA ROUTINE =============================
C
      CALL JEMARQ()
C
      NTABV = '&&RVECHD.VAL.CMP'
      NTABF = '&&RVECHD.NUM.FACE'
      NTABR = '&&RVECHD.VAL.PAR'
C
      CALL WKVECT(NTABR,'V V R',2,ATABR)
      CALL WKVECT(NTABF,'V V I',2,ATABF)
C
      NBPT = 2
C
      CALL JEVEUO(SSCH19//'.NOMA','L',ADR)
      CALL JELIRA(SSCH19//'.VALE','DOCU',I,DOCU)
C
      NMAILA = ZK8(ADR)
C
      IF ( DIM .EQ. '3D' ) THEN
C
         NBPARA = 2
C
      ELSE
C
         NBPARA = 1
C
      ENDIF
C
      IF ( DOCU .EQ. 'CHNO' ) THEN
C
         DO 100, I = 1, N, 1
C
            M         = MA1(I)
            ZI(ATABF) = FOR(I)
            ZR(ATABR) = ROR(1 + (I-1)*NBPARA)
C
            CALL RVCHLO(EPSI,SSCH19,NBCP,1,1,1,1,M,ZI(ATABF),1,
     +               ZR(ATABR),NBPARA,VAL(PTADR + (I-1)*NBCP))
C
100       CONTINUE
C
         M         = MA1(N)
         ZI(ATABF) = FEX(N)
         ZR(ATABR) = REX(1 + (N-1)*NBPARA)
C
         CALL RVCHLO(EPSI,SSCH19,NBCP,1,1,1,1,M,ZI(ATABF),1,
     +               ZR(ATABR),NBPARA,VAL(PTADR + N*NBCP))
C
         PTADR = PTADR + (N+1)*NBCP
C
      ELSE
C
         CALL JEVEUO(SSCH19//'.PNCO','L',APNCO)
         CALL JEVEUO(SSCH19//'.PNSP','L',APNSP)
         CALL JEVEUO(SSCH19//'.PNBN','L',APNBN)
C
         DO 200, I = 1, N, 1
C
            M               = MA1(I)
            ZI(ATABF + 1-1) = FOR(I)
            ZI(ATABF + 2-1) = FEX(I)
            ZR(ATABR + 1-1) = ROR(I)
            ZR(ATABR + 2-1) = REX(I)
CC          WRITE(IFR,*)'M1 = ',M
CC          WRITE(IFR,*)'FOR= ',FOR(I)
CC          WRITE(IFR,*)'FEX= ',FEX(I)
CC          WRITE(IFR,*)'ROR= ',ROR(I)
CC          WRITE(IFR,*)'REX= ',REX(I)
C
            NBCM = ZI(APNCO + M-1)
            NBSM = ZI(APNSP + M-1)
C
            CALL RVCHLO(EPSI,SSCH19,NBCP,NBCO,NBSP,NBCM,NBSM,M,
     +                  ZI(ATABF),NBPT,ZR(ATABR),NBPARA,VAL(PTADR))
C
            M = MA2(I)
C
            IF ( M .GT. 0 ) THEN
C
               CALL RVFCOM(NMAILA,MA1(I),FOR(I),M,F)
CC          WRITE(IFR,*)'M2 = ',M
CC          WRITE(IFR,*)'F  = ',F
C
C              /* CE BLOCK IF NE MARCHE QUE POUR NBPARA = 1 (2D) */
C
               IF ( F .LT. 0 ) THEN
C
                  F = -F
C
                  ZR(ATABR + 1-1) = 1.0D0 - ROR(I)
                  ZR(ATABR + 2-1) = 1.0D0 - REX(I)
                  ZI(ATABF + 1-1) = F
                  ZI(ATABF + 2-1) = F
C
               ENDIF
C
               F = 2*NBCO*NBSP*NBCP
C
               CALL WKVECT(NTABV,'V V R',F,ATABV)
               CALL RVCHLO(EPSI,SSCH19,NBCP,NBCO,NBSP,NBCM,NBSM,M,
     +                     ZI(ATABF),NBPT,ZR(ATABR),NBPARA,ZR(ATABV))
C
               DO 210, J = 1,2*NBSP*NBCP*NBCO, 1
C
                  VAL(PTADR + J-1) =
     +                       0.5D0*(VAL(PTADR + J-1) + ZR(ATABV + J-1))
C
210            CONTINUE
C
               CALL JEDETR(NTABV)
C
            ENDIF
C
            PTADR = PTADR + 2*NBCP*NBCO*NBSP
C
200      CONTINUE
C
      ENDIF
C
      CALL JEDETR(NTABR)
      CALL JEDETR(NTABF)
C
      CALL JEDEMA()
      END
