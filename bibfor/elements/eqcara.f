      SUBROUTINE EQCARA(NOMTE,TYPMOD,NDIM,NCEQ,NCMP,NBVA)
      IMPLICIT NONE
      CHARACTER*(*) NOMTE
      CHARACTER*6   TYPMOD
      INTEGER       NDIM, NCEQ ,NCMP, NBVA
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/12/2010   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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

C BUT :  RETOURNE EN FONCTION DU TYPE D'ELEMENT
C        LES CARACTERISTIQUES SUIVANTES:
C
C ----------------------------------------------------------------------
C   IN   NOMTE   : NOM DE L'ELEMENT
C   OUT  TYPEMOD : TYPE DE MODELELISATION
C        NDIM    : DIMENSION ESPACE 3 OU 2
C        NCEQ    : NOMBRE DE CONTRAINTES EQUIVALENTES
C        NCMP    : NOMBRE DE COMPOSANTES
C        NBVA    : NOMBRE DE VALEURS 
C   -------------------------------------------------------------------
C
C
       INTEGER ITAB(3),IRET

C--- ELEMENTS 2D MECA
       INTEGER       NBEL2D
       PARAMETER    (NBEL2D=56)
       CHARACTER*16  ELEM2D(NBEL2D)
C
C--- ELEMENTS FOURIER MECA
       INTEGER       NBELFO
       PARAMETER    (NBELFO=5)
       CHARACTER*16  ELEMFO(NBELFO)
C
C--- ELEMENTS 3D MECA
       INTEGER       NBEL3D
       PARAMETER    (NBEL3D=35)
       CHARACTER*16  ELEM3D(NBEL3D)
C
C--- ELEMENTS COQUE MECA
       INTEGER       NBELCQ
       PARAMETER    (NBELCQ=7)
       CHARACTER*16  ELEMCQ(NBELCQ)
C
C--- ELEMENTS THM

       INTEGER       NBDTHM
       PARAMETER    (NBDTHM=38)
       CHARACTER*16  ELDTHM(NBDTHM)
C
       INTEGER       NBATHM
       PARAMETER    (NBATHM=32)
       CHARACTER*16  ELATHM(NBATHM)
C
       INTEGER       NB3THM
       PARAMETER    (NB3THM=48)
       CHARACTER*16  EL3THM(NB3THM)
C
       INTEGER       I
C
       LOGICAL       LELE2D,LELEFO,LELE3D,LELECQ
       LOGICAL       LEDTHM,LEATHM,LE3THM
C
       LOGICAL       LTEATT
C       
       DATA ELEM2D /
     &     'MGDPTR3',  'MGCPTR3',  'MGDPQU8',  'MGCPQU8',  'MGDPTR6',
     &     'MGSPQU8',  'MGSPTR6',  
     &     'MGCPTR6',  'MEAXQU4',  'MDAXQU4',  'MEAXQU8',  'MEAXQU9',
     &     'MEAXTR3',  'MEAXTR6',  'MEAXQS8',  'DUMMY_1',  'MECPQS8',  
     &     'MECPQU4',  'MECPQU8',  'MECPQU9',  'MECPTR6',  'MECPTR6_X',
     &     'MECPQU8_X','DUMMY_2',  'MEDPQU4',  'MDDPQU4',  'MEDPTR3',  
     &     'MEDPTR6',  'MEDPQU8',  'MEDPQU9',  'MEDPTR6_X','MEDPQU8_X',
     &     'MVCPTR6',  'MVCPQS8',  'MVDPTR6',  'MVDPQS8',  'MVAXTR6',  
     &     'MVAXQS8',  'MECPQS4',  'MECPTR3',  'MEDPQS4',  'MEDPQS8',
     &     'MIAXQU8',  'MIAXTR6',  'MIPLQU8',  'MIPLTR6',  'GIAXTR6',
     &     'GIAXQU8',  'GIPLTR6',  'GIPLQU8',  'MIAXUPQU8','MIPLUPQU8',
     &     'MIPLUPTR6','MIPLUPTR3','MIAXUPTR3','MIAXUPTR6'/
     
       DATA ELEMFO /
     & 'MEFOQU4' ,  'MEFOQU8' ,'MEFOQU9'  , 'MEFOTR3',   'MEFOTR6'/
     
       DATA ELEM3D /
     & 'MECA_HEXA20' ,  'MECA_HEXA27' ,'MECA_HEXA8'  , 'MECA_HEXS20',
     & 'MECA_PENTA15',  'MECA_PENTA6' ,'MECA_PYRAM13', 'MECA_PYRAM5', 
     & 'MECA_TETRA10',  'MECA_TETRA4' ,'MECA_X_HEXA20','MECA_X_PENTA15',
     & 'MECA_X_TETRA10','MGCA_TETRA4' ,'MGCA_HEXA20',  'MGCA_TETRA10',
     & 'MGCA_PENTA15',  'MGCA_PYRAM13','GDIN_HEXA20',  'GDIN_TETRA10',
     & 'MVCA_HEXS20',   'MVCA_PENTA15','MVCA_TETRA10', 'MECA_HEXS8',
     & 'MINC_HEXA20',   'MINC_TETRA10','MINC_PENTA15', 'MECA_SHB8',
     & 'MECA_PENTA18',  'MECA_TETRS10','MINCUP_HEXA20','MINCUP_TETRA10',
     & 'MINCUP_TETRA4', 'MINCUP_PENTA15','MINC_TETRA4'/

       DATA ELEMCQ /
     &      'MEC3QU9H', 'MEC3TR7H', 'MEDKQU4', 'MEDKTR3', 'MEDSQU4',
     &      'MEDSTR3',  'MEQ4QU4'/

       
