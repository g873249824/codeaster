      SUBROUTINE XMMAA0(NDIM,NNC,NNE,NNES,HPG,NFAES,CFACE,
     &                  FFPC,JACOBI,IAINES,COEFCA,TYPMA,MMAT)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/05/2009   AUTEUR MAZET S.MAZET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      INTEGER  NDIM,NNC,NNE,NNES,NFAES,CFACE(5,3),IAINES
      REAL*8   MMAT(120,120)
      REAL*8   HPG,FFPC(9),JACOBI,COEFCA
      CHARACTER*8  TYPMA
C
C ----------------------------------------------------------------------
C ROUTINE APPELLEE PAR : TE0366
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C CALCUL DE A ET DE AT POUR LE CONTACT METHODE CONTINUE
C CAS SANS CONTACT (XFEM)
C
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNC    : NOMBRE DE NOEUDS DE CONTACT
C IN  NNE    : NOMBRE TOTAL DE NOEUDS DE LA MAILLE ESCLAVE
C IN  NNES   : NOMBRE DE NOEUDS SOMMETS DE LA MAILLE ESCLAVE
C IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  NFACES : NUMERO DE LA FACETTE DE CONTACT ESCLAVE
C IN  CFACE  : MATRICE DE CONECTIVITE DES FACETTES DE CONTACT
C IN  FFPC   : FONCTIONS DE FORME DU POINT DE CONTACT DANS ELC
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  IAINES : POINTEUR VERS LE VECTEUR DES ARRETES ESCLAVES 
C              INTERSECTEES
C IN  COEFCA : COEF_REGU_CONT
C IN  TYPMA    : NOM DE LA MAILLE ESCLAVE D'ORIGINE (QUADRATIQUE)
C I/O MMAT   : MATRICE ELEMENTAIRE DE CONTACT/FROTTEMENT
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER I,J,INI,INJ,PLI,PLJ,XOULA
      REAL*8   E
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      E=1
      DO 10 I = 1,NNC
        DO 20 J = 1,NNC
          INI=XOULA(CFACE,NFAES,I,IAINES,TYPMA)
          CALL XPLMA2(NDIM,NNE,NNES,INI,PLI)
          INJ=XOULA(CFACE,NFAES,J,IAINES,TYPMA)
          CALL XPLMA2(NDIM,NNE,NNES,INJ,PLJ)
          MMAT(PLI,PLJ) = -HPG*FFPC(J)*FFPC(I)*JACOBI/COEFCA*E*E
 20     CONTINUE
 10   CONTINUE
C
      CALL JEDEMA()      
      END
