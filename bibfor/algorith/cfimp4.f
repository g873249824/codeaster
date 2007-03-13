      SUBROUTINE CFIMP4(DEFICO,RESOCO,NOMA,IFM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/03/2007   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_20
C
      IMPLICIT     NONE
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO
      INTEGER      IFM
      CHARACTER*8  NOMA
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CFGEOM
C ----------------------------------------------------------------------
C
C IMPRESSION DES INFOS DETAILLES DE L'APPARIEMENT
C
C IN  IFM    : UNITE D'IMPRESSION DU MESSAGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*32 JEXNUM
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
      INTEGER      CFMMVD,ZREAC,ZAPPA,ZAPME
      CHARACTER*24 APPARI,CONTNO,CONTMA,APJEU,NDIMCO,APREAC,APMEMO
      INTEGER      JAPPAR,JNOCO,JMACO,JAPJEU,JDIM,JREAC,JAPMEM
      CHARACTER*24 NORINI,APPOIN,PDDLCO,NORMCO,TANGCO,APDDL,APCOEF
      INTEGER      JNRINI,JAPPTR,JPDDL,JNORMO,JTANGO,JAPDDL,JAPCOE
      CHARACTER*24 APCOFR,PNOMA,NOMACO,COMAFO,FROTE,PENAL
      INTEGER      JAPCOF,JPONO,JNOMA,JCOMA,JFRO,JPENA
      INTEGER      IBID,TYPALF,FROT3D
      INTEGER      NZOCO,NESMAX,NESCL,NNOCO,NDIM
      INTEGER      K,IZONE,INOEUD,IESCL,IDDLE,IMAIT,IDDLM
      INTEGER      NUMNOE,NUMPRM,NUMAPM,NUMESC,NUMMAI,NUMMA2
      INTEGER      POSNOE,POSPRM,POSAPM,POSESC,POSMAI,POSMA2
      CHARACTER*8  NOMNOE,NOMPRM,NOMAPM,NOMESC,NOMMAI,NOMMA2
      INTEGER      JDECE,JDECM
      INTEGER      NDDLT,NDDLE,NDDLM,NBNOM
      CHARACTER*20 CREAC1,TYPNOE
      CHARACTER*13 CREAC2
      CHARACTER*5  CREAC3
      REAL*8       COEFRO,COEFPN,COEFPT,COEFTE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INFOS SUR LA CHARGE DE CONTACT
C
      CALL CFDISC(DEFICO,'              ',IBID,TYPALF,FROT3D,IBID)
C
      APPARI = RESOCO(1:14)//'.APPARI'
      APREAC = RESOCO(1:14)//'.APREAC'
      APDDL  = RESOCO(1:14)//'.APDDL'
      APCOEF = RESOCO(1:14)//'.APCOEF'
      PDDLCO = DEFICO(1:16)//'.PDDLCO'
      NDIMCO = DEFICO(1:16)//'.NDIMCO'
      CONTNO = DEFICO(1:16)//'.NOEUCO'
      CONTMA = DEFICO(1:16)//'.MAILCO'
      APJEU  = RESOCO(1:14)//'.APJEU'
      APMEMO = RESOCO(1:14)//'.APMEMO'
      NORINI = RESOCO(1:14)//'.NORINI'
      APPOIN = RESOCO(1:14)//'.APPOIN'
      NORMCO = RESOCO(1:14)//'.NORMCO'
      TANGCO = RESOCO(1:14)//'.TANGCO'
      NOMACO = DEFICO(1:16)//'.NOMACO'
      PNOMA  = DEFICO(1:16)//'.PNOMACO'
      PENAL  = DEFICO(1:16)//'.PENAL' 
      COMAFO = DEFICO(1:16)//'.COMAFO'
      FROTE  = DEFICO(1:16)//'.FROTE'           
C
      CALL JEVEUO(NDIMCO,'L',JDIM)
      CALL JEVEUO(APPARI,'L',JAPPAR)
      CALL JEVEUO(CONTNO,'L',JNOCO )
      CALL JEVEUO(CONTMA,'L',JMACO )
      CALL JEVEUO(APJEU, 'L',JAPJEU)
      CALL JEVEUO(APREAC,'L',JREAC)
      CALL JEVEUO(APMEMO,'L',JAPMEM)
      CALL JEVEUO(NORINI,'L',JNRINI)
      CALL JEVEUO(APPOIN,'L',JAPPTR)
      CALL JEVEUO(PDDLCO,'L',JPDDL)
      CALL JEVEUO(APDDL,'L',JAPDDL)
      CALL JEVEUO(NORMCO,'L',JNORMO)
      CALL JEVEUO(TANGCO,'L',JTANGO)
      CALL JEVEUO(APCOEF,'L',JAPCOE)
      CALL JEVEUO(PNOMA,'L',JPONO)
      CALL JEVEUO(NOMACO,'L',JNOMA)
      CALL JEVEUO(COMAFO,'L',JCOMA )
      CALL JEVEUO(FROTE ,'L',JFRO  ) 
      CALL JEVEUO(PENAL ,'L',JPENA )           
      IF (TYPALF.NE.0) THEN
        APCOFR = RESOCO(1:14)//'.APCOFR'
        CALL JEVEUO(APCOFR,'L',JAPCOF)
      ENDIF
C
      ZAPME = CFMMVD('ZAPME')
      ZAPPA = CFMMVD('ZAPPA')
      ZREAC = CFMMVD('ZREAC') 
C
C --- DIMENSION DU PROBLEME
C
      NDIM   = ZI(JDIM)                
C
C --- NOMBRE DE ZONES DE CONTACT
C
      NZOCO  = ZI(JDIM+1)
C
C --- NOMBRE MAXIMAL DE NOEUDS ESCLAVES
C
      NESMAX = ZI(JDIM+8)
C
C --- NOMBRE EFFECTIF DE NOEUDS ESCLAVES
C
      NESCL  = ZI(JAPPAR)
C
C --- NOMBRE TOTAL DE NOEUDS ET MAILLES DE CONTACT
C
      NNOCO  = ZI(JDIM+4)

      WRITE(IFM,*) '<CONTACT_DVLP> *** APPARIEMENT *** '
C
C ----------------------------------------------------------------------
C --- INFOS SUR LES ZONES DE CONTACT
C ----------------------------------------------------------------------
C
      WRITE(IFM,*) '<CONTACT_DVLP> ------ ZONES ------ '

      WRITE(IFM,1000) NZOCO
      WRITE(IFM,1001) NESMAX
      WRITE(IFM,1002) NESCL

      DO 20 IZONE = 1,NZOCO

        IF (ZI(JREAC+ZREAC*(IZONE-1)).EQ.0) THEN
         CALL CFIMPA('CFIMP4',2)
        ELSE IF (ZI(JREAC+ZREAC*(IZONE-1)).EQ.-1) THEN
          CREAC1 = ' REMPLISSAGE DES SD '
        ELSE IF (ZI(JREAC+ZREAC*(IZONE-1)).EQ.1) THEN
          CREAC1 = ' DOUBLE BOUCLE      '
        ELSE IF (ABS(ZI(JREAC+ZREAC*(IZONE-1))).EQ.2) THEN
          CREAC1 = ' VOISINAGE          '
        ELSE IF (ABS(ZI(JREAC+ZREAC*(IZONE-1))).EQ.3) THEN
          CREAC1 = ' BOITE              '
        ENDIF

        IF (ABS(ZI(JREAC+ZREAC*(IZONE-1)+2)).EQ.1) THEN
          CREAC2 = ' LINEAIRE    '
        ELSE
          CREAC2 = ' QUADRATIQUE '
        ENDIF

        IF (ABS(ZI(JREAC+ZREAC*(IZONE-1)+1)).GT.0) THEN
          CREAC3 = ' OUI '
        ELSE
          CREAC3 = ' NON '
        ENDIF

        WRITE(IFM,2000) IZONE
        WRITE(IFM,2001) CREAC1
        WRITE(IFM,2002) ZI(JREAC+ZREAC*(IZONE-1)+1)
        WRITE(IFM,2003) CREAC2
        WRITE(IFM,2004) CREAC3

  20  CONTINUE

C
C ----------------------------------------------------------------------
C --- INFOS SUR TOUS LES NOEUDS
C ----------------------------------------------------------------------
C
      WRITE(IFM,*) '<CONTACT_DVLP> ------ NOEUDS DE CONTACT ------ '

      DO 30 INOEUD = 1,NNOCO
        POSNOE = INOEUD
        NUMNOE = ZI(JNOCO+POSNOE-1)
        CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMNOE),NOMNOE)
        IF (ZI(JAPMEM+ZAPME*(INOEUD-1)).EQ.1) THEN
           TYPNOE = 'ESCLAVE             '
        ELSE IF (ZI(JAPMEM+ZAPME*(INOEUD-1)).EQ.0) THEN
           TYPNOE = 'MAITRE              '
        ELSE IF (ZI(JAPMEM+ZAPME*(INOEUD-1)).EQ.-1) THEN
           TYPNOE = 'EXCLU (SANS_NOEUD)  '
        ELSE IF (ZI(JAPMEM+ZAPME*(INOEUD-1)).EQ.-2) THEN
           TYPNOE = 'EXCLU (PIVOT NUL)   '
        ELSE IF (ZI(JAPMEM+ZAPME*(INOEUD-1)).EQ.-3) THEN
           TYPNOE = 'EXCLU (HORS ZONE)   '           
        ELSE
           TYPNOE = 'ETAT INCONNU        '  
        ENDIF

        WRITE(IFM,3000) INOEUD,NOMNOE,TYPNOE
        
        IF (TYPNOE.EQ.'ESCLAVE             ') THEN
          POSPRM = ZI(JAPMEM+ZAPME*(INOEUD-1)+1) 
          IF (POSPRM.NE.0) THEN
            NUMPRM = ZI(JNOCO+POSPRM-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',ABS(NUMPRM)),NOMPRM)
            WRITE(IFM,3001) NOMPRM
          ENDIF
         
          POSAPM = ZI(JAPMEM+ZAPME*(INOEUD-1)+2)  
          IF (POSAPM.NE.0) THEN
            NUMAPM = ZI(JMACO+POSAPM-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',ABS(NUMAPM)),NOMAPM)
            WRITE(IFM,3002) NOMAPM
          ELSE
            WRITE(IFM,3004)
          ENDIF
        ENDIF

        IF (TYPNOE(1:5).NE.'EXCLU') THEN
          WRITE(IFM,3003) (ZR(JNRINI+3*(INOEUD-1)+K-1),K=1,3)
        ENDIF
        
3000  FORMAT (' <CONTACT_DVLP> NOEUD NUMERO ',I6,' (',A8,') -> NOEUD ',
     &           A20)

3001  FORMAT (' <CONTACT_DVLP>  * NOEUD MAITRE PROCHE   : ',A8)
3002  FORMAT (' <CONTACT_DVLP>  * MAILLE MAITRE APPARIEE: ',A8)
3003  FORMAT (' <CONTACT_DVLP>  * NORMALE  : ',3(1PE15.8,2X))
3004  FORMAT (' <CONTACT_DVLP>  * MAILLE MAITRE NON APPARIEE')



  30  CONTINUE
C
C ----------------------------------------------------------------------
C --- INFOS SUR LES NOEUDS ESCLAVES
C ----------------------------------------------------------------------
C
      WRITE(IFM,*) '<CONTACT_DVLP> ----- NOEUDS ESCLAVES ----- '

      DO 40 IESCL = 1,NESCL

        POSESC = ZI(JAPPAR+ZAPPA*(IESCL-1)+1)

        IF (POSESC.EQ.0) GOTO 40
        NUMESC = ZI(JNOCO+POSESC-1)

        CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMESC),NOMESC)
        WRITE(IFM,4000) IESCL,NOMESC
        
        POSAPM = ZI(JAPMEM+ZAPME*(POSESC-1)+2)

        POSMAI = ZI(JAPPAR+ZAPPA*(IESCL-1)+2)
        IF (POSAPM.EQ.0) THEN
          IF (POSMAI.LT.0) THEN   
            NUMMAI = ZI(JNOCO+ABS(POSMAI)-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMMAI),NOMMAI)
            WRITE(IFM,4001) NOMMAI
          ELSE  
            WRITE(IFM,4009)
            GOTO 40
          END IF        
        ELSE
          IF (POSMAI.GT.0) THEN
            NUMMAI = ZI(JMACO+POSMAI-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMMAI',NUMMAI),NOMMAI)
            WRITE(IFM,4002) NOMMAI
          ELSE IF (POSMAI.LT.0) THEN   
            NUMMAI = ZI(JNOCO+ABS(POSMAI)-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMMAI),NOMMAI)
            WRITE(IFM,4001) NOMMAI
          ELSE  
            CALL CFIMPA('CFIMP4',1)
          END IF
        ENDIF
         
        

