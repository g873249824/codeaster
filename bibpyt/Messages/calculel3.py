#@ MODIF calculel3 Messages  DATE 02/02/2011   AUTEUR PELLET J.PELLET 
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
 manque les acc�l�rations
"""),

2 : _("""
 pour une SD RESULTAT de type DYNA_TRANS,
 seuls les mots-cl�s FONC_MULT et COEF_MULT sont autoris�s
"""),

3 : _("""
 pour une SD RESULTAT de type  EVOL_ELAS,
 seul le mot-cl� fonc_mult est autoris�
"""),

4 : _("""
 l'utilisation du mot-cl� FONC_MULT n'est licite que pour
 les SD RESULTATS :  EVOL_ELAS, DYNA_TRANS, DYNA_HARMO
"""),

5 : _("""
  pour calculer  %(k1)s  il faut SIEF_ELNO ou EFGE_ELNO
"""),

6 : _("""
  option  %(k1)s  non trait�e pour un r�sultat de type  %(k2)s
"""),

7 : _("""
 Calcul de  %(k1)s  impossible.
"""),

8 : _("""
 les champs SIEF_ELGA, SICO_ELNO et SIGM_ELNO sont absents :
 on ne peut pas calculer l'option %(k1)s  avec la SD de type  %(k2)s
"""),

9 : _("""
 Le champ  SIGM_ELNO est absent :
 on ne peut pas calculer l'option %(k1)s  avec la SD de type  %(k2)s.
"""),

10 : _("""
 Le champ  SICO_ELNO est absent :
 on ne peut pas calculer l'option %(k1)s  avec la SD de type  %(k2)s.
"""),

11 : _("""
 le r�sultat  %(k1)s  doit comporter un champ de d�placement au num�ro d'ordre  %(k2)s  .
"""),

12 : _("""
 Le mot cl� PREC_ERR est OBLIGATOIRE avec l'option SING_ELEM.
 Il faut renseigner le mot cl� PREC_ERR avec une valeur comprise entre 0 et 1.
"""),

13 : _("""
 Le mot cl� PREC_ERR doit etre strictement positif.
"""),

14 : _("""
 Il n'y a pas de champ d'estimateur d'erreur dans la structure de donn�e r�sultat.
 On ne calcule pas l'option SING_ELEM.
 Le calcul pr�alable d'un estimateur d'erreur est OBLIGATOIRE pour le calcul de cette option.
"""),

15: _("""
 Par d�faut on utilise l'estimateur en r�sidu ERME_ELEM.
"""),

16 : _("""
 Par d�faut on utilise l'estimateur bas� sur les contraintes liss�es version 2 ERZ2_ELEM.
"""),

17 : _("""
 le r�sultat  %(k1)s  doit comporter un champ de contraintes au num�ro d'ordre  %(k2)s  .
"""),

18 : _("""
 pas de champ de contraintes pour calculer  %(k1)s
"""),

19 : _("""
 probleme � l'appel de ALCHML pour  %(k1)s
"""),

20 : _("""
 pas de champ d'endommagement pour calculer  %(k1)s
"""),

21 : _("""
 le calcul avec l'option ENDO_ELNO n�cessite au pr�alable un calcul avec l'option ENDO_ELGA
"""),

22 : _("""
  L'option %(k1)s est inexistante.
"""),

23 : _("""
 option :  %(k1)s
"""),

24: _("""
 <I> L'estimateur que vous avez choisi pour le calcul de l'option SING_ELEM est %(k1)s.
"""),

25 : _("""
 calcul non disponible
"""),

26: _("""
 L'estimateur %(k1)s que vous avez choisi pour le calcul de l'option SING_ELEM
 n'existe pas dans la structure de donn�e r�sultat %(k2)s.
 L'option SING_ELEM n'est pas calcul�e.
"""),

27 : _("""
 type :  %(k1)s  incompatible avec l'option :  %(k2)s
"""),

28 : _("""
 type de champ inconnu
"""),

29 : _("""
 Il n'y a pas de champ d'�nergie dans la structure de donn�e r�sultat.
 On ne calcule pas l'option SING_ELEM.
 Le calcul pr�alable de l'option  EPOT_ELEM ou ETOT_ELEM est OBLIGATOIRE
 pour le calcul de cette option.
"""),

30 : _("""
 il faut un mod�le ou des charges.
"""),

31 : _("""
 la masse du MACR_ELEM : %(k1)s  n'a pas encore ete calcul�e.
"""),

32 : _("""
 il manque des masses.
"""),

33 : _("""
 la rigidit� du MACR_ELEM : %(k1)s  n'a pas encore �t� calcul�e.
"""),

34 : _("""
 il manque des rigidit�s.
"""),

35 : _("""
 le mod�le doit contenir des �l�ments finis ou des sous-structures.
"""),

36 : _("""
 A cause des alarmes pr�c�dentes, l'option SING_ELEM n'est pas calcul�e.
"""),

38 : _("""
 on ne traite pas le type_scalaire: %(k1)s
"""),

39 : _("""
 le mod�le contient des �l�ments de structure
 il faut probablement utiliser le mot-cl� CARA_ELEM.
