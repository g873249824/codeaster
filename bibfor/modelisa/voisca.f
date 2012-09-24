      SUBROUTINE VOISCA(MAILLA,NBNOBE,NUNOBE,COMIMA,NBNOBI,NUNOBI)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 25/09/2012   AUTEUR CHEIGNON E.CHEIGNON 
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
C-----------------------------------------------------------------------
C  DESCRIPTION : SELECTION DANS LA LISTE NUNOBE DES NOEUDS DE BETON
C  -----------   APPARTENANT AU PAVE DEFINI PAR LES COORDONNEES EXTREMES
C                CONTENUES DANS COMIMA.
C
C  IN     : MAILLA : CHARACTER*8 , SCALAIRE
C                    NOM DU CONCEPT MAILLAGE ASSOCIE A L'ETUDE
C  IN     : NBNOBE : INTEGER , SCALAIRE
C                    NOMBRE DE NOEUDS APPARTENANT A LA STRUCTURE BETON
C  IN     : NUNOBE : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR D'ENTIERS POUR STOCKAGE DES
C                    NUMEROS DES NOEUDS APPARTENANT A LA STRUCTURE BETON
C  IN     : COMIMA : CHARACTER*24
C                    NOM DU VECTEUR CONTENANT LES 6 COORDONNEES
C                    EXTREME QUI CONSTITUENT LE PAVE DANS LEQUEL
C                    EST CONTENU LE CALBLE
C  OUT    : NBNOBI : INTEGER , SCALAIRE
C                    NOMBRE DE NOEUDS DE BETONAPPARTENANT A LA SELECTION
C  OUT    : NUNOBI : CHARACTER*19 , SCALAIRE
C                    NOM D'UN VECTEUR D'ENTIERS POUR STOCKAGE DES
C                    NUMEROS DES NOEUDS APPARTENANT A LA SELECTION

C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      CHARACTER*8   MAILLA
      CHARACTER*19  NUNOBE,NUNOBI
      CHARACTER*24  COMIMA
      INTEGER       NBNOBE,NBNOBI
C
C VARIABLES LOCALES
C -----------------
      INCLUDE 'jeveux.h'
      INTEGER       JCOOR
      REAL*8        XMIN,XMAX,YMIN,YMAX,ZMIN,ZMAX,X,Y,Z

      CHARACTER*24  COORNO, NONOCA, NONOMA
C
      INTEGER       NBSUB,INUBE,INUBI,ICOMM,NOEBE,I,J

C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
      CALL JEMARQ()
      CALL JEVEUO(NUNOBE,'L',INUBE)
      CALL JEVEUO(NUNOBI,'E',INUBI)
      CALL JEVEUO(COMIMA,'L',ICOMM)
      COORNO = MAILLA//'.COORDO    .VALE'
      CALL JEVEUO(COORNO,'L',JCOOR)

      XMIN = ZR(ICOMM-1+1)
      XMAX = ZR(ICOMM-1+2)
      YMIN = ZR(ICOMM-1+3)
      YMAX = ZR(ICOMM-1+4)
      ZMIN = ZR(ICOMM-1+5)
      ZMAX = ZR(ICOMM-1+6)

C     SELECTION DES NOEUDS APPARTENANT AU PAVE FORME PAR LES
C     COORDONNEES EXTREMES DES NOEUDS DU CABLE
      J=0
      DO 10 I=1,NBNOBE
        NOEBE = ZI(INUBE-1+I)
        X = ZR(JCOOR+3*(NOEBE-1)  )
        Y = ZR(JCOOR+3*(NOEBE-1)+1)
        Z = ZR(JCOOR+3*(NOEBE-1)+2)
        IF (X.LT.XMIN) GOTO 10
        IF (X.GT.XMAX) GOTO 10
        IF (Y.LT.YMIN) GOTO 10
        IF (Y.GT.YMAX) GOTO 10
        IF (Z.LT.ZMIN) GOTO 10
        IF (Z.GT.ZMAX) GOTO 10

        ZI(INUBI+J) = NOEBE
        J = J+1
10    CONTINUE
      NBNOBI=J

      CALL JEDEMA()
      END
