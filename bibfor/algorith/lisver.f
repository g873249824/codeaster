      SUBROUTINE LISVER(LISCHA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*19 LISCHA
C
C ----------------------------------------------------------------------
C
C ROUTINE UTILITAIRE (LISTE_CHARGES)
C
C VERIFICATIONS DIVERSES SUR LES TYPES DE CHARGES
C
C ----------------------------------------------------------------------
C
C
C IN  LISCHA : SD LISTE DES CHARGES
C
C
C
C
      INTEGER      ICHAR,NBCHAR
      CHARACTER*8  CHARGE
      INTEGER      CODCHA
      CHARACTER*16 TYPAPP
      LOGICAL      LISICO,LELIM,LDUAL,LEVOC
      LOGICAL      LISCFT,LFONT
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- NOMBRE DE CHARGES
C
      CALL LISNNB(LISCHA,NBCHAR)
      IF (NBCHAR.EQ.0) GOTO 999
C
C --- BOUCLE SUR LES CHARGES
C
      DO 10 ICHAR = 1,NBCHAR
C
C ----- NOM DE LA CHARGE
C
        CALL LISLCH(LISCHA,ICHAR ,CHARGE)
C
C ----- CODE DU GENRE DE LA CHARGE
C
        CALL LISLCO(LISCHA,ICHAR ,CODCHA)
C
C ----- IDENTIFICATION DES GENRES ACTIFS DANS LA CHARGE
C
        LELIM  = LISICO('DIRI_ELIM',CODCHA)
        LDUAL  = LISICO('DIRI_DUAL',CODCHA)
        LEVOC  = LISICO('EVOL_CHAR',CODCHA)
C
C ----- TYPE D'APPLICATION DE LA CHARGE
C
        CALL LISLTA(LISCHA,ICHAR ,TYPAPP)
C
C ----- RESTRICTIONS SUR AFFE_CHAR_CINE
C
        IF (LELIM) THEN
          IF (TYPAPP.EQ.'SUIV') THEN
            CALL U2MESK('F','CHARGES5_7',1,CHARGE)
          ENDIF
          IF (TYPAPP.EQ.'DIDI') THEN
            CALL U2MESK('F','CHARGES5_8',1,CHARGE)
          ENDIF
          IF (TYPAPP.EQ.'FIXE_PILO') THEN
            CALL U2MESK('F','CHARGES5_9',1,CHARGE)
          ENDIF
        ENDIF
C
C ----- RESTRICTIONS SUR AFFE_CHAR_MECA/DIRICHLET
C
        IF (LDUAL) THEN
          IF (TYPAPP.EQ.'SUIV') THEN
            CALL U2MESK('F','CHARGES5_10',1,CHARGE)
          ENDIF
        ENDIF
C
C ----- RESTRICTIONS SUR EVOL_CHAR
C
        IF (LEVOC) THEN
          IF (TYPAPP.EQ.'FIXE_PILO') THEN
            CALL U2MESK('F','CHARGES5_11',1,CHARGE)
          ENDIF
        ENDIF
C
C ----- PAS DE FONCTION DU TEMPS AVEC CHARGES PILOTEES
C
        IF (TYPAPP.EQ.'FIXE_PILO') THEN
          LFONT = LISCFT(LISCHA,ICHAR )
          IF (LFONT) THEN
            CALL U2MESK('F','CHARGES5_12',1,CHARGE)
          ENDIF
        ENDIF

  10  CONTINUE
C
  999 CONTINUE
C
      CALL JEDEMA()
      END
