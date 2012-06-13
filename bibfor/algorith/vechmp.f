      SUBROUTINE VECHMP(NOMO  ,MATE  ,CARELE,VARPLU,LXFEM ,
     &                  PARTPS,TYPCAL,NOPASE,NBIN  ,LPAIN ,
     &                  LCHIN ,LASTIN)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      INTEGER       NBIN,LASTIN
      CHARACTER*8   LPAIN(NBIN)
      CHARACTER*19  LCHIN(NBIN)
      CHARACTER*8   NOMO
      LOGICAL       LXFEM
      CHARACTER*4   TYPCAL
      REAL*8        PARTPS(3)
      CHARACTER*19  VARPLU
      CHARACTER*24  MATE,CARELE
      CHARACTER*(*) NOPASE
C
C ----------------------------------------------------------------------
C
C CALCUL DES VECTEURS ELEMENTAIRES DES CHARGEMENTS MECANIQUES
C DE NEUMANN
C
C PREPARATION DES CHAMPS D'ENTREE STANDARDS
C
C ----------------------------------------------------------------------
C
C
C IN  NOMO   : NOM DU MODELE
C IN  TYPCAL : TYPE DU CALCUL :
C               'MECA', POUR LA RESOLUTION DE LA MECANIQUE,
C               'DLAG', POUR LE CALCUL DE LA DERIVEE LAGRANGIENNE
C IN  PARTPS : TABLEAU DONNANT T+, DELTAT ET THETA (POUR LE THM)
C IN  CARELE : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE   : MATERIAU CODE
C IN  VARPLU : VARIABLES DE COMMANDE A L'INSTANT T+
C IN  LXFEM  : .TRUE. SI XFEM
C IN  NOPASE : NOM DU PARAMETRE SENSIBLE
C              . POUR LA DERIVEE LAGRANGIENNE, C'EST UN CHAMP THETA
C IN  NBIN   : NOMBRE MAXI DE CHAMPS D'ENTREE
C OUT LPAIN  : LISTE DES PARAMETRES IN
C OUT LCHIN  : LISTE DES CHAMPS IN
C OUT LASTIN : NOMBRE EFFECTIF DE CHAMPS IN
C
C
C
C
      INTEGER      IBID,NUMORD,IRET
      CHARACTER*8  K8BID
      LOGICAL      EXICAR
      COMPLEX*16   C16BID
      CHARACTER*8  NOMCMP(3)
      CHARACTER*19 LIGRMO
      CHARACTER*19 CHGEOM,CHCARA(18),CHTIME
      CHARACTER*19 VECTTH,GRADTH
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      LIGRMO = NOMO(1:8)//'.MODELE'
      CALL ASSERT(TYPCAL.EQ.'MECA' .OR. TYPCAL.EQ.'DLAG')
C
C --- RECUPERATION CHAMPS POUR SENSIBILITE EN LAGRANGIEN
C
      IF (TYPCAL.EQ.'DLAG') THEN
        NUMORD = 0
        CALL RSEXCH(NOPASE,'THETA'          ,NUMORD,VECTTH,IRET)
        CALL RSEXCH(NOPASE,'GRAD_NOEU_THETA',NUMORD,GRADTH,IRET)
      END IF
C
C --- CHAMP DE GEOMETRIE
C
      CALL MECOOR(NOMO  ,CHGEOM)
C
C --- CHAMP DE CARACTERISTIQUES ELEMENTAIRES
C
      CALL MECARA(CARELE,EXICAR,CHCARA)
C
C --- CREATION DE LA CARTE DES INSTANTS
C
      CHTIME    = '&&VECHMP.CH_INST_R'
      NOMCMP(1) = 'INST'
      NOMCMP(2) = 'DELTAT'
      NOMCMP(3) = 'THETA'
      CALL MECACT('V'   ,CHTIME,'LIGREL',LIGRMO,'INST_R',
     &            3     ,NOMCMP,IBID    ,PARTPS,C16BID  ,
     &            K8BID )
