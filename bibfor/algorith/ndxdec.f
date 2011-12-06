      SUBROUTINE NDXDEC(SDIMPR,SDDISC,NUMINS,ACTITE,ACTPAS)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/09/2011   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INTEGER      ACTITE,ACTPAS
      INTEGER      NUMINS
      CHARACTER*19 SDDISC
      CHARACTER*24 SDIMPR
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C GESTION DE LA DECOUPE DU PAS DE TEMPS
C      
C ----------------------------------------------------------------------
C
C IN  SDIMPR : SD AFFICHAGE
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  NUMINS : NUMERO D'INSTANT
C IN  ACTITE : BOUCLE NEWTON -> ACTION POUR LA SUITE
C     0 - NEWTON OK   - ON SORT
C     1 - NEWTON NOOK - IL FAUT FAIRE QUELQUE CHOSE
C     2 - NEWTON NCVG - ON CONTINUE NEWTON
C     3 - NEWTON STOP - TEMPS/USR1
C OUT ACTPAS : BOUCLE TEMPS -> ACTION POUR LA SUITE
C     1 - BOUCLE TEMPS - PAS SUIVANT
C     2 - BOUCLE TEMPS - ON REFAIT LE PAS
C     3 - BOUCLE TEMPS - ARRET DU CALCUL
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
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
C 
      INTEGER      ITERAT,RETACT,IEVDAC
      CHARACTER*24 K24BLA
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      ACTPAS = 0
      ITERAT = 0
      K24BLA = ' '
C
C --- CONTINUER LA BOUCLE DE NEWTON EST IMPOSSIBLE ICI
C
      IF (ACTITE.EQ.2) CALL ASSERT(.FALSE.)
C
C --- PAS DE TEMPS SUIVANT
C
      IF (ACTITE.EQ.0) THEN
        ACTPAS = 1
        GOTO 999
      ENDIF  
C
C --- SORTIE DE BOUCLE (PROBLEME)
C
      IF (ACTITE.EQ.3) THEN
        ACTPAS = 3
        GOTO 999
      ENDIF       
C
C --- ECHEC DE NEWTON: IL FAUT FAIRE QUELQUE CHOSE
C
      CALL ASSERT(ACTITE.EQ.1)
C
C --- RECHERCHE DES EVENEMENTS ACTIVES
C
      CALL NMACTO(SDDISC,IEVDAC)
C
C --- ACTIONS SUITE A UN EVENEMENT
C
      IF (IEVDAC.EQ.0) THEN
        RETACT = 0
      ELSE
        CALL NMEVAC(SDIMPR,SDDISC,K24BLA,K24BLA,IEVDAC,
     &              NUMINS,ITERAT,RETACT)
      ENDIF
C
C --- TRAITEMENT DE L'ACTION
C
      IF (RETACT.EQ.0) THEN
C      
C ----- RIEN A FAIRE: BOUCLE CONTACT SUIVANTE
C
        ACTPAS = 1    
      
      ELSE IF (RETACT.EQ.1)  THEN
C      
C ----- LA SUBDIVISION S'EST BIEN PASSEE: ON REFAIT LE PAS
C
        ACTPAS = 2

      ELSE IF (RETACT.EQ.2) THEN
C      
C ----- AUTORISATION DE FAIRE DES ITERATIONS DE NEWTON EN PLUS  
C
        WRITE(6,*) 'ON PEUT PAS FAIRE DES ITERATIONS EN PLUS'
        CALL ASSERT(.FALSE.)
        

      ELSEIF (RETACT.EQ.3) THEN
C      
C ----- ON REFAIT LE PAS
C
        ACTPAS = 2

      ELSE
C
C ----- ARRET DU CALCUL        
C
        ACTPAS = 3

      ENDIF 
C
 999  CONTINUE   
C
      CALL JEDEMA()
      END
