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

cata_msg={


2: _(u"""
Erreur dans la r�cup�ration de la dimension (du maillage ou du mod�le).
L'op�rateur CALC_G ne fonctionne que pour des maillages et des mod�les purement 2d ou 3d.
Notamment, un m�lange de dimensions n'est pas autoris�.
Si le besoin est r�el, faites une demande d'�volution aupr�s de l'�quipe de d�veloppement.
"""),

3: _(u"""
Erreur utilisateur.
Incoh�rence entre le mot-cl� OPTION et la dimension du probl�me.
L'option %(k1)s ne s'utilise qu'en 3d. Or le probl�me est 2d.
"""),

4: _(u"""
Erreur utilisateur :
Incoh�rence entre le mot-cl� FISSURE et le mod�le associ� au mot-cl� RESULTAT.
- Pour utiliser une fissure maill�e, renseignez sous le mot-cl� FOND_FISS
une fissure provenant de la commande DEFI_FOND_FISS.
- Pour utiliser une fissure non maill�e (calcul X-FEM), renseignez sous le mot-cl� FISSURE
une fissure provenant de la commande DEFI_FISS_XFEM. Le mod�le associ� au mot-cl� RESULTAT
doit �tre un mod�le X-FEM provenant de la commande MODI_MODELE_XFEM.
"""),


5: _(u"""
Il faut d�finir ELAS dans DEFI_MATERIAU.
"""),

6: _(u"""
La temp�rature en fond de fissure, n�cessaire pour le calcul des propri�t�s
mat�riaux et donc des facteurs d'intensit� des contraintes, n'est pas connue.
Le calcul se poursuite en prenant la temp�rature de r�f�rence du mat�riau
(TEMP = %(r1)f).
-> Risque et Conseil :
Quand les propri�t�s mat�riau d�pendent de la temp�rature, il faut fournir
en entr�e de POST_K1_K2_K3 le champ de temp�rature utilis� pour le calcul
m�canique, sous le mot cl� EVOL_THER.
"""),

7: _(u"""
L'entit� %(k1)s renseign�e au mot-cl� %(k2)s n'est pas dans le maillage.
-> Risque et Conseil :
Veuillez v�rifier les donn�es fournies au mot-cl� %(k2)s.
"""),

8: _(u"""
Probl�me dans la cr�ation de la base locale au fond de fissure.
Il est impossible de d�terminer le sens de la direction de propagation (vecteur tangent aux l�vres).
Dans le cas sym�trique (SYME='OUI') il faut :
- soit donner les l�vres de la fissure (LEVRE_SUP),
- soit indiquer le vecteur tangent au point origine du fond de fissure (DTAN_ORIG).
"""),

9: _(u"""
Dans le cas d'une SD RESULTAT de type DYNA_TRANS,
le mot-cl� EXCIT est obligatoire.
Veuillez le renseigner.
"""),

10: _(u"""
Mod�lisation non implant�e.
"""),

11: _(u"""
Probl�me � la r�cup�ration des noeuds du fond de fissure.
-> Risque et Conseil :
V�rifier que le concept %(k1)s indiqu� sous le mot cl� FOND_FISS a �t�
correctement cr�e par l'op�rateur DEFI_FOND_FISS.
"""),

12: _(u"""
Type de mailles du fond de fissure non d�fini.
-> Risque et Conseil :
Pour une mod�lisation 3D, les mailles de votre fond de fissure
doivent �tre de type SEG2 ou SEG3.
Veuillez revoir la cr�ation de votre fond de fissure
(op�rateur DEFI_FOND_FISS).
"""),

13: _(u"""
Le GROUP_NO %(k1)s n'est pas dans le maillage.
-> Risque et Conseil :
Veuillez v�rifier les donn�es fournies au mot-cl� GROUP_NO.
"""),

14: _(u"""
Le noeud  %(k1)s  n'appartient pas au maillage :  %(k2)s
-> Risque et Conseil :
Veuillez v�rifier les donn�es fournies au mot-cl� SANS_GROUP_NO.
"""),

15: _(u"""
Le noeud %(k1)s n'appartient pas au fond de fissure.
-> Risque et Conseil :
Veuillez v�rifier les donn�es fournies au mot-cl� GROUP_NO ou NOEUD.
"""),

16: _(u"""
Les l�vres de la fissure ne sont pas initialement coll�es.
POST_K1_K2_K3 ne fonctionne que sur des l�vres initialement coll�es.
-> Risque et Conseil :
   Veuillez v�rifier la d�finition du fond de fissure (DEFI_FOND_FISS/CONFIG_INIT).
   Si les l�vres sont vraiment d�coll�es alors il faut utiliser CALC_G.
"""),

17: _(u"""
La diff�rence entre la taille maximale et la taille minimale des mailles connect�es aux
noeuds du fond de fissure est importante.
La taille minimale vaut : %(r1)f
La taille maximale vaut : %(r2)f
-> Risque et Conseil :
Il a �t� choisi de multiplier par %(i1)d la taille maximale des mailles connect�es aux
noeuds du fond de fissure pour calculer le param�tre ABSC_CURV_MAXI. Or, si cette taille
est importante, vous risquez de post-traiter vos r�sultats sur une zone trop �loign�e
du fond de fissure et d'obtenir des valeurs de facteurs d'intensit� moins pr�cises.
V�rifiez que la valeur de ABSC_CURV_MAXI calcul�e est licite.
Sinon, veuillez sp�cifier directement la valeur de ABSC_CURV_MAXI ou bien revoir
le maillage de mani�re � rendre les mailles proches du fond de fissure de taille homog�ne.
"""),

18: _(u"""
Probl�me � la r�cup�ration du mod�le dans la sd r�sultat fournie.
-> Risque et Conseil :
Veuillez v�rifier que le concept fourni au mot-cl� RESULTAT correspond
au r�sultat � consid�rer.
"""),

19: _(u"""
Probl�me � la r�cup�ration des noeuds de la l�vre sup�rieure :
-> Risque et Conseil :
Pour un calcul avec POST_K1_K2_K3, la l�vre sup�rieure de la fissure doit
�tre obligatoirement d�finie dans DEFI_FOND_FISS � l'aide du mot-cl�
LEVRE_SUP. V�rifier la d�finition du fond de fissure.
"""),


21: _(u"""
Les noeuds ne sont pas en vis-�-vis dans le plan perpendiculaire
au noeud %(k1)s.
-> Risque et Conseil :
Pour interpoler les sauts de d�placement, les noeuds doivent �tre par d�faut
en vis-�-vis deux � deux sur les l�vres. Si ce n'est pas le cas, utilisez
l'option TYPE_MAILLE='LIBRE' dans POST_K1_K2_K3.
"""),

22: _(u"""
Il manque des points dans le plan d�fini par la l�vre
sup�rieure et perpendiculaire au fond %(k1)s.
-> Risque et Conseil :
"""),

23: _(u"""
V�rifier les tangentes extr�mit�s ou
"""),

24: _(u"""
Augmenter PREC_NORM dans DEFI_FOND_FISS.
"""),

25: _(u"""
Augmenter ABSC_CURV_MAXI.
"""),

26: _(u"""
Il manque des points dans le plan d�fini par la l�vre
inf�rieure et perpendiculaire au fond  %(k1)s.
-> Risque et Conseil :
"""),

27: _(u"""
Pour un r�sultat de type MODE_MECA, seule l'option CALC_K_G est disponible.
"""),

28: _(u"""
Le cas de charge %(k1)s n'a pas �t� trouv� dans la SD R�sultat %(k2)s.
-> Risque et Conseil :
Veuillez v�rifier les donn�es fournies au mot-cl� NOM_CAS.
"""),

29: _(u"""
Lorsque une mod�lisation 3D est de type FEM l'option %(k1)s n�cessite une
fissure en configuration coll�e.
-> Risque et Conseil :
Veuillez mettre CONFIG_INIT='COLLEE' dans DEFI_FOND_FISS.
"""),

30: _(u"""
Calcul possible pour aucun noeud du fond.
-> Risque et Conseil :
Veuillez v�rifier les donn�es, notamment celles du mot-cl� DIRECTION.
"""),

31: _(u"""
Il n'y a pas de mailles de bord connect�es au noeud %(k1)s.
"""),

32: _(u"""
Le param�tre ABSC_CURV_MAXI automatiquement choisi vaut : %(r1)f.
"""),

34: _(u"""
L'hypoth�se de l�vres coll�es n'est pas valide.
Cela peut �tre d� au fait :
 - que seule la l�vre sup�rieure est mod�lis�e. Dans ce cas, il faut mettre SYME='OUI'.
 - que les l�vres sont initialement d�coll�es. Dans ce cas, il faut mettre CONFIG_INIT='DECOLLEE'.
"""),

35: _(u"""
Attention, le vecteur tangent au 1er noeud du fond de fissure (DTAN_ORIG) est dans le sens
oppos� � celui calcul� automatiquement (%(r1)f %(r2)f %(r3)f).
Cela est probablement une erreur, qui peut conduire � des r�sultats faux.
-> Risque et Conseil :
  - v�rifiez DTAN_ORIG,
  - ou bien ne le renseignez pas.
"""),

36: _(u"""
Attention, le vecteur tangent au dernier noeud du fond de fissure (DTAN_EXTR) est dans le sens
oppos� � celui calcul� automatiquement (%(r1)f %(r2)f %(r3)f).
Cela est probablement une erreur, qui peut conduire � des r�sultats faux.
-> Risque et Conseil :
  - v�rifiez DTAN_EXTR,
  - ou bien ne le renseignez pas.
"""),

37: _(u"""
Le num�ro d'ordre %(i1)d n'a pas �t� trouv� dans la table.
"""),

38: _(u"""
Pas d'instant trouv� dans la table pour l'instant %(r1)f.
"""),

39: _(u"""
Plusieurs instants trouv�s dans la table pour l'instant %(r1)f.
"""),

41 : _(u"""
Le groupe de mailles %(k1)s d�fini sous le mot-cl� GROUP_MA n'existe pas.
"""),

42 : _(u"""
Dans le cas o� le fond est une courbe ferm�e, les mots-cl�s MAILLE_ORIG ou GROUP_MA_ORIG doivent accompagner le mot-cl� NOEUD_ORIG ou GROUP_NO_ORIG.
"""),

43 : _(u"""
Le noeud d�fini le mot-cl� NOEUD_ORIG ou GROUP_NO_ORIG n'appartient pas � la maille d�finie
sous le mot-cl� MAILLE_ORIG ou GROUP_MA_ORIG.
"""),

44 : _(u"""
La maille %(k1)s d�finie sous le mot-cl� MAILLE_ORIG ou GROUP_MA_ORIG n'appartient pas au fond de fissure.
"""),

45 : _(u"""
Une seule maille doit constitu� le groupe de mailles GROUP_MA_ORIG. La maille utilis�e est %(k1)s.
"""),

46: _(u"""
Il faut au moins trois noeuds dans le plan d�fini par les l�vres et perpendiculaire
au fond de fissure. Le calcul est impossible. On extrapole les valeurs du point le plus proche.
"""),

47: _(u"""
Noeud %(k1)s
"""),

48: _(u"""
Le mot-cl� 'FOND_FISS' est obligatoire avec l'option  %(k1)s.
Veuillez le renseigner.
"""),

49: _(u"""
Le maillage ne permet pas de d�terminer la taille des mailles en fond de fissure, et donc
R_INF/R_SUP ou ABSC_CURV_MAXI seront obligatoires en post-traitement.
-> Conseil :
Pour ne plus avoir cette alarme, il faut revoir le maillage et faire en sorte que chaque noeud du fond
de fissure soit connect� � au moins une ar�te faisant un angle inf�rieur � 60 degr�s avec le vecteur de
direction de propagation.
"""),

50: _(u"""
Nombre de modes diff�rent entre la base modale
et %(k1)s : on prend le minimum des deux %(i1)d.
"""),

51: _(u"""
Le num�ro d'ordre %(i1)d n'appartient pas au r�sultat %(k1)s.
"""),

52: _(u"""
Vous avez utilis� des param�tres mat�riaux d�pendant de la temp�rature.
Cependant, 'TEMP_DEF_ALPHA' dans DEFI_MATERIAU n'est pas renseign�.
-> Conseil :
Renseignez une temp�rature pour 'TEMP_DEF_ALPHA',
ou utilisez l'option 'EVOL_THER' de POST_K1_K2_K3.
"""),

53: _(u"""
Vous avez utilis� un module de Young nul. Le post-traitement ne peut pas se poursuivre."""),

54: _(u"""
Aucun instant ou num�ro d'ordre trouv�.
"""),

55: _(u"""
-> Attention: Le mot-cl� EXCIT est facultatif, il n'est pas n�cessaire dans tous les cas.
Il n'est utile que si le r�sultat � post-traiter a �t� cr�� avec la commande CREA_RESU.
-> Risque et Conseil :
Si vous utilisez CALC_G en dehors de ce cas sp�cifique,
v�rifiez la pr�sence de tous les chargements ayant servi � cr�er le r�sultat.
"""),

56 : _(u"""
CALC_G - option CALC_K_G : le calcul est impossible sur un point de rayon nul
(point sur l'axe de rotation).
-> Risque et Conseil :
Modifier les couronnes R_INF et R_SUP pour qu'elles soient toutes les deux plus
petites que le rayon du fond de fissure. De mani�re g�n�rale en axisym�trie, le
calcul de K est d'autant plus pr�cis que le rayon des couronnes est petit devant
le rayon du fond de fissure.
"""),

57 : _(u"""
Pour cette option en 3D, le champ THETA doit �tre calcul� directement
dans l'op�rateur CALC_G.
-> Risque et Conseil :
Dans le mot-cl� facteur THETA, supprimez le mot-cl� THETA et renseignez les
mots-cl�s FOND_FISS, R_SUP, R_INF, MODULE, et DIRECTION pour la d�termination
automatique du champ th�ta.
"""),








60 : _(u"""
M�lange de mailles de type SEG2 et SEG3 dans la d�finition du fond de fissure.
-> Risque et Conseil :
Les mailles du fond de fissure doivent toutes �tre du m�me type.
Modifiez le maillage ou d�finissez plusieurs fonds de fissure cons�cutifs.
"""),

61 : _(u"""
L'angle entre 2 vecteurs normaux cons�cutifs est sup�rieur � 10 degr�s.
Cela signifie que la fissure est fortement non plane.
-> Risque et Conseil :
 - Le calcul des facteurs d'intensit� des contraintes sera potentiellement impr�cis,
 - Un raffinement du fond de fissure est probablement n�cessaire.
"""),

63 : _(u"""
Les mailles du fond de fissure doivent �tre du type segment (SEG2 ou SEG3).
"""),

65 : _(u"""
D�tection d'une maille de type %(k1)s dans la d�finition des l�vres de la
fissure (%(k2)s).
-> Risque et Conseil :
Les mailles des l�vres doivent �tre du type quadrangle ou triangle.
V�rifiez que les mailles d�finies correspondent bien aux faces des �l�ments
3D qui s'appuient sur la l�vre.
"""),

66 : _(u"""
Le groupe de noeuds ou la liste de noeuds d�finissant le fond de fissure n'est pas ordonn�.
-> Risque et Conseil :
Il faut ordonner les noeuds du fond de fissure.
Les options SEGM_DROI_ORDO et NOEUD_ORDO de l'op�rateur
DEFI_GROUP/CREA_GROUP_NO peuvent �tre utilis�es.
."""),

67 : _(u"""
Les mots-cl�s LISSAGE_G et LISSAGE_THETA n'ont de sens que pour un calcul 3d local.
Dans le cas pr�sent, ils sont ignor�s.
-> Conseil pour ne plus avoir cette alarme :
Supprimer les mots-cl�s LISSAGE_G et/ou LISSAGE_THETA.
."""),

68 : _(u"""
Les mailles de FOND_INF et de FOND_SUP sont de type diff�rent.
  Type de mailles pour FOND_SUP : %(k1)s
  Type de mailles pour FOND_INF : %(k2)s
"""),

69: _(u"""
Les noeuds %(k1)s de FOND_INF et %(k2)s de FOND_SUP ne sont pas en vis � vis.
-> Risque et Conseil :
V�rifiez que les deux groupes correspondent bien � des noeuds co�ncidents
g�om�triquement et que les groupes de noeuds sont ordonn�s dans le m�me sens.
"""),

70 : _(u"""
Erreur utilisateur : la l�vre d�finie sous %(k1)s poss�de une maille r�p�t�e 2 fois :
maille %(k2)s.
-> Risque et Conseil :
Veuillez revoir les donn�es.
"""),


72 : _(u"""
Le noeud %(k1)s du fond de fissure n'est rattach� � aucune maille surfacique
de la l�vre d�finie sous %(k2)s.
-> Risque et Conseil :
Veuillez v�rifier les groupes de mailles.
"""),

73 : _(u"""
Erreur utilisateur : la l�vre inf�rieure et la l�vre sup�rieure ont une maille
surfacique en commun. Maille en commun : %(k1)s
-> Risque et Conseil :
Revoir les donn�es.
"""),

74: _(u"""
Le mode %(i1)d n'a pas �t� trouv� dans la table.
"""),

75 : _(u"""
D�tection d'une maille de type %(k1)s dans la d�finition des l�vres de la
fissure (%(k2)s).
-> Risque et Conseil :
Les mailles des l�vres doivent �tre lin�iques. V�rifiez que les mailles
d�finies correspondent bien aux faces des �l�ments 2D qui s'appuient
sur la l�vre.
"""),

76: _(u"""
Erreur utilisateur.
Cette combinaison de lissage est interdite avec X-FEM.
"""),

78: _(u"""
La tangente � l'origine n'est pas orthogonale � la normale :
   Normale aux l�vres de la fissure : %(r1)f %(r2)f %(r3)f
   Tangente � l'origine (= direction de propagation) :  %(r4)f %(r5)f %(r6)f
-> Risque et Conseil :
La tangente � l'origine est n�cessairement dans le plan de la fissure,
donc orthogonale � la normale fournie. V�rifier les donn�es.
"""),

79: _(u"""
La tangente � l'extr�mit� n'est pas orthogonale � la normale :
   Normale aux l�vres de la fissure : %(r1)f %(r2)f %(r3)f
   Tangente � l'origine (= direction de propagation) :  %(r4)f %(r5)f %(r6)f
-> Risque et Conseil :
La tangente � l'extr�mit� est n�cessairement dans le plan de la fissure,
donc orthogonale � la normale fournie. V�rifier les donn�es.
"""),

81: _(u"""
Il faut donner la direction de propagation en 2D
La direction par d�faut n'existe plus.
-> Risque et Conseil :
Veuillez renseigner le mot-cl� DIRECTION.
"""),

83: _(u"""
Cette combinaison de lissage n'est pas programm�e pour l'option : %(k1)s.
-> Risque et Conseil :
Veuillez consulter la documentation U4.82.03 pour d�terminer une combinaison de lissage
licite avec l'option d�sir�e.
"""),

84: _(u"""
Le degr� des polyn�mes de Legendre doit �tre inf�rieur au nombre de noeuds
du fond de fissure (ici �gal � %(i1)i) lorsque le lissage de G est de type
LEGENDRE et le lissage de THETA de type LAGRANGE.
"""),

86: _(u"""
Erreur utilisateur.
Cette combinaison de lissage est interdite.
"""),

88: _(u"""
Aucune fr�quence trouv�e dans la table pour la fr�quence %(r1)f.
"""),

89: _(u"""
Plusieurs fr�quences trouv�es dans la table pour la fr�quence %(r1)f.
"""),



90: _(u"""
L'usage des polyn�mes de Legendre dans le cas d'un fond de fissure clos
est interdit.
-> Risque et Conseil :
Veuillez red�finir le mot-cl� LISSAGE_THETA.
"""),

91: _(u"""
Aucune direction de propagation n'est fournie par l'utilisateur, la direction est
calcul�e � partir de la normale au fond de fissure (donn�e dans DEFI_FOND_FISS).

-> Risque :
  - La direction calcul�e est correcte, au signe pr�s. En effet, comme il n'y a
    aucun moyen de v�rifier que la direction de propagation est dans le bon sens,
    cela peut inverser le signe du G calcul�.

-> Conseils pour ne plus avoir cette alarme :
  - On peut pr�ciser la direction de propagation sous le mot cl� DIRECTION.
    Cette solution n'est applicable que si le fond de fissure est rectiligne.
  - La solution la plus g�n�rale (donc pr�f�rable) est de d�finir le fond de
    fissure � partir des mailles de l�vres (DEFI_FOND_FISS/LEVRE_SUP et LEVRE_INF).
"""),

92: _(u"""
Le mot-clef BORNES est obligatoire avec l'option  %(k1)s  !
"""),

93: _(u"""
Acc�s impossible au champ SIEF_ELGA pour le num�ro d'ordre : %(i1)d.
Or il est n�cessaire de conna�tre SIEF_ELGA car vous avez activ� le mot-cl� 
CALCUL_CONTRAINTE='NON'. Le calcul s'arr�te.
-> Conseils :
- V�rifiez vote mise en donn�es pour archiver SIEF_ELGA � tous les instants 
demand�s dans la commande CALC_G.
- Ou bien supprimer CALCUL_CONTRAINTE='NON' de la commande CALC_G.
"""),

94: _(u"""
La direction de propagation de la fissure et la normale au fond de fissure
ne sont pas orthogonales.
-> Risque et Conseil :
Si la fissure est plane, la normale et la direction de propagation sont
n�cessairement orthogonales, sinon les r�sultats sont faux: v�rifier la
mise en donn�es dans DEFI_FOND_FISS et CALC_G.
Si la fissure n'est pas plane, on ne peut pas utiliser le mot-cl� NORMALE
dans DEFI_FOND_FISS: d�finissez la fissure � partir des mailles de ses l�vres.
"""),

95: _(u"""
Erreur utilisateur.
Il y a incompatibilit� entre le mot-cl� FOND_FISS et le mod�le %(k1)s associ�
� la structure de donn�e RESULTAT. En effet, le mod�le %(k1)s est un mod�le X-FEM.
-> Conseil :
Lorsque le mod�le est de type X-FEM il faut obligatoirement utiliser
le mot-cl� FISSURE de la commande CALC_G.
"""),

96: _(u"""
Erreur utilisateur.
Il y a incompatibilit� entre le mot-cl� FISSURE et le mod�le %(k1)s associ�
� la structure de donn�e RESULTAT. En effet, le mod�le %(k1)s est un mod�le non X-FEM.
-> Conseil :
Veuillez utiliser les mots-cl�s FOND_FISS ou THETA ou revoir votre mod�le.
"""),

97: _(u"""
Erreur utilisateur.
Il y a incompatibilit� entre le mot-cl� FISSURE et le mod�le %(k2)s associ�
� la structure de donn�e RESULTAT. En effet, la fissure %(k1)s n'est pas associ�e au 
mod�le %(k2)s.
-> Conseils :
  - V�rifier le mot-cl� FISSURE,
  - V�rifier le mot-cl� RESULTAT,
  - V�rifier la commande MODI_MODELE_XFEM qui a cr�� le mod�le %(k2)s.
"""),

99: _(u"""
Point du fond num�ro : %(i1)d.
Augmenter NB_NOEUD_COUPE. S'il s'agit d'un noeud extr�mit�, v�rifier les tangentes
(DTAN_ORIG et DTAN_EXTR).
"""),

}
