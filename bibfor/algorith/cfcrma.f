      SUBROUTINE CFCRMA(NEQMAT,NOMA  ,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/09/2011   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT     NONE
      INTEGER      NEQMAT
      CHARACTER*8  NOMA
      CHARACTER*24 RESOCO
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE DISCRETE - CREATION SD)
C
C CREATION DE LA MATRICE DE "CONTACT"
C CETTE MATRICE EST STOCKEE EN LIGNE DE CIEL
C TRIANGULAIRE SYMETRIQUE PLEINE
C
C ----------------------------------------------------------------------
C 
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  NEQMAT : NOMBRE D'EQUATIONS DE LA MATRICE DE CONTACT
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
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
      INTEGER      VALI(3)
      REAL*8       TMAX,JEVTBL,TVALA,TVMAX,TV
      INTEGER      ITBLOC,HMAX,IVALA,NTBLC,NBLC,NBCOL,TBMAX
      CHARACTER*19 STOC,MACONT
      CHARACTER*24 VALK
      CHARACTER*8  K8BID
      INTEGER      IEQ,ICOL,ICOMPT,IBLC
      INTEGER      JSCHC,JSCDI,JSCBL,JSCIB,JSCDE
      INTEGER      JREFA,JLIME
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- TAILLE MAXI D'UN BLOC
C
      TMAX   = JEVTBL()
      ITBLOC = NINT(TMAX*1024)
C
C --- TAUX DE VIDE MAXI D'UN BLOC POUR ALARME
C
      TVALA  = 0.25D0
C
C --- HAUTEUR MAXI D'UNE COLONNE
C
      HMAX   = NEQMAT
C
C --- OBJET NUME_DDL
C
      STOC   = RESOCO(1:14)//'.SLCS'
C
C --- OBJET MATR_ASSE DE CONTACT DUALISEE ACM1AT
C
      MACONT = RESOCO(1:14)//'.MATC'
