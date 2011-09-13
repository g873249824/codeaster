      SUBROUTINE CFAFMU(RESOCO,NEQ   ,NBLIAI,NBLIAC,LLF   )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/09/2011   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT     NONE
      INTEGER      NEQ
      INTEGER      NBLIAC,NBLIAI,LLF
      CHARACTER*24 RESOCO
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE DISCRETE - ALGORITHME)
C
C CALCUL DE AFMU - VECTEUR DES FORCES DE FROTTEMENT
C
C ----------------------------------------------------------------------
C  
C
C IN  NEQ    : NOMBRE D'EQUATIONS
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NESMAX : NOMBRE MAX DE NOEUDS ESCLAVES
C              (SERT A DECALER LES POINTEURS POUR LE FROTTEMENT 3D)
C IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C                'E': RESOCO(1:14)//'.ATMU'
C IN  LLF    : NOMBRE DE LIAISONS DE FROTTEMENT (EN 2D)
C              NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LES DEUX
C               DIRECTIONS SIMULTANEES (EN 3D)
C IN  LLF1   : NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LA
C               PREMIERE DIRECTION (EN 3D)
C IN  LLF2   : NOMBRE DE LIAISONS DE FROTTEMENT SUIVANT LA
C               SECONDE DIRECTION (EN 3D)
C IN  FROT   : VAUT 1 LORSQU'IL Y A DU FROTTEMENT, 0 SINON
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      COMPT0,JDECAL,NBDDL
      INTEGER      ILIAC,ILIAI
      REAL*8       LAMBDC,ZMU
      CHARACTER*19 LIAC,MU,AFMU,TYPL
      INTEGER      JLIAC,JMU,JAFMU,JTYPL
      CHARACTER*24 APPOIN,APDDL
      CHARACTER*24 APCOFR
      INTEGER      JAPPTR,JAPDDL
      INTEGER      JAPCOF 
      CHARACTER*2  TYPLIA,TYPEC0 
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      COMPT0 = 0
      TYPEC0 = 'C0'
C 
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C 
      APPOIN = RESOCO(1:14)//'.APPOIN'
      APCOFR = RESOCO(1:14)//'.APCOFR'
      APDDL  = RESOCO(1:14)//'.APDDL'
      LIAC   = RESOCO(1:14)//'.LIAC'
      MU     = RESOCO(1:14)//'.MU'
      AFMU   = RESOCO(1:14)//'.AFMU'
      TYPL   = RESOCO(1:14)//'.TYPL'
      CALL JEVEUO(APPOIN,'L',JAPPTR)
      CALL JEVEUO(APCOFR,'L',JAPCOF)
      CALL JEVEUO(APDDL, 'L',JAPDDL)
      CALL JEVEUO(TYPL  ,'L',JTYPL )
      CALL JEVEUO(LIAC,  'L',JLIAC )
      CALL JEVEUO(MU,    'L',JMU   )
      CALL JEVEUO(AFMU , 'E',JAFMU )      
C
C --- CALCUL
C      
      DO 140 ILIAC = 1, NBLIAC + LLF
        TYPLIA = ZK8(JTYPL-1+ILIAC)(1:2)
        IF (TYPLIA.EQ.TYPEC0) THEN
          COMPT0 = COMPT0 + 1
          ILIAI  = ZI(JLIAC+ILIAC-1)
          JDECAL = ZI(JAPPTR+ILIAI-1)
          NBDDL  = ZI(JAPPTR+ILIAI) - ZI(JAPPTR+ILIAI-1)
          LAMBDC = ZR(JMU+COMPT0-1)
          ZMU    = LAMBDC * ZR(JMU+3*NBLIAI+ILIAI-1)
          CALL CALATM(NEQ, NBDDL, ZMU, ZR(JAPCOF+JDECAL),
     &                ZI(JAPDDL+JDECAL), ZR(JAFMU))
        ENDIF
 140  CONTINUE
C
      CALL JEDEMA()
      END
