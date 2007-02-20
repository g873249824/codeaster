      SUBROUTINE FLEXIB(BASMOD,NBMOD,FLEX,NL,NC,NUML,NUMC)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/02/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
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
C***********************************************************************
C  P. RICHARD     DATE 09/04/91
C-----------------------------------------------------------------------
C  BUT : CALCULER LA MATRICE DE FLEXIBILITE RESIDUELLE ASSOCIEE
C        A UN PROBLEME CYCLIQUE AVEC INTERFACE MAC NEAL OU AUCUN
C        (FLEXIBILITE NULLE DANS LE CAS AUCUN)
C
C        SEULE LA SOUS MATRICE RELATIVE AUX DEFORMEES (COLONNES) D'UNE
C        INTERFACE ET AUX DDL D'UNE AUTRE (LIGNES) EST CALCULEE
C
C        POUR LES LIGNES IL EST POSSIBLE DE NE PAS DONNER UNE INTERFACE
C        MAIS DE PRENDRE TOUTES LES LIGNES ( = TOUS LES DDL PHYSIQUES)
C        IL SUFFIT POUR CELA DE DONNER UN NUMERO D'INTERFACE NUML = 0
C-----------------------------------------------------------------------
C
C BASMOD /I/ : NOM UTILISATEUR DE LA BASE MODALE
C NBMOD  /I/ : NOMBRE DE MODES PROPRES UTILISES
C FLEX   /O/ : MATRICE DE FLEXIBILITE RESIDUELLE
C NL     /I/ : NOMBRE DE LIGNES DE LA MATRICE DE FLEXIBILITE
C NC     /I/ : NOMBRE DE COLONNES DE LA MATRICE DE FLEXIBILITE
C NUML   /I/ : NUMERO DE L'INTERFACE DE DDL RELATIFS AUX LIGNES
C NUMC   /I/ : NUMERO DE L'INTERFACE DE DDL RELATIFS AUX COLONNES
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
      CHARACTER*32 JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      REAL*8       FLEX(NL,NC)
      CHARACTER*6  PGC
      CHARACTER*8  BASMOD,TYPINT,INTF,KBID,K8BID
      CHARACTER*19 NUMDDL
      CHARACTER*24 CHAMVA,NOEINT
      CHARACTER*24 VALK
      CHARACTER*1 K1BID
C
C-----------------------------------------------------------------------
      DATA PGC /'FLEXIB'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      DO 10 I=1,NL
        DO 10 J=1,NC
          FLEX(I,J)=0.D0
