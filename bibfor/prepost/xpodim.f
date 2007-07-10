      SUBROUTINE XPODIM(MALINI,MAILC,MAILX,NSETOT,NNNTOT,NCOTOT,LISTNO,
     &                  CNS1,CNS2,CES1,CES2,CEL2,CESVI1,CESVI2,CELVI2,
     &                  IOR,RESUCO,NBNOC,NBMAC,
     &                  MAXFEM)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 10/07/2007   AUTEUR MARKOVIC D.MARKOVIC 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT

      IMPLICIT NONE

      INTEGER       NSETOT,NNNTOT,NCOTOT,NBNOC,IOR
      CHARACTER*8   MAXFEM,MALINI,RESUCO
      CHARACTER*19  CNS1,CNS2,CES1,CES2,CEL2,CESVI1,CESVI2,CELVI2
      CHARACTER*24  MAILX,MAILC,LISTNO

C
C   DIMENTIONNEMENT DES OBJETS DU NOUVEAU MAILLAGE MAXFEM
C                ET DES NOUVEAUX CHAMPS RESULTAT
C
C   IN
C       MALINI : MAILLAGE SAIN
C       MAILC  : LISTE DES NUMEROS DES MAILLES NON SOUS-DECOUPEES
C       MAILX  : LISTE DES NUMEROS DES MAILLES SOUS-DECOUPEES
C       NSETOT : NOMBRE TOTAL DE SOUS-ELEMENT
C       NNNTOT : NOMBRE TOTAL DE NOUVEAUX NOEUDS
C       NCOTOT : LONGUEUR DE LA CONNECTIVITE DES NOUVEAUX NOEUDS
C       CNS1   : CHAMP_NO_S DU DEPLACEMENT EN ENTREE
C       CES1   : CHAMP_ELEM_S DE CONTRAINTES EN ENTREE
C       MAXFEM : MAILLAGE FISSURE (SI POST_CHAMP_XFEM)
C       IOR    : POSITION DU NUMERO D'ORDRE (SI POST_CHAMP_XFEM)
C       RESUCO : NOM DU CONCEPT RESULTAT DONT ON EXTRAIT LES CHAMPS

C   OUT
C       MAXFEM : MAILLAGE FISSURE (SI POST_MAIL_XFEM)
C       CNS2   : CHAMP_NO_S DU DEPLACEMENT EN SORTIE
C       CES2   : CHAMP_ELEM_S DE CONTRAINTES EN SORTIE
C       CEL2   : CHAMP_ELEM DE CONTRAINTES EN SORTIE
C       NBNOC  : NOMBRE DE NOEUDS CLASSIQUES DU MAILLAGE FISSURE
C       NBMAC  : NOMBRE DE MAILLES CLASSIQUES DU MAILLAGE FISSURE
C       LISTNO : LISTE DES NUMEROS DES NOEUDS CLASSIQUES


C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
      CHARACTER*32 JEXNOM,JEXNUM,JEXATR
C---------------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------

      INTEGER       IER,NBMAC,NBMA2,NBNO,NBNO2,IRET,JDIME,IGEOMR,NBID
      INTEGER       IADESC,IBID,IAREFE,IACOO2,JTYPM2,JTRAV,JNO,JMAC
      INTEGER       NDIM,JORD,IORD,I,IFM,NIV,NBMA,NMAXSP,NMAXCM
      INTEGER       JCNSK1,JCNSD1,JCNSC1,JCVID1,JNBPT,JCESD2
      INTEGER       JCNSK2,JCNSD2,JCNSC2,JCNSV2,JCNSL2
      CHARACTER*1   KBID
      CHARACTER*4   NOMCHA
      CHARACTER*8   K8B,LDEP(3),MODVIS
      CHARACTER*16  K16B,NOMCMD,NOMCH1
      CHARACTER*19  COORD2,LIGREL,CHN1,CHSIG1
      CHARACTER*24  ORDR
      DATA          NOMCHA / 'DEPL' /
      DATA          LDEP/ 'DX','DY','DZ'/
      
      
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

C     NOM DE LA COMMANDE (POST_MAIL_XFEM OU POST_CHAM_XFEM)
      CALL GETRES(K8B,K16B,NOMCMD)

C     NOMBRE DE MAILLES CLASSIQUES
      CALL JEEXIN(MAILC,IER)
      IF (IER.EQ.0) THEN
        NBMAC = 0
        NBNOC = 0
      ELSE
        CALL JEVEUO(MAILC,'L',JMAC)
        CALL JELIRA(MAILC,'LONMAX',NBMAC,K8B)
