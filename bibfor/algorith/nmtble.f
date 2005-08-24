      SUBROUTINE NMTBLE(NIVEAU, 
     &                  MAILLA, DEFICO, OLDGEO, NEWGEO,
     &                  DEPMOI, DEPGEO, MAXB,   DEPLAM,
     &                  COMGEO, CSEUIL, COBCA,  ICONTX,  
     &                  DEPPLU, INST,   DECOL,  MODELE,
     &                  MAXREL, IMPRCO)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/08/2005   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PBADEL P.BADEL
      IMPLICIT NONE

      INTEGER      NIVEAU
      INTEGER      MAXB(4)
      INTEGER      COMGEO,CSEUIL,COBCA
      INTEGER      ICONTX
      CHARACTER*8  MAILLA
      CHARACTER*24 DEFICO,IMPRCO
      CHARACTER*24 OLDGEO,NEWGEO,DEPGEO
      CHARACTER*24 DEPMOI,DEPLAM,DEPPLU
      CHARACTER*24 MODELE
      REAL*8       INST(3)
      LOGICAL      DECOL   
      LOGICAL      MAXREL   
C
C ----------------------------------------------------------------------
C
C   STAT_NON_LINE : ROUTINE DE FIN DE BOUCLE DES ITERATIONS SE SITUANT
C                   ENTRE LES PAS DE TEMPS ET L'EQUILIBRE
C
C                   POUR LE MOMENT, SERT A LA METHODE CONTINUE DE
C                   CONTACT
C
C                   SERVIRA DANS L'AVENIR POUR LES CALCULS DE
C                   SENSIBILITE
C
C                   LES ITERATIONS ONT LIEU ENTRE CETTE ROUTINE
C                   (NMTBLE) ET SA COUSINE (NMIBLE) QUI COMMUNIQUENT
C                   POUR LE MOMENT PAR LA VARIABLE NIVEAU
C
C I/O NIVEAU : INDICATEUR D'UTILISATION DE LA BOUCLE 
C     -1     ON N'UTILISE PAS CETTE BOUCLE
C      4     BOUCLE CONTACT METHODE CONTINUE
C              INITIALISATION 
C      3     BOUCLE CONTACT METHODE CONTINUE
C              BOUCLE GEOMETRIE
C      2     BOUCLE CONTACT METHODE CONTINUE
C              BOUCLE SEUILS DE FROTTEMENT
C      1     BOUCLE CONTACT METHODE CONTINUE
C              BOUCLE CONTRAINTES ACTIVES
C
C IN  MAXB   : MAXB(1) - ITER_CONT_MAXI
C              MAXB(2) - ITER_FROT_MAXI
C              MAXB(3) - ITER_GEOM_MAXI
C              MAXB(4) - 1 FROTTEMENT = 'SANS'
C                        3 FROTTEMENT = 'COULOMB'
C IN  COMGEO : ITERATION DE REACTUALISATION GEOMETRIQUE
C                POUR LE CONTACT METHODE CONTINUE
C IN  CSEUIL : ITERATION DE POINT FIXE SUR LE SEUIL DE FROTTEMENT
C                POUR LE CONTACT METHODE CONTINUE
C IN  COBCA  : ITERATION DE CONTRAINTE ACTIVE
C                POUR LE CONTACT METHODE CONTINUE
C IN  ICONTX : INDICATEUR VALANT 1 POUR XFEM AVEC CONTACT
C IN  MAILLA : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  OLDGEO : CHAMP DE DEPLACEMENT POUR ANCIENNE GEOMETRIE
C IN  NEWGEO : CHAMP DE DEPLACEMENT POUR NOUVELLE GEOMETRIE
C IN  DEPPLU : DEPLACEMENT APRES CONVERGENCE DE NEWTON
C IN  DEPMOI : DEPLACEMENT AVANT CONVERGENCE DE NEWTON
C IN  DEPGEO : ?
C IN  DEPLAM : ?
C IN  IMPRCO : SD AFFICHAGE
C IN  MODELE : NOM DU MODELE
C IN  INST   : INST(1) - INSTANT COURANT
C              INST(2) - INCREMENT DE TEMPS
C              INST(3) - VALEUR DU THETA (INTEGRATION PAR THETA METHODE)
C I/O DECOL  : ?
C IN  MAXREL : .TRUE. SI CRITERE RESI_GLOB_RELA ET CHARGEMENT = 0,
C                     ON UTILISE RESI_GLOB_MAXI
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      LOGICAL RGENCE,CGENCE
      INTEGER INCOCA
