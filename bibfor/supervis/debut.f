      SUBROUTINE DEBUT  ( LOT,IPASS,IER )
      IMPLICIT NONE
      LOGICAL             LOT
      INTEGER                 IER,IPASS
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 22/02/2005   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
C TOLE CRP_7
C    DECODAGE DE LA COMMANDE DEBUT OU POURSUITE
C     ------------------------------------------------------------------
C     ROUTINE(S) UTILISEE(S) :
C        IBBASE  IBCATA
C     ------------------------------------------------------------------
C
      INTEGER    MXCMD
      PARAMETER (MXCMD = 500 )
      CHARACTER*8 CBID
      CHARACTER*16 NOMCMD
      CHARACTER*80 FICHDF
      INTEGER IERIMP,ISTAT,ICMD
      REAL*8  XTT
C
      IER    = 0
      IF(IPASS .NE. 1) GOTO 9999
         CALL IBIMPR( IERIMP )
         CALL PRINIT( -1, 0 )
         CALL PRENTE
         CALL UTINIT( 2 , 80 , 1 )
         CALL JVINIT( 2 , 80 , 1 )
C     --- LECTURE DU MOT CLE FACTEUR DEBUG OU DE GESTION MEMOIRE DEMANDE
      CALL IBDBGS()
C
C     --- LECTURE DU MOT CLE HDF ---
C
      IF ( IER .EQ. 0 ) CALL IBFHDF( IER , FICHDF )
C
C     --- LECTURE DU MOT CLE FACTEUR BASE ET ---
C     --- ALLOCATION DES BASES DE DONNEES ---
      IF ( IER .EQ. 0 ) CALL IBBASE( IER , FICHDF )
      IF ( IER. EQ. 0 ) THEN
         CALL GETRES(CBID,CBID,NOMCMD)
C        -- INITIALISATION DE LA FONCTION NULLE : '&FOZERO'
         CALL FOZERO('&FOZERO')
      ENDIF
C
C     --- INITIALISATION DE LA TABLE DES CONCEPTS ---
      CALL GCUINI( MXCMD , 'G' , IER )
C   -- STATS SUR LA COMMANDE DE DEMARRAGE --
      ISTAT = 1
      IF ( IER .EQ. 0 ) CALL EXSTAT( ISTAT, 0, XTT )
C
C     --- LECTURE DU MOT CLE FACTEUR CODE ---
      IF ( IER .EQ. 0 .AND. FICHDF .EQ. '  ') CALL IBCODE( IER )
C
C     --- LECTURE DU MOT CLE FACTEUR  CATALOGUE ---
      IF ( IER .EQ. 0 .AND. FICHDF .EQ. '  ') CALL IBCATA( IER )
C
C     --- LECTURE DU MOT CLE SIMPLE PAR LOT  ---
      IF ( IER .EQ. 0 ) CALL IBTLOT( LOT, IER )
C
C
C     --- STATS SUR LA COMMANDE DE DEMARRAGE  ---
      ISTAT = 2
      IF ( IER .EQ. 0 ) CALL EXSTAT( ISTAT, 0, XTT )
C
      IF ( IER .EQ. 0 ) CALL GCUOPR( 1, ICMD )
 9999 CONTINUE
      END