C --- MODELISATION THM EN D_PLAN
       DATA ELDTHM /
     &  'HH2M_DPQ8D', 'HH2M_DPTR6D', 'HH2M_DPQ8S', 'HH2M_DPTR6S',
     &  'HHM_DPQ8',   'HHM_DPTR6',   'HHM_DPQ8D',  'HHM_DPTR6D',
     &  'HHM_DPQ8S',  'HHM_DPTR6S',  'HM_DPQ8',    'HM_DPTR6',
     &  'HM_DPQ8D',   'HM_DPTR6D',   'HM_DPQ8S',   'HM_DPTR6S',
     &  'HM_DPQ8',    'HM_DPTR6',    'HM_DPQ8D',   'HM_DPTR6D',
     &  'HM_DPQ8S',   'HM_DPTR6S',   'THH2M_DPQ8D','THH2M_DPTR6D',
     &  'THH2M_DPQ8S','THH2M_DPTR6S','THHM_DPQ8',  'THHM_DPTR6',
     &  'THHM_DPQ8D', 'THHM_DPTR6D', 'THHM_DPQ8S', 'THHM_DPTR6S',
     &  'THM_DPQ8',   'THM_DPTR6',   'THM_DPQ8D',  'THM_DPTR6D',
     &  'THM_DPQ8S',  'THM_DPTR6S'/

C --- MODELISATION THM EN AXIS
       DATA ELATHM /
     &  'HH2M_AXIS_QU8D', 'HH2M_AXIS_TR6D', 'HH2M_AXIS_QU8S',
     &  'HH2M_AXIS_TR6S', 'HHM_AXIS_QU8',   'HHM_AXIS_TR6',
     &  'HHM_AXIS_QU8D',  'HHM_AXIS_TR6D',  'HHM_AXIS_QU8S',
     &  'HHM_AXIS_TR6S',  'HM_AXIS_QU8',    'HM_AXIS_TR6',
     &  'HM_AXIS_QU8D',   'HM_AXIS_TR6D',   'HM_AXIS_QU8S',
     &  'HM_AXIS_TR6S',   'THH2M_AXIS_QU8D','THH2M_AXIS_TR6D',
     &  'THH2M_AXIS_QU8S','THH2M_AXIS_TR6S','THHM_AXIS_QU8',
     &  'THHM_AXIS_TR6',  'THHM_AXIS_QU8D', 'THHM_AXIS_TR6D',
     &  'THHM_AXIS_QU8S', 'THHM_AXIS_TR6S', 'THM_AXIS_QU8',
     &  'THM_AXIS_TR6',   'THM_AXIS_QU8D',  'THM_AXIS_TR6D',
     &  'THM_AXIS_QU8S','THM_AXIS_TR6S'/

C --- MODELISATION THM EN 3D
       DATA EL3THM /
     &   'HH2M_TETRA10D', 'HH2M_PENTA15D', 'HH2M_HEXA20D',
     &   'HH2M_TETRA10S', 'HH2M_PENTA15S', 'HH2M_HEXA20S',
     &   'HHM_TETRA10',   'HHM_PENTA15',   'HHM_HEXA20',
     &   'HHM_TETRA10D',  'HHM_PENTA15D',  'HHM_HEXA20D',
     &   'HHM_TETRA10S',  'HHM_PENTA15S',  'HHM_HEXA20S',
     &   'HM_TETRA10',    'HM_PENTA15',    'HM_HEXA20',
     &   'HM_TETRA10D',   'HM_PENTA15D',   'HM_HEXA20D',
     &   'HM_TETRA10S',   'HM_PENTA15S',   'HM_HEXA20S',
     &   'THH2M_TETRA10D','THH2M_PENTA15D','THH2M_HEXA20D',
     &   'THH2M_TETRA10S','THH2M_PENTA15S','THH2M_HEXA20S',
     &   'THHM_HEXA20',   'THHM_TETRA10',  'THHM_PENTA15',
     &   'THHM_HEXA20D',  'THHM_TETRA10D', 'THHM_PENTA15D',
     &   'THHM_HEXA20S',  'THHM_TETRA10S', 'THHM_PENTA15S',
     &   'THM_TETRA10',   'THM_PENTA15',   'THM_HEXA20',
     &   'THM_TETRA10D',  'THM_PENTA15D',  'THM_HEXA20D',
     &   'THM_TETRA10S',  'THM_PENTA15S',  'THM_HEXA20S'/

