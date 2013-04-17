#@ MODIF calculel2 Messages  DATE 15/04/2013   AUTEUR PELLET J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

1: _(u"""
Erreur utilisateur :
 Les deux champs suivants : %(k1)s et %(k2)s
 sont associ�s � deux maillages diff�rents : %(k3)s et %(k4)s
Risques & conseils :
 Si l'un des champs est de type ETAT_INIT, il faut que son maillage
 soit le m�me que celui qui est associ� au mod�le.
"""),

2: _(u"""
 le CHAMP_S:  %(k1)s  est a la fois CHAM_ELEM_S et CHAM_NO_S.
"""),

3: _(u"""
 le CHAMP_S:  %(k1)s n'existe pas.
"""),

4: _(u"""
Erreur de programmation :
 On essaye de calculer l'int�grale d'un CHAM_ELEM / ELGA.
 Malheureusement, la famille de points de Gauss : %(k1)s n'est pas autoris�e dans la programmation.

Conseil :
  Si n�cessaire, il faut demander une �volution du code.
"""),

5: _(u"""
Erreur dans CREA_RESU :
  Quand on utilise la commande CREA_RESU avec le mot cl� AFFE / CHAM_GD, les
  composantes du champ de fonctions %(k2)s (de la g�om�trie et/ou du temps),
  doivent �tre au m�me rang que celles du champ de r�els %(k1)s.
Incoh�rence dans les grandeurs %(k1)s et %(k2)s :
  Le rang de la composante %(k3)s de %(k1)s correspond
  au rang de la composante %(k4)s de %(k2)s.

Conseil :
  Si n�cessaire, il faut demander une �volution du code.
"""),

6: _(u"""
Erreur utilisateur dans PROJ_CHAMP :
  Le champ utilis� dans le mot cl� CHAM_NO_REFE (%(k1)s) est associ� au maillage %(k2)s
  Il doit �tre associ� au maillage %(k3)s
"""),

7: _(u"""
 trop d'ant�c�dents
 v�rifiez si le maillage de l'interface ne contient pas de noeuds co�ncidents ou diminuez DIST_REFE.
"""),

8: _(u"""
  %(k1)s  valeurs de CHAMNO de d�placement n'ont pas �t� recopi�es sur  %(k2)s  noeuds
  a affecter  ce qui peut entra�ner des erreurs de calcul sur la masse ajout�e des sous structures
  d�duites par rotation et translation d�finies dans le mod�le  g�n�ralis�. augmentez DIST_REFE
  ou assurez vous de l' invariance du maillage de structure par la translation et la rotation
  d�finies dans le mod�le g�n�ralis�.
"""),

9: _(u"""
  -> plus de 50 %% des valeurs de CHAM_NO de d�placement n'ont pas �t� recopi�es
     ce qui peut entra�ner des erreurs graves de calcul sur la masse ajout�e des
     sous structures d�duites par rotation et translation d�finies dans le mod�le g�n�ralis�
  -> Risque & Conseil :
     augmentez DIST_REFE
"""),

10: _(u"""
 trop de noeuds affect�s
"""),

11: _(u"""
 Erreur d'utilisation :
   Le maillage associ� au mod�le : %(k1)s
   n'est pas le m�me que celui du champ de mat�riaux : %(k2)s
"""),

12: _(u"""
Erreur lors de la transformation du CHAM_NO_S (%(k1)s) en CHAM_NO (%(k2)s):
Le CHAM_NO_S est vide (i.e. il n'a aucune valeur).
"""),

13: _(u"""
Erreur lors d'une transformation d'un CHAM_NO_S en CHAM_NO :
  Il manque la composante: %(k1)s  sur le noeud: %(k2)s pour le CHAM_NO: %(k3)s

Risques & conseils :
  Si cette erreur se produit dans la commande CREA_CHAMP, il est possible de
  mettre � z�ro les composantes manquantes en utilisant le mot-cl� PROL_ZERO.
"""),

14: _(u"""
Erreur utilisateur dans la commande POST_CHAMP :
 On demande l'extraction des champs sur une couche de num�ro sup�rieur au nombre de couches.
"""),

