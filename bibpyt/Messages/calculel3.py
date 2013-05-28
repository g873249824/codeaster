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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

1 : _(u"""
 manque les acc�l�rations
"""),

2 : _(u"""
 pour une SD RESULTAT de type DYNA_TRANS,
 seuls les mots-cl�s FONC_MULT et COEF_MULT sont autoris�s
"""),

3 : _(u"""
 pour une SD RESULTAT de type  EVOL_ELAS,
 seul le mot-cl� FONC_MULT est autoris�
"""),

4 : _(u"""
 l'utilisation du mot-cl� FONC_MULT n'est licite que pour
 les structures de donn�es r�sultat :  EVOL_ELAS, DYNA_TRANS, DYNA_HARMO
"""),

5 : _(u"""
 La composante %(k1)s n'existe pas dans le champ.
"""),

6 : _(u"""
 La composante %(k1)s n'existe pas dans le champ sur la maille sp�cifi�e.
"""),

7 : _(u"""
 Calcul de  %(k1)s  impossible.
"""),

11 : _(u"""
 le r�sultat  %(k1)s  doit comporter un champ de d�placement au num�ro d'ordre  %(k2)s  .
"""),

12 : _(u"""
 Le mot cl� PREC_ERR est OBLIGATOIRE avec l'option SING_ELEM.
 Il faut renseigner le mot cl� PREC_ERR avec une valeur comprise entre 0 et 1.
"""),

13 : _(u"""
 Le mot cl� PREC_ERR doit �tre strictement positif.
"""),

14 : _(u"""
 Il n'y a pas de champ d'estimateur d'erreur dans la structure de donn�e r�sultat.
 On ne calcule pas l'option SING_ELEM.
 Le calcul pr�alable d'un estimateur d'erreur est OBLIGATOIRE pour le calcul de cette option.
"""),

15: _(u"""
 Par d�faut on utilise l'estimateur en r�sidu ERME_ELEM.
"""),

16 : _(u"""
 Par d�faut on utilise l'estimateur bas� sur les contraintes liss�es version 2 ERZ2_ELEM.
"""),

17 : _(u"""
Erreur utilisateur dans la commande CREA_CHAMP / EXTR :
   Le champ que l'on veut extraire (%(k1)s n'existe pas dans la structure
   de donn�e CARA_ELEM ou CHAR_MECA.

Conseil :
  Pour "voir" les champs existants dans la structure de donn�e XXXX,
  vous pouvez utiliser la commande :
   IMPR_CO(CONCEPT=_F(NOM=XXXX), NIVEAU=-1)

"""),




19 : _(u"""
 probl�me � l'appel de ALCHML pour  %(k1)s
"""),




22 : _(u"""
  L'option %(k1)s est inexistante.
"""),

24: _(u"""
 <I> L'estimateur que vous avez choisi pour le calcul de l'option SING_ELEM est %(k1)s.
"""),

26: _(u"""
 L'estimateur %(k1)s que vous avez choisi pour le calcul de l'option SING_ELEM
 n'existe pas dans la structure de donn�e r�sultat %(k2)s.
 L'option SING_ELEM n'est pas calcul�e.
"""),

27 : _(u"""
 type :  %(k1)s  incompatible avec l'option :  %(k2)s
"""),

28 : _(u"""
PROJ_CHAMP / METHODE='ECLA_PG' :
 On va traiter les mailles de dimension :  %(i1)d
 Les autres mailles sont ignor�es
"""),

29 : _(u"""
 Il n'y a pas de champ d'�nergie dans la structure de donn�e r�sultat.
 On ne calcule pas l'option SING_ELEM.
 Le calcul pr�alable de l'option  EPOT_ELEM ou ETOT_ELEM est OBLIGATOIRE
 pour le calcul de cette option.
"""),





31 : _(u"""
 la masse du MACR_ELEM : %(k1)s  n'a pas encore �t� calcul�e.
"""),

32 : _(u"""
 il manque des masses.
"""),

33 : _(u"""
 la rigidit� du MACR_ELEM : %(k1)s  n'a pas encore �t� calcul�e.
"""),

34 : _(u"""
 il manque des rigidit�s.
"""),

