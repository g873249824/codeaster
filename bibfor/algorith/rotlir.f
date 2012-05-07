      SUBROUTINE  ROTLIR (NOMRES,SST1,INTF1,LINO1,CODRET,INDIN1,
     &                    TRAMO1,DDLA1,NBEQ1,IMAST,NUMLIA)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/05/2012   AUTEUR ALARCON A.ALARCON 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    M. CORUS     DATE 02/02/10
C-----------------------------------------------------------------------
C  BUT:      < CALCUL DE LA TRACE DES MODES ORIENTES A L'INTERFACE >
C
C  CALCULER LES NOUVELLES MATRICE REDUITES DE LIAISON EN TENANT COMPTE
C  DE L'ORIENTATION DES SOUS-STRUCTURES.
C  ON DETERMINE LA MATRICE DE LIAISON, LES DIMENSIONS DE CES MATRICES
C  ET LE PRONO ASSOCIE
C
C  VERIFICATION DE LA COHERENCE DES INTERFACE EN VIS-A-VIS
C  GESTION DES LIAISONS INCOMPATIBLES
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UTILISATEUR DU RESULTAT
C SST1     /I/: NOM UTILISATEUR DE LA SOUS STRUCTURE
C INTF1    /I/: NOM UTILISATEUR DE L'INTERFACE
C LINO1 /I/: VECTEUR CONTENANT LA LISTE DES NOEUDS DE L'INTERFACE
C                 COURANTE
C CODRET   /I/: ENTIER PERMETTANT DE SAVOIR SI L'AUTRE "COTE" DE LA
C               MEME INTERFACE A DEJA ETE TRAITEE, POUR REORDONNER
C               LES NOEUDS
C NUMLIA   /I/: NUMERO DE LA LIAISON COURANTE
C INDIN1 /I/: VECTEUR CONTENANT LES INDICES ASSOCIES AUX DDL
C                 D'INTERFACE
C TRAMO1  /I/: MATRICE CONTENANT LA TRACE DES MODES ORIENTES
C DDLA1  /O/: NOMBRE DE DDL ACTIFS DE L'INTERFACE
C NBEQ1    /O/: NOMBRE DE MODES DANS LA BASE MODALE
C IMAST    /I/: ENTIER DETERMINANT SI ON CONSTRUIT :
C               -1 / -2 : LA MATRICE DE LIAISON STANDARD (C),
C                1 /  2 : LA MATRICE DE LIAISON PROJETEE (C.PHI)
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32 JEXNOM, JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C   PARAMETER REPRESENTANT LE NOMBRE MAX DE COMPOSANTES DE LA GRANDEUR
C   SOUS-JACENTE TRAITEE
C
      CHARACTER*8    NOMRES
      CHARACTER*1    K1BID
      CHARACTER*24   INT1,INDIN1,LINO1,MAINT1,RESTMO,TRAMO1,ORDOL
      CHARACTER*19   KINT
      CHARACTER*8    SST1,INTF1,LINT1,K8BID,BAMO1,
     &               KBID,NMACR1,TEMP,SST2
      CHARACTER*4    NLIAI
      INTEGER        IBID,NBNO1,LLINT1,NBEQ1,LMOD1,NUMLIA,LONMOD,
     &               I1,J1,K1,L1,M1,N1,LINDI1,LNOEU1,NBNOE,NBEC,
     &               IPOS1,IPOS2,LMAIN1,NBCMPM,LEULER,LRESMO,CODRET,
     &               LMACR1,NBDDL1,IMAST,DDLA1,LACT1,IRET,LMAROT,LENGTH
      PARAMETER      (NBCMPM=10)
      INTEGER        DECO(NBCMPM)
      REAL*8         EULER(3),ROTA(3,3),NORME,NORTOT,DDOT,R8PREM

C-----------C
C--       --C
C-- DEBUT --C
C--       --C
C-----------C

      CALL JEMARQ()

C-- RECUPERATION DU NOMBRE D'ENTIER CODES POUR LES DDL
      CALL DISMOI('F','NB_EC','DEPL_R','GRANDEUR',NBEC,KBID,IBID)
            
C--------------------------------------------------------C
C--                                                    --C
C-- RECUPERATION DE LA TRACE DES MODES SUR L'INTERFACE --C
C--                                                    --C
C--------------------------------------------------------C

C-- NOM DE LA BASE MODALE ET NOMBRE DE MODES
      CALL MGUTDM(NOMRES,SST1,IBID,'NOM_BASE_MODALE',IBID,BAMO1)
      CALL DISMOI('F','NB_MODES_TOT',BAMO1,'RESULTAT',
     &                      NBEQ1,KBID,IBID)
      
