      SUBROUTINE PROJCO (INST,NOMA,NEWGEO,DEFICO,RESOCO)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/05/2002   AUTEUR PABHHHH N.TARDIEU 
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
C
      IMPLICIT NONE
C
      REAL*8        INST
      CHARACTER*8   NOMA
      CHARACTER*24  NEWGEO,DEFICO,RESOCO
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : NMCONT
C ----------------------------------------------------------------------
C
C CALCUL DES COEFFICIENTS DE LA RELATION DE NON-INTERPENETRATION.
C LA PROJECTION N'EST EFFECTUEE QUE SI L'APPARIEMENT NE VIENT PAS
C D'ETRE REACTUALISE (SINON PROJEC A DEJA ETE APPELE PAR RECHCO).
C
C IN  INST   : VALEUR DE L'INSTANT DE CALCUL
C IN  NOMA   : NOM DU MAILLAGE
C IN  NEWGEO : GEOMETRIE ACTUALISEE EN TENANT COMPTE DU CHAMP DE
C              DEPLACEMENTS COURANT
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C VAR RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32       JEXNUM , JEXNOM
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      LOGICAL      MULNOR
      INTEGER      NDIM,IESCL,NESCL,POSNO,POSMA,IFM,IMPR,NZOCO,NNOCO
      INTEGER      JDECAL,NBNO,JDIM,REACTU,REAPRO,NBDDL,IER
      INTEGER      JAPPAR,JAPPTR,JAPNOR,JAPJEU,JAPCOE,JAPDDL,JNOCO
      INTEGER      JJSUP,JJFO1,JJFO2,IBID,JCOOR,NUMNO
      INTEGER      JREAC,JAPMEM,K,POSNOE(10),IZONE,JZOCO,JCOEF,JCHAM
      REAL*8       OLDJEU,JEU,CMULT,DIST1,DIST2,RBID,RBID2(3)
      REAL*8       X,Y,Z,VALPAR(3)
      CHARACTER*8  JEUF1,JEUF2,NOMPAR(3)
      CHARACTER*24 CONTNO,CONTMA,NOMACO,PNOMA,NDIMCO,DDLCO,PDDL,NORMCO
      CHARACTER*24 APPARI,APPOIN,APNORM,APJEU,APCOEF,APDDL
      CHARACTER*24 APREAC,APMEMO,NOZOCO,COEFCO,CHAMCO
      CHARACTER*24 JEUSUP,JEUFO1,JEUFO2
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ ()
C
C --- SD POUR LE CONTACT POTENTIEL
C
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      NDIMCO = DEFICO(1:16)//'.NDIMCO'
      NOZOCO = DEFICO(1:16)//'.NOZOCO'
      COEFCO = DEFICO(1:16)//'.COEFCO'
      CHAMCO = DEFICO(1:16)//'.CHAMCO'
      JEUSUP = DEFICO(1:16)//'.JSUPCO'
      JEUFO1 = DEFICO(1:16)//'.JFO1CO'
      JEUFO2 = DEFICO(1:16)//'.JFO2CO'
C
      CALL JEVEUO (CONTNO,'L',JNOCO)
      CALL JEVEUO (NOZOCO,'L',JZOCO)
      CALL JEVEUO (COEFCO,'L',JCOEF)
      CALL JEVEUO (CHAMCO,'L',JCHAM)
      CALL JEVEUO (JEUSUP,'E',JJSUP)
      CALL JEVEUO (JEUFO1,'L',JJFO1)
      CALL JEVEUO (JEUFO2,'L',JJFO2)
C
C --- SD POUR LE CONTACT EFFECTIF
C
      APREAC = RESOCO(1:14)//'.APREAC'
      APMEMO = RESOCO(1:14)//'.APMEMO'
      APPARI = RESOCO(1:14)//'.APPARI'
      APPOIN = RESOCO(1:14)//'.APPOIN'
      APNORM = RESOCO(1:14)//'.APNORM'
      APJEU  = RESOCO(1:14)//'.APJEU'
      APCOEF = RESOCO(1:14)//'.APCOEF'
      APDDL  = RESOCO(1:14)//'.APDDL'
