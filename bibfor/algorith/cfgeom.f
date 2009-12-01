      SUBROUTINE CFGEOM(PREMIE,REAGEO,ITERAT,INSTAN,NOMA  ,
     &                  DEFICO,RESOCO,DEPPLU,DDEPLA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/02/2009   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT     NONE
      INTEGER      ITERAT
      LOGICAL      PREMIE,REAGEO  
      REAL*8       INSTAN
      CHARACTER*8  NOMA
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 DEPPLU
      CHARACTER*19 DDEPLA
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
C
C ROUTINE D'AIGUILLAGE POUR L'ACTUALISATION GEOMETRIQUE DU CONTACT:
C  APPARIEMENT, PROJECTION, JEUX
C
C ----------------------------------------------------------------------
C
C
C IN  PREMIE : VAUT .TRUE. SI C'EST LE PREMIER CALCUL (PAS DE PASSE)
C IN  REAGEO : VAUT .TRUE. SI REACTUALISATION GEOMETRIQUE
C IN  ITERAT : NUMERO DE L'ITERATION DE NEWTON COURANTE
C IN  INSTAN : VALEUR DE L'INSTANT DE CALCUL
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  DEPPLU : CHAMP DE DEPLACEMENTS DEPUIS L'INSTANT INITIAL
C IN  DDEPLA : CHAMP DE DEPLACEMENTS DEPUIS L'ITERATION PRECEDENTE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*24 NEWGEO
      INTEGER      IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()    
      CALL INFDBG('CONTACT',IFM,NIV)  

      IF (REAGEO) THEN      
C 
C --- REACTUALISATION DE L'APPARIEMENT
C
         CALL CFIMPE(IFM,NIV,'CFGEOM',1)
C 
C --- REACTUALISATION DE LA GEOMETRIE
C 
         CALL GEOMCO(NOMA  ,DEFICO,DEPPLU,DDEPLA,NEWGEO)
C 
C --- APPARIEMENT NOEUD ESCLAVE - MAILLE (OU NOEUD) MAITRE
C 
         CALL RECHCO(NOMA  ,DEFICO,RESOCO,NEWGEO,PREMIE,
     &               INSTAN)
C
      ELSE
         CALL CFIMPE(IFM,NIV,'CFGEOM',4)
C
C --- REACTUALISATION DU JEU NECESSAIRE EN DEBUT DE PAS
C --- DE TEMPS AU CAS OU IL Y AURAIT EU REDECOUPAGE
C
         IF (ITERAT.EQ.0) THEN
           CALL REAJEU(RESOCO)
         ENDIF
      ENDIF
C
C --- IMPRESSIONS POUR LES DEVELOPPEURS
C
      IF (NIV.GE.2) THEN
        CALL CFIMP4(DEFICO,RESOCO,NOMA,IFM)
      ENDIF     
C
      CALL JEDEMA()
      END
