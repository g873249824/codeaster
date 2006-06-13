      SUBROUTINE INCLIS (NOMRES,SSTA,SSTB,INTFA,INTFB,FMLIA,FPLIAN,
     &                   FPLIBN,FPLIAO,FPLIBO,IADA,IADB,NUMLIS,MATPRJ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/08/2004   AUTEUR NICOLAS O.NICOLAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C***********************************************************************
C  O. NICOLAS     DATE 01/08/04
C-----------------------------------------------------------------------
C  BUT : < CALCUL DES LIAISONS CAS INCOMPATIBLE>
C
C  CALCULER LES NOUVELLES MATRICES DE LIAISON EN TENANT COMPTE DE
C  L'ORIENTATION DES SOUS-STRUCTURES ET DES INCOMPATIBILITES
C  ON DETERMINE LES MATRICES DE LIAISON, LES DIMENSIONS DE CES MATRICES
C  ET LE PRONO ASSOCIE
C
C-----------------------------------------------------------------------
C
C NOMRES  /I/ : NOM K8 DU MODELE GENERALISE
C SSTA    /I/ : NOM K8 DE LA SOUS-STRUCTURE MAITRE
C SSTB    /I/ : NOM K8 DE LA SOUS-STRUCTURE ESCLAVE
C INTFA   /I/ : NOM K8 DE L'INTERFACE DE SSTA
C INTFB   /I/ : NOM K8 DE L'INTERFACE DE SSTB
C FPLIAO /I/ : FAMILLE DES PROFNO MATRICES DE LIAISON ORIENTEES SSTA
C FPLIAN /I/ : FAMILLE DES PROFNO MATRICES DE LIAISON NON ORIENTEES SSTA
C FPLIBO /I/ : FAMILLE DES PROFNO MATRICES DE LIAISON ORIENTEES SSTB
C FPLIBN /I/ : FAMILLE DES PROFNO MATRICES DE LIAISON NON ORIENTEES SSTB
C IADA   /I/ : VECTEUR DES CARACTERISTIQUES LIAISON SSTA
C IADB   /I/ : VECTEUR DES CARACTERISTIQUES LIAISON SSTB
C NUMLIS /I/ : NUMERO INTERFACE COURANTE
C MATPRJ /I/ : NOM K8 DE LA MATRICE D'OBSERVATION INTERFACE
C               MAITRE/ESCLAVE
C FMLIA   /I/ : FAMILLE DES MATRICES DE LIAISON
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
      CHARACTER*32  JEXNOM,JEXNUM
C
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      CHARACTER*1    K1BID
      CHARACTER*8    K8BID,NOMRES,MATPRJ,SSTA,SSTB,INTFA,INTFB,NOMG
      CHARACTER*24   FMLIA,TOTO,
     &               FPLIAO,FPLIBO,FPLIAN,FPLIBN,INTA,INTB,MAILMA
      INTEGER        IBID,IADA(3),IADB(3),NUMLIS,ZIT(3),NBEC,IERD,
     &               NBNOEA,NBNOEB,NBCMPM,
     &               K,M1,N1,M2,N2,
     &               LLPLIA,LLPLIB,ICOMPA,ICOMPB,LDMAT,LDMAT2,
     &               IADOA,IADOB
      PARAMETER      (NBCMPM=10)
      INTEGER        IDECOA(NBCMPM),IDECOB(NBCMPM),ITEMCM
      REAL*8         RBID,UN,MOINS1
C
C-----------------------------------------------------------------------
      DATA UN,MOINS1 /1.0D+00,-1.0D+00/
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
C 
      TOTO='TATA'
      NOMG = 'DEPL_R'
      CALL DISMOI('F','NB_EC',NOMG,'GRANDEUR',NBEC,K8BID,IERD)
      IF (NBEC.GT.10) THEN
         CALL UTMESS('F','ROTLIS',
     +                   'LE DESCRIPTEUR_GRANDEUR DES DEPLACEMENTS'//
     +                    ' NE TIENT PAS SUR DIX ENTIERS CODES')
      ENDIF

      CALL JEVEUO(MATPRJ,'L',ITEMCM)
      
C Calcul de la matrice orientee de la structure esclave 
      IF (IADB(3).LT.IADA(3)) THEN
        CALL ROTLIS(NOMRES,FMLIA,IADB,FPLIBN,FPLIBO,NUMLIS,SSTB,
     &              INTFB,UN)
      ENDIF
C Calcul de la matrice orientee de la structure maitre        
      ZIT(1)=IADA(1)
      ZIT(2)=IADA(2)
      ZIT(3)=1
      CALL JECREC(TOTO,'V V R','NU','DISPERSE','VARIABLE',1)
      
      CALL ROTLIS(NOMRES,TOTO,ZIT,FPLIAN,FPLIAO,NUMLIS,
     &            SSTA,INTFA,MOINS1)
      CALL JECROC(JEXNUM(FMLIA,IADA(3)))
      CALL JEECRA(JEXNUM(FMLIA,IADA(3)),'LONMAX',
     &            IADB(1)*IADA(2),' ')
      CALL JEVEUO(JEXNUM(FMLIA,IADA(3)),'E',LDMAT)
      CALL JEVEUO(JEXNUM(TOTO,1),'L',LDMAT2)

C Recuperation des donnees composantes      
      CALL JEVEUO(JEXNUM(FPLIAO,NUMLIS),'L',LLPLIA)
      CALL JELIRA(JEXNUM(FPLIAO,NUMLIS),'LONMAX',NBNOEA,K8BID)
      NBNOEA=NBNOEA/(1+NBEC)
      CALL JEVEUO(JEXNUM(FPLIBO,NUMLIS),'L',LLPLIB)
      CALL JELIRA(JEXNUM(FPLIBO,NUMLIS),'LONMAX',NBNOEB,K8BID)
      NBNOEB=NBNOEB/(1+NBEC)


C boucle sur nombre de mode de la structure maitre 
      DO 1 K=1,IADA(2)
C boucle sur nombre de noeuds d'interface de la structure esclave 
        DO 2 M1=1,NBNOEB
          IADOB=ZI(LLPLIB+(M1-1)*(1+NBEC))
          CALL ISDECO(ZI(LLPLIB+(M1-1)*(1+NBEC)+1),IDECOB,
     &                NBCMPM)
          ICOMPB=IADOB-1
C boucle sur nombre de composante de la structure esclave 
         DO 3 N1=1,NBCMPM
            IF(IDECOB(N1).GT.0) THEN
C boucle sur nombre de noeuds d'interface de la structure maitre 
              ICOMPB=ICOMPB+1
              RBID=0.D0
              DO 4 M2=1,NBNOEA
                IADOA=ZI(LLPLIA+(M2-1)*(1+NBEC))
                CALL ISDECO(ZI(LLPLIA+(M2-1)*(1+NBEC)+1),
     &                      IDECOA,NBCMPM)
C boucle sur nombre de composante de la structure maitre
                ICOMPA=IADOA-1
                DO 5 N2=1,NBCMPM
                  IF ((IDECOA(N2).GT.0).AND.(N1.EQ.N2)) THEN
                    ICOMPA=ICOMPA+N2
                    RBID=RBID+
     &                   ZR(ITEMCM+(ICOMPB-1)*IADA(1)+ICOMPA-1)* 
     &                   ZR(LDMAT2+(K-1)*IADA(1)+ICOMPA-1)
                  ENDIF
 5            CONTINUE
 4          CONTINUE
            ZR(LDMAT+(K-1)*IADB(1)+ICOMPB-1)=RBID
            ENDIF
 3        CONTINUE
 2      CONTINUE
 1    CONTINUE
C On corrige in fine la taille de la nouvelle matrice de liaison
      IADA(1)=IADB(1)
      CALL JEDETR(TOTO)
      
      IF (IADB(3).GT.IADA(3)) THEN
        CALL ROTLIS(NOMRES,FMLIA,IADB,FPLIBN,FPLIBO,NUMLIS,SSTB,
     &              INTFB,UN)
      ENDIF          


      CALL JEDEMA()
      END
