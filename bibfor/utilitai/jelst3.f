      SUBROUTINE JELST3(BASE,DEST,NMAX,NTOTAL)
      IMPLICIT NONE
      CHARACTER*1 BASE
      CHARACTER*24 DEST(*)
      INTEGER NMAX, NTOTAL
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 13/02/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C BUT : FABRIQUER UNE LISTE DE NOMS CONTENANT LE NOM DE TOUS LES OBJETS
C       TROUVES SUR UNE BASE ET DONT LE NOM CONTIENT UNE CERTAINE CHAINE
C ----------------------------------------------------------------------
C BASE   IN  K1 : NOM DE LA BASE : 'G'/'V'/'L'/' '  A SCRUTER
C SOUCH  IN  K* : CHAINE A CHERCHER DANS LE NOM
C IPOS   IN  I  : POSITION DU DEBUT DE LA CHAINE
C                 SI IPOS=0 : ON IGNORE SOUCH, ON PREND TOUS LES OBJETS
C BASE2  IN  K1 : NOM DE LA BASE POUR LA CREATION DE PTNOM
C PTNOM  IN/JXOUT K24 : NOM DU POINTEUR DE NOM A CREER.
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR,JEXR8
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
      INTEGER NBVAL

      CALL JEMARQ()


C     1. RECUPERATION DE LA LISTE DES OBJETS :
C     --------------------------------------------------------------
      CALL JELSTC(BASE,' ',0,NMAX,DEST,NBVAL)
      IF (NBVAL.LT.0) THEN
         NTOTAL = -NBVAL
      ELSE
         NTOTAL = NBVAL
      ENDIF
      CALL JEDEMA()

      END
