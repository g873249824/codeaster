      SUBROUTINE ARBRCR(NOMARB,BASE  ,NMA   ,NMIN  ,GAMMA0,
     &                  GAMMA1,PRECAR,IMAX)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*1  BASE
      CHARACTER*16 NOMARB
      INTEGER      NMA
      INTEGER      NMIN
      REAL*8       GAMMA0,GAMMA1,PRECAR
      INTEGER      IMAX
C      
C ----------------------------------------------------------------------
C
C CREATION D'UN ARBRE BSP POUR APPARIEMENT DES MAILLES (EN BOITE) 
C
C CREATION DE LA STRUCTURE DE DONNEES
C
C ----------------------------------------------------------------------
C
C IN  NOMARB : NOM DE LA SD ARBRE
C IN  BASE   : TYPE DE BASE ('V' OU 'G')
C IN  NMA    : NOMBRE DE MAILLES
C IN  GAMMA0 : CRITERE GLOBAL DE QUALITE DE SEPARATION DE L'ARBRE
C IN  NMIN   : NOMBRE MAXIMUM DE MAILLES DANS UNE FEUILLE DE L'ARBRE
C IN  IMAX   : NOMBRE DE CANDIDATS POUR ETRE L'HYPERPLAN SEPARATEUR
C IN  GAMMA1 : AUTRE CRITERE DE QUALITE DE L'ARBRE (?)
C IN  PRECAR : PRECISION RELATIVE POUR DECIDER SI FEUILLE SUR PLAN 
C              MEDIATEUR OU NON
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
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
C      
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      IMA
      INTEGER      JLIMA,JCELL,JINFO
      INTEGER      NLIMA,NCELL      
      INTEGER      H        
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- HAUTEUR MAXIMALE DE L'ARBRE
C
      IF ((NMA.EQ.0).OR.
     &    ((1.D0*NMIN/NMA).LE.0).OR.
     &    ((0.5D0+0.5D0*GAMMA0.LE.0))) THEN
        CALL ASSERT(.FALSE.)
      ELSE
        H     = (LOG(1.D0*NMIN/NMA))/LOG(0.5D0+0.5D0*GAMMA0)
        H     = MAX(H,0) + 1        
      ENDIF
C
      NLIMA = ((1.D0+GAMMA0)**H)*NMA
      NCELL = (2**H)-1
C
C --- CREATION VECTEURS JEVEUX
C
      CALL WKVECT(NOMARB(1:16)//'.LIMA',BASE//' V I',NLIMA  ,JLIMA)
      CALL WKVECT(NOMARB(1:16)//'.CELL',BASE//' V I',NCELL*3,JCELL)
      CALL WKVECT(NOMARB(1:16)//'.INFO',BASE//' V R',9      ,JINFO)  
C
C --- SAUVEGARDE INFOS
C
      ZR(JINFO)     = H
      ZR(JINFO + 1) = NMA
      ZR(JINFO + 2) = NMIN
      ZR(JINFO + 3) = GAMMA0
      ZR(JINFO + 4) = GAMMA1
      ZR(JINFO + 5) = PRECAR
      ZR(JINFO + 6) = IMAX
      ZR(JINFO + 7) = NLIMA      
      ZR(JINFO + 8) = NCELL                  
C
C --- QUELQUES INITIALISATIONS ELEMENTAIRES
C
      DO 10 IMA = 1, NMA
        ZI(JLIMA+IMA-1) = IMA
 10   CONTINUE
      ZI(JCELL)   = -NMA
      ZI(JCELL+1) = 1
      ZI(JCELL+2) = NLIMA      
C
      CALL JEDEMA()
      END
