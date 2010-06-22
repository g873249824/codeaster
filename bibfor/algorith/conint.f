      SUBROUTINE CONINT(NUME,RAIDE,COINT,SIZECO,CONNEC,NODDLI,
     &                  NNOINT,NUME91,RAIINT,SSAMI)
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
C    M. CORUS     DATE 7/03/10
C-----------------------------------------------------------------------
C
C  BUT:      < DETERMINER LA CONNECTIVITE DES NOEUDS D'INTERFACE >
C
C  ON RECONSTRUIT UNE CONNECTIVITE DES NOEUDS A L'INTERFACE A PARTIR
C  DE LA MATRICE DE RAIDEUR ASSEMBLEE DU MODELE SOUS JACENT. ON ASSEMBLE
C  ENSUITE UN MODELE CONSTRUIT SUR LA BASE D'UN TREILLIS DE POUTRES AVEC
C  LA MEME CONNECTIVITE.
C
C-----------------------------------------------------------------------
C  NUME      /I/ : NOM DU NUME_DDL
C  RAIDE     /I/ : NOM DE LA MATRICE DE RAIDEUR
C  COINT   /I/ : NOM DE LA MATRICE DE CONNECTIVITE
C  SIZECO  /I/ : NB DE LIGNE DE LA MATRICE DE CONNECTIVITE PRE ALLOUEE
C  CONNEC    /O/ : NOMBRE DE CONNECTIONS
C  NODDLI  /I/ : NOM DU VECTEUR CONTENANT LES NOEUD ET LES DDL 
C                    D'INTERFACE
C  NNOINT   /I/ : NOMBRE DE NOEUDS D'INTERFACE
C  NUME91    /O/ : NUME_DDL_GENE DES OPERATEURS D'INTERFACE
C  RAIINT   /O/ : MATRICE DE RAIDEUR DU MODELE D'INTERFACE
C  SSAMI   /O/ : MATRICE DE MASSE DU MODELE D'INTERFACE
C     
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      INTEGER*4        ZI4
      COMMON  /I4VAJE/ ZI4(1)
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
      CHARACTER*32 JEXNUM, JEXNOM
     
C-- VARIABLES EN ENTREES / SORTIE
      INTEGER      SIZECO,CONNEC,NNOINT
      CHARACTER*14 NUME,NUME91
      CHARACTER*24 COINT,NODDLI
      CHARACTER*19 RAIDE

C-- VARIABLES DE LA ROUTINE      
      INTEGER      IBID,IERD,I1,J1,K1,L1,M1,N1,LRAIDE,LSMDI,LSMHC,NEQ,
     &             LPRNO,LNDDLI,IPOS1,IPOS2,NOEU,NBEC,ICON1,ICON2,
     &             NOEUCO,NUMNO,LCONNC,LREFN,LDPRS,LDORS,LDDEEQ,LIPOS,
     &             LDNUEQ,LDDELG,NEQDDL,NOZERO,OLDNUM,NO1,NO2,LINDNO,
     &             INDEQ,ISMHC,INDDDL,NEQD2,NBVOIS,
     &             NBVMAX,LCOORD,JREFA,LRAINT,LMAINT
      REAL*8       RAYON,DIST,MINDIS,MAXDIS,KR(12,12),MR(12,12),
     &             DIREC(3),PTREF(3),TEMP,LONG,VTEST(3),RAND
      CHARACTER*8  K8BID,NOMMA
      CHARACTER*19 PRGENE,PRNO,RAIINT,SSAMI,SOLVEU
      CHARACTER*24 REPSST,NOMMCL

C-----------C
C--       --C      
C-- DEBUT --C      
C--       --C
C-----------C

      CALL JEMARQ()

C--------------------------------C
C--                            --C
C-- INITIALISATION DU NUME_DDL --C
C--                            --C
C--------------------------------C

