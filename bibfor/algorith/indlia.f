      SUBROUTINE INDLIA(MODGEN,SELIAI,NINDEP,NBDDL,SST,SIZLIA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/06/2010   AUTEUR CORUS M.CORUS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    M. CORUS     DATE 25/01/10
C-----------------------------------------------------------------------
C
C  BUT:      < CONSTRUIRE LE SOUS ESPACE POUR L'ELIMINATION >
C
C  ON IMPOSE DES LIAISONS DU TYPE C.Q=0. ON CONSTRUIT UN BASE R DU NOYAU
C  DE C. LES DDL GENERALISEES Y VERIFIENT DONC NATURELLEMENT C.R.Y=0, ET
C  Q=R.Y
C
C-----------------------------------------------------------------------
C  MODGEN  /I/ : NOM DU CONCEPT DE MODELE GENERALISE
C  SELIAI  /O/ : BASE DU NOYAU DES EQUATIONS DE LIAISON
C  NINDEP  /O/ : NOMBRE DE LIAISONS INDEPENDANTES ENTRE LES SOUS 
C                  STRUCTURES
C  NBDDL   /O/ : NOMBRE DE DDL IMPLIQUES DANS LES LIAISONS
C  SST     /O/ : VECTEUR CONTENANT LES NOMS DES SOUS STRUCTURES
C  SIZLIA  /O/ : VECTEUR CONTENANT LE NB DE DDL DE CHAQUE SOUS STRUCTURE
C-----------------------------------------------------------------------

      IMPLICIT NONE
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

C-- VARIABLES EN ENTREES / SORTIE
      INTEGER      NINDEP,NBDDL
      CHARACTER*8  MODGEN
      CHARACTER*24 SELIAI,SIZLIA,SST
      
C-- VARIABLES DE LA ROUTINE  
      INTEGER      I1,J1,K1,L1,M1,N1,BIDON,NBSST,NBLIA,NE,ND1,ND2,
     &             NUMLIA,LNOLI1,LNOLI2,NEDEC,ND1DEQ,
     &             ND2DEQ,NBEQT,INDS,LDS,LDELIA,
     &             LLPROF,LNOLIA,LKNOMS,LMALIA,LMATS,
     &             LMATU,LMATV,LSILIA,LWORK,JWORK,JIWORK,LDVT,NM2,
     &             INFO,LSELIA,LTAU,NEQ,LDIAQR
      
      CHARACTER*8  INT1,INT2,K8BID
      CHARACTER*24 DEFLIA,FPROFL,NOMSST,NOMLIA,MATLIA,MATS,MATU,MATV
      REAL*8       EPS,TOL,SWORK,TEMP
      PARAMETER    (EPS=2.3D-16)

C-----------C
C--       --C     
C-- DEBUT --C
C--       --C
C-----------C
            
      CALL JEMARQ()
            
C----------------------------------------------C
C--                                          --C
C-- INITIALISATION DES DIFFERENTES GRANDEURS --C
C--                                          --C
C----------------------------------------------C

      DEFLIA=MODGEN//'      .MODG.LIDF'
      FPROFL=MODGEN//'      .MODG.LIPR'
      NOMSST=MODGEN//'      .MODG.SSNO'
      NOMLIA=MODGEN//'      .MODG.LIMA'

C-- NOMBRE DE SOUS STRUCTURES      
      CALL JELIRA(NOMSST,'NOMMAX',NBSST,K8BID)

C-- NOMBRE D'INTERFACES      
      CALL JELIRA(DEFLIA,'NMAXOC',NBLIA,K8BID) 
    
C-- LISTE DES NOMS DES SOUS-STRUCTURES
      CALL WKVECT(SST,'G V K8',NBSST,LKNOMS)

C-- LISTE DES TAILLES DES SOUS-STRUCTURES
      CALL WKVECT(SIZLIA,'G V I',NBSST,LSILIA)
      
C-- ON DETERMINE LA TAILLE DE LA MATRICE DES LIAISONS
      CALL JEVEUO(FPROFL,'L',LLPROF)
      NBDDL=0
      NBEQT=0
 
      DO 10 I1=1,NBLIA
      
C-- NOMBRE D'EQUATIONS
        NE=ZI(LLPROF+(I1-1)*9)
        ND1=ZI(LLPROF+(I1-1)*9+1)
        ND2=ZI(LLPROF+(I1-1)*9+4)
        NBEQT=NBEQT+NE

C-- NOM DES SOUS STRUCTURES ET TAILLES
        CALL JEVEUO(JEXNUM(DEFLIA,I1),'L',LDELIA)
        INT1=ZK8(LDELIA)
        INT2=ZK8(LDELIA+2)
        IF (I1 .EQ. 1) THEN
           ZK8(LKNOMS)=INT1
           ZK8(LKNOMS+1)=INT2
           ZI(LSILIA)=ND1
           ZI(LSILIA+1)=ND2
           K1=2
           NBDDL=NBDDL+ND1+ND2
        ELSE
           L1=0
           M1=0
           DO 20 J1=1,K1
                IF (INT1 .EQ. ZK8(LKNOMS+J1-1)) THEN 
                  L1=1
                ENDIF
                IF (INT2 .EQ. ZK8(LKNOMS+J1-1)) THEN 
                  M1=1
                ENDIF
   20      CONTINUE  
           IF (L1 .EQ. 0) THEN
              ZK8(LKNOMS+K1)=INT1
              ZI(LSILIA+K1)=ND1
              NBDDL=NBDDL+ND1
              K1=K1+1
           ENDIF
           IF (M1 .EQ. 0) THEN
              ZK8(LKNOMS+K1)=INT2
              ZI(LSILIA+K1)=ND2
              NBDDL=NBDDL+ND2
              K1=K1+1
           ENDIF
        ENDIF
        
   10 CONTINUE
      
C--------------------------------------------------------------C
C--                                                          --C
C-- ALLOCATION DE LA MATRICE L CONTENANT TOUTES LES LIAISONS --C
C--   ON CONSTRUIT SA TRANSPOSEE L^T, DIRECTEMENT UTILISABLE --C
C--   POUR LA DECOMPOSITION QR (CONSTRUCTION DU NOYAU DE L)  --C
C--                                                          --C
C--------------------------------------------------------------C

C-- EN FONCTION DE LA TAILLE DE LA MATRICE, IL PEUT
C-- RESTER INTERESSANT DE FAIRE LA SVD, PUISQU'AVEC QR, ON EST
C-- OBLIGE D'AVOIR UNE MATRICE CARREE, AVEC BEAUCOUP DE ZEROS
C-- A INTEGRER DANS LA SUITE

      MATLIA='&&MATRICE_LIAISON_TEMPO'
      
C-- MATRICE QUI FAIT JUSTE LA TAILLE (SI SVD)
C      NEQ=NBEQT
C-- MATRICE CARRE NEQ*NBDDL
      NEQ=MAX(NBDDL,NBEQT)
      CALL WKVECT(MATLIA,'V V R',NEQ*NBDDL,LMALIA)
C      CALL WKVECT('&&MATRICE_TEST','V V R',NEQ*NBDDL,BIDON)

C-- ON PARCOURS LES INTERFACES POUR LA REMPLIR

      NEDEC=0
      DO 30 K1=1,NBLIA
        NE=ZI(LLPROF+(K1-1)*9)
        ND1=ZI(LLPROF+(K1-1)*9+1)
        ND2=ZI(LLPROF+(K1-1)*9+4)
C        
C-- RECHERCHE DE LA POSITION DE LA SOUS MATRICE DE LA
C-- LIAISON COURANTE DANS LA MATRICE GLOBALE
C
        ND1DEQ=0
        ND2DEQ=0
        CALL JEVEUO(JEXNUM(DEFLIA,K1),'L',LDELIA)
        INT1=ZK8(LDELIA)
        INT2=ZK8(LDELIA+2)
        DO 40 I1=1,NBSST
           IF (INT1 .EQ. ZK8(LKNOMS+I1-1)) THEN
              DO 50 J1=1,I1-1
                 ND1DEQ=ND1DEQ+ZI(LSILIA+J1-1)
   50         CONTINUE
           ENDIF  
           IF (INT2 .EQ. ZK8(LKNOMS+I1-1)) THEN
              DO 60 J1=1,I1-1
                 ND2DEQ=ND2DEQ+ZI(LSILIA+J1-1)
   60         CONTINUE
           ENDIF
   40   CONTINUE
C
C-- REMPLISSAGE DE LA SOUS MATRICE POUR LA LIAISON K1
C
        CALL JEVEUO(JEXNUM(NOMLIA,(K1-1)*3+1),'L',LNOLI1)
        CALL JEVEUO(JEXNUM(NOMLIA,(K1-1)*3+2),'L',LNOLI2)

        DO 70 J1=1,NE
          DO 80 I1=1,ND1
            IF (ABS(ZR(LNOLI1+(I1-1)*NE+J1-1)) .GT. EPS) THEN
              ZR(LMALIA+(J1-1+NEDEC)*NBDDL+I1-1+ND1DEQ)=
     &           ZR(LNOLI1+(I1-1)*NE+J1-1)
            ELSE
              ZR(LMALIA+(J1-1+NEDEC)*NBDDL+I1-1+ND1DEQ)=0.D0
            ENDIF
   80     CONTINUE

          DO 90 I1=1,ND2
            IF (ABS(ZR(LNOLI2+(I1-1)*NE+J1-1)) .GT. EPS) THEN
              ZR(LMALIA+(J1-1+NEDEC)*NBDDL+I1-1+ND2DEQ)=
     &           ZR(LNOLI2+(I1-1)*NE+J1-1)
            ELSE
              ZR(LMALIA+(J1-1+NEDEC)*NBDDL+I1-1+ND2DEQ)=0.D0
            ENDIF
   90     CONTINUE
   70   CONTINUE
  
C-- ANCIENNE VERSION - MATRICE NON TRANSPOSEE --C
   
C        DO 71 I1=1,NE
C          DO 81 J1=1,ND1          
C            IF (ABS(ZR(LNOLI1+(J1-1)*NE+I1-1)) .GT. EPS) THEN
C              ZR(BIDON+(J1-1+ND1DEQ)*NEQ+I1-1+NEDEC)=
C     &           ZR(LNOLI1+(J1-1)*NE+I1-1)
C            ELSE
C              ZR(BIDON+(J1-1+ND1DEQ)*NEQ+I1-1+NEDEC)=0.  
C            ENDIF
C   81     CONTINUE  
C          DO 91 J1=1,ND2
C            IF (ABS(ZR(LNOLI2+(J1-1)*NE+I1-1)) .GT. EPS) THEN
C              ZR(BIDON+(J1-1+ND2DEQ)*NEQ+I1-1+NEDEC)=
C     &           ZR(LNOLI2+(J1-1)*NE+I1-1)
C            ELSE
C              ZR(BIDON+(J1-1+ND2DEQ)*NEQ+I1-1+NEDEC)=0. 
C            ENDIF
C   91     CONTINUE
C  71   CONTINUE
   
         NEDEC=NEDEC+NE
   30  CONTINUE

C      WRITE(6,*)' '
C      WRITE(6,*)'%-- IMPRESSIONS DIVERSES'
C      WRITE(6,*)' '
C      WRITE(6,*)'clear all;'
C      WRITE(6,*)'LT=zeros(',NBDDL,',',NEQ,');Q=LT;'

C      DO 111 I1=1,NBDDL
C        DO 121 J1=1,NEQ
C         IF (ABS(ZR(LMALIA+(J1-1)*NBDDL+I1-1)) .GT. 1.D-20) THEN
C            WRITE(6,*)'LT(',I1,',',J1,')=',
C     &                ZR(LMALIA+(J1-1)*NBDDL+I1-1),';'
C          ENDIF
C 121    CONTINUE
C 111  CONTINUE        

C      DO 113 I1=1,NEQ
C        DO 123 J1=1,NBDDL
C          IF (ABS(ZR(BIDON+(J1-1)*NEQ+I1-1)) .GT. 1.D-6) THEN
C            WRITE(6,*)'L(',I1,',',J1,')=',
C     &                ZR(BIDON+(J1-1)*NEQ+I1-1),';'
C          ENDIF
C 123    CONTINUE
C 113  CONTINUE        
C      CALL JEDETR('&&MATRICE_TEST')



C-------------------------------------------------------------C
C--                                                         --C
C-- QR DE LA MATRICE POUR DETERMINER LA TAILLE DE SON NOYAU --C
C--                                                         --C
C-------------------------------------------------------------C

C-- CONSTRUCTION DES OBJETS TEMPORAIRES POUR LA DECOMPOSITION

C      WRITE(6,*)'NEQ=',NEQ
C      WRITE(6,*)'NBDDL=',NBDDL
      MATS='&&MATRICE_DIAG_R'
      LDS=INT(MIN(NEQ,NBDDL))

      CALL WKVECT(MATS,'V V R',LDS,LMATS)
      CALL WKVECT('&&MATR_TAU','V V R',NEQ,LTAU)

C-- INITIALISATION DES VALEURS DIAGONALES A 0
      DO 100 I1=1,LDS
        ZR(LMATS+I1-1)=0.D0
  100 CONTINUE

C-- DESACTIVATION DU TEST FPE
      CALL MATFPE(-1)

C-- RECHERCHE DE LA TAILLE DE L'ESPACE DE TRAVAIL      
      LWORK=-1
      CALL DGEQRF(NBDDL,NEQ,ZR(LMALIA),NBDDL,ZR(LTAU),SWORK,
     &            LWORK,INFO)
      LWORK=INT(SWORK)
C      WRITE(6,*)'LWORK=',LWORK
C-- DECOMPOSITION QR
      CALL WKVECT('&&MATR_QR_WORK','V V R',LWORK,JWORK)
      CALL DGEQRF(NBDDL,NEQ,ZR(LMALIA),NBDDL,ZR(LTAU),ZR(JWORK),
     &            LWORK,INFO)

C-- RECHERCHE DES ELEMENTS DIAGONAUX DE R
      TEMP=0.D0     
      DO 110 I1=1,LDS
        ZR(LMATS+I1-1)=ABS(ZR(LMALIA+(NEQ-NBDDL+I1-1)*NBDDL+I1-1))
        IF (ZR(LMATS+I1-1) .GT. TEMP) THEN
          TEMP=ZR(LMATS+I1-1)
        ENDIF
  110 CONTINUE

C-- TEST SI ON DOIT AGRANDIR LA TAILLE DE L'ESPACE DE TRAVAIL
      CALL DORGQR(NBDDL,NEQ,NBDDL,ZR(LMALIA),NBDDL,ZR(LTAU),
     &            SWORK,-1,INFO)
C      WRITE(6,*)'SWORK=',SWORK
      IF (SWORK .GT.LWORK) THEN
        LWORK=INT(SWORK)
        CALL JEDETR('&&MATR_QR_WORK')
        CALL WKVECT('&&MATR_QR_WORK','V V R',LWORK,JWORK)
      ENDIF
C-- CONSTRUCTION DE LA MATRICE Q      
      CALL DORGQR(NBDDL,NEQ,NBDDL,ZR(LMALIA),NBDDL,ZR(LTAU),
     &            ZR(JWORK),LWORK,INFO)

C-- REACTIVATION DU TEST FPE
      CALL MATFPE(1)
      
      TOL=TEMP*LDS*1.D-16
      CALL WKVECT('&&INDICES_DIAG_QR','V V I',LDS,LDIAQR)
            
C-- IL NE PEUT PAS Y AVOIR MOINS DE DDL INDEPENDANTS QUE LE NOMBRE
C--  TOTAL DE DDL MOINS LE NOMBRE DE CONTRAINTES.       

C      DO WHILE (NINDEP .LT. NBDDL-NBEQT)
  666   CONTINUE
        NINDEP=0
        DO 120 I1=1,LDS
          IF (ZR(LMATS+I1-1) .LE. TOL) THEN
            ZI(LDIAQR+NINDEP)=I1
            NINDEP=NINDEP+1
          ENDIF
  120   CONTINUE
        TOL=TOL*10
        IF (NINDEP .LT. NBDDL-NBEQT) THEN
          GOTO 666
        ENDIF    
C      END DO
      
      WRITE(6,*)'--------'
      WRITE(6,*)' '       
      WRITE(6,*)'+++',NBDDL,' DEGRES DE LIBERTE AU TOTAL'
      WRITE(6,*)'+++',NBEQT,' CONTRAINTES CINEMATIQUES.'
      WRITE(6,*)' ' 
      WRITE(6,*)'ON A TROUVE',NINDEP,' RELATIONS INDEPENDANTES.'
      WRITE(6,*)' '       
      WRITE(6,*)'--------'      

C-- CONSTRUCTION DU SOUS ESPACE

      CALL WKVECT(SELIAI,'G V R',NINDEP*NBDDL,LSELIA)
C      WRITE(6,*)'  '
C      WRITE(6,*)'T=zeros(',NBDDL,',',NINDEP,');'
      DO 130 J1=1,NINDEP
        INDS=ZI(LDIAQR+J1-1)-1
C        WRITE(6,*)'INDS=',INDS
        DO 140 I1=1,NBDDL
          ZR(LSELIA+(J1-1)*NBDDL+I1-1)=
     &       ZR(LMALIA+INDS*NBDDL+I1-1)
C          IF (ABS(ZR(LMALIA+INDS*NBDDL+I1-1)) .GT. 1.D-20) THEN
C            WRITE(6,*)'T(',I1,',',J1,')=',
C     &        ZR(LSELIA+(J1-1)*NBDDL+I1-1),';'
C          ENDIF
  140   CONTINUE
  130 CONTINUE


C-- DESTRUCTION DES MATRICES TEMPORAIRES
C
      CALL JEDETR(MATLIA)
      CALL JEDETR(MATS)
      CALL JEDETR('&&MATR_QR_WORK')
      CALL JEDETR('&&MATR_TAU')
C
C--   FIN      
C      
      CALL JEDEMA()

      END
