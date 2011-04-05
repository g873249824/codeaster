      SUBROUTINE NXNOLI(MODELE,MATE  ,CARELE,COMPOR,LOSTAT,
     &                  LREUSE,LNONL ,LEVOL ,PARA  ,SDDISC,
     &                  SDCRIT,NBPASE,INPSCO,VHYDR ,LISCH2)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/02/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER       NBPASE
      REAL*8        PARA(*)
      LOGICAL       LNONL,LOSTAT,LREUSE,LEVOL
      CHARACTER*(*) INPSCO
      CHARACTER*19  SDDISC,SDCRIT
      CHARACTER*24  VHYDR,COMPOR
      CHARACTER*24  MODELE,MATE  ,CARELE
      CHARACTER*19  LISCH2
C
C ----------------------------------------------------------------------
C
C ROUTINE THER_* (SD EVOL_THER)
C
C PREPARATION DE LA SD EVOL_THER
C
C ----------------------------------------------------------------------
C
C
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
      CHARACTER*24 ARCINF
      INTEGER      JARINF
      CHARACTER*19 SDARCH
      INTEGER      NUMARC,NUMINS
      INTEGER      IFM,NIV
      CHARACTER*24 NOOBJ,RESULT     
      LOGICAL      FORCE
      INTEGER      NRPASE
      INTEGER      IAUX,JAUX      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<THERMIQUE> PREPARATION DE LA SD EVOL_THER'
      ENDIF   
C
C --- INSTANT INITIAL
C
      NUMINS = 0
      FORCE  = .TRUE.
C
C --- DETERMINATION DU NOM DE LA SD INFO_CHARGE STOCKEE
C --- DANS LA SD RESULTAT
C       
      NOOBJ  = '12345678'//'.1234'//'.EXCIT'           
      CALL GNOMSD(NOOBJ,10,13)
      LISCH2 = NOOBJ(1:19) 
C
C --- ACCES SD ARCHIVAGE
C
      SDARCH = SDDISC(1:14)//'.ARCH'
      ARCINF = SDARCH(1:19)//'.AINF'
C
C --- NUMERO ARCHIVAGE COURANT
C
      CALL JEVEUO(ARCINF,'L',JARINF)
      NUMARC = ZI(JARINF+1 -1)
C
C --- CREATION DE LA SD EVOL_THER OU NETTOYAGE DES ANCIENS NUMEROS
C
      DO 20 NRPASE = 0,NBPASE
        JAUX = 3
        IAUX = NRPASE
        CALL PSNSLE(INPSCO,IAUX  ,JAUX  ,RESULT)
        IF (LREUSE) THEN
          CALL ASSERT(NUMARC.NE.0)
          CALL RSRUSD(RESULT,NUMARC)
        ELSE
          CALL ASSERT(NUMARC.EQ.0)
          CALL RSCRSD('G',RESULT,'EVOL_THER',100)
        ENDIF
 20   CONTINUE
C 
C --- ARCHIVAGE ETAT INITIAL
C
      IF ((.NOT.LREUSE).AND.(.NOT.LOSTAT).AND.LEVOL) THEN
        CALL U2MESS('I','ARCHIVAGE_4')
        JAUX = 3
        IAUX = 0
        CALL PSNSLE(INPSCO,IAUX  ,JAUX  ,RESULT)
        CALL NTARCH(NUMINS,MODELE,MATE  ,CARELE,COMPOR,
     &              LNONL ,PARA  ,SDDISC,SDCRIT,NBPASE,
     &              INPSCO,VHYDR ,LISCH2,FORCE )
      ENDIF     
C
      CALL JEDEMA()

      END