C
C--------------------CREATION DU .REFN----------------------------------
C                       ET DU DESC
      PRGENE=NUME91//'.NUME'
      CALL WKVECT(PRGENE//'.REFN','V V K24',4,LREFN)
      ZK24(LREFN)='&&MODL91'
      ZK24(LREFN+1)='DEPL_R'
      CALL WKVECT(PRGENE//'.DESC','V V I',1,IBID)
      ZI(IBID)=2

C-- CREATION D'UN MODELE_GENE MINIMALISTE
      CALL WKVECT(PRGENE//'.REFE','V V K24',4,IBID)
      ZK24(IBID)='&&MODL91'
C-- ET ON REMPLIT AVEC JUSTE LES INFOS UTILES POUR RGNDAS.F      
      REPSST='&&MODL91      .MODG.SSNO'
      NOMMCL='&&MODL91      .MODG.SSME'
      CALL JECREO(REPSST,'V N K8')
      CALL JEECRA(REPSST,'NOMMAX',1,' ')
      CALL JECREC(NOMMCL,'V V K8','NU','CONTIG','CONSTANT',1)
      CALL JECROC(JEXNUM(NOMMCL,1))
      CALL JEECRA(NOMMCL,'LONT',1,' ')
      CALL JECROC(JEXNOM(REPSST,'MODLINTF'))
      CALL JENONU(JEXNOM(REPSST,'MODLINTF'),IBID)
      CALL JEVEUO(JEXNUM(NOMMCL,1),'E',IBID)
      ZK8(IBID)='MODLINTF'
C-- FIN DU MODELE_GENE

      CALL JECREO(PRGENE//'.LILI','V N K8')
      CALL JEECRA(PRGENE//'.LILI','NOMMAX',1,K8BID)
      CALL JECROC(JEXNOM(PRGENE//'.LILI','&SOUSSTR'))
      CALL JECREC(PRGENE//'.PRNO','V V I','NU','DISPERSE','VARIABLE',1)
      CALL JECREC(PRGENE//'.ORIG','V V I','NU','DISPERSE','VARIABLE',1)

      CALL JENONU(JEXNOM(PRGENE//'.LILI','&SOUSSTR'),IBID)
      CALL JEECRA(JEXNUM(PRGENE//'.PRNO',IBID),'LONMAX',2,' ')
      CALL JENONU(JEXNOM(PRGENE//'.LILI','&SOUSSTR'),IBID)
      CALL JEECRA(JEXNUM(PRGENE//'.ORIG',IBID),'LONMAX',1,' ')

      CALL JENONU(JEXNOM(PRGENE//'.LILI','&SOUSSTR'),IBID)
      CALL JEVEUO(JEXNUM(PRGENE//'.PRNO',IBID),'E',LDPRS)
      CALL JENONU(JEXNOM(PRGENE//'.LILI','&SOUSSTR'),IBID)
      CALL JEVEUO(JEXNUM(PRGENE//'.ORIG',IBID),'E',LDORS)

      ZI(LDORS)=1
      ZI(LDPRS)=1

C-------------------------------------C
C--                                 --C
C-- CONSTRUCTION DE LA CONNECTIVITE --C
C--                                 --C
C-------------------------------------C

C-- RECUPERATION DE LA MATRICE DE RAIDEUR

      CALL JEVEUO(JEXNUM(RAIDE//'.VALM',1),'L',LRAIDE)
      CALL JEVEUO(NUME//'.SMOS.SMDI','L',LSMDI)
      CALL JEVEUO(NUME//'.SMOS.SMHC','L',LSMHC)
      CALL DISMOI('F','PROF_CHNO',NUME,'NUME_DDL',IBID,PRNO,IERD)
      CALL JEVEUO(JEXNUM(PRNO//'.PRNO',1),'L',LPRNO)
      
C-- BOUCLE SUR LES NOEUDS D'INTERFACE      

      CALL DISMOI('F','NB_EC','DEPL_R','GRANDEUR',NBEC,K8BID,IBID)
      CALL JEVEUO(NODDLI,'L',LNDDLI)
      CALL JEVEUO(COINT,'E',LCONNC)
      CONNEC=0
      NEQ=0
      NOZERO=0
      NBVMAX=0
      DO 10 I1=2,NNOINT
        L1=NNOINT-I1+1
        NOEU=ZI(LNDDLI+L1)
        NBVOIS=0
        IPOS2=ZI(LPRNO+(NOEU-1)*(2+NBEC))
        IPOS1=IPOS2-1
        NEQDDL=ZI(LPRNO+(NOEU-1)*(2+NBEC)+1)
        NEQ=NEQ+NEQDDL
        NOZERO=NOZERO+INT((NEQDDL*(NEQDDL+1))/2)
        
        DO 20 J1=1,NNOINT-I1+1
          NOEUCO=ZI(LNDDLI+J1-1)
          ICON1=ZI(LPRNO+(NOEUCO-1)*(2+NBEC))
          ICON2=ICON1+ZI(LPRNO+(NOEUCO-1)*(2+NBEC)+1)
          NUMNO=0
          
          DO 30 K1=ZI(LSMDI+IPOS1),ZI(LSMDI+IPOS2)
            IF ((ZI4(LSMHC+K1-1) .GE. ICON1) .AND.
     &          (ZI4(LSMHC+K1-1) .LE. ICON2) .AND.
     &          (NUMNO .EQ. 0) ) THEN
              NBVOIS=NBVOIS+1
              CONNEC=CONNEC+1              
              ZI(LCONNC+L1+NNOINT*NBVOIS)=NOEUCO
              NUMNO=1
              NOZERO=NOZERO+ZI(LPRNO+(NOEUCO-1)*(2+NBEC)+1)*NEQDDL
            ENDIF
  30      CONTINUE
  20    CONTINUE
  
        ZI(LCONNC+L1)=NBVOIS
        IF (NBVOIS .GT. NBVMAX) THEN
          NBVMAX=NBVOIS
        ENDIF
        
  10  CONTINUE
            
C-----------------------------C
C--                         --C
C-- REMPLISSAGE DU NUME_DDL --C
C--                         --C
C-----------------------------C
      
      NEQ=6*NNOINT
      NOZERO=21*NNOINT+36*CONNEC
      
      ZI(LDPRS+1)=NEQ
      CALL WKVECT(PRGENE//'.NEQU','V V I',1,IBID)
      ZI(IBID)=NEQ
      
      CALL WKVECT(PRGENE//'.DEEQ','V V I',NEQ*2,LDDEEQ)     
      CALL WKVECT(PRGENE//'.NUEQ','V V I',NEQ,LDNUEQ)
      CALL WKVECT(PRGENE//'.DELG','V V I',NEQ,LDDELG)
      
      DO 40 I1=1,NEQ
        ZI(LDNUEQ+I1-1)=I1
        ZI(LDDELG+I1-1)=0 
        ZI(LDDEEQ+(I1-1)*2)=I1
        ZI(LDDEEQ+(I1-1)*2+1)=1
  40  CONTINUE

C-- CONSTRUCTION DU .SMDE
      CALL WKVECT(NUME91//'.SMOS.SMDE','V V I',6,IBID)
      ZI(IBID)=NEQ
      ZI(IBID+1)=NOZERO
      ZI(IBID+2)=1
            
C-- CONSTRUCTION DU .SMDI ET DU .SMHC
      CALL WKVECT(NUME91//'.SMOS.SMDI','V V I',NEQ,LSMDI)
      CALL WKVECT(NUME91//'.SMOS.SMHC','V V S',NOZERO,LSMHC)
      
      CALL JEVEUO('&&MOIN93.IND_NOEUD','E',LINDNO)
      CALL JEVEUO('&&MOIN93.IPOS_DDL_INTERF','E',LIPOS)
      J1=0
      DO 50 I1=1,NNOINT
        ZI(LINDNO+ZI(LNDDLI+I1-1)-1)=I1
        ZI(LIPOS+I1-1)=J1
        J1=J1+ZI(LNDDLI+2*NNOINT+I1-1)
  50  CONTINUE    
      
      ISMHC=0
      INDEQ=0

      DO 60 I1=1,NNOINT
        NO1=ZI(LNDDLI+I1-1)
        NBVOIS=ZI(LCONNC+I1-1)
        NEQDDL=6
        
        DO 70 J1=1,NEQDDL

C-- ON REMPLIT LES CONNECTIONS NOEUD COURANT / NOEUDS PRECEDENTS        
          DO 80 K1=1,NBVOIS
            NO2=ZI(LCONNC+I1-1+K1*NNOINT)
            NEQD2=6
            INDDDL=ZI(LIPOS+ZI(LINDNO+NO2-1)-1)            
            
            DO 90 L1=1,NEQD2
              ZI4(LSMHC+ISMHC)=INDDDL+L1
              ISMHC=ISMHC+1
  90        CONTINUE
  80      CONTINUE       

C-- ON REMPLIT LE BLOC DIAGONAL DU NOEUD COURANT
          INDDDL=ZI(LIPOS+I1-1)
          DO 100 L1=1,J1
            ZI4(LSMHC+ISMHC)=INDDDL+L1
            ISMHC=ISMHC+1
  100     CONTINUE
          ZI(LSMDI+INDEQ)=ISMHC
          INDEQ=INDEQ+1
  70    CONTINUE          
  60  CONTINUE
    
C-- CREATION DU SOLVEUR
      SOLVEU=NUME91//'.SOLV'
      CALL CRSOLV ('LDLT','SANS',SOLVEU,'V')
      
C-----------------------------------------------------C
C--                                                 --C
C-- RECHERCHE DES PROPRIETES DU TREILLIS DE POUTRES --C
C--                                                 --C
C-----------------------------------------------------C

      CALL DISMOI('F','NOM_MAILLA',RAIDE,'MATR_ASSE',IBID,NOMMA,IERD)
      CALL JEVEUO(NOMMA//'.COORDO    .VALE','L',LCOORD)
      
      MINDIS=1.D16
      MAXDIS=0.D0
      
      DO 110 I1=1,NNOINT
        NO1=ZI(LNDDLI+I1-1)
        NBVOIS=ZI(LCONNC+I1-1)
        DO 120 J1=1,NBVOIS
          NO2=ZI(LCONNC+I1-1+J1*NNOINT)
          DIST=(ZR(LCOORD+(NO2-1)*3)-ZR(LCOORD+(NO1-1)*3))**2+
     &         (ZR(LCOORD+(NO2-1)*3+1)-ZR(LCOORD+(NO1-1)*3+1))**2+
     &         (ZR(LCOORD+(NO2-1)*3+2)-ZR(LCOORD+(NO1-1)*3+2))**2
          DIST=SQRT(DIST)
          IF (DIST .LT. MINDIS) THEN
            MINDIS=DIST
          ENDIF
          IF (DIST .GT. MAXDIS) THEN
            MAXDIS=DIST
          ENDIF
  120   CONTINUE
  110 CONTINUE
      RAYON=(MINDIS+MAXDIS)/20
      
  

C------------------------------------------------------------------C
C--                                                              --C
C-- RECHERCHE D'UN POINT DE REFERENCE POUR DEFINIR L'ORIENTATION --C
C--                                                              --C
C------------------------------------------------------------------C

C      DO WHILE (TEMP .LT. LONG*1.D-10)
  135   CONTINUE
  
        CALL GETRAN(PTREF(1))
        CALL GETRAN(PTREF(2))
        CALL GETRAN(PTREF(3))

        LONG=SQRT(PTREF(1)**2+PTREF(2)**2+PTREF(3)**2)
        TEMP=1.D0
        DO 130 I1=1,NNOINT
          NO1=ZI(LNDDLI+I1-1)
          NBVOIS=ZI(LCONNC+I1-1)
          DO 140 J1=1,NBVOIS
            NO2=ZI(LCONNC+I1-1+J1*NNOINT)
            DIREC(1)=ZR(LCOORD+(NO2-1)*3)-ZR(LCOORD+(NO1-1)*3)
            DIREC(2)=ZR(LCOORD+(NO2-1)*3+1)-ZR(LCOORD+(NO1-1)*3+1)
            DIREC(3)=ZR(LCOORD+(NO2-1)*3+2)-ZR(LCOORD+(NO1-1)*3+2)
            VTEST(1)=PTREF(1)-ZR(LCOORD+(NO1-1)*3)
            VTEST(2)=PTREF(2)-ZR(LCOORD+(NO1-1)*3+1)
            VTEST(3)=PTREF(3)-ZR(LCOORD+(NO1-1)*3+2)
            DIST=SQRT( (DIREC(2)*VTEST(3)-DIREC(3)*VTEST(2))**2+
     &                 (DIREC(1)*VTEST(3)-DIREC(3)*VTEST(1))**2+
     &                 (DIREC(2)*VTEST(1)-DIREC(1)*VTEST(2))**2 )
            IF (DIST .LT. TEMP) THEN
              TEMP=DIST
            ENDIF
  140     CONTINUE        
  130   CONTINUE
        IF (TEMP .LT. LONG*1.D-10) THEN
          GOTO 135
        ENDIF  
C      END DO
      


C--------------------------------------------------------C
C--                                                    --C
C-- INITIALISATION DES MATRICES DE MASSE ET DE RAIDEUR --C
C--                                                    --C
C--------------------------------------------------------C

      CALL INMAIN(RAIINT,NEQ,NOZERO)
      CALL INMAIN(SSAMI,NEQ,NOZERO)
      CALL JEVEUO(JEXNUM(RAIINT//'.VALM',1),'E',LRAINT)
      CALL JEVEUO(JEXNUM(SSAMI//'.VALM',1),'E',LMAINT)

      DO 150 I1=1,NNOINT
        
        NBVOIS=ZI(LCONNC+I1-1)
        DO 160 J1=1,NBVOIS
          NO1=ZI(LNDDLI+I1-1)
          NO2=ZI(LCONNC+I1-1+J1*NNOINT)

C-- CONSTRUCTION DES MATRICES ELEMENTAIRES          
          DO 170 K1=1,3
            DIREC(K1)=ZR(LCOORD+(NO2-1)*3+K1-1)-
     &                ZR(LCOORD+(NO1-1)*3+K1-1)
            VTEST(K1)=PTREF(K1)-ZR(LCOORD+(NO1-1)*3+K1-1)
  170     CONTINUE
         
          CALL MATINT(KR,MR,DIREC,VTEST,RAYON)
          NO1=I1
          NO2=ZI(LINDNO+NO2-1)
          NEQDDL=ZI(LNDDLI+2*NNOINT+NO1-1)
          NEQD2=ZI(LNDDLI+2*NNOINT+NO2-1)
C--          
C-- REMPLISSAGE DES .VALM          
C--
          
C-- REMPLISSAGE DES BLOCS SUR LA DIAGONALE

          DO 180 K1=1,NEQDDL
            IPOS1=ZI(LIPOS+NO1-1)+K1
            IPOS2=ZI(LSMDI+IPOS1-1)-1
            M1=ZI(LNDDLI+NNOINT*(2+K1)+NO1-1)
            DO 190 L1=1,K1
              N1=ZI(LNDDLI+NNOINT*(2+L1)+NO1-1)
              ZR(LRAINT+IPOS2-K1+L1)=ZR(LRAINT+IPOS2-K1+L1)+
     &           KR(N1,M1)
              ZR(LMAINT+IPOS2-K1+L1)=ZR(LMAINT+IPOS2-K1+L1)+
     &           MR(N1,M1)
  190       CONTINUE
  180     CONTINUE
          DO 200 K1=1,NEQD2
            IPOS1=ZI(LIPOS+NO2-1)+K1
            IPOS2=ZI(LSMDI+IPOS1-1)-1
            M1=6+ZI(LNDDLI+NNOINT*(2+K1)+NO2-1)
            DO 210 L1=1,K1
              N1=6+ZI(LNDDLI+NNOINT*(2+L1)+NO1-1)              
              ZR(LRAINT+IPOS2-K1+L1)=ZR(LRAINT+IPOS2-K1+L1)+
     &           KR(N1,M1)
              ZR(LMAINT+IPOS2-K1+L1)=ZR(LMAINT+IPOS2-K1+L1)+
     &           MR(N1,M1)
  210       CONTINUE
  200     CONTINUE        
          
C-- REMPLISSAGE DU BLOC DE COUPLAGE

          IPOS1=ZI(LSMDI+ ZI(LIPOS+NO1-1) -1 )
          IPOS2=ZI(LSMDI+ ZI(LIPOS+NO1-1) )-IPOS1
          M1=ZI(LIPOS+NO2-1)+1
          DO 220 L1=1,IPOS2-1
            IF (ZI4(LSMHC+IPOS1+L1-1) .EQ. M1) THEN
              INDEQ=L1
            ENDIF  
  220     CONTINUE
  
          DO 230 K1=1,NEQDDL
            IPOS1=ZI(LSMDI+ ZI(LIPOS+NO1-1)+K1-2 )           
            M1=ZI(LNDDLI+NNOINT*(2+K1)+NO2-1)
            DO 240 L1=1,NEQD2
              N1=6+ZI(LNDDLI+NNOINT*(2+L1)+NO1-1)
              ZR(LRAINT+IPOS1+INDEQ+L1-2)=
     &           ZR(LRAINT+IPOS1+INDEQ+L1-2)+
     &           KR(M1,N1)
              ZR(LMAINT+IPOS1+INDEQ+L1-2)=
     &           ZR(LMAINT+IPOS1+INDEQ+L1-2)+
     &           MR(M1,N1)
  240       CONTINUE        
  230     CONTINUE
  
  160   CONTINUE      
  150 CONTINUE

C---------C
C--     --C
C-- FIN --C
C--     --C
C---------C

      CALL JEDEMA()
      
      END
