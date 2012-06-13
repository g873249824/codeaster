      SUBROUTINE LISCVA(PREFOB,CHAMNO)
C
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*13 PREFOB
      CHARACTER*19 CHAMNO
C
C ----------------------------------------------------------------------
C
C ROUTINE UTILITAIRE (LISTE_CHARGES)
C
C DONNE LE NOM DU CHAM_NO
C
C ----------------------------------------------------------------------
C
C CETTE ROUTINE EST OBLIGATOIRE TANT QUE L'ON A DES VRAIS VECT_ASSE
C ET DES FAUX
C VRAIS VECT_ASSE: DANS LES OPERATEURS DE DYNAMIQUE
C FAUX  VECT_ASSE: LE CHAMP EST STOCKE DANS UN OBJET CREE DANS
C                  AFFE_CHAR_MECA
C
C IN  PREFOB : PREFIXE DE L'OBJET DE LA CHARGE
C OUT CHAMNO : NOM DU CHAMP
C
C
C
C
      CHARACTER*8  CHARGE
      CHARACTER*24 NOMOBJ
      INTEGER      JOBJE,IRET
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      CHAMNO = ' '
      CHARGE = PREFOB(1:8)
C
C --- ON IDENTIFIE
C
      CALL EXISD('CHAM_NO',CHARGE,IRET)
      IF (IRET.EQ.1) THEN
        CHAMNO = CHARGE
      ELSE
        NOMOBJ = PREFOB(1:13)//'.VEASS'
        CALL JEEXIN(NOMOBJ,IRET)
        CALL ASSERT(IRET.NE.0)
        CALL JEVEUO(NOMOBJ,'L',JOBJE)
        CHAMNO = ZK8(JOBJE)
        CALL EXISD('CHAM_NO',CHAMNO,IRET)
        CALL ASSERT(IRET.EQ.0)
      ENDIF
C
      CALL JEDEMA()
      END