C
C --- CREATION .SCHC
C
      CALL WKVECT(STOC(1:19)//'.SCHC','V V I',NEQMAT,JSCHC)
      DO 5 IEQ = 1, NEQMAT
        ZI(JSCHC+IEQ-1) = IEQ
 5    CONTINUE
C
C --- CREATION .SCDI
C
      CALL WKVECT(STOC(1:19)//'.SCDI','V V I',NEQMAT,JSCDI)
      DO 6 IEQ = 1, NEQMAT
        ZI(JSCDI+IEQ-1) = IEQ*(IEQ+1)/2
 6    CONTINUE
C
C --- LA TAILLE DE BLOC DOIT ETRE SUPERIEURE A HMAX
C --- POUR CONTENIR AU MOINS LA DERNIERE COLONNE
C
      IF (HMAX.GT.ITBLOC) THEN
        VALI (1) = ITBLOC
        VALI (2) = HMAX
        VALI (3) = HMAX/1024+1
        VALK = ' '
        CALL U2MESG('F', 'ALGORITH12_41',1,VALK,3,VALI,0,0.D0)
      ENDIF
C
C --- ON FAIT LA PREMIERE COLONNE (DU 1ER BLOC) A PART
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
C --- NOMBRE DE BLOCS TROP VIDES
C
      IVALA = 0
C
C --- TAUX DE VIDE MAXI
C
      TVMAX = 0.D0
C
C --- TAILLE MAXI D'UN BLOC
C
      TBMAX = 0
C
C --- CALCUL DU NOMBRE DE BLOCS ET MISE A JOUR DE SCDI
C
      DO 180 IEQ = 2,NEQMAT
        NTBLC = NTBLC + ZI(JSCHC+IEQ-1)
        IF (NTBLC.LE.ITBLOC) THEN
C         ON PEUT TOUJOURS AJOUTER LA COLONNE DANS LE BLOC
          ZI(JSCDI+IEQ-1) = ZI(JSCDI+IEQ-2) + ZI(JSCHC+IEQ-1)
        ELSE
C         LA COLONNE NE PEUT PAS ENTRER DANS LE NOUVEAU BLOC
C         TAUX DE VIDE LAISSE DANS LE BLOC
          TV = (1.D0*ITBLOC-ZI(JSCDI+IEQ-2))/ITBLOC
          IF (TV.GE.TVMAX) THEN
            TVMAX = TV
          ENDIF
          IF (TV.GE.TVALA) THEN
            IVALA = IVALA+1
          ENDIF
          IF (ZI(JSCDI+IEQ-2).GE.TBMAX) THEN
            TBMAX = ZI(JSCDI+IEQ-2)
          ENDIF
C         NOUVEAU BLOC
          NTBLC = ZI(JSCHC+IEQ-1)
          NBLC  = NBLC + 1
          ZI(JSCDI+IEQ-1) = ZI(JSCHC+IEQ-1)
        END IF
  180 CONTINUE

      IF (ZI(JSCDI-1+NEQMAT).GE.TBMAX) THEN
        TBMAX = ZI(JSCDI-1+NEQMAT)
      ENDIF
C
C --- AFFICHAGES
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '--- TAILLE MAXI DES BLOCS              : ',ITBLOC
        WRITE (IFM,*) '--- HAUTEUR MAXIMUM D''UNE COLONNE     : ',HMAX
        WRITE (IFM,*) '--- TAUX DE VIDE MAXI DANS UN BLOC     : ',TVMAX
        WRITE (IFM,*) '--- TAILLE MAXI UTILISEE POUR UN BLOC  : ',TBMAX
        WRITE (IFM,*) '--- NOMBRE DE BLOCS UTILISES           : ',NBLC
        WRITE (IFM,*) '--- TAUX DE VIDE PROVOQUANT ALARME     : ',TVALA
        WRITE (IFM,*) '--- NOMBRE DE BLOCS ALARMANT           : ',IVALA
      END IF
C
C --- CREATION .SCBL
C
      CALL WKVECT(STOC(1:19)//'.SCBL','V V I',NBLC+1,JSCBL)
      ZI(JSCBL) = 0
      IBLC      = 1
      NTBLC     = ZI(JSCHC)

      DO 190 IEQ = 2,NEQMAT
        NTBLC = NTBLC + ZI(JSCHC+IEQ-1)
        IF (NTBLC.GT.ITBLOC) THEN
          NTBLC          = ZI(JSCHC+IEQ-1)
          ZI(JSCBL+IBLC) = IEQ - 1
          IBLC           = IBLC + 1
        END IF
  190 CONTINUE
      CALL ASSERT(IBLC.EQ.NBLC)
      ZI(JSCBL+NBLC) = NEQMAT
C
C --- CREATION .SCIB
C
      CALL WKVECT(STOC(1:19)//'.SCIB','V V I',NEQMAT,JSCIB)
      ICOMPT = 0
      DO 210 IBLC = 1,NBLC
        NBCOL = ZI(JSCBL+IBLC) - ZI(JSCBL+IBLC-1)
        DO 200 ICOL = 1,NBCOL
          ICOMPT = ICOMPT + 1
          ZI(JSCIB-1+ICOMPT) = IBLC
  200   CONTINUE
  210 CONTINUE
      CALL ASSERT (ICOMPT.EQ.NEQMAT)
C
C --- CREATION .SCDE
C
      CALL WKVECT(STOC//'.SCDE','V V I',6,JSCDE)
      ZI(JSCDE-1+1) = NEQMAT
      ZI(JSCDE-1+2) = ITBLOC
      ZI(JSCDE-1+3) = NBLC
      ZI(JSCDE-1+4) = HMAX
C
C --- ON CREE AUSSI LE STOCKAGE "MORSE" CORRESPONDANT A UNE
C --- MATRICE PLEINE
C
      CALL CRNSLV(STOC(1:14),'LDLT','SANS','V')
C
C --- CREATION .REFA
C
      CALL WKVECT(MACONT(1:19)//'.REFA','V V K24',11,JREFA)
      ZK24(JREFA-1+11) = 'MPI_COMPLET'
      ZK24(JREFA-1+1)  = NOMA
      ZK24(JREFA-1+2)  = RESOCO(1:14)
      ZK24(JREFA-1+9)  = 'MS'
      ZK24(JREFA-1+10) = 'NOEU'
C
C --- CREATION .LIME
C
      CALL WKVECT(MACONT(1:19)//'.LIME','V V K24',1,JLIME)
      ZK24(JLIME) = ' '
C
C --- CREATION .UALF
C
      CALL JECREC(MACONT(1:19)//'.UALF','V V R','NU','DISPERSE'
     &     ,'CONSTANT',NBLC)
      CALL JEECRA(MACONT(1:19)//'.UALF','LONMAX',TBMAX,K8BID)
      DO 4 IBLC = 1, NBLC
        CALL JECROC(JEXNUM(MACONT(1:19)//'.UALF',IBLC))
 4    CONTINUE
C
C ----------------------------------------------------------------------
      CALL JEDEMA ()
      END
