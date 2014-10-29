# coding=utf-8
# person_in_charge: mathieu.courtois at edf.fr
# ======================================================================
# COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
#
#
# ======================================================================


"""
"""
# Modules Python
import types
import string
import os
import shutil


def repr_float(valeur):
    """
        Cette fonction représente le réel valeur comme une chaine de caractères
        sous forme mantisse exposant si nécessaire cad si le nombre contient plus de
        5 caractères
        NB : valeur est un réel au format Python ou une chaine de caractères représentant un réel
    """
    if type(valeur) == types.StringType:
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
    if string.find(t, 'e') != -1 or string.find(t, 'E') != -1:
        # le réel est déjà sous forme mantisse exposant !
        # --> on remplace e par E
        t = string.replace(t, 'e', 'E')
        # --> on doit encore vérifier que la mantisse contient bien un '.'
        if string.find(t, '.') != -1:
            return t
        else:
            # -->il faut rajouter le point avant le E
            t = string.replace(t, 'E', '.E')
            return t
    s = ''
    neg = 0
    if t[0] == '-':
        s = s + t[0]
        t = t[1:]
    cpt = 0
    if string.atof(t[0]) == 0.:
        # réel plus petit que 1
        neg = 1
        t = t[2:]
        cpt = 1
        while string.atof(t[0]) == 0.:
            cpt = cpt + 1
            t = t[1:]
        s = s + t[0] + '.'
        for c in t[1:]:
            s = s + c
    else:
        # réel plus grand que 1
        s = s + t[0] + '.'
        if string.atof(t[1:]) == 0.:
            l = string.split(t[1:], '.')
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
                    if r + 1 == len(t) or string.atof(t[r + 1:]) == 0.:
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
