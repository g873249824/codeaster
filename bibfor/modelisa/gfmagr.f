      SUBROUTINE GFMAGR(NOMA,NOMGRF,NBFIGR)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/12/2011   AUTEUR PELLET J.PELLET 
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
C
C     ------------------------------------------------------------------
C
      IMPLICIT NONE
C     IN
      INTEGER         NBFIGR
      CHARACTER*8     NOMA,NOMGRF
C
C     ------------------------------------------------------------------
C     CREATION D'UN GROUPE DE MAILLES QUI CONTIENDRA LES MAILLES D'UN
C     GROUPE DE FIBRES (MOT CLE SECTION ET FIBRE)
C     (DEFI_GEOM_FIBRE)
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C ----- DECLARATIONS
C
      CHARACTER*24    GRPMAI
      CHARACTER*32    JEXNOM

      CALL JEMARQ ( )

      GRPMAI  = NOMA// '.GROUPEMA       '

      CALL JECROC(JEXNOM(GRPMAI,NOMGRF))
      CALL JEECRA(JEXNOM(GRPMAI,NOMGRF),'LONMAX',NBFIGR,' ')
      CALL JEECRA(JEXNOM(GRPMAI,NOMGRF),'LONUTI',NBFIGR,' ')


      CALL JEDEMA ( )
      END
