      SUBROUTINE IRADHS(VERSIO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 14/10/2008   AUTEUR REZETTE C.REZETTE 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C                BUT: TRAITER LES "ADHERENCES SUPERTAB":
C     OBJETS JEVEUX CREES:
C        &&IRADHS.CODEGRA : TABLEAU D'ENTIERS DIMENSIONNE
C                 AU NOMBRE DE TYPE_MAILLES DONNANT LE CODE GRAPHIQUE
C                 DE CHAQUE TYPE_MAILLE POUR SUPERTAB.
C        &&IRADHS.CODEPHY : TABLEAU D'ENTIERS DIMENSIONNE
C                 AU NOMBRE DE TYPE_ELEM DONNANT LE CODE PHYSIQUE
C                 DE CHAQUE TYPE_ELEMENT POUR SUPERTAB.
C        &&IRADHS.CODEPHD : TABLEAU D'ENTIERS DIMENSIONNE
C                 AU NOMBRE DE TYPE_MAILLE DONNANT LE CODE PHYSIQUE
C                 PAR DEFAUT DE CHAQUE TYPE_MAILLE POUR SUPERTAB.
C        &&IRADHS.PERMUTA : TABLEAU D'ENTIERS DIMENSIONNE
C                 AU NOMBRE DE TYPE_MAILLES*NOMBRE MAXI DE NOEUDS/MAILLE
C                 DONNANT LES PERMUTATIONS EVENTUELLES DANS L'ORDRE DES
C                 NOEUDS DE CHAQUE TYPE_MAILLE, ENTRE ASTER ET SUPERTAB.
C                 LE NOMBRE MAXI DE NOEUDS/MAILLE EST STOCKE AU BOUT DU
C                 VECTEUR
C
C   IN:  VERSIO = VERSION D'IDEAS 4 OU 5(DEFAUT)
C
C---------------- COMMUNS NORMALISES JEVEUX --------------------------
      COMMON/IVARJE/ZI(1)
      COMMON/RVARJE/ZR(1)
      COMMON/CVARJE/ZC(1)
      COMMON/LVARJE/ZL(1)
      COMMON/KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*2  AXDPCP(4)
      CHARACTER*5  PHE(2),MOT
      INTEGER ZI, VERSIO
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8  ZK8,NOMO,NOMA,FORM,NOMMAI
      CHARACTER*16 ZK16,NOMELE
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM,JEXNOM,JEXR8,JEXATR
      CHARACTER*80 ZK80
C
      PARAMETER (MAXNOD=32,NBTYMX=48,MAXFA=6)
      CHARACTER*8 NOMAIL(NBTYMX),NOMTM
      INTEGER LIMAIL(NBTYMX),INDIC(NBTYMX),INDICF(NBTYMX)
      CHARACTER*1 K1BID
C
      DATA AXDPCP/'AX','DP','CP','PL'/
C
      CALL JEMARQ()
      CALL JEEXIN('&&IRADHS.PERMSUP',IRET1)
      CALL JEEXIN('&&IRADHS.PERFSUP',IRET2)
      CALL JEEXIN('&&IRADHS.CODEGRA',IRET3)
      CALL JEEXIN('&&IRADHS.PERMUTA',IRET4)
      CALL JEEXIN('&&IRADHS.CODEPHY',IRET5)
      CALL JEEXIN('&&IRADHS.CODEPHD',IRET6)
      IF (IRET1*IRET2*IRET3*IRET4*IRET5*IRET6.NE.0) GOTO 9999
C
      IF (IRET1.EQ.0) THEN
         CALL WKVECT('&&IRADHS.PERMSUP','V V I',MAXNOD*NBTYMX,JPERSU)
      END IF
      CALL JEVEUO('&&IRADHS.PERMSUP','E',JPERSU)
      IF (IRET2.EQ.0) THEN
         CALL WKVECT('&&IRADHS.PERFSUP','V V I',MAXFA*NBTYMX,JPEFSU)
      END IF
      CALL JEVEUO('&&IRADHS.PERFSUP','E',JPEFSU)
      CALL INISTB(MAXNOD,NBTYMS,NOMAIL,INDIC,ZI(JPERSU),LIMAIL,
     &            INDICF,ZI(JPEFSU),MAXFA)
      CALL JELIRA('&CATA.TM.NOMTM','NOMMAX',NBTYMA,K1BID)
      IF (IRET3.EQ.0) THEN
         CALL JECREO('&&IRADHS.CODEGRA','V V I')
         CALL JEECRA('&&IRADHS.CODEGRA','LONMAX',NBTYMA,' ')
      END IF
      CALL JEVEUO('&&IRADHS.CODEGRA','E',JCOD1)
      DO 1 IMA=1,NBTYMA
         CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',IMA),NOMTM)
         IF ( NOMTM .EQ. 'HEXA27' ) NOMTM = 'HEXA20'
         IF ( NOMTM .EQ. 'TRIA7' ) NOMTM = 'TRIA6'
         IF ( NOMTM .EQ. 'QUAD9' ) NOMTM = 'QUAD8'
         IF ( NOMTM .EQ. 'SEG4' ) NOMTM = 'SEG2'
         DO 2 ISU=1,NBTYMS
            IF (NOMTM.EQ.NOMAIL(ISU)) THEN
               ZI(JCOD1-1+IMA)=ISU
               GO TO 1
            END IF
    2    CONTINUE
    1 CONTINUE
      IF (IRET4.EQ.0) THEN
         CALL WKVECT('&&IRADHS.PERMUTA','V V I',MAXNOD*NBTYMX+1,JPERMU)
         ZI(JPERMU-1+MAXNOD*NBTYMX+1)=MAXNOD
      END IF
      IF (IRET6.EQ.0) THEN
         CALL WKVECT('&&IRADHS.CODEPHD','V V I',NBTYMA,JCODD)
      END IF
      CALL JEVEUO('&&IRADHS.PERMUTA','E',JPERMU)
      CALL JEVEUO('&CATA.TM.NBNO','L',JNBNOE)
      DO 4 IMA=1,NBTYMA
         NBN=ZI(JNBNOE-1+IMA)
         ISU=ZI(JCOD1-1+IMA)
         IF (INDIC(ISU).LT.0) THEN
            DO 41 INO=1,NBN
               ZI(JPERMU-1+MAXNOD*(IMA-1)+INO)=0
   41       CONTINUE
         ELSE IF (INDIC(ISU).EQ.0) THEN
            DO 42 INO=1,NBN
               ZI(JPERMU-1+MAXNOD*(IMA-1)+INO)=INO
   42       CONTINUE
         ELSE IF (INDIC(ISU).GT.0) THEN
            DO 43 INO=1,NBN
               DO 44 INOS=1,NBN
                  IMPER=ZI(JPERSU-1+MAXNOD*(ISU-1)+INOS)
                  IF (INO.EQ.IMPER) THEN
                     ZI(JPERMU-1+MAXNOD*(IMA-1)+INO)=INOS
                     GO TO 43
                  END IF
   44          CONTINUE
   43       CONTINUE
         END IF
         CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',IMA),NOMMAI)
         CALL UTIDEA ( NOMMAI , ZI(JCODD-1+IMA), VERSIO )
    4 CONTINUE
      CALL JELIRA('&CATA.TE.NOMTE','NOMMAX',NBTYEL,K1BID)
      IF (IRET5.EQ.0) THEN
         CALL JECREO('&&IRADHS.CODEPHY','V V I')
         CALL JEECRA('&&IRADHS.CODEPHY','LONMAX',NBTYEL,' ')
         CALL JEVEUO('&CATA.TE.TYPEMA','L',IA1)
      END IF
      CALL JEVEUO('&&IRADHS.CODEPHY','E',JCOD2)
      DO 55 ITEL=1,NBTYEL
         CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITEL),NOMELE)
         CALL UTIDEA ( ZK8(IA1-1+ITEL) , ZI(JCOD2-1+ITEL), VERSIO )
 55   CONTINUE
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDKQU4'),IEL)
      IF (IEL.NE.0) ZI(JCOD2-1+IEL)=94
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDKTR3'),IEL)
      IF (IEL.NE.0) ZI(JCOD2-1+IEL)=91
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDSQU4'),IEL)
      IF (IEL.NE.0) ZI(JCOD2-1+IEL)=94
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEDSTR3'),IEL)
      IF (IEL.NE.0) ZI(JCOD2-1+IEL)=91
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE','MEQ4QU4'),IEL)
      IF (IEL.NE.0) ZI(JCOD2-1+IEL)=94
      PHE(1)='MECA_'
      PHE(2)='THER_'
      DO 3 IPHE=1,2
