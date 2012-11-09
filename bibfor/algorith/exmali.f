      SUBROUTINE EXMALI(BASMOD,NOMINT,NUMINT,NOMMAT,BASE,
     &                     NBLIG,NBCOL,ORD,II)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
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
C***********************************************************************
C    P. RICHARD     DATE 23/05/91
C-----------------------------------------------------------------------
C  BUT:  < EXTRACTION DES DDL RELATIFS A UNE INTERFACE >
      IMPLICIT NONE
C
C  CONSISTE A EXTRAIRE LES VALEURS DANS LA BASE MODALE DES DDL ACTIFS
C   D'UNE INTERFACE
C
C-----------------------------------------------------------------------
C
C BASMOD   /I/: NOM UT DE LA BASE_MODALE
C NOMINT   /I/: NOM DE L'INTERFACE
C NUMINT   /I/: NUMERO DE L'INTERFACE
C NOMMAT   /I/: NOM K24 DE LA MATRICE RESULTAT A ALLOUE
C BASE     /I/: NOM K1 DE LA BASE POUR CREATION NOMMAT
C NBLIG    /I/: NOMBRE DE LIGNES DE LA MATRICE LIAISON CREE
C NBCOL    /I/: NOMBRE DE COLONNES DE LA MATRICE LIAISON CREE
C
C
C
C
C
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNOM
      CHARACTER*1 BASE
      CHARACTER*6      PGC
      CHARACTER*8 BASMOD,NOMINT,LINTF,KBID
      CHARACTER*24 CHAMVA,NOMMAT
      INTEGER ORD,II,LLREF,NUMINT,NBDEF,NBCOL,IBID,NBDDL,NBLIG,
     &        LTRANG,LLCHAM,IRAN,IAD,I,J,LDMAT,IER
C
C-----------------------------------------------------------------------
      DATA PGC /'EXMALI'/
C-----------------------------------------------------------------------
C
C---------------------RECUPERATION LISTE_INTERFACE AMONT----------------
C
      CALL JEMARQ()
      CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
      LINTF=ZK24(LLREF+4)
C
C----------------RECUPERATION EVENTUELLE DU NUMERO INTERFACE------------
C
      IF(NOMINT.NE.'             ') THEN
        CALL JENONU(JEXNOM(LINTF//'.IDC_NOMS',NOMINT),NUMINT)
      ENDIF
C
C
C----------------RECUPERATION DU NOMBRE DE DDL GENERALISES--------------
C
      CALL DISMOI('F','NB_MODES_TOT',BASMOD,'RESULTAT',
     &                      NBDEF,KBID,IER)
      NBCOL=NBDEF
C
C----RECUPERATION DU NOMBRE DE DDL  ET NOEUDS ASSOCIES A L'INTERFACE----
C
      KBID=' '
      CALL BMRDDA(BASMOD,KBID,NOMINT,NUMINT,0,IBID,NBDDL,ORD,II)
      NBLIG=NBDDL
C
C----------------ALLOCATION DU VECTEUR DES RANGS DES DDL----------------
C
      CALL WKVECT('&&'//PGC//'.RAN.DDL','V V I',NBDDL,LTRANG)
C
C-------------DETERMINATION DES RANG DES DDL ASSOCIES A INTERFACE-------
C
       KBID=' '
       CALL BMRDDA(BASMOD,KBID,NOMINT,NUMINT,NBDDL,ZI(LTRANG),IBID,
     &             ORD,II)
C
C-----------------ALLOCATION MATRICE LIAISON RESULTAT-------------------
C

      CALL WKVECT(NOMMAT,BASE//' V R',NBLIG*NBCOL,LDMAT)
C
C-------------------------EXTRACTION------------------------------------
C
      DO 10 I=1,NBDEF
C
        CALL DCAPNO(BASMOD,'DEPL    ',I,CHAMVA)
        CALL JEVEUO(CHAMVA,'L',LLCHAM)
C
        DO 20 J=1,NBDDL
          IRAN=ZI(LTRANG+J-1)
          IAD=LDMAT+((I-1)*NBDDL)+J-1
          ZR(IAD)=ZR(LLCHAM+IRAN-1)
 20     CONTINUE
C
C
 10   CONTINUE
C
C
      CALL JEDETR('&&'//PGC//'.RAN.DDL')
C
      CALL JEDEMA()
      END
