      SUBROUTINE SURFCO(CHAR,NOMA)  
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 07/10/2004   AUTEUR MABBAS M.ABBAS 
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
C
      IMPLICIT     NONE
      CHARACTER*8  CHAR
      CHARACTER*8  NOMA
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CALICO
C ----------------------------------------------------------------------
C
C AFFICHAGE DES RESULTATS DE LA LECTURE DU MOT-CLE CONTACT.
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      ZMETH
      PARAMETER    (ZMETH=8)
      INTEGER      IFM,NIV
      INTEGER      JNOMMA,JNOMNO
      INTEGER      NBZONE,NBSYME,NBMA,NBSURF,NBNO
      
      INTEGER      IZONE,ISURF,ISUCO,IMA,INO,K
      INTEGER      JDECMA,JDECNO,IECPCO

      CHARACTER*8  CHAIN1,CHAIN2
      CHARACTER*31 TEXT

      CHARACTER*24 NOEUMA,MAILMA
      INTEGER      NUMMA,NUMNO
      CHARACTER*24 PZONE,PSURMA,PSURNO,CONTMA,CONTNO,METHCO,NDIMCO
      INTEGER      JZONE,JSUMA,JSUNO,JMACO,JNOCO,JMETH,JDIM
      CHARACTER*24 CHAMCO,COEFCO,SYMECO 
      INTEGER      JCHAM,JCOEF,JSYME
      CHARACTER*24 MANOCO,PMANO,NOMACO,PNOMA,MAMACO,PMAMA,NOZOCO
      INTEGER      JMANO,JPOMA,JNOMA,JPONO,JMAMA,JPOIN,JZOCO

      CHARACTER*24 CARACF,ECPDON,MAESCL,NOESCL,TABFIN,PNOQUA,NORLIS
      INTEGER      JCMCF,JECPD,JMAESC,JNOESC,JTABF,JNOQUA,JNORLI
      INTEGER      NZOCO,NSUCO,NMACO,NNOCO,NMANO,NNOMA,NMAMA


C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL INFNIV(IFM,NIV)
C
      MAILMA = NOMA//'.NOMMAI'
      NOEUMA = NOMA//'.NOMNOE'
      PZONE  = CHAR(1:8)//'.CONTACT.PZONECO'
      PSURMA = CHAR(1:8)//'.CONTACT.PSUMACO'
      PSURNO = CHAR(1:8)//'.CONTACT.PSUNOCO'
      PNOQUA = CHAR(1:8)//'.CONTACT.PNOEUQU'

      SYMECO = CHAR(1:8)//'.CONTACT.SYMECO'      
      CONTMA = CHAR(1:8)//'.CONTACT.MAILCO'
      CONTNO = CHAR(1:8)//'.CONTACT.NOEUCO' 
      METHCO = CHAR(1:8)//'.CONTACT.METHCO' 
      CHAMCO = CHAR(1:8)//'.CONTACT.CHAMCO'     
      COEFCO = CHAR(1:8)//'.CONTACT.COEFCO' 
      MANOCO = CHAR(1:8)//'.CONTACT.MANOCO'
      PMANO  = CHAR(1:8)//'.CONTACT.PMANOCO'
      NOMACO = CHAR(1:8)//'.CONTACT.NOMACO'
      PNOMA  = CHAR(1:8)//'.CONTACT.PNOMACO'
      MAMACO = CHAR(1:8)//'.CONTACT.MAMACO'
      PMAMA  = CHAR(1:8)//'.CONTACT.PMAMACO'
      NOZOCO = CHAR(1:8)//'.CONTACT.NOZOCO'   
      CARACF = CHAR(1:8)//'.CONTACT.CARACF' 
      ECPDON = CHAR(1:8)//'.CONTACT.ECPDON' 
      MAESCL = CHAR(1:8)//'.CONTACT.MAESCL' 
      NOESCL = CHAR(1:8)//'.CONTACT.NOESCL' 
      TABFIN = CHAR(1:8)//'.CONTACT.TABFIN' 
      NDIMCO = CHAR(1:8)//'.CONTACT.NDIMCO'    
      NORLIS = CHAR(1:8)//'.CONTACT.NORLIS'  


      CALL JEVEUO (NDIMCO,'L',JDIM)
      NZOCO = ZI(JDIM+1)
      NSUCO = ZI(JDIM+2)
      NMACO = ZI(JDIM+3)
      NNOCO = ZI(JDIM+4)
      NMANO = ZI(JDIM+5)
      NNOMA = ZI(JDIM+6)
      NMAMA = ZI(JDIM+7)       
