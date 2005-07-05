      SUBROUTINE CRLIDD(NOMRES,MAILLA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/07/2005   AUTEUR CIBHHPD L.SALMONA 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C    P. RICHARD     DATE 19/02/91
C-----------------------------------------------------------------------
C  BUT:  CREER LE TABLEAU DESCRIPTEUR DES DEFORMEES A CALCULER
C
C  REMPLIR LA PREMIERE LIGNE PAR LES NUMERO (MAILLAGE) DES NOEUDS
C
C
C  REMPLIR LA DEUXIEME LIGNE PAR UN CODE DE TYPE D'INTERFACE
C   (-1 MAC NEAL) (-2 CRAIG BAMPTON)(-3  CB_HARMO)(-4 AUCUN)
C  CETTE COLONNE CONTIENDRA PLUS TARD LE NUMERO DE LA PREMIERE
C    DEFORMEE STATIQUE DU NOEUDS
C
C REMPLIR LA TROISIEME COLONNE  PAR LE  DU CUMUL DES
C       MASQUES AU NOEUDS (DDL SUR LESQUELS SERONT CALCULEES
C      LES DEFORMES A PRIORI)
C  CET ENTIER SERA REACTUALISE PLUS TARD EN FONCTION DES DDL
C    REELLEMENT ACTIFS AUX NOEUDS
C
C
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UTLISATEUR DU CONCEPT RESULTAT DE L'OPERATEUR
C MAILLA /I/: NOM UTLISATEUR DU MAILLAGE DE LA SOUS-STRUCTURE
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
      CHARACTER*8 NOMRES,MAILLA,CB,MN,HA,AU,NOMTYP
      CHARACTER*8 K8BID
      CHARACTER*24 TEMMN,TEMCB,TEMHA,TEMAU,TEMMAS
      CHARACTER*24 NOMINT,TYPINT,NOEINT,DESDEF
      LOGICAL DOUBOK
      CHARACTER*1 K1BID
C
C-----------------------------------------------------------------------
      DATA CB,MN,HA,AU /'CRAIGB','MNEAL','CB_HARMO','AUCUN'/
      DATA DOUBOK /.FALSE./
C-----------------------------------------------------------------------
C
C-----------------INITIALISATION DES NOM LES PLUS UTILISES--------------
C
      CALL JEMARQ()
      TYPINT=NOMRES//'.IDC_TYPE'
      NOEINT=NOMRES//'.IDC_LINO'
C
C----------------RECUPERATION DU NOMBRE D'ENTIERS CODES DE LA GRANDEUR-
C
      CALL DISMOI('F','NB_EC',NOMRES,'INTERF_DYNA',NBEC,K8BID,IRET)
C
C----------------------RECUPERATION TYPE INTERFACE----------------------
C
       CALL JEVEUO(TYPINT,'L',LLTYP)
C
C--------------------RECHERCHE DU NOMBRE D'INTERFACES-------------------
C
      CALL JELIRA(NOEINT,'NMAXOC',NBINT,K1BID)
C
C------- BOUCLE DE COMPTAGE DES NOEUDS PAR TYPE INTERFACES--------------
C
      NBCB=0
      NBMN=0
      NBAU=0
      NBHA=0
      DO 10 I=1,NBINT
        NOMTYP=ZK8(LLTYP+I-1)
C
C    COMPTEUR CRAIG BAMPTON
C
        IF(NOMTYP.EQ.CB) THEN
          CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
          NBCB=NBCB+NBNO
        ENDIF
C
C    COMPTEUR MAC NEAL
C
        IF(NOMTYP.EQ.MN) THEN
          CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
          NBMN=NBMN+NBNO
        ENDIF
C
C    COMPTEUR CRAIG-BAMPTON-HARMONIQUE
C
        IF(NOMTYP.EQ.HA) THEN
          CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
          NBHA=NBHA+NBNO
        ENDIF
C
C    COMPTEUR AUCUN
C
        IF(NOMTYP.EQ.AU) THEN
          CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
          NBAU=NBAU+NBNO
        ENDIF
C
 10   CONTINUE
C
C---------ALLOCATION DU VECTEUR DES NOEUDS CRAIG BAMPTON----------------
C
      TEMCB='&&CRLIDD.NOE.CB'
      IF(NBCB.GT.0) THEN
        CALL WKVECT(TEMCB,'V V I',NBCB,LTCB)
      ENDIF
C
C---------ALLOCATION DU VECTEUR DES NOEUDS MAC NEAL---------------------
C
      TEMMN='&&CRLIDD.NOE.MN'
      IF(NBMN.GT.0) THEN
        CALL WKVECT(TEMMN,'V V I',NBMN,LTMN)
      ENDIF
C
C---------ALLOCATION DU VECTEUR DES NOEUDS CB_HARMO---------------------
C
      TEMHA='&&CRLIDD.NOE.HA'
      IF(NBHA.GT.0) THEN
        CALL WKVECT(TEMHA,'V V I',NBHA,LTHA)
      ENDIF
C
C------------ALLOCATION DU VECTEUR DES NOEUDS AUCUN---------------------
C
      TEMAU='&&CRLIDD.NOE.AU'
      IF(NBAU.GT.0) THEN
        CALL WKVECT(TEMAU,'V V I',NBAU,LTAU)
      ENDIF
C
C---------BOUCLE DE REMPLISSAGE DES 3 VECTEURS TEMCB TEMMN TEMAU--------
C
      NBCB=0
      NBMN=0
      NBAU=0
      NBHA=0
C
      DO 20 I=1,NBINT
        NOMTYP=ZK8(LLTYP+I-1)
C
C    NOEUDS DE CRAIG BAMPTON
C
        IF(NOMTYP.EQ.CB) THEN
          CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
          CALL JEVEUO(JEXNUM(NOEINT,I),'L',LLNIN)
          DO 30 J=1,NBNO
            ZI(LTCB+NBCB)=ZI(LLNIN+J-1)
            NBCB=NBCB+1
 30       CONTINUE
        ENDIF
C
C    NOEUD DE MAC NEAL
C
        IF(NOMTYP.EQ.MN) THEN
          CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
          CALL JEVEUO(JEXNUM(NOEINT,I),'L',LLNIN)
          DO 40 J=1,NBNO
            ZI(LTMN+NBMN)=ZI(LLNIN+J-1)
            NBMN=NBMN+1
 40       CONTINUE
        ENDIF
C
C    NOEUD DE CB_HARMO
C
        IF(NOMTYP.EQ.HA) THEN
          CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
          CALL JEVEUO(JEXNUM(NOEINT,I),'L',LLNIN)
          DO 50 J=1,NBNO
            ZI(LTHA+NBHA)=ZI(LLNIN+J-1)
            NBHA=NBHA+1
 50       CONTINUE
        ENDIF
C
C    NOEUD DE AUCUN
C
        IF(NOMTYP.EQ.AU) THEN
          CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
          CALL JEVEUO(JEXNUM(NOEINT,I),'L',LLNIN)
          DO 60 J=1,NBNO
            ZI(LTAU+NBAU)=ZI(LLNIN+J-1)
            NBAU=NBAU+1
 60       CONTINUE
        ENDIF
C
 20   CONTINUE
C
C-------SUPPRESSION DES DOUBLES ET ORDRE DES LISTES TROUVEES------------
C
      IF (NBCB.NE.0) CALL UTTRII(ZI(LTCB),NBCB)
      IF (NBMN.NE.0) CALL UTTRII(ZI(LTMN),NBMN)
      IF (NBHA.NE.0) CALL UTTRII(ZI(LTHA),NBHA)
      IF (NBAU.NE.0) CALL UTTRII(ZI(LTAU),NBAU)
C
C-----------COMPARAISON LISTES MN ET CB POUR DETECTION INTERSECTION-----
C
      CALL NODOUB(NBMN,NBCB,ZI(LTMN),ZI(LTCB),MN,CB,MAILLA,DOUBOK)
      CALL NODOUB(NBMN,NBHA,ZI(LTMN),ZI(LTHA),MN,HA,MAILLA,DOUBOK)
      CALL NODOUB(NBHA,NBCB,ZI(LTHA),ZI(LTCB),HA,CB,MAILLA,DOUBOK)
      IF(DOUBOK) THEN
        CALL UTDEBM('F','CRLIDD','ARRET SUR PROBLEME CONDITIONS
     &              INTERFACE')
       CALL UTFINM
      ENDIF
C
C-----------ALLOCATION TABLEAU DESCRIPTION DEFORMEES CALCULEES----------
C
      NBTO=NBCB+NBMN+NBHA+NBAU
C
      NBTEM=(2+NBEC)*NBTO
C
      DESDEF=NOMRES//'.IDC_DEFO'
      CALL WKVECT(DESDEF,'G V I',NBTEM,LLDES)
C
C-----REMPLISSAGE DU TABLEAU PAR ORDRE DES NOEUDS (MN CB AU)------------
C
      NBTEM=0
C
C    NOEUD MAC NEAL
C
      CALL COPVIS(NBMN,ZI(LTMN),ZI(LLDES+NBTEM))
      NBTEM=NBTEM+NBMN
C
C
C    NOEUD CRAIG BAMPTON
C
      CALL COPVIS(NBCB,ZI(LTCB),ZI(LLDES+NBTEM))
      NBTEM=NBTEM+NBCB
C
C    NOEUD CRAIG-BAMPTON-HARMONIQUE
C
      CALL COPVIS(NBHA,ZI(LTHA),ZI(LLDES+NBTEM))
      NBTEM=NBTEM+NBHA
C
C    NOEUD AUCUN
C
      CALL COPVIS(NBAU,ZI(LTAU),ZI(LLDES+NBTEM))
      NBTEM=NBTEM+NBAU
C
C--RECUPERATION DU NOMBRE DE COMPOSANTES DE LA GRANDEUR SOUS-JACENTE----
C
      CALL DISMOI('F','NB_CMP_MAX',NOMRES,'INTERF_DYNA',
     &             NBCMP,K8BID,IRET)
C
C-------------DEFINITION DU NOM  OBJET MASQUE AUX INTERFACES------------
C
      TEMMAS='&&DEFINT'//'.MASQUE'
C
C---------MODIFICATION NUMEROTATION DANS DEFINITION INTERFACES----------
C LE NUMERO DU NOEUD DANS LE MAILLAGE DEVIENT LE NUMERO DANS LA
C        LISTE DES NOEUDS D'INTERFACE
C
C REMPLISSAGE COMME INDIQUE DANS L'ENTETE DES COLONNES 2 ET 3 DU
C DESCRIPTEUR DES DEFORMEES
C
      DO 100 I=1,NBINT
        NOMTYP=ZK8(LLTYP+I-1)
        CALL JELIRA(JEXNUM(NOEINT,I),'LONMAX',NBNO,K1BID)
        CALL JEVEUO(JEXNUM(NOEINT,I),'E',LLNIN)
        CALL JEVEUO(JEXNUM(TEMMAS,I),'L',LTMAS)
C
C    NOEUD DE MAC NEAL
C
        IF(NOMTYP.EQ.MN) THEN
C
          NBTEM=0
C
          DO 110 J=1,NBNO
            INO=ZI(LLNIN+J-1)
            CALL CHERIS(NBMN,ZI(LLDES+NBTEM),INO,IRAN)
            ZI(LLNIN+J-1)=IRAN+NBTEM
C
            IAD=LLDES+NBTO+IRAN+NBTEM-1
            ZI(IAD)=-1
C
            IAD=LLDES+NBTO*2+(IRAN-1)*NBEC+NBTEM-1+1
            CALL ISGECO(ZI(LTMAS+(J-1)*NBEC),ZI(IAD),NBCMP,1,ZI(IAD))
 110      CONTINUE
        ENDIF
C
C    NOEUDS DE CRAIG BAMPTON
C
        IF(NOMTYP.EQ.CB) THEN
C
          NBTEM=NBMN
C
          DO 120 J=1,NBNO
            INO=ZI(LLNIN+J-1)
            CALL CHERIS(NBCB,ZI(LLDES+NBTEM),INO,IRAN)
            ZI(LLNIN+J-1)=IRAN+NBTEM
C
            IAD=LLDES+NBTO+IRAN+NBTEM-1
            ZI(IAD)=-2
C
            IAD=LLDES+NBTO*2+(IRAN-1)*NBEC+NBTEM-1+1
            CALL ISGECO(ZI(LTMAS+(J-1)*NBEC),ZI(IAD),NBCMP,1,ZI(IAD))
C
 120      CONTINUE
        ENDIF
C
C    NOEUDS DE CRAIG-BAMPTON-HARMONIQUE
C
        IF(NOMTYP.EQ.HA) THEN
C
          NBTEM=NBMN+NBCB
C
          DO 130 J=1,NBNO
            INO=ZI(LLNIN+J-1)
            CALL CHERIS(NBHA,ZI(LLDES+NBTEM),INO,IRAN)
            ZI(LLNIN+J-1)=IRAN+NBTEM
C
            IAD=LLDES+NBTO+IRAN+NBTEM-1
            ZI(IAD)=-3
C
            IAD=LLDES+NBTO*2+(IRAN-1)*NBEC+NBTEM-1+1
            CALL ISGECO(ZI(LTMAS+(J-1)*NBEC),ZI(IAD),NBCMP,1,ZI(IAD))
C
 130      CONTINUE
        ENDIF
C
C    NOEUD DE AUCUN
C
        IF(NOMTYP.EQ.AU) THEN
C
          NBTEM=NBMN+NBCB+NBHA
C
          DO 140 J=1,NBNO
            INO=ZI(LLNIN+J-1)
            CALL CHERIS(NBAU,ZI(LLDES+NBTEM),INO,IRAN)
            ZI(LLNIN+J-1)=IRAN+NBTEM
C
            IAD=LLDES+NBTO+IRAN+NBTEM-1
            ZI(IAD)=-4
C
            IAD=LLDES+NBTO*2+(IRAN-1)*NBEC+NBTEM-1+1
            CALL ISGECO(ZI(LTMAS+(J-1)*NBEC),ZI(IAD),NBCMP,1,ZI(IAD))
C
 140      CONTINUE
        ENDIF
C
 100  CONTINUE
C
C---------SAUVEGARDE DE LA DEFINITION DES INTERFACES--------------------
C
      CALL JEDETR('&&DEFINT.MASQUE')
      CALL JEDETR('&&DEFINT.NOM.INTF')
      IF(NBMN.GT.0) CALL JEDETR(TEMMN)
      IF(NBCB.GT.0) CALL JEDETR(TEMCB)
      IF(NBAU.GT.0) CALL JEDETR(TEMAU)
      IF(NBHA.GT.0) CALL JEDETR(TEMHA)
C
 9999 CONTINUE
      CALL JEDEMA()
      END
