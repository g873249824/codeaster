        SUBROUTINE LCMMEI( COEFT,IFA,NMAT,NBCOMM,NECRIS,
     &                     NUMS,VIS,NVI,VINI,RP,SQ )
        IMPLICIT NONE
        INTEGER IFA,NMAT,NBCOMM(NMAT,3),NVI,NUMS
        REAL*8 COEFT(NMAT),VIS(3),DP
        REAL*8 VINI(NVI),SQ,QS
        CHARACTER*16 NECRIS
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/11/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C RESPONSABLE JMBHH01 J.M.PROIX
C  COMPORTEMENT MONOCRISTALLIN : ECROUISSAGE ISOTROPE 
C       IN  COEFT   :  PARAMETRES MATERIAU
C           IFA     :  NUMERO DE FAMILLE
C           NMAT    :  NOMBRE MAXI DE MATERIAUX
C           NBCOMM  :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C           NECOUL  :  NOM DE LA LOI D'ECOULEMENT
C           NECRIS  :  NOM DE LA LOI D'ECROUISSAGE ISTROPE
C           NUMS    :  NUMERO DU SYSTEME DE GLISSEMET EN COURS
C           VIS : VARIABLES INTERNES DU SYSTEME DE GLISSEMENT COURANT
C           NVI     :  NOMBRE DE VARIABLES INTERNES 
C           VINI    :  TOUTES lES VARIABLES INTERNES
C     OUT:
C           RP    :  R(P)
C ======================================================================

C     ----------------------------------------------------------------
      REAL*8 C,P,R0,Q,H,B,RP,K,N,FTAU,CRIT,B1,B2,Q1,Q2,A,GAMMA0,V,D
      REAL*8 TPERD,TABS,PR,DRDP,DDVIR(NVI),DRDPR,B1P
      INTEGER IEI,TNS,NS,IS
C     ----------------------------------------------------------------

C     DANS VIS : 1 = ALPHA, 2=GAMMA, 3=P

      IEI=NBCOMM(IFA,3)
      P=VIS(3)
C     NS=NOMBRE TOTAL DE SYSTEMES DE GLISSEMENT         
      NS=(NVI-1-6)/3
      

C--------------------------------------------------------------------
C     POUR UN NOUVEAU TYPE D'ECROUISSAGE ISOTROPE, AJOUTER UN BLOC IF
C--------------------------------------------------------------------
      IF (NECRIS.EQ.'ECRO_ISOT1') THEN

         R0=COEFT(IEI-1+1)
         Q=COEFT(IEI-1+2)
         B=COEFT(IEI-1+3)
         H=COEFT(IEI-1+4)
         
         RP=R0
C        R(PS)=R0+Q*SOMME(HSR*(1-EXP(-B*PR))       
         IF (NUMS.EQ.1) THEN
            SQ=0.D0
            DO 1 IS=1,NS
C           POUR GAGNER DU TEMSP CALCUL DE SOMME DE QI UNE SEULE FOIS
C
C           CAR RS=Q((1-H)QS + H(SOMME(QR))
               PR=VINI(3*(IS-1)+3)
               IF (ABS(B*PR).GT.100.D0) THEN
                  SQ=SQ+1
               ELSE
                  SQ=SQ+(1.D0-EXP(-B*PR))
               ENDIF
 1         CONTINUE         
         ENDIF  
         
         IF (ABS(B*P).GT.100.D0) THEN
            QS=1.D0
         ELSE
            QS=(1.D0-EXP(-B*P))
         ENDIF
         RP=RP+Q*((1.D0-H)*QS+H*SQ)

      ELSEIF (NECRIS.EQ.'ECRO_ISOT2') THEN

         R0=COEFT(IEI-1+1)
         Q1=COEFT(IEI-1+2)
         B1=COEFT(IEI-1+3)
         H =COEFT(IEI-1+4)
         Q2=COEFT(IEI-1+5)
         B2=COEFT(IEI-1+6)

         RP=R0
C        R(PS)=R0+Q1*SOMME(HSR*(1-EXP(-B1*PR))+Q2*(1-EXP(-B2*PR)        
         IF (NUMS.EQ.1) THEN
            SQ=0.D0
            DO 11 IS=1,NS
C           POUR GAGNER DU TEMSP CALCUL DE SOMME DE QI UNE SEULE FOIS
C
C           CAR RS=Q1((1-H)Q1S + H(SOMME(Q1R))+Q2*Q2s
               PR=VINI(3*(IS-1)+3)
               IF (ABS(B1*PR).GT.100.D0) THEN
                  SQ=SQ+1
               ELSE
                  SQ=SQ+(1.D0-EXP(-B1*PR))
               ENDIF
 11         CONTINUE         
         ENDIF  
         
         B1P=B1*P
         IF (B1P.GT.100.D0) THEN
            QS=1.D0
         ELSE
            QS=(1.D0-EXP(-B1P))
         ENDIF
         RP=RP+Q1*((1.D0-H)*QS+H*SQ)
         IF (ABS(B2*P).GT.100.D0) THEN
            RP=RP+Q2
         ELSE
            RP=RP+Q2*(1.D0-EXP(-B2*P))
         ENDIF

      ENDIF
           
      END
