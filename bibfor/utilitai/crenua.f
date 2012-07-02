      SUBROUTINE CRENUA ( NUAGE, NOMGD, NP, NX, NC, LNUAL )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER                           NP, NX, NC
      CHARACTER*(*)       NUAGE, NOMGD
      LOGICAL                                       LNUAL
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     CREATION D'UN SD NUAGE
C IN  NUAGE  : NOM DE LA SD A ALLOUER
C IN  NOMGD  : NOM DE LA GRANDEUR
C IN  NP     : NOMBRE DE POINTS DU NUAGE
C IN  NX     : NOMBRE DE COORDONNES DES POINTS
C IN  NC     : NOMBRE MAX DE CMP PORTES PAR LES POINTS
C IN  LNUAL  : CREATION OU NON DU .NUAL
C     ------------------------------------------------------------------
      INTEGER       IBID, IE, I, NDIM
      CHARACTER*4   TYPE
      CHARACTER*19  KNUAGE
C     ------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER JNUAI ,JNUAL ,JNUAV ,JNUAX 
C-----------------------------------------------------------------------
      CALL JEMARQ()
      KNUAGE = NUAGE
C
C     --- CREATION DU .NUAX ---
C
      NDIM = NX * NP
      CALL WKVECT ( KNUAGE//'.NUAX','V V R',NDIM,JNUAX)
C
C     --- CREATION DU .NUAI ---
C
      NDIM = 5 + NC
      CALL WKVECT ( KNUAGE//'.NUAI','V V I',NDIM,JNUAI)
C
C     --- CREATION DU .NUAV ---
C
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TYPE,IE)
      NDIM = NC * NP
      IF ( TYPE(1:1) .EQ. 'R' ) THEN
         CALL WKVECT ( KNUAGE//'.NUAV','V V R',NDIM,JNUAV)
      ELSEIF ( TYPE(1:1) .EQ. 'C' ) THEN
         CALL WKVECT ( KNUAGE//'.NUAV','V V C',NDIM,JNUAV)
      ELSE
         CALL U2MESS('F','UTILITAI_45')
      ENDIF
C
C     --- CREATION DU .NUAL ---
C
      IF ( LNUAL ) THEN
         NDIM = NC * NP
         CALL WKVECT ( KNUAGE//'.NUAL','V V L',NDIM,JNUAL)
         DO 10 I = 1 , NDIM
            ZL(JNUAL+I-1) = .FALSE.
 10      CONTINUE
      ENDIF
C
      CALL JEDEMA()
      END
