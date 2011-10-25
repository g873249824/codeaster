#@ MODIF rupture1 Messages  DATE 25/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

cata_msg={
1: _(u"""
L'option de lissage 'LAGRANGE_REGU' n'a pas �t� d�velopp�e lorsque
le nombre de noeuds d'un fond de fissure ferm� est pair.
-> Risque et Conseil :
Veuillez utiliser une autre option de lissage
(par exemple, le lissage 'LAGRANGE' pour le champ theta)
"""),


5: _(u"""
La commande POST_RUPTURE / OPERATION = '%(k1)s' traite uniquement
un seul fond de fissure. Or la table %(k2)s contient %(i1)d fonds de fissure
(colonne 'NUME_FOND').
"""),

6: _(u"""
Le rayon R_SUP (ou R_SUP_FO) doit obligatoirement etre sup�rieur au rayon
R_INF (resp. R_INF_FO).
-> Risque et Conseil :
Veuillez revoir votre mise en donn�es.
"""),

7: _(u"""
Probl�me dans RINF et RSUP.
-> Risque et Conseil :
Veuillez revoir les valeurs fournies aux mots-cl�s R_INF ou R_INF_FO
ou R_SUP ou R_SUP_FO.
"""),

8: _(u"""
Le groupe %(k1)s n'appartient pas au maillage : %(k2)s
"""),

9: _(u"""
Le fond de fissure n'est pas complet.
-> Risque et Conseil :
Veuillez revoir la mise en donn�es de l'op�rateur DEFI_FOND_FISS.
"""),

10: _(u"""
Le fond de fissure ne doit etre d�fini que par un noeud.
-> Risque et Conseil :
Veuillez revoir le contenu du mot-cl� GROUP_NO ou NOEUD ou FOND_FISS.
"""),

11: _(u"""
Il faut un mot cl� parmis FOND_FISS ou FISSURE pour l'option %(k1)s
Veuillez le renseigner.
"""),

12: _(u"""
Aucun champ initial trouv�.
"""),

13: _(u"""
%(k1)s : champ initial impossible avec cette option.
"""),

14: _(u"""
Nombre de bornes erron�.
-> Risque et Conseil :
On doit en avoir autant que de num�ros d'ordre.
"""),

15: _(u"""
Le r�sultat n'est pas un EVOL_NOLI.
"""),

16: _(u"""
Le champ %(k1)s n'a pas �t� trouv�.
"""),

17: _(u"""
L'association: lissage du champ THETA par les polynomes de Lagrange
               lissage de G autre que par des polynomes de Lagrange
n'est pas possible.
-> Risque et Conseil :
Veuillez consulter la documentation U4.82.03 pour d�terminer une
association satisfaisante.
"""),


20: _(u"""
Une d�formation initiale est pr�sente dans la charge. Ceci est incompatible
avec la contrainte initiale sigma_init.
-> Risque et Conseil :
On ne peut pas faire de calcul en introduisant simultan�ment une contrainte
initiale ET une d�formation initiale. Veuillez revoir les donn�es.
"""),

21: _(u"""
Seule une loi de comportement �lastique isotrope est valide pour
le calcul de DG.
"""),

22: _(u"""
Le calcul de DG n'a pas �t� �tendu � la plasticit� !
"""),

23: _(u"""
CALC_G - option CALC_G : d�tection de chargements non nuls sur l'axe,
le calcul est impossible.
-> Risque et Conseil :
En 2D-axi, le calcul de G n'est pas possible pour les �l�ments de l'axe de
sym�trie si un chargement est impos� sur ceux-ci.
Modifier les couronnes R_INF et R_SUP pour qu'elles soient toutes les deux
plus petites que le rayon du fond de fissure.
"""),

24: _(u"""
L'option CALC_K_G est incompatible avec les comportements incr�mentaux,
avec les comportements non lin�aires et avec la d�formation GROT_GDEP.
"""),

25: _(u"""
Il faut affecter les �l�ments de bord (E et NU) pour le calcul des fic.
-> Risque et Conseil :
Veuillez revoir la mise en donn�es des op�rateurs DEFI_MATERIAU
et AFFE_MATERIAU.
"""),

26: _(u"""
La masse volumique RHO n'a pas �t� d�finie.
-> Risque et Conseil :
Pour l'option K_G_MODA, il est indispensable de fournir la masse volumique
du mat�riau consid�r�. Veuillez revoir la mise en donn�es de l'op�rateur
DEFI_MATERIAU.
"""),

27: _(u"""
L'option est incompatible avec les comportements incr�mentaux ainsi
qu'avec la d�formation GROT_GDEP.
"""),

28: _(u"""
Le champ de nom symbolique %(k1)s existe d�j� dans la SD RESULTAT  %(k1)s.
"""),



30: _(u"""
Il faut donner 3 composantes de la direction.
-> Risque et Conseil :
Si vous utilisez CALC_THETA/THETA_2D ou CALG_G/THETA en 2d, veuillez fournir
une valeur nulle pour la 3eme composante.
"""),

31: _(u"""
Option non op�rationnelle:
Seule l'option COURONNE est � utiliser dans le cas ou
on emploie le mot cl� THETA_3D ou THETA_2D.
"""),

32: _(u"""
Option inexistante:
Seule l'option BANDE est � utiliser dans le cas ou on emploie
le mot cl� THETA_BANDE .
"""),

33: _(u"""
La tangente � l'origine n'est pas orthogonale � la normale au plan de la fissure.
Normale au plan :  (%(r1)f,%(r2)f,%(r3)f)
-> Risque et Conseil :
La tangente � l'origine DTAN_ORIG est n�cessairement dans le plan de la fissure,
donc orthogonale � la normale au plan, calcul�e � partir des fonctions de niveaux
(level set) qui d�finissent la fissure. V�rifier les donn�es.
"""),

34: _(u"""
La tangente � l'extr�mit� n'est pas orthogonale � la normale au plan de la fissure.
Normale au plan :  (%(r1)f,%(r2)f,%(r3)f)
-> Risque et Conseil :
La tangente � l'extr�mit� DTAN_EXTR est n�cessairement dans le plan de la fissure,
donc orthogonale � la normale au plan, calcul�e � partir des fonctions de niveaux
(level set) qui d�finissent la fissure. V�rifier les donn�es.
"""),

35: _(u"""
Les directions normales au plan de la fissure entre les points %(i1)d et %(i2)d successifs du fond forment un angle
sup�rieur � 10 degr�s.
-> Risque et Conseils
L'interpolation des sauts de d�placements est bas�e sur les champs singuliers
correspondants � une fissure plane. La fissure utilis�e ici est trop irr�guli�re et
il y a donc un risque d'obtenir des r�sultats impr�cis.
"""),

36: _(u"""
La tangente � l'origine n'est pas orthogonale � la normale au plan de la fissure
d�fini par VECT_K1.
-> Risque et Conseil :
La tangente � l'origine DTAN_ORIG est n�cessairement dans le plan de la fissure,
donc orthogonale au VECT_K1 fourni. V�rifier les donn�es.
"""),

37: _(u"""
La tangente � l'extr�mit� n'est pas orthogonale � la normale au plan de la fissure
d�fini par VECT_K1.
-> Risque et Conseil :
La tangente � l'extr�mit� DTAN_EXTR est n�cessairement dans le plan de la fissure,
donc orthogonale au VECT_K1 fourni. V�rifier les donn�es.
"""),

38: _(u"""
La fissure contient %(i1)d fond(s) et le calcul est demand� pour le fond num�ro %(i2)d.
-> Risque et Conseil :
V�rifier le param�tre d�fini sous le mot cl� NUME_FOND de POST_K1_K2_K3.
"""),

39: _(u"""
La r�cup�ration des contraintes � partir de la SD R�sultat n'est permise que si les fissures sont maill�es.
-> Risque et Conseil :
Veillez � ne pas vous servir de FISSURE avec le mot-cl� CALCUL_CONTRAINTE.
"""),

41: _(u"""
On recalcule donc les champs de contraintes et d'�nergie
comme si vous aviez renseign� CALCUL_CONTRAINTE='OUI'.
"""),

42: _(u"""
 Lois de comportement diff�rentes pour la maille %(k3)s :
 - loi de comportement extraite de la SD R�sultat   : %(k1)s
 - loi de comportement fournie � l'op�rateur CALC_G : %(k2)s

--> Risques & conseils :
On doit g�n�ralement utiliser la meme loi de comportement entre le calcul et le
post-traitement. On peut utiliser deux comportements diff�rents, mais alors
l'utilisateur doit etre vigilant sur l'interpr�tation des r�sultats(cf.U2.05.01).
Si plusieurs comportements sont d�finis sur la structure, le comportement �
indiquer dans CALC_G est celui du mat�riau dans lequel la fissure se d�veloppe.
Dans ce cas, ce message d'alarme est quand meme �mis mais le r�sultat est bien coh�rent.
Un post-traitement �lastique non-lin�aire d'un calcul �lastoplastique est
admissible, si le chargement est radial et monotone. La comparaison du G calcul�
� partir des contraintes issues de STAT_NON_LINE (option CALC_CONTRAINTE='NON')
ou � partir des contraintes recalcul�es avec la loi de comportement
(CALC_CONTRAINTES='OUI') peut fournir une indication sur le respect de ces
hypoth�ses.
"""),

43: _(u"""
Le calcul de G avec une mod�lisation X-FEM n'est pas possible avec une loi de comportement
�lastoplastique.
--> Risques & conseils :
Remplacer si possible le comportement �lastoplastique (COMP_INCR) par un comportement
�lastique non lin�aire (COMP_ELAS).
"""),

44: _(u"""
Les param�tres K1 et/ou G sont absents du tableau des facteurs d'intensit� des
contraintes fourni.
-> Risque et Conseil :
Le mot cl� METHODE_POSTK doit �tre fourni si et seulement si la table TABLE a �t�
calcul�e avec l'op�rateur POST_K1_K2_K3.
"""),


46: _(u"""
Le taux de restitution d'�nergie G est n�gatif ou nul sur certains des noeuds du fond de fissure :
le calcul de propagation est impossible.
-> Risque et Conseil :
V�rifier les param�tres du calcul de G (rayons des couronnes ou abscisse curviligne
maximale, type de lissage, ...).
"""),

49: _(u"""
Le facteur d'intensit� des contraintes K1 est n�gatif sur certains des noeuds du fond
de fissure : le calcul de propagation est impossible.
-> Risque et Conseil :
V�rifier les param�tres du calcul de K1 (rayons des couronnes ou abscisse curviligne
maximale, type de lissage, ...).
"""),

50: _(u"""
La d�finition d'une loi de propagation (mot cl� facteur LOI_PROPA) est obligatoire pour
le calcul de la propagation de la fissure.
"""),

51: _(u"""
PROPA_FISS / METHODE = 'MAILLAGE' : les noeuds d�finissant la fissure initiale ne sont
pas ordonn�s. V�rifiez le maillage donn� en entr�e (MAIL_ACTUEL).
"""),

52: _(u"""
PROPA_FISS / METHODE = 'INITIALISATION' : les deux vecteurs VECT_X et VECT_Y
d�finissant la fissure initiale, de forme elliptique, ne sont pas orthogonaux. V�rifiez
les donn�es d'entr�e.
"""),

53: _(u"""
L'instant %(r1)f n'appartient pas au r�sultat %(k1)s.
"""),

54:_(u"""
Les champs de contraintes et de d�formations ne sont pas de m�me taille. V�rifiez que votre
calcul m�canique s'est bien pass�.
"""),

55:_(u"""
Probl�me dans la liste d'instants du r�sultats: 2 instants cons�cutifs sont �gaux.
"""),

56:_(u"""
La contrainte de r�f�rence est nulle � l'instant %(r1)f.
"""),

57:_(u"""
Probl�me dans la dimension du mod�le. POST_BORDET ne supporte pas les raccords 2D-3D
"""),

58:_(u"""
L'utilisation de POST_BORDET n'est possible qu'avec 1 seul MODELE et 1 seul
CHAM_MATERIAU
"""),

59:_(u"""
La table %(k1)s ne contient pas le param�tre %(k2)s.
"""),

60:_(u"""
Le crit�re 'K2_NUL' donne des mauvais r�sultats pour des angles sup�rieurs � 60 degr�s.
Il se peut que le signe de l'angle soit faux.
Conseil : utiliser le crit�re par d�faut.
"""),

61:_(u"""
Impossible de r�aliser le comptage sur les quantit�s demand�es car
le nombre de cycles pour chaqune d'elles est diff�rent.
Conseil : limiter le comptage des cycles � une seule quantit� (K_EQ par exemple).
"""),

62:_(u"""
Pour l'op�ration %(k1)s, la table doit �tre r�entrante (reuse obligatoire).
"""),

63:_(u"""La r�cup�ration des contraintes � partir de la SD R�sultat
en pr�sence d'un �tat initial n'est pas permise.
Pour l'op�ration %(k1)s, la table ne doit pas �tre r�entrante (reuse interdit).
"""),

64:_(u"""
Pour le comptage %(k1)s, la table doit comporter uniquement 1 instant/nume_ordre (ou aucun).
Or la table %(k2)s contient %(i1)d instants/nume_ordre.
Conseil : V�rifier la table en entr�e ou utiliser un autre type de comptage des cycles.
"""),

65:_(u"""
La table %(k1)s ne doit pas contenir le param�tre %(k2)s.
"""),

66:_(u"""
L'op�ration %(k1)s n�cessite une seule table sous le mot-cl� TABLE, or il y en a %(i1)d.
"""),

67:_(u"""
Les caract�ristiques du mat�riau ne peuvent d�pendre que de la temp�rature.
-> Conseil :
Veuillez revoir les donn�es du mat�riau.
"""),

68:_(u"""
La macro-commande POST_RUPTURE ne fonctionne pas quand les param�tres mat�riau ne sont pas constants.
"""),

}
