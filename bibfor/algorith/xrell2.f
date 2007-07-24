      SUBROUTINE XRELL2(TABNOZ,NDIM  ,NARZ  ,TABCOZ,
     &                  NLISEQ,NLISRL,NLISCO)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/07/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
      IMPLICIT NONE
      INTEGER       NARZ,NDIM
      INTEGER       TABNOZ(3,NARZ)
      REAL*8        TABCOZ(NDIM,NARZ)
      CHARACTER*19  NLISEQ,NLISRL,NLISCO       
C      
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (PREPARATION)
C
C CHOIX DE L'ESPACE DES LAGRANGES POUR LE CONTACT - V2: 
C                    (VOIR BOOK VI 30/09/05)
C    - CREATION DES RELATIONS DE LIAISONS ENTRE LAGRANGE
C
C ----------------------------------------------------------------------
C 
C
C IN  NAR    : NOMBRE D'ARETES COUPEES
C IN  TABNOZ : TABLEAU DES NOEUDS EXTREMITES ET NOEUD MILIEU
C IN  TABCOZ : TABLEAU DES COORDONNEES DES NOEUDS MILIEU
C IN  NDIM   : DIMENSION DU PROBLEME
C OUT NLISRL : LISTE REL. LIN. POUR V1 ET V2
C OUT NLISCO : LISTE REL. LIN. POUR V1 ET V2
C OUT NLISEQ : LISTE REL. LIN. POUR V2 SEULEMENT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER     NAR,I,J,TABNO(NARZ,3),NBARVI,NBARHY,SCORNO(2*NARZ)
      INTEGER     CPT,DEJA,K,NOEUD(2*NARZ),IK,TABDIR(NARZ,2),NBNO,II,IA
      INTEGER     SCORAR(NARZ),BESTAR,MAXI,ARHY(NARZ,3),IR,T1(2*NARZ)
      INTEGER     MI,MA,NPAQ,T2(NARZ),NRELEQ,IP,DIMEQ,EQ(NARZ),IE,IPAQ
      INTEGER     LISEQT(NARZ,2),JLIS1,NRELRL,IH,IEXT
      INTEGER     COEFI(2),JLIS2,JLIS3
      INTEGER     IFM,NIV
      REAL*8      TABCO(NARZ,NDIM),R8MAEM,DIST,DISMIN
      REAL*8      COEFR(2),COARHY(NARZ,NDIM)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)        
C
C --- INITIALISATIONS
C
      NAR    = NARZ
      DO 100 I=1,NAR
        DO 101 J=1,3
          TABNO(I,J)=TABNOZ(J,I)
 101    CONTINUE
        DO 102 J=1,NDIM
          TABCO(I,J)=TABCOZ(J,I)  
 102    CONTINUE
 100  CONTINUE
C     COMPTEUR D'ARETES HYPERSTATIQUES
      NBARHY = 0 
      DO 200 I=1,2*NAR
        SCORNO(I)=0
 200  CONTINUE      
C
C --- SELECTION DES ARETES VITALES
C 
C
C --- CALCUL DE SCORNO : NB D'ARETES CONNECTEES AU NOEUD
C
      CPT=0
      DO 201 I=1,NAR
        DO 202 J=1,2
          DEJA=0
          DO 203 K=1,CPT
            IF (TABNO(I,J).EQ.NOEUD(K)) THEN
              DEJA=1
              IK=K
            ENDIF
 203      CONTINUE
          IF (DEJA.EQ.0) THEN
             CPT=CPT+1
             NOEUD(CPT)=TABNO(I,J)
             TABDIR(I,J)=CPT
          ELSE
            TABDIR(I,J)=IK
          ENDIF
        SCORNO(TABDIR(I,J))=SCORNO(TABDIR(I,J))+1
 202    CONTINUE
 201  CONTINUE
C
C --- NOMBRE DE NOEUDS
C
      NBNO=CPT

C     BOUCLE TANT QU'IL RESTE DES ARETES HYPERSTATIQUES
      DO 210 II=1,NARZ

C       CALCUL SCORAR : MIN DE SCORE POUR CHAQUE NOEUD
C       CALCUL SCOAR2 : LONGUEUR DE L'ARETE
        DO 211 IA=1,NAR
          SCORAR(IA) = MIN(SCORNO(TABDIR(IA,1)),SCORNO(TABDIR(IA,2)))
 211    CONTINUE

