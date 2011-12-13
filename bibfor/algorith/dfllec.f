      SUBROUTINE DFLLEC(SDLIST,DTMIN )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/12/2011   AUTEUR GENIAUT S.GENIAUT 
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
C
      IMPLICIT NONE
      CHARACTER*8  SDLIST
      REAL*8       DTMIN
C
C ----------------------------------------------------------------------
C
C OPERATEUR DEFI_LIST_INST
C
C LECTURE DES ECHECS
C
C MOT-CLEF ECHEC
C
C ----------------------------------------------------------------------
C
C IN  SDLIST : NOM DE LA SD RESULTAT
C     CONSTRUCTION DE SDLIST//'.ECHE.EVENR'
C     CONSTRUCTION DE SDLIST//'.ECHE.EVENK'
C     CONSTRUCTION DE SDLIST//'.ECHE.SUBDR'
C IN  DTMIN  : INTERVALLE DE TEMPS MINIMUM SUR LA LISTE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      NBORDR
      PARAMETER    (NBORDR = 7)
      CHARACTER*16 EVDORD(NBORDR)
      INTEGER      LISORD(NBORDR)
      LOGICAL      OBLORD(NBORDR)
C
      CHARACTER*16 MCFACT
      INTEGER      IBID
      CHARACTER*16 NOCHAM,NOCMP,CRICMP     
      REAL*8       VALERE,PASMIN
      INTEGER      NERREU
      INTEGER      NECHEC,NECHE2
      INTEGER      IECHEC,IORDR,ISAUVE
      CHARACTER*24 LISIFR
      INTEGER      JLINR
      CHARACTER*16 EVEN,ACTION,EVD
      CHARACTER*16 SUBMET,SUBAUT
      INTEGER      NBRPAS,NIVEAU
      REAL*8       NIVMAX,NIVEAR,PCPLUS,PENMAX
      REAL*8       CMMAXI,DUCOLL,PRCOLL
      INTEGER      DFLLVD
      CHARACTER*24 LISEVR,LISEVK,LISESU
      INTEGER      LEEVR,LEEVK,LESUR   
      INTEGER      JEEVR,JEEVK,JESUR
      LOGICAL      LOBLIG,LSAVE
      INTEGER      JTRAV,ILAST,IPLUS
      INTEGER      IARG
C
      DATA EVDORD  /'DIVE_ITER','DIVE_ERRE',
     &              'COMP_NCVG','DELTA_GRANDEUR',
     &              'COLLISION','INTERPENETRATION',
     &              'DIVE_RESI'/
      DATA OBLORD  /.TRUE. ,.TRUE. ,
     &              .TRUE. ,.FALSE.,
     &              .FALSE.,.FALSE.,
     &              .FALSE./     
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      MCFACT = 'ECHEC'
      NERREU = 0
      NECHEC = 0
      NECHE2 = 0
      NIVMAX = 0.D0
      DO 10 IORDR = 1,NBORDR
        LISORD(IORDR) = 0
  10  CONTINUE 
      LISIFR = SDLIST(1:8)//'.LIST.INFOR'           
      CALL JEVEUO(LISIFR,'E',JLINR )
C
C --- TAILLE DES VECTEURS
C
      LEEVR  = DFLLVD('LEEVR')
      LEEVK  = DFLLVD('LEEVK')
      LESUR  = DFLLVD('LESUR')
C
C --- DECOMPTE DES OCCURRENCES MOT-CLEF ECHEC      
C
      CALL DFLLNE(MCFACT,NECHEC,NERREU)
      NECHE2 = NECHEC
C
C --- L'EVENEMENT 'ERREUR' AJOUTE TROIS EVENTS OBLIGATOIRES
C
      IF (NERREU.EQ.1) THEN
        NECHE2 = NECHE2 + 2
      ELSEIF (NERREU.EQ.0) THEN
        NECHE2 = NECHE2 + 3
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
      CALL WKVECT('&&DFLLEC.TRAV','V V I',NECHE2,JTRAV)
C
C --- CREATION SD
C
      LISEVR = SDLIST(1:8)//'.ECHE.EVENR'
      LISEVK = SDLIST(1:8)//'.ECHE.EVENK'
      LISESU = SDLIST(1:8)//'.ECHE.SUBDR' 
      CALL WKVECT(LISEVR,'G V R',  NECHE2*LEEVR,JEEVR )
      CALL WKVECT(LISEVK,'G V K16',NECHE2*LEEVK,JEEVK )
      CALL WKVECT(LISESU,'G V R'  ,NECHE2*LESUR,JESUR )
      ZR(JLINR-1+9) = NECHE2