35 : _(u"""
 le mod�le doit contenir des �l�ments finis ou des sous-structures.
"""),

36 : _(u"""
 A cause des alarmes pr�c�dentes, l'option SING_ELEM n'est pas calcul�e.
"""),

37 : _(u"""
 Attention : Certains ddls sont "impos�s" plusieurs fois par AFFE_CHAR_CINE.
 Pour ces ddls, la valeur impos�e sera la SOMME des diff�rentes valeurs impos�es.
 Ce n'est peut-�tre pas ce qui est voulu.

 Exemple d'un ddl impos� plusieurs fois :
   Noeud : %(k1)s  Composante : %(k2)s

"""),

38 : _(u"""
 on ne traite pas le type_scalaire: %(k1)s
"""),

39 : _(u"""
 le mod�le contient des �l�ments de structure
 il faut probablement utiliser le mot-cl� CARA_ELEM.
"""),

40 : _(u"""
  -> Le mod�le a probablement besoin d'un champ de mat�riau (mot-cl� CHAM_MATER).

  -> Risque & Conseil :
     Ce message peut aider � comprendre un �ventuel probl�me ult�rieur lors de calculs �l�mentaires
     n�cessitant des caract�ristiques mat�rielles.
     V�rifiez si votre mod�lisation n�cessite un CHAM_MATER.
"""),

41 : _(u"""
 les charges ne s'appuient pas toutes sur le m�me mod�le.
"""),

42 : _(u"""
 les charges ne s'appuient pas sur le mod�le donn� en argument.
"""),

43 : _(u"""
 les charges sont de type diff�rent.
"""),

44 : _(u"""
 les charges ne s'appuient pas toutes sur le m�me mod�le
"""),

45 : _(u"""
 donn�es incorrectes.
"""),

46 : _(u"""
La MATR_ASSE et le CHAM_NO ont des num�rotations diff�rentes (%(k1)s et %(k2)s).
Si la MATR_ASSE contient des ddls LAGR, ceux-ci sont mis � z�ro.
"""),

47 : _(u"""
Possible erreur d'utilisation :
  Vous voulez "poursuivre" un calcul non-lin�aire (STAT_NON_LINE ou DYNA_NON_LINE).
  Pour cela, vous pr�cisez un �tat initial (mot cl� ETAT_INIT / EVOL_NOLI).
  Pour le calcul du premier pas de temps, le champ des variables internes du d�but du pas est pris
  dans le concept EVOL_NOLI fourni.
  Pour l'�l�ment port� par la maille %(k1)s, ce champ de variables internes a �t� calcul� avec
  la relation de comportement %(k2)s, mais le comportement choisi pour le calcul est diff�rent (%(k3)s).

Risques & conseils :
  Ce changement de comportement est-il volontaire ou s'agit-il d'une faute de frappe ?
"""),

