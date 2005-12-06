      SUBROUTINE GCURES ( TYPGEN, ICOMP, NBCMD, NOMCMD )
      IMPLICIT   NONE
      INTEGER             NBCMD, ICOMP
      CHARACTER*8         TYPGEN, NOMCMD(*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF SUPERVIS  DATE 17/11/97   AUTEUR CIBHHLV L.VIVAN 
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
C     RECUPERATION DES NOMS UTILISATEUR CORRESPONDANT A UN TYPE DONNE
C
C IN  : TYPGEN : TYPE DE GENERIQUE A RECUPERER
C IN  : ICOMP  : = 0 , ON COMPTE 
C                SINON ON COMPTE ET ON RECUPERE LES NOMS UTILISATEUR
C                      EN SUPPRIMANT LES DOUBLONS
C OUT : NBCMD  : NOMBRE DE NOMS UTILISATEUR VERIFIANT TYPGEN
C OUT : NOMCMD : LISTE DES NOMS UTILISATEUR VERIFIANT TYPGEN
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER      IBID, LONUTI, JCMD, I, J, IERD
      CHARACTER*8  K8B, NOUSER, REPONS, STATUT
C     ------------------------------------------------------------------
      CHARACTER*24      KINFO , KRESU, KSTAT
      COMMON / GCUCC1 / KINFO , KRESU, KSTAT
C     ------------------------------------------------------------------
C
      CALL JEMARQ( )
C
      CALL JEVEUO ( KRESU , 'L' ,  JCMD )
      CALL JELIRA ( KRESU , 'LONUTI' , LONUTI , K8B )
C
C     DESCRIPTION DE KRESU :
C          ZK80(JCMD)( 1: 8) = NOM UTILISATEUR DU RESULTAT
C          ZK80(JCMD)( 9:24) = NOM DU CONCEPT DU RESULTAT
C          ZK80(JCMD)(25:40) = NOM DE L'OPERATEUR
C          ZK80(JCMD)(41:48) = STATUT DE L'OBJET
C
      NBCMD = 0
      DO 10 I = 1 , LONUTI
         NOUSER = ZK80(JCMD+I-1)( 1: 8)
         STATUT = ZK80(JCMD+I-1)(41:48)
         CALL DISMOI('F',TYPGEN,NOUSER,'INCONNU',IBID,REPONS,IERD)
         IF ( REPONS(1:3).EQ.'OUI' .AND. STATUT.EQ.'&EXECUTE' ) THEN
            IF ( ICOMP .NE. 0 ) THEN
               DO 12 J = 1 , NBCMD
                  IF ( NOUSER .EQ. NOMCMD(J) ) GOTO 10
 12            CONTINUE
               NBCMD = NBCMD + 1
               NOMCMD(NBCMD) = NOUSER
            ELSE
               NBCMD = NBCMD + 1
            ENDIF
         ENDIF
 10   CONTINUE
C
      CALL JEDEMA()
      END
