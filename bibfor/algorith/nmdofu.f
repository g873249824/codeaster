      SUBROUTINE NMDOFU(COMPEL,COMPOR)
C RESPONSABLE PROIX J-M.PROIX
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/09/2008   AUTEUR PROIX J-M.PROIX 
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
C  ON SURCHARGE COMPEL (ELAS PARTOUT) AVEC LA CARTE COMPOR CREEE 
C  A PARTIR DE COMP_INCR OU COMP_ELAS
C  IN      COMPEL    carte constante de comportement elastique
C  IN/OUT  COMPOR    carte de comportement
C ----------------------------------------------------------------------

      IMPLICIT NONE
      INTEGER N1,IBID
      CHARACTER*19 COMPOR,CHS(2),CHS3,COMPEL
      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='NMDOFU')
      REAL*8 LCOER(2)
      COMPLEX*16 LCOEC(2)
      LOGICAL LCUMU(2),LCOC(2)
      
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
      INTEGER        ZI
      COMMON /IVARJE/ZI(1)
      REAL*8         ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16     ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL        ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8    ZK8
      CHARACTER*16          ZK16
      CHARACTER*24                  ZK24
      CHARACTER*32                          ZK32
      CHARACTER*80                                  ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32     JEXNUM, JEXNOM
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      DATA LCUMU/.FALSE.,.FALSE./
      DATA LCOC/.FALSE.,.FALSE./
      DATA LCOER/1.D0,1.D0/
C ----------------------------------------------------------------------
      CALL JEMARQ()
C    -----------------------------------------------------------
C     ON FUSIONNE LES CARTES
C     ON RECUPERE LA CARTE ET ON EN FAIT UN CHAM_ELEM_S
      CHS(1)='&&'//NOMPRO//'.CHS1'
      CHS(2)='&&'//NOMPRO//'.CHS2'
      CHS3  ='&&'//NOMPRO//'.CHS3'
      CALL CARCES(COMPEL,'ELEM',' ','V',CHS(1),IBID)
      CALL CARCES(COMPOR,'ELEM',' ','V',CHS(2),IBID)
      CALL DETRSD('CARTE',COMPOR)
      CALL CESFUS(2,CHS,LCUMU,LCOER,LCOEC,LCOC,'V',CHS3)
      CALL CESCAR(CHS3,COMPOR,'V')
      CALL DETRSD('CHAM_ELEM_S',CHS(1))
      CALL DETRSD('CHAM_ELEM_S',CHS(2))
      CALL DETRSD('CHAM_ELEM_S',CHS3)
      CALL JEDEMA()
      END
