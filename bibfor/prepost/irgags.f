      SUBROUTINE IRGAGS(NCMPMX,NOMCMP,NOMSYM,NBCHS,NOMCHS,NBCMPS,NOMGDS
     +                        ,IPCMPS)
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INTEGER           NCMPMX,       NBCHS,   NBCMPS(*),IPCMPS(*)
      CHARACTER*(*)            NOMCMP(*),NOMSYM,NOMCHS(*),NOMGDS(*)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 21/05/2007   AUTEUR FERNANDES R.FERNANDES 
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
C TOLE CRP_20
C--------------------------------------------------------------------
C       RECHERCHE DES GRANDEURS SUPERTAB PRESENTENT DANS UNE GRANDEUR
C       ASTER
C      ENTREE:
C         NCMPMX: NOMBRE MAXI DE CMP DE LA GRANDEUR NOMGD
C         NOMCMP: NOMS DES CMP
C         NOMSYM: NOM SYMBOLIQUE
C      SORTIE:
C         NBCHS : NOMBRE DE GRANDEURS SUPERTAB
C         NOMCHS: NOM DE L'INFORMATION SUPERTAB
C         NBCMPS: NOMBRE DE COMPOSANTES DE CHAQUE GRANDEUR SUPERTAB
C         NOMGDS: NOM DES GRANDEURS SUPERTAB
C         IPCMPS: POSITION DES COMPOSANTES SUPERTAB DANS LA COMPOSANTE
C                 ASTER
C
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL,EXISTE,EXISDG
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNUM,JEXNOM
      CHARACTER*80 ZK80
C     ------------------------------------------------------------------
      INTEGER     NBDEPL,NBTEMP,NBTEMI,NBTEMS,NBVARI
      INTEGER     NBSIGM,NBSIGI,NBSIGS,NBPRES,NBEPSM,NBEPSI,NBEPSS
      INTEGER     NBPRE1,NBPRE2
      INTEGER     NBFLU,NBFLUI,NBFLUS
      INTEGER     NBFH11,NBFH12,NBFH21,NBFH22,NBFHT,NBSIP
C
      CALL WKVECT('&&IRGAGS.IDEPL','V V I',6,IDEPL)
      CALL WKVECT('&&IRGAGS.ITEMP','V V I',1,ITEMP)
      CALL WKVECT('&&IRGAGS.ITEMI','V V I',1,ITEMI)
      CALL WKVECT('&&IRGAGS.ITEMS','V V I',1,ITEMS)
      CALL WKVECT('&&IRGAGS.IPRES','V V I',1,IPRES)
      CALL WKVECT('&&IRGAGS.IPRE1','V V I',1,IPRE1)
      CALL WKVECT('&&IRGAGS.IPRE2','V V I',1,IPRE2)
      CALL WKVECT('&&IRGAGS.ISIP','V V I',1,ISIP)
      CALL WKVECT('&&IRGAGS.ISIGM','V V I',6,ISIGM)
      CALL WKVECT('&&IRGAGS.ISIGS','V V I',6,ISIGS)
      CALL WKVECT('&&IRGAGS.ISIGI','V V I',6,ISIGI)
      CALL WKVECT('&&IRGAGS.IEPSI','V V I',6,IEPSI)
      CALL WKVECT('&&IRGAGS.IEPSM','V V I',6,IEPSM)
      CALL WKVECT('&&IRGAGS.IEPSS','V V I',6,IEPSS)
      CALL WKVECT('&&IRGAGS.IFLU','V V I',3,IFLU )
      CALL WKVECT('&&IRGAGS.IFLUI','V V I',3,IFLUI)
      CALL WKVECT('&&IRGAGS.IFLUS','V V I',3,IFLUS)
      CALL WKVECT('&&IRGAGS.IFH11','V V I',3,IFH11)
      CALL WKVECT('&&IRGAGS.IFH12','V V I',3,IFH12)
      CALL WKVECT('&&IRGAGS.IFH21','V V I',3,IFH21)
      CALL WKVECT('&&IRGAGS.IFH22','V V I',3,IFH22)
      CALL WKVECT('&&IRGAGS.IFHT','V V I',3,IFHT)
      CALL WKVECT('&&IRGAGS.IVARI','V V I',NCMPMX,IVARI)
