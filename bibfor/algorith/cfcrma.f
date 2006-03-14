      SUBROUTINE CFCRMA(NEQ,NOMA,RESOSD)     
C      
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/03/2006   AUTEUR MABBAS M.ABBAS 
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
C
      IMPLICIT     NONE
      INTEGER      NEQ
      CHARACTER*8  NOMA
      CHARACTER*24 RESOSD
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CFCRSD/CUCRSD
C ----------------------------------------------------------------------
C
C CREATION DE LA MATRICE DE "CONTACT"
C VALABLE AUSSI POUR LIAISON_UNIL
C     CETTE MATRICE EST STOCKEE EN LIGNE DE CIEL
C     TRIANGULAIRE SYMETRIQUE PLEINE   
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NEQ    : NOMBRE D'EQUATIONS DE LA MATRICE
C IN  RESOSD : NOM JEVEUX DE LA SD DE TRAITEMENT NUMERIQUE 
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32       JEXNUM
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV
      REAL*8       TMAX,JEVTBL,TVALA,TVMAX,TV
      INTEGER      ITBLOC,HMAX,IVALA,NTBLC,NBLC,NBCOL
      CHARACTER*19 STOC,MATR 
      CHARACTER*8  K8BID
      INTEGER      I,II,J,IEQUA,ICOMPT,IBLC
      INTEGER      JREFA,JSCHC,JSCDI,JSCBL,JSCIB,JSCDE,JBID
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C ----------------------------------------------------------------------
      
      CALL INFNIV(IFM,NIV)
C 
C --- OBJET NUME_DDL
C 
      STOC   = RESOSD(1:14)//'.SLCS'
C
C --- TAILLE MAXI D'UN BLOC
C
      TMAX   = JEVTBL()
      ITBLOC = NINT(TMAX*1024)
C
C --- HAUTEUR MAXI D'UNE COLONNE
C
      HMAX   = NEQ
