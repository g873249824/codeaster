      SUBROUTINE DFLLTY(SDLIST,METLIS,DTMIN )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
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
      CHARACTER*8  SDLIST
      CHARACTER*16 METLIS
      REAL*8       DTMIN
C
C ----------------------------------------------------------------------
C
C OPERATEUR DEFI_LIST_INST
C
C LECTURE DU TYPE DE CONSTRUCTION DE LA LISTE D'INSTANTS
C
C MOT-CLEF DEFI_LIST
C
C ----------------------------------------------------------------------
C
C CONSTRUCTION DE SDLIST//'.LIST.INFOR'
C
C     ZR(JLINR-1 + 1)  <===> 'METHODE' = 1 SI 'MANUEL'
C                                      = 2 SI 'AUTO'
C     ZR(JLINR-1 + 2)  <===> 'PAS_MINI
C     ZR(JLINR-1 + 3)  <===> 'PAS_MAXI'
C     ZR(JLINR-1 + 4)  <===> 'NB_PAS_MAX'
C     ZR(JLINR-1 + 5)  <===> DTMIN
C     ZR(JLINR-1 + 6)  <===> DT ACTUEL (VOIR NMCRLI...)
C     ZR(JLINR-1 + 7)  <===> REDECOUPE SI DIVE_ERRE (POUR CRESOL)
C     ZR(JLINR-1 + 8)  <===> NBINST
C     ZR(JLINR-1 + 9)  <===> NECHEC
C     ZR(JLINR-1 + 10) <===> NADAPT
C
C IN  SDLIST : NOM DE LA SD RESULTAT
C OUT METLIS : NOM DE LA METHODE DE GESTION DE LA LISTE D'INSTANTS
C OUT DTMIN  : INTERVALLE DE TEMPS MINIMUM SUR LA LISTE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*16 MOTFAC
      CHARACTER*16 MODETP
      INTEGER      DFLLVD,LLINR
      CHARACTER*24 LISIFR
      INTEGER      JLINR
      CHARACTER*19 LISINS
      INTEGER      NBINST,NADAPT
      INTEGER      JINST,JDITR
      INTEGER      N1,I,IRET,IBID
      REAL*8       PASMIN,PASMAX,PAS0
      INTEGER      NBPAMX
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      MOTFAC = 'DEFI_LIST'
      METLIS = ' '
      DTMIN  = 0.D0
C
C --- TAILLE DES VECTEURS
C
      LLINR  = DFLLVD('LLINR')
C
C --- CONSTRUCTION DE LA SD
C
      LISIFR = SDLIST(1:8)//'.LIST.INFOR'
      CALL WKVECT(LISIFR,'G V R',LLINR ,JLINR )
C
C --- LECTURE METHODE
C
      CALL GETVTX(MOTFAC,'METHODE',1,IARG,1,METLIS,IBID)
C   
C --- METHODE DE CONSTRUCTION DE LA LISTE D'INSTANT
C
      IF (METLIS.EQ.'MANUEL') THEN
        ZR(JLINR-1+1)= 1.D0
      ELSEIF (METLIS.EQ.'AUTO') THEN
        ZR(JLINR-1+1)= 2.D0
      ELSE
        WRITE(6,*)'CETTE FONCTIONNALITE N EST PAS ENCORE DISPO'
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- RECUPERATION DU NOM DE LA LISTE D'INSTANTS FOURNIE
C
      CALL GETVID(MOTFAC,'LIST_INST',1,IARG,1,LISINS,N1)
C
C --- VERIFICATIONS LISTE D'INSTANTS (CROISSANCE, TAILLE, ETC.)
C
      CALL DFLLLI(LISINS,DTMIN ,NBINST)
C
C --- ACCES LISTE INSTANTS
C
      CALL JEVEUO(LISINS//'.VALE','L',JINST)   
C
C --- CREATION LISTE D'INSTANTS DANS SDLIST
C   
      CALL WKVECT(SDLIST//'.LIST.DITR','G V R',NBINST,JDITR)
      DO 20 I=1,NBINST
        ZR(JDITR-1+I) = ZR(JINST-1+I)
 20   CONTINUE
C
C --- INTERVALLE MINIMUM + NOMBRE INSTANTS STOCKES
C
      ZR(JLINR-1+5) = DTMIN
      ZR(JLINR-1+8) = NBINST
C
C --- A CAUSE D IMPLEX, ON VA RECUPERER DE SUITE LE MODE DE CALCUL
C --- DE T+
C
      IF (METLIS.EQ.'AUTO')THEN
        CALL GETFAC('ADAPTATION',NADAPT)
        CALL GETVTX('ADAPTATION','MODE_CALCUL_TPLUS',NADAPT,IARG,1,
     &              MODETP,IBID)
        IF (NADAPT.NE.1.AND.MODETP.EQ.'IMPLEX') THEN
          CALL U2MESS('F','DISCRETISATION_15')
        ENDIF
      ENDIF
C
C --- PARAMETRES DE LA METHODE AUTOMATIQUE
C 
      IF (METLIS.EQ.'AUTO') THEN
C        
        CALL GETVR8(MOTFAC,'PAS_MAXI' ,1,IARG,1,PASMAX,IRET)
        IF (IRET.EQ.0) PASMAX = ZR(JDITR-1+NBINST) - ZR(JDITR-1+1)
C
C ----- CAS D'IMPLEX
C
        IF (MODETP.EQ.'IMPLEX') THEN
          PAS0   = ZR(JINST+1)-ZR(JINST)
          PASMIN = PAS0/1000
          IF (IRET.EQ.0) PASMAX = PAS0*10
        ELSE
C         PASMIN = CELLE DE VAL_MIN DE PAS_MINI (DEFI_LIST_INST.CAPY)
          PASMIN = 1.D-12
          IF (IRET.EQ.0) PASMAX = ZR(JDITR-1+NBINST) - ZR(JDITR-1+1)
        ENDIF
C
        CALL GETVR8(MOTFAC,'PAS_MINI'    ,1,IARG,1,PASMIN,IRET)
        IF (PASMIN.GT.DTMIN) CALL U2MESS('F','DISCRETISATION_1')      
C
        CALL GETVIS(MOTFAC,'NB_PAS_MAXI' ,1,IARG,1,NBPAMX,IRET)   
C
        ZR(JLINR-1+2) = PASMIN
        ZR(JLINR-1+3) = PASMAX
        ZR(JLINR-1+4) = NBPAMX
      ENDIF  
C
      CALL JEDEMA()
      END
