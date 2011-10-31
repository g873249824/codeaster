#@ MODIF modelisa8 Messages  DATE 31/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

1 : _(u"""
 la section de la poutre est nulle
"""),

2 : _(u"""
 l'inertie de la poutre suivant OY est nulle
"""),

3 : _(u"""
 l'inertie de la poutre suivant OZ est nulle
"""),

4 : _(u"""
 La somme des aires des fibres est diff�rente de l'aire de la section de la poutre.

 L'erreur relative est superieure a la pr�cision d�finie par le mot cle PREC_AIRE :

   - occurrence de multifibre : %(r1).0f

   - aire de la poutre       : %(r2)12.5E

   - aire des fibres         : %(r3)12.5E

   - erreur relative         : %(r4)12.5E
"""),

5 : _(u"""
 La somme des moments d'inertie des fibres par rapport a l'axe 0Y est diff�rente du moment de la poutre.

 L'erreur relative est superieure a la pr�cision d�finie par le mot cle PREC_INERTIE :

   - occurrence de multifibre       : %(r1).0f

   - moment d'inertie de la poutre : %(r2)12.5E

   - aire d'inertie des fibres     : %(r3)12.5E

   - erreur relative               : %(r4)12.5E
"""),

6 : _(u"""
 La somme des moments d'inertie des fibres par rapport a l'axe 0Z est diff�rente du moment de la poutre.

 L'erreur relative est superieure a la pr�cision d�finie par le mot cle PREC_INERTIE :

   - occurrence de multifibre       : %(r1).0f

   - moment d'inertie de la poutre : %(r2)12.5E

   - aire d'inertie des fibres     : %(r3)12.5E

   - erreur relative               : %(r4)12.5E
"""),

7 : _(u"""
 actuellemnt on ne peut mettre que %(k1)s groupes de fibres sur un �l�ment
"""),

8 : _(u"""
 Le groupe de fibre %(k1)s n'a pas ete d�fini dans DEFI_GEOM_FIBRE
"""),

9 : _(u"""
 mot cle facteur  "defi_arc", occurrence  %(i1)d , group_ma :  %(k1)s
 le centre n'est pas vraiment  le centre du cercle %(k2)s
"""),

10 : _(u"""
 mot cle facteur  "defi_arc", occurrence  %(i1)d , group_ma :  %(k1)s
 le point de tangence n est pas equidistant des points extremites %(k2)s
"""),

11 : _(u"""
 mot cle facteur  "defi_arc", occurrence  %(i1)d , maille :  %(k1)s
 le centre n'est pas vraiment  le centre du cercle %(k2)s
"""),

13 : _(u"""
  , maille :  %(i1)d la maille n'est pas situee  sur le cercle %(k1)s
"""),

14 : _(u"""
  , maille :  %(i1)d
 la maille n'est pas orientee  dans le m�me sens que les autres sur le cercle %(k1)s
"""),

16 : _(u"""
  , maille :  %(i1)d pb produit scalaire %(k1)s
"""),

25 : _(u"""
   l'ensemble des mailles comporte plus de 2 extremites %(k1)s
"""),

26 : _(u"""
 defi_arcl'ensemble des mailles  forme un cercle : a subdiviser  %(k1)s
"""),

27 : _(u"""
 le ddl  %(k1)s est interdit pour le noeud %(k2)s
"""),

28 : _(u"""
 affectation d�j� effectu�e du ddl  %(k1)s du noeud %(k2)s : on applique la r�gle de surcharge
"""),

29 : _(u"""
 nombre de cmps superieur au max nmaxcmp=  %(i1)d ncmp   =  %(i2)d
"""),

30 : _(u"""
 Erreur utilisateur:
    On cherche � imposer une condition aux limites sur le ddl %(k1)s
    du noeud %(k2)s.
    Mais ce noeud ne porte pas ce ddl.

    Conseils :
     - v�rifier le mod�le et les conditions aux limites :
        - le noeud incrimin� fait-il partie du mod�le ?
        - le noeud porte-t-il le ddl que l'on cherche � contraindre ?
"""),

