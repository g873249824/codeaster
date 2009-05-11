      SUBROUTINE INER81(NOMRES,CLASSE,BASMOD,NOMMAT)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/05/2009   AUTEUR NISTOR I.NISTOR 
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
C***********************************************************************
C
C  BUT : CALCUL DES FORCES D'INERTIES SUR BASE MODALE
C
C-----------------------------------------------------------------------
C
C NOMRES /I/ : NOM K19 DE LA MATRICE CARREE RESULTAT
C CLASSE /I/ : CLASSE DE LA BASE JEVEUX DE L'OBJET RESULTAT
C BASMOD /I/ : NOM UT DE LA BASE MODALE DE PROJECTION
C NOMMAT /I/ : NOM K8 DE LA MATRICE A PROJETER
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      PARAMETER     (MXDDL=6)
      CHARACTER*8   NOMDDL(MXDDL)
      CHARACTER*1  CLASSE
      CHARACTER*6  PGC
      CHARACTER*19 NOMMAT
      CHARACTER*8  BASMOD,K8BID
      CHARACTER*14 NUM
      CHARACTER*24 CHAMVA, NOMRES
      CHARACTER*24 VALK
C
C-----------------------------------------------------------------------
      DATA PGC /'INER81'/
      DATA NOMDDL/'DX      ','DY      ','DZ      ',
     +            'DRX     ','DRY     ','DRZ     '/
C-----------------------------------------------------------------------
C
C --- CREATION DU .REFE
C
      CALL JEMARQ()
      CALL WKVECT(NOMRES(1:18)//'_REFE','G V K24',2,LDREF)
      ZK24(LDREF)=BASMOD
      ZK24(LDREF+1)=NOMMAT
C
C --- NOMBRE TOTAL DE MODES ET DEFORMEES
C
      CALL DISMOI('F','NB_MODES_TOT',BASMOD,'RESULTAT',
     &                      NBDEF,K8BID,IER)

C
C --- ALLOCATION DE LA MATRICE RESULTAT
C
      CALL WKVECT(NOMRES(1:18)//'_VALE',CLASSE//' V R',3*NBDEF,LDRES)
C
C --- CONTROLE D'EXISTENCE DE LA MATRICE
C
      CALL MTEXIS(NOMMAT(1:8),IER)
      IF(IER.EQ.0) THEN
        VALK = NOMMAT(1:8)
        CALL U2MESG('F', 'ALGORITH12_39',1,VALK,0,0,0,0.D0)
      ENDIF
C
C --- ALLOCATION DESCRIPTEUR DE LA MATRICE
C
      CALL MTDSCR(NOMMAT(1:8))
      CALL JEVEUO(NOMMAT(1:19)//'.&INT','E',LMAT)
C
C --- RECUPERATION NUMEROTATION ET NB EQUATIONS
C
      CALL DISMOI('F','NB_EQUA',NOMMAT(1:8),'MATR_ASSE',NEQ,K8BID,IRET)
      CALL DISMOI('F','NOM_NUME_DDL',NOMMAT(1:8),'MATR_ASSE',IBID,
     +            NUM,IRET)
C
C --- ALLOCATION VECTEURS DE TRAVAIL
C
      CALL WKVECT('&&'//PGC//'.VECT1','V V R',NEQ,LTVEC1)
      CALL WKVECT('&&'//PGC//'.VECT2','V V R',NEQ,LTVEC2)
      CALL WKVECT('&&'//PGC//'.VECT3','V V I',MXDDL*NEQ,LTVEC3)
      CALL PTEDDL('NUME_DDL',NUM,MXDDL,NOMDDL,NEQ,ZI(LTVEC3))
C
      CALL JEVEUO(NUM//'.NUME.DEEQ','L',IDDEEQ)
      CALL WKVECT('&&'//PGC//'.BASEMO','V V R',NBDEF*NEQ,IDBASE)
      CALL COPMO2(BASMOD,NEQ,NUM,NBDEF,ZR(IDBASE))
C
C --- CALCUL DES FORCES D'INERTIES
C
      DO 30 IF = 1 , 3
C
C     --- MODE RIGIDE EN DX , DY , DZ 
C
         IA = (IF-1)*NEQ
         DO 10 IEQ = 0,NEQ-1
            ZR(LTVEC1+IEQ) = ZI(LTVEC3+IA+IEQ)
   10    CONTINUE
C
C     --- MULTIPLICATION DU MODE RIGIDE PAR LA MATRICE MASSE
C
         CALL MRMULT('ZERO',LMAT,ZR(LTVEC1),'R',ZR(LTVEC2),1)
C
C     --- PROJECTION SUR LES MODES PROPRES ET LES DEFORMEES NON MODALES
C
         IAD = (IF-1)*NBDEF
         DO 20 I=1,NBDEF
           CALL DCOPY(NEQ,ZR(IDBASE+(I-1)*NEQ),1,ZR(LTVEC1),1)
           CALL ZERLAG(ZR(LTVEC1),NEQ,ZI(IDDEEQ))
           ZR(LDRES+IAD+I-1) = DDOT(NEQ,ZR(LTVEC1),1,ZR(LTVEC2),1)
   20    CONTINUE
C
   30 CONTINUE
C
C --- DESTRUCTION VECTEURS DE TRAVAIL
C
      CALL JEDETR('&&'//PGC//'.BASEMO')
      CALL JEDETR('&&'//PGC//'.VECT1')
      CALL JEDETR('&&'//PGC//'.VECT2')
      CALL JEDETR('&&'//PGC//'.VECT3')
C
 9999 CONTINUE
      CALL JEDEMA()
      END
