      SUBROUTINE RESU74 (TRAN,NOMRES)
      IMPLICIT REAL*8 (A-H,O-Z)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/08/2000   AUTEUR ACBHHCD G.DEVESA 
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
C     CETTE ROUTINE PERMET LA CONCATENATION DE DEUX CONCEPTS TRAN_GENE
C     CALCULES PAR DEUX COMMANDE DYNA_TRAN_MODAL
C     TRAN TRONQUE ET NOMRES SONT COPIES DANS RESU
C
C
C
C ----------------------------------------------------------------------
      CHARACTER*8  NOMRES, TRAN
C
C IN  : TRAN : PREMIER CONCEPT TRAN_GENE
C IN  : NOMRES : SECOND CONCEPT TRAN_GENE
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
C
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
C
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER      NBMODE, NC, NP, NI, NBSTO1, NBINST, NBSTO2
      INTEGER      NBSTO3, NBSTOC, NBSAU2, NBSAUV, NTEM2, NTEMP
      INTEGER      NBCHOC
      REAL*8       PREC, TINIT, PREC2
      CHARACTER*1  K1BID
      CHARACTER*8  RESU, CRIT
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      RESU = '88888'
C
      CALL JEVEUO (TRAN//'           .DESC','E',JDESC)
      NBMODE = ZI(JDESC+1)
C
C     --- RECUPERATION DE L'INSTANT DE REPRISE
C
      CALL GETVTX('ETAT_INIT','CRITERE',1,1,1,CRIT,NC)
      CALL GETVR8('ETAT_INIT','PRECISION',1,1,1,PREC,NP)
      CALL GETVR8('ETAT_INIT','INST_INIT',1,1,1,TINIT,NI)
C
C      --- RECHERCHE DU NUMERO D'ORDRE DE L'INSTANT DE REPRISE
C
      CALL JEVEUO(TRAN//'           .INST','E',JINST1)
      IF (NI.EQ.0) THEN
         CALL JELIRA(TRAN//'           .INST' ,'LONUTI',NBINST,K1BID)
         TINIT = ZR(JINST1+NBINST-1)
      ENDIF
      CALL JELIRA(TRAN//'           .INST' ,'LONUTI',NBINST,K1BID)
      CALL JELIRA(TRAN//'           .DEPL','LONUTI',NBSTO1,K1BID)
      NBSTO1 = NBSTO1/NBMODE
      PREC2 = PREC
      IF ( CRIT(1:7).EQ.'RELATIF') PREC2 = PREC * ZR(JINST1)
      IF ( ABS ( TINIT - ZR(JINST1) ).LE.PREC2 ) THEN
         NBINST = 1
         GOTO 202
      ENDIF
      IF ( CRIT(1:7).EQ.'RELATIF') PREC2 = PREC * ZR(JINST1+NBSTO1-1)
      IF ( ABS ( TINIT - ZR(JINST1+NBSTO1-1) ).LE.PREC2 ) THEN
         NBINST = NBSTO1
         GOTO 202
      ENDIF
      DO 201 I = 2, NBSTO1-1
         IF ( CRIT(1:7).EQ.'RELATIF') PREC2 = PREC * ZR(JINST1+I-1)
         IF ( ABS ( TINIT - ZR(JINST1+I-1) ).LE.PREC2 ) THEN
            NBINST = I
            GOTO 202
         ENDIF
 201  CONTINUE
 202  CONTINUE
C
C     --- RECUPERATION DES CHAMPS DEPL VITE ET ACCE ---
C
      CALL JEVEUO(TRAN//'           .DEPL' ,'E',JDEPL1)
      CALL JEVEUO(NOMRES//'           .DEPL' ,'E',JDEPL2)
      CALL JELIRA(NOMRES//'           .DEPL' ,'LONUTI',NBSTO2,K1BID)
C
      NBSTO3 = NBINST*NBMODE
      NBSTOC = NBSTO3 + NBSTO2 - NBMODE
C
      CALL WKVECT(RESU//'           .DEPL','G V R',NBSTOC,JDEPL)
      CALL R8COPY(NBSTO3,ZR(JDEPL1),1,ZR(JDEPL),1)
      CALL R8COPY(NBSTO2-NBMODE,ZR(JDEPL2+NBMODE),
     +                           1,ZR(JDEPL+NBSTO3),1)
      CALL JEVEUO(TRAN//'           .VITE' ,'E',JVITE1)
      CALL JEVEUO(NOMRES//'           .VITE' ,'E',JVITE2)
      CALL WKVECT(RESU//'           .VITE','G V R',NBSTOC,JVITE)
      CALL R8COPY(NBSTO3,ZR(JVITE1),1,ZR(JVITE),1)
      CALL R8COPY(NBSTO2-NBMODE,ZR(JVITE2+NBMODE),
     +                           1,ZR(JVITE+NBSTO3),1)
      CALL JEVEUO(TRAN//'           .ACCE' ,'E',JACCE1)
      CALL JEVEUO(NOMRES//'           .ACCE' ,'E',JACCE2)
      CALL WKVECT(RESU//'           .ACCE','G V R',NBSTOC,JACCE)
      CALL R8COPY(NBSTO3,ZR(JACCE1),1,ZR(JACCE),1)
      CALL R8COPY(NBSTO2-NBMODE,ZR(JACCE2+NBMODE),
     +                           1,ZR(JACCE+NBSTO3),1)
C
C     --- RECUPERATION DES CHAMPS ORDR ET INST
C
      CALL JEVEUO(TRAN//'           .ORDR' ,'E',JORDR1)
      CALL JEVEUO(NOMRES//'           .ORDR' ,'E',JORDR2)
      CALL JELIRA(NOMRES//'           .ORDR' ,'LONUTI',NBSAU2,K1BID)
C
      NBSAUV = NBINST + NBSAU2 - 1
C
      CALL WKVECT(RESU//'           .ORDR','G V I',NBSAUV,JORDR)
      DO 10 I = 1,NBINST
         ZI(JORDR-1+I) = ZI(JORDR1-1+I)
  10  CONTINUE
      DO 20 I = 1,NBSAU2
         ZI(JORDR+NBINST-1+I) = ZI(JORDR2+I) + ZI(JORDR1+NBINST-1)
  20  CONTINUE
      CALL JEVEUO(NOMRES//'           .INST' ,'E',JINST2)
      CALL WKVECT(RESU//'           .INST','G V R',NBSAUV,JINST)
      CALL R8COPY(NBINST,ZR(JINST1),1,ZR(JINST),1)
      CALL R8COPY(NBSAU2-1,ZR(JINST2+1),1,ZR(JINST+NBINST),1)
C
C     --- RECUPERATION DES PAS DE TEMPS
C
      CALL JELIRA(NOMRES//'           .PTEM' ,'LONUTI',NTEM2,K1BID)
      IF (NTEM2.GT.1) THEN
        CALL JEVEUO(TRAN//'           .PTEM' ,'E',JTEM1)
        CALL JEVEUO(NOMRES//'           .PTEM' ,'E',JTEM2)
        NTEMP = NBINST -1 + NTEM2
        CALL WKVECT(RESU//'           .PTEM','G V R',NTEMP,JTEMP)
        CALL R8COPY(NBINST-1,ZR(JTEM1),1,ZR(JTEMP),1)
        CALL R8COPY(NTEM2,ZR(JTEM2),1,ZR(JTEMP+NBINST-1),1)
      ENDIF
C
C     --- RECUPERATION DES CHOCS
C
      CALL JEVEUO(TRAN//'           .DESC' ,'E',JDESC)
      NBCHOC = ZI(JDESC+2)
      IF (NBCHOC.NE.0) THEN
         CALL JEVEUO(TRAN//'           .FCHO' ,'E',JFCH1)
         CALL JEVEUO(TRAN//'           .VCHO' ,'E',JVCH1)
         CALL JEVEUO(NOMRES//'           .FCHO' ,'E',JFCH2)
         CALL JEVEUO(NOMRES//'           .VCHO' ,'E',JVCH2)
         CALL WKVECT(RESU//'           .FCHO','G V R',3*NBCHOC*NBSAUV
     +                                              ,JFCHO)
         CALL WKVECT(RESU//'           .VCHO','G V R',3*NBCHOC*NBSAUV
     +                                              ,JVCHO)
         CALL R8COPY(3*NBCHOC*NBINST,ZR(JFCH1),1,ZR(JFCHO),1)
         CALL R8COPY(3*NBCHOC*NBINST,ZR(JVCH1),1,ZR(JVCHO),1)
         CALL R8COPY(3*NBCHOC*(NBSAU2-1),ZR(JFCH2+3*NBCHOC),1,
     +                              ZR(JFCHO+3*NBCHOC*NBINST),1)
         CALL R8COPY(3*NBCHOC*(NBSAU2-1),ZR(JVCH2+3*NBCHOC),1,
     +                              ZR(JVCHO+3*NBCHOC*NBINST),1)
         CALL JEVEUO(NOMRES//'           .DLOC' ,'E',JDCH2)
         CALL WKVECT(RESU//'           .DLOC','G V R',6*NBCHOC*NBSAUV
     +                                              ,JDCHO)
         CALL JEVEUO(TRAN//'           .DLOC' ,'E',JDCH1)
         CALL R8COPY(6*NBCHOC*NBINST,ZR(JDCH1),1,ZR(JDCHO),1)
         CALL R8COPY(6*NBCHOC*(NBSAU2-1),ZR(JDCH2+6*NBCHOC),1,
     +                              ZR(JDCHO+6*NBCHOC*NBINST),1)
         CALL JEVEUO(NOMRES//'           .VINT' ,'E',JVINT2)
         CALL WKVECT(RESU//'           .VINT','G V R',NBCHOC*NBSAUV
     +                                              ,JVINT)
         CALL JEVEUO(TRAN//'           .VINT' ,'E',JVINT1)
         CALL R8COPY(NBCHOC*NBINST,ZR(JVINT1),1,ZR(JVINT),1)
         CALL R8COPY(NBCHOC*(NBSAU2-1),ZR(JVINT2+NBCHOC),1,
     +                              ZR(JVINT+NBCHOC*NBINST),1)
      ENDIF
C
C     --- DUPLICATION ---
C
      CALL JEDUPO(RESU//'           .DEPL',
     +            'G',TRAN//'           .DEPL',.FALSE.)
      CALL JEDUPO(RESU//'           .VITE',
     +            'G',TRAN//'           .VITE',.FALSE.)
      CALL JEDUPO(RESU//'           .ACCE',
     +            'G',TRAN//'           .ACCE',.FALSE.)
      CALL JEDUPO(RESU//'           .ORDR',
     +            'G',TRAN//'           .ORDR',.FALSE.)
      CALL JEDUPO(RESU//'           .INST',
     +            'G',TRAN//'           .INST',.FALSE.)
      IF (NTEM2.GT.1) THEN
         CALL JEDUPO(RESU//'           .PTEM',
     +               'G',TRAN//'           .PTEM',.FALSE.)
      ENDIF
      IF (NBCHOC.NE.0) THEN
       CALL JEDUPO(RESU//'           .FCHO',
     +               'G',TRAN//'           .FCHO',.FALSE.)
       CALL JEDUPO(RESU//'           .DLOC',
     +               'G',TRAN//'           .DLOC',.FALSE.)
       CALL JEDUPO(RESU//'           .VCHO',
     +               'G',TRAN//'           .VCHO',.FALSE.)
C      VARIABLES INTERNES (FLAMBAGE)
       CALL JEDUPO(RESU//'           .VINT',
     +               'G',TRAN//'           .VINT',.FALSE.)
      ENDIF
C
C     --- DESTRUCTION DES OBJETS PROVISOIRES
C
      CALL JEDETC('G',RESU//'           ',1)
      CALL JEDETC('G',NOMRES//'           ',1)
C
      CALL JEDEMA()
C
      END
