#@ MODIF compor2 Messages  DATE 25/06/2012   AUTEUR PROIX J-M.PROIX 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

1 : _(u"""
   SIMU_POINT_MAT : Le type de DEFORMATION choisi,  <%(k1)s>, est actuellement incompatible avec SUPPORT=POINT.
    On utilise donc SUPPORT=ELEMENT.
"""),

2 : _(u"""
   SIMU_POINT_MAT : Erreur, on ne peut avoir � la fois SIGM et EPSI impos�s sur la composante <%(k1)s>
"""),

3 : _(u"""
   SIMU_POINT_MAT : Erreur, on doit avoir une seule composante donn�e parmi  <%(k1)s>
"""),

4 : _(u"""
   SIMU_POINT_MAT : Probl�me a l'inversion de la matrice jacobienne. 
   On tente de subdiviser le pas de temps
"""),

5 : _(u"""
   SIMU_POINT_MAT : nombre d'it�rations maximum atteint.
   On tente de subdiviser le pas de temps
"""),

6 : _(u"""
   POLYCRISTAL : nombre de phases trop grand (le nombre maximum de phases vaut actuellement 1000).
   Faire une demande d'�volution pour lever cette limitation si n�cessaire.
"""),

8 : _(u"""
   DEFI_COMPOR : la somme des fractions volumiques est tr�s diff�rente de 1.0 : <%(r1).15E>
   V�rifiez FRAC_VOL pour toutes les occurrences du mot cl� POLYCRISTAL.
"""),

9 : _(u"""
Les d�formations deviennent trop grandes : <%(r1)E>
=> GROT_GDEP sous COMP_INCR n'est plus valide.

Pour un calcul en grandes d�formation sous COMP_INCR
il faut utiliser GDEF_HYPO_ELAS ou SIMO_MIEHE.

Pour un calcul hyper-�lastique, utiliser COMP_ELAS.
"""),


10 : _(u"""
Le red�coupage local du pas de temps n'est pas compatible avec <%(k1)s>
"""),

11 : _(u"""
La rotation de r�seau n'est pas compatible avec RUNGE_KUTTA. Utiliser l'int�gration IMPLICITE.
"""),

12 : _(u"""
  LA LOI ENDO_HETEROGENE N'EST COMPATIBLE QU'AVEC LE MODELE NON LOCAL GRAD_SIGM.
"""),

13 : _(u"""
  LA MODELISATION GRAD_SIGM N'EST COMPATIBLE QU'AVEC LA LOI ENDO_HETEROGENE.
"""),

14: _(u"""
 ENDO_HETEROGENE : Les crit�res entre KI et SY ne sont pas respect�s ; baissez KI ou augmentez SY
"""),

15: _(u"""
 MONOCRISTAL : la matrice d'interaction fournie n'est pas carr�e : nombre lignes = <%(r1)E>, nombre colonnes = <%(r2)E>.
"""),

16: _(u"""
 POLYCRISTAL : Il faut au maximum 5 mono cristaux diff�rents sur l'ensemble des phases.  Ici,il y en a : <%(i1)i>.
"""),

17: _(u"""
 MONOCRISTAL : la matrice d'interaction fournie ne comporte pas le bon nombre de syst�mes.
 il en faut : <%(i1)i>.
"""),

18: _(u"""
 MONOCRISTAL : la matrice d'interaction fournie n'est pas sym�trique.
"""),

19: _(u"""
 MONOCRISTAL : le nombre de composantes de n et m n'est pas correct :  <%(r1)E> au lieu de 6.
"""),

20: _(u"""
 MONOCRISTAL : comme il y a  plusieurs familles de syst�mes de glissement, 
 il faut fournir une matrice d'interaction entre tous ces syst�mes, de dimension  <%(i1)i>
"""),

21: _(u"""
 MONOCRISTAL : pas de matrice jacobienne programm�e actuellement pour  MONO_DD_FAT.
 Utiliser ALGO_INTE='NEWTON_PERT'
"""),

22: _(u"""
   SIMU_POINT_MAT : Le type de DEFORMATION choisi,  <%(k1)s>, est incompatible avec GRAD_IMPOSE.
   GRAD_IMPOSE n'est utilisable qu'avec DEFORMATION='SIMO_MIEHE'.
"""),

23: _(u"""
Mot-clef : %(k1)s - occurrence  %(i1)d : comportement %(k2)s - nombre de variables internes : %(i2)d
Noms des variables internes :"""),

24: _(u"""   V%(i1)d : %(k1)s"""),

25: _(u"""
Pour les noms des variables internes du MONOCRISTAL, voir DEFI_COMPOR."""),

26: _(u"""
MONOCRISTAL : en grandes d�formations, il y a 18 variables internes suppl�mentaires :
Le tableau des variables internes comporte, avant les 3 derni�res variables internes habituelles :
FP : (1,1),(1,2),(1,3),(2,1),(2,2),(2,3),(3,1),(3,2),(3,3),
FE : (1,1),(1,2),(1,3),(2,1),(2,2),(2,3),(3,1),(3,2),(3,3),
"""),

27: _(u"""
Mot-clef : %(k1)s - nombre de grains  %(i1)d : localisation %(k2)s 
nombre d'occurrences de MONOCRISTAL diff�rentes : %(i2)d - nombre de variables internes : %(i3)d
Noms des variables internes :"""),

28: _(u""" A partir de la variable interne %(i1)d : pour chaque grain : """),

29: _(u""" Derni�re variable interne V%(i1)d : %(k1)s"""),

30: _(u""" ... jusqu'� V%(i1)d """),

}
