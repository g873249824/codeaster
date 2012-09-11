      SUBROUTINE OP5901(NBOCCM,IFM,NIV,COMPOR)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 10/09/2012   AUTEUR PROIX J-M.PROIX 
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
C RESPONSABLE PROIX J.M.PROIX
C     COMMANDE:  DEFI_COMPOR MONOCRISTAL
      INCLUDE 'jeveux.h'
      CHARACTER*8  COMPOR, MATERI, TYPPAR(5),CHAINE
      CHARACTER*16 NOMPAR(5), ECOULE, ECROIS, ECROCI,ELASTI,NOMVAR(200)
      CHARACTER*16 FASYGL, NOMS(6),COMDES,ROTA,TBINTE,SYSTGL
      CHARACTER*19 LISTR
      REAL*8 MS(6),NG(3),Q(3,3),LG(3),PGL(3,3)
      COMPLEX*16 CBID
      INTEGER IARG,IFM,NIV,NBTBSG, NUMS(2),INDROT,INDVAR
      INTEGER IOCC, NBMAT, NBECOU, NBECRO, NBCINE, NBELAS, NBFASY
      INTEGER I,J,NBELA1, NBSYS, NVI,IMK,IMI,IPR,ITAB,ITSG,IRRA,IRR2
      INTEGER NCPRR,IR,IROTA,IADLR,DECAL,NBROTA,NBSYST,TABDES(13),NBOCCM



      CALL JEMARQ()

      COMDES='&&OP0059.TABLETX'
      CALL TBCRSD(COMDES,'V')
      NOMPAR(1)='FAMI_SYST_GLIS'
      NOMPAR(2)='MAT_SYST'
      NOMPAR(3)='ECOULEMENT'
      NOMPAR(4)='ECRO_ISOT'
      NOMPAR(5)='ECRO_CINE'
      TYPPAR(1)='K16'
      TYPPAR(2)='K16'
      TYPPAR(3)='K16'
      TYPPAR(4)='K16'
      TYPPAR(5)='K16'
      NBSYST=0
      NBELAS=0
      NVI=6
