      SUBROUTINE NMEXTK(NOMA  ,MOTFAC,IOCC  ,CHAMP ,NOMCHA,
     &                  TYPCHA,LISTNO,LISTMA,LISTPI,LISTSP,
     &                  NBNO  ,NBMA  ,NBPI  ,NBSPI ,LISTCP,
     &                  NBCMP )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/01/2011   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT      NONE
      CHARACTER*8   NOMA
      CHARACTER*16  MOTFAC
      INTEGER       IOCC
      CHARACTER*4   TYPCHA
      INTEGER       NBNO,NBMA,NBCMP
      CHARACTER*16  NOMCHA
      CHARACTER*19  CHAMP
      CHARACTER*24  LISTPI,LISTSP
      INTEGER       NBPI,NBSPI
      CHARACTER*24  LISTCP,LISTNO,LISTMA
C
C ----------------------------------------------------------------------
C
C ROUTINE *_NON_LINE (EXTRACTION - LECTURE)
C
C LECTURE COMPOSANTE DU CHAMP
C
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  MOTFAC : MOT-FACTEUR POUR LIRE
C IN  IOCC   : OCCURRENCE DU MOT-CLEF FACTEUR MOTFAC
C IN  NOMCHA : NOM DU CHAMP
C IN  TYPCHA : TYPE DU CHAMP 'NOEU' OU 'ELGA'
C IN  LISTNO : LISTE CONTENANT LES NOEUDS
C IN  LISTMA : LISTE CONTENANT LES MAILLES
C IN  NBNO   : LONGUEUR DE LA LISTE DES NOEUDS
C IN  NBMA   : LONGUEUR DE LA LISTE DES MAILLES
C IN  CHAMP  : CHAMP EXEMPLE POUR VERIF COMPOSANTE
C IN  LISTPI : LISTE CONTENANT LES POINTS D'EXTRACTION
C IN  LISTSP : LISTE CONTENANT LES SOUS-POINTS D'EXTRACTION
C OUT LISTCP : LISTE DES COMPOSANTES
C OUT NBCMP  : NOMBRE DE COMPOSANTES
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      CHARACTER*32 JEXNUM
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
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      NPARX
      PARAMETER    (NPARX=20)
      CHARACTER*8  K8BID
      INTEGER      N1
      INTEGER      IRET
      INTEGER      JCMP,JNO,JMA,JPI,JSPI
      INTEGER      INO,IMA,ICMP,IPI,ISPI
      INTEGER      NUNO,NUDDL
      INTEGER      NMAPT,NMASPT,NPI,NSPI
      INTEGER      NUMNOE,NUMMAI,NUM,SNUM
      CHARACTER*8  NOMNOE,NOMMAI,NOMCMP
      CHARACTER*8  NOMVAR
      INTEGER      IVARI
      CHARACTER*16 VALK(2)
      CHARACTER*19 CHELES
      INTEGER      JCESD
      INTEGER      VALI(4)
      REAL*8       R8BID
      COMPLEX*16   C16BID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C      
      CHELES = '&&NMEXTP.CHEL.TRAV' 
      NBCMP  = 0
