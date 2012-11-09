      SUBROUTINE GENUGL(PROFNO,INDIRF,MODGEN,MAILSK)
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
      IMPLICIT NONE
C
C***********************************************************************
C  P. RICHARD     DATE 16/11/92
C-----------------------------------------------------------------------
C  BUT: < GENERALE NUMEROTATION GLOBALE >
C
C  CREER, A PARTIR D'UN MODELE GENERALISE ET D'UN MAILLAGE GLOBAL
C  SQUELETTE, LE PROFIL CHAMNO ET UNE FAMILLE NUMEROTEE DONT CHAQUE
C  OBJET CORRESPOND A UNE SOUS-STRUCTURE, ET EST DIMENSIONNE A 2*NBDDL
C  ENGENDRE PAR LES SOUS-STRUCTURES :
C            2*(I-1)+1 --> NUMERO EQUATION DANS NUMDDL SST
C            2*(I-1)+2 --> NUMERO EQUATION DANS PROFNO GLOBAL
C
C-----------------------------------------------------------------------
C
C PROFNO  /I/ : NOM K19 DU PROF_CHNO A CREER
C INDIRF  /I/ : NOM K24 DE LA FAMILLE DES INDIRECTIONS A CREER
C MODGEN  /I/ : NOM DU MODELE GENERALISE EN AMONT
C MAILSK  /I/ : NOM DU MAILLAGE SKELETTE
C
C
C
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM,JEXNOM
C
C
C-----------------------------------------------------------------------
      INTEGER I ,IBID ,ICOMP ,IDDN ,IDDS ,IEC ,IEQ
      INTEGER IPOINT ,IRET ,J ,K ,LDDEEQ ,LDINSE ,LDNUEQ
      INTEGER LDPRNO ,LINUEQ ,LLINSK ,LLNUEQ ,LLPRNO ,LTTDS ,NBCMP
      INTEGER NBCOU ,NBCPMX ,NBDDL ,NBEC ,NBNOT ,NBSST ,NDDLT
      INTEGER NTAIL ,NUMNO ,NUSST
C-----------------------------------------------------------------------
      PARAMETER    (NBCPMX=300)
      CHARACTER*6  PGC
      CHARACTER*8  MAILSK,MODGEN,KBID
      CHARACTER*8  K8BID
      CHARACTER*19 NUMDDL,PROFNO
      CHARACTER*24 INDIRF,LILI,PRNO,DEEQ,NUEQ
      INTEGER      IDEC(NBCPMX)
C
C-----------------------------------------------------------------------
      DATA PGC /'GENUGL'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      KBID='  '
      CALL MGUTDM(MODGEN,KBID,1,'NB_CMP_MAX',NBCMP,K8BID)
C
C-----RECUPERATION DU NOMBRE D'ENTIERS CODES DE LA GRANDEUR DEPL_R------
C
      CALL DISMOI('F','NB_EC','DEPL_R','GRANDEUR',NBEC,K8BID,IRET)
      IF (NBEC.GT.10) THEN
        CALL U2MESS('F','MODELISA_94')
      ENDIF