C
C  --- INITIALISATIONS ----
C
      NBDEPL = 0
      NBFLU  = 0
      NBFLUI = 0
      NBFLUS = 0
      NBFH11 = 0
      NBFH12 = 0
      NBFH21 = 0
      NBFH22 = 0
      NBFHT  = 0
      NBTEMP = 0
      NBTEMI = 0
      NBTEMS = 0
      NBPRES = 0
      NBPRE1 = 0
      NBPRE2 = 0
      NBSIP  = 0
      NBSIGM = 0
      NBSIGI = 0
      NBSIGS = 0
      NBEPSM = 0
      NBEPSI = 0
      NBEPSS = 0
      NBVARI = 0
      IVA    = 0
      NBCHS = 0
C
C  --- RECHERCHE DES GRANDEURS SUPERTAB ASSOCIEES A LA GRANDEUR ASTER---
C
      DO 1 ICMAS=1,NCMPMX
       IF (NOMCMP(ICMAS).EQ.'DX') THEN
          NBDEPL= NBDEPL+1
          ZI(IDEPL-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'DY') THEN
          NBDEPL= NBDEPL+1
          ZI(IDEPL-1+2)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'DZ') THEN
          NBDEPL= NBDEPL+1
          ZI(IDEPL-1+3)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'DRX') THEN
          NBDEPL= NBDEPL+1
          ZI(IDEPL-1+4)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'DRY') THEN
          NBDEPL= NBDEPL+1
          ZI(IDEPL-1+5)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'DRZ') THEN
          NBDEPL= NBDEPL+1
          ZI(IDEPL-1+6)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FLUXI') THEN
          NBFLUI= NBFLUI+1
          ZI(IFLUI-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FLUYI') THEN
          NBFLUI= NBFLUI+1
          ZI(IFLUI-1+2)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FLUZI') THEN
          NBFLUI= NBFLUI+1
          ZI(IFLUI-1+3)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FLUXS') THEN
          NBFLUS= NBFLUS+1
          ZI(IFLUS-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FLUYS') THEN
          NBFLUS= NBFLUS+1
          ZI(IFLUS-1+2)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FLUZS') THEN
          NBFLUS= NBFLUS+1
          ZI(IFLUS-1+3)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FLUX') THEN
          NBFLU= NBFLU+1
          ZI(IFLU-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FLUY') THEN
          NBFLU= NBFLU+1
          ZI(IFLU-1+2)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FLUZ') THEN
          NBFLU= NBFLU+1
          ZI(IFLU-1+3)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH11X') THEN
          NBFH11 = NBFH11+1
          ZI(IFH11-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH11Y') THEN
          NBFH11= NBFH11+1
          ZI(IFH11-1+2)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH11Z') THEN
          NBFH11= NBFH11+1
          ZI(IFH11-1+3)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH12X') THEN
          NBFH12= NBFH12+1
          ZI(IFH12-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH12Y') THEN
          NBFH12= NBFH12+1
          ZI(IFH12-1+2)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH12Z') THEN
          NBFH12= NBFH12+1
          ZI(IFH12-1+3)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH21X') THEN
          NBFH21= NBFH21+1
          ZI(IFH21-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH21Y') THEN
          NBFH21= NBFH21+1
          ZI(IFH21-1+2)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH21Z') THEN
          NBFH21= NBFH21+1
          ZI(IFH21-1+3)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH22X') THEN
          NBFH22= NBFH22+1
          ZI(IFH22-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH22Y') THEN
          NBFH22= NBFH22+1
          ZI(IFH22-1+2)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FH22Z') THEN
          NBFH22= NBFH22+1
          ZI(IFH22-1+3)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FHTX') THEN
          NBFHT= NBFHT+1
          ZI(IFHT-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FHTY') THEN
          NBFHT= NBFHT+1
          ZI(IFHT-1+2)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'FHTZ') THEN
          NBFHT= NBFHT+1
          ZI(IFHT-1+3)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'TEMP_I') THEN
          NBTEMI= NBTEMI+1
          ZI(ITEMI-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'TEMP_S') THEN
          NBTEMS= NBTEMS+1
          ZI(ITEMS-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'TEMP') THEN
          NBTEMP= NBTEMP+1
          ZI(ITEMP-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'PRES') THEN
          NBPRES= NBPRES+1
          ZI(IPRES-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'PRE1') THEN
          NBPRE1= NBPRE1+1
          ZI(IPRE1-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'PRE2') THEN
          NBPRE2= NBPRE2+1
          ZI(IPRE2-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIP') THEN
          NBSIP= NBSIP+1
          ZI(ISIP-1+1)=ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIXX_I') THEN
          NBSIGI= NBSIGI+1
          ZI(ISIGI-1+1) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIXY_I') THEN
          NBSIGI= NBSIGI+1
          ZI(ISIGI-1+2) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIYY_I') THEN
          NBSIGI= NBSIGI+1
          ZI(ISIGI-1+3) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIXZ_I') THEN
          NBSIGI= NBSIGI+1
          ZI(ISIGI-1+4) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIYZ_I')  THEN
          NBSIGI= NBSIGI+1
          ZI(ISIGI-1+5) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIZZ_I') THEN
          NBSIGI= NBSIGI+1
          ZI(ISIGI-1+6) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIXX_S') THEN
          NBSIGS= NBSIGS+1
          ZI(ISIGS-1+1) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIXY_S') THEN
          NBSIGS= NBSIGS+1
          ZI(ISIGS-1+2) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIYY_S') THEN
          NBSIGS= NBSIGS+1
          ZI(ISIGS-1+3) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIXZ_S') THEN
          NBSIGS= NBSIGS+1
          ZI(ISIGS-1+4) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIYZ_S')  THEN
          NBSIGS= NBSIGS+1
          ZI(ISIGS-1+5) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIZZ_S') THEN
          NBSIGS= NBSIGS+1
          ZI(ISIGS-1+6) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIXX') THEN
          NBSIGM= NBSIGM+1
          ZI(ISIGM-1+1) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIXY') THEN
          NBSIGM= NBSIGM+1
          ZI(ISIGM-1+2) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIYY') THEN
          NBSIGM= NBSIGM+1
          ZI(ISIGM-1+3) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIXZ') THEN
          NBSIGM= NBSIGM+1
          ZI(ISIGM-1+4) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIYZ')  THEN
          NBSIGM= NBSIGM+1
          ZI(ISIGM-1+5) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'SIZZ') THEN
          NBSIGM= NBSIGM+1
          ZI(ISIGM-1+6) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPXX_I') THEN
          NBEPSI= NBEPSI+1
          ZI(IEPSI-1+1) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPXY_I') THEN
          NBEPSI= NBEPSI+1
          ZI(IEPSI-1+2) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPYY_I') THEN
          NBEPSI= NBEPSI+1
          ZI(IEPSI-1+3) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPXZ_I') THEN
          NBEPSI= NBEPSI+1
          ZI(IEPSI-1+4) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPYZ_I') THEN
          NBEPSI= NBEPSI+1
          ZI(IEPSI-1+5) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPZZ_I') THEN
          NBEPSI= NBEPSI+1
          ZI(IEPSI-1+6) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPXX_S') THEN
          NBEPSS= NBEPSS+1
          ZI(IEPSS-1+1) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPXY_S') THEN
          NBEPSS= NBEPSS+1
          ZI(IEPSS-1+2) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPYY_S') THEN
          NBEPSS= NBEPSS+1
          ZI(IEPSS-1+3) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPXZ_S') THEN
          NBEPSS= NBEPSS+1
          ZI(IEPSS-1+4) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPYZ_S') THEN
          NBEPSS= NBEPSS+1
          ZI(IEPSS-1+5) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPZZ_S') THEN
          NBEPSS= NBEPSS+1
          ZI(IEPSS-1+6) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPXX') THEN
          NBEPSM= NBEPSM+1
          ZI(IEPSM-1+1) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPXY') THEN
          NBEPSM= NBEPSM+1
          ZI(IEPSM-1+2) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPYY') THEN
          NBEPSM= NBEPSM+1
          ZI(IEPSM-1+3) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPXZ') THEN
          NBEPSM= NBEPSM+1
          ZI(IEPSM-1+4) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPYZ') THEN
          NBEPSM= NBEPSM+1
          ZI(IEPSM-1+5) = ICMAS
       ELSEIF (NOMCMP(ICMAS).EQ.'EPZZ') THEN
          NBEPSM= NBEPSM+1
          ZI(IEPSM-1+6) = ICMAS
       ELSE
          NBVARI= NBVARI+1
          ZI(IVARI-1+NBVARI)= ICMAS
       ENDIF
  1   CONTINUE
C
C  --- RECHERCHE DES GRANDEURS SUPERTAB ASSOCIEES A LA GRANDEUR ASTER---
C
      IF(NBDEPL.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'DEPL'
         NBCMPS(NBCHS) = NBDEPL
         NOMGDS(NBCHS) = 'DEPL'
         IF(NOMSYM.EQ.'DEPL') NOMGDS(NBCHS) = 'DEPL'
         IF(NOMSYM.EQ.'VITE') NOMGDS(NBCHS) = 'VITE'
         IF(NOMSYM.EQ.'ACCE') NOMGDS(NBCHS) = 'ACCE'
      ENDIF
      IF(NBFLU.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'FLUX'
         NBCMPS(NBCHS) = NBFLU
         NOMGDS(NBCHS) = 'FLUX'
      ENDIF
      IF(NBFLUI.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'FLUI'
         NBCMPS(NBCHS) = NBFLUI
         NOMGDS(NBCHS) = 'FLUX'
      ENDIF
      IF(NBFLUS.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'FLUS'
         NBCMPS(NBCHS) = NBFLUS
         NOMGDS(NBCHS) = 'FLUX'
      ENDIF
      IF(NBFH11.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'FH11'
         NBCMPS(NBCHS) = NBFH11
         NOMGDS(NBCHS) = 'FLUX'
      ENDIF
      IF(NBFH12.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'FH12'
         NBCMPS(NBCHS) = NBFH12
         NOMGDS(NBCHS) = 'FLUX'
      ENDIF
      IF(NBFH21.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'FH21'
         NBCMPS(NBCHS) = NBFH21
         NOMGDS(NBCHS) = 'FLUX'
      ENDIF
      IF(NBFH22.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'FH22'
         NBCMPS(NBCHS) = NBFH22
         NOMGDS(NBCHS) = 'FLUX'
      ENDIF
      IF(NBFHT.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'FHT'
         NBCMPS(NBCHS) = NBFHT
         NOMGDS(NBCHS) = 'FLUX'
      ENDIF
      IF(NBTEMP.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'TEMP'
         NBCMPS(NBCHS) = NBTEMP
         NOMGDS(NBCHS) = 'TEMP'
      ENDIF
      IF(NBTEMI.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'TEMI'
         NBCMPS(NBCHS) = NBTEMI
         NOMGDS(NBCHS) = 'TEMP'
      ENDIF
      IF(NBTEMS.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'TEMS'
         NBCMPS(NBCHS) = NBTEMS
         NOMGDS(NBCHS) = 'TEMP'
      ENDIF
      IF(NBPRES.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'PRES'
         NBCMPS(NBCHS) = NBPRES
         NOMGDS(NBCHS) = 'PRES'
      ENDIF
      IF(NBPRE1.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'PRE1'
         NBCMPS(NBCHS) = NBPRE1
         NOMGDS(NBCHS) = 'PRES'
      ENDIF
      IF(NBPRE2.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'PRE2'
         NBCMPS(NBCHS) = NBPRE2
         NOMGDS(NBCHS) = 'PRES'
      ENDIF
      IF(NBSIP.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'SIP'
         NBCMPS(NBCHS) = NBSIP
         NOMGDS(NBCHS) = 'VARI'
      ENDIF
      IF(NBSIGM.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'SIGM'
         NBCMPS(NBCHS) = NBSIGM
         NOMGDS(NBCHS) = 'SIGM'
      ENDIF
      IF(NBSIGS.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'SIGS'
         NBCMPS(NBCHS) = NBSIGS
         NOMGDS(NBCHS) = 'SIGM'
      ENDIF
      IF(NBSIGI.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'SIGI'
         NBCMPS(NBCHS) = NBSIGI
         NOMGDS(NBCHS) = 'SIGM'
      ENDIF
      IF(NBEPSM.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'EPSM'
         NBCMPS(NBCHS) = NBEPSM
         NOMGDS(NBCHS) = 'EPSI'
      ENDIF
      IF(NBEPSS.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'EPSS'
         NBCMPS(NBCHS) = NBEPSS
         NOMGDS(NBCHS) = 'EPSI'
      ENDIF
      IF(NBEPSI.NE.0) THEN
         NBCHS=NBCHS+1
         NOMCHS(NBCHS) = 'EPSI'
         NBCMPS(NBCHS) = NBEPSI
         NOMGDS(NBCHS) = 'EPSI'
      ENDIF
      IF(NBVARI.NE.0) THEN
         IENT =NBVARI/6
         IRES =NBVARI-(IENT*6)
         IF(IENT.NE.0) THEN
           DO 50 IVAR=1,IENT
             NOMCHS(NBCHS+IVAR)= 'VARI'
             NBCMPS(NBCHS+IVAR)= 6
             NOMGDS(NBCHS+IVAR)= 'VARI'
 50        CONTINUE
         ENDIF
         IF(IRES.NE.0) THEN
           NOMCHS(NBCHS+IENT+1)= 'VARI'
           NBCMPS(NBCHS+IENT+1)= IRES
           NOMGDS(NBCHS+IENT+1)= 'VARI'
           NBCHS = NBCHS+IENT+1
         ELSE
           NBCHS = NBCHS+IENT
         ENDIF
      ENDIF
C
C  ---- POSITIONS DES COMPOSANTES SUPERTAB DANS LA GRANDEUR ASTER ----
C
      DO 8 I=1,NBCHS
       IF (NOMCHS(I).EQ.'DEPL') THEN
         DO 31 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IDEPL-1+J)
  31     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'FLUX') THEN
         DO 32 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IFLU-1+J)
  32     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'FLUI') THEN
         DO 33 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IFLUI-1+J)
  33     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'FLUS') THEN
         DO 34 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IFLUS-1+J)
  34     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'FH11') THEN
         DO 341 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IFH11-1+J)
 341     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'FH12') THEN
         DO 342 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IFH12-1+J)
 342     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'FH21') THEN
         DO 343 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IFH21-1+J)
 343     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'FH22') THEN
         DO 344 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IFH22-1+J)
 344     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'FHT') THEN
         DO 345 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IFHT-1+J)
 345     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'TEMP') THEN
         DO 35 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(ITEMP-1+J)
  35     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'TEMI') THEN
         DO 36 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(ITEMI-1+J)
  36     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'TEMS') THEN
         DO 37 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(ITEMS-1+J)
  37     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'PRES') THEN
         DO 38 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IPRES-1+J)
  38     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'PRE1') THEN
         DO 381 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IPRE1-1+J)
 381     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'PRE2') THEN
         DO 382 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IPRE2-1+J)
 382     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'SIP') THEN
         DO 383 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(ISIP-1+J)
 383     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'SIGM') THEN
         DO 39 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(ISIGM-1+J)
  39     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'SIGI') THEN
         DO 40 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(ISIGI-1+J)
  40     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'SIGS') THEN
         DO 41 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(ISIGS-1+J)
  41     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'EPSM') THEN
         DO 42 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IEPSM-1+J)
  42     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'EPSS') THEN
         DO 43 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IEPSS-1+J)
  43     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'EPSI') THEN
         DO 44 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IEPSI-1+J)
  44     CONTINUE
       ELSEIF (NOMCHS(I).EQ.'VARI') THEN
         IVA =IVA + 1
         DO 45 J=1,NBCMPS(I)
          IPCMPS((I-1)*NCMPMX+J) = ZI(IVARI-1+(IVA-1)*6+J)
  45     CONTINUE
       ENDIF
   8  CONTINUE
