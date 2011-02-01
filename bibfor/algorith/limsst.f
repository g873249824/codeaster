      SUBROUTINE LIMSST (NOMCMD)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/01/2011   AUTEUR GREFFET N.GREFFET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
C
C***********************************************************************
C  C. VARE     DATE 31/10/94
C-----------------------------------------------------------------------
C
C  BUT : VERIFIER LES DONNEES UTILISATEUR EN FONCTION DES POSSIBILITES
C        DU CALCUL TRANSITOIRE PAR SOUS-STRUCTURATION
C
C-----------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER       NBCHOC,NBREDE,NBREVI
      CHARACTER*24 VALK(2)
      CHARACTER*16  NOMCMD,METHOD
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
      CALL GETVTX(' ','METHODE' ,0,1,1,METHOD,N1)
      CALL GETFAC('ETAT_INIT',N2)
      CALL GETVR8(' ','AMOR_REDUIT',0,1,0,RBID,NAMOR)
      CALL GETFAC('CHOC',NBCHOC)
      CALL GETFAC('RELA_EFFO_DEPL',NBREDE)
      CALL GETFAC('RELA_EFFO_VITE',NBREVI)
C
      IF (METHOD.NE.'EULER' .AND. METHOD(1:5).NE.'ADAPT') THEN
        VALK (1) = METHOD
        VALK (2) = 'EULER ET ADAPT_...'
        CALL U2MESG('F', 'ALGORITH13_29',2,VALK,0,0,0,0.D0)
      ENDIF
C
      IF (N2.NE.0) THEN
        CALL U2MESG('F', 'ALGORITH13_30',0,' ',0,0,0,0.D0)
      ENDIF
C
      IF (NBCHOC.NE.0) THEN
        CALL U2MESG('F', 'ALGORITH13_31',0,' ',0,0,0,0.D0)
      ENDIF
C
      IF (NBREDE.NE.0) THEN
        CALL U2MESG('F', 'ALGORITH13_32',0,' ',0,0,0,0.D0)
      ENDIF
C
      IF (NBREVI.NE.0) THEN
        CALL U2MESG('F', 'ALGORITH13_33',0,' ',0,0,0,0.D0)
      ENDIF
C
      IF (NAMOR.NE.0) THEN
        CALL U2MESG('F', 'ALGORITH13_34',0,' ',0,0,0,0.D0)
      ENDIF
C
      END
