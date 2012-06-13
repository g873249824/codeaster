      SUBROUTINE ERMES3(NOE,IFA,TYMVOL,NNOF,TYPMAV,
     &                  IREF1,IVOIS,ISIG,NBCMP,
     &                  DSG11,DSG22,DSG33,DSG12,DSG13,DSG23)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE DELMAS J.DELMAS
C =====================================================================
C  ERREUR EN MECANIQUE - TERME DE SAUT - DIMENSION 3
C  **        **                   *                *
C =====================================================================
C
C     BUT:
C         DEUXIEME TERME DE L'ESTIMATEUR D'ERREUR EN RESIDU EXPLICITE :
C         CALCUL DU SAUT DE CONTRAINTE ENTRE UNE FACE D'UN ELEMENT
C         ET SON VOISIN EN 3D.
C
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   NOE    : LISTE DES NUMEROS DES NOEUDS PAR FACE (VOIR TE0003)
C IN   IFA    : NUMERO LOCAL DE LA FACE
C IN   TYMVOL : NUMERO DU TYPE DE LA MAILLE VOLUMIQUE COURANTE
C               1 : HEXAEDRE; 2 : PENTAEDRE; 3 : TETRAEDRE; 4 : PYRAMIDE
C IN   NNOF   : NOMBRE DE NOEUDS DE LA FACE
C IN   TYPMAV : TYPE DE LA MAILLE VOISINE :
C              'HEXA....', 'TETR....', 'PENT....', 'PYRA....'
C IN   ISIG   : ADRESSE DANS ZR DU TABLEAU DES CONTRAINTES AUX NOEUDS
C IN   NBCMP  : NOMBRE DE COMPOSANTES
C
C      SORTIE :
C-------------
C OUT  DSG11  : SAUT DE CONTRAINTE AUX NOEUDS - COMPOSANTE 11
C OUT  DSG22  : SAUT DE CONTRAINTE AUX NOEUDS - COMPOSANTE 22
C OUT  DSG33  : SAUT DE CONTRAINTE AUX NOEUDS - COMPOSANTE 33
C OUT  DSG12  : SAUT DE CONTRAINTE AUX NOEUDS - COMPOSANTE 12
C OUT  DSG13  : SAUT DE CONTRAINTE AUX NOEUDS - COMPOSANTE 13
C OUT  DSG23  : SAUT DE CONTRAINTE AUX NOEUDS - COMPOSANTE 23
C
C ......................................................................
C
C CORPS DU PROGRAMME
      IMPLICIT NONE
C DECLARATION PARAMETRES D'APPELS
      INCLUDE 'jeveux.h'
      INTEGER NOE(9,6,4),IFA,TYMVOL,NNOF
      INTEGER IREF1,IVOIS,ISIG,NBCMP
      REAL*8 DSG11(9),DSG22(9),DSG33(9),DSG12(9),DSG13(9),DSG23(9)
      CHARACTER*8 TYPMAV




C DECLARATION VARIABLES LOCALES
      INTEGER IAREPE,JCELD,JCELV,ICONX1,ICONX2,JAD,JADV,IMAV,IGREL,IEL
      INTEGER ADIEL,IAVAL,INO,NCHER,INOV,INDIIS,IN
      INTEGER NBNOVO
      INTEGER IAUX, JAUX
C
      REAL*8 SIG11(9),SIG22(9),SIG33(9),SIG12(9),SIG13(9),SIG23(9)
      REAL*8 SIGV11(9),SIGV22(9),SIGV33(9)
      REAL*8 SIGV12(9),SIGV13(9),SIGV23(9)

C ----------------------------------------------------------------------
C ----- NOMBRE DE NOEUDS DE LA MAILLE VOISINE --------------------------
C
      IF (TYPMAV.EQ.'HEXA8') THEN
        NBNOVO=8
      ELSE IF (TYPMAV.EQ.'HEXA20') THEN
        NBNOVO=20
      ELSE IF (TYPMAV.EQ.'HEXA27') THEN
        NBNOVO=27
      ELSE IF (TYPMAV.EQ.'PENTA6') THEN
        NBNOVO=6
      ELSE IF (TYPMAV.EQ.'PENTA15') THEN
        NBNOVO=15
      ELSE IF (TYPMAV.EQ.'PENTA18') THEN
        NBNOVO=18
      ELSE IF (TYPMAV.EQ.'TETRA4') THEN
        NBNOVO=4
      ELSE IF (TYPMAV.EQ.'TETRA10') THEN
        NBNOVO=10
      ELSE IF (TYPMAV.EQ.'PYRAM5') THEN
        NBNOVO=5
      ELSE IF (TYPMAV.EQ.'PYRAM13') THEN
        NBNOVO=13
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
C ----- RECHERCHE DES ADRESSES POUR OBTENIR SIGMA SUR LES VOISINS ------
C
      IAREPE = ZI(IREF1-1+1)
      JCELD  = ZI(IREF1-1+2)
      JCELV  = ZI(IREF1-1+3)
