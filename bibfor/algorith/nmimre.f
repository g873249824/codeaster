      SUBROUTINE NMIMRE(NUMEDD,SDIMPR,SDCONV,VRELA ,VMAXI ,
     &                  VREFE, VCOMP ,VFROT ,VGEOM ,IRELA ,
     &                  IMAXI ,IREFE ,NODDLM,ICOMP ,NFROT ,
     &                  NGEOM )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/09/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      INCLUDE      'jeveux.h'
      CHARACTER*24 NUMEDD,SDIMPR,SDCONV
      INTEGER      IRELA,IMAXI,IREFE,ICOMP
      REAL*8       VRELA,VMAXI,VREFE,VCOMP,VFROT,VGEOM
      CHARACTER*8  NODDLM
      CHARACTER*16 NFROT,NGEOM
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C IMPRESSION DES INFORMATIONS SUR LES RESIDUS DANS LE TABLEAU DE
C CONVERGENCE
C
C ----------------------------------------------------------------------
C
C
C IN  NUMEDD : NUMEROTATION NUME_DDL
C IN  SDIMPR : SD AFFICHAGE
C IN  SDCONV : SD GESTION DE LA CONVERGENCE
C IN  IRELA  : NUMERO DU DDL SUR LAQUELLE NORME_MAX (RESI_GLOB_RELA)
C IN  VRELA  : VALEUR NORME_MAX (RESI_GLOB_RELA)
C IN  IMAXI  : NUMERO DU DDL SUR LAQUELLE NORME_MAX (RESI_GLOB_MAXI)
C IN  VMAXI  : VALEUR NORME_MAX (RESI_GLOB_MAXI)
C IN  IREFE  : NUMERO DU DDL SUR LAQUELLE NORME_MAX (RESI_GLOB_REFE)
C IN  VREFE  : VALEUR NORME_MAX (RESI_GLOB_REFE)
C IN  ICOMP  : NUMERO DU NOEUD SUR LAQUELLE NORME_MAX (RESI_COMP_RELA)
C IN  VCOMP  : VALEUR NORME_MAX (RESI_COMP_RELA)
C IN  VFROT  : VALEUR NORME_MAX POUR RESI_FROT
C IN  NFROT  : LIEU OU VALEUR NORME_MAX POUR RESI_FROT
C IN  VGEOM  : VALEUR NORME_MAX POUR RESI_GEOM
C IN  NGEOM  : LIEU OU VALEUR NORME_MAX POUR RESI_GEOM
C
C ----------------------------------------------------------------------
C
      CHARACTER*24 CNVLIE,CNVVAL,CNVNCO
      INTEGER      JCNVLI,JCNVVA,JCNVNC
      CHARACTER*16 NRELA,NMAXI,NREFE,NCOMP
      INTEGER      IRESI,NRESI
      REAL*8       VALE,R8VIDE
      CHARACTER*16 LIEU
      CHARACTER*8  K8BID
      CHARACTER*9  COLONN
      LOGICAL      LAFFE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- ACCES SD CONVERGENCE
C
      CNVLIE = SDCONV(1:19)//'.LIEU'
      CNVVAL = SDCONV(1:19)//'.VALE'
      CNVNCO = SDCONV(1:19)//'.NCOL'
      CALL JEVEUO(CNVLIE,'E',JCNVLI)
      CALL JEVEUO(CNVVAL,'E',JCNVVA)
      CALL JEVEUO(CNVNCO,'L',JCNVNC)
      CALL JELIRA(CNVNCO,'LONMAX',NRESI,K8BID)
C
C --- NOM DES DDLS
C
      CALL IMPCMP(IRELA ,NUMEDD,NRELA )
      CALL IMPCMP(IMAXI ,NUMEDD,NMAXI )
      CALL IMPCMP(IREFE ,NUMEDD,NREFE )
      CALL IMPCOM(ICOMP ,NODDLM,NCOMP )
C
C --- BOUCLE SUR LES RESIDUS
C
      LAFFE = .TRUE.
      DO 10 IRESI = 1,NRESI
        COLONN = ZK16(JCNVNC-1+IRESI)(1:9)
        LIEU   = ' '
        VALE   = R8VIDE()
        IF (COLONN.EQ.'RESI_RELA') THEN
          VALE = VRELA
          LIEU = NRELA
          CALL NMIMCR(SDIMPR,'RESI_RELA',VRELA,LAFFE )
          CALL NMIMCK(SDIMPR,'RELA_NOEU',NRELA,LAFFE )
        ELSEIF (COLONN.EQ.'RESI_MAXI') THEN
          VALE = VMAXI
          LIEU = NMAXI
          CALL NMIMCR(SDIMPR,'RESI_MAXI',VMAXI,LAFFE )
          CALL NMIMCK(SDIMPR,'MAXI_NOEU',NMAXI,LAFFE )
        ELSEIF (COLONN.EQ.'RESI_REFE') THEN
          VALE = VREFE
          LIEU = NREFE
          CALL NMIMCR(SDIMPR,'RESI_REFE',VREFE,LAFFE )
          CALL NMIMCK(SDIMPR,'REFE_NOEU',NREFE,LAFFE )
        ELSEIF (COLONN.EQ.'RESI_COMP') THEN
          VALE = VCOMP
          LIEU = NCOMP
          CALL NMIMCR(SDIMPR,'RESI_COMP',VCOMP,LAFFE )
          CALL NMIMCK(SDIMPR,'COMP_NOEU',NCOMP,LAFFE )
        ELSEIF (COLONN.EQ.'FROT_NEWT') THEN
          VALE = VFROT
          LIEU = NFROT
          CALL NMIMCR(SDIMPR,'FROT_NEWT',VFROT,LAFFE )
          CALL NMIMCK(SDIMPR,'FROT_NOEU',NFROT,LAFFE )
        ELSEIF (COLONN.EQ.'GEOM_NEWT') THEN
         VALE = VGEOM
         LIEU = NGEOM
         CALL NMIMCR(SDIMPR,'GEOM_NEWT',VGEOM,LAFFE )
         CALL NMIMCK(SDIMPR,'GEOM_NOEU',NGEOM,LAFFE )
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
        ZR(JCNVVA-1+IRESI)   = VALE
        ZK16(JCNVLI-1+IRESI) = LIEU
  10  CONTINUE
C
      CALL JEDEMA()
      END
