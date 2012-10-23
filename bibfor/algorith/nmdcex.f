      SUBROUTINE NMDCEX(SDDISC,INSREF,DURDEC,IEVDAC,DELTAC,
     &                  RETDEX)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/10/2012   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*19 SDDISC
      INTEGER      IEVDAC,RETDEX
      REAL*8       DURDEC,INSREF,DELTAC
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
C
C EXTENSION DE LA DECOUPE AUX INSTANTS SUIVANTS - MANUEL
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  INSREF : INSTANT AU-DELA DUQUEL ON ETEND LA DECOUPE
C IN  DURDEC : DUREEE DE L'EXTENSION DE LA DECOUPE
C IN  DELTAC : INCREMENT DE TEMPS CIBLE
C IN  IEVDAC : INDICE DE L'EVENEMENT ACTIF
C OUT RETDEC : CODE RETOUR DECOUPE
C     0 - ECHEC DE LA DECOUPE
C     1 - ON A DECOUPE
C     2 - PAS DE DECOUPE
C
C
C
C
      INTEGER      NUMINS
      LOGICAL      LSTOP
      REAL*8       DIINST,INSTAM,INSTAP,DELTAT,INSFIN
      REAL*8       DTMIN,RATIO
      REAL*8       VALR(2)
      INTEGER      NBRPAS
      LOGICAL      LDECO
      CHARACTER*4  TYPDEC
      CHARACTER*24 NOMLIS
      CHARACTER*16 OPTDEC
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      OPTDEC = ' '
      LDECO  = .FALSE.
      NBRPAS = -1
      TYPDEC = 'DELT'
      RATIO  = 1.D0
      NOMLIS = '&&NMDCEX.NOMLIS'
      RETDEX = 0
      CALL ASSERT(DURDEC.GT.0.D0)
      INSFIN = INSREF+DURDEC
C
C --- AFFICHAGE
C
      VALR(1) = INSREF
      VALR(2) = DURDEC
      CALL U2MESR('I','SUBDIVISE_13',2,VALR)
C
      NUMINS = 1
C
  10  CONTINUE
C
C ----- INFORMATIONS SUR LE PAS DE TEMPS
C
        INSTAM = DIINST(SDDISC,NUMINS-1)
        INSTAP = DIINST(SDDISC,NUMINS)
        DELTAT = INSTAP-INSTAM
        IF ((INSTAM.GE.INSREF).AND.(INSTAM.LE.INSFIN)) THEN
          IF (DELTAT.GT.DELTAC) THEN   
            IF (INSTAP.GT.INSFIN) THEN
              OPTDEC = 'DEGRESSIF'
              RATIO  = (INSTAP-INSFIN)/DELTAT
            ELSE
              OPTDEC = 'UNIFORME'
            ENDIF
C
C --------- DECOUPE
C
            CALL NMDECC(NOMLIS,.FALSE.,OPTDEC,DELTAT,INSTAM,
     &                  RATIO ,TYPDEC ,NBRPAS,DELTAC,DTMIN ,
     &                  RETDEX)
            IF (RETDEX.EQ.0) GOTO 999
            IF (RETDEX.EQ.2) GOTO 888
C
C --------- VERIFICATIONS DE LA DECOUPE
C
            CALL NMDECV(SDDISC,NUMINS,IEVDAC,DTMIN ,RETDEX)
            IF (RETDEX.EQ.0) GOTO 999
C
C --------- MISE A JOUR DES SD APRES DECOUPE
C
            CALL NMDCDC(SDDISC,NUMINS,NOMLIS,NBRPAS)
            LDECO = .TRUE.
 888        CONTINUE
            CALL JEDETR(NOMLIS)
          ENDIF
        ENDIF
C
        CALL NMFINP(SDDISC,NUMINS,LSTOP )
        IF (LSTOP) GOTO 99
        NUMINS = NUMINS + 1
        GOTO 10

  99  CONTINUE
C
      IF (LDECO) THEN
        RETDEX = 1
      ELSE
        RETDEX = 2
      ENDIF
C
  999 CONTINUE
C
      IF (RETDEX.EQ.0) THEN

      ELSEIF (RETDEX.EQ.1) THEN
        CALL U2MESR('I','SUBDIVISE_14',1,INSFIN)
      ELSEIF (RETDEX.EQ.2) THEN
        CALL U2MESR('I','SUBDIVISE_15',1,INSREF)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEDEMA()
      END
