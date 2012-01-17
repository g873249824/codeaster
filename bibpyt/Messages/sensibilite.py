#@ MODIF sensibilite Messages  DATE 16/01/2012   AUTEUR PELLET J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

1 : _(u"""
 Type de d�rivation voulu : %(i1)d
 Ce type n'est pas implant�.
"""),

2 : _(u"""
 On veut d�river %(k1)s par rapport � %(k2)s.
 Cela n'est pas disponible.
"""),

3 : _(u"""
 La d�riv�e de %(k1)s par rapport � %(k2)s est introuvable.
"""),

4 : _(u"""
 Le champ de th�ta sensibilit� est inexistant dans la structure de donn�e %(k1)s
"""),

5 : _(u"""
 On ne sait pas d�river ce type de structures : %(k1)s.
"""),

6 : _(u"""
 Le param�tre de sensibilit� doit �tre un champ th�ta.
"""),

8 : _(u"""
 Pour l'occurrence num�ro %(i1)d ,
 la d�riv�e du champ %(k1)s de %(k2)s par rapport � %(k3)s est introuvable.
"""),

9 : _(u"""
 On ne sait pas trouver le type de la d�rivation par rapport � %(k1)s.
"""),

10 : _(u"""
 Initialisation de la table associ�e � la table %(k1)s et au param�tre sensible %(k2)s
 connue sous le nom de concept %(k3)s
"""),

11 : _(u"""
 Le calcul de sensibilit� n'est pas encore disponible pour les chargements de type EPSI_INIT
"""),

12 : _(u"""
 Il y a vraisemblablement %(i1)d modes propres multiples.
 Le calcul des sensibilit�s se limite actuellement aux modes propres simples
"""),

13 : _(u"""
 On ne peut pas d�river avec une charge complexe en entr�e de DYNA_LINE_HARM.
"""),

15 : _(u"""
 Le comportement %(k1)s n'est pas autoris� en sensibilit�
"""),

16 : _(u"""
 EXICHA diff�rent de 0 et 1
"""),

33 : _(u"""
 La d�riv�e des contraintes par rapport � l'�paisseur n'est pas implant�e
 pour les COQUE_3D.
"""),

35 : _(u"""
 L'option sensibilit� n'est pas op�rationnelle pour le comportement %(k1)s
"""),

37 : _(u"""
 L'option sensibilit� n'est pas op�rationnelle pour la mod�lisation %(k1)s
"""),

41 : _(u"""
 D�placements initiaux impos�s nuls pour les  calculs de sensibilit�
"""),

42 : _(u"""
 Vitesses initiales impos�es nulles pour les  calculs de sensibilit�
"""),

51 : _(u"""
 D�rivation de g : un seul param�tre sensible par appel � CALC_G.
"""),

52 : _(u"""
 Actuellement, on ne sait d�river que les 'POU_D_E'.
"""),

53 : _(u"""
 En thermo �lasticit�, le calcul des d�riv�es de g est pour le moment incorrect.
"""),

54 : _(u"""
 Avec un chargement en d�formations (ou contraintes) initiales, le calcul
 des d�riv�es de g est pour le moment incorrect.
"""),

55 : _(u"""
 Le calcul de d�riv�e n'a pas �t� �tendu � la plasticit�.
"""),

56 : _(u"""
Probl�me :
  Le calcul de sensibilit� dans MODE_ITER_SIMULT n'est pas conseill� ici.
  Il aura besoin de beaucoup de m�moire (>3 Go).

Conseil :
  Pour les nombres de ddls importants, il faut pr�f�rer le calcul de sensibilit�
  par "diff�rences finies".
"""),

57 : _(u"""
 Le calcul de d�riv�e n'a pas �t� pr�vu pour les variables de commande de s�chage ou d'hydratation.
"""),

71 : _(u"""
 D�rivation par rapport au param�tre sensible : %(k1)s
"""),

73 : _(u"""
 Le type de la d�rivation est %(k1)s
"""),

81 : _(u"""
 la structure nosimp est introuvable dans la m�morisation inpsco
"""),

91 : _(u"""
 Le pas de temps adaptatif n'est pas appropri� pour le calcul de sensibilit�
 par rapport au param�tre mat�riau
"""),

92 : _(u"""
 On ne peut pas d�river les concepts de type %(k1)s
"""),

93 : _(u"""
 On ne peut pas d�river avec un VECT_ASSE en entr�e de DYNA_LINE_HARM.
"""),

95 : _(u"""
 Seuls sont possibles :
"""),

96 : _(u"""
 Les sous types de sensibilit� pour l'influence de %(k1)s sont %(k2)s et %(k3)s
 C'est incoh�rent.
"""),

}
