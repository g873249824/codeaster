      SUBROUTINE NMEVDR(SDDISC,CONVER,VALINC,LICCVG,LEVDRI)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/10/2010   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      LOGICAL      CONVER,LEVDRI
      CHARACTER*19 SDDISC,VALINC(*)
      INTEGER      LICCVG(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C VERIFICATION DES CRITERES DE DIVERGENCE DE TYPE EVENT-DRIVEN
C
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION
C IN/OUT CONVER : .TRUE. SI CONVERGENCE REALISEE
C                 CE LOGICAL EST MODIFIE SI UN EVENT-DRIVENT EST VERIFIE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  LICCVG : CODES RETOURS D'ERREUR
C              (1) : PILOTAGE
C                  =  0 CONVERGENCE
C                  =  1 PAS DE CONVERGENCE
C                  = -1 BORNE ATTEINTE
C              (2) : INTEGRATION DE LA LOI DE COMPORTEMENT
C                  = 0 OK
C                  = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
C                  = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
C              (3) : TRAITEMENT DU CONTACT UNILATERAL EN GD. DEPL.
C                  = 0 OK
C                  = 1 ECHEC DANS LE TRAITEMENT DU CONTACT
C              (4) : TRAITEMENT DU CONTACT UNILATERAL EN GD. DEPL.
C                  = 0 OK
C                  = 1 MATRICE DE CONTACT SINGULIERE
C              (5) : MATRICE DU SYSTEME (MATASS)
C                  = 0 OK
C                  = 1 MATRICE SINGULIERE
C                  = 3 ON NE SAIT PAS SI SINGULIERE
C OUT LEVDRI : .TRUE. SI UN DES EVENT-DRIVEN EST VERIFIE

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
      REAL*8       R8B,VALREF,DVAL
      INTEGER      IFM,NIV,IB,NOCC,IOCC
      CHARACTER*8  K8B,CRIT,TYPEXT,TXT
      CHARACTER*16 NOCHAM,NOCMP,NOMEVD
      PARAMETER   (TYPEXT = 'MAX_ABS')
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> EVALUATION DES EVENT-DRIVEN'
      ENDIF
C
C     PAR DEFAUT, AUCUN EVENT-DRIVEN N'EST SATISFAIT
      LEVDRI = .FALSE.
      
C     LES EVENT-DRIVEN NE SONT VERIFIES QU'A CONVERGENCE
      IF (.NOT.CONVER) GOTO 9999

C     NOMBRE D'EVENT-DRIVEN : NOCC
      CALL UTDIDT('L',SDDISC,'ECHE',IB,'NB_OCC',R8B,NOCC,K8B)
      
C     BOUCLE SUR LES EVENT-DRIVEN
C     DES QU'UN EVENT-DRIVEN EST SATISFAIT, ON SORT
C     ON NE CHERCHE PAS A VERIFIER LES AUTRES EVENT POUR LES PERFS
C     ATTENTION, ON N'ENREGISTRERA DONC PAS FORCEMENT TOUS LES EVEN
      DO 100 IOCC = 1,NOCC

C       RECUPERATION DU NOM DE L'EVENT-DRIVEN
        CALL UTDIDT('L',SDDISC,'ECHE',IOCC,'NOM_EVEN',R8B,IB,NOMEVD)

C       VERIF
        CALL ASSERT(NOMEVD.EQ.'ERREUR'.OR.NOMEVD.EQ.'DELTA_GRANDEUR')

C       ----------------------------------------------------------------
        IF (NOMEVD.EQ.'ERREUR') THEN
C       ----------------------------------------------------------------

C         CET EVENEMENT CORRESPOND A UNE ERREUR DANS LES LDC SUR LA 
C         NON VERIFICATION DE CRITERES PHYSIQUES (CODRET = 2)

C         ATTENTION, NE PAS METTRE 'NON' PAS DEFAUT, ON RISQUE
C         D'ECRASER LA VALEUR ECRITE PRECEDEMMENT PAR NMCONV !

          IF (LICCVG(2).EQ.2) THEN
          
C           EVENT-DRIVEN SATISFAIT : ENREGISTREMENT ET ON SORT
C           AU PIRE ON ECRASE LA VALEUR 'OUI' ECRITE PRECEDEMMENT 
C           PAR NMCONV PAR UN 'OUI', CE N'EST PAS BIEN GRAVE...
            LEVDRI=.TRUE.
            GOTO 8888
          ENDIF

C       ----------------------------------------------------------------
        ELSEIF (NOMEVD.EQ.'DELTA_GRANDEUR') THEN
C       ----------------------------------------------------------------

C         PAR DEFAUT, CET EVENT-DRIVEN N'EST PAS SATISAFAIT
          TXT = 'NON'
          CALL UTDIDT('E',SDDISC,'ECHE',IOCC,'VERIF_EVEN',R8B,IB,TXT)

          CALL UTDIDT('L',SDDISC,'ECHE',IOCC,'NOM_CHAM',R8B,IB,NOCHAM)
          CALL UTDIDT('L',SDDISC,'ECHE',IOCC,'NOM_CMP',R8B,IB,NOCMP)
          CALL UTDIDT('L',SDDISC,'ECHE',IOCC,'VALE_REF',VALREF,IB,K8B)
          CALL UTDIDT('L',SDDISC,'ECHE',IOCC,'CRIT_COMP',R8B,IB,CRIT)
          
C         DVAL :MAX EN VALEUR ABSOLUE DU DELTA(CHAMP+CMP)
          CALL EXTDCH(TYPEXT,VALINC,NOCHAM,NOCMP,DVAL)
          
C         SEUL UN "DEPASSEMENT STRICT" DU SEUIL EST POSSIBLE
          CALL ASSERT(CRIT.EQ.'GT')

          IF (DVAL.GT.VALREF) THEN
C           EVENT-DRIVEN SATISFAIT : ENREGISTREMENT ET ON SORT
            LEVDRI=.TRUE.
            GOTO 8888
          ENDIF
          
        ENDIF
        
 100  CONTINUE



 8888 CONTINUE
      IF (LEVDRI) THEN
C       PHASE D'ENREGISTREMENT DES QU'UN EVENT-DRIVENT EST SATISFAIT
        TXT = 'OUI'
        CALL UTDIDT('E',SDDISC,'ECHE',IOCC,'VERIF_EVEN',R8B,IB,TXT)
        CONVER = .FALSE.
      ENDIF

 9999 CONTINUE
C     FIN
  
      CALL JEDEMA()
      END
