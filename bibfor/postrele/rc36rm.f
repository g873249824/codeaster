      SUBROUTINE RC36RM
      IMPLICIT   NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 11/09/2002   AUTEUR VABHHTS J.PELLET 
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
C     RECUPERATION DES DONNEES DE "RESU_MECA"
C
C IN  : NBMA   : NOMBRE DE MAILLES D'ANALYSE
C IN  : LISTMA : LISTE DES MAILLES D'ANALYSE
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
      INTEGER      N1, IOCC, IRET, JORD, JNUME, JTYPE, NBORDR, 
     +             JCHAM, NBRESU
      REAL*8       PREC
      CHARACTER*8  K8B, RESU, CRIT
      CHARACTER*16 MOTCLF, NOMSYM
      CHARACTER*24 KNUM, NOMCHA, CHAMS0
C DEB ------------------------------------------------------------------
      CALL JEMARQ()
C
      MOTCLF = 'RESU_MECA'
      KNUM   = '&&RC3600.NUME_ORDRE'
C
      CALL GETFAC ( MOTCLF, NBRESU )
C
      CALL WKVECT('&&RC3600.NUME_CHAR', 'V V I  ', NBRESU, JNUME )
      CALL WKVECT('&&RC3600.TYPE_CHAR', 'V V K8 ', NBRESU, JTYPE )
      CALL WKVECT('&&RC3600.CHAMP'    , 'V V K24', NBRESU, JCHAM )
C
      DO 10, IOCC = 1, NBRESU, 1
C
         CALL GETVIS ( MOTCLF,'NUME_CHAR',IOCC,1,1,ZI(JNUME+IOCC-1),N1)
C
         CALL GETVTX ( MOTCLF,'TYPE_CHAR',IOCC,1,1,ZK8(JTYPE+IOCC-1),N1)
C
         CALL GETVID ( MOTCLF,'RESULTAT' ,IOCC,1,1,RESU,N1)
         IF ( N1 .NE. 0 ) THEN
            CALL GETVTX(MOTCLF,'NOM_CHAM' ,IOCC,1,1,NOMSYM,N1)
            CALL GETVR8(MOTCLF,'PRECISION',IOCC,1,1,PREC,N1)
            CALL GETVTX(MOTCLF,'CRITERE'  ,IOCC,1,1,CRIT,N1)
            CALL RSUTNU(RESU,MOTCLF,IOCC,KNUM,NBORDR,PREC,CRIT,IRET)
            IF (IRET.NE.0) THEN
               CALL UTDEBM('F','FATIGUE_B3600','PROBLEME RECUPERATION')
               CALL UTIMPI('S',' POUR L''OCCURRENCE ',1,IOCC)
               CALL UTIMPK('L',' DANS LE RESULTAT ',1,RESU)
               CALL UTFINM()
            ENDIF
            IF (NBORDR.NE.1) THEN
               CALL UTDEBM('F','FATIGUE_B3600','PROBLEME DONNEES')
               CALL UTIMPI('S',' POUR L''OCCURRENCE ',1,IOCC)
               CALL UTIMPI('L',' UN SEUL NUMERO D''ORDRE ',0,IOCC)
               CALL UTFINM()
            ENDIF
            CALL JEVEUO ( KNUM, 'L', JORD )
            CALL RSEXCH(RESU,NOMSYM,ZI(JORD),NOMCHA,IRET)
            IF (IRET.NE.0) THEN
               CALL UTDEBM('F','FATIGUE_B3600','PROBLEME DONNEES')
               CALL UTIMPI('S',' POUR L''OCCURRENCE ',1,IOCC)
               CALL UTIMPK('L',' DANS LE RESULTAT ',1,RESU)
               CALL UTIMPK('S',' POUR LE NOM_CHAM ',1,NOMCHA)
               CALL UTFINM()
            ENDIF
            CALL JEDETR ( KNUM )
C
         ELSE
            CALL GETVID ( MOTCLF, 'CHAM_GD', IOCC,1,1, NOMCHA, N1 )
C
         ENDIF
C
         CALL CODENT ( IOCC , 'D0' , K8B  )
         CHAMS0 = '&&RC3602.'//K8B
         CALL CELCES ( NOMCHA, 'V', CHAMS0 )
         ZK24(JCHAM+IOCC-1) = CHAMS0
C
 10   CONTINUE
C
      CALL JEDEMA( )
      END
