      SUBROUTINE GDIREC ( NOMA, FOND, CHAINE, NOMOBJ, NOMNOE, COORN,
     &                    NBNOEU, DIRE3, MILIEU )
      IMPLICIT REAL*8 (A-H,O-Z)
C
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 16/04/2002   AUTEUR DURAND C.DURAND 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C
C FONCTION REALISEE:
C
C     POUR CHAQUE NOEUD DU FOND DE FISSURE GAMM0 ON CALCULE
C     LA DIRECTION DU CHAMP THETA
C
C     ETAPE 1 :
C              RECUPERER TOUTES LES MAILLES D'UNE LEVRE CONTENANT GAMM0
C              PUIS TRI SUR CELLES AYANT 2 NOEUDS APPARTENANT A GAMM0
C
C     ETAPE 2 :
C               CALCUL POUR CHAQUE NOEUDS DE GAMM0 DE LA DIRECTION
C                  CAS TRIA : APPEL 1 FOIS A GDIRE3
C                  CAS QUAD : APPEL 2 FOIS A GDIRE3 ET MOYENNE
C ENTREE:
C     ------------------------------------------------------------------
C        NOMA   : NOM DU MAILLAGE
C        FOND   : NOM DU CONCEPT DE DEFI_FOND_FISS
C        CHAINE : 'LEVRESUP' OU 'LEVREINF'
C        NOMOBJ : NOM DE L'OBJET CONTENANT LES NOMS DE NOEUDS
C        NOMNOE : NOMS DES NOEUDS
C        COORN  : NOM DE L'OBJET CONTENANT LES COORDONNEES DES NOEUDS
C        NBNOEU : NOMBRE DE NOEUDS DE GAMM0
C
C SORTIE:
C        DIRE3 : OBJET CONTENANT LA DIRECTION DE THETA
C        MILIEU: .TRUE.  : ELEMENT QUADRATIQUE
C                .FALSE. : ELEMENT LINEAIRE
C     ------------------------------------------------------------------
C
      CHARACTER*24  OBJ3,DIRE1,DIRE2,DIRE3,NUMNO
      CHARACTER*24  CONEX,NOMOBJ,COORN
      CHARACTER*8   FOND,NOMA,NOEUD,MODELE,NOEUG,NOMNO2
      CHARACTER*8   MAILLE,CHAINE,TYPE, NOMNOE(*)
C
      INTEGER       NBNOEU,LOBJ3,COMPTA,COMPTC,NN,LONG
      INTEGER       IADMA1,IADMA3,IADRCO,IAMASE,INUMNO
      INTEGER       INORM1,INORM2,NOEUD1,NOEUD2,NOEUD4,IADRLV
      INTEGER       K1,K2,K3,K4,MC,PERMU
C
      REAL*8        COORD(3,4),A1,A2,A3,B1,B2,B3,C1,C2,C3
      REAL*8        S1,S2,S3,DIR1,DIR2,DIR3,NORME
C
      LOGICAL       SOMMET,MILIEU
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON/IVARJE/ZI(1)
      COMMON/RVARJE/ZR(1)
      COMMON/CVARJE/ZC(1)
      COMMON/LVARJE/ZL(1)
      COMMON/KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXNOM,JEXNUM
      CHARACTER*80 ZK80
      CHARACTER*1 K1BID
