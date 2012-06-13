      SUBROUTINE CFLLM1(RESOCO,NEQ   ,NESMAX,NBLIAI,NBLIAC,
     &                  LLF   ,LLF1  ,LLF2  ,XMUL  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 RESOCO
      INTEGER      NEQ,NESMAX
      INTEGER      NBLIAC,NBLIAI,LLF,LLF1,LLF2
      REAL*8       XMUL
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
C IN  NEQ    : DIMENSION DU PROBLEME
C IN  NESMAX : NOMBRE MAX DE NOEUDS ESCLAVES
C IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
C IN  NBLIAI : NOMBRE DE LIAISONS
C
C
C
C
      INTEGER      NDLMAX
      PARAMETER   (NDLMAX = 30)
      REAL*8       XMU
      INTEGER      ILIAI1,ILIAI2,ILIAC2
      CHARACTER*19 LIAC,TYPL,MU
      INTEGER      JLIAC,JTYPL,JMU
      CHARACTER*24 TACFIN,APPOIN,APCOFR,APDDL
      INTEGER      JTACF,JAPPTR,JAPCOF,JAPDDL
      INTEGER      CFMMVD,ZTACF
      CHARACTER*19 FRO1
      INTEGER      JFRO11,JFRO12
      LOGICAL      LIAACT
      CHARACTER*2  TYPEC0,TYPEF0,TYPEF1,TYPEF2
      REAL*8       R8PREM
      REAL*8       COEFFF
      CHARACTER*2  TYPLI2
      LOGICAL      LELPIV,LELPI1,LELPI2
      REAL*8       AJEUFX,AJEUFY,GLIS
      REAL*8       LAMBDC,LAMBDF
      CHARACTER*19 DEPLC
      INTEGER      JDEPC
      INTEGER      NBDDL,JDECAL,BTOTAL
      INTEGER      COMPT0
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      COMPT0 = 0
      BTOTAL = NBLIAC + LLF + LLF1 + LLF2
      TYPEC0 = 'C0'
      TYPEF0 = 'F0'
      TYPEF1 = 'F1'
      TYPEF2 = 'F2'
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      APPOIN = RESOCO(1:14)//'.APPOIN'
      APCOFR = RESOCO(1:14)//'.APCOFR'
      APDDL  = RESOCO(1:14)//'.APDDL'
      LIAC   = RESOCO(1:14)//'.LIAC'
      TYPL   = RESOCO(1:14)//'.TYPL'
      TACFIN = RESOCO(1:14)//'.TACFIN' 
      MU     = RESOCO(1:14)//'.MU'
      CALL JEVEUO(APPOIN,'L',JAPPTR)
      CALL JEVEUO(APCOFR,'L',JAPCOF)
      CALL JEVEUO(APDDL, 'L',JAPDDL)
      CALL JEVEUO(LIAC,  'L',JLIAC )
      CALL JEVEUO(TYPL  ,'L',JTYPL )
      CALL JEVEUO(TACFIN,'L',JTACF )
      CALL JEVEUO(MU,    'L',JMU   )
      ZTACF  = CFMMVD('ZTACF')
C
      FRO1   = RESOCO(1:14)//'.FRO1'
C
C --- ACCES AUX CHAMPS DE TRAVAIL
C --- DEPLC : INCREMENT DE DEPLACEMENT CUMULE DEPUIS DEBUT 
C ---         DU PAS DE TEMPS AVEC CORRECTION DU CONTACT
C
      DEPLC  = RESOCO(1:14)//'.DEPC'
      CALL JEVEUO(DEPLC (1:19)//'.VALE','L',JDEPC) 
C
C --- CALCUL DE LA MATRICE
C
      DO 100 ILIAI1 = 1,NBLIAI
C
C ----- INFORMATIONS SUR LA LIAISON
C
        JDECAL = ZI(JAPPTR+ILIAI1-1)
        NBDDL  = ZI(JAPPTR+ILIAI1)-ZI(JAPPTR+ILIAI1-1)
        COEFFF = ZR(JTACF+ZTACF*(ILIAI1-1)+1-1)
C
C ----- LIAISON PROVOQUANT UN PIVOT NUL ?
C
        CALL CFELPV(ILIAI1,TYPEF0,RESOCO,NBLIAI,LELPIV)
        CALL CFELPV(ILIAI1,TYPEF1,RESOCO,NBLIAI,LELPI1)
        CALL CFELPV(ILIAI1,TYPEF2,RESOCO,NBLIAI,LELPI2)
C
C ----- ACCES AUX COLONNES
C
        CALL JEVEUO(JEXNUM(FRO1,ILIAI1)       ,'E',JFRO11)   
        CALL JEVEUO(JEXNUM(FRO1,ILIAI1+NBLIAI),'E',JFRO12)      
C
C ----- LA LIAISON EST-ELLE ACTIVE ?
C
        LIAACT = .FALSE.
        COMPT0 = 0
        DO 200 ILIAC2 = 1,BTOTAL
          ILIAI2 = ZI(JLIAC+ILIAC2-1)
          TYPLI2 = ZK8(JTYPL+ILIAC2-1)(1:2)   
          IF (TYPLI2.EQ.TYPEC0) COMPT0 = COMPT0 + 1 
          IF (ILIAI2.EQ.ILIAI1) THEN
            LIAACT = .NOT.LIAACT
            LAMBDC = ZR(JMU+COMPT0-1)
            LAMBDF = COEFFF*LAMBDC
          ENDIF
  200   CONTINUE 
C
C ----- CALCUL DES COLONNES DE LA LIAISON ACTIVE
C
        IF (.NOT.LIAACT) THEN
          CALL R8INIR(NDLMAX,0.D0,ZR(JFRO11),1)
          CALL R8INIR(NDLMAX,0.D0,ZR(JFRO12),1)
        ELSE
          IF (LELPIV) THEN
            CALL R8INIR(NDLMAX,0.D0,ZR(JFRO11),1)
            CALL R8INIR(NDLMAX,0.D0,ZR(JFRO12),1)
          ELSE  
C
C --------- CALCUL DES JEUX
C
            AJEUFX = 0.D0
            AJEUFY = 0.D0 
            IF (.NOT.LELPI1) THEN
              CALL CALADU(NEQ   ,NBDDL,ZR(JAPCOF+JDECAL),
     &                    ZI(JAPDDL+JDECAL),ZR(JDEPC),AJEUFX)
            ENDIF
            IF (.NOT.LELPI2) THEN
              CALL CALADU(NEQ   ,NBDDL,ZR(JAPCOF+JDECAL+NDLMAX*NESMAX),
     &                    ZI(JAPDDL+JDECAL),ZR(JDEPC),AJEUFY)
            ENDIF
            GLIS   = SQRT( AJEUFX**2 + AJEUFY**2 )
C
C --------- COEFFICIENT
C
            IF (GLIS.LE.R8PREM()) THEN
              XMU = XMUL
            ELSE
              XMU = SQRT(LAMBDF/GLIS)
            ENDIF
C
C --------- CALCUL DES COLONNES
C
            IF (.NOT.LELPI1) THEN
              CALL R8INIR(NDLMAX,0.D0,ZR(JFRO11),1)
              CALL DAXPY(NBDDL,XMU,
     &                   ZR(JAPCOF+JDECAL),1,ZR(JFRO11),1)
            ENDIF
            IF (.NOT.LELPI2) THEN
              CALL R8INIR(NDLMAX,0.D0,ZR(JFRO12),1)
              CALL DAXPY(NBDDL,XMU,
     &                   ZR(JAPCOF+JDECAL+NDLMAX*NESMAX),1,ZR(JFRO12),1)
            ENDIF
          ENDIF
        ENDIF       
C
C ----- LIBERATION DES COLONNES
C
        CALL JELIBE(JEXNUM(FRO1,ILIAI1))
        CALL JELIBE(JEXNUM(FRO1,ILIAI1+NBLIAI))
  100 CONTINUE
C 
      CALL JEDEMA() 
C
      END 