C --- POSITION DU NOEUD ESCLAVE DANS CONTNO: POSESC
C                         SON NUMERO ABSOLU: NUMESC
C                                   SON NOM: NOMESC

C --- POSITION DE LA MAILLE MAITRE DANS CONTMA: POSMAI
C      SI POSMAI>0 : APPARIEMENT MAITRE ESCLAVE
C        -> LA MAILLE MAITRE EST UNE MAILLE !
C                           SON NUMERO ABSOLU : NUMMAI
C                                      SON NOM: NOMMAI
C      SI POSMAI<0 : APPARIEMENT NODAL
C        -> LA MAILLE MAITRE EST UN NOEUD !
C                           SON NUMERO ABSOLU : NUMMAI
C                                      SON NOM: NOMMAI
C      SI POSMAI=0 : PAS APPARIEMENT 
C        -> PAS DE MAILLE MAITRE !
C                           SON NUMERO ABSOLU : NON-SENS !
C                                      SON NOM: NON-SENS !
        JDECE = ZI(JAPPTR+IESCL-1)
C
C --- NOMBRE DE DDL TOTAL: NDDLT
C
        NDDLT = ZI(JAPPTR+IESCL) - ZI(JAPPTR+IESCL-1)
C
C --- NOMBRE DE DDL POUR NOEUD ESCLAVE
C
        NDDLE = ZI(JPDDL+POSESC) - ZI(JPDDL+POSESC-1)
