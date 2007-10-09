      SUBROUTINE MMCONV(NIVEAU,DEFICO,RESOCO,SDIMPR,DEPPLU,
     &                  MAXREL,IXFEM ,LFROTT,MMCVCA,MMCVFR,       
     &                  MMCVGO)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/10/2007   AUTEUR NISTOR I.NISTOR 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      INTEGER      NIVEAU
      LOGICAL      MAXREL
      LOGICAL      IXFEM,LFROTT
      CHARACTER*24 DEPPLU
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 SDIMPR
      LOGICAL      MMCVCA,MMCVFR,MMCVGO
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - ALGORITHME - UTILITAIRE)
C
C GESTION DE LA CONVERGENCE 
C      
C ----------------------------------------------------------------------
C
C
C IN  NIVEAU : NIVEAU DE LA BOUCLE METHODE CONTINUE
C      3     BOUCLE GEOMETRIE
C      2     BOUCLE SEUILS DE FROTTEMENT
C      1     BOUCLE CONTRAINTES ACTIVES
C IN  MAXREL : .TRUE. SI CRITERE RESI_GLOB_RELA ET CHARGEMENT = 0,
C                     ON UTILISE RESI_GLOB_MAXI
C IN  IXFEM  : INDICATEUR VALANT TRUE POUR XFEM AVEC CONTACT
C IN  LFROTT : INDICATEUR VALANT TRUE SI FROTTEMENT
C IN  DEPPLU : DEPLACEMENT APRES CONVERGENCE DE NEWTON
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE RESOLUTION DU CONTACT
C IN  SDIMPR : SD AFFICHAGE
C OUT MMCVCA : FIN DE BOUCLE DE CONTRAINTES ACTIVES
C OUT MMCVFR : FIN DE BOUCLE POUR LE SEUIL DE FROTTEMENT
C OUT MMCVGO : FIN DE BOUCLE POUR LA BOUCLE DE GEOMETRIE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      REAL*8       EPSFRO,EPSGEO,R8BID
      INTEGER      IBID,MAXB(3)
      LOGICAL      LBID
      CHARACTER*24 K24BLA,K24BID,DEPGEO,DEPLAM
      INTEGER      MMITCA,MMITFR,MMITGO      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      K24BLA = ' '   
      DEPGEO = RESOCO(1:14)//'.DEPG' 
      DEPLAM = RESOCO(1:14)//'.DEPF'  
C
C --- ETAT DES BOUCLES
C
      CALL MMBOUC(RESOCO,'GEOM','READ',MMITGO)
      CALL MMBOUC(RESOCO,'FROT','READ',MMITFR)
      CALL MMBOUC(RESOCO,'CONT','READ',MMITCA)    
C
C --- INFOS BOUCLES CONTACT
C      
      CALL MMINFP(0,DEFICO,K24BLA,'ITER_CONT_MAXI',
     &            MAXB(1),R8BID,K24BID,LBID)
      CALL MMINFP(0,DEFICO,K24BLA,'ITER_FROT_MAXI',
     &            MAXB(2),R8BID,K24BID,LBID)
      CALL MMINFP(0,DEFICO,K24BLA,'ITER_GEOM_MAXI',
     &            MAXB(3),R8BID,K24BID,LBID)                     
C
C --- CRITERES DE CONVERGENCE
C
      CALL MMINFP(0,DEFICO,K24BLA,'RESI_FROT',
     &            IBID,EPSFRO,K24BID,LBID)
      CALL MMINFP(0,DEFICO,K24BLA,'RESI_GEOM',
     &            IBID,EPSGEO,K24BID,LBID)
C
      GO TO (101,102,103) NIVEAU
 101  CONTINUE
C
C --- CONVERGENCE CONTRAINTES ACTIVES
C
      IF (MMITCA.GE.MAXB(1)) THEN
        IF (LFROTT) THEN
          CALL U2MESS('A','CONTACT3_86')
          MMCVCA = .TRUE.        
        ELSE
          CALL U2MESS('F','CONTACT3_85')
        ENDIF
      END IF
C
      IF (MMCVCA) THEN
        CALL NMIMPR('IMPR','CNV_CTACT',' ',0.D0,MMITCA)
      ENDIF
      GOTO 999
 102  CONTINUE
C
C --- CONVERGENCE SEUIL FROTTEMENT
C
      CALL MMMCRI(DEPLAM,DEPPLU,EPSFRO,MMCVFR)
C
      IF (MMITFR.GE.MAXB(2)) THEN
        CALL U2MESS('A','CONTACT3_87')
        MMCVFR = .TRUE.
      ENDIF
C
      IF (MMCVFR) THEN
        CALL NMIMPR('IMPR','CNV_SEUIL',' ',0.D0,MMITFR)
      ELSE
        CALL COPISD('CHAMP_GD','V',DEPPLU,DEPLAM) 
      ENDIF
      GOTO 999
 103  CONTINUE
C
C --- CONVERGENCE GEOMETRIE
C
      IF (IXFEM) THEN
        IF (MAXB(3).GT.0) THEN
          CALL MMMCRI(DEPGEO,DEPPLU,EPSGEO,MMCVGO)
          IF (MMITGO.EQ.(MAXB(3)+1)) THEN
            CALL U2MESS('A','CONTACT3_88')
            MMCVGO = .TRUE.
          ENDIF
        ELSEIF (MAXB(3).EQ.0) THEN
          MMCVGO = .TRUE.
        ENDIF
      ELSE
        CALL MMMCRI(DEPGEO,DEPPLU,EPSGEO,MMCVGO)
      ENDIF
C
      IF (.NOT.IXFEM) THEN
        IF (MMITGO.EQ.(MAXB(3)+1)) THEN
          CALL U2MESS('A','CONTACT3_88')
          MMCVGO = .TRUE.
        ENDIF
      ENDIF
C
      IF (MMCVGO) THEN
        CALL NMIMPR('IMPR','CNV_GEOME',' ',0.D0,MMITGO)
        CALL IMPSDM(SDIMPR(1:14),'ITER_NEWT',' ')
        CALL NMIMPR('IMPR','ETAT_CONV',' ',0.D0,0)
        IF (MAXREL) THEN
          CALL NMIMPR('IMPR','MAXI_RELA',' ',0.D0,0)
        ELSE
          CALL NMIMPR('IMPR','CONV_OK',' ',0.D0,0)
        ENDIF
        CALL NMIMPR('IMPR','CONV_RECA',' ',0.D0,0)
      ELSE
        CALL COPISD('CHAMP_GD','V',DEPPLU,DEPGEO)        
      ENDIF
      GOTO 999
C
 999  CONTINUE
C
      CALL JEDEMA()
      END
