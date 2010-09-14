      SUBROUTINE CFADDM(RESOCO,LCTFD ,LCTF3D,IP    ,POSNOE,
     &                  NUMNOE,ILIAI ,NDIMG ,NBNOM ,POSNSM,
     &                  COEFNO,TAU1  ,TAU2  ,NORM  ,JEU   )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*24 RESOCO
      INTEGER      POSNOE,NUMNOE
      INTEGER      IP,ILIAI
      INTEGER      NBNOM,NDIMG
      REAL*8       COEFNO(9)
      REAL*8       JEU
      REAL*8       NORM(3),TAU1(3),TAU2(3)
      LOGICAL      LCTFD ,LCTF3D     
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
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  LCTFD  : FROTTEMENT
C IN  LCTF3D : FROTTEMENT EN 3D
C IN  IP     : INDICE DU POINT DANS LA SD APPARIEMENT
C IN  POSNOE : INDICE DANS CONTNO DU NOEUD ESCLAVE
C IN  NUMNOE : NUMERO ABSOLU DU NOEUD ESCLAVE DANS LE MAILLAGE
C IN  ILIAI  : INDICE DE LA LIAISON COURANTE
C IN  NDIMG  : DIMENSION DE L'ESPACE
C IN  NBNOM  : NOMBRE DE NOEUDS MAITRES CONCERNES (MAX: 9)
C IN  POSNSM : INDICES DANS CONTNO DES NOEUDS MAITRES
C IN  COEFNO : VALEURS EN M DES FONCTIONS DE FORME ASSOCIEES AUX NOEUDS
C               MAITRES
C IN  TAU1   : TANGENTE LOCALE DIRECTION 1
C IN  TAU2   : TANGENTE LOCALE DIRECTION 2
C IN  NORM   : NORMALE LOCALE
C IN  JEU    : JEU DANS LA DIRECTION DE LA NORMALE CHOISIE (PM.NORM)
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
      CHARACTER*24 APJEU,APJEFX,APJEFY,TANGCO
      INTEGER      JAPJEU,JAPJFX,JAPJFY,JTANGO
      REAL*8       COEF(30),COFX(30),COFY(30)      
      INTEGER      POSNSM(9)
      INTEGER      NBDDLT
      INTEGER      DDL(30)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C 
      APJEU  = RESOCO(1:14)//'.APJEU' 
      TANGCO = RESOCO(1:14)//'.TANGCO'         
      CALL JEVEUO(APJEU, 'E',JAPJEU) 
      IF (LCTFD) THEN
        APJEFX = RESOCO(1:14)//'.APJEFX'
        APJEFY = RESOCO(1:14)//'.APJEFY'
        CALL JEVEUO(APJEFX,'E',JAPJFX)
        CALL JEVEUO(APJEFY,'E',JAPJFY)
      ENDIF 
      CALL JEVEUO(TANGCO,'E',JTANGO)
C
C --- CALCUL DES COEFFICIENTS DES RELATIONS LINEAIRES 
C 
      CALL CFCOEF(NDIMG ,RESOCO,NBNOM ,POSNSM,COEFNO,
     &            POSNOE,NORM  ,TAU1  ,TAU2  ,COEF  ,
     &            COFX  ,COFY  ,NBDDLT,DDL   )
C
C --- MISE A JOUR DU JEU POUR LE CONTACT
C  
      ZR(JAPJEU+ILIAI-1)   = JEU      
C
C --- INITIALISATIONS JEUX FROTTEMENT EN 3D
C         
      IF (LCTF3D) THEN
        ZR(JAPJFX+ILIAI-1) = 0.D0
        ZR(JAPJFY+ILIAI-1) = 0.D0
      ENDIF 
C
C --- SAUVEGARDE TANGENTES
C
      ZR(JTANGO+6*(ILIAI-1)+1-1) = TAU1(1)
      ZR(JTANGO+6*(ILIAI-1)+2-1) = TAU1(2)
      ZR(JTANGO+6*(ILIAI-1)+3-1) = TAU1(3)
      ZR(JTANGO+6*(ILIAI-1)+4-1) = TAU2(1)
      ZR(JTANGO+6*(ILIAI-1)+5-1) = TAU2(2)
      ZR(JTANGO+6*(ILIAI-1)+6-1) = TAU2(3)
C
C --- COEFFICIENTS RELATIONS LINEAIRES APPARIEMENT 
C
      CALL CFCOEM(RESOCO,LCTFD ,LCTF3D,IP    ,POSNOE,
     &            NUMNOE,ILIAI ,NBDDLT,NBNOM ,POSNSM,
     &            DDL   ,COEF  ,COFX  ,COFY)   
C
      CALL JEDEMA()
      END