C
C --- AFFICHAGES
C
        WRITE(IFM,4004) NDDLT,NDDLE
        WRITE(IFM,4006) ZR(JAPJEU+IESCL-1)
        WRITE(IFM,4007) (ZR(JNORMO+3*(IESCL-1)+K-1),K=1,3)
        WRITE(IFM,4008) (ZR(JTANGO+6*(IESCL-1)+K-1),K=1,3)
        IF (NDIM.EQ.3) THEN
          WRITE(IFM,5008) (ZR(JTANGO+6*(IESCL-1)+K-1+3),K=1,3)
        ENDIF
C ----------------------------------------------------------------------
C --- PARAMETRES PENALISATION
C ----------------------------------------------------------------------

        COEFRO = ZR(JFRO-1+IESCL)     
        COEFPN = ZR(JPENA-1+2*IESCL-1) 
        COEFPT = ZR(JPENA-1+2*IESCL)  
        COEFTE = ZR(JCOMA-1+IESCL)         
 
 
        WRITE(IFM,7000) COEFPN
        WRITE(IFM,7001) COEFPT
        WRITE(IFM,7002) COEFTE
        WRITE(IFM,7003) COEFRO
        
C
C ----------------------------------------------------------------------
C --- DDL ET COEF POUR NOEUD ESCLAVE
C ----------------------------------------------------------------------
C
C
C --- COEFFICIENTS POUR CONTACT
C
        IF (NDIM.EQ.3) THEN
          WRITE (IFM,4015) NOMESC,
     &      (ZI(JAPDDL+JDECE+IDDLE-1),IDDLE=1,NDDLE),
     &      (ZR(JAPCOE+JDECE+IDDLE-1),IDDLE=1,NDDLE)
        ELSE
          WRITE (IFM,4018) NOMESC,
     &      (ZI(JAPDDL+JDECE+IDDLE-1),IDDLE=1,NDDLE),
     &      (ZR(JAPCOE+JDECE+IDDLE-1),IDDLE=1,NDDLE)        
        ENDIF
