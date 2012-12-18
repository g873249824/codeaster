      SUBROUTINE CGVEFO(OPTION,TYPFIS,NOMFIS)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*8  TYPFIS,NOMFIS
      CHARACTER*16 OPTION

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/12/2012   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE GENIAUT S.GENIAUT
C
C     SOUS-ROUTINE DE L'OPERATEUR CALC_G
C
C     BUT : VERIFICATION DE LA COMPATIBILITE ENTRE
C           OPTION ET TYPE DE FISSURE
C
C  IN :
C    OPTION : OPTION DE CALC_G
C    TYPFIS : TYPE DE LA SD DECRIVANT LE FOND DE FISSURE
C             ('THETA' OU 'FONDIFSS' OU 'FISSURE')
C    NOMFIS : NOM DE LA SD DECRIVANT LE FOND DE FISSURE
C ======================================================================
C
      INTEGER      IER,IBID
      CHARACTER*8  CONF

      CALL JEMARQ()

C     LE CAS DES FONDS DOUBLES N'EST PAS TRAITE DANS CALC_G
      IF (TYPFIS.EQ.'FONDFISS') THEN
        CALL JEEXIN(NOMFIS//'.FOND.NOEU',IER)
        IF (IER.EQ.0) CALL U2MESS('F','RUPTURE1_4')
      ENDIF

C     COMPATIBILITE ENTRE OPTION ET "ENTAILLE"
C     ON NE SAIT DEFINIR K QUE DANS LE CAS D'UNE FISSURE AVEC LEVRES
C     INITIALLEMENT COLLEES (PAS D'ENTAILLE), DONC
C     CERTAINES OPTIONS EN MODELISATION FEM NE TRAITENT PAS LES
C     FISSURES EN CONFIGURATION DECOLLEE
C     (SI X-FEM OU THETA, LA CONFIG ET TOUJOURS COLLEE)
      IF (TYPFIS.EQ.'FONDFISS') THEN

        CALL DISMOI('F','CONFIG_INIT',NOMFIS,'FOND_FISS',IBID,CONF,IER)

        IF ((OPTION.EQ.'CALC_K_G'.OR.
     &       OPTION.EQ.'K_G_MODA'.OR.
     &       OPTION.EQ.'CALC_K_MAX').AND.
     &      (CONF.EQ.'DECOLLEE')) THEN
          CALL U2MESK('F','RUPTURE0_29',1,OPTION)
        ENDIF

      ENDIF

C     CERTAINES OPTIONS NE SONT PAS ENCORE PROGRAMMEES POUR X-FEM
      IF (OPTION.EQ.'G_MAX'.OR.OPTION.EQ.'G_BILI') THEN
        IF (TYPFIS.EQ.'FISSURE') CALL U2MESK('F','RUPTURE0_48',1,OPTION)
      ENDIF


      CALL JEDEMA()

      END
