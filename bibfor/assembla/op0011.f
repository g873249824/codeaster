      SUBROUTINE OP0011()
      IMPLICIT  NONE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

C======================================================================

C                       OPERATEUR NUME_DDL
C======================================================================
C
C
C======================================================================
C----------------------------------------------------------------------
C     VARIABLES LOCALES
C----------------------------------------------------------------------
      INCLUDE 'jeveux.h'
      INTEGER      NLIMAT,IMATEL
      PARAMETER   (NLIMAT=100)
      INTEGER      IFM,NBID,NBMAT,NIV,NBCHA,IACHA,JNSLV,IL
      CHARACTER*2  BASE
      CHARACTER*8  K8B, TLIMAT(NLIMAT), NUUTI, RENUM, MO
      CHARACTER*14 NUDEV
      CHARACTER*16 TYPE,OPER, METHOD
      CHARACTER*19 CH19, SOLVEU
      CHARACTER*24 CHARGE
      INTEGER      IARG
C----------------------------------------------------------------------
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)

      CALL GETVTX ( ' ', 'METHODE', 0,IARG,1, METHOD, NBID )
      CALL GETVTX ( ' ', 'RENUM'  , 0,IARG,1, RENUM,  NBID )

      CHARGE = '&&OP0011.CHARGES   .LCHA'
      BASE ='GG'

C --- RECUPERATION DU CONCEPT RESULTAT ET DE SON NOM UTILISATEUR :
C     ----------------------------------------------------------
      CALL GETRES(NUUTI,TYPE,OPER)
      NUDEV = NUUTI


C     -- CREATION D'UNE SD SOLVEUR :
C     --------------------------------
      SOLVEU=NUUTI//'.SOLVEUR'
      CALL CRSOLV ( METHOD, RENUM, SOLVEU, 'G' )


C --- TRAITEMENT DU MOT CLE MATR_RIGI OU MODELE :
C     -----------------------------------------
      CALL GETVID ( ' ', 'MATR_RIGI', 0,IARG,0, K8B, NBMAT )
C
      IF ( NBMAT .EQ. 0 ) THEN
         CALL GETVID ( ' ', 'MODELE', 1,IARG,1, MO, NBID )
         CALL GETVID ( ' ', 'CHARGE', 1,IARG,0, K8B,NBCHA)
         NBCHA = -NBCHA
         IF (NBCHA.NE.0) THEN
            CALL WKVECT ( CHARGE, 'V V K24', NBCHA, IACHA )
            CALL GETVID (' ', 'CHARGE', 1,IARG,NBCHA, ZK24(IACHA), NBID)
         ENDIF
         CALL NUMERO (' ',MO, CHARGE(1:19), SOLVEU, BASE, NUDEV )
         CALL JEDETR ( CHARGE )
         GOTO 20
      ENDIF


      NBMAT = -NBMAT
      CALL GETVID ( ' ', 'MATR_RIGI', 0,IARG,NBMAT, TLIMAT, NBMAT )
      CALL WKVECT('&&OP001_LIST_MATEL','V V K24',NBMAT,IMATEL)
      DO 10 IL=1,NBMAT
        ZK24(IMATEL+IL-1)=TLIMAT(IL)
 10   CONTINUE


      CALL UTTCPU('CPU.RESO.1','DEBUT',' ')
      CALL UTTCPU('CPU.RESO.2','DEBUT',' ')

C --- CALCUL DE LA NUMEROTATION PROPREMENT DITE :
C     -----------------------------------------
      CALL NUMDDL ( NUDEV, 'GG', NBMAT,ZK24(IMATEL), RENUM)

C --- CREATION ET CALCUL DU STOCKAGE MORSE DE LA MATRICE :
C     -----------------------------------------------------------
      CALL PROMOR (NUDEV,'G')

      CALL UTTCPU('CPU.RESO.1','FIN',' ')
      CALL UTTCPU('CPU.RESO.2','FIN',' ')


C --- CREATION DE L'OBJET .NSLV :
C     -------------------------------------
      CALL WKVECT(NUDEV//'.NSLV','G V K24',1,JNSLV)
      ZK24(JNSLV-1+1)=SOLVEU


 20   CONTINUE



C --- MENAGE :
C     ------
      CH19 = NUDEV
      CALL JEDETR(CH19(1:14)//'.NEWN')
      CALL JEDETR(CH19(1:14)//'.OLDN')
      CALL JEDETR(CH19//'.ADNE')
      CALL JEDETR(CH19//'.ADLI')
      END
