      SUBROUTINE MLAGRG(OPTION,RESULT,MODELE,DEPLA,THETA,ALPHA,MATE,
     &                  NCHAR,LCHAR,SYMECH,EXTIM,TIME,IORD,NBPRUP,
     &                  NOPRUP)
       IMPLICIT   NONE
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 24/05/2004   AUTEUR GALENNE E.GALENNE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     - FONCTION REALISEE:   CALCUL DU TAUX DE RESTITUTION D'ENERGIE

C IN   OPTION  --> CALC_G_LAGR      (SI CHARGES REELLES)
C              --> CALC_G_LAGR_F    (SI CHARGES FONCTIONS)
C              --> CALC_GLAG_EPSI_R (DEFORMATIONS INITIALES REELLES)
C              --> CALC_GLAG_EPSI_F (DEFORMATIONS INITIALES FONCTIONS)
C IN   RESULT  --> NOM UTILISATEUR DU RESULTAT ET TABLE
C IN   MODELE  --> NOM DU MODELE
C IN   DEPLA   --> CHAMP DE DEPLACEMENT
C IN   THETA   --> CHAMP THETA
C IN   ALPHA   --> VALEUR DE LA PROPAGATION LAGRANGIENNE
C IN   MATE    --> CHAMP DU MATERIAU
C IN   NCHAR   --> NOMBRE DE CHARGES
C IN   LCHAR   --> LISTE DES CHARGES
C IN   SYMECH  --> SYMETRIE DU CHARGEMENT
C IN   EXTIM   --> VRAI SI L'INSTANT EST DONNE
C IN   TIME    --> INSTANT DE CALCUL
C IN   IORD    --> NUMERO D'ORDRE DE LA SD
C ......................................................................
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------

      INTEGER IERD,IRET,IBID,IORD,I,NBCHIN,NBPRUP
      INTEGER JTEMP,NCHAR,IFM,NIV

      REAL*8 TIME,G,ALPHA,VAL(2)

      COMPLEX*16 CBID

      LOGICAL EXTIM,EXIGEO,EXITHE,EXITRF,FONC,EPSI

      CHARACTER*8 MODELE,SYMECH,NOMA,KBID,RESULT,K8B
      CHARACTER*8 LPAIN(12),LPAOUT(1),LCHAR(*),REPK
      CHARACTER*16 OPTION,NOPRUP(*)
      CHARACTER*24 DEPLA,LIGRMO,TEMPE,CHGEOM,THETA,CHPESA,CF2D3D
      CHARACTER*24 CHTEMP,CHTREF,CHVOLU,CF1D2D,CHPRES,CHEPSI,CHROTA
      CHARACTER*24 LCHIN(12),LCHOUT(1),CHALPH,CHTIME,MATE
      CHARACTER*24 PAVOLU,PA1D2D,PAPRES,OBVALE
C ......................................................................

C- RECUPERATION DU CHAMP GEOMETRIQUE

      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
      NOMA = CHGEOM

