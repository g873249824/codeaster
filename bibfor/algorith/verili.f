      SUBROUTINE  VERILI (NOMRES,II,FPLI1,FPLI2,IRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C    P. RICHARD     DATE 13/10/92
C-----------------------------------------------------------------------
C  BUT:      < CALCUL DES LIAISONS >
      IMPLICIT REAL*8 (A-H,O-Z)
C
C  CALCULER LES NOUVELLES MATRICE DE LIAISON EN TENANT COMPTE
C   DE L'ORIENTATION DES SOUS-STRUCTURES
C  ON DETERMINE LES MATRICE DE LIAISON, LES DIMENSIONS DE CES MATRICES
C  ET LE PRONO ASSOCIE
C
C-----------------------------------------------------------------------
C
C NOMRES   /I/: NOM UTILISATEUR DU RESULTAT MODE_GENE
C I        /I/: NUMERO INTERFACE COURANTE
C FPLI1    /I/: FAMILLE DES PROFNO DES MATRICES DE LIAISON COTE 1
C FPLI2    /I/: FAMILLE DES PROFNO DES MATRICES DE LIAISON COTE 2
C IRET     /I/: CODE RETOUR DE LA VERIF (=NOMBRE ERREUR, 0=OK)
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
      CHARACTER*32  JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C   PARAMETER REPRESENTANT LE NOMBRE MAX DE COMPOSANTE DE LA GRANDEUR
C   SOUS-JACENTE TRAITES
C
      PARAMETER (NBCMPM =  10)
      PARAMETER (NBECMX =  10)
      CHARACTER*6      PGC
      CHARACTER*8 NOMRES,NOMG,KBID
      CHARACTER*24  FPLI1,FPLI2
      CHARACTER*8 SST1,SST2,INTF1,INTF2,BLANC
      INTEGER IDECP(NBCMPM),IDECM(NBCMPM)
      INTEGER ICODP(NBECMX),ICODM(NBECMX)
      CHARACTER*1 K1BID
C
C-----------------------------------------------------------------------
      DATA PGC /'VERILI'/
      DATA BLANC /' '/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      IRET=0
C
C-----RECUPERATION DU NOMBRE DU NOMBRE D'ENTIERS CODES ASSOCIE A DEPL_R
C
      NOMG = 'DEPL_R'
      CALL DISMOI('F','NB_EC',NOMG,'GRANDEUR',NBEC,KBID,IERD)
      IF (NBEC.GT.10) THEN
         CALL U2MESS('F','MODELISA_94')
      ENDIF
C
C----RECUPERATION DES NOM DE MACR_ELEM ET INTERFACE MIS EN JEU----------
C
      CALL JEVEUO(JEXNUM(NOMRES//'      .MODG.LIDF',II),'L',LLLIA)
      SST1=ZK8(LLLIA)
      INTF1=ZK8(LLLIA+1)
      SST2=ZK8(LLLIA+2)
      INTF2=ZK8(LLLIA+3)
C
C--------------VERIFICATION COHERENCE NOMBRE DE NOEUDS------------------
C
      CALL JELIRA(JEXNUM(FPLI1,II),'LONMAX',IDIM1,K1BID)
      NBNOE1=IDIM1/(1+NBEC)
      CALL JELIRA(JEXNUM(FPLI2,II),'LONMAX',IDIM2,K1BID)
      NBNOE2=IDIM2/(1+NBEC)
C
      IF(NBNOE1.NE.NBNOE2) THEN
        CALL UTDEBM('E',PGC,
     &'PROBLEME DE COHERENCE DE NOMBRE DE NOEUDS D''INTERFACE')
        CALL UTIMPK('L','SOUS-STRUCTURE1:',1,SST1)
        CALL UTIMPK('L','INTERFACE1:',1,INTF1)
        CALL UTIMPI('L','NOMBRE DE NOEUDS INTERFACE1:',1,NBNOE1)
        CALL UTIMPK('L','SOUS-STRUCTURE2:',1,SST2)
        CALL UTIMPK('L','INTERFACE2:',1,INTF2)
        CALL UTIMPI('L','NOMBRE DE NOEUDS INTERFACE2:',1,NBNOE2)
        CALL UTFINM
        IRET=1
        GOTO 9999
      ENDIF
C
C--------RECUPERATION DU NUMERO DE GRANDEUR SOUS-JACENTE----------------
C
      CALL JEVEUO(NOMRES//'      .MODG.DESC','L',LLDESC)
        NUMGD=ZI(LLDESC+2)
C
C-----------------VERIFICATION SUR LES COMPOSANTES----------------------
C
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',NUMGD),'L',LLNCMP)
      CALL JEVEUO(JEXNUM(FPLI1,II),'L',LLPL1)
      CALL JEVEUO(JEXNUM(FPLI2,II),'L',LLPL2)
C
      DO 10 I=1,NBNOE1
C
        CALL ISGECO(ZI(LLPL1+(I-1)*(NBEC+1)+1),
     &              ZI(LLPL2+(I-1)*(NBEC+1)+1),NBCMPM,-1,ICODP)
        CALL ISGECO(ZI(LLPL2+(I-1)*(NBEC+1)+1),
     &              ZI(LLPL1+(I-1)*(NBEC+1)+1),NBCMPM,-1,ICODM)
C
        CALL ISDECO(ICODM,IDECM,NBCMPM)
        CALL ISDECO(ICODP,IDECP,NBCMPM)
C
        DO 20 J=1,NBCMPM
          IF(IDECP(J).NE.0) THEN
            CALL UTDEBM('F',PGC,
     &'PROBLEME DE COHERENCE DES INTERFACES ORIENTEES')
            CALL UTIMPK('L','SOUS-STRUCTURE1:',1,SST1)
            CALL UTIMPK('L','INTERFACE1:',1,INTF1)
            CALL UTIMPK('L','PRESENCE COMPOSANTE SUR 1:',
     &1,ZK8(LLNCMP+J-1))
            CALL UTIMPK('L','SOUS-STRUCTURE2:',1,SST2)
            CALL UTIMPK('L','INTERFACE2:',1,INTF2)
            CALL UTIMPK('L','COMPOSANTE INEXISTANTE SUR 2',1,BLANC)
            CALL UTFINM
            IRET=IRET+1
          ENDIF
          IF(IDECM(J).NE.0) THEN
            CALL UTDEBM('F',PGC,
     &'PROBLEME DE COHERENCE DES INTERFACES ORIENTEES')
            CALL UTIMPK('L','SOUS-STRUCTURE2:',1,SST2)
            CALL UTIMPK('L','INTERFACE2:',1,INTF2)
            CALL UTIMPK('L','PRESENCE COMPOSANTE SUR 2:',
     &1,ZK8(LLNCMP+J-1))
            CALL UTIMPK('L','SOUS-STRUCTURE1:',1,SST1)
            CALL UTIMPK('L','INTERFACE1:',1,INTF1)
            CALL UTIMPK('L','COMPOSANTE INEXISTANTE SUR 1',1,BLANC)
            CALL UTFINM
            IRET=IRET+1
          ENDIF
20      CONTINUE
10    CONTINUE
C
C
 9999 CONTINUE
      CALL JEDEMA()
      END
