#@ MODIF prepost4 Messages  DATE 12/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

5 : _(u"""
 l'option  %(k1)s n'a pas �t� calcul�e pour la SD  %(k2)s
"""),

6 : _(u"""
 le champ " %(k1)s " ( %(k2)s ) n'a pas �t� not� dans la SD  %(k3)s
"""),

7 : _(u"""
 "TUBE_NEUF" n'a de sens que pour une table d'usure existante
"""),

8 : _(u"""
 angle initial diff�rent de -180. degr�s.
"""),

9 : _(u"""
 les angles ne sont pas croissants.
"""),

10 : _(u"""
 angle final diff�rent de 180. degr�s.
"""),

11 : _(u"""
 rayon mobile obligatoire avec secteur.
"""),

12 : _(u"""
 rayon obstacle obligatoire avec secteur.
"""),

13 : _(u"""
 la table usure en sortie est differente de celle en entree
"""),

14 : _(u"""
 le nombre de secteurs en sortie est diff�rent de celui en entree
"""),

15 : _(u"""
 probleme extraction pour la table  %(k1)s
"""),

17 : _(u"""
 aucune valeur de moment presente
"""),

18 : _(u"""
 y a un bug: recup frequences
"""),

19 : _(u"""
 il faut au moins un group_ma_radier
"""),

20 : _(u"""
 rigidite de translation non nulle
"""),

21 : _(u"""
 rigidite de rotation non nulle
"""),

22 : _(u"""
 nombres de composantes raideurs et mode differents
"""),

23 : _(u"""
 nombres de group_ma et amor_interne differents
"""),

24 : _(u"""
 nombres de composantes amortissements et mode differents
"""),

26 : _(u"""
 le type du concept resultat  n'est ni evol_elas, ni evol_noli.
"""),

27 : _(u"""
 vous avez probablement archive l etat initial dans la commande stat_non_line. cela correspond au numero d ordre 0. nous ne tenons pas compte du resultat a ce numero d ordre pour le calcul de de la fatigue.
"""),

29 : _(u"""
 les champs de  contraintes aux points de gauss n'existent pas.
"""),

30 : _(u"""
 le champ simple qui contient les valeurs des contraintes n existe pas.
"""),

32 : _(u"""
 le champ de contraintes aux points de gauss  SIEF_ELGA n'a pas �t� calcule.
"""),

33 : _(u"""
 le champ de deformations aux points de gauss EPSI_ELGA n'a pas ete calcule.
"""),

34 : _(u"""
 les champs de  deformations aux points de gauss n'existent pas.
"""),

35 : _(u"""
 le champ simple qui contient les valeurs des deformations n existe pas.
"""),

38 : _(u"""
 le champ de contraintes aux noeuds SIEF_NOEU n'a pas �t� calcule.
"""),

39 : _(u"""
 le champ de deformations aux noeuds EPSI_NOEU n'a pas ete calcule.
"""),

40 : _(u"""
 le champ de  contraintes aux noeuds n'existe pas.
"""),

41 : _(u"""
 le champ de  deformations aux noeuds n'existe pas.
"""),

47 : _(u"""
 inst_init plus grand que inst_fin
"""),

57 : _(u"""
  erreur donnees.
"""),

58 : _(u"""
 pr�sence de point(s) que dans un secteur.
"""),

59 : _(u"""
 aucun cercle n'est circonscrit aux quatre points.
"""),

60 : _(u"""
 le d�calage se trouve n�cessairement cot� rev�tement
 le d�calage doit �tre n�gatif
"""),

76 : _(u"""
 le champ demand� n'est pas pr�vu
"""),

77 : _(u"""
 nom_cham:  %(k1)s  interdit.
"""),

82 : _(u"""
 type  %(k1)s  non implante.
"""),

83 : _(u"""
 profondeur > rayon du tube
"""),

84 : _(u"""
 pas d'informations dans le "RESU_GENE" sur l'option "choc".
"""),

85 : _(u"""
 modele non valide.
"""),

86 : _(u"""
  seuil / v0  > 1
"""),

87 : _(u"""
  ***** arret du calcul *****
"""),

89 : _(u"""
 type non traite  %(k1)s
"""),

90 : _(u"""
 les tables TABL_MECA_REV et TABL_MECA_MDB n'ont pas les m�mes dimensions
"""),

91 : _(u"""
 les tables n'ont pas les m�mes instants de calculs
"""),

92 : _(u"""
 les tables n'ont pas les m�mes dimensions
"""),

93 : _(u"""
 volume us� trop grand pour la mod�lisation
"""),

94 : _(u"""
El�ment inconnu.
   Type d'�l�ment Gibi          : %(i1)d
   Nombre de sous-objet         : %(i2)d
   Nombre de sous-r�f�rence     : %(i3)d
   Nombre de noeuds par �l�ment : %(i4)d
   Nombre d'�l�ments            : %(i5)d

La ligne lue dans le fichier doit ressembler � ceci :
%(i1)8d%(i2)8d%(i3)8d%(i4)8d%(i5)8d
"""),

95 : _(u"""
On a lu un objet dit compos� (car type d'�l�ment = 0) qui serait
compos� de 0 sous-objet !
"""),

96 : _(u"""
 Type de concept invalide.
"""),

97 : _(u"""
 Erreur Utilisateur :
 La maille de peau : %(k1)s ne peut pas �tre r�orient�e.
 Car elle est inserr�e entre 2 mailles "support" plac�es de part et d'autre : %(k2)s et %(k3)s.
"""),

}
