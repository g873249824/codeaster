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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

1 : _(u"""
 La grandeur fournie : %(k1)s ne figure pas dans le catalogue des grandeurs
"""),

2 : _(u"""
 Erreur utilisateur (CREA_CHAMP/AFFE) :
   Le type du champ que l'on cherche � cr�er (r�el, entier, complexe, fonction)
   n'est pas compatible avec le mot cl� utilis� (VALE, VALE_I, VALE_C, VALE_F).

 Il faut respecter la correspondance suivante :
    - champ r�el        -> VALE
    - champ complexe    -> VALE_C
    - champ entier      -> VALE_I
    - champ fonction    -> VALE_F
"""),

3 : _(u"""
 la liste de composantes et la liste des valeurs n'ont pas la m�me dimension
 occurrence de AFFE num�ro  %(i1)d
"""),

4 : _(u"""
 une composante n'appartient pas � la grandeur
 occurrence de AFFE num�ro  %(i1)d
 grandeur   :  %(k1)s
 composante :  %(k2)s
"""),

5 : _(u"""
 le NUME_DDL en entr�e ne s'appuie pas sur la m�me grandeur que celle de la commande
 grandeur associ�e au NUME_DDL : %(k1)s
 grandeur de la commande       :  %(k2)s
"""),

11 : _(u"""
 une composante n'appartient pas � la grandeur
 grandeur   :  %(k1)s
 composante :  %(k2)s
"""),

12 : _(u"""
 variable inconnue:  %(k1)s  pour le r�sultat :  %(k2)s
"""),

13 : _(u"""
 probl�me rencontr� lors de la recherche de la variable :  %(k1)s
         DEBUT :  %(k2)s
           fin :  %(k3)s
"""),

14 : _(u"""
 interpolation non permise
 valeur � interpoler : %(r1)f
 borne inf�rieure    : %(r2)f
 borne sup�rieure    : %(r3)f
"""),

16 : _(u"""
 interpolation impossible
 instant � interpoler:  %(r1)f
"""),

17 : _(u"""
 interpolation impossible
 instant � interpoler:  %(r1)f
 borne inf�rieure    :  %(r2)f
"""),

18 : _(u"""
 interpolation impossible
 instant � interpoler:  %(r1)f
 borne sup�rieure    : %(r2)f
"""),













37 : _(u"""
 la fonction  %(k1)s  a  %(i1)d arguments
 le maximum exploitable est  %(i2)d
"""),

38 : _(u"""
 il y a  %(i1)d param�tre(s) identique(s) dans la d�finition de la nappe
"""),

44 : _(u"""
 trop d'amortissements modaux
 nombre d'amortissements :  %(i1)d
 nombre de modes         :  %(i2)d
"""),

47 : _(u"""
 erreur dans la recherche du noeud
 nom du noeud    :  %(k1)s
 nom du maillage :  %(k2)s
"""),

48 : _(u"""
 m�thode de Newton
 exposant de la loi  = %(r1)f
 nombre d'it�rations = %(i1)d
 r�sidu fonction = %(r2)f
 r�sidu = %(r3)f
 pr�cision = %(r4)f
"""),

51 : _(u"""
 pas de champ correspondant � l'instant demand�.
 r�sultat  %(k1)s
 acc�s "INST_INIT" : %(r1)f
"""),

52 : _(u"""
 plusieurs champs correspondant � l'instant demand�
 r�sultat  %(k1)s
 acc�s "INST_INIT" : %(r1)f
 nombre : %(i1)d
"""),

53 : _(u"""
 le premier instant de rupture n'est pas dans la liste des instants de calcul
 premier instant de rupture =  %(r1)f
 premier instant de calcul  =  %(r2)f
"""),

54 : _(u"""
 le dernier instant de rupture n'est pas dans la liste des instants de calcul
 dernier instant de rupture =  %(r1)f
 dernier instant de calcul  =  %(r2)f
"""),

55 : _(u"""
 param�tres initiaux de WEIBULL
 exposant de la loi      = %(r1)f
 volume de r�f�rence     = %(r2)f
 contrainte de r�f�rence = %(r3)f
"""),

56 : _(u"""
 statistiques recalage :
 nombre d'it�rations  = %(i1)d
 convergence atteinte = %(r1)f
"""),

60 : _(u"""
 homog�n�it� du champ de mat�riaux pour WEIBULL
 nombre de RC WEIBULL trouv�es =  %(i1)d
 les calculs sont valables pour  un seul comportement WEIBULL %(k1)s
 on choisit la premi�re relation du type WEIBULL %(k2)s
"""),

61 : _(u"""
 param�tres de la RC WEIBULL_FO
 exposant de la loi      = %(r1)f
 volume de r�f�rence     = %(r2)f
 contrainte de r�f�rence conventionnelle = %(r3)f
"""),

62 : _(u"""
 param�tres de la RC WEIBULL
 exposant de la loi      = %(r1)f
 volume de r�f�rence     = %(r2)f
 contrainte de r�f�rence = %(r3)f
"""),




72 : _(u"""
 trop de mailles dans le GROUP_MA
 maille utilis�e:  %(k1)s
"""),

77 : _(u"""
Concept r�sultat %(k1)s :
le num�ro d'ordre %(i1)d est inconnu.
"""),

78 : _(u"""
Concept r�sultat %(k1)s :
le num�ro d'archivage %(i1)d est sup�rieur au max %(i2)d.
"""),

79 : _(u"""
Concept r�sultat %(k1)s :
le num�ro de rangement %(i1)d est sup�rieur au max %(i2)d.
"""),

80 : _(u"""
Concept r�sultat %(k1)s :
la variable %(k2)s est inconnue pour le type %(k3)s.
"""),

84 : _(u"""
 le "NOM_PARA_RESU"  %(k1)s n'est pas un param�tre du r�sultat  %(k2)s
"""),

89 : _(u"""
 erreur dans les donn�es
 le param�tre  %(k1)s n'existe pas
"""),

93 : _(u"""
 le param�tre  %(k1)s n'existe pas dans la table %(k2)s
 il est n�cessaire
 veuillez consulter la documentation de la commande
"""),

99 : _(u"""
 erreur dans les donn�es
 param�tre :  %(k1)s
 plusieurs valeurs trouv�es
 pour le param�tre : %(k3)s
 et le param�tre   : %(k4)s
"""),

}
