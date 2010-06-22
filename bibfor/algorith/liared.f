      SUBROUTINE LIARED (NOMRES,FMLI,IBLO,LIAMOD,NLILIA,NCOLIA,
     &                   PROMOD,NLIPRO,NCOPRO,TAILLE,INDCOL,NBCOL)
      IMPLICIT NONE
C MODIF ALGORITH  DATE 21/06/2010   AUTEUR CORUS M.CORUS 
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
C***********************************************************************
C  O. NICOLAS     DATE 01/08/04
C
C  REFAIT INTEGRALEMENT
C
C    M. CORUS     DATE 05/02/10
C-----------------------------------------------------------------------
C  BUT:      < CALCUL DE LA MATRICE DE LIAISON REDUITE >
C
C  ON PROJETTE LA RESTICTION DE LA BASE MODALE A L'INTERFACE SUR
C  LA RESTRICTION DE LA BASE MODALE ESCLAVE. L'ORIENTATION DES 
C  SOUS-STRUCTURES A DEJA ETE PRISE EN COMPTE
C  ON ELIMINE LES LIGNES CORRESPONDANT AUX VECTEURS DU PROJECTEUR
C  NE FAISANT PAS BOUGER L'INTERFACE
C
C-----------------------------------------------------------------------
C
C NOMRES  /I/ : NOM UTILISATEUR DU RESULTAT MODELE_GENE
C FMLI    /I/ : FAMILLE DES MATRICES DE LIAISON
C IBLO    /I/ : NUMERO DU BLOC DE LA LIAISON
C LIAMOD  /I/ : MATRICE A PROJETER
C NLILIA /I/ : NB DE LIGNES DE LA MATRICE A PROJETER
C NCOLIA /I/ : NB DE COLONNES DE LA MATRICE A PROJETER
C PROMOD  /I/ : MATRICE DU PROJECTEUR
C NLIPRO /I/ : NB DE LIGNES DU PROJECTEUR
C NCOPRO /I/ : NB DE COLONNES DU PROJECTEUR
C TAILLE  /O/ : TAILLE DE LA MATRICE DE LAISON
C INDCOL /I-O/ : VECTEUR DES INDICES DES COLONNES DE LIAISONS ACTIVES
C NBCOL   /I-O/ : NOMBRE DE COLONNES ACTIVES
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
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32  JEXNOM,JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

C-- VARIABLES EN ENTREES / SORTIE
      INTEGER      IBLO,NLILIA,NCOLIA,NLIPRO,NCOPRO,TAILLE(2),
     &             NBCOL
      CHARACTER*8  NOMRES
      CHARACTER*24 FMLI,LIAMOD,PROMOD,INDCOL
      
C-- VARIABLES DE LA ROUTINE  
      INTEGER      I1,J1,K1,L1,M,N,LLIAMO,LPROMO,LTEMP,LPRO,LMAT,
     &             LMATB,LMATS,LWORK,LLWORK,RANK,INFO
      REAL*8       TEMP,EPS,COEFF,SWORK
      PARAMETER    (EPS=2.3D-16)
C
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C-- TEST SUR LA TAILLE DES MATRICES POUR S'ASSURER DE POUVOIR
C-- FAIRE LA PROJECTION
C
      IF (NLIPRO .EQ. NLILIA) THEN
      
        CALL JEVEUO(LIAMOD,'L',LLIAMO)
        CALL JEVEUO(PROMOD,'L',LPROMO)
        
        IF (LIAMOD .EQ. PROMOD) THEN
          COEFF=-1.D0
        ELSE
          COEFF=1.D0
        ENDIF       
