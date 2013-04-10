#@ MODIF rupture1 Messages  DATE 08/04/2013   AUTEUR LADIER A.LADIER 
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
L'option de lissage 'LAGRANGE_REGU' n'a pas �t� d�velopp�e lorsque
le nombre de noeuds d'un fond de fissure ferm� est pair.
-> Risque et Conseil :
Veuillez utiliser une autre option de lissage
(par exemple, le lissage 'LAGRANGE' pour le champ th�ta)
"""),

4: _(u"""
La commande CALC_G ne traite pas le cas des fonds doubles.
"""),

5: _(u"""
Le param�tre R_INF automatiquement choisi vaut %(r1)f.
Le param�tre R_SUP automatiquement choisi vaut %(r2)f.
"""),

6: _(u"""
Le rayon R_SUP (ou R_SUP_FO) doit obligatoirement �tre sup�rieur au rayon
R_INF (respectivement R_INF_FO).
-> Risque et Conseil :
Veuillez revoir votre mise en donn�es.
"""),

7: _(u"""
Il n'est pas possible de calculer automatiquement R_INF et R_SUP en cas
de mod�lisation FEM avec une fissure en configuration d�coll�e.
-> Risque et Conseil :
Veuillez indiquer les mots-cl�s R_INF et R_SUP (ou R_INF_FO et R_SUP_FO).
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
Le fond de fissure ne doit �tre d�fini que par un noeud.
-> Risque et Conseil :
Veuillez revoir le contenu du mot-cl� GROUP_NO ou NOEUD ou FOND_FISS.
"""),

11: _(u"""
Il faut un mot cl� parmi FOND_FISS ou FISSURE.
Veuillez le renseigner.
"""),

12: _(u"""
Le champ de contrainte initiale n'est ni de type ELNO, ni NOEU, ni ELGA.
"""),

13: _(u"""
%(k1)s : prise en compte d'un �tat initial impossible avec cette option.
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
La diff�rence entre la taille maximale et la taille minimale des mailles connect�es aux
noeuds du fond de fissure est importante.
La taille minimale vaut : %(r1)f
La taille maximale vaut : %(r2)f
-> Risque et Conseil :
Il a �t� choisi de multiplier par quatre la taille maximale des mailles connect�es aux
noeuds du fond de fissure pour calculer le param�tre R_SUP et par deux, pour calculer
le param�tre R_INF. Or, si ces tailles sont importantes, vous risquez de post-traiter
vos r�sultats sur une zone trop grande autour du fond de fissure et d'obtenir des
valeurs de taux de restitution d'�nergie et de facteurs d'intensit� moins pr�cises.
V�rifiez que les valeurs de R_INF et de R_SUP calcul�es sont licites.
Sinon, veuillez sp�cifier directement les valeurs de R_INF et de R_SUP ou bien revoir
le maillage de mani�re � rendre les mailles proches du fond de fissure de taille homog�ne.
"""),

17: _(u"""
L'association: lissage du champ THETA par les polyn�mes de Lagrange
               lissage de G autre que par des polyn�mes de Lagrange
n'est pas possible.
-> Risque et Conseil :
Veuillez consulter la documentation U4.82.03 pour d�terminer une
association satisfaisante.
"""),

18: _(u"""
Les mots-cl�s R_INF_FO et R_SUP_FO ne peuvent �tre employ�s dans le cas 2D.
-> Risque et Conseil :
Veuillez les remplacer par R_INF ou R_SUP, ou bien ne rien indiquer afin que les rayons
de la couronne soient calcul�s avec les donn�es du maillage.
"""),

19: _(u"""
L'utilisation du mot-cl� facteur %(k1)s n'est compatible qu'avec une mod�lisation %(k2)s.
Veuillez v�rifiez vos donn�es.
"""),

20: _(u"""
Votre �tude comporte une charge de type PRE_EPSI. Ceci est incompatible
avec la pr�sence d'une contrainte initiale dans le calcul de G(mot cl� SIGM_INIT
de l'op�rateur CALC_G).
-> Risque et Conseil :
On ne peut pas faire de calcul de G en introduisant simultan�ment une contrainte
initiale ET une d�formation initiale. Veuillez revoir les donn�es.
"""),

21: _(u"""
La liste de taille n'a pas la taille de la liste des groupes mailles.
V�rifiez vos donn�es.
"""),

22: _(u"""
Les mailles volumiques caract�risant les zones de calcul doivent absolument �tre des
hexa�dres.
V�rifiez votre maillage ou vos donn�es.
"""),

23: _(u"""
CALC_G - option CALC_G : d�tection de chargements non nuls sur l'axe,
le calcul est impossible.
-> Risque et Conseil :
En 2D axisym�trique, le calcul de G n'est pas possible pour les �l�ments de l'axe de
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
Pour le calcul de l'option CALC_K_G avec un r�sultat de type MODE_MECA,
il est indispensable de fournir la masse volumique du mat�riau consid�r�.
La masse volumique doit �tre d�finie dans l'op�rateur DEFI_MATERIAU.
"""),

27: _(u"""
La connexit� entre les mailles caract�risant les zones de calcul n'est pas valide.
-> Risque et Conseil :
Veuillez vous assurer que les copeaux de chaque tranche d�finies dans
GROUP_MA du mot-cl� facteur TRANCHE_3D, suivent les r�gles pr�cis�es dans
la documentation U de CALC_GP.
"""),

28: _(u"""
Le champ de nom symbolique %(k1)s existe d�j� dans la SD RESULTAT  %(k1)s.
"""),

29: _(u"""
Au moins une des mailles caract�risant les zones de calcul a une forme trop
trap�zo�dale.
-> Risque et Conseil :
Le calcul de la surface de sa face appartenant au plan de sym�trie de
l'entaille risque d'�tre alt�r� et par cons�quent celui de GP �galement.
Veuillez v�rifier votre maillage.
"""),

30: _(u"""
Il faut donner 3 composantes de la direction.
-> Risque et Conseil :
Si vous utilisez CALC_THETA/THETA_2D ou CALC_G/THETA en 2d, veuillez fournir
une valeur nulle pour la 3�me composante.
"""),



35: _(u"""
Les directions normales au plan de la fissure entre les points %(i1)d et %(i2)d successifs du fond forment un angle
sup�rieur � 10 degr�s.
-> Risque et Conseils
L'interpolation des sauts de d�placements est bas�e sur les champs singuliers
correspondants � une fissure plane. La fissure utilis�e ici est trop irr�guli�re et
il y a donc un risque d'obtenir des r�sultats impr�cis.
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

