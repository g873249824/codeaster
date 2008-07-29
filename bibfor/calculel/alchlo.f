      SUBROUTINE ALCHLO(OPT,LIGREL,NIN,LPAIN,LCHIN,NOUT,LPAOUT)
      IMPLICIT NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 28/07/2008   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE                            VABHHTS J.PELLET
C     ARGUMENTS:
C     ----------
      INTEGER OPT,NIN,NOUT
      CHARACTER*8 LPAIN(NIN),LPAOUT(NOUT)
      CHARACTER*19 LIGREL
      CHARACTER*19 LCHIN(NIN)
C ----------------------------------------------------------------------
C     ENTREES:
C      OPT : OPTION
C     LIGREL : NOM DE LIGREL

C     SORTIES:
C     CREATION DES CHAMPS LOCAUX DE NOMS &&CALCUL.NOMPAR(OPT)
C     LE CHAMP LOCAL EST UNE ZONE MEMOIRE TEMPORAIRE A LA ROUTINE CALCUL
C     QUI CONTIENDRA LES  VALEURS DES CHAMPS "BIEN RANGEES"
C     (POUR LES TE00IJ) DE TOUS LES ELEMENTS D'UN GREL.

C ----------------------------------------------------------------------
      COMMON /CAII02/IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS,
     +       IAOPPA,NPARIO,NPARIN,IAMLOC,ILMLOC,IADSGD
      COMMON /CAII05/IANOOP,IANOTE,NBOBTR,IAOBTR,NBOBMX
      INTEGER        NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      COMMON /CAII06/NBGR,IGR,NBELGR,JCTEAT,LCTEAT,IAWLOC,IAWLO2,IAWTYP
      COMMON /CAII08/IEL
C-----------------------------------------------------------------------

C     FONCTIONS EXTERNES:
C     -------------------
      INTEGER GRDEUR
      CHARACTER*8 SCALAI

C     VARIABLES LOCALES:
C     ------------------
      INTEGER IPARG,TAILLE,GD
      INTEGER IAOPTT,LGCO,IAOPMO,ILOPMO,IAOPNO,ILOPNO,IAOPDS
      INTEGER IAOPPA,NPARIO,IAMLOC,ILMLOC,IADSGD
      INTEGER IANOOP,IANOTE,NBOBTR,IAOBTR,NBOBMX,NPARIN
      INTEGER IEL,IPARIN,IPAROU,INDIK8,TYPELE,NUTE
      CHARACTER*24 NOCHL,NOCHL2
      CHARACTER*8 NOMPAR
      CHARACTER*8 SCAL
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      CHARACTER*1 K1BID
C ---------------- FIN COMMUNS NORMALISES  JEVEUX  --------------------


      CALL WKVECT('&&CALCUL.IA_CHLOC','V V I',3*NPARIO,IAWLOC)
      CALL WKVECT('&&CALCUL.IA_CHLO2','V V I',5*NPARIO*NBGR,IAWLO2)
      CALL WKVECT('&&CALCUL.TYPE_SCA','V V K8',NPARIO,IAWTYP)
      NBOBTR = NBOBTR + 1
      ZK24(IAOBTR-1+NBOBTR) = '&&CALCUL.IA_CHLOC'
      NBOBTR = NBOBTR + 1
      ZK24(IAOBTR-1+NBOBTR) = '&&CALCUL.IA_CHLO2'
      NBOBTR = NBOBTR + 1
      ZK24(IAOBTR-1+NBOBTR) = '&&CALCUL.TYPE_SCA'


C     -- INITIALISATION DE CAII06/IAWLO2:
      DO 99 IGR=1,NBGR
        NUTE=TYPELE(LIGREL,IGR)
        CALL MECOE1(OPT,NUTE)
 99   CONTINUE


      DO 40 IPARG = 1,NPARIO
        NOMPAR = ZK8(IAOPPA-1+IPARG)
        NOCHL = '&&CALCUL.'//NOMPAR
        NOCHL2= '&&CALCUL.'//NOMPAR//'.EXIS'
        ZI(IAWLOC-1+3*(IPARG-1)+1)=-1
        ZI(IAWLOC-1+3*(IPARG-1)+2)=-1

C       SI LE PARAMETRE N'EST ASSOCIE A AUCUN CHAMP, ON PASSE :
C       --------------------------------------------------------
        IPARIN = INDIK8(LPAIN,NOMPAR,1,NIN)
        IPAROU = INDIK8(LPAOUT,NOMPAR,1,NOUT)
        ZI(IAWLOC-1+3*(IPARG-1)+3)=IPARIN+IPAROU
        IF ((IPARIN+IPAROU).EQ.0)  GO TO 40

        GD = GRDEUR(NOMPAR)
        SCAL = SCALAI(GD)
        ZK8(IAWTYP-1+IPARG) = SCAL
        CALL DCHLMX(OPT,LIGREL,IPARG,NIN,LPAIN,NOUT,LPAOUT,TAILLE)
        IF (TAILLE.NE.0) THEN
          CALL WKVECT(NOCHL,'V V '//SCAL(1:4),TAILLE,
     +                ZI(IAWLOC-1+3*(IPARG-1)+1))
          NBOBTR = NBOBTR + 1
          ZK24(IAOBTR-1+NBOBTR) = NOCHL
          IF (IPARIN.GT.0) THEN
            CALL WKVECT(NOCHL2,'V V L',TAILLE,
     +                ZI(IAWLOC-1+3*(IPARG-1)+2))
            NBOBTR = NBOBTR + 1
            ZK24(IAOBTR-1+NBOBTR) = NOCHL2
          END IF
        ELSE
          ZI(IAWLOC-1+3*(IPARG-1)+1)=-2
        END IF
   40 CONTINUE

   70 CONTINUE
      END