C       ARETE AU SCORE MAX
        MAXI=-1
        DO 212 IA=1,NAR
          IF (SCORAR(IA).GT.MAXI) THEN
            MAXI =SCORAR(IA)
            BESTAR=IA
          ENDIF
 212    CONTINUE

C       SI SCORE DE LA MEILLEURE ARETE =1 ALORS IL RESTE QUE DES ARETES
C       VITALES ET DONC ON SORT DE LA BOUCLE 210
        IF (MAXI.EQ.1) THEN
          GOTO 299
        ELSE
C         ON SAUVE BESTAR DANS ARHY ET NOARHY
          NBARHY=NBARHY+1
          DO 213 I=1,3
            ARHY(NBARHY,I)=TABNO(BESTAR,I)
 213      CONTINUE
          DO 214 I=1,NDIM
            COARHY(NBARHY,I)=TABCO(BESTAR,I)
 214      CONTINUE

C         UPDATE SCORE DES NOEUDS SI ON SUPPRIMAIT LA MEILLEURE ARETE
          SCORNO(TABDIR(BESTAR,1))=SCORNO(TABDIR(BESTAR,1))-1
          SCORNO(TABDIR(BESTAR,2))=SCORNO(TABDIR(BESTAR,2))-1

C         ON SUPPRIME EFFECTIVEMENT LA MEILLEURE ARETE
          DO 220 I=BESTAR,NAR-1
            TABNO(I,1) = TABNO(I+1,1)
            TABNO(I,2) = TABNO(I+1,2)
            TABNO(I,3) = TABNO(I+1,3)
            TABDIR(I,1)= TABDIR(I+1,1)
            TABDIR(I,2)= TABDIR(I+1,2)
            DO 230 J=1,NDIM
              TABCO(I,J) = TABCO(I+1,J)
 230        CONTINUE
 220      CONTINUE
          TABNO(NAR,1)=0
          TABNO(NAR,2)=0
          TABNO(NAR,3)=0
          TABDIR(NAR,1)=0
          TABDIR(NAR,2)=0
          DO 240 J=1,NDIM
            TABCO(NAR,J)=0    
 240      CONTINUE
          NAR=NAR-1
        ENDIF

 210  CONTINUE

 299  CONTINUE

C     NOMBRE D'ARETES VITALES : NB D'ARETES RESTANTES
      NBARVI=NAR

C     VERIF SI NB ARETES HYPERS + NB ARETES VITALES = NB ARETES INITIAL
      CALL ASSERT(NBARHY+NBARVI.EQ.NARZ)

C     ATTENTION : MAINTENANT, TABNO ET TABDIR SONT DE LONGUEUR NBARVI
C
C --- CREATION DES RELATIONS D'EGALITE A IMPOSER
C --- TABLEAU T1 : PAQUET DE NOEUDS  DIM : NBNO
C
      IPAQ=0
      DO 400 I=1,2*NARZ
        T1(I)=0
 400  CONTINUE     
      DO 401 IR = 1,NBARVI
        IF (T1(TABDIR(IR,1)).EQ.0 .AND. T1(TABDIR(IR,2)).EQ.0) THEN
          IPAQ=IPAQ+1
          T1(TABDIR(IR,1))=IPAQ
          T1(TABDIR(IR,2))=IPAQ
        ELSEIF (T1(TABDIR(IR,1)).EQ.0 .AND. T1(TABDIR(IR,2)).NE.0) THEN
          T1(TABDIR(IR,1))=T1(TABDIR(IR,2))
        ELSEIF (T1(TABDIR(IR,1)).NE.0 .AND. T1(TABDIR(IR,2)).EQ.0) THEN
          T1(TABDIR(IR,2))=T1(TABDIR(IR,1))
        ELSEIF (T1(TABDIR(IR,1)).NE.0 .AND. T1(TABDIR(IR,2)).NE.0) THEN
C         SI ILS APPARTIENNET A DEUX PAQUETS DIFFERENTS
C         ALORS ON REGROUPE LES PAQUETS
          IF (T1(TABDIR(IR,1)) .NE. T1(TABDIR(IR,2))) THEN
              MI=MIN(T1(TABDIR(IR,1)) ,  T1(TABDIR(IR,2)))
              MA=MAX(T1(TABDIR(IR,1)) ,  T1(TABDIR(IR,2)))
              DO 402 I=1,NBNO
                IF (T1(I).EQ.MA)  T1(I)=MI
 402          CONTINUE
          ENDIF
        ENDIF
 401  CONTINUE
