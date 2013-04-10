#@ MODIF elements Messages  DATE 09/04/2013   AUTEUR PELLET J.PELLET 
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

cata_msg = {

1 : _(u"""
 AFFE_CARA_ELEM : mot cl� GENE_TUYAU
 probl�me : OMEGA est diff�rent de OMEGA2
 OMEGA  = %(r1)f
 OMEGA2 = %(r2)f
"""),

2 : _(u"""
Erreur :
   Le calcul du chargement d� au s�chage n'est pas programm� par le type d'�l�ment %(k1)s.

Conseil :
  �mettre une demande d'�volution.
"""),

3 : _(u"""
Vous utilisez des �l�ments de type GRILLE_MEMBRANE. Le mot-cl� ANGL_REP de la commande AFFE_CARA_ELEM
permet d'indiquer la direction des armatures.
La projection de ce vecteur directeur dans le plan de certains des �l�ments de GRILLE_MEMBRANE est nulle.

Conseil :
  V�rifiez les donn�es sous le mot clef ANGL_REP de la commande AFFE_CARA_ELEM.
"""),

4 : _(u"""
Probl�me dans le calcul de l'option FORC_NODA / REAC_NODA :

Le nombre de sous-point du champ de contrainte contenu dans la SD n'est
pas coh�rent avec ce qui a �t� d�fini dans AFFE_CARA_ELEM.

Il est probable que le champ de contrainte a �t� extrait sur un seul sous-point.

Il est imp�ratif d'utiliser un champ de contrainte complet pour le calcul de FORC_NODA.
"""),

5 : _(u"""
 probl�me de maillage TUYAU :
 pour une maille d�finie par les noeuds N1 N2 N3,
 le noeud N3 doit �tre le noeud milieu
"""),

6 : _(u"""
  GENE_TUYAU
  il faut donner un vecteur non colin�aire au tuyau
"""),

7 : _(u"""
  -> L'angle du coude est trop grand
     ANGLE     = %(r1)f
     ANGLE MAX = %(r2)f
  -> Risque & Conseil : mailler plus fin
"""),

8 : _(u"""
La raideur tangente de la section est nulle.
V�rifier votre mat�riau, vous avez peut �tre d�fini un mat�riau �lastoplastique parfait.

Risque & Conseil : mettre un l�ger �crouissage peut permettre de passer cette difficult�.
"""),


9 : _(u"""
 il faut renseigner le coefficient E_N  dans les cas des d�formations planes et de l'asym�trie
 on ne regarde donc que le cas des contraintes planes.
"""),

10 : _(u"""
 Sous-programme CHPVER :
 le champ  %(k1)s n'a pas le bon type :
   type autoris�  :%(k2)s
   type du champ  :%(k3)s
"""),

11 : _(u"""
 La mod�lisation utilis�e n'est pas trait�e.
"""),

12 : _(u"""
 Le nombre de couche doit �tre obligatoirement sup�rieur � z�ro.
"""),

13 : _(u"""
 Le nombre de couche est limit� � 10 pour la mod�lisation COQUE_3D.
"""),

14 : _(u"""
 Le type d'�l�ment %(k1)s n'est pas pr�vu.
"""),

15 : _(u"""
 La nature du mat�riau %(k1)s n'est pas trait�e.
 Seules sont consid�r�es les natures : ELAS, ELAS_ISTR, ELAS_ORTH.
"""),

17 : _(u"""
 noeuds confondus pour un �l�ment
"""),

18 : _(u"""
 le nombre de noeuds d'un tuyau est diff�rent de 3 ou 4
"""),

20 : _(u"""
 Aucun type d'�l�ments ne correspond au type demand�.
"""),

21 : _(u"""
 pr�dicteur ELAS hors champs
"""),

24 : _(u"""
 d�riv�es de "MP" non d�finies
"""),

25 : _(u"""
 On passe en m�canisme 2.
"""),

26 : _(u"""
 Chargement en m�canisme 2 trop important.
 � v�rifier.
"""),

27 : _(u"""
 On poursuit en m�canisme 2.
"""),

28 : _(u"""
 d�charge n�gative sans passer par le m�canisme 1
 diminuer le pas de temps
"""),

29 : _(u"""
 on revient en m�canisme 1
"""),

30 : _(u"""
 pas de retour dans le m�canisme 1 trop important
 diminuer le pas de temps
"""),

31 : _(u"""
 type d'�l�ment  %(k1)s  incompatible avec  %(k2)s
"""),

32 : _(u"""
 le comportement %(k1)s est inattendu
"""),

34 : _(u"""
 �l�ment non trait�  %(k1)s
"""),

36 : _(u"""
 nombre de couches n�gatif ou nul :  %(k1)s
"""),

37 : _(u"""
 Sous-programme CHPVER :
 le champ  %(k1)s n'a pas la bonne grandeur :
   grandeur autoris�e  :%(k2)s
   grandeur du champ   :%(k3)s
"""),

40 : _(u"""
  -> L'axe de r�f�rence pour le calcul du rep�re local est normal � un
     au moins un �l�ment de plaque.
  -> Risque & Conseil :
     Il faut modifier l'axe de r�f�rence (axe X par d�faut) en utilisant
     ANGL_REP ou VECTEUR.

"""),

41 : _(u"""
 impossibilit� :
 vous avez un mat�riau de type "ELAS_COQUE" et vous n'avez pas d�fini la raideur de membrane,
 ni sous la forme "MEMB_L", ni sous la forme "M_LLLL".
"""),

42 : _(u"""
 Le comportement mat�riau %(k1)s n'est pas trait�. Conseil : utilisez
 la commande DEFI_COMPOSITE pour d�finir une coque mono couche avec ce
 comportement.
"""),

43 : _(u"""
 impossibilit� :
 vous avez un mat�riau de type "ELAS_COQUE" et le d�terminant de la sous matrice de Hooke relative au cisaillement est nul.
"""),

46 : _(u"""
 nombre de couches n�gatif ou nul
"""),

48 : _(u"""
 impossibilit�, la surface de l'�l�ment est nulle.
"""),

50 : _(u"""
 comportement �lastique inexistant
"""),

52 : _(u"""
  -> Le type de comportement %(k1)s n'est pas pr�vu pour le calcul de
     SIEF_ELGA avec chargement thermique.
"""),

53 : _(u"""
Erreur utilisateur :
  Temp�rature sur la maille: %(k1)s : il manque la composante "TEMP_MIL"
"""),

55 : _(u"""
 ELREFA inconnu:  %(k1)s
"""),

58 : _(u"""
 la nature du mat�riau  %(k1)s  n�cessite la d�finition du coefficient  B_ENDOGE dans DEFI_MATERIAU.
"""),

62 : _(u"""
 GROUP_MA :  %(k1)s  inconnu dans le maillage
"""),

64 : _(u"""
  le LIAISON_*** de  %(k1)s  implique les noeuds physiques  %(k2)s  et  %(k3)s et traverse l'interface
"""),

65 : _(u"""
  le LIAISON_*** de  %(k1)s  implique le noeud physique  %(k2)s et touche l'interface
"""),

66 : _(u"""
 Si vous avez renseign� le mot-cl� NOEUD_ORIG, donnez un groupe de mailles sous GROUP_MA ou une liste de mailles
 sous MAILLE. On ne r�ordonne pas les groupes de noeuds et les listes de noeuds.
"""),

67 : _(u"""
 Le groupe de noeuds %(k1)s n'existe pas.
"""),


68 : _(u"""
 Le noeud origine ou extr�mit� %(k1)s ne fait pas partie des mailles de la ligne.
"""),

69 : _(u"""
 Le noeud origine ou extr�mit�  %(k1)s  n'est pas une extr�mit� de la ligne.
"""),

70 : _(u"""
 Alarme DEFI_GROUP / CREA_GROUP_NO / OPTION='NOEUD_ORDO' :
   Le groupe de mailles sp�cifi� forme une ligne ferm�e (NOEUD_ORIG et NOEUD_EXTR identiques).
   Vous n'avez pas renseign� le mot cl� VECT_ORIE. La ligne est donc orient�e arbitrairement.
"""),

71 : _(u"""
 Erreur utilisateur :
   On cherche � orienter une ligne (un ensemble de segments).
   La recherche du noeud "origine" de la ligne �choue.

 Conseil :
   La ligne est peut-�tre une ligne ferm�e (sans extr�mit�s).
   Il faut alors utiliser les mots cl�s GROUP_NO_ORIG et GROUP_NO_EXTR
   (ou NOEUD_ORIG et NOEUD_EXTR).

"""),

72 : _(u"""
 GROUP_NO orient� : noeud origine =  %(k1)s
"""),

73 : _(u"""
 Le GROUP_MA :  %(k1)s n'existe pas.
"""),




77 : _(u"""
 le noeud extr�mit�  %(k1)s  n'est pas le dernier noeud
"""),





83 : _(u"""
 Le type des mailles des l�vres doit �tre quadrangle ou triangle.
"""),


87 : _(u"""
 Mauvaise d�finition de MP1 et MP2
"""),

88 : _(u"""
 Option %(k1)s n'est pas disponible pour l'�l�ment %(k2)s et la loi de comportement %(k3)s
"""),

90 : _(u"""
Erreur de programmation :
   L'attribut NBSIGM n'est pas d�fini pour cette mod�lisation.
Solution :
   Il faut modifier le catalogue phenomene_modelisation__.cata pour ajouter NBSIGM pour cette mod�lisation.
"""),

}
