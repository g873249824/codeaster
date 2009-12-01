      SUBROUTINE DRZROT(LISNOZ,NBNO,CHARGZ,TYPLAZ,LISREZ,IOCC,NDIMMO)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 02/10/2007   AUTEUR PELLET J.PELLET 
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
      CHARACTER*(*) CHARGZ,LISNOZ,TYPLAZ,LISREZ
      INTEGER NBNO,IOCC,NDIMMO
      CHARACTER*8 CHARGE
      CHARACTER*19 LISREL
      CHARACTER*24 LISNOE
C -------------------------------------------------------
C     LIAISON_SOLIDE +  ANGL_NAUT + TRAN
C -------------------------------------------------------
C  LISNOE        - IN    - K24 - : NOM DE LA LISTE DES NOEUDS
C -------------------------------------------------------
C  NBNO        - IN    - I   - :  NOMBRE DE NOEUDS
C -------------------------------------------------------
C  CHARGE        - IN    - K8  - : NOM DE LA SD CHARGE
C -------------------------------------------------------
C TYPLAG         - IN    - K2  - : TYPE DES MULTIPLICATEURS DE LAGRANGE
C -------------------------------------------------------
C  LISREL        - IN    - K19 - : NOM DE LA SD
C                - JXVAR -     -   LISTE DE RELATIONS
C -------------------------------------------------------
C  IOCC        - IN    - I - : NUMERO D'OCCURRENCE DE LIAISON_SOLIDE
C -------------------------------------------------------
C  NDIMMO      - IN    - I - : 2/3 : DIMENSION DU MODELE
C -------------------------------------------------------

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ------

C --------- VARIABLES LOCALES ---------------------------
      CHARACTER*2 TYPLAG
      CHARACTER*8 RESU
      CHARACTER*8 MOD,NOMG,NOMNOE,KBID
      CHARACTER*8 NOMA,CMP,NOMCMP(6)
      CHARACTER*9 NOMTE
      CHARACTER*16 TYPE,OPER
      CHARACTER*19 LIGRMO
      CHARACTER*24 GEOM2,LINUNO
      LOGICAL EXISDG,LROTA
      REAL*8 BETA,RBID,MROTA(3,3)
      COMPLEX*16 CBID
      INTEGER JNOMA,KCMP,INDIK8,INO,ILISNO,I,IBID,JCOOR,JPRNM
      INTEGER INOM,IER,NBCMP,ICMP,NBEC,JNUNO,JGEOM2
C --------- FIN  DECLARATIONS  VARIABLES LOCALES --------

      CALL JEMARQ()
      CALL GETRES(RESU,TYPE,OPER)
      LISREL = LISREZ
      CHARGE = CHARGZ
      TYPLAG = TYPLAZ
      LISNOE = LISNOZ

      NOMCMP(1)='DX'
      NOMCMP(2)='DY'
      NOMCMP(3)='DZ'


      CALL DISMOI('F','NOM_MODELE',CHARGE(1:8),'CHARGE',IBID,MOD,IER)
      LIGRMO = MOD(1:8)//'.MODELE'
      CALL JEVEUO(LIGRMO//'.LGRF','L',JNOMA)
      NOMA = ZK8(JNOMA)

      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP','DEPL_R'),'L',INOM)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP','DEPL_R'),'LONMAX',
     &            NBCMP,KBID)
      CALL DISMOI('F','NB_EC','DEPL_R','GRANDEUR',NBEC,KBID,IER)

      CALL JEVEUO(LIGRMO//'.PRNM','L',JPRNM)
      CALL JEVEUO(NOMA//'.COORDO    .VALE','L',JCOOR)
      CALL JEVEUO(LISNOE,'L',ILISNO)


C     TRANSFORMATION DE LA GEOMETRIE DES NOEUDS :
C     ------------------------------------------
      GEOM2 = '&&DRZROT.GEOM_TRANSF'
      LINUNO = '&&DRZROT.LINUNO'
      CALL WKVECT(LINUNO,'V V I',NBNO,JNUNO)
      DO 12,I=1,NBNO
        NOMNOE=ZK8(ILISNO+I-1)
        CALL JENONU(JEXNOM(NOMA//'.NOMNOE',NOMNOE),INO)
        ZI(JNUNO-1+I)=INO
  12  CONTINUE
      CALL CALIRG('LIAISON_SOLIDE',IOCC,NDIMMO,NOMA,LINUNO,
     &              GEOM2,MROTA,LROTA)
      CALL JEVEUO(GEOM2,'L',JGEOM2)


C     -- BOUCLE SUR LES NOEUDS :
C     ------------------------------
      DO 40,I=1,NBNO
        NOMNOE=ZK8(ILISNO+I-1)
        INO=ZI(JNUNO-1+I)

C       -- BOUCLE SUR LES 3 CMPS : DX, DY, DZ
        DO 41 , KCMP=1,3
           CMP= NOMCMP(KCMP)
           ICMP = INDIK8(ZK8(INOM),CMP,1,NBCMP)
           CALL ASSERT(ICMP.GT.0)
           IF (EXISDG(ZI(JPRNM-1+ (INO-1)*NBEC+1),ICMP)) THEN

             BETA= ZR(JGEOM2-1+3*(INO-1)+KCMP)
     &            -ZR(JCOOR -1+3*(INO-1)+KCMP)
             CALL AFRELA(1.D0,CBID,CMP,NOMNOE,
     &                   0,RBID,1,BETA,CBID,' ',
     &                   'REEL','REEL',TYPLAG,0.D0,LISREL)
           END IF
   41 CONTINUE
   40 CONTINUE

      CALL JEDETR(GEOM2)
      CALL JEDETR(LINUNO)
      CALL JEDEMA()
      END
