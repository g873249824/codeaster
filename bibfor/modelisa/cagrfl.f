      SUBROUTINE CAGRFL ( CHAR, NOMA )
      IMPLICIT   NONE
      CHARACTER*8       CHAR, NOMA
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/10/2003   AUTEUR BOYERE E.BOYERE 
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
C
C BUT : STOCKAGE DES DONNEES HYDRAULIQUES ET DONNEES GEOMETRIQUES
C       POUR LE CALCUL DES FORCES FLUIDES
C
C ARGUMENTS D'ENTREE:
C      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
C      NOMA   : NOM DU MAILLAGE
C
C --- VECTEURS CREES :
C 
C     CHAR//'.CHME.GRFLU.GEOM' : DONNEES GEOMETRIQUES
C     CHAR//'.CHME.GRFLU.NOMA' : NOM DU MAILLAGE
C     CHAR//'.CHME.GRFLU.LIMA' : LISTE DES MAILLES ORDONNEES
C     CHAR//'.CHME.GRFLU.LINO' : LISTE DES NOEUDS ORDONNES
C     CHAR//'.CHME.GRFLU.VDIR' : VECTEUR DIRECTEUR
C     CHAR//'.CHME.GRFLU.ABSC' : ABSCISSES CURVILIGNES
C     CHAR//'.CHME.GF_DH.NCMP' : NOM DES COMPOSANTES POUR "DH"
C     CHAR//'.CHME.GF_DH.VALE' : VALEUR DES COMPOSANTES POUR "DH"
C     CHAR//'.CHME.GF_GR.NCMP' : NOM DES COMPOSANTES POUR "GR"
C     CHAR//'.CHME.GF_GR.VALE' : VALEUR DES COMPOSANTES POUR "GR"
C     CHAR//'.CHME.GF_MC.NCMP' : NOM DES COMPOSANTES POUR "MC"
C     CHAR//'.CHME.GF_MC.VALE' : VALEUR DES COMPOSANTES POUR "MC"
C     CHAR//'.CHME.GF_MA.NCMP' : NOM DES COMPOSANTES POUR "MA"
C     CHAR//'.CHME.GF_MA.VALE' : VALEUR DES COMPOSANTES POUR "MA"
C     CHAR//'.CHME.GF_TG.NCMP' : NOM DES COMPOSANTES POUR "TG"
C     CHAR//'.CHME.GF_TG.VALE' : VALEUR DES COMPOSANTES POUR "TG"
C     CHAR//'.CHME.GF_AS.NCMP' : NOM DES COMPOSANTES POUR "AS"
C     CHAR//'.CHME.GF_AS.VALE' : VALEUR DES COMPOSANTES POUR "AS"
C     CHAR//'.CHME.GF_PC.NCMP' : NOM DES COMPOSANTES POUR "PC"
C     CHAR//'.CHME.GF_PC.VALE' : VALEUR DES COMPOSANTES POUR "PC"
C
C ----------------------------------------------------------------------
C     ----- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------
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
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER       NDH, NGR, NMC, NMA, NTG, NAS, NPC, JGEO
      PARAMETER    ( NDH = 16 , NGR = 20 , NMC = 11 , NMA = 11 ,
     +               NTG = 12 , NAS = 11 , NPC = 10 )
      CHARACTER*8   FFDH(NDH) , FFGR(NGR) , FFMC(NMC) , FFMA(NMA),
     +              FFTG(NTG) , FFAS(NAS) , FFPC(NPC)
      INTEGER       I, J, N1, N2, IOC, NBFFL, INDIK8, NBV, JNOMA,
     +              JCDH, JCGR, JCMC, JCMA, JCTG, JCAS, JCPC,
     +              JVDH, JVGR, JVMC, JVMA, JVTG, JVAS, JVPC
      REAL*8        VALR(NGR), Z0
      CHARACTER*8   K8B, VALK(NGR)
      CHARACTER*16  MOTCLF
