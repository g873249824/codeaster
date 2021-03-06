# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: mathieu.courtois at edf.fr


"""
"""
# Modules Python
import os
import shutil


def repr_float(valeur):
    """
        Cette fonction représente le réel valeur comme une chaine de caractères
        sous forme mantisse exposant si nécessaire cad si le nombre contient plus de
        5 caractères
        NB : valeur est un réel au format Python ou une chaine de caractères représentant un réel
    """
    if type(valeur) == bytes:
        valeur = eval(valeur)
    if valeur == 0.:
        return '0.0'
    if abs(valeur) > 1.:
        if abs(valeur) < 10000.:
            return repr(valeur)
    else:
        if abs(valeur) > 0.01:
            return repr(valeur)
    t = repr(valeur)
    if t == 'nan':
        return t
    if t.find('e') != -1 or t.find('E') != -1:
        # le réel est déjà sous forme mantisse exposant !
        # --> on remplace e par E
        t = t.replace('e', 'E')
        # --> on doit encore vérifier que la mantisse contient bien un '.'
        if t.find('.') != -1:
            return t
        else:
            # -->il faut rajouter le point avant le E
            t = t.replace('E', '.E')
            return t
    s = ''
    neg = 0
    if t[0] == '-':
        s = s + t[0]
        t = t[1:]
    cpt = 0
    if float(t[0]) == 0.:
        # réel plus petit que 1
        neg = 1
        t = t[2:]
        cpt = 1
        while float(t[0]) == 0.:
            cpt = cpt + 1
            t = t[1:]
        s = s + t[0] + '.'
        for c in t[1:]:
            s = s + c
    else:
        # réel plus grand que 1
        s = s + t[0] + '.'
        if float(t[1:]) == 0.:
            l = t[1:].split('.')
            cpt = len(l[0])
        else:
            r = 0
            pt = 0
            for c in t[1:]:
                r = r + 1
                if c != '.':
                    if pt != 1:
                        cpt = cpt + 1
                    s = s + c
                else:
                    pt = 1
                    if r + 1 == len(t) or float(t[r + 1:]) == 0.:
                        break
    s = s + 'E' + neg * '-' + repr(cpt)
    return s


def lierRepertoire(source, destination, exeptions=[]):
    """
    Cette fonction sert à recopier (sous forme de liens symboliques)
    un répertoire
    """
    if os.path.exists(destination):
        try:
            shutil.rmtree(destination)
        except OSError:
            os.remove(destination)

    os.mkdir(destination)

    listeFichiers = os.listdir(source)
    for fichier in listeFichiers:
        aEviter = False
        for fichierAEviter in exeptions:
            if fichier[:len(fichierAEviter)] == fichierAEviter:
                aEviter = True
        if aEviter:
            continue
        os.symlink(source + "/" + fichier, destination + "/" + fichier)


def copierBase(source, destination):
    """
    Fonction servant à recopier une base vers un repertoire
    """
    if os.path.exists(destination + "/glob.1"):
        os.remove(destination + "/glob.1")
        shutil.copy(source + "/glob.1", destination)

    if os.path.exists("pick.1"):
        os.remove("pick.1")
        shutil.copy(source + "/pick.1", destination)


def supprimerRepertoire(path):
    shutil.rmtree(path)