31 : _(u"""
 nombre de mots-cl�s superieur au max nmaxocl=  %(i1)d nmocl  =  %(i2)d
"""),

34 : _(u"""
 erreur dans les donn�esle param�tre  %(k1)s n existe pas dans la table  %(k2)s
"""),

35 : _(u"""
 erreur dans les donn�espas de valeur pour le param�tre  %(k1)s
"""),

36 : _(u"""
 erreur dans les donn�esplusieurs valeurs pour le group_ma  %(k1)s
"""),

40 : _(u"""
 la maille de nom :  %(k1)s n'est pas de type  %(k2)s  ou  %(k3)s
 elle ne sera pas affectee par  %(k4)s
"""),

43 : _(u"""

 le nombre de ddl_1 figurant dans  la liaison n'est pas egal au nombre de coef_mult_1 :
   %(i1)d
   %(i2)d
"""),

44 : _(u"""

 le nombre de ddl_2 figurant dans  la liaison n'est pas egal au nombre de coef_mult_2 :
   %(i1)d
   %(i2)d
"""),

46 : _(u"""

 le nombre de ddls figurant dans  la liaison n'est pas egal au nombre de  coef_mult/coef_mult_fonc :
   %(i1)d
   %(i2)d
"""),

47 : _(u"""

 le nombre de ddls figurant dans  la liaison n'est pas egal au nombre de noeuds :
   %(i1)d
   %(i2)d
"""),

49 : _(u"""

 la direction normale est calculee sur la face esclave. il faut donner des mailles
  de facettes, mots cles :  %(k1)s %(k2)s
"""),

52 : _(u"""
 les noeuds n1 et n2 sont confondus coor(n1): %(r1)f   %(r2)f coor(n2): %(r3)f
   %(r4)f
 norme   : %(r5)f
"""),

53 : _(u"""
 n3 colineaires coor(n1): %(r1)f   %(r2)f   %(r3)f coor(n2): %(r4)f   %(r5)f
   %(r6)f
 coor(n3): %(r7)f
   %(r8)f
   %(r9)f
 norme   : %(r10)f
"""),

55 : _(u"""
Interpolation interdite pour un r�sultat de type :  %(k1)s
Seule l'extraction est possible : OPERATION='EXTR'
"""),

56 : _(u"""
Dans le groupe de mailles %(k1)s, il y a %(i1)d mailles mal orient�es. Utilisez la commande MODI_MAILLAGE pour orienter la normale aux surfaces.
"""),

57 : _(u"""
La maille %(k1)s est mal orient�e. Utilisez la commande MODI_MAILLAGE pour orienter la normale aux surfaces.
"""),


68 : _(u"""
 Certaines mailles constituant le groupe de mailles %(k1)s ne sont pas
 des mailles surfaciques.
 Risques & Conseils :
 Verifiez la constitution des groupes de mailles renseignees sous le
 mot-cle GROUP_MA_ESCL.
"""),

69 : _(u"""
 le code:  %(i1)d   %(k1)s
"""),

