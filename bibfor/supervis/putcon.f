      SUBROUTINE PUTCON(NOMRES,NBIND,IND,VALR,VALI,NUM,IER)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 18/04/2005   AUTEUR NICOLAS O.NICOLAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE  CRP_6
      IMPLICIT NONE
      CHARACTER*(*) NOMRES
      INTEGER       IER,NBIND, IND(NBIND),NUM
      REAL*8        VALR(NBIND),VALI(NBIND)
C IN  NOMRES  K*  NOM DE L'OBJET OU COLLECTION JEVEUX
C IN  NBIND   I   TAILLE DU VECTEUR D'INDICE
C IN  IND     I   LISTE D INDICE DES VALEURS MODIFIEES DANS LE VECTEUR
C IN  VALR    R   VECTEUR REEL A AFFECTER
C IN  VALI    C   VECTEUR IMAGINAIRE A AFFECTER
C IN  NUM    I    NUMERO D'ORDRE SI COLLECTION
C OUT IER     I   <0=ERREUR 1=OK

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32  JEXNUM,JEXNOM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*4     TYPE
      CHARACTER*2     ACCES
      CHARACTER*1     XOUS,GENR,KBID
      INTEGER         JRES,IRET,IBID,I,NBINDJ
      CHARACTER*32    NOML32
C     ------------------------------------------------------------------
      CALL JEMARQ()
      NOML32=NOMRES
C
      CALL JJVERN(NOML32,0,IRET)
      CALL JELIRA(NOML32,'XOUS',IBID,XOUS)
      CALL JELIRA(NOML32,'GENR',IBID,GENR)
      IF(IRET.EQ.0)THEN
C     CET OBJET N'EXISTE PAS
         IER=0
      ELSE IF((XOUS.EQ.'S').AND.(GENR.NE.'N'))THEN
C     ------------------------------------------------------------------
C     CET OBJET EXISTE ET EST SIMPLE. ON PEUT AVOIR SA VALEUR
C     ------------------------------------------------------------------
         CALL JEVEUO(NOML32,'E',JRES)
         CALL JELIRA(NOML32,'TYPELONG',IBID,TYPE)
         CALL JELIRA(NOML32,'LONMAX',NBINDJ,KBID)
         IF (NBIND.GT.NBINDJ) THEN
            IER=0
         ENDIF
         IF(TYPE.EQ.'R')THEN
C     LES VALEURS SONT REELLES
            IER=1
            DO 66 I=1,NBIND
              ZR(JRES+IND(I)-1)=VALR(I)
  66        CONTINUE
         ELSE IF (TYPE.EQ.'C')THEN
C     LES VALEURS SONT COMPLEXES
            IER=1
            DO 67 I=1,NBIND
              ZC(JRES+IND(I)-1)=DCMPLX(VALR(I),VALI(I))
  67        CONTINUE
         ELSE
C     LES VALEURS SONT NI REELLES NI COMPLEXES
            IER=0
         ENDIF
      ELSE IF(XOUS.EQ.'X')THEN
C     ------------------------------------------------------------------
C     CET OBJET EST UNE COLLECTION, ON PEUT AVOIR SA VALEUR GRACE A NUM
C     LE NUMERO D'ORDRE DANS LA COLLECTION
C     ------------------------------------------------------------------
         CALL JEVEUO(JEXNUM(NOML32,NUM),'E',JRES)
         CALL JELIRA(NOML32,'TYPELONG',IBID,TYPE)
         CALL JELIRA(JEXNUM(NOML32,NUM),'LONMAX',NBINDJ,KBID)
         IF (NBIND.GT.NBINDJ) THEN
            IER=0
         ENDIF
         IF(TYPE.EQ.'R')THEN
C     LES VALEURS SONT REELLES
            IER=1
            DO 68 I=1,NBIND
              ZR(JRES+IND(I)-1)=VALR(I)
  68        CONTINUE
         ELSE IF (TYPE.EQ.'C')THEN
C     LES VALEURS SONT COMPLEXES
            IER=1
            DO 69 I=1,NBIND
              ZC(JRES+IND(I)-1)=DCMPLX(VALR(I),VALI(I))
  69        CONTINUE
         ELSE
C     LES VALEURS SONT NI REELLES NI COMPLEXES
            IER=0
         ENDIF
C         IER=0
      ELSE IF((XOUS.EQ.'S').AND.(GENR.EQ.'N'))THEN
C     ------------------------------------------------------------------
C     CET OBJET EST SIMPLE MAIS C EST UN REPERTOIRE DE NOMS
C     ------------------------------------------------------------------
         IER=0
      ENDIF

 999  CONTINUE
      CALL JEDEMA()
      END
