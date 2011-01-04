      SUBROUTINE APCPOI(SDAPPA,NDIMG ,IZONE ,NOMMAI,TYPZON,
     &                  TAU1  ,TAU2  )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/01/2011   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*19  SDAPPA      
      CHARACTER*8   NOMMAI
      CHARACTER*4   TYPZON
      INTEGER       IZONE,NDIMG
      REAL*8        TAU1(3),TAU2(3)
C      
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT (UTILITAIRE)
C
C ORIENTATION DES TANGENTES DANS LE CAS DES MAILLES POINT
C      
C ----------------------------------------------------------------------
C
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C IN  NDIMG  : DIMENSION DE L'ESPACE
C IN  IZONE  : NUMERO DE LA ZONE
C IN  NOMMAI : NOM DE LA MAILLE
C IN  TYPZON : TYPE DE LA MAILLE 'MAIT' OU 'ESCL'
C OUT TAU1   : PREMIERE TANGENTE (NON NORMALISEE)
C OUT TAU2   : SECONDE TANGENTE (NON NORMALISEE)
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
      INTEGER      ITYPE
      REAL*8       NORMAL(3),NORME,R8PREM
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ() 
C
C --- MAILLE POI1 SEULEMENT ESCLAVE
C
      IF (TYPZON.EQ.'MAIT') THEN
        CALL U2MESS('F','APPARIEMENT_75')
      ENDIF
C
C --- CHOIX DE LA NORMALE SUIVANT UTILISATEUR
C
      CALL APZONI(SDAPPA,IZONE ,'TYPE_NORM_ESCL',ITYPE )
      IF (ITYPE.NE.0) THEN
        CALL APZONV(SDAPPA,IZONE ,'VECT_ESCL',NORMAL)
        CALL NORMEV(NORMAL,NORME  )
      ENDIF      
C
C --- CONSTRUCTION BASE TANGENTE NULLE
C
      IF (ITYPE.EQ.0) THEN
        CALL U2MESK('F','APPARIEMENT_62',1,NOMMAI)
      ELSEIF (ITYPE.EQ.1) THEN
        IF (NORME.LE.R8PREM()) THEN
          CALL U2MESK('F','APPARIEMENT_63',1,NOMMAI)
        ELSE
         NORMAL(1) = -NORMAL(1)
         NORMAL(2) = -NORMAL(2)
         NORMAL(3) = -NORMAL(3)
         CALL MMMRON(NDIMG ,NORMAL,TAU1  ,TAU2  )
        ENDIF
      ELSEIF (ITYPE.EQ.2) THEN
        CALL U2MESK('F','APPARIEMENT_62',1,NOMMAI)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF     
C
      CALL JEDEMA()
      END