"""),

40 : _("""
  -> Le mod�le a probablement besoin d'un champ de mat�riau (mot-cl� CHAM_MATER).

  -> Risque & Conseil :
     Ce message peut aider � comprendre un �ventuel probl�me ult�rieur lors de calculs �l�mentaires
     n�cessitant des caract�ristiques mat�rielles.
     V�rifiez si votre mod�lisation n�cessite un CHAM_MATER.
"""),

41 : _("""
 les charges ne s'appuient pas toutes sur le meme mod�le.
"""),

42 : _("""
 les charges ne s'appuient pas sur le mod�le donn� en argument.
"""),

43 : _("""
 les charges sont de type diff�rent.
"""),

44 : _("""
 les charges ne s'appuient pas toutes sur le meme mod�le
"""),

45 : _("""
 donn�es incorrectes.
"""),

46 : _("""
Erreur de programmation :
  On cherche � utiliser dans CALCUL un cham_elem "IN" ayant %(i1)d composantes
  alors que le catalogue de l'�l�ment en attend %(i2)d.

Conseils :
  Il s'agit probablement d'une erreur de programmation.
  Mais il faut peut etre �mettre une demande d'�volution pour traiter ce cas.
"""),

47 : _("""
Possible erreur d'utilisation :
  Vous voulez "poursuivre" un calcul non-lin�aire (STAT_NON_LINE ou DYNA_NON_LINE).
  Pour cela, vous pr�cisez un �tat initial (mot cl� ETAT_INIT / EVOL_NOLI).
  Pour le calcul du 1er pas de temps, le champ des variables internes du d�but du pas est pris
  dans le concept evol_noli fourni.
  Pour l'�l�ment port� par la maille %(k1)s, ce champ de variables internes a �t� calcul� avec
  la relation de comportement %(k2)s, mais le comportement choisi pour le calcul est diff�rent (%(k3)s).

Risques & conseils :
  Ce changement de comportement est-il volontaire ou s'agit-il d'une faute de frappe ?
"""),

48 : _("""
Possible erreur d'utilisation :
  Vous voulez "poursuivre" un calcul non-lin�aire (STAT_NON_LINE ou DYNA_NON_LINE).
  Pour cela, vous pr�cisez un �tat initial (mot cl� ETAT_INIT / VARI=chvari).
  Pour le calcul du 1er pas de temps, le champ des variables internes utilis� pour le d�but du pas
  est "chvari".
  Pour l'�l�ment port� par la maille %(k1)s, ce champ de variables internes n'a pas le meme nombre de
  variables internes (%(i1)d) que le nombre attendu par le comportement choisi pour le calcul (%(i2)d).

  Il y a donc un changement de comportement pour la maille %(k1)s

  Un changement de comportement lors d'un transitoire est a priori "douteux".
  Il semble que vous soyez dans l'un des cas tol�r�s par le code :
    / comportement "-" �lastique
    / comportement "+" �lastique

  Sur cet �l�ment, les variables internes "-" sont mises � z�ro.

Risques & conseils :
  Ce changement de comportement est-il volontaire ou s'agit-il d'une faute de frappe ?
"""),

49 : _("""
Erreur d'utilisation :
  Vous voulez "poursuivre" un calcul non-lin�aire (STAT_NON_LINE ou DYNA_NON_LINE).
  Pour cela, vous pr�cisez un �tat initial (mot cl� ETAT_INIT / VARI=chvari).
  Pour le calcul du 1er pas de temps, le champ des variables internes utilis� pour le d�but du pas
  est "chvari".
  Pour l'�l�ment port� par la maille %(k1)s, ce champ de variables internes n'a pas le meme nombre de
  variables internes (%(i1)d) que le nombre attendu par le comportement choisi pour le calcul (%(i2)d).

  Il y a donc un changement de comportement pour la maille %(k1)s
  Le code n'accepte de changement de comportement que dans quelques cas tr�s particuliers :
    - LEMAITRE <-> VMIS_ISOT_XXXX
    - ELAS     <-> XXXX
  Il ne semble pas que vous soyez dans ce cas de figure. L'ex�cution est arret�e.

Risques & conseils :
  V�rifiez le comportement affect� sur cette maille.
"""),

50 : _("""
 La commande a besoin d'un nom de mod�le.
"""),

51 : _("""
  Erreur Utilisateur :
    On essaie d'utiliser dans la commande %(k1)s
    un mod�le pour lequel des �l�ments finis ont �t� affect�s directement
    sur des noeuds (AFFE_MODELE / AFFE / GROUP_NO).
    Ceci est interdit.

  Conseils :
    Il faut d�finir le mod�le avec les mots cl� GROUP_MA et MAILLE.
    Pour cela, il faut cr�er dans le maillage des mailles de type POI1.
    C'est possible avec la commande CREA_MAILLAGE / CREA_POI1.
"""),

52 : _("""
 le champ doit �tre un CHAM_ELEM.
"""),

53 : _("""
 ne traite qu'un CHAM_ELEM r�el
"""),

54 : _("""
 longueurs des modes locaux imcompatibles entre eux.