C
C ----------------------------------------------------------------------
C
      IF (NIVEAU.LT.0) THEN 
        GOTO 9999
      ENDIF

      GO TO (101,102,103) NIVEAU
C
C --- NIVEAU: 1   BOUCLE CONTACT METHODE CONTINUE
C ---             BOUCLE CONTRAINTES ACTIVES
C
 101  CONTINUE
      IF (ICONTX.EQ.0) THEN
        CALL MMMBCA(MAILLA,DEFICO,OLDGEO,DEPPLU,DEPMOI,
     &              INCOCA,INST,DECOL)
      ELSE
C       CAS X-FEM
        CALL XMMBCA(MAILLA,MODELE(1:8),DEFICO,OLDGEO,DEPPLU,
     &              DEPMOI,INCOCA)
      ENDIF
 
      IF (COBCA.GE.MAXB(1)) THEN
        IF (MAXB(4).EQ.1) THEN
          CALL UTMESS('F', 'NMTBLE','ECHEC DANS LE '//
     &    'TRAITEMENT DU CONTACT, AUGMENTER ITER_CONT_MAX')
        ENDIF
        INCOCA = 1
      END IF
C
C --- CONVERGENCE CONTRAINTES ACTIVES ?
C
      IF (INCOCA.EQ.0) THEN
        NIVEAU = 1
        GOTO 999
      ELSE
        CALL NMIMPR('IMPR','CNV_CTACT',' ',0.D0,COBCA)
      ENDIF
C
C --- NIVEAU: 2   BOUCLE CONTACT METHODE CONTINUE
C ---             BOUCLE SEUILS DE FROTTEMENT
C
 102  CONTINUE

      IF (MAXB(4).EQ.1) THEN 
        GOTO 103
      ENDIF

      CALL MMMCRI(DEPPLU,DEPLAM,CGENCE)
      
      IF (ICONTX.EQ.0) THEN 
        CALL REACLM(MAILLA,DEPPLU,NEWGEO,DEFICO)
      ELSE
C       CAS X-FEM : MISE � JOUR DU SEUIL DE FROTTEMENT
        CALL XREACL(MAILLA,MODELE(1:8),DEPPLU,DEFICO)
      ENDIF         
C
C --- CONVERGENCE SEUIL FROTTEMENT ?
C
      IF ( CGENCE .OR. (CSEUIL.GE.MAXB(2))) THEN
        CALL NMIMPR('IMPR','CNV_SEUIL',' ',0.D0,CSEUIL)
      ELSE
        CALL COPISD('CHAMP_GD','V',DEPPLU,DEPLAM)
        NIVEAU = 2
        GOTO 999
      ENDIF
C
C --- NIVEAU: 3   BOUCLE CONTACT METHODE CONTINUE
C ---             BOUCLE GEOMETRIE
C
 103  CONTINUE

      IF (ICONTX.EQ.0) THEN 
        CALL MMMCRI(DEPPLU,DEPGEO,RGENCE)
      ELSE
C       CAS X-FEM
        RGENCE=.TRUE.
      ENDIF
C
C --- CONVERGENCE GEOMETRIE ?
C

      IF ( RGENCE .OR. (COMGEO.EQ.(MAXB(3)+1)) ) THEN

        CALL NMIMPR('IMPR','CNV_GEOME',' ',0.D0,CSEUIL)
        CALL IMPSDM(IMPRCO(1:14),'ITER_NEWT',' ')
        CALL NMIMPR('IMPR','ETAT_CONV',' ',0.D0,0) 
C
C --- TYPE DE CONVERGENCE
C
        IF (MAXREL) THEN
          CALL NMIMPR('IMPR','MAXI_RELA',' ',0.D0,0)
        ELSE
          CALL NMIMPR('IMPR','CONV_OK',' ',0.D0,0)
        ENDIF
C
C --- RECAPITULATIF CRITERES CONVERGENCE - AFFICHAGE RESIDUS
C
        CALL NMIMPR('IMPR','CONV_RECA',' ',0.D0,0)  
        NIVEAU = 0
        GOTO 9999
      ELSE
        CALL COPISD('CHAMP_GD','V',DEPPLU,DEPGEO)
        NIVEAU = 3
        GOTO 999
      ENDIF
C
  999 CONTINUE  
C
C --- AFFICHAGE TABLEAU CONVERGENCE
C
      CALL IMPSDM(IMPRCO(1:14),'ITER_NEWT',' ')
      CALL NMIMPR('IMPR','ETAT_CONV',' ',0.D0,0)    
      CALL NMIMPR('IMPR','LIGNE    ',' ',0.D0,0)     
C
 9999 CONTINUE     

      END
