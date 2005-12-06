      SUBROUTINE IBTCPU ( IER )
      IMPLICIT NONE
      INTEGER             IER
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 23/05/2005   AUTEUR D6BHHJP J.P.LEFEBVRE 
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
C     OPTION DE MODIFICATION DE LA LIMITE DE TEMPS CPU POUR CONSERVER 
C     UNE MARGE SUFFISANTE AFIN DE TERMINER PROPREMENT UNE EXECUTION
C     ------------------------------------------------------------------
C            0 TOUT C'EST BIEN PASSE
C            1 ERREUR DANS LA LECTURE DE LA COMMANDE
C     ------------------------------------------------------------------
C
      INTEGER L1,L2,L3,LCPU,NTPMAX,IBORNE,ITPMAX
      REAL*8  PCCPU,TPMAX
      CHARACTER*16 CBID,NOMCMD
C
      IER = 0 
      NTPMAX = 0
      TPMAX = 0.D0
C     RECUPERATION DU TEMPS LIMITE DE L'EXECUTION       
      CALL UTTLIM ( TPMAX )
      ITPMAX = TPMAX
C      
      CALL GETVIS('RESERVE_CPU','VALE',1,1,1,LCPU,L1)
      CALL GETVIS('RESERVE_CPU','BORNE',1,1,1,IBORNE,L3)
      IF ( L1 .GT. 0 ) THEN
        LCPU = MIN ( IBORNE , LCPU )
        IF ( LCPU .GT. TPMAX ) THEN
          CALL GETRES(CBID,CBID,NOMCMD)
          CALL UTMESS ('F',NOMCMD,'VALEUR INVALIDE POUR LE MOT CLE'
     &                 //'RESERVE_CPU')
          IER = 1
        ENDIF
        NTPMAX = TPMAX-LCPU
        CALL UTCLIM ( ITPMAX-NTPMAX )
      ENDIF
C      
      CALL GETVR8('RESERVE_CPU','POURCENTAGE',1,1,1,PCCPU,L2)
      IF ( L2 .GT. 0 ) THEN
        NTPMAX = MAX ( TPMAX*(1-PCCPU) , TPMAX-IBORNE )
        CALL UTCLIM ( ITPMAX-NTPMAX )
      ENDIF
C      
C     IMPRESSION D'UN MESSAGE D'INFORMATION  
C     
      IF ( L1 .GT. 0 .OR. L2 .GT. 0 ) THEN
        CALL UTDEBM ('I',' ','VALEUR INITIALE DU TEMPS CPU MAXIMUM = ') 
        CALL UTIMPI ('S',' ',1,ITPMAX)
        CALL UTIMPK ('S','SECONDES ',0,' ')
        CALL UTFINM () 
        CALL UTDEBM ('I',' ','VALEUR DU TEMPS CPU MAXIMUM PASSEE AUX'
     &             //' COMMANDES = ') 
        CALL UTIMPI ('S',' ',1,NTPMAX)
        CALL UTIMPK ('S','SECONDES ',0,' ')
        CALL UTFINM () 
      ENDIF
C      
      END
