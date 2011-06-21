#@ MODIF context Noyau  DATE 21/06/2011   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
# RESPONSABLE COURTOIS M.COURTOIS
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

_root=None
_cata=None
debug=0

# L'usage a certainement d�vi� : le current step est plut�t le parent courant
# que l'�tape courante. Pour cela, l'ex�cution des �tapes (ou macro-�tape)
# devrait appel�e les m�thodes set/get_current_step des �tapes...

def set_current_step(step):
   """
      Fonction qui permet de changer la valeur de l'�tape courante
   """
   global _root
   if _root : raise "Impossible d'affecter _root. Il devrait valoir None"
   _root=step

def get_current_step():
   """
      Fonction qui permet d'obtenir la valeur de l'�tape courante
   """
   return _root

def unset_current_step():
   """
      Fonction qui permet de remettre � None l'�tape courante
   """
   global _root
   _root=None

def set_current_cata(cata):
   """
      Fonction qui permet de changer l'objet catalogue courant
   """
   global _cata
   if _cata : raise "Impossible d'affecter _cata. Il devrait valoir None"
   _cata=cata

def get_current_cata():
   """
      Fonction qui retourne l'objet catalogue courant
   """
   return _cata

def unset_current_cata():
   """
      Fonction qui permet de remettre � None le catalogue courant
   """
   global _cata
   _cata=None