15: _(u"""
Erreur utilisateur dans la commande POST_CHAMP :
 On demande l'extraction pour des champs n'ayant pas de "sous-points".
"""),

16: _(u"""
Erreur utilisateur dans la commande POST_CHAMP :
 On demande l'extraction des champs sur une fibre de num�ro sup�rieur au nombre de fibres.
"""),

17: _(u"""
Erreur utilisateur dans la commande CREA_CHAMP :
 Incoh�rence entre le champ %(k1)s associ� au maillage %(k2)s
 et le maillage %(k3)s
"""),

18: _(u"""
Erreur utilisateur dans la commande POST_CHAMP / MIN_MAX_SP :
 La composante demand�e %(k1)s n'est pas trouv�e dans le champ %(k2)s
"""),

19: _(u"""
Erreur utilisateur dans la commande POST_CHAMP / COQUE_EXCENT :
 Pour l'occurrence %(i1)d du mot cl� COQUE_EXCENT,
 et pour le num�ro d'ordre %(i2)d le champ calcul� est vide.
"""),

20: _(u"""
Erreur utilisateur dans la commande POST_CHAMP / COQUE_EXCENT :
 La structure de donn�e produite est vide.
"""),

21: _(u"""
 grandeur :  %(k1)s  inexistante au catalogue
"""),

22: _(u"""
 composante :  %(k1)s  inexistante au catalogue pour la grandeur : %(k2)s
"""),

23: _(u"""
 la grandeur : %(k1)s  n est pas de type r�el.
"""),

24: _(u"""
 on traite un super-�l�ment  et le noeud courant n'est ni un noeud Lagrange,
 ni un noeud physique du maillage.
"""),

25: _(u"""
 le LIGREL :  %(k1)s  ne contient pas d �l�ments finis
"""),

26: _(u"""
 l'option  %(k1)s  n'existe pas.
"""),

27: _(u"""
 Erreur utilisateur :
   Le maillage associ� au champ: %(k1)s  (%(k3)s)
   est diff�rent de celui associe au LIGREL:  %(k2)s  (%(k4)s)
"""),

28: _(u"""
  erreur programmeur : appel a calcul, le champ: %(k1)s  est un champ "in" et un champ "out".
"""),

29: _(u"""
 la grandeur associ�e au champ  %(k1)s : %(k2)s
 n'est pas celle associ�e au param�tre  %(k3)s : %(k4)s  (option: %(k5)s
"""),

30: _(u"""
  on n'arrive pas a �tendre la carte:  %(k1)s
"""),

31: _(u"""
Erreur utilisateur dans la commande AFFE_CARA_ELEM :
  On a affect� un excentrement non nul (mot cl� COQUE / EXCENTREMENT)
  sur un �l�ment qui ne sait pas traiter l'excentrement (maille %(k1)s).
"""),

33: _(u"""
Erreur Utilisateur :
 Pour le mod�le  %(k1)s  on ne peut pas visualiser ensemble plusieurs champs ELGA (%(k2)s,  ...)
 car les familles de points de Gauss sont diff�rentes
"""),

35: _(u"""
Erreur Utilisateur :
 Aucun �l�ment du mod�le n'est visualisable avec ECLA_PG
"""),

36: _(u"""
 On ne trouve aucun point de Gauss
"""),

37: _(u"""
 le type de RESU_INIT est diff�rent de celui du r�sultat.
"""),

38: _(u"""
 la liste de num�ros d'ordre est vide.
"""),

39: _(u"""
 les seuls champs autoris�s pour ECLA_PG sont les champs r�els.
"""),

40: _(u"""
Erreur :
 Apr�s avoir retir� tous les �l�ments � sous-points du champ %(k1)s (grandeur: %(k2)s), celui-ci est vide.
"""),

41: _(u"""
 les seuls champs autorises sont ELGA.
"""),

42: _(u"""
 le TYPE_ELEM:  %(k1)s  n'a pas le nombre de points de Gauss d�clar� dans la routine ECLAU1.
"""),

43: _(u"""
 nombre de noeuds > 27
"""),

