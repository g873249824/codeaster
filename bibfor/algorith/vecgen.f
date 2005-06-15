      SUBROUTINE VECGEN(NOMRES,NUMEG)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/06/2005   AUTEUR VABHHTS J.PELLET 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C    T. KERBER      DATE 12/05/93
C-----------------------------------------------------------------------
C  BUT: ASSEMBLER UN VECTEUR ISSU D'UN MODELE GENERALISE
C
C     CONCEPT CREE: VECT_ASSE_GENE
C
C-----------------------------------------------------------------------
C
      INTEGER IER
C
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
C
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
C
      CHARACTER*32 JEXNOM,JEXNUM
C
C-----  FIN  COMMUNS NORMALISES  JEVEUX  -------------------------------
C
      CHARACTER*6 PGC
      CHARACTER*8 NOMRES,NUMEG,MODGEN,NOMSST,NOM2MB,NOMDDL,SSTOLD
      CHARACTER*8 BASMOD,TYPVE
      CHARACTER*9 OPTION
      CHARACTER*16 MOTFAC
      CHARACTER*19 PROFG,CHASOU,MOTCLE
      CHARACTER*24 RESDSC,RESREF,RESVAL
      CHARACTER*24 CHADSC,CHALIS,CHAVAL
      CHARACTER*24 NUCHAR,NUBAMO
      CHARACTER*24 NOMCHA,DEEQ
      REAL*8       DDOT
      CHARACTER*8 KBID
      COMPLEX*16  CBID
      CHARACTER*16 NOMCON,NOMOPE
      INTEGER      GD, GD0,NBLIA,IBID
      CHARACTER*1 K1BID
C
C-----------------------------------------------------------------------
      DATA PGC/'VECGEN'/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C     1/ LECTURE ET STOCKAGE DES INFORMATIONS
C     =======================================
C
C-----------------------------------------------------------------------
C     1.1/ RECUPERATION CONCEPTS AMONT
C-----------------------------------------------------------------------
C
C     NOMBRE DE SOUS-STRUCTURES SOUMISES A CHARGEMENTS
C
      CALL GETFAC('CHAR_SOUS_STRUC',NBCHAR)
C
      PROFG = NUMEG//'      .NUME'
