      SUBROUTINE ARLMOD(MAIL  ,NOMO  ,NDIM  ,MAILAR,MODARL,
     &                  TABCOR) 
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8  MAILAR,MODARL
      CHARACTER*8  MAIL,NOMO      
      INTEGER      NDIM   
      CHARACTER*24 TABCOR             
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CREATION DU PSEUDO-MODELE  
C
C ----------------------------------------------------------------------
C
C
C IN  MAIL   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C IN  MAILAR : NOM DU PSEUDO-MAILLAGE
C IN  NDIM   : NDIMNSION DU PROBLEME
C IN  TABCOR : TABLEAU DE CORRESPONDANCE 
C            POUR CHAQUE NOUVEAU NUMERO ABSOLU DANS MAILAR 
C             -> ANCIEN NUMERO ABSOLU DANS MAIL
C             -> SI NEGATIF, LA NOUVELLE MAILLE EST ISSUE D'UNE
C                DECOUPE DE LA MAILLE DE NUMERO ABSOLU ABS(NUM) DANS
C                MAIL
C IN  MODARL : NOM DU PSEUDO-MODELE
C
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C      
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      CALL JEMARQ()
C
C --- NOM DES SDS TEMPORAIRES
C
      MODARL = '&&ARL.MO'      
C
C --- CREATION DU LIGREL DU PSEUDO-MODELE  
C           
      CALL ARLMOL(MAIL  ,NOMO  ,NDIM  ,MAILAR,MODARL,
     &            TABCOR)
C
C --- CREATION DU PSEUDO-MODELE  
C           
      CALL ARLMOM(MAILAR,MODARL)                    
C
      CALL JEDEMA()

      END
