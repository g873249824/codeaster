#@ MODIF nommage Noyau  DATE 27/03/2002   AUTEUR DURAND C.DURAND 
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
   Ce module sert � nommer les concepts produits par les commandes.
   Le nom du concept est obtenu en appelant la fonction GetNomConceptResultat
   du module avec le nom de la commande en argument.
   
   Cette fonction parcourt le source dans lequel la commande se trouve, parse le
   fichier et retrouve le nom du concept qui se trouve � gauche du signe = pr�c�dant
   le nom de la commande.

   Cette fonction utilise la fonction cur_frame du module N_utils qui retourne la frame
   d'ex�cution Python situ�e 2 niveaux au-dessus. C'est � partir de cette frame que
   l'on retrouve le fichier source et le num�ro de ligne o� se trouve l'appel � la commande.

"""

# Modules Python
import re,string
import linecache

# Modules EFICAS
import N_utils

regex1='=\s*%s\s*\('

def GetNomConceptResultat(ope):
  """
     Cette fonction recherche dans la pile des appels, l'appel � la commande
     qui doit etre situ� � 2 niveaux au-dessus (cur_frame(2)).
     On retrouve d'abord la frame d'ex�cution f. Puis le num�ro de la ligne
     dans le source f.f_lineno et le nom du fichier source (f.f_code.co_filename).
     A partir de l�, on r�cup�re la ligne de source avec linecache.getline
     et on v�rifie que cette ligne correspond v�ritablement � l'appel.

     En effet, lorsque les commandes tiennent sur plusieurs lignes, on retrouve
     la derni�re ligne. Il faut donc remonter dans le source jusqu'� la premi�re 
     ligne.

     Enfin la fonction evalnom forme un nom acceptable lorsque le concept est un
     �l�ment d'une liste, par exemple.

  """
  f=N_utils.cur_frame(2)
  lineno = f.f_lineno     # XXX Too bad if -O is used
  #lineno = f_lineno(f)  # Ne marche pas toujours
  co = f.f_code
  filename = co.co_filename
  name = co.co_name
  #print "NOMOP,FICHIER, LIGNE ",ope,filename,lineno
  line = linecache.getline(filename, lineno)
  if not line: line = None

  list=[]
  list.append(line)
  while lineno > 0:
    #print "LIGNE ",line
    if re.search(regex1 % ope,line):
      l=re.split(regex1 % ope,line)
      list.reverse()
      #print "COMMANDE ",string.join(list)
      #print "SPLIT ",l
      # On suppose que le concept resultat a bien ete
      # isole en tete de la ligne de source
      m=evalnom(string.strip(l[0]),f.f_locals)
      #print "NOMS ",m
      return m[-1]
    lineno=lineno-1
    line = linecache.getline(filename, lineno)
    list.append(line)
  #print "appel inconnu"
  return ""

def evalnom(text,d):
  """
   Retourne un nom pour le concept resultat identifie par text
   Pour obtenir ce nom il y a plusieurs possibilites :
    1-text est un identificateur python c est le nom du concept
    2-text est un element d une liste on construit le nom en
      evaluant la partie indice dans le contexte de l appelant d
  """
  l=re.split('([\[\]]+)',text)
  #print l
  if l[-1] == '' :l=l[:-1]
  lll=[]
  i=0
  while i<len(l):
    s=l[i]
    ll=string.split(s,',')
    ll=re.split('[ ,]+',s)
    if ll[0] == '' :ll=ll[1:]
    if len(ll) == 1:
      id0=ll[0]
    else:
      lll=lll+ll[0:-1]
      id0=ll[-1]
    if i+1<len(l) and l[i+1] == '[': # le nom est suivi d un subscript
      sub=l[i+2]
      nom=id0+'_'+str(eval(sub,d))
      i=i+4
    else:
      nom=id0
      i=i+1
    lll.append(nom)
  return lll

def f_lineno(f):
   """
      Calcule le numero de ligne courant
      Devrait marcher meme avec -O
      Semble ne pas marcher en pr�sence de tuples longs
   """
   c=f.f_code
   if not hasattr(c, 'co_lnotab'):return f.f_lineno
   tab=c.co_lnotab
   line = c.co_firstlineno
   stopat = f.f_lasti
   addr = 0
   for i in range(0, len(tab), 2):
       addr = addr + ord(tab[i])
       if addr > stopat:
           break
       line = line + ord(tab[i+1])
   return line