C
C --- CREATION DES EVENEMENTS DANS LEUR ORDRE DE PRIORITE
C
      ILAST = 1
      DO 100 IORDR = 1,NBORDR
        EVD    = EVDORD(IORDR)
        LOBLIG = OBLORD(IORDR)
        DO 101 IECHEC = 1,NECHEC
          CALL GETVTX(MCFACT,'EVENEMENT',IECHEC,IARG,1,EVEN,IBID)
          IF (LOBLIG) THEN
            IF (EVEN.EQ.'ERREUR') THEN
              LISORD(IORDR) = IECHEC
            ENDIF  
          ELSE
            IF (EVEN.EQ.EVD) THEN
              LISORD(IORDR) = IECHEC
              IF (EVEN.EQ.'DELTA_GRANDEUR') THEN
                ZI(JTRAV+ILAST-1) = IECHEC
                ILAST = ILAST + 1
              ENDIF
            ENDIF
          ENDIF  
  101   CONTINUE
  100 CONTINUE
C
C --- TRAITEMENT DES OCCURRENCES
C
      ISAUVE = 0
      IPLUS  = 0
      ILAST  = 1
      DO 110 IORDR = 1,NBORDR
C
C ----- OCCURRENCE DE ECHEC
C
        IECHEC = LISORD(IORDR)
        EVD    = EVDORD(IORDR)
        LOBLIG = OBLORD(IORDR)
C
C ----- EVENEMENT A CREER
C        
  157   CONTINUE
        IF (IECHEC.EQ.0) THEN
          IF (LOBLIG) THEN
            EVEN   = EVD
            IPLUS  = 0
            ISAUVE = ISAUVE + 1
          ENDIF
        ELSE
          EVEN   = EVD
          IF (EVEN.EQ.'DELTA_GRANDEUR') THEN
            IPLUS  = ZI(JTRAV+ILAST-1)
            IECHEC = IPLUS
            IF (IPLUS.EQ.0) THEN
              IECHEC = 0
            ELSE
              ISAUVE = ISAUVE + 1
              ILAST  = ILAST  + 1
            ENDIF
          ELSE
            ISAUVE = ISAUVE+ 1
          ENDIF
        ENDIF
C
C ----- PARAMETRES DE L'ACTION
C
        LSAVE = .FALSE.
        IF (IECHEC.EQ.0) THEN
          IF (LOBLIG) THEN
C
C --------- VALEURS PAR DEFAUT POUR UNE DECOUPE MANUELLE
C
            CALL DFDEVN(ACTION,SUBMET,PASMIN,NBRPAS,NIVEAU)
            LSAVE = .TRUE.
          ENDIF
        ELSE
C
C ------- LECTURE DES PARAMETRES DE L'EVENEMENT
C
          CALL DFLLPE(MCFACT,IECHEC,EVEN ,PENMAX,NOCHAM,
     &                NOCMP ,CRICMP,VALERE)
C
C ------- LECTURE DES PARAMETRES DE L'ACTION
C
          CALL DFLLAC(MCFACT,IECHEC,DTMIN ,EVEN  ,ACTION,
     &                SUBMET,SUBAUT,PASMIN,NBRPAS,NIVEAU,
     &                PCPLUS,CMMAXI,PRCOLL,DUCOLL)
          LSAVE = .TRUE.
        ENDIF       
C
C ----- SAUVEGARDE DES INFORMATIONS
C
        IF (LSAVE) THEN
          CALL DFLLSV(LISIFR,LISEVR,LISEVK,LISESU,ISAUVE,
     &                EVEN  ,ACTION,SUBMET,SUBAUT,PASMIN,
     &                NBRPAS,NIVEAU,PCPLUS,CMMAXI,PRCOLL,
     &                DUCOLL,PENMAX,CRICMP,VALERE,NOCHAM,
     &                NOCMP )
        ENDIF
        IF (IPLUS.NE.0) GOTO 157

 110  CONTINUE
C
C --- TRAITEMENT PARTICULIER DU MOT-CLE 'SUBD_NIVEAU' QUI EST EN FAIT 
C --- UN MOT-CLE GLOBAL A TOUTE LES METHODES DE SOUS-DECOUPAGE
C --- ON PREND LE MAX SUR TOUS LES EVENEMENTS
C
      DO 120 IECHEC = 1,NECHE2
        NIVEAR = ZR(JESUR-1+LESUR*(IECHEC-1)+4)
        NIVMAX = MAX(NIVEAR,NIVMAX)
 120  CONTINUE
C
C --- ENREGISTREMENT DU NIVEAU MAX
C
      DO 130 IECHEC = 1,NECHE2
        ZR(JESUR-1+LESUR*(IECHEC-1)+4) = NIVMAX
 130  CONTINUE 
C
      CALL JEDETR('&&DFLLEC.TRAV')
      CALL JEDEMA()
      END
