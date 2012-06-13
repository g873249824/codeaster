      SUBROUTINE VECHBN(MDGENE,NOMNO1,SST1,NOMNO2,SST2)
      IMPLICIT REAL*8 (A-H,O-Z)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C
C     BUT: S'ASSURER QUE LA DEFINITION DES NON-LINEARITES EST COMPATIBLE
C          AVEC LA DEFINITION DU MODELE GENERALISE
C
C ----------------------------------------------------------------------
C
C
C
      INCLUDE 'jeveux.h'
C
C
      CHARACTER*8   NOMNO1,NOMNO2,SST1,SST2,SS1,SS2,MACRO1,MACRO2
      CHARACTER*8   LIAI1,LIAI2,NOEUD1,NOEUD2,K8BID
      CHARACTER*24  MDGENE,MDLIAI,MDNOMS,BAMO1,BAMO2,INTF1,INTF2
      CHARACTER*24 VALK(4)
      CHARACTER*24  LINO1,LINO2,MAYA1,MAYA2
C
C-----------------------------------------------------------------------
C
C --- LES SOUS-STRUCTURES SST1 ET SST2 SONT-ELLES LIAISONNEES
C
      CALL JEMARQ()
      MDLIAI = MDGENE(1:14)//'.MODG.LIDF'
      MDNOMS = MDGENE(1:14)//'.MODG.SSME'
C
      K8BID = '        '
      CALL JELIRA(MDLIAI,'NUTIOC',NBLIAI,K8BID)
C
      DO 10 ILIAI=1,NBLIAI
        CALL JEVEUO(JEXNUM(MDLIAI,ILIAI),'L',LLIAI)
        SS1 = ZK8(LLIAI)
        SS2 = ZK8(LLIAI+2)
C
        IF ((SS1.EQ.SST1.AND.SS2.EQ.SST2).OR.
     &      (SS1.EQ.SST2.AND.SS2.EQ.SST1)) THEN
          LIAI1 = ZK8(LLIAI+1)
          LIAI2 = ZK8(LLIAI+3)
          CALL JENONU(JEXNOM(MDNOMS(1:19)//'.SSNO',SS1),IBID)
          CALL JEVEUO(JEXNUM(MDNOMS,IBID),'L',LLNOM1)
          CALL JENONU(JEXNOM(MDNOMS(1:19)//'.SSNO',SS2),IBID)
          CALL JEVEUO(JEXNUM(MDNOMS,IBID),'L',LLNOM2)
          MACRO1 = ZK8(LLNOM1)
          MACRO2 = ZK8(LLNOM2)
          CALL JEVEUO(MACRO1//'.MAEL_MASS_REFE','L',LMACR1)
          CALL JEVEUO(MACRO2//'.MAEL_MASS_REFE','L',LMACR2)
          BAMO1 = ZK24(LMACR1)
          BAMO2 = ZK24(LMACR2)
          CALL JEVEUO(BAMO1(1:19)//'.REFD','L',LBAMO1)
          CALL JEVEUO(BAMO2(1:19)//'.REFD','L',LBAMO2)
          INTF1 = ZK24(LBAMO1+4)
          INTF2 = ZK24(LBAMO2+4)
          LINO1 = INTF1(1:8)//'.IDC_LINO'
          LINO2 = INTF2(1:8)//'.IDC_LINO'
          CALL JENONU(JEXNOM(LINO1(1:13)//'NOMS',LIAI1),IBID)
          CALL JEVEUO(JEXNUM(LINO1,IBID),'L',LLINO1)
          CALL JENONU(JEXNOM(LINO2(1:13)//'NOMS',LIAI2),IBID)
          CALL JEVEUO(JEXNUM(LINO2,IBID),'L',LLINO2)
          K8BID = '        '
          CALL JELIRA(JEXNUM(LINO2,IBID),'LONMAX',NBNOEU,K8BID)
          CALL JEVEUO(INTF1(1:8)//'.IDC_DEFO','L',LDEFO1)
          CALL JEVEUO(INTF2(1:8)//'.IDC_DEFO','L',LDEFO2)
          CALL JEVEUO(INTF1(1:8)//'.IDC_REFE','L',LREFE1)
          CALL JEVEUO(INTF2(1:8)//'.IDC_REFE','L',LREFE2)
          MAYA1 = ZK24(LREFE1)(1:8)//'.NOMNOE'
          MAYA2 = ZK24(LREFE2)(1:8)//'.NOMNOE'
C
C ------- LES NOEUDS NOMNO1 ET NOMNO2 SONT-ILS LIAISONNES
C
          DO 20 INOEU=1,NBNOEU
            JLINO1 = ZI(LLINO1-1+INOEU)
            JLINO2 = ZI(LLINO2-1+INOEU)
            JNOEU1 = ZI(LDEFO1+JLINO1-1)
            JNOEU2 = ZI(LDEFO2+JLINO2-1)
            CALL JENUNO(JEXNUM(MAYA1,JNOEU1),NOEUD1)
            CALL JENUNO(JEXNUM(MAYA2,JNOEU2),NOEUD2)
C
            IF ((SS1.EQ.SST1.AND.SS2.EQ.SST2.AND.
     &           NOMNO1.EQ.NOEUD1.AND.NOMNO2.EQ.NOEUD2).OR.
     &          (SS1.EQ.SST2.AND.SS2.EQ.SST1.AND.
     &           NOMNO1.EQ.NOEUD2.AND.NOMNO2.EQ.NOEUD1)) THEN
C
       VALK (1) = NOMNO1
       VALK (2) = SST1
       VALK (3) = NOMNO2
       VALK (4) = SST2
       CALL U2MESG('F', 'ALGORITH14_69',4,VALK,0,0,0,0.D0)
C
            ENDIF
C
20        CONTINUE
C
        ENDIF
C
10    CONTINUE
C
      CALL JEDEMA()
      END
