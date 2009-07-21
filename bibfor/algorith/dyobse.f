      SUBROUTINE DYOBSE(MAILLA,RESULT,NBPAS,SDDISC,NUMINI,
     &                  SDOBSE,SDSUIV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/07/2009   AUTEUR GENIAUT S.GENIAUT 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      INTEGER       NBPAS,NUMINI
      CHARACTER*8   RESULT,MAILLA
      CHARACTER*19  SDDISC
      CHARACTER*24  SDSUIV
      CHARACTER*14  SDOBSE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (OBSERVATION)
C
C SAISIE DU MOT CLE FACTEUR "OBSERVATION"
C
C ----------------------------------------------------------------------
C
C  _CETTE ROUTINE EST UNE DUPLICATION DE DYARCH_
C
C IN  NBPAS  : NOMBRE DE PAS DE CALCUL
C IN  SDDISC : SD LOCALE SUR LA GESTION DE LA LISTE D'INSTANTS
C IN  MAILLA : NOM DU MAILLAGE 
C IN  NUMINI : NUMERO PREMIER INSTANT DE CALCUL
C IN  RESULT : NOM UTILISATEUR DU RESULTAT
C OUT SDSUIV : NOM DE LA SD POUR SUIVI DDL
C OUT SDOBSE : NOM DE LA SD POUR OBSERVATION
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
      INTEGER      IFM,NIV
      INTEGER      NBOCC,NTOBS,I,KCHAM,NBOBSE
      INTEGER      KCOMP,KNUCM,KNOEU,KMAIL,KPOIN,NBSUIV,JSDDL
      INTEGER      JSUIMA,JSUINB
      CHARACTER*4  CH4
      CHARACTER*16 MOTFAC
      CHARACTER*19 LISOBS,INFOBS
      INTEGER      JOBSE ,JOBSI     
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
C
C --- INITIALISATIONS
C
      NBOBSE = 0
      MOTFAC = 'OBSERVATION'
      CALL GETFAC(MOTFAC,NBOCC)
C
C --- ACCES SD
C      
      LISOBS = SDOBSE(1:14)//'.LIST' 
      INFOBS = SDOBSE(1:14)//'.INFO' 
      CALL JEVEUO(LISOBS,'E',JOBSE)
      CALL JEVEUO(INFOBS,'E',JOBSI)      
C
      IF (NBOCC.EQ.0) THEN
        CALL WKVECT(SDSUIV(1:14)//'.NBSUIV','V V I'  ,1    ,JSUINB)
        CALL WKVECT(SDSUIV(1:14)//'.MAILLA','V V K8' ,1    ,JSUIMA)
        ZK8(JSUIMA)= MAILLA
        ZI(JSUINB) = 0
        GOTO 999
      ENDIF
C
C --- VERIFICATION DES DONNEES ET COMPTAGE DES FONCTIONS 
C
      CALL WKVECT('&&DYOBSE.SUIVI_DDL','V V L',NBOCC,JSDDL)
      CALL DYOBS1(MOTFAC,MAILLA,NBOCC,ZL(JSDDL),NTOBS,
     &            NBSUIV)
C 
C --- SAISIE DES DONNEES
C 
      CALL DYOBS2(MOTFAC,MAILLA,NBOCC ,ZL(JSDDL),NTOBS ,
     &            NBSUIV,SDOBSE,SDSUIV)
C 
C --- TRAITEMENT DES INSTANTS
C 
      CALL DYOBS3(MOTFAC,NBOCC ,NBPAS,ZL(JSDDL),ZI(JOBSE),
     &            SDDISC,NBOBSE)
      IF (NBOBSE.EQ.0) THEN 
        GOTO 999
      ENDIF
C 
C --- CREATION DE LA TABLE D'OBSERVATION
C
      CALL DYOBS4(RESULT,SDOBSE)
C 
C --- REMPLISSAGE SD
C          
      ZI(JOBSI+1-1) = NBOBSE
      ZI(JOBSI+2-1) = NTOBS
      ZI(JOBSI+3-1) = 0
      ZI(JOBSI+4-1) = NUMINI
      ZI(JOBSI+5-1) = 0
      ZI(JOBSI+6-1) = 0              
C
C --- AFFICHAGE DES INFOS STOCKEES DANS LA TABLE D'OBSERVATION
C
      CALL JEVEUO(SDOBSE(1:14)//'.NOM_CHAM','L',KCHAM)
      CALL JEVEUO(SDOBSE(1:14)//'.NOM_CMP ','L',KCOMP)
      CALL JEVEUO(SDOBSE(1:14)//'.NUME_CMP','L',KNUCM)
      CALL JEVEUO(SDOBSE(1:14)//'.NOEUD','L',KNOEU)
      CALL JEVEUO(SDOBSE(1:14)//'.MAILLE','L',KMAIL)
      CALL JEVEUO(SDOBSE(1:14)//'.POINT','L',KPOIN)
      WRITE (IFM,1000)
      DO 10 I = 0,NTOBS - 1
        IF (ZI(KPOIN+I).EQ.0) THEN
          CH4 = '    '
        ELSE
          CALL CODENT(ZI(KPOIN+I),'D',CH4)
        END IF
        WRITE (IFM,1010) ZK16(KCHAM+I),ZK8(KCOMP+I),ZK8(KNOEU+I),
     &    ZK8(KMAIL+I),CH4
   10 CONTINUE
C
      CALL JEDETR('&&DYOBSE.SUIVI_DDL')
C
C ----------------------------------------------------------------------
C
 1000 FORMAT (/,'=> OBSERVATION:',/,5X,
     &       'NOM_CHAM        NOM_CMP     NOEUD     MAILLE    POINT')
 1010 FORMAT (1X,A16,3X,A8,3X,A8,3X,A8,4X,A4)
C
  999 CONTINUE
      CALL JEDEMA()

      END