C
      CALL JEVEUO(PZONE, 'L',JZONE)
      CALL JEVEUO(PSURMA,'L',JSUMA)
      CALL JEVEUO(PSURNO,'L',JSUNO)
      CALL JEVEUO(PNOQUA,'L',JNOQUA)

      CALL JEVEUO(SYMECO,'L',JSYME)      
      CALL JEVEUO(CONTMA,'L',JMACO)
      CALL JEVEUO(CONTNO,'L',JNOCO)
      CALL JEVEUO(METHCO,'L',JMETH)
      CALL JEVEUO(CHAMCO,'L',JCHAM)
      CALL JEVEUO(COEFCO,'L',JCOEF)
      CALL WKVECT('&&SURFCO.TRAVMA','V V K8',NMACO,JNOMMA)
      CALL WKVECT('&&SURFCO.TRAVNO','V V K8',NNOCO,JNOMNO)
      CALL JEVEUO(MANOCO,'L',JMANO)
      CALL JEVEUO(PMANO,'L',JPOMA)
      CALL JEVEUO(NOMACO,'L',JNOMA)
      CALL JEVEUO(PNOMA,'L',JPONO)
      CALL JEVEUO(MAMACO,'L',JMAMA)
      CALL JEVEUO(PMAMA,'L',JPOIN)
      CALL JEVEUO(NOZOCO,'L',JZOCO)
      CALL JEVEUO(NORLIS,'L',JNORLI) 
    


C
C ======================================================================
C                    IMPRESSIONS POUR L'UTILISATEUR
C ======================================================================
C
      IF (NIV.GE.2) THEN
C
        WRITE (IFM,1100) '--------------------------------------'
        WRITE (IFM,1110) '          INFOS DE CONTACT '
        WRITE (IFM,1100) '--------------------------------------' 
        WRITE (IFM,*)
        WRITE (IFM,*)    'NDIM:',ZI(JDIM)
        WRITE (IFM,*)    'NZOCO:',ZI(JDIM+1)
        WRITE (IFM,*)    'NSUCO:',ZI(JDIM+2)
        WRITE (IFM,*)    'NMACO:',ZI(JDIM+3)
        WRITE (IFM,*)    'NNOCO:',ZI(JDIM+4)
        WRITE (IFM,*)    'NMANO:',ZI(JDIM+5)
        WRITE (IFM,*)    'NNOMA:',ZI(JDIM+6)
        WRITE (IFM,*)    'NMAMA:',ZI(JDIM+7)
        WRITE (IFM,*)    'NESMAX:',ZI(JDIM+8)
        WRITE (IFM,*)    'NOMBRE DE NOEUDS ESCLAVES PAR ZONE : ',
     &                    (ZI(JDIM+8+K),K=1,ZI(JDIM+1))

        WRITE (IFM,1100) '--------------------------------------'
        WRITE (IFM,1110) '          ZONES DE CONTACT '
        WRITE (IFM,1100) '--------------------------------------'
        WRITE (IFM,*)
        ISUCO = 0
        NBZONE = ZI(JMETH)
        NBSYME = ZI(JSYME)
        
        WRITE (IFM,1000) 'NOMBRE DE ZONES    DE CONTACT : ',NBZONE
        WRITE (IFM,1000) ' / DONT ZONES SYMETRIQUES     : ',NBSYME
        
        WRITE (IFM,1000) 'NOMBRE DE SURFACES DE CONTACT : ',
     &                    ZI(JZONE+NBZONE)
        WRITE (IFM,1000) 'NOMBRE DE MAILLES  DE CONTACT : ',
     &                    ZI(JSUMA+ZI(JZONE+NBZONE))
        WRITE (IFM,1000) 'NOMBRE DE NOEUDS   DE CONTACT : ',
     &                    ZI(JSUNO+ZI(JZONE+NBZONE))

        DO 10 IZONE = 1,NBZONE