C-- INTERFACE AMONT DE LA SOUS-STRUCTURE
      CALL MGUTDM(NOMRES,SST1,IBID,'NOM_LIST_INTERF',IBID,LINT1)
      
C-- NOMBRE DE NOEUDS DE L'INTERFACE
      INT1=LINT1//'.IDC_LINO'
      CALL JENONU(JEXNOM(INT1(1:13)//'NOMS',INTF1),IBID)
      CALL JELIRA(JEXNUM(INT1,IBID),'LONMAX',NBNO1,K8BID)

C-- LISTE DES NUMEROS DES NOEUDS DE L'INTERFACE
      CALL JENONU(JEXNOM(LINT1 //'.IDC_NOMS',INTF1),IBID)
      CALL JEVEUO(JEXNUM(LINT1 //'.IDC_LINO',IBID),'L',
     &                LLINT1)

C-- NUMEROTATION DES NOEUDS DE L'INTERFACE DANS LES MAILLAGES INITAUX
      CALL WKVECT(LINO1,'V V I',NBNO1,LNOEU1)
      CALL BMNOIN(BAMO1,KBID,INTF1,IBID,NBNO1,ZI(LNOEU1),NBNOE)

C-- SI UNE AUTRE INTERFACE A DEJA ETE DEFINIE, ON REORDONNE LA LISTE 
C-- COURANTE POUR QUE LES NOEUDS TOMBENT "EN FACE"

      IF (CODRET .GT. 0) THEN
           TEMP='&&OP0126'
           CALL CODENT(NUMLIA,'D',NLIAI)
           ORDOL=TEMP//'      .LINO.'//NLIAI
           
           CALL JEEXIN(ORDOL,IRET)
           
           IF (IRET .NE. 0) THEN
             CALL JEVEUO(ORDOL,'L',L1)
             CALL WKVECT('&&VECTEUR_NOEUDS_TEMP','V V I',NBNO1,M1)
             CALL WKVECT('&&VECTEUR_INDICES_TEMP','V V I',NBNO1,N1)
             DO 10 I1=1,NBNO1
               ZI(M1+I1-1)=ZI(LNOEU1+I1-1)
               DO 20 J1=1,NBNO1
                 IF (ZI(L1+I1-1) .EQ. ZI(LLINT1+J1-1) ) THEN
                   ZI(N1+I1-1)=J1
                 ENDIF
  20           CONTINUE
  10         CONTINUE
             DO 30 I1=1,NBNO1
               ZI(LNOEU1+I1-1)=ZI(M1+ZI(N1+I1-1)-1)
  30         CONTINUE
             CALL JEDETR('&&VECTEUR_NOEUDS_TEMP')
             CALL JEDETR('&&VECTEUR_INDICES_TEMP')
           ENDIF
             
      ENDIF

C-- RECUPERATION DES INDICES CORRESPONDANT AUX DDL D'INTERFACE
C-- DANS LA NUMEROTATION DES MAILLAGES INITIAUX
      CALL MGUTDM(NOMRES,SST1,IBID,'NOM_MACR_ELEM',IBID,NMACR1)
                    
C-- RECUPERATION DE LA NUMEROTATION DES EQUATIONS                    
      CALL JEVEUO(JEXNUM(NMACR1//'      .NUME.PRNO',1),
     &                'L',LMACR1)

C-- REMPLISSAGE DES VECTEURS D'INDICES POUR REPERER LES DDL  D'INTEFACE
      NBDDL1=6*NBNO1
      CALL JEEXIN(INDIN1,IRET)
      IF (IRET .EQ. 0) THEN
        CALL WKVECT(INDIN1,'V V I',NBDDL1,LINDI1)
      ELSE
        CALL JEVEUO(INDIN1,'L',LINDI1)  
      ENDIF
              
C-- ON NE TRAITE QUE LES DDL DX DY DZ DRX DRY ET DRZ
C-- RENVOYER UNE ERREUR OU UN WARNING SINON
      DDLA1=0    
      DO 40 I1=1,NBNO1
        IPOS1=ZI(LMACR1+(ZI(LNOEU1+I1-1)-1)*(2+NBEC))
        CALL ISDECO(ZI(LMACR1+(ZI(LNOEU1+I1-1)-1)*(2+NBEC)+2),
     &              DECO,NBCMPM)
        IPOS2=0
        DO 50,K1=1,6
          IF (IRET .EQ. 0) THEN
            ZI(LINDI1+(I1-1)*6+K1-1)=(IPOS1+IPOS2)*DECO(K1)
          ENDIF  
          IPOS2=IPOS2+DECO(K1)
          DDLA1=DDLA1+DECO(K1)
  50    CONTINUE
  40  CONTINUE

C-- ALLOCATION DE LA PLACE POUR LES MATRICES TEMPORAIRES
      MAINT1='&&MATR_TEMP_MO_INT1'
      RESTMO='&&VECT_MODE_NOEUD_6DDL'
      CALL WKVECT(RESTMO,'V V R',6,LRESMO) 
      
C
C-- IL DOIT Y AVOIR MOYEN D'OPTIMISER LE PROCESS
C-- D'EXTRACTION / ROTATION / REMPLISSAGE
C-- MAIS LA, CA MARCHE...
C 

C--
C-- CAS DE LA MATRICE IDENTITE SEULE, POUR CONSTRUIRE
C-- ENSUITE D'OBSERVATION C AVEC LIPSRB
C--
      IF (IMAST .LT. 0) THEN

C-- DANS CE CAS, LA MATRICE EST UNE "IDENTITE", QUI EST ENSUITE 
C-- MULTIPLIEE PAR UNE MATRICE DIAGONALE PAR BLOC, OU CHAQUE BLOC
C-- EST UNE MATRICE DE ROTATION. POUR GAGNER DE LA PLACE ET DU
C-- TEMPS, ON NE STOCKE QU'UN SEUL BLOC

        NBEQ1=DDLA1
        
        CALL WKVECT(MAINT1,'V V R',NBDDL1*DDLA1,LMAIN1)        
        
        IF (DDLA1 .EQ. NBDDL1) THEN
           DO 260 J1=1,DDLA1
               ZR(LMAIN1+(J1-1)*(DDLA1+1))=1.0D0
  260      CONTINUE
        ENDIF
        IF (2*DDLA1 .EQ. NBDDL1) THEN
           L1=0
           M1=0
           DO 270 J1=1,DDLA1
               ZR(LMAIN1+(J1-1)*NBDDL1+L1+M1)=1.0D0
               L1=L1+1
               IF (L1 .EQ. 3) THEN
                 M1=M1+6
                 L1=0
               ENDIF
  270      CONTINUE
        ENDIF
        IF ((DDLA1-NBDDL1)*(2*DDLA1-NBDDL1) .NE. 0) THEN
          WRITE(6,*)'SEULS LES ELEMENTS PORTANT (DX,DY,DZ) OU ',
     &'(DX,DY,DZ,DRX,DRY,DRZ) SONT SUPPORTES'
        ENDIF
        
C-- RECUPERATION DE LA MATRICE DE ROTATION DE LA SST ESCLAVE
        CALL JEVEUO(JEXNUM(NOMRES//'      .MODG.LIDF',NUMLIA),'L',J1)
        IF (SST1 .EQ. ZK8(J1)) THEN
          SST2=ZK8(J1+2)
        ELSE
          SST2=ZK8(J1)
        ENDIF        
        
C-- CALCUL DE MATRICE DE ROTATION POUR LA SOUS STRUCTURE
C--  => IL FAUT CONSTRUIRE LA MATRICE INVERSE 
        CALL JENONU(JEXNOM(NOMRES//'      .MODG.SSNO',SST2),IBID)
        CALL JEVEUO(JEXNUM(NOMRES//'      .MODG.SSOR',IBID),
     &              'L',LEULER)
        DO 75 I1=1,3
          EULER(I1)=-ZR(LEULER+I1-1)
   75   CONTINUE
   
        CALL ROTATI(EULER,ROTA)
C        CALL WKVECT('&&ROTLIR.MATR_ROTATION','V V R',
C     &               DDLA1*DDLA1,LMAROT)
        CALL WKVECT('&&ROTLIR.MATR_ROTATION','V V R',
     &               9,LMAROT)

C-- REMPLISSAGE DE LA MATRICE DE ROTATION
C        DO 280 I1=1,DDLA1
        DO 280 I1=1,3
          J1=((I1-1)/3)+1
          L1=I1-(J1-1)*3

C          IBID=LMAROT+(I1-1)*DDLA1
          IBID=LMAROT+(I1-1)*3
          
          ZR(IBID+(J1-1)*3  )=ROTA(1,L1)
          ZR(IBID+(J1-1)*3+1)=ROTA(2,L1)
          ZR(IBID+(J1-1)*3+2)=ROTA(3,L1)
          
  280   CONTINUE
  
  

  
      ELSEIF (IMAST .GT. 0) THEN
C--
C-- CAS DE LA TRACE DES MODES
C--

C-- CALCUL DE MATRICE DE ROTATION POUR LA SOUS STRUCTURE
        CALL JENONU(JEXNOM(NOMRES//'      .MODG.SSNO',SST1),IBID)
        CALL JEVEUO(JEXNUM(NOMRES//'      .MODG.SSOR',IBID),
     &              'L',LEULER)
        DO 65 I1=1,3
          EULER(I1)=ZR(LEULER+I1-1)
   65   CONTINUE
        CALL ROTATI(EULER,ROTA)
        
C-- ALLOCATION DE LA PLACE POUR LES MATRICES TEMPORAIRES
        CALL WKVECT(MAINT1,'V V R',NBDDL1*NBEQ1,LMAIN1)

C-- EXTRACTION ET ROTATION DE LA TRACE DES MODES SUR L'INTERFACE
C
        CALL JEVEUO(JEXNUM(BAMO1//'           .TACH',1),'L',LMOD1)
        DO 80 I1=1,NBEQ1
          KINT = ZK24(LMOD1+I1-1)(1:19)
          CALL JEVEUO(KINT//'.VALE','L',IBID)
          
          IF (I1 .EQ. 1) THEN
            CALL JELIRA(KINT//'.VALE','LONMAX',LONMOD,K1BID)
          ENDIF
          
          NORME=0.D0
          LENGTH=0
          DO 90 J1=1,NBNO1
C-- REMPLISSAGE TEMPORAIRE DE LA RESTRICTION DU MODE AUX 6 DDL 
C-- DU NOEUD J1           
            DO 100 K1=1,6
              IF (ZI(LINDI1+(J1-1)*6+K1-1) .GT. 0) THEN
                ZR(LRESMO+K1-1)=
     &             ZR(IBID+ZI(LINDI1+(J1-1)*6+K1-1)-1)
                LENGTH=LENGTH+1
                NORME=NORME+ZR(LRESMO+K1-1)**2
              ELSE
                 ZR(LRESMO+K1-1)=0.D0
              ENDIF
  100       CONTINUE
  
C-- ROTATION DU VECTEUR RESTRICTION
            DO 110 K1=1,6
              L1=INT(MOD(K1-1,3)+1)
              M1=INT(INT((K1-1)/3)*3)             
              ZR(LMAIN1+(I1-1)*NBDDL1+(J1-1)*6+K1-1)=
     &           ROTA(L1,1)*ZR(LRESMO+M1)+
     &           ROTA(L1,2)*ZR(LRESMO+M1+1)+
     &           ROTA(L1,3)*ZR(LRESMO+M1+2)
  110       CONTINUE
  90      CONTINUE
          
C-- ON ANNULE BRUTALEMENT LES DEPLACEMENTS DES MODES 
C--   DONT ON PENSE QUE L'INTERFACE EST FIXE
C-- SINON, ON GENERE DES PATHOLOGIE DANS LA RECHERCHE 
C--   DES RELATIONS INDEPENDANTES

          NORTOT=SQRT(DDOT(LONMOD,ZR(IBID-1),1,ZR(IBID-1),1))
         
          IF (SQRT(NORME)/LENGTH .LT. 100.D0*R8PREM()*NORTOT) THEN
            DO 101 K1=1,NBDDL1
              ZR(LMAIN1+(I1-1)*NBDDL1+K1-1)=0.D0
  101       CONTINUE          
          ENDIF 
  
  80    CONTINUE
  
      ELSE
C-- POUR EVITER DES CALCULS 
        GOTO 9999      
      ENDIF

C
C-- TRI DES MATRICES POUR ELIMINER LES LIGNES DES DDL NON REPRESENTES
C  
      CALL WKVECT(TRAMO1,'V V R',DDLA1*NBEQ1,LACT1)
      CALL CODENT(NUMLIA,'D0',K1BID)
      
      DO 180 J1=1,NBEQ1
        IBID=0
        DO 190 I1=1,NBDDL1
          IF (ZI(LINDI1+I1-1) .GT. 0) THEN
            ZR(LACT1+DDLA1*(J1-1)+IBID)=
     &         ZR(LMAIN1+NBDDL1*(J1-1)+I1-1)
            IBID=IBID+1 
          ENDIF
  190   CONTINUE
  180 CONTINUE

        

      CALL JEDETR(MAINT1)
C---------C
C--     --C
C-- FIN --C
C--     --C
C---------C

9999  CONTINUE
      CALL JEDETR(RESTMO)
      CALL JEDEMA()
      END
