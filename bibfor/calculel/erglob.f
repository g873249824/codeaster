      SUBROUTINE ERGLOB (CHELER,YATHM ,PERMAN,OPTION,IORD,
     &                   TIME  ,RESUCO,RESUC1)
      IMPLICIT NONE
      INTEGER       IORD
      REAL*8        TIME
      CHARACTER*(*) RESUCO
      CHARACTER*19  RESUC1
      CHARACTER*(*) CHELER,OPTION
      LOGICAL       YATHM,PERMAN
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 07/12/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C =====================================================================
C ERREUR GLOBALE AU MAILLAGE
C **     ****
C =====================================================================
C     BUT:
C         CALCULER LES ESTIMATEURS GLOBAUX A PARTIR DES ESTIMATEURS
C         LOCAUX CONTENUS DANS CHELER.
C
C     ARGUMENTS:
C     ----------
C
C      ENTREE :
C-------------
C IN   CHELER : NOM DU CHAM_ELEM ERREUR
C IN   YATHM  : MODELISATION THM ?
C IN   PERMAN : MODELISATION THM PERMANENTE ?
C IN   OPTION :    'ERZ1_ELEM_SIGM' OU 'ERZ2_ELEM_SIGM'
C               OU 'QIZ1_ELEM_SIGM' OU 'QIZ2_ELEM_SIGM'
C               OU 'ERME_ELEM' OU 'QIRE_ELEM_SIGM'
C IN   IORD   : NUMERO D'ORDRE
C IN   TIME   : INSTANT DE CALCUL
C IN   RESUCO : NOM DU CONCEPT ENTRANT
C IN   RESUC1 : NOM DU CONCEPT RESULTAT DE LA COMMANDE CALC_ELEM
C
C      SORTIE :
C-------------
C
C ......................................................................

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX  --------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER NBGREL,DIGDEL,IBID,LONGT,LONG2,MODE,J,IAVALE,ICOEF,NBGR,
     &        JCELD,IACELK
      CHARACTER*4 DOCU
      CHARACTER*19 CHELE2,LIGREL
      LOGICAL FIRST
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C=================
C 1. VERIFICATIONS
C=================
      CHELE2 = CHELER(1:19)

C 1.1. ON VERIFIE QUE CHELE2 A UN NOMBRE DE COMPOSANTES CONSTANT
C    PAR ELEMENT

      CALL CELVER(CHELE2,'NBVARI_CST','STOP',IBID)

C 1.2. ON VERIFIE QUE LE CHAM_ELEM N'A QU'UN SOUS-POINT

      CALL CELVER(CHELE2,'NBSPT_1','STOP',IBID)

      CALL JELIRA (CHELE2//'.CELD','DOCU',IBID,DOCU)
      IF( DOCU.NE.'CHML' ) THEN
        CALL U2MESS('F','CALCULEL5_44')
      ENDIF

C 1.3. ON RETROUVE LE NOM DU LIGREL

      CALL JEVEUO (CHELE2//'.CELK','L',IACELK)
      LIGREL = ZK24(IACELK-1+1)(1:19)
      CALL JEVEUO (CHELE2//'.CELD','L',JCELD)

C 1.4. ON VERIFIE LA LONGUEUR DES CHAMPS LOCAUX POUR L'OPTION

      FIRST = .TRUE.
      NBGR  = NBGREL(LIGREL)

      DO 10 ,J = 1,NBGR
        MODE=ZI(JCELD-1+ZI(JCELD-1+4+J)+2)
        IF (MODE.EQ.0) GOTO 10
        LONG2 = DIGDEL(MODE)
        ICOEF=MAX(1,ZI(JCELD-1+4))
        LONG2 = LONG2 * ICOEF
        IF (FIRST) THEN
          LONGT = LONG2
          FIRST = .FALSE.
        ELSE
          IF (LONGT.NE.LONG2) THEN
            CALL U2MESS('F','CALCULEL3_54')
          ENDIF
        ENDIF
 10   CONTINUE

C==================================
C 2. CALCUL DES INDICATEURS GLOBAUX
C==================================

      CALL JEVEUO (CHELE2//'.CELV','E',IAVALE)
      IF (YATHM) THEN
        CALL ERGLHM(PERMAN,JCELD,IAVALE,IORD,LIGREL,
     &              LONGT ,NBGR ,RESUC1)
      ELSE
        CALL ERGLME(JCELD,IAVALE,OPTION,IORD,LIGREL,LONGT,NBGR,
     &              TIME ,RESUCO,RESUC1)
      ENDIF
C
      CALL JEDEMA()
C
      END
