#@ MODIF contact Messages  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
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

def _(x) : return x

cata_msg = {

1 : _("""
Contact m�thodes discr�tes.
 -> Les m�thodes de contact discr�tes supposent la sym�trie de la matrice obtenue apr�s assemblage.
    Si votre mod�lisation produit une matrice non-sym�trique, on force donc sa sym�trie pour r�soudre
    le contact.
 -> Risque & Conseil :
    Ce changement peut conduire � des difficult�s de convergence dans le processus de Newton mais en
    aucun cas il ne produit des r�sultats faux.
    
    Si la matrice de rigidit� de votre structure est sym�trique, vous pouvez ignorer ce qui pr�c�de.
    Enfin, il est possible de supprimer l'affichage de cette alarme en renseignant SYME='OUI'
    sous le mot-cl� facteur SOLVEUR.
"""),

2 : _("""
Contact methode GCP. Nombre d'it�rations maximal (%(i1)s) d�pass� pour le GCP.
Vous pouvez essayer d'augmenter ITER_GCP_MAXI.
La liste des noeuds pr�sentant une interp�n�tration est donn�e ci-dessous.
"""),

3 : _("""
Contact methode GCP. Nombre d'it�rations maximal (%(i1)s) d�pass� pour le pr�conditionneur.
Vous pouvez essayer d'augmenter ITER_PRE_MAXI
"""),

6 : _("""
Contact methode GCP. On ne peut utiliser le solveur GCPC avec le contact. 
"""),

7 : _("""
Contact methode GCP. Le pas d'avancement est negatif ; risque de comportement hasardeux de l'algorithme
"""),

9 : _("""
Contact liaison glissiere. Des noeuds se d�collent plus que la valeur d'ALARME_JEU:
"""),

13 : _("""
La normale que vous avez pr�d�finie (VECT_* = 'FIXE') sur le noeud %(k1)s est colin�aire � la tangente � la maille.
"""),

14 : _("""
La normale que vous avez pr�d�finie (VECT_* = 'FIXE') sur la maille %(k1)s est colin�aire � la tangente � la maille.
"""),

15 : _("""
Le vecteur MAIT_FIXE ou ESCL_FIXE est nul !
"""),

16 : _("""
Le vecteur MAIT_VECT_Y ou ESCL_VECT_Y est nul !
"""),

60 : _("""
La maille %(k1)s est de type 'SEG' (poutres) en 3D sans donner la normale pour l'appariement.
Vous devez utilisez l'option NORMALE:
- FIXE: qui d�crit une normale constante pour la poutre
- ou VECT_Y: qui d�crit une normale par construction d'un rep�re bas� sur la tangente (voir documentation)
"""),

61 : _("""
Le noeud %(k1)s fait partie d'une maille de type 'SEG' (poutres) en 3D sans donner la normale pour l'appariement.
Vous devez utilisez l'option NORMALE:
- FIXE: qui d�crit une normale constante pour la poutre
- ou VECT_Y: qui d�crit une normale par construction d'un rep�re bas� sur la tangente (voir documentation)
"""),

75 : _("""
Contact m�thodes discr�tes. Un POI1 ne peut pas etre une maille maitre.
"""),

83 : _("""
Il y a plusieurs charges contenant des conditions de contact.
"""),

84 : _("""
Le mod�le m�langent des mailles avec des mod�lisations de dimensions 
diff�rentes (2D avec 3D ou macro-�l�ments).
A ce moment du fichier de commande, on ne peut dire si ce m�lange sera
compatible avec le contact.

"""),

85 : _("""
L'alarme CONTACT_84 se transforment en erreur fatale !
Il ne faut pas que les surfaces de contact m�langent des mailles affect�es d'une mod�lisations planes (D_PLAN, C_PLAN ou AXI)
avec des mailles affect�es d'une mod�lisation 3D. 

"""),

88 : _("""
Ne pas utiliser REAC_INCR=0 avec le frottement.
"""),

93 : _("""
Contact methode VERIF.
 -> Interp�n�trations des surfaces.
    Attention : si les mailles en contact sont quadratiques, le jeu aux noeuds milieux risque d'etre impr�cis (oscillations entre noeuds sommets et milieux).
 
 -> Risque & Conseil :
    V�rifier si le niveau d'interp�n�tration des surfaces est acceptable dans
    votre probl�me.
"""),

96 : _("""
Contact m�thode continue. Pour l'option SANS_GROUP_NO_FR, il faut que le frottement soit activ�.
"""),

97 : _("""
Contact m�thode continue. Pour l'option SANS_GROUP_NO et SANS_GROUP_NO_FR, l'int�gration aux noeuds est obligatoire.
"""),

98 : _("""
Contact m�thode continue. Pour l'option NORMALE = 'MAIT_ESCL' ou NORMALE = 'ESCL', l'int�gration aux noeuds est obligatoire.
"""),

}
