      SUBROUTINE XBASLO(MODELE,NOMA,CHFOND,GRLT,GRLN,CNSBAS)
      IMPLICIT NONE

      CHARACTER*8     MODELE,NOMA
      CHARACTER*19    GRLT,GRLN,CNSBAS
      CHARACTER*24    CHFOND


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/04/2005   AUTEUR GENIAUT S.GENIAUT 
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
C RESPONSABLE GENIAUT S.GENIAUT
C
C     FONCTION REALISEE : CREATION D'UN CHAM_EL QUI CONTIENT LA BASE
C                         LOCALE AU POINT DU FOND DE FISSURE ASSOCIE
C ----------------------------------------------------------------------
C ENTREE:
C      MODELE  : NOM DE L'OBJET MODELE
C      NOMA    : NOM DE L'OBJET MAILLAGE
C      CHFOND  : NOM DES POINTS DU FOND DE FISSURE
C      GRLT    : GRADIENTS DE LA LEVEL-SET TANGENTE
C      GRLN    : GRADIENTS DE LA LEVEL-SET NORMALE
C
C SORTIE:
C      CNSBAS  : CHAM_NO_S BASE LOCALE DE FONFIS
C ----------------------------------------------------------------------
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
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
      CHARACTER*1 K1BID
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*24      COORN
      CHARACTER*19      LIGREL
      CHARACTER*8       LICMP(9),K8BID
      INTEGER           IFON,IADRCO,IADRMA,JGSV,JGSL,JGT,JGN
      INTEGER           LONG,LNOFF,NBNO,IRET,INO,J
      REAL*8            XI1,YI1,ZI1,XJ1,YJ1,ZJ1,XIJ,YIJ,ZIJ,EPS,D,NORM2
      REAL*8            XM,YM,ZM,XIM,YIM,ZIM,S,DMIN,XN,YN,ZN,A(3)
      REAL*8            R8MAEM
C
      CALL JEMARQ()
  
      CALL JEVEUO(CHFOND,'L',IFON) 
      CALL JELIRA(CHFOND,'LONMAX',LONG,K8BID)  
      LNOFF=LONG/4

C     R�CUP�RATION DES GRADIENTS DE LST ET LSN
      CALL JEVEUO(GRLT//'.CNSV','L',JGT)
      CALL JEVEUO(GRLN//'.CNSV','L',JGN)

      COORN = NOMA//'.COORDO    .VALE'
      CALL JEVEUO(COORN,'L',IADRCO)

      LICMP(1)  = 'X1'
      LICMP(2)  = 'X2'
      LICMP(3)  = 'X3'
      LICMP(4)  = 'X4'
      LICMP(5)  = 'X5'
      LICMP(6)  = 'X6'
      LICMP(7)  = 'X7'
      LICMP(8)  = 'X8'
      LICMP(9)  = 'X9'
      CALL CNSCRE(NOMA,'NEUT_R',9,LICMP,'V',CNSBAS)
      CALL JEVEUO(CNSBAS//'.CNSV','E',JGSV)
      CALL JEVEUO(CNSBAS//'.CNSL','E',JGSL)
      CALL DISMOI('F','NB_NO_MAILLA',NOMA,'MAILLAGE',NBNO,K8BID,IRET)
 
C     CALCUL DES PROJET�S DES NOEUDS SUR LE FOND DE FISSURE 
      EPS = 1.D-12
      DO 100 INO=1,NBNO
C       COORD DU NOEUD M DU MAILLAGE                
        XM = ZR(IADRCO+(INO-1)*3+1-1)
        YM = ZR(IADRCO+(INO-1)*3+2-1)
        ZM = ZR(IADRCO+(INO-1)*3+3-1)
C       INITIALISATION
        DMIN = R8MAEM()
C       BOUCLE SUR PT DE FONFIS (ALGO VOIR )
        DO 110 J=1,LNOFF-1
C         COORD PT I, ET J
          XI1 = ZR(IFON-1+4*(J-1)+1) 
          YI1 = ZR(IFON-1+4*(J-1)+2) 
          ZI1 = ZR(IFON-1+4*(J-1)+3) 
          XJ1 = ZR(IFON-1+4*(J-1+1)+1) 
          YJ1 = ZR(IFON-1+4*(J-1+1)+2) 
          ZJ1 = ZR(IFON-1+4*(J-1+1)+3) 
C         VECTEUR IJ ET IM
          XIJ = XJ1-XI1
          YIJ = YJ1-YI1
          ZIJ = ZJ1-ZI1
          XIM = XM-XI1
          YIM = YM-YI1
          ZIM = ZM-ZI1
C         PARAM S (PRODUIT SCALAIRE...)
          S        = XIJ*XIM + YIJ*YIM + ZIJ*ZIM
          NORM2 = XIJ*XIJ + YIJ *YIJ + ZIJ*ZIJ
          IF (NORM2.LE.1.D-10) CALL UTMESS('F','XBASLO','SEGMENT NUL')
          S        = S/NORM2
C         SI N=P(M) SORT DU SEGMENT
          IF ((S-1).GE.EPS) S = 1.D0
          IF (S.LE.EPS)     S = 0.D0
C         COORD DE N
          XN = S*XIJ+XI1
          YN = S*YIJ+YI1
          ZN = S*ZIJ+ZI1
C         DISTANCE MN
          D = SQRT((XN-XM)*(XN-XM)+(YN-YM)*(YN-YM)+
     &             (ZN-ZM)*(ZN-ZM))
          IF(D.LT.DMIN) THEN
            DMIN = D
            A(1)=XN
            A(2)=YN
            A(3)=ZN
          ENDIF
110     CONTINUE
C       STOCKAGE DU PROJET� ET DES GRADIENTS         
        DO 120 J=1,3
          ZR(JGSV-1+9*(INO-1)+J)=A(J)
          ZL(JGSL-1+9*(INO-1)+J)=.TRUE.
          ZR(JGSV-1+9*(INO-1)+J+3)=ZR(JGT-1+3*(INO-1)+J)
          ZL(JGSL-1+9*(INO-1)+J+3)=.TRUE.
          ZR(JGSV-1+9*(INO-1)+J+6)=ZR(JGN-1+3*(INO-1)+J)
          ZL(JGSL-1+9*(INO-1)+J+6)=.TRUE.
 120    CONTINUE
 100  CONTINUE
      CALL JXVERI(' ',' ')
      CALL JEDEMA()
      END
