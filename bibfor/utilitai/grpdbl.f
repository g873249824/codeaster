      SUBROUTINE GRPDBL(MAZ,TYPGZ)
      IMPLICIT NONE
      CHARACTER*(*) MAZ,TYPGZ
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 23/05/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE VABHHTS J.PELLET
C ----------------------------------------------------------------------
C  BUT : SUPPRIMER LES DOUBLONS DANS MA.GROUPENO ET MA.GROUPEMA
C ----------------------------------------------------------------------
C       MAZ   : NOM DE LA STRUCTURE DE DONNEES A TESTER
C       TYPGZ : /GROUPEMA / GROUPENO
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 ZK32 ,JEXNUM,JEXNOM
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER IGR,NBGR,IE,NBE,JGROUP,NUE,NBNO,NBMA
      INTEGER JLENT,K,JDIME,NBENT,JGROU2,IBID
      INTEGER IMAX,NELIM,LNEW,JNEW,JE,KK
      CHARACTER*4 KBID ,CLAS
      CHARACTER*8 MA,TYPGR,NOMGR
C -DEB------------------------------------------------------------------

      CALL JEMARQ()


      MA = MAZ
      TYPGR=TYPGZ
      CALL ASSERT(TYPGR.EQ.'GROUPENO'.OR.TYPGR.EQ.'GROUPEMA')

      CALL JEVEUO(MA//'.DIME','L',JDIME)
      NBNO=ZI(JDIME-1+1)
      NBMA=ZI(JDIME-1+3)
      IF (TYPGR.EQ.'GROUPENO') THEN
         NBENT=NBNO
      ELSE
         NBENT=NBMA
      ENDIF


      CALL WKVECT('&&GRPDBL.LENT','V V I',NBENT,JLENT)
      CALL JELIRA(MA//'.'//TYPGR,'NOMUTI',NBGR,KBID)

      CALL JECREC('&&GRPDBL.NEWGROUP','V V I','NO','DISPERSE',
     &            'VARIABLE',NBGR)

      DO 21,IGR = 1,NBGR
        CALL JELIRA(JEXNUM(MA//'.'//TYPGR,IGR),'LONMAX',NBE,KBID)
        CALL JEVEUO(JEXNUM(MA//'.'//TYPGR,IGR),'L',JGROUP)
        CALL JENUNO(JEXNUM(MA//'.'//TYPGR,IGR),NOMGR)
        CALL JECROC(JEXNOM('&&GRPDBL.NEWGROUP',NOMGR))
        IMAX=0
        DO 11,IE = 1,NBE
          NUE = ZI(JGROUP-1+IE)
          ZI(JLENT-1+NUE)=ZI(JLENT-1+NUE)+1
          IMAX=MAX(IMAX,ZI(JLENT-1+NUE))
   11   CONTINUE

        LNEW=NBE
        IF (IMAX.GT.1) THEN
C         -- IL Y A DES DOUBLONS A ELIMINER :
          NELIM=0
          DO 31,K=1,NBENT
             IF (ZI(JLENT-1+K).GT.1) NELIM=NELIM+1
   31     CONTINUE
          CALL ASSERT(NELIM.GT.0)
          LNEW=NBE-NELIM
          CALL ASSERT(LNEW.GT.0)
          CALL WKVECT('&&GRPDBL.LNEW','V V I', LNEW,JNEW)
          JE=0
          DO 34,IE=1,NBE
            NUE = ZI(JGROUP-1+IE)
            KK=ZI(JLENT-1+NUE)
            CALL ASSERT(KK.NE.0)
            IF (KK.EQ.1) THEN
C             -- ENTITE NON DOUBLONNEE :
              JE=JE+1
              CALL ASSERT(JE.GE.1.AND.JE.LE.LNEW)
              ZI(JNEW-1+JE)=NUE
            ELSE IF (KK.GT.1) THEN
C             -- ENTITE DOUBLONNEE VUE LA 1ERE FOIS:
              JE=JE+1
              CALL ASSERT(JE.GE.1.AND.JE.LE.LNEW)
              ZI(JNEW-1+JE)=NUE
              ZI(JLENT-1+NUE)=-1
            ELSE IF (KK.EQ.-1) THEN
C             -- ENTITE DOUBLONNEE DEJA VUE :
            ELSE
               CALL ASSERT(.FALSE.)
            ENDIF
   34     CONTINUE
        ENDIF

        CALL JEECRA(JEXNOM('&&GRPDBL.NEWGROUP',NOMGR),'LONMAX',LNEW,
     &              KBID)
        CALL JEVEUO(JEXNOM('&&GRPDBL.NEWGROUP',NOMGR),'E',JGROU2)

        IF (IMAX.GT.1) THEN
          DO 35,K=1,LNEW
            ZI(JGROU2-1+K)=ZI(JNEW-1+K)
   35     CONTINUE
          CALL JEDETR('&&GRPDBL.LNEW')
        ELSE
          DO 36,K=1,LNEW
            ZI(JGROU2-1+K)=ZI(JGROUP-1+K)
   36     CONTINUE
        ENDIF


C       -- REMISE A ZERO DE .LENT :
        DO 32,K=1,NBENT
           ZI(JLENT-1+K)=0
   32   CONTINUE

   21 CONTINUE

      CALL JEDETR('&&GRPDBL.LENT')

      CALL JELIRA(MA//'.'//TYPGR,'CLAS',IBID,CLAS)
      CALL JEDETR(MA//'.'//TYPGR)
      CALL JEDUPO('&&GRPDBL.NEWGROUP',CLAS, MA//'.'//TYPGR,.FALSE.)
      CALL JEDETR('&&GRPDBL.NEWGROUP')


  999 CONTINUE
      CALL JEDEMA()
      END
