# coding=utf-8
# person_in_charge: mathieu.courtois at edf.fr
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


"""
   Ce module contient des fonctions utilitaires
"""

# Modules Python
import sys

# Modules EFICAS
from N_Exception import AsException
from N_types import is_int, is_float, is_complex, is_str, is_sequence, is_assd

SEP='_'

try:
   # Si la version de Python possède la fonction _getframe
   # on l'utilise.
   cur_frame=sys._getframe
except:
   # Sinon on l'émule
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
      Retourne le type d'un concept (a) à partir
      des caractéristiques de l'objet Python
   """
   if is_sequence(a):
       return AsType(a[0])
   if is_assd(a):
       return type(a)
   if is_float(a):
       return "R"
   if is_int(a):
       return "I"
   if is_str(a):
       return "TXM"
   if a == None:
       return None
   raise AsException("type inconnu: %r %s" % (a, type(a)))


def prbanner(s):
   print "*"*(len(s)+10)
   print "*"*5 + s + "*"*5
   print "*"*(len(s)+10)


def repr_float(valeur):
  """
      Cette fonction représente le réel valeur comme une chaine de caractères
      sous forme mantisse exposant si nécessaire cad si le nombre contient plus de
      5 caractères
      NB : valeur est un réel au format Python ou une chaine de caractères représentant un réel
  """
  if type(valeur) == str : valeur = eval(valeur)
  if valeur == 0. : return '0.0'
  if abs(valeur) > 1. :
    if abs(valeur) < 10000. : return repr(valeur)
  else :
    if abs(valeur) > 0.01 : return repr(valeur)
  t=repr(valeur)
  if t.find('e') != -1 or t.find('E') != -1 :
    # le réel est déjà sous forme mantisse exposant !
    # --> on remplace e par E
    t=t.replace('e','E')
    # --> on doit encore vérifier que la mantisse contient bien un '.'
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
    # réel plus petit que 1
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
    # réel plus grand que 1
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


def import_object(uri):
    """Load and return a python object (class, function...).
    Its `uri` looks like "mainpkg.subpkg.module.object", this means
    that "mainpkg.subpkg.module" is imported and "object" is
    the object to return.
    """
    path = uri.split('.')
    modname = '.'.join(path[:-1])
    if len(modname) == 0:
        raise ImportError(u"invalid uri: %s" % uri)
    mod = object = '?'
    objname = path[-1]
    try:
        __import__(modname)
        mod = sys.modules[modname]
    except ImportError, err:
        raise ImportError(u"can not import module : %s (%s)" % (modname, str(err)))
    try:
        object = getattr(mod, objname)
    except AttributeError, err:
        raise AttributeError(u"object (%s) not found in module '%s'. "
            "Module content is: %s" % (objname, modname, tuple(dir(mod))))
    return object


class Singleton(object):
    """Singleton implementation in python."""
    # add _singleton_id attribute to the class to be independant of import path used
    __inst = {}
    def __new__(cls, *args, **kargs):
        cls_id = getattr(cls, '_singleton_id', cls)
        if Singleton.__inst.get(cls_id) is None:
            Singleton.__inst[cls_id] = object.__new__(cls)
        return Singleton.__inst[cls_id]


class Enum(object):
    """
    This class emulates a C-like enum for python. It is initialized with a list
    of strings to be used as the enum symbolic keys. The enum values are automatically
    generated as sequencing integer starting at 0.
    """
    def __init__(self, *keys):
        """Constructor"""
        self._dict_keys = {}
        for inum, key in enumerate(keys):
            setattr(self, key, 2**inum)
            self._dict_keys[2**inum] = key

    def exists(self, value):
        """Tell if value is in the enumeration"""
        return self.get_id(value) is not None

    def get_id(self, value):
        """Return the key associated to the given value"""
        return self._dict_keys.get(value, None)