C
C-----RECUPERATION DU NOMBRE DE SOUS-STRUCTURES-------------------------
C
      CALL JELIRA(MODGEN//'      .MODG.SSNO','NOMMAX',NBSST,K8BID)
C
C-----RECUPERATION DIMENSION MAILLAGE SQUELETTE-------------------------
C
      CALL DISMOI('F','NB_NO_MAILLA',MAILSK,'MAILLAGE',NBNOT,K8BID,IRET)
C
C-----RECUPERATION DU .INV.SKELETON-------------------------------------
C
      CALL JEVEUO(MAILSK//'.INV.SKELETON','L',LLINSK)
C
C-----ALLOCATION DU VECTEUR DE TRAVAIL POUR STOCKAGE NOMBRE DE DDL
C     GLOBAUX ENGENDRE PAR SOUS STRUCTURE
C
      CALL WKVECT('&&'//PGC//'.TAIL.DDL.SST','V V I',NBSST,LTTDS)
C
C-----BOUCLE DE COMPTAGE DES DDL FINAUX---------------------------------
C
      NDDLT=0
      DO 10 I=1,NBSST
        KBID='  '
        CALL MGUTDM(MODGEN,KBID,I,'NOM_NUME_DDL',IBID,NUMDDL)
        NUMDDL(15:19)='.NUME'
        CALL JENONU(JEXNOM(NUMDDL//'.LILI','&MAILLA'),IBID)
        CALL JEVEUO(JEXNUM(NUMDDL//'.PRNO',IBID),'L',LLPRNO)
        DO 20 J=1,NBNOT
          NUSST=ZI(LLINSK+J-1)
          NUMNO=ZI(LLINSK+NBNOT+J-1)
          IF(NUSST.EQ.I) THEN
            NDDLT=NDDLT+ZI(LLPRNO+(NUMNO-1)*(2+NBEC)+1)
            ZI(LTTDS+I-1)=ZI(LTTDS+I-1)+ZI(LLPRNO+(NUMNO-1)*(2+NBEC)+1)
          ENDIF
20      CONTINUE
10    CONTINUE
C
C-----ALLOCATION DES DIVERS OBJETS-------------------------------------
C
      LILI=PROFNO//'.LILI'
      PRNO=PROFNO//'.PRNO'
      DEEQ=PROFNO//'.DEEQ'
      NUEQ=PROFNO//'.NUEQ'
C
      CALL JECREO(LILI,'G N K24')
      CALL JEECRA(LILI,'NOMMAX',2,' ')
      CALL WKVECT(DEEQ,'G V I',NDDLT*2,LDDEEQ)
      CALL WKVECT(NUEQ,'G V I',NDDLT,LDNUEQ)
      CALL JECREC(PRNO,'G V I','NU','CONTIG','VARIABLE',2)
      CALL JECROC(JEXNOM(PRNO(1:19)//'.LILI','&MAILLA'))
      CALL JECROC(JEXNOM(PRNO(1:19)//'.LILI','LIAISONS'))
      CALL JECREC(INDIRF,'V V I','NU','DISPERSE','VARIABLE',NBSST)
C
      DO 40 I=1,NBSST
        NTAIL=2*ZI(LTTDS+I-1)
        IF(NTAIL.GT.0) THEN
          CALL JEECRA(JEXNUM(INDIRF,I),'LONMAX',NTAIL,' ')
          CALL JECROC(JEXNUM(INDIRF,I))
        ENDIF
 40   CONTINUE
C
C-----REMPLISSAGE DES OBJETS EVIDENTS-----------------------------------
C
      CALL JEECRA(JEXNUM(PRNO,1),'LONMAX',NBNOT*(2+NBEC),KBID)
      CALL JEECRA(JEXNUM(PRNO,2),'LONMAX',1,KBID)
      CALL JEECRA(PRNO,'LONT',NBNOT*(2+NBEC)+1,' ')
C
C-----REMPLISSAGE DES OBJETS--------------------------------------------
C
      CALL JENONU(JEXNOM(PRNO(1:19)//'.LILI','&MAILLA'),IBID)
      CALL JEVEUO(JEXNUM(PRNO,IBID),'E',LDPRNO)
C
      ICOMP=0
C
C  BOUCLE SUR LES SST DU MODELE GENERALISE
C
      DO 60 I=1,NBSST
        NBCOU=ZI(LTTDS+I-1)
        IDDS=0
C
C  TEST SI LA SST COURANTE ENGENDRE DES DDL GLOBAUX
C
        IF(NBCOU.GT.0) THEN
          KBID='  '
          CALL MGUTDM(MODGEN,KBID,I,'NOM_NUME_DDL',IBID,NUMDDL)
          NUMDDL(15:19)='.NUME'
          CALL JENONU(JEXNOM(NUMDDL//'.LILI','&MAILLA'),IBID)
          CALL JEVEUO(JEXNUM(NUMDDL//'.PRNO',IBID),'L',LLPRNO)
          CALL JEVEUO(NUMDDL//'.NUEQ','L',LLNUEQ)
          CALL JEVEUO(JEXNUM(INDIRF,I),'E',LDINSE)
C
C  BOUCLE SUR LES DDL GLOBAUX
C
          DO 70 J=1,NBNOT
            NUSST=ZI(LLINSK+J-1)
C
C  TEST SI LE NOEUD GLOBAL EST ENGENDRE PAR LA SST
C
            IF(NUSST.EQ.I) THEN
              NUMNO=ZI(LLINSK+NBNOT+J-1)
              IEQ=ZI(LLPRNO+(NUMNO-1)*(2+NBEC))
              NBDDL=ZI(LLPRNO+(NUMNO-1)*(2+NBEC)+1)
              CALL ISDECO(ZI(LLPRNO+(NUMNO-1)*(2+NBEC)+2),IDEC,NBCMP)
              ZI(LDPRNO+(J-1)*(2+NBEC))=ICOMP+1
              ZI(LDPRNO+(J-1)*(2+NBEC)+1)=NBDDL
              DO 80 IEC =1 , NBEC
                ZI(LDPRNO+(J-1)*(2+NBEC)+1+IEC)=
     &                            ZI(LLPRNO+(NUMNO-1)*(2+NBEC)+1+IEC)
 80           CONTINUE
              IDDN=0
              DO 90 K=1,NBCMP
                IF(IDEC(K).GT.0) THEN
                  IDDN=IDDN+1
                  ICOMP=ICOMP+1
                  ZI(LDDEEQ+(ICOMP-1)*2)=J
                  ZI(LDDEEQ+(ICOMP-1)*2+1)=K
                  ZI(LDNUEQ+ICOMP-1)=ICOMP
                  LINUEQ=ZI(LLNUEQ+IEQ+IDDN-2)
                  IPOINT=LDINSE+2*IDDS-1
                  ZI(IPOINT+1)=LINUEQ
                  ZI(IPOINT+2)=ICOMP
                  IDDS=IDDS+1
                  ENDIF
90             CONTINUE
             ENDIF
70        CONTINUE
          CALL JELIBE(NUMDDL//'.NUEQ')
          CALL JELIBE(JEXNUM(INDIRF,I))
        ENDIF
60    CONTINUE
C
C-----SAUVEGARDE DES OBJETS---------------------------------------------
C
      CALL JEDETR('&&'//PGC//'.TAIL.DDL.SST')
C
      CALL JEDEMA()
      END
