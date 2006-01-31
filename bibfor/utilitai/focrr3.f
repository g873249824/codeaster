      SUBROUTINE FOCRR3 ( NOMFON, RESU, NOPARA, BASE, IER )
      IMPLICIT   NONE
      INTEGER             IER
      CHARACTER*1         BASE
      CHARACTER*16        NOPARA
      CHARACTER*19        NOMFON, RESU
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 30/01/2006   AUTEUR LEBOUVIE F.LEBOUVIER 
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
C     RECUPERATION D'UNE FONCTION DANS UNE STRUCTURE "RESULTAT"
C                                 PARAMETRE = F(VARIABLE D'ACCES)
C     ------------------------------------------------------------------
C VAR : NOMFON : NOM DE LA FONCTION
C IN  : RESU   : NOM DE LA STRUCTURE RESULTAT
C IN  : NOPARA : NOM DU PARAMETRE
C IN  : BASE   : BASE OU L'ON CREE LA FONCTION
C OUT : IER    : CODE RETOUR, = 0 : OK
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER      NBORDR, IRET, KORDR, NP, NC,  LPRO, LFON, LVAR, 
     +             IORDR, LACCE, ILON, LXLGUT, NBACC, NBPAR
      REAL*8       EPSI
      CHARACTER*8  K8B, CRIT, TYPE
      CHARACTER*16 NOMCMD, TYPCON, NOMACC
      CHARACTER*19 KNUME
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      IER = 0
      CALL GETRES ( K8B, TYPCON, NOMCMD )
      KNUME = '&&FOCRR3.NUME_ORDR'
C
C     --- RECUPERATION DES NUME_ORDRE FOURNIS PAR L'UTILISATEUR ---
C
      CALL RSUTN1 ( RESU, NOPARA, ' ', 1, KNUME, NBORDR )
      CALL JEVEUO ( KNUME, 'L', KORDR )
C
      ILON = LXLGUT( NOPARA )
      IF ( ILON .GT. 16 ) THEN
         CALL UTDEBM('A','FOCRR3','PARAMETRE TROP LONG, IL SERA ')
         CALL UTIMPK('S','TRONQUE: ', 1, NOPARA(1:16) )
         CALL UTFINM
      ENDIF
C
C     --- RECUPERATION DE LA VARIABLE D'ACCES ---
C
      CALL RSNOPA ( RESU, 0, '&&FOCRR3.VAR.ACCES', NBACC, NBPAR )
      CALL JEEXIN ( '&&FOCRR3.VAR.ACCES', IRET )
      IF ( IRET .GT. 0 ) THEN
         CALL JEVEUO ( '&&FOCRR3.VAR.ACCES', 'L', LACCE )
         NOMACC = ZK16(LACCE)
      ELSE
         CALL UTMESS('F','FOCRR3',
     +               'PROBLEME POUR RECUPERER LES VARIABLES D''ACCES')
      ENDIF
      CALL JEDETR ( '&&FOCRR3.VAR.ACCES' )
C
C     --- CREATION DE LA FONCTION SORTIE ---
C
C     --- REMPLISSAGE DU .PROL ---
      CALL WKVECT ( NOMFON//'.PROL', BASE//' V K16', 5, LPRO )
      ZK16(LPRO  ) = 'FONCTION'
      ZK16(LPRO+1) = 'NON NON '
      ZK16(LPRO+2) = NOMACC(1:8)
      ZK16(LPRO+3) = NOPARA(1:8)
      ZK16(LPRO+4) = 'EE      '
C
C     --- REMPLISSAGE DU .VALE ---
      CALL WKVECT ( NOMFON//'.VALE', BASE//' V R', 2*NBORDR, LVAR )
      LFON = LVAR + NBORDR
C
      DO 20 IORDR = 1 , NBORDR
C
         CALL RSADPA (RESU,'L',1,NOMACC,ZI(KORDR+IORDR-1),1,LACCE,TYPE)
         IF ( TYPE(1:1) .EQ. 'R' ) THEN
            ZR(LVAR+IORDR-1) = ZR(LACCE)
         ELSE
            CALL UTMESS('F','FOCRR3',
     +               'ON NE TRAITE QUE DES VARIABLES D''ACCES REELLES')
         ENDIF
C
         CALL RSADPA (RESU,'L',1,NOPARA,ZI(KORDR+IORDR-1),1,LACCE,TYPE)
         IF ( TYPE(1:1) .EQ. 'R' ) THEN
            ZR(LFON+IORDR-1) = ZR(LACCE)
         ELSE
            CALL UTMESS('F','FOCRR3',
     +                      'ON NE TRAITE QUE DES PARAMETRES REELS')
         ENDIF
C
 20   CONTINUE
C
      CALL JEDETR( KNUME )
C
      CALL JEDEMA()
      END
