      SUBROUTINE EXLIM1 (LISMAI, NBMAIL, MODELZ, BASEZ, LIGREZ)
      IMPLICIT NONE
      INTEGER            LISMAI(*), NBMAIL
      CHARACTER*(*)      MODELZ, BASEZ, LIGREZ
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 31/01/2005   AUTEUR CIBHHLV L.VIVAN 
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
C IN  : LISMAI : LISTE DES NUMEROS DE MAILLES CONSTITUANT LE
C                LIGREL A CREER
C IN  : NBMAIL : LONGUEUR DE LA LISTE DES MAILLES
C IN  : MODELZ : NOM DU MODELE REFERENCANT LES MAILLES DE LISMAI
C                DES GRELS
C IN  : BASEZ  : BASE SUR-LAQUELLE ON CREE LE LIGREL
C OUT : LIGREZ : LIGREL A CREER
C     ------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       02/11/03 (OB): MODIF. POUR FETI: RAJOUT 'DOCU' POUR 'NOMA'.
C----------------------------------------------------------------------

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32       JEXNOM, JEXNUM, JEXATR
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      CHARACTER*1     BASE,K1BID
      CHARACTER*8     MODELE,NOMA,NOMAIL
      CHARACTER*16    PHENO
      CHARACTER*19    LIGREL,LIGRMO
      CHARACTER*24    CPTLIE
      INTEGER         I,J,IB,IE,LONT,NUMVEC,NUMAIL,IGREL,NBMAM
      INTEGER         LCLIEL,ADLIEL,JREPE,JDNB,JDNM,IADM,JDLI
      INTEGER         JTYP,JNEL,TYPELE,TYPEL1,NBTYEL,ITYPE,NMEL
C     ------------------------------------------------------------------

      CALL JEMARQ()
      
      BASE   = BASEZ
      MODELE = MODELZ
      LIGREL = LIGREZ

C --- MAILLAGE ASSOCIE AU MODELE
C     --------------------------
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IB,NOMA  ,IE)

C --- LIGREL DU MODELE
C     ----------------
      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IB,LIGRMO,IE)
C
      CALL JEVEUO(LIGRMO//'.REPE','L',JREPE)
      CALL JEVEUO(JEXATR(LIGRMO//'.LIEL','LONCUM'),'L',LCLIEL)
      CALL JEVEUO(LIGRMO//'.LIEL','L',ADLIEL)

C --- OBJET NBNO
C     ----------
      CALL WKVECT(LIGREL//'.NBNO',BASE//' V I',1,JDNB)
      ZI(JDNB) = 0

C --- OBJET NOMA
C     ----------
      CALL WKVECT(LIGREL//'.NOMA',BASE//' V K8',1,JDNM)
      ZK8(JDNM) = NOMA
C 
      CALL JELIRA(MODELE(1:8)//'.MODELE    .NOMA','DOCU',IB,PHENO)
      CALL JEECRA(LIGREL//'.NOMA','DOCU',IB,PHENO)      

C --- TYPE D'ELEMENT ET NOMBRE DE MAILLES PAR TYPE
C     --------------------------------------------
      CALL WKVECT ( '&&EXLIM1.TYPE_NOMBRE', 'V V I', 2*NBMAIL, JTYP )
      JNEL = JTYP + NBMAIL

      TYPEL1 = 0
      NBTYEL = 0
      ITYPE = 0
      DO 10 I = 1 , NBMAIL
         NUMAIL = LISMAI(I)
         IGREL = ZI(JREPE+2*(NUMAIL-1))
         IF (IGREL.EQ.0) THEN
           CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMAIL),NOMAIL)
           CALL UTMESS('F','EXLIM1','LA MAILLE : '//NOMAIL//
     &                 ' N''EST PAS AFFECTEE PAR UN ELEMENT FINI.')
         END IF
         IADM = ZI(LCLIEL+IGREL)
         TYPELE = ZI(ADLIEL-1+IADM-1)
         IF ( TYPELE .EQ. TYPEL1 ) THEN
            ZI(JNEL-1+ITYPE) = ZI(JNEL-1+ITYPE) + 1
         ELSE
            NBTYEL = NBTYEL + 1
            ITYPE = NBTYEL
            TYPEL1 = TYPELE
            ZI(JNEL-1+ITYPE) = 1
            ZI(JTYP-1+NBTYEL) = TYPELE
         ENDIF
 10   CONTINUE 
           
      NBMAM = 0
      DO 12 I = 1 , NBTYEL
         NBMAM = MAX ( NBMAM, ZI(JNEL-1+I) )
 12   CONTINUE 

C --- OBJET LIEL
C     ----------
      CPTLIE = LIGREL//'.LIEL'
      LONT = NBTYEL * (NBMAM+1)
      CALL JECREC(CPTLIE,BASE//' V I','NU','CONTIG','VARIABLE',NBTYEL)
      CALL JEECRA(CPTLIE,'LONT',LONT,' ')
      CALL JEVEUO(CPTLIE,'E',JDLI)

C --- STOCKAGE DES GROUPES ELEMENTS DANS LIEL
C     ---------------------------------------
      NUMVEC = 0
      NUMAIL = 0
      DO 20 I = 1 , NBTYEL
         NMEL = ZI(JNEL-1+I)

         CALL JECROC(JEXNUM(CPTLIE,I))
         CALL JEECRA(JEXNUM(CPTLIE,I),'LONMAX',NMEL+1,' ')

         DO 22 J = 1 , NMEL
            NUMVEC = NUMVEC + 1
            NUMAIL = NUMAIL + 1
            ZI(JDLI+NUMVEC-1) = LISMAI(NUMAIL)
 22      CONTINUE 
 
         NUMVEC = NUMVEC + 1
         ZI(JDLI+NUMVEC-1) = ZI(JTYP-1+I)

 20   CONTINUE            
 
      CALL JEDETR ( '&&EXLIM1.TYPE_NOMBRE' )

C     ---  ADAPTATION DE LA TAILLE DES GRELS
C          ---------------------------------
      CALL ADALIG(LIGREL)

C     --- CREATION DE LA CORRESPONDANCE MAILLE --> (IGREL,IM)
C         ---------------------------------------------------
      CALL CORMGI(BASE, LIGREL)

      CALL JEDEMA()
      END