C---------------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------
C
C OBJETS DEFINISSANT LA CONNECTIVITE  ET LE TYPE DES MAILLES
C
      CALL JEMARQ()
      CONEX = NOMA//'.CONNEX'
      CALL JEVEUO (NOMA//'.TYPMAIL','L',IATYMA)
C
C OBJET CONTENANT LES MAILLES DE LA LEVRE
C
      OBJ3 = FOND//'.'//CHAINE//'  .MAIL'
      CALL JELIRA (OBJ3,'LONMAX',LOBJ3,K1BID)
      CALL JEVEUO (OBJ3,'L',IADRLV)
      CALL JEVEUO (COORN,'L',IADRCO)
C
C ALLOCATION D'OBJETS DE TRAVAIL
C
      DIRE1 = '&&DIRECT.MAIL1'//'          '
      DIRE2 = '&&DIRECT.MAIL2'//'          '
      NUMNO = '&&NUME        '//'          '
      CALL WKVECT(DIRE1,'V V K8',3*NBNOEU,IADMA1)
      CALL WKVECT(DIRE2,'V V K8',NBNOEU-1,IADMA3)
      CALL WKVECT(DIRE3,'V V R',3*NBNOEU,IN2)
      CALL WKVECT(NUMNO,'V V I',2*LOBJ3,INUMNO)
C
C ON RECUPERE LES MAILLES DE LA LEVRE QUI CONTIENNENT
C UN NOEUD DE GAMM0
C
      COMPTA = 0
      DO 200 I=1,NBNOEU
        DO 150 J=1,LOBJ3
          CALL JENONU (JEXNOM(NOMA//'.NOMMAI',ZK8(IADRLV+J-1)),IBID)
          CALL JEVEUO (JEXNUM(CONEX,IBID),'L',IAMASE)
          IADTYP=IATYMA-1+IBID
          CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(IADTYP)),TYPE)
          IF(TYPE(1:4).EQ.'QUAD') THEN
            NN = 4
          ELSE IF(TYPE(1:4).EQ.'TRIA') THEN
            NN = 3
          ELSE
            CALL UTMESS('F','GDIREC','LE TYPE DES MAILLES DES
     &                     LEVRES DOIT ETRE QUADRANGLE OU TRIANGLE')
          ENDIF
          DO 100 K=1,NN
            CALL JENUNO(JEXNUM(NOMOBJ,ZI(IAMASE+K-1)),NOEUG)
            IF(NOEUG.EQ.NOMNOE(I)) THEN
              ZK8(IADMA1+COMPTA+1-1) = ZK8(IADRLV+J-1)
              COMPTA = COMPTA + 1
              ZI(INUMNO+COMPTA-1) = I
            ENDIF
100       CONTINUE
150     CONTINUE
200   CONTINUE
C
      COMPTC = 0
      DO 351 I=1,COMPTA-1
        IF(ZK8(IADMA1+I-1).NE.'0') THEN
          DO 451 J=I+1,COMPTA
            IF(ZI(INUMNO+J-1) .LT.  (ZI(INUMNO+I-1)+3))THEN
              IF(ZK8(IADMA1+I-1).EQ.ZK8(IADMA1+J-1))THEN
                ZK8(IADMA3+COMPTC+1-1) = ZK8(IADMA1+J-1)
                ZK8(IADMA1+J -1) = '0'
                COMPTC = COMPTC + 1
              ENDIF
            ENDIF
451       CONTINUE
        ENDIF
351   CONTINUE
C
C  CALCUL DE LA DIRECTION DE THETA POUR LES NOEUDS DE GAMMO
C
      A1 = 0.D0
      B1 = 0.D0
      C1 = 0.D0
      MC = 1
      SOMMET = .TRUE.
      DO 500 I=1,NBNOEU
         S1 = A1
         S2 = B1
         S3 = C1
C
         K1 = 0
         IF((SOMMET).AND.(I.NE.NBNOEU)) THEN
           CALL JENONU (JEXNOM(NOMA//'.NOMMAI',ZK8(IADMA3+MC-1)),IBID)
           CALL JEVEUO (JEXNUM(CONEX,IBID),'L',IAMASE)
           IADTYP=IATYMA-1+IBID
           CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(IADTYP)),TYPE)
           IF(TYPE(1:4).EQ.'QUAD') THEN
             NN = 4
             IF(TYPE(5:5).EQ.'4') THEN
               SOMMET = .TRUE.
               MILIEU = .FALSE.
             ELSE
               SOMMET = .FALSE.
               MILIEU = .TRUE.
             ENDIF
           ELSE IF(TYPE(1:4).EQ.'TRIA') THEN
             NN = 3
             IF(TYPE(5:5).EQ.'3') THEN
               SOMMET = .TRUE.
               MILIEU = .FALSE.
             ELSE
               SOMMET = .FALSE.
               MILIEU = .TRUE.
             ENDIF
           ENDIF
           MC = MC + 1
           DO 600 K=1,NN
             CALL JENUNO(JEXNUM(NOMOBJ,ZI(IAMASE+K-1)),NOEUG)
             IF(NOEUG.EQ.NOMNOE(I)) THEN
               K1 = K
             ENDIF
600        CONTINUE
           K2 = K1+1
           K3 = K1+2
           IF(K2.GE.(NN+1)) THEN
             K2 = MOD(K2,NN)
           ENDIF
           IF(K3.GE.(NN+1)) THEN
             K3 = MOD(K3,NN)
           ENDIF
           NOEUD1 = ZI(IAMASE+K1-1)
           NOEUD2 = ZI(IAMASE+K2-1)
           NOEUD3 = ZI(IAMASE+K3-1)
C
           IF(TYPE(1:4).EQ.'TRIA') THEN
             INO2 = 0
             DO 550 IL=1,NBNOEU
               CALL JENUNO(JEXNUM(NOMOBJ,NOEUD2),NOMNO2)
               IF(NOMNO2.EQ.NOMNOE(IL)) THEN
                 INO2 = INO2 + 1
               ENDIF
550          CONTINUE
             IF (INO2.EQ.0) THEN
               PERMU  = NOEUD2
               NOEUD2 = NOEUD3
               NOEUD3 = PERMU
             ENDIF
             COORD(1,1) = ZR(IADRCO+(NOEUD1-1)*3+1-1)
             COORD(1,2) = ZR(IADRCO+(NOEUD2-1)*3+1-1)
             COORD(1,3) = ZR(IADRCO+(NOEUD3-1)*3+1-1)
             COORD(2,1) = ZR(IADRCO+(NOEUD1-1)*3+2-1)
             COORD(2,2) = ZR(IADRCO+(NOEUD2-1)*3+2-1)
             COORD(2,3) = ZR(IADRCO+(NOEUD3-1)*3+2-1)
             COORD(3,1) = ZR(IADRCO+(NOEUD1-1)*3+3-1)
             COORD(3,2) = ZR(IADRCO+(NOEUD2-1)*3+3-1)
             COORD(3,3) = ZR(IADRCO+(NOEUD3-1)*3+3-1)
             CALL GDIRE3(COORD,A1,B1,C1,1)
             IF(I.EQ.1) THEN
               ZR(IN2+(I-1)*3+1-1) = A1
               ZR(IN2+(I-1)*3+2-1) = B1
               ZR(IN2+(I-1)*3+3-1) = C1
             ELSE
               DIR1 = (A1+S1)/2
               DIR2 = (B1+S2)/2
               DIR3 = (C1+S3)/2
               NORME = SQRT(DIR1*DIR1 + DIR2*DIR2 + DIR3*DIR3)
               ZR(IN2+(I-1)*3+1-1) = DIR1/NORME
               ZR(IN2+(I-1)*3+2-1) = DIR2/NORME
               ZR(IN2+(I-1)*3+3-1) = DIR3/NORME
             ENDIF
           ENDIF
           IF(TYPE(1:4).EQ.'QUAD') THEN
             K4 = K1+3
             IF(K4.GE.(NN+1)) THEN
               K4 = MOD(K4,NN)
             ENDIF
             NOEUD4 = ZI(IAMASE+K4-1)
             INO2 = 0
             DO 650 IR=1,NBNOEU
               CALL JENUNO(JEXNUM(NOMOBJ,NOEUD2),NOMNO2)
               IF(NOMNO2.EQ.NOMNOE(IR)) THEN
                 INO2 = INO2 + 1
               ENDIF
650          CONTINUE
             IF (INO2.EQ.0) THEN
               PERMU  = NOEUD2
               NOEUD2 = NOEUD4
               NOEUD4 = PERMU
             ENDIF
             COORD(1,1) = ZR(IADRCO+(NOEUD1-1)*3+1-1)
             COORD(1,2) = ZR(IADRCO+(NOEUD2-1)*3+1-1)
             COORD(1,3) = ZR(IADRCO+(NOEUD3-1)*3+1-1)
             COORD(1,4) = ZR(IADRCO+(NOEUD4-1)*3+1-1)
             COORD(2,1) = ZR(IADRCO+(NOEUD1-1)*3+2-1)
             COORD(2,2) = ZR(IADRCO+(NOEUD2-1)*3+2-1)
             COORD(2,3) = ZR(IADRCO+(NOEUD3-1)*3+2-1)
             COORD(2,4) = ZR(IADRCO+(NOEUD4-1)*3+2-1)
             COORD(3,1) = ZR(IADRCO+(NOEUD1-1)*3+3-1)
             COORD(3,2) = ZR(IADRCO+(NOEUD2-1)*3+3-1)
             COORD(3,3) = ZR(IADRCO+(NOEUD3-1)*3+3-1)
             COORD(3,4) = ZR(IADRCO+(NOEUD4-1)*3+3-1)
             CALL GDIRE3(COORD,A2,B2,C2,1)
             CALL GDIRE3(COORD,A3,B3,C3,2)
             A1 = (A2+A3)/2
             B1 = (B2+B3)/2
             C1 = (C2+C3)/2
             IF(I.EQ.1) THEN
               ZR(IN2+(I-1)*3+1-1) = A1
               ZR(IN2+(I-1)*3+2-1) = B1
               ZR(IN2+(I-1)*3+3-1) = C1
             ELSE
               DIR1 = (A1+S1)/2
               DIR2 = (B1+S2)/2
               DIR3 = (C1+S3)/2
               NORME = SQRT(DIR1*DIR1 + DIR2*DIR2 + DIR3*DIR3)
               ZR(IN2+(I-1)*3+1-1) = DIR1/NORME
               ZR(IN2+(I-1)*3+2-1) = DIR2/NORME
               ZR(IN2+(I-1)*3+3-1) = DIR3/NORME
             ENDIF
           ENDIF
         ELSE IF(.NOT.(SOMMET).OR.(I.EQ.NBNOEU)) THEN
           ZR(IN2+(I-1)*3+1-1) = S1
           ZR(IN2+(I-1)*3+2-1) = S2
           ZR(IN2+(I-1)*3+3-1) = S3
           SOMMET = .TRUE.
         ENDIF
500   CONTINUE
C
C  CAS DU FOND DE FISSURE FERME, ON MOYENNE LES VECTEURS A CHAQUE
C  EXTREMITE
C
      IF ( NOMNOE(1) . EQ . NOMNOE(NBNOEU) ) THEN
           DIR1 = ( ZR(IN2+(1     -1)*3+1-1)+
     &              ZR(IN2+(NBNOEU-1)*3+1-1)  )/2
           DIR2 = ( ZR(IN2+(1     -1)*3+2-1)+
     &              ZR(IN2+(NBNOEU-1)*3+2-1)  )/2
           DIR3 = ( ZR(IN2+(1     -1)*3+3-1)+
     &              ZR(IN2+(NBNOEU-1)*3+3-1)  )/2
           NORME = SQRT(DIR1*DIR1 + DIR2*DIR2 + DIR3*DIR3)
           ZR(IN2+(1     -1)*3+1-1) = DIR1/NORME
           ZR(IN2+(1     -1)*3+2-1) = DIR2/NORME
           ZR(IN2+(1     -1)*3+3-1) = DIR3/NORME
           ZR(IN2+(NBNOEU-1)*3+1-1) = DIR1/NORME
           ZR(IN2+(NBNOEU-1)*3+2-1) = DIR2/NORME
           ZR(IN2+(NBNOEU-1)*3+3-1) = DIR3/NORME
      ENDIF
C
C DESTRUCTION D'OBJETS DE TRAVAIL
C
      CALL JEDETR (DIRE1)
      CALL JEDETR (DIRE2)
      CALL JEDETR (NUMNO)
C
      CALL JEDEMA()
      END
