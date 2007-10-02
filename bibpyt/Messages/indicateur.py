#@ MODIF indicateur Messages  DATE 02/10/2007   AUTEUR MACOCCO K.MACOCCO 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
# RESPONSABLE GNICOLAS G.NICOLAS

def _(x) : return x

cata_msg={

1: _("""
Le choix TOUT = 'OUI' est obligatoire avec l'option %(k1)s.
On ne peut pas faire de calcul de champ d'indicateur d'erreur sur des mailles
ou des groupes de mailles car on doit connaitre tous les voisins.
"""),

2: _("""
Le champ de contraintes n'a pas �t� calcul� sur tout le mod�le.
On ne peut pas calculer l'option %(k1)s pour le num�ro d'ordre %(k2)s.
"""),

3: _("""
On ne peut pas calculer un indicateur d'erreur spatial � l'instant initial.
Revoyez votre liste d'instants de calcul.
Conseil : Faites-la d�marrer au premier instant suivant l'instant initial.
"""),

4: _("""
Attention : on n'a pas pu r�cup�rer le parametre theta dans le resultat %(k1)s.
La valeur prise par d�faut pour theta est 0.57
"""),

5: _("""
Attention : r�cup�ration d'une valeur de theta illicite dans le resultat %(k1)s.
La valeur prise par d�faut pour theta est 1.
"""),

6: _("""
Le calcul de l'indicateur d erreur ne sait pas traiter les charges du type de %(k1)s.
"""),

7: _("""
Le choix %(k1)s apparait au moins dans 2 charges.
"""),

8: _("""
Probleme sur les charges. Consulter la documentation
"""),

11: _("""
Impossible de r�cup�rer les param�tres temporels.
"""),

20: _("""
perm_in: division par z�ro
"""),

21: _("""
La %(k1)s caract�ristique est nulle. On risque la division par z�ro.
"""),



28: _("""
Pour le calcul de l'indicateur d'erreur en THM, il faut fournir
les longueur et pression caract�ristiques.
"""),





31: _("""
deltat: division par z�ro
"""),

38: _("""
type d'element %(k1)s inconnu
"""),

39: _("""
rho liquide: division par z�ro
"""),

41: _("""
Il faut renseigner le mot-clef comp_incr avec elas et liqu_satu
pour calculer l'indicateur d'erreur temporelle.                
"""),

42: _("""
Vous n'utilisez pas une mod�lisation hm satur�e �lastique.
"""),

43: _("""
pression caract�ristique : division par z�ro
"""),

44: _("""
module de Young non d�fini : division par z�ro
"""),

48: _("""
Vous utilisez une mod�lisation THM et vous n'avez pas renseign�
correctement le mot-cl� ERRE_THM.
Conseil : Donner une longueur et une pression caract�ristique 
"""),

90: _("""
La condition %(k1)s est bizarre.
"""),

91: _("""
On ne sait pas traiter la condition %(k1)s.
"""),

98: _("""
L'option %(k1)s est invalide.
"""),

99: _("""
Erreur de programmation dans %(k1)s
L'option %(k2)s ne correspond pas � une option de calcul d'indicateur d'erreur.
"""),

}
