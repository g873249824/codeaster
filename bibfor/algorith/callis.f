      SUBROUTINE  CALLIS (NOMRES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C YOU SHOULD HAVE RECEIVED A COPY OfF THE GNU GENERAL PUBLIC LICENSE   
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,       
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
      IMPLICIT NONE
C***********************************************************************
C    P. RICHARD     DATE 13/10/92
C-----------------------------------------------------------------------
C  BUT:      < CALCUL DES LIAISONS >
C
C  CALCULER LES NOUVELLES MATRICE DE LIAISON EN TENANT COMPTE
C   DE L'ORIENTATION DES SOUS-STRUCTURES
C  ON DETERMINE LES MATRICE DE LIAISON, LES DIMENSIONS DE CES MATRICES
C  ET LE PRONO ASSOCIE
C
C  VERIFICATION DE LA COHERENCE DES INTERFACE EN VIS-A-VIS
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UTILISATEUR DU RESULTAT
C
C
C
      INCLUDE 'jeveux.h'
C
C
      CHARACTER*1    K1BID
      CHARACTER*8    NOMRES,OPTION
      CHARACTER*24   FAMLI,FMLIA,PROMLI
      CHARACTER*24   FPLI1O,FPLI2O,FPLI1N,FPLI2N,INT1,INT2,
     &               INDIN1,INDIN2,LINO1,LINO2,
     &               TRAMO1,TRAMO2,INDCOL
      CHARACTER*8    SST1,SST2,INTF1,INTF2,MOD1,MOD2,
     &               LINT1,LINT2,K8BID,MA1,MA2,MATPRJ
      CHARACTER*16   MOTCLE(2)  
      INTEGER        NBLIS,LDPMLI,NBBLOC,LLLIA,IAD,NBLIG,I,IRET,
     &               IBID,NBNO1,NBNO2,IER,LLINT1,LLINT2,
     &               IINC,IREP11,IREP12,IREP21,IREP22,IOPT,
     &               NBEQ1,NBEQ2,DDLA1,DDLA2,IMAST,NBCOL
      INTEGER        TAILLE(2),ICAR(4)
      REAL*8         UN,MOINS1
      INTEGER      IARG

C
C-----------------------------------------------------------------------
      DATA UN,MOINS1 /1.0D+00,-1.0D+00/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C   NOM FAMILLE DEFINITION DES LIAISONS
C
C--------------NOMRES EST LE NOM DU MODELE GENERALISE
      FAMLI=NOMRES//'      .MODG.LIDF'
      FMLIA=NOMRES//'      .MODG.LIMA'
      PROMLI=NOMRES//'      .MODG.LIPR'
      MATPRJ='MATPROJ '
C
C  MINI-PROFNO DES LIAISON ORIENTEES ET NON ORIENTEE
C
      FPLI1O='&&'//'PGC.PROF.LI1O'
      FPLI2O='&&'//'PGC.PROF.LI2O'
      FPLI1N='&&'//'PGC.PROF.LI1N'
      FPLI2N='&&'//'PGC.PROF.LI2N'
C
C-----------------RECUPERATION DU NOMBRE DE LIAISONS--------------------
C             ET DECLARATION DES FAMILLES
C
      CALL JELIRA(FAMLI,'NMAXOC',NBLIS,K1BID)
C
      CALL WKVECT(PROMLI,'G V IS',NBLIS*9,LDPMLI)
C
C  NOM FAMILLE VOLATILE POUR PROFNO MATRICES ORIENTEES
C
      CALL JECREC(FPLI1N,'V V I','NU','DISPERSE','VARIABLE',NBLIS)
      CALL JECREC(FPLI2N,'V V I','NU','DISPERSE','VARIABLE',NBLIS)
      CALL JECREC(FPLI1O,'V V I','NU','DISPERSE','VARIABLE',NBLIS)
      CALL JECREC(FPLI2O,'V V I','NU','DISPERSE','VARIABLE',NBLIS)      
C
C------------------------BOUCLE SUR LES LIAISON-------------------------
C    POUR COMPTAGE BLOC ET STOCKAGE DIMENSION ET AUTRE
C
C
C  FAMILLE A CREER POUR MATRICE LIAISON ORIENTEES
C
      CALL JECREC(FMLIA,'G V R','NU','DISPERSE','VARIABLE',NBLIS*3)
C
      NBBLOC=0
C
      DO 10 I=1,NBLIS

C   *******************************************
C  RECUPERATION DES DONNEES SOUS-STRUCTURES
C   *******************************************

C ------------- LA DEFINITION DE LA LIAISON
        CALL JEVEUO(JEXNUM(FAMLI,I),'L',LLLIA)
        SST1=ZK8(LLLIA)
        INTF1=ZK8(LLLIA+1)
        SST2=ZK8(LLLIA+2)
        INTF2=ZK8(LLLIA+3)

C ------------- ON VERIFIE SI MODES REDUITS OU PAS
        CALL GETVTX('LIAISON','OPTION',I,IARG,1,OPTION,IOPT)
C------------------------------------------C
C--                                      --C
C-- CONSTRUCTION DES MATRICES DE LIAISON --C
C--                                      --C
C------------------------------------------C

C
C-------------LE NOM DES MODELES
C
        CALL MGUTDM(NOMRES,SST1,IBID,'NOM_MODELE  ',IBID,MOD1)
        CALL MGUTDM(NOMRES,SST2,IBID,'NOM_MODELE  ',IBID,MOD2)
C
C-------------LE NOM DES MAILLAGES
        CALL DISMOI('F','NOM_MAILLA',MOD1,'MODELE',IBID,MA1,IER) 
        CALL DISMOI('F','NOM_MAILLA',MOD2,'MODELE',IBID,MA2,IER) 
C
C--------------LES INTERFACES AMONT DES SOUS-STRUCTURES
        CALL MGUTDM(NOMRES,SST1,IBID,'NOM_LIST_INTERF',IBID,LINT1)
        CALL MGUTDM(NOMRES,SST2,IBID,'NOM_LIST_INTERF',IBID,LINT2)

C--------------LES NOMBRES DES NOEUDS DES INTERFACES
        INT1=LINT1//'.IDC_LINO'
        CALL JENONU(JEXNOM(INT1(1:13)//'NOMS',INTF1),IBID)
        CALL JELIRA(JEXNUM(INT1,IBID),'LONMAX',NBNO1,K8BID)
C      
        INT2=LINT2//'.IDC_LINO'
        CALL JENONU(JEXNOM(INT2(1:13)//'NOMS',INTF2),IBID)
        CALL JELIRA(JEXNUM(INT2,IBID),'LONMAX',NBNO2,K8BID)

C--------------LES LISTES DES NUMEROS DES NOEUDS DES INTERFACES
        CALL JENONU(JEXNOM(LINT1 //'.IDC_NOMS',INTF1),IBID)
        CALL JEVEUO(JEXNUM(LINT1 //'.IDC_LINO',IBID),'L',
     &                LLINT1)
     
        CALL JENONU(JEXNOM(LINT2 //'.IDC_NOMS',INTF2),IBID)
        CALL JEVEUO(JEXNUM(LINT2 //'.IDC_LINO',IBID),'L',
     &                LLINT2)
C     
C
        IF (OPTION.EQ.'CLASSIQU') THEN  
        
C  *******************************************
C  CALCUL DES MATRICES DE LIAISON
C  *******************************************

C  MATRICE DE LIAISON 1
C
          IAD=LDPMLI+(I-1)*9
          CALL LIACAR(NOMRES,SST1,INTF1,FPLI1N,FPLI1O,I,ZI(IAD))
          ZI(LDPMLI+(I-1)*9+2)=NBBLOC+1
          NBBLOC=NBBLOC+1

C  MATRICE DE LIAISON 2
C
          IAD=LDPMLI+(I-1)*9+3
          CALL LIACAR(NOMRES,SST2,INTF2,FPLI2N,FPLI2O,I,ZI(IAD))
          ZI(LDPMLI+(I-1)*9+5)=NBBLOC+1
          NBBLOC=NBBLOC+1
C
C  *******************************************
C  RECUPERATION DES DONNEES INCOMPATIBILITE
C  *******************************************

C-- LA GESTION DE L'INCOMPATIBILITE SE BORNE A FAIRE UNE INTERPOLATION
C-- LINEAIRE DES DEPLACEMENTS DE LA MAILLE MAITRE...

          IINC=0
C       On teste si la liaison est incompatible        
          CALL GETVTX('LIAISON','GROUP_MA_MAIT_1',I,IARG,1,K8BID,IREP11)
          CALL GETVTX('LIAISON','MAILLE_MAIT_1',I,IARG,1,K8BID,IREP12)
          CALL GETVTX('LIAISON','GROUP_MA_MAIT_2',I,IARG,1,K8BID,IREP21)
          CALL GETVTX('LIAISON','MAILLE_MAIT_2',I,IARG,1,K8BID,IREP22)
          IF ((IREP11.NE.0).OR.(IREP12.NE.0)) THEN
            MOTCLE(1) = 'MAILLE_MAIT_1'
            MOTCLE(2) = 'GROUP_MA_MAIT_1'
            CALL PRJLIS(MOD1,MA1,MOD2,MA2,NBNO1,NBNO2,MOTCLE,LINT1,
     &            LINT2,INTF1,INTF2,FPLI1O,FPLI2O,ZI(LDPMLI+(I-1)*9),
     &            ZI(LDPMLI+(I-1)*9+3),I,MATPRJ,NOMRES,SST1,SST2)
            NBLIG=ZI(LDPMLI+(I-1)*9+3)
            IINC=1
          ELSEIF ((IREP21.NE.0).OR.(IREP22.NE.0)) THEN
            MOTCLE(1) = 'MAILLE_MAIT_2'
            MOTCLE(2) = 'GROUP_MA_MAIT_2'
            CALL PRJLIS(MOD2,MA2,MOD1,MA1,NBNO2,NBNO1,MOTCLE,LINT2,
     &            LINT1,INTF2,INTF1,FPLI2O,FPLI1O,ZI(LDPMLI+(I-1)*9+3),
     &                  ZI(LDPMLI+(I-1)*9),I,MATPRJ,NOMRES,SST2,SST1)
            NBLIG=ZI(LDPMLI+(I-1)*9)
            IINC=2
          ELSE
            NBLIG=ZI(LDPMLI+(I-1)*9)
          ENDIF                
C
C  MATRICE LAGRANGE-LAGRANGE
C
          IAD=LDPMLI+(I-1)*9+6
          ZI(IAD)=NBLIG
          ZI(IAD+1)=2
          ZI(IAD+2)=NBBLOC+1
          ICAR(1)=ZI(IAD)
          ICAR(2)=ZI(IAD+1)
          ICAR(3)=ZI(IAD+2)
          ICAR(4)=1
          
          NBBLOC=NBBLOC+1   
          
C-------------------------DETERMINATION MATRICES ORIENTEES--------------
C
C   ROTATION DES MATRICES DE LIAISON DE LA LIAISON COURANTE
C       
          IF (IINC.EQ.0) THEN
            CALL VERILI(NOMRES,I,FPLI1O,FPLI2O,IRET)
            IF(IRET.GT.0) THEN
              CALL U2MESG('F', 'ALGORITH12_38',0,' ',0,0,0,0.D0)
            ENDIF
          
            IAD=LDPMLI+(I-1)*9
            CALL ROTLIS(NOMRES,FMLIA,ZI(IAD),FPLI1N,FPLI1O,I,SST1,
     &                  INTF1,UN)     
            IAD=LDPMLI+(I-1)*9+3
            CALL ROTLIS(NOMRES,FMLIA,ZI(IAD),FPLI2N,FPLI2O,I,
     &                  SST2,INTF2,MOINS1)
            
          ELSE
            IF (IINC.EQ.1) THEN
              CALL INCLIS(NOMRES,SST1,SST2,INTF1,INTF2,FMLIA,FPLI1N,
     &                    FPLI2N,FPLI1O,FPLI2O,ZI(LDPMLI+(I-1)*9),
     &                    ZI(LDPMLI+(I-1)*9+3),I,MATPRJ)
            ELSEIF (IINC.EQ.2) THEN
              CALL INCLIS(NOMRES,SST2,SST1,INTF2,INTF1,FMLIA,FPLI2N,
     &                    FPLI1N,FPLI2O,FPLI1O,ZI(LDPMLI+(I-1)*9+3),
     &                    ZI(LDPMLI+(I-1)*9),I,MATPRJ)
            ENDIF
            CALL JEDETR(MATPRJ)
          ENDIF  
C
C  MATRICE LAGRANGE-LAGRANGE
C
          IAD=LDPMLI+(I-1)*9+6
          CALL INILAG(FMLIA,ICAR)
          
C--------------------------------------------------C
C--                                              --C
C-- INTERFACES DEFINIES AVEC DES DDL GENERALISES --C
C--                                              --C
C---------------------------------------------------C

C   DANS CE CAS, ON NE PEUT PAS ECRIRE
C             L1.Q1+L2.Q2=0, 
C       OU Q1 ET Q2 SONT DES DDL PHYSUQUES
C
C   ICI, ON A :  Q1=PHI1.QG1   ET  Q2=PHI2.QG2
C       PHI1 / PHI2 : BASE MODALE
C       QG1 / QG2 : DDL GENERALISES
C
C   ON ASSURE DONC LA CONTINUITE DANS LE 
C   SOUS ESPACE ENGENDRE PAR PHI1 OU PAR PHI2. 
C   ON CHOISI ICI LA SOUS STRUTURE ESCLAVE (PAR EX. PHI1)
C   ON CONSTRUIT DONC LA RELATION LG1.QG1+LG2.QG2=0, SOIT
C   PHI1^T(L1.PHI1).QC1 + PHI1^T(L2.PHI2).QC2=0
C
C   CETTE RELATION NE PERMET DONC PAS UN RECOLLEMNT PARFAIT
C   A L'INTERFACE, EN PARTICULIER SI PHI1 ET PHI2 SONT TRES
C   DIFFERENTES. DANS CE CAS, ON VERIFIE LE RANG DE PHI1^T(L2.PHI2)
C   ET ON FILTRE LES RELATIONS MAL PROJETEES, EN AVERTISSANT 
C   L'UTILISATEUR

        ELSEIF (OPTION(1:6).EQ.'REDUIT') THEN
          
C----------------------------------------------------------------C
C--                                                            --C
C-- EXTRACTION ET ROTATION DE LA TRACE DES MODES A L'INTERFACE --C
C--                                                            --C
C----------------------------------------------------------------C

C-- VERIFICATION DE LA COMPATIBILITE DES NOEUDS

          IRET=I
          CALL VECOMO(NOMRES,SST1,SST2,INTF1,INTF2,IRET,OPTION)
C          IF (IRET .EQ.1) THEN
C          
C            VERIFIER ICI QUE, DANS CE CAS, ALORS CHAQUE NOEUD
C            PORTE LES MEMES DDL QUE SONT VIS A VIS
C            SINON, IRET=0
C
C          ENDIF 

C-- SOUS STRUCTURE 1
          LINO1='&&VECT_NOEUD_INTERF1'
          INDIN1='&&VECT_IND_DDL_INTERF1'
          TRAMO1='&&MATR_TRACE_MODE_INT1  '

          CALL ROTLIR(NOMRES,SST1,INTF1,LINO1,0,INDIN1,
     &                TRAMO1,DDLA1,NBEQ1,1,I)

C-- SOUS STRUCTURE 2
          LINO2='&&VECT_NOEUD_INTERF2'
          INDIN2='&&VECT_IND_DDL_INTERF2'
          TRAMO2='&&MATR_TRACE_MODE_INT2  '

          CALL ROTLIR(NOMRES,SST2,INTF2,LINO2,IRET,INDIN2,
     &                TRAMO2,DDLA2,NBEQ2,2,I)

C----------------------------------------C
C--                                    --C
C-- RECUPERATION DE L'INTERFACE MAITRE --C
C--                                    --C
C----------------------------------------C

          CALL GETVTX('LIAISON','GROUP_MA_MAIT_1',I,IARG,1,K8BID,IREP11)
          CALL GETVTX('LIAISON','MAILLE_MAIT_1',I,IARG,1,K8BID,IREP12)
          CALL GETVTX('LIAISON','GROUP_MA_MAIT_2',I,IARG,1,K8BID,IREP21)
          CALL GETVTX('LIAISON','MAILLE_MAIT_2',I,IARG,1,K8BID,IREP22)
         
          IF ((IREP21.NE.0).OR.(IREP22.NE.0)) THEN
            IMAST=2
            IF (IRET .EQ. 0) THEN
              CALL LIPSRB(NOMRES,MATPRJ,SST1,SST2,INTF1,INTF2,
     &                    LINO1,LINO2,INDIN1,INDIN2,
     &                    DDLA2,DDLA1,NBEQ2,NBEQ1,IMAST,TRAMO2)
            ENDIF
C-- ET ON PROJETTE L'EQUATION DE LIAISON SUR PHI1

          ELSE
C-- SI ON NE PRECISE RIEN, C'EST LA SOUS STRUCTURE 1 QUI EST MAITRE
            IMAST=1
            IF (IRET .EQ. 0) THEN
              CALL LIPSRB(NOMRES,MATPRJ,SST1,SST2,INTF1,INTF2,
     &                    LINO1,LINO2,INDIN1,INDIN2,
     &                    DDLA1,DDLA2,NBEQ1,NBEQ2,IMAST,TRAMO1)
C-- ET ON PROJETTE L'EQUATION DE LIAISON SUR PHI2
            ENDIF
            
          ENDIF

C-------------------------------------------------------------------C
C--                                                               --C
C-- PROJECTION DES MATRICES DE LIAISON SUR LA BASE MODALE ESCLAVE --C
C--                                                               --C
C-------------------------------------------------------------------C

          INDCOL='BLANC'
          NBCOL=0          
          
          IF (IMAST .LT. 2) THEN

            IAD=LDPMLI+(I-1)*9
            NBBLOC=NBBLOC+1
            ZI(IAD+2)=NBBLOC
            CALL LIARED(NOMRES,FMLIA,NBBLOC,TRAMO1,DDLA2,NBEQ1,
     &                  TRAMO2,DDLA2,NBEQ2,TAILLE,INDCOL,NBCOL)
            ZI(IAD)=TAILLE(1)
            ZI(IAD+1)=TAILLE(2)
     
            IAD=LDPMLI+(I-1)*9+3       
            NBBLOC=NBBLOC+1
            ZI(IAD+2)=NBBLOC        
            CALL LIARED (NOMRES,FMLIA,NBBLOC,TRAMO2,DDLA2,NBEQ2,
     &                   TRAMO2,DDLA2,NBEQ2,TAILLE,INDCOL,NBCOL)
            ZI(IAD)=TAILLE(1)
            ZI(IAD+1)=TAILLE(2)
            NBLIG=TAILLE(1)
            
          ELSE
          
            IAD=LDPMLI+(I-1)*9
            NBBLOC=NBBLOC+1
            ZI(IAD+2)=NBBLOC
            CALL LIARED (NOMRES,FMLIA,NBBLOC,TRAMO1,DDLA1,NBEQ1,
     &                   TRAMO1,DDLA1,NBEQ1,TAILLE,INDCOL,NBCOL)
            ZI(IAD)=TAILLE(1)
            ZI(IAD+1)=TAILLE(2)

            IAD=LDPMLI+(I-1)*9+3
            NBBLOC=NBBLOC+1
            ZI(IAD+2)=NBBLOC        
            CALL LIARED(NOMRES,FMLIA,NBBLOC,TRAMO2,DDLA1,NBEQ2,
     &                  TRAMO1,DDLA1,NBEQ1,TAILLE,INDCOL,NBCOL)
            ZI(IAD)=TAILLE(1)
            ZI(IAD+1)=TAILLE(2)
     
            NBLIG=TAILLE(1)
            
          ENDIF
                          
          CALL JEDETR(INDCOL)
C
C  MATRICE LAGRANGE-LAGRANGE
C
          IAD=LDPMLI+(I-1)*9+6
          ZI(IAD)=NBLIG
          ZI(IAD+1)=2
          ZI(IAD+2)=NBBLOC+1
          NBBLOC=NBBLOC+1
          ICAR(1)=ZI(IAD)
          ICAR(2)=ZI(IAD+1)
          ICAR(3)=ZI(IAD+2)
          ICAR(4)=IMAST
          CALL INILAG(FMLIA,ICAR)
                    
C-- DESTRUCTION DES CONCEPTS TEMPORAIRES
          
          CALL JEDETR(INDIN1)
          CALL JEDETR(LINO1)
          CALL JEDETR(TRAMO1)

          CALL JEDETR(INDIN2)
          CALL JEDETR(LINO2)
          CALL JEDETR(TRAMO2)

        ENDIF

  10  CONTINUE
C
C   DESTRUCTIONS COLLECTIONS VOLATILES DE TRAVAIL
C
      CALL JEDETR(FPLI1O)
      CALL JEDETR(FPLI2O)
      CALL JEDETR(FPLI1N)
      CALL JEDETR(FPLI2N)
C
      CALL JEDEMA()
      END