C
      CALL JEVEUO (APPARI,'L',JAPPAR)
      NESCL = ZI(JAPPAR)
      CALL JEVEUO (APPOIN,'L',JAPPTR)
      CALL JEVEUO (APNORM,'E',JAPNOR)
      CALL JEVEUO (APJEU, 'E',JAPJEU)
      CALL JEVEUO (APCOEF,'E',JAPCOE)
      CALL JEVEUO (APDDL, 'E',JAPDDL)
C
C --- DIMENSION DE L'ESPACE (2 OU 3)
C
      CALL JEVEUO (NDIMCO, 'L',JDIM)
      NDIM = ZI(JDIM)
C
C --- COORDONNEES DES NOEUDS DU MAILLAGE
C
      CALL JEVEUO (NEWGEO(1:19)//'.VALE','L',JCOOR)
C
C --- EN VUE DE L'INTERPOLATION DU JEU PAR DES VARIABLES D'ESPACE
C
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      NOMPAR(3) = 'Z'
C
C --- BOUCLE SUR LES NOEUDS ESCLAVES, PROJECTION SUR LA MAILLE MAITRE
C --- ET CALCUL DU JEU COURANT
C
      DO 10 IESCL = 1,NESCL
C
        POSNO  = ZI(JAPPAR+3*(IESCL-1)+1)
        POSMA  = ZI(JAPPAR+3*(IESCL-1)+2)
        REACTU = ZI(JAPPAR+3*(IESCL-1)+3)
        REAPRO = ABS(REACTU)
        IZONE = ZI(JZOCO+POSNO-1)
        CMULT = ZR(JCOEF+IZONE-1)
        MULNOR = (ABS(ZI(JCHAM+IZONE-1)).EQ.1)
C
C --- NUMERO DU NOEUD ESCLAVE COURANT
C
        NUMNO = ZI(JNOCO+POSNO-1)
C
C --- COORDONNEES DU NOEUD ESCLAVE COURANT
C
        X = ZR(JCOOR+3*(NUMNO-1))
        Y = ZR(JCOOR+3*(NUMNO-1)+1)
        Z = ZR(JCOOR+3*(NUMNO-1)+2)
C
C --- TABLEAU DES PARAMETRES A TRANSMETTRE POUR L'INTERPOLATION DU JEU
C
        VALPAR(1) = X
        VALPAR(2) = Y
        VALPAR(3) = Z
C
C --- VALEUR DU JEU SUPPLEMENTAIRE SI C'EST UNE "FONCTION" D'ESPACE
C
        DIST1 = 0.D0
        DIST2 = 0.D0
        JEUF1 = ZK8(JJFO1+IZONE-1)
        JEUF2 = ZK8(JJFO2+IZONE-1)
        IF ((JEUF1.NE.' ').OR.(JEUF2.NE.' ')) THEN
          IF (JEUF1.NE.' ')
     &        CALL FOINTE ('F',JEUF1,3,NOMPAR,VALPAR,DIST1,IER)
          IF (JEUF2.NE.' ')
     &        CALL FOINTE ('F',JEUF2,3,NOMPAR,VALPAR,DIST2,IER)
          ZR(JJSUP+IZONE-1) = DIST1 + DIST2
        END IF
C
C --- PROJECTION (DETERMINATION DES NOEUDS MAITRES, DES DDLS DE LA
C --- RELATION, CALCUL DES COEFFICIENTS, DE LA NORMALE, DU JEU)
C --- NB : ON AJOUTE AU JEU LE TABLEAU JEUSUP, JEU INITIAL "FICTIF"
C
        IF (REACTU.NE.0) THEN
          JDECAL = ZI(JAPPTR+IESCL-1)
          CALL PROJEC (IZONE,NDIM,NOMA,NEWGEO,DEFICO,
     &                 MULNOR,POSNO,POSMA,
     &                 REAPRO,CMULT,ZR(JAPNOR+3*(IESCL-1)),
     &                 POSNOE,ZR(JAPCOE+JDECAL),OLDJEU,JEU,
     &                 ZI(JAPDDL+JDECAL),NBNO,NBDDL,RBID2,RBID,RBID,
     &                 RBID)
          ZR(JAPJEU+IESCL-1) = JEU - ZR(JJSUP+IZONE-1)
C
        END IF
C
 10   CONTINUE
C
C --- IMPRESSIONS POUR LES DEVELOPPEURS
C
      CALL INFNIV (IFM,IMPR)
C
      IF (IMPR.GE.2) THEN
C        NZOCO = ZI(JDIM+1)
C        NNOCO = ZI(JDIM+4)
        CALL JEVEUO (APREAC,'L',JREAC)
        CALL JEVEUO (APMEMO,'L',JAPMEM)
        WRITE (IFM,*)
        WRITE (IFM,1060) '--------------------------------------'
        WRITE (IFM,1060) '     IMPRESSIONS DE VERIFICATION      '
        WRITE (IFM,1060) '      APRES PROJECTION (PROJCO)       '
        WRITE (IFM,1060) '--------------------------------------'
        WRITE (IFM,*)
C        WRITE (IFM,1060) '---> NESCL = ',NESCL
C        WRITE (IFM,*)
C        WRITE (IFM,1050) '---> APREAC'
C        WRITE (IFM,1030) (ZI(JREAC+K-1),K=1,4*NZOCO)
C        WRITE (IFM,*)
C        WRITE (IFM,1050) '---> APMEMO'
C        WRITE (IFM,1020) (ZI(JAPMEM+K-1),K=1,4*NNOCO)
C        WRITE (IFM,*)
C        WRITE (IFM,1050) '---> APPARI'
C        WRITE (IFM,1070) ZI(JAPPAR)
C        WRITE (IFM,1010) (ZI(JAPPAR+K),K=1,3*NESCL)
C        WRITE (IFM,*)
C        WRITE (IFM,1050) '---> APPOIN'
C        WRITE (IFM,1030) (ZI(JAPPTR+K),K=0,NESCL)
C        WRITE (IFM,*)
        WRITE (IFM,1050) '---> APNORM'
        WRITE (IFM,1000) (ZR(JAPNOR+K-1),K=1,3*NESCL)
        WRITE (IFM,*)
        WRITE (IFM,1050) '---> APJEU'
        WRITE (IFM,1000) (ZR(JAPJEU+K-1),K=1,NESCL)
        WRITE (IFM,*)
C        WRITE (IFM,1050) '---> APCOEF'
C        WRITE (IFM,1000) (ZR(JAPCOE+K-1),K=1,ZI(JAPPTR+NESCL))
C        WRITE (IFM,*)
C        WRITE (IFM,1050) '---> APDDL'
C        WRITE (IFM,1010) (ZI(JAPDDL+K-1),K=1,ZI(JAPPTR+NESCL))
        WRITE (IFM,*)
        WRITE (IFM,1060) '--------------------------------------'
        WRITE (IFM,*)
      END IF
C
C ----------------------------------------------------------------------
C
 1000 FORMAT (('<CONTACT_3> ',8X,6(1E10.3,1X)))
 1010 FORMAT (('<CONTACT_3> ',8X,6(I5,2X)))
 1020 FORMAT (('<CONTACT_3> ',8X,8(I5,2X)))
 1030 FORMAT (('<CONTACT_3> ',8X,10(I5,2X)))
 1040 FORMAT (('<CONTACT_3> ',8X,6(I5,2X)))
 1050 FORMAT ('<CONTACT_3> ',A11)
 1060 FORMAT ('<CONTACT_3> ',A38)
 1070 FORMAT ('<CONTACT_3> ',9X,I5)
C
      CALL JEDEMA ()
      END
