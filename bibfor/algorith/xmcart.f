      SUBROUTINE XMCART(NOMA  ,DEFICO,MODELE,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXATR
      CHARACTER*8  NOMA,MODELE
      CHARACTER*24 DEFICO,RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM-GG
C
C CREATION DE LA CARTE CONTENANT LES INFOS DE CONTACT
C
C ----------------------------------------------------------------------
C
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  MODELE   : NOM DU MODELE
C
C CONTENU DE LA CARTE
C
C 1  XPC    : COORDONNEE PARAMETRIQUE X DU POINT DE CONTACT
C 2  XPR    : COORDONNEE PARAMETRIQUE X DU PROJETE DU POINT DE CONTACT
C 3  YPR    : COORDONNEE PARAMETRIQUE Y DU PROJETE DU POINT DE CONTACT
C 4  TAU1(1): COMPOSANTE 1 DU VECTEUR TANGENT 1
C 5  TAU1(2): COMPOSANTE 2 DU VECTEUR TANGENT 1
C 6  TAU1(3): COMPOSANTE 3 DU VECTEUR TANGENT 1
C 7  TAU2(1): COMPOSANTE 1 DU VECTEUR TANGENT 2
C 8  TAU2(2): COMPOSANTE 2 DU VECTEUR TANGENT 2
C 9  TAU2(3): COMPOSANTE 3 DU VECTEUR TANGENT 2
C 10 YPC    : COORDONNEE PARAMETRIQUE Y DU POINT DE CONTACT
C 11 INDCO  : ETAT DE CONTACT (0 PAS DE CONTACT)
C 13 COEFCA : COEF_REGU_CONT
C 14 COEFFA : COEF_REGU_FROT
C 15 COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C 16 IFROTT : FROTTEMENT (0 SI PAS, 3 SI COULOMB)
C 17 INDNOR : NOEUD EXCLU PAR PROJECTION HORS ZONE
C 18 NINTER : NOMBRE DE POINT D'INTERSECTION DE LA MAILLE ESCLAVE
C 19 HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C 20 IGLISS : CONTACT GLISSIERE
C 21 MEMCO  : MEMOIRE DE CONTACT
C 22 NFAES  : NUMEROS DE LA FACETTES ESCLAVE
C 23 NFAMA  : NUMEROS DE LA FACETTES MAITRE
C
C
C
C
      INTEGER      NCMP(7)
C
      INTEGER      NUMMAE,NUMMAM,NNOE,NNOM,IFISE,IFISM,JFISS
      INTEGER      I,J,IPC,K,NTPC,NDIM,IZONE,MMINFI,NFACE,NPTE
      INTEGER      CFMMVD,ZTABF,JTABF,JNOSDC,NFHE,NFHM,NFISS
      CHARACTER*24 TABFIN,NOSDCO
      REAL*8       MMINFR
      INTEGER      CFDISI
      INTEGER      JVALV(7),JNCMP(7),JCESL(7),JCESD(7),JCESV(7),IAD
      CHARACTER*2  CH2
      CHARACTER*8  KBID,NOMGD
      CHARACTER*19 LIGRXF,CHS(7),CARTE(7)
      INTEGER      ZXAIN,XXMMVD,IFM,NIV,JCONX,NINTER,NBPI,IER
      LOGICAL      LMULTI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> CREATION DE LA CARTE POUR LES'//
     &        ' ELEMENTS DE CONTACT X-FEM'
      ENDIF
C
C --- INITIALISATIONS
C
      NDIM   = CFDISI(DEFICO,'NDIM')
      NTPC   = CFDISI(DEFICO,'NTPC')
      NCMP(1) = 34
      IF (NDIM.EQ.2) THEN
        NCMP(2)  = 32
        NCMP(3)  = 6
        NCMP(4)  = 15
        NCMP(5)  = 3
        NCMP(6)  = 32
        NCMP(7)  = 4
      ELSEIF (NDIM.EQ.3) THEN
        NCMP(2)  = 64
        NCMP(3)  = 18
        NCMP(4)  = 30
        NCMP(5)  = 15
        NCMP(6)  = 64
        NCMP(7)  = 8
      ENDIF
C
      ZTABF = CFMMVD('ZTABF')
      ZXAIN = XXMMVD('ZXAIN')
C
C --- ACCES OBJETS
C
      TABFIN = RESOCO(1:14)//'.TABFIN'
      CALL JEVEUO(TABFIN,'L',JTABF )
      NOSDCO = RESOCO(1:14)//'.NOSDCO'
      CALL JEVEUO(NOSDCO,'L',JNOSDC)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JCONX)
