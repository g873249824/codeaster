      SUBROUTINE INTMAM(DIME  ,NOMARL,
     &                  NOMMA1,TYPEM1,COORD1,NBNO1 ,H1,
     &                  NOMMA2,TYPEM2,COORD2,NBNO2 ,H2,
     &                  TRAVR ,TRAVI ,TRAVL ,NT)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_20
C
      IMPLICIT NONE
      INTEGER      DIME
      CHARACTER*8  NOMARL
      INTEGER      TRAVI(*)
      LOGICAL      TRAVL(*)
      REAL*8       TRAVR(*)
      CHARACTER*8  TYPEM1,TYPEM2
      CHARACTER*8  NOMMA1,NOMMA2            
      REAL*8       COORD1(*),COORD2(*)
      REAL*8       H1,H2
      INTEGER      NT
      INTEGER      NBNO1,NBNO2
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C   
C CALCUL DE L'INTERSECTION MAILLE / MAILLE
C      
C ----------------------------------------------------------------------
C
C
C IN  DIME   : DIMENSION DE L'ESPACE
C IN  NOMARL : NOM DE LA SD PRINCIPALE ARLEQUIN
C IN  TYPEM1 : TYPE DE LA PREMIERE MAILLE
C IN  NOMMA1 : NOM DE LA PREMIERE MAILLE
C IN  COORD1 : COORDONNEES DES NOEUDS DE LA PREMIERE MAILLE
C IN  NBNO1  : NOMBRE DE NOEUDS DE LA PREMIERE MAILLE
C IN  H1     : DIAMETRE DE LA PREMIERE MAILLE
C IN  TYPEM2 : TYPE DE LA SECONDE MAILLE
C IN  NOMMA2 : NOM DE LA SECONDE MAILLE
C IN  COORD2 : COORDONNEES DES NOEUDS DE LA SECONDE MAILLE
C IN  NBNO2  : NOMBRE DE NOEUDS DE LA SECONDE MAILLE
C IN  H2     : DIAMETRE DE LA SECONDE MAILLE
C I/O TRAVR  : IN  - VECTEURS DE TRAVAIL DE REELS 
C                DIME : 12 + 276*NHINT**2
C              OUT - COORDONNNEES DES NOEUDS DU PAVAGE DE L'INTERSECTION
C
C I/O TRAVI  : IN  - VECTEURS DE TRAVAIL D'ENTIERS
C                DIME : 56 + 1536*NHINT**2
C              OUT - CONNECTIVITE DU PAVAGE DE L'INTERSECTION
C                DIME : 3*NT EN 2D ET 4*NT EN 3D
C              *** EN 2D 
C              CONNECTIVITE TRIANGULATION (UNE LIGNE PAR TRIANGLE)
C                (SOMMET.1.1,SOMMET.1.2,SOMMET.1.3,
C                (SOMMET.2.1,SOMMET.2.2,SOMMET.2.3,...)
C              *** EN 3D 
C              CONNECTIVITE TETRAEDRISATION (UNE LIGNE PAR TETRA)
C                (SOMMET.1.1,SOMMET.1.2,SOMMET.1.3,SOMMET.1.4,
C                 SOMMET.2.1,SOMMET.2.2,SOMMET.2.3,SOMMET.2.4,)
C              L'INDEX DU SOMMET SE REFERE A SC (TRAVR)

C IN  TRAVL  : VECTEURS DE TRAVAIL DE BOOLEENS
C                DIME : 24*NHINT**2
C OUT NT     : NB TRIANGLES / TETRAEDRES PAVANT INTERSECTION
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER     ZMXARE,ZMXPAN,ZMXNOE
      PARAMETER   (ZMXARE = 48,ZMXPAN = 60,ZMXNOE = 27)   
C
C --- GENERATEUR PSEUDO-ALEATOIRE
C
      REAL*8      GRAMAX
      INTEGER     GRAIN0,GRAIN1,GRAINS(32)
      PARAMETER  (GRAMAX = 1073741823.D0)
C
      INTEGER     NHINT,NCMAX,NECH,ITEMCP
      INTEGER     ARLGEI
      REAL*8      ARLGER
      REAL*8      PRECCP,PRECTR,PRECIT,PRECVM
      REAL*8      DDOT,PLVOL2,PLVOL3
      LOGICAL     DEDANS
      INTEGER     NBSOM,NBARE,NBPAN         
      INTEGER     ARE1(ZMXARE),ARE2(ZMXARE)
      INTEGER     PAN1(ZMXPAN),PAN2(ZMXPAN)
      REAL*8      CSOM1(3*ZMXNOE),CSOM2(3*ZMXNOE)      
      INTEGER     NSOM
      INTEGER     NARE1,NARE2
      INTEGER     NSOM1,NSOM2
      INTEGER     NPAN1,NPAN2
      INTEGER     NFAC,NFAC1,NFAC2
      INTEGER     NSEG,NSEG1,NSEG2
      INTEGER     NTRI,NTET
      INTEGER     NC,PEQ,PZR,S1,S2,S3
      INTEGER     I,P,Q,IFAC,ISEG
      INTEGER     JNSC
      INTEGER     PFS,PAS,PAF 
      INTEGER     OFFSOM,OFFSEG,OFFFAC,OFFARE    
      REAL*8      V1,V2,VC,VOLMIN,G(3),PREC
      LOGICAL     IR
      REAL*8      BRUIT
      INTEGER     IFM,NIV      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('ARLEQUIN',IFM,NIV) 
C 
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> *** CALCUL INTERSECTION '//
     &               'MAILLE/MAILLE...'
        WRITE(IFM,*) '<ARLEQUIN> ... MAILLE 1         : ',
     &                NOMMA1,' - ',TYPEM1
        WRITE(IFM,*) '<ARLEQUIN> ... MAILLE 2         : ',
     &                NOMMA2,' - ',TYPEM2     
      ENDIF            
C
C --- PARAMETRES
C 
      PRECCP = ARLGER(NOMARL,'PRECCP')
      PRECIT = ARLGER(NOMARL,'PRECIT')
      PRECVM = ARLGER(NOMARL,'PRECVM')
      ITEMCP = ARLGEI(NOMARL,'ITEMCP')/10
      NHINT  = ARLGEI(NOMARL,'NHINT ')
      NCMAX  = ARLGEI(NOMARL,'NCMAX ')
      PRECTR = ARLGER(NOMARL,'PRECTR')          
C
C --- INITIALISATIONS
C
      IF (DIME.EQ.3) NCMAX = 2*NCMAX
      NT  = 0
      NC  = NHINT*NHINT
      PEQ = 13 + 144*NC
      PZR = 13 + 240*NC
      PFS = 33 + 888*NC
      PAS = 57 + 1176*NC
      PAF = 57 + 1356*NC 
      NSEG  = 0
      NFAC  = 0       
      CALL WKVECT('&&INTMAM.NSC','V V I',NCMAX,JNSC)
      GRAIN0 = 0 
C
C --- VERIFICATIONS
C      
      IF ((NBNO1.GT.ZMXNOE).OR.(NBNO2.GT.ZMXNOE)) THEN 
        CALL ASSERT(.FALSE.)
      ENDIF  
      IF ((DIME.LT.2).OR.(DIME.GT.3)) THEN 
        CALL ASSERT(.FALSE.)
      ENDIF      
C          
C --- VALEUR ECHANTILLONNAGE: NHINT CAR SUIVANT SCHEMA INTEGRATION      
C
      NECH   = NHINT
C      
C --- RECOPIE DES COORDONNES
C
      CALL DCOPY(DIME*NBNO1,COORD1,1,CSOM1,1)
      CALL DCOPY(DIME*NBNO2,COORD2,1,CSOM2,1)     
C      
C --- ORIENTATION DES MAILLES
C
      CALL ORIEM2(TYPEM1,CSOM1)
      CALL ORIEM2(TYPEM2,CSOM2)           
C
C --- BRUITAGE DES SOMMETS POUR EVITER CAS DE COINCIDENCE PARFAITE
C
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> ... BRUITAGE SOMMETS '
      ENDIF  
C
      DO 10 I = 1, NBNO1*DIME
        CALL HASARD(GRAIN0,GRAIN1,GRAINS,32) 
        BRUIT    =  PRECIT*H1*(((GRAIN1-1)/GRAMAX)-1.D0) 
        CSOM1(I) =  CSOM1(I) + BRUIT       
 10   CONTINUE
C
      DO 20 I = 1, NBNO2*DIME
        CALL HASARD(GRAIN0,GRAIN1,GRAINS,32) 
        BRUIT    =  PRECIT*H2*(((GRAIN1-1)/GRAMAX)-1.D0)      
        CSOM2(I) =  CSOM2(I) + BRUIT
 20   CONTINUE       
C
C --- CARACTERISTIQUES DES MAILLES: NBRE ARETES/PANS
C
      NBNO1 = NBSOM(TYPEM1)
      NBNO2 = NBSOM(TYPEM2)
      NARE1 = NBARE(TYPEM1)
      NARE2 = NBARE(TYPEM2)   
      NPAN1 = NBPAN(TYPEM1)
      NPAN2 = NBPAN(TYPEM2)  
C
C --- CARACTERISTIQUES DES MAILLES: CONNECTIVITES ARETES/PANS
C       
      CALL NOARE(TYPEM1,ARE1)
      CALL NOARE(TYPEM2,ARE2)   
      CALL NOPAN(TYPEM1,PAN1)
      CALL NOPAN(TYPEM2,PAN2) 
C
C --- ECHANTILLONNAGE DE LA FRONTIERE DES MAILLES 1&2
C --- STOCKAGE DES COORDONNEES FRONTIERE DANS TRAVR
C --- POINTS AJOUTES+SOMMETS ORIGINAUX
C
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> ... ECHANTILLONNAGE DE '//
     &               'LA FRONTIERE MAILLE 1 - CALCUL DES COORD.'
      ENDIF  
C      
      CALL ECHMAP(NOMMA1,TYPEM1,DIME  ,CSOM1 ,NBNO1 ,
     &            ARE1  ,NARE1 ,PAN1  ,NPAN1 ,NECH  ,
     &            TRAVR               ,NSOM1)      
C
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> ... ECHANTILLONNAGE DE '//
     &               'LA FRONTIERE MAILLE 2 - CALCUL DES COORD.'
      ENDIF       
C
      CALL ECHMAP(NOMMA2,TYPEM2,DIME  ,CSOM2 ,NBNO2 ,
     &            ARE2  ,NARE2 ,PAN2  ,NPAN2 ,NECH  ,
     &            TRAVR(1+DIME*NSOM1) ,NSOM2)
C
C --- NOUVEAU NOMBRE DE SOMMETS (AVEC ECHANTILLONNAGE)
C
      NSOM = NSOM1 + NSOM2
C
C --- CONNECTIVITE DE L'ECHANTILLONNAGE DE LA FRONTIERE DES MAILLES 1&2
C --- STOCKAGE DES CONNECTIVITES DANS TRAVI (TABLEAUX FS, AF, AS)
C
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> ... ECHANTILLONNAGE DE '//
     &               'LA FRONTIERE MAILLE 1 - '//
     &               'CALCUL DES CONNECTIVITES'
      ENDIF 
C
      OFFSOM = 0
      OFFSEG = 0
      OFFFAC = 0
      OFFARE = 0
C          
      CALL ECHMCO(NOMMA1,TYPEM1,DIME  ,NECH  ,
     &            NBNO1 ,NARE1 ,NPAN1 ,ARE1  ,PAN1  ,                 
     &            OFFSOM,OFFSEG,OFFFAC,OFFARE,
     &            PFS   ,PAS   ,PAF   ,
     &            TRAVI ,NSEG1 ,NFAC1)
C
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> ... ECHANTILLONNAGE DE '//
     &               'LA FRONTIERE MAILLE 2 - '//
     &               'CALCUL DES CONNECTIVITES'
      ENDIF       
C
      OFFSOM = NSOM1
      OFFSEG = NSEG1      
      OFFFAC = NFAC1
      OFFARE = NARE1
C
      CALL ECHMCO(NOMMA2,TYPEM2,DIME  ,NECH  ,
     &            NBNO2 ,NARE2 ,NPAN2 ,ARE2  ,PAN2  ,               
     &            OFFSOM,OFFSEG,OFFFAC,OFFARE,
     &            PFS   ,PAS   ,PAF   ,
     &            TRAVI ,NSEG2 ,NFAC2)
C
C --- NOMBRE D'ENTITES (SEGMENTS EN 2D, FACETTES EN 3D)
C
      IF (DIME.EQ.2) THEN
        NSEG  = NSEG1 + NSEG2
      ELSEIF (DIME.EQ.3) THEN
        NFAC  = NFAC1 + NFAC2
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF  
C
C --- VERIF ECRASEMENT MEMOIRE
C
      IF (PAS.LT.(PFS+3*NFAC)) THEN
        CALL ASSERT(.FALSE.)
      ENDIF         
C
C --- VOLUME DES DEUX POLYEDRES
C
      IF (DIME.EQ.2) THEN     
C
C --- REMISE DES SOMMETS DANS L'ORDRE: TRANSFERT DE PFS A PAS
C       
        P = PAS
        Q = PFS
        TRAVI(P) = NSOM1
        DO 30 I = 1, NSOM1
          P = P + 1
          TRAVI(P) = TRAVI(Q)
          Q = Q + 2
 30     CONTINUE
        P = P + 1 
        TRAVI(P) = NSOM2
        DO 40 I = 1, NSOM2
          P = P + 1
          TRAVI(P) = TRAVI(Q)
          Q = Q + 2
 40     CONTINUE
        V1 = PLVOL2(DIME ,TRAVR,TRAVR,TRAVI(PAS+1)      ,NSOM1)
        V2 = PLVOL2(DIME ,TRAVR,TRAVR,TRAVI(PAS+NSOM1+2),NSOM2)
        
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... SURFACE DE LA MAILLE 1: ',V1
          WRITE(IFM,*) '<ARLEQUIN> ... SURFACE DE LA MAILLE 2: ',V2
        ENDIF         
      ELSE
        V1 = PLVOL3(TRAVR,TRAVI(PFS)         ,NFAC1)
        V2 = PLVOL3(TRAVR,TRAVI(PFS+3*NFAC1) ,NFAC2)
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... VOLUME DE LA MAILLE  1: ',V1
          WRITE(IFM,*) '<ARLEQUIN> ... VOLUME DE LA MAILLE  2: ',V2
        ENDIF         
      ENDIF
C
      VOLMIN = PRECVM*MIN(V1,V2)     
C
C --- EQUATIONS DE DROITES / PLANS
C --- STOCKAGE DES COEFFICIENTS DANS TRAVR (TABLEAU EQ)
C EN 2D
C  -> TRAVR(PEQ->PEQ+3*NSEG) - LES 3 COEF. DES DROITES FRONTIERES
C         (INDICEE PAR NUMERO SEGMENT)
C EN 3D
C  -> TRAVR(PEQ->PEQ+4*NFAC) - LES 4 COEF. DES PLANS FRONTIERES
C         (INDICEE PAR NUMERO FACETTE)
C
C
      IF (DIME.EQ.2) THEN
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... EQUATIONS DES DROITES FRONTIERES'
        ENDIF  
        DO 50 ISEG = 1, NSEG
          P  = PFS + 2*ISEG
          S1 = 2*TRAVI(P-2)
          S2 = 2*TRAVI(P-1)
          P  = PEQ + 3*ISEG 
          TRAVR(P-3) = TRAVR(S2)   - TRAVR(S1)
          TRAVR(P-2) = TRAVR(S1-1) - TRAVR(S2-1)
          TRAVR(P-1) = TRAVR(S2-1)*TRAVR(S1) - TRAVR(S1-1)*TRAVR(S2)
 50     CONTINUE
      ELSE
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... EQUATIONS DES PLANS FRONTIERES ' 
        ENDIF       
        DO 60 IFAC = 1, NFAC
          P = PFS + 3*IFAC
          S1 = 3*TRAVI(P-3)-2
          S2 = 3*TRAVI(P-2)-2
          S3 = 3*TRAVI(P-1)-2
          P = PEQ + 4*IFAC - 4
          CALL PROVE3(TRAVR(S1),TRAVR(S2),TRAVR(S3),TRAVR(P))
          TRAVR(P+3) = -DDOT(3,TRAVR(P),1,TRAVR(S1),1)
 60     CONTINUE
      ENDIF
C
C --- INTERSECTION
C      
      IF (DIME.EQ.2) THEN
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... CALCUL DE L''INTERSECTION '//
     &                 'ENTRE LES DEUX POLYGONES'
        ENDIF       
        CALL PLINT2(TRAVR ,NSOM  ,TRAVI(PFS),TRAVR(PEQ),NCMAX ,
     &              NSEG1 ,NSEG2 ,TRAVR(PZR),TRAVI(PAS),TRAVL ,
     &              NC)
      ELSE
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... CALCUL DE L''INTERSECTION '//
     &                 'ENTRE LES DEUX POLYEDRES'         
        ENDIF 
        CALL PLINT3(TRAVR ,NSOM  ,TRAVI(PFS),TRAVR(PEQ),NCMAX,
     &              PRECTR,NFAC1 ,NFAC2     ,TRAVI(PAS),TRAVI(PAF),
     &              NARE1 ,NARE2 ,TRAVR(PZR),TRAVI,TRAVL,
     &              NC)   
        DO 70 I = 1, NC
          ZI(JNSC+I-1) = TRAVI(I)
 70     CONTINUE
      ENDIF
C      
C --- TROP DE COMPOSANTES CONNEXES
C
      IF (NC.GT.NCMAX) THEN
        CALL U2MESS('A','ARLEQUIN_24')  
      ENDIF      
C
C --- CAS DE L'INCLUSION
C
      IF (NC.EQ.0) THEN      
        IF (V1.LT.V2) THEN
          IF (NIV.GE.2) THEN
            WRITE(IFM,*) '<ARLEQUIN> ... PAS D''INTERSECTION MAIS '//
     &                 ' INCLUSION DE M1 DANS M2'
          ENDIF        
          PREC = H1*PRECCP
          IF (DIME.EQ.2) THEN
            CALL PLCENT(DIME,TRAVR,TRAVI(PFS),NSEG1,G)
          ELSE
            CALL PLCENT(DIME,TRAVR,TRAVI(PFS),NFAC1,G)
          ENDIF  
          CALL REFERE(G,CSOM2,DIME,TYPEM2,PREC,ITEMCP,.FALSE.,
     &                G,IR,TRAVR)
          IF (IR.AND.DEDANS(G,TYPEM2)) THEN
            NC = 1
            IF (DIME.EQ.2) THEN
              P = PAS
              Q = PFS
              TRAVI(P) = NSOM1
              DO 80 I = 1, NSOM1
                P = P + 1
                TRAVI(P) = TRAVI(Q)
                Q = Q + 2
 80           CONTINUE
            ELSE
              ZI(JNSC+1-1) = NFAC1
            ENDIF
          ENDIF
        ELSE
          IF (NIV.GE.2) THEN
            WRITE(IFM,*) '<ARLEQUIN> ... PAS D''INTERSECTION MAIS '//
     &                 ' INCLUSION DE M2 DANS M1'
          ENDIF         
          PREC = H2*PRECCP
          IF (DIME.EQ.2) THEN          
            CALL PLCENT(DIME,TRAVR,TRAVI(PFS+DIME*NFAC1),NSEG2,G)
          ELSE
            CALL PLCENT(DIME,TRAVR,TRAVI(PFS+DIME*NFAC1),NFAC2,G)
          ENDIF  
          CALL REFERE(G,CSOM1,DIME,TYPEM1,PREC,ITEMCP,.FALSE.,
     &                G,IR,TRAVR)  
          IF (IR.AND.DEDANS(G,TYPEM1)) THEN
            NC = 1
            IF (DIME.EQ.2) THEN
              P = PAS
              Q = PFS+2*NFAC1
              TRAVI(P) = NSOM2
              DO 90 I = 1, NSOM2
                P = P + 1
                TRAVI(P) = TRAVI(Q)
                Q = Q + 2
 90           CONTINUE
            ELSE
              ZI(JNSC+1-1) = NFAC2
              PFS = PFS+3*NFAC1
            ENDIF
          ENDIF
        ENDIF
      ENDIF
C
C --- TRIANGULATION / TETRAEDRISATION
C
      P = 1
      IF (DIME.EQ.2) THEN
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... TRIANGULATION DE L''INTERSECTION'
        ENDIF      
        DO 100 I = 1, NC
          NSOM = TRAVI(PAS)
          VC   = PLVOL2(2,TRAVR,TRAVR,TRAVI(PAS+1),NSOM)
          IF (VC.GT.VOLMIN) THEN
            CALL PLTRI2(2,TRAVR,TRAVR,TRAVI(PAS+1),NSOM,
     &                  PRECTR,TRAVI(P),NTRI)
            NT = NT + NTRI
            P = P + 3*NTRI
          ENDIF
          PAS = PAS + NSOM + 1
 100    CONTINUE
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... ON OBTIENT ',NT,' TRIANGLES'
        ENDIF   
      ELSE
        IF (NIV.GE.2) THEN
         WRITE(IFM,*) '<ARLEQUIN> ... TETRAEDRISATION '//
     &                'DE L''INTERSECTION'
        ENDIF       
        DO 110 I = 1, NC
          NFAC  = ZI(JNSC+1-1)
          VC    = PLVOL3(TRAVR,TRAVI(PFS),NFAC)
          IF (VC.GT.VOLMIN) THEN
            CALL PLTRI3(NOMMA1,NOMMA2,TRAVR,NSOM    ,TRAVI(PFS),
     &                  NFAC  ,VOLMIN,TRAVL,TRAVI(P),NTET)
            NT = NT + NTET
            P = P + 4*NTET
          ENDIF
          PFS = PFS + 3*NFAC
 110    CONTINUE
        IF (NIV.GE.2) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... ON OBTIENT ',NT,' TETRAEDRES'
        ENDIF  
      ENDIF
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> *** FIN DU CALCUL INTERSECTION '//
     &               'MAILLE/MAILLE'
      ENDIF      
C
      CALL JEDETR('&&INTMAM.NSC')
C
      CALL JEDEMA()      
C
      END
