      SUBROUTINE RVECHM(SSCH19,SDLIEU,SDEVAL)
      IMPLICIT REAL*8 (A-H,O-Z)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 19/06/2007   AUTEUR PELLET J.PELLET 
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
      CHARACTER*19 SSCH19,SDLIEU,SDEVAL
C
C**********************************************************************
C
C  OPERATION REALISEE
C  ------------------
C     OPERATION D' EXTRACTION DU POST-TRAITEMENT D' UNE COURBE OBTENUE
C     COMME REUNION FINIE DE MAILLES 1D
C
C  ARGUMENT EN ENTREE
C  ------------------
C
C     SSCH19 : NOM DU SOUS CHAMP DE GRANDEUR
C
C     SDLIEU : NOM DE LA SD REPRESENTANT LE LIEU
C
C
C  ARGUMENT EN SORTIE
C  ------------------
C
C     SDEVAL: NOM DE LA SD SOUS_CHAMP_GD PRODUITES
C            (DESCRIPTION : CF RVPSTE)
C
C**********************************************************************
C
C
C  FONCTIONS EXTERNES
C  ------------------
C
      CHARACTER*32 JEXNOM,JEXNUM
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
      CHARACTER*24 INVALE,INPADR,INPCMP,INNOMA,INNUGD,INPNCO,INPNSP
      CHARACTER*24 OUVALE,OUPADR,OUPCMP,OUERRE,OUNOMA,OUPNBN,OUNUGD
      CHARACTER*24 NREFE,NABSC,NDESC,NNUME,NTAB1,NNUMND,OUPNCO,OUPNSP
      CHARACTER*15 NCHMIN
      CHARACTER*14 NMAIL1,NMAIL2
      CHARACTER*8  MAILLA,TYPMAI,COURBE
      CHARACTER*4  DOCU
C
      INTEGER AIVALE,AIPADR,AIPCMP,IOCER,J,NBTCMP,ADRNL,AOPNCO,AOPNSP
      INTEGER AOPNBN,AOVALE,AOPADR,AOPCMP,AOERRE,ML,LONG,AIPNCO,AIPNSP
      INTEGER AREFE,ADESC,NBCMP,ANUME,ADRM,ADRND,I,IBID,INL
      INTEGER AMAIL1,AMAIL2,ACHMIN,ADRIN,ADROU,ISD,ANUMND,ATYPM,ATAB1
      INTEGER M2D,M2D1,M2D2,NBADR,NBMPST,NBNPST,NBOCER,ND,N1
      INTEGER PTADR,IATYMA
      CHARACTER*1 K1BID
C
C==================== CORPS DE LA ROUTINE =============================
C
      CALL JEMARQ()
C
      NTAB1   = '&&RVECHM.TABLE.CONTRI.M2'
      NNUMND  = '&&RCECHM.NUM.NOEUD.LISTE'
      INVALE  = SSCH19//'.VALE'
      INPADR  = SSCH19//'.PADR'
      INPCMP  = SSCH19//'.PCMP'
      INPNCO  = SSCH19//'.PNCO'
      INPNSP  = SSCH19//'.PNSP'
      INNOMA  = SSCH19//'.NOMA'
      INNUGD  = SSCH19//'.NUGD'
      OUVALE  = SDEVAL//'.VALE'
      OUPNBN  = SDEVAL//'.PNBN'
      OUPNCO  = SDEVAL//'.PNCO'
      OUPNSP  = SDEVAL//'.PNSP'
      OUPADR  = SDEVAL//'.PADR'
      OUPCMP  = SDEVAL//'.PCMP'
      OUNOMA  = SDEVAL//'.NOMA'
      OUNUGD  = SDEVAL//'.NUGD'
      OUERRE  = SDEVAL//'.ERRE'
C
C
      NABSC = SDLIEU//'.ABSC'
      NREFE = SDLIEU//'.REFE'
      NDESC = SDLIEU//'.DESC'
      NNUME = SDLIEU//'.NUME'
C
      CALL JELIRA(INVALE,'DOCU',IBID,DOCU)
      CALL JEVEUO(NREFE,'L',AREFE)
      CALL JEVEUO(NDESC,'L',ADESC)
      CALL JEVEUO(NNUME,'L',ANUME)
C
      ISD = ZI(ANUME)
C
      CALL JELIRA(JEXNUM(NABSC,1),'LONMAX',NBNPST,K1BID)
C
      NBMPST = NBNPST - 1
