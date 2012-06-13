      SUBROUTINE XFISNO(NOMA  ,MODELX)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE MASSIN P.MASSIN
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8   NOMA,MODELX

C----------------------------------------------------------------------
C  BUT: CREATION D'UN CHAMPS ELNO QUI ASSOCIE POUR CHAQUE NOEUD LE
C       NUM�RO DE FISSURE LOCALE AU DDL HEAVISIDE
C
C----------------------------------------------------------------------
C
C     ARGUMENTS/
C  NOMA       IN       K8 : MAILLAGE
C  MODELX     IN/OUT   K8 : MODELE XFEM
C
C
C
C

      INTEGER JLCNX,JNBSP,JNBSP2,JCESFD,JCESFL,JCESFV,JCESD,JCESL,JCESV
      INTEGER JCESD2,JCESV2,JCESL2,JXC
      INTEGER NBMA,IMA,NBNO,INO,NHEAV,IHEAV,NFISS,IFISS
      INTEGER IRET,IBID,IAD,NNCP
      CHARACTER*8   K8BID
      CHARACTER*19  FISSNO,CES,CESF,LIGREL,CES2,HEAVNO
      LOGICAL      LCONT
C     ------------------------------------------------------------------

      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      LIGREL = MODELX(1:8)//'.MODELE'
      FISSNO = MODELX(1:8)//'.FISSNO'
      CES  = '&&XFISNO.FISSNO'
      CESF = '&&XFISNO.STNO'
C
C --- LE CONTACT EST-IL D�CLAR�
C
      CALL JEVEUO(MODELX(1:8)//'.XFEM_CONT','L',JXC)
      CALL ASSERT(ZI(JXC).LE.1)
      LCONT = ZI(JXC).EQ.1
      IF (LCONT) THEN
        HEAVNO = MODELX(1:8)//'.HEAVNO'
        CES2 = '&&XFISNO.HEAVNO'
      ENDIF
C
C --- TRANSFO CHAM_ELEM -> CHAM_ELEM_S DE STANO
C
      CALL CELCES(MODELX(1:8)//'.STNO','V',CESF)
C
      CALL JEVEUO(CESF//'.CESD','L',JCESFD)
      CALL JEVEUO(CESF//'.CESV','L',JCESFV)
      CALL JEVEUO(CESF//'.CESL','L',JCESFL)
C
C --- RECUPERATION DU NOMBRE DE FISSURES VUES
C
      CALL JEVEUO('&&XTYELE.NBSP','L',JNBSP)

C
C --- RECUPERATION DU NOMBRE DE FONCTIONS HEAVISIDES
C
      CALL JEVEUO('&&XTYELE.NBSP2','L',JNBSP2)
C
C --- CREATION DE LA SD ELNO FISSNO
C
      CALL CESCRE('V',CES,'ELNO',NOMA,'NEUT_I',1,'X1',
     &              IBID,ZI(JNBSP2),-1)
C
      CALL JEVEUO(CES//'.CESD','L',JCESD)
      CALL JEVEUO(CES//'.CESV','E',JCESV)
      CALL JEVEUO(CES//'.CESL','E',JCESL)
C
C --- SI CONTACT, CREATION DE LA SD ELNO HEAVNO
C
      IF (LCONT) THEN
        CALL CESCRE('V',CES2,'ELNO',NOMA,'NEUT_I',1,'X1',
     &              IBID,ZI(JNBSP),-1)
C
        CALL JEVEUO(CES2//'.CESD','L',JCESD2)
        CALL JEVEUO(CES2//'.CESV','E',JCESV2)
        CALL JEVEUO(CES2//'.CESL','E',JCESL2)
      ENDIF
C
C --- INFOS SUR LE MAILLAGE
C
      CALL DISMOI('F','NB_MA_MAILLA',NOMA,'MAILLAGE',NBMA,K8BID,IRET)
      CALL JEVEUO(JEXATR(NOMA//'.CONNEX','LONCUM'),'L',JLCNX)
C
      DO 10 IMA = 1,NBMA
        NFISS = ZI(JNBSP-1+IMA)
        NHEAV = ZI(JNBSP2-1+IMA)
        IF (NFISS.GE.2) THEN
          NBNO = ZI(JLCNX+IMA)-ZI(JLCNX-1+IMA)
          DO 20 INO = 1,NBNO
C
C --- PREMIERE PASSE, ON REMPLIT AVEC LES HEAVISIDES ACTIFS
C
            DO 30 IFISS = 1,NFISS
              CALL CESEXI('S',JCESFD,JCESFL,IMA,INO,IFISS,1,IAD)
              CALL ASSERT(IAD.GT.0)
              IF (ZI(JCESFV-1+IAD).EQ.1) THEN
                DO 40 IHEAV = 1,NHEAV
                  CALL CESEXI('S',JCESD,JCESL,IMA,INO,IHEAV,1,IAD)
                  IF (IAD.LT.0) THEN
                    ZL(JCESL-1-IAD) = .TRUE.
                    ZI(JCESV-1-IAD) = IFISS
                    IF (LCONT) THEN
                      CALL CESEXI('S',JCESD2,JCESL2,IMA,INO,IFISS,1,IAD)
                      CALL ASSERT(IAD.LT.0)
                      ZL(JCESL2-1-IAD) = .TRUE.
                      ZI(JCESV2-1-IAD) = IHEAV
                    ENDIF
                    GOTO 30
                  ENDIF
 40             CONTINUE
              ENDIF
 30         CONTINUE
C
C --- DEUXIEME PASSE, ON REMPLIT AVEC LES HEAVISIDES INACTIFS
C
            DO 50 IFISS = 1,NFISS
              CALL CESEXI('S',JCESFD,JCESFL,IMA,INO,IFISS,1,IAD)
              CALL ASSERT(IAD.GT.0)
              IF (ZI(JCESFV-1+IAD).EQ.0) THEN
                DO 60 IHEAV = 1,NHEAV
                  CALL CESEXI('S',JCESD,JCESL,IMA,INO,IHEAV,1,IAD)
                  IF (IAD.LT.0) THEN
                    ZL(JCESL-1-IAD) = .TRUE.
                    ZI(JCESV-1-IAD) = IFISS
                    IF (LCONT) THEN
                      CALL CESEXI('S',JCESD2,JCESL2,IMA,INO,IFISS,1,IAD)
                      CALL ASSERT(IAD.LT.0)
                      ZL(JCESL2-1-IAD) = .TRUE.
                      ZI(JCESV2-1-IAD) = IHEAV
                    ENDIF
                    GOTO 50
                  ENDIF
 60             CONTINUE
              ENDIF
 50         CONTINUE
C
C --- FIN DES DEUX PASSES, FISSNO EST DEFINI ENTIEREMENT POUR LE NOEUD
C ---                      HEAVNO N'EST PAS COMPLET
C
 20       CONTINUE
        ENDIF
 10   CONTINUE
C
C --- CONVERSION CHAM_ELEM_S -> CHAM_ELEM
C
      CALL CESCEL(CES,LIGREL,'FULL_MECA','PFISNO','NON',NNCP,'G',FISSNO,
     &            'F',IBID)
      CALL DETRSD('CHAM_ELEM_S',CES)
      IF (LCONT) THEN
        CALL CESCEL(CES2,LIGREL,'FULL_MECA','PHEAVNO','NAN',NNCP,'G',
     &            HEAVNO,'F',IBID)
        CALL DETRSD('CHAM_ELEM_S',CES2)
      ENDIF
      CALL DETRSD('CHAM_ELEM_S',CESF)
      CALL JEDEMA()
      END
