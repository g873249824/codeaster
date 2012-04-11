      SUBROUTINE FONVEC ( RESU, NOMA, CNXINV )
      IMPLICIT NONE
      CHARACTER*8         RESU, NOMA
      CHARACTER*19        CNXINV 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/04/2012   AUTEUR LADIER A.LADIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C FONCTION REALISEE:
C
C     VERIFICATION DE LA COHERENCE DES VECTEURS RENSEIGNES DANS 
C     DEFI_FOND_FISS
C
C     ENTREES:
C        RESU       : NOM DU CONCEPT RESULTAT DE L'OPERATEUR
C        NOMA       : NOM DU MAILLAGE
C        CNXINV     : CONNECTIVITE INVERSE
C-----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32     JEXNOM
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       JNORM, JORIG, JEXTR, JVALE
      INTEGER       IAGRN, NUMER
      INTEGER       NDTAEX, NDTAOR, NVENOR
      INTEGER       NVEOR, NVEEX
      REAL*8        XPFI, XPFO, YPFI, YPFO, ZPFI, ZPFO, ZRBID
      REAL*8        DDOT, VALR(6), PS1, PS2, ZERO, R8PREM
      CHARACTER*8   NOMGRP(2)
      CHARACTER*24  GRPNOE, COOVAL
      INTEGER      IARG
C     -----------------------------------------------------------------
C
      CALL JEMARQ()
C
      GRPNOE = NOMA//'.GROUPENO       '
      COOVAL = NOMA//'.COORDO    .VALE'
      CALL JEVEUO ( COOVAL, 'L', JVALE )
