#@ MODIF N_utils Noyau  DATE 13/02/2007   AUTEUR PELLET J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
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
   Ce module contient des fonctions utilitaires
"""

# Modules Python
import sys

# Modules EFICAS
from N_Exception import AsException
from N_ASSD      import ASSD

SEP='_'

try:
   # Si la version de Python poss�de la fonction _getframe
   # on l'utilise.
   cur_frame=sys._getframe
except:
   # Sinon on l'�mule
   def cur_frame(offset=0):
     """ Retourne la frame d execution effective eventuellement en remontant
         de offset niveaux dans la pile d execution
         Si il y a moins de offset niveaux retourne None
     """
     try:1/0
     except:
       frame=sys.exc_info()[2].tb_frame.f_back
     while offset > 0:
       if frame == None:return None
       frame=frame.f_back
       offset=offset-1
     return frame


def callee_where(niveau=4):
   """ 
      recupere la position de l appel 
   """
   frame=cur_frame(niveau)
   if frame == None: return 0,"inconnu",0,{}
   try:
     return frame.f_lineno,frame.f_code.co_filename,frame.f_code.co_firstlineno,frame.f_locals
   except:
     return 0,"inconnu",0,{}

def AsType(a):
   """
      Retourne le type d'un concept (a) � partir
      des caract�ristiques de l'objet Python
   """
   if type(a) in (tuple, list):return AsType(a[0])
   if isinstance(a, ASSD):return type(a)
   if type(a) == float:return "R"
   if type(a) == int:return "I"
   if type(a) == str:return "TXM"
   if a == None : return None
   print 'a=',a,type(a)
   raise AsException("type inconnu")

def prbanner(s):
   print "*"*(len(s)+10)
   print "*"*5 + s + "*"*5
   print "*"*(len(s)+10)

def repr_float(valeur):
  """ 
      Cette fonction repr�sente le r�el valeur comme une chaine de caract�res
      sous forme mantisse exposant si n�cessaire cad si le nombre contient plus de
      5 caract�res
      NB : valeur est un r�el au format Python ou une chaine de caract�res repr�sentant un r�el
  """
  if type(valeur) == str : valeur = eval(valeur)
  if valeur == 0. : return '0.0'
  if abs(valeur) > 1. :
    if abs(valeur) < 10000. : return repr(valeur)
  else :
    if abs(valeur) > 0.01 : return repr(valeur)
  t=repr(valeur)
  if t.find('e') != -1 or t.find('E') != -1 :
    # le r�el est d�j� sous forme mantisse exposant !
    # --> on remplace e par E
    t=t.replace('e','E')
    # --> on doit encore v�rifier que la mantisse contient bien un '.'
    if t.find('.')!= -1:
      return t
    else:
      # -->il faut rajouter le point avant le E
      t=t.replace('E','.E')
      return t
  s=''
  neg = 0
  if t[0]=='-':
    s=s+t[0]
    t=t[1:]
  cpt = 0
  if t[0].atof() == 0.:
    # r�el plus petit que 1
    neg = 1
    t=t[2:]
    cpt=1
    while t[0].atof() == 0. :
      cpt = cpt+1
      t=t[1:]
    s=s+t[0]+'.'
    for c in t[1:]:
      s=s+c
  else:
    # r�el plus grand que 1
    s=s+t[0]+'.'
    if t[1:].atof() == 0.:
      l=t[1:].split('.')
      cpt = len(l[0])
    else:
      r=0
      pt=0
      for c in t[1:]:
        r=r+1
        if c != '.' :
          if pt != 1 : cpt = cpt + 1
          s=s+c
        else:
          pt = 1
          if r+1 == len(t) or t[r+1:].atof() == 0.:break
  s=s+'E'+neg*'-'+repr(cpt)
  return s

