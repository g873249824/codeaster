       SUBROUTINE CFACAT(NDIM  ,INDIC ,NBLIAC,AJLIAI,SPLIAI,
     &                   LLF   ,LLF1  ,LLF2  ,INDFAC,NESMAX,
     &                   DEFICO,RESOCO,LMAT  ,NBLIAI,XJVMAX)
C 
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
       IMPLICIT      NONE
       INTEGER       NBLIAI,NBLIAC,LLF,LLF1,LLF2
       INTEGER       NDIM  ,INDIC ,AJLIAI, SPLIAI
       INTEGER       INDFAC,NESMAX,LMAT
       REAL*8        XJVMAX
       CHARACTER*24  DEFICO,RESOCO
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
C
C ROUTINE MERE POUR LE CALCUL DE A.C-1.AT
C
C ----------------------------------------------------------------------
C
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  LMAT   : DESCRIPTEUR DE LA MATR_ASSE DU SYSTEME MECANIQUE
C IN  NBLIAI : NOMBRE DE LIAISONS DE CONTACT POSSIBLES
C IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
C I/O AJLIAI : INDICE DANS LA LISTE DES LIAISONS ACTIVES DE LA DERNIERE
C              LIAISON CORRECTE DU CALCUL
C              DE LA MATRICE DE CONTACT ACM1AT
C I/O XJVMAX : VALEUR DU PIVOT MAX
C I/O SPLIAI : INDICE DANS LA LISTE DES LIAISONS ACTIVES DE LA DERNIERE
C              LIAISON AYANT ETE CALCULEE POUR LE VECTEUR CM1A
C IN  NESMAX : NOMBRE MAX DE NOEUDS ESCLAVES
C              (SERT A DECALER LES POINTEURS POUR LE FROTTEMENT 3D)
C IN  LLF    : NOMBRE DE LIAISONS DE FROTTEMENT (EN 2D)
C              NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LES DEUX
C               DIRECTIONS SIMULTANEES (EN 3D)
C IN  LLF1   : NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LA
C               PREMIERE DIRECTION (EN 3D)
C IN  LLF2   : NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LA
C               SECONDE DIRECTION (EN 3D)
C I/O INDFAC : INDICE DE DEBUT DE LA FACTORISATION
C I/O INDIC  : +1 ON A RAJOUTE UNE LIAISON
C              -1 ON A ENLEVE UNE LIAISON
C      
C ----------------------------------------------------------------------
C
       IF (INDIC.NE.-1) THEN
         CALL CFACA1(NDIM  ,NBLIAC,AJLIAI,LLF   ,LLF1  , 
     &               LLF2  ,NESMAX,DEFICO,RESOCO,LMAT  ,
     &               NBLIAI)
       ENDIF
       CALL CFACA2(NDIM  ,NBLIAC,SPLIAI,LLF   ,LLF1  ,
     &             LLF2  ,INDFAC,NESMAX,RESOCO,LMAT  , 
     &             NBLIAI,XJVMAX)
C  
       INDIC = 1
C
       END