44: _(u"""
   Le mod�le n'a pas �t� trouv�. Le calcul n'est pas possible.
"""),

45: _(u"""
 famille de points de Gauss "liste" interdite: %(k1)s
"""),

46: _(u"""
  mode ligne  %(k1)s  /= mode colonne  %(k2)s
"""),

47: _(u"""
  le mode  %(k1)s  de code  %(k2)s  r�f�rence le mode  %(k3)s  dont le code :  %(k4)s  > 3
"""),

48: _(u"""
  pour le mode  %(k1)s  nombre de points  %(k2)s  < argument k :  %(k3)s
"""),

49: _(u"""
 carte inexistante.
"""),

50: _(u"""
Erreur utilisateur :
  Le champ %(k1)s n'est pas associ� au maillage %(k2)s.
"""),

51: _(u"""
 Erreur :
   Le code cherche � utiliser dans un calcul �l�mentaire un CHAM_ELEM "�tendu" (VARI_R ou sous-points).
   La programmation de la routine exchml.f ne sait pas encore traiter ce cas.
 Conseil :
   Il y a peut-�tre lieu d'�mettre une demande d'�volution pour traiter ce cas.
"""),

52: _(u"""
 probl�me noeud tardif pour un champ � repr�sentation constante
"""),

53: _(u"""
 Le calcul de l'option %(k1)s n'est pas possible. Il manque le CARA_ELEM.
"""),

54: _(u"""
 Le calcul de l'option %(k1)s n'est pas possible. Il manque le CHAM_MATER.
"""),

55: _(u"""
 Le calcul de l'option %(k1)s n'est pas possible. Il manque le MODELE.
"""),

56: _(u"""
  erreur lors d'une extraction:
  le champ associe au param�tre :  %(k1)s  n'est pas dans la liste des champs param�tres.
"""),








61: _(u"""
 Erreur d�veloppeur :
 L'option que l'on calcule ne conna�t pas le param�tre :  %(k1)s
 Erreur probable dans un catalogue(typelem)
"""),

62: _(u"""
 Erreur utilisateur POST_CHAMP /MIN_MAX_SP :
  Il n'y a rien � calculer car le champ  %(k1)s n'existe pas pour les num�ros d'ordre indiqu�s.
"""),

63: _(u"""
  -> La maille %(k1)s porte un �l�ment fini de bord, mais elle ne borde
     aucun �l�ment ayant une "rigidit�".

  -> Risque & Conseil :
     Cela peut entra�ner des probl�mes de "pivot nul" lors de la r�solution.
     Si la r�solution des syst�mes lin�aires ne pose pas de probl�mes, vous
     pouvez ignorer ce message.
     Sinon, v�rifier la d�finition du mod�le (AFFE_MODELE) en �vitant l'utilisation
     de l'op�rande TOUT='OUI'.
"""),

64: _(u"""
  -> Le mod�le %(k1)s n'a pas d'�l�ments sachant calculer la rigidit�.

  -> Risque & Conseil :
     Ce mod�le ne pourra donc pas (en g�n�ral) �tre utilis� pour faire des calculs.
     V�rifier la d�finition du mod�le (AFFE_MODELE) et assurez-vous que les
     types de mailles du maillage (SEG2, TRIA3, QUAD4, ...) sont compatibles avec votre
     mod�lisation.
     Exemples d'erreur :
       * affecter une mod�lisation "3D" sur un maillage form� de facettes.
       * affecter une mod�lisation qui ne sait pas traiter tous les types de mailles du maillage
         (par exemple 'PLAN_DIAG' en thermique, 'AXIS_SI' en m�canique)
"""),

65: _(u"""
Erreur d'utilisation :
  -> Le mod�le %(k1)s n'a pas d'�l�ments sachant calculer la rigidit�.

  -> Risque & Conseil :
     Ce mod�le ne peut pas �tre utilis� pour faire des calculs.
     V�rifier la d�finition du mod�le (AFFE_MODELE) et assurez-vous que les
     types de mailles du maillage (SEG2, TRIA3, QUAD4, ...) sont compatibles avec votre
     mod�lisation.
     Exemples d'erreur :
       * affecter une mod�lisation "3D" sur un maillage form� de facettes.
       * affecter une mod�lisation qui ne sait pas traiter tous les types de mailles du maillage
         (par exemple 'PLAN_DIAG' en thermique, 'AXIS_SI' en m�canique)
"""),

