#@ MODIF utilitai6 Messages  DATE 07/04/2009   AUTEUR COURTOIS M.COURTOIS 
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

def _(x) : return x

cata_msg = {

1 : _("""
 La grandeur fournie : %(k1)s ne figure pas dans le catalogue des grandeurs
"""),

2 : _("""
 Erreur utilisateur (CREA_CHAMP/AFFE) :
   Le type du champ que l'on cherche � cr�er (r�el, entier, complexe, fonction)
   n'est pas compatible avec le mot cl� utilis� (VALE, VALE_I, VALE_C, VALE_F).

 Il faut respecter la correspondance suivante :
    - champ r�el        -> VALE
    - champ complexe    -> VALE_C
    - champ entier      -> VALE_I
    - champ fonction    -> VALE_F
"""),

3 : _("""
 la liste de composantes et la liste des valeurs n'ont pas la m�me dimension
 occurence de AFFE num�ro  %(i1)d
"""),

4 : _("""
 une composante n'appartient pas � la grandeur
 occurence de AFFE num�ro  %(i1)d
 grandeur   :  %(k1)s
 composante :  %(k2)s
"""),

5 : _("""
 le NUME_DDL en entr�e ne s'appuie pas sur la m�me grandeur que celle de la commande
 grandeur associee au NUME_DDL : %(k1)s
 grandeur de la commande       :  %(k2)s
"""),

11 : _("""
 une composante n'appartient pas � la grandeur
 grandeur   :  %(k1)s
 composante :  %(k2)s
"""),

12 : _("""
 variable inconnue:  %(k1)s  pour le r�sultat :  %(k2)s
"""),

13 : _("""
 probl�me rencontr� lors de la recherche de la variable :  %(k1)s
         debut :  %(k2)s
           fin :  %(k3)s
"""),

14 : _("""
 interpolation non permise
 valeur � interpoler : %(r1)f
 borne inferieure    : %(r2)f
 borne superieure    : %(r3)f
"""),

15 : _("""
 il faut donner :
    - une MAILLE ou un GROUP_MA
    - un NOEUD ou un GROUP_NO ou un point
"""),

16 : _("""
 interpolation impossible
 instant � interpoler:  %(r1)f
"""),

17 : _("""
 interpolation impossible
 instant � interpoler:  %(r1)f
 borne inf�rieure    :  %(r2)f
"""),

18 : _("""
 interpolation impossible
 instant � interpoler:  %(r1)f
 borne sup�rieure    : %(r2)f
"""),

19 : _("""
 CHAM_NO inexistant pour l'acc�s %(k1)s sur le r�sultat %(k2)s
 pour le NUME_ORDRE %(i1)d
 instant � interpoler %(r1)f
"""),

25 : _("""
 CHAM_ELEM inexistant pour l'acc�s %(k1)s sur le r�sultat %(k2)s
 pour le NUME_ORDRE %(i1)d
 instant � interpoler %(r1)f
"""),

37 : _("""
 la fonction  %(k1)s  a  %(i1)d arguments
 le maximum exploitable est  %(i2)d
"""),

38 : _("""
 il y a  %(i1)d param�tre(s) identique(s) dans la d�finition de la nappe
"""),

39 : _("""
 erreur dans les donn�es
 interface de type :  %(k1)s  non valable
"""),

40 : _("""
 erreur dans les donn�es
 on ne retrouve pas le noeud  %(k1)s dans la numerotation
"""),

41 : _("""
 erreur dans les donn�es
 le noeud :  %(k1)s n'appartient pas au maillage  %(k2)s
"""),

44 : _("""
 trop d'amortissements modaux
 nombre d'amortissements :  %(i1)d
 nombre de modes         :  %(i2)d
"""),

47 : _("""
 erreur dans la recherche du noeud
 nom du noeud    :  %(k1)s
 nom du maillage :  %(k2)s
"""),

48 : _("""
 methode de newton
 exposant de la loi   = %(r1)f
 nombre d''iterations = %(i1)d
 residu fonction = %(r2)f
 residu f/df = %(r3)f
 precision = %(r4)f
"""),

51 : _("""
 pas de champ correspondant � l'instant demand�.
 resultat  %(k1)s
 acc�s "INST_INIT" : %(r1)f
"""),

52 : _("""
 plusieurs champs correspondant � l'instant demand�
 resultat  %(k1)s
 acces "INST_INIT" : %(r1)f
 nombre : %(i1)d
"""),

53 : _("""
 le premier instant de rupture n'est pas dans la liste des instants de calcul
 premier instant de rupture =  %(r1)f
 premier instant de calcul  =  %(r2)f
"""),

54 : _("""
 le dernier instant de rupture n'est pas dans la liste des instants de calcul
 dernier instant de rupture =  %(r1)f
 dernier instant de calcul  =  %(r2)f
"""),

55 : _("""
 parametres initiaux de weibull
 exposant de la loi      = %(r1)f
 volume de reference     = %(r2)f
 contrainte de reference = %(r3)f
"""),

56 : _("""
 statistiques recalage :
 nombre d'iterations  = %(i1)d
 convergence atteinte = %(r1)f
"""),

57 : _("""
 les abscisses %(k1)s %(k2)s ne sont pas monotones.
"""),

58 : _("""
 les abscisses %(k1)s %(k2)s ont �t� r�ordonn�es.
"""),

59 : _("""
 l'ordre des abscisses %(k1)s %(k2)s a �t� invers�.
"""),

60 : _("""
 homog�n�it� du champ de mat�riaux pour weibull
 nombre de rc weibull trouvees =  %(i1)d
 les calculs sont valables pour  un seul comportement weibull %(k1)s
 on choisit la premiere relation du type weibull %(k2)s
"""),

61 : _("""
 param�tres de la rc weibull_fo
 exposant de la loi      = %(r1)f
 volume de reference     = %(r2)f
 contrainte de r�f�rence conventionnelle = %(r3)f
"""),

62 : _("""
 parametres de la rc weibull
 exposant de la loi      = %(r1)f
 volume de reference     = %(r2)f
 contrainte de reference = %(r3)f
"""),

68 : _("""
 type de num�rotation non connue
 num�rotation: %(k1)s
"""),

72 : _("""
 trop de mailles dans le GROUP_MA
 maille utilis�e:  %(k1)s
"""),

77 : _("""
Concept r�sultat %(k1)s :
le num�ro d'ordre %(i1)d est inconnu.
"""),

78 : _("""
Concept r�sultat %(k1)s :
le num�ro d'archivage %(i1)d est sup�rieur au max %(i2)d.
"""),

79 : _("""
Concept r�sultat %(k1)s :
le num�ro de rangement %(i1)d est sup�rieur au max %(i2)d.
"""),

80 : _("""
Concept r�sultat %(k1)s :
la variable %(k2)s est inconnue pour le type %(k3)s.
"""),

82 : _("""
 pas de champ trouv� pour la fr�quence  %(r1)f
"""),

83 : _("""
 plusieurs champs trouv�s pour la fr�quence  %(r1)f
 nombre de champs trouv�s  : %(i1)d
"""),

84 : _("""
 le "NOM_PARA_RESU"  %(k1)s n'est pas un param�tre du r�sultat  %(k2)s
"""),

89 : _("""
 erreur dans les donn�es
 le param�tre  %(k1)s n'existe pas
"""),

90 : _("""
 erreur dans les donn�es
 le param�tre %(k1)s n'est pas trouv�
"""),

93 : _("""
 le param�tre  %(k1)s n'existe pas dans la table %(k2)s
 il est n�cessaire
 veuillez consulter la documentation de la commande
"""),

99 : _("""
 erreur dans les donn�es
 param�tre :  %(k1)s
 plusieurs valeurs trouvees
 pour le param�tre : %(k3)s
 et le param�tre   : %(k4)s
"""),

}
