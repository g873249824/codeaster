      SUBROUTINE NMFLAL(COMPOR,METHOD,OPTFLA,MOD45 ,DEFO  ,
     &                  NFREQ ,TYPMAT,OPTMOD,BANDE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/12/2009   AUTEUR PROIX J-M.PROIX 
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
      CHARACTER*24 COMPOR
      CHARACTER*8  OPTFLA
      CHARACTER*16 OPTMOD
      CHARACTER*16 METHOD(*)
      CHARACTER*4  MOD45
      INTEGER      NFREQ,DEFO      
      CHARACTER*16 TYPMAT
      REAL*8       BANDE(2)
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL DE MODES)
C
C LECTURE DES OPTIONS DANS MECA_NON_LINE
C      
C ----------------------------------------------------------------------
C      
C
C IN  OPTFLA : TYPE DE CALCUL
C              'FLAMBSTA' MODES DE FLAMBEMENT EN STATIQUE
C              'FLAMBDYN' MODES DE FLAMBEMENT EN DYNAMIQUE
C              'VIBRDYNA' MODES VIBRATOIRES
C IN  COMPOR : CARTE COMPORTEMENT
C IN  METHOD : INFORMATIONS SUR LES METHODES DE RESOLUTION
C OUT MOD45  : TYPE DE CALCUL DE MODES PROPRES
C              'VIBR'     MODES VIBRATOIRES
C              'FLAM'     MODES DE FLAMBEMENT  
C OUT NFREQ  : NOMBRE DE FREQUENCES A CALCULER
C OUT TYPMAT : TYPE DE MATRICE A UTILISER 
C                'ELASTIQUE/TANGENTE/SECANTE'
C OUT OPTMOD : OPTION DE RECHERCHE DE MODES
C               'PLUS_PETITE' LA PLUS PETITE FREQUENCE
C               'BANDE'       DANS UNE BANDE DE FREQUENCE DONNEE
C OUT DEFO   : TYPE DE DEFORMATIONS
C                0            PETITES DEFORMATIONS (MATR. GEOM.)
C                1            GRANDES DEFORMATIONS (PAS DE MATR. GEOM.)
C OUT BANDE  : BANDE DE FREQUENCES SI OPTMOD='BANDE'
C 
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
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
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      IRET,NBV,I
      REAL*8       R8BID,OMEGA2
      INTEGER      INIT,IDES
      CHARACTER*8  MRIG     
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      BANDE(1) = 1.D-5
      BANDE(2) = 1.D5
      DEFO   = 0
      MOD45  = ' '
      MRIG   = ' '
      OPTMOD = 'PLUS_PETITE'
C
C --- TYPE DE DEFORMATIONS
C
      CALL JEVEUO(COMPOR(1:19)//'.VALE','L',INIT)
      CALL JEVEUO(COMPOR(1:19)//'.DESC','L',IDES)
      NBV    = ZI(IDES-1+3)
C     RIGIDITE GEOMETRIQUE INTEGREE A LA MATRICE TANGENTE      
      DO 10 I = 1,NBV
        IF ((ZK16(INIT+2+20*(I-1)).EQ.'GROT_GDEP').OR.
     &      (ZK16(INIT+2+20*(I-1)).EQ.'GDEF_HYPO_ELAS').OR.
     &      (ZK16(INIT+2+20*(I-1)).EQ.'SIMO_MIEHE')) THEN
          DEFO = 1
        END IF
   10 CONTINUE      
C  
C --- RECUPERATION DES OPTIONS
C         
      IF ( OPTFLA(1:7) .EQ. 'VIBRDYN' ) THEN
        CALL GETVIS('MODE_VIBR','NB_FREQ'  ,1,1,1,NFREQ ,IRET)
        CALL GETVTX('MODE_VIBR','MATR_RIGI',1,1,1,MRIG  ,IRET)
        MOD45    = 'VIBR'
        IF ( MRIG(1:4) .EQ. 'ELAS' ) THEN
          TYPMAT = 'ELASTIQUE'
        ELSE IF ( MRIG(1:4) .EQ. 'TANG' ) THEN
          TYPMAT = 'TANGENTE'
        ELSE IF ( MRIG(1:4) .EQ. 'SECA' ) THEN
          TYPMAT = 'SECANTE'
        ELSE
          CALL ASSERT(.FALSE.)  
        ENDIF
        OPTMOD = 'PLUS_PETITE'
        CALL GETVR8('MODE_VIBR','BANDE',1,1,2,BANDE ,IRET)
        IF ( IRET.NE.0 ) OPTMOD = 'BANDE'
        R8BID = OMEGA2(BANDE(1))
        BANDE(1) = R8BID
        R8BID = OMEGA2(BANDE(2))
        BANDE(2) = R8BID        
      ELSEIF ( OPTFLA(1:5) .EQ. 'FLAMB' ) THEN
        CALL GETVIS('CRIT_FLAMB','NB_FREQ'  ,1,1,1,NFREQ ,IRET)
        CALL GETVR8('CRIT_FLAMB','CHAR_CRIT',1,1,2,BANDE ,IRET)
        MOD45  = 'FLAM'
        MRIG   = '    '
        IF (DEFO.EQ.0) THEN
          OPTMOD = 'BANDE'
        ELSEIF (DEFO.EQ.1) THEN
          OPTMOD = 'PLUS_PETITE'
        ELSE
          CALL ASSERT(.FALSE.)  
        ENDIF
        TYPMAT = METHOD(5)
      ELSE
        CALL ASSERT(.FALSE.)  
      ENDIF
C         
     
      CALL JEDEMA()
      END
