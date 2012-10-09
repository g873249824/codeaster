      SUBROUTINE ORILMA ( NOMA, NDIM, LISTMA, NBMAIL, NORIEN, NTRAIT,
     &                    REORIE, PREC, NBMAVO, MAILVO )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER             NDIM, LISTMA(*), NBMAIL, NORIEN, NTRAIT,
     &                    NBMAVO, MAILVO(*)
      CHARACTER*8         NOMA
      LOGICAL             REORIE
      REAL*8              PREC
C.======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/10/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ORILMA  --  LE BUT EST DE REORIENTER, SI C'EST NECESSAIRE,
C                 LES MAILLES DE PEAU D'UNE LISTE DE MAILLES
C                 LA NORMALE A LA MAILLE DE PEAU DOIT ETRE
C                 EXTERIEURE AU VOLUME.
C                 DANS LE CAS OU REORIE EST FAUX, L'ORIENTATION
C                 GEOMETRIQUE N'EST PAS UTILISEE, CECI PERMET DE
C                 TESTER UNE SURFACE POUR UNE CONDITION AUX LIMITES
C                 DE PRESSION
C
C   ARGUMENT        E/S  TYPE         ROLE
C    NOMA           IN    K8      NOM DU MAILLAGE
C    NDIM           IN    I       DIMENSION DU PROBLEME
C    LISTMA         IN    I       LISTE DES NUMEROS DE MAILLE
C                                 A REORIENTER
C    NBMAIL         IN    I       NB DE MAILLES DE LA LISTE
C    NORIEN        VAR            NOMBRE DE MAILLES REORIENTEES
C    REORIE         IN    L       INDIQUE SI L'ON DOIT APPELER ORIEMA
C    PREC           IN    R       (INUTILISE)
C    MAILVO         IN    I       SI ORIE_PEAU_3D ("GROUP_MA_VOLU")
C                                   = LISTE DES MAILLES VOLUMIQUES
C                                     UTILES A LA REORIENTATION
C                                 SI ORIE_PEAU_2D ("GROUP_MA_SURF")
C                                   = LISTE DES MAILLES SURFACIQUES
C                                     UTILES A LA REORIENTATION
C                                 SINON: MAILVO N'EST PAS UTILISE
C    NBMAVO         IN    I       NB DE MAILLES DE MAILVO
C.========================= DEBUT DES DECLARATIONS ====================
C -----  VARIABLES LOCALES
      INTEGER       IFM, NIV, IMA, NUMA, NUTYMA,
     &              NBNMAI, NUMA3D, NBNM3D, NORIEM, NORIEG
      INTEGER       JTYMA, JCOOR,  P1, P2, JNBN, JDNO,
     &              JNOM, JTYP, JM3D, JDESM, JDES3D
      LOGICAL       DIME1, DIME2
      CHARACTER*2   KDIM
      CHARACTER*8    TPMAIL, NOMAIL, TYP3D
      CHARACTER*24  MAILMA, NOMOB1
      CHARACTER*24 VALK(2)
C
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
      CALL JEMARQ ( )
      IF (NBMAIL.EQ.0) GOTO 9999
C
C --- INITIALISATIONS :
C     ---------------
      CALL INFNIV ( IFM , NIV )
      MAILMA = NOMA//'.NOMMAI'
