      SUBROUTINE INIGRL(LIGREL,IGREL,NMAX,ADTABL,K24TAB,NVAL)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/10/2002   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE                            VABHHTS J.PELLET
C TOLE CRP_20
C TOLE CRS_513
C     ARGUMENTS:
C     ----------
      CHARACTER*(*) LIGREL
      INTEGER IGREL,NMAX,ADTABL(NMAX),NVAL
      CHARACTER*24 K24TAB(NMAX)
C ----------------------------------------------------------------------
C     BUT:
C     INITIALISER LE TYPE_ELEMENT ASSOCIE AU GREL  (INI00K)

C     IN:
C      LIGREL : NOM DU LIGREL A INITIALISER
C      IGREL  : NUMERO DU GREL
C      NMAX   : DIMENSION DE K24TAB ET ADTABL

C     OUT:
C         CREATION DES OBJETS JEVEUX PROPRES AU
C             TYPE_ELEMENT PRESENTS DANS LE LIGREL(IGREL).

C         NVAL  : NOMBRE DE NOMS RENDUS DANS K24TAB
C         K24TAB: TABLEAU DES NOMS DES OBJETS '&INEL.XXXX'
C         ADTABL : TABLEAU D'ADRESSES DES '&INEL.XXXXX'
C         ADTABL(I) = 0 SI L'OBJET CORRESPONDANT N'EXISTE PAS
C         SI NVAL > NMAX  : ON  S'ARRETE EN ERREUR FATALE

C ----------------------------------------------------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8,NOMNUM
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM
      CHARACTER*80 ZK80
      CHARACTER*1 K1BID
      CHARACTER*24 NOLIEL
      CHARACTER*16 NOMTE
      INTEGER LIEL,L,TE,NUMINI,NUM,K



      NOLIEL = LIGREL(1:19)//'.LIEL'
      CALL JEVEUO(JEXNUM(NOLIEL,IGREL),'L',LIEL)
      CALL JELIRA(JEXNUM(NOLIEL,IGREL),'LONMAX',L,K1BID)
      TE = ZI(LIEL-1+L)
      CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)
      CALL JEVEUO('&CATA.TE.NUMINIT','L',NUMINI)
      NUM = ZI(NUMINI-1+TE)

