      SUBROUTINE ARLBBS(DIME  ,NOMA  ,NOMB  ,BC    ,LCARA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*10 NOMA,NOMB
      INTEGER      DIME
      REAL*8       BC(2,3),LCARA
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C CALCUL DE LA BOITE DE SUPERPOSITION
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DE LA SD POUR STOCKAGE MAILLES GROUP_MA_1
C IN  NOMB   : NOM DE LA SD POUR STOCKAGE MAILLES GROUP_MA_2
C IN  DIME   : DIMENSION DE L'ESPACE GLOBAL
C OUT BC     : BOITE ENGLOBANT LA ZONE DE RECOUVREMENT
C OUT LCARA  : LONGUEUR CARACTERISTIQUE POUR TERME DE COUPLAGE
C
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
      INTEGER      JBOITA,JBOITB
      INTEGER      IDIME
      INTEGER      IFM,NIV 
      REAL*8       RMIN,RMAX 
      CHARACTER*16 NOMBOA,NOMBOB               
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)  
C      
C ----------------------------------------------------------------------
C          
      NOMBOA = NOMA(1:10)//'.BOITE'
      NOMBOB = NOMB(1:10)//'.BOITE'                  
C
C --- CALCUL BOITE DE LA ZONE DE SUPERPOSITION (BS)
C 
      IF (NIV.GE.2) THEN
        WRITE(IFM,*) '<ARLEQUIN> CALCUL BOITE DE SUPERPOSITION...'
      ENDIF
      LCARA = 1.D0
      CALL JEVEUO(NOMBOA(1:16)//'.MMGLOB','L',JBOITA)
      CALL JEVEUO(NOMBOB(1:16)//'.MMGLOB','L',JBOITB)
            
      DO 40 IDIME = 1, DIME
        RMIN = MAX(ZR(JBOITA),ZR(JBOITB))
        JBOITA = JBOITA + 1
        JBOITB = JBOITB + 1
        RMAX = MIN(ZR(JBOITA),ZR(JBOITB))
        JBOITA = JBOITA + 1
        JBOITB = JBOITB + 1
        IF (RMIN.GE.RMAX) THEN
          CALL U2MESS('F','ARLEQUIN_9')
        ENDIF
        BC(1,IDIME) = RMIN         
        BC(2,IDIME) = RMAX
        LCARA = LCARA * (RMAX-RMIN)
 40   CONTINUE
C
      IF (LCARA.LT.0.D0) THEN
        CALL ASSERT(.FALSE.)
      ENDIF 
C
      IF (DIME.EQ.2) THEN
        LCARA = 0.5D0*LCARA
      ELSEIF (DIME.EQ.3) THEN
        LCARA = 0.5D0*(LCARA**(2.D0/3.D0))
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C 
      IF (NIV.GE.2) THEN         
        WRITE(IFM,*) '<ARLEQUIN> ... X = (',BC(1,1),',',
     &                                      BC(2,1),')'
        WRITE(IFM,*) '<ARLEQUIN> ... Y = (',BC(1,2),',',
     &                                      BC(2,2),')'
        IF (DIME.EQ.3) THEN
          WRITE(IFM,*) '<ARLEQUIN> ... Z = (',BC(1,3),',',
     &                                        BC(2,3),')'        
        ENDIF   
        WRITE(IFM,*) '<ARLEQUIN> LONGUEUR CARACTERISTIQUE POUR '//
     &               'TERME DE COUPLAGE:',LCARA     
      ENDIF  
C
      CALL JEDEMA()
      END
