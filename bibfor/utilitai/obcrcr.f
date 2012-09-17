      SUBROUTINE OBCRCR(NOMSTR,NBPARB,NBPARI,NBPARR,NBPARK,
     &                  NBPARO,PARAB ,PARAI ,PARAR ,PARAK ,
     &                  PARAO ,TYPEO )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 18/09/2012   AUTEUR ABBAS M.ABBAS 
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
      INCLUDE      'jeveux.h'
      CHARACTER*24 NOMSTR
      INTEGER      NBPARB,NBPARI,NBPARR,NBPARK,NBPARO
      CHARACTER*24 PARAB(NBPARB)
      CHARACTER*24 PARAI(NBPARI)
      CHARACTER*24 PARAR(NBPARR)
      CHARACTER*24 PARAK(NBPARK)
      CHARACTER*24 PARAO(NBPARO)
      CHARACTER*24 TYPEO(NBPARO)
C
C ----------------------------------------------------------------------
C
C ROUTINE UTILITAIRE (GESTION STRUCT)
C
C CREATION
C
C ----------------------------------------------------------------------
C
C
C IN  NOMSTR : NOM DU STRUCT
C IN  NBPARB : NOMBRE DE PARAMETRES DE TYPE BOOLEEN
C IN  NBPARI : NOMBRE DE PARAMETRES DE TYPE ENTIER
C IN  NBPARR : NOMBRE DE PARAMETRES DE TYPE REEL
C IN  NBPARK : NOMBRE DE PARAMETRES DE TYPE CHAINE
C IN  NBPARO : NOMBRE DE PARAMETRES DE TYPE OBJET
C IN  PARAB  : LISTE DES PARAMETRES DE TYPE BOOLEEN
C IN  PARAI  : LISTE DES PARAMETRES DE TYPE ENTIER
C IN  PARAR  : LISTE DES PARAMETRES DE TYPE REEL
C IN  PARAK  : LISTE DES PARAMETRES DE TYPE CHAINE
C IN  PARAO  : LISTE DES PARAMETRES DE TYPE OBJET
C IN  TYPEO  : LISTE DES TYPES D'OBJETS
C
C ----------------------------------------------------------------------
C
      CHARACTER*24 SDVALB,SDVALI,SDVALR,SDVALK,SDVALO,SDTYPO
      INTEGER      JSVALB,JSVALI,JSVALR,JSVALK,JSVALO,JSTYPO
      CHARACTER*24 SDPARA
      INTEGER      JSPARA
      INTEGER      JDECAL,NBPARA,IPARA
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- NOM DES OBJETS JEVEUX
C
      SDPARA = NOMSTR(1:19)//'.PARA'
      SDVALB = NOMSTR(1:19)//'.VALB'
      SDVALI = NOMSTR(1:19)//'.VALI'
      SDVALR = NOMSTR(1:19)//'.VALE'
      SDVALK = NOMSTR(1:19)//'.VALK'
      SDVALO = NOMSTR(1:19)//'.VALO'
      SDTYPO = NOMSTR(1:19)//'.TYPO'
C
C --- CREATION SEGMENTS DE VALEUR
C
      IF (NBPARB.NE.0) CALL WKVECT(SDVALB,'V V I  ',NBPARB,JSVALB)
      IF (NBPARI.NE.0) CALL WKVECT(SDVALI,'V V I  ',NBPARI,JSVALI)
      IF (NBPARR.NE.0) CALL WKVECT(SDVALR,'V V R  ',NBPARR,JSVALR)
      IF (NBPARK.NE.0) CALL WKVECT(SDVALK,'V V K24',NBPARK,JSVALK)
      IF (NBPARO.NE.0) CALL WKVECT(SDVALO,'V V K24',NBPARO,JSVALO)
      IF (NBPARO.NE.0) CALL WKVECT(SDTYPO,'V V K24',NBPARO,JSTYPO)
C
C --- CREATION PARAMETRES
C
      NBPARA = NBPARB+NBPARI+NBPARR+NBPARK+NBPARO
      CALL ASSERT(NBPARA.GT.0)
      CALL WKVECT(SDPARA,'V V K24',NBPARA,JSPARA)
C
C --- NOM DES PARAMETRES
C
      JDECAL = 0
      DO 10 IPARA = 1,NBPARB
        ZK24(JSPARA-1+IPARA+JDECAL) = PARAB(IPARA)
 10   CONTINUE
      JDECAL = NBPARB
      DO 20 IPARA = 1,NBPARI
        ZK24(JSPARA-1+IPARA+JDECAL) = PARAI(IPARA)
 20   CONTINUE
      JDECAL = JDECAL+NBPARI
      DO 30 IPARA = 1,NBPARR
        ZK24(JSPARA-1+IPARA+JDECAL) = PARAR(IPARA)
 30   CONTINUE
      JDECAL = JDECAL+NBPARR
      DO 40 IPARA = 1,NBPARK
        ZK24(JSPARA-1+IPARA+JDECAL) = PARAK(IPARA)
 40   CONTINUE
      JDECAL = JDECAL+NBPARK
      DO 50 IPARA = 1,NBPARO
        ZK24(JSPARA-1+IPARA+JDECAL) = PARAO(IPARA)
        ZK24(JSTYPO-1+IPARA)        = TYPEO(IPARA)
 50   CONTINUE
C
      CALL JEDEMA()
      END
