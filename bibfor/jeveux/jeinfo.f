      SUBROUTINE JEINFO(RVAL)
      IMPLICIT NONE
      REAL*8           RVAL(9)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF JEVEUX  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C TOLE CRS_512
C RESPONSABLE LEFEBVRE J-P.LEFEBVRE
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
C     RENVOIE LA VALEUR EN MEGA OCTETS DE LA MEMOIRE UTILISEE PAR JEVEUX
C     RVAL(1) = TAILLE EN MO CUMULEE UTISEE
C     RVAL(2) = TAILLE EN MO MAXIMUM UTILISEE AU COURS DE L'EX�CUTION
C     RVAL(3) = TAILLE EN MO CUMULEE ALLOUEE DYNAMIQUEMENT
C     RVAL(4) = TAILLE EN MO MAXIMUM ALLOUEE DYNAMIQUEMENT
C     RVAL(5) = LIMITE MAXIMALE POUR L'ALLOCATION DYNAMIQUE
C     RVAL(6) = TAILLE EN MO POUR VmData
C     RVAL(7) = TAILLE EN MO POUR VmSize
C     RVAL(8) = NOMBRE DE MISE EN OEUVRE DU MECANISME DE LIBERATION 
C     RVAL(9) = TAILLE EN MO POUR VmPeak
C DEB ------------------------------------------------------------------
      REAL *8          SVUSE,SMXUSE   
      COMMON /STATJE/  SVUSE,SMXUSE  
      REAL *8          MXDYN , MCDYN , MLDYN , VMXDYN , LGIO   
      COMMON /RDYNJE/  MXDYN , MCDYN , MLDYN , VMXDYN , LGIO(2) 
      INTEGER          ICDYN , MXLTOT
      COMMON /XDYNJE/  ICDYN , MXLTOT
C FIN ------------------------------------------------------------------
      INTEGER LOISEM,IV(3),IVAL
C-----------------------------------------------------------------------
      INTEGER MEMPID 
C-----------------------------------------------------------------------
      IV(1) = 0
      IV(2) = 0
      IV(3) = 0
      RVAL(1) = (SVUSE*LOISEM())/(1024*1024)
      RVAL(2) = (SMXUSE*LOISEM())/(1024*1024)
      RVAL(3) =  MCDYN  /(1024*1024)
      RVAL(4) =  VMXDYN /(1024*1024)
      RVAL(5) =  MXDYN  /(1024*1024)
      IVAL    =  MEMPID(IV)
C       IV(1) VmData
C       IV(2) VmSize
      IF ( IVAL .NE. -1 ) THEN 
        RVAL(6) = DBLE(IV(1))
        RVAL(7) = DBLE(IV(2))
        RVAL(9) = DBLE(IV(3))
      ELSE
        RVAL(6) = 0.D0
        RVAL(7) = 0.D0
        RVAL(9) = 0.D0
      ENDIF
      RVAL(8) = DBLE(ICDYN)
            
      END      