10    CONTINUE
C
C --- RECUPERATION CONCEPTS AMONT
C
      CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
      INTF=ZK24(LLREF+4)
      NUMDDL=ZK24(LLREF+3)
      CALL JELIBE(BASMOD//'           .REFD')
      IF(INTF.EQ.'        ') THEN
        VALK = BASMOD
        CALL U2MESG('F', 'ALGORITH13_17',1,VALK,0,0,0,0.D0)
      ENDIF
C
C --- TEST SUR LE TYPE D'INTERFACE
C
      CALL JEVEUO(INTF//'.IDC_TYPE','L',LLTYP)
      TYPINT=ZK8(LLTYP+NUMC-1)
      CALL JELIBE(INTF//'.IDC_TYPE')
      IF (TYPINT.EQ.'AUCUN   ') GOTO 9999
C
C --- ALLOCATION DES TABLEAUX DE TRAVAIL
C
      CALL WKVECT('&&'//PGC//'.ORDREC','V V I',NC,LTORC)
      CALL WKVECT('&&'//PGC//'.EXTRACC','V V I',NC,LTEXTC)
      CALL WKVECT('&&'//PGC//'.EXTRACL','V V I',NL,LTEXTL)
C
C --- RECUPERATION DU NOMBRE DE DDL PHYSIQUES ASSEMBLES
C
      CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,K8BID,IRET)
      CALL JEVEUO(NUMDDL//'.DEEQ','L',IDDEEQ)
C
C --- RECUPERATION DU NOMBRE DE NOEUDS DES INTERFACES
C
      NOEINT=INTF//'.IDC_LINO'
C
      IF(NUML.GT.0) THEN
        CALL JELIRA(JEXNUM(NOEINT,NUML),'LONMAX',NBNOL,K1BID)
        CALL JEVEUO(JEXNUM(NOEINT,NUML),'L',LLNOL)
      ELSE
        NBNOL=0
      ENDIF
C
      CALL JELIRA(JEXNUM(NOEINT,NUMC),'LONMAX',NBNOC,K1BID)
      CALL JEVEUO(JEXNUM(NOEINT,NUMC),'L',LLNOC)
C
C --- RECUPERATION DU DESCRIPTEUR DES DEFORMEES
C
      CALL JEVEUO(INTF//'.IDC_DEFO','L',LLDES)
      CALL JELIRA(INTF//'.IDC_DEFO','LONMAX',NBNOT,K1BID)
      NBNOT=NBNOT/3
C
C --- RECUPERATION DES NUMEROS D'ORDRE DES DEFORMEES (COLONNES)
C     ET RANGS DES DDL D'INTERFACE (LIGNES) DANS VECTEUR ASSEMBLE
C
C --- RECUPERATION NUMERO ORDRE DEFORMEES ET RANG DDL POUR COLONNES
C
      KBID=' '
      CALL BMNODI(BASMOD,KBID,'        ',NUMC,NC,ZI(LTORC),IBID)
      CALL BMRADI(BASMOD,KBID,'        ',NUMC,NC,ZI(LTEXTC),IBID)
C
C --- RECUPERATION DDL PHYSIQUES POUR LES LIGNES
C
      IF(NUML.GT.0) THEN
        CALL BMRADI(BASMOD,KBID,'        ',NUML,NL,ZI(LTEXTL),IBID)
      ELSE
        DO 45 I=1,NEQ
          ZI(LTEXTL+I-1)=I
 45     CONTINUE
      ENDIF
C
      IF(NUML.GT.0) THEN
        CALL JELIBE(JEXNUM(NOEINT,NUML))
      ENDIF
      CALL JELIBE(JEXNUM(NOEINT,NUMC))
      CALL JELIBE(INTF//'.IDC_DEFO')
C
C --- EXTRACTION PARTIE INTERFACE DE FLEXIBILITE
C
      DO 60 I=1,NC
        CALL WKVECT('&&'//PGC//'.VECT','V V R',NEQ,LTVEC)
        IORD=ZI(LTORC+I-1)
        CALL DCAPNO(BASMOD,'DEPL    ',IORD,CHAMVA)
        CALL JEVEUO(CHAMVA,'L',LLCHAM)
        CALL DCOPY(NEQ,ZR(LLCHAM),1,ZR(LTVEC),1)
        CALL ZERLAG(ZR(LTVEC),NEQ,ZI(IDDEEQ))
C
        DO 70 J=1,NL
C
C  EXTRACTION DDL
C
          IRAN=ZI(LTEXTL+J-1)
          XX=ZR(LTVEC+IRAN-1)
          FLEX(J,I)=XX
70      CONTINUE
        CALL JELIBE(CHAMVA)
        CALL JEDETR('&&'//PGC//'.VECT')
 60   CONTINUE
C
C --- SUPPRESSION CONTRIBUTION STATIQUE DES MODES CONNUS
C
      DO 80 I=1,NBMOD
C
        CALL RSADPA(BASMOD,'L',1,'RIGI_GENE',I,0,LDKGE,K8BID)
        XKGEN=ZR(LDKGE)
        CALL RSADPA(BASMOD,'L',1,'MASS_GENE',I,0,LDMGE,K8BID)
C
        CALL DCAPNO(BASMOD,'DEPL    ',I,CHAMVA)
        CALL JEVEUO(CHAMVA,'L',LLCHAM)
        CALL WKVECT('&&'//PGC//'.VECT','V V R',NEQ,LTVEC)
        CALL DCOPY(NEQ,ZR(LLCHAM),1,ZR(LTVEC),1)
        CALL ZERLAG(ZR(LTVEC),NEQ,ZI(IDDEEQ))
C
        DO 90 J=1,NC
          DO 95 K=1,NL
            JJ=ZI(LTEXTC+J-1)
            KK=ZI(LTEXTL+K-1)
            TOTO=ZR(LTVEC+JJ-1)*ZR(LTVEC+KK-1)/XKGEN
            FLEX(K,J)=FLEX(K,J)-TOTO
95        CONTINUE
90      CONTINUE
        CALL JELIBE(CHAMVA)
        CALL JEDETR('&&'//PGC//'.VECT')
80    CONTINUE
C
      CALL JEDETR('&&'//PGC//'.ORDREC')
      CALL JEDETR('&&'//PGC//'.EXTRACC')
      CALL JEDETR('&&'//PGC//'.EXTRACL')
C
 9999 CONTINUE
      CALL JEDEMA()
      END
