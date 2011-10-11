#@ MODIF contact3 Messages  DATE 11/10/2011   AUTEUR DESOZA T.DESOZA 
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

cata_msg = {

1 : _("""
Formulation continue.
Vous avez activ� le frottement de Coulomb (FROTTEMENT='COULOMB') pourtant toutes les zones de contact
portent un coefficient de frottement nul.

Le frottement est donc d�sactiv�.

Conseil : v�rifiez que vous avez correctement d�fini le coefficient de frottement (mot-cl� COULOMB) dans chaque zone. 
"""),

2 : _("""
  La maille de fond de fissure de type POI1, introduite par le mot-clef MAILLE_FOND ou GROUP_MA_FOND,
ne correspond pas � une extr�mit� du segment toucahnt le fond de fisssure. 
  
"""),

3 : _("""
  Pour la formulation de contact < %(k1)s > le couple :
  ALGO_CONT : < %(k2)s >
  ALGO_FROT : < %(k3)s >  
  n'est pas permis.
  
  Conseil : consultez la documentation pour conna�tre les couples autoris�s.
"""),

4 : _("""
  Le mot-clef < %(k1)s > doit avoir la meme valeur sur toutes les zones
  de contact
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
Avec un FOND_FISSURE, il est impossible d'utiliser les options suivantes:
- LISSAGE = 'OUI' ou/et
- NORMALE = 'ESCL' ou
- NORMALE = 'MAIT_ESCL'
"""),

18 : _("""
Contact m�thode continue.
La direction d'exclusion du frottement fournie pour la zone de contact num�ro %(i1)s (%(r1)s,%(r2)s,%(r3)s) est perpendiculaire au plan de contact sur la maille %(k1)s.

Conseil :
   - V�rifiez le vecteur DIRE_EXCL_FROT. Sa projection sur le plan tangent de contact doit exister
     pour indiquer une direction � exclure.

"""),

23 : _("""
Le vecteur normal est nul au niveau du projet� du point de contact de coordonn�es
  (%(r1)s,%(r2)s,%(r3)s) 
sur la maille %(k1)s, 
Erreur de d�finition de la maille ou projection difficile. Contactez l'assistance dans ce dernier cas.
"""),

24 : _("""
Le vecteur normal est nul sur la maille %(k1)s, 
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

31 : _("""
Les vecteurs tangents sont nuls au niveau quand on projette le noeud esclave
%(k1)s sur la maille %(k2)s
"""),

32: _("""
 Le mot-clef DIST_POUT ne fonctionne qu'avec des sections circulaires d�finies dans AFFE_CARA_ELEM.
 """),

35 : _("""
Les vecteurs tangents sont nuls au niveau quand on projette le noeud esclave
%(k1)s sur la noeud maitre %(k2)s
"""),


37: _("""
 La section de la poutre n'est pas constante sur l'�l�ment. On prend la moyenne.
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
La normale que vous avez pr�d�finie par (VECT_* = 'VECT_Y') sur la maille %(k1)s n'est pas utilisable en 2D.
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

61 : _("""
La maille %(k1)s est de type poutre, elle n�cessite la d�finition d'une base locale.
Utilisez NORMALE='FIXE' ou NORMALE='VECT_Y' dans DEFI_CONTACT.
"""),

75 : _("""
La maille %(k1)s est de type 'POI1', elle ne peut pas �tre une maille ma�tre.
"""),

81 : _("""
Contact.
  -> Il y a trop de r�actualisations g�om�triques.
  -> Conseils :
     - Augmentez le mot-cl� ITER_GEOM_MAXI dans la commande DEFI_CONTACT.
     - V�rifiez votre maillage (orientation des surfaces, d�finition des zones de contact).
     - D�coupez plus finement le pas de temps.
"""),

85 : _("""
Contact m�thode continue. 
  -> Il y a �chec de la boucle des contraintes actives lors du traitement du contact.
  -> Conseil :
     - Augmentez le mot-cl� ITER_CONT_MAXI (ou ITER_CONT_MULT) dans la commande DEFI_CONTACT.
"""),

86 : _("""
Contact m�thode continue. 
  -> Il y a convergence forc�e sur la boucle des contraintes actives lors du traitement du contact.
  -> Risque & conseil :
     La convergence forc�e sur les statuts de contact se d�clenche lorsque le probl�me a du mal � converger.
     Il y a des risques que le probl�me soit un peu moins bien trait�.
     V�rifiez bien que vous n'avez pas d'interp�n�tration au niveau des zones de contact.
     S'il y a des interp�n�trations intempestives, d�coupez plus finement le pas de temps."""),

87 : _("""
Contact m�thode continue. 
  -> Il y a trop de r�actualisations pour le seuil de frottement.
  -> Conseils :
     - Augmentez le mot-cl� ITER_FROT_MAXI dans la commande DEFI_CONTACT.
     - D�coupez plus finement le pas de temps."""),


96 : _("""
Contact.
    -> Les surfaces en contact ont boug� de plus de 1%% depuis la derni�re r�actualisation.
       Or vous n'avez pas activ� la r�actualisation g�om�trique automatique dans la commande DEFI_CONTACT
       (REAC_GEOM='AUTOMATIQUE') ou bien vous utilisez le mode 'CONTROLE'
    -> Risque & conseil : 
       Vos r�sultats risquent d'�tre faux, les mailles ne seront peut-�tre pas correctement appari�es
       et des interp�n�trations pourraient appara�tre.
       Si vous avez volontairement n�glig� la non-lin�arit� g�om�trique de contact (pour des raisons
       de performance), nous vous invitons � v�rifier visuellement qu'il n'y a effectivement
       pas d'interp�n�trations.
"""),

97 : _("""
Contact formulation continue.
    -> Le seuil de frottement a boug� de plus de 1%% depuis la derni�re r�actualisation.
       Or vous utilisez la r�actualisation contr�l�e (REAC_FROT='CONTROLE') dans la commande DEFI_CONTACT.
    -> Risque & Conseil :
       Vos r�sultats risquent d'etre faux, le seuil de Coulomb ne sera peut �tre pas le bon
       et le frottement pas bien pris en compte.
       Si vous avez volontairement n�glig� la non-lin�arit� de frottement (pour des raisons
       de performance), nous vous invitons � v�rifier la validit� de vos r�sultats.
"""),

}