C
C --- CHAMPS D'ENTREES STANDARDS
C
      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = CHGEOM
      LPAIN(2)  = 'PTEMPSR'
      LCHIN(2)  = CHTIME
      LPAIN(3)  = 'PMATERC'
      LCHIN(3)  = MATE(1:19)
      LPAIN(4)  = 'PCACOQU'
      LCHIN(4)  = CHCARA(7)
      LPAIN(5)  = 'PCAGNPO'
      LCHIN(5)  = CHCARA(6)
      LPAIN(6)  = 'PCADISM'
      LCHIN(6)  = CHCARA(3)
      LPAIN(7)  = 'PCAORIE'
      LCHIN(7)  = CHCARA(1)
      LPAIN(8)  = 'PCACABL'
      LCHIN(8)  = CHCARA(10)
      LPAIN(9)  = 'PCAARPO'
      LCHIN(9)  = CHCARA(9)
      LPAIN(10) = 'PCAGNBA'
      LCHIN(10) = CHCARA(11)
      LPAIN(11) = 'PVARCPR'
      LCHIN(11) = VARPLU
      LPAIN(12) = 'PCAMASS'
      LCHIN(12) = CHCARA(12)
      LPAIN(13) = 'PCAGEPO'
      LCHIN(13) = CHCARA(5)
      LPAIN(14) = 'PNBSP_I'
      LCHIN(14) = CHCARA(16)
      LPAIN(15) = 'PFIBRES'
      LCHIN(15) = CHCARA(17)
      LPAIN(16) = 'PCINFDI'
      LCHIN(16) = CHCARA(15)
      LASTIN    = 16
C
C --- CHAMPS NECESSAIRES POUR XFEM
C
      IF (LXFEM) THEN
        LPAIN(17) = 'PPINTTO'
        LCHIN(17) = NOMO(1:8)//'.TOPOSE.PIN'
        LPAIN(18) = 'PCNSETO'
        LCHIN(18) = NOMO(1:8)//'.TOPOSE.CNS'
        LPAIN(19) = 'PHEAVTO'
        LCHIN(19) = NOMO(1:8)//'.TOPOSE.HEA'
        LPAIN(20) = 'PLONCHA'
        LCHIN(20) = NOMO(1:8)//'.TOPOSE.LON'
        LPAIN(21) = 'PLSN'
        LCHIN(21) = NOMO(1:8)//'.LNNO'
        LPAIN(22) = 'PLST'
        LCHIN(22) = NOMO(1:8)//'.LTNO'
        LPAIN(23) = 'PSTANO'
        LCHIN(23) = NOMO(1:8)//'.STNO'
        LPAIN(24) = 'PPMILTO'
        LCHIN(24) = NOMO(1:8)//'.TOPOSE.PMI'
        LPAIN(25) = 'PFISNO'
        LCHIN(25) = NOMO(1:8)//'.FISSNO'
        LPAIN(26) = 'PPINTER'
        LCHIN(26) = NOMO(1:8)//'.TOPOFAC.OE'
        LPAIN(27) = 'PAINTER'
        LCHIN(27) = NOMO(1:8)//'.TOPOFAC.AI'
        LPAIN(28) = 'PCFACE'
        LCHIN(28) = NOMO(1:8)//'.TOPOFAC.CF'
        LPAIN(29) = 'PLONGCO'
        LCHIN(29) = NOMO(1:8)//'.TOPOFAC.LO'
        LPAIN(30) = 'PBASECO'
        LCHIN(30) = NOMO(1:8)//'.TOPOFAC.BA'
        LASTIN    = 30
      ENDIF
C
C --- PCOMPOR UTILE POUR POUTRES MULTI-FIBRES
C
      LASTIN = LASTIN + 1
      LPAIN(LASTIN) = 'PCOMPOR'
      LCHIN(LASTIN) =  MATE(1:8)//'.COMPOR'
C
C --- CHAMPS POUR SENSIBILITE
C
      IF (TYPCAL.EQ.'DLAG') THEN
        LASTIN = LASTIN + 1
        LPAIN(LASTIN) = 'PVECTTH'
        LCHIN(LASTIN) = VECTTH
        LASTIN = LASTIN + 1
        LPAIN(LASTIN) = 'PGRADTH'
        LCHIN(LASTIN) = GRADTH
      ENDIF
C
      CALL ASSERT(LASTIN.LE.NBIN)
C
      CALL JEDEMA()
      END
