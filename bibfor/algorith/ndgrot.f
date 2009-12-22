      SUBROUTINE NDGROT(SDDYNA,VALINC,SOLALG,DELDET,THETA1,
     &                  THETA2,IRAN  )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      REAL*8        THETA2(3),THETA1(3),DELDET(3)     
      CHARACTER*19  SDDYNA
      CHARACTER*19  SOLALG(*),VALINC(*)
      INTEGER       IRAN(3)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - UTILITAIRE - DYNAMIQUE)
C
C MISE A JOUR DES VITESSES/ACCELERATIONS EN GRANDES ROTATIONS
C POUR POU_D_GD
C      
C ----------------------------------------------------------------------
C 
C
C IN  SDDYNA : SD DYNAMIQUE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  THETA2 : VALEUR DE LA ROTATION PRECEDENTE
C IN  DELDET : INCREMENT DE ROTATION 
C IN  IRAN   : NUMEROS ABSOLUS D'EQUATION DES DDL DE ROTATION DANS LES
C                 CHAM_NO
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      CHARACTER*19 DEPMOI,DEPPLU,VITPLU,ACCPLU
      INTEGER      JDEPM,JDEPP,JVITP,JACCP
      CHARACTER*19 DEPKM1,VITKM1,ACCKM1,ROMK,ROMKM1
      INTEGER      JDEPKM,JVITKM,JACCKM,JROMK,JROMKM
      INTEGER      IC
      REAL*8       QUAPRO(4),QUAROT(4),DELQUA(4)
      REAL*8       QIM(3),QIKM1(3),QIK(3),OMKM1(3),OMPKM1(3),DELROT(3)
      REAL*8       VECT1(3),VECT2(3),VECT3(3),VECT4(3),ROTM(3,3)
      REAL*8       ROTKM(3,3),ROTK(3,3),ROTMT(3,3),ROTKMT(3,3)
      REAL*8       NDYNRE,COEVIT,COEACC
      CHARACTER*19 DEPDEL
      INTEGER      JDEPDE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()             
C
C --- COEFFICIENTS
C  
      COEVIT = NDYNRE(SDDYNA,'COEF_VITE') 
      COEACC = NDYNRE(SDDYNA,'COEF_ACCE') 
C
C --- DECOMPACTION VARIABLES CHAPEAUX
C
      CALL NMCHEX(VALINC,'VALINC','DEPMOI',DEPMOI)
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU)
      CALL NMCHEX(VALINC,'VALINC','VITPLU',VITPLU)
      CALL NMCHEX(VALINC,'VALINC','ACCPLU',ACCPLU)
      CALL NMCHEX(VALINC,'VALINC','DEPKM1',DEPKM1)
      CALL NMCHEX(VALINC,'VALINC','VITKM1',VITKM1)
      CALL NMCHEX(VALINC,'VALINC','ACCKM1',ACCKM1)      
      CALL NMCHEX(VALINC,'VALINC','ROMKM1',ROMKM1)      
      CALL NMCHEX(VALINC,'VALINC','ROMK  ',ROMK  )      
      CALL NMCHEX(SOLALG,'SOLALG','DEPDEL',DEPDEL)      
