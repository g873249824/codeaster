      SUBROUTINE FETCCN(CHAMN1,CHAMN2,CHAMN3,CHAMN4,TYPCUM,CHAMNR)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/11/2004   AUTEUR BOITEAU O.BOITEAU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  CONCATENATION DE CHAM_NOS EN UN SEUL. EN 
C      FAIT UNIQUEMENT DE LEUR .VALE. LEURS .REFE/.DESC SONT SUPPOSES 
C      IDENTIQUES ET LES CHAM_NOS HOMOGENES (TOUS FETI OU AUCUN, ET SI
C      FETI AVEC LA MEME SD_FETI).
C      POUR GAGNER DU TEMPS AUCUN TEST D'HOMOGENEITE N'EST EFFECTUE. ILS
C      SONT NORMALEMENT FAITS (ET REFAITS !) EN AMONT.
C
C IN CHAMN1/4 : CHAM_NOS A CONCATENER
C IN TYPCUM   : TYPE DE CUMUL
C OUT CHAMNR  : CHAM_NO RESULTAT
C
C   -------------------------------------------------------------------
C     SUBROUTINES APPELLEES:
C       JEVEUX:JEMARQ,JEDEMA,JEEXIN,JEVEUO,JELIRA.
C       MSG   :UTDEBM,UTIMPI,UTFINM,UTMESS
C     FONCTIONS INTRINSEQUES:
C       NONE.
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       04/12/03 (OB): CREATION.
C----------------------------------------------------------------------
C RESPONSABLE BOITEAU O.BOITEAU
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      INTEGER      TYPCUM
      CHARACTER*19 CHAMN1,CHAMN2,CHAMN3,CHAMN4,CHAMNR

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      
C DECLARATION VARIABLES LOCALES
      INTEGER      IDD,IRET,NBSD,I1,I2,I3,I4,IR,NBVAL,K,J1,J2,J3,J4,JR,
     &             IDD1,IFM,NIV,IINF,IREFE
      CHARACTER*5  VALE,FETC 
      CHARACTER*8  K8BID
      CHARACTER*19 CHAM1B,CHAM2B,CHAM3B,CHAM4B,CHAMRB       
      CHARACTER*24 K24B,INFOFE
      
C CORPS DU PROGRAMME
      CALL JEMARQ()
C RECUPERATION ET MAJ DU NIVEAU D'IMPRESSION
      CALL INFNIV(IFM,NIV)
      
C INIT.
      VALE='.VALE'
      FETC='.FETC'
  
C FETI OR NOT ?      
      K24B=CHAMNR//FETC
      CALL JEEXIN(K24B,IRET)
      IF (IRET.GT.0) THEN

C NBRE DE SOUS-DOMAINES NBSD      
        CALL JELIRA(K24B,'LONMAX',NBSD,K8BID)
        