C
      CALL JEDETR('&&IRGAGS.IDEPL')
      CALL JEDETR('&&IRGAGS.ITEMP')
      CALL JEDETR('&&IRGAGS.ITEMI')
      CALL JEDETR('&&IRGAGS.ITEMS')
      CALL JEDETR('&&IRGAGS.IPRES')
      CALL JEDETR('&&IRGAGS.IPRE1')
      CALL JEDETR('&&IRGAGS.IPRE2')
      CALL JEDETR('&&IRGAGS.ISIP')
      CALL JEDETR('&&IRGAGS.ISIGM')
      CALL JEDETR('&&IRGAGS.ISIGS')
      CALL JEDETR('&&IRGAGS.ISIGI')
      CALL JEDETR('&&IRGAGS.IEPSI')
      CALL JEDETR('&&IRGAGS.IEPSM')
      CALL JEDETR('&&IRGAGS.IEPSS')
      CALL JEDETR('&&IRGAGS.IFLU')
      CALL JEDETR('&&IRGAGS.IFLUI')
      CALL JEDETR('&&IRGAGS.IFLUS')
      CALL JEDETR('&&IRGAGS.IFH11')
      CALL JEDETR('&&IRGAGS.IFH12')
      CALL JEDETR('&&IRGAGS.IFH21')
      CALL JEDETR('&&IRGAGS.IFH22')
      CALL JEDETR('&&IRGAGS.IFHT')
      CALL JEDETR('&&IRGAGS.IVARI')
      END
