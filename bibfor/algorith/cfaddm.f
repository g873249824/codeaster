      SUBROUTINE CFADDM(JAPPTR,JAPJEU,JNORMO, 
     &                  JPDDL ,JTANGO,JAPCOF,JAPCOE,JAPJFX,
     &                  JAPJFY,JAPDDL,
     &                  TYPALF,FROT3D,POSESC,
     &                  IESCL ,NESMAX,NORM  ,TANG  ,COEF  ,
     &                  COFX  ,COFY  ,JEU   ,NBNOM ,POSNO ,
     &                  NBDDLT,DDL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/03/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT     NONE
      INTEGER      JAPCOE
      INTEGER      JAPCOF
      INTEGER      JAPDDL
      INTEGER      JAPJEU
      INTEGER      JAPJFX
      INTEGER      JAPJFY
      INTEGER      JAPPTR
      INTEGER      JNORMO
      INTEGER      JPDDL 
      INTEGER      JTANGO
      INTEGER      TYPALF
      INTEGER      FROT3D
      INTEGER      POSESC
      INTEGER      IESCL
      INTEGER      NESMAX
      REAL*8       NORM(3)
      REAL*8       TANG(6)
      REAL*8       COEF(30)
      REAL*8       COFX(30)
      REAL*8       COFY(30)
      REAL*8       JEU
      INTEGER      NBNOM
      INTEGER      POSNO(10)
      INTEGER      NBDDLT
      INTEGER      DDL(30)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
C
C ON AJOUTE UNE LIAISON MAITRE/ESCLAVE OU NODALE 
C
C ----------------------------------------------------------------------
C
C
C IN  JAPPTR : POINTEUR VERS RESOCO(1:14)//'.APPOIN'
C IN  JAPJEU : POINTEUR VERS RESOCO(1:14)//'.APJEU'
C IN  JNORMO : POINTEUR VERS RESOCO(1:14)//'.NORMCO'
C IN  JPDDL  : POINTEUR VERS DEFICO(1:16)//'.PDDLCO'
C IN  JTANGO : POINTEUR VERS RESOCO(1:14)//'.TANGCO'
C IN  JAPCOF : POINTEUR VERS RESOCO(1:14)//'.APCOFR'
C IN  JAPCOE : POINTEUR VERS RESOCO(1:14)//'.APCOEF'
C IN  JAPJFX : POINTEUR VERS RESOCO(1:14)//'.APJEFX'
C IN  JAPJFY : POINTEUR VERS RESOCO(1:14)//'.APJEFY'
C IN  JAPDDL : POINTEUR VERS RESOCO(1:14)//'.APDDL'
C IN  TYPALF : TYPE ALGO UTILISE POUR LE FROTTEMENT
C                0 PAS DE FROTTEMENT 
C                1 FROTTEMENT 
C IN  FROT3D : DIMENSION POUR LE FROTTEMENT
C                0 FROTTEMENT 2D
C                1 FROTTEMENT 3D
C IN  POSESC : POSITION DANS DEFICO(1:16)//'.CONTNO' DU NOEUD ESCLAVE
C IN  IESCL  : INDICE DU NOEUD ESCLAVE
C IN  NESMAX : NOMBRE MAX DE NOEUDS ESCLAVES
C IN  NORM   : VECTEUR NORMAL
C IN  TANG   : LES DEUX VECTEURS TANGENTS
C IN  COEF   : VALEURS EN M DES FONCTIONS DE FORME ASSOCIEES AUX NOEUDS
C IN  COFX   : VALEURS EN M DES FONCTIONS DE FORME ASSOCIEES AUX NOEUDS
C                POUR LA PREMIERE DIRECTION TANGENTE
C IN  COFY   : VALEURS EN M DES FONCTIONS DE FORME ASSOCIEES AUX NOEUDS
C                POUR LA SECONDE DIRECTION TANGENTE
C IN  JEU    : JEU DANS LA DIRECTION DE LA NORMALE CHOISIE (PM.NORM)
C IN  NBNOM  : NOMBRE DE NOEUDS MAITRES CONCERNES (MAX: 9)
C IN  POSNO  : INDICES DANS CONTNO DU NOEUD ESCLAVE ET DES NOEUDS 
C               MAITRES (MAX: 1+9=10)
C IN  NBDDLT : NOMBRE DE DDL NOEUD ESCLAVE+NOEUDS MAITRES
C IN  DDL    : NUMEROS DES DDLS ESCLAVE ET MAITRES CONCERNES
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
      CALL JEMARQ()
C
C --- STOCKAGE NORMALES/TANGENTES DES NOEUDS ESCLAVES
C      
      CALL DCOPY(3,NORM,1,ZR(JNORMO+3*(IESCL-1)),1)
      CALL DCOPY(6,TANG,1,ZR(JTANGO+6*(IESCL-1)),1)     
C
C --- MISE A JOUR DU JEU POUR LE CONTACT
C  
      ZR(JAPJEU+IESCL-1)   = JEU      
C
C --- INITIALISATIONS JEUX FROTTEMENT
C         
      IF (FROT3D.EQ.1) THEN
        ZR(JAPJFX+IESCL-1) = 0.D0
        ZR(JAPJFY+IESCL-1) = 0.D0
      ENDIF                          
C
C --- COEFFICIENTS RELATIONS LINEAIRES APPARIEMENT 
C
      CALL CFCOEM(JAPCOE,JAPCOF,JAPDDL,JAPPTR,JPDDL ,                 
     &            TYPALF,FROT3D,NESMAX,POSESC,IESCL ,
     &            NBDDLT,NBNOM ,POSNO ,DDL   ,COEF  ,
     &            COFX  ,COFY)      
C
      CALL JEDEMA()
      END
