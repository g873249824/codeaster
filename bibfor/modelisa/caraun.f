      SUBROUTINE CARAUN(CHAR,NOMA,MOTFAC,NBOCC,FONREE,
     &                  DIMECU,NBGDCU,
     &                  COEFCU,CMPGCU,MULTCU)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 14/03/2006   AUTEUR MABBAS M.ABBAS 
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
C
      IMPLICIT      NONE
      CHARACTER*8   NOMA
      CHARACTER*8   CHAR      
      CHARACTER*16  MOTFAC
      INTEGER       NBOCC
      CHARACTER*4   FONREE  
      CHARACTER*24  DIMECU
      CHARACTER*24  NBGDCU
      CHARACTER*24  COEFCU      
      CHARACTER*24  CMPGCU      
      CHARACTER*24  MULTCU          
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR: CALIUN
C ----------------------------------------------------------------------
C
C EXTRAIRE LES CARACTERISTIQUES DE LA LIAISON UNILATERALE
C
C
C IN  CHAR   : NOM DU CONCEPT CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  MOTFAC : MOT_CLEF FACTEUR POUR LIAISON UNILATERALE
C IN  NBOCC  : NOMBRE D'OCCURRENCES MOT-CLEF FACTEUR
C IN  FONREE : FONC OU REEL SUIVANT L'OPERATEUR
C IN  DIMECU : NOM JEVEUX DE LA SD INFOS GENERALES
C       ZI(JDIM+0): NOMBRE DE ZONES
C       ZI(JDIM+1): TYPE FONCTION OU REEL D'AFFE_CHAR_MECA
C       ZI(JDIM+2): NOMBRE TOTAL DE NOEUDS (SOMME DE TOUTES LES ZONES)
C       ZI(JDIM+3): NOMBRE TOTAL DE GRANDEURS A GAUCHE DE L'INEGALITE 
C                                          (SOMME DE TOUTES LES ZONES)
C       ZI(JDIM+2*(IOCC-1)+4): POUR ZONE IOCC NOMBRE DE NOEUDS 
C                                !! REMPLI DANS ELIMUN !!
C       ZI(JDIM+2*(IOCC-1)+5): POUR ZONE IOCC NOMBRE DE GRANDEURS A
C                                GAUCHE DE L'INEGALITE 
C IN  NBGDCU : NOM JEVEUX DE LA SD INFOS POINTEURS GRANDEURS
C       ZI(JNBGD+IOCC-1): INDICE DEBUT DANS LISTE DES NOMS DES GRANDEURS
C                       POUR ZONE IOCC
C       ZI(JNBGD+IOCC) - ZI(JNBGD+IOCC-1): NOMBRE DE GRANDEURS DE LA 
C                       ZONE IOCC
C IN  COEFCU : NOM JEVEUX DE LA SD CONTENANT LES COEFFICIENTS DES 
C              GRANDEURS DE MEMBRE DE DROITE
C              VECTEUR TYPE ZR OU ZK8 SUIVANT FONREE
C       Z*(JCOEF+IOCC-1): VALEUR OU NOM FONCTION DU MEMBRE DE DROITE
C IN  CMPGCU : NOM JEVEUX DE LA SD CONTENANT LES GRANDEURS DU MEMBRE
C              DE GAUCHE
C              LONGUEUR = ZI(JDIM+3)
C              INDEXE PAR NBGDCU: 
C       ZI(JNBGD+IOCC-1): INDEX DEBUT POUR ZONE IOCC
C       ZI(JDIM+2*(IOCC-1)+5) = ZI(JNBGD+IOCC)-ZI(JNBGD+IOCC-1):
C                         NOMBRE GRANDEURS A GAUCHE POUR ZONE IOCC
C       ZK8(JCMPG-1+INDEX+ICMP-1): NOM ICMP-EME GRANDEUR 
C IN  MULTCU : NOM JEVEUX DE LA SD CONTENANT LES COEF DU MEMBRE
C              DE GAUCHE
C              VECTEUR TYPE ZR OU ZK8 SUIVANT FONREE
C              MEME ACCES QUE CMPGCU
C     
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER       ZMAX
      PARAMETER     (ZMAX = 30)
      CHARACTER*8   CMPGD(ZMAX),K8BID,TYPM,CCOEF,CCMULT(ZMAX)
      INTEGER       NTOT,NBRESO,NOC,NOCGD,NOCCMP,NOCMUL
      INTEGER       IOCC,I
      CHARACTER*24  METHCU,PARACU
      INTEGER       JMETH,JPARA
      INTEGER       JCOEF,JNBGD,JCMPG,JMULT,JDIM 
      REAL*8        COEF,CMULT(ZMAX),R8BID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C ======================================================================
