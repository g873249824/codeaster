      SUBROUTINE QUADIM(UNIT,QUADRA,NGRMA1,NGRMA2)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/01/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*10  QUADRA
      CHARACTER*10  NGRMA1,NGRMA2      
      INTEGER       UNIT
C      
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C IMPRESSION DE LA SD POUR LES INTEGRALES (QUADRATURES) 
C
C ----------------------------------------------------------------------
C
C
C IN  UNIT   : UNITE D'IMPRESSION 
C IN  QUADRA : NOM DE LA STRUCTURE DE DONNEES QUADRATURES
C IN  NGRMA1 : NOM DE LA LISTE DES MAILLES DU PREMIER GROUPE
C IN  NGRMA2 : NOM DE LA LISTE DES MAILLES DU SECOND GROUPE
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*32       JEXNUM
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
C      
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      INTEGER      IRET 
      INTEGER      JLIMA
      INTEGER      IM1,IM2
      INTEGER      NAPP,IAPP,NFAM,IFAM,NCPL,ICPL
      INTEGER      JMAMA,JTYPM,JNUME,JGRMA1,JGRMA2
      CHARACTER*8  K8BID,NOMO,NOMA,NOMMA1,NOMMA2
      INTEGER      NUMMA1,NUMMA2,IOCC,JNOMA
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- RECUPERATION MAILLAGE 
C
      CALL GETVID(' ','MODELE',0,1,1,NOMO,IOCC)
      IF (IOCC.EQ.0) THEN
        WRITE(UNIT,*) '<QUADRA  > AFFICHAGE IMPOSSIBLE (VOIR QUADIM) '
        GOTO 999  
      ELSE
        WRITE(UNIT,*) '<QUADRA  > SD DE QUADRATURE (INTEGRATION '//
     &                'NUMERIQUE)...'       
      ENDIF
      CALL JEVEUO(NOMO(1:8)//'.MODELE    .NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)       
C     
      CALL JEVEUO(NGRMA1(1:10)//'.GROUPEMA','L',JGRMA1)
      CALL JEVEUO(NGRMA2(1:10)//'.GROUPEMA','L',JGRMA2)            
C          
      CALL JEEXIN(QUADRA(1:10)//'.MAMA',IRET)
      IF (IRET.EQ.0) THEN
        WRITE(UNIT,*) '<QUADRA  > SD QUADRATURES: <',
     &          QUADRA(1:10)//'.MAMA','> N''EXISTE PAS'        
      ELSE
        CALL JELIRA(QUADRA(1:10)//'.MAMA','LONMAX',NAPP,K8BID)
        NAPP = NAPP/2
        WRITE(UNIT,*) '<QUADRA  > ... NOMBRE DE COUPLES DE MAILLES '//
     &                'A INTEGRER :',NAPP  
C
        CALL JEVEUO(QUADRA(1:10)//'.MAMA','L',JMAMA)
        WRITE(UNIT,*) '<QUADRA  > ... COUPLES DE MAILLES '//
     &                'A INTEGRER...'  
C
        DO 70 IAPP = 1 , NAPP
          IM1 = ZI(JMAMA+2*(IAPP-1))
          IM2 = ZI(JMAMA+2*(IAPP-1)+1)
C      
          NUMMA1 = ZI(JGRMA1+ABS(IM1)-1)
          CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMMAI',NUMMA1),NOMMA1)
          NUMMA2 = ZI(JGRMA2+ABS(IM2)-1)
          CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMMAI',NUMMA2),NOMMA2)
C                   
          WRITE(UNIT,*) '<QUADRA  > ...... COUPLE (',IAPP,' ): ',
     &                  NOMMA1,'/',NOMMA2
C          
          IF (IM2.GT.0) THEN
            WRITE(UNIT,*) '<QUADRA  > ...... INTEGRE PAR INCLUSION' 
          ELSE
            WRITE(UNIT,*) '<QUADRA  > ...... INTEGRE PAR '//
     &                    'SOUS-MAILLES'              
            IM2 = -IM2
          ENDIF
C         
          IF (IM1.GT.0) THEN
            WRITE(UNIT,*) '<QUADRA  > ...... INTEGRE SUR LA '//
     &                    'PREMIERE MAILLE '
          ELSE
            WRITE(UNIT,*) '<QUADRA  > ...... INTEGRE SUR LA '//
     &                    'SECONDE MAILLE '
          ENDIF
 70     CONTINUE 
      ENDIF       
C
      CALL JEEXIN(QUADRA(1:10)//'.TYPEMA',IRET)
      IF (IRET.EQ.0) THEN
        WRITE(UNIT,*) '<QUADRA  > SD QUADRATURES: <',
     &          QUADRA(1:10)//'.TYPEMA','> N''EXISTE PAS'        
      ELSE
        CALL JELIRA(QUADRA(1:10)//'.TYPEMA','LONMAX',NFAM,K8BID)
        CALL JEVEUO(QUADRA(1:10)//'.TYPEMA','L',JTYPM)
        CALL JEVEUO(QUADRA(1:10)//'.NUMERO','L',JNUME)
        CALL JEVEUO(QUADRA(1:10)//'.LIMAMA','L',JLIMA)
C
        WRITE(UNIT,*) '<QUADRA  > ... NOMBRE DE FAMILLES DE '//
     &                'QUADRATURES: ',NFAM    
C
        WRITE(UNIT,*) '<QUADRA  > ... FAMILLES DE QUADRATURE...'
C
        DO 80 IFAM = 1, NFAM 
          WRITE(UNIT,*) '<QUADRA  > ... FAMILLE (',IFAM,' )...'
          WRITE(UNIT,*) '<QUADRA  > ...... NUMERO FORMULE: ',
     &                      ZI(JNUME+IFAM-1)
          WRITE(UNIT,*) '<QUADRA  > ...... TYPE DE MAILLE: ',
     &                      ZK8(JTYPM+IFAM-1)
          CALL JELIRA(JEXNUM(QUADRA(1:10)//'.LIMAMA',IFAM),
     &                  'LONMAX',NCPL,K8BID) 
          WRITE(UNIT,*) '<QUADRA  > ...... NOMBRE DE COUPLES : ',
     &                      NCPL/2 
          CALL JEVEUO(JEXNUM(QUADRA(1:10)//'.LIMAMA',IFAM),'L',JLIMA)
          DO 81 ICPL = 1, NCPL-1
            NUMMA1 = ZI(JLIMA+ICPL-1)
            CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMMAI',NUMMA1),NOMMA1)
            NUMMA2 = ZI(JLIMA+ICPL-1+1)
            CALL JENUNO(JEXNUM(NOMA(1:8)//'.NOMMAI',NUMMA2),NOMMA2)
            WRITE(UNIT,*) '<QUADRA  > ...... FAMILLE ',IFAM, 
     &                    ' SUR COUPLE ',NOMMA1,'/',NOMMA2
  81      CONTINUE                             
  80    CONTINUE        
      ENDIF  
C
  999 CONTINUE      
C
      CALL JEDEMA()
      END
