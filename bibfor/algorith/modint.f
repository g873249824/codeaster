      SUBROUTINE MODINT(SSAMI,RAIINT,NDDLIN,NBMOD,SHIFT,MATMOD,
     &                  MASSE,RAIDE,NEQ,COINT,NODDLI,NNOINT,
     &                  VEFREQ)
      IMPLICIT NONE
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
C TOLE CRP_4
C-----------------------------------------------------------------------
C    M. CORUS     DATE 05/02/10
C-----------------------------------------------------------------------
C
C  BUT:      < CALCUL DES MODES D'INTERFACE >
C
C  ON EXTRAIT, A PARTIR DE LA SOUS MATRICE ASSOCIEE A L'INTERFACE, LA
C  CONNECTIVITE DU TREILLIS DE POUTRE SOUS JACENT. ON DETERMINE LE 
C  NOMBRE DE PARTIES INDEPENDANTES DE L'INTERFACE, ET ON CALCULE, POUR 
C  CHAQUE PARTIE, LES PREMIERS MODES PROPRES, EN PRENANT SOIN DE BIEN  
C  CAPTER LES MODES DE CORPS RIGIDE. ON CONSTRUIT ENSUITE, SUR LA BASE
C  DE CES MODES, UN SOUS ESPACE POUR PROJETER LES MATRICES DU PROBLEME
C  COMPLET, ET ON CALCULE, SUR CE SOUS ESPACE, LES MODES D'INTERFACE.
C
C-----------------------------------------------------------------------
C  IN  : SSAMI  : MATRICE DE MASSE DU MODELE D'INTERFACE
C  IN  : RAIINT  : MATRICE DE RAIDEUR DU MODELE D'INTERFACE
C  IN  : NDDLIN : NOMBRE D'EQUATIONS DU NUME_DDL D'INTERFACE
C  IN  : NBMOD    : NOMBRE DE MODES D'INTERFACE DEMANDE
C  IN  : SHIFT    : VALEUR DE FREQUENCE POUR LE DECALAGE DE LA RAIDEUR
C  OUT : MATMOD   : MATRICE DES MODES D'INTERFACE
C  IN  : SSAMI  : MATRICE DE MASSE DU MODELE COMPLET
C  IN  : RAIINT  : MATRICE DE RAIDEUR DU MODELE COMPLET
C  IN  : NDDLIN : NOMBRE D'EQUATIONS DU NUME_DDL COMPLET
C  IN  : COINT  : DEFINITION DE LA CONNECTIVITE DE L'INTERFACE
C  IN  : NODDLI : DEFINITION DES DDL PORTES PAR LES NOEUDS D'INTERFACE
C  IN  : NNOINT  : NOMBRE DE NOEUD A L'INTERFACE
C  OUT : VEFREQ  : NOM DU VECTEUR CONTENANT LES FREQUENCES PROPRES
C
C-----------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32  JEXNOM,JEXNUM      
C      
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C     ------------------------------------------------------------------

C-- VARIABLES EN ENTREES / SORTIE
      INTEGER      NDDLIN,NBMOD,NNOINT,NEQ
      REAL*8       SHIFT
      CHARACTER*19 MASSE,RAIDE,SSAMI,RAIINT
      CHARACTER*24 COINT,NODDLI,MATMOD,VEFREQ
     
C-- VARIABLES DE LA ROUTINE  
      INTEGER      LMATMO,I1,J1,K1,M1,N1,L1,LMAKRY,LINDDL,
     &             LACT,NSEKRY,ILA1,ILA2,LVTEMP,LVTMP2,NOD,LWR,LWI,
     &             LINLAG,LALPI,LBETA,LMATK,LMATM,LMAPRO,LKPRO,
     &             LMORED,LMATRM,LMATRK,LWORK,LLWORK,LALPR,LDDLD,
     &             LFREQ,LINDFR,LKRYL,LMATH,LIMPED,LMOLOL,LMOLOR,
     &             LMATMA,NDECI,ISINGU,NPVNEG,IRET,NBVECT,IBID,LMATS,
     &             DECAL,LINDNO,LTAU,LDDL,NBVOIS,JWORK,
     &             LCONNC,NO,LNDDLI,NBSST,LINDIN,LIPOS,NBDI,COEFF,
     &             IPOS1,IPOS2,LVP,LINTRF
      INTEGER*4    INFO
      REAL*8       TEMP,PI,RBID,NORM,DDOT,LAMBDA,COMLIN(2),SWORK,
     &             RAND
      PARAMETER    (PI=3.141592653589793238462643D0)
      COMPLEX*16   CBID
      CHARACTER*1  LISTYP(2),KBID
      CHARACTER*8  NOMCMP(6)
      CHARACTER*19 LISMAT(2),IMPED,SOLVEU,NUME91,NUME
      CHARACTER*24 MAKRY,VTEMP,VTEMP2,INDDDL,INDLAG,MATINT,VALK 

