      SUBROUTINE GFMAFI(NOMA,NUMAGL,CENTRE,NUNOEU,NOMGRF,NUMAGR)
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
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C     IN
      INTEGER         NUNOEU,NUMAGL,NUMAGR
      CHARACTER*8     NOMA,NOMGRF
      REAL*8          CENTRE(2)

C     NOMA   : NOM DU MAILLAGE GLOBAL DE LA SD G_FIBRE
C     NUMAGL : NUMERO DE MAILLE DANS LE MAILLAGE GLOBAL
C     CENTRE : COORDONNEES DU CENTRE DE LA FIBRE
C     NUNOEU : NUMERO DU NOEUD DANS LE MAILLAGE GLOBAL
C     NOMGRF : NOM DU GROUPE DE FIBRES/MAILLES
C     NUMAGR : NUMERO DE LA MAILLE DANS LE GROUPE DE FIBRES/MAILLES
C
C     ------------------------------------------------------------------
C     REMPLISSAGE DES ATTRIBUTS DE MAILLAGE POUR LES GROUPES DE FIBRES
C     ISSUS DU MOT CLE FIBRE (.NOMMAI ,.TYPMAIL,COORDO.VALE,CONNEX)
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
C     ----- DECLARATIONS
C
      INTEGER         I,ICOVAL,IADT,JCONNX,JGG
      CHARACTER*8     KNMA,KNNOEU
      CHARACTER*24    NOMMAI,COOVAL,GRPMAI,CONNEX,TYPMAI
      CHARACTER*32    JEXNOM,JEXNUM

      CALL JEMARQ ( )

C
C     CONSTRUCTION DES NOMS JEVEUX POUR L OBJET-MAILLAGE
C     --------------------------------------------------

C               123456789012345678901234
      NOMMAI  = NOMA// '.NOMMAI         '
      COOVAL  = NOMA// '.COORDO    .VALE'
      GRPMAI  = NOMA// '.GROUPEMA       '
      CONNEX  = NOMA// '.CONNEX         '
      TYPMAI  = NOMA// '.TYPMAIL        '

C
C - RECUPERATION DES ADRESSES DES CHAMPS
C
      CALL JEVEUO(TYPMAI,'E',IADT)
C
C -   REMPLISSAGE DES OBJETS .NOMMAI ET .TYPMAI
C
      ZI(IADT-1+NUMAGL) = 1
      KNMA='M0000000'
      WRITE(KNMA(2:8),'(I7.7)')NUMAGL
      CALL JECROC(JEXNOM(NOMMAI,KNMA))
C
C - STOCKAGE DES NUMERO DES NOEUDS DE LA MAILLE
C
      CALL JEECRA(JEXNUM(CONNEX,NUMAGL),'LONMAX',1,' ')
      CALL JEVEUO(JEXNUM(CONNEX,NUMAGL),'E',JCONNX)
      ZI(JCONNX) = NUNOEU
C
C --- REMPLISSAGE DE L'OBJET .COORDO    .VALE :
C     -------------------------
      CALL JEVEUO(COOVAL,'E',ICOVAL)

      ZR(ICOVAL+(NUNOEU-1)*3-1+1)=CENTRE(1)
      ZR(ICOVAL+(NUNOEU-1)*3-1+2)=CENTRE(2)

C
C --- AJOUT DE LA MAILLE DANS SON GROUPE DE MAILLE
C
      CALL JEVEUO(JEXNOM(GRPMAI,NOMGRF),'E',JGG)
      ZI(JGG+NUMAGR-1) = NUMAGL

      CALL JEDEMA ( )
      END
