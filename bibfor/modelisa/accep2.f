      SUBROUTINE ACCEP2(MODMEC,NBM,PGOUT,PHIOUT,SPHOUT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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

      IMPLICIT NONE
C-----------------------------------------------------------------------
C     OPERATEUR PROJ_SPEC_BASE
C     CREATION DE LA MATRICE DES MODES PROPRES DEFINIS SUR LES POINTS DE
C     GAUSS ET DE LA LISTE DES POINTS DE GAUSS ASSOCIES AVEC LEURS
C     COORDONNEES
C-----------------------------------------------------------------------
C IN  : MODMEC : BASE DE MODES A EXPTRAPOLER
C IN  : NBM    : NOMBRE DE MODES PROPRES
C OUT : PGOUT  : CHAM_ELEM_S CONTENANT LES COORDONNEES DES POINTS DE
C                GAUSS ET LEURS POIDS RESPECTIFS
C OUT : PHIOUT : VECTEUR CONTENANT LES NOMS DES MODES PROPRES DEFINIS
C                AUX POINTS DE GAUSS (CHAM_ELEM_S)
C OUT : SPHOUT: VECTEUR CONTENANT LES NOMS DES CHAM_ELEM_S INITIALISES
C                A 0 COMPLEXES
C-----------------------------------------------------------------------


      INCLUDE 'jeveux.h'
      INTEGER      IRET,IDM,IBID,NBM,INOCHA,ISNCHA,NBCHIN,NBCHOU,IARG
      CHARACTER*6  CHAINE
      CHARACTER*8  MOINT,MODMEC
      PARAMETER    (NBCHIN=1,NBCHOU=1)
      CHARACTER*8  LPAIN(NBCHIN),LPAOU(NBCHOU)
      CHARACTER*19 NOCHNO, NOCHNS, NCHES1, NCHES2, NCHEL1, MNOGA
      CHARACTER*19 NOCHEL,LCHIN(NBCHIN),LCHOU(NBCHOU),PGOUT,PHIOUT
      CHARACTER*19 NCHELC,NCHESC,SPHOUT
      CHARACTER*24 LIGREL,CHGEOM
      CHARACTER*8  PARAM
      CHARACTER*16 OPTION
      LOGICAL      EXIGEO


C-----------------------------------------------------------------------
      CALL JEMARQ()

C RECUPERE LE MODELE ASSOCIE A LA BASE
      CALL GETVID(' ','MODELE_INTERFACE',0,IARG,1,MOINT,IBID)
      IF (IBID.EQ.0) THEN
        CALL U2MESS('F','MODELISA10_14')
      ENDIF

C NOMS DE CHAMPS PROVISOIRES
      NOCHNS='&&ACCEP2.CHNOS'
      LIGREL='&&ACCEP2.LIGREL'
      NCHEL1='&&ACCEP2.CHELEL'
      NCHELC='&&ACCEP2.CHELELC'
      NCHES1='&&ACCEP2.CHELES1'
      MNOGA='&&ACCEP.MNOGA'
C LIGREL ASSOCIE AU MODELE ET A UN GROUPE DE MAILLE
      CALL EXLIMA(' ',0,'V',MOINT,LIGREL)

C CREATION DES CHAMPS DES MODES PROPRES INTERPOLES SUR LEURS
C POINTS DE GAUSS - LES '&&SFIFJ.0000XX'

C VECTEUR DE TRAVAIL CONTENANT LES NOMS '&&SFIFJ.0000XX'
      CALL WKVECT('&&SFIFJ.PHI','V V K24',NBM,INOCHA)
      CALL WKVECT('&&SFIFJ.SPHI','V V K24',NBM,ISNCHA)

C BOUCLE SUR LES NUMEROS D'ORDRE
      DO 10 IDM = 1,NBM
        CALL CODENT(IDM,'D',CHAINE)
C NCHESC : CHAM_ELEM_S COMPLEXE. UNIQUEMENT POUR INITIALISATION
        NCHESC='&&SFIFJ.SPHI.'//CHAINE
C NCHES2 : CHAM_ELEM_S CONTENANT LES MODES INTERPOLES AUX PDG
        NCHES2='&&SFIFJ.PHI.'//CHAINE
        ZK24(INOCHA-1+IDM)=NCHES2
        ZK24(ISNCHA-1+IDM)=NCHESC
C RECUPERATION DU CHAMP CORRESPONDANT AU NUM ORDRE
        CALL RSEXCH(MODMEC,'DEPL',IDM,NOCHNO,IRET)
        CALL CNOCNS(NOCHNO,'V',NOCHNS)
C FABRICATION D'UN CHAM_ELEM VIERGE (UN REEL) ET UN COMPLEXE)
        CALL ALCHML(LIGREL,'TOU_INI_ELGA',
     &              'PDEPL_R','V',NCHEL1,IRET,' ')
        CALL ALCHML(LIGREL,'TOU_INI_ELGA',
     &              'PDEPL_C','V',NCHELC,IRET,' ')
        CALL CELCES(NCHEL1,'V',NCHES1)
        CALL CELCES(NCHELC,'V',NCHESC)
        CALL DISMOI('F','NOM_OPTION',NCHEL1,
     &               'CHAM_ELEM',IBID,OPTION,IBID)
        CALL DISMOI('F','NOM_PARAM',NCHEL1,
     &              'CHAM_ELEM',IBID,PARAM,IBID)
        CALL MANOPG(LIGREL,OPTION,PARAM,MNOGA)
C INTERPOLER LE CHAM NO SIMPLE SUR LES PDG
        CALL CNSCES(NOCHNS,'ELGA',NCHES1,MNOGA,'V',NCHES2)
C DESTRUCTION DES CHAMPS TEMPORAIRES
        CALL DETRSD('CHAM_NO_S',NOCHNS)
        CALL DETRSD('CHAM_ELEM_S',NCHES1)
        CALL DETRSD('CHAM_ELEM',NCHELC)
        CALL DETRSD('CHAM_ELEM',NCHEL1)
10    CONTINUE

      PHIOUT='&&SFIFJ.PHI'
      SPHOUT='&&SFIFJ.SPHI'

C 2 - CREATION D'UN CHAM_ELEM_S CONTENANT LES COORDONNEES
C     DES POINTS DE GAUSS ET LEUR POIDS
      CALL MEGEOM(MOINT,' ',EXIGEO,CHGEOM)
      IF (.NOT.EXIGEO) CALL U2MESS('F','MODELISA10_2')
      LCHIN(1)=CHGEOM(1:19)
      LPAIN(1)='PGEOMER'
      LCHOU(1)='&&ACCEP2.PGCOOR'
      LPAOU(1)='PCOORPG'
      CALL CALCUL('C','COOR_ELGA',LIGREL,NBCHIN,LCHIN,LPAIN,
     &            NBCHOU,LCHOU,LPAOU,'V','OUI')
      PGOUT='&&SFIFJ.PGCOOR'
      CALL CELCES(LCHOU(1),'V',PGOUT)

      CALL JEDEMA()
      END
