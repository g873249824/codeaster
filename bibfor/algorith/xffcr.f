      SUBROUTINE XFFCR(NFON,JFONO,JBASO,JINDPT,JFON,JBAS)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/07/2012   AUTEUR LADIER A.LADIER 
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
      INTEGER       NFON,JFONO,JBASO,JINDPT,JFON,JBAS
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM
C
C              ORDONNANCEMENT DES VECTEURS BASEFOND ET FONDFISS
C
C ----------------------------------------------------------------------
C
C
C IN  NFON  :  NOMBRE DE POINTS AU FOND DE FISSURE
C     JFONO :  ADRESSE DES POINTS DU FOND DE FISSURE DÉSORDONNÉS
C     JBASO :  ADRESSE DES DIRECTIONS DE PROPAGATION DÉSORDONNÉS
C     JINDPT:  ADRESSE DES INDICES DES POINTS ORDONNÉS

C OUT JFON  :  ADRESSE DES POINTS DU FOND DE FISSURE ORDONNÉS
C     JBAS  :  ADRESSE DES DIRECTIONS DE PROPAGATION ORDONNÉS

C
      INTEGER       INDIPT,IPT,K 
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()

      DO 10 IPT=1,NFON

        INDIPT = ZI(JINDPT-1+IPT)

        DO 11 K=1,3

          ZR(JFON-1+4*(IPT-1)+K)   = ZR(JFONO-1+4*(INDIPT-1)+K)
          ZR(JBAS-1+6*(IPT-1)+K)   = ZR(JBASO-1+6*(INDIPT-1)+K)
          ZR(JBAS-1+6*(IPT-1)+K+3) = ZR(JBASO-1+6*(INDIPT-1)+3+K)

 11     CONTINUE

        ZR(JFON-1+4*(IPT-1)+4)   = ZR(JFONO-1+4*(INDIPT-1)+4)

 10   CONTINUE

      CALL JEDEMA()
      END
