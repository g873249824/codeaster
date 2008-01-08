#@ MODIF contact Messages  DATE 08/01/2008   AUTEUR DESOZA T.DESOZA 
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
Contact methode GCP. On ne peut utiliser le solveur GCPC avec le contact 
"""),

7 : _("""
Contact methode GCP. Le pas d'avancement est negatif ; risque de comportement hasardeux de l'algorithme
"""),

9 : _("""
Contact liaison glissiere. Des noeuds se decollent plus que la valeur d'ALARME_JEU:
"""),

10 : _("""
Contact m�thodes discr�tes. Une maille maitre de type SEG a une longueur nulle. Verifiez votre maillage.
"""),

11 : _("""
Contact m�thodes discr�tes. Le vecteur tangent d�fini par VECT_Y est colin�aire au vecteur normal.
"""),

12 : _("""
Contact m�thodes discr�tes. Le vecteur normal est colin�aire au plan de projection.
"""),

14 : _("""
Contact m�thodes discr�tes. La projection quadratique pour les triangles n'est pas disponible
"""),

15 : _("""
Contact m�thodes discr�tes. Une maille maitre de type TRI a une surface nulle. Verifiez votre maillage.
"""),

27 : _("""
Contact m�thodes discr�tes. On n'a pas trouve de noeud maitre proche du noeud esclave : contacter les developpeurs
"""),

32 : _("""
Contact m�thodes discr�tes. Pas de lissage des normales possible avec l'appariement nodal : contacter les developpeurs
"""),

54 : _("""
Contact m�thodes discr�tes. On ne peut pas utiliser une direction d'appariement fixe VECT_NORM_ESCL si l'appariement n'est pas NODAL.
"""),

55 : _("""
Contact m�thodes discr�tes. La commande VECT_Y n'est utilisable qu'en 3D.
"""),

56 : _("""
Contact m�thodes discr�tes. La commande VECT_ORIE_POU n'est utilisable qu'en 3D.
"""),

60 : _("""
Contact m�thodes discr�tes. Vous utilisez des mailles de type SEG2/SEG3 en 3D sans definir un repere pour l'appariement. Voir les mots-clefs VECT_Y et VECT_ORIE_POU.
"""),

75 : _("""
Contact m�thodes discr�tes. Un POI1 ne peut pas etre une maille maitre.
"""),

76 : _("""
Contact. On ne peut pas avoir plus de 3 ddls impliques dans la meme relation unilaterale : contacter les developpeurs
"""),

83 : _("""
Contact. Il y a plusieurs charges contenant des conditions de contact.
"""),

84 : _("""
Contact. Melange 2d et 3d dans le contact.
"""),

85 : _("""
Contact. Melange dimensions maillage dans le contact.
"""),

86 : _("""
Contact. Code methode contact incorrect : contacter les developpeurs
"""),

87 : _("""
Contact. La norme tangentielle de frottement est negative: contacter les developpeurs
"""),

88 : _("""
Contact. Ne pas utiliser REAC_INCR=0 avec le frottement.
"""),

93 : _("""
Contact methode VERIF.
 -> Interp�n�trations des surfaces.
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

}