70 : _(u"""
 Possible erreur utilisateur dans la commande AFFE_MODELE :
   Un probl�me a �t� d�tect� lors de l'affectation des �l�ments finis.
   Pour l'occurrence AFFE de num�ro %(i1)d, certaines mailles de m�me dimension topologique
   que la (ou les) mod�lisation(s) (ici dimension = %(i3)d) n'ont pas pu �tre affect�es.

   Cela veut dire que la (ou les) mod�lisation(s) que l'on cherche � affecter
   ne supporte(nt) pas tous les types de mailles pr�sents dans le maillage.

   Le nombre de mailles que l'on n'a pas pu affecter (pour cette occurrence de AFFE) est :  %(i2)d

 Risques & conseils :
   * Comme certaines mailles n'ont peut-�tre pas �t� affect�es, il y a un risque
     de r�sultats faux (pr�sence de "trous" dans la mod�lisation).
     Pour connaitre les mailles non affect�es (� la fin de l'op�rateur), on peut utiliser INFO=2.
   * Ce probl�me est fr�quent quand on souhaite une mod�lisation "sous-int�gr�e"
     (par exemple AXIS_SI). Pour l'�viter, il faut donner une mod�lisation de
     "substitution" pour les mailles qui n'existent pas dans la mod�lisation d�sir�e (ici 'AXIS_SI').
     On fera par exemple :
        MO=AFFE_MODELE( MAILLAGE=MA,  INFO=2,
                        AFFE=_F(TOUT='OUI', PHENOMENE='MECANIQUE', MODELISATION=('AXIS','AXIS_SI')))

     Ce qui aura le m�me effet (mais sans provoquer l'alarme) que :
        MO=AFFE_MODELE( MAILLAGE=MA,  INFO=2, AFFE=(
                        _F(TOUT='OUI', PHENOMENE='MECANIQUE', MODELISATION=('AXIS')),
                        _F(TOUT='OUI', PHENOMENE='MECANIQUE', MODELISATION=('AXIS_SI')),
                        ))

"""),

71 : _(u"""
 materiau non valide materiau :  %(k1)s
"""),

72 : _(u"""
 materiaux non valideson ne peut avoir a la fois  %(k1)s  et  %(k2)s
"""),

75 : _(u"""
 erreur donn�esle group_no n'existe pas  %(k1)s
"""),

77 : _(u"""
 Il y a un conflit dans les vis-�-vis des noeuds. Le noeud  %(k1)s est
 � la fois le vis-�-vis du noeud %(k2)s et du noeud %(k3)s.

 Risques & conseils :
   V�rifiez les groupes en vis-�-vis, il se peut que les maillages soient incompatibles.
   Il faut �galement s'assurer que la distance entre les deux maillages soit du m�me
   ordre de grandeur que la longueur caract�ristique du maillage (distance entre deux noeuds).
"""),

79 : _(u"""
 conflit dans les vis-a-vis  generes successivement le noeud  %(k1)s
  a pour vis-a-vis le noeud %(k2)s
  et le noeud %(k3)s
"""),

80 : _(u"""
 conflit dans les vis-a-vis  generes successivement
 le noeud de la premiere liste %(k1)s
  n"est l"image d"aucun  %(k2)s
 noeud par la correspondance inverse %(k3)s
"""),

87 : _(u"""
 conflit dans les vis-a-vis  generes successivement a partir des listes  %(k1)s
 et  %(k2)s
 le noeud  %(k3)s
 a pour vis-a-vis le noeud %(k4)s
  et le noeud %(k5)s
"""),

88 : _(u"""
 conflit dans les vis-a-vis  generes successivement a partir des listes  %(k1)s
 et  %(k2)s
 le noeud de la premiere liste %(k3)s
  n"est l"image d"aucun  %(k4)s
 noeud par la correspondance inverse %(k5)s
"""),

89 : _(u"""
 on ne trouve pas dans la paroi 2 de maille de type :  %(i1)d
"""),

90 : _(u"""
 conflit dans les vis_a_vis les mailles  %(k1)s  et  %(k2)s
  ont toutes les 2 comme vis_a_vis la maille %(k3)s
"""),

93 : _(u"""

 evaluation impossible  d une fonction materiau - on deborde a gauche  pour la temperature
 temp : %(r1)f
"""),

94 : _(u"""

 evaluation impossible  d une fonction materiau - on deborde a droite  pour la temperature
 temp : %(r1)f
"""),

98 : _(u"""
 il manque le param�tre  %(k1)s dans la table %(k2)s
 .sa presence est indispensable a la  creation du champ nodal. %(k3)s
"""),

99 : _(u"""
 le param�tre  %(k1)s ne doit pas apparaitre dans la  table %(k2)s
 pour la creation d'un champ nodal. %(k3)s
"""),

}
