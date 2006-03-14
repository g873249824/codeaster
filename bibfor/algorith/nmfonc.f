      SUBROUTINE NMFONC(ZFON,PARCRI,SOLVEU,MODELE,DEFICO,DEFICU,MODEDE,
     &                  FONACT)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/03/2006   AUTEUR MABBAS M.ABBAS 
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
C RESPONSABLE MABBAS M.ABBAS

      IMPLICIT NONE
      INTEGER      ZFON
      LOGICAL      FONACT(ZFON)
      REAL*8       PARCRI
      CHARACTER*19 SOLVEU
      CHARACTER*24 MODELE
      CHARACTER*24 DEFICO
      CHARACTER*24 DEFICU
      CHARACTER*8  MODEDE
C ---------------------------------------------------------------------
C
C     COMMANDES STAT/DYNA_NON_LINE 
C     FONCTIONNALITES ACTIVEES
C
C ---------------------------------------------------------------------
C
C IN   MODELE  :  MODELE MECANIQUE
C IN   MODEDE  :  MODELE NON LOCAL
C IN   DEFICO  :  SD DE DEFINITION DU CONTACT
C IN   DEFICU  :  SD DE DEFINITION D'UNE LIAISON UNILATERALE
C IN   SOLVEU  :  NOM DU SOLVEUR DE NEWTON
C IN   PARCRI  :  RESI_CONT_RELA VAUT R8VIDE SI NON ACTIF
C          CORRESPOND A PARCRI(6)
C  IN  ZFON    :   LONGUEUR DU VECTEUR FONACT
C  OUT FONACT  :   FONCTIONNALITES SPECIFIQUES ACTIVEES
C             <INITIALISE A FALSE DANS NMINI0>
C       FONACT(1) :  RECHERCHE LINEAIRE
C       FONACT(2) :  PILOTAGE
C       FONACT(3) :  LOIS NON LOCALES
C       FONACT(4) :  CONTACT DISCRET
C       FONACT(5) :  CONTACT CONTINU
C       FONACT(6) :  METHODE XFEM
C       FONACT(7) :  ALGORITHME DE DE BORST
C       FONACT(8) :  CONVERGENCE PAR RESIDU DE REFERENCE
C       FONACT(9) :  METHODE XFEM AVEC CONTACT
C       FONACT(10):  CONTACT/FROTTEMENT CONTINU
C       FONACT(11):  SOLVEUR FETI
C       FONACT(12):  LIAISON UNILATERALE
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX -----------------------------
C
      INTEGER      IBID,NOCC
      INTEGER      TYPALC,TYPALF
      INTEGER      JSOLVE,IFISS,IXFEM,ICONT,IUNIL
      INTEGER      ICONTX
      REAL*8       R8VIDE
      CHARACTER*8  K8BID
      CHARACTER*16 NOMCMD,K16BID
C
C ---------------------------------------------------------------------
C
C  VOUS AVEZ CHANGE (AJOUTE/RETIRE UNE FONCTIONNALITE)
C  ZFON MODIFIEE DANS OP0070
C  MODIFIER LA LIGNE CI-DESSOUS ET DOCUMENTER DANS L'ENTETE
C
      IF (ZFON.NE.12) THEN
         CALL UTMESS('F','NMFONC',
     &               'FONCTIONNALITE MODIFIEE (DVLP)')
      ENDIF
C
C --- NOM DE LA COMMANDE: STAT_NON_LINE, DYNA_NON_LINE, DYNA_TRAN_EXPLI
C
      CALL GETRES(K8BID,K16BID,NOMCMD)

C --- RECHERCHE LINEAIRE
      NOCC = 0
      IF (NOMCMD.EQ.'STAT_NON_LINE') THEN
        CALL GETFAC('RECH_LINEAIRE',NOCC)
      ENDIF
      FONACT(1) = NOCC .NE. 0

C --- PILOTAGE
      NOCC = 0
      IF (NOMCMD.EQ.'STAT_NON_LINE') THEN
        CALL GETFAC('PILOTAGE',NOCC)
      ENDIF
      FONACT(2) = NOCC .NE. 0

C --- LOIS NON LOCALES
      FONACT(3) = MODEDE .NE. ' '
      