C- RECUPERATION (S'ILS EXISTENT) DES CHAMP DE TEMPERATURES (T,TREF)

      TEMPE = ' '
      DO 10 I = 1,NCHAR
        CALL JEEXIN(LCHAR(I)//'.CHME.TEMPE.TEMP',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(LCHAR(I)//'.CHME.TEMPE.TEMP','L',JTEMP)
          TEMPE = ZK8(JTEMP)
        END IF
   10 CONTINUE

      CHTEMP = '&&MLAGRG.CH_TEMP_R'
      CALL METREF(MATE,NOMA,EXITRF,CHTREF)
      CALL METEMP(CHGEOM(1:8),TEMPE,EXTIM,TIME,CHTREF,EXITHE,
     &            CHTEMP(1:19))
      CALL DISMOI('F','ELAS_F_TEMP',MATE,'CHAM_MATER',IBID,REPK,IERD)
      IF (REPK.EQ.'OUI') THEN
        IF (.NOT.EXITHE) THEN
          CALL UTMESS('F','MLAGRG',
     &                'LE MATERIAU DEPEND DE LA TEMPERATURE'//
     &                '! IL N''Y A PAS DE CHAMP DE TEMPERATURE '//
     &                '! LE CALCUL EST IMPOSSIBLE ')
        END IF
        IF (.NOT.EXITRF) THEN
          CALL UTMESS('A',' MLAGRG',
     &                'LE MATERIAU DEPEND DE LA TEMPERATURE'//
     &                ' IL N''Y A PAS DE TEMPERATURE DE REFERENCE'//
     &                ' ON PRENDRA DONC LA VALEUR 0')
        END IF
      END IF

C - TRAITEMENT DES CHARGES

      CALL GCHARG(MODELE,NCHAR,LCHAR,CHVOLU,CF1D2D,CF2D3D,CHPRES,CHEPSI,
     &            CHPESA,CHROTA,FONC,EPSI,TIME,IORD)
      IF (FONC) THEN
        PAVOLU = 'PFFVOLU'
        PA1D2D = 'PFF1D2D'
        PAPRES = 'PPRESSF'
      ELSE
        PAVOLU = 'PFRVOLU'
        PA1D2D = 'PFR1D2D'
        PAPRES = 'PPRESSR'
      END IF

C- CREATION DU CHAMP ALPHA

      CALL MEALPH(NOMA,ALPHA,CHALPH)

      LIGRMO = MODELE//'.MODELE'

      LPAOUT(1) = 'PGTHETA'
      LCHOUT(1) = '&&CHGELE'

      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PDEPLAR'
      LCHIN(2) = DEPLA
      LPAIN(3) = 'PTHETAR'
      LCHIN(3) = THETA
      LPAIN(4) = 'PMATERC'
      LCHIN(4) = MATE
      LPAIN(5) = 'PTEMPER'
      LCHIN(5) = CHTEMP
      LPAIN(6) = 'PTEREF'
      LCHIN(6) = CHTREF
      LPAIN(7) = PAVOLU
      LCHIN(7) = CHVOLU
      LPAIN(8) = PA1D2D
      LCHIN(8) = CF1D2D
      LPAIN(9) = PAPRES
      LCHIN(9) = CHPRES
      LPAIN(10) = 'PALPHAR'
      LCHIN(10) = CHALPH

      IF (FONC) THEN
        CHTIME = '&&MLAGRG.CH_INST_R'
        CALL MECACT('V',CHTIME,'MODELE',LIGRMO,'INST_R',1,'INST',IBID,
     &              TIME,CBID,KBID)
        LPAIN(11) = 'PTEMPSR'
        LCHIN(11) = CHTIME
        IF (EPSI) THEN
          OPTION = 'CALC_GLAG_EPSI_F'
          LPAIN(12) = 'PEPSINF'
          LCHIN(12) = CHEPSI
          NBCHIN = 12
        ELSE
          OPTION = 'CALC_G_LAGR_F'
          NBCHIN = 11
        END IF
      ELSE
        IF (EPSI) THEN
          OPTION = 'CALC_GLAG_EPSI_R'
          LPAIN(11) = 'PEPSINF'
          LCHIN(11) = CHEPSI
          NBCHIN = 11
        ELSE
          OPTION = 'CALC_G_LAGR'
          NBCHIN = 10
        END IF
      END IF
      CALL CALCUL('S',OPTION,LIGRMO,NBCHIN,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &            'V')

C  SOMMATION DES G ELEMENTAIRES

      CALL MESOMM(LCHOUT(1),1,IBID,G,CBID,0,IBID)
      IF (SYMECH.NE.'SANS') G = 2.D0*G

C IMPRESSION DE G ET ECRITURE DANS LA TABLE RESU

      IF (NIV.GE.2) THEN
        OBVALE = LCHOUT(1) (1:19)//'.VALE'
        CALL JEIMPO('MESSAGE',OBVALE,' ',
     &              'OBJET CONTENANT LA VALEUR DE G SUR CHAQUE ELEMENT')
      END IF

      IF (NBPRUP.EQ.1) THEN
        CALL TBAJLI(RESULT,NBPRUP,NOPRUP,IBID,G,CBID,K8B,0)
      ELSE
        VAL(1) = TIME
        VAL(2) = G
        CALL TBAJLI(RESULT,NBPRUP,NOPRUP,IORD,VAL,CBID,K8B,0)
      END IF

      CALL DETRSD('CHAMP_GD',CHTEMP)
      CALL JEDETR('&&MLAGRG.VALG')
      CALL JEDETR('&&MELAGRG.CH_INST_R')

      CALL JEDEMA()
      END
