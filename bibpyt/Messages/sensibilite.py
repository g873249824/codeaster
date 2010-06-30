#@ MODIF sensibilite Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg = {

1 : _("""
 Type de d�rivation voulu : %(i1)d
 Ce type n'est pas implant�.
"""),

2 : _("""
 On veut d�river %(k1)s par rapport � %(k2)s.
 Cela n'est pas disponible.
"""),

3 : _("""
 La d�riv�e de %(k1)s par rapport � %(k2)s est introuvable.
"""),

4 : _("""
 Le champ de theta sensibilit� est inexistant dans la sd %(k1)s
"""),

5 : _("""
 On ne sait pas d�river ce type de structures : %(k1)s.
"""),

6 : _("""
 Le param�tre de sensibilit� doit etre un champ theta.
"""),

7 : _("""
 Cette option est indisponible en sensibilit� lagrangienne.
"""),

8 : _("""
 Pour l'occurrence num�ro %(i1)d ,
 la d�riv�e du champ %(k1)s de %(k2)s par rapport � %(k3)s est introuvable.
"""),

9 : _("""
 On ne sait pas trouver le type de la d�rivation par rapport � %(k1)s.
"""),

10 : _("""
 Initialisation de la table associ�e � la table %(k1)s et au param�tre sensible %(k2)s
 connue sous le nom de concept %(k3)s
"""),

11 : _("""
 Le calcul de sensibilit� n'est pas encore disponible pour les chargements de type epsi_init
"""),

12 : _("""
 Il y a vraisemblablement %(i1)d modes propres multiples.
 Le calcul des sensibilit�s se limite actuellement aux modes propres simples
"""),

13 : _("""
 On ne peut pas d�river avec une charge complexe en entr�e de dyna_line_harm.
"""),

15 : _("""
 Le comportement %(k1)s n'est pas autoris� en sensibilit�
"""),

16 : _("""
 EXICHA diff�rent de 0 et 1
"""),

21 : _("""
 Pour faire une reprise avec un calcul de sensibilit�, il faut renseigner "evol_noli" dans "etat_init"
"""),

22 : _("""
 L'option sensibilit� lagrangienne non op�rationnelle en non lineaire
"""),

31 : _("""
 L'option sensibilit� n'est pas op�rationnelle en s�chage
"""),

32 : _("""
 L'option sensibilit� n'est pas op�rationnelle en hydratation
"""),

35 : _("""
 L'option sensibilit� n'est pas op�rationnelle pour le comportement %(k1)s
"""),

37 : _("""
 L'option sensibilit� n'est pas op�rationnelle pour la mod�lisation %(k1)s
"""),

38 : _("""
 pb determination sensibilit� de rayonnement
"""),

39 : _("""
 pb determination sensibilit� materiau ther_nl
"""),

41 : _("""
 D�placements initiaux impos�s nuls pour les  calculs de sensibilit�
"""),

42 : _("""
 Vitesses initiales impos�es nulles pour les  calculs de sensibilit�
"""),

51 : _("""
 D�rivation de g : un seul param�tre sensible par appel � CALC_G.
"""),

52 : _("""
 Actuellement, on ne sait d�river que les 'POU_D_E'.
"""),

53 : _("""
 En thermo�lasticit�, le calcul des d�riv�es de g est pour le moment incorrect.
"""),

54 : _("""
 Avec un chargement en d�formations (ou contraintes) initiales, le calcul
 des d�riv�es de g est pour le moment incorrect.
"""),

55 : _("""
 Le calcul de deriv�e n'a pas �t� �tendu � la plasticit�.
"""),

56 : _("""
Probl�me :
  Le calcul de sensibilit� dans MODE_ITER_SIMULT n'est pas conseill� ici.
  Il aura besoin de beaucoup de m�moire (>3 Go).

Conseil :
  Pour les nombres de ddls importants, il faut pr�f�rer le calcul de sensibilit�
  par "diff�rences finies".
"""),






71 : _("""
 D�rivation par rapport au param�tre sensible : %(k1)s
"""),

72 : _("""
 Le r�sultat est insensible au param�tre %(k1)s.
"""),

73 : _("""
 Le type de la d�rivation est %(k1)s
"""),

81 : _("""
 la structure nosimp est introuvable dans la memorisation inpsco
"""),

91 : _("""
 Le pas de temps adaptatif n'est pas appropri� pour le calcul de sensibilit�
 par rapport au param�tre materiau
"""),

92 : _("""
 On ne peut pas d�river les concepts de type %(k1)s
"""),

93 : _("""
 On ne peut pas d�river avec un vect_asse en entree de dyna_line_harm.
"""),

95 : _("""
 Seuls sont possibles :
"""),

96 : _("""
 Les sous-types de sensibilit� pour l'influence de %(k1)s sont %(k2)s et %(k3)s
 C'est incoh�rent.
"""),

}