C-----------C
C--       --C     
C-- DEBUT --C
C--       --C
C-----------C

      CALL JEMARQ()

C------------------------------------------------------------C
C--                                                        --C      
C-- CONSTRUCTION DES MATRICES D'IMPEDANCE DYNAMIQUE K+MU*M --C
C--            ET DE MASSE DU MODELE D'INTERFACE           --C
C--                                                        --C
C------------------------------------------------------------C

      CALL MTDSCR(SSAMI)
      CALL JEVEUO(SSAMI(1:19)//'.&INT','L',LMATMA)

      IMPED='&&MOIN93.RAID_SHIFT'
      CALL MTDEFS(IMPED,RAIINT,'V',' ')
      LISMAT(1)=RAIINT
      LISMAT(2)=SSAMI
      CALL GETVR8('MODE_INTERF','FREQ',1,1,1,RBID,IBID)
      SHIFT=-(RBID*2*PI)**2
      COMLIN(1)=1.D0
      COMLIN(2)=SHIFT
      LISTYP(1)='R'
      LISTYP(2)='R'
      
      CALL MTCMBL(2,LISTYP,COMLIN,LISMAT,
     &                  IMPED,' ',NUME91,'ELIM1')
      CALL MTDSCR(IMPED)
      CALL JEVEUO(IMPED(1:19)//'.&INT','E',LIMPED)
      CALL DISMOI('F','SOLVEUR',SSAMI,'MATR_ASSE',IBID,SOLVEU,IBID)
      CALL DISMOI('F','NOM_NUME_DDL',SSAMI,'MATR_ASSE',IBID,
     &            NUME91,IBID)
      CALL TLDLG3('LDLT','SANS',1,LIMPED,1,0,0,NDECI,ISINGU,NPVNEG,
     &            IRET,SOLVEU)
      IF (IRET.EQ.2) THEN
                  VALK = IMPED
         CALL U2MESK('F', 'ALGELINE4_37',1,VALK)
      ENDIF

C-------------------------------------------------------------------C
C--                                                               --C
C-- RECUPERATION DU NOMBRE DE STRUCTURES DISJOINTES A L'INTERFACE --C
C--      AINSI QUE LES CONNECTIVITES PAR DECOMPOSITION QR         --C
C--                                                               --C
C-------------------------------------------------------------------C

      CALL INTDIS(COINT,NNOINT,NODDLI,'&&MODINT.INTERFACES_SST ',
     &            NBSST)
      
      CALL JEVEUO('&&MODINT.INTERFACES_SST ','L',LINDIN)
      
C------------------------------------------------------C
C--                                                  --C
C-- CALCUL DES MODES DU MODELE D'INTERFACE (ARNOLDI) --C
C--                                                  --C
C------------------------------------------------------C

C-- ESTIMATION DU NOMBRE DE MODES A CALCULER PAR SOUS STRUCURE

      NORM=NBMOD/NBSST
      TEMP=6.D0/NBSST
      
      COEFF=3
      IF (NORM .GT. 7) THEN
        NBVECT=COEFF*(INT(NORM)+2*(INT(TEMP)+1))
      ELSE
        NBVECT=COEFF*(6+INT(NORM)+2)
      ENDIF
      NSEKRY=INT(NBVECT*NBSST/COEFF)
      COEFF=INT(NBVECT/COEFF)
      WRITE(6,*)'------------------------------------------------',
     &'------------------------'
      WRITE(6,*)' VOUS AVEZ DEMANDE',NBMOD,' MODES'
      WRITE(6,*)' LA TAILE DU SOUS ESPACE RETENU EST',NSEKRY
      WRITE(6,*)'------------------------------------------------',
     &'------------------------'
            
      CALL WKVECT('&&MODINT.VECT_TEMP','V V R',6*NNOINT,LVTEMP)
      CALL WKVECT('&&MODINT.VECT_TEMP_2','V V R',6*NNOINT,LVTMP2)
      CALL WKVECT('&&MODINT.KRYLOV_INT','V V R',6*NNOINT*NBVECT,LKRYL)
      CALL WKVECT('&&MODINT.HESSENBERG','V V R',NBVECT**2,LMATH)

C-- ALLOC. DES MATRICES DE TRAVAIL POUR LE CALCUL DES VALEURS PROPRES
      CALL WKVECT('&&MODINT.LEFT_MODES','V V R',NBVECT**2,LMOLOL)
      CALL WKVECT('&&MODINT.RIGHT_MODES','V V R',NBVECT**2,LMOLOR)
      NO=MAX(NSEKRY,NBVECT)
      CALL WKVECT('&&MODINT.REAL_PART','V V R',NO,LWR)
      CALL WKVECT('&&MODINT.IMAG_PART','V V R',NO,LWI)
      CALL WKVECT('&&MODINT.V_F_PRO','V V R',NO,LFREQ)
      CALL WKVECT('&&MODINT.V_IND_F_PRO','V V I',NO,LINDFR)

C-- ALLOCATION DE LA MATRICE CONTENANT LA BASE DU SE DE KRYLOV
      CALL WKVECT('&&MODINT.SE_KRYLOV','V V R',NEQ*NSEKRY,LMAKRY)
      CALL JEVEUO('&&MOIN93.IS_DDL_INTERF  ','L',LDDLD)
      
C-- VECTEUR D'INDICES
      CALL JEVEUO('&&MOIN93.V_IND_DDL_INT','L',LINDDL)
      CALL JEVEUO('&&MOIN93.V_IND_LAG','L',LINLAG)
      CALL JEVEUO('&&MOIN93.DDL_ACTIF_INT','L',LINTRF)

C--                                               
C-- BOUCLE SUR LES PARTIES D'INTERFACE DISJOINTES 
C--                      
                         
C-- ON DESACTIVE LE TEST FPE     
      CALL MATFPE(-1)
      
      DO 70 N1=1,NBSST
                
C-- TIRAGE ALEATOIRE DU VECTEUR INITIAL
        NORM=0.D0
        DO 80 I1=1,6*NNOINT
          CALL GETRAN(RAND)
          ZR(LKRYL+I1-1)=(RAND*2-1)*ZI(LINDIN+6*NNOINT*(N1-1)+I1-1)
          NORM=NORM+ZR(LKRYL+I1-1)**2
  80    CONTINUE

        NORM=SQRT(NORM)
        DO 90 I1=1,6*NNOINT
          ZR(LKRYL+I1-1)=ZR(LKRYL+I1-1)/NORM
  90    CONTINUE

C-- REMPLISSAGE DE LA MATRICE DE HESSENBERG ET DU SE DE KRYLOV ASSOCIE
        DO 100 K1=2,NBVECT+1
          DO 110 I1=1,6*NNOINT
            ZR(LVTEMP+I1-1)=ZR(LKRYL+I1-1+(K1-2)*6*NNOINT)
  110     CONTINUE

          CALL MRMULT('ZERO',LMATMA,ZR(LVTEMP),'R',ZR(LVTMP2),1)
          CALL RESOUD(IMPED,' ',' ',SOLVEU,' ',' ',' ',
     &                      ' ',1,ZR(LVTMP2),CBID)
          DO 120 J1=1,K1-1
            NORM=DDOT(6*NNOINT,ZR(LVTMP2),1,
     &                ZR(LKRYL+(J1-1)*6*NNOINT),1)
            ZR(LMATH+(K1-2)*NBVECT+J1-1)=NORM
            DO 130 I1=1,6*NNOINT
              ZR(LVTMP2+I1-1)=ZR(LVTMP2+I1-1)-
     &                       NORM*ZR(LKRYL+(J1-1)*6*NNOINT+I1-1)
  130       CONTINUE
  120     CONTINUE

          NORM=DDOT(6*NNOINT,ZR(LVTMP2),1,ZR(LVTMP2),1)
          NORM=SQRT(NORM)
          IF (K1 .LT. NBVECT+1) THEN
            ZR(LMATH+(K1-2)*NBVECT+K1-1)=NORM
            DO 140 I1=1,6*NNOINT
              ZR(LKRYL+(K1-1)*6*NNOINT+I1-1)=ZR(LVTMP2+I1-1)/NORM
              ZR(LVTEMP+I1-1)=ZR(LKRYL+(K1-1)*6*NNOINT+I1-1)
  140       CONTINUE
          ENDIF  
  100   CONTINUE

C-- RESOLUTION DU PROBLEME AUX VALEURS PROPRES
        CALL DGEEV('N','V',NBVECT,ZR(LMATH),NBVECT,ZR(LWR),ZR(LWI),
     &             ZR(LMOLOL),NBVECT,ZR(LMOLOR),NBVECT,
     &             SWORK,-1,IRET)
        LWORK=INT(SWORK)
        CALL WKVECT('&&MODINT.MATR_EIGEN_WORK','V V R',LWORK,JWORK)
        CALL DGEEV('N','V',NBVECT,ZR(LMATH),NBVECT,ZR(LWR),ZR(LWI),
     &             ZR(LMOLOL),NBVECT,ZR(LMOLOR),NBVECT,
     &             ZR(JWORK),LWORK,IRET)
        CALL JEDETR('&&MODINT.MATR_EIGEN_WORK')

C-- TRI DES VALEURS PROPRES
        DO 150 I1=1,NBVECT
          TEMP=1.D+16
          DO 160 J1=1,NBVECT
            NORM=ABS(1.D0/SQRT(ZR(LWR+J1-1)**2+ZR(LWI+J1-1)**2)+SHIFT)
            IF (NORM .LT. TEMP) THEN
              TEMP=NORM
              ZI(LINDFR+I1-1)=J1
            ENDIF
  160     CONTINUE
  
          ZR(LWR+ZI(LINDFR+I1-1)-1)=1.D-16
          ZR(LWI+ZI(LINDFR+I1-1)-1)=1.D-16
  150   CONTINUE
 
C-- RAJOUTER LA SELECTION DES DDL
C-- ON GARDE LES 6 DDL POUR LA CONSTRUCTION DU MODELE D'INTERFACE


C-- CONSTRUCTION DU SOUS ESPACE POUR LE PROBLEME COMPLET
        DECAL=INT((N1-1)*COEFF*NEQ)
        DO 170 L1=1,COEFF
          J1=ZI(LINDFR+L1-1)
          DO 180 K1=1,NBVECT
            TEMP=ZR(LMOLOR+(J1-1)*NBVECT+K1-1)
            DO 190 I1=1,NDDLIN
              M1=ZI(LINTRF+I1-1)
              
              ZR(LMAKRY+DECAL+(L1-1)*NEQ+ZI(LINLAG+(I1-1)*2)-1)=
     &           ZR(LMAKRY+DECAL+(L1-1)*NEQ+ZI(LINLAG+(I1-1)*2)-1)
     &           +ZR(LKRYL+(K1-1)*6*NNOINT+M1-1)*TEMP
     
              ZR(LMAKRY+DECAL+(L1-1)*NEQ+ZI(LINLAG+(I1-1)*2+1)-1)=
     &           ZR(LMAKRY+DECAL+(L1-1)*NEQ+ZI(LINLAG+(I1-1)*2+1)-1)
     &           +ZR(LKRYL+(K1-1)*6*NNOINT+M1-1)*TEMP
  190       CONTINUE
  180     CONTINUE
  170   CONTINUE

  70  CONTINUE



C-- RELEVE STATIQUE DU SOUS ESPACE DE KRYLOV SUR LE MODELE COMPLET
      CALL DISMOI('F','SOLVEUR',RAIDE,'MATR_ASSE',IBID,SOLVEU,IBID)
      CALL RESOUD(RAIDE,'&&MOIN93.MATPRE',' ',SOLVEU,' ',' ',' ',
     &            ' ',NSEKRY,ZR(LMAKRY),CBID)

C---------------------------------------------C
C--                                         --C
C-- PROJECTION DE LA MASSE ET DE LA RAIDEUR --C
C--                                         --C
C---------------------------------------------C

      CALL WKVECT('&&MODINT.M_PROJ_TEMP','V V R',NEQ*NSEKRY,LMATRM)
      CALL WKVECT('&&MODINT.K_PROJ_TEMP','V V R',NEQ*NSEKRY,LMATRK)
      CALL WKVECT('&&MODINT.M_PROJ','V V R',NSEKRY**2,LMAPRO)
      CALL WKVECT('&&MODINT.K_PROJ','V V R',NSEKRY**2,LKPRO)

C-- MISE A 0 DES DDL DE LAGRANGE
      DO 200 I1=1,NDDLIN
        DO 210 J1=1,NSEKRY
          ZR(LMAKRY+(J1-1)*NEQ+ZI(LINLAG+(I1-1)*2)-1)=0.D0
          ZR(LMAKRY+(J1-1)*NEQ+ZI(LINLAG+(I1-1)*2+1)-1)=0.D0
  210   CONTINUE   
  200 CONTINUE    

      CALL JEVEUO(MASSE(1:19)//'.&INT','L',LMATM)
      CALL MRMULT('ZERO',LMATM,ZR(LMAKRY),'R',ZR(LMATRM),NSEKRY)
      CALL JEVEUO(RAIDE(1:19)//'.&INT','L',LMATK)
      CALL MRMULT('ZERO',LMATK,ZR(LMAKRY),'R',ZR(LMATRK),NSEKRY)

C-- MISE A 0 DES DDL DE LAGRANGE
      DO 220 I1=1,NDDLIN
        DO 230 J1=1,NSEKRY
          ZR(LMATRM+(J1-1)*NEQ+ZI(LINLAG+(I1-1)*2)-1)=0.D0
          ZR(LMATRM+(J1-1)*NEQ+ZI(LINLAG+(I1-1)*2+1)-1)=0.D0
          ZR(LMATRK+(J1-1)*NEQ+ZI(LINLAG+(I1-1)*2)-1)=0.D0
          ZR(LMATRK+(J1-1)*NEQ+ZI(LINLAG+(I1-1)*2+1)-1)=0.D0
  230   CONTINUE   
  220 CONTINUE    

      DO 240 J1=1,NSEKRY
          ZR(LMAPRO+(J1-1)*NSEKRY+J1-1)=
     &       DDOT(NEQ,ZR(LMAKRY+(J1-1)*NEQ),1,
     &                ZR(LMATRM+(J1-1)*NEQ),1)
          ZR(LKPRO+(J1-1)*NSEKRY+J1-1)=
     &       DDOT(NEQ,ZR(LMAKRY+(J1-1)*NEQ),1,
     &                ZR(LMATRK+(J1-1)*NEQ),1)        
        DO 250 I1=1,J1-1
          ZR(LMAPRO+(J1-1)*NSEKRY+I1-1)=
     &       DDOT(NEQ,ZR(LMAKRY+(I1-1)*NEQ),1,
     &                ZR(LMATRM+(J1-1)*NEQ),1)
          ZR(LMAPRO+(I1-1)*NSEKRY+J1-1)=
     &       ZR(LMAPRO+(J1-1)*NSEKRY+I1-1)
      
          ZR(LKPRO+(J1-1)*NSEKRY+I1-1)=
     &       DDOT(NEQ,ZR(LMAKRY+(I1-1)*NEQ),1,
     &                ZR(LMATRK+(J1-1)*NEQ),1)
          ZR(LKPRO+(I1-1)*NSEKRY+J1-1)=
     &       ZR(LKPRO+(J1-1)*NSEKRY+I1-1)
  250     CONTINUE
  240 CONTINUE

C-------------------------------------------------C
C--                                             --C
C-- RESOLUTION DU PB AUX VALEURS PROPRES REDUIT --C  
C--                                             --C
C-------------------------------------------------C

      CALL WKVECT('&&MODINT.VECT_ALPHAR','V V R',NSEKRY,LALPR)
      CALL WKVECT('&&MODINT.VECT_ALPHAI','V V R',NSEKRY,LALPI)
      CALL WKVECT('&&MODINT.VECT_BETA','V V R',NSEKRY,LBETA)
      CALL WKVECT('&&MODINT.MATR_MOD_RED','V V R',NSEKRY**2,LMORED)

      CALL DGGEV('N','V',NSEKRY,ZR(LKPRO),NSEKRY,ZR(LMAPRO),
     &           NSEKRY,ZR(LALPR),ZR(LALPI),ZR(LBETA),
     &           ZR(LMORED),NSEKRY,ZR(LMORED),NSEKRY,SWORK,
     &           -1,INFO)
      LWORK=INT(SWORK)
      CALL WKVECT('&&MODINT.MATR_WORK_DGGEV','V V R',LWORK,LLWORK)     
      CALL DGGEV('N','V',NSEKRY,ZR(LKPRO),NSEKRY,ZR(LMAPRO),
     &           NSEKRY,ZR(LALPR),ZR(LALPI),ZR(LBETA),
     &           ZR(LMORED),NSEKRY,ZR(LMORED),NSEKRY,ZR(LLWORK),
     &           LWORK,INFO)
C-- ON REACTIVE LE TEST FPE  
      CALL MATFPE(1)
      
C-- CLASSEMENT DES FREQUENCES PROPRES
      TEMP=1.D+16
      DO 260 I1=1,NSEKRY
        IF (ABS(ZR(LBETA+I1-1)) .GT. 0) THEN
          LAMBDA=ZR(LALPR+I1-1)/ZR(LBETA+I1-1)
          ZR(LFREQ+I1-1)=(SQRT(ABS(LAMBDA)))/2/PI
        ELSE
          ZR(LFREQ+I1-1)=TEMP
        ENDIF
  260 CONTINUE
  
  
      CALL WKVECT(VEFREQ,'V V R',NBMOD,LVP)
  
      DO 270 I1=1,NBMOD
        TEMP=1.D+16
        DO 280 J1=1,NSEKRY
          IF (ZR(LFREQ+J1-1) .LT. TEMP) THEN
            TEMP=ZR(LFREQ+J1-1)
            ZI(LINDFR+I1-1)=J1
          ENDIF
  280   CONTINUE
        ZR(LFREQ+ZI(LINDFR+I1-1)-1)=1.D+16
        LAMBDA=ZR(LALPR+ZI(LINDFR+I1-1)-1)/
     &         ZR(LBETA+ZI(LINDFR+I1-1)-1)-0*SHIFT
        ZR(LVP+I1-1)=(SQRT(ABS(LAMBDA)))/2/PI
  270 CONTINUE        

C-------------------------------------------------------C
C--                                                   --C
C-- RESTITUTION DES MODES D'INTERFACE SUR LE MAILLAGE --C
C--                                                   --C
C-------------------------------------------------------C

      CALL WKVECT(MATMOD,'V V R',NEQ*NBMOD,LMATMO)
      DO 290 J1=1,NBMOD
        DO 300 K1=1,NSEKRY
          TEMP=ZR(LMORED+(ZI(LINDFR+J1-1)-1)*NSEKRY+K1-1)
          DO 310 I1=1,NEQ
            ZR(LMATMO+(J1-1)*NEQ+I1-1)=ZR(LMATMO+(J1-1)*NEQ+I1-1)+
     &         TEMP*ZR(LMAKRY+(K1-1)*NEQ+I1-1)
  310     CONTINUE
  300   CONTINUE
  290 CONTINUE

C---------------------------------------C
C--                                   --C 
C-- DESTRUCTION DES OBJETS DE TRAVAIL --C
C--                                   --C
C---------------------------------------C
      
      CALL DETRSD('MATR_ASSE',IMPED)
      
      CALL JEDETR('&&MODINT.VECT_TEMP')
      CALL JEDETR('&&MODINT.VECT_TEMP_2')
      CALL JEDETR('&&MODINT.KRYLOV_INT')
      CALL JEDETR('&&MODINT.HESSENBERG')

      CALL JEDETR('&&MODINT.LEFT_MODES')
      CALL JEDETR('&&MODINT.RIGHT_MODES')
      CALL JEDETR('&&MODINT.REAL_PART')
      CALL JEDETR('&&MODINT.IMAG_PART')
      CALL JEDETR('&&MODINT.V_F_PRO')
      CALL JEDETR('&&MODINT.V_IND_F_PRO')

      CALL JEDETR('&&MODINT.M_PROJ_TEMP')
      CALL JEDETR('&&MODINT.K_PROJ_TEMP')
      CALL JEDETR('&&MODINT.M_PROJ')
      CALL JEDETR('&&MODINT.K_PROJ')

      CALL JEDETR('&&MODINT.VECT_ALPHAR')
      CALL JEDETR('&&MODINT.VECT_ALPHAI')
      CALL JEDETR('&&MODINT.VECT_BETA')
      CALL JEDETR('&&MODINT.MATR_MOD_RED')
      CALL JEDETR('&&MODINT.MATR_WORK_DGGEV')     

C---------C
C--     --C
C-- FIN --C
C--     --C
C---------C

      CALL JEDEMA()
      END