C
C DEB ------------------------------------------------------------------

      LELE2D = .FALSE.
      LELEFO = .FALSE.
      LELE3D = .FALSE.
      LELECQ = .FALSE.
      LEDTHM = .FALSE.
      LEATHM = .FALSE.
      LE3THM = .FALSE.
C
C --- UTILISE POUR LES ELEMENTS THM
      CALL TECACH('NNN','PCONTRR',3,ITAB,IRET)
      IF(IRET.EQ.1) THEN
         CALL TECACH('NOO','PCONCOR',3,ITAB,IRET)
      ENDIF
      IF(ITAB(3) .NE. 0) NBVA = ITAB(2)/ITAB(3)

C
C --- RECHERCHE DU TYPE D'ELEMENT 2D(AXI), 3D ou COQUE      
      DO 10 I=1,NBEL2D
         IF(NOMTE.EQ.ELEM2D(I)) THEN
            LELE2D = .TRUE.
            GOTO 40
         ENDIF
 10   CONTINUE
C
      DO 11 I=1,NBELFO
         IF(NOMTE.EQ.ELEMFO(I)) THEN
            LELEFO = .TRUE.
            GOTO 40
      ENDIF
 11   CONTINUE
C
      DO 20 I=1,NBEL3D
         IF(NOMTE.EQ.ELEM3D(I)) THEN
            LELE3D = .TRUE.
            GOTO 40
      ENDIF
 20   CONTINUE

      DO 30 I=1,NBELCQ
         IF(NOMTE.EQ.ELEMCQ(I)) THEN
            LELECQ = .TRUE.
            GOTO 40
         ENDIF
 30   CONTINUE

C --- MODELISATION THM

      DO 50 I=1,NBDTHM
         IF(NOMTE.EQ.ELDTHM(I)) THEN
            LEDTHM = .TRUE.
            GOTO 40
         ENDIF
 50   CONTINUE

      DO 60 I=1,NBATHM
         IF(NOMTE.EQ.ELATHM(I)) THEN
            LEATHM = .TRUE.
            GOTO 40
         ENDIF
60    CONTINUE
 
      DO 70 I=1,NB3THM
         IF(NOMTE.EQ.EL3THM(I)) THEN
            LE3THM = .TRUE.
            GOTO 40
         ENDIF
70    CONTINUE
C
C --- DEFINITION DES CARACTERISTIQUES
C
 40   CONTINUE

      IF (LELE2D) THEN
         TYPMOD = '2D'
         NDIM  = 2
         NCEQ  = 16
         NCMP  = 7
         IF(LTEATT(' ','INCO','OUI')) NCEQ = 7
      ELSEIF (LELE3D) THEN
         TYPMOD = '3D'
         NDIM  = 3
         NCEQ  = 16
         NCMP  = 7
         IF(LTEATT(' ','INCO','OUI')) NCEQ = 7
         IF(NOMTE.EQ.'MECA_SHB8') NBVA = 6
      ELSEIF (LELEFO) THEN
         TYPMOD = '3D'
         NDIM  = 3
         NCEQ  = 16
         NCMP  = 7
      ELSEIF(LELECQ)THEN
         TYPMOD = 'COQUE'
         NDIM  = 3
         NCEQ  = 7
         NCMP  = 7
C	 
C --- ELEMENTS THM 
C
      ELSEIF(LEDTHM)THEN
         TYPMOD = '2D'
         NDIM  = 2
         NCEQ  = 7
         NCMP  = 7
      ELSEIF(LEATHM)THEN
         TYPMOD = '2D'
         NDIM  = 2
         NCEQ  = 7
         NCMP  = 7
      ELSEIF(LE3THM)THEN
         TYPMOD = '3D'
         NDIM  = 3
         NCEQ  = 7
         NCMP  = 7
      ELSE
         CALL U2MESS('F','MODELISA3_27')
      ENDIF
C
      END