C
C     --------------------------------------------------------------
      CALL GETVR8 ('FOND_FISS','DTAN_ORIG',1,IARG,0,ZRBID,NDTAOR)
      IF(NDTAOR.NE.0) THEN
        NDTAOR = -NDTAOR
        CALL WKVECT(RESU//'.DTAN_ORIGINE','G V R8',3,JORIG)
        CALL GETVR8 ('FOND_FISS','DTAN_ORIG',1,IARG,3,ZR(JORIG),NDTAOR)
      ENDIF
C
C     --------------------------------------------------------------
      CALL GETVR8 ('FOND_FISS','DTAN_EXTR',1,IARG,0,ZRBID,NDTAEX)
      IF(NDTAEX.NE.0) THEN
        NDTAEX = -NDTAEX
        CALL WKVECT(RESU//'.DTAN_EXTREMITE','G V R8',3,JEXTR)
        CALL GETVR8 ('FOND_FISS','DTAN_EXTR',1,IARG,3,ZR(JEXTR),NDTAEX)
      ENDIF
C
C     --------------------------------------------------------------
      CALL GETVR8 (' ','NORMALE',1,IARG,0,ZRBID,NVENOR)
      IF(NVENOR.NE.0) THEN
        NVENOR = -NVENOR
        CALL WKVECT(RESU//'.NORMALE','G V R8',3,JNORM)
        CALL GETVR8 (' ','NORMALE',1,IARG,3,ZR(JNORM),NVENOR)
      ELSE
          CALL FONNOR(RESU, NOMA, CNXINV )
      ENDIF
C
C     --------------------------------------------------------------
      CALL GETVEM (NOMA,'GROUP_NO',
     &                'FOND_FISS','VECT_GRNO_ORIG',1,IARG,0,NOMGRP,
     &                NVEOR)
      IF(NVEOR.NE.0) THEN
        NVEOR = -NVEOR
        CALL WKVECT(RESU//'.DTAN_ORIGINE','G V R8',3,JORIG)
        CALL GETVEM (NOMA,'GROUP_NO',
     &              'FOND_FISS','VECT_GRNO_ORIG',1,IARG,2,NOMGRP,NVEOR)
C
        CALL JEVEUO (JEXNOM(GRPNOE,NOMGRP(1)),'L',IAGRN)
        NUMER = ZI(IAGRN)
        XPFO = ZR(JVALE-1+3*(NUMER-1)+1)
        YPFO = ZR(JVALE-1+3*(NUMER-1)+2)
        ZPFO = ZR(JVALE-1+3*(NUMER-1)+3)
C
        CALL JEVEUO (JEXNOM(GRPNOE,NOMGRP(2)),'L',IAGRN)
        NUMER = ZI(IAGRN)
        XPFI = ZR(JVALE-1+3*(NUMER-1)+1)
        YPFI = ZR(JVALE-1+3*(NUMER-1)+2)
        ZPFI = ZR(JVALE-1+3*(NUMER-1)+3)
        ZR(JORIG+0)=XPFI-XPFO
        ZR(JORIG+1)=YPFI-YPFO
        ZR(JORIG+2)=ZPFI-ZPFO
C
      ENDIF
C
C     --------------------------------------------------------------
      CALL GETVEM (NOMA,'GROUP_NO',
     &                'FOND_FISS','VECT_GRNO_EXTR',1,IARG,0,NOMGRP,
     &                NVEEX)
      IF(NVEEX.NE.0) THEN
        NVEEX = -NVEEX
        CALL WKVECT(RESU//'.DTAN_EXTREMITE','G V R8',3,JEXTR)
        CALL GETVEM (NOMA,'GROUP_NO',
     &              'FOND_FISS','VECT_GRNO_EXTR',1,IARG,2,NOMGRP,NVEEX)
C
        CALL JEVEUO (JEXNOM(GRPNOE,NOMGRP(1)),'L',IAGRN)
        NUMER = ZI(IAGRN)
        XPFO = ZR(JVALE-1+3*(NUMER-1)+1)
        YPFO = ZR(JVALE-1+3*(NUMER-1)+2)
        ZPFO = ZR(JVALE-1+3*(NUMER-1)+3)
C
        CALL JEVEUO (JEXNOM(GRPNOE,NOMGRP(2)),'L',IAGRN)
        NUMER = ZI(IAGRN)
        XPFI = ZR(JVALE-1+3*(NUMER-1)+1)
        YPFI = ZR(JVALE-1+3*(NUMER-1)+2)
        ZPFI = ZR(JVALE-1+3*(NUMER-1)+3)
        ZR(JEXTR+0)=XPFI-XPFO
        ZR(JEXTR+1)=YPFI-YPFO
        ZR(JEXTR+2)=ZPFI-ZPFO
C
      ENDIF

C
C VERIFICATION DE L'ORTHOGONALITE DE LA NORMALE AU PLAN DES LEVRES
C  ET DES 2 DIRECTIONS TANGENTES
C
      IF(NVENOR.NE.0.AND.NDTAOR.NE.0.AND.NDTAEX.NE.0) THEN
        CALL JEVEUO(RESU//'.NORMALE','L',JNORM)
        PS1=DDOT(3,ZR(JNORM),1,ZR(JORIG),1)
        PS2=DDOT(3,ZR(JNORM),1,ZR(JEXTR),1)
        ZERO = R8PREM()
        IF(ABS(PS1).GT.ZERO) THEN
           VALR(1) = ZR(JNORM)
           VALR(2) = ZR(JNORM+1)
           VALR(3) = ZR(JNORM+2)
           VALR(4) = ZR(JORIG)
           VALR(5) = ZR(JORIG+1)
           VALR(6) = ZR(JORIG+2)
           CALL U2MESR('F','RUPTURE0_78',6,VALR)
        ENDIF
        IF(ABS(PS2).GT.ZERO) THEN
           VALR(1) = ZR(JNORM)
           VALR(2) = ZR(JNORM+1)
           VALR(3) = ZR(JNORM+2)
           VALR(4) = ZR(JEXTR)
           VALR(5) = ZR(JEXTR+1)
           VALR(6) = ZR(JEXTR+2)
           CALL U2MESR('F','RUPTURE0_79',6,VALR)
        ENDIF
      ENDIF
C

      CALL JEDEMA()
      END
