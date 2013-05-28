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
# person_in_charge: mathieu.courtois at edf.fr

"""
   Utilitaires pour la v�rification des SD
"""

# pour utilisation dans eficas
try:
   import aster
except:
   pass

import copy


#  1) Utilitaires pour v�rifier certaines propri�t�s.
#     Ces utilitaires ne provoquent pas d'arret mais �crivent des messages dans un "checker"
#  -----------------------------------------------------------------------------------------

#   1.1 Utilitaires pour des scalaires :
#   ------------------------------------
def sdu_assert(ojb, checker, bool,comment=''):
    """V�rifie que le bool�en (bool) est vrai"""
    if not bool:
        checker.err(ojb, "condition non respect�e :  (%s)" % (comment,))

def sdu_compare(ojb, checker, val1, comp, val2, comment=''):
    """V�rifie que la relation de comparaison entre val1 et val2 est respect�e :
       comp= '==' / '!=' / '>=' / '>' / '<=' / '<'"""
    comp=comp.strip()
    ok = 0
    if comp == "==":
        ok = val1 == val2
        comp1 = "n'est pas �gale au"
    elif comp == "!=":
        ok = val1 != val2
        comp1 = "est �gale au"
    elif comp == ">=":
        ok = val1 >= val2
        comp1 = "est inf�rieure strictement au"
    elif comp == "<=":
        ok = val1 <= val2
        comp1 = "est sup�rieure strictement au"
    elif comp == ">":
        ok = val1 > val2
        comp1 = "est inf�rieure ou �gale au"
    elif comp == "<":
        ok = val1 < val2
        comp1 = "est sup�rieure ou �gale au"
    else:
        sdu_assert(ojb, checker, 0, 'sdu_compare: op�rateur de comparaison interdit: '+comp)

    if not ok:
        checker.err(ojb, "condition non respect�e pour le test suivant : longueur s�quence (%s) %s nombre d'�l�ments diff�rents dans la s�quence (%s) (%s)" % (val1,comp1,val2,comment))


#   1.2 Utilitaires pour des s�quences :
#   ------------------------------------
def sdu_tous_differents(ojb,checker,sequence=None,comment=''):
    """V�rifie que les �l�ments de la s�quence sont tous diff�rents.
    Si l'argument sequence est None, on prend l'ensemble de l'ojb."""
    if sequence:
        seq=sequence
    else:
        seq=ojb.get()
    sdu_compare(ojb, checker, len(seq), '==', len(set(seq)), comment='Tous les �l�ments de la s�quence devraient �tre diff�rents, mais ils ne le sont pas'+comment)

def sdu_tous_non_blancs(ojb,checker,sequence=None,comment=''):
    """V�rifie que les �l�ments (chaines) de la s�quence sont tous "non blancs".
    Si l'argument sequence est None, on prend l'ensemble de l'ojb."""
    if sequence:
        seq=sequence
    else:
        seq=ojb.get()
    for elem in seq:
        assert len(elem.strip()) > 0 , (seq,self, 'tous "non blancs" '+comment)

def sdu_tous_compris(ojb,checker,sequence=None,vmin=None,vmax=None,comment=''):
    """V�rifie que toutes les valeurs de la sequence sont comprises entre vmin et vmax
    Les bornes vmin et vmax sont autoris�es
    Si l'argument sequence est None, on prend l'ensemble de l'ojb."""
    assert (not vmin is None) or (not vmax is None),'Il faut fournir au moins une des valeurs vmin ou vmax'
    if sequence:
        seq=sequence
    else:
        seq=ojb.get()
    ier = 0
    for v in seq:
        if vmin and v < vmin:
            ier = 1
        if vmax and v > vmax:
            ier = 1
    if ier == 1:
        checker.err( ojb, "L'objet doit contenir des valeurs dans l'intervalle : [%s, %s] "  % (vmin,vmax))

def sdu_monotone(seqini):
    """v�rifie qu'une s�quence est tri�e par ordre croissant (ou d�croissant)
    retourne :
       3 : ni croissant ni d�croissant  (d�sordre)
       1 : croissant
      -1 : d�croissant
       0 : constant"""
    import numpy
    if len(seqini) < 2:
        return 0
    tv = numpy.array(seqini)
    diff = tv[1:] - tv[:-1]
    croiss = min(diff) >= 0
    decroiss = max(diff) <= 0
    if croiss and decroiss:
        return 0
    elif croiss and not decroiss:
        return 1
    elif not croiss and decroiss:
        return -1
    else:
        return 3


#  2) Utilitaires de questionnement :
#  -----------------------------------------------------------------------------------------

def sdu_verif_nom_gd(nomgd):
    """v�rifie que nomgd est bien un nom de grandeur"""
    nomgd2=nomgd.strip()
    ptn=aster.getvectjev('&CATA.GD.NOMGD')
    ok=False
    for x in ptn :
       if x.strip()==nomgd2 :
          ok=True
          break
    if not ok:
        checker.err(ojb, "condition non respect�e : "+nomgd+" n'est pas un nom de grandeur.")

def sdu_nom_gd(numgd):
    """retourne le nom de la grandeur de num�ro (numgd)"""
    assert numgd > 0 and numgd <1000 , numgd
    ptn=aster.getvectjev('&CATA.GD.NOMGD')
    return ptn[numgd-1].strip()

def sdu_licmp_gd(numgd):
    """retourne la liste des cmps de la grandeur de num�ro (numgd)"""
    nomgd=sdu_nom_gd(numgd)
    nocmp=aster.getcolljev('&CATA.GD.NOMCMP')
    return nocmp[nomgd.ljust(24)]

def sdu_nb_ec(numgd):
    """retourne le nombre d'entiers cod�s pour d�crire les composantes de la grandeur (numgd)"""
    assert numgd > 0 and numgd <1000 , numgd
    descrigd=aster.getcolljev('&CATA.GD.DESCRIGD')
    return descrigd[numgd-1][-1+3]


#  3) Utilitaires pour la v�rification de l'existence des objets :
#  -----------------------------------------------------------------------------------------

def sdu_ensemble(lojb):
    """v�rifie que les objets JEVEUX de lojb existent simultan�ment :"""
    assert len(lojb) > 1 , lojb
    lexi=[]
    for obj1 in lojb:
        lexi.append(obj1.exists)
    for x in lexi[1:]:
        assert x==lexi[0] , (lojb,lexi)
