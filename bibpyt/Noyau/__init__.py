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
#
#
# ======================================================================


"""
    Ce package fournit les classes de base d'EFICAS.
    Ces classes permettent d'effectuer quelques op�rations basiques :

      - la cr�ation

      - la v�rification des d�finitions

      - la cr�ation d'objets de type OBJECT � partir d'une d�finition de type ENTITE
"""
# Avant toutes choses, on met le module context dans le global de l'interpreteur (__builtin__)
# sous le nom CONTEXT afin d'avoir acc�s aux fonctions
# get_current_step, set_current_step et unset_current_step de n'importe o�
import context
import __builtin__
__builtin__.CONTEXT=context

def _(msg):
    """Differs translation."""
    # 'codex' should install its translation functions later
    return msg
__builtin__._ = _

# Classes de base
from N_SIMP import SIMP
from N_FACT import FACT

# structures de donn�es
import asojb
from asojb import AsBase
