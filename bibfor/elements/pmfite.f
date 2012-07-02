      SUBROUTINE PMFITE(NF,NCF,VF,VE,VS)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C -----------------------------------------------------------
C ---  INTEGRATIONS SUR LA SECTION (TENANT COMPTE DU MODULE DE
C                                   CHAQUE FIBRE)
C --- IN : FIBRES
C          NF : NOMBRE DE FIBRES
C          NCF: NOMBRE DE CARACTERISTIQUES SUR CHAQUE FIBRE
C          VF(1,*) : Y FIBRES
C          VF(2,*) : Z FIBRES
C          VF(3,*) : S FIBRES
C          VF(4-6,*) : AUTRES CARACTERISTIQUES
C          VE(*) : E MODULE DES FIBRES

C --- OUT : SECTION
C          VS(1) : INT(E.DS)
C          VS(2) : INT(E.Y.DS)
C          VS(3) : INT(E.Z.DS)
C          VS(4) : INT(E.Y.Y.DS)
C          VS(5) : INT(E.Z.Z.DS)
C          VS(6) : INT(E.Y.Z.DS)
C -----------------------------------------------------------
      INTEGER NF,NCF,I
      REAL*8 VF(NCF,NF),VE(NF),VS(6),ZERO,ESF
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      PARAMETER (ZERO=0.0D+0)
      CHARACTER*2 KNCF

      DO 10 I = 1,6
        VS(I) = ZERO
   10 CONTINUE

      IF (NCF.EQ.3) THEN
C --- ON A 3 CARACTERISTIQUES PAR FIBRE : Y, Z ET S
        DO 20 I = 1,NF
          ESF = VF(3,I)*VE(I)
          VS(1) = VS(1) + ESF
          VS(2) = VS(2) + VF(1,I)*ESF
          VS(3) = VS(3) + VF(2,I)*ESF
          VS(4) = VS(4) + VF(1,I)*VF(1,I)*ESF
          VS(5) = VS(5) + VF(2,I)*VF(2,I)*ESF
          VS(6) = VS(6) + VF(1,I)*VF(2,I)*ESF
   20   CONTINUE
      ELSE IF (NCF.EQ.6) THEN
C --- ON A 6 CARACTERISTIQUES PAR FIBRE : Y, Z, S, IZ, IY ET IYZ
        CALL U2MESS('F','ELEMENTS2_41')
      ELSE
C --- ERREUR SUR NCARFI
        CALL CODENT(NCF,'G',KNCF)
        CALL U2MESK('F','ELEMENTS2_40',1,KNCF)
      END IF

      END