C
C ----------------------------------------------------------------------
C
C     INFOS GENERALES
C
C ----------------------------------------------------------------------
C
      CALL JEVEUO(DIMECU,'E',JDIM)
C
C --- NOMBRE DE ZONES
C
      ZI(JDIM)  = NBOCC
C     
C --- TYPE REEL OU FONCTION
C 
      IF (FONREE(1:4).EQ.'REEL') THEN
        ZI(JDIM+1) = 1
      ELSE IF (FONREE(1:4).EQ.'FONC') THEN  
        ZI(JDIM+1) = 2    
      ELSE
        CALL UTMESS('F','CARAUN',
     &              'LIAISON UNILATERALE NI REELLE, NI FONCTION')
      ENDIF     
C
C ----------------------------------------------------------------------
C
C     METHODE DE RESOLUTION
C
C ----------------------------------------------------------------------
C   
      METHCU = CHAR(1:8)//'.UNILATE.METHCU'
      CALL WKVECT(METHCU,'G V I',1,JMETH) 
C
C --- METHODE: CONTRAINTES ACTIVES OU GRADIENT CONJUGUE PROJETE
C 
      CALL GETVTX(MOTFAC,'METHODE',1,1,1,TYPM,NOC)
      IF (TYPM(1:8).EQ.'CONTRAIN') THEN
        ZI(JMETH) = 0
      ELSE IF (TYPM(1:8).EQ.'GRADIENT') THEN
        ZI(JMETH) = 1
      ELSE
        CALL UTMESS('F','CARAUN',
     &      'NE CORRESPOND A AUCUNE METHODE DE LIAISON_UNILATERALE')
      END IF 
C
C --- PARAMETRES DE LA METHODE
C
      PARACU = CHAR(1:8)//'.UNILATE.PARACU' 
      CALL WKVECT(PARACU,'G V R',1,JPARA)
      IF (TYPM(1:8).EQ.'CONTRAIN') THEN
        CALL GETVIS(MOTFAC,'NB_RESOL',1,1,1,NBRESO,NOC)
        ZR(JPARA) = NBRESO 
      ELSE
        CALL UTMESS('F','CARAUN',
     &      'NE CORRESPOND A AUCUNE METHODE DE LIAISON_UNILATERALE')
      ENDIF   
C
C --- METHODE: VERIF
C  
      DO 1000 IOCC=2,NBOCC
        CALL GETVTX(MOTFAC,'METHODE',IOCC,1,1,TYPM,NOC)
        IF (TYPM(1:8).EQ.'CONTRAIN') THEN
          IF (ZI(JMETH).EQ.1) THEN
            CALL UTMESS('F','CARAUN',
     &      'UNE SEULE METHODE POUR TOUTES LES LIAISONS UNILATERALES')
          ENDIF
        ELSE IF (TYPM(1:8).EQ.'GRADIENT') THEN
          IF (ZI(JMETH).EQ.0) THEN
            CALL UTMESS('F','CARAUN',
     &      'UNE SEULE METHODE POUR TOUTES LES LIAISONS UNILATERALES')
          ENDIF
        ELSE
          CALL UTMESS('F','CARAUN',
     &        'NE CORRESPOND A AUCUNE METHODE DE LIAISON_UNILATERALE')
        END IF
 1000 CONTINUE   
C
C ----------------------------------------------------------------------
C
C     MEMBRE DE DROITE DE L'INEGALITE
C
C ----------------------------------------------------------------------
C       
      COEFCU = '&&CARAUN.COEFCU'      
      IF (FONREE(1:4).EQ.'REEL') THEN
        CALL WKVECT(COEFCU,'V V R',NBOCC,JCOEF)
      ELSE IF (FONREE(1:4).EQ.'FONC') THEN
        CALL WKVECT(COEFCU,'V V K8',NBOCC,JCOEF)     
      ELSE
        CALL UTMESS('F','CARAUN',
     &              'LIAISON UNILATERALE NI REELLE, NI FONCTION')
      ENDIF       
   
      DO 1001 IOCC=1,NBOCC
        IF (FONREE(1:4).EQ.'REEL') THEN
          CALL GETVR8(MOTFAC,'COEF_IMPO',IOCC,1,1,COEF,NOC)
          ZR(JCOEF-1+IOCC)  = COEF
        ELSE IF (FONREE(1:4).EQ.'FONC') THEN
          CALL GETVID(MOTFAC,'COEF_IMPO',IOCC,1,1,CCOEF,NOC)
          ZK8(JCOEF-1+IOCC) = CCOEF      
        ELSE
          CALL UTMESS('F','CARAUN',
     &    'LIAISON UNILATERALE NI REELLE, NI FONCTION')
        ENDIF   
 1001 CONTINUE  
