      SUBROUTINE NMDOVM(MODELE,MESMAI,NBMA,CES2,COMCOD,COMP,TXCP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/09/2008   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*24 MODELE,MESMAI
      CHARACTER*19 COMPOR
      CHARACTER*16 TXCP,COMP,COMCOD
C
C PERMET DE VERIFIER SI LES COMPORTEMENTS  
C SONT COMPATIBLES AVEC LES ELEMENTS DU MODELE 
C      
C ----------------------------------------------------------------------
C IN MODELE   : LE MODELE
C IN MESMAI   : LISTE DES MAILLES AFFECTEES 
C IN NBMA     : NOMRE DE CES MAILLES (0 SIGNIFIE : TOUT)
C IN CES2     :  CHAMELEM SIMPLE ISSU DE COMPOR, DEFINIR SUR LES 
C                ELEMENTS QUI CALCULENT FULL_MECA
C IN  COMCOD  : COMPORTMENT PYTHON AFFECTE AUX MAILLES MESMAI
C IN  COMP    : COMPORTMENT LU ACTUELLEMENT AFFECTE AUX MAILLES MESMAI
C IN  TXCP    : TYPE DE CONTRAINTES PLANES : ANALYTIQUE OU DEBORST
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM, JEXATR
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*16 NOTYPE,NOMCOM,TEXTE(2),TYPMOD
      CHARACTER*24 K24BID,LIGREL,MAILMA
      CHARACTER*19 CES1,CES2,CEL1
      CHARACTER*8  NOMA
      CHARACTER*1  TX
      INTEGER      NUMAIL,NUTYEL,NBCOMP,IRETT,IBID,IAD,NUGREL
      INTEGER      IREPE,IDESC,IVALE,ICP,I1D,NBMA,NBMAT,NBMA1
      INTEGER      IMA,ILMAIL,IEL,I,IGREL,JDESC,JMA,IRET
      INTEGER      NBGREL,NBMAGL,NBELEM,NBEL,JCESD,JCESL,JCESV
      LOGICAL      LTEATT      
C      
C      NUMAIL(I,IEL) = ZI(IALIEL-1+ZI(ILLIEL+I-1)+IEL-1)
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C

C a faire : verifier les perf
C SI CPLAN OU 1D ON NE PLANTE PAS MAIS ON PASSE EN DEBORST
      TX='A'

      LIGREL = MODELE(1:8)//'.MODELE    .LIEL'      
      CALL JEVEUO(LIGREL(1:19)//'.REPE','L',IREPE)
      CALL DISMOI('I','NOM_MAILLA',MODELE(1:8),'MODELE',I,NOMA,IRETT)

      CALL JEVEUO(CES2//'.CESD','L',JCESD)
      CALL JEVEUO(CES2//'.CESL','L',JCESL)
      CALL JEVEUO(CES2//'.CESV','L',JCESV)
      NBMAT = ZI(JCESD-1+1)

      IF (NBMA.NE.0) THEN
         CALL JEVEUO(MESMAI,'L',JMA)
         NBMA1=NBMA
      ELSE
         NBMA1=NBMAT
      ENDIF
      
      DO 40,I = 1,NBMA1
         IF (NBMA.NE.0) THEN
            IMA=ZI(JMA-1+I)
         ELSE
            IMA=I
         ENDIF
         CALL CESEXI('C',JCESD,JCESL,IMA,1,1,1,IAD)
         IF (IAD.GT.0) THEN
            NOMCOM = ZK16(JCESV-1+IAD)
            IF (NOMCOM.EQ.' ') THEN
               MAILMA = NOMA(1:8)//'.NOMMAI'
               CALL JENUNO(JEXNUM(MAILMA,IMA),NOMA)
               CALL U2MESG(TX,'COMPOR1_50',1,NOMA,0,0,0,0.D0)
            ENDIF
C           NUMERO DU GREL CONTENANT LA MAILLE IMA
            NUGREL=ZI(IREPE-1+2*(IMA-1)+1)
            CALL JEVEUO(JEXNUM(LIGREL,NUGREL),'L',IGREL)
            CALL JELIRA(JEXNUM(LIGREL,NUGREL),'LONMAX',NBMAGL,K24BID)
            NUTYEL = ZI(IGREL+NBMAGL-1)
            CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',NUTYEL),NOTYPE)
            CALL TEATTR(NOTYPE,'C','TYPMOD',TYPMOD,IRET)
            IF (IRET.NE.0) GOTO 40
            
C           Dans le grel il y a TYPMOD=C_PLAN
C            IF(LTEATT(NOTYPE,'TYPMOD','C_PLAN')) THEN
            IF(TYPMOD(1:6).EQ.'C_PLAN') THEN
               CALL LCTEST(COMCOD,'MODELISATION','C_PLAN',IRETT)
               IF (TXCP.EQ.'DEBORST') THEN
                  IF (IRETT.NE.0) THEN
                     TEXTE(1)='C_PLAN'
                     TEXTE(2)=COMP
                     CALL U2MESG(TX,'COMPOR1_52',2,TEXTE,0,0,0,0.D0)
                  ENDIF
               ELSE
                  IF (IRETT.EQ.0) THEN
                     TEXTE(1)='C_PLAN'
                     TEXTE(2)=COMP
                     CALL U2MESG(TX,'COMPOR1_47',2,TEXTE,0,0,0,0.D0)
                     TXCP='DEBORST'
                  ENDIF
               ENDIF
C           Dans le grel il y a TYPMOD=COMP1D
C            IF(LTEATT(NOTYPE,'TYPMOD','COMP1D')) THEN
            ELSEIF(TYPMOD(1:6).EQ.'COMP1D') THEN
               CALL LCTEST(COMCOD,'MODELISATION','1D',IRETT)
               IF (TXCP.EQ.'DEBORST') THEN
                  IF (IRETT.NE.0) THEN
                     TEXTE(1)='1D'
                     TEXTE(2)=COMP
                     CALL U2MESG(TX,'COMPOR1_53',2,TEXTE,0,0,0,0.D0)
                  ENDIF
               ELSE
                  IF (IRETT.EQ.0) THEN
                     TEXTE(1)='1D'
                     TEXTE(2)=COMP
                     CALL U2MESG(TX,'COMPOR1_48',2,TEXTE,0,0,0,0.D0)
                     TXCP='DEBORST'
                  ENDIF
               ENDIF
C           Dans le grel il y a TYPMOD=COMP3D
            ELSEIF(TYPMOD(1:6).EQ.'COMP3D') THEN
               CALL LCTEST(COMCOD,'MODELISATION','3D',IRETT)
               IF (IRETT.EQ.0) THEN
                  TEXTE(1)='3D'
                  TEXTE(2)=COMP
                  CALL U2MESG(TX,'COMPOR1_49',2,TEXTE,0,0,0,0.D0)
               ENDIF
            ELSE
               CALL LCTEST(COMCOD,'MODELISATION',TYPMOD,IRETT)
               IF (IRETT.EQ.0) THEN
                  TEXTE(1)=TYPMOD
                  TEXTE(2)=COMP
                  CALL U2MESG(TX,'COMPOR1_49',2,TEXTE,0,0,0,0.D0)
               ENDIF
            ENDIF

         ENDIF
 40   CONTINUE
      
      CALL JEDEMA()
C
      END
