      SUBROUTINE TE0122(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/01/2011   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C......................................................................
C     FONCTION REALISEE:  CALCUL DES CHAMELEM AUX NOEUDS A PARTIR DES
C     VALEURS AUX POINTS DE GAUSS ( SIEF_ELNO ET VARI_ELNO_ELGA )
C     ELEMENTS DE JOINT ET JOINT_HYME 2D ET 3D

C IN  OPTION : OPTION DE CALCUL
C IN  NOMTE  : NOM DU TYPE ELEMENT
C ......................................................................

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER JGANO,NPG,NNOS,NNO,NDIM,NDIME,IPOIDS,IVF,IDFDE
      INTEGER ICHG,ICHN,ICOM,JTAB(7),NCMP,N,C,IBID,I,J,IN,IG,NTROU
      LOGICAL JHM
      CHARACTER*8 LIELRF(10)
C     ------------------------------------------------------------------

      JHM=.FALSE.
      IF (NOMTE(1:6).EQ.'EJHYME') THEN
        JHM=.TRUE.
      ENDIF  

C     INFORMATION SUR L'ELEMENT DE REFERENCE
      IF (JHM) THEN
        CALL ELREF2(NOMTE,2,LIELRF,NTROU)
        CALL ELREF4
     &       (LIELRF(2),'RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      ELSE
        CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      ENDIF


C RAPPEL DES INTERPOLATIONS POUR L'ESPACE
C JOINT 2D (QUAD4)  EST BASE SUR LE QUAD4 A 2PG DONC NPG=2, NNO=4
C JOINT 3D (HEXA8)  EST BASE SUR LE QUAD4 A 4PG DONC NPG=4, NNO=4
C JOINT 3D (PENTA6) EST BASE SUR LE TRIA3 A 1PG DONC NPG=1, NNO=3
C JOINT_HYME 2D (QUAD8) EST BASE SUR LE SEG2 A 2PG DONC NPG=2, NNO=2
C JOINT_HYME 3D (HEXA20) EST BASE SUR LE QUAD4 A 4PG DONC NPG=4, NNO=4
C JOINT_HYME 3D (PENTA15) EST BASE SUR LE TRIA3 A 3PG DONC NPG=3, NNO=3
     
C     DIMENSION DE L'ESPACE
      IF (NPG.EQ.2) THEN 
        NDIME = 2
      ELSE
        NDIME = 3
      ENDIF  
      
      IF (OPTION.EQ.'SIEF_ELNO') THEN
      
        CALL JEVECH('PCONTRR' ,'L',ICHG)
        CALL JEVECH('PSIEFNOR','E',ICHN)
        
        IF (JHM) THEN
          NCMP = 2*NDIME-1
        ELSE
          NCMP = NDIME
        ENDIF
         
      ELSEIF (OPTION.EQ.'VARI_ELNO_ELGA') THEN
      
        CALL JEVECH('PCOMPOR','L',ICOM)
        CALL JEVECH('PVARIGR','L',ICHG)
        CALL JEVECH('PVARINR','E',ICHN)
        CALL TECACH('OOO','PVARINR',7,JTAB,IBID)
        NCMP = MAX(JTAB(6),1)*JTAB(7)
        
      ENDIF

C    EXTRAPOLATION AUX NOEUDS

      IF (JHM) THEN

        IF (NDIME.EQ.2) THEN
              
          DO 10 I = 1,NCMP
            IG = ICHG-1+I
            IN = ICHN-1+I
C           NOEUDS 1,4,8            
            ZR(IN)        = ZR(IG+NCMP) + 
     &                     (ZR(IG)-ZR(IG+NCMP))*(1.D0-SQRT(3.D0))/2.D0
            ZR(IN+3*NCMP) = ZR(IG+NCMP) + 
     &                     (ZR(IG)-ZR(IG+NCMP))*(1.D0-SQRT(3.D0))/2.D0
            ZR(IN+7*NCMP) = ZR(IG+NCMP) + 
     &                     (ZR(IG)-ZR(IG+NCMP))*(1.D0-SQRT(3.D0))/2.D0
C           NOEUDS 2,3,6                        
            ZR(IN+  NCMP) = ZR(IG+NCMP) + 
     &                     (ZR(IG)-ZR(IG+NCMP))*(1.D0+SQRT(3.D0))/2.D0
            ZR(IN+2*NCMP) = ZR(IG+NCMP) + 
     &                     (ZR(IG)-ZR(IG+NCMP))*(1.D0+SQRT(3.D0))/2.D0
            ZR(IN+5*NCMP) = ZR(IG+NCMP) + 
     &                     (ZR(IG)-ZR(IG+NCMP))*(1.D0+SQRT(3.D0))/2.D0
C           NOEUDS 5,7                                   
            ZR(IN+4*NCMP) = (ZR(IG) + ZR(IG+NCMP))/2.D0  
            ZR(IN+6*NCMP) = (ZR(IG) + ZR(IG+NCMP))/2.D0
           
   10     CONTINUE 
   
        ELSE
        
C         ON REMPLIT LES NOEUDS SOMMETS DE LA 1ERE FACE 
C         (EX POUR L'HEXA20 : 1 2 3 4)
          CALL PPGAN2(JGANO,NCMP,ZR(ICHG),ZR(ICHN))

          DO 18 I = 1,NCMP
          
            IN = ICHN-1+I

C         ON REMPLIT LES NOEUDS MILIEU DE LA 1ERE FACE 
C         (EX POUR L'HEXA20 : 9 10 11 12)
C         EN MOYENNANT LES VALEURS DES NOEUDS SOMMETS DE LA 1ERE FACE
              
            ZR(IN+(2*NNO  )*NCMP) = (ZR(IN) + ZR(IN+NCMP))/2.D0
            ZR(IN+(2*NNO+1)*NCMP) = (ZR(IN+NCMP) + ZR(IN+2*NCMP))/2.D0
            ZR(IN+(2*NNO+2)*NCMP) = (ZR(IN+2*NCMP) + ZR(IN+3*NCMP))/2.D0
            ZR(IN+(2*NNO+3)*NCMP) = (ZR(IN+4*NCMP) + ZR(IN))/2.D0

            DO 19 J=1,NNO
C             ON REMPLIT LES NOEUDS SOMMETS DE LA 2ND FACE
C             (EX POUR L'HEXA20 : 5 6 7 8)
C             AINSI QUE LES NOEUDS MILIEU INTERMEDIAIRES 
C             (EX POUR L'HEXA20 : 13 14 15 16)
C             A L'IDENTIQUE DES NOEUDS SOMMETS DE LA 1ERE FACE
              ZR(IN+(J+  NNO-1)*NCMP) = ZR(IN+(J-1)*NCMP)
              ZR(IN+(J+3*NNO-1)*NCMP) = ZR(IN+(J-1)*NCMP)
              
C             ON REMPLIT LES NOEUDS MILIEU DE LA DEUXIEME FACE
C            (EX POUR L'HEXA20 : 17 18 19 20)              
C             A L'IDENTIQUE DES NOEUDS MILIEU DE LA PREMIERE FACE
              ZR(IN+(J+4*NNO-1)*NCMP) = ZR(IN+(J+2*NNO-1)*NCMP)
              
   19       CONTINUE 
     
   18     CONTINUE                         
        
        ENDIF
     
      ELSE

        IF (NDIME.EQ.2) THEN 
C REMARQUE : ICI LA POSITION DES 2 PG DE l'EJ SONT INVERSEES PAR
C RAPPORT A LA POS HABITUELLE DES FAMILLES D'EF 1D (SEG2 SEG3) A 2 PG
          DO 11 I = 1,NCMP
            IG = ICHG-1+I
            IN = ICHN-1+I
            ZR(IN)        = ZR(IG)+
     &                     (ZR(IG+NCMP)-ZR(IG))*(1.D0-SQRT(3.D0))/2.D0
            ZR(IN+3*NCMP) = ZR(IG)+
     &                     (ZR(IG+NCMP)-ZR(IG))*(1.D0-SQRT(3.D0))/2.D0
            ZR(IN+NCMP)   = ZR(IG)+
     &                     (ZR(IG+NCMP)-ZR(IG))*(1.D0+SQRT(3.D0))/2.D0
            ZR(IN+2*NCMP) = ZR(IG)+
     &                     (ZR(IG+NCMP)-ZR(IG))*(1.D0+SQRT(3.D0))/2.D0
   11     CONTINUE 
          
        ELSE
      
C         ON REMPLIT LES NOEUDS DE LA PREMIERE FACE       
          CALL PPGAN2(JGANO,NCMP,ZR(ICHG),ZR(ICHN))

C         ON REMPLIT LES NOEUD DE LA DEUXIEME FACE A L'IDENTIQUE
          DO 20 I = 1,NCMP
            IN = ICHN-1+I
            DO 30 J=1,NNO
              ZR(IN+(J+NNO-1)*NCMP) = ZR(IN+(J-1)*NCMP)
   30       CONTINUE                         
   20     CONTINUE                         
       
        ENDIF 
           
      ENDIF
           
      END