66: _(u"""Erreur d'utilisation :
 On ne peut pas utiliser plus de 50 param�tres pour �valuer une fonction.
 Ici, les diff�rents champs du mot-cl� CHAM_PARA poss�dent au total plus de 50 composantes.
"""),

67: _(u"""Erreur d'utilisation :
 On ne peut pas filtrer les mailles de type %(k1)s car ce n'est pas un type de maille connu.
"""),

68: _(u"""
 maille partiellement affect�e.
"""),

69: _(u"""
 le param�tre: %(k1)s  n'est pas un param�tre de l'option: %(k2)s
"""),

70: _(u"""
 le param�tre: %(k1)s  n'est pas un param�tre de l'option: %(k2)s  pour le type_�l�ment:  %(k3)s
"""),

71: _(u"""
 on ne trouve pas dans les arguments de la routine CALCUL de champ � associer au param�tre: %(k1)s
  - option: %(k2)s
  - type_�l�ment: %(k3)s
"""),

72: _(u"""
Erreur utilisateur dans un calcul �l�mentaire de forces r�parties :
  On n'a pas trouv� toutes les composantes voulues du champ pour le param�tre : %(k1)s
   - option        : %(k2)s
   - type_�l�ment  : %(k3)s
   - maille        : %(k4)s
  On a trouv� un noeud sur lequel il existe des composantes mais pas toutes.
  On ne peut pas continuer

Risques et conseils :
  Si le champ provient de CREA_CHAMP/AFFE, v�rifier que vous avez bien affect� FX,FY [FZ]
"""),

73: _(u"""
Erreur dans un calcul �l�mentaire :
  On n'a pas trouv� toutes les composantes voulues du champ pour le param�tre : %(k1)s
   - option        : %(k2)s
   - type_�l�ment  : %(k3)s
   - maille        : %(k4)s

Risques et conseils :
  Certaines informations sur le contexte de cette erreur sont imprim�es ci-dessous.
  Elles peuvent aider � comprendre une �ventuelle erreur d'utilisation.
"""),

74: _(u"""
Erreur utilisateur dans un calcul �l�mentaire :
  Le mat�riau est n�cessaire sur la maille : %(k4)s
  - option de calcul �l�mentaire : %(k2)s
  - type_�l�ment                 : %(k3)s

Conseils :
  * Peut-�tre avez-vous oubli� de renseigner le mot cl� CHAM_MATER dans la commande courante.
  * Dans la commande AFFE_MATERIAU, avez-vous affect� un mat�riau sur la maille incrimin�e ?
"""),

75: _(u"""
Erreur utilisateur dans un calcul �l�mentaire :
  Des caract�ristiques de "coque" sont n�cessaires sur la maille : %(k4)s
  - option de calcul �l�mentaire : %(k2)s
  - type_�l�ment                 : %(k3)s

Conseils :
  * Peut-�tre avez-vous oubli� de renseigner le mot cl� CARA_ELEM dans la commande courante.
  * Dans la commande AFFE_CARA_ELEM, avez-vous affect� des caract�ristiques de "coque"
    sur la maille incrimin�e ?
"""),

76: _(u"""
Erreur utilisateur dans un calcul �l�mentaire :
  Des caract�ristiques de "poutre" sont n�cessaires sur la maille : %(k4)s
  - option de calcul �l�mentaire : %(k2)s
  - type_�l�ment                 : %(k3)s

Conseils :
  * Peut-�tre avez-vous oubli� de renseigner le mot cl� CARA_ELEM dans la commande courante.
  * Dans la commande AFFE_CARA_ELEM, avez-vous affect� des caract�ristiques de "poutre"
    sur la maille incrimin�e ?
"""),