C
C-- TEST SUR LA PRESENCE DE COLONNES DE ZEROS DANS LE PROJECTEUR
C-- ET DETERMINATION DE LA TAILLE DE LA MATRICE DE LIAISON SI CA N'A
C-- PAS DEJA ETE FAIT
C
        IF (INDCOL(1:5) .EQ. 'BLANC') THEN
          INDCOL='&&INDCOLONNES_NON_ZERO'
          CALL WKVECT(INDCOL,'V V I',NCOPRO,LPRO)
          DO 20 I1=1,NCOPRO
            ZI(LPRO+I1-1)=0
  20      CONTINUE
          NBCOL=0
          DO 30 J1=1,NCOPRO
            TEMP=0.D0
            DO 40 I1=1,NLIPRO
              TEMP=TEMP+ZR(LPROMO+(J1-1)*NLIPRO+I1-1)**2
  40        CONTINUE
            IF (SQRT(TEMP)/NLIPRO .GT. EPS ) THEN
              ZI(LPRO+NBCOL)=J1
              NBCOL=NBCOL+1
            ENDIF
  30      CONTINUE
        ELSE
          CALL JEVEUO(INDCOL,'L',LPRO)
        ENDIF
C
C --- CREATION DE LA NOUVELLE MATRICE DE LIAISON
C
        CALL JECROC(JEXNUM(FMLI,IBLO))
        CALL JEECRA(JEXNUM(FMLI,IBLO),'LONMAX',NBCOL*NCOLIA,' ')
        CALL JEVEUO(JEXNUM(FMLI,IBLO),'E',LTEMP)
C
C --- INITIALISATION DES MATRICES ORIENTEES DE LIAISON----------
C
        DO 10 I1=1,NBCOL*NCOLIA
          ZR(LTEMP+I1-1)=0.D0
 10     CONTINUE       


C        CALL DGEMM('T','N',NCOPRO,NCOLIA,NLIPRO,1.,ZR(LPROMO),
C     &            NLIPRO,ZR(LLIAMO),NLILIA,0.,ZR(LTEMP),NCOPRO)

C-- BOUCLE "A LA MAIN", TEL QUE DANS DGEMM :
C
C   C=A^T*B  => Cij = Sum(Aki*Bkj)
C
C    A : NLA*NCA  
C    B : NLA*NCB
C    C : NCA*NCB
C
C   C(i,j) = C( (j-1)*NCA + i-1 )
C   A(i,k) = A( (k-1)*NLA + i-1 )
C    => A(k,i) = A( (k-1)*NLA + i-1 )
C   B(k,j) = B( (j-1)*NLB + k-1 )
C
C   pour j=1,NCB
C     pour k=1,NLA
C       pour i=1,NCA
C         C( (j-1)*NCA+(i-1) ) = 
C              C( (j-1)*NCA+ i-1 ) +
C              A( (i-1)*NLA + k-1 ) *
C              B( (j-1)*NLB + k-1 )
C
  

C--
C-- PROJECTION INITIALE
C--
        
        DO 50 J1=1,NCOLIA
          DO 60 K1=1,NLIPRO
            TEMP=ZR(LLIAMO+(J1-1)*NLILIA+K1-1)
              DO 70 L1=1,NBCOL
                I1=ZI(LPRO+L1-1)
                ZR(LTEMP+(J1-1)*NBCOL+L1-1)=
     &             ZR(LTEMP+(J1-1)*NBCOL+L1-1)+
     &             COEFF*TEMP*ZR(LPROMO+(I1-1)*NLIPRO+K1-1)
  70          CONTINUE
  60      CONTINUE
  50    CONTINUE

C-- TEST EN PRENANT LE PSEUDO INVERSE

C-- CREATION DE LA MATRICE TEMPORAIRE DE LIAISON POUR LE PRODUIT

