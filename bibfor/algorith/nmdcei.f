      SUBROUTINE NMDCEI(SDDISC,METHOD,NUMINS,INSTAM,DELTAT,
     &                  LENIVO,PASMIN,NBRPAS,RATIO ,RETOUR)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/07/2009   AUTEUR GENIAUT S.GENIAUT 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*19 SDDISC
      CHARACTER*16 METHOD
      INTEGER      NBRPAS,NUMINS,LENIVO
      REAL*8       RATIO,PASMIN
      REAL*8       INSTAM,DELTAT
      INTEGER      RETOUR
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - DECOUPE)
C
C EXTENSION DE LA LISTE D'INSTANTS
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION
C IN  METHOD : NOM DE LA METHODE DE SUBDIVISION DU PAS DE TEMPS
C IN  NUMINS : NUMERO D'INSTANT
C IN  INSTAM : INSTANT PRECEDENT
C IN  DELTAT : INCREMENT DE TEMPS
C IN  LENIVO : NIVEAU DE SOUS-DECOUPE COURANT
C IN  PASMIN : PAS MINIMUM A NE APS ATTEINDRE EN DECOUPANT
C IN  NBRPAS : NOMBRE DE PAS A CREER
C IN  RATIO  : RATIO DE CREATION DES PAS
C OUT RETOUR : CODE RETOUR ALGORITHME EXTRAPOLATION
C                2 - FINESSE MAXIMALE ATTEINTE 
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
      INTEGER      INSPAS,LGINI,NBINI,LGTEMP,I,IBID
      CHARACTER*24 TPSDIT,TPSDIN
      INTEGER      JTEMPS,JNIVTP
      CHARACTER*8  K8BID
      CHARACTER*16 METLIS
      REAL*8       INCINS,INST,R8B,DT0
      REAL*8       VALRM(2)
      INTEGER      VALIM(2)
      CHARACTER*40 VALKM(1)      
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()

      CALL ASSERT(METHOD.EQ.'UNIFORME'.OR. 
     &            METHOD.EQ.'EXTRAP_IGNO'.OR. 
     &            METHOD.EQ.'EXTRAP_FIN') 

C     METHODE DE GESTION DE LA LISTE D'INSTANT
      CALL UTDIDT('L',SDDISC,'LIST',IBID,'METHODE',R8B,IBID,METLIS)

C --- ACCES SD LISTE D'INSTANTS
C         
      TPSDIT = SDDISC(1:19)//'.DITR'
      TPSDIN = SDDISC(1:19)//'.DINI'        
C
C --- TAILLE DE PAS MINIMALE ATTEINTE PENDANT LA SUBDIVISION
C
      IF (METHOD.EQ.'UNIFORME') THEN
        INCINS = DELTAT / (RATIO + NBRPAS - 1)
        IF ( INCINS .LT. PASMIN ) THEN
          VALKM(1) = 'PENDANT LA NOUVELLE SUBDIVISION'
          CALL U2MESK('I','SUBDIVISE_13',1,VALKM)
          VALKM(1) = METHOD
          VALIM(1) = LENIVO-1
          VALRM(1) = INCINS*RATIO
          VALRM(2) = PASMIN
          CALL U2MESG('I','SUBDIVISE_15',1,VALKM,1,VALIM,2,VALRM)
          RETOUR = 2
          GOTO 999
        ENDIF
      ENDIF              
C 
C
C --- LONGUEUR INITIALE DE LA LISTE D'INSTANTS
      CALL UTDIDT('L',SDDISC,'LIST',IBID,'NBINST',R8B,LGINI,K8BID)

      NBINI  = LGINI  - 1
C
C --- NOUVEAU NOMBRE D'INSTANTS
C    
      INSPAS = NBRPAS - 1
      IF (METLIS.EQ.'AUTO') INSPAS = 1
      LGTEMP = LGINI  + INSPAS
C      
C --- ALLONGEMENT DE LA LISTE D'INSTANTS      
C      
      CALL JUVECA(TPSDIT,LGTEMP)
      CALL JUVECA(TPSDIN,LGTEMP)      
      CALL JEVEUO(TPSDIT,'E',JTEMPS)
      CALL JEVEUO(TPSDIN,'E',JNIVTP) 
C            
C --- RECOPIE DE LA PARTIE HAUTE DE LA LISTE
C
      DO 12 I = NBINI, NUMINS, -1
        ZR(JTEMPS+I+INSPAS) = ZR(JTEMPS+I)
        ZI(JNIVTP+I+INSPAS) = ZI(JNIVTP+I)
12    CONTINUE
C
C --- INSERTION DES INSTANTS SUPPLEMENTAIRES
C
      IF (METHOD(1:7) .EQ. 'EXTRAP_')THEN
        INCINS = DELTAT
        INST   = INSTAM
        DO 14 I = NUMINS, NUMINS+INSPAS-1
          IF ( (I-NUMINS+1) .LE. NBRPAS*0.5D0 ) THEN
            INST = INST + INCINS*RATIO*(I-NUMINS+1)
          ELSE
            INST = INST + INCINS*RATIO*NBRPAS*0.5D0
          ENDIF
          ZR(JTEMPS+I) = INST
          ZI(JNIVTP+I) = ZI(JNIVTP+NUMINS+INSPAS)+1
14      CONTINUE
      ELSEIF (METHOD.EQ.'UNIFORME') THEN
        INCINS = DELTAT / (RATIO + NBRPAS - 1)
        INST   = INSTAM
        DO 24 I = NUMINS, NUMINS+INSPAS-1
          IF (I .EQ. NUMINS) THEN
            INST = INST + INCINS*RATIO
          ELSE
            INST = INST + INCINS
          ENDIF
          ZR(JTEMPS+I) = INST
          ZI(JNIVTP+I) = ZI(JNIVTP+NUMINS+INSPAS)+1
24      CONTINUE
C       JE NE SAIS PAS A QUOI CA SERT      
        ZI(JNIVTP+NUMINS+INSPAS) = ZI(JNIVTP+NUMINS+INSPAS)+1
      ENDIF
C
  999 CONTINUE      
C
C     EN GESTION AUTOMATIQUE, ENREGISTREMENT DE DT MOINS
      IF (METLIS.EQ.'AUTO') THEN
        DT0 = ZR(JTEMPS-1+NUMINS+1)-ZR(JTEMPS-1+NUMINS)
        CALL UTDIDT('E',SDDISC,'LIST',IBID,'DT-',DT0,IBID,K8BID)
      ENDIF
      
      CALL JEDEMA()
      END