C --- LIAISON UNILATERALE
      CALL JEEXIN(DEFICU(1:16)//'.METHCU',IUNIL)
      FONACT(12) = IUNIL .NE. 0     

C --- DEBORST ?
      CALL NMBORS(FONACT(7))

C --- CONVERGENCE SUR CRITERE EN CONTRAINTE GENERALISEE
      IF (PARCRI.NE.R8VIDE()) THEN
        FONACT(8) = .TRUE.
      ENDIF

C ----------------------------------------------------------------------
C
C     X-FEM
C
C ----------------------------------------------------------------------

      CALL JEEXIN(MODELE(1:8)//'.FISS',IXFEM)
      IF (IXFEM.NE.0) THEN
        FONACT(6) = .TRUE.
      ENDIF

C --- X-FEM ET CONTACT (METHODE CONTINUE)
      IF (FONACT(6)) THEN
        CALL JEVEUO(MODELE(1:8)//'.FISS','L',IFISS)
        CALL JEEXIN(ZK8(IFISS)//'.CONTACT.XFEM',ICONTX)
        DEFICO(1:16)=ZK8(IFISS)//'.CONTACT'
        CALL  JEVEUO (SOLVEU//'.SLVK','L',JSOLVE)
        IF (ZK24(JSOLVE)(1:5).NE.'MUMPS') CALL UTMESS('A','NMINIT',
     &   'POUR LE TRAITEMENT DU CONTACT AVEC X-FEM, LE SOLVEUR MUMPS '//
     &   'EST VIVEMENT RECOMMANDE.') 
        IF (ICONTX.NE.0) THEN
          FONACT(5) = .TRUE.
          FONACT(9) = .TRUE.
        ENDIF
      ELSE
        ICONTX = 0
      ENDIF


C ----------------------------------------------------------------------
C
C     CONTACT / FROTTEMENT 
C
C ----------------------------------------------------------------------

      CALL JEEXIN(DEFICO(1:16)//'.METHCO',ICONT)
      IF (ICONT.NE.0) THEN
        CALL CFDISC(DEFICO,'              ',TYPALC,TYPALF,IBID,IBID)
        IF (ABS(TYPALC).EQ.3) THEN
          FONACT(5) = .TRUE.
          IF (ABS(TYPALF).EQ.3) THEN
            FONACT(10) = .TRUE.
          ELSE
            FONACT(10) = .FALSE.
          ENDIF
        ELSE
          FONACT(4) = .TRUE.
        ENDIF
      ENDIF
      
C ----------------------------------------------------------------------
C
C     FETI 
C
C ----------------------------------------------------------------------

      CALL  JEVEUO (SOLVEU//'.SLVK','L',JSOLVE)
      IF (ZK24(JSOLVE)(1:4).EQ.'FETI') THEN
        FONACT(11)=.TRUE.
      ELSE
        FONACT(11)=.FALSE.
      ENDIF       
      
C ----------------------------------------------------------------------
C
C     INCOMPATIBILITES DE CERTAINES FONCTIONNALITES
C
C ----------------------------------------------------------------------

      IF (FONACT(4).OR.FONACT(5)) THEN
        IF (FONACT(2)) THEN
          CALL UTMESS('F','NMINIT',
     &    'CONTACT ET PILOTAGE SONT DES FONCTIONNALITES INCOMPATIBLES')
        ENDIF

        IF (FONACT(1).AND.ABS(TYPALC).NE.5) THEN 
          CALL UTMESS('F','NMINIT',
     &     'CONTACT ET RECH. LIN. SONT DES '//
     &     'FONCTIONNALITES INCOMPATIBLES')
        ENDIF

        CALL  JEVEUO (SOLVEU//'.SLVK','L',JSOLVE)
        IF (ZK24(JSOLVE)(1:4).EQ.'GCPC') THEN
          IF (ABS(TYPALC).EQ.3) THEN
            CALL UTMESS('F','NMINIT',
     &           'LA COMBINAISON: METHODE CONTINUE EN CONTACT'//
     &           ' ET SOLVEUR GCPC N''EST PAS DISPONIBLE.')
          ENDIF
          IF (ABS(TYPALF).NE.0) THEN
            CALL UTMESS('F','NMINIT',
     &           'LA COMBINAISON: CONTACT-FROTTEMENT'//
     &           ' ET SOLVEUR GCPC N''EST PAS DISPONIBLE.')
          ENDIF
        ENDIF
      ENDIF

      IF (FONACT(12)) THEN
        IF (FONACT(2)) THEN
          CALL UTMESS('F','NMINIT',
     &    'LIAISON_UNILATERALE ET PILOTAGE SONT DES '//
     &    'FONCTIONNALITES INCOMPATIBLES')
        ENDIF
        IF (FONACT(1)) THEN 
          CALL UTMESS('F','NMINIT',
     &     'IAISON_UNILATERALE ET RECH. LIN. SONT DES '//
     &     'FONCTIONNALITES INCOMPATIBLES')
        ENDIF
      ENDIF



      END
