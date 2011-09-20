#@ MODIF compor2 Messages  DATE 20/09/2011   AUTEUR PROIX J-M.PROIX 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY  
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY  
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR     
# (AT YOUR OPTION) ANY LATER VERSION.                                                  
#                                                                       
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT   
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF            
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU      
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.                              
#                                                                       
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE     
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,         
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.        
# ======================================================================
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg={

1 : _("""
   SIMU_POINT_MAT : Le type de DEFORMATION choisi,  <%(k1)s>, est actuellement incompatible avec SUPPORT=POINT.
    On utilise donc SUPPORT=ELEMENT.
"""),

2 : _("""
   SIMU_POINT_MAT : Erreur, on ne peut avoir � la fois SIGM et EPSI impos�s sur la composante <%(k1)s>
"""),

3 : _("""
   SIMU_POINT_MAT : Erreur, on doit avoir une seule composante donn�e parmi  <%(k1)s>
"""),

4 : _("""
   SIMU_POINT_MAT : Probl�me a l'inversion de la matrice jacobienne. 
   On tente de subdiviser le pas de temps
"""),

5 : _("""
   SIMU_POINT_MAT : nombre d'iterations maximum atteint.
   On tente de subdiviser le pas de temps
"""),

6 : _("""
   POLYCRISTAL : nombre de phases trop grand (le nombre maximum de phases vaut actuellement 1000).
   Faire une demande d'�volution pour lever cette limitation si n�cessaire.
"""),

7 : _("""
   SIMU_POINT_MAT : le nombre de variables internes d�passe le maximum : <%(i1)i>
   Faire une demande d'�volution ou modifier NBVIMAX dans OP0033.
"""),

8 : _("""
   DEFI_COMPOR : la somme des fractions volumiques est tr�s diff�rente de 1.0 : <%(r1).15E>
   V�rifiez FRAC_VOL pour toutes les occurrences du mot cl� POLYCRISTAL.
"""),

9 : _("""
Les d�formations deviennent trop grandes : <%(r1)E>
=> GROT_GDEP sous COMP_INCR n'est plus valide.

Pour un calcul en grandes d�foramtion sous COMP_INCR
il faut utiliser GDEF_HYPO_ELAS ou SIMO_MIEHE.

Pour un calcul hyperelastique, utiliser COMP_ELAS.
"""),


10 : _("""
Le red�coupage local du pas de temps n'est pas compatible avec <%(k1)s>
"""),

11 : _("""
La rotation de r�seau n'est pas compatible ave RUNGE_KUTTA. Utiliser l'integration IMPLICITE.
"""),

12 : _("""
  LA LOI ENDO_HETEROGENE N'EST COMPATIBLE QU'AVEC LE MODELE NON LOCAL GRAD_SIGM.
"""),
13 : _("""
  LA MODELISATION GRAD_SIGM N'EST COMPATIBLE QU'AVEC LA LOI ENDO_HETEROGENE.
"""),
14: _("""
 ENDO_HETEROGENE : Les crit�res entre KI et SY ne sont pas respect�s ; baissez KI ou augmentez SY
"""),
}
