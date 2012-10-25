      SUBROUTINE ORTH99 ( NOMRES , RITZ )
      IMPLICIT  NONE
      CHARACTER*8         NOMRES
      INTEGER             RITZ
C----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/10/2012   AUTEUR CHANSARD F.CHANSARD 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C----------------------------------------------------------------------
C
C         DEFI_BASE_MODALE : ORTHO_BASE
C
C CE MOT CLE PERMET D'ORTHONORMALISER UNE BASE MODALE QUELCONQUE
C
C----------------------------------------------------------------------
C-------- DEBUT COMMUNS NORMALISES  JEVEUX ----------------------------
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
C-----  FIN  COMMUNS NORMALISES  JEVEUX  ------------------------------
      INTEGER       IFM,NIV,N1,IER,IBID,IMATRA,NBMODE,JORDM,IADRI1,
     &              IDDEEQ,LLNEQU,NEQ,IDMODE,JTRAV1,JTRAV3,JTRAV4,
     &              IOROL,IORNE,IAD,JIAD,JVALE,IEQ,I,NINDEP,LREFE
      REAL*8        ALPHA,RBID
      COMPLEX*16    CBID
      CHARACTER*8   K8B,MATRAS,BASE,ORTHO,INTF
      CHARACTER*16   TYPBAS
      CHARACTER*14  NU, NUMDD1, NUMDDA,MATRI1
      CHARACTER*19  MATR,CHAMOL
C----------------------------------------------------------------------
      CALL JEMARQ()
C
      ALPHA = 0.717D0
C
C     ---RECUPERATION DU NIVEAU D'IMPRESSION---
C
      CALL INFMAJ
      CALL INFNIV ( IFM , NIV )

