      SUBROUTINE NMDCCO(SDDISC,IEVDAC,TYPDEC,NBRPAS,DELTAC,
     &                  RATIO ,OPTDEC,RETDEC,LDCEXT,SUBDUR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/04/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*19 SDDISC
      INTEGER      IEVDAC,NBRPAS,RETDEC
      REAL*8       RATIO,DELTAC,SUBDUR
      LOGICAL      LDCEXT
      CHARACTER*4  TYPDEC
      CHARACTER*16 OPTDEC
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
C
C PARAMETRES DE DECOUPE - COLLISION
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  IEVDAC : INDICE DE L'EVENEMENT ACTIF
C OUT RATIO  : RATIO DU PREMIER PAS DE TEMPS
C OUT TYPDEC : TYPE DE DECOUPE
C              'SUBD' - SUBDIVISION PAR UN NOMBRE DE PAS DONNE
C              'DELT' - SUBDIVISION PAR UN INCREMENT DONNE
C OUT NBRPAS : NOMBRE DE PAS DE TEMPS
C OUT DELTAC : INCREMENT DE TEMPS CIBLE
C OUT OPTDEC : OPTION DE DECOUPE
C     'UNIFORME'   - DECOUPE REGULIERE ET UNIFORME
C     'PROGRESSIF' - DECOUPE EN DEUX ZONES, UN PAS LONG+ UNE SERIE
C                    DE PAS UNIFORMES
C     'DEGRESSIF'  - DECOUPE EN DEUX ZONES, UNE SERIE DE PAS
C                    UNIFORMES + UN PAS LONG
C OUT RETDEC : CODE RETOUR DECOUPE
C     0 - ECHEC DE LA DECOUPE
C     1 - ON A DECOUPE
C     2 - PAS DE DECOUPE
C OUT LDCEXT : .TRUE. SI ON DOIT CONTINUER LA DECOUPE
C OUT SUBDUR : DUREEE DE LA DECOUPE APRES (SI LDCEXT =.TRUE.)
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      IBID
      CHARACTER*8  K8BID
      REAL*8       SUBINS
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      RETDEC = 0
      RATIO  = 1.D0
      NBRPAS = -1
      OPTDEC = 'UNIFORME'
      TYPDEC = ' '
      LDCEXT = .FALSE.
      SUBDUR = -1.D0
C
C --- PARAMETRES
C
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IEVDAC,'SUBD_INST',
     &            SUBINS,IBID  ,K8BID )
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IEVDAC,'SUBD_DUREE'   ,
     &            SUBDUR,IBID  ,K8BID )
      TYPDEC = 'DELT'
      DELTAC = SUBINS
      LDCEXT = .TRUE.
      RETDEC = 1
C
      CALL JEDEMA()
      END
