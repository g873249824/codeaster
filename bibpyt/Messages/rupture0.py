#@ MODIF rupture0 Messages  DATE 14/03/2011   AUTEUR GENIAUT S.GENIAUT 
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

def _(x) : return x

cata_msg={
1: _("""
La valeur de Kj critique demand�e n'est pas atteinte dans l'�tude demand�e;
il n'est donc pas possible d'identifier le Gp critique dans cette �tude.
-> Risque et Conseil :
Augmentez le chargement.
"""),

2: _("""
Le label %(k1)s doit etre pr�sent dans la table %(k2)s.
"""),

3: _("""
Cr�ation de la table  %(k1)s.
"""),

4: _("""
Erreur utilisateur :
Incoh�rence entre le mot-cl� FISSURE et le mod�le associ� au mot-cl� RESULTAT.
- Pour utiliser une fissure maill�e, renseignez sous le mot-cl� FOND_FISS
une fissure provenant de la commande DEFI_FOND_FISS.
- Pour utiliser une fissure non-maill�e (calcul X-FEM), renseignez sous le mot-cl� FISSURE
une fissure provenant de la commande DEFI_FISS_XFEM. Le mod�le associ� au mot-cl� RESULTAT 
doit �tre un mod�le X-FEM provenant de la commande MODI_MODELE_XFEM.
"""),


5: _("""
Il faut d�finir ELAS dans DEFI_MATERIAU.
"""),

6: _("""
La temp�rature en fond de fissure, n�cessaire pour le calcul des propriet�s
mat�riaux et donc des facteurs d'intensit� des contraintes, n'est pas connue.
Le calcul se poursuite en prenant la temp�rature de r�ference du materiau
(TEMP = %(r1)f).
-> Risque et Conseil :
Quand les propri�t�s mat�riau d�pendent de la temp�rature, il faut fournir 
en entr�e de POST_K1_K2_K3 le champ de temp�rature utilis� pour le calcul 
m�canique, sous le mot cl� EVOL_THER.
"""),

9: _("""
Dans le cas d'une SD RESULTAT de type DYNA_TRANS,
le mot-cle EXCIT est obligatoire.
Veuillez le renseigner.
"""),

10: _("""
Mod�lisation non implant�e.
"""),

11: _("""
Probl�me � la r�cup�ration des noeuds du fond de fissure.
-> Risque et Conseil :
V�rifier que le concept %(k1)s indiqu� sous le mot cl� FOND_FISS a �t� 
correctement cr�e par l'op�rateur DEFI_FOND_FISS.
"""),

12: _("""
Type de mailles du fond de fissure non d�fini.
-> Risque et Conseil :
Pour une mod�lisation 3D, les mailles de votre fond de fissure
doivent etre de type SEG2 ou SEG3.
Veuillez revoir la cr�ation de votre fond de fissure 
(op�rateur DEFI_FOND_FISS). 
"""),

13: _("""
Le group_no %(k1)s n'est pas dans le maillage.
-> Risque et Conseil :
Veuillez v�rifier les donn�es fournies au mot-cl� GROUP_NO.
"""),

14: _("""
Le noeud  %(k1)s  n'appartient pas au maillage :  %(k2)s
-> Risque et Conseil :
Veuillez v�rifier les donn�es fournies au mot-cl� SANS_GROUP_NO.
"""),

15: _("""
Le noeud %(k1)s n'appartient pas au fond de fissure.
-> Risque et Conseil :
Veuillez v�rifier les donn�es fournies au mot-cl� GROUP_NO ou NOEUD.
"""),

16: _("""
Le mot cl� RESULTAT est obligatoire pour TYPE_MAILLAGE = LIBRE.
"""),

18: _("""
Probl�me � la r�cup�ration du mod�le dans la sd r�sultat fournie.
-> Risque et Conseil :
Veuillez v�rifier que le concept fourni au mot-cl� RESULTAT correspond
au r�sultat � consid�rer.
"""),

19: _("""
Probl�me � la r�cup�ration des noeuds de la l�vre sup : 
-> Risque et Conseil :
Pour un calcul avec POST_K1_K2_K3, la l�vre sup�rieure de la fissure doit 
�tre obligatoirement d�finie dans DEFI_FOND_FISS � l'aide du mot-cl�
LEVRE_SUP. V�rifier la d�finition du fond de fissure.
"""),

20: _("""
Probl�me � la r�cup�ration des noeuds de la l�vre inf : 
-> Risque et Conseil :
Pour un calcul avec POST_K1_K2_K3, la l�vre inf�rieure de la fissure doit
�tre obligatoirement d�finie dans DEFI_FOND_FISS � l'aide du mot-cl�
LEVRE_INF. 
Si seule la l�vre sup�rieure est maill�e, ne pas oublier de sp�cifier
SYME_CHAR = 'SYME' dans POST_K1_K2_K3. 
"""),

21: _("""
Les noeuds ne sont pas en vis-�-vis dans le plan perpendiculaire
au noeud %(k1)s.
-> Risque et Conseil :
Pour interpoler les sauts de d�placement, les noeuds doivent �tre par d�faut
en vis-�-vis deux � deux sur les l�vres. Si ce n'est pas le cas, utilisez
l'option TYPE_MAILLE='LIBRE' dans POST_K1_K2_K3.
"""),

22: _("""
Il manque des points dans le plan d�fini par la l�vre
sup�rieure et perpendiculaire au fond %(k1)s.
-> Risque et Conseil :
"""),

23: _("""
V�rifier les tangentes extremit�s ou
"""),

24: _("""
Augmenter PREC_NORM dans DEFI_FOND_FISS.
"""),

25: _("""
Augmenter ABSC_CURV_MAXI.
"""),

26: _("""
Il manque des points dans le plan d�fini par la l�vre
inf�rieure et perpendiculaire au fond  %(k1)s.
-> Risque et Conseil :
"""),

27: _("""
Pour un r�sultat de type MODE_MECA,
l'option de calcul doit etre K_G_MODA.
-> Risque et Conseil :
Veuillez fournir au mot-cl� OPTION l'option K_G_MODA
et v�rifier que le concept fourni au mot-cl� RESULTAT
est de type MODE_MECA.
"""),

28: _("""
Le cas de charge %(k1)s n'a pas �t� trouv� dans la SD R�sultat %(k2)s.
-> Risque et Conseil :
Veuillez v�rifier les donn�es fournies au mot-cl� NOM_CAS.
"""),

29: _("""
Le mot-cl� 'FISSURE' est obligatoire avec l'option  %(k1)s.
Veuillez le renseigner.
"""),

30: _("""
Calcul possible pour aucun noeud du fond.
-> Risque et Conseil :
Veuillez v�rifier les donn�es, notamment celles du mot-cl� DIRECTION.
"""),

32: _("""
Diff�rence entre la normale au plan d�duite de VECT_K1 et la normale 
au plan de la fissure calcul�e pour le noeud %(i1)d :
  VECT_K1 : (%(r4)f,%(r5)f,%(r6)f)
  Vecteur normal calcul� � partir de la d�finition de la fissure : (%(r1)f,%(r2)f,%(r3)f)
-> Risque et Conseil :
On poursuit le calcul mais si l'�cart entre les deux vecteurs est trop important, 
le calcul risque d'�chouer ou de conduire � des r�sultats peu pr�cis.
V�rifier absolument le VECT_K1 fourni ou supprimer ce mot cl� pour que la normale
au plan soit calcul�e automatiquement.
"""),

33: _("""
Probl�me dans la r�cup�ration du saut de d�placement sur les l�vres.
-> Risque et Conseil :
Il y a plusieurs causes possibles :
- v�rifiez que le r�sultat correspond bien � un calcul sur des �l�ments x-fem;
- si le calcul correspond � un calcul X-FEM avec contact sur les l�vres de la
  fissure,v�rifiez que le maillage fourni est bien le maillage lin�aire initial;
- v�rifiez que le param�tre ABSC_CURV_MAXI est coh�rent avec la taille de la
  fissure : les segments pour l'interpolation du d�placement des l�vres, 
  perpendiculaires au fond de fissure et de longueur ABSC_CURV_MAXI, ne doivent
  pas "sortir" de la mati�re.
"""),


37: _("""
Le num�ro d'ordre %(i1)d n'a pas �t� trouv� dans la table.
"""),

38: _("""
Pas d'instant trouv� dans la table pour l'instant %(r1)f.
"""),

39: _("""
Plusieurs instants trouv�s dans la table pour l'instant %(r1)f.
"""),

40: _("""
ABSC_CURV non croissants pour %(k1)s.
"""),


46: _("""
Il faut au moins trois noeuds dans le plan d�fini par les l�vres et perpendiculaire 
au fond de fissure. Le calcul est impossible : on met la ligne correspondant au noeud
consid�r� � z�ro et on poursuit le calcul pour le noeud du fond suivant.
-> Risque et Conseil :
"""),

47: _("""
Noeud %(k1)s 
"""),

48: _("""
Le mot-cl� 'FOND_FISS' est obligatoire avec l'option  %(k1)s.
Veuillez le renseigner.
"""),

49: _("""
D�placement normal du noeud %(k1)s non nul
et SYME_CHAR = %(k2)s.
-> Risque et Conseil :
V�rifier les conditions aux limites et VECT_K1.
"""),

50: _("""
Nombre de modes diff�rent entre la base modale
et %(k1)s : on prend le minimum des deux %(i1)d.
"""),

51: _("""
Le num�ro d'ordre %(i1)d n'appartient pas au r�sultat %(k1)s.
"""),

54: _("""
Aucun instant ou num�ro d'ordre trouv�.
"""),

55: _("""
-> Attention: En pr�sence d'une SD R�sultat de type mult_elas, les mots-cl�s
EXCIT et NOM_CAS sont obligatoires.
-> Risque et Conseil :
Risque de r�sultats faux si un des chargements impacte le calcul de G et de K
(par exemple force de pression sur les l�vres de la fissure,force volumique...)
"""),

56 : _("""
CALC_G - option CALC_K_G : le calcul est impossible sur un point de rayon nul
(point sur l'axe de rotation).
-> Risque et Conseil :
Modifier les couronnes R_INF et R_SUP pour qu'elles soient toutes les deux plus
petites que le rayon du fond de fissure. De mani�re g�n�rale en axisym�trie, le
calcul de K est d'autant plus pr�cis que le rayon des couronnes est petit devant
le rayon du fond de fissure.
"""),

57 : _("""
Pour l'option CALC_G en 3D, le champ THETA doit �tre calcul� directement
dans l'op�rateur CALC_G.
-> Risque et Conseil :
Dans le mot-cl� facteur THETA, supprimez le mot-cl� THETA et renseignez les 
mots-cl�s FOND_FISS, R_SUP, R_INF, MODULE, et DIRECTION pour la d�termination
automatique du champ theta.
"""),

59 : _("""
Le champ de THETA est inexistant dans la structure de donn�es  %(k1)s
de type THETA_GEOM.
-> Risque et Conseil :
Veuillez revoir la cr�ation du champ theta (op�rateur CALC_THETA).
"""),

60 : _("""
M�lange de mailles de type SEG2 et SEG3 dans la d�finition du fond de fissure.
-> Risque et Conseil :
Les mailles du fond de fissure doivent toutes �tre du meme type. 
Modifiez le maillage ou d�finissez plusieurs fonds de fissure cons�cutifs.
"""),

61 : _("""
Le groupe de noeuds  %(k1)s d�finissant le fond de fissure n'est pas ordonn�.
-> Risque et Conseil :
Il faut ordonner les noeuds du fond de fissure. 
Les options SEGM_DROI_ORDO et NOEUD_ORDO de l'op�rateur 
DEFI_GROUP/CREA_GROUP_NO peuvent etre utilis�es.
."""),

62 : _("""
Arret sur erreur utilisateur : deux GROUP_NO cons�cutifs incoh�rents dans la 
d�finition du fond de fissure.
-> Risque et Conseil :
Les noeuds de chaque groupe doivent etre ordonn�s et le dernier noeud d'un
groupe identique au premier noeud du groupe suivant dans la liste.
"""),

63 : _("""
Les mailles du fond de fissure doivent etre du type segment (SEG2 ou SEG3).
"""),

64 : _("""
Arret sur erreur utilisateur : deux mailles ou groupes de mailles du fond de
fissure sont non cons�cutives dans la num�rotation des noeuds.
En effet, le fond de fissures doit �tre discr�tis� avec des mailles segment 
ordonn�es de telle sorte que pour deux segments cons�cutifs, le 2�me noeud sommet
du 1er segment soit le m�me que le 1er noeud sommet du 2�me segment.

Conseil : Pour ordonner les mailles du fond de fissure, veuillez 
utiliser NOEUD_ORIG (ou GROUP_NO_ORIG) et NOEUD_EXTR (ou GROUP_NO_EXTR).
"""),

65 : _("""
D�tection d'une maille de type %(k1)s dans la d�finition des l�vres de la
fissure (%(k2)s).
-> Risque et Conseil :
Les mailles des l�vres doivent etre du type quadrangle ou triangle. 
V�rifiez que les mailles d�finies correspondent bien aux faces des �l�ments
3D qui s'appuient sur la l�vre.
"""),

66 : _("""
La liste de noeuds d�finissant le fond de fissure n'est pas ordonn�e. 
-> Risque et Conseil :
Veuillez v�rifier l'ordre des noeuds.
"""),

67 : _("""
Arret sur erreur utilisateur : le fond de fissure poss�de un noeud
r�p�t� deux fois (noeud  %(k1)s). 
-> Risque et Conseil :
Veuillez revoir la d�finition du fond dans FOND_FISS ou FOND_FERME.
"""),

68 : _("""
Les mailles de FOND_INF et de FOND_SUP sont de type diff�rent.
  Type de mailles pour FOND_SUP : %(k1)s
  Type de mailles pour FOND_INF : %(k2)s
"""),

69: _("""
Les noeuds %(k1)s de FOND_INF et %(k2)s de FOND_SUP ne sont pas en vis � vis. 
-> Risque et Conseil :
V�rifiez que les deux groupes correspondent bien � des noeuds coincidents
g�om�triquement et que les groupes de noeuds sont ordonn�s dans le meme sens. 
"""), 

70 : _("""
Erreur utilisateur : la l�vre sup�rieure poss�de une maille r�p�t�e 2 fois : 
maille  %(k1)s. 
-> Risque et Conseil :
Veuillez revoir les donn�es.
"""),

71 : _("""
Erreur utilisateur : la l�vre inf�rieure poss�de une maille r�p�t�e 2 fois : 
maille  %(k1)s. 
-> Risque et Conseil :
Veuillez revoir les donn�es.
"""),

72 : _("""
Le noeud %(k1)s du fond de fissure n'est rattach� � aucune maille surfacique
de la l�vre sup�rieure.
-> Risque et Conseil :
Veuillez v�rifier les groupes de mailles.
"""), 

73 : _("""
Erreur utilisateur : la l�vre inf�rieure et la l�vre sup�rieure ont une maille
surfacique en commun. Maille en commun : %(k1)s
-> Risque et Conseil :
Revoir les donn�es.
"""),

74: _("""
Le noeud %(k1)s du fond de fissure n'est rattach� � aucune maille
surfacique de la l�vre inf�rieure.
-> Risque et Conseil :
Veuillez v�rifier les groupes de mailles.
"""), 

75 : _("""
D�tection d'une maille de type %(k1)s dans la d�finition des l�vres de la
fissure (%(k2)s).
-> Risque et Conseil :
Les mailles des l�vres doivent etre lin�iques. V�rifiez que les mailles 
d�finies correspondent bien aux faces des �l�ments 2D qui s'appuient
sur la l�vre.
"""),

76: _("""
Le noeud %(k1)s du fond de fissure n'appartient � aucune des mailles
de la l�vre sup�rieure. 
-> Risque et Conseil :
Veuillez revoir les donn�es.
"""), 

77: _("""
Le noeud %(k1)s du fond de fissure n'appartient � aucune des mailles
de la l�vre inf�rieure. 
-> Risque et Conseil :
Veuillez revoir les donn�es.
"""), 

78: _("""
La tangente � l'origine n'est pas orthogonale � la normale :
   Normale aux l�vres de la fissure : %(r1)f %(r2)f %(r3)f
   Tangente � l'origine (= direction de propagation) :  %(r4)f %(r5)f %(r6)f
-> Risque et Conseil :
La tangente � l'origine est n�cessairement dans le plan de la fissure, 
donc orthogonale � la normale fournie. V�rifier les donn�es.
"""), 

79: _("""
La tangente � l'extr�mit� n'est pas orthogonale � la normale :
   Normale aux l�vres de la fissure : %(r1)f %(r2)f %(r3)f
   Tangente � l'origine (= direction de propagation) :  %(r4)f %(r5)f %(r6)f
-> Risque et Conseil :
La tangente � l'extr�mit� est n�cessairement dans le plan de la fissure, 
donc orthogonale � la normale fournie. V�rifier les donn�es.
"""), 

80: _("""
Il ne faut donner la direction de propagation si le champ th�ta est donn�.

-> Conseil :
Veuillez supprimer le mot-cl� DIRECTION sous CALC_G/THETA.
"""), 


81: _("""
Il faut donner la direction de propagation en 2D
La direction par d�faut n'existe plus.
-> Risque et Conseil :
Veuillez renseigner le mot-cl� DIRECTION.
"""), 

83: _("""
Cette combinaison de lissage n'est pas programm�e pour l'option : %(k1)s.
-> Risque et Conseil :
Veuillez consulter la doc U4.82.03 pour d�terminer une combinaison de lissage
licite avec l'option d�sir�e.
"""), 

84: _("""
Le degr� des polynomes de Legendre doit etre inf�rieur au nombre de noeuds
du fond de fissure (ici �gal � %(i1)i) lorsque le lissage de G est de type
LEGENDRE et le lissage de THETA de type LAGRANGE.
"""), 

85: _("""
Le lissage de G doit etre de type LEGENDRE si le lissage de THETA
est de type LEGENDRE.
-> Risque et Conseil :
Veuillez red�finir le mot-cl� LISSAGE_G.
"""), 

87: _("""
Si la m�thode LAGRANGE_REGU est utilis�e pour le lissage, 
alors le lissage de G et de theta doivent etre de type LAGRANGE_REGU.
"""),

90: _("""
L'usage des polynomes de Legendre dans le cas d'un fond de fissure clos
est interdit.
-> Risque et Conseil :
Veuillez red�finir le mot-cl� LISSAGE_THETA.
"""), 

91: _("""
Aucune direction de propagation n'est fournie par l'utilisateur, la direction est
calcul�e � partir de la normale au fond de fissure (donn�e dans DEFI_FOND_FISS).
-> Risque et Conseil :
  - Si le fond de fissure est droit, la direction calcul�e est correcte, au signe pr�s.
Comme il n'y a aucun moyen de v�rifier que la direction de propagation est dans le bon sens,
cela peut inverser le signe du G calcul�. On peut alors pr�ciser la direction de
propagation sous le mot cl� DIRECTION. Mais il est pr�f�ranbble de d�finir la fissure �
partir des mailles de ses l�vres (DEFI_FOND_FISS).
- Si le fond de fissure est courbe, le direction calcul�e n'est pas correcte et il faut
imp�rativement d�finir la fissure � partir des mailles de ses l�vres (DEFI_FOND_FISS).
"""), 

92: _("""
Le mot-clef BORNES est obligatoire avec l'option  %(k1)s  !
"""), 

93: _("""
Acc�s impossible au champ : %(k1)s pour le num�ro d'ordre : %(i1)d
"""), 

94: _("""
La direction de propagation de la fissure et la normale au fond de fissure
ne sont pas orthogonales.
-> Risque et Conseil :
Si la fissure est plane, la normale et la direction de propagation sont
n�cessairement orthogonales, sinon les r�sultats sont faux: v�rifier la
mise en donn�es dans DEFI_FOND_FISS et CALC_G.
Si la fissure n'est pas plane, on ne peut pas utiliser le mot-cl� NORMALE
dans DEFI_FOND_FISS: d�finissez la fissure � partir des mailles de ses l�vres.
"""), 

95: _("""
Acc�s impossible au mode propre champ : %(k1)s pour le num�ro d'ordre : %(i1)d.
"""), 

96: _("""
Option non disponible actuellement.
"""), 

98: _("""
R�cup�ration impossible de la normale dans le fond de fissure FOND_FISS.
-> Risque et Conseil :
Un probl�me a du se produire lors de la cr�ation de la structure de donn�es 
FOND_FISS. V�rifiez les donn�es dans DEFI_FOND_FISS.
"""), 

99: _("""
Point du fond num�ro : %(i1)s.
Augmenter NB_NOEUD_COUPE. S'il s'agit d'un noeud extr�mit�, v�rifier les tangentes 
(DTAN_ORIG et DTAN_EXTR).
"""), 

}
