      SUBROUTINE OPS002( ICMD , ICOND, IER )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 28/09/2004   AUTEUR DURAND C.DURAND 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER            ICMD , ICOND, IER
C     PROCEDURE "RETOUR" PERMET DE REVENIR A L'UNITE PRECEDENTE.
C     SERT POUR L'INCLUDE NORMAL ET POUR L'INCLUDE_MATERIAU
C     ------------------------------------------------------------------
      CHARACTER*16     CBID, NOMCMD
      CHARACTER*32     NAME
      CHARACTER*8      UNITE,NOMSYM
      PARAMETER             (MXFILE=30)
      COMMON  /SUCC00/ UNITE(MXFILE), NAME(MXFILE)
      COMMON  /SUCN00/ IPASS,IFILE,JCMD
C     ------------------------------------------------------------------
C     COMMON SPECIFIQUE A L'INCLUDE_MATERIAU POUR CONSERVER LE NOM
C     DE MATERIAU DEVANT PREFIXER LES CONCEPTS INCLUS DANS LE FICHIER
      CHARACTER*8 PRFXCO
      INTEGER     LPRFXC
      COMMON /INCMAT/ PRFXCO  
      COMMON /INCMAI/ LPRFXC  
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
      IF (ICOND .EQ. 1 ) THEN
C     --- DESACTIVATION DU PREFIXE CONCEPT
        PRFXCO='?'
        LPRFXC=1
        GOTO 9999
      ENDIF

      IF (ICOND .EQ. 0 ) THEN
C     --- DESACTIVATION DU PREFIXE CONCEPT
        PRFXCO='?'
        LPRFXC=1
        GOTO 9999
      ENDIF

      IF (ICOND .NE. -1) THEN
        CALL UTMESS('E','SUPERVISEUR','ERREUR FATALE  **** '//
     +                                'APPEL A COMMANDE "SUPERVISEUR".')
        IER = 1
        GOTO 9999
      ENDIF
      CALL GETRES(CBID,CBID,NOMCMD)
      IF ( IPASS.NE.80191 .OR. (IPASS.EQ.80191 .AND. IFILE.EQ.0) ) THEN
         CALL UTMESS('E','ANALYSE SEMANTIQUE (ERREUR XX)',
     +               'LA PROCEDURE "RETOUR" NE PEUT ETRE UTILISEE '//
     +               'DANS LE FICHIER PRINCIPAL DE COMMANDES.')
         IER = 1
         GOTO 9999
      ENDIF
C
C     --- INFORMATION SUR L'UNITE COURANTE ---
      CALL LXINFU(IREAD,LREC,IWRITE,NOMSYM )
C
C     --- IMPRESSION DE LA MARQUE DE FIN ---
      IF ( IWRITE .EQ. 0 ) THEN
         IWR = IUNIFI('MESSAGE')
         IF ( IWR .GT. 0 ) THEN
            IF(NOMSYM.EQ.'INCMAT')THEN
                  WRITE(IWR,*) ' --- FIN INCLUDE_MATERIAU '
            ELSE
                  WRITE(IWR,*) ' --- FIN INCLUDE : ',
     +                      ' SUR UNITE:',IREAD
            ENDIF
         ENDIF
         WRITE(IWR,*)
      ELSE
         WRITE(IWRITE,*)
      ENDIF
C
C     --- DESACTIVATION DE L'UNITE COURANTE ---
      CALL LXUNIT( -1, 0  , 0 ,NOMSYM )
      CALL ULOPEN(-IREAD,' ',NOMSYM,' ',' ')
C     --- DESACTIVATION DU PREFIXE CONCEPT
      PRFXCO='?'
      LPRFXC=1
C
C     --- ACTIVATION DE L'UNITE PRECEDENTE (ON DEPILE) ---
      CALL LXUNIT( 0 , 0  , 0 ,UNITE(IFILE))
      IFILE = IFILE - 1
C
C     --- ANNULATION DE LA PROCEDURE ---
      CALL SMCDEL(ICMD,0,IER)
      ICMD = ICMD - 1
 9999 CONTINUE
      END
