      SUBROUTINE ACEACA(NOMU,NOMA,LMAX,NBOCC)
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      INTEGER                     LMAX,NBOCC
      CHARACTER*8       NOMU,NOMA
C ----------------------------------------------------------------------
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ----------------------------------------------------------------------
C     AFFE_CARA_ELEM
C     AFFECTATION DES CARACTERISTIQUES POUR L'ELEMENT CABLE
C ----------------------------------------------------------------------
C IN  : NOMU   : NOM UTILISATEUR DE LA COMMANDE
C IN  : NOMA   : NOM DU MAILLAGE
C IN  : LMAX   : NOMBRE MAX DE MAILLES OU GROUPE DE MAILLES
C IN  : NBOCC  : NOMBRE D'OCCURENCE DE NOT CLE CABLE
C ----------------------------------------------------------------------
      REAL*8       SCT,TENS
      CHARACTER*8  FCX
      CHARACTER*19 CARTCA,CARTCF
      CHARACTER*24 TMPNCA, TMPVCA,TMPNCF, TMPVCF
      INTEGER      IARG
C     ------------------------------------------------------------------
C
C --- CONSTRUCTION DES CARTES ET ALLOCATION
      CALL JEMARQ()
      CARTCA = NOMU//'.CARCABLE'
      TMPNCA = CARTCA//'.NCMP'
      TMPVCA = CARTCA//'.VALV'
      CALL ALCART('G',CARTCA,NOMA,'CACABL')
      CALL JEVEUO(TMPNCA,'E',JDCC)
      CALL JEVEUO(TMPVCA,'E',JDVC)

      CARTCF = NOMU//'.CVENTCXF'
      TMPNCF = CARTCF//'.NCMP'
      TMPVCF = CARTCF//'.VALV'
      CALL JEVEUO(TMPNCF,'E',JDCCF)
      CALL JEVEUO(TMPVCF,'E',JDVCF)
C
      CALL WKVECT('&&TMPCABLE','V V K8',LMAX,JDLS)
C
      ZK8(JDCC)   = 'SECT'
      ZK8(JDCC+1) = 'TENS'
C
      ZK8(JDCCF)  = 'FCXP'

C
C --- LECTURE DES VALEURS ET AFFECTATION DANS LA CARTE CARTCA
      DO 10 IOC = 1 , NBOCC
         SCT = 0.D0
         CALL GETVEM(NOMA,'GROUP_MA','CABLE','GROUP_MA',
     +           IOC,IARG,LMAX,ZK8(JDLS),NG)
         CALL GETVEM(NOMA,'MAILLE','CABLE','MAILLE',
     +         IOC,IARG,LMAX,ZK8(JDLS),NM)

         CALL GETVR8('CABLE','SECTION' ,IOC,IARG,1,SCT,NV)
         IF (NV.EQ.0) THEN
           CALL GETVR8('CABLE','A' ,IOC,IARG,1,SCT,NV)
         ENDIF
         ZR(JDVC)   = SCT
         CALL GETVR8('CABLE','N_INIT',IOC,IARG,1,TENS ,NT)
         ZR(JDVC+1)   = TENS

         FCX = '.'
         CALL GETVID('CABLE','FCX',IOC,IARG,1,FCX,NFCX)
         ZK8(JDVCF) = FCX

C ---    "GROUP_MA" = TOUTES LES MAILLES DE LA LISTE DE GROUPES MAILLES
         IF (NG.GT.0) THEN
            DO 20 I = 1 , NG
              CALL NOCART(CARTCA ,2,ZK8(JDLS+I-1),' ',0,' ',0,' ',2)
              CALL NOCART(CARTCF,2,ZK8(JDLS+I-1),' ',0,' ',0,' ',1)
 20         CONTINUE
         ENDIF
C
C -      "MAILLE" = TOUTES LES MAILLES DE LA LISTE DE MAILLES
C
         IF (NM.GT.0) THEN
            CALL NOCART(CARTCA ,3,' ','NOM',NM,ZK8(JDLS),0,' ',2)
            CALL NOCART(CARTCF,3,' ','NOM',NM,ZK8(JDLS),0,' ',1)
         ENDIF
C
 10   CONTINUE
C
      CALL JEDETR('&&TMPCABLE')
      CALL JEDETR(TMPNCA)
      CALL JEDETR(TMPVCA)
C
      CALL JEDEMA()
      END
