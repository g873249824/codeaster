      SUBROUTINE TE0097(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 10/04/2002   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ......................................................................
C    CALCUL DES OPTIONS :
C       'MASS_ID_MDEP_R'
C       'MASS_ID_MTEM_R'
C       'MASS_ID_MDNS_R'
C       'MASS_ID_MTNS_R'
C    POUR TOUS LES TYPES D'ELEMENTS
C ......................................................................

C     REAL*8             DBLE,SQRT
      INTEGER ITAB(5),IAD,IEQ,NEQ,NVAL
      LOGICAL SYME

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      IF ((OPTION.EQ.'MASS_ID_MDEP_R') .OR.
     &    (OPTION.EQ.'MASS_ID_MTEM_R')) THEN
        SYME = .TRUE.
      ELSE IF ((OPTION.EQ.'MASS_ID_MDNS_R') .OR.
     &         (OPTION.EQ.'MASS_ID_MTNS_R')) THEN
        SYME = .FALSE.
      ELSE
        CALL UTMESS('F','TE0097','OPTION INVALIDE')
      END IF

      CALL TECACH(.TRUE.,.TRUE.,'PMATRIC',5,ITAB)

      IF (ITAB(1).LE.0) CALL UTMESS('F','TE0097','STOP 1')
      IF (ITAB(4).NE.5) CALL UTMESS('F','TE0097','STOP 2')

      IAD = ITAB(1)
      NVAL = ITAB(2)


C     CAS SYMETRIQUE REEL :
C     ----------------------
      IF (SYME) THEN
        NEQ = (NINT(SQRT(DBLE(8*NVAL+1)))-1)/2
        IF ((NEQ* (NEQ+1)/2).NE.NVAL) CALL UTMESS('F','TE0097','STOP 3')

        DO 10,IEQ = 1,NEQ
          ZR(IAD-1+IEQ* (IEQ+1)/2) = 1.D0
   10   CONTINUE


C     CAS NON-SYMETRIQUE REEL :
C     ----------------------
      ELSE
        NEQ = NINT(SQRT(DBLE(NVAL)))
        IF ((NEQ*NEQ).NE.NVAL) CALL UTMESS('F','TE0097','STOP 4')

        DO 20,IEQ = 1,NEQ
          ZR(IAD-1+ (IEQ-1)*NEQ+1) = 1.D0
   20   CONTINUE
      END IF

      END
