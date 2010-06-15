      SUBROUTINE CALIR3(MO,NBMA1,LIMA1,NBNO2,LINO2,GEOM2,CORRE1,CORRE2,
     &                  JLISV1,IOCC)
      IMPLICIT NONE
      CHARACTER*8 MO
      CHARACTER*16 CORRE1,CORRE2
      CHARACTER*24 GEOM2
      INTEGER NBMA1,LIMA1(NBMA1)
      INTEGER NBNO2,LINO2(NBNO2),JLISV1,IOCC
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/04/2010   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PELLET
C BUT : CALCULER LES SD CORRE1 ET COORE2 UTILISEES POUR :
C       LIAISON_MAIL + TYPE_RACCORD='COQUE_MASSIF'
C ======================================================================
C     ----------- COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNOM,JEXNUM
C---------------- FIN COMMUNS NORMALISES  JEVEUX  ----------------------

      REAL*8 RBID,EPAIS
      INTEGER INO2,NUNO2,JGEOM2,K,NCMP,JCNSD,JCNSV,JCNSL,IBID
      CHARACTER*19 CHNORM,CSNORM
C ----------------------------------------------------------------------

      CALL JEMARQ()
      CALL JEVEUO(GEOM2,'E',JGEOM2)

      CALL GETVID('LIAISON_MAIL','CHAM_NORMALE',IOCC,1,1,CHNORM,IBID)
      CALL GETVR8('LIAISON_MAIL','EPAIS',IOCC,1,1,EPAIS,IBID)

      CSNORM='&&CALIR3.CSNORM'
      CALL CNOCNS(CHNORM,'V',CSNORM)
      CALL JEVEUO(CSNORM//'.CNSD','L',JCNSD)
      CALL JEVEUO(CSNORM//'.CNSL','L',JCNSL)
      CALL JEVEUO(CSNORM//'.CNSV','L',JCNSV)
      NCMP=ZI(JCNSD-1+2)
      CALL ASSERT(NCMP.EQ.3)
      CALL ASSERT(NCMP.EQ.3)


C     -- ON REMPLIT L'OBJET &&CALIRC.LISV1 :
C     -------------------------------------------------
      DO 20,INO2=1,NBNO2
        NUNO2=LINO2(INO2)
        DO 10,K=1,3
          CALL ASSERT(ZL(JCNSL-1+3*(NUNO2-1)+K))
          ZR(JLISV1-1+3*(NUNO2-1)+K)=ZR(JCNSV-1+3*(NUNO2-1)+K)*EPAIS
   10   CONTINUE
   20 CONTINUE


C     -- ON MODIFIE GEOM2 (+H/2) POUR OBTENIR CORRE1 :
C     -------------------------------------------------
      DO 40,INO2=1,NBNO2
        NUNO2=LINO2(INO2)
        DO 30,K=1,3
          ZR(JGEOM2-1+(NUNO2-1)*3+K)=ZR(JGEOM2-1+(NUNO2-1)*3+K)+
     &                               ZR(JLISV1-1+3*(NUNO2-1)+K)/2.D0
   30   CONTINUE
   40 CONTINUE
      CALL PJ3DCO('PARTIE',MO,MO,NBMA1,LIMA1,NBNO2,LINO2,' ',GEOM2,
     &            CORRE1,.FALSE.,RBID)


C     -- ON MODIFIE GEOM2 (-H/2) POUR OBTENIR CORRE2 :
C     -------------------------------------------------
      DO 60,INO2=1,NBNO2
        NUNO2=LINO2(INO2)
        DO 50,K=1,3
          ZR(JGEOM2-1+(NUNO2-1)*3+K)=ZR(JGEOM2-1+(NUNO2-1)*3+K)-
     &                               ZR(JLISV1-1+3*(NUNO2-1)+K)
   50   CONTINUE
   60 CONTINUE
      CALL PJ3DCO('PARTIE',MO,MO,NBMA1,LIMA1,NBNO2,LINO2,' ',GEOM2,
     &            CORRE2,.FALSE.,RBID)

C     -- ON RETABLIT GEOM2 :
C     -------------------------------------------------
      DO 80,INO2=1,NBNO2
        NUNO2=LINO2(INO2)
        DO 70,K=1,3
          ZR(JGEOM2-1+(NUNO2-1)*3+K)=ZR(JGEOM2-1+(NUNO2-1)*3+K)+
     &                               ZR(JLISV1-1+3*(NUNO2-1)+K)/2.D0
   70   CONTINUE
   80 CONTINUE


      CALL DETRSD('CHAMP',CSNORM)
      CALL JEDEMA()
      END