C##        CALL WKVECT('&&LIARED.MAT_TEMP','V V R',NBCOL*NLIPRO,LMAT)
C##        
C##C-- ON RECOPIE LE PROJECTEUR EN LE TRANSPOSANT  
C##
C##C        WRITE(6,*)'RAOUL'
C##C        WRITE(6,*)'      '
C##C        WRITE(6,*)'      '
C##C        WRITE(6,*)'      '
C##C        WRITE(6,*)'      '
C##        
C##   
C##        DO 50 I1=1,NLIPRO
C##          DO 60 J1=1,NBCOL
C##            K1=ZI(LPRO+J1-1)
C##            ZR(LMAT+(I1-1)*NBCOL+J1-1)=
C##     &         ZR(LPROMO+(K1-1)*NLIPRO+I1-1)
C##  60      CONTINUE
C##  50    CONTINUE
C##  
C##C        DO 11 I1=1,NBCOL
C##C          DO 12 J1=1,NLIPRO
C##C            WRITE(6,*)'PHIT(',I1,',',J1,')=',
C##C     &                 ZR(LMAT+(J1-1)*NBCOL+I1-1),';'
C##C  12      CONTINUE
C##C  11    CONTINUE        
C##  
C##        M=NLIPRO
C##        N=NBCOL
C##        CALL WKVECT('&&LIARED.MATRICE_B','V V R',MAX(M,N)**2,LMATB)
C##        CALL WKVECT('&&LIARED.MATRICE_S','V V R',MIN(M,N),LMATS)
C##        DO 70 I1=1,N
C##          ZR(LMATB+(I1-1)*NLIPRO+I1-1)=1.
C##  70    CONTINUE
C##        CALL DGELSS(N,M,N,ZR(LMAT),N,ZR(LMATB),M,ZR(LMATS),EPS,RANK,
C##     &              SWORK,-1,INFO)
C##        LWORK=INT(SWORK)
C##        CALL WKVECT('&&LIARED.MATR_WORK','V V R',LWORK,LLWORK)
C##        CALL DGELSS(N,M,N,ZR(LMAT),N,ZR(LMATB),M,ZR(LMATS),EPS,RANK,
C##     &              ZR(LLWORK),LWORK,INFO)
C##     
C##        
C##C        WRITE(6,*)'      '
C##C        WRITE(6,*)'      '
C##        
C##C        DO 80 I1=1,NLIPRO
C##C          DO 90 J1=1,NBCOL
C##C            WRITE(6,*)'PHI_INV(',I1,',',J1,')=',
C##C     &                 ZR(LMATB+(J1-1)*NLIPRO+I1-1),';'
C##C  90      CONTINUE
C##C  80    CONTINUE
C##
C##
C##C        WRITE(6,*)'COEFF=',COEFF
C##C        WRITE(6,*)'NBCOL=',NBCOL
C##C        WRITE(6,*)'NLIPRO=',NLIPRO
C##        
C##        
C##        DO 51 J1=1,NCOLIA
C##          DO 61 K1=1,NLIPRO
C##            TEMP=ZR(LLIAMO+(J1-1)*NLILIA+K1-1)
C##              DO 71 L1=1,NBCOL
C##C                I1=ZI(LPRO+L1-1)
C##                ZR(LTEMP+(J1-1)*NBCOL+L1-1)=
C##     &             ZR(LTEMP+(J1-1)*NBCOL+L1-1)+
C##     &             COEFF*TEMP*ZR(LMATB+(L1-1)*NLIPRO+K1-1)
C##  71          CONTINUE
C##  61      CONTINUE
C##  51    CONTINUE
C##      CALL JEDETR('&&LIARED.MATRICE_S')
C##      CALL JEDETR('&&LIARED.MATRICE_B')
C##      CALL JEDETR('&&LIARED.MAT_TEMP')
C##      CALL JEDETR('&&LIARED.MATR_WORK')

          
      ENDIF             
        
      TAILLE(1)=NBCOL
      TAILLE(2)=NCOLIA
      
C      WRITE(6,*)'  '
C      WRITE(6,*)'  '
C      DO 52 J1=1,NCOLIA
C        DO 72 L1=1,NBCOL
C          WRITE(6,*)'T(',L1,',',J1,')=',
C     &          ZR(LTEMP+(J1-1)*NBCOL+L1-1),';'
C  72    CONTINUE
C  52  CONTINUE


      CALL JEDEMA()
      
      END
