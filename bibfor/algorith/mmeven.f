      SUBROUTINE MMEVEN(PHASE ,DEFICO,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/04/2012   AUTEUR ABBAS M.ABBAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*3  PHASE
      CHARACTER*24 DEFICO,RESOCO
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - EVENT-DRIVEN)
C
C DETECTION D'UNE COLLISION
C
C ----------------------------------------------------------------------
C
C
C IN  PHASE  : PHASE DE DETECTION
C              'INI' - AU DEBUT DU PAS DE TEMPS
C              'FIN' - A LA FIN DU PAS DE TEMPS
C IN  DEFICO : SD DE DEFINITION DU CONTACT
C IN  RESOCO : SD DE RESOLUTION DU CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV
      INTEGER      CFDISI,NTPC,IPTC
      CHARACTER*24 CTEVCO,TABFIN
      INTEGER      JCTEVC,JTABF
      INTEGER      CFMMVD,ZEVEN,ZTABF
      LOGICAL      LACTIF
      REAL*8       ETACIN,ETACFI
      LOGICAL      LEXIV,CFDISL
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> ...... GESTION DES JEUX POUR'//
     &                ' EVENT-DRIVEN'
      ENDIF
C
C --- PARAMETRES
C
      NTPC   = CFDISI(DEFICO,'NTPC')
C
C --- UNE ZONE EN MODE SANS CALCUL: ON NE PEUT RIEN FAIRE
C
      LEXIV  = CFDISL(DEFICO,'EXIS_VERIF')
      IF (LEXIV) GOTO 999
C
C --- ACCES OBJETS DU CONTACT
C
      TABFIN = RESOCO(1:14)//'.TABFIN'
      CTEVCO = RESOCO(1:14)//'.EVENCO'
      CALL JEVEUO(TABFIN,'L',JTABF )
      CALL JEVEUO(CTEVCO,'E',JCTEVC)
      ZTABF = CFMMVD('ZTABF')
      ZEVEN  = CFMMVD('ZEVEN')
C
C --- DETECTION
C
      DO 20 IPTC = 1,NTPC
        ETACIN = ZR(JCTEVC+ZEVEN*(IPTC-1)+1-1)
        ETACFI = ZR(JCTEVC+ZEVEN*(IPTC-1)+2-1)
        LACTIF = .FALSE.
C
C ----- LA LIAISON EST-ELLE ACTIVE ?
C
        IF (ZR(JTABF+ZTABF*(IPTC-1)+22).GT.0.D0) LACTIF = .TRUE.
C
C ----- CHANGEMENT STATUT
C
        IF (LACTIF) THEN
          IF (PHASE.EQ.'INI') THEN
            ETACIN = 1.D0
          ELSEIF (PHASE.EQ.'FIN') THEN
            ETACFI = 1.D0
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ELSE
          IF (PHASE.EQ.'INI') THEN
            ETACIN = 0.D0
          ELSEIF (PHASE.EQ.'FIN') THEN
            ETACFI = 0.D0
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
        ENDIF
        ZR(JCTEVC+ZEVEN*(IPTC-1)+1-1) = ETACIN
        ZR(JCTEVC+ZEVEN*(IPTC-1)+2-1) = ETACFI
 20   CONTINUE
C
 999  CONTINUE
C
      CALL JEDEMA()
      END
