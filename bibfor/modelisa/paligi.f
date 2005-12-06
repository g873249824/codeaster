      SUBROUTINE PALIGI(PHENO,MODL,LIGRCH,IGREL,INEMA,ILISTE)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*4 PHENO
      CHARACTER*(*) MODL,LIGRCH
      INTEGER IGREL,INEMA,ILISTE(*)
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     PAROIS DEFINI PAR LA LISTE ILISTE DESCRIVANT LES VIS A VIS ENTRE
C     DES MAILLES(UN OBJET DE LA COLLECTION GENEREE PAR PATRMA)
C ARGUMENTS D'ENTREE:
C IN   PHENO  K4  : PHENOMENE ( 'THER' )
C IN   MODL   K*  : MODELISATION
C IN   LIGRCH K19 : NOM DU LIGREL DE CHARGE
C IN   IGREL  I   : NUMERO DU GREL DE CHARGE
C VAR  INEMA  I   : NUMERO  DE LA DERNIERE MAILLE TARDIVE DANS LIGRCH
C IN   ILISTE I(*): TABLEAU DESCRIVANT LES VIS A VIS
C                  (1) = ITYPM : NUM. DU TYPE_MAIL
C                  (2) = NBMA  : NBRE DE VIS A VIS
C                  (3) = NBTOT :NBRE DE NOEUDS DES MAILLES EN VIS A VIS
C          POUR IC = 1,NBMA
C    V(3+(IC-1)*(2+2*NBNTOT)+1)= NUMA1 NUM. DE LA 1ERE MAILLE DU COUPLE
C    V(3+(IC-1)*(2+2*NBNTOT)+2)= NUMA2 NUM. DE LA 2EME MAILLE DU COUPLE
C                        EN VIS A VIS AVEC NUMA1
C           POUR INO = 1,NBNTOT
C V(3+(IC-1)*(2+2*NBTOT)+2+2*(INO-1)+1)=N1(INO)NUM.DU NO. INO DE NUMA1
C V(3+(IC-1)*(2+2*NBTOT)+2+2*(INO-1)+1)= N2(N1(INO)) NUM.DU NOEUD DE
C                   NUMA2 EN VIS A VIS AVEC LE NOEUD N1(INO)
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNOM,JEXNUM
C     ------- FIN COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*16 TYPELM
      CHARACTER*19 LIGR
      CHARACTER*24 LIEL,NEMA
      INTEGER NMAXOB
      PARAMETER (NMAXOB=30)
      INTEGER ITABL(NMAXOB),NVAL
      CHARACTER*24 K24TAB(NMAXOB)

C --- DEBUT
      CALL JEMARQ()
      NBMA = ILISTE(2)
      NBNO = ILISTE(3)
      LIGR = LIGRCH
      LIEL = LIGR//'.LIEL'
      NEMA = LIGR//'.NEMA'

C --- TYPE_ELEM ASSOCIE AUX MAILLES DE COUPLAGE
      TYPELM = PHENO(1:4)
      IF (MODL(1:2).EQ.'PL') THEN
        TYPELM(3:6) = 'PLSE'
        IF (NBNO.EQ.2) THEN
          TYPELM(7:8) = '22'
        ELSE IF (NBNO.EQ.3) THEN
          TYPELM(7:8) = '33'
        ELSE
          CALL UTMESS('F','PALIGI_1','TYPE DE MAILLE INCONNUE')
        END IF
      ELSE IF (MODL(1:2).EQ.'AX') THEN
        TYPELM(3:6) = 'PLSE'
        IF (NBNO.EQ.2) THEN
          TYPELM(7:8) = '22'
        ELSE IF (NBNO.EQ.3) THEN
          TYPELM(7:8) = '33'
        ELSE
          CALL UTMESS('F','PALIGI_2','TYPE DE MAILLE INCONNUE')
        END IF
      ELSE IF (MODL(1:2).EQ.'3D') THEN
        TYPELM(5:9) = '_FACE'
        IF (NBNO.EQ.3) THEN
          TYPELM(10:11) = '33'
        ELSE IF (NBNO.EQ.4) THEN
          TYPELM(10:11) = '44'
        ELSE IF (NBNO.EQ.6) THEN
          TYPELM(10:11) = '66'
        ELSE IF (NBNO.EQ.8) THEN
          TYPELM(10:11) = '88'
        ELSE IF (NBNO.EQ.9) THEN
          TYPELM(10:11) = '99'
        ELSE
          CALL UTMESS('F','PALIGI_3','TYPE DE MAILLE INCONNUE')
        END IF
        CALL INI002(TYPELM,NMAXOB,ITABL,K24TAB,NVAL)
      ELSE
      END IF
      CALL JENONU(JEXNOM('&CATA.TE.NOMTE',TYPELM),ITYPEL)

C --- ON CREE ET ON REMPLI LE GREL

      CALL JECROC(JEXNUM(LIEL,IGREL))
      CALL JEECRA(JEXNUM(LIEL,IGREL),'LONMAX',NBMA+1,' ')
      CALL JEVEUO(JEXNUM(LIEL,IGREL),'E',IDLIEL)
      DO 20 IMA = 1,NBMA
        INEMA = INEMA + 1
        JMA = 3 + (IMA-1)*2* (NBNO+1)
        ZI(IDLIEL-1+IMA) = -INEMA
        CALL JECROC(JEXNUM(NEMA,INEMA))
        CALL JEECRA(JEXNUM(NEMA,INEMA),'LONMAX',2*NBNO+1,' ')
        CALL JEVEUO(JEXNUM(NEMA,INEMA),'E',IDNEMA)
        DO 10 INO = 1,NBNO
          ZI(IDNEMA-1+INO) = ILISTE(JMA+2+2*INO-1)
          ZI(IDNEMA-1+NBNO+INO) = ILISTE(JMA+2+2*INO)
   10   CONTINUE
        ZI(IDNEMA+2*NBNO) = ILISTE(1)
   20 CONTINUE
      ZI(IDLIEL+NBMA) = ITYPEL
      CALL JEDEMA()
      END
