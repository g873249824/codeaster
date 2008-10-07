#@ MODIF calculel Messages  DATE 07/10/2008   AUTEUR PELLET J.PELLET 
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
Erreur Utilisateur :
 En cherchant � projeter 1 noeud sur une maille, l'algorithme de Newton �choue.
 Le probl�me vient probablement de la mauvaise qualit� de la maille.
 Maille "coupable" : %(k1)s

Risques & conseils :
 V�rifiez la maille incrimin�e (num�rotation et g�om�trie de ses noeuds, ...)
"""),

2 : _("""
Erreur Utilisateur :
 Quand on utilise AFFE_CHAR_CINE/EVOL_IMPO, c'est le champ de l'evol_xxx correspondant
 au 1er instant qui impose sa "loi" : tous les ddls de ce champ seront impos�s pour tous
 les instants du calcul.

 Malheureusement, on ne trouve pas un ddl dans l'evol_xxx %(k1)s :
   instant : %(r1)f  noeud : %(i1)d  cmp : %(k2)s

Risques & conseils :
 Assurez-vous que l'�volution impos�e %(k1)s concerne les memes ddls pour tous les instants.
"""),

3 : _("""
 la grandeur :  %(k1)s  n existe pas dans le catalogue des grandeurs.
"""),

4 : _("""
 incoherence des maillages : %(k1)s  et  %(k2)s