C     DEFORMATION PLASTIQUE CUMULEE MACROSCOPIQUE EQUIVALENTE
      NVI=NVI+1
      CALL TBAJPA(COMDES, 5,NOMPAR,TYPPAR)
      CALL GETFAC('MONOCRISTAL',NBOCCM)
      CALL WKVECT(COMPOR//'.CPRK', 'G V K16',5*NBOCCM+1,IMK)
C     DIMENSION MAX DE CPRR : 1812 = 12+5*6*30+30*30   
C     ORGANISATION DE CPRR :
C     1 : NB TABLES SYST GLIS
C     2 : POSITION DE LA TABLE D'INTERACTION. 0 SINON
C     3 : NOMBRE DE SYSTEMES TABLE  1
C     4 : POSITION DE LA TABLE  1,   
C     5 : NOMBRE DE SYSTEMES TABLE 2 
C     6 : POSITION DE LA TABLE  2  
C     ...
C     CPRR(4)   : TABLE DE SYS GLIS1 (6*NSYS1 VALEURS)
C     CPRR(6)    : TABLE DE SYS GLIS2 (6*NSYS2 VALEURS)
C     ...
C     CPRR(2)    : TABLE D'INTERACTION (NBSYST*NBSYST VALEURS)
      NCPRR=1812
      CALL WKVECT(COMPOR//'.CPRR', 'G V R',NCPRR,IPR)         
      NBTBSG=0
      DECAL=12
      DO 101 I=1,13
         TABDES(I)=0
 101  CONTINUE
      IRRA=0
      IRR2=0
      
      DO 9 IOCC=1,NBOCCM
         CALL GETVID('MONOCRISTAL','MATER',IOCC,IARG,1,MATERI,NBMAT)
         CALL GETVTX('MONOCRISTAL','ECOULEMENT',IOCC,IARG,1,ECOULE,
     &                NBECOU)
         CALL GETVTX('MONOCRISTAL','ECRO_ISOT',IOCC,IARG,1,ECROIS,
     &                NBECRO)
         CALL GETVTX('MONOCRISTAL','ECRO_CINE',IOCC,IARG,1,ECROCI,
     &                NBCINE)
         CALL GETVTX('MONOCRISTAL','ELAS',IOCC,IARG,1,ELASTI,NBELA1)
         IF (NBELA1.GT.0) THEN
            IF (NBELAS.EQ.0) THEN
               NBELAS=1
            ELSE
               CALL U2MESS('F','MODELISA5_64')
            ENDIF
         ENDIF
C        CAS DES LOIS DD
         IF (ECOULE(1:7).EQ.'MONO_DD')  THEN
            ECROIS=ECOULE
            ECROCI=' '
         ENDIF
C        CAS DES LOIS DD_CC_IRRA
         IF (ECOULE.EQ.'MONO_DD_CC_IRRA')  THEN
            IRRA=IRRA+1
         ENDIF
C        CAS DES LOIS DD_CFC_IRRA
         IF (ECOULE.EQ.'MONO_DD_CFC_IRRA')  THEN
            IRR2=IRR2+1
         ENDIF

         CALL GETVTX('MONOCRISTAL','FAMI_SYST_GLIS',IOCC,IARG,1,
     &                FASYGL,NBFASY)
         NOMS(1)=FASYGL
         NOMS(2)=MATERI
         NOMS(3)=ECOULE
         NOMS(4)=ECROIS
         NOMS(5)=ECROCI
         IF (FASYGL.EQ.'UTILISATEUR') THEN
            CALL GETVID('MONOCRISTAL','TABL_SYST_GLIS',IOCC,IARG,1,
     &                   SYSTGL,ITSG)
            NOMS(1)='UTIL'
            NBTBSG=NBTBSG+1
            CALL CODENT(NBTBSG,'G',NOMS(1)(5:5))
            NOMS(1)(6:8)='___'
            NOMS(1)(9:16)=SYSTGL(1:8)
            FASYGL=NOMS(1)
            LISTR = '&&LCMMAT.TABL_SYSGL'
            CALL TBEXLR ( SYSTGL, LISTR, 'V' )
            CALL JEVEUO ( LISTR//'.VALE' , 'L', IADLR )
            NBSYS=NINT(ZR(IADLR+2))
C           VERIF QUE LA MATRICE EST CARREE
            IF (6.NE.ZR(IADLR+1)) THEN
               CALL U2MESG('F','COMPOR2_19',0,' ',0,0,1,ZR(IADLR+1))
            ENDIF
            ZR(IPR+2+2*(NBTBSG-1))  =NBSYS
            ZR(IPR+2+2*(NBTBSG-1)+1)=DECAL+1
            CALL DCOPY(6*NBSYS,ZR(IADLR+3),1,ZR(IPR+DECAL),1)
            TABDES(8+IOCC)=NBSYS
            CALL JEDETC('V',LISTR,1 )
            
            IF (NIV.EQ.2) THEN              
               WRITE(IFM,*) ' TABLE SYSTEMES DE GLISSEMENT FAMILLE',IOCC
               WRITE(IFM,*) ' NX     NY     NZ     MX     MY     MZ '
               DO 4 I=1,NBSYS
                  WRITE(IFM,'(I2,6(1X,E11.4))') 
     &               I,(ZR(IPR-1+DECAL+6*(I-1)+J),J=1,6)
 4             CONTINUE
            ENDIF
            
            DECAL=DECAL+6*NBSYS 
            
         ELSE
            IR=0
            CALL LCMMSG(FASYGL,NBSYS,0,PGL,MS,NG,LG,IR,Q)
         ENDIF
         
         CALL TBAJLI(COMDES,5, NOMPAR,0,0.D0,CBID,NOMS,0)
         DO 11 J=1,5
            ZK16(IMK-1+(IOCC-1)*5+J)=NOMS(J)
11       CONTINUE
         IR=0
         NVI=NVI+4*NBSYS
         NBSYST=NBSYST+NBSYS

9     CONTINUE

      ZR(IPR)=NBTBSG
      ZR(IPR+1)=DECAL+1
C     INDICATEUR PLASTIQUE
      NVI=NVI+1
C     CONTRAINTE DE CLIVAGE MAX
      NVI=NVI+1
C     ROTATION DE RESEAU
      CALL GETVTX(' ','ROTA_RESEAU',0,IARG,1,ROTA,NBROTA)
      IROTA=0
      IF (NBROTA.NE.0) THEN
          IF (ROTA.NE.'NON') THEN
              IF (ROTA.EQ.'POST') IROTA=1
              IF (ROTA.EQ.'CALC') IROTA=2
          ENDIF
          IF (IROTA.GT.0) NVI = NVI+16
      ENDIF
C     RHO_IRR       
      IF (IRRA.GT.0) THEN
         NVI=NVI+12*NBOCCM
      ENDIF
C     RHO_IRR       
      IF (IRR2.GT.0) THEN
         NVI=NVI+24*NBOCCM
      ENDIF
      
      NOMS(1)='MONOCRISTAL'
      NOMS(2)=ECOULE
      NUMS(1)=NBOCCM
      NUMS(2)=NVI
      CALL U2MESG('I','COMPOR2_23',2,NOMS,2,NUMS,0,0.D0)
      
      NOMVAR(1)='EPSPXX'
      NOMVAR(2)='EPSPYY'
      NOMVAR(3)='EPSPZZ'
      NOMVAR(4)='EPSPXY'
      NOMVAR(5)='EPSPXZ'
      NOMVAR(6)='EPSPYZ'
      DO 554 I=1,NBSYST
         CALL CODENT(I,'G',CHAINE)
         NOMVAR(6+3*I-2)='ALPHA'//CHAINE
         NOMVAR(6+3*I-1)='GAMMA'//CHAINE
         NOMVAR(6+3*I  )='P'//CHAINE
 554  CONTINUE
      IF (IRRA.GT.0) THEN
         DO 557 I=1,12*NBOCCM
            CALL CODENT(I,'G',CHAINE)
            NOMVAR(6+3*NBSYST+I)='RHO_IRRA_'//CHAINE
 557     CONTINUE
      ENDIF
      
      IF (IRR2.GT.0) THEN
         DO 559 I=1,12*NBOCCM
            CALL CODENT(I,'G',CHAINE)
            NOMVAR(6+3*NBSYST+I)='RHO_LOOPS_'//CHAINE
            CALL CODENT(I,'G',CHAINE)
            NOMVAR(6+4*NBSYST+I)='PHI_VOIDS_'//CHAINE
 559     CONTINUE
      ENDIF
      
      INDVAR=6+3*NBSYST
      IF (IRRA.GT.0) INDVAR=INDVAR+12*NBOCCM
      
      IF (IRR2.GT.0) INDVAR=INDVAR+24*NBOCCM
      
      IF (IROTA.GT.0) THEN
         DO 556 I=1,16
            CALL CODENT(I,'G',CHAINE)
            NOMVAR(INDVAR+I)='ROTA_'//CHAINE
 556     CONTINUE
         INDVAR=INDVAR+16
      ENDIF
      
      DO 558 I=1,NBSYST
         CALL CODENT(I,'G',CHAINE)
         NOMVAR(INDVAR+I)='TAU_'//CHAINE
 558  CONTINUE

      NOMVAR(NVI-2)='SIGM_CLIV'
      NOMVAR(NVI-1)='EPSPEQ'
      NOMVAR(NVI)='NBITER'
      
      DO 555 I=1,NVI
        CALL U2MESG('I','COMPOR2_24',1,NOMVAR(I),1,I,0,0.D0)
 555  CONTINUE
      
      
      ZK16(IMK+5*NBOCCM)=ELASTI         
      CALL GETVID(' ','MATR_INTER',0,IARG,1,TBINTE,ITAB)
      IF (ITAB.NE.0) THEN
         LISTR = '&&LCMMAT.TABL_INTER'
         CALL TBEXLR ( TBINTE, LISTR, 'V' )
         CALL JEVEUO ( LISTR//'.VALE' , 'L', IADLR )
C        VERIF QUE LA MATRICE EST CARREE
         IF (ZR(IADLR+1).NE.ZR(IADLR+2)) THEN
            CALL U2MESG('F','COMPOR2_15',0,' ',0,0,2,ZR(IADLR+1))
         ENDIF
C        VERIF QUE LE NB DE SYST EST OK
         IF (ZR(IADLR+1).NE.NBSYST) THEN
            CALL U2MESG('F','COMPOR2_17',0,' ',1,NBSYST,0,0.D0)
         ENDIF
         CALL DCOPY(NBSYST*NBSYST,ZR(IADLR+3),1,ZR(IPR+DECAL),1)
C        VERIF QUE LA MATRICE EST SYMETRIQUE
         DO 5 I=1,NBSYST
         DO 5 J=1,NBSYST
            IF (ZR(IPR-1+DECAL+NBSYST*(I-1)+J).NE.
     &          ZR(IPR-1+DECAL+NBSYST*(J-1)+I)) THEN
               CALL U2MESS('F','COMPOR2_18')
            ENDIF
 5       CONTINUE
         CALL JEDETC('V',LISTR,1 )

         IF (NIV.EQ.2) THEN
            WRITE(IFM,*) ' MATRICE INTERACTION UTILISATEUR'
            DO 6 I=1,NBSYST
               WRITE(IFM,'(I2,12(1X,E11.4))') 
     &            I,(ZR(IPR-1+DECAL+NBSYST*(I-1)+J),J=1,NBSYST)
 6          CONTINUE
         ENDIF
      ELSE
         IF (NBOCCM.GT.1) THEN
            CALL U2MESG('F','COMPOR2_20',0,' ',1,NBSYST,0,0.D0)
         ENDIF
      ENDIF
      TABDES(1)=1
      TABDES(2)=1
      TABDES(3)=NVI
      TABDES(4)=ITAB
      TABDES(5)=NBOCCM
      TABDES(6)=IROTA
      TABDES(7)=NVI
      TABDES(8)=NBSYST 
              
C     organisation de CPRI :
C     1 : TYPE =1 pour MONOCRISTAL
C     2 : NBPHAS=1 pour MONOCRISTAL
C     3 : NVI
C     4 : NOMBRE DE MONOCRISTAUX différents  =1
C     5 : NBFAMILLES DE SYS GLIS
C     6 : 1 si ROTA=POST, 2 si CALC, 0 sinon
C     7 : NVI
C     8 : NOMBRE DE SYSTEMES DE GLISSEMENT TOTAL

      CALL WKVECT(COMPOR//'.CPRI', 'G V I',13,IMI)
      DO 999 I=1,13
         ZI(IMI+I-1)=TABDES(I)
999   CONTINUE
      CALL JEDETC('V',COMDES,1)
      
C FIN ------------------------------------------------------------------

      CALL JEDEMA()
      END
