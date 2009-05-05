#@ MODIF contact3 Messages  DATE 05/05/2009   AUTEUR DESOZA T.DESOZA 
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


13 : _("""
L'algorithme de Newton a �chou� lors de la projection du point de contact de coordonn�es
  (%(r1)s,%(r2)s,%(r3)s)
sur la maille %(k1)s.
Erreur de d�finition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.  
"""),

14 : _("""
Les vecteurs tangents sont nuls au niveau du projet� du point de contact de coordonn�es
  (%(r1)s,%(r2)s,%(r3)s) 
sur la maille %(k1)s, 
Erreur de d�finition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.
"""),

15 : _("""
La direction d'appariement fixe donn�es par le vecteur DIRE_APPA est nulle !
"""),

16 : _("""
Contact m�thode continue.
La m�thode d'int�gration n'est pas NOEUD, le champ VALE_CONT n'est pas cr��.
"""),

17 : _("""
Contact m�thode continue.
Avec un FOND-FISSURE, il est impossible d'utiliser les options suivantes:
- LISSAGE = 'OUI' ou/et
- NORMALE = 'ESCL' ou
- NORMALE = 'MAIT_ESCL'
"""),


23 : _("""
Le vecteur normal est nul au niveau du projet� du point de contact de coordonn�es
  (%(r1)s,%(r2)s,%(r3)s) 
sur la maille %(k1)s, 
Erreur de d�finition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.
"""),

25 : _("""
L'�l�ment port� par la maille esclave %(k1)s n'est pas du bon type pour un fond de fissure, elle est de type  %(k2)s 
"""),

26 : _("""
Le vecteur normal est nul au niveau du noeud %(k1)s.
"""),

27 : _("""
Le vecteur normal est nul au niveau de la maille %(k1)s.
"""),

28 : _("""
Le statut du contact a chang� %(i1)d fois au point de contact num�ro %(i2)d sur la maille esclave %(k1)s
Pr�sence de flip-flop. 
"""),

29 : _("""
Nom de la maille : %(k1)s 
"""),

30 : _("""
Le couple de surfaces de contact %(i1)s pour l'appariement nodal est mal d�fini.
Il faut moins de noeuds esclaves que de noeuds maitres pour respecter l'injectivit�.
Or ici:
Nombre de noeuds maitres : %(i2)s
Nombre de noeuds esclaves: %(i3)s
Conseil: intervertissez les deux surfaces maitres et esclaves
"""),

31 : _("""
Les vecteurs tangents sont nuls au niveau quand on projette le noeud esclave
%(k1)s sur la maille %(k2)s
"""),

32: _("""
 Le mot-clef DIST_POUT ne fonctionne qu'avec des sections circulaires d�finies dans AFFE_CARA_ELEM.
 """),

33 : _("""
L'erreur suivante est arriv�e lors du pr�-calcul des normales aux noeuds activ�es par les options
- LISSAGE = 'OUI' ou/et
- NORMALE = 'ESCL' ou
- NORMALE = 'MAIT_ESCL'
"""),

34 : _("""
Echec de l'orthogonalisation du rep�re tangent construit au niveau du projet� du point de contact de coordonn�es
  (%(r1)s,%(r2)s,%(r3)s) 
sur la maille %(k1)s, 
Erreur de d�finition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.
"""),

35 : _("""
Les vecteurs tangents sont nuls au niveau quand on projette le noeud esclave
%(k1)s sur la noeud maitre %(k2)s
"""),

36 : _("""
La maille %(k1)s est de type 'POI1', ce n'est pas autoris� sur une maille maitre. 
"""),


38 : _("""
La maille %(k1)s est de type poutre et sa tangente est nulle.
V�rifiez votre maillage.
"""),

39: _("""
Probl�me pour r�cup�rer l'�paisseur de la coque pour la maille  %(k1)s
"""),

40: _("""
L'excentricit� de la coque pour la maille %(k1)s n'est pas trait�e
"""),

41: _("""
Probl�me pour r�cup�rer l'excentricit� de la coque pour la maille  %(k1)s
"""),

43 : _("""
La normale que vous avez pr�d�finie par (VECT_* = 'VECT_Y') n'est pas utilisable en 2D.
Utilisez plutot (ou Dingo) VECT_* = 'FIXE'
"""),


50: _("""
Avec l'option VECT_MAIT = 'FIXE', seule l'option NORMALE = 'MAIT' est possible.
"""),

51: _("""
Avec l'option VECT_MAIT = 'VECT_Y', seule l'option NORMALE = 'MAIT' est possible.
"""),

52: _("""
Avec l'option VECT_ESCL = 'FIXE', seule l'option NORMALE = 'ESCL' est possible.
"""),

53: _("""
Avec l'option VECT_ESCL = 'VECT_Y', seule l'option NORMALE = 'ESCL' est possible.
"""),

54: _("""
Le LISSAGE n'est possible qu'avec des normales automatiques VECT_ESCL='AUTO' et/ou VECT_MAIT='AUTO'.
"""),

54: _("""
Le LISSAGE n'est possible qu'avec des normales automatiques VECT_ESCL='AUTO' et/ou VECT_MAIT='AUTO'.
"""),

60 : _("""
La maille %(k1)s est de type 'POI1', elle n�cessite l'utilisation de l'option
NORMALE='FIXE' avec une normale non-nulle. 
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

}
