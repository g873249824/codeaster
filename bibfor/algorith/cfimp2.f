      SUBROUTINE CFIMP2(IFM,NOMA,ILIAI,TYPLIA,TYPOPE,TYPEOU,JEU,
     &                  JAPPAR,JNOCO,JMACO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/11/2004   AUTEUR MABBAS M.ABBAS 
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
C
      IMPLICIT     NONE
      INTEGER      IFM
      CHARACTER*8  NOMA
      INTEGER      ILIAI
      CHARACTER*2  TYPLIA
      CHARACTER*1  TYPOPE
      CHARACTER*3  TYPEOU
      REAL*8       JEU
      INTEGER      JAPPAR
      INTEGER      JNOCO
      INTEGER      JMACO
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : ALGOCL/ALGOCO/ALGOCP/FRO2GD/FROGDP/FROLGD/FROPGD
C ----------------------------------------------------------------------
C
C IMPRESSION DE L'ACTIVATION/DESACTIVATION DE LA LIAISON ESCLAVE/MAITRE
C
C IN  IFM    : UNITE D'IMPRESSION DU MESSAGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  ILIAI  : NUMERO DE LA LIAISON (INDICE DANS LE TABLEAU GLOBAL DE
C              TOUTE LES LIAISONS POSSIBLES -APPARIEES-)
C IN  TYPLIA : TYPE DE LA LIAISON
C                'C0': CONTACT
C                'F0': FROTTEMENT SUIVANT LES DEUX DIRECTIONS
C                       SIMULTANEES (3D)
C                'F1': FROTTEMENT SUIVANT LA PREMIERE DIRECTION (3D)
C                'F2': FROTTEMENT SUIVANT LA SECONDE DIRECTION (3D)
C                'F3': FROTTEMENT (2D)
C IN  TYPOPE : TYPE D'OPERATION DANS LE VECTEUR DES LIAISONS
C                'A' : AJOUTER UNE LIAISON
C                'S' : SUPPRIMER UNE LIAISON
C IN  TYPEOU : LIEU OU L'OPERATION A ETE FAITE
C                'ALG' : ALGO PRINCIPAL DE CONTACT
C                'NEG' : SUPPRESSION D'UNE LIAISON A PRESSION NEGATIVE
C                'ADH' : SUPPRESSION D'UNE LIAISON ADHERENTE
C                'PIV' : SUPPRESSION D'UNE LIAISON A PIVOT NUL 
C IN  JAPPAR : POINTEUR VERS RESOCO(1:14)//'.APPARI'
C IN  JNOCO  : POINTEUR VERS DEFICO(1:16)//'.NOEUCO'
C IN  JMACO  : POINTEUR VERS DEFICO(1:16)//'.MAILCO'
C IN  JEU    : JEU DE LA LIAISON OU LAMBDA DANS LE CAS 'PRE'
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      ZAPPAR
      PARAMETER    (ZAPPAR=3)
      INTEGER      POSESC,NUMESC,NUMMAI,POSMAI
      CHARACTER*8  NOMESC,NOMMAI
      CHARACTER*20 CHAIAC
      CHARACTER*10 TYPLI
      CHARACTER*4  TYPE2
C
C ----------------------------------------------------------------------
C
C --- REPERAGE DE L'ESCLAVE
      POSESC = ZI(JAPPAR+ZAPPAR*(ILIAI-1)+1)
      NUMESC = ZI(JNOCO+POSESC-1)
      CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMESC),NOMESC)
C --- REPERAGE DU MAITRE
      POSMAI = ZI(JAPPAR+ZAPPAR*(ILIAI-1)+2)
  
C --- PREPARATION DES CHAINES POUR LES NOMS
      TYPE2 = '    '
      IF (POSMAI.GT.0) THEN
        TYPE2 ='/EL '
        NUMMAI = ZI(JMACO+POSMAI-1)
        CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAI),NOMMAI)
      ELSE IF (POSMAI.LT.0) THEN   
        TYPE2 ='/ND '
        NUMMAI = ZI(JNOCO+ABS(POSMAI)-1)
        CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMMAI),NOMMAI)
      END IF

      IF (TYPOPE.EQ.'A') THEN
        CHAIAC = ' ACTIVEE       (JEU:'
      ELSE
        CHAIAC = ' DESACTIVEE    (JEU:'
      ENDIF
      
      IF (TYPLIA.EQ.'C0') THEN
        TYPLI = 'CONTACT   '
      ELSE IF (TYPLIA.EQ.'F0') THEN
        TYPLI = 'FROT. 1&2 '
      ELSE IF (TYPLIA.EQ.'F1') THEN
        TYPLI = 'FROT. 1   '
      ELSE IF (TYPLIA.EQ.'F2') THEN
        TYPLI = 'FROT. 2   '
      ELSE IF (TYPLIA.EQ.'F3') THEN
        TYPLI = 'FROT.     '
      ENDIF


      IF (TYPEOU.EQ.'ALG') THEN
        WRITE (IFM,1000) ILIAI,'(',NOMESC,TYPE2,NOMMAI,'): ',
     &                   CHAIAC,JEU,',TYPE: ',TYPLI,
     &                   ')'
      ELSE IF (TYPEOU.EQ.'PRE') THEN
        CHAIAC = ' PRES. NEGATIVE (MU:'
        WRITE (IFM,1000) ILIAI,'(',NOMESC,TYPE2,NOMMAI,'): ',
     &                   CHAIAC,JEU,',TYPE: ',TYPLI,
     &                   ')'
      ELSE IF (TYPEOU.EQ.'PIV') THEN
        CHAIAC = ' PIVOT NUL         ('
        WRITE (IFM,1001) ILIAI,'(',NOMESC,TYPE2,NOMMAI,'): ',
     &                   CHAIAC,',TYPE: ',TYPLI,
     &                   ')'
      ELSE IF (TYPEOU.EQ.'ADH') THEN
        CHAIAC = ' NON ADHERENTE     ('
        WRITE (IFM,1001) ILIAI,'(',NOMESC,TYPE2,NOMMAI,'): ',
     &                   CHAIAC,',TYPE: ',TYPLI,
     &                   ')'
      ENDIF


    
 1000 FORMAT (' <CONTACT> <> LIAISON ',I5,A1,A8,A4,A8,A3,A20,E10.3,
     &         A7,A10,A1)
 1001 FORMAT (' <CONTACT> <> LIAISON ',I5,A1,A8,A4,A8,A3,A20,
     &         A7,A10,A1)


      END
