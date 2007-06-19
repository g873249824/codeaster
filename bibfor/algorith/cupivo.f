      SUBROUTINE CUPIVO(XJVMAX,INDIC,NBLIAC,AJLIAI,SPLIAI,SPAVAN,
     &                  NOMA,DEFICU,RESOCU)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/03/2006   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*8  NOMA
      CHARACTER*24 RESOCU
      CHARACTER*24 DEFICU
      REAL*8       XJVMAX
      INTEGER      NBLIAC
      INTEGER      INDIC
      INTEGER      AJLIAI
      INTEGER      SPLIAI
      INTEGER      SPAVAN
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : ALGOCU
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
C IN  DEFICU : SD DE DEFINITION (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCU : SD DE TRAITEMENT 
C                'E': RESOCU(1:14)//'.LIAC'
C                'E': RESOCU(1:14)//'.LIOT'
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
      CHARACTER*19 LIAC, LIOT, MATR, STOC,OUVERT
      INTEGER      JLIAC,JLIOT,JVALE,JVA,JSCDE,JOUV
      CHARACTER*24 DIMECU
      INTEGER      NBBLOC,JDIM
      REAL*8       COPMAX
      INTEGER      KK1,KK2,KK1F,KK2F
      INTEGER      NBOTE,PIVOT,NBLIAI,LLIAC, II
      INTEGER      NIV,IFM
      INTEGER      BLOC, ISCIB, JSCBL, DERCOL
C
C ----------------------------------------------------------------------
C
      CALL INFNIV(IFM,NIV)
      CALL JEMARQ()
C ======================================================================
C --- LECTURE DES STRUCTURES DE DONNEES
C ======================================================================
      DIMECU = DEFICU(1:16)//'.DIMECU'     
      LIAC   = RESOCU(1:14)//'.LIAC'
      LIOT   = RESOCU(1:14)//'.LIOT'
      MATR   = RESOCU(1:14)//'.MATR'
      STOC   = RESOCU(1:14)//'.SLCS'
C ======================================================================
      CALL JEVEUO(LIAC,'E',JLIAC)
      CALL JEVEUO(LIOT,'E',JLIOT)
      CALL JEVEUO(DIMECU,'L',JDIM)
      CALL JEVEUO(STOC//'.SCIB','L',ISCIB)
      CALL JEVEUO(STOC//'.SCBL','L',JSCBL)
      CALL JEVEUO(STOC//'.SCDE','L',JSCDE)
C ======================================================================
C --- INITIALISATION DES VARIABLES
C ======================================================================
      NBLIAI = ZI(JDIM)      
      TYPESP = 'S'
      COPMAX = XJVMAX * 1.0D-08
      PIVOT  = 0
      NBBLOC=ZI(JSCDE-1+3)
      OUVERT='&&ELPIV2.TRAV'
      CALL WKVECT (OUVERT,'V V L',NBBLOC,JOUV)
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
          II     = ZI(ISCIB-1+KK1F)
          DERCOL = ZI(JSCBL+II-1)
          BLOC   = DERCOL*(DERCOL+1)/2
          IF (.NOT.ZL(JOUV-1+II)) THEN
             IF ((II.GT.1).AND.(KK1F.NE.(SPAVAN+1))) THEN
                CALL JELIBE(JEXNUM(MATR//'.UALF',(II-1)))
                ZL(JOUV-2+II)=.FALSE.
             ENDIF
             CALL JEVEUO (JEXNUM(MATR//'.UALF',II),'E',JVALE)
             ZL(JOUV-1+II)=.TRUE.
          ENDIF
        
          JVA=JVALE-1+(KK1F-1)*(KK1F)/2-BLOC+KK2F
     
          IF(ABS(ZR(JVA)).LT.COPMAX) THEN
            PIVOT = 1           
          ELSE
            PIVOT = 0          
            GOTO 10
          ENDIF
 20     CONTINUE
        IF (PIVOT.EQ.1) THEN
C
          LLIAC = ZI(JLIAC-1+KK1)
C
          ZI(JLIOT+4*NBLIAI) = ZI(JLIOT+4*NBLIAI) + 1
          NBOTE              = ZI(JLIOT+4*NBLIAI)
          ZI(JLIOT-1+NBOTE)  = ZI(JLIAC-1+KK1)

          CALL CUTABL(INDIC,NBLIAC,AJLIAI,SPLIAI,
     &                RESOCU,TYPESP,KK1,LLIAC)
          CALL CUIMP2(IFM,LLIAC,TYPESP,'PIV',RESOCU)
          GOTO 40
        ENDIF
 10   CONTINUE
C
40    CONTINUE
      CALL JEDETR(OUVERT)
      CALL JEDEMA()
C
      END
