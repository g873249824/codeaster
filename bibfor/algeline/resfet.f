      SUBROUTINE RESFET(SDFETI,MATAS,CHCINE,CHSECM,CHSOL,NITER,
     &       EPSI,CRITER,TESTCO,NBREOR,TYREOR,PRECO,SCALIN,STOGI)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 20/06/2005   AUTEUR BOITEAU O.BOITEAU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    - FONCTION REALISEE:  RESOLUTION D'UN SYSTEME LINEAIRE VIA FETI
C
C     RESOLUTION DU SYSTEME       "NOMMAT" * X = "CHAMNO"
C                                       AVEC X = U0 SUR G
C     ------------------------------------------------------------------
C     IN  SDFETI : CH19 : SD DECRIVANT LE PARTIONNEMENT FETI
C     IN  MATAS  : CH19 : NOM DE LA MATR_ASSE GLOBALE
C     IN  CHCINE : CH19 : CHAM_NO DE CHARGEMENT CINEMATIQUE
C                         ASSOCIE A LA CONTRAINTE X = U0 SUR G
C     IN CHSECM  : CH19 : CHAM_NO GLOBAL SECOND MEMBRE
C     OUT CHSOL  : CH19 : CHAM_NO GLOBAL SOLUTION
C     IN  NITER  :  IN  : NOMBRE D'ITERATIONS MAXIMALES ADMISSIBLES DU
C                         GCPPC DE FETI
C     IN  EPSI   :  R8  : CRITERE D'ARRET RELATIF DU GCPPC
C     IN  CRITER :  K24 : STRUCTURE DE DONNEE STOCKANT INFOS DE CV
C     IN  TESTCO :  R8  : PARAMETRE DE TEST DE LA CONT. A L'INTERFACE
C     IN  NBREOR :  IN  : NBRE DE DD A REORTHOGONALISER
C     IN  TYREOR :  K24 : TYPE DE REORTHOGONALISATION
C     IN  PRECO  :  K24 : TYPE DE PRECONDITIONNEMENT
C     IN  SCALIN :  K24 : PARAMETRE DE SCALING DANS LE PRECOND
C     IN STOGI   :  K24  :PARAMETRE DE STOCKAGE DE LA MATRICE GI 
C     ------------------------------------------------------------------
C     VERIFICATIONS :
C     1) SI VCINE = ' ' : ERREUR SI LE NOMBRE DE DDLS IMPOSES ELIMINES
C                         ASSOCIES A LA MATRICE EST /=0
C     2) SI VCINE/= ' ' : ERREUR SI LE NOMBRE DE DDLS IMPOSES ELIMINES
C                         ASSOCIES A LA MATRICE EST =0
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      INTEGER      NITER,NBREOR
      REAL*8       EPSI,TESTCO
      CHARACTER*19 SDFETI,MATAS,CHCINE,CHSECM,CHSOL
      CHARACTER*24 CRITER,TYREOR,PRECO,SCALIN,STOGI
      
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      
C DECLARATION VARIABLES LOCALES
      INTEGER      IDIME,NBSD,IDD,IFETM,ILIMPI
      
      
C CORPS DU PROGRAMME
      CALL JEMARQ()

      CALL JEVEUO(SDFETI//'.FDIM','L',IDIME)
C NOMBRE DE SOUS-DOMAINES       
      NBSD=ZI(IDIME)
      CALL JEVEUO(MATAS//'.FETM','L',IFETM)

C ADRESSE JEVEUX OBJET FETI & MPI
      CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
            
C PAR SOUCIS D'HOMOGENEITE, MAJ DES OBJETS JEVEUX TEMPORAIRE .&INT 
      DO 10 IDD=1,NBSD
        IF (ZI(ILIMPI+IDD).EQ.1) CALL MTDSCR(ZK24(IFETM+IDD-1)(1:19))
   10 CONTINUE              

C SOLVEUR FETI SANS AFFE_CHAR_CINE/MECA     
      CALL ALFETI(SDFETI,MATAS,CHSECM,CHSOL,NITER,EPSI,CRITER,TESTCO,
     &            NBREOR,TYREOR,PRECO,SCALIN,STOGI)
 
      CALL JEDEMA()
      END