C----------------------------------------------------------------------
C --- RECUPERATION DE LA MATRICE ASSEMBLEE
C-----------------------------------------------------------------------
    
      IF (RITZ .EQ. 1) THEN
           
        CALL GETVTX('  ','ORTHO',1,1,8,ORTHO,IBID)

        IF (ORTHO .EQ. 'OUI     ') THEN
          CALL GETVID (' ', 'MATRICE'     , 1,1,1, MATRAS, N1 )
        ELSE
          GOTO 9999
        ENDIF
      ELSE
        CALL GETVID ( 'ORTHO_BASE', 'MATRICE'     , 1,1,1, MATRAS, N1 )
      ENDIF

      IF (N1.NE.0) THEN
        CALL DISMOI('F', 'NOM_NUME_DDL', MATRAS, 'MATR_ASSE', IBID,
     &                                            NUMDDA,IER)
        CALL MTDSCR ( MATRAS )
        MATR=MATRAS
        CALL JEVEUO ( MATR//'.&INT', 'E', IMATRA )
        CALL DISMOI('F', 'NOM_NUME_DDL', MATRAS, 'MATR_ASSE', IBID,
     &              NUMDDA,IER)
      ELSE
          MATR=' '
      ENDIF    

C----------------------------------------------------------------------
C --- RECUPERATION DES MODES PROPRES
C-----------------------------------------------------------------------
C
      IF (RITZ .EQ. 1) THEN
        BASE=NOMRES
      ELSE
        CALL GETVID ( 'ORTHO_BASE', 'BASE', 1,1,1, BASE, N1 )
      ENDIF  
      
C RECUPERATION DU TYPE ET DU NBRE DE MODES DES BASES
      CALL GETTCO ( BASE, TYPBAS )
      CALL RSORAC ( BASE, 'LONUTI', IBID, RBID, K8B, CBID, RBID,
     &              'ABSOLU', NBMODE, 1, IBID )

      CALL JEVEUO(  BASE//'           .ORDR','L',JORDM)
C RECUPERATION DE LA NUMEROTATION DES BASES
      CALL JEVEUO(BASE//'           .REFD','L',IADRI1)
      IF ((TYPBAS.EQ.'MODE_MECA').OR.(TYPBAS.EQ.'MODE_GENE')) THEN
         MATRI1 = ZK24(IADRI1)
      ELSE
         MATRI1 = ZK24(IADRI1+2)
      ENDIF
      IF (MATRI1.NE.' ') THEN
        CALL DISMOI('F','NOM_NUME_DDL',MATRI1,'MATR_ASSE',IBID,
     &                NUMDD1,IER)
      ELSE
        NUMDD1 = ZK24(IADRI1+3)(1:14)
      ENDIF
      
      INTF=ZK24(IADRI1+4)(1:8)
      
      IF (NUMDD1.NE.NUMDDA) THEN
          CALL U2MESS('I','ALGELINE2_81')
      ENDIF
      NU = NUMDDA(1:14)
      CALL JEVEUO ( NU//'.NUME.DEEQ', 'L', IDDEEQ )
      CALL JEVEUO(NU//'.NUME.NEQU','L',LLNEQU)
      NEQ = ZI(LLNEQU)
      CALL WKVECT ('&&ORTH99.BASE','V V R',NBMODE*NEQ,IDMODE)
      IF (TYPBAS.EQ.'MODE_GENE') THEN
         CALL COPMOD(BASE,'DEPL',NEQ,NU,NBMODE,ZR(IDMODE))
      ELSE
         CALL COPMO2(BASE,NEQ,NU,NBMODE,ZR(IDMODE))
      ENDIF
C-- FINALEMENT SI, DONC RECOPIE OK      

C-----------------------------------------------------------------------
      CALL WKVECT ('&&ORTH99.TRAV1'   ,'V V R',NEQ       ,JTRAV1)
      CALL WKVECT ('&&ORTH99.TRAV3'   ,'V V R',NBMODE    ,JTRAV3)
      CALL WKVECT ('&&ORTH99.TRAV4'   ,'V V I',NEQ       ,JTRAV4)
C
      DO 50 I = 1,NEQ
         ZI(JTRAV4+I-1) = 1
 50   CONTINUE
C
      IF (MATR.EQ.' ') THEN
C ORTHONORMALISATION L2
        CALL VPGSKP ( NEQ, NBMODE, ZR(IDMODE), ALPHA, IMATRA, 0,
     &                ZR(JTRAV1), ZI(JTRAV4), ZR(JTRAV3) )
      ELSE
C ORTHONORMALISATION PAR RAPPORT A LA MATRICE
        CALL VPGSKP ( NEQ, NBMODE, ZR(IDMODE), ALPHA, IMATRA, 2,
     &                ZR(JTRAV1), ZI(JTRAV4), ZR(JTRAV3) )
      ENDIF
C MISE A ZEROS DES VECTEURS NON INDEPENDANTS       
      CALL VECIND(MATR,IDMODE,NEQ,NBMODE,0,NINDEP)
C
C-- GESTION DES CONCEPTS REENTRANTS
      CALL JEEXIN(NOMRES//'           .DESC',IER)
      IF (IER .NE. 0) THEN
        CALL WKVECT('&&ORTH99.VECT_TEMP','V V I',NBMODE,IBID)
        DO 10 I=1,NBMODE
          ZI(IBID+I-1)=ZI(JORDM+I-1)
  10    CONTINUE
        JORDM=IBID
        CALL JEDETC('G',NOMRES,1)
      ENDIF
      CALL RSCRSD('G',NOMRES,'MODE_MECA',NBMODE)
      
C-- CREATION DU REFD POUR SD_VERI, ET REUTILISATION ULTERIEURE      
      CALL JEEXIN(NOMRES(1:8)//'           .REFD',IBID)
      IF (IBID .EQ. 0) THEN
        CALL WKVECT(NOMRES//'           .REFD','G V K24',7,LREFE)
        ZK24(LREFE)=' '
        ZK24(LREFE+1)=' '
        ZK24(LREFE+2)=' '
        ZK24(LREFE+3)=NUMDD1
        ZK24(LREFE+4)=INTF
        ZK24(LREFE+5)=' '
        ZK24(LREFE+6)='RITZ'
        CALL JELIBE(NOMRES//'           .REFD')
      ENDIF
C
C
      IORNE =0
      DO 80 I=1,NBMODE
         IOROL = ZI(JORDM+I-1)
         IORNE = IORNE+1
C
         CALL RSEXCH(NOMRES,'DEPL',IORNE,CHAMOL,IER)
         CALL VTCREM(CHAMOL,MATRAS,'G','R')
         CALL JEVEUO(CHAMOL//'.VALE','E',JVALE)
         DO 111 IEQ = 1 , NEQ
           ZR(JVALE+IEQ-1) = ZR(IDMODE+(I-1)*NEQ+IEQ-1)
 111     CONTINUE
         CALL RSNOCH(NOMRES,'DEPL',IORNE,' ')
C
         CALL RSADPA(  BASE, 'L',1,'NUME_MODE',IOROL,0, IAD,K8B)
         CALL RSADPA(NOMRES, 'E',1,'NUME_MODE',IORNE,0,JIAD,K8B)
         ZI(JIAD) = ZI(IAD)
C
         CALL RSADPA(  BASE, 'L',1,'FREQ',IOROL,0, IAD,K8B)
         CALL RSADPA(NOMRES, 'E',1,'FREQ',IORNE,0,JIAD,K8B)
         ZR(JIAD) = ZR(IAD)
C
         CALL RSADPA(  BASE, 'L',1,'NORME' ,IOROL,0, IAD,K8B)
         CALL RSADPA(NOMRES, 'E',1,'NORME' ,IORNE,0,JIAD,K8B)
         ZK24(JIAD) = ZK24(IAD)
C
         CALL RSADPA(  BASE, 'L',1,'OMEGA2',IOROL,0, IAD,K8B)
         CALL RSADPA(NOMRES, 'E',1,'OMEGA2',IORNE,0,JIAD,K8B)
         ZR(JIAD) = ZR(IAD)
C
         CALL RSADPA(  BASE, 'L',1,'MASS_GENE',IOROL,0, IAD,K8B)
         CALL RSADPA(NOMRES, 'E',1,'MASS_GENE',IORNE,0,JIAD,K8B)
         ZR(JIAD) = ZR(IAD)
C
         CALL RSADPA(  BASE, 'L',1,'RIGI_GENE',IOROL,0, IAD,K8B)
         CALL RSADPA(NOMRES, 'E',1,'RIGI_GENE',IORNE,0,JIAD,K8B)
         ZR(JIAD) = ZR(IAD)
C
         CALL RSADPA(  BASE, 'L',1,'TYPE_MODE',IOROL,0, IAD,K8B)
         CALL RSADPA(NOMRES, 'E',1,'TYPE_MODE',IORNE,0,JIAD,K8B)
         ZK16(JIAD) = ZK16(IAD)
 80   CONTINUE
C
C
      CALL JEDETR('&&ORTH99.TRAV1')
      CALL JEDETR('&&ORTH99.TRAV3')
      CALL JEDETR('&&ORTH99.TRAV4')
      CALL JEDETR('&&ORTH99.BASE')
      CALL JEDETR('&&ORTH99.VECT_TEM')
C

 9999 CONTINUE
 
C      CALL JELIBE(NOMRES//'           .REFD')
 
 
      CALL JEDEMA()
      END