C
         DO 5 IAX=1,4
            MOT=PHE(IPHE)(1:2)//AXDPCP(IAX)
            CALL JENONU(JEXNOM('&CATA.TE.NOMTE',MOT(1:4)//'QU4'),IEL)
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'AX') ZI(JCOD2-1+IEL)=84
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'CP') ZI(JCOD2-1+IEL)=44
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'DP') ZI(JCOD2-1+IEL)=54
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'PL') ZI(JCOD2-1+IEL)=44
            CALL JENONU(JEXNOM('&CATA.TE.NOMTE',MOT(1:4)//'QU8'),IEL)
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'AX') ZI(JCOD2-1+IEL)=85
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'CP') ZI(JCOD2-1+IEL)=45
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'DP') ZI(JCOD2-1+IEL)=55
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'PL') ZI(JCOD2-1+IEL)=45
            CALL JENONU(JEXNOM('&CATA.TE.NOMTE',MOT(1:4)//'TR3'),IEL)
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'AX') ZI(JCOD2-1+IEL)=81
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'CP') ZI(JCOD2-1+IEL)=41
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'DP') ZI(JCOD2-1+IEL)=51
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'PL') ZI(JCOD2-1+IEL)=41
            CALL JENONU(JEXNOM('&CATA.TE.NOMTE',MOT(1:4)//'TR6'),IEL)
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'AX') ZI(JCOD2-1+IEL)=82
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'CP') ZI(JCOD2-1+IEL)=42
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'DP') ZI(JCOD2-1+IEL)=52
            IF (IEL.NE.0.AND.AXDPCP(IAX).EQ.'PL') ZI(JCOD2-1+IEL)=42
            CALL JENONU(JEXNOM('&CATA.TE.NOMTE',MOT(1:4)//'SE2'),IEL)
            IF (IEL.NE.0) ZI(JCOD2-1+IEL)=21
    5    CONTINUE
    3 CONTINUE
      CALL JEDETR('&&IRADHS.PERMSUP')
      CALL JEDETR('&&IRADHS.PERFSUP')
 9999 CONTINUE
      CALL JEDEMA()
      END