48 : _(u"""
Possible erreur d'utilisation :
  Vous voulez "poursuivre" un calcul non-lin�aire (STAT_NON_LINE ou DYNA_NON_LINE).
  Pour cela, vous pr�cisez un �tat initial (mot cl� ETAT_INIT / VARI=chvari).
  Pour le calcul du premier pas de temps, le champ des variables internes utilis� pour le d�but du pas
  est "chvari".
  Pour l'�l�ment port� par la maille %(k1)s, ce champ de variables internes n'a pas le m�me nombre de
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

49 : _(u"""
Erreur d'utilisation :
  Vous voulez "poursuivre" un calcul non-lin�aire (STAT_NON_LINE ou DYNA_NON_LINE).
  Pour cela, vous pr�cisez un �tat initial (mot cl� ETAT_INIT / VARI=chvari).
  Pour le calcul du premier pas de temps, le champ des variables internes utilis� pour le d�but du pas
  est "chvari".
  Pour l'�l�ment port� par la maille %(k1)s, ce champ de variables internes n'a pas le m�me nombre de
  variables internes (%(i1)d) que le nombre attendu par le comportement choisi pour le calcul (%(i2)d).

  Il y a donc un changement de comportement pour la maille %(k1)s
  Le code n'accepte de changement de comportement que dans quelques cas tr�s particuliers :
    - LEMAITRE <-> VMIS_ISOT_XXXX
    - ELAS     <-> XXXX
  Il ne semble pas que vous soyez dans ce cas de figure. L'ex�cution est arr�t�e.

Risques & conseils :
  V�rifiez le comportement affect� sur cette maille.
"""),

50 : _(u"""
 La commande a besoin d'un nom de mod�le.
"""),

51 : _(u"""
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

52 : _(u"""
 le champ doit �tre un CHAM_ELEM.
"""),

53 : _(u"""
 ne traite qu'un CHAM_ELEM r�el
"""),

54 : _(u"""
 longueurs des modes locaux incompatibles entre eux.
"""),

57 : _(u"""
 on ne sait pas moyenner cette composante n�gative
"""),

58 : _(u"""
 champs sur des mod�les diff�rents
"""),

59 : _(u"""
  %(k1)s  doit �tre un CHAM_ELEM.
"""),

60 : _(u"""
 longueurs des modes locaux champ1 incompatibles entre eux.
"""),

61 : _(u"""
 longueurs des modes locaux champ2 incompatibles entre eux.
"""),

62 : _(u"""
 composante non d�finie
"""),





71 : _(u"""
 il faut 1 chargement de rotation et un seul.
"""),

72 : _(u"""
  il ne faut pas d�finir plus d"un champ de vitesse
"""),

73 : _(u"""
 le champ:  %(k1)s  n'est ni un CHAM_ELEM ni un resuelem
"""),

74 : _(u"""
 type scalaire interdit : %(k1)s
"""),

78 : _(u"""
Utilisation de LIAISON_ELEM / OPTION='%(k1)s', occurrence %(i1)d :
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

79 : _(u"""
 la matrice A est singuli�re
"""),

80 : _(u"""
 Utilisation de LIAISON_ELEM / OPTION='%(k1)s', occurrence %(i1)d :
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

81 : _(u"""
 cette fonction ne marche que pour des modes locaux de type champ aux noeuds, vecteur, ou matrice.
"""),

82 : _(u"""
 le mode local est de type matrice non_carr�e
"""),

84 : _(u"""
 il n y a pas de param�tre  %(k1)s  associe a la grandeur: %(k2)s  dans l option: %(k3)s
"""),

85 : _(u"""
 il y a plusieurs param�tres  %(k1)s  associes a la grandeur: %(k2)s  dans l option: %(k3)s
"""),

88: _(u"""
 Les charges ne s'appuie pas sur le MODELE fourni.
"""),

89 : _(u"""
 les charges ne s'appuient pas toutes sur le m�me mod�le.
"""),

90 : _(u"""
 le champ %(k1)s doit �tre une CARTE.
"""),

91 : _(u"""
 une des charges n'est pas m�canique
"""),

92 : _(u"""
 erreur: une des charges n'est pas thermique
"""),

93 : _(u"""
 une des charges n'est pas acoustique
"""),

94 : _(u"""
 le champ doit �tre un CHAM_ELEM aux points de gauss
"""),

95 : _(u"""
 avec un CHAM_ELEM calcule sur une liste de maille,
 il faut utiliser le mot cl� "MODELE"
"""),

96 : _(u"""
  Pour prendre en compte les termes d'inertie,
  il est pr�f�rable d'utiliser la commande CALC_CHAMP.
  Le mot-cl� ACCE n'est pas trait� et les r�sultats risquent d'�tre faux.
"""),

97 : _(u"""
  Erreur d'utilisation :
    Fonctionnalit� : projection de maillage
    On cherche � projeter des mailles sur certains noeuds.
    Mais la liste des noeuds que l'on arrive � projeter dans les mailles est vide.

  Conseil :
    Cette erreur peut venir d'une mauvaise utilisation du mot cl�
    PROJ_CHAMP/DISTANCE_MAX
"""),

98 : _(u"""
 Le calcul de carte de taille et de d�tection de singularit� n'est pas
 programm� en 3D pour les �l�ments de type HEXA, PENTA et PYRAM.
"""),

99 : _(u"""
 Probl�me de convergence pour calculer la nouvelle carte de taille.
"""),


}