C
      IMAV  = ZI(IVOIS+IFA)
      IGREL = ZI(IAREPE-1+2*(IMAV-1)+1)
      IEL   = ZI(IAREPE-1+2*(IMAV-1)+2)
C
C --- ON VERIFIE QU'IL N'Y A PAS DE SOUS POINT -------------------------
C
      IAUX=JCELD-1+ZI(JCELD-1+4+IGREL)+4+4*(IEL-1)+1
      JAUX=ZI(IAUX)
      CALL ASSERT( (JAUX.EQ.1) .OR. (JAUX.EQ.0) )
C
C --- FORMULES MAGIQUES DONNANT LE BON DECALAGE POUR NAVIGUER DANS .CELV
C
      ADIEL=ZI(IAUX+3)
      IAVAL=JCELV-1+ADIEL
C
C ----- CALCUL DE LA NUMEROTATION DU VOISIN ----------------------------
C
      ICONX1=ZI(IREF1+10)
      ICONX2=ZI(IREF1+11)
      JAD=ICONX1-1+ZI(ICONX2+ZI(IVOIS)-1)
      JADV=ICONX1-1+ZI(ICONX2+ZI(IVOIS+IFA)-1)
C
C ----- BOUCLE SUR LES NOEUDS DE LA FACE ----------------------
C
      DO 10 , IN = 1 , NNOF
C
        INO=NOE(IN,IFA,TYMVOL)
C
C ----- RECUPERATION DE SIGMA SUR LA MAILLE COURANTE ------
C
        IAUX = ISIG-1+NBCMP*(INO-1)+1
        SIG11(IN) = ZR(IAUX)
        SIG22(IN) = ZR(IAUX+1)
        SIG33(IN) = ZR(IAUX+2)
        SIG12(IN) = ZR(IAUX+3)
        SIG13(IN) = ZR(IAUX+4)
        SIG23(IN) = ZR(IAUX+5)
C
C ----- RECUPERATION DE SIGMA SUR LE VOISIN ------
C
        NCHER=ZI(JAD-1+INO)
        INOV=INDIIS(ZI(JADV),NCHER,1,NBNOVO)
C       ON VERIFIE QUE L'ON TROUVE BIEN UN NOEUD DANS LA LISTE
        CALL ASSERT(INOV.GT.0)
        IAUX = IAVAL-1+NBCMP*(INOV-1)+1
        SIGV11(IN) = ZR(IAUX)
        SIGV22(IN) = ZR(IAUX+1)
        SIGV33(IN) = ZR(IAUX+2)
        SIGV12(IN) = ZR(IAUX+3)
        SIGV13(IN) = ZR(IAUX+4)
        SIGV23(IN) = ZR(IAUX+5)
C
C ----- CALCUL DES SAUTS DE CONTRAINTES --------------------------------
C
        DSG11(IN)=SIG11(IN)-SIGV11(IN)
        DSG22(IN)=SIG22(IN)-SIGV22(IN)
        DSG33(IN)=SIG33(IN)-SIGV33(IN)
        DSG12(IN)=SIG12(IN)-SIGV12(IN)
        DSG13(IN)=SIG13(IN)-SIGV13(IN)
        DSG23(IN)=SIG23(IN)-SIGV23(IN)
C
  10  CONTINUE
C
         IF ( NNOF.EQ.1789 ) THEN
          WRITE(6,*) 'TYPE MAILLE VOLUMIQUE COURANTE :',TYMVOL
          WRITE(6,1001)
 1000 FORMAT(I3,6X,(6(1X,1PE12.5)))
 1001 FORMAT(11X,'SIXX         SIYY         SIZZ         SIXY',
     >           '         SIXZ         SIYZ')
      DO 110 , IN = 1 , NNOF
        INO=NOE(IN,IFA,TYMVOL)
        NCHER=ZI(JAD-1+INO)
        WRITE(6,1000) NCHER,SIG11(IN),SIG22(IN),SIG33(IN),
     >                   SIG12(IN),SIG13(IN),SIG23(IN)
 110  CONTINUE
          WRITE(6,*) 'TYPE MAILLE VOISINE :',TYPMAV
      DO 120 , IN = 1 , NNOF
        INO=NOE(IN,IFA,TYMVOL)
        NCHER=ZI(JAD-1+INO)
        WRITE(6,1000) NCHER,SIGV11(IN),SIGV22(IN),SIGV33(IN),
     >                   SIGV12(IN),SIGV13(IN),SIGV23(IN)
 120  CONTINUE
              ENDIF
C
      END