C     VERIFIER QUE LA NUMEROTATION EST COHERENTE
      CALL JENONU(JEXNOM(PROFG//'.LILI','LIAISONS'),IBID)
      CALL JELIRA(JEXNUM(PROFG//'.PRNO',IBID),'LONMAX',NBLIA,K1BID)
      IF (NBLIA.EQ.1) THEN
        CALL UTMESS('F','VECGEN',
     +                ' LA NUMEROTATION N''EST PAS COHERENTE AVEC LE '
     +                //' MODELE GENERALISE '
     +                //' SI VOUS AVEZ ACTIVE L''OPTION INITIAL DANS '
     +                //' NUME_DDL_GENE FAITE DE MEME ICI ! '
     +                //' ON ARRETE TOUT ')
      ENDIF

C
C     VERIFIER QUE LE NOMBRE NBCHAR DE SOUS-STRUCTURES CHARGEES EST
C     INFERIEUR AU NOMBRE TOTAL NBSST DE SOUS-STRUCTURES
C
      CALL JENONU(JEXNOM(PROFG//'.LILI','&SOUSSTR'),IBID)
      CALL JELIRA(JEXNUM(PROFG//'.ORIG',IBID),'LONMAX',NBSST,K1BID)
      IF (NBCHAR.GT.NBSST) THEN
        CALL UTDEBM('F',PGC,
     +              'ARRET : NOMBRE INCORRECT DE SOUS-STRUCTURES')
        CALL UTIMPI('L','IL VAUT : ',1,NBCHAR)
        CALL UTIMPI('L','ALORS QUE LE NOMBRE TOTAL DE SOUS-'//
     +              'STRUCTURES VAUT : ',1,NBSST)
        CALL UTFINM
      END IF
C
C-----------------------------------------------------------------------
C     1.2/ CREATION DE LA STRUCTURE DE DONNEES NOMRES
C-----------------------------------------------------------------------
C
C     CETTE STRUCTURE DE DONNEES, DE TYPE VECT_ASSE_GENE, COMPREND
C     LES ARTICLES USUELS D'UN VECT_ASSE, PLUS UN .ELEM CONTENANT DES
C     INFORMATIONS PROPRES AUX DIVERSES SOUS-STRUCTURES.
C
C     CELUI-CI COMPREND LES ARTICLES QUI SUIVENT.
C        - UN .DESC, AVEC LE NOMBRE DE SOUS-STRUCTURES SOUMISES A
C          CHARGEMENT
C        - UN .LICH, REGROUPANT LES INFORMATIONS SUR LES SOUS-STRUCTURES
C          CHARGEES : NOM DE LA SOUS-STRUCTURE, DU SECOND MEMBRE
C          ASSEMBLE POUR CELLE-CI, ET DU NUME_DDL ASSOCIE.
C        - UN .VALE, QUI CONTIENDRA LES PROJECTIONS DES SECOND MEMBRES
C          ASSEMBLES, SUR LA BASE MODALE CORRESPONDANTE. C'EST UNE
C          COLLECTION NOMMEE PAR LES NOMS DES SOUS-STRUCTURES.
C
C     NOTONS QUE DANS LE .REFE, LE MAILLAGE EST REMPLACE PAR LE MODELE
C     GENERALISE.
C
C
      RESDSC = NOMRES//'           .DESC'
      RESREF = NOMRES//'           .REFE'
      RESVAL = NOMRES//'           .VALE'
C
      CHASOU = NOMRES//'      .ELEM'
      CHADSC = CHASOU//'.DESC'
      CHALIS = CHASOU//'.LICH'
      CHAVAL = CHASOU//'.VALE'
C
      CALL WKVECT(RESDSC,'G V I',3,LRDESC)
      CALL JEECRA(RESDSC,'DOCU',0,'CHNO')
C
      CALL WKVECT(RESREF,'G V K24',2,LRREF)
C
C     RECUPERATION DU NOMBRE TOTAL DE D.D.L. GENERALISES, POUR
C     L'ALLOCATION DU .VALE.
C
      CALL JEVEUO(PROFG//'.NEQU','L',LLNEQ)
      NEQGEN = ZI(LLNEQ)
C
      CALL WKVECT(RESVAL,'G V R',NEQGEN,LRVAL)
C
      CALL WKVECT(CHADSC,'G V I',1,LDDESC)
C
      CALL JECREC(CHALIS,'G V K8','NO','CONTIG','CONSTANT',3)
      CALL JECROC(JEXNOM(CHALIS,'SOUSSTR'))
      CALL JECROC(JEXNOM(CHALIS,'VECTASS'))
      CALL JECROC(JEXNOM(CHALIS,'NUMEDDL'))
      CALL JEECRA(JEXNOM(CHALIS,'SOUSSTR'),'LONMAX',NBCHAR,' ')


C
      CALL JEVEUO(JEXNOM(CHALIS,'SOUSSTR'),'E',LDNSST)
      CALL JEVEUO(JEXNOM(CHALIS,'VECTASS'),'E',LDNVEC)
      CALL JEVEUO(JEXNOM(CHALIS,'NUMEDDL'),'E',LDNDDL)
C
      CALL JECREC(CHAVAL,'G V R','NO','DISPERSE','VARIABLE',NBCHAR)
C
C-----------------------------------------------------------------------
C     1.3/ REMPLISSAGE DES INFORMATIONS DE NOMRES
C-----------------------------------------------------------------------
C
C     ECRITURE DU .DESC DANS LE .ELEM
C
      ZI(LDDESC) = NBCHAR
C
C     ECRITURE DES INFORMATIONS DANS CHARLIS
C
      MOTFAC = 'CHAR_SOUS_STRUC'
C
C-----------------------------------------------------------------------
C     A/ RECUPERATION DU MODELE GENERALISE
C-----------------------------------------------------------------------
C
      CALL JEVEUO(PROFG//'.REFN','E',LLREF)
      MODGEN = ZK24(LLREF) (1:8)
C
C     BOUCLE SUR LES SOUS-STRUCTURES CHARGEES
C
      DO 10 I = 1,NBCHAR
C
C-----------------------------------------------------------------------
C     B/ RECUPERATION DU NOM DE LA SOUS-STRUCTURE ET ECRITURE DANS
C        LE .LICH.
C-----------------------------------------------------------------------
C
        CALL GETVTX(MOTFAC,'SOUS_STRUC',I,1,0,NOMSST,IOC)
        IOC = -IOC
        IF (IOC.NE.1) THEN
          CALL UTDEBM('F',PGC,
     +                'ARRET : NOMBRE INCORRECT DE SOUS-STRUCTURES')
          CALL UTIMPI('L','POUR LE CHARGEMENT NUMERO :',1,I)
          CALL UTIMPI('L','IL EN FAUT EXACTEMENT : ',1,1)
          CALL UTIMPI('L','VOUS EN AVEZ : ',1,IOC)
          CALL UTFINM

        ELSE
          CALL GETVTX(MOTFAC,'SOUS_STRUC',I,1,1,NOMSST,IOC)
        END IF
C
        ZK8(LDNSST+I-1) = NOMSST
C
C-----------------------------------------------------------------------
C     C/ RECUPERATION DU NOM DU SECOND MEMBRE ASSEMBLE, ET ECRITURE
C        DANS LE .LICH
C-----------------------------------------------------------------------
C
        CALL GETVID(MOTFAC,'VECT_ASSE',I,1,0,NOM2MB,IOC)
        IOC = -IOC
        IF (IOC.NE.1) THEN
          CALL UTDEBM('F',PGC,
     +                'ARRET : NOMBRE INCORRECT DE VECTEURS CHARGEMENTS'
     +                )
          CALL UTIMPI('L','POUR LE CHARGEMENT NUMERO :',1,I)
          CALL UTIMPI('L','IL EN FAUT EXACTEMENT : ',1,1)
          CALL UTIMPI('L','VOUS EN AVEZ : ',1,IOC)
          CALL UTFINM

        ELSE
          CALL GETVID(MOTFAC,'VECT_ASSE',I,1,1,NOM2MB,IOC)
        END IF
C
C     RECUPERATION DU NUME_DDL ASSOCIE AU SECOND MEMBRE.
C
C     ON VERIFIE D'ABORD QU'ON A BIEN LE NOM DU PROF_CHNO DANS LE
C     .REFE DU CHAMNO SECOND MEMBRE. POUR CE FAIRE, ON CONTROLE QUE
C     LA VALEUR DE NUME DANS LE .DESC EST BIEN POSITIVE.
C
        CALL JEVEUO(NOM2MB//'           .DESC','L',LDESC)
        NUM = ZI(LDESC+1)
        IF (NUM.LT.0) THEN
          CALL UTDEBM('F',PGC,'ARRET : UN PROF_CHNO N''EST PAS DEFINI')
          CALL UTIMPK('L','IL MANQUE POUR LE CHARGEMENT :',1,NOM2MB)
          CALL UTFINM
        END IF
C
        CALL JEVEUO(NOM2MB//'           .REFE','L',LREFE)
        NUCHAR = ZK24(LREFE+1)
C
C     VERIFICATION DE LA COHERENCE DES GRANDEURS ENTRE CHARGEMENTS.
C
        GD = ZI(LDESC)
        IF (I.EQ.1) THEN
          GD0 = GD
        END IF
C
        IF (GD.NE.GD0) THEN
          CALL UTDEBM('F',PGC,
     +'ON DOIT AVOIR LE MEME TYPE DE FORCES POUR  UN MEME CHARGEMENT GLO
     +BAL')
          CALL UTIMPI('L','OR, LA GRANDEUR VAUT : ',1,GD0)
          CALL UTIMPK('S','POUR LA SOUS-STRUCTURE ',1,SSTOLD)
          CALL UTIMPI('L','ET ELLE VAUT : ',1,GD)
          CALL UTIMPK('S','POUR LA SOUS-STRUCTURE ',1,NOMSST)
        END IF
C
        GD0 = GD
        SSTOLD = NOMSST
        ZK8(LDNVEC+I-1) = NOM2MB
C
C-----------------------------------------------------------------------
C     D/ RECUPERATION DU NUME_DDL ET ENREGISTREMENT DANS LE .LICH
C-----------------------------------------------------------------------
C
C     ON UTILISE LA BASE MODALE, ET ON VERIFIE AU PASSAGE QUE
C     SON TYPE EST BIEN CELUI D'UNE BASE CLASSIQUE OU DE RITZ.
C
        CALL MGUTDM(MODGEN,NOMSST,0,'NOM_BASE_MODALE',IBID,BASMOD)
        CALL JEVEUO(BASMOD//'           .REFD','L',LLREFB)
        NUBAMO = ZK24(LLREFB+1)
C
        CALL JEVEUO(BASMOD//'           .UTIL','L',LLDESC)
        ITYBA = ZI(LLDESC)
C
        IF (ITYBA.NE.3 .AND. ITYBA.NE.1) THEN
          CALL UTDEBM('F',PGC,
     +                'UNE DES BASES MODALES A UN TYPE INCORRECT')
          CALL UTIMPK('L','ELLE EST ASSOCIEE A LA SOUS-STRUCTURE ',1,
     +                NOMSST)
          CALL UTFINM
        END IF
C
C     PAR SECURITE, ON S'ASSURE QUE LE NUME_DDL ASSOCIE AU CHARGEMENT
C     COINCIDE AVEC CELUI ASSOCIE A LA SOUS-STRUCTURE.
C
        IF (NUCHAR.NE.NUBAMO) THEN
          CALL UTDEBM('F',PGC,'LES NUMEROTATIONS NE COINCIDENT PAS')
          CALL UTIMPK('L','POUR LA SOUS-STRUCTURE :',1,NOMSST)
          CALL UTIMPK('L','LE PROF_CHNO POUR LA BASE MODALE EST : ',1,
     +                NUBAMO)
          CALL UTIMPK('L','ET CELUI POUR LE SECOND MEMBRE : ',1,NUCHAR)
          CALL UTFINM
        END IF
C
C     COPIE DU NUME_DDL DANS LE .LICH
C
        ZK8(LDNDDL+I-1) = NUBAMO(1:8)
C
   10 CONTINUE
C
C
C     ECRITURE DU .REFE
C
      ZK24(LLREF) = MODGEN
      ZK24(LRREF+1) = PROFG
C
C     ECRITURE DU .DESC
C
      ZI(LRDESC) = GD
      ZI(LRDESC+1) = 1
C
C
C
C     2/ PROJECTION DES CHARGEMENTS SUR LES BASES MODALES
C     ===================================================
C
C-----------------------------------------------------------------------
C     BOUCLES SUR LES SOUS-STRUCTURES CHARGEES
C-----------------------------------------------------------------------
C
      DO 50 I = 1,NBCHAR
C
C-----------------------------------------------------------------------
C     2.1/ RECUPERATION D'INFORMATIONS DE BASE
C-----------------------------------------------------------------------
C
C     NOMS STOCKES DANS LE .LICH
C
        NOMSST = ZK8(LDNSST+I-1)
        NOM2MB = ZK8(LDNVEC+I-1)
        NOMDDL = ZK8(LDNDDL+I-1)
C
C     RECUPERATION DE LA BASE MODALE ASSOCIEE A LA SOUS-STRUCTURE
C
        CALL MGUTDM(MODGEN,NOMSST,0,'NOM_BASE_MODALE',IBID,BASMOD)
C
C     NOMBRE DE MODES NBMOD DE LA BASE MODALE
C
        CALL RSORAC(BASMOD,'LONUTI',IBID,RBID,KBID,CBID,RBID,KBID,NBMOD,
     +              1,IBID)
C
C
C     RECUPERATION DU .VALE ASSOCIE AU SECOND MEMBRE
C
        CALL JEVEUO(NOM2MB//'           .VALE','L',LADRVE)
        CALL JELIRA(NOM2MB//'           .VALE','TYPE',IBID,TYPVE)
C
C     NOMBRE D'EQUATIONS DU SYSTEME PHYSIQUE, POUR LA SOUS-STRUCTURE
C
        CALL DISMOI('F','NB_EQUA',NOMDDL,'NUME_DDL',NEQ,KBID,IRET)
C
C     POSITIONNEMENT DANS LE .DEEQ, AFIN DE DISPOSER DES CORRESPONDANCES
C     ENTRE NUMEROS D'EQUATIONS ET NOEUDS ET D.D.L.
C
        DEEQ = NOMDDL//'      .NUME.DEEQ'
        CALL JEVEUO(DEEQ,'L',IDDEEQ)
C
C-----------------------------------------------------------------------
C     2.2/ CREATION DE L'OBJET CHARGEMENT PROJETE DU .VALE
C-----------------------------------------------------------------------
C
        CALL JECROC(JEXNOM(CHAVAL,NOMSST))
        CALL JEECRA(JEXNOM(CHAVAL,NOMSST),'LONMAX',NBMOD,' ')
C
C
C-----------------------------------------------------------------------
C     2.3/ PROJECTION EFFECTIVE
C-----------------------------------------------------------------------
C
C     ALLOCATION DE LA PLACE POUR UN VECTEUR TEMPORAIRE
C
        CALL WKVECT('&&'//PGC//'.VECTA','V V R',NEQ,IDVECT)
C
C     ACCES AU CHAMP DE CHARVAL ASSOCIE A NOMSST
C
        CALL JEVEUO(JEXNOM(CHAVAL,NOMSST),'E',IAVALE)
C
C     BOUCLE SUR LES MODES
C
        DO 20 J = 1,NBMOD
C
C     EXTRACTION DU CHAMP DE DEPLACEMENTS ASSOCIE AU MODE J
C
          CALL RSEXCH(BASMOD,'DEPL',J,NOMCHA,IRET)
C
          NOMCHA = NOMCHA(1:19)//'.VALE'
          CALL JEVEUO(NOMCHA,'L',IADMOD)
C
C     RECOPIE DU CHAMP DANS LE VECTEUR TEMPORAIRE
C
          CALL DCOPY(NEQ,ZR(IADMOD),1,ZR(IDVECT),1)
C
C
C     MISE A ZERO DES D.D.L. DE LAGRANGE
C
          CALL ZERLAG(ZR(IDVECT),NEQ,ZI(IDDEEQ))
C
C     PRODUIT SCALAIRE SECOND MEMBRE ET MODE
C
          ZR(IAVALE+J-1) = DDOT(NEQ,ZR(IDVECT),1,ZR(LADRVE),1)
C
   20   CONTINUE
C
        CALL JEDETR('&&'//PGC//'.VECTA')
C
   50 CONTINUE
C
C

C
C     3/ ASSEMBLAGE
C     =============
C
C     ACCES AU PRNO DU PROF_CHNO GENERALISE, POUR LES SOUS-STRUCTURES.
C
      CALL JENONU(JEXNOM(PROFG//'.LILI','&SOUSSTR'),IBID)
      CALL JEVEUO(JEXNUM(PROFG//'.PRNO',IBID),'L',LDPRS)
C
C     ACCES AUX NOMS DES SOUS-STRUCTURES CHARGEES
C
      CALL JEVEUO(JEXNOM(CHALIS,'SOUSSTR'),'L',LDSTR)
C
C     BOUCLE SUR LES SOUS-STRUCTURES CHARGEES
C
      DO 100 I = 1,NBCHAR
C
C     RECUPERATION DU NOM DE LA SOUS-STRUCTURE ET DU CHARGEMENT
C     PROJETE ASSOCIE.
C
        NOMSST = ZK8(LDSTR+I-1)
C
C     RECUPERATION DU NUMERO GLOBAL DE LA SOUS-STRUCTURE
C
        CALL JENONU(JEXNOM(MODGEN//'      .MODG.SSNO',NOMSST),NUSST)
C
C     RECUPERATION DU D.D.L. GENERALISE DE DEPART ET DU NOMBRE TOTAL
C     DE D.D.L., ASSOCIES A LA SOUS-STRUCTURE.
C
        NDDL0 = ZI(LDPRS+2*NUSST-2)
        NBMOD = ZI(LDPRS+2*NUSST-1)
C
C     ASSEMBLAGE DES VALEURS DE CHARGEMENT
C
C     LE VECTEUR GLOBAL EST POSITIONNE EN ZR(LRVAL) (DANS RESVAL)
C     CELUI LOCAL A LA SOUS-STRUCTURE EN ZR(IDVALE)
C
        CALL JEVEUO(JEXNOM(CHAVAL,NOMSST),'L',IDVALE)
C
C     BOUCLE SUR LES MODES DE LA SOUS-STRUCTURE
C
        DO 60 J = 1,NBMOD
          IPOS = (NDDL0-1) + (J-1)
          ZR(LRVAL+IPOS) = ZR(LRVAL+IPOS) + ZR(IDVALE+J-1)
   60   CONTINUE
C
C
  100 CONTINUE
C
      CALL JEDEMA()
      END
