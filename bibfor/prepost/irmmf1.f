      SUBROUTINE IRMMF1 ( FID, NOMAMD,
     >                    TYPENT, NBRENT, NBGROU, NOMGEN, NUFAEN,
     >                    NOMAST, PREFIX,
     >                    TYPGEO, NOMTYP, NMATYP,
     >                    INFMED, NIVINF, IFM )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 11/05/2011   AUTEUR SELLENET N.SELLENET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE SELLENET N.SELLENET
C-----------------------------------------------------------------------
C     ECRITURE DU MAILLAGE - FORMAT MED - LES FAMILLES - 1
C        -  -     -                 -         -          -
C-----------------------------------------------------------------------
C     L'ENSEMBLE DES FAMILLES EST L'INTERSECTION DE L'ENSEMBLE 
C     DES GROUPES : UN ENTITE/MAILLE APPARAIT AU PLUS DANS 1 FAMILLE
C     TABLE  NUMEROS DES FAMILLES POUR LES ENTITES  <-> TABLE  DES COO
C     TABLES NUMEROS DES FAMILLES POUR MAILLE/TYPE <-> TABLES DES CNX
C     PAR CONVENTION, LES FAMILLES DE ENTITES SONT NUMEROTEES >0 ET LES
C     FAMILLES DE MAILLES SONT NUMEROTEES <0. LA FAMILLE NULLE EST
C     DESTINEE AUX ENTITES / ELEMENTS SANS FAMILLE.
C     ENTREE:
C   FID    : IDENTIFIANT DU FICHIER MED
C   NOMAMD : NOM DU MAILLAGE MED
C   TYPENT : TYPE D'ENTITES : 0, POUR DES NOEUDS, 1 POUR DES MAILLES
C   NBRENT : NOMBRE D'ENTITES A TRAITER
C   NBGROU : NOMBRE DE GROUPES D'ENTITES
C   NOMGEN : VECTEUR NOMS DES GROUPES D'ENTITES
C   NOMAST : NOM DU MAILLAGE ASTER
C   PREFIX : PREFIXE POUR LES TABLEAUX DES RENUMEROTATIONS
C   TYPGEO : TYPE MED POUR CHAQUE MAILLE
C   NOMTYP : NOM DES TYPES POUR CHAQUE MAILLE
C   NMATYP : NOMBRE DE MAILLES PAR TYPE
C TABLEAUX DE TRAVAIL
C   NUFAEN : NUMERO DE FAMILLE POUR CHAQUE ENTITE
C            PAR DEFAUT, L'ALLOCATION AVEC JEVEUX A TOUT MIS A 0. CELA
C            SIGNIFIE QUE LES ENTITES APPARTIENNENT A LA FAMILLE NULLE.
C DIVERS
C   INFMED : NIVEAU DES INFORMATIONS SPECIFIQUES A MED A IMPRIMER
C   NIVINF : NIVEAU DES INFORMATIONS GENERALES
C   IFM    : UNITE LOGIQUE DU FICHIER DE MESSAGE
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
      INTEGER FID 
      INTEGER TYPENT, NBRENT, NBGROU
      INTEGER NUFAEN(NBRENT)
      INTEGER TYPGEO(*), NMATYP(*)
      INTEGER INFMED
      INTEGER IFM, NIVINF
C
      CHARACTER*6 PREFIX
      CHARACTER*8 NOMAST, NOMGEN(*)
      CHARACTER*8 NOMTYP(*)
      CHARACTER*(*) NOMAMD
C
C 0.2. ==> COMMUNS
C
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'IRMMF1' )
C
      INTEGER TYGENO
      PARAMETER (TYGENO=0)
C
      INTEGER IAUX
      INTEGER NBEC
      INTEGER ADTABX, ADNUFA, ADNOGR, ADNOFE
C
      REAL*8 RAUX
C
      CHARACTER*7 SAUX07
      CHARACTER*24 NUFACR, NOGRFA, NOFAEX, TABAUX
C
C====
C 1. S'IL EXISTE DES GROUPES, ON ALLOUE DES TABLEAUX DE TRAVAIL POUR
C    POUVOIR CONSTRUIRE LES FAMILLES
C====
C
      IF ( NIVINF.GE.2 ) THEN
        WRITE (IFM,1001) NOMPRO
 1001 FORMAT( 60('='),/,'DEBUT DU PROGRAMME ',A)
      ENDIF
C
      IF ( INFMED.GE.2 ) THEN
C
        IF ( TYPENT.EQ.TYGENO ) THEN
          SAUX07 = 'NOEUDS '
        ELSE
          SAUX07 = 'MAILLES'
        ENDIF
        WRITE (IFM,1002) SAUX07, SAUX07, NBRENT, NBGROU
 1002 FORMAT( /,'CONSTRUCTION DES FAMILLES DE ',A,
     >        /,'. NOMBRE DE ',A,' :',I12,
     >        /,'. NOMBRE DE GROUPES :',I5)
