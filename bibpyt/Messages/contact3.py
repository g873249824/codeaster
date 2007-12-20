#@ MODIF contact3 Messages  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
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
Le mot-clef < %(k1)s > est inconnu dans AFFE_CONTACT. Contactez les d�veloppeurs.
Note DVP: erreur de coh�rence fortran/catalogue. 
"""),

2 : _("""
Le mot-clef < %(k1)s > n'est pas renseign� dans AFFE_CONTACT alors qu'il est obligatoire. Contactez les d�veloppeurs.
Note DVP: erreur de coh�rence fortran/catalogue. 
"""),

3 : _("""
L'option < %(k1)s > ne correspond a aucune option permise par le mot-clef < %(k2)s > dans AFFE_CONTACT. Contactez les d�veloppeurs.
Note DVP: erreur de coh�rence fortran/catalogue.            
"""),

10 : _("""
La matrice est singuli�re lors du calcul du rep�re local tangent au noeud maitre  %(k1)s  sur la maille maitre %(k2)s.
Une erreur de d�finition de la maille: les vecteurs tangents sont colin�aires.
"""),

11 : _("""
La matrice est singuli�re lors de la projection du point de contact  sur la maille maitre  %(k1)s.
Une erreur de d�finition de la maille: les vecteurs tangents sont colin�aires.
"""),

12 : _("""
L'algorithme de Newton a �chou� lors du calcul du rep�re local tangent au noeud maitre %(k1)s sur la maille maitre  %(k2)s.
Erreur de d�finition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas. 
"""),

13 : _("""
L'algorithme de Newton a �chou� lors de la projection du point de contact  sur la maille maitre  %(k1)s.
Erreur de d�finition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.  
"""),

14 : _("""
Les vecteurs tangents sont nuls au noeud maitre  %(k1)s  sur la maille maitre  %(k2)s.
Une erreur de d�finition de la maille.
"""),

15 : _("""
Contact m�thode continue.
Le vecteur DIRE_APPA est nul !
"""),

16 : _("""
Contact m�thode continue.
La m�thode d'int�gration est GAUSS, le champ VALE_CONT n'est pas cr��.
"""),

21 : _("""
Les vecteurs tangents sont nuls lors de la projection du point de contact sur la maille maitre  %(k1)s. 
Une erreur de d�finition de la maille.
"""),

22 : _("""
L'�lement inconnu sur la maille maitre  %(k1)s.
Cet �l�ment n'est pas programm� pour le contact avec formualtion continue.
Contactez l'assistance. 
"""),

23 : _("""
Le vecteur normal est nul sur le noeud maitre  %(k1)s.
Si vous avez activ� le lissage, essaye� de le d�sactiver. 
"""),

24 : _("""
Il y a plus de trois noeuds exclus sur la maille esclave  %(k1)s  par l'option SANS_GROUP_NO ou SANS_NOEUD.
Supprimer directement la maille esclave de la d�finition de la surface.
"""),

25 : _("""
L'�l�ment port� par la maille esclave %(k1)s n'est pas du bon type pour un fond de fissure, elle est de type  %(k2)s 
"""),

26 : _("""
Schema d'int�gration inconnu sur la maille  %(k1)s. 
"""),

27 : _("""
Code erreur introuvable. Contactez les d�veloppeurs.
"""),

28 : _("""
Le statut du contact a chang� %(i1)d fois au point de contact num�ro %(i2)d sur la maille esclave %(k1)s
Pr�sence de flip-flop. 
"""),

35 : _("""
Contact m�thode continue. 
  -> La normale calcul�e sur une maille est nulle.
  -> Risque & Conseil :
     V�rifier votre maillage.
"""),

42 : _("""
Contact m�thodes discr�tes. Il y a m�lange de mailles quadratiques (TRIA6, TRIA7 ou QUAD9) avec des mailles QUAD8 sur la surface escalve du contact.
On supprime la liaison entre les noeuds sommets et noeud milieu sur le QUAD8.
Il y a risque d'interp�n�tration du noeud milieu pour le QUAD8 consid�r�.
"""),

85 : _("""
Contact m�thode continue. 
  -> Il y a �chec de la boucle contraintes actives lors du traitement
     du contact
  -> Risque & Conseil :
     V�rifier votre maillage ou augmenter ITER_CONT_MAX.
"""),

86 : _("""
Contact m�thode continue. 
  -> Il y a convergence forc�e sur boucle contraintes actives lors du traitement
     du contact.
  -> Risque & Conseil :
     La convergence forc�e se d�clenche lorsque le probl�me a du mal � converger. Il y a des risques que le probl�me 
     soit un peu moins bien trait�. V�rifiez bien que vous n'avez pas d'interp�n�tration entre les mailles. S'il y des 
     interp�n�trations intempestives, tentez de d�couper plus finement en temps votre probl�me.
"""),

87 : _("""
Contact m�thode continue. 
  -> Il y a convergence forc�e sur boucle seuil frottement lors du traitement du
     contact.
  -> Risque & Conseil :
     La convergence forc�e se d�clenche lorsque le probl�me a du mal � converger. Il y a des risques que le probl�me 
     soit un peu moins bien trait�. La condition de frottement de Coulomb est peut etre mal prise en compte. Risque de 
     r�sultats faux sur les forces d'adh�rence. Essayez de d�couper plus finement en temps votre probl�me.
"""),

88 : _("""
Contact m�thode continue. 
  -> Il y a convergence forc�e sur boucle de g�om�trie lors du traitement du
     contact.
  -> Risque & Conseil :
     La convergence forc�e se d�clenche lorsque le probl�me a du mal � converger
     lors de grands glissements relatifs entre deux surfaces de contact.
     Il y a des risques que le probl�me soit un peu moins bien trait�.
     V�rifiez bien que vous n'avez pas d'interp�n�tration entre les mailles.
     S'il y des interp�n�trations intempestives, tentez de d�couper plus finement en temps votre probl�me.
"""),

94 : _("""
Contact m�thode discr�te. 
 Le jeu entre les noeuds milieux au niveau des l�vres risque
 d'etre impr�cis si les mailles en contact sont quadratiques.
"""),

}
