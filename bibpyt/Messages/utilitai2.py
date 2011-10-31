#@ MODIF utilitai2 Messages  DATE 31/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

cata_msg = {

4 : _(u"""
 Il y a un probl�me pour r�cup�rer les variables d'acc�s.
"""),

5 : _(u"""
 Seules les variables d'acc�s r�elles sont trait�es.
"""),

6 : _(u"""
 Seuls les param�tres r�els sont trait�s.
"""),

7 : _(u"""
 L'unit� logique est inexistante.
"""),

8 : _(u"""
  Les fonctions � une seule variable sont admises.
"""),

10 : _(u"""
  Les fonctions de type " %(k1)s " ne sont pas encore imprim�es.
"""),

11 : _(u"""
  Les fonctions de type " %(k1)s " ne sont pas imprim�es.
"""),

12 : _(u"""
 interpolation sur param�tres non permise
"""),

13 : _(u"""
 interpolation " %(k1)s " inconnue
"""),

14 : _(u"""
 " %(k1)s " type de fonction inconnu
"""),

16 : _(u"""
 interpolation non permise
"""),

17 : _(u"""
 on ne connait pas ce type d'interpolation:  %(k1)s
"""),

31 : _(u"""
 on ne trouve pas l'equation  %(k1)s  dans le "prof_chno"
"""),





36 : _(u"""
 group_ma_interf: un �l�ment n'est ni tria3 ni tria6 ni quad4 ni quad8
"""),

37 : _(u"""
 group_ma_flu_str: un �l�ment n'est ni tria3 ni tria6 ni quad4 ni quad8
"""),

38 : _(u"""
 group_ma_flu_sol: un �l�ment n'est ni tria3 ni tria6 ni quad4 ni quad8
"""),

39 : _(u"""
 group_ma_sol_sol: un �l�ment n'est ni tria3 ni tria6 ni quad4 ni quad8
"""),





47 : _(u"""
  Le fichier " %(k1)s " n'est reli� a aucune unit� logique.
"""),




52 : _(u"""
 ajout de l'option "SIEF_ELGA", les charges sont-elles correctes ?
"""),

53 : _(u"""
 Le nombre maximum d'iterations est atteint.
"""),

54 : _(u"""
  La dimension de l'espace doit �tre inf�rieur ou �gal � 3.
"""),

55 : _(u"""
 les points du nuage de depart sont tous en (0.,0.,0.).
"""),

56 : _(u"""
 le nuage de depart est vide.
"""),

57 : _(u"""
 les points du nuage de depart sont tous confondus.
"""),

58 : _(u"""
 les points du nuage de depart sont tous alignes.
"""),

59 : _(u"""
 les points du nuage de depart sont tous coplanaires.
"""),

60 : _(u"""
 methode inconnue :  %(k1)s
"""),

61 : _(u"""
 le descripteur_grandeur de compor ne tient pas sur un seul entier_code
"""),

62 : _(u"""
 erreur dans etenca
"""),

63 : _(u"""
 la composante relcom n'a pas ete affectee pour la grandeur compor
"""),

66 : _(u"""
 pas assez de valeurs dans la liste.
"""),

67 : _(u"""
 il faut des triplets de valeurs.
"""),

68 : _(u"""
 il n'y a pas un nombre pair de valeurs.
"""),

69 : _(u"""
 nombre de valeurs diff�rent  pour "noeud_para" et "vale_y"
"""),

70 : _(u"""
 il manque des valeurs dans  %(k1)s  ,liste plus petite que  %(k2)s
"""),

71 : _(u"""
La fonction a des valeurs n�gatives. Ce n'est pas compatible avec une
interpolation "LOG".

Conseil :
    Vous pouvez forcer le type d'interpolation de la fonction produite
    avec le mot-cl� INTERPOL (ou INTERPOL_FONC quand il s'agit de nappe).
"""),

72 : _(u"""
Les param�tres de la nappe ne sont pas croissants !
"""),

73 : _(u"""
On ne peut pas d�finir une nappe avec deux fonctions diff�rentes pour la m�me
valeur du param�tre.
"""),

75 : _(u"""
Les listes NUME_LIGN et LISTE_R/LISTE_K/LISTE_I doivent contenir le m�me nombre de termes.
"""),

76 : _(u"""
Les noms de param�tres doivent �tre diff�rents
"""),

77 : _(u"""
 les listes d'abscisses et d'ordonn�es doivent �tre de m�mes longueurs
"""),

78 : _(u"""
 fonction incompatible avec  %(k1)s
"""),

79 : _(u"""
 les noms de chaque param�tre doivent �tre diff�rents
"""),

80 : _(u"""
 un seul nume_ordre !!!
"""),

83 : _(u"""
 les noeuds debut et fin n appartiennent pas au maillage.
"""),

84 : _(u"""
 la fonction doit s appuyee sur un maillage pour lequel une abscisse curviligne est d�finie.
"""),

85 : _(u"""
 mauvaise d�finition des noeuds debut et fin
"""),

86 : _(u"""
 le nombre de champs � lire est sup�rieur a 100
"""),

87 : _(u"""
  -> Le maillage doit �tre issu d'IDEAS pour garantir la coh�rence entre
     le maillage et les r�sultats lus.

  -> Risque & Conseil :
     Vous r�cup�rez des r�sultats au format IDEAS, ces r�sultats sont donn�s
     aux noeuds par leur nom, et/ou aux mailles par leurs noms. Il faut
     v�rifier que les r�sultats lus ont �t� obtenus avec le m�me maillage
     que celui lu par aster (LIRE_MAILLAGE).
"""),

88 : _(u"""
  Pour le format ENSIGHT, le mot-cl� MODELE est obligatoire.
"""),

89 : _(u"""
  Le format ENSIGHT n'accepte que le champ de type PRES.
"""),

91 : _(u"""
  Le type d'�l�ment %(k1)s n'est pas prevu.
"""),

94 : _(u"""
  Le champ %(k1)s n'est pas pr�vu.
  Vous pouvez demander l'�volution.
"""),

95 : _(u"""
  %(k1)s  et  %(k2)s  : nombre de composantes incompatible.
"""),

97 : _(u"""
Erreur Utilisateur :
  On n'a pu lire aucun champ dans le fichier.
  La structure de donn�es cr��e est vide.

Risques & Conseils :
  Si le fichier lu est au format Ideas, et si la commande est LIRE_RESU,
  le probl�me vient peut-�tre d'une mauvaise utilisation (ou d'une abscence d'utilisation)
  du mot cl� FORMAT_IDEAS. Il faut examiner les "entetes" des DATASET du fichier � lire.
"""),

}
