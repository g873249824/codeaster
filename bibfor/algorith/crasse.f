      SUBROUTINE CRASSE ( )
      IMPLICIT  NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/07/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     COMMANDE:  CREA_RESU
C     CREE UNE STRUCTURE DE DONNEE DE TYPE "EVOL_THER"
C     PAR ASSEMBLAGES D'EVOL_THER EXISTANTS
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      INTEGER       IBID, IRET, NBFAC, IOCC,NBORD2,NBORD1,IORD2,IORD1
      INTEGER       KORD1,IAD,JORD1,JORD2,N1
      REAL*8        RBID,INST1,INST2,TRANS
      COMPLEX*16    CBID
      CHARACTER*8   K8B, RESU2, RESU1
      CHARACTER*16  TYPE,OPER
      CHARACTER*19  NOMCH,CHAM1,RESU19

C ----------------------------------------------------------------------
      CALL JEMARQ()


C     -- CREATION (OU NON) DE RESU2
C     -- CALCUL DE NBORD2 ET JORD2
C     --------------------------------
      CALL GETRES ( RESU2, TYPE, OPER )
      CALL GETFAC ( 'ASSE', NBFAC )

      CALL JEEXIN ( RESU2//'           .DESC', IRET )
      IF ( IRET .EQ. 0 ) THEN
        CALL RSCRSD ( RESU2, TYPE, 100 )
      ENDIF

      RESU19=RESU2
      CALL JELIRA(RESU19//'.ORDR','LONUTI',NBORD2,K8B)
      IF (NBORD2.GT.0) THEN
         CALL JEVEUO(RESU19//'.ORDR','L',JORD2)
         IORD2=ZI(JORD2-1+NBORD2)
      ELSE
         IORD2=0
      ENDIF


C       BOUCLE SUR LES OCCURRENCES DE ASSE :
C       -----------------------------------------------------------
      DO 100 IOCC = 1,NBFAC
        CALL GETVR8 ( 'ASSE', 'TRANSLATION'  , IOCC,1,1, TRANS , N1 )
        CALL GETVID ( 'ASSE', 'RESULTAT'  , IOCC,1,1, RESU1 , N1 )
        RESU19=RESU1
        CALL JELIRA(RESU19//'.ORDR','LONUTI',NBORD1,K8B)
        CALL JEVEUO(RESU19//'.ORDR','L',JORD1)


C       BOUCLE SUR LES CHAMPS 'TEMP' DE RESU1 ET RECOPIE DANS RESU2:
C       -----------------------------------------------------------
        DO 110, KORD1=1,NBORD1

C         1- RECUPERATION DU CHAMP : CHAM1
          IORD1=ZI(JORD1-1+KORD1)
          CALL RSEXCH(RESU1, 'TEMP', IORD1, CHAM1, IRET )
          CALL ASSERT (IRET.EQ.0)

C         2- STOCKAGE DE CHAM1 :
          IORD2 = IORD2 + 1
          CALL RSEXCH(RESU2, 'TEMP', IORD2, NOMCH, IRET )
          IF ( IRET .EQ. 110 )  CALL RSAGSD ( RESU2, 0 )
          CALL COPISD('CHAMP_GD','G',CHAM1,NOMCH)
          CALL RSNOCH(RESU2, 'TEMP', IORD2, ' ' )

C         3- STOCKAGE DE L'INSTANT ASSOCIE A CHAM1 :
           CALL RSADPA(RESU1,'L',1,'INST',IORD1,0,IAD,K8B)
           INST1=ZR(IAD)
           INST2=INST1+TRANS
           CALL RSADPA (RESU2,'E',1,'INST',IORD2,0,IAD,K8B)
           ZR(IAD)=INST2


 110    CONTINUE
        CALL JEDETR('&&OP0124.NUME_ORDR1')
 100  CONTINUE
      CALL JEDETR('&&OP0124.NUME_ORDR2')

      CALL JEDEMA()

      END
