      SUBROUTINE BMNODI(BASMDZ,INTFZ,NMINTZ,NUMINT,NBDEF,IVCORD,NBDIF)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C    P. RICHARD     DATE 09/0491/
C-----------------------------------------------------------------------
C  BUT:       < BASE MODALE NUMERO ORDRE DES DEFORMEES INTERFACE>
C
C  SI BASE MODALE DONNEE:
C  ----------------------
C    RENDRE UN VECTEUR DONNANT LES NUMEROS ORDRE DES DEFORMEES (DANS
C  UN CONCEPT BASE MODALE) ASSOCIEES AU DDL D'UNE INTERFACE
C
C  SI PAS DE BASE MODALE DONNEE:
C  ----------------------
C    RENDRE UN VECTEUR DONNANT LES NUMEROS ORDRE DES DEFORMEES A CALCULE
C  RELATIF A UNE INTERFACE D'UNE INTERF_DYNA
C
C  L'INTERFACE EST DONNEE SOIT PAR SON NOM SOIT PAR SON NUMERO
C
C-----------------------------------------------------------------------
C
C BASMDZ   /I/: NOM UTILISATEUR DE LA BASE MODALE OU BLANC
C INTFZ    /I/: NOM UTILISATEUR DE L'INTERF_DYNA OU BLANC
C NMINTZ   /I/: NOM DE L'INTERFACE
C NUMINT   /I/: NUMERO DE L'INTERFACE
C NBDEF    /I/: NOMBRE DE NUMERO ORDRE ATTENDUS
C IVCORD   /O/: VECTEUR DES NUMEROS D'ORDRE A REMPLIR
C NBDIF    /0/: NOMBRE ATTENDU - NOMBRE TROUVE
C
C
C
      INCLUDE 'jeveux.h'
C
C
      CHARACTER*8 BASMOD,NOMINT,INTF,BLANC,INTFB
      CHARACTER*8 K8BID
      CHARACTER*(*) BASMDZ,NMINTZ,INTFZ
      CHARACTER*24 NOEINT,IDESC
      CHARACTER*24 VALK(3)
      INTEGER IVCORD(NBDEF),IDEC(300)
      INTEGER VALI,IER
      CHARACTER*10 TYPBAS(3)
      CHARACTER*1 K1BID
C
C-----------------------------------------------------------------------
      DATA TYPBAS/'CLASSIQUE','CYCLIQUE','RITZ'/
C-----------------------------------------------------------------------
C
C
      CALL JEMARQ()
      BASMOD = BASMDZ
      NOMINT = NMINTZ
      INTF   = INTFZ
      BLANC='        '
      IF(BASMOD.EQ.BLANC.AND.INTF.EQ.BLANC) THEN
          VALK (1) = BASMOD
          VALK (2) = INTF
          CALL U2MESG('F', 'ALGORITH12_26',2,VALK,0,0,0,0.D0)
      ENDIF
C
      NBDIF=NBDEF
      NBMOD=0
C
C
C-------------RECUPERATION DU TYPE DE BASE ET INTERF_DYNA------------
C
      IF(BASMOD.NE.BLANC) THEN
        CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
        IDESC=ZK24(LLREF+6)
        CALL DISMOI('F','NB_MODES_DYN',BASMOD,'RESULTAT',
     &                      NBMOD,K8BID,IER)
        IF(IDESC(1:9).NE.'CLASSIQUE') THEN
          VALK (1) = BASMOD
          VALK (2) = IDESC
          VALK (3) = TYPBAS(1)
          CALL U2MESG('F', 'ALGORITH12_27',3,VALK,0,0,0,0.D0)
        ENDIF
C
        CALL JEVEUO(BASMOD//'           .REFD','L',LLREF)
        INTFB=ZK24(LLREF+4)
        IF(INTF.NE.BLANC.AND.INTF.NE.INTFB) THEN
          VALK (1) = BASMOD
          VALK (2) = INTFB
          VALK (3) = INTF
          CALL U2MESG('F', 'ALGORITH12_28',3,VALK,0,0,0,0.D0)
        ELSE
          INTF=INTFB
        ENDIF
      ENDIF
C
C
C----------------RECUPERATION DONNEES GRANDEUR SOUS-JACENTE-------------
C
      CALL DISMOI('F','NB_CMP_MAX',INTF,'INTERF_DYNA',NBCMP,
     &            K8BID,IRET)
      CALL DISMOI('F','NB_EC',INTF,'INTERF_DYNA',NBEC,
     &            K8BID,IRET)
C
C
C
C----------------RECUPERATION EVENTUELLE DU NUMERO INTERFACE------------
C
      IF(NUMINT.LT.1) THEN
        IF(NOMINT.EQ.'          ') THEN
          VALK (1) = NOMINT
          VALI = NUMINT
          CALL U2MESG('F', 'ALGORITH12_29',1,VALK,1,VALI,0,0.D0)
        ELSE
          CALL JENONU(JEXNOM(INTF//'.IDC_NOMS',NOMINT),NUMINT)
        ENDIF
      ENDIF
C
C----------RECUPERATION DU NOMBRE DE NOEUD DE L' INTERFACES-------------
C
      NOEINT=INTF//'.IDC_LINO'
C
        CALL JELIRA(JEXNUM(NOEINT,NUMINT),'LONMAX',NBNOE,K1BID)
        CALL JEVEUO(JEXNUM(NOEINT,NUMINT),'L',LLNOE)
C
C-------------RECUPERATION DU DESCRIPTEUR DES DEFORMEES-----------------
C
C
      CALL JEVEUO(INTF//'.IDC_DEFO','L',LLDES)
      CALL JELIRA(INTF//'.IDC_DEFO','LONMAX',NBNOT,K1BID)
      NBNOT = NBNOT/(2+NBEC)
C
C-----------RECUPERATION DES NUMERO ORDRE DEFORMEES --------------------
C
C
C RECUPERATION NUMERO ORDRE  DEFORMEES
C
      DO 20 I=1,NBNOE
        INOE=ZI(LLNOE+I-1)
        IORDEF=ZI(LLDES+NBNOT+INOE-1)+NBMOD
        CALL ISDECO(ZI(LLDES+2*NBNOT+(INOE-1)*NBEC+1-1),IDEC,NBCMP)
C
        DO 30 J=1,NBCMP
          IF(IDEC(J).GT.0) THEN
            NBDIF=NBDIF-1
            IF(NBDIF.GE.0) IVCORD(NBDEF-NBDIF)=IORDEF
            IORDEF=IORDEF+1
          ENDIF
 30     CONTINUE
C
 20   CONTINUE
C
      NBDIF=-NBDIF
C
      CALL JEDEMA()
      END