C PREPARATION POUR LA BOUCLE SUR LES SOUS-DOMAINES. STOCKAGE
C DES ADRESSES DES .FETC DE CHACUN DES CHAM_NOS A CONCATENER
        IF (TYPCUM.GT.0) CALL JEVEUO(CHAMN1//FETC,'L',I1)
        IF (TYPCUM.GT.1) CALL JEVEUO(CHAMN2//FETC,'L',I2)
        IF (TYPCUM.GT.2) CALL JEVEUO(CHAMN3//FETC,'L',I3)
        IF (TYPCUM.GT.3) CALL JEVEUO(CHAMN4//FETC,'L',I4)
        CALL JEVEUO(CHAMNR//FETC,'L',IR)
        CALL JEVEUO(CHAMNR//'.REFE','L',IREFE)  
        CALL JEVEUO('&&'//ZK24(IREFE+3)(1:17)//'.FINF','L',IINF)
        INFOFE=ZK24(IINF)
      ELSE
        NBSD=0        
      ENDIF

C----------------------------------------------------------------------
C --- BOUCLE SUR LES SOUS-DOMAINES
C----------------------------------------------------------------------

      DO 10 IDD=0,NBSD
      
        IF (IDD.EQ.0) THEN
C DOMAINE GLOBAL        
          CHAM1B=CHAMN1
          CHAM2B=CHAMN2
          CHAM3B=CHAMN3
          CHAM4B=CHAMN4
          CHAMRB=CHAMNR
        ELSE
C SOUS-DOMAINE N�IDD
          IDD1=IDD-1    
          IF (TYPCUM.GT.0) CHAM1B=ZK24(I1+IDD1)
          IF (TYPCUM.GT.1) CHAM2B=ZK24(I2+IDD1)
          IF (TYPCUM.GT.2) CHAM3B=ZK24(I3+IDD1)
          IF (TYPCUM.GT.3) CHAM4B=ZK24(I4+IDD1)
          CHAMRB=ZK24(IR+IDD1)    
        ENDIF

        IF (TYPCUM.GT.0) CALL JEVEUO(CHAM1B//VALE,'L',J1)
        IF (TYPCUM.GT.1) CALL JEVEUO(CHAM2B//VALE,'L',J2)      
        IF (TYPCUM.GT.2) CALL JEVEUO(CHAM3B//VALE,'L',J3)      
        IF (TYPCUM.GT.3) CALL JEVEUO(CHAM4B//VALE,'L',J4)      
        CALL JEVEUO(CHAMRB//VALE,'E',JR)
        CALL JELIRA(CHAMRB//VALE,'LONMAX',NBVAL,K8BID)
        NBVAL=NBVAL-1     

C----------------------------------------------------------------------
C ----- BOUCLE SUR LES .VALE SELON LES TYPES DE CUMUL
C----------------------------------------------------------------------

        IF (TYPCUM.EQ.0) THEN
          DO 2 K = 0, NBVAL
            ZR(JR+K) = 0.D0         
    2     CONTINUE
        ELSEIF (TYPCUM.EQ.1) THEN
          DO 3 K = 0, NBVAL
            ZR(JR+K) = ZR(J1+K)
    3     CONTINUE
        ELSEIF (TYPCUM.EQ.2) THEN
          DO 4 K = 0, NBVAL
            ZR(JR+K) = ZR(J1+K) + ZR(J2+K)
    4     CONTINUE
        ELSEIF (TYPCUM.EQ.3) THEN
          DO 5 K = 0, NBVAL
            ZR(JR+K) = ZR(J1+K) + ZR(J2+K) + ZR(J3+K)
    5     CONTINUE
        ELSEIF (TYPCUM.EQ.4) THEN
          DO 6  K = 0, NBVAL
            ZR(JR+K) = ZR(J1+K) + ZR(J2+K) + ZR(J3+K) + ZR(J4+K)
    6     CONTINUE
        ELSE
          CALL UTDEBM ('A','FETCCN', 'MAUVAISE VALEUR DE TYPCUM')
          CALL UTIMPI ('S', ': ', 1, TYPCUM)
          CALL UTFINM
          CALL UTMESS ('F','FETCCN', 'ERREUR DE PROGRAMMATION')
        ENDIF   
C MONITORING
        IF ((INFOFE(1:1).EQ.'T').AND.(NBSD.GT.0)) THEN
          WRITE(IFM,*)
          WRITE(IFM,*)'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD'
          IF (IDD.EQ.0) THEN
            WRITE(IFM,*)'<FETI/FETCCN> DOMAINE GLOBAL'
          ELSE
            WRITE(IFM,*)'<FETI/FETCCN> NUMERO DE SOUS-DOMAINE: ',IDD
          ENDIF                           
          WRITE(IFM,*)'<FETI/FETCCN> REMPLISSAGE OBJETS JEVEUX ',
     &         CHAMRB(1:19)
          WRITE(IFM,*)
          WRITE(IFM,*)'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD'        
          WRITE(IFM,*)
        ENDIF
        IF ((INFOFE(2:2).EQ.'T').AND.(IDD.NE.0)) 
     &    CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,CHAMRB(1:19),1,' ')
        IF ((INFOFE(2:2).EQ.'T').AND.(IDD.EQ.NBSD))
     &    CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,CHAMNR(1:19),1,' ')
   10 CONTINUE   
     
      CALL JEDEMA()
      END
