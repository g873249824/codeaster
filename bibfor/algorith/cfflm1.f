      SUBROUTINE CFFLM1(RESOCO,NDIM  ,NESMAX,NBLIAI,NBLIAC)
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
      IMPLICIT NONE
      CHARACTER*24 RESOCO
      INTEGER      NBLIAC,NESMAX,NDIM,NBLIAI
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
C
C CONSTRUCTION DE LA MATRICE TANGENTE DE FROTTEMENT - TERME POSITIF
C
C ----------------------------------------------------------------------
C
C
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NESMAX : NOMBRE MAX DE NOEUDS ESCLAVES
C IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
C IN  NBLIAI : NOMBRE DE LIAISONS
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      CHARACTER*32       JEXNUM
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
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      NDLMAX
      PARAMETER   (NDLMAX = 30)
      INTEGER      JDECAL,NBDDL
      REAL*8       XMU
      INTEGER      ILIAI,ILIAC
      CHARACTER*24 APDDL,APPOIN,APCOFR
      INTEGER      JAPDDL,JAPPTR,JAPCOF
      CHARACTER*19 LIAC,MU
      INTEGER      JLIAC,JMU
      CHARACTER*19 FRO1
      INTEGER      JFRO11,JFRO12
      LOGICAL      LIAACT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      APPOIN = RESOCO(1:14)//'.APPOIN'
      APCOFR = RESOCO(1:14)//'.APCOFR'
      APDDL  = RESOCO(1:14)//'.APDDL'
      LIAC   = RESOCO(1:14)//'.LIAC'
      MU     = RESOCO(1:14)//'.MU'
      CALL JEVEUO(APPOIN,'L',JAPPTR)
      CALL JEVEUO(APCOFR,'L',JAPCOF)
      CALL JEVEUO(APDDL ,'L',JAPDDL)
      CALL JEVEUO(LIAC  ,'L',JLIAC )
      CALL JEVEUO(MU    ,'L',JMU   )
      FRO1   = RESOCO(1:14)//'.FRO1'
C
C --- CALCUL DE LA MATRICE E_T*AaT
C
      DO 100 ILIAI = 1,NBLIAI
C
C ----- INITIALISATION DES COLONNES
C
        CALL JEVEUO(JEXNUM(FRO1,ILIAI),'E',JFRO11)
        CALL R8INIR(NDLMAX,0.D0,ZR(JFRO11),1)
        IF (NDIM.EQ.3) THEN
          CALL JEVEUO(JEXNUM(FRO1,ILIAI+NBLIAI),'E',JFRO12)
          CALL R8INIR(NDLMAX,0.D0,ZR(JFRO12),1)
        ENDIF
C
C ----- LA LIAISON EST-ELLE ACTIVE ?
C
        LIAACT = .FALSE.
        DO 200 ILIAC = 1,NBLIAC
          IF (ZI(JLIAC-1+ILIAC).EQ.ILIAI) LIAACT = .TRUE.
  200   CONTINUE
C
C ----- CALCUL
C
        IF (LIAACT) THEN
          JDECAL = ZI(JAPPTR+ILIAI-1)
          NBDDL  = ZI(JAPPTR+ILIAI) - ZI(JAPPTR+ILIAI-1)
          XMU    = ZR(JMU+3*NBLIAI+ILIAI-1)
          CALL DAXPY(NBDDL,XMU,ZR(JAPCOF+JDECAL),1,ZR(JFRO11),1)
          IF (NDIM.EQ.3) THEN
            CALL DAXPY(NBDDL,XMU,ZR(JAPCOF+JDECAL+NDLMAX*NESMAX),
     &                 1,ZR(JFRO12),1)
          ENDIF  
        ENDIF
C
        CALL JELIBE(JEXNUM(FRO1,ILIAI))
        IF (NDIM.EQ.3) THEN
          CALL JELIBE(JEXNUM(FRO1,ILIAI+NBLIAI))
        ENDIF   
  100 CONTINUE
C 
      CALL JEDEMA() 
C
      END 