C     -- ON MET LES ADRESSES A ZERO :
      DO 10,K = 1,NMAX
        K24TAB(K) = ' '
        ADTABL(K) = 0
   10 CONTINUE

      GO TO (20,30,40,50,60,70,80,90,100,
     &       110,120,130,140,150,160,170,180,190,
     &       200,210,220,230,240,250,260,270,280,
     &       290,300,310,320,330,340,350,360,370,
     &       380,390,400,410,420,430,440,450,460,
     &       470,480,490,500,510,520,530,540,550,
     &       560,570,580,590,600,610,620,630,640,
     &       650,660,670,680,690,700,710,720,730,
     &       740,750,760,770,780,790,800,810,820,
     &       830,840,850,860,870,880,890,900,910,
     &       920,930,940,950,960,970,980,990,1000,
     &       1010) NUM
      GO TO 1020
   20 CONTINUE
      CALL INI001(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
   30 CONTINUE
      CALL INI002(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
   40 CONTINUE
      CALL INI003(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
   50 CONTINUE
      CALL INI004(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
   60 CONTINUE
      CALL INI005(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
   70 CONTINUE
      CALL INI006(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
   80 CONTINUE
      CALL INI007(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
   90 CONTINUE
      CALL INI008(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  100 CONTINUE
      CALL INI009(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  110 CONTINUE
      CALL INI010(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  120 CONTINUE
      CALL INI011(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  130 CONTINUE
      CALL INI012(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  140 CONTINUE
      CALL INI013(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  150 CONTINUE
      CALL INI014(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  160 CONTINUE
      CALL INI015(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  170 CONTINUE
      CALL INI016(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  180 CONTINUE
      CALL INI017(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  190 CONTINUE
      CALL INI018(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  200 CONTINUE
      CALL INI019(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  210 CONTINUE
      CALL INI020(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  220 CONTINUE
      CALL INI021(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  230 CONTINUE
      CALL INI022(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  240 CONTINUE
      CALL INI023(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  250 CONTINUE
      CALL INI024(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  260 CONTINUE
      CALL INI025(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  270 CONTINUE
      CALL INI026(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  280 CONTINUE
      CALL INI027(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  290 CONTINUE
      CALL INI028(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  300 CONTINUE
      CALL INI029(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  310 CONTINUE
      CALL INI030(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  320 CONTINUE
      CALL INI031(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  330 CONTINUE
      CALL INI032(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  340 CONTINUE
      CALL INI033(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  350 CONTINUE
      CALL INI034(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  360 CONTINUE
      CALL INI035(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  370 CONTINUE
      CALL INI036(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  380 CONTINUE
      CALL INI037(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  390 CONTINUE
      CALL INI038(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  400 CONTINUE
      CALL INI039(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  410 CONTINUE
      CALL INI040(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  420 CONTINUE
      CALL INI041(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  430 CONTINUE
      CALL INI042(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  440 CONTINUE
      CALL INI043(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  450 CONTINUE
      CALL INI044(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  460 CONTINUE
      CALL INI045(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  470 CONTINUE
      CALL INI046(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  480 CONTINUE
      CALL INI047(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  490 CONTINUE
      CALL INI048(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  500 CONTINUE
      CALL INI049(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  510 CONTINUE
      CALL INI050(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  520 CONTINUE
      CALL INI051(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  530 CONTINUE
      CALL INI052(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  540 CONTINUE
      CALL INI053(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  550 CONTINUE
      CALL INI054(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  560 CONTINUE
      CALL INI055(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  570 CONTINUE
      CALL INI056(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  580 CONTINUE
      CALL INI057(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  590 CONTINUE
      CALL INI058(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  600 CONTINUE
      CALL INI059(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  610 CONTINUE
      CALL INI060(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  620 CONTINUE
      CALL INI061(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  630 CONTINUE
      CALL INI062(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  640 CONTINUE
      CALL INI063(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  650 CONTINUE
      CALL INI064(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  660 CONTINUE
      CALL INI065(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  670 CONTINUE
      CALL INI066(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  680 CONTINUE
      CALL INI067(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  690 CONTINUE
      CALL INI068(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  700 CONTINUE
      CALL INI069(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  710 CONTINUE
      CALL INI070(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  720 CONTINUE
      CALL INI071(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  730 CONTINUE
      CALL INI072(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  740 CONTINUE
      CALL INI073(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  750 CONTINUE
      CALL INI074(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  760 CONTINUE
      CALL INI075(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  770 CONTINUE
      CALL INI076(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  780 CONTINUE
      CALL INI077(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  790 CONTINUE
      CALL INI078(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  800 CONTINUE
      CALL INI079(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  810 CONTINUE
      CALL INI080(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  820 CONTINUE
      CALL INI081(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  830 CONTINUE
      CALL INI082(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  840 CONTINUE
      CALL INI083(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  850 CONTINUE
      CALL INI084(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  860 CONTINUE
      CALL INI085(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  870 CONTINUE
      CALL INI086(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  880 CONTINUE
      CALL INI087(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  890 CONTINUE
      CALL INI088(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  900 CONTINUE
      CALL INI089(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  910 CONTINUE
      CALL INI090(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  920 CONTINUE
      CALL INI091(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  930 CONTINUE
      CALL INI092(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  940 CONTINUE
      CALL INI093(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  950 CONTINUE
      CALL INI094(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  960 CONTINUE
      CALL INI095(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  970 CONTINUE
      CALL INI096(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  980 CONTINUE
      CALL INI097(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
  990 CONTINUE
      CALL INI098(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
 1000 CONTINUE
      CALL INI099(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
 1010 CONTINUE
      CALL INI100(NOMTE,' ',NMAX,ADTABL,K24TAB,NVAL)
      GO TO 1030
 1020 CONTINUE
      CALL CODENT(NUM,'D',NOMNUM)
      CALL UTMESS('F','INIGRL',' ON NE TROUVE PAS DE ROUTINE ININPQ'//
     &            ' NPQ DOIT ETRE COMPRIS ENTRE 1 ET 100'//
     &            ' ICI : NPQ ='//NOMNUM)

 1030 CONTINUE


 1040 CONTINUE
      END
