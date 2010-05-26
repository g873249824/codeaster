#@ MODIF contact3 Messages  DATE 26/05/2010   AUTEUR ABBAS M.ABBAS 
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

2 : _("""
  La maille de fond de fissure de type POI1, introduite par le mot-clef MAILLE_FOND ou GROUP_MA_FOND,
ne correspond pas � une extr�mit� du segment toucahnt le fond de fisssure. 
  
"""),

3 : _("""
  Pour la formulation de contact < %(k1)s > le couple:
  ALGO_CONT: < %(k2)s >
  ALGO_FROT: < %(k3)s >  
  N'est pas possible.
"""),

4 : _("""
  Le mot-clef < %(k1)s > doit avoir la meme valeur sur toutes les zones
  de contact
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

37: _("""
 La section de la poutre n'est pas constante sur l'�l�ment. On prend la moyenne.
 """),

38 : _("""
La maille %(k1)s est de type poutre et sa tangente est nulle.
V�rifiez votre maillage.
"""),

39: _("""
Probl�me pour r�cup�rer l'�paisseur de la coque pour la maille  %(k1)s
"""),

40: _("""
L'excentricit� de la coque pour la maille %(k1)s ne peut pas etre trait�e
"""),

41: _("""
Probl�me pour r�cup�rer l'excentricit� de la coque pour la maille  %(k1)s
"""),

43 : _("""
La normale que vous avez pr�d�finie par (VECT_* = 'VECT_Y') n'est pas utilisable en 2D.
Utilisez plut�t VECT_* = 'FIXE'
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

81 : _("""
Contact.
  -> Il y a trop de r�actualisations g�om�triques.
  -> Risque & Conseil :
     Le param�tre ITER_GEOM_MAXI est trop faible.
     Votre maillage est incorrect ou le glissement relatif des deux
     surfaces est trop important.
     Tentez de d�couper plus finement en temps votre probl�me ou augmenter ITER_GEOM_MAXI.
 
"""),

85 : _("""
Contact m�thode continue. 
  -> Il y a �chec de la boucle des contraintes actives lors du traitement
     du contact
  -> Risque & Conseil :
     V�rifier votre mod�le ou augmenter ITER_CONT_MAXI/ITER_CONT_MULT.
"""),

86 : _("""
Contact m�thode continue. 
  -> Il y a convergence forc�e sur la boucle des contraintes actives lors du traitement
     du contact.
  -> Risque & Conseil :
     La convergence forc�e sur les statuts de contact se d�clenche lorsque le probl�me a du mal � converger.
     Il y a des risques que le probl�me soit un peu moins bien trait�.
     V�rifiez bien que vous n'avez pas d'interp�n�tration entre les mailles.
     S'il y a des interp�n�trations intempestives, tentez de d�couper plus finement en temps votre probl�me."""),

87 : _("""
Contact m�thode continue. 
  -> Il y a trop de r�actualisations pour le seuil de frottement.
  -> Risque & Conseil :
     Le param�tre ITER_FROT_MAXI est trop faible.
     La condition de frottement de Coulomb est peut �tre mal prise en compte, il y a donc un risque de 
     r�sultats faux sur les forces d'adh�rence.
     Essayez de d�couper plus finement en temps votre probl�me."""),


96 : _("""
Contact.
    -> Les surfaces en contact ont boug� de plus de 1%% depuis la derni�re r�actualisation.
       Or vous n'avez pas activ� la r�actualisation g�om�trique (REAC_GEOM) automatique ou
       vous utilisez le mode 'CONTROLE'
    -> Risque & Conseil : Vos r�sultats risquent d'etre faux, les mailles ne
       seront peut-etre pas correctement appari�es et donc la condition de contact sera peut
       etre fausse.
       Si vous avez volontairement n�glig� la non-lin�arit� g�om�trique de contact (pour des raisons
       de performance), nous vous invitons � v�rifier visuellement qu'il n'y a effectivement
       pas interp�n�tration.
"""),

97 : _("""
Contact formulation continue.
    -> Le seuil de frottement a boug� de plus de 1%% depuis la derni�re r�actualisation.
       Or vous utilisez la r�actualisation contr�l�e (REAC_FROT='CONTROLE').
    -> Risque & Conseil : Vos r�sultats risquent d'etre faux, le seuil de Coulomb ne sera peut �tre pas
       atteint et le frottement pas bien pris en compte.
       Si vous avez volontairement n�glig� la non-lin�arit� de frottement (pour des raisons
       de performance), nous vous invitons � v�rifier la validit� de vos r�sultats.
"""),

}