C
C --- COEFFICIENTS POUR FROTTEMENT 
C
        IF (TYPALF.NE.0) THEN
          IF (NDIM.EQ.3) THEN
            WRITE (IFM,4016) NOMESC,
     &        (ZI(JAPDDL+JDECE+IDDLE-1),IDDLE=1,NDDLE),
     &        (ZR(JAPCOF+JDECE+IDDLE-1),IDDLE=1,NDDLE)
            WRITE (IFM,4017) NOMESC,
     &        (ZI(JAPDDL+JDECE+IDDLE-1),IDDLE=1,NDDLE),
     &        (ZR(JAPCOF+30*NESMAX+JDECE+IDDLE-1),IDDLE=1,NDDLE)     
          ELSE
            WRITE (IFM,4019) NOMESC,
     &        (ZI(JAPDDL+JDECE+IDDLE-1),IDDLE=1,NDDLE),
     &        (ZR(JAPCOF+JDECE+IDDLE-1),IDDLE=1,NDDLE)        
          ENDIF
        ENDIF
C
C ----------------------------------------------------------------------
C --- DDL ET COEF POUR NOEUDS MAITRES
C ----------------------------------------------------------------------
C
        JDECM  = JDECE + NDDLE
C 
C --- APPARIEMENT NODAL
C
        IF (POSMAI.LT.0) THEN  
          NBNOM  = 1
          POSMAI = ABS(POSMAI)
          IMAIT  = 1
          NDDLM  = NDDLT - NDDLE