C     NOMBRE DE PAQUETS
      NPAQ=IPAQ

C     TABLEAU T2 : PAQUETS D'ARETES  (DIM : NBARVI)
      DO 410 IA=1,NBARVI
        CALL ASSERT( T1(TABDIR(IA,1)) .EQ. T1(TABDIR(IA,2)) )
        T2(IA)=T1(TABDIR(IA,1))
 410  CONTINUE

C     CREATION DU TABLEAU TEMPORAIRE DES RELATIONS D'EGALITE : LISEQT
      NRELEQ=0
      DO 440 IP=1,NPAQ
        DIMEQ=0
C       RECHERCHE DES ARETES DU PAQUET
        DO 441 IA=1,NBARVI
          IF (IP.EQ.T2(IA)) THEN
            DIMEQ=DIMEQ+1
            EQ(DIMEQ)=TABNO(IA,3)
          ENDIF
 441    CONTINUE
        CALL ASSERT(DIMEQ-1.GE.0)
        DO 442 IE=1,DIMEQ-1
           NRELEQ=NRELEQ+1
           LISEQT(NRELEQ,1)=EQ(IE)
           LISEQT(NRELEQ,2)=EQ(IE+1)
 442    CONTINUE
 440  CONTINUE

      WRITE(IFM,*)'NOMBRE DE RELATIONS D''EGALITE : ',NRELEQ

C     STOCKAGE DE LISEQT
      IF (NRELEQ.GT.0) THEN
        CALL WKVECT(NLISEQ,'G V I',NRELEQ*2,JLIS1)
        DO 450 IE=1,NRELEQ
          ZI(JLIS1-1+2*(IE-1)+1)=LISEQT(IE,1)
          ZI(JLIS1-1+2*(IE-1)+2)=LISEQT(IE,2)
C          WRITE(6,*)'LISEQ ',LISEQT(IE,1),LISEQT(IE,2)
 450    CONTINUE
      ENDIF


C     ------------------------------------------------------------------
C     CREATION DES RELATION LINEAIRES A IMPOSER
C     ------------------------------------------------------------------

C     NOMBRE DE RELATIONS LINEAIRES  = NB D'ARETES HYPERSTATIQUES
      NRELRL=NBARHY

C     VECTEUR DES RELATIONS LINEAIRES           :LISRLT
C     VECTEUR DES COEFFICIENTS DE CES RELATIONS :LISCOT

      WRITE(IFM,*)'NOMBRE DE RELATIONS LINEAIRES : ',NRELRL
      WRITE(IFM,*)' '

      IF (NRELRL.GT.0) THEN

        CALL WKVECT(NLISRL,'G V I',NRELRL*3,JLIS2)
        CALL WKVECT(NLISCO,'G V R',NRELRL*3,JLIS3)

        DO 500 IH=1,NRELRL

          DO 510 IEXT=1,2
            DISMIN=R8MAEM()
C           ON PARCOURT LES ARETES VITALES CONNECTEES
            DO 511 I=1,NBARVI
              IF ( TABNO(I,1).EQ.ARHY(IH,IEXT).OR.
     &             TABNO(I,2).EQ.ARHY(IH,IEXT) )    THEN
C               CALCUL DISTANCE ENTRE LAG A LIER ET LE LAG EXT
                DIST=0
                DO 512 J=1,NDIM
                  DIST = (DIST + ((TABCO(I,J)-COARHY(IH,J))**2))
 512            CONTINUE
                DIST = SQRT(DIST)
                IF (DIST.LE.DISMIN) THEN
                  DISMIN=DIST
                  COEFI(IEXT)=TABNO(I,3)
                  COEFR(IEXT)=DIST
                ENDIF
              ENDIF
 511        CONTINUE
 510      CONTINUE

          ZI(JLIS2-1+3*(IH-1)+1)=ARHY(IH,3)
          ZI(JLIS2-1+3*(IH-1)+2)=COEFI(1)
          ZI(JLIS2-1+3*(IH-1)+3)=COEFI(2)

          ZR(JLIS3-1+3*(IH-1)+1)=1.D0
          ZR(JLIS3-1+3*(IH-1)+2)=-COEFR(2)/(COEFR(1)+COEFR(2))
          ZR(JLIS3-1+3*(IH-1)+3)=-COEFR(1)/(COEFR(1)+COEFR(2))

 500    CONTINUE

      ENDIF      

      CALL JEDEMA()
      END