C
      CALL JEVEUO(INPCMP,'L',AIPCMP)
      CALL JELIRA(INPCMP,'LONMAX',NBTCMP,K1BID)
      CALL WKVECT(OUPCMP,'V V I',NBTCMP,AOPCMP)
C
      NBCMP = 0
C
      DO 20, I = 1, NBTCMP, 1
C
         NBCMP = NBCMP + MIN(1,ZI(AIPCMP + I-1))
C
         ZI(AOPCMP + I-1) = ZI(AIPCMP + I-1)
C
20    CONTINUE
C
      CALL WKVECT(OUNOMA,'V V K8',1,ADROU)
      CALL JEVEUO(INNOMA,'L',ADRIN)
C
      MAILLA     = ZK8(ADRIN)
      ZK8(ADROU) = MAILLA
C
      CALL WKVECT(OUNUGD,'V V I',1,ADROU)
      CALL JEVEUO(INNUGD,'L',ADRIN)
C
      ZI(ADROU) = ZI(ADRIN)
C
      COURBE = ZK8(AREFE)
C
      NMAIL1 = COURBE//'.MAIL1'
      NMAIL2 = COURBE//'.MAIL2'
      NCHMIN = COURBE//'.CHEMIN'
C
      CALL JEVEUO(JEXNUM(NMAIL1,ISD),'L',AMAIL1)
      CALL JELIRA(JEXNUM(NMAIL1,ISD),'LONMAX',N1,K1BID)
      CALL JEVEUO(JEXNUM(NMAIL2,ISD),'L',AMAIL2)
      CALL JEVEUO(JEXNUM(NCHMIN,ISD),'L',ACHMIN)
C
      IF ( DOCU.EQ. 'CHLM' ) THEN
C
         CALL WKVECT(OUPNBN,'V V I',NBMPST,AOPNBN)
         CALL WKVECT(OUPNCO,'V V I',NBMPST,AOPNCO)
         CALL WKVECT(OUPNSP,'V V I',NBMPST,AOPNSP)
         CALL JEVEUO(INPNCO,'L',AIPNCO)
         CALL JEVEUO(INPNSP,'L',AIPNSP)
C
         NBSP = 1000
         NBCO = 1000
C
         DO 40, I = 1, N1-1, 1
C
            M2D1 = ZI(AMAIL1 + I-1)
            M2D2 = ZI(AMAIL2 + I-1)
            NBCO = MIN(ZI(AIPNCO + M2D1-1),NBCO)
            NBSP = MIN(ZI(AIPNSP + M2D1-1),NBSP)
C
            IF ( M2D2 .NE. 0 ) THEN
C
               NBCO = MIN(ZI(AIPNCO + M2D2-1),NBCO)
               NBSP = MIN(ZI(AIPNSP + M2D2-1),NBSP)
C
            ENDIF
C
40       CONTINUE
C
         DO 41, I = 1, NBMPST, 1
C
            ZI(AOPNBN + I-1) = 2
            ZI(AOPNCO + I-1) = NBCO
            ZI(AOPNSP + I-1) = NBSP
C
41       CONTINUE
C
         LONG   =  2*NBCMP*NBSP*NBCO
         NBADR  =  NBMPST
         NBOCER =  NBMPST
C
      ELSE
C
         LONG   =  NBCMP
         NBADR  =  NBNPST
         NBOCER =  NBNPST
C
      ENDIF
C
      CALL JECREC(OUERRE,'V V I','NU','DISPERSE','VARIABLE',NBOCER)
C
      DO 30, IOCER = 1, NBOCER, 1
C
         CALL JECROC(JEXNUM(OUERRE,IOCER))
         CALL JEECRA(JEXNUM(OUERRE,IOCER),'LONMAX',NBCMP,' ')
         CALL JEVEUO(JEXNUM(OUERRE,IOCER),'E',AOERRE)
C
         DO 31, I = 1, NBCMP, 1
C
            ZI(AOERRE + I-1) = 0
C
31       CONTINUE
C
30    CONTINUE
C
      CALL WKVECT(OUVALE,'V V R',LONG*NBADR,AOVALE)
      CALL WKVECT(OUPADR,'V V I',NBADR,AOPADR)
C
      ZI(AOPADR + 1-1) = 1
C
      DO 60, I = 1, NBADR-1, 1
C
         ZI(AOPADR + I+1-1) = ZI(AOPADR + I-1) + LONG
C
60    CONTINUE
C
C
      CALL JEVEUO(INPADR,'L',AIPADR)
      CALL JEVEUO(INVALE,'L',AIVALE)
C
      IF ( DOCU .EQ. 'CHNO' ) THEN