C
C --- CONVERSION EN CHAM_ELEM_S
C
      IF (TYPCHA.EQ.'ELGA') THEN
        CALL SDMPIC('CHAM_ELEM',CHAMP )
        CALL CELCES(CHAMP ,'V',CHELES)
        CALL JEVEUO(CHELES(1:19)//'.CESD','L',JCESD)
      ENDIF  
C     
C --- LECTURE DES COMPOSANTES : IL FAUT AU MOINS UNE COMPOSANTE MAIS
C --- MOINS DE NPARX
C
      CALL GETVTX(MOTFAC,'NOM_CMP' ,IOCC  ,1     ,0     ,
     &            K8BID ,N1     )
      NBCMP  = -N1
      IF ((NBCMP.LT.1).OR.(NBCMP.GT.NPARX)) THEN
        VALI(1) = NPARX
        VALI(2) = NBCMP
        CALL U2MESI('F','EXTRACTION_12',2,VALI)
      ENDIF
C
C --- LECTURE EFFECTIVE
C
      CALL WKVECT(LISTCP,'V V K8',NBCMP ,JCMP  )    
      CALL GETVTX(MOTFAC,'NOM_CMP',IOCC,1,NBCMP,ZK8(JCMP),IRET)
C
C --- VERIFICATION QUE LES NOEUDS SUPPORTENT LES COMPOSANTES FOURNIES
C
      IF (TYPCHA.EQ.'NOEU') THEN
        CALL JEVEUO(LISTNO,'L',JNO)
        DO 20 INO = 1,NBNO
          NUMNOE  = ZI(JNO-1+INO)
          CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMNOE',NUMNOE),NOMNOE)
          DO 21 ICMP = 1,NBCMP
            NOMCMP = ZK8(JCMP-1+ICMP)
            CALL POSDDL('CHAM_NO',CHAMP ,NOMNOE,NOMCMP,NUNO,NUDDL)
            IF ((NUNO.EQ.0).OR.(NUDDL.EQ.0)) THEN
              VALK(1) = NOMNOE
              VALK(2) = NOMCMP
              CALL U2MESK('F', 'EXTRACTION_20',2,VALK)
            ENDIF
  21      CONTINUE
  20    CONTINUE
C
C --- VERIFICATION QUE LES ELEMENTS SUPPORTENT LES COMPOSANTES FOURNIES
C  
      ELSEIF (TYPCHA.EQ.'ELGA') THEN
        CALL JEVEUO(LISTMA,'L',JMA)
        CALL JEVEUO(LISTPI,'L',JPI)
        CALL JEVEUO(LISTSP,'L',JSPI)        
        DO 30 IMA = 1,NBMA
C        
C ------- PROPRIETES DE LA MAILLE
C
          NUMMAI = ZI(JMA-1+IMA)
          CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMMAI',NUMMAI),NOMMAI)
C
C ------- NOMBRE EFFECTIF DE POINTS/SOUS-POINTS SUR LA MAILLE
C
          NMAPT  = ZI(JCESD+5+4*(IMA-1))
          NMASPT = ZI(JCESD+5+4*(IMA-1)+1)
C
C ------- PLAFONNEMENT
C
          NPI    = NBPI
          NSPI   = NBSPI
          IF (NPI.GT.NMAPT)   NPI  = NMAPT
          IF (NSPI.GT.NMASPT) NSPI = NMASPT
C
          DO 31 ICMP = 1,NBCMP
            NOMCMP = ZK8(JCMP-1+ICMP)
            IF (NOMCHA(1:4).EQ.'VARI') THEN
              NOMVAR = NOMCMP(2:8)//' '
              CALL LXLIIS(NOMVAR,IVARI ,IRET )
            ELSE 
              IVARI  = 0
            ENDIF  
            DO 45 IPI = 1,NPI
              NUM     = ZI(JPI-1+IPI )
              CALL ASSERT(NUM.NE.0)
              DO 46 ISPI = 1,NSPI
                SNUM   = ZI(JSPI-1+ISPI ) 
                CALL ASSERT(SNUM.NE.0)
                CALL UTCH19(CHAMP ,NOMA  ,NOMMAI,' '   ,NUM   ,
     &                      SNUM  ,IVARI ,NOMCMP,'R'   ,R8BID ,
     &                      C16BID,IRET  )
                IF (IRET.EQ.1) THEN
                  VALK(1) = NOMMAI
                  VALK(2) = NOMCMP
                  VALI(1) = NUM
                  VALI(2) = SNUM
                  CALL U2MESG('F','EXTRACTION_21',2,VALK,
     &                                            2,VALI,
     &                                            0,0.D0)
                ENDIF
  46          CONTINUE 
  45        CONTINUE      
  31      CONTINUE
  30    CONTINUE  
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C      
      CALL JEDETR(CHELES)
      CALL JEDEMA()
C
      END
