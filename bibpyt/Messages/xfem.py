#@ MODIF xfem Messages  DATE 15/05/2007   AUTEUR GENIAUT S.GENIAUT 
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

cata_msg={

1: _("""
Pour le DVP : �crasement des valeurs nodales dans xconno.f
Pour l'utilisateur : les fissures X-FEM sont surement trop proches.
                     il faut au minimum 2 mailles entre les fissures.
                     veuillez raffiner le maillage entre les fissures (ou �carter les fissures). 
"""),

2: _("""
 Le nombre de fissures autoris�es avec X-FEM est limit� � (i1)i
"""),

3: _("""
 Le modele %(k1)s est incompatible avec la methode X-FEM.
 V�rifier qu'il a bien �t� cr�� par l'op�rateur MODI_MODELE_XFEM. 
"""),

4: _("""
 Il est interdit de melanger dans un mod�le les fissures X-FEM avec et sans
 contact. Veuillez rajouter les mots cl� CONTACT manquants 
 dans DEFI_FISS_XFEM.
"""),

5: _("""
La valeur du parametre %(k1)s (%(i1)d) de la fissure %(k2)s 
a �t� chang� � 
%(i2)d (valeur maximale de toutes les fissures du mod�le)
"""),

6: _("""
DDL_IMPO sur un noeud X-FEM : %(k1)s =  %(r1)f au noeud %(k2)s
"""),

7: _("""
Il y a %(i1)s mailles %(k1)s 
"""),

8: _("""
Le nombre de %(k1)s X-FEM est limit� � 10E6. Veuillez reduire la taille du maillage.
"""),

9: _("""
erreur de dvt dans %(k2)s : on a trouv� trop de nouveaux %(k1)s � ajouter.
"""),

10: _("""
On ne peut pas post-traiter de champs aux points de Gauss avec X-FEM sur des �l�ments
dont le nombre de points de Gauss est diff�rent de 1.
"""),

11: _("""
On a trouv� plus de 2 points de fond de fissure, ce qui est impossible en 2d.
Veuillez revoir la d�finition des level sets.
"""),

12: _("""
La prise en compte du contact sur les l�vres des fissures X-FEM n'est possible qu'avec une
approximation du champ de d�placement lin�aire.
Deux solutions : 
- soit passer en approximation lin�aire (mot-cl� DEGRE_DEPL de MODI_MODELE_XFEM)
- soit ne pas prendre en compte le contact (enlever le mot-cl� CONTACT de MODI_MODELE_XFEM)
"""),

13: _("""
pb fissure elliptique
"""),

18: _("""
Dimension de l'espace incorrecte. Le mod�le doit etre 2D ou 3D et ne pas comporter
de sous-structures.
"""),

19: _("""
Caract�ristique de la SD inconnue. Contactez les d�veloppeurs.
"""),

20: _("""
Le mot-clef ORIE_FOND est indispensable en 3D.
"""),

21: _("""
Le mot-clef ORIE_FOND n'est pas n�cessaire en 2D.
"""),

22: _("""
Plus d'une occurrence du mot-clef ORIE_FOND.
"""),

23: _("""
Erreur dans le choix de la methode de calcul des level-sets: renseignez FONC_LT/LN ou GROUP_MA_FISS/FOND.
"""),

50: _("""
Le nombre d'aretes coupees par la fissure est superieur au critere de dimensionnement initialement prevu. Contactez les d�veloppeurs.
Note DVP: Il faut augmenter le parametre mxar dans la routine xlagsp.
"""),

57: _("""
Aucune maille de fissure n'a �t� trouv�e. Suite des calculs risqu�e.
"""),

58: _("""
  -> Aucun point du fond de fissure n'a �t� trouv� !
  -> Risque & Conseil :
     Ce message est normal si vous souhaitiez d�finir une interface (et non une fissure).
     Si vous souhaitiez d�finir une fissure, la d�finition des level sets (M�thode XFEM)
     ne permet pas de trouver de points du fond de fissure � l'int�rieur de la structure.
     Il doit y avoir une erreur lors de la d�finition de la level set tangente.
     V�rifier la d�finition des level sets.
"""),

59: _("""
Ne pas utiliser le mot-clef RAYON_ENRI lorsque le fond de fissure est en dehors de la structure.
"""),

60: _("""
Le point initial de fissure n'est pas un point de bord de fissure, bien que la fissure soit d�bouchante. assurez-vous de la bonne d�finition de PFON_INI.
"""),


}