C
         DO 100, INL = 1, NBNPST, 1
C
            CALL JENONU(JEXNOM(MAILLA//'.NOMNOE',ZK8(ADESC+INL-1)),ND)
C
            ADRND = ZI(AIPADR +  ND-1)
            ADRNL = ZI(AOPADR + INL-1)
C
            DO 110, J = 1, NBCMP, 1
C
               ZR(AOVALE + ADRNL-1 + J-1) = ZR(AIVALE + ADRND-1 + J-1)
C
110         CONTINUE
C
100      CONTINUE
C
         CALL JEECRA(OUVALE,'DOCU',IBID,'CHNO')
C
      ELSE IF ( DOCU .EQ. 'CHLM' ) THEN
C
         ML  = 1
         M2D = 1
C
         CALL WKVECT(NNUMND,'V V I',NBNPST ,ANUMND)
         CALL WKVECT(NTAB1 ,'V V R',3*NBCMP*NBCO*NBSP,ATAB1 )
C
         DO 200, I = 1, NBNPST, 1
C
            CALL JENONU(JEXNOM(MAILLA//'.NOMNOE',ZK8(ADESC + I-1)),
     +                  ZI(ANUMND + I-1))
C
200      CONTINUE
C
         LONG = LONG/2
C
300      CONTINUE
         IF ( ML .LT. NBNPST ) THEN
C
            M2D1 = ZI(AMAIL1 + M2D-1)
            M2D2 = ZI(AMAIL2 + M2D-1)
            ADRM = ZI(AOPADR + ML-1)
C
C
            CALL JEVEUO(MAILLA//'.TYPMAIL','L',IATYMA)
            ATYPM=IATYMA-1+M2D1
            CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(ATYPM)),TYPMAI)
C
            CALL RVCHLM(SSCH19,M2D1,ZI(ANUMND + ML-1),2,NBCMP,NBCO,NBSP,
     +                  ZR(AOVALE + ADRM-1))
C
            IF ( M2D2 .GT. 0 ) THEN
C
               CALL RVCHLM(SSCH19,M2D2,ZI(ANUMND + ML-1),2,NBCMP,NBCO,
     +                     NBSP,ZR(ATAB1))
C
               DO 310, J = 1, 2*LONG, 1
C
                  IF( ZR(ATAB1 + J-1).EQ.R8VIDE() ) GOTO 310
                  ZR(AOVALE+ADRM-1+J-1) = 0.5D0*(ZR(AOVALE+ADRM-1+J-1)+
     +                                           ZR(ATAB1 + J-1))

C
310            CONTINUE
C
C
            ENDIF
C
            ML   = ML + 1
            ADRM = ZI(AOPADR + ML-1)
C
            IF ( (TYPMAI .EQ. 'TRIA6').OR.(TYPMAI .EQ. 'QUAD8').OR.
     +           (TYPMAI .EQ. 'QUAD9') ) THEN
C
               DO 311, J = 1, LONG, 1
C
                  ZR(AOVALE+ADRM-1+J-1) = ZR(AOVALE+ADRM-1-LONG +J-1)
C
311            CONTINUE
C
C
               CALL RVCHLM(SSCH19,M2D1,ZI(ANUMND + ML+1-1),1,NBCMP,
     +                     NBCO,NBSP,ZR(AOVALE + ADRM-1 + LONG))
C
C
               IF ( M2D2 .GT. 0 ) THEN
C
                  CALL RVCHLM(SSCH19,M2D2,ZI(ANUMND + ML+1-1),1,NBCMP,
     +                        NBCO,NBSP,ZR(ATAB1))
C
C
                  DO 320, J = 1, LONG, 1
C
                     IF( ZR(ATAB1 + J-1).EQ.R8VIDE() ) GOTO 320
                     ZR(AOVALE+ADRM+LONG-1+J-1) = 0.5D0*
     +                                 (ZR(AOVALE+ADRM+LONG-1+J-1)+
     +                                           ZR(ATAB1 + J-1))

C
320               CONTINUE
C
C
               ENDIF
C
               ML = ML + 1
C
            ENDIF
C
            M2D = M2D + 1
C
C
            GOTO 300
C
         ENDIF
C
         CALL JEECRA(OUVALE,'DOCU',IBID,'CHLM')
C
         CALL JEDETR(NTAB1)
         CALL JEDETR(NNUMND)
C
      ELSE
C
C       /* AUTRE TYPE DE CHAMPS */
C
      ENDIF
C
      CALL JEDEMA()
      END