C
C --- VECTEUR DU TYPE DES MAILLES DU MAILLAGE :
C     ---------------------------------------
      CALL JEVEUO ( NOMA//'.TYPMAIL        ', 'L', JTYMA )
C
C --- COORDONNEES DES NOEUDS DU MAILLAGE :
C     ----------------------------------
      CALL JEVEUO ( NOMA//'.COORDO    .VALE', 'L', JCOOR )
C
C --- RECUPERATION DE LA CONNECTIVITE DES MAILLES :
C     -------------------------------------------
      CALL JEVEUO ( JEXATR(NOMA//'.CONNEX','LONCUM'), 'L', P2 )
      CALL JEVEUO ( NOMA//'.CONNEX', 'E', P1 )
C
C     ALLOCATIONS :
C     -----------
      CALL WKVECT ( '&&ORILMA.ORI1', 'V V I' , NBMAIL, JNBN )
      CALL WKVECT ( '&&ORILMA.ORI2', 'V V I' , NBMAIL, JDNO )
      CALL WKVECT ( '&&ORILMA.ORI3', 'V V K8', NBMAIL, JNOM )
      CALL WKVECT ( '&&ORILMA.ORI4', 'V V K8', NBMAIL, JTYP )
C
C --- VERIFICATION DU TYPE DES MAILLES
C --- (ON DOIT AVOIR DES MAILLES DE PEAU) :
C     -----------------------------------
      DIME1 = .FALSE.
      DIME2 = .FALSE.
      DO 10 IMA = 1, NBMAIL
         NUMA = LISTMA(IMA)
         CALL JENUNO ( JEXNUM(MAILMA,NUMA), NOMAIL )
         ZK8(JNOM-1+IMA) = NOMAIL
         ZI(JNBN-1+IMA) = ZI(P2+NUMA+1-1) - ZI(P2+NUMA-1)
         ZI(JDNO-1+IMA) = ZI(P2+NUMA-1)
C
C ---   TYPE DE LA MAILLE COURANTE :
C       --------------------------
        NUTYMA = ZI(JTYMA+NUMA-1)
        CALL JENUNO ( JEXNUM('&CATA.TM.NOMTM',NUTYMA), TPMAIL )
        ZK8(JTYP-1+IMA) = TPMAIL
C
        IF (TPMAIL(1:4).EQ.'QUAD') THEN
           DIME2 = .TRUE.
        ELSEIF (TPMAIL(1:4).EQ.'TRIA') THEN
           DIME2 = .TRUE.
        ELSEIF (TPMAIL(1:3).EQ.'SEG') THEN
           DIME1 = .TRUE.
        ELSE
            VALK(1) = NOMAIL
            VALK(2) = TPMAIL
            CALL U2MESK('F','MODELISA5_94', 2 ,VALK)
        ENDIF
        IF (DIME1.AND.DIME2) CALL U2MESS('F','MODELISA5_98')
C
 10   CONTINUE
C
C --- RECHERCHE DES MAILLES SUPPORTS
C
      KDIM =' '
      IF ( DIME1 ) KDIM ='2D'
      IF ( DIME2 ) KDIM ='3D'
      CALL ASSERT(KDIM.NE.' ')
      NOMOB1 = '&&ORILMA.MAILLE_3D'
      CALL UTMASU ( NOMA, KDIM, NBMAIL, LISTMA, NOMOB1,ZR(JCOOR),
     &              NBMAVO, MAILVO,.FALSE.)
      CALL JEVEUO ( NOMOB1, 'L', JM3D )
C
      NORIEG = 0
      NTRAIT = 0
C
      DO 100 IMA = 1 , NBMAIL
C
         NOMAIL = ZK8(JNOM-1+IMA)
         TPMAIL = ZK8(JTYP-1+IMA)
         NBNMAI =  ZI(JNBN-1+IMA)
         JDESM  =  ZI(JDNO-1+IMA)
         NUMA3D =  ZI(JM3D-1+IMA)
         IF ( NUMA3D .EQ. 0 ) THEN
            NTRAIT = NTRAIT + 1
            GOTO 100
         ENDIF
         NBNM3D = ZI(P2+NUMA3D+1-1) - ZI(P2+NUMA3D-1)
         JDES3D = ZI(P2+NUMA3D-1)
         CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',ZI(JTYMA+NUMA3D-1)),TYP3D)
C
         CALL ORIEMA ( NOMAIL, TPMAIL, NBNMAI, ZI(P1+JDESM-1),
     &                 TYP3D, NBNM3D, ZI(P1+JDES3D-1),
     &                 NDIM, ZR(JCOOR), REORIE, NORIEM, IFM, NIV )
C
          NORIEG = NORIEG + NORIEM
C
 100  CONTINUE
C
      NORIEN = NORIEN + NORIEG
C
      CALL JEDETR('&&ORILMA.ORI1')
      CALL JEDETR('&&ORILMA.ORI2')
      CALL JEDETR('&&ORILMA.ORI3')
      CALL JEDETR('&&ORILMA.ORI4')
      CALL JEDETR(NOMOB1)
C
9999  CONTINUE
      CALL JEDEMA()
      END
