#@ MODIF calculel5 Messages  DATE 10/10/2006   AUTEUR VABHHTS J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
 ! attention numeros d'ordre non contigus !
"""),

2: _("""
 pour les options de thermique, il y a encore a travailler !!
"""),

3: _("""
 !! option indisponible ensensibilite lagrangienne !!
"""),

4: _("""
 !! problemecreation cham_elem nul dans alchml !!
"""),

5: _("""
 nb_ec trop grand
"""),

6: _("""
 cumul impossible avec i
"""),

7: _("""
 cumul impossible avec kn
"""),

8: _("""
 il faut donner "maille"
"""),

9: _("""
 le mot cle "nume_cmp" doit etre supprime en sta 5.5
"""),

10: _("""
 nbnocp trop grand, contacter l'asistance
"""),

11: _("""
 le parametre est a valeurs de type  " %(k1)s "  et la valeur de reference de type  " %(k2)s ".
"""),

12: _("""
 "type_test" inconnu
"""),

13: _("""
 le champ  %(k1)s  est a valeurs de type  " %(k2)s "  et la valeur de reference de type  " %(k3)s ".
"""),

14: _("""
 le champ  %(k1)s  est de type inconnu.
"""),

15: _("""
 ! type d'element  %(k1)s inconnu !
"""),

16: _("""
 ! nbnv: typelem inconnu !
"""),

17: _("""
 ! jac(ipg): div par zero !
"""),

18: _("""
 le group_no  %(k1)s  n'existe pas.
"""),

19: _("""
 le group_ma  %(k1)s  n'existe pas.
"""),

20: _("""
 le group_no  %(k1)s  contient  %(k2)s  noeuds
"""),

21: _("""
 le group_ma  %(k1)s  contient  %(k2)s  mailles
"""),

22: _("""
 ! jac(1): div par zero !
"""),

23: _("""
 ! jac(2): div par zero !
"""),

24: _("""
 ! hf: div par zero !
"""),

25: _("""
 ! calcul naret 2d: typelem inconnu !
"""),

26: _("""
 ! calcul nsomm 2d: typelem inconnu !
"""),

27: _("""
 ! pas de lumpe en 3d p2: hexa20_d --> face8_d !
"""),

28: _("""
 ! pas de lumpe en 3d p2: hexa27 --> face9_d !
"""),

29: _("""
 ! pas de lumpe en 3d p2: penta15_d --> face6/8_d !
"""),

30: _("""
 ! pas de lumpe en 3d p2: tetra10_d --> face6_d !
"""),

31: _("""
 ! calcul naret/nsomm 3d: typelem inconnu !
"""),

32: _("""
 ! l'objet chval des segments est inexistant !
"""),

33: _("""
 ! l'objet chval2 des segments est inexistant !
"""),

34: _("""
 ! p2 obligeatoire avec terme source non nul !
"""),

35: _("""
 la cmp:  %(k1)s  est en double.
"""),

36: _("""
 la cmp:  %(k1)s  n'est pas une cmp de  %(k2)s
"""),

37: _("""
 programme  %(k1)s
"""),

38: _("""
  il faut definir un champ de vitesse
"""),

39: _("""
 la grandeur pour la variable:  %(k1)s  doit etre:  %(k2)s  mais elle est:  %(k3)s
"""),

40: _("""
 nombre de sous-points incoherent avec etat initial
"""),

41: _("""
 pas de variables internes initiales pour la maille  %(k1)s
"""),

42: _("""
 comportements incompatibles :  %(k1)s  et  %(k2)s  pour la maille  %(k3)s
"""),

43: _("""
 erreur pgmeur dans zechlo : type_scalaire: %(k1)s  non autorise(r ou c),
"""),

44: _("""
 ! le champ doit etre un cham_elem !
"""),

45: _("""
 ! longueurs des modes locaux imcompatibles entre eux !
"""),

46: _("""
 ! terme normalisation global nul !
"""),

47: _("""
 le champ doit etre un cham_elem
"""),

48: _("""
 PROJ_CHAMP (ou LAISON_MAIL) :
 Le noeud : %(k1)s      est projet� sur une maille un peu distante (%(k2)s).
    distance � la maille  =   %(r1)g
    diam�tre de la maille =   %(r2)g
"""),

49: _("""
 LIAISON_MAIL :
 La relation lin�aire destin�e � �liminer le noeud esclave %(k1)s est une tautologie
 car la maille maitre en vis � vis de ce noeud poss�de ce meme noeud dans sa connectivit�.
 On ne l'�crit donc pas.
"""),
}
