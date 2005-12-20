      SUBROUTINE OPS001( ICMD , ICOND, IER )
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER            ICMD , ICOND, IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 03/06/2003   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
C     PROCEDURE "INCLUDE" PERMET LE DEBRANCHEMENT DE LA LECTURE
C     VERS UNE AUTRE UNITE LOGIQUE.
C     ------------------------------------------------------------------
C     ATTENTION : CETTE OPS EST A FAIRE EVOLUER EN PARALLELE 
C                 AVEC INCLUDE_MATERIAU (OPS014)
C     ------------------------------------------------------------------
      CHARACTER*16     CBID, NOMCMD
      CHARACTER*32     NAME
      CHARACTER*8      UNITE,NOMSYM
      PARAMETER             (MXFILE=30)
      COMMON  /SUCC00/ UNITE(MXFILE), NAME(MXFILE)
      COMMON  /SUCN00/ IPASS,IFILE,JCMD
C     ------------------------------------------------------------------
      IF (ICOND .NE. -1) THEN
        CALL UTMESS('E','SUPERVISEUR','ERREUR FATALE  **** '//
     +                                'APPEL A COMMANDE "SUPERVISEUR".')
        IER = 1
        GOTO 9999
      ENDIF
C
      IF ( IPASS .NE. 80191  ) THEN
         IPASS   = 80191
         IFILE   = 0
         NAME(1) = '   '
      ENDIF
C
      JCMD = ICMD
      CALL GETRES(CBID,CBID,NOMCMD)
      CALL LXINFU(IREAD,LREC,IWRITE,NOMSYM )
      IFILE = IFILE + 1
C
      IF ( IFILE .GT. MXFILE ) THEN
         CALL UTDEBM('E','ANALYSE DES COMMANDES (ERREUR 1C)',
     +                   'VOUS NE POUVEZ UTILISER PLUS DE')
         CALL UTIMPI('S',' ',1,MXFILE)
         CALL UTIMPK('S','NIVEAUX DE PROFONDEUR POUR DES APPELS PAR LA '
     +                 //'PROCEDURE',1,'CALL')
         CALL UTFINM()
         CALL UTMESS('F','SUPERVISEUR',
     +                            'ARRET DE LA LECTURE DES COMMANDES.')
      ENDIF
C
C     --- ON EMPILE LE NOM SYMBOLIQUE DE L'UNITE DE LECTURE COURANTE ---
      UNITE(IFILE) = NOMSYM
C
C     --- NOUVELLE UNITE DE LECTURE ---
      CALL GETVIS(' ','UNITE',1,1,1,IUNIT,L)
      CALL CODENT(IUNIT, 'D0',NOMSYM(7:8) )
C     --- ON IMPRIME OUI / NON  ---
C
      CALL GETVIS(' ','INFO',1,1,1,IBID,L)
      IF ( IBID .GT. 1 ) THEN
        IWRITE = IUNIFI('MESSAGE')
      ELSE
        IWRITE = 0
      ENDIF
      IF (IWRITE.GT.0) WRITE(IWRITE,*)
C
C     --- DEFINITION DE LA NOUVELLE UNITE LOGIQUE ---
      CALL LXUNIT(IUNIT,LREC,IWRITE,NOMSYM )
C
C     --- ANNULATION DE LA PROCEDURE ---
      CALL SMCDEL(ICMD,0,IER)
      ICMD = ICMD - 1
 9999 CONTINUE
      END