"""),

5 : _("""
 Erreur de programmation (ou d'utilisation ?) :
   Le changement de discr�tisation : %(k1)s n'est pas encore programm�.
 Risques et conseils :
   Il y a peut-etre une demande d'�volution � �mettre ...
"""),

6 : _("""
 Erreur d'utilisation :
   On n'arrive pas � construire correctement le champ contenant le nombre de sous-points
   des �l�ments finis (coques multi-couches, tuyaux, poutre multi-fibres, ...)  du mod�le %(k1)s.

 Risques & conseils :
   Cette erreur intervient lorsque l'on ne d�finit pas TOUTES les caract�ristiques �l�mentaires
   dans le meme AFFE_CARA_ELEM.
   Pour les commandes de calcul, il ne faut qu'un seul MODELE et qu'un seul CARA_ELEM.
"""),

7 : _("""
 Erreur de maillage :
   La maille %(k1)s de type %(k2)s est trop distordue.
   Le jacobien de la transformation g�om�trique n'a pas le meme signe sur tous les
   points de Gauss.

 Risques & conseils :
   Le maillage a-t-il �t� produit par un mailleur ?
   La connectivit� respecte-elle bien la convention Aster ?
"""),

8 : _("""
 sur la maille %(k1)s le calcul est thermo m�canique. Or il manque la temp�rature de r�f�rence.
 On ne peut donc pas calculer de d�formation thermique.
"""),

9 : _("""
 Erreur d'utilisation dans AFFE_CHAR_CINE :
   Aucun des ddls que l'on souhaite bloquer n'appartient au mod�le.
   La charge cin�matique produite est donc vide.

 Risques & Conseils :
   V�rifier le nom des ddls port�s par les noeuds des �l�ments de votre mod�le.
"""),

11 : _("""
 le mode_local:  %(k1)s  ne doit pas etre vecteur ou matrice.
"""),

12 : _("""
 le mode_local:  %(k1)s  ne doit pas etre "diff__".
"""),

14 : _("""
  incompatibilite des type_champ ("elga"/"elno")  pour l option :  %(k1)s  entre les 2 type_elem :  %(k2)s  et  %(k3)s
"""),

15 : _("""
 sur la maille %(k1)s le calcul est thermo m�canique. Or il manque le parametre mat�riau
 %(k2)s . On ne peut donc pas calculer de d�formation thermique.
"""),

16 : _("""
 type de maille indisponible
"""),

17 : _("""
 type de champ inconnu
"""),

18 : _("""
 les parties r�elle et imaginaire du champ � assembler ne sont pas du m�me type
 l'un est un CHAM_NO et l'autre un CHAM_ELEM
"""),

20 : _("""
 le champ de grandeur  %(k1)s  ne respecte pas le format xxxx_r
"""),

21 : _("""
 les champs r�el et imaginaire � assembler ne contiennent pas la m�me grandeur
"""),

22 : _("""
 probl�me dans le catalogue des grandeurs simples
 la grandeur %(k1)s  ne poss�de pas le m�me nombre de champs que son homologue complexe %(k2)s
"""),

23 : _("""
 probl�me dans le catalogue des grandeurs simples
 la grandeur  %(k1)s  ne poss�de pas les m�mes champs que son homologue complexe  %(k2)s
"""),

24 : _("""
 les champs � assembler n'ont pas la m�me longueur
"""),

27 : _("""
 CHAM_ELEM � combiner incompatible
"""),

29 : _("""
 option inconnue au catalogue :  %(k1)s
"""),

30 : _("""
  -> Le TYPE_ELEMENT %(k1)s  ne sait pas encore calculer l'OPTION:  %(k2)s.
     On ne calcule donc rien sur les �l�ments de ce type.

  -> Risque & Conseil :
     V�rifiez que l'option incompl�tement calcul�e est bien une option de post-traitement
     et que le d�ficit de calcul n'entraine pas de r�sultats faux.
"""),

31 : _("""
  la temp�rature n'est pas correctement renseign�e
"""),

34 : _("""
 le calcul de l'option :  %(k1)s
 n'est possible pour aucun des types d'�l�ments du LIGREL.
"""),

35 : _("""
 Erreur utilisateur :
  On essaye de fusionner 2 cham_elem mais ils n'ont pas le meme nombre
  "points" (noeuds ou points de Gauss) pour la maille num�ro : %(i1)d.
  Nombres de points :  %(i2)d et %(i3)d
"""),

36 : _("""
 Erreur utilisateur :
  On essaye de fusionner 2 cham_elem mais ils n'ont pas le meme nombre
  de "sous-points" (fibres, couches, ...) pour la maille num�ro : %(i1)d.
  Nombres de sous-points :  %(i2)d et %(i3)d
"""),

37 : _("""
 Erreur dans la lecture des CHAR_CINE ou dans les CHAR_CINE
"""),

38 : _("""
 la carte concerne aussi des mailles tardives qui sont oubli�es
"""),

42 : _("""
 Erreur Programmeur:
 Incoh�rence fortran/catalogue
 TYPE_ELEMENT :  %(k1)s
 OPTION       :  %(k2)s
 La routine texxxx.f correspondant au calcul �l�mentaire ci-dessus est buggu�e
 Elle �crit en dehors de la zone allou�e au param�tre (OUT) %(k3)s.

"""),

47 : _("""
  le CHAM_ELEM:  %(k1)s  n'existe pas.
"""),

48 : _("""
 le CHAM_ELEM: %(k1)s  n'a pas le m�me nombre de composantes dynamiques sur tous ses �l�ments.
"""),

49 : _("""
 le CHAM_ELEM : %(k1)s a des sous-points.
"""),

52 : _("""
 La composante: %(k1)s  n'appartient pas � la grandeur: %(k2)s
 Champ : %(k4)s
"""),

53 : _("""
 Option : %(k1)s  inexistante dans les catalogues.
 Champ : %(k4)s
"""),

54 : _("""
 Le param�tre:  %(k1)s  de l'option:  %(k2)s  n'est pas connu des TYPE_ELEM du LIGREL:  %(k3)s
 Champ : %(k4)s
"""),

55 : _("""
 Erreur utilisateur :
   On cherche � cr�er un CHAM_ELEM mais sur certains points, on ne trouve pas la composante : %(k1)s
   Champ : %(k4)s
 Risques & conseils :
   Si la commande que vous ex�cutez comporte le mot cl� PROL_ZERO='OUI', vous devriez peut-etre l'utiliser.
"""),

56 : _("""
 Le LIGREL contient des mailles tardives
 Champ : %(k4)s
"""),

57 : _("""
 Erreur Utilisateur :
   On cherche � transformer un champ simple en cham_elem.
   Le nombre de "points" (points de Gauss ou noeuds) du champ simple (%(i1)d) est
   diff�rent du nombre de points attendu pour le cham_elem (%(i2)d) :
     - maille              :  %(k1)s
     - nom du cham_elem    :  %(k4)s
     - nom du champ simple :  %(k5)s

"""),

58 : _("""
 Il manque la composante : %(k1)s  sur la maille : %(k2)s
 Champ : %(k4)s
"""),

67 : _("""
 grandeur:  %(k1)s  inconnue au catalogue.
"""),

68 : _("""
 num�ro de maille invalide     :  %(k1)s  (<1 ou >nbma)
"""),

69 : _("""
 num�ro de point invalide      :  %(k1)s  (<1 ou >nbpt)
 pour la maille                :  %(k2)s
"""),

70 : _("""
 num�ro de sous_point invalide :  %(k1)s  (<1 ou >nbspt)
 pour la maille                :  %(k2)s
 pour le point                 :  %(k3)s
"""),

71 : _("""
 num�ro de composante invalide :  %(k1)s  (<1 ou >nbcmp)
 pour la maille                :  %(k2)s
 pour le point                 :  %(k3)s
 pour le sous-point            :  %(k4)s
"""),

91 : _("""
 incoh�rence des familles de points de Gauss pour la maille  %(k1)s
 ( %(k2)s / %(k3)s )
"""),

92 : _("""
 type scalaire du CHAM_NO :  %(k1)s  non r�el.
"""),

93 : _("""
 type scalaire du NUME_DDL :  %(k1)s  non r�el.
"""),

99 : _("""
 melange de CHAM_ELEM_S et CHAM_NO_S
"""),

}
