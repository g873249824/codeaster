      SUBROUTINE ARLCVP(NOMARL,CHARGE,MAIL  ,BASE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*1 BASE
      CHARACTER*8 MAIL
      CHARACTER*8 CHARGE
      CHARACTER*8 NOMARL
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CREATION DU VECTEUR DE PONDERATION DES MAILLES
C
C ----------------------------------------------------------------------
C
C IN  CHARGE : NOM DE LA CHARGE ARLEQUIN
C IN  MAIL   : NOM UTILISATEUR DU MAILLAGE
C IN  BASE   : TYPE DE BASE ('V' OU 'G')
C IN  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
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
      INTEGER      JDIME,JPOIM,JNOM
      INTEGER      NMA,IMA   
      CHARACTER*24 NOMPOI  
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- LONGUEURS
C
      CALL JEVEUO(MAIL(1:8)//'.DIME','L',JDIME)
      NMA = ZI(JDIME+2)
C
C --- CREATION VECTEUR JEVEUX
C
      NOMPOI = CHARGE(1:8)//'.POIDS_MAILLE'
      CALL WKVECT(NOMPOI,BASE//' V R',NMA,JPOIM)
      CALL JEVEUO(NOMARL(1:8)//'.POIDS','E',JNOM)
      ZK24(JNOM) = NOMPOI
C
C --- QUELQUES INITIALISATIONS ELEMENTAIRES
C
      DO 20 IMA = 1, NMA
        ZR(JPOIM-1+IMA) = 1.D0
 20   CONTINUE     
C
      CALL JEDEMA()
      END
