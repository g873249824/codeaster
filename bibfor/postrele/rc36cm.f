      SUBROUTINE RC36CM ( IOCC, ETAT, NBMA, LISTMA, NBCHAR, 
     +                    LICHAR, CHMOME )
      IMPLICIT   NONE
      INTEGER             IOCC, NBMA, LISTMA(*), NBCHAR, LICHAR(*)
      CHARACTER*1         ETAT
      CHARACTER*24        CHMOME
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 03/04/2007   AUTEUR VIVAN L.VIVAN 
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
C     ------------------------------------------------------------------
C
C     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
C     CALCUL DU TORSEUR PAR SOMMATION ALGEBRIQUE DES TORSEURS 
C     CORRESPONDANT AUX DIFFERENTS CAS DE CHARGE DE LA SITUATION
C
C IN  : IOCC   : NUMERO D'OCCURRENCE DE SITUATION
C IN  : ETAT   : ETAT STABILISE A OU B POUR LE MESSAGE D'ERREUR
C IN  : NBMA   : NOMBRE DE MAILLES D'ANALYSE
C IN  : LISTMA : LISTE DES MAILLES D'ANALYSE
C IN  : NBCHAR : NOMBRE DE CAS DE CHARGE POUR UN ETAT STABILISE 
C IN  : LICHAR : LISTE DES CAS DE CHARGE POUR UN ETAT STABILISE 
C OUT : CHNOME : TORSEUR RESULTAT 
C     ------------------------------------------------------------------
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
      INTEGER      JNUME, JCHAM, NBRESU, NBCMP, ICHA, IR, JTYPE, 
     +             JLICH, JLICM, JLICR
      INTEGER      VALI(2)
      LOGICAL      SEISME, AUTRE
      CHARACTER*8  K8B, NOCMP(3), TYPE
      CHARACTER*24 CHAMS0
      COMPLEX*16   CBID
C DEB ------------------------------------------------------------------
      CALL JEMARQ()
C
      CALL JEVEUO ( '&&RC3600.NUME_CHAR', 'L', JNUME )
      CALL JEVEUO ( '&&RC3600.CHAMP'    , 'L', JCHAM )
      CALL JELIRA ( '&&RC3600.NUME_CHAR', 'LONMAX', NBRESU, K8B )
      CALL JEVEUO ( '&&RC3600.TYPE_CHAR', 'L', JTYPE )
C
      NBCMP = 3
      NOCMP(1) = 'MT'
      NOCMP(2) = 'MFY'
      NOCMP(3) = 'MFZ'
C
      SEISME = .FALSE.
      AUTRE  = .FALSE.      
C
      CALL WKVECT ( '&&RC36CM.LICH', 'V V K24',NBCHAR, JLICH )
      CALL WKVECT ( '&&RC36CM.LICM', 'V V L'  ,NBCHAR, JLICM )
      CALL WKVECT ( '&&RC36CM.LICR', 'V V R'  ,NBCHAR, JLICR )
C
      DO 110, ICHA = 1, NBCHAR, 1
         DO 112, IR = 1, NBRESU, 1
            IF ( LICHAR(ICHA).EQ.ZI(JNUME+IR-1) ) GOTO 114
 112     CONTINUE
         VALI (1) = IOCC
         VALI (2) = LICHAR(ICHA)
         CALL U2MESI ('F', 'POSTRCCM_28', 2, VALI )
 114     CONTINUE
         TYPE = ZK8(JTYPE+IR-1)
         IF ( TYPE(1:6) .EQ. 'SEISME' ) THEN
            SEISME = .TRUE.
         ELSE
            AUTRE = .TRUE.
         ENDIF
         ZK24(JLICH+ICHA-1) = ZK24(JCHAM+IR-1)
           ZL(JLICM+ICHA-1) = .TRUE.
           ZR(JLICR+ICHA-1) = 1.D0
 110  CONTINUE
C
      IF ( SEISME .AND. AUTRE ) THEN
         CALL U2MESI ('F', 'POSTRCCM_29', 1, IOCC )
      ENDIF
C
      IF ( NBCHAR .EQ. 1 ) THEN
         CHAMS0 = ZK24(JLICH)
         CALL CESRED (CHAMS0, NBMA,LISTMA, NBCMP,NOCMP, 'V', CHMOME)
      ELSE
C
        CHAMS0='&&RC36CM.CHAMS0'
        IF ( AUTRE ) THEN
         CALL CESFUS (NBCHAR,ZK24(JLICH),ZL(JLICM),ZR(JLICR),CBID,
     &                .FALSE.,'V',CHAMS0)
        ELSE
         CALL CESQUA (NBCHAR,ZK24(JLICH),ZL(JLICM),'V',CHAMS0)
        ENDIF
        CALL CESRED (CHAMS0, NBMA,LISTMA, NBCMP,NOCMP, 'V', CHMOME)
        CALL DETRSD ( 'CHAM_ELEM_S', CHAMS0 )
      ENDIF
C
      CALL JEDETR ( '&&RC36CM.LICH' )
      CALL JEDETR ( '&&RC36CM.LICM' )
      CALL JEDETR ( '&&RC36CM.LICR' )
C
      CALL JEDEMA( )
      END
