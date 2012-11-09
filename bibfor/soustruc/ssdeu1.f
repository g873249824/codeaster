      SUBROUTINE SSDEU1(MOTCLE,NOMA,NBNO,ILISTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SOUSTRUC  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
      IMPLICIT NONE
C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNOM
      CHARACTER*(*) MOTCLE
      CHARACTER*8   NOMA
      INTEGER NBNO,ILISTE(*)
C ----------------------------------------------------------------------
C     BUT:
C        - TRAITER LES MOTS CLEFS "GROUP_NO" ET "NOEUD" DE
C          EXTERIEUR DE LA COMMANDE MACR_ELEM_STAT.
C        - COMPTER LES NOEUDS TROUVES , EN ETABLIR LA LISTE.
C
C     IN:
C        MOTCLE: 'NOMBRE' --> ON REND LE NOMBRE DE NOEUDS UNIQUEMENT.
C                'LISTE ' --> ON REND LE NOMBRE ET LA LISTE.
C        NOMA  : NOM DU MAILLAGE
C     OUT:
C        NBNO  :  NOMBRE DE NOEUDS TROUVES.
C        ILISTE:  LISTE DES NUMEROS DE NOEUDS TROUVES
C                 (SI MOTCLE='LISTE' SEULEMENT.)
C
      CHARACTER*8  KBI81,KBID
      CHARACTER*24 VALK(2)
      INTEGER      IARG
C ----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER I ,IAGPNO ,IAWK1 ,IBID ,ICO ,II ,IRET
      INTEGER N1 ,N2 ,N3 ,N4 ,NDIM
C-----------------------------------------------------------------------
      CALL JEMARQ()
      NBNO=0
C
C
C
      CALL JEEXIN('&&SSDEU1.WK1',IRET)
      IF (IRET.LE.0) THEN
         NDIM=100
         CALL WKVECT('&&SSDEU1.WK1','V V K8',NDIM,IAWK1)
      ELSE
         CALL JELIRA('&&SSDEU1.WK1','LONMAX',NDIM,KBID)
         CALL JEVEUO('&&SSDEU1.WK1','E',IAWK1)
      END IF
C
C
C     --CAS NOEUD:
C     ------------
      CALL GETVEM(NOMA,'NOEUD','EXTERIEUR','NOEUD',
     &         1,IARG,0,KBI81,N1)
      IF (N1.NE.0) THEN
         N3=-N1
         IF (NDIM.LT.N3) THEN
            CALL JEDETR('&&SSDEU1.WK1')
            CALL WKVECT('&&SSDEU1.WK1','V V K8',2*N3,IAWK1)
         END IF
         CALL GETVEM(NOMA,'NOEUD','EXTERIEUR','NOEUD',
     &            1,IARG,N3,ZK8(IAWK1),IBID)
         NBNO=NBNO+N3
         IF (MOTCLE.EQ.'LISTE') THEN
           DO 100 I=1,N3
             CALL JENONU(JEXNOM(NOMA//'.NOMNOE',ZK8(IAWK1-1+I)),
     &                    ILISTE(I))
             IF (ILISTE(I).EQ.0) THEN
                VALK(1) = ZK8(IAWK1-1+I)
                VALK(2) = NOMA
                CALL U2MESK('F','SOUSTRUC_48', 2 ,VALK)
             ENDIF
 100       CONTINUE
         END IF
      END IF
C
C
C     --CAS GROUP_NO:
C     ---------------
      CALL GETVEM(NOMA,'GROUP_NO','EXTERIEUR','GROUP_NO',
     &            1,IARG,0,KBI81,N2)
      IF (N2.NE.0) THEN
         N3=-N2
         IF (NDIM.LT.N3) THEN
            CALL JEDETR('&&SSDEU1.WK1')
            CALL WKVECT('&&SSDEU1.WK1','V V K8',2*N3,IAWK1)
         END IF
         CALL GETVEM(NOMA,'GROUP_NO','EXTERIEUR','GROUP_NO',
     &               1,IARG,N3,ZK8(IAWK1),IBID)
         ICO=NBNO
         DO 101 I=1,N3
            CALL JEEXIN(JEXNOM(NOMA//'.GROUPENO',ZK8(IAWK1-1+I)),IRET)
            IF (IRET.EQ.0) THEN
               VALK(1) = ZK8(IAWK1-1+I)
               VALK(2) = NOMA
               CALL U2MESK('F','SOUSTRUC_49', 2 ,VALK)
            ENDIF
            CALL JELIRA(JEXNOM(NOMA//'.GROUPENO',ZK8(IAWK1-1+I)),
     &                  'LONMAX',N4,KBID)
            NBNO= NBNO+N4
            IF (MOTCLE.EQ.'LISTE') THEN
               CALL JEVEUO(JEXNOM(NOMA//'.GROUPENO',ZK8(IAWK1-1+I)),
     &                  'L',IAGPNO)
               DO 102 II=1,N4
                  ICO= ICO+1
                  ILISTE(ICO)=  ZI(IAGPNO-1+II)
 102           CONTINUE
            END IF
 101     CONTINUE
      END IF
C
C
C
      CALL JEDEMA()
      END