"""),

55 : _("""
Erreur utilisateur dans CALC_ELEM:
  Pour pouvoir calculer SIEQ_ELNO sur un concept de type comb_fourier,
  il faut avoir calcul� au pr�alable l'option 'SIEF_ELGA'
"""),





57 : _("""
 on ne sait pas moyenner cette composante negative
"""),

58 : _("""
 champs sur modeles differents
"""),

59 : _("""
  %(k1)s  doit etre un cham_elem.
"""),

60 : _("""
 longueurs des modes locaux champ1 imcompatibles entre eux.
"""),

61 : _("""
 longueurs des modes locaux champ2 imcompatibles entre eux.
"""),

62 : _("""
 composante non definie
"""),

63 : _("""
 champ de geometrie non trouve
"""),

64 : _("""
 l'instant du calcul est pris  arbitrairement a 0.0
"""),

65 : _("""
  on n'accepte un instant arbitraire que si le concept deformations anelastiques n'a qu'1 champ.
"""),

66 : _("""
  le concept evol_noli :  %(k1)s  ne contient aucun champ de d�formations an�lastiques.
"""),

71 : _("""
 il faut 1 chargement de rotation et un seul.
"""),

72 : _("""
  il ne faut pas definir plus d"un champ de vitesse
"""),

73 : _("""
 le champ:  %(k1)s  n'est ni un cham_elem ni un resuelem
"""),

74 : _("""
 type scalaire interdit : %(k1)s
"""),

78 : _("""
Utilisation de LIAISON_ELEM / OPTION='%(k1)s', occurence %(i1)d :
Le noeud "poutre" (GROUP_NO_2) n'est pas situ� g�om�triquement au m�me endroit que
le centre de gravit� de la section (GROUP_MA_1). La distance entre les 2 noeuds est
sup�rieure � %(r7)g%% du "rayon" (Aire/Pi)^0.5 de la section.
   Position du centre de gravit� de la section :
      %(r1)g   %(r2)g   %(r3)g
   Position du noeud "poutre" :
      %(r4)g   %(r5)g   %(r6)g
   Distance : %(r9)g
   Rayon    : %(r8)g
"""),

79 : _("""
 la matrice A est singuli�re
"""),

80 : _("""
 Utilisation de LIAISON_ELEM / OPTION='%(k1)s', occurence %(i1)d :
Le noeud "poutre" (GROUP_NO_2) n'est pas situ� g�om�triquement au m�me endroit que
le centre de gravit� de la section (GROUP_MA_1). La distance entre les 2 noeuds est
sup�rieure � %(r7)g%% du "rayon" (Aire/Pi)^0.5 de la section.
   Position du centre de gravit� de la section :
      %(r1)g   %(r2)g   %(r3)g
   Position du noeud "poutre" :
      %(r4)g   %(r5)g   %(r6)g
   Distance : %(r9)g
   Rayon    : %(r8)g

Risque et conseils :
   V�rifiez la position du noeud "poutre".
   Rappel : on ne peut pas utiliser ce type de liaison pour relier une poutre avec
   une section 3D qui ne serait que partiellement maill�e (sym�trie du maillage).
"""),

81 : _("""
 cette fonction ne marche que pour des modes locaux de type chno, vect, ou mat
"""),

82 : _("""
 le mode local est de type matrice non_carree
"""),

84 : _("""
 il n y a pas de parametre  %(k1)s  associe a la grandeur: %(k2)s  dans l option: %(k3)s
"""),

85 : _("""
 il y a plusieurs parametres  %(k1)s  associes a la grandeur: %(k2)s  dans l option: %(k3)s
"""),

88: _("""
 Les charges ne s'appuie pas sur le MODELE fourni.
"""),

89 : _("""
 les charges ne s'appuient pas toutes sur le m�me mod�le.
"""),

91 : _("""
 une des charges n'est pas m�canique
"""),

92 : _("""
 erreur: une des charges n'est pas thermique
"""),

93 : _("""
 une des charges n'est pas acoustique
"""),

94 : _("""
 le champ doit �tre un CHAM_ELEM aux points de gauss
"""),

95 : _("""
 avec un CHAM_ELEM calcule sur une liste de maille,
 il faut utiliser le mot cle "MODELE"
"""),

96 : _("""
  pour prendre en compte les termes d'inertie,
  il est pr�f�rable d'utiliser la commande "CALC_ELEM".
  le mot cle "ACCE" n'est pas trait� et les r�sultats risquent d'�tre faux.
"""),

97 : _("""
  Erreur d'utilisation :
    Fonctionnalit� : projection de maillage
    On cherche � projeter des mailles sur certains noeuds.
    Mais la liste des noeuds que l'on arrive � projeter dans les mailles est vide.

  Conseil :
    Cette erreur peut venir d'une mauvaise utilisation du mot cl�
    PROJ_CHAMP/DISTANCE_MAX
"""),

98 : _("""
 Le calcul de carte de taille et de d�tection de singularit� n'est pas
 programm� en 3D pour les �l�ments de type HEXA, PENTA et PYRAM.
"""),

99 : _("""
 Probl�me de convergence pour calculer la nouvelle carte de taille.
"""),


}
