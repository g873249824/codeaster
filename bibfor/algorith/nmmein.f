      SUBROUTINE NMMEIN(FISS,NOMA,NNO,NUMNOD,LISCMP,NBNO,
     &             GRO1,GRO2,NDIM,COMPO)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 01/02/2011   AUTEUR MASSIN P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C
      IMPLICIT NONE
      CHARACTER*8  FISS,NOMA
      INTEGER  NNO,NBNO,NDIM
      CHARACTER*24 GRO1,GRO2,NUMNOD,LISCMP
      CHARACTER*8  COMPO     
C
C ----------------------------------------------------------------------
C
C INITIALISATION DU PILOTAGE DDL_IMPO OU LONG_ARC - FORMULATION XFEM
C
C RENVOIE L'ENSEMBLE DES ARETES PILOTEES ET INITIALISE LES COMPOSANTES
C PILOTEES DANS LE CAS DTAN OU DNOR
C
C ----------------------------------------------------------------------
C
C
C IN  FISS   : SD FISSURE
C IN  NOMA   : NOM DU MAILLAGE
C IN NNO     : NOMBRE DE NOEUDS ENTRES PAR L UTILISATEUR
C IN  NUMNOD : LISTE DES NOEUDS ENTREE PAR L UTILISATEUR
C IN/OUT LISCMP : LISTE DES COMPOSANTES PILOTEES
C OUT NBNO   : NOMBRE D ARETES FINALEMENT PILOTEES
C OUT GRO1   : LISTE DES NOEUDS EXTREMITE 1 DES ARETES PILOTEES
C OUT GRO2   : LISTE DES NOEUDS EXTREMITE 2 DES ARETES PILOTEES
C OUT NDIM   : DIMENSION DE L ESPACE
C OUT COMPO  : NOM DE LA COMPOSANTE UTILISATEUR
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32       JEXNOM,JEXATR,JEXNUM
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
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------

      INTEGER ALGLAG,I,NDDL
      CHARACTER*8 NOMAP,NOMO,KBID,K8BID
      CHARACTER*19 NLISCO,NLISEQ,NLISRL,NBASCO
      INTEGER JLICMP,IADRMA
      INTEGER NBARVI,IBID,IRET

C ----------------------------------------------------------------------

      CALL JEVEUO(LISCMP,'E',JLICMP)
      CALL JELIRA(LISCMP,'LONMAX',NDDL,K8BID)      
      CALL GETVID(' ','MODELE',1,1,1,NOMO,IBID)
      CALL JEVEUO(NOMO(1:8)//'.MODELE    .LGRF','L',IADRMA)
      NOMAP  = ZK8(IADRMA)
      CALL DISMOI('F','DIM_GEOM',NOMAP,'MAILLAGE',NDIM,KBID,IRET)

      NLISEQ = '&&NMMEIN.LISEQ'
      NLISRL = '&&NMMEIN.LISRL'
      NLISCO = '&&NMMEIN.LISCO'
      NBASCO = '&&NMMEIN.BASCO'
      ALGLAG = 2     
      CALL XLAGSP(NOMA,NOMO,FISS,ALGLAG,NDIM,
     &            NLISEQ,NLISRL,NLISCO,NBASCO)


      CALL JELIRA(NLISEQ,'LONMAX',NBARVI,K8BID)
      NBARVI=NBARVI/2
      CALL NMARET(NBARVI,NNO,NDIM,NLISEQ,NBNO,NUMNOD,
     &            GRO1,GRO2)
      DO 1 I=1,NDDL
         COMPO = ZK8(JLICMP-1+I)
         IF(COMPO.EQ.'DX') ZK8(JLICMP-1+I)='H1X'
         IF(COMPO.EQ.'DY') ZK8(JLICMP-1+I)='H1Y'
         IF(COMPO.EQ.'DZ') ZK8(JLICMP-1+I)='H1Z'            
         IF(COMPO(1:4).EQ.'DTAN'.OR.COMPO.EQ.'DNOR') THEN
            CALL JEDETR(LISCMP)
            CALL WKVECT(LISCMP,'V V K8',NDIM,JLICMP)
            ZK8(JLICMP)='H1X'
            ZK8(JLICMP+1)='H1Y'
            IF(NDIM.EQ.3) ZK8(JLICMP+2)='H1Z'
            GOTO 2         
         ENDIF  
1     CONTINUE
2     CONTINUE                
      CALL JEDETR(NLISEQ)
      CALL JEDETR(NLISRL)
      CALL JEDETR(NLISCO)
      CALL JEDETR(NBASCO)
      CALL JEDETR('&&NMMEIN.CONNECTANT')
      CALL JEDETR('&&NMMEIN.CONNECTES')
      END
