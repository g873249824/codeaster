      SUBROUTINE XGECFI(MODELE,DEPDEL)
      IMPLICIT NONE
      CHARACTER*8    MODELE
      CHARACTER*19   CHGEOM,DEPDEL
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/05/2009   AUTEUR MAZET S.MAZET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C          BUT : CREATION DES SD CONTENANT LA GEOMETRIE DES 
C                FACETTES DE CONTACT (ESCLAVES ET MAITRE)
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C                    
C  IN        PREMIE    : SI ON EST � LA PREMI�RE IT�RATION DE NEWTON
C  IN        MODELE    : NOM DE L'OBJET MODELE 
C  IN        DEPLA     : CHAMP DE DEPLACEMENTS
C  IN/OUT    GEOMES    : SD AVEC LES COORDONNES DE PTS.INT. ESCLAVES
C  IN/OUT    GEOMMA    : SD AVEC LES COORDONNES DE PTS.INT. MAITRES

C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*8   LPAIN(5),LPAOUT(2)
      CHARACTER*19  LCHIN(5),LCHOUT(2)
      CHARACTER*19  LIGREL,PINTER,LONCHA,NEWGES,NEWGEM
      CHARACTER*19  GESCLO,GMAITO
C ----------------------------------------------------------------------

      CALL JEMARQ()

      NEWGES='&&XGECFI.GEOESCL'
      NEWGEM='&&XGECFI.GEOMAIT'

      LIGREL = MODELE//'.MODELE'
      PINTER=MODELE//'.TOPOFAC.PI'
      LONCHA=MODELE//'.TOPOFAC.LO'
      GESCLO=MODELE//'.TOPOFAC.OE'
      GMAITO=MODELE//'.TOPOFAC.OM'

      LPAIN(1) = 'PDEPLA'
      LCHIN(1) = DEPDEL
      LPAIN(2) = 'PPINTER'
      LCHIN(2) = PINTER
      LPAIN(3) = 'PLONCHA'
      LCHIN(3) = LONCHA 
      LPAIN(4) = 'PGESCLO'
      LCHIN(4) = GESCLO
      LPAIN(5) = 'PGMAITO'
      LCHIN(5) = GMAITO

      LPAOUT(1) = 'PNEWGES'
      LCHOUT(1) = NEWGES
      LPAOUT(2) = 'PNEWGEM'
      LCHOUT(2) = NEWGEM

      CALL CALCUL('C','GEOM_FAC',
     &            LIGREL,5,LCHIN,LPAIN,2,LCHOUT,LPAOUT,'V')

C     ON COPIE LA NOUVELLE GEOMETRIE DANS LES SD DES FACETTES DE CONTACT

      CALL COPISD('CHAMP_GD','V',LCHOUT(1),MODELE//'.TOPOFAC.GE')
      CALL COPISD('CHAMP_GD','V',LCHOUT(2),MODELE//'.TOPOFAC.GM')

      CALL JEDETR(NEWGES)
      CALL JEDETR(NEWGEM)

      CALL JEDEMA()
      END