C
C --- COEFFICIENTS POUR CONTACT
C          
          IF (NDIM.EQ.3) THEN
            WRITE (IFM,5011) NOMMAI,
     &        (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM),
     &        (ZR(JAPCOE+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM) 
          ELSE
            WRITE (IFM,6011) NOMMAI,
     &        (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM),
     &        (ZR(JAPCOE+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM)
          ENDIF
C
C --- COEFFICIENTS POUR FROTTEMENT 
C
          IF (TYPALF.NE.0) THEN
            IF (NDIM.EQ.3) THEN
              WRITE (IFM,5012) NOMMAI,
     &         (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM),
     &         (ZR(JAPCOE+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM)
              WRITE (IFM,5013) NOMMAI,
     &          (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),
     &                        IDDLM=1,NDDLM),
     &          (ZR(JAPCOF+30*NESMAX+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),
     &                        IDDLM=1,NDDLM)
            ELSE
              WRITE (IFM,6012) NOMMAI,
     &         (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM),
     &         (ZR(JAPCOE+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM)
            ENDIF
          ENDIF
C 
C --- APPARIEMENT MAITRE/ESCLAVE
C
        ELSE IF (POSMAI.GT.0) THEN
          NBNOM = ZI(JPONO+POSMAI) - ZI(JPONO+POSMAI-1)
          NDDLM = ZI(JPDDL+POSMAI) - ZI(JPDDL+POSMAI-1)
          DO 50 IMAIT = 1,NBNOM    
            POSMA2 = ZI(JNOMA+ZI(JPONO+POSMAI-1)+IMAIT-1)
            NUMMA2 = ZI(JNOCO+POSMA2-1)
            CALL JENUNO(JEXNUM(NOMA//'.NOMNOE',NUMMA2),NOMMA2)
C
C --- COEFFICIENTS POUR CONTACT
C             
            IF (NDIM.EQ.3) THEN
              WRITE (IFM,5001) NOMMAI,NOMMA2,
     &        (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM),
     &        (ZR(JAPCOE+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM)
            ELSE
              WRITE (IFM,6001) NOMMAI,NOMMA2,
     &        (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM),
     &        (ZR(JAPCOE+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM)
            ENDIF
C
C --- COEFFICIENTS POUR FROTTEMENT 
C
            IF (TYPALF.NE.0) THEN
              IF (NDIM.EQ.3) THEN            
                WRITE (IFM,5002) NOMMAI,NOMMA2,
     &         (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM),
     &         (ZR(JAPCOE+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM)
                WRITE (IFM,5003) NOMMAI,NOMMA2,
     &            (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),
     &                        IDDLM=1,NDDLM),
     &            (ZR(JAPCOF+30*NESMAX+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),
     &                        IDDLM=1,NDDLM)
              ELSE
                WRITE (IFM,6002) NOMMAI,NOMMA2,
     &         (ZI(JAPDDL+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM),
     &         (ZR(JAPCOE+JDECM+(IMAIT-1)*NDDLM+IDDLM-1),IDDLM=1,NDDLM)
              ENDIF
            ENDIF
   50     CONTINUE

        ENDIF
     
  40  CONTINUE
C
1000  FORMAT (' <CONTACT_DVLP> NOMBRE DE ZONES DE CONTACT: ',I6)
1001  FORMAT (' <CONTACT_DVLP> NOMBRE MAXIMAL DE NOEUDS ESCLAVES: ',I6)
1002  FORMAT (' <CONTACT_DVLP> NOMBRE EFFECTIF DE NOEUDS ESCLAVES: ',I6)

2000  FORMAT (' <CONTACT_DVLP> ZONE DE CONTACT NUMERO ',I6)

2001  FORMAT (' <CONTACT_DVLP>   * APPARIEMENT : ',A20)
2002  FORMAT (' <CONTACT_DVLP>   * APPARIEMENT FIXE ',I6,
     &            ' FOIS')
2003  FORMAT (' <CONTACT_DVLP>   * PROJECTION ',A13)
2004  FORMAT (' <CONTACT_DVLP>   * REACTUALISATION GEOMETRIE/NORMALES:',
     &            A5)



4000  FORMAT (' <CONTACT_DVLP> NOEUD ESCLAVE NUMERO ',I6,' (',
     &        A8,')') 

4001  FORMAT (' <CONTACT_DVLP>  * APPARIEMENT AVEC NOEUD  ',A8)
4002  FORMAT (' <CONTACT_DVLP>  * APPARIEMENT AVEC MAILLE ',A8)
4004  FORMAT (' <CONTACT_DVLP>  * NOMBRE DE DDLs : ',I6,' DONT ',I6,
     &                        ' POUR NOEUD ESCLAVE',I6)

4006  FORMAT (' <CONTACT_DVLP>  * JEU: ',1PE15.8)
4007  FORMAT (' <CONTACT_DVLP>  * NORMALE LISSEE/MOYENNEE: ',
     &         3(1PE15.8,2X))
4008  FORMAT (' <CONTACT_DVLP>  * TANGENTE DIRECTION 1   : ',
     &         3(1PE15.8,2X))
5008  FORMAT (' <CONTACT_DVLP>  * TANGENTE DIRECTION 2   : ',
     &         3(1PE15.8,2X))

4009  FORMAT (' <CONTACT_DVLP>  * PREMIER APPARIEMENT ')

C
C --- 3D - ESCLAVE
C
4015  FORMAT ((' <CONTACT_DVLP>  * DDL ESCL. CONTACT ( ',A8,'):',
     &           3(I8,2X),' / ',
     &           3(1PE15.8,2X)))

4016  FORMAT ((' <CONTACT_DVLP>  * DDL ESCL. FROT1   ( ',A8,'):',
     &           3(I8,2X),' / ',
     &           3(1PE15.8,2X)))
4017  FORMAT ((' <CONTACT_DVLP>  * DDL ESCL. FROT2   ( ',A8,'):',
     &           3(I8,2X),' / ',
     &           3(1PE15.8,2X)))
     
C
C --- 2D - ESCLAVE
C     
4018  FORMAT ((' <CONTACT_DVLP>  * DDL ESCL. CONTACT ( ',A8,'):',
     &           2(I8,2X),' / ',
     &           2(1PE15.8,2X)))

4019  FORMAT ((' <CONTACT_DVLP>  * DDL ESCL. FROT1   ( ',A8,'):',
     &           2(I8,2X),' / ',
     &           2(1PE15.8,2X)))
   
C
C --- 3D MAITRE/ESCL - MAITRE
C
5001  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. CONTACT ( ',A8,
     &           '/',A8,'):',
     &           3(I8,2X),' / ',
     &           3(1PE15.8,2X)))
5002  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. FROT1   ( ',A8,
     &           '/',A8,'):',
     &           3(I8,2X),' / ',
     &           3(1PE15.8,2X)))
5003  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. FROT2   ( ',A8,
     &           '/',A8,'):',
     &           3(I8,2X),' / ',
     &           3(1PE15.8,2X)))
C
C --- 3D NODAL - MAITRE
C    
5011  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. CONTACT ( ',A8,'):',
     &           3(I8,2X),' / ',
     &           3(1PE15.8,2X)))
5012  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. FROT1   ( ',A8,'):',
     &           3(I8,2X),' / ',
     &           3(1PE15.8,2X)))
5013  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. FROT2   ( ',A8,'):',
     &           3(I8,2X),' / ',
     &           3(1PE15.8,2X)))  
