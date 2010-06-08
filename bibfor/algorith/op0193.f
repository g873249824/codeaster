      SUBROUTINE OP0193 ( IER )
      IMPLICIT   NONE
      INTEGER             IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/10/2004   AUTEUR REZETTE C.REZETTE 
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
C     OPERATEUR  PROJ_MESU_MODAL
C     
C     EXTRAPOLATION DE RESULTATS DE MESURES EXPERIMENTALES SUR UN MODELE
C     NUMERIQUE EN DYNAMIQUE
C     ------------------------------------------------------------------
C
      INTEGER      N1 , NBMESU , NBMODE
C
      CHARACTER*8  BASEMO, NOMMES
      CHARACTER*24  VRANGE,VNOEUD,BASEPR
C
CDEB
C
      CALL JEMARQ ( ) 
      CALL INFMAJ()
C
C --- RECUPERATION DE LA BASE DE PROJECTION ---
C
      CALL GETVID ('MODELE_CALCUL','BASE',1,1,1,BASEMO,N1)
C
C --- RECUPERATION DE LA MESURE
C
      CALL GETVID ('MODELE_MESURE','MESURE',1,1,1,NOMMES,N1)
C
C --- PROJECTION SUR LE MODELE NUMERIQUE
C
      CALL MPMOD2 (BASEMO,NOMMES,NBMESU,NBMODE,BASEPR,VNOEUD,VRANGE)
C
C --- ECRITURE SD RESULTAT (TRAN_GENE)
C
      CALL MPTRAN (BASEMO,NOMMES,NBMESU,NBMODE,BASEPR,VNOEUD,VRANGE)
C
      CALL JEDEMA ( ) 
C
      END
