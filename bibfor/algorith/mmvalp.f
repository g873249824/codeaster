      SUBROUTINE MMVALP(NDIM  ,ALIAS ,NNO   ,NCMP  ,KSI1  ,
     &                  KSI2  ,VALEND,VALEPT)
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      INTEGER      NDIM,NNO,NCMP
      CHARACTER*8  ALIAS
      REAL*8       KSI1,KSI2
      REAL*8       VALEND(*),VALEPT(*)

C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C CALCUL D'UNE COMPOSANTE D'UN CHAMP EN UN POINT DONNE D'UNE MAILLE
C
C ----------------------------------------------------------------------
C
C
C IN  ALIAS  : NOM D'ALIAS DE L'ELEMENT
C IN  NNO    : NOMBRE DE NOEUD DE L'ELEMENT
C IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
C IN  NCMP   : NOMBRE DE COMPOSANTE
C IN  KSI1   : COORDONNEE KSI1 SUR LA MAILLE
C IN  KSI2   : COORDONNEE KSI2 SUR LA MAILLE
C IN  VALEND : VALEUR DU CHAMP AUX NOEUDS
C OUT VALEPT : VALEUR DU CHAMP SUR LE POINT
C
C
C
C
      REAL*8      FF(9)
      INTEGER     INO,ICMP
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      DO 1 ICMP = 1,NCMP
        VALEPT(ICMP) = 0.D0
   1  CONTINUE
      CALL ASSERT(NNO.LE.9)
C
C --- FONCTIONS DE FORME
C
      CALL MMNONF(NDIM  ,NNO   ,ALIAS ,KSI1,KSI2,
     &            FF    )
C
C --- CALCUL
C
      DO 40 ICMP = 1,NCMP
        DO 10 INO = 1,NNO
          VALEPT(ICMP) = FF(INO)*VALEND((INO-1)*NCMP+ICMP) +
     &                   VALEPT(ICMP)
   10   CONTINUE
   40 CONTINUE
C
      CALL JEDEMA()
      END