C
C --- DONNEES HYDRAULIQUES
C
      DATA FFDH  / 'Q'  , 'ROC', 'ROD' , 'ROP', 'ROM', 'ROML', 'ROG',
     +             'NUC', 'NUM', 'NUML', 'NUG', 'P2' , 'P3'  , 'P4' , 
     +             'CGG', 'G'  /
C
C --- DONNEES GEOMETRIQUES GRAPPE
C
      DATA FFGR / 'M'     , 'DTIGE', 'DTMOY' , 'ROTIGE', 'LTIGE' ,
     +            'LLT'   , 'LCT'  , 'VARAI' , 'RORAI' , 'DCRAY' ,
     +            'ROCRAY', 'LCRAY', 'LCHUT' , 'CFCM'  , 'CFCI'  ,
     +            'CFCG'  , 'HRUGC', 'HRUGTC', 'NCA'   , 'Z0'    /
C   
C --- DONNEES GEOMETRIQUES MECANISME DE COMMANDE
C
      DATA FFMC / 'LI'  , 'LML', 'LG' , 'LIG' , 'DIML' , 'DEML' , 
     +            'DCSP', 'DG' , 'HRUGML', 'HRUGCSP', 'HRUGG' /
C
C --- DONNEES GEOMETRIQUES MANCHETTE ET ADAPTATEUR
C
      DATA FFMA / 'LM' , 'LA'  , 'LIM', 'DIMT' , 'DEMT'  , 'DCMT', 
     +            'VMT', 'ROMT', 'DA' , 'HRUGM', 'HRUGA' /
C
C --- DONNEES GEOMETRIQUES TUBES GUIDES
C
      DATA FFTG / 'NRET', 'L0' , 'L1'  , 'L2' , 'L3'  , 'L4'     ,  
     +            'DTG' , 'DR' , 'DOR' , 'D0' , 'D00' , 'HRUGTG' /
C
C --- DONNEES GEOMETRIQUES ASSEMBLAGES
C
      DATA FFAS / 'SASS' , 'DCC' , 'DTI' , 'NGM' , 'NGMDP' , 'KM', 
     +            'KS'   , 'KI'  , 'KES' , 'KEI' , 'KF'    /
C
C --- COEFFICIENT DE PERTE DE CHARGE SINGULIERE
C
      DATA FFPC / 'CD0' , 'CD1' , 'CD2'  , 'CDELARG' , 'CDRET' , 
     +            'CDM' , 'CDA' , 'CDML' , 'CDI'     , 'CDG'   /
C
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      MOTCLF = 'GRAPPE_FLUIDE'
      CALL GETFAC ( MOTCLF , NBFFL )
      IF ( NBFFL .EQ. 0 ) GOTO 9999