77: _(u"""
Erreur utilisateur dans un calcul �l�mentaire :
  Des caract�ristiques d'"orientation" sont n�cessaires sur la maille : %(k4)s
  - option de calcul �l�mentaire : %(k2)s
  - type_�l�ment                 : %(k3)s

Conseils :
  * Peut-�tre avez-vous oubli� de renseigner le mot cl� CARA_ELEM dans la commande courante.
  * Dans la commande AFFE_CARA_ELEM, avez-vous affect� des caract�ristiques d'"orientation"
    sur la maille incrimin�e ?
"""),

78: _(u"""
Erreur utilisateur :
  Pour �valuer une fonction, Il ne faut pas fournir plusieurs fois le m�me param�tre.
  Ici, le param�tre %(k1)s a �t� fourni plus d'une fois.

Conseil :
  Si les champs utilis�s avec le mot cl� CHAM_PARA ont �t� obtenus avec la commande CREA_CHAMP,
  on peut voir leur contenu avec le mot cl� INFO=2.
"""),

79: _(u"""
Erreur dans CREA_RESU :
  Quand on utilise la commande CREA_RESU / EVOL_VARC avec le mot cl� AFFE / CHAM_GD et
  que le champ de fonctions est %(k2)s_F (de la g�om�trie et/ou du temps),
  NOM_CHAM doit �tre %(k2)s et pas %(k1)s.
"""),

80: _(u"""
Erreur dans CREA_RESU :
  Quand on utilise la commande CREA_RESU avec le mot cl� AFFE / CHAM_GD :
  le champ de fonctions %(k2)s doit avoir le m�me nombre d'entier cod�s que le
  champ de r�els %(k1)s.
    %(k2)s : %(i2)d entier cod�
    %(k1)s : %(i1)d entier cod�

Conseil :
  Si n�cessaire, il faut demander une �volution du code.
"""),

81: _(u"""
Erreur utilisateur :
  Calcul de la d�formation thermique d'un �l�ment de grille.
  On ne trouve pas de temp�rature sur le maille %(k1)s.
"""),

82: _(u"""
 il faut un MODELE
"""),

86: _(u"""
 La carte de COMPORTEMENT est absente.
 Votre r�sultat a peut-�tre �t� produit par LIRE_RESU ou CREA_RESU.
 Si votre r�sultat a �t� produit par LIRE_RESU, il faut renseigner le mot-cl� COMP_INCR.
"""),

88: _(u"""
 L'option %(k1)s  n'est disponible pour aucun des �l�ments de votre mod�le.
 Le calcul d'indicateur d'erreur est donc impossible.
"""),

89: _(u"""
 Alarme utilisateur :
   Le champ  %(k1)s  n'a pas pu �tre calcul�.

 Risques & conseils :
   * Si le champ est un champ par �l�ments, c'est que le calcul �l�mentaire n'est pas disponible
     pour les �l�ments finis utilis�s. Cela peut se produire soit parce que ce
     calcul n'a pas �t� encore programm�, soit parce que ce calcul n'a pas de sens.
     Par exemple, le champ EFGE_ELNO n'a pas de sens pour les �l�ments de la mod�lisation '3D'.
   * Si le champ est un champ aux noeuds (XXXX_NOEU), cela veut dire que le champ XXXX_ELNO
     n'existe pas sur les �l�ments sp�cifi�s.
     Par exemple, le calcul de SIGM_NOEU sur les �l�ments de bord est impossible.

"""),

90: _(u"""
Erreur dans CREA_RESU :
  Quand on utilise la commande CREA_RESU avec le mot cl� AFFE / CHAM_GD et que
  le champ de fonctions est %(k2)s_F (de la g�om�trie et/ou du temps),
  le champ de r�els doit �tre %(k1)s_R.

Conseil :
  V�rifier la construction du champ de fonctions est %(k2)s_F
"""),

92: _(u"""
 votre chargement contient plus d'une charge r�partie
 le calcul n'est pas possible pour les mod�les de poutre.
"""),

94: _(u"""
 pour un mod�le comportant des �l�ments de plaque ou de coque
 il faut fournir le "CARA_ELEM"
"""),

}