42: _(u"""
 Lois de comportement diff�rentes pour la maille %(k3)s :
 - loi de comportement extraite de la SD R�sultat   : %(k1)s
 - loi de comportement fournie � l'op�rateur CALC_G : %(k2)s

--> Risques & conseils :
On doit g�n�ralement utiliser la m�me loi de comportement entre le calcul et le
post-traitement. On peut utiliser deux comportements diff�rents, mais alors
l'utilisateur doit �tre vigilant sur l'interpr�tation des r�sultats(cf.U2.05.01).
Si plusieurs comportements sont d�finis sur la structure, le comportement �
indiquer dans CALC_G est celui du mat�riau dans lequel la fissure se d�veloppe.
Dans ce cas, ce message d'alarme est quand m�me �mis mais le r�sultat est bien coh�rent.
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
Les param�tres K1 et/ou K2 et/ou G sont absents du tableau des facteurs d'intensit� des
contraintes (SIF) fourni.
-> Risque et Conseil :
Le tableau des facteurs d'intensit� des contraintes doit absolument contenir ces trois
param�tres ainsi que K3 en 3D. Veuillez v�rifier le contenu de votre tableau de SIF.
"""),

45: _(u"""
 Lois de comportement diff�rentes pour la maille %(k3)s :
 - type de d�formation de la loi de comportement extraite de la SD R�sultat   : %(k1)s
 - type de d�formation de la loi de comportement fournie � l'op�rateur CALC_G : %(k2)s

--> Risques & conseils :
On doit g�n�ralement utiliser la m�me type de d�formation de loi de comportement entre le calcul et le
post-traitement. On peut utiliser deux type de d�formation diff�rents, mais alors
l'utilisateur doit �tre vigilant sur l'interpr�tation des r�sultats(cf.U2.05.01).
Si plusieurs types de d�formation de comportements sont d�finis sur la structure, le type de d�formation comportement �
indiquer dans CALC_G est celui du mat�riau dans lequel la fissure se d�veloppe.
Dans ce cas, ce message d'alarme est quand m�me �mis mais le r�sultat est bien coh�rent.
"""),

46: _(u"""
Le taux de restitution d'�nergie G est n�gatif ou nul sur certains des noeuds du fond de fissure :
le calcul de propagation est impossible.
-> Risque et Conseil :
V�rifier les param�tres du calcul de G (rayons des couronnes ou abscisse curviligne
maximale, type de lissage, ...).
"""),

47: _(u"""
Vous demandez un calcul de G en post-traitement d'un calcul �lastoplastique. Ceci n'est valable que 
si votre CHARGEMENT est MONOTONE PROPORTIONNEL.
Si tel est le cas, renseignez, dans CALC_G, l'option COMP_ELAS, RELATION = ELAS_VMIS_XXX pour un calcul de G.
Si votre chargement n'est pas monotone proportionnel, il faut renseigner, dans CALC_G, 
l'option COMP_INCR, RELATION=VMIS_XXX, et dans ce cas vous calculerez GTP (mod�le en cours de validation).
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
le nombre de cycles pour chacune d'elles est diff�rent.
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
Pour le comptage %(k1)s, la table doit comporter uniquement 1 instant/NUME_ORDRE (ou aucun).
Or la table %(k2)s contient %(i1)d instants/NUME_ORDRE.
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