C
      CALL WKVECT ( CHAR//'.CHME.GRFLU.NOMA', 'G V K8', 1, JNOMA )
      ZK8(JNOMA) = NOMA
C
      CALL WKVECT ( CHAR//'.CHME.GF_DH.NCMP', 'G V K8', NDH, JCDH )
      CALL WKVECT ( CHAR//'.CHME.GF_DH.VALE', 'G V R' , NDH, JVDH )
      CALL WKVECT ( CHAR//'.CHME.GF_GR.NCMP', 'G V K8', NGR, JCGR )
      CALL WKVECT ( CHAR//'.CHME.GF_GR.VALE', 'G V R' , NGR, JVGR )
      CALL WKVECT ( CHAR//'.CHME.GF_MC.NCMP', 'G V K8', NMC, JCMC )
      CALL WKVECT ( CHAR//'.CHME.GF_MC.VALE', 'G V R' , NMC, JVMC )
      CALL WKVECT ( CHAR//'.CHME.GF_MA.NCMP', 'G V K8', NMA, JCMA )
      CALL WKVECT ( CHAR//'.CHME.GF_MA.VALE', 'G V R' , NMA, JVMA )
      CALL WKVECT ( CHAR//'.CHME.GF_TG.NCMP', 'G V K8', NTG, JCTG )
      CALL WKVECT ( CHAR//'.CHME.GF_TG.VALE', 'G V R' , NTG, JVTG )
      CALL WKVECT ( CHAR//'.CHME.GF_AS.NCMP', 'G V K8', NAS, JCAS )
      CALL WKVECT ( CHAR//'.CHME.GF_AS.VALE', 'G V R' , NAS, JVAS )
      CALL WKVECT ( CHAR//'.CHME.GF_PC.NCMP', 'G V K8', NPC, JCPC )
      CALL WKVECT ( CHAR//'.CHME.GF_PC.VALE', 'G V R' , NPC, JVPC )
      CALL WKVECT ( CHAR//'.CHME.GRFLU.GEOM', 'G V R' ,   8, JGEO )
C
      DO 11 I = 1, NDH
         ZK8(JCDH-1+I) = FFDH(I)
 11   CONTINUE
      DO 12 I = 1, NGR
         ZK8(JCGR-1+I) = FFGR(I)
 12   CONTINUE
      DO 13 I = 1, NMC
         ZK8(JCMC-1+I) = FFMC(I)
 13   CONTINUE
      DO 14 I = 1, NMA
         ZK8(JCMA-1+I) = FFMA(I)
 14   CONTINUE
      DO 15 I = 1, NTG
         ZK8(JCTG-1+I) = FFTG(I)
 15   CONTINUE
      DO 16 I = 1, NAS
         ZK8(JCAS-1+I) = FFAS(I)
 16   CONTINUE
      DO 17 I = 1, NPC
         ZK8(JCPC-1+I) = FFPC(I)
 17   CONTINUE
C
C --- LA PREMIERE OCCURENCE SERT A INITIALISER LES DONNEES
C     VERIFICATION QUE TOUS LES MOTS CLES SONT PRESENTS:
C
      CALL GETVID ( MOTCLF, 'GROUP_MA', 1, 1, 1, K8B, N1)
      IF ( N1 .EQ. 0 ) THEN
         CALL UTMESS('F','CAGRFL','LE MOT CLE "GROUP_MA" DOIT ETRE '//
     +                            'PRESENT A LA PREMIERE OCCURENCE')
      ENDIF
      CALL GETVID ( MOTCLF, 'GROUP_NO_ORIG', 1, 1, 1, K8B, N1)
      CALL GETVID ( MOTCLF, 'NOEUD_ORIG'   , 1, 1, 1, K8B, N2)
      IF ( N1+N2 .EQ. 0 ) THEN
         CALL UTMESS('F','CAGRFL',' UN DES MOTS CLES "GROUP_NO_ORIG"'//
     +    ' OU "NOEUD_ORIG" DOIT ETRE PRESENT A LA PREMIERE OCCURENCE')
      ENDIF
      CALL GETVID ( MOTCLF, 'GROUP_NO_EXTR', 1, 1, 1, K8B, N1)
      CALL GETVID ( MOTCLF, 'NOEUD_EXTR'   , 1, 1, 1, K8B, N2)
      IF ( N1+N2 .EQ. 0 ) THEN
         CALL UTMESS('F','CAGRFL',' UN DES MOTS CLES "GROUP_NO_EXTR"'//
     +    ' OU "NOEUD_EXTR" DOIT ETRE PRESENT A LA PREMIERE OCCURENCE')
      ENDIF
      CALL GETVR8 ( MOTCLF, 'Z0', 1, 1, 1, Z0, N1)
      IF ( N1 .EQ. 0 ) THEN
         CALL UTMESS('F','CAGRFL','LE MOT CLE "Z0" DOIT ETRE '//
     +                            'PRESENT A LA PREMIERE OCCURENCE')
      ENDIF
C
C --- LECTURE DES DONNEES HYDRAULIQUES
C
      CALL GETVTX ( MOTCLF, 'CARA_HYDR', 1, 1, NDH, VALK, N1)
      CALL GETVR8 ( MOTCLF, 'VALE_HYDR', 1, 1, NDH, VALR, N2)
      IF ( N1 .NE. N2 ) THEN
         CALL UTMESS('F','CAGRFL',
     +               'NOMBRE CARA_HYDR DIFFERENT DE VALE_HYDR')
      ENDIF
      IF ( N1 .NE. NDH ) THEN
         CALL UTDEBM('F','CAGRFL',' IL MANQUE DES DONNEES')
         CALL UTIMPK('L','   DONNEES RECUES ', ABS(N1), VALK )
         CALL UTIMPK('L','   DONNEES ATTENDUES ',  NDH, FFDH )
      ENDIF
      DO 101 I = 1, NDH
         J = INDIK8 ( FFDH, VALK(I), 1, NDH )
         ZR(JVDH-1+J) = VALR(I)
 101  CONTINUE
C
C --- LECTURE DES DONNEES GEOMETRIQUES GRAPPE
C
      CALL GETVTX ( MOTCLF, 'CARA_GRAPPE', 1, 1, NGR, VALK, N1 )
      CALL GETVR8 ( MOTCLF, 'VALE_GRAPPE', 1, 1, NGR, VALR, N2 )
      IF ( N1 .NE. N2 ) THEN
         CALL UTMESS('F','CAGRFL',
     +             'NOMBRE CARA_GRAPPE DIFFERENT DE VALE_GRAPPE')
      ENDIF
      IF ( N1 .NE. NGR-1 ) THEN
         CALL UTDEBM('F','CAGRFL',' IL MANQUE DES DONNEES')
         CALL UTIMPK('L','   DONNEES RECUES ', ABS(N1), VALK )
         CALL UTIMPK('L','   DONNEES ATTENDUES ', NGR-1, FFGR )
      ENDIF
      DO 102 I = 1, NGR-1
         J = INDIK8 ( FFGR, VALK(I), 1, NGR )
         ZR(JVGR-1+J) = VALR(I)
 102  CONTINUE
C
C --- LECTURE DES DONNEES GEOMETRIQUES MECANISME DE COMMANDE
C
      CALL GETVTX ( MOTCLF, 'CARA_COMMANDE', 1, 1, NMC, VALK, N1 )
      CALL GETVR8 ( MOTCLF, 'VALE_COMMANDE', 1, 1, NMC, VALR, N2 )
      IF ( N1 .NE. N2 ) THEN
        CALL UTMESS('F','CAGRFL',
     +            'NOMBRE CARA_COMMANDE DIFFERENT DE VALE_COMMANDE')
      ENDIF
      IF ( N1 .NE. NMC ) THEN
         CALL UTDEBM('F','CAGRFL',' IL MANQUE DES DONNEES')
         CALL UTIMPK('L','   DONNEES RECUES ', ABS(N1), VALK )
         CALL UTIMPK('L','   DONNEES ATTENDUES ',  NMC, FFMC )
      ENDIF
      DO 103 I = 1, NMC
         J = INDIK8 ( FFMC, VALK(I), 1, NMC )
         ZR(JVMC-1+J) = VALR(I)
 103  CONTINUE
C
C --- LECTURE DES DONNEES GEOMETRIQUES MANCHETTE ET ADAPTATEUR
C
      CALL GETVTX ( MOTCLF, 'CARA_MANCHETTE', 1, 1, NMA, VALK, N1 )
      CALL GETVR8 ( MOTCLF, 'VALE_MANCHETTE', 1, 1, NMA, VALR, N2 )
      IF ( N1 .NE. N2 ) THEN
         CALL UTMESS('F','CAGRFL',
     +         'NOMBRE CARA_MANCHETTE DIFFERENT DE VALE_MANCHETTE')
      ENDIF
      IF ( N1 .NE. NMA ) THEN
         CALL UTDEBM('F','CAGRFL',' IL MANQUE DES DONNEES')
         CALL UTIMPK('L','   DONNEES RECUES ', ABS(N1), VALK )
         CALL UTIMPK('L','   DONNEES ATTENDUES ',  NMA, FFMA )
      ENDIF
      DO 104 I = 1, NMA
         J = INDIK8 ( FFMA, VALK(I), 1, NMA )
         ZR(JVMA-1+J) = VALR(I)
 104  CONTINUE
C
C --- LECTURE DES DONNEES GEOMETRIQUES TUBES GUIDES
C
      CALL GETVTX ( MOTCLF, 'CARA_GUIDE', 1, 1, NTG, VALK, N1 )
      CALL GETVR8 ( MOTCLF, 'VALE_GUIDE', 1, 1, NTG, VALR, N2 )
      IF ( N1 .NE. N2 ) THEN
         CALL UTMESS('F','CAGRFL',
     +               'NOMBRE CARA_GUIDE DIFFERENT DE VALE_GUIDE')
      ENDIF
      IF ( N1 .NE. NTG ) THEN
         CALL UTDEBM('F','CAGRFL',' IL MANQUE DES DONNEES')
         CALL UTIMPK('L','   DONNEES RECUES ', ABS(N1), VALK )
         CALL UTIMPK('L','   DONNEES ATTENDUES ',  NTG, FFTG )
      ENDIF
      DO 105 I = 1, NTG
         J = INDIK8 ( FFTG, VALK(I), 1, NTG )
         ZR(JVTG-1+J) = VALR(I)
 105  CONTINUE
C
C --- LECTURE DES DONNEES GEOMETRIQUES ASSEMBLAGES
C
      CALL GETVTX ( MOTCLF, 'CARA_ASSEMBLAGE', 1, 1, NAS, VALK, N1 )
      CALL GETVR8 ( MOTCLF, 'VALE_ASSEMBLAGE', 1, 1, NAS, VALR, N2 )
      IF ( N1 .NE. N2 ) THEN
         CALL UTMESS('F','CAGRFL',
     +        'NOMBRE CARA_ASSEMBLAGE DIFFERENT DE VALE_ASSEMBLAGE')
      ENDIF
      IF ( N1 .NE. NAS ) THEN
         CALL UTDEBM('F','CAGRFL',' IL MANQUE DES DONNEES')
         CALL UTIMPK('L','   DONNEES RECUES ', ABS(N1), VALK )
         CALL UTIMPK('L','   DONNEES ATTENDUES ',  NAS, FFAS )
      ENDIF
      DO 106 I = 1, NAS
         J = INDIK8 ( FFAS, VALK(I), 1, NAS )
         ZR(JVAS-1+J) = VALR(I)
 106  CONTINUE
C
C --- LECTURE DES COEFFICIENTS DE PERTE DE CHARGE SINGULIERE
C
      CALL GETVTX ( MOTCLF, 'CARA_PDC', 1, 1, NPC, VALK, N1 )
      CALL GETVR8 ( MOTCLF, 'VALE_PDC', 1, 1, NPC, VALR, N2 )
      IF ( N1 .NE. N2 ) THEN
         CALL UTMESS('F','CAGRFL',
     +               'NOMBRE CARA_PDC DIFFERENT DE VALE_PDC')
      ENDIF
      IF ( N1 .NE. NPC ) THEN
         CALL UTDEBM('F','CAGRFL',' IL MANQUE DES DONNEES')
         CALL UTIMPK('L','   DONNEES RECUES ', ABS(N1), VALK )
         CALL UTIMPK('L','   DONNEES ATTENDUES ',  NPC, FFPC )
      ENDIF
      DO 107 I = 1, NPC
         J = INDIK8 ( FFPC, VALK(I), 1, NPC )
         ZR(JVPC-1+J) = VALR(I)
 107  CONTINUE
C
C --- LECTURE DU Z0
C
      CALL GETVR8 ( MOTCLF, 'Z0', 1, 1, 1, Z0, N1 )
      ZR(JVGR-1+NGR) = Z0
C
C --- LES OCCURENCES SUIVANTES SERVENT A SURCHARGER
C
      DO 200 IOC = 2, NBFFL
C
        CALL GETVTX ( MOTCLF, 'CARA_HYDR', IOC,1,0, K8B, N1 )
        IF ( N1 .NE. 0 ) THEN
          NBV = -N1
          CALL GETVTX ( MOTCLF, 'CARA_HYDR', IOC,1,NBV, VALK, N1)
          CALL GETVR8 ( MOTCLF, 'VALE_HYDR', IOC,1,NBV, VALR, N2)
          IF ( N1 .NE. N2 ) THEN
            CALL UTMESS('F','CAGRFL',
     +                      'NOMBRE CARA_HYDR DIFFERENT DE VALE_HYDR')
          ENDIF
          DO 201 I = 1, NBV
            J = INDIK8 ( FFDH, VALK(I), 1, NDH )
            ZR(JVDH-1+J) = VALR(I)
 201      CONTINUE
        ENDIF
C
        CALL GETVTX ( MOTCLF, 'CARA_GRAPPE', IOC,1,0, K8B, N1 )
        IF ( N1 .NE. 0 ) THEN
          NBV = -N1
          CALL GETVTX ( MOTCLF, 'CARA_GRAPPE', IOC,1,NBV, VALK, N1)
          CALL GETVR8 ( MOTCLF, 'VALE_GRAPPE', IOC,1,NBV, VALR, N2)
          IF ( N1 .NE. N2 ) THEN
            CALL UTMESS('F','CAGRFL',
     +                  'NOMBRE CARA_GRAPPE DIFFERENT DE VALE_GRAPPE')
          ENDIF
          DO 202 I = 1, NBV
            J = INDIK8 ( FFGR, VALK(I), 1, NGR )
            ZR(JVGR-1+J) = VALR(I)
 202      CONTINUE
        ENDIF
C
        CALL GETVTX ( MOTCLF, 'CARA_COMMANDE', IOC,1,0, K8B, N1 )
        IF ( N1 .NE. 0 ) THEN
          NBV = -N1
          CALL GETVTX ( MOTCLF, 'CARA_COMMANDE', IOC,1,NBV, VALK, N1)
          CALL GETVR8 ( MOTCLF, 'VALE_COMMANDE', IOC,1,NBV, VALR, N2)
          IF ( N1 .NE. N2 ) THEN
            CALL UTMESS('F','CAGRFL',
     +               'NOMBRE CARA_COMMANDE DIFFERENT DE VALE_COMMANDE')
          ENDIF
          DO 203 I = 1, NBV
            J = INDIK8 ( FFMC, VALK(I), 1, NMC )
            ZR(JVMC-1+J) = VALR(I)
 203      CONTINUE
        ENDIF
C
        CALL GETVTX ( MOTCLF, 'CARA_MANCHETTE', IOC,1,0, K8B, N1 )
        IF ( N1 .NE. 0 ) THEN
          NBV = -N1
          CALL GETVTX ( MOTCLF, 'CARA_MANCHETTE', IOC,1,NBV, VALK, N1)
          CALL GETVR8 ( MOTCLF, 'VALE_MANCHETTE', IOC,1,NBV, VALR, N2)
          IF ( N1 .NE. N2 ) THEN
            CALL UTMESS('F','CAGRFL',
     +            'NOMBRE CARA_MANCHETTE DIFFERENT DE VALE_MANCHETTE')
          ENDIF
          DO 204 I = 1, NBV
            J = INDIK8 ( FFMA, VALK(I), 1, NMA )
            ZR(JVMA-1+J) = VALR(I)
 204      CONTINUE
        ENDIF
C
        CALL GETVTX ( MOTCLF, 'CARA_GUIDE', IOC,1,0, K8B, N1 )
        IF ( N1 .NE. 0 ) THEN
          NBV = -N1
          CALL GETVTX ( MOTCLF, 'CARA_GUIDE', IOC,1,NBV, VALK, N1)
          CALL GETVR8 ( MOTCLF, 'VALE_GUIDE', IOC,1,NBV, VALR, N2)
          IF ( N1 .NE. N2 ) THEN
            CALL UTMESS('F','CAGRFL',
     +                  'NOMBRE CARA_GUIDE DIFFERENT DE VALE_GUIDE')
          ENDIF
          DO 205 I = 1, NBV
            J = INDIK8 ( FFTG, VALK(I), 1, NTG )
            ZR(JVTG-1+J) = VALR(I)
 205      CONTINUE
        ENDIF
C
        CALL GETVTX ( MOTCLF, 'CARA_ASSEMBLAGE', IOC,1,0, K8B, N1)
        IF ( N1 .NE. 0 ) THEN
          NBV = -N1
          CALL GETVTX ( MOTCLF, 'CARA_ASSEMBLAGE', IOC,1,NBV, VALK, N1)
          CALL GETVR8 ( MOTCLF, 'VALE_ASSEMBLAGE', IOC,1,NBV, VALR, N2)
          IF ( N1 .NE. N2 ) THEN
            CALL UTMESS('F','CAGRFL',
     +           'NOMBRE CARA_ASSEMBLAGE DIFFERENT DE VALE_ASSEMBLAGE')
           ENDIF
           DO 206 I = 1, NBV
             J = INDIK8 ( FFAS, VALK(I), 1, NAS )
             ZR(JVAS-1+J) = VALR(I)
 206      CONTINUE
        ENDIF
C
        CALL GETVTX ( MOTCLF, 'CARA_PDC', IOC,1,0, K8B, N1 )
        IF ( N1 .NE. 0 ) THEN
          NBV = -N1
          CALL GETVTX ( MOTCLF, 'CARA_PDC', IOC,1,NBV, VALK, N1 )
          CALL GETVR8 ( MOTCLF, 'VALE_PDC', IOC,1,NBV, VALR, N2 )
          IF ( N1 .NE. N2 ) THEN
             CALL UTMESS('F','CAGRFL',
     +                       'NOMBRE CARA_PDC DIFFERENT DE VALE_PDC')
          ENDIF
          DO 207 I = 1, NBV
             J = INDIK8 ( FFPC, VALK(I), 1, NPC )
             ZR(JVPC-1+J) = VALR(I)
 207      CONTINUE
        ENDIF
 200  CONTINUE

C
C --- Q EST DONNEE EN M3/H
C
      ZR(JVDH-1+1) = ZR(JVDH-1+1) / 3600.D0

C
C --- DESCRIPTION DU VECTEUR CONTENANT LES DONNEES GEOMETRIQUES
C --- DECRIVANT LA GRAPPE :
C
C     LG
      ZR(JGEO+1-1) = ZR(JVMC-1+3)
C     LML
      ZR(JGEO+2-1) = ZR(JVMC-1+2)
C     LM
      ZR(JGEO+3-1) = ZR(JVMA-1+1)
C     LDOME
      ZR(JGEO+4-1) = 4.536D0 - 4.297D0
C     LGDC 
      ZR(JGEO+5-1) = 4.297D0 - 1.217D0
C     HGC 
      ZR(JGEO+6-1) = 1.217D0
C     L1
      ZR(JGEO+7-1) = ZR(JVTG-1+3)
C     L2
      ZR(JGEO+8-1) = ZR(JVTG-1+4)
C
      CALL CAGRF1 ( CHAR, NOMA, Z0 )
C
 9999 CONTINUE
C
      CALL JEDEMA()
      END
