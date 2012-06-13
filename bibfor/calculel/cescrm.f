      SUBROUTINE CESCRM(BASEZ,CESZ,TYPCEZ,NOMGDZ,NCMPG,LICMP,CESMZ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER       NCMPG
      CHARACTER*(*) CESZ,BASEZ,TYPCEZ,NOMGDZ,CESMZ
      CHARACTER*(*) LICMP(*)
C ----------------------------------------------------------------------
C BUT : CREER UN CHAM_ELEM_S VIERGE (CESZ) EN PRENANT CESM COMME MODELE
C       PROCHE DE CESCRE : ON CREE UN CHAMP AYANT LA MEME TOPOLOGIE
C       (MEME MAILLAGE, MEME NBRE DE POINTS ET SOUS-POINTS PAR MAILLE).
C ----------------------------------------------------------------------
C     ARGUMENTS:
C BASEZ   IN       K1  : BASE DE CREATION POUR CESZ : G/V/L
C CESZ    IN/JXOUT K19 : SD CHAM_ELEM_S A CREER
C TYPCEZ  IN       K4  : TYPE DU CHAM_ELEM_S :
C                        / 'ELNO'
C                        / 'ELGA'
C                        / 'ELEM'
C NOMGDZ  IN       K8  : NOM DE LA GRANDEUR DE CESZ
C NCMPG   IN       I   : DIMENSION DE LICMP
C LICMP   IN       L_K8: NOMS DES CMPS VOULUES DANS CESZ
C CESMZ   IN       K19 : NOM DU CHAMP SIMPLE QUI SERT DE MODELE
C
C     ------------------------------------------------------------------
C     VARIABLES LOCALES:
C     ------------------
      INTEGER      I, IMA, NBMA
      INTEGER      J1, J2, JCHSD, JCHSK, JCMPS
      CHARACTER*1  BASE
      CHARACTER*4  CNUM
      CHARACTER*4  TYPCES
      CHARACTER*8  NOMGD
      CHARACTER*19 CES, CESM, WK1, WK2, CMPS
C     ------------------------------------------------------------------

      CALL JEMARQ()
      BASE = BASEZ
      CES = CESZ
      TYPCES = TYPCEZ
      NOMGD = NOMGDZ
      CESM = CESMZ
      WK1 = '&&CESCRM.WK1'
      WK2 = '&&CESCRM.WK2'
      CMPS = '&&CESCRM.LICMP'

      CALL JEVEUO(CESM//'.CESD','L',JCHSD)
      CALL JEVEUO(CESM//'.CESK','L',JCHSK)

C --- RECUPERE LA TOPOLOGIE DU CHAM_ELEM_S MODELE
      NBMA = ZI(JCHSD-1+1)
      CALL WKVECT(WK1, 'V V I',NBMA,J1)
      CALL WKVECT(WK2, 'V V I',NBMA,J2)
      DO 10 IMA=1,NBMA
        ZI(J1-1+IMA) = ZI(JCHSD-1+5+4*(IMA-1)+1)
        ZI(J2-1+IMA) = ZI(JCHSD-1+5+4*(IMA-1)+2)
 10   CONTINUE

C --- VECTEUR DES COMPOSANTES
      CALL WKVECT(CMPS, 'V V K8', NCMPG, JCMPS)
      IF (NOMGD.EQ.'NEUT_R' .AND. LICMP(1)(1:1).EQ.' ') THEN
        DO 20 I=1,NCMPG
          CALL CODENT(I, 'G', CNUM)
          ZK8(JCMPS-1+I) = 'X'//CNUM
 20     CONTINUE
      ELSE
        DO 21 I=1,NCMPG
          CALL ASSERT(LICMP(I).NE.' ')
          ZK8(JCMPS-1+I) = LICMP(I)
 21     CONTINUE
      ENDIF

C --- APPEL A CESCRE
      CALL CESCRE(BASE, CES, TYPCES, ZK8(JCHSK-1+1), NOMGD,
     &            NCMPG, ZK8(JCMPS), ZI(J1), ZI(J2), -NCMPG)

C --- MENAGE
      CALL JEDETR(WK1)
      CALL JEDETR(WK2)
      CALL JEDETR(CMPS)

      CALL JEDEMA()
      END
