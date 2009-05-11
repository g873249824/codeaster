      SUBROUTINE MDALLC (NOMRE0,BASEMO,NBMODE,NBSAUV,
     &                   JDEPL,JVITE,JACCE)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/05/2009   AUTEUR NISTOR I.NISTOR 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     ALLOCATION DES VECTEURS DE SORTIE (DONNEEES COMPLEXES)
C     ------------------------------------------------------------------
C IN  : NOMRE0 : NOM DU CONCEPT RESULTAT
C IN  : BASEMO : NOM DU CONCEPT BASE MODALE
C IN  : NBMODE : NOMBRE DE MODES
C IN  : NBSAUV : NOMBRE DE PAS CALCULE (INITIAL COMPRIS)
C IN : JDEPL  : ADRESSE DE NOMRES.DEPL
C IN : JVITE  : ADRESSE DE NOMRES.VITE
C IN : JACCE  : ADRESSE DE NOMRES.ACCE
C ----------------------------------------------------------------------
      IMPLICIT    NONE
      INTEGER NBMODE,JREDC,JFREQ
      INTEGER NBCHOC,NBSAUV,NBREDE,NBREVI,JDEPL,JVITE,JACCE
      INTEGER IABS,IER,IBID,LVALE,JREFA,LDLIM
      INTEGER JDEP0,JVIT0,JACC0
      CHARACTER*8 BASEMO,NOMRE0,MASGEN,RIGGEN,AMOGEN
      CHARACTER*8 NOMRES,KBID,MATGEN
      CHARACTER*8 METHOD
      CHARACTER*14 NUGENE
      CHARACTER*19 CHAMGE
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      INTEGER IRET,JREFE,JDESC,JREFD
      INTEGER I,JREDN,J1REFE

      CHARACTER*8 NUMGEN,BLANC
C
C     ------------------------------------------------------------------
      CALL JEMARQ()

      NOMRES = NOMRE0
C
      BLANC =  '        '

      NUGENE = NOMRES//'.NUGENE'

         CALL WKVECT(NOMRES//'           .REFD','G V K24',7,JREFD)
         ZK24(JREFD) = BLANC
         ZK24(JREFD+1) = BLANC
         ZK24(JREFD+2) = BLANC
         ZK24(JREFD+3) = BLANC
         ZK24(JREFD+4) = BLANC
         ZK24(JREFD+5) = BASEMO(1:8)
         ZK24(JREFD+6) = BLANC
C ET ON REMPLIT LA SD

C CREATION DE LA NUMEROTATION GENERALISE SUPPORT
      CALL  NUMMO1(NUGENE,BASEMO,NBMODE,'PLEIN')
      CALL  CRNSLV(NUGENE,'LDLT','SANS','G')

      MATGEN = '&&MDALMA'

C CREATION DE LA MATRICE GENERALISE SUPPORT
      CALL WKVECT(MATGEN//'           .REFA','V V K24',11,JREFA)
      ZK24(JREFA-1+11)='MPI_COMPLET'
      ZK24(JREFA-1+1)=BASEMO
      ZK24(JREFA-1+2)=NUGENE
      ZK24(JREFA-1+9) = 'MS'
      ZK24(JREFA-1+10) = 'GENE'

      DO 100 IABS = 1, NBSAUV
        CALL RSEXCH (NOMRES, 'DEPL', IABS, CHAMGE, IER )
        IF     ( IER .EQ. 0   ) THEN
        ELSEIF ( IER .EQ. 100 ) THEN
            CALL VTCREM (CHAMGE, MATGEN, 'G', 'C' )
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
        CALL JEECRA (CHAMGE//'.DESC', 'DOCU', IBID, 'VGEN' )
        CALL JEVEUO (CHAMGE//'.VALE', 'E', LVALE )
        DO 110 IER = 1, NBMODE
              ZC(LVALE+IER-1) = ZC(JDEPL-1+IER+(IABS-1)*NBMODE)
 110    CONTINUE
        CALL RSNOCH (NOMRES, 'DEPL', IABS, ' ' )

        CALL RSEXCH (NOMRES, 'VITE', IABS, CHAMGE, IER )
        IF     ( IER .EQ. 0   ) THEN
        ELSEIF ( IER .EQ. 100 ) THEN
            CALL VTCREM (CHAMGE, MATGEN, 'G', 'C' )
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
        CALL JEECRA (CHAMGE//'.DESC', 'DOCU', IBID, 'VGEN' )
        CALL JEVEUO (CHAMGE//'.VALE', 'E', LVALE )
        DO 120 IER = 1, NBMODE
              ZC(LVALE+IER-1) = ZC(JVITE-1+IER+(IABS-1)*NBMODE)
 120    CONTINUE
        CALL RSNOCH (NOMRES, 'VITE', IABS, ' ' )

        CALL RSEXCH (NOMRES, 'ACCE', IABS, CHAMGE, IER )
        IF     ( IER .EQ. 0   ) THEN
        ELSEIF ( IER .EQ. 100 ) THEN
            CALL VTCREM (CHAMGE, MATGEN, 'G', 'C' )
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
        CALL JEECRA (CHAMGE//'.DESC', 'DOCU', IBID, 'VGEN' )
        CALL JEVEUO (CHAMGE//'.VALE', 'E', LVALE )
        DO 130 IER = 1, NBMODE
              ZC(LVALE+IER-1) = ZC(JACCE-1+IER+(IABS-1)*NBMODE)
 130    CONTINUE
        CALL RSNOCH (NOMRES, 'ACCE', IABS, ' ' )

 100  CONTINUE

      CALL JEDETC (' ',MATGEN,1)

 9999 CONTINUE
      CALL JEDEMA()
      END
