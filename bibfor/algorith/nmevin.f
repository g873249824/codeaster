      SUBROUTINE NMEVIN(SDDISC,RESOCO,IECHEC,IEVDAC)
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 RESOCO
      INTEGER      IECHEC,IEVDAC
      CHARACTER*19 SDDISC
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - EVENEMENTS)
C
C GESTION DE L'EVENEMENT INTERPENETRATION
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  IECHEC : OCCURRENCE DE L'ECHEC
C OUT IEVDAC : VAUT IECHEC SI EVENEMENT DECLENCHE
C                   0 SINON
C
C
C
C
      INTEGER      IFM,NIV
      INTEGER      CFDISD,NBLIAI
      INTEGER      ILIAI
      CHARACTER*24 JEUITE
      INTEGER      JJEUIT
      REAL*8       JEUFIN,PNMAXI
      LOGICAL      LEVENT
      REAL*8       PENMAX
      INTEGER      IBID
      CHARACTER*8  K8BID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... INTERPENETRATION'
      ENDIF
C
C --- INITIALISATIONS
C
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IECHEC,'PENE_MAXI',
     &            PENMAX,IBID  ,K8BID )
      IEVDAC = 0
      LEVENT = .FALSE.
      PNMAXI = 0.D0
C
C --- PARAMETRES
C
      NBLIAI = CFDISD(RESOCO,'NBLIAI')
C
C --- ACCES OBJETS DU CONTACT
C
      JEUITE = RESOCO(1:14)//'.JEUITE'
      CALL JEVEUO(JEUITE,'L',JJEUIT)
C
C --- DETECTION PENETRATION
C
      DO 10 ILIAI = 1,NBLIAI
        JEUFIN = ZR(JJEUIT+3*(ILIAI-1)+1-1)
        IF (JEUFIN.LE.0.D0) THEN
          IF (ABS(JEUFIN).GT.PENMAX) THEN
            IF (ABS(JEUFIN).GT.PNMAXI) PNMAXI = ABS(JEUFIN)
            LEVENT = .TRUE.
          ENDIF
        ENDIF
  10  CONTINUE
C
C --- ACTIVATION EVENEMENT
C
      IF (LEVENT) THEN
        IEVDAC = IECHEC
        CALL U2MESS('I','MECANONLINE6_42')
      ENDIF
C
      CALL JEDEMA()
      END