C
           WRITE (IFM,*)
           WRITE (IFM,1010) '************* ZONE ',IZONE,' *************'
           WRITE (IFM,*)

           IF (IZONE.GT.(NBZONE-NBSYME)) THEN 
             WRITE (IFM,*) ' ZONE SYMETRIQUE, CREEE AUTOMATIQUEMENT '
           ENDIF 

           IF (ZI(JCHAM+IZONE-1).EQ.1) THEN
             TEXT = 'DEPLACEMENTS (AVEC APPARIEMENT)'
           ELSE IF (ZI(JCHAM+IZONE-1).EQ.-1) THEN
             TEXT = 'DEPLACEMENTS (SANS APPARIEMENT)'
           ELSE IF (ZI(JCHAM+IZONE-1).EQ.-2) THEN
             TEXT = 'PRESSION (SANS APPARIEMENT)'
           ELSE IF (ZI(JCHAM+IZONE-1).EQ.-3) THEN
             TEXT = 'TEMPERATURE (SANS APPARIEMENT)'
           ELSE IF (ZI(JCHAM+IZONE-1).EQ.-4) THEN
             TEXT = 'PRESSION1 (SANS APPARIEMENT)'
           ELSE IF (ZI(JCHAM+IZONE-1).EQ.-5) THEN
             TEXT = 'PRESSION2 (SANS APPARIEMENT)'
           END IF
           WRITE (IFM,1120) 'CHAMP SUR LEQUEL PORTE LA CONDITION '
     &                   //' UNILATERALE : ',TEXT
           WRITE (IFM,1130) 'COEFFICIENT DE LA CONDITION '
     &                   //' UNILATERALE :         ',ZR(JCOEF+IZONE-1)
           NBSURF =  ZI(JZONE+IZONE) - ZI(JZONE+IZONE-1)
           WRITE (IFM,1020) 'NOMBRE DE SURFACES DE CETTE ZONE : ',
     &        NBSURF
           WRITE (IFM,1020) 'NOMBRE DE MAILLES  DE CETTE ZONE : ',
     &        ZI(JSUMA+ZI(JZONE+IZONE))-ZI(JSUMA+ZI(JZONE+IZONE-1))
           WRITE (IFM,1020) 'NOMBRE DE NOEUDS   DE CETTE ZONE : ',
     &        ZI(JSUNO+ZI(JZONE+IZONE))-ZI(JSUNO+ZI(JZONE+IZONE-1))
C
           DO 20 ISURF = 1,NBSURF
              ISUCO = ISUCO + 1
              NBMA  = ZI(JSUMA+ISUCO) - ZI(JSUMA+ISUCO-1)
              NBNO  = ZI(JSUNO+ISUCO) - ZI(JSUNO+ISUCO-1)
              JDECMA = ZI(JSUMA+ISUCO-1)
              JDECNO = ZI(JSUNO+ISUCO-1)
              WRITE (IFM,*)
              CHAIN1 = ' MAILLES'
              CHAIN2 = ' NOEUDS'
              IF (NBMA.LE.1) CHAIN1 = ' MAILLE '
              IF (NBNO.LE.1) CHAIN2 = ' NOEUD '
              WRITE (IFM,1030) '---> SURFACE  ',ISURF,' : ',NBMA,
     &                          CHAIN1,NBNO,CHAIN2
              DO 30 IMA = 1,NBMA
                 NUMMA = ZI(JMACO+JDECMA+IMA-1)
                 CALL JENUNO (JEXNUM(MAILMA,NUMMA),ZK8(JNOMMA+IMA-1))
 30           CONTINUE
              WRITE (IFM,1040) '     LISTE DES MAILLES : '
              WRITE (IFM,1050) (ZK8(JNOMMA+IMA-1),IMA=1,NBMA)
              DO 40 INO = 1,NBNO
                 NUMNO = ZI(JNOCO+JDECNO+INO-1)
                 CALL JENUNO (JEXNUM(NOEUMA,NUMNO),ZK8(JNOMNO+INO-1))
 40           CONTINUE
              WRITE (IFM,1040) '     LISTE DES NOEUDS  : '
              WRITE (IFM,1050) (ZK8(JNOMNO+INO-1),INO=1,NBNO)
 20        CONTINUE

C
 10     CONTINUE
C
        WRITE (IFM,*)
C
      END IF
