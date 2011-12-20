#@ MODIF calculel2 Messages  DATE 21/12/2011   AUTEUR MACOCCO K.MACOCCO 
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

cata_msg={

1: _("""
Erreur utilisateur :
 Les deux champs suivants : %(k1)s et %(k2)s
 sont associ�s � deux maillages diff�rents : %(k3)s et %(k4)s
Risques & conseils :
 Si l'un des champs est de type ETAT_INIT, il faut que son maillage
 soit le meme que celui qui est associ� au mod�le.
"""),

2: _("""
 le CHAMP_S:  %(k1)s  est a la fois CHAM_ELEM_S et CHAM_NO_S.
"""),

3: _("""
 le CHAMP_S:  %(k1)s n'existe pas.
"""),

4: _("""
Erreur de programmation :
 On essaye de calculer l'int�grale d'un cham_elem / ELGA.
 Malheureusement, la famille de points de Gauss : %(k1)s n'est pas autoris�e dans la programmation.

Conseil :
  Si n�cessaire, il faut demander une �volution du code.
"""),

5: _("""
Erreur utilisateur dans CREA_RESU :
  Quand on utilise la commande CREA_RESU avec le mot cl� AFFE / CHAM_GD et que le
  champ est un champ de fonctions (de la g�om�trie et/ou du temps), il faut que la grandeur
  associ�e � ce champ soit TEMP_F, DEPL_F, PRES_F ou FORC_F.

  Ici, la grandeur est : %(k1)s
"""),

6: _("""
Erreur utilisateur dans PROJ_CHAMP :
  Le champ utilis� dans le mot cl� CHAM_NO_REFE (%(k1)s) est associ� au maillage %(k2)s
  Il doit etre associ� au maillage %(k3)s
"""),

7: _("""
 trop d'ant�c�dents
 v�rifiez si le maillage de l'interface ne contient pas de noeuds coincidents ou diminuez DIST_REFE.
"""),

8: _("""
  %(k1)s  valeurs de CHAMNO de deplacement n'ont pas ete recopiees sur  %(k2)s  noeuds
  a affecter  ce qui peut entrainer des erreurs de calcul sur la masse ajoutee des sous structures
  deduites par rotation et translation definies dans le modele  generalise. augmentez dist_refe
  ou assurez vous de l' invariance du maillage de structure par la translation et la rotation
  definies dans le modele generalise.
"""),

9: _("""
  -> plus de 50 %% des valeurs de CHAM_NO de d�placement n'ont pas �t� recopi�es
     ce qui peut entrainer des erreurs graves de calcul sur la masse ajout�e des
     sous structures d�duites par rotation et translation d�finies dans le mod�le g�n�ralis�
  -> Risque & Conseil :
     augmentez DIST_REFE
"""),

10: _("""
 trop de noeuds affect�s
"""),

11: _("""
 Erreur d'utilisation :
   Le maillage associ� au mod�le : %(k1)s
   n'est pas le meme que celui du champ de mat�riaux : %(k2)s
"""),

12: _("""
Erreur lors de la transformation du cham_no_s (%(k1)s) en cham_no (%(k2)s):
Le cham_no_s est vide (i.e. il n'a aucune valeur).
"""),

13: _("""
Erreur lors d'une transformation de cham_no_s en cham_no :
 Il manque la composante: %(k1)s  sur le noeud: %(k2)s pour le CHAM_NO: %(k3)s
"""),




21: _("""
 grandeur :  %(k1)s  inexistante au catalogue
"""),

22: _("""
 composante :  %(k1)s  inexistante au catalogue pour la grandeur : %(k2)s
"""),

23: _("""
 la grandeur : %(k1)s  n est pas de type reel.
"""),

24: _("""
 on traite un superelement  et le noeud courant n'est ni un noeud lagrange,
 ni un noeud physique du maillage.
"""),

25: _("""
 le ligrel :  %(k1)s  ne contient pas d elements finis
"""),

26: _("""
 l'option  %(k1)s  n'existe pas.
"""),

27: _("""
 Erreur utilisateur :
   Le maillage associ� au champ: %(k1)s  (%(k3)s)
   est different de celui associe au ligrel:  %(k2)s  (%(k4)s)
"""),

28: _("""
  erreur programmeur : appel a calcul, le champ: %(k1)s  est un champ "in" et un champ "out".
"""),

29: _("""
 la grandeur associ�e au champ  %(k1)s : %(k2)s
 n'est pas celle associ�e au param�tre  %(k3)s : %(k4)s  (option: %(k5)s
"""),

30: _("""
  on n'arrive pas a etendre la carte:  %(k1)s
"""),

33: _("""
Erreur Utilisateur :
 Pour le modele  %(k1)s  on ne peut pas visualiser ensemble plusieurs champs ELGA (%(k2)s,  ...)
 car les familles de points de Gauss sont differentes
"""),

35: _("""
Erreur Utilisateur :
 Aucun �l�ment du mod�le n'est visualisable avec ECLA_PG
"""),

36: _("""
 On ne trouve aucun point de Gauss
"""),

37: _("""
 le type de RESU_INIT est diff�rent de celui du r�sultat.
"""),

38: _("""
 la liste de num�ros d'ordre est vide.
"""),

39: _("""
 les seuls champs autoris�s pour ECLA_PG sont les champs r�els.
"""),

40: _("""
Erreur :
 Apr�s avoir retir� tous les �l�ments � sous-points du champ %(k1)s (grandeur: %(k2)s), celui-ci est vide.
"""),

41: _("""
 les seuls champs autorises sont elga.
"""),

42: _("""
 le TYPE_ELEM:  %(k1)s  n'a pas le nombre de points de Gauss d�clar� dans la routine ECLAU1.
"""),

43: _("""
 nombre de noeuds > 27
"""),

45: _("""
 famille de pg "liste" interdite: %(k1)s
"""),

46: _("""
  mode ligne  %(k1)s  /= mode colonne  %(k2)s
"""),

47: _("""
  le mode  %(k1)s  de code  %(k2)s  reference le mode  %(k3)s  dont le code :  %(k4)s  > 3
"""),

48: _("""
  pour le mode  %(k1)s  nombre de points  %(k2)s  < argument k :  %(k3)s
"""),

49: _("""
 carte inexistante.
"""),

51: _("""
 Erreur :
   Le code cherche � utiliser dans un calcul �l�mentaire un cham_elem "�tendu" (VARI_R ou sous-points).
   La programmation de la routine exchml.f ne sait pas encore traiter ce cas.
 Conseil :
   Il y a peut-etre lieu d'�mettre une demande d'�volution pour traiter ce cas.
"""),

52: _("""
 probleme noeud tardif pour un champ � repr�sentation constante
"""),






56: _("""
  erreur lors d'une extraction:
  le champ associe au parametre :  %(k1)s  n'est pas dans la liste des champs parametres.
"""),

61: _("""
 Erreur d�veloppeur :
 L'option que l'on calcule ne connait pas le param�tre :  %(k1)s
 Erreur probable dans un catalogue(typelem)
"""),

63: _("""
  -> La maille %(k1)s porte un �l�ment fini de bord, mais elle ne borde
     aucun �l�ment ayant une "rigidit�".

  -> Risque & Conseil :
     Cela peut entrainer des probl�mes de "pivot nul" lors de la r�solution.
     Si la r�solution des syst�mes lin�aires ne pose pas de probl�mes, vous
     pouvez ignorer ce message.
     Sinon, v�rifier la d�finition du mod�le (AFFE_MODELE) en �vitant l'utilisation
     de l'op�rande TOUT='OUI'.
"""),

64: _("""
  -> Le mod�le %(k1)s n'a pas d'�l�ments sachant calculer la rigidit�.

  -> Risque & Conseil :
     Ce mod�le ne poura donc pas (en g�n�ral) etre utilis� pour faire des calculs.
     V�rifier la d�finition du mod�le (AFFE_MODELE) et assurez-vous que les
     types de mailles du maillage (SEG2, TRIA3, QUAD4, ...) sont compatibles avec votre
     mod�lisation.
     Exemples d'erreur :
       * affecter une mod�lisation "3D" sur un maillage form� de facettes.
       * affecter une mod�lisation qui ne sait pas traiter tous les types de mailles du maillage
         (par exemple 'PLAN_DIAG' en thermique, 'AXIS_SI' en m�canique)
"""),

65: _("""
Erreur d'utilisation :
  -> Le mod�le %(k1)s n'a pas d'�l�ments sachant calculer la rigidit�.

  -> Risque & Conseil :
     Ce mod�le ne peut pas etre utilis� pour faire des calculs.
     V�rifier la d�finition du mod�le (AFFE_MODELE) et assurez-vous que les
     types de mailles du maillage (SEG2, TRIA3, QUAD4, ...) sont compatibles avec votre
     mod�lisation.
     Exemples d'erreur :
       * affecter une mod�lisation "3D" sur un maillage form� de facettes.
       * affecter une mod�lisation qui ne sait pas traiter tous les types de mailles du maillage
         (par exemple 'PLAN_DIAG' en thermique, 'AXIS_SI' en m�canique)
"""),

68: _("""
 maille partiellement affect�e.
"""),

69: _("""
 le parametre: %(k1)s  n'est pas un param�tre de l'option: %(k2)s
"""),

70: _("""
 le parametre: %(k1)s  n'est pas un param�tre de l'option: %(k2)s  pour le type_element:  %(k3)s
"""),

71: _("""
 on ne trouve pas dans les arguments de la routine CALCUL de champ � associer au parametre: %(k1)s
  - option: %(k2)s
  - type_element: %(k3)s
"""),

72: _("""
Erreur utilisateur dans un calcul �l�mentaire de forces r�parties :
  On n'a pas trouv� toutes les composantes voulues du champ pour le param�tre : %(k1)s
   - option        : %(k2)s
   - type_element  : %(k3)s
   - maille        : %(k4)s
  On a trouv� un noeud sur lequel il existe des composantes mais pas toutes.
  On ne peut pas continuer

Risques et conseils :
  Si le champ provient de CREA_CHAMP/AFFE, v�rifier que vous avez bien affect� FX,FY [FZ]
"""),

73: _("""
Erreur dans un calcul �l�mentaire :
  On n'a pas trouv� toutes les composantes voulues du champ pour le param�tre : %(k1)s
   - option        : %(k2)s
   - type_element  : %(k3)s
   - maille        : %(k4)s

Risques et conseils :
  Certaines informations sur le contexte de cette erreur sont imprim�es ci-dessous.
  Elles peuvent aider � comprendre une �ventuelle erreur d'utilisation.
"""),

74: _("""
Erreur utilisateur dans un calcul �l�mentaire :
  Le mat�riau est n�cessaire sur la maille : %(k4)s
  - option de calcul �l�mentaire : %(k2)s
  - type_element                 : %(k3)s

Conseils :
  * Peut-etre avez-vous oubli� de renseigner le mot cl� CHAM_MATER dans la commande courante.
  * Dans la commande AFFE_MATERIAU, avez-vous affect� un mat�riau sur la maille incrimin�e ?
"""),

75: _("""
Erreur utilisateur dans un calcul �l�mentaire :
  Des caract�ristiques de "coque" sont n�cessaires sur la maille : %(k4)s
  - option de calcul �l�mentaire : %(k2)s
  - type_element                 : %(k3)s

Conseils :
  * Peut-etre avez-vous oubli� de renseigner le mot cl� CARA_ELEM dans la commande courante.
  * Dans la commande AFFE_CARA_ELEM, avez-vous affect� des caract�ristiques de "coque"
    sur la maille incrimin�e ?
"""),

76: _("""
Erreur utilisateur dans un calcul �l�mentaire :
  Des caract�ristiques de "poutre" sont n�cessaires sur la maille : %(k4)s
  - option de calcul �l�mentaire : %(k2)s
  - type_element                 : %(k3)s

Conseils :
  * Peut-etre avez-vous oubli� de renseigner le mot cl� CARA_ELEM dans la commande courante.
  * Dans la commande AFFE_CARA_ELEM, avez-vous affect� des caract�ristiques de "poutre"
    sur la maille incrimin�e ?
"""),

77: _("""
Erreur utilisateur dans un calcul �l�mentaire :
  Des caract�ristiques d'"orientation" sont n�cessaires sur la maille : %(k4)s
  - option de calcul �l�mentaire : %(k2)s
  - type_element                 : %(k3)s

Conseils :
  * Peut-etre avez-vous oubli� de renseigner le mot cl� CARA_ELEM dans la commande courante.
  * Dans la commande AFFE_CARA_ELEM, avez-vous affect� des caract�ristiques d'"orientation"
    sur la maille incrimin�e ?
"""),





81: _("""
 pas de chgeom
"""),

82: _("""
 il faut un MODELE
"""),

86: _("""
 La carte de COMPORTEMENT est absente.
 Votre r�sultat a peut-�tre �t� produit par LIRE_RESU ou CREA_RESU.
 Si votre r�sultat a �t� produit par LIRE_RESU, il faut renseigner le mot-cl� COMP_INCR.
"""),

87: _("""
 impossible lire  %(k1)s
"""),

88: _("""
 L'option %(k1)s  n'est disponible pour aucun des �l�ments de votre mod�le.
 Le calcul d'indicateur d'erreur est donc impossible.
"""),

89: _("""
 option  %(k1)s  non disponible sur les �l�ments du mod�le
 pas de champ cr��
"""),

92: _("""
 votre chargement contient plus d'une charge r�partie
 le calcul n'est pas possible pour les mod�les de poutre.
"""),

93: _("""
  -> Vous avez renseign� un des mots-cl�s fonc_mult_*, coef_mult_*,
     PHAS_DEG, PUIS_PULS, or votre charge ne contient pas d'effort r�parti
     sur des poutres. Ces mots-cl�s seront donc ignor�s.
  -> Risque & Conseil :
"""),

94: _("""
 pour un mod�le comportant des �l�ments de plaque ou de coque
 il faut fournir le "CARA_ELEM"
"""),

98: _("""
 la charge doit �tre une charge m�canique
"""),

99: _("""
 option  %(k1)s non licite pour un calcul non lin�aire.
"""),
}
