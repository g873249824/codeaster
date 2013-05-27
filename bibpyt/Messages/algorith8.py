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
 contraintes planes en grandes d�formations non implant�es
"""),

2 : _(u"""
 caract�ristique fluage incomplet
"""),

12 : _(u"""
 F reste toujours n�gative
"""),

13 : _(u"""
 F  reste toujours positive
"""),

14 : _(u"""
 signe de SIGMA ind�termin�
"""),

15 : _(u"""
 changement de signe de SIGMA
"""),

16 : _(u"""
 F=0 : pas converge
"""),


20 : _(u"""
 La d�finition du rep�re d'orthotropie a �t� mal faite.
 Utilisez soit ANGL_REP  soit ANGL_AXE de la commande AFFE_CARA_ELEM mot cl� facteur MASSIF
"""),

22 : _(u"""
 type d'�l�ment incompatible avec une loi �lastique anisotrope
"""),

24 : _(u"""
 Le chargement de type cisaillement (mot-cl� CISA_2D) ne peut pas �tre suiveur (mot-cl� TYPE_CHAR='SUIV').
"""),

25 : _(u"""
 On ne sait pas traiter un chargement de type pression (mot-cl� PRES_REP) suiveuse (mot-cl� TYPE_CHAR_='SUIV') impos� sur l'axe du mod�le axisym�trique.

 Conseils :
  - V�rifiez que le chargement doit bien �tre suiveur.
  - V�rifiez que la zone d'application du chargement est la bonne.
"""),

28 : _(u"""
 pr�diction par extrapolation impossible : pas de temps nul
"""),

31 : _(u"""
 borne sup�rieure PMAX incorrecte
"""),

32 : _(u"""
 la viscosit� N doit �tre diff�rente de z�ro
"""),

33 : _(u"""
 la viscosit� UN_SUR_K doit �tre diff�rente de z�ro
"""),

35 : _(u"""
 incompatibilit� entre la loi de couplage  %(k1)s  et la mod�lisation choisie  %(k2)s
"""),

36 : _(u"""
 il y a d�j� une loi de couplage
"""),

37 : _(u"""
 il y a d�j� une loi hydraulique
"""),

38 : _(u"""
 il y a d�j� une loi de m�canique
"""),

39 : _(u"""
 il n y a pas de loi de couplage
"""),

40 : _(u"""
 il n y a pas de loi hydraulique
"""),

41 : _(u"""
 il n y a pas de loi de m�canique
"""),

42 : _(u"""
 la loi de couplage est incorrecte pour une mod�lisation %(k1)s
"""),

43 : _(u"""
 incompatibilit� des comportements m�canique et hydraulique
"""),

44 : _(u"""
 loi de m�canique incompatible avec une mod�lisation %(k1)s
"""),

46 : _(u"""
 il y a une loi de m�canique dans la relation %(k1)s
"""),

59 : _(u"""
 la loi de couplage doit �tre LIQU_SATU ou GAZ pour une mod�lisation H
"""),

61 : _(u"""
 Il manque le s�chage de r�f�rence (AFFE_MATERIAU/AFFE_VARC/VALE_REF)
"""),

65 : _(u"""
Arr�t suite � l'�chec de l'int�gration de la loi de comportement.
   V�rifiez vos param�tres, la coh�rence des unit�s.
   Essayez d'augmenter ITER_INTE_MAXI.
"""),

66 : _(u"""
  convergence atteinte sur approximation lin�aire tangente de l'�volution plastique
  risque d'impr�cision
"""),

67 : _(u"""
  endommagement maximal atteint au cours des r�solutions internes
"""),

77 : _(u"""
 le nombre de composantes dans le champ de vent est incorrect. on doit avoir : DX, DY, DZ
"""),

80 : _(u"""
Pour le comportement %(k3)s, mat�riau %(k4)s. Incoh�rence dans les donn�es mat�riau.
   %(k1)s est >= %(k2)s cela n'est pas possible.
   valeur de %(k1)s : %(r1)E
   valeur de %(k2)s : %(r2)E
"""),

81 : _(u"""
L'association comportement vs mat�riau est incorrecte.
Les combinaisons possibles sont :
   comportement %(k1)s et mat�riau %(k2)s et %(k5)s
   comportement %(k3)s et mat�riau %(k4)s et %(k5)s
"""),


86 : _(u"""
 porosit� strictement nulle( cas non trait�)
"""),

87 : _(u"""
 l'incr�ment de temps vaut z�ro, v�rifiez votre d�coupage
"""),

88 : _(u"""
 fluence d�croissante (flux<0)
"""),

89 : _(u"""
 le param�tre A doit �tre >=0
"""),

90 : _(u"""
 la loi LMARC_IRRA n'est compatible qu'avec une mod�lisation poutre
"""),

91 : _(u"""
 stop, RIGI_MECA_TANG non disponible
"""),

92 : _(u"""
 la maille doit �tre de type TETRA10,PENTA15,HEXA20,QUAD8 ou TRIA6.
 or la maille est de type :  %(k1)s .
"""),

94 : _(u"""
 le champ issu du concept %(k1)s n'est pas calcul� � l'instant %(i3)i
"""),

96 : _(u"""
 le s�chage ne peut pas �tre m�lang� � un autre comportement
"""),

97 : _(u"""
 EVOL_THER_SECH est un mot-cl� obligatoire pour le s�chage de type SECH_GRANGER et SECH_NAPPE
"""),

98 : _(u"""
  le concept :  %(k1)s  n'est pas un champ de temp�rature
"""),

99 : _(u"""
  le concept EVOL_THER :  %(k1)s  ne contient aucun champ de temp�rature
"""),

}