C
C ======================================================================
C                    IMPRESSIONS POUR LES DEVELOPPEURS
C ======================================================================
C

      CALL JEEXIN(MAESCL,IECPCO)

      IF ((IECPCO.NE.0).AND.(NIV.GE.2)) THEN
        CALL JEVEUO (CARACF,'L',JCMCF)
        CALL JEVEUO (ECPDON,'L',JECPD)
        CALL JEVEUO (MAESCL,'L',JMAESC)
        CALL JEVEUO (NOESCL,'L',JNOESC)
        CALL JEVEUO (TABFIN,'L',JTABF)
        WRITE (IFM,*)    'CARACF : '
        WRITE (IFM,*)     ZR(JCMCF)
        WRITE (IFM,*)    (ZR(JCMCF+6*(K-1)+1),K=1,NZOCO)
        WRITE (IFM,*)    (ZR(JCMCF+6*(K-1)+2),K=1,NZOCO)
        WRITE (IFM,*)    (ZR(JCMCF+6*(K-1)+3),K=1,NZOCO)
        WRITE (IFM,*)    (ZR(JCMCF+6*(K-1)+4),K=1,NZOCO)
        WRITE (IFM,*)    (ZR(JCMCF+6*(K-1)+5),K=1,NZOCO)
        WRITE (IFM,*)    (ZR(JCMCF+6*(K-1)+6),K=1,NZOCO)
        WRITE (IFM,*)    'ECPDON : '
        WRITE (IFM,*)     ZI(JECPD)
        WRITE (IFM,*)    (ZI(JECPD+5*(K-1)+1),K=1,NZOCO)
        WRITE (IFM,*)    (ZI(JECPD+5*(K-1)+2),K=1,NZOCO)
        WRITE (IFM,*)    (ZI(JECPD+5*(K-1)+3),K=1,NZOCO)
        WRITE (IFM,*)    (ZI(JECPD+5*(K-1)+4),K=1,NZOCO)
        WRITE (IFM,*)    (ZI(JECPD+5*(K-1)+5),K=1,NZOCO)
        WRITE (IFM,*)    'MAESCL : '
        WRITE (IFM,*)     ZI(JMAESC)
        WRITE (IFM,*)    (ZI(JMAESC+3*(K-1)+1),K=1,ZI(JMAESC))
        WRITE (IFM,*)    (ZI(JMAESC+3*(K-1)+2),K=1,ZI(JMAESC))
        WRITE (IFM,*)    (ZI(JMAESC+3*(K-1)+3),K=1,ZI(JMAESC))
        WRITE (IFM,*)    'NOESCL : '
        WRITE (IFM,*)     ZR(JNOESC)
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+1),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+2),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+3),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+4),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+5),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+6),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+7),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+8),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+9),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JNOESC+10*(K-1)+10),K=1,INT(ZR(JNOESC)))
 
        WRITE (IFM,*)    'TABFIN : '
        WRITE (IFM,*)     ZR(JTABF)
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+1),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+2),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+3),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+4),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+5),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+6),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+7),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+8),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+9),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+10),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+11),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+12),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+13),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+14),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+15),K=1,INT(ZR(JNOESC)))
        WRITE (IFM,*)    (ZR(JTABF+16*(K-1)+16),K=1,INT(ZR(JNOESC)))
      ENDIF


      IF (NIV.GE.2) THEN
        
        WRITE (IFM,1080) 'METHCO : '
        WRITE (IFM,*)   ZI(JMETH)
        WRITE (IFM,*)   (ZI(JMETH+ZMETH*(K-1)+1),  K=1,ZI(JMETH))
        WRITE (IFM,*)   (ZI(JMETH+ZMETH*(K-1)+2),  K=1,ZI(JMETH))
        WRITE (IFM,*)   (ZI(JMETH+ZMETH*(K-1)+3),  K=1,ZI(JMETH))
        WRITE (IFM,*)   (ZI(JMETH+ZMETH*(K-1)+4),  K=1,ZI(JMETH))
        WRITE (IFM,*)   (ZI(JMETH+ZMETH*(K-1)+5),  K=1,ZI(JMETH))
        WRITE (IFM,*)   (ZI(JMETH+ZMETH*(K-1)+6),  K=1,ZI(JMETH))
        WRITE (IFM,*)   (ZI(JMETH+ZMETH*(K-1)+7),  K=1,ZI(JMETH))
        WRITE (IFM,*)   (ZI(JMETH+ZMETH*(K-1)+8),  K=1,ZI(JMETH))
        WRITE (IFM,*)   (ZI(JMETH+ZMETH*(K-1)+9),  K=1,ZI(JMETH))



        WRITE (IFM,1080) 'PZONE  : '
        WRITE (IFM,1060) (ZI(JZONE+K),  K=0,NZOCO)

        WRITE (IFM,1080) 'NORLIS  : '
        WRITE (IFM,1060) (ZI(JNORLI+K),  K=0,NZOCO)

        WRITE (IFM,1080) 'PSURMA : '
        WRITE (IFM,1060) (ZI(JSUMA+K),  K=0,NSUCO)

        WRITE (IFM,1080) 'PSURNO : '
        WRITE (IFM,1060) (ZI(JSUNO+K),  K=0,NSUCO)

        WRITE (IFM,1080) 'PNOQUA : '
        WRITE (IFM,1060) (ZI(JNOQUA+K),  K=0,NSUCO)

        WRITE (IFM,1080) 'CONTMA : '
        WRITE (IFM,1060) (ZI(JMACO+K-1),K=1,NMACO)

        WRITE (IFM,1080) 'CONTNO : '
        WRITE (IFM,1060) (ZI(JNOCO+K-1),K=1,NNOCO)


        WRITE (IFM,*)
        WRITE (IFM,2090) '--------------------------------------'
        WRITE (IFM,2090) '  TABLEAUX INVERSES (ROUTINE TABLCO)  '
        WRITE (IFM,2090) '--------------------------------------'
        WRITE (IFM,*)
        WRITE (IFM,2070) 'NMANO  : ',NMANO
        WRITE (IFM,2070) 'NNOMA  : ',NNOMA
        WRITE (IFM,2070) 'NMAMA  : ',NMAMA
        WRITE (IFM,*)
        WRITE (IFM,2080) 'MANOCO : '
        WRITE (IFM,2060) (ZI(JMANO+K-1),K=1,NMANO)
        WRITE (IFM,2080) 'PMANO  : '
        WRITE (IFM,2060) (ZI(JPOMA+K),K=0,NNOCO)
        WRITE (IFM,2080) 'NOMACO : '
        WRITE (IFM,2060) (ZI(JNOMA+K-1),K=1,NNOMA)
        WRITE (IFM,2080) 'PNOMA  : '
        WRITE (IFM,2060) (ZI(JPONO+K),K=0,NMACO)
        WRITE (IFM,2080) 'MAMACO : '
        WRITE (IFM,2060) (ZI(JMAMA+K-1),K=1,NMAMA)
        WRITE (IFM,2080) 'PMAMA  : '
        WRITE (IFM,2060) (ZI(JPOIN+K),K=0,NMACO)
        WRITE (IFM,2080) 'NOZOCO : '
        WRITE (IFM,2060) (ZI(JZOCO+K-1),K=1,NNOCO)
        WRITE (IFM,*)
        WRITE (IFM,2090) '--------------------------------------'
        WRITE (IFM,*)






      END IF
