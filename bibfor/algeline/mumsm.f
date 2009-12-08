      SUBROUTINE MUMSM(OPTMPI,IFM,NIV,ACH24,ARGI1,ARGI2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 07/12/2009   AUTEUR BOITEAU O.BOITEAU 
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
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  COQUILLE VIDE SI MUMPS DISTRIBUE ET PAS 
C                          COMPILER AVEC LIB MPI
C
C ARGUMENTS D'APPELS
C IN OPTMPI   : IN  : OPTION DE LA ROUTINE
C    =0        DISTRIBUTION DE LA CHARGE SD/PROC
C    =1        DIFFUSION DU VECTEUR (REEL/INTEGER) ACH24 DE LONGUEUR 
C              ARGI1 DE PROC 0 A TOUS LES PROCS
C    =2       DETERMINATION DU RANG DANS ARGI1
C    =3       DETERMINATION DU NBRE DE PROCS DANS ARGI1
C    =4       REDUCTION DU VECTEUR ACH24 DE LONGUEUR ARGI1 AU PROC 0
C    =5       REDUCTION+DIFFUSION DE ACH24 DE LONGUEUR ARGI1
C    =6       IDEM QUE 5 MAIS AVEC DIRECTEMENT L'ADRESSE JEVEUX DE ACH24
C
C IN IFM,NIV  : IN  : AFFICHAGE
C IN    ACH24 : K24 : NOM JEVEUX DU VECTEUR A COMMUNIQUER 
C INOUT ARGI1 : IN  : 1ERE ARGUMENT ENTIER
C INOUT ARGI2 : IN  : 2ND ARGUMENT ENTIER
C----------------------------------------------------------------------
C RESPONSABLE BOITEAU O.BOITEAU
C CORPS DU PROGRAMME
      IMPLICIT NONE
C DECLARATION PARAMETRES D'APPELS
      INTEGER      OPTMPI,IFM,NIV,ARGI1,ARGI2
      CHARACTER*24 ACH24

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

C DECLARATION VARIABLES LOCALES
      INTEGER      VALI(2),IEXIST,ILIST,I,NB
      CHARACTER*24 NOMLOG
      
C CORPS DU PROGRAMME

C---------------------------------------------- OPTION = 0  
      IF (OPTMPI.EQ.0) THEN
C REPARTITION DE LA CHARGE SD/PROC. ON REPREND LA MEME HEURISTIQUE
C QUE CELLE DE FETI (CF. BIBFOR/FROM_C/FETAM.F)
C OBJET TEMPORAIRE POUR PARALLELISME MPI:
C ZI(ILIST+I)=1 IEME SOUS-DOMAINE CALCULE PAR PROCESSEUR COURANT
C            =0 ELSE
        NOMLOG='&MUMPS.LISTE.SD.MPI'
        CALL JEEXIN(NOMLOG,IEXIST)
        CALL ASSERT(IEXIST.EQ.0)
        NB=ARGI1+1
        CALL WKVECT(NOMLOG,'V V I',NB,ILIST)
        DO 10 I=1,NB
          ZI(ILIST-1+I)=1
   10   CONTINUE
C---------------------------------------------- OPTION = 1  
      ELSE IF (OPTMPI.EQ.1) THEN
C---------------------------------------------- OPTION = 2  
      ELSE IF (OPTMPI.EQ.2) THEN
C DETERMINATION DU RANG D'UN PROCESSUS 
        ARGI1=0
C---------------------------------------------- OPTION = 3  
      ELSE IF (OPTMPI.EQ.3) THEN
C DETERMINATION DU NBRE DE PROCESSEURS
        ARGI1=1
C---------------------------------------------- OPTION = 4  
      ELSE IF (OPTMPI.EQ.4) THEN
C---------------------------------------------- OPTION = 5  
      ELSE IF (OPTMPI.EQ.5) THEN
C---------------------------------------------- OPTION = 6  
      ELSE IF (OPTMPI.EQ.6) THEN
C---------------------------------------------- MAUVAISE OPTION 
      ELSE
        VALI(1)=0
        VALI(2)=OPTMPI
        CALL U2MESI('F','APPELMPI_6',2,VALI)
      ENDIF
      
      END