C       RECHERCHE DE LA LISTE DE NOEUDS SOUS-JACENTE � MAILC
        CALL DISMOI('F','NB_NO_MAILLA',MALINI,'MAILLAGE',NBNO,K8B,IRET)
        CALL WKVECT('&&XPODIM.LITRAV','V V I',NBNO,JTRAV)
        CALL WKVECT(LISTNO,'V V I',NBNO,JNO)
        CALL GMGNRE(MALINI,NBNO,ZI(JTRAV),ZI(JMAC),NBMAC,ZI(JNO),
     &                                                   NBNOC,'TOUS')
        CALL JEDETR('&&XPODIM.LITRAV')
      ENDIF

C     NOMBRE DE MAILLES DU NOUVEAU MAILLAGE : NBMA2
      NBMA2 = NBMAC + NSETOT

C     NOMBRE DE NOEUDS DU NOUVEAU MAILLAGE : NBNO2
      NBNO2 = NBNOC + NNNTOT

      IF (NOMCMD.EQ.'POST_MAIL_XFEM') THEN

C       ---------------------------------------------------------------
C                   TRAITEMENT POUR POST_MAIL_XFEM
C       ---------------------------------------------------------------

C       CHANGEMENT DU .DIME
C       .DIME(1) : NOMBRE DE NOEUDS PHYSIQUES DU MAILLAGE
C       .DIME(3) : NOMBRE DE MAILLES DU MAILLAGE
        CALL JEDUP1(MALINI//'.DIME','G',MAXFEM//'.DIME')
        CALL JEVEUO(MAXFEM//'.DIME','E',JDIME)
        ZI(JDIME-1+1) = NBNO2
        ZI(JDIME-1+3) = NBMA2
        CALL ASSERT(ZI(JDIME-1+2).EQ.0)
        CALL ASSERT(ZI(JDIME-1+4).EQ.0)
        CALL ASSERT(ZI(JDIME-1+5).EQ.0)

C       CREATION DES .NOMMAI, .NOMNOE, .TYPMAIL, .COORDO  .CONNEX
C       DU MAILLAGE 2
        CALL JECREO(MAXFEM//'.NOMMAI','G N K8')
        CALL JEECRA(MAXFEM//'.NOMMAI','NOMMAX',NBMA2,K8B)

        CALL JECREO(MAXFEM//'.NOMNOE','G N K8')
        CALL JEECRA(MAXFEM//'.NOMNOE','NOMMAX',NBNO2,K8B)

        COORD2= MAXFEM//'.COORDO'
        CALL JENONU(JEXNOM('&CATA.GD.NOMGD','GEOM_R'),IGEOMR)
        CALL WKVECT(COORD2//'.DESC','G V I',3,IADESC)
        CALL JEECRA(COORD2//'.DESC','DOCU',IBID,'CHNO')
        ZI (IADESC-1+1)= IGEOMR
C       -- TOUJOURS 3 COMPOSANTES X, Y ET Z
        ZI (IADESC-1+2)= -3
C       -- 14 = 2**1 + 2**2 + 2**3
        ZI (IADESC-1+3)= 14
        CALL WKVECT(COORD2//'.REFE','G V K24',2,IAREFE)
        ZK24(IAREFE-1+1)= MAXFEM
        CALL WKVECT(COORD2//'.VALE','G V R',3*NBNO2,IACOO2)

        CALL WKVECT(MAXFEM//'.TYPMAIL','G V I',NBMA2,JTYPM2)

        CALL JECREC(MAXFEM//'.CONNEX','G V I','NU'
     &                           ,'CONTIG','VARIABLE',NBMA2)
        CALL JEECRA(MAXFEM//'.CONNEX','LONT',NCOTOT,K8B)

C       .NOMGNO
C        CALL JEDUP1(MALINI//'.NOMGNO','G',MAXFEM//'.NOMGNO')
C        CALL JEDUP1(MALINI//'.GROUPENO','G',MAXFEM//'.GROUPENO')

        IF (NIV.GT.1) THEN
          WRITE(IFM,*)'CREATION .NOMAI DE LONGUEUR ',NBMA2
          WRITE(IFM,*)'CREATION .TYPMAIL DE LONGUEUR ',NBMA2
          WRITE(IFM,*)'CREATION .NOMNOE DE LONGUEUR ',NBNO2
          WRITE(IFM,*)'CREATION .COORDO.VALE DE LONGUEUR ',3*NBNO2
          WRITE(IFM,*)'CREATION .CONNEX DE LONGUEUR ',NCOTOT
        ENDIF

      ELSEIF (NOMCMD.EQ.'POST_CHAM_XFEM') THEN

C       ---------------------------------------------------------------
C                   TRAITEMENT POUR POST_CHAM_XFEM
C       ---------------------------------------------------------------

        CALL DISMOI('F','DIM_GEOM',MALINI,'MAILLAGE',NDIM,K8B,IER)
        CALL DISMOI('F','NB_NO_MAILLA',MAXFEM,'MAILLAGE',NBID,K8B,IER)
        CALL ASSERT(NBNO2.EQ.NBID)

        CHN1   ='&&XPODIM.CHN1'
C
C       EXTRACTION DES DEPLACEMENTS : CNS1
        ORDR=RESUCO//'           .ORDR'
        CALL JEVEUO(ORDR,'L',JORD)
        IORD=ZI(JORD-1+IOR)
        CALL RSEXCH(RESUCO,NOMCHA,IORD,CHN1,IER)
        CALL CNOCNS(CHN1,'V',CNS1)
        CALL JEVEUO(CNS1//'.CNSK','L',JCNSK1)

C       CREATION D'UN CHAMP SIMPLE : CNS2
        CALL CNSCRE(MAXFEM,'DEPL_R',NDIM,LDEP,'V',CNS2)
        CALL JEVEUO(CNS2//'.CNSK','E',JCNSK2)
        CALL JEVEUO(CNS2//'.CNSD','E',JCNSD2)
        CALL JEVEUO(CNS2//'.CNSC','E',JCNSC2)

C       REMPLISSAGE DES DIFFERENTS OBJETS DU CNS2
        ZK8(JCNSK2-1+1)=MAXFEM
        ZK8(JCNSK2-1+2)=ZK8(JCNSK1-1+2)

        ZI(JCNSD2-1+1)=NBNO2
        ZI(JCNSD2-1+2)=NDIM

        DO 20 I=1,NDIM
           ZK8(JCNSC2-1+I)=LDEP(I)
 20     CONTINUE


C       CONTRAINTES
        NOMCH1='SIEF_ELGA'
        CHSIG1 = '&&XPODIM.CHE1'
        CALL RSEXCH(RESUCO,NOMCH1,IORD,CHSIG1,IER)
        CALL CELCES(CHSIG1,'V',CES1)

C       CREATION D'UN CHAMP SIMPLE
        CALL GETVID(' ','MODELE_VISU',0,1,1,MODVIS,IRET)
        LIGREL = MODVIS//'.MODELE'
        CALL ALCHML(LIGREL,'FULL_MECA','PCONTMR','V',CEL2,IRET,' ')
        CALL CELCES(CEL2,'V',CES2)

C       VARIABLES INTERNES
        NOMCH1='VARI_ELGA'
        CHSIG1 = '&&XPODIM.CHE1'
        CALL RSEXCH(RESUCO,NOMCH1,IORD,CHSIG1,IER)
        
        IF(IER .EQ. 0) THEN
          CALL CELCES(CHSIG1,'V',CESVI1)

C         TROUVER LES VALEURS MAJORANTES DU NOMBRE DE POINTS DE GAUSS,
C         NOMBRE DES SOUS-POINTS ET NOMBRE DE COMPOSANTES        

          CALL JEVEUO(CESVI1//'.CESD','L',JCVID1)
          CALL JEVEUO(CES2//'.CESD','L',JCESD2)

          NMAXSP = ZI(JCVID1-1 +4)
          NMAXCM = ZI(JCVID1-1 +5)
        
          CALL WKVECT('&&XPODIM.NBPT','V V I',NBMA2,JNBPT)
          DO 10,I = 1,NBMA2
            ZI(JNBPT-1+I) = ZI(JCESD2-1+5 + 4*(I-1) + 1)
   10     CONTINUE

          CALL CESCRE('V',CESVI2,'ELGA',MAXFEM,'VARI_R',-NMAXCM,
     &           ' ',ZI(JNBPT),-NMAXSP,-NMAXCM)
        ENDIF         

      ENDIF

      CALL JEDETR('&&XPODIM.NBPT')
      CALL JEDEMA()
      END