C
C --- 2D MAITRE/ESCL - MAITRE
C     
6001  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. CONTACT ( ',A8,
     &           '/',A8,'):',
     &           2(I8,2X),' / ',
     &           2(1PE15.8,2X)))
6002  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. FROT1   ( ',A8,
     &           '/',A8,'):',
     &           2(I8,2X),' / ',
     &           2(1PE15.8,2X)))
C
C --- 2D NODAL - MAITRE
C
6011  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. CONTACT ( ',A8,'):',
     &           2(I8,2X),' / ',
     &           2(1PE15.8,2X)))
6012  FORMAT ((' <CONTACT_DVLP>  * DDL MAIT. FROT1   ( ',A8,'):',
     &           2(I8,2X),' / ',
     &           2(1PE15.8,2X)))
C
C --- PENALISATION
C
7000  FORMAT (' <CONTACT_DVLP>  * E_N              :',1PE15.8)
7001  FORMAT (' <CONTACT_DVLP>  * E_T              :',1PE15.8)
7002  FORMAT (' <CONTACT_DVLP>  * COEF_MATR_FROT   :',1PE15.8)
7003  FORMAT (' <CONTACT_DVLP>  * COULOMB          :',1PE15.8)
C
      
C
      CALL JEDEMA()
C
      END
