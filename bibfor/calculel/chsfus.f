      SUBROUTINE CHSFUS(NBCHS,LICHS,LCUMUL,LCOEFR,LCOEFC,LCOC,BASE,CHS3)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/09/2006   AUTEUR REZETTE C.REZETTE 
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
C RESPONSABLE VABHHTS J.PELLET
C A_UTIL
      IMPLICIT NONE
      INTEGER NBCHS
      CHARACTER*(*) LICHS(NBCHS),CHS3,BASE
      LOGICAL LCUMUL(NBCHS),LCOC
      REAL*8 LCOEFR(NBCHS)
      COMPLEX*16 LCOEFC(NBCHS)
C ---------------------------------------------------------------------
C BUT: FUSIONNER UNE LISTE DE CHAMP_S (CHAM_ELEM_S OU CHAM_NO_S)
C      POUR EN FORMER 1 CHAMP_S
C ---------------------------------------------------------------------
C     ARGUMENTS:
C NBCHS   IN       I      : NOMBRE DE CHAMP_S A FUSIONNER
C LICHS   IN/JXIN  V(K19) : LISTE DES SD CHAMP_S A FUSIONNER
C LCUMUL  IN       V(L)   : V(I) =.TRUE. => ON ADDITIONNE LE CHAMP I
C                         : V(I) =.FALSE. => ON SURCHARGE LE CHAMP I
C LCOEFR  IN       V(R)   : LISTE DES COEF. MULT. DES VALEURS DES CHAMPS
C LCOEFC  IN       V(C)   : LISTE DES COEF. MULT. DES VALEURS DES CHAMPS
C LCOC    IN       L      : =TRUE SI COEF COMPLEXE 
C CHS3    IN/JXOUT K19    : SD CHAMP_S RESULTAT
C BASE    IN       K1     : BASE DE CREATION POUR CHS3 : G/V/L

C REMARQUES :

C- LES CHAMP_S DE LICHS DOIVENT ETRE DE LA MEME GRANDEUR,S'APPUYER
C  SUR LE MEME MAILLAGE ET ETRE DE MEME TYPE (NOEU/CART/ELGA/ELNO).
C  POUR LES CHAM_ELEM_S :
C  DANS TOUS LES CHAM_ELEM_S, CHAQUE MAILLE DOIT AVOIR LE MEME
C  NOMBRE DE POINTS (NOEUD OU GAUSS) ET LE MEME NOMBRE DE SOUS-POINTS.

C- L'ORDRE DES CHAMP_S DANS LICHS EST IMPORTANT :
C  LES CHAMP_S SE SURCHARGENT LES UNS LES AUTRES

C- ON PEUT APPELER CETTE ROUTINE MEME SI CHS3 APPARTIENT
C  A LA LISTE LICHS (CHAMP_S IN/OUT)
C ---------------------------------------------------------------------

      CHARACTER*19 CHS
      INTEGER I1,I2,K,J1,J2

      J1 = 0
      J2 = 0
      DO 10,K = 1,NBCHS
        CHS = LICHS(K)
        CALL EXISD('CHAM_NO_S',CHS,I1)
        CALL EXISD('CHAM_ELEM_S',CHS,I2)
        J1 = MAX(J1,I1)
        J2 = MAX(J2,I2)
   10 CONTINUE
      IF (J1*J2.NE.0) CALL UTMESS('F','CHSFUS',
     &                            'MELANGE DE CHAM_ELEM_S ET CHAM_NO_S '
     &                            )

      IF(J1.GT.0)
     &   CALL CNSFUS(NBCHS,LICHS,LCUMUL,LCOEFR,LCOEFC,LCOC,BASE,CHS3)
      IF(J2.GT.0)
     &   CALL CESFUS(NBCHS,LICHS,LCUMUL,LCOEFR,LCOEFC,LCOC,BASE,CHS3)
      END
