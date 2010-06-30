#@ MODIF indicateur Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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
Le choix TOUT = 'OUI' est obligatoire avec l'option %(k1)s.
On ne peut pas faire de calcul de champ d'indicateur d'erreur sur des mailles
ou des groupes de mailles car on doit connaitre tous les voisins.
"""),

2 : _("""
Le champ de contraintes n'a pas �t� calcul� sur tout le mod�le.
On ne peut pas calculer l'option %(k1)s pour le num�ro d'ordre %(k2)s.
"""),

3: _("""
On ne peut pas calculer un indicateur d'erreur spatial � l'instant initial.
Revoyez votre liste d'instants de calcul.
Conseil : Faites-la d�marrer au premier instant suivant l'instant initial.
"""),

4: _("""
Attention : on n'a pas pu r�cup�rer le parametre theta dans le resultat %(k1)s.
La valeur prise par d�faut pour theta est 0.57
"""),

5: _("""
Attention : r�cup�ration d'une valeur de theta illicite dans le resultat %(k1)s.
theta doit �tre compris entre 0 et 1.
"""),

6 : _("""
Le calcul de l'indicateur d erreur ne sait pas traiter les charges du type de %(k1)s.
"""),

7 : _("""
Le choix %(k1)s apparait au moins dans 2 charges.
"""),

8 : _("""
Probleme sur les charges. Consulter la documentation
"""),

9 : _("""
 La maille %(k1)s semble �tre est trop distordue.
 On ne calcule pas l'option %(k2)s sur cette maille.

 Risques & conseils :
   Il faut v�rifier votre maillage !
   V�rifiez les messages �mis par la commande AFFE_MODELE.
"""),

10 : _("""
 Erreur de programmation :
 Le type de maille %(k1)s n'est pas pr�vu ou est inconnu.
"""),

11 : _("""
Impossible de r�cup�rer les param�tres temporels.
"""),

20 : _("""
perm_in: division par z�ro
"""),

21 : _("""
La %(k1)s caract�ristique est nulle. On risque la division par z�ro.
"""),

22: _("""
rho liquide: div par zero
"""),

23: _("""
Vous n'utilisez pas une mod�lisation hm satur�e �lastique.
"""),

24 : _("""
 le r�sultat  %(k1)s  doit comporter un champ d'indicateurs d'erreur au num�ro
 d'ordre%(k2)s  .
"""),


25: _("""
Il faut renseigner le mot-clef comp_incr avec elas et liqu_satu pour calculer l'
indicateur d'erreur temporelle.
"""),

28 : _("""
Pour le calcul de l'indicateur d'erreur en HM, il faut fournir
les longueur et pression caract�ristiques.
Ces valeurs doivent etre strictement positives.

-> Conseil :
     N'oubliez pas de renseigner les valeurs sous le mot-clef GRANDEUR_CARA dans AFFE_MODELE.
"""),

31: _("""
deltat: division par z�ro
"""),

32 : _("""
 Dans le programme %(k1)s, impossible de trouver le diam�tre
 pour un �l�ment de type %(k2)s
"""),

33 : _("""
 Le diam�tre de l'�l�ment de type %(k1)s vaut : %(r1)f
"""),

90 : _("""
La condition %(k1)s est bizarre.
"""),

91 : _("""
On ne sait pas traiter la condition %(k1)s.
"""),

92 : _("""
L'option %(k1)s est calculable en dimension 2 uniquement.
"""),

98 : _("""
L'option %(k1)s est invalide.
"""),

99 : _("""
Erreur de programmation dans %(k1)s
L'option %(k2)s ne correspond pas � une option de calcul d'indicateur d'erreur.
"""),

}