C
      ENDIF
C
      IF ( NBGROU.NE.0 ) THEN
C
C====
C 2. S'IL EXISTE DES GROUPES, ON ALLOUE DES TABLEAUX DE TRAVAIL POUR
C    POUVOIR CONSTRUIRE LES FAMILLES
C====
C                 12   345678   9012345678901234
        NUFACR = '&&'//NOMPRO//'.NU_FAM_CRE     '
        NOGRFA = '&&'//NOMPRO//'.NOM_GR_FAM     '
        NOFAEX = '&&'//NOMPRO//'.NOM_FAM_EX     '
        TABAUX = '&&'//NOMPRO//'.TABL_AUXIL     '
C
C       VECTEUR NUMEROS DES FAMILLES D'ENTITES CREES = NBRENT MAX
        CALL WKVECT ( NUFACR, 'V V I', NBRENT, ADNUFA )
C
C       VECTEUR NOMS DES GROUPES D'ENTITES / FAMILLE = NB GRP MAX
        CALL WKVECT ( NOGRFA, 'V V K80', NBGROU, ADNOGR )
C
C       VECTEUR NOMS DES FAMILLES = NB FAMILLE MAX
C       AU PIRE, IL Y A UNE FAMILLE PAR ENTITE. MAIS EN FAIT, C'EST
C       UNE PARTITION SELON LES GROUPES : IL Y EN A AU PIRE 2**NBGROU-1
C       ON CHOISIT DONC LE MIN DES 2
C       POURQUOI 2**NBGROU-1 ?
C       SOIT L'ENTITE APPARTIENT A 1 GROUPE  ==> NBGROU CHOIX
C       SOIT L'ENTITE APPARTIENT A 2 GROUPES ==> ARR(NBGROU,2) CHOIX
C       SOIT L'ENTITE APPARTIENT A 3 GROUPES ==> ARR(NBGROU,3) CHOIX
C       ...
C       SOIT L'ENTITE APPARTIENT A (NBGROU-1) GROUPES
C                                        ==> ARR(NBGROU,NBGROU-1) CHOIX
C       SOIT L'ENTITE APPARTIENT AUX NBGROU GROUPES ==> 1 CHOIX
C       AU TOTAL : NBGROU + ARR(NBGROU,2) + ARR(NBGROU,3) + ...
C                     ... + ARR(NBGROU,NBGROU-1) + 1
C       ON REMARQUE QUE CE SONT LES COEFFICIENTS D'UNE LIGNE DU TRIANGLE
C       DE PASCAL (HONNEUR AUX AUVERGNATS)
C       DONC LA SOMME VAUT (1+1)*NBGROU-1 - 1
C
        RAUX = LOG(DBLE(NBRENT)) / LOG(2.D0)
        IF ( NBGROU.LT.INT(RAUX) ) THEN
          IAUX = 2**NBGROU - 1
        ELSE
          IAUX = NBRENT
        ENDIF
        CALL WKVECT ( NOFAEX, 'V V K80', IAUX, ADNOFE )
C
C       ON UTILISE DES TABLEAUX DE BITS POUR ENREGISTRER LA PRESENCE
C       D'UNE ENTITE DANS UN GROUPE : 30 PAR ENTIER INT*4 NBEC ENTIERS  
C       
        NBEC = (NBGROU-1) / 30 + 1
C       COLOSSAL ALLOC DU TABLEAU CROISE DES ENTITES X GROUPES
C
        CALL WKVECT ( TABAUX, 'V V I', NBRENT*NBEC, ADTABX )
C
C====
C 3. CREATION ET ECRITURE DES FAMILLES
C====
C
        CALL IRMMF2 ( FID, NOMAMD,
     >                TYPENT, NBRENT, NBGROU, NOMGEN,
     >                NBEC, NOMAST, PREFIX,
     >                TYPGEO, NOMTYP, NMATYP,
     >                NUFAEN, ZI(ADNUFA), ZK80(ADNOGR), ZK80(ADNOFE),
     >                ZI(ADTABX),
     >                INFMED, NIVINF, IFM )
C
C====
C 4. MENAGE
C====
C
        CALL JEDETR ( NUFACR )
        CALL JEDETR ( NOGRFA )
        CALL JEDETR ( NOFAEX )
        CALL JEDETR ( TABAUX )
C
      ENDIF
C
      IF ( NIVINF.GE.2 ) THEN
C
        WRITE (IFM,4001) NOMPRO
 4001 FORMAT(/,'FIN DU PROGRAMME ',A,/,60('-'))
C
      ENDIF
C
      END