C
C --- RECUPERATION DES ADRESSES
C    
      CALL JEVEUO(DEPMOI(1:19)//'.VALE','L',JDEPM )
      CALL JEVEUO(DEPPLU(1:19)//'.VALE','E',JDEPP )
      CALL JEVEUO(DEPDEL(1:19)//'.VALE','E',JDEPDE)      
      CALL JEVEUO(VITPLU(1:19)//'.VALE','E',JVITP )
      CALL JEVEUO(ACCPLU(1:19)//'.VALE','E',JACCP )
      CALL JEVEUO(DEPKM1(1:19)//'.VALE','L',JDEPKM)
      CALL JEVEUO(VITKM1(1:19)//'.VALE','L',JVITKM)
      CALL JEVEUO(ACCKM1(1:19)//'.VALE','L',JACCKM)
      CALL JEVEUO(ROMKM1(1:19)//'.VALE','L',JROMKM)
      CALL JEVEUO(ROMK(1:19)  //'.VALE','E',JROMK )
C
C --- QUATERNION DE L'INCREMENT DE ROTATION
C      
      CALL VROQUA(DELDET,DELQUA)                    
C
C --- QUATERNION DE LA ROTATION PRECEDENTE
C
      CALL VROQUA(THETA1,QUAROT)
C
C --- CALCUL DE LA NOUVELLE ROTATION
C      
      CALL PROQUA(DELQUA,QUAROT,QUAPRO)
      CALL QUAVRO(QUAPRO,THETA1)
C
C --- MISE A JOUR DES DEPLACEMENTS
C     
      DO 14 IC=1,3
         ZR(JDEPP+IRAN(IC) -1) = THETA1(IC)
         ZR(JDEPDE+IRAN(IC)-1) = THETA1(IC)
14    CONTINUE    
C
C --- QUATERNION DE LA ROTATION PRECEDENTE
C
      CALL VROQUA(THETA2,QUAROT)
C
C --- CALCUL DE LA NOUVELLE ROTATION
C      
      CALL PROQUA(DELQUA,QUAROT,QUAPRO)
      CALL QUAVRO(QUAPRO,THETA2)  
C
C --- MISE A JOUR DE LA ROTATION
C        
      DO 15 IC = 1,3
        ZR(JROMK+IRAN(IC) -1) = THETA2(IC)
15    CONTINUE
C
C --- CALCUL DES INCREMENTS DE ROTATION
C
      DO 16 IC=1,3
        QIM   (IC) = ZR(JDEPM+IRAN(IC) -1)
        QIKM1 (IC) = ZR(JDEPKM+IRAN(IC)-1)
        QIK   (IC) = ZR(JDEPP+IRAN(IC) -1)
        OMKM1 (IC) = ZR(JVITKM+IRAN(IC)-1)
        OMPKM1(IC) = ZR(JACCKM+IRAN(IC)-1)
16    CONTINUE
C
C --- CALCUL DE L'INCREMENT DE ROTATION TOTALE
C
      DO 17 IC=1,3
        DELROT(IC) = ZR(JROMK+IRAN(IC) -1) -
     &               ZR(JROMKM+IRAN(IC)-1)
17    CONTINUE
C
C --- CALCUL DES MATRICES DE ROTATION
C
      CALL MAROTA(QIM   ,ROTM  )
      CALL MAROTA(QIKM1 ,ROTKM )
      CALL MAROTA(QIK   ,ROTK  )
      CALL TRANSP(ROTM  ,3,3,3,ROTMT ,3)
      CALL TRANSP(ROTKM ,3,3,3,ROTKMT,3)
C
C --- CALCUL DE LA VITESSE ANGULAIRE 
C
      CALL PROMAT(ROTMT ,3,3,3,DELROT,3,3,1,   VECT3 )
      CALL PROMAT(ROTK  ,3,3,3,VECT3 ,3,3,1,   VECT2 )
      CALL PROMAT(ROTKMT,3,3,3,OMKM1 ,3,3,1,   VECT3 )
      CALL PROMAT(ROTK  ,3,3,3,VECT3 ,3,3,1,   VECT1 )
      DO 18 IC=1,3
        ZR(JVITP+IRAN(IC)-1) = VECT1(IC) + COEVIT*VECT2(IC)
18    CONTINUE
C
C --- CALCUL DE L'ACCELERATION ANGULAIRE 
C
      CALL PROMAT(ROTKMT,3,3,3,OMPKM1,3,3,1,   VECT4 )
      CALL PROMAT(ROTK  ,3,3,3,VECT4 ,3,3,1,   VECT3 )
      DO 19 IC=1,3
        ZR(JACCP+IRAN(IC)-1) = VECT3(IC) + COEACC*VECT2(IC)
19    CONTINUE    
C            
      CALL JEDEMA()
      END
