      SUBROUTINE ELPIV1(XJVMAX,INDIC,NBLIAC,AJLIAI,SPLIAI,SPAVAN,
     &                  NOMA,DEFICO,RESOCO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/11/2004   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
      IMPLICIT     NONE
      CHARACTER*8  NOMA
      CHARACTER*24 RESOCO
      CHARACTER*24 DEFICO
      REAL*8       XJVMAX
      INTEGER      NBLIAC
      INTEGER      INDIC
      INTEGER      AJLIAI
      INTEGER      SPLIAI
      INTEGER      SPAVAN
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : ALGOCL/ALGOCO/FROPGD
C ----------------------------------------------------------------------
C
C  ELIMINATION DES PIVOTS NULS DANS LA MATRICE DE CONTACT
C
C IN  XJVMAX : VALEUR DU PIVOT MAX
C OUT INDIC  : +1 ON A RAJOUTE UNE LIAISON 
C              -1 ON A ENLEVE UNE LIAISON  
C I/O NBLIAC : NOMBRE DE LIAISONS ACTIVES
C I/O AJLIAI : INDICE DANS LA LISTE DES LIAISONS ACTIVES DE LA DERNIERE
C              LIAISON CORRECTE DU CALCUL 
C              DE LA MATRICE DE CONTACT ACM1AT
C I/O SPLIAI : INDICE DANS LA LISTE DES LIAISONS ACTIVES DE LA DERNIERE
C              LIAISON AYANT ETE CALCULEE POUR LE VECTEUR CM1A
C IN  SPAVAN : INDICE DE DEBUT DE TRAITEMENT DES LIAISONS
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C                'E': RESOCO(1:14)//'.LIAC'
C                'E': RESOCO(1:14)//'.LIOT'
C
C      
C --------------- DEBUT DECLARATIONS NORMALISEES JEVEUX ---------------
C
      CHARACTER*32 JEXNUM
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
      CHARACTER*1  TYPESP
      CHARACTER*2  TYPEC0
      CHARACTER*19 LIAC, LIOT, MATR
      INTEGER      JLIAC,JLIOT,JVALE,JVA
      CHARACTER*24 APPARI,CONTNO,CONTMA
      INTEGER      JAPPAR,JNOCO,JMACO
      REAL*8       COPMAX
      INTEGER      KK1,KK2,KK1F,KK2F,LLF,LLF1,LLF2
      INTEGER      NBOTE,PIVOT,NBLIAI,LLIAC  
      INTEGER      NIV,IFM   
C
C ----------------------------------------------------------------------
C
      CALL INFNIV(IFM,NIV)
      CALL JEMARQ()
C ======================================================================
C --- LECTURE DES STRUCTURES DE DONNEES 
C ======================================================================
      APPARI = RESOCO(1:14)//'.APPARI'
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      CONTMA = DEFICO(1:16)//'.MAILCO'
      LIAC = RESOCO(1:14)//'.LIAC'
      LIOT = RESOCO(1:14)//'.LIOT'
      MATR = RESOCO(1:14)//'.MATR'
C ======================================================================
      CALL JEVEUO(CONTNO,'L',JNOCO)
      CALL JEVEUO(CONTMA,'L',JMACO)
      CALL JEVEUO(APPARI,'L',JAPPAR)
      CALL JEVEUO(LIAC,'E',JLIAC)
      CALL JEVEUO(LIOT,'E',JLIOT)
      CALL JEVEUO(JEXNUM(MATR//'.VALE',1),'L',JVALE)
C ======================================================================
C --- INITIALISATION DES VARIABLES
C ======================================================================
      NBLIAI = ZI(JAPPAR)
      TYPESP = 'S'
      TYPEC0 = 'C0'
      COPMAX = XJVMAX * 1.0D-08
      PIVOT  = 0
      LLF    = 0
      LLF1   = 0
      LLF2   = 0
C        
        DO 10 KK1=SPAVAN+1,NBLIAC
          DO 20 KK2=1,NBLIAC
            IF(KK2.GT.KK1) THEN
              KK1F = KK2
              KK2F = KK1
            ELSE
              KK1F = KK1
              KK2F = KK2
            ENDIF
            JVA = JVALE-1+((KK1F-1)*KK1F)/2 +KK2F
            IF(ABS(ZR(JVA)).LT.COPMAX) THEN            
              PIVOT = 1
            ELSE
              PIVOT = 0
              GOTO 10
            ENDIF
 20       CONTINUE
          IF (PIVOT.EQ.1) THEN
C
            LLIAC = ZI(JLIAC-1+KK1)
C
            ZI(JLIOT+4*NBLIAI) = ZI(JLIOT+4*NBLIAI) + 1
            NBOTE              = ZI(JLIOT+4*NBLIAI)            
            ZI(JLIOT-1+NBOTE)  = ZI(JLIAC-1+KK1)

            CALL CFTABL(INDIC,NBLIAC,AJLIAI,SPLIAI,LLF,LLF1,LLF2,
     &                  RESOCO,TYPESP,KK1,LLIAC,TYPEC0)
            CALL CFIMP2(IFM,NOMA,LLIAC,TYPEC0,TYPESP,'PIV',0.D0,
     &                  JAPPAR,JNOCO,JMACO)
            GOTO 40
          ENDIF
 10     CONTINUE
C  
40      CONTINUE
        CALL JEDEMA()
C
      END 