C
C --- CREATION SCHC
C
      CALL WKVECT (STOC//'.SCHC','V V I',NEQ,JSCHC)
      DO 5 II = 1, NEQ
         ZI(JSCHC+II-1) = II
 5    CONTINUE
C
C --- CREATION SCDI
C
      CALL WKVECT (STOC//'.SCDI','V V I',NEQ,JSCDI)
      DO 6 II = 1, NEQ
         ZI(JSCDI+II-1) = II*(II+1)/2
 6    CONTINUE
C
      ZI(JSCDI) = ZI(JSCHC)
C      
C --- HAUTEUR COLONNE CUMULEE
C
      NTBLC =  ZI(JSCHC)
C      
C --- NOMBRE DE BLOCS
C
      NBLC  = 1
C      
C --- TAUX DE VIDE MAXI POUR ALARME
C
      TVALA = 0.25D0
C      
C --- NOMBRE DE BLOCS TROP VIDES
C
      IVALA = 0
C      
C --- TAUX DE VIDE MAXI
C
      TVMAX = 1.D0

      DO 180 IEQUA = 2,NEQ
        NTBLC = NTBLC + ZI(JSCHC+IEQUA-1)
        IF (NTBLC.LE.ITBLOC) THEN
C         ON PEUT TOUJOURS AJOUTER LA COLONNE DANS LE BLOC
          ZI(JSCDI+IEQUA-1) = ZI(JSCDI+IEQUA-2) + ZI(JSCHC+IEQUA-1)
        ELSE

C         LA COLONNE NE PEUT PAS ENTRER DANS LE NOUVEAU BLOC
C         TAUX DE VIDE LAISSE DANS LE BLOC
          TV = (ITBLOC-NTBLC)/ITBLOC
          IF (TV.GE.TVMAX) THEN
            TVMAX = TV
            IF (TVMAX.GE.TVALA) THEN
              IVALA = IVALA+1
            ENDIF
          ENDIF
C         NOUVEAU BLOC
          NTBLC = ZI(JSCHC+IEQUA-1)
          IF (NTBLC.GT.ITBLOC) THEN
           CALL UTDEBM('F','CRSDCO','---')
           CALL UTIMPI('L',' LA TAILLE BLOC  :',1,ITBLOC)
           CALL UTIMPI('S','EST < HAUTEUR_MAX :',1,HMAX)
           CALL UTIMPK('L',' CHANGEZ LA TAILLE_BLOC DES PROFILS:',0,' ')
           CALL UTIMPI('S',' PRENEZ AU MOINS :',1,HMAX/1024+1)
           CALL UTFINM()
          ENDIF
          NBLC = NBLC + 1
          ZI(JSCDI+IEQUA-1) = ZI(JSCHC+IEQUA-1)
        END IF
  180 CONTINUE
C
C --- AFFICHAGES
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '--- TAILLE MAXI DES BLOCS          : ',ITBLOC
        WRITE (IFM,*) '--- HAUTEUR MAXIMUM D''UNE COLONNE  : ',HMAX
        WRITE (IFM,*) '--- TAUX DE VIDE MAXI DANS UN BLOC : ',TVMAX
        WRITE (IFM,*) '--- NOMBRE DE BLOCS UTILISES       : ',NBLC
        WRITE (IFM,*) '--- TAUX DE VIDE PROVOQUANT ALARME : ',TVALA
        WRITE (IFM,*) '--- NOMBRE DE BLOCS ALARMANT       : ',IVALA
      END IF
C
C --- CREATION SCBL
C
      CALL WKVECT (STOC//'.SCBL','V V I',NBLC+1,JSCBL)

      ZI(JSCBL) = 0
      IBLC      = 1
      NTBLC     = ZI(JSCHC)

      DO 190 IEQUA = 2,NEQ
        NTBLC = NTBLC + ZI(JSCHC+IEQUA-1)
        IF (NTBLC.GT.ITBLOC) THEN
          NTBLC = ZI(JSCHC+IEQUA-1)
          ZI(JSCBL+IBLC) = IEQUA - 1
          IBLC = IBLC + 1
        END IF
  190 CONTINUE
      ZI(JSCBL+NBLC) = NEQ
      IF (NBLC.EQ.1) THEN
        ITBLOC = NTBLC
      END IF
C
C --- CREATION .SCIB
C
      CALL WKVECT(STOC//'.SCIB','V V I',NEQ,JSCIB)
      ICOMPT = 0
      DO 210 I = 1,NBLC
        NBCOL = ZI(JSCBL+I) - ZI(JSCBL+I-1)
        DO 200 J = 1,NBCOL
          ICOMPT = ICOMPT + 1
          ZI(JSCIB-1+ICOMPT) = I
  200   CONTINUE
  210 CONTINUE
      IF (ICOMPT.NE. (NEQ)) THEN
        CALL UTMESS('F','CRSDCO','ERREUR PGMEUR 1')
      END IF
C
C --- CREATION .SCDE
C
      CALL WKVECT(STOC//'.SCDE','V V I',6,JSCDE)
      ZI(JSCDE-1+1) = NEQ
      ZI(JSCDE-1+2) = ITBLOC
      ZI(JSCDE-1+3) = NBLC
      ZI(JSCDE-1+4) = HMAX
C
C --- ON CREE AUSSI LE STOCKAGE "MORSE" CORRESPONDANT A UNE
C ---    MATRICE PLEINE
C
      CALL CRNSLV(STOC(1:14),'LDLT','SANS','V')
C
C --- OBJET MATR_ASSE
C
      MATR   = RESOSD(1:14)//'.MATR'
C
      CALL WKVECT(MATR//'.REFA','V V K24',10,JREFA)
      ZK24(JREFA-1+1)  = NOMA
      ZK24(JREFA-1+2)  = RESOSD(1:14)
      ZK24(JREFA-1+9)  = 'MS'
      ZK24(JREFA-1+10) = 'NOEU'
C
      CALL WKVECT(MATR//'.&VDI','V V R',NEQ,JBID)
      CALL WKVECT(MATR//'.&TRA','V V R',NEQ,JBID)
      CALL WKVECT(MATR//'.LIME','V V K8',1,JBID)
      ZK8(JBID) = ' '
C
      CALL JECREC (MATR//'.UALF','V V R','NU','DISPERSE'
     &     ,'CONSTANT',NBLC)
      CALL JEECRA (MATR//'.UALF','LONMAX',
     &     NEQ*(NEQ+1)/2,K8BID)
      DO 4 II = 1, NBLC
         CALL JECROC (JEXNUM(MATR//'.UALF',II))
         CALL JEVEUO (JEXNUM(MATR//'.UALF',II),'E',JBID)
         CALL JELIBE (JEXNUM(MATR//'.UALF',II))
 4    CONTINUE
C
 9999 CONTINUE
C
C ----------------------------------------------------------------------
      CALL JEDEMA ()
      END
