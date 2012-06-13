      SUBROUTINE TSTOBJ(OB,PERM,RESUME,SOMMI,SOMMR,LONUTI,LONMAX,TYPE,
     &           IRET,NI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C TOLE CRP_4
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
      IMPLICIT NONE
C
C     ARGUMENTS:
C     ----------

C BUT : RECUPERER 5 NOMBRES REPRESENTANT UN OBJET JEVEUX
C
C IN: OB    K24     : NOM D'UN OBJET JEVEUX
C IN: PERM  K3 : /OUI/NON
C           NON : ON FAIT LA SOMME BETE DES ELEMENTS DU VECTEUR
C                 => UNE PERMUTATION DU VECTEUR NE SE VOIT PAS !
C           OUI : ON FAIT UNE "SOMME" QUI DONNE UN RESULTAT
C                 DEPENDANT UN PEU DE L'ORDRE DES ELEMENTS DU VECTEUR
C
C OUT: RESUME  I      : VALEUR "RESUMANT" LE CONTENU BINAIRE DE OB
C OUT: SOMMI   I      : SOMME(OB(I)) SI OB EST DE TYPE "I"
C OUT: SOMMR   R      : SOMME(ABS(OB(I))) SI OB EST DE TYPE "R/C"
C OUT: LONUTI  I      : LONUTI (OU SOMME DES LONUTI)
C OUT: LONMAX  I      : LONMAX (OU SOMME DES LONMAX)

C OUT: TYPE    K3     : TYPE DES ELEMENTS DE OB :
C                         I/R/C/L/K8/K16/K24/K32/K80
C OUT: IRET    I      : /0 : OK
C                       /1 : NOOK
C OUT: NI      I      : NOMBRE DE VALEURS IGNOREES DANS SOMMR


      INCLUDE 'jeveux.h'
      CHARACTER*(*) OB,PERM
      CHARACTER*24 OB1
      CHARACTER*1 XOUS,TYP1
      REAL*8 SOMMR,SOMMR2
      INTEGER RESUME,SOMMI,IRET0,IBID,LONUTI,LONMAX
      INTEGER SOMMI2,LTYP,NI
      INTEGER*8 SOMMI3
      INTEGER IRET,IADM,IADD,LONG,LON2,IAD,KK,NBIGN
      INTEGER NBOB2,ITROU,IOBJ
      LOGICAL CONTIG
      CHARACTER*24 K24
      CHARACTER*8  KBID,STOCK
      CHARACTER*3  TYPE
      CHARACTER*1  GENR
C
C
      OB1=OB
      CALL JEMARQ()

C     VALEURS PAR DEFAUT (SI ON SORT AVANT LA FIN) :
      NI=0
      IRET=1
      TYPE='XXX'
      LONMAX=0
      LONUTI=0
      SOMMI=0
      SOMMR=0.D0
      RESUME=0

      CALL JEEXIN(OB1,IRET0)
      IF (IRET0.EQ.0)  GO TO 9999

      CALL JELIRA(OB1,'TYPE',IBID,TYP1)
      IF (TYP1.EQ.'K') THEN
        CALL JELIRA(OB1,'LTYP',LTYP,KBID)
        IF (LTYP.EQ.8) THEN
          TYPE='K8'
        ELSE IF (LTYP.EQ.16) THEN
          TYPE='K16'
        ELSE IF (LTYP.EQ.24) THEN
          TYPE='K24'
        ELSE IF (LTYP.EQ.32) THEN
          TYPE='K32'
        ELSE IF (LTYP.EQ.80) THEN
          TYPE='K80'
        END IF
      ELSE
        TYPE=TYP1
      END IF


      CALL JELIRA(OB1,'XOUS',IBID,XOUS)
      CALL JELIRA(OB1,'GENR',IBID,GENR)


C       - CAS DES OBJETS SIMPLES :
C       --------------------------
        IF (XOUS.EQ.'S') THEN
C         -- POUR SE PROTEGER DES OBJETS EN COURS DE CREATION :
          CALL JELIRA(OB1,'IADM',IADM,KBID)
          CALL JELIRA(OB1,'IADD',IADD,KBID)
          IF (ABS(IADM)+ABS(IADD).EQ.0) GO TO 9999

          IF (GENR.NE.'N') THEN
            CALL JELIRA(OB1,'LONMAX',LONG,KBID)
            CALL JELIRA(OB1,'LONUTI',LON2,KBID)
            LONUTI=LON2
            LONMAX=LONG
            CALL JEVEUO(OB1,'L',IAD)
          ELSE
            CALL JELIRA(OB1,'NOMMAX',LON2,KBID)
            CALL JELIRA(OB1,'NOMUTI',LONG,KBID)
            LONUTI=LONG
            LONMAX=LON2
            CALL WKVECT('&&TSTOBJ.PTEUR_NOM','V V '//TYPE,LONG,IAD)
            IF (TYPE.EQ.'K8') THEN
              DO 51, KK=1,LONG
                CALL JENUNO(JEXNUM(OB1,KK),ZK8(IAD-1+KK))
51            CONTINUE
            ELSE IF (TYPE.EQ.'K16') THEN
              DO 52, KK=1,LONG
                CALL JENUNO(JEXNUM(OB1,KK),ZK16(IAD-1+KK))
52            CONTINUE
            ELSE IF (TYPE.EQ.'K24') THEN
              DO 53, KK=1,LONG
                CALL JENUNO(JEXNUM(OB1,KK),ZK24(IAD-1+KK))
53            CONTINUE
            END IF
          END IF

          CALL TSTVEC(PERM,IAD,LONG,TYPE,SOMMI,SOMMR,NBIGN)
          NI=NI+NBIGN
          IF (GENR.EQ.'N') CALL JEDETR('&&TSTOBJ.PTEUR_NOM')
        END IF


C       - CAS DES COLLECTIONS :
C       -----------------------
        IF (XOUS.EQ.'X') THEN
          CALL JELIRA(OB1,'NMAXOC',NBOB2,KBID)
          CALL JELIRA(OB1,'STOCKAGE',IBID,STOCK)
          CONTIG=STOCK.EQ.'CONTIG'
          ITROU=0
          LONUTI=0
          LONMAX=0
          SOMMI3=0
          SOMMR=0.D0
          DO 2, IOBJ=1,NBOB2
             CALL JEEXIN(JEXNUM(OB1,IOBJ),IRET0)
             IF (IRET0.LE.0) GO TO 2

C            -- POUR SE PROTEGER DES OBJETS EN COURS DE CREATION :
             CALL JELIRA(JEXNUM(OB1,IOBJ),'IADM',IADM,KBID)
             CALL JELIRA(JEXNUM(OB1,IOBJ),'IADD',IADD,KBID)
             IF (ABS(IADM)+ABS(IADD).EQ.0) GO TO 2

             ITROU=1

             CALL JELIRA(JEXNUM(OB1,IOBJ),'LONUTI',LON2,KBID)
             CALL JELIRA(JEXNUM(OB1,IOBJ),'LONMAX',LONG,KBID)
             LONUTI=LONUTI+LON2
             LONMAX=LONMAX+LONG
             CALL JEVEUO(JEXNUM(OB1,IOBJ),'L',IAD)

             CALL TSTVEC(PERM,IAD,LONG,TYPE,SOMMI2,SOMMR2,NBIGN)
             NI=NI+NBIGN
             SOMMI3=SOMMI3+SOMMI2
             SOMMR=SOMMR+SOMMR2
             IF (.NOT.CONTIG) CALL JELIBE(JEXNUM(OB1,IOBJ))

 2        CONTINUE
          IF (ITROU.EQ.0) GO TO 9999
          WRITE(K24,'(I24)') SOMMI3
          READ(K24(16:24),'(I9)') SOMMI
        END IF


C     -- SORTIE NORMALE :
      IRET=0

C     -- POUR L'INSTANT : RESUME= SOMMI
      RESUME=SOMMI

 9999 CONTINUE
      CALL JEDEMA()
      END
