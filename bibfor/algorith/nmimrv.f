      SUBROUTINE NMIMRV(SDIMPR,INSTAN,NEWITE,FETITE,CTCITE,
     &                  DEBORS,RELCOE,RELITE,ETA   ,CTCNOE,
     &                  CTCVAL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/07/2011   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT     NONE
      CHARACTER*24 SDIMPR
      REAL*8       INSTAN,RELCOE,ETA,CTCVAL
      INTEGER      NEWITE,RELITE,FETITE,CTCITE
      CHARACTER*16 DEBORS,CTCNOE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - CONVERGENCE)
C
C ENREGISTRE LES DONNEES DANS LA SDIMPR
C LES DONNES POUR LES RESIDUS SONT ECRITS DANS NMIMRE
C
C ----------------------------------------------------------------------
C
C
C IN  SDIMPR : SD AFFICHAGE
C IN  INSTAN : VALEUR DE L'INSTANT DE CALCUL
C IN  NEWITE : NB ITER. NEWTON
C IN  FETITE : NB ITER. FETI
C IN  CTCITE : NB ITER. CONTACT DISCRET
C IN  DEBORS : CHAINE ITERATION DE BORST
C IN  RELCOE : VALEUR COEF. RECHERCHE LINEAIRE
C IN  RELITE : NB ITER. RECHERCHE LINEAIRE
C IN  ETA    : VALEUR COEF. PILOTAGE
C IN  CTCNOE : ENDROIT POUR MAX GEOMETRIE 
C IN  CTCVAL : VALEUR DU MAX GEOMETRIE
C
C ----------------------------------------------------------------------
C
      CHARACTER*16 K16BLA
      INTEGER      IBID
      REAL*8       R8BID
C
C ----------------------------------------------------------------------
C

C
C --- INITIALISATIONS
C
      K16BLA = ' '
C
C --- ECRITURE INSTANT
C
      CALL IMPSDR(SDIMPR,'INCR_INST',K16BLA,INSTAN,IBID  )
C
C --- ECRITURE NUMERO ITERATION NEWTON
C
      CALL IMPSDR(SDIMPR,'ITER_NUME',K16BLA,R8BID ,NEWITE)
C
C --- ECRITURE CRITERES RECHERCHE LINEAIRE
C
      CALL IMPSDR(SDIMPR,'RELI_NBIT',K16BLA,R8BID ,RELITE)
      CALL IMPSDR(SDIMPR,'RELI_COEF',K16BLA,RELCOE,IBID  )
C
C --- ECRITURE CRITERES PILOTAGE
C
      CALL IMPSDR(SDIMPR,'PILO_COEF',K16BLA,ETA   ,IBID  )
C
C --- ECRITURE NUMERO ITERATION FETI
C
      CALL IMPSDR(SDIMPR,'FETI_NBIT',K16BLA,R8BID ,FETITE)
C
C --- ECRITURE CONTACT DISCRET
C
      CALL IMPSDR(SDIMPR,'CTCD_NBIT',K16BLA,R8BID ,CTCITE)
C
C --- ECRITURE DE BORST
C
      CALL IMPSDR(SDIMPR,'DEBORST  ',DEBORS,R8BID ,IBID  )
C
C --- ECRITURE REAC_GEOM CONTACT
C
      CALL IMPSDR(SDIMPR,'BOUC_NOEU',CTCNOE,R8BID ,IBID  )
      CALL IMPSDR(SDIMPR,'BOUC_VALE',K16BLA,CTCVAL,IBID  )
      END
