      SUBROUTINE NMEVEV(SDDISC,CONVER,VALE  ,ITEMAX,LDCCVG,
     &                  ERROR ,RESOCO,LPOST ,DIVRES,LEVEN )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 27/02/2012   AUTEUR GREFFET N.GREFFET 
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
      CHARACTER*24 RESOCO
      LOGICAL      CONVER,ITEMAX,DIVRES,ERROR,LPOST,LEVEN
      INTEGER      LDCCVG
      CHARACTER*19 SDDISC,VALE(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C DETECTION DU PREMIER EVENEMENT DECLENCHE
C
C DES QU'UN EVENT-DRIVEN EST SATISFAIT, ON SORT
C ON NE CHERCHE PAS A VERIFIER LES AUTRES EVENEMENTS
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION
C IN  ITEMAX : .TRUE. SI ITERATION MAXIMUM ATTEINTE
C IN  DIVRES : .TRUE. SI LE RESIDU DIVERGE
C IN  CONVER : .TRUE. SI CONVERGENCE REALISEE
C IN  LPOST  : .TRUE. SI ON EST EN POST-TRAITEMENT
C IN  ERROR  : .TRUE. SI ERREUR
C IN  VALE   : INCREMENTS DES VARIABLES
C               OP0070: VARIABLE CHAPEAU
C               OP0033: TABLE
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT POUR
C              LE PARAMETRE DE PILOTAGE CHOISI
C     0 - CAS DE FONCTIONNEMENT NORMAL
C     1 - ECHEC DE L'INTEGRATION DE LA LDC
C     2 - ERREUR DANS LES LDC SUR LA NON VERIFICATION DE
C         CRITERES PHYSIQUES 
C     3 - SIZZ PAS NUL POUR C_PLAN DEBORST
C OUT LEVEN  : TRUE. SI AU MOINS UN EVENT DECLENCHE
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      REAL*8       R8BID
      INTEGER      IBID,NECHEC,IECHEC,IEVDAC
      CHARACTER*8  K8BID
      CHARACTER*16 NOMEVD
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      LEVEN  = .FALSE.
C
C --- NOMBRE D'EVENT-DRIVEN : NECHEC
C
      CALL UTDIDT('L'   ,SDDISC,'LIST',IBID  ,'NECHEC',
     &            R8BID ,NECHEC,K8BID )
C
C --- DETECTION DU PREMIER EVENEMENT DECLENCHE
C --- DES QU'UN EVENT-DRIVEN EST SATISFAIT, ON SORT
C --- ON NE CHERCHE PAS A VERIFIER LES AUTRES EVENT
C
      IEVDAC = 0
      DO 100 IECHEC = 1,NECHEC
C
C ----- RECUPERATION DU NOM DE L'EVENT-DRIVEN
C
        CALL UTDIDT('L'   ,SDDISC,'ECHE',IECHEC,'NOM_EVEN',
     &              R8BID ,IBID  ,NOMEVD)
C
C ----- PAR DEFAUT: EVENEMENT NON ACTIVE
C
        CALL ENEVEN(SDDISC,IECHEC,.FALSE.)
C
        IF (NOMEVD.EQ.'DIVE_ERRE') THEN
          IF (ERROR) THEN
            IEVDAC = IECHEC
            GOTO 8888
          ENDIF
C
        ELSEIF (NOMEVD.EQ.'DIVE_ITER') THEN
          IF (ITEMAX) THEN
            IEVDAC = IECHEC
            GOTO 8888
          ENDIF

        ELSEIF (NOMEVD.EQ.'DIVE_RESI') THEN
          IF (DIVRES) THEN
            IEVDAC = IECHEC
            GOTO 8888
          ENDIF
C
        ELSEIF (NOMEVD.EQ.'COMP_NCVG') THEN
          IF (CONVER) THEN
            IF (LDCCVG.EQ.2) THEN
              IEVDAC = IECHEC
              GOTO 8888
            ENDIF
          ENDIF
C
        ELSEIF (NOMEVD.EQ.'DELTA_GRANDEUR') THEN
          IF (CONVER) THEN
            CALL NMEVDG(SDDISC,VALE  ,IECHEC,IEVDAC)
            IF (IEVDAC.NE.0) GOTO 8888
          ENDIF
C
        ELSEIF (NOMEVD.EQ.'COLLISION') THEN
          IF (LPOST) THEN
            CALL NMEVCO(SDDISC,RESOCO,IECHEC,IEVDAC)
            IF (IEVDAC.NE.0) GOTO 8888
          ENDIF          
C
        ELSEIF (NOMEVD.EQ.'INTERPENETRATION') THEN
          IF (LPOST) THEN
            CALL NMEVIN(SDDISC,RESOCO,IECHEC,IEVDAC)
            IF (IEVDAC.NE.0) GOTO 8888
          ENDIF          
C          
        ELSEIF (NOMEVD.EQ.'INSTABILITE') THEN
          GOTO 8888
C          
        ELSE
          CALL ASSERT(.FALSE.)           
        ENDIF   
 100  CONTINUE
C
 8888 CONTINUE
C
C --- DECLENCHEMENT DE L'EVENEMENT
C
      IF (IEVDAC.NE.0) THEN
        CALL ENEVEN(SDDISC,IEVDAC,.TRUE.)
        LEVEN  = .TRUE.


      ENDIF
C
      CALL JEDEMA()
      END
