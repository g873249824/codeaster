      SUBROUTINE NMIBLE(NIVEAU, 
     &                  PREMIE, MAILLA, DEFICO, OLDGEO, NEWGEO,
     &                  DEPMOI, DEPGEO, MAXB,   DEPLAM,
     &                  COMGEO, CSEUIL, COBCA, 
     &                  NEQ   , DEPDEL, DDEPLA, DEPPLU, LIGRCF,
     &                  CARTCF, MODELE, LISCHA, SOLVEU, NUMEDD, 
     &                  MCONEL, SCONEL, MEMASS, MASSE,
     &                  VITPLU, ACCPLU, VITINI, ACCINI, CMD,
     &                  INST,  ICONTX) 

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
C TOLE CRP_21

      IMPLICIT NONE

      LOGICAL      PREMIE
      INTEGER      NIVEAU,MAXB(4),COMGEO,CSEUIL,COBCA,NEQ,ICONTX
      CHARACTER*8  MAILLA,MCONEL,SCONEL
      CHARACTER*16 CMD
      CHARACTER*19 LIGRCF,CARTCF,LISCHA,SOLVEU
      CHARACTER*24 DEFICO,OLDGEO,NEWGEO,DEPMOI,DEPGEO,DEPLAM
      CHARACTER*24 DEPDEL,DDEPLA,DEPPLU,MODELE,NUMEDD
      CHARACTER*24 MEMASS,MASSE, ACCPLU,VITPLU,ACCINI,VITINI
      REAL*8 INST(3)
C ----------------------------------------------------------------------
C
C   STAT_NON_LINE : ROUTINE D'AIGUILLAGE DES ITERATIONS SE SITUANT
C                   ENTRE LES PAS DE TEMPS ET L'EQUILIBRE
C
C                   POUR LE MOMENT, SERT A LA METHODE CONTINUE DE
C                   CONTACT
C
C                   SERVIRA DANS L'AVENIR POUR LES CALCULS DE
C                   SENSIBILITE
C
C                   LES ITERATIONS ONT LIEU ENTRE CETTE ROUTINE
C                   (NMIBLE) ET SA COUSINE (NMTBLE) QUI COMMUNIQUENT
C                   POUR LE MOMENT PAR LA VARIABLE NIVEAU
C
C   IN  NIVEAU : INDICATEUR D'UTILISATION DE LA BOUCLE 
C        -1     ON N'UTILISE PAS CETTE BOUCLE
C         4     BOUCLE CONTACT METHODE CONTINUE
C                 INITIALISATION 
C         3     BOUCLE CONTACT METHODE CONTINUE
C                 BOUCLE GEOMETRIE
C         2     BOUCLE CONTACT METHODE CONTINUE
C                 BOUCLE SEUILS DE FROTTEMENT
C         1     BOUCLE CONTACT METHODE CONTINUE
C                 BOUCLE CONTRAINTES ACTIVES
C
C   OUT
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
C
C --- BOUCLE NMIBLE/NMTBLE NON UTILISEE
C
      IF (NIVEAU.LT.0) THEN 
        GOTO 9999
      ENDIF
      
      GO TO (101,102,103,104) NIVEAU

C
C --- NIVEAU: 4   BOUCLE CONTACT METHODE CONTINUE
C ---             INITIALISATION
C
 104  CONTINUE
 
      CALL DONNCO(MAILLA,OLDGEO,NEWGEO,DEPMOI,DEFICO,DEPGEO,MAXB)
C MAXB(1): ITER_CONT_MAXI
C MAXB(2): ITER_FROT_MAXI
C MAXB(3): ITER_GEOM_MAXI
C MAXB(4): 1 FROTTEMENT = 'SANS'
C          3 FROTTEMENT = 'COULOMB'

      COMGEO = 0
C
C --- NIVEAU: 3   BOUCLE CONTACT METHODE CONTINUE
C ---             BOUCLE GEOMETRIE
C
 103  CONTINUE
      NIVEAU = 3
      COMGEO = COMGEO + 1
      CALL NMIMPR('IMPR','BCL_GEOME',' ',0.D0,COMGEO)
C
C --- APPARIEMENT
C
      IF (ICONTX.EQ.0) THEN 
        CALL MAPPAR(PREMIE,MAILLA,DEFICO,OLDGEO,NEWGEO,COMGEO,DEPGEO)
      ENDIF

      CSEUIL = 0
C
C --- SI PAS DE FROTTEMENT -> PAS DE BOUCLE SUR SEUIL DE FROTTEMENT
C
      IF (MAXB(4).EQ.1) THEN 
        GOTO 666
      ENDIF   
      CALL COPISD('CHAMP_GD','V',DEPMOI,DEPLAM)
C
C --- NIVEAU: 2   BOUCLE CONTACT METHODE CONTINUE
C ---             BOUCLE SEUILS DE FROTTEMENT
C
 102  CONTINUE
      NIVEAU = 2
      CSEUIL = CSEUIL + 1
      CALL NMIMPR('IMPR','BCL_SEUIL',' ',0.D0,CSEUIL)

 666  CONTINUE
      COBCA = 0
C
C --- NIVEAU: 1   BOUCLE CONTACT METHODE CONTINUE
C ---             BOUCLE CONTRAINTES ACTIVES
C
 101  CONTINUE
      NIVEAU = 1
      COBCA  = COBCA + 1
      CALL NMIMPR('IMPR','BCL_CTACT',' ',0.D0,COBCA)
C
C --- AFIN QUE LE VECTEUR DES FORCES D'INERTIE NE SOIT PAS MODIFIE AU
C --- COURS DE LA BOUCLE DES CONTRAINTES ACTIVES PAR L'APPEL A OP0070
C --- ON LE DUPLIQUE ET ON UTILISE CETTE COPIE FIXE (VITINI,ACCINI)
C
      IF (CMD(1:4).EQ.'DYNA') THEN
        CALL COPISD('CHAMP_GD','V',VITINI,VITPLU)
        CALL COPISD('CHAMP_GD','V',ACCINI,ACCPLU)
      ENDIF 
      
      IF (ICONTX.EQ.0) THEN
        CALL CONLIG(NEQ,    DEPDEL, DDEPLA, DEPMOI, DEPPLU,
     &              DEFICO, MAILLA, LIGRCF, CARTCF, MODELE,
     &              LISCHA, SOLVEU, NUMEDD, MCONEL, SCONEL, 
     &              MEMASS, MASSE,  PREMIE, CMD,    INST)
      ELSE
C --- CAS X-FEM
        CALL XCONLI(NEQ,DEPDEL,DDEPLA,DEPMOI,DEPPLU,PREMIE,MODELE(1:8),
     &              MAILLA,DEFICO,MCONEL,SCONEL)
      ENDIF
C
9999  CONTINUE

      END