C
C ----------------------------------------------------------------------
C
 1000 FORMAT ('<CONTACT> ',A32,I5)
 1010 FORMAT ('<CONTACT> ',A19,I5,A14)

 1020 FORMAT ('<CONTACT> ',A37,I5)
 1030 FORMAT ('<CONTACT> ',A13,I5,A3,I5,A8,1X,I5,A7)
 1040 FORMAT ('<CONTACT> ',A25)
 1050 FORMAT (('<CONTACT> ',10X,4(A8,1X)))
 1060 FORMAT (('<CONTACT_DVLP> ',9X,8(I5,1X)))
 1070 FORMAT ('<CONTACT_DVLP> ',A9,I5)
 1080 FORMAT ('<CONTACT_DVLP> ',A9)
 1100 FORMAT ('<CONTACT> ',A38)
 1110 FORMAT ('<CONTACT> ',A36)
 1120 FORMAT ('<CONTACT> ',A51,A31)
 1130 FORMAT ('<CONTACT> ',A51,E12.5)
 2060 FORMAT (('<CONTACT_DVLP> ',9X,8 (I5,1X)))
 2070 FORMAT ('<CONTACT_DVLP> ',A9,I5)
 2080 FORMAT ('<CONTACT_DVLP> ',A9)
 2090 FORMAT ('<CONTACT_DVLP> ',A38)
C
      CALL JEDETR('&&SURFCO.TRAVMA')
      CALL JEDETR('&&SURFCO.TRAVNO')
C
      CALL JEDEMA()
      END
