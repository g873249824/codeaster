      SUBROUTINE POCHOC ( TRANGE, NBBLOC, TDEBUT, TFIN, OFFSET, TREPOS,
     +                    NBCLAS,NOMRES, LOPTIO )
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)      TRANGE, NOMRES
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
C     CALCUL ET IMPRESSION DES STATISTIQUES DE CHOC
C     DEUX OPTIONS PREVUES STATISTIQUES POUR VIBRATIONS USURE
C     ET STATISTIQUES POUR LES IMPACTS SOUS SEISME
C
C ----------------------------------------------------------------------
C     ---- DEBUT DES COMMUNS JEVEUX ------------------------------------
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
C     ---- FIN DES COMMUNS JEVEUX --------------------------------------
      CHARACTER*8   K8B
      CHARACTER*19  NOMK19
      LOGICAL LOPTIO
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
C
C     --- RECUPERATION DES VECTEURS CONTENANT LES RESULTATS ---
      CALL JEMARQ()
      NOMK19='                   '
      NOMK19(1:8)=TRANGE
C
      CALL JEVEUO(NOMK19//'.DESC','L',IDDESC)
      NBCHOC = ZI(IDDESC+2)
C
      CALL JEVEUO(NOMK19//'.INST','L',IDINST)
      CALL JELIRA(NOMK19//'.INST','LONMAX',NBPT,K8B)
      WRITE(6,*) ' NB DE PAS DE TEMPS :',NBPT
      TMAX = ZR(IDINST+NBPT-1)
      TMIN = ZR(IDINST)
      IF (TFIN.GT.TMAX) TFIN = TMAX
      IF (TDEBUT.LT.TMIN) TDEBUT = TMIN
      IF (TDEBUT.GE.TFIN) CALL UTMESS('F','IMPR_STAT_CHOC',
     +                            'INST_INIT PLUS GRAND QUE INST_FIN')
C
      CALL JEVEUO(NOMK19//'.FCHO','L', IDFCHO)
      CALL JEVEUO(NOMK19//'.DLOC','L', IDDLOC)
      CALL JEVEUO(NOMK19//'.VCHO','L', IDVGLI)
      CALL JEVEUO(NOMK19//'.ICHO','L', IDIADH)
      CALL JEVEUO(NOMK19//'.NCHO','L', IDNCHO)
      CALL JEVEUO(NOMK19//'.INTI','L', IDNINT)
      CALL JEVEUO(NOMK19//'.VINT','L', IDVINT)
C
      CALL WKVECT('&&OP0130.WK1','V V R',NBPT,IDWK1)
      CALL WKVECT('&&OP0130.WK2','V V R',NBPT,IDWK2)
      CALL WKVECT('&&OP0130.WK3','V V R',NBPT,IDWK3)
      CALL WKVECT('&&OP0130.IWK4','V V I',NBPT,IDWK4)
C
      IF (LOPTIO) THEN
      CALL STATCH(NBCHOC,NBPT,ZR(IDINST),ZR(IDDLOC),
     +            ZR(IDFCHO),ZR(IDVGLI),ZI(IDIADH),
     +            ZR(IDWK1),ZR(IDWK2),ZR(IDWK3),ZI(IDWK4),
     +            TDEBUT,TFIN,NBBLOC,OFFSET,TREPOS,ZK8(IDNCHO),
     +            ZK8(IDNINT),
     +            NOMRES )
      ELSE
      CALL STATIM(NBCHOC,NBPT,ZR(IDINST),ZR(IDFCHO),
     +            ZR(IDVGLI),ZR(IDVINT),ZR(IDWK1),ZR(IDWK2),ZR(IDWK3),
     +            TDEBUT,TFIN,NBBLOC,OFFSET,TREPOS,NBCLAS,ZK8(IDNCHO),
     +            ZK8(IDNINT),
     +            NOMRES )
      ENDIF
      CALL JEDETR('&&OP0130.WK1')
      CALL JEDETR('&&OP0130.WK2')
      CALL JEDETR('&&OP0130.WK3')
      CALL JEDETR('&&OP0130.IWK4')
C
      CALL JEDEMA()
      END