C
C ----------------------------------------------------------------------
C
C     MEMBRE DE GAUCHE DE L'INEGALITE: 
C
C ----------------------------------------------------------------------
C               
C
C --- COMPTAGE PREALABLE DU NOMBRE DE DDLS
C      
      CALL JEVEUO(NBGDCU,'E',JNBGD)
      ZI(JNBGD) = 1               
      NTOT      = 0               
      DO 1002 IOCC=1,NBOCC      
        CALL GETVTX(MOTFAC,'NOM_CMP',IOCC,1,1,K8BID,NOCCMP)
        IF (FONREE(1:4).EQ.'REEL') THEN
          CALL GETVR8(MOTFAC,'COEF_MULT',IOCC,1,1,R8BID,NOCMUL)
        ELSE
          CALL GETVID(MOTFAC,'COEF_MULT',IOCC,1,1,K8BID,NOCMUL)
        ENDIF
        IF (NOCCMP.NE.NOCMUL) THEN
            CALL UTMESS('F','CARAUN',
     &   'LE NOMBRE DE COEF_MULT N EST PAS EGAL AU NOMBRE DE GRANDEURS')
        ENDIF 
        NOCCMP = ABS(NOCCMP)
        NOCMUL = ABS(NOCMUL)
        NTOT   = NTOT + NOCCMP
        ZI(JNBGD+IOCC)        = ZI(JNBGD+IOCC-1) + NOCCMP
        ZI(JDIM+2*(IOCC-1)+5) = NOCCMP
        
 1002 CONTINUE  
C
C --- MEMBRE DE GAUCHE DE L'INEGALITE: CREATION DES OBJETS
C 
      CMPGCU = '&&CARAUN.CMPGCU'
      MULTCU = '&&CARAUN.MULTCU'
      CALL WKVECT(CMPGCU,'V V K8',NTOT,JCMPG)
      IF (FONREE(1:4).EQ.'REEL') THEN
        CALL WKVECT(MULTCU,'V V R',NTOT,JMULT)
      ELSE IF (FONREE(1:4).EQ.'FONC') THEN
        CALL WKVECT(MULTCU,'V V K8',NTOT,JMULT)      
      ELSE
        CALL UTMESS('F','CARAUN',
     &              'LIAISON UNILATERALE NI REELLE, NI FONCTION')
      ENDIF  
C
C --- MEMBRE DE GAUCHE DE L'INEGALITE: REMPLISSAGE DES OBJETS
C 
      DO 2000 IOCC=1,NBOCC
        NOCGD = ZI(JNBGD+IOCC) - ZI(JNBGD+IOCC-1)
        IF (NOCGD.GT.ZMAX) THEN
          CALL UTMESS('F','CARAUN',
     &                'TROP DE GRANDEURS DANS LA LIAISON UNILATERALE')
        ENDIF
        
        IF (FONREE(1:4).EQ.'REEL') THEN
          CALL GETVTX(MOTFAC,'NOM_CMP',IOCC,1,NOCGD,CMPGD,NOC)
          CALL GETVR8(MOTFAC,'COEF_MULT',IOCC,1,NOCGD,CMULT,NOC)
          DO 10 I = 1,NOCGD
            ZK8(JCMPG-1+ZI(JNBGD+IOCC-1)+I-1) = CMPGD(I)
            ZR(JMULT-1+ZI(JNBGD+IOCC-1)+I-1)  = CMULT(I)
   10     CONTINUE 
        ELSE IF (FONREE(1:4).EQ.'FONC') THEN
          CALL GETVTX(MOTFAC,'NOM_CMP',IOCC,1,NOCGD,CMPGD,NOC)
          CALL GETVID(MOTFAC,'COEF_MULT',IOCC,1,NOCGD,CCMULT,NOC)
          DO 11 I = 1,NOCGD
            ZK8(JCMPG-1+ZI(JNBGD+IOCC-1)+I-1) = CMPGD(I)
            ZK8(JMULT-1+ZI(JNBGD+IOCC-1)+I-1) = CCMULT(I)
   11     CONTINUE      
        ELSE
          CALL UTMESS('F','CARAUN',
     &                'LIAISON UNILATERALE NI REELLE, NI FONCTION')
        ENDIF         
 2000 CONTINUE    
C ======================================================================
      CALL JEDEMA()
C
      END
