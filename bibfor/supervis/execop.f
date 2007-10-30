      SUBROUTINE EXECOP( ICMD  , ICOND , IERTOT, IER , IFIN  )
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER            ICMD  , ICOND , IERTOT, IER , IFIN
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 29/10/2007   AUTEUR PELLET J.PELLET 
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
C     EXECUTION DE LA COMMANDE NUMERO : ICMD
C     ------------------------------------------------------------------
C IN  ICMD   : IS : NUMERO D'ORDRE DE LA COMMANDE A EXECUTER
C IN  ICOND  : IS : CONDITIONS DE FONCTIONNEMENT DES OPERATEURS
C           0  EXECUTION DE L'OPERATEURS
C           1  VERIFICATION SUPPLEMENTAIRES
C IN  IERTOT : IS : NOMBRE D'ERREURS TOTALES DEJA RENCONTREES
C     IER  IS : NOMBRE D'ERREURS RENCONTREES DANS LA COMMANDE COURANTE
C OUT IFIN   : IS : INDICATEUR D'EXECUTION DE LA COMMANDE FIN
C           0  EXECUTION D'UN OPERATEUR AUTRE QUE FIN
C           1  EXECUTION DE L'OPERATEUR FIN
C     ------------------------------------------------------------------
C     COMMON POUR LE NIVEAU D'"INFO"
      INTEGER         NIVUTI,NIVPGM,UNITE
      COMMON /INF001/ NIVUTI,NIVPGM,UNITE

C     COMMON POUR LA DETECTION D'UNE SORTIE EN ERREUR SI PAS PAR_LOT
      INTEGER     IERLOT
      COMMON  /CERRLO/ IERLOT


      INTEGER    NUOPER,IUNERR,IUNRES,IUNIFI,NUOP2,IBID
      REAL*8      TPS1(4),TPRES
      CHARACTER*6  NOMMAR
      CHARACTER*8  CMDUSR,K8BID
C     ------------------------------------------------------------------

      CALL GCECDU(NUOPER)

      NOMMAR = 'OP'
      CALL CODENT(NUOPER,'D0',NOMMAR )

      IER = 0
      IF ( NUOPER.EQ.9999 ) THEN
         IF (IERLOT .NE. 0) THEN
            IERTOT = IERLOT
            CALL GCECCO( 'SUPERVISEUR', 0, 'I', ' ' )
            CALL U2MESS('F','SUPERVIS_2')
         ENDIF
      CALL OP9999( ICOND , IERTOT , IFIN )
      ENDIF

C     -- ON NOTE LA MARQUE AVANT D'APPELER LA PROCHAINE COMMANDE :
      CALL JEVEMA(IMAAV)

C     -- ON REMET A "ZERO" LES COMMONS UTILISES PAR FOINTE :
      CALL FOINT0()

C     -- ON REMET A "ZERO" LES COMMONS UTILISES PAR FODERI :
      CALL FODER0()

C     -- ON MET A JOUR LE COMMON INF001 :
      NIVUTI = 1
      NIVPGM = 1
      UNITE  = IUNIFI('MESSAGE')

      IF ( NUOPER .LT. 0 ) THEN
        NUOP2 = ABS(NUOPER)
        CALL OPSEXE(ICMD,ICOND,NUOP2,CMDUSR,IER)
      ELSEIF (( NUOPER.LT. 100 ).AND.(ICOND.EQ.0)) THEN
        CALL EX0000(NUOPER,IER)
      ELSEIF (( NUOPER.LT. 200 ).AND.(ICOND.EQ.0)) THEN
        CALL EX0100(NUOPER,IER)
      ELSEIF (( NUOPER.NE.9999 ).AND.(ICOND.EQ.0))  THEN
        IER = 1
        CALL U2MESG('E','SUPERVIS_61',0,' ',1,NUOPER,0,0.D0)
      ENDIF

      CALL UTTRST(TPRES)
      IF (ICOND.EQ.0 .AND. TPRES .LT. 0.D0) THEN
        CALL UTEXCM(28,'SUPERVIS_63',0,K8BID,0,IBID,1,-TPRES)
      ENDIF

C     -- CONTROLE DE L'APPARIEMMENT DES JEMARQ/JEDEMA
      CALL JEVEMA(IMAAP)
      IF (IMAAV.NE.IMAAP) CALL U2MESS('F','SUPERVIS_3')


C     --LIBERATION DES OBJETS RAMENES EN MEMOIRE PAR JEVEUT :
      CALL JELIBZ ( 'G' )

      IF ( IER .NE. 0 ) THEN
         IF ( ICOND .EQ. 1 ) THEN
            CALL U2MESS('I','SUPERVIS_62')
            CALL GCECDU(NUOPER)
         ENDIF
      ENDIF

C     -- DESTRUCTION DES OBJETS DE LA BASE VOLATILE :
      IF (ICOND .EQ. 0)  THEN
         CALL JEDETV()
         CALL JERECU('G')
      ENDIF

 9999 CONTINUE
      END
