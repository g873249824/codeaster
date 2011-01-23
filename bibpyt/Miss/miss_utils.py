#@ MODIF miss_utils Miss  DATE 25/01/2011   AUTEUR COURTOIS M.COURTOIS 
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
# RESPONSABLE COURTOIS M.COURTOIS

"""Module d'utilitaires pour la gestion des calculs Miss3D.

Les objets/fonctions d�finis sont :
    dict_format     : formats d'impression des r�els et des entiers
    _print          : fonction d'impression
    MISS_PARAMETERS : rassemble les param�tres pour un calcul
    lire_nb_valeurs : lit des valeurs dans un fichier texte
    en_ligne        : formatte des valeurs en colonnes
"""

import os
import re
import pprint

import aster
from Utilitai.Utmess import ASSERT


dict_format = {
    'R'  : "15.6E",
    'sR' : "%15.6E",
    'I'  : "6d",
    'sI' : "%6d",
}

DEBUG = False
def set_debug(value):
    """Positionne la variable de d�boggage"""
    global DEBUG
    DEBUG = value


def _print(*args):
    l_str = []
    for arg in args:
        if type(arg) not in (str, unicode):
            arg = repr(arg)
        l_str.append(arg)
    text = " ".join(l_str)
    aster.affiche('MESSAGE', text)


class MISS_PARAMETER(object):
    """Stocke les param�tres n�cessaires au calcul � partir des mots-cl�s.
    """
    def __init__(self, initial_dir, **kwargs):
        """Enregistrement des valeurs des mots-cl�s."""
        self._defaults = {
            'REPERTOIRE' : None,
            'PROJET'     : 'MODEL',
            '_INIDIR'    : initial_dir,
            '_WRKDIR'    : os.path.join(initial_dir, 'tmp_miss3d'),
        }
        self._keywords = {}
        # une seule occurence du mcfact
        mcfact = kwargs.get('PARAMETRE', [None,])[0]
        if mcfact is not None:
            self._keywords.update( mcfact.cree_dict_valeurs(mcfact.mc_liste) )
        # mcsimp
        mcsimp = ('TABLE_SOL', 'PROJET', 'REPERTOIRE', 'VERSION', 'INFO',
                  'UNITE_IMPR_ASTER', 'UNITE_RESU_IMPE', 'UNITE_RESU_FORC')
        aux = ('_INIDIR', '_WRKDIR',)
        for key in mcsimp + aux:
            self._keywords[key] = kwargs.get(key) or self._defaults[key]
        # v�rification des r�gles impossible � �crire dans le .capy
        ASSERT(self['LFREQ_NB'] is None or len(self['LFREQ_LISTE']) == self['LFREQ_NB'])


    def __getitem__(self, key):
        return self._keywords[key]


    def get(self, key):
        return self._keywords.get(key)


    def __repr__(self):
        return pprint.pformat(self._keywords)



def lire_nb_valeurs(file_object, nb, extend_to, conversion,
                    nb_bloc=1, nb_ignore=0, max_per_line=-1,
                    regexp_label=None):
    """Lit nb valeurs dans file_object et les ajoute � extend_to
    apr�s les avoir converties en utilisant la fonction conversion.
    Ignore nb_ignore lignes pour chacun des nb_bloc lus et lit au
    maximum max_per_line valeurs par ligne.
    Retourne le nombre de lignes lues."""
    if max_per_line < 0:
        max_per_line = nb
    ln = 0
    _printDBG("LIRE_NB_VALEURS nb=", nb, ", nb_bloc=", nb_bloc, ", nb_ignore=", nb_ignore)
    for i in range(nb_bloc):
        val = []
        j = 0
        label = []
        while j < nb_ignore:
            ln += 1
            line = file_object.readline()
            if line.strip() == '':
                continue
            j += 1
            label.append(line)
        if nb_ignore:
            _printDBG("IGNORE", label)
            slabel = ''.join(label)
            if regexp_label:
                mat = re.search(regexp_label, slabel, re.M)
                if mat is None:
                    _printDBG("LABEL", regexp_label, "non trouve, recule de",
                              nb_ignore, "lignes.", i, "bloc(s) lu(s).")
                    curpos = file_object.tell()
                    file_object.seek(curpos - len(slabel))
                    return 0
        while len(val) < nb:
            ln += 1
            line = file_object.readline()
            if line.strip() == '':
                continue
            add = [conversion(v) for v in line.split()[:max_per_line]]
            val.extend(add)
        assert len(val) == nb, "%d valeurs attendues, %d valeurs lues" % (nb, len(val))
        extend_to.extend(val)
        _printDBG("BLOC", i, ",", nb, "valeurs lues, debut :", repr(val[:3]))
    return ln


def en_ligne(valeurs, format, cols, separateur=" ", format_ligne="%(valeurs)s"):
    """Formatte valeurs en cols colonnes en utilisant le format.
    """
    res = []
    ind = -1
    while len(valeurs) > 0:
        lv = []
        for i in range(cols):
            if len(valeurs) == 0:
                break
            lv.append(format % valeurs.pop(0))
        ind += 1
        line = format_ligne % {
            "valeurs" : separateur.join(lv),
            "index"   : ind,
            "index_1" : ind + 1,
        }
        res.append(line)
    return res


def convert_double(fich1, fich2):
    """Convertit les 1.D+09 en 1.E+09.
    """
    txt = open(fich1, "r").read()
    # see python doc (module re)
    expr = re.compile("([\-\+]?\d+(\.\d*)?|\.\d+)([eEdD])([\-\+]?\d+)?")
    new = expr.sub("\\1E\\4", txt)
    open(fich2, "w").write(new)


def double(string):
    """Convertit la chaine en r�elle (accepte le D comme exposant).
    """
    return float(string.replace("D", "e"))


def _printDBG(*args):
    """Print debug informations."""
    if not DEBUG:
        return
    _print(*args)

