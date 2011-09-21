      SUBROUTINE NMCRER(CARCRI,SDERRO)
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*24 SDERRO,CARCRI
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - INITIALISATIONS)
C
C CREATION DE LA SD ERREUR
C      
C ----------------------------------------------------------------------
C 
C
C IN  SDERRO : SD ERREUR
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      ZLICC
      PARAMETER   (ZLICC = 4)
C    
      INTEGER      IFM,NIV
      INTEGER      IBID
      CHARACTER*24 ERRCOD,ERRTPS,ERRCAR,ERRCVG
      INTEGER      JVALE,JECAR,JECVG
      INTEGER      JECOD,JERRT
      CHARACTER*16 MOTFAC,CHAINE
      REAL*8       THETA
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... LECTURE CALCUL ERREUR' 
      ENDIF
C
C --- INITIALISATIONS
C
      MOTFAC = 'INCREMENT'
C
C --- VALEUR DE THETA
C
      CALL JEVEUO(CARCRI(1:19)//'.VALV','L',JVALE)
      THETA  =  ZR(JVALE+3)      
C
C --- NOM DES SDS
C
      ERRCOD = SDERRO(1:19)//'.CODE'   
      ERRCAR = SDERRO(1:19)//'.CART'
      ERRCVG = SDERRO(1:19)//'.CCVG'
C
C --- CREATION SD 
C
      CALL WKVECT(ERRCOD,'V V L'  ,10   ,JECOD)
      CALL WKVECT(ERRCAR,'V V K24',1    ,JECAR)
      CALL WKVECT(ERRCVG,'V V I'  ,ZLICC,JECVG)
C
C --- ERREUR EN TEMPS (THM)
C
      CALL GETVTX(MOTFAC,'ERRE_TEMPS',1,IARG,1,CHAINE,IBID)
      IF (CHAINE.EQ.'OUI') THEN
        ERRTPS = SDERRO(1:19)//'.ERRT'
        CALL WKVECT(ERRTPS,'V V R',3,JERRT)
        ZR(JERRT-1+3) = THETA
      ENDIF
C
      CALL JEDEMA()
      END