C
C --- CHAMPS DES ELEMENTS XFEM
C
      CHS(1) = '&&XMCART.CHS1'
      CHS(2) = '&&XMCART.CHS2'
      CHS(3) = '&&XMCART.CHS3'
      CHS(4) = '&&XMCART.CHS4'
      CHS(5) = '&&XMCART.CHS5'
      CHS(6) = '&&XMCART.CHS6'
      CHS(7) = '&&XMCART.CHS7'
C
      CALL CELCES(MODELE//'.STNO','V',CHS(1))
      CALL CELCES(MODELE//'.TOPOFAC.OE','V',CHS(2))
      CALL CELCES(MODELE//'.TOPOFAC.AI','V',CHS(3))
      CALL CELCES(MODELE//'.TOPOFAC.CF','V',CHS(4))
C
      DO 100 I = 1,4
        CALL JEVEUO(CHS(I)//'.CESD','L',JCESD(I))
        CALL JEVEUO(CHS(I)//'.CESV','L',JCESV(I))
        CALL JEVEUO(CHS(I)//'.CESL','L',JCESL(I))
  100 CONTINUE
C
C --- CHAMPS ELEM XFEM MULTI-HEAVISIDE
C
      LMULTI = .FALSE.
      CALL JEEXIN(MODELE//'.FISSNO    .CELD',IER)
      IF (IER.NE.0) THEN
        LMULTI = .TRUE.
        CALL CELCES(MODELE//'.FISSNO','V',CHS(5))
        CALL CELCES(MODELE//'.HEAVNO','V',CHS(6))
        CALL CELCES(MODELE//'.TOPOFAC.HE','V',CHS(7))
        DO 110 I = 5,7
          CALL JEVEUO(CHS(I)//'.CESD','L',JCESD(I))
          CALL JEVEUO(CHS(I)//'.CESV','L',JCESV(I))
          CALL JEVEUO(CHS(I)//'.CESL','L',JCESL(I))
  110   CONTINUE
      ENDIF
C
C --- LIGREL DES ELEMENTS TARDIFS DE CONTACT/FROTTEMENT
C
      LIGRXF = ZK24(JNOSDC+3-1)(1:19)
C
C --- INITIALISATION DES CARTES POUR ELEMENTS TARDIFS
C
      CARTE(1) = RESOCO(1:14)//'.XFPO'
      CARTE(2) = RESOCO(1:14)//'.XFST'
      CARTE(3) = RESOCO(1:14)//'.XFPI'
      CARTE(4) = RESOCO(1:14)//'.XFAI'
      CARTE(5) = RESOCO(1:14)//'.XFCF'
      CARTE(6) = RESOCO(1:14)//'.XFHF'
      CARTE(7) = RESOCO(1:14)//'.XFPL'
      DO 120 I = 1,7
        CALL DETRSD('CARTE',CARTE(I))
        IF (I.EQ.1.OR.I.EQ.3.OR.I.EQ.4) THEN
          NOMGD = 'NEUT_R'
        ELSE
          NOMGD = 'NEUT_I'
        ENDIF
        CALL ALCART('V',CARTE(I),NOMA,NOMGD)
        CALL JEVEUO(CARTE(I)//'.NCMP','E',JNCMP(I))
        CALL JEVEUO(CARTE(I)//'.VALV','E',JVALV(I))
        DO 130,K = 1,NCMP(I)
          CALL CODENT(K,'G',CH2)
          ZK8(JNCMP(I)-1+K) = 'X'//CH2
  130   CONTINUE
  120 CONTINUE
C
C --- REMPLISSAGE DES CARTES
C
      DO 200 IPC = 1,NTPC
        IZONE  = NINT(ZR(JTABF+ZTABF*(IPC-1)+15))
C ----- NUMEROS MAILLE ET NOMBRE DE NOEUDS ESCLAVE ET MAITRE
        NUMMAE = NINT(ZR(JTABF+ZTABF*(IPC-1)+1))
        NUMMAM = NINT(ZR(JTABF+ZTABF*(IPC-1)+2))
        NNOE = ZI(JCONX+NUMMAE) - ZI(JCONX+NUMMAE-1)
        NNOM = ZI(JCONX+NUMMAM) - ZI(JCONX+NUMMAM-1)
C ----- NOMBRE DE POINTS D'INTERSECTION ET DE FACETTES ESCLAVE
        NPTE   = NINT(ZR(JTABF+ZTABF*(IPC-1)+24))
        NINTER = NINT(ZR(JTABF+ZTABF*(IPC-1)+14))
        NBPI=NINTER
        IF(NNOE.EQ.NNOM .AND. NDIM.EQ.2) THEN
          IF (NNOE.EQ.6 .AND.NINTER.EQ.2) NBPI=3
          IF (NNOE.EQ.8 .AND.NINTER.EQ.2) NBPI=3
        ENDIF
        NFACE  = NINT(ZR(JTABF+ZTABF*(IPC-1)+26))
C ----- NUMERO LOCALE DE FISSURE ESCLAVE ET MAITRE
        IFISE= NINT(ZR(JTABF+ZTABF*(IPC-1)+33))
        IFISM= NINT(ZR(JTABF+ZTABF*(IPC-1)+34))
C ----- NOMBRE DE FONCTIONS HEAVISIDE
        IF (LMULTI) THEN
          NFHE = ZI(JCESD(5)-1+5+4*(NUMMAE-1)+2)
          NFHM = ZI(JCESD(5)-1+5+4*(NUMMAM-1)+2)
        ELSE
          NFHE = 1
          NFHM = 1
        ENDIF
C
C ----- REMPLISSAGE DE LA CARTE CARTCF.POINT
C
        ZR(JVALV(1)-1+1)  = ZR(JTABF+ZTABF*(IPC-1)+3)
        ZR(JVALV(1)-1+2)  = ZR(JTABF+ZTABF*(IPC-1)+4)
        ZR(JVALV(1)-1+3)  = ZR(JTABF+ZTABF*(IPC-1)+5)
        ZR(JVALV(1)-1+4)  = ZR(JTABF+ZTABF*(IPC-1)+6)
        ZR(JVALV(1)-1+5)  = ZR(JTABF+ZTABF*(IPC-1)+7)
        ZR(JVALV(1)-1+6)  = ZR(JTABF+ZTABF*(IPC-1)+8)
        ZR(JVALV(1)-1+7)  = ZR(JTABF+ZTABF*(IPC-1)+9)
        ZR(JVALV(1)-1+8)  = ZR(JTABF+ZTABF*(IPC-1)+10)
        ZR(JVALV(1)-1+9)  = ZR(JTABF+ZTABF*(IPC-1)+11)
        ZR(JVALV(1)-1+10) = ZR(JTABF+ZTABF*(IPC-1)+12)
        ZR(JVALV(1)-1+11) = ZR(JTABF+ZTABF*(IPC-1)+13)
        ZR(JVALV(1)-1+12) = NPTE
        ZR(JVALV(1)-1+13) = MMINFR(DEFICO,'COEF_AUGM_CONT' ,IZONE )
        ZR(JVALV(1)-1+14) = MMINFR(DEFICO,'COEF_AUGM_FROT' ,IZONE )
        ZR(JVALV(1)-1+15) = MMINFR(DEFICO,'COEF_COULOMB'   ,IZONE )
        ZR(JVALV(1)-1+16) = MMINFI(DEFICO,'FROTTEMENT_ZONE',IZONE )
        ZR(JVALV(1)-1+17) = ZR(JTABF+ZTABF*(IPC-1)+22)
        ZR(JVALV(1)-1+18) = ZR(JTABF+ZTABF*(IPC-1)+30)
        ZR(JVALV(1)-1+19) = ZR(JTABF+ZTABF*(IPC-1)+16)
        ZR(JVALV(1)-1+20) = ZR(JTABF+ZTABF*(IPC-1)+29)
        ZR(JVALV(1)-1+21) = ZR(JTABF+ZTABF*(IPC-1)+28)
        ZR(JVALV(1)-1+22) = ZR(JTABF+ZTABF*(IPC-1)+25)
        ZR(JVALV(1)-1+23) = ZR(JTABF+ZTABF*(IPC-1)+31)
        ZR(JVALV(1)-1+24) = ZR(JTABF+ZTABF*(IPC-1)+17)
        ZR(JVALV(1)-1+25) = ZR(JTABF+ZTABF*(IPC-1)+18)
        ZR(JVALV(1)-1+26) = ZR(JTABF+ZTABF*(IPC-1)+19)
        ZR(JVALV(1)-1+27) = ZR(JTABF+ZTABF*(IPC-1)+20)
        ZR(JVALV(1)-1+28) = ZR(JTABF+ZTABF*(IPC-1)+21)
        ZR(JVALV(1)-1+29) = ZR(JTABF+ZTABF*(IPC-1)+23)
        ZR(JVALV(1)-1+30) = ZR(JTABF+ZTABF*(IPC-1)+27)
        ZR(JVALV(1)-1+31) = NINTER
        ZR(JVALV(1)-1+33) = MMINFR(DEFICO,'COEF_PENA_CONT' ,IZONE )
        ZR(JVALV(1)-1+34) = MMINFR(DEFICO,'COEF_PENA_FROT' ,IZONE )

        CALL NOCART(CARTE(1),-3,KBID,'NUM',1,KBID,-IPC,LIGRXF,NCMP(1))
C
C ----- REMPLISSAGE DE LA CARTE CARTCF.STANO
C
        DO 210 I=1,NNOE
          DO 220 J=1,NFHE
            JFISS = 1
            IF (LMULTI) THEN
              CALL CESEXI('C',JCESD(5),JCESL(5),NUMMAE,I,J,1,IAD)
              IF (IAD.GT.0) JFISS = ZI(JCESV(5)-1+IAD)
            ENDIF
            CALL CESEXI('S',JCESD(1),JCESL(1),NUMMAE,I,JFISS,1,IAD)
            CALL ASSERT(IAD.GT.0)
            ZI(JVALV(2)-1+NFHE*(I-1)+J)=ZI(JCESV(1)-1+IAD)
  220     CONTINUE
  210   CONTINUE
        DO 230 I=1,NNOM
          DO 240 J=1,NFHM
            JFISS = 1
            IF (LMULTI) THEN
              CALL CESEXI('C',JCESD(5),JCESL(5),NUMMAM,I,J,1,IAD)
              IF (IAD.GT.0) JFISS = ZI(JCESV(5)-1+IAD)
            ENDIF
            CALL CESEXI('S',JCESD(1),JCESL(1),NUMMAM,I,JFISS,1,IAD)
            CALL ASSERT(IAD.GT.0)
            ZI(JVALV(2)-1+NFHE*NNOE+NFHM*(I-1)+J)=ZI(JCESV(1)-1+IAD)
  240     CONTINUE
  230   CONTINUE
        CALL NOCART(CARTE(2),-3,KBID,'NUM',1,KBID,-IPC,LIGRXF,NCMP(2))
C
C ----- REMPLISSAGE DE LA CARTE CARTCF.PINTER
C
        DO 10 I=1,NDIM
          DO 20 J=1,NBPI
            CALL CESEXI('S',JCESD(2),JCESL(2),NUMMAE,1,IFISE,
     &                  NDIM*(J-1)+I,IAD)
            CALL ASSERT(IAD.GT.0)
            ZR(JVALV(3)-1+NDIM*(J-1)+I)=ZR(JCESV(2)-1+IAD)
 20       CONTINUE
 10     CONTINUE
        CALL NOCART(CARTE(3),-3,KBID,'NUM',1,KBID,-IPC,LIGRXF,NCMP(3))
C
C ----- REMPLISSAGE DE LA CARTE CARTCF.AINTER
C
        DO 40 I=1,ZXAIN
          DO 50 J=1,NINTER
            CALL CESEXI('S',JCESD(3),JCESL(3),NUMMAE,1,IFISE,
     &                  ZXAIN*(J-1)+I,IAD)
            CALL ASSERT(IAD.GT.0)
            ZR(JVALV(4)-1+ZXAIN*(J-1)+I)=ZR(JCESV(3)-1+IAD)
 50       CONTINUE
 40     CONTINUE
        CALL NOCART(CARTE(4),-3,KBID,'NUM',1,KBID,-IPC,LIGRXF,NCMP(4))
C
C ----- REMPLISSAGE DE LA CARTE CARTCF.CCFACE
C
        DO 70 I=1,NPTE
          DO 80 J=1,NFACE
            CALL CESEXI('S',JCESD(4),JCESL(4),NUMMAE,1,IFISE,
     &                  NPTE*(J-1)+I,IAD)
            CALL ASSERT(IAD.GT.0)
            ZI(JVALV(5)-1+NPTE*(J-1)+I)=ZI(JCESV(4)-1+IAD)
 80       CONTINUE
 70     CONTINUE
        CALL NOCART(CARTE(5),-3,KBID,'NUM',1,KBID,-IPC,LIGRXF,NCMP(5))
C
        IF (LMULTI) THEN
          IF (NFHE.GT.1.OR.NFHM.GT.1) THEN
C
C ----- REMPLISSAGE DE LA CARTE CARTCF.TOPOFAC.HE
C
            NFISS = ZI(JCESD(6)-1+5+4*(NUMMAE-1)+2)
            DO 250 I=1,NNOE
              DO 260 J=1,NFHE
                CALL CESEXI('C',JCESD(5),JCESL(5),NUMMAE,I,J,1,IAD)
                IF (IAD.GT.0) THEN
                  JFISS = ZI(JCESV(5)-1+IAD)
                  CALL CESEXI('S',JCESD(7),JCESL(7),NUMMAE,1,
     &                        NFISS*(IFISE-1)+JFISS,1,IAD)
                  CALL ASSERT(IAD.GT.0)
                  ZI(JVALV(6)-1+NFHE*(I-1)+J)=ZI(JCESV(7)-1+IAD)
                ELSE
                  ZI(JVALV(6)-1+NFHE*(I-1)+J)=-1
                ENDIF
  260         CONTINUE
  250       CONTINUE
            NFISS = ZI(JCESD(6)-1+5+4*(NUMMAM-1)+2)
            DO 270 I=1,NNOM
              DO 280 J=1,NFHM
                CALL CESEXI('C',JCESD(5),JCESL(5),NUMMAM,I,J,1,IAD)
                IF (IAD.GT.0) THEN
                  JFISS = ZI(JCESV(5)-1+IAD)
                  CALL CESEXI('S',JCESD(7),JCESL(7),NUMMAM,1,
     &                        NFISS*(IFISM-1)+JFISS,2,IAD)
                  CALL ASSERT(IAD.GT.0)
                  ZI(JVALV(6)-1+NFHE*NNOE+NFHM*(I-1)+J)=
     &                                                ZI(JCESV(7)-1+IAD)
                ELSE
                  ZI(JVALV(6)-1+NFHE*NNOE+NFHM*(I-1)+J)=1
                ENDIF
  280         CONTINUE
  270       CONTINUE
            CALL NOCART(CARTE(6),-3,KBID,'NUM',1,KBID,-IPC,LIGRXF,
     &                  NCMP(6))
C
C ----- REMPLISSAGE DE LA CARTE CARTCF.PLALA
C
            DO 290 I=1,NNOE
              CALL CESEXI('C',JCESD(6),JCESL(6),NUMMAE,I,IFISE,1,IAD)
              IF (IAD.GT.0) THEN
                ZI(JVALV(7)-1+I)=ZI(JCESV(6)-1+IAD)
              ELSE
                ZI(JVALV(7)-1+I)=1
              ENDIF
  290       CONTINUE
            CALL NOCART(CARTE(7),-3,KBID,'NUM',1,KBID,-IPC,LIGRXF,
     &                  NCMP(7))
          ENDIF
        ENDIF
C
        IF (NIV.GE.2) THEN
          CALL XMIMP3(IFM,NOMA,IPC,JVALV(1),JTABF)
        ENDIF

  200 CONTINUE
C
C --- MENAGE
C
      DO 140 I = 1,7
        CALL JEEXIN(CHS(I)//'.CESD',IER)
        IF (IER.NE.0) CALL DETRSD('CHAM_ELEM_S',CHS(I))
  140 CONTINUE
C
      DO 150 I = 1,7
        CALL JEDETR(CARTE(I)//'.NCMP')
        CALL JEDETR(CARTE(I)//'.VALV')
  150 CONTINUE
C
      CALL JEDEMA()
      END
