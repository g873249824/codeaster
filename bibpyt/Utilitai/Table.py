#@ MODIF Table Utilitai  DATE 30/11/2004   AUTEUR MCOURTOI M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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

# RESPONSABLE MCOURTOI M.COURTOIS

import sys
import string
import re

from types import *
EnumTypes=(ListType, TupleType)
NumberTypes=(IntType, LongType, FloatType, ComplexType)

# try/except pour utiliser hors aster
try:
   from Utilitai.Utmess import UTMESS
except ImportError:
   def UTMESS(code,sprg,texte):
      fmt='\n <%s> <%s> %s\n\n'
      print fmt % (code,sprg,texte)

if not sys.modules.has_key('Graph'):
   try:
      from Utilitai import Graph
   except ImportError:
      import Graph

# formats de base (identiques � ceux du module Graph)
DicForm={
   'csep'  : ' ',       # s�parateur
   'ccom'  : '#',       # commentaire
   'cdeb'  : '',        # d�but de ligne
   'cfin'  : '\n',      # fin de ligne
   'formK' : '%-8s',    # chaines
   'formR' : '%12.5E',  # r�els
   'formI' : '%8d'      # entiers
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
class TableBase(object):
   """Classe pour partager les m�thodes d'impression entre Table et Colonne
   (c'est surtout utile pour v�rifier que l'extraction et les filtres sur les
   colonnes sont corrects).
   """
   def __repr__(self):
      return self.ReprTable()
   def Croise(self,**kargs):
      raise StandardError, 'Must be defined in a derived class'

# ------------------------------------------------------------------------------
   def Impr(self,FICHIER=None,FORMAT='TABLEAU',dform=None,**opts):
      """Impresssion de la Table selon le format sp�cifi�.
         FICHIER : nom du(des) fichier(s). Si None, on dirige vers stdout
         dform : dictionnaire de formats d'impression (format des r�els,
            commentaires, saut de ligne...)
         opts  : selon FORMAT.
      """
      para={
         'TABLEAU'         : { 'mode' : 'a', 'driver' : self.ImprTableau,   },
         'ASTER'           : { 'mode' : 'a', 'driver' : self.ImprTableau,   },
         'XMGRACE'         : { 'mode' : 'a', 'driver' : self.ImprGraph,     },
         'AGRAF'           : { 'mode' : 'a', 'driver' : self.ImprTableau,   },
         'TABLEAU_CROISE'  : { 'mode' : 'a', 'driver' : self.ImprTabCroise, },
      }
      kargs={
         'FICHIER'   : FICHIER,
         'FORMAT'    : FORMAT,
         'dform'     : DicForm.copy(),
         'mode'      : para[FORMAT]['mode'],
      }
      if dform<>None and type(dform)==DictType:
         kargs['dform'].update(dform)
      # ajout des options
      kargs.update(opts)
      
      if not kargs.get('PAGINATION'):
         # call the associated driver
         para[FORMAT]['driver'](**kargs)

      else:
         if not type(kargs['PAGINATION']) in EnumTypes:
            ppag=[kargs['PAGINATION'],]
         else:
            ppag=list(kargs['PAGINATION'])
         del kargs['PAGINATION']
         npag=len(ppag)
         # param�tres hors ceux de la pagination
         lkeep=[p for p in self.para if ppag.count(p)==0]
         # cr�ation des listes des valeurs distinctes
         lvd=[]
         for p in ppag:
            lvp=getattr(self,p).values()
            lvn=[]
            for it in lvp:
               if it<>None and lvn.count(it)==0:
                  lvn.append(it)
            lvd.append(lvn)
         # cr�ation des n-uplets
         s = '[['+','.join(['x'+str(i) for i in range(npag)])+'] '
         s+= ' '.join(['for x'+str(i)+' in lvd['+str(i)+']' for i in range(npag)])+']'
         try:
            lnup=eval(s)
         except SyntaxError, s:
            UTMESS('F','Table','Erreur lors de la construction des n-uplets')
         # pour chaque n-uplet, on imprime la sous-table
         for nup in lnup:
            tab=self
            for i in range(npag):
               tab = tab & (getattr(tab,ppag[i]) == nup[i])
               sl=''
               if tab.titr: sl='\n'
               tab.titr += sl+ppag[i]+': '+str(nup[i])
            tab[lkeep].Impr(**kargs)

# ------------------------------------------------------------------------------
   def ImprTableau(self,**kargs):
      """Impression au format TABLEAU ou ASTER
      """
      # fichier ou stdout
      if kargs.get('FICHIER')<>None:
         f=open(kargs['FICHIER'],kargs['mode'])
      else:
         f=sys.stdout
      # ecriture
      f.write(self.ReprTable(**kargs) + '\n')
      # fermeture
      if kargs.get('FICHIER')<>None:
         f.close()

   def ReprTable(self,FORMAT='TABLEAU',dform=DicForm,**ignore):
      """Repr�sentation d'une Table ou d'une Colonne sous forme d'un tableau.
      """
      rows=self.rows
      para=self.para
      typ =self.type
      if not type(para) in EnumTypes:
         para=[self.para,]
         typ =[self.type,]
      # est-ce que l'attribut .type est renseign� ?
      typdef=typ<>[None]*len(typ)
      txt=[]
      # ['']+ pour ajouter un s�parateur en d�but de ligne
      lspa=['',]
      # lmax : largeur max des colonnes = max(form{K,R,I},len(parametre))
      lmax=[]
      for p in para:
         t=typ[para.index(p)]
         larg_max=max([len(p)] + \
               [len(FMT(dform,k,t) % 0) for k in ('formK','formR','formI')])
         lspa.append(FMT(dform,'formK',t,larg_max,p) % p)
         lmax.append(larg_max)
      if typdef:
         stype=dform['csep'].join([''] + \
          [FMT(dform,'formK',typ[i],lmax[i]) % typ[i] for i in range(len(para))])
      txt.append('')
      txt.append('-'*80)
      txt.append('')
      ASTER=(FORMAT=='ASTER')
      if ASTER:
         txt.append('#DEBUT_TABLE')
      if self.titr:
         if ASTER:
            txt.extend(['#TITRE '+lig for lig in self.titr.split('\n')])
         else:
            txt.append(self.titr)
      txt.append(dform['csep'].join(lspa))
      if ASTER and typdef:
         txt.append(stype)
      for r in rows:
         lig=['']
         empty=True
         for v in para:
            i=para.index(v)
            t=typ[i]
            rep=r.get(v,None)
            if type(rep) is FloatType:
               lig.append(FMT(dform,'formR',t,lmax[i]) % rep)
               empty=False
            elif type(rep) is IntType:
               lig.append(FMT(dform,'formI',t,lmax[i]) % rep)
               empty=False
            else:
               if rep==None:
                  rep='-'
               else:
                  empty=False
               s=FMT(dform,'formK',t,lmax[i],rep) % str(rep)
               # format AGRAF = TABLEAU + '\' devant les chaines de caract�res !
               if FORMAT=='AGRAF':
                  s='\\'+s
               lig.append(s)
         if not empty:
            txt.append(dform['csep'].join(lig))
      if ASTER:
         txt.append('#FIN_TABLE')
      return dform['cfin'].join(txt)
# ------------------------------------------------------------------------------
   def ImprTabCroise(self,**kargs):
      """Impression au format TABLEAU_CROISE d'une table ayant 3 param�tres.
      """
      # cr�ation du tableau crois� et impression au format TABLEAU
      tabc=self.Croise()
      kargs['FORMAT']='TABLEAU'
      tabc.Impr(**kargs)
# ------------------------------------------------------------------------------
   def ImprGraph(self,**kargs):
      """Impression au format XMGRACE : via le module Graph
      """
      args=kargs.copy()
      if len(self.para)<>2:
         UTMESS('A','Table','La table doit avoir exactement deux param�tres.')
         return
      lx, ly = [[v for v in getattr(self,p).values() if v<>None] for p in self.para]
      # objet Graph
      graph=Graph.Graph()
      dicC={
         'Val' : [lx, ly],
         'Lab' : self.para,
      }
      if args['LEGENDE']==None: del args['LEGENDE']
      Graph.AjoutParaCourbe(dicC, args)
      graph.AjoutCourbe(**dicC)
      
      # Surcharge des propri�t�s du graphique et des axes
      # (bloc quasiment identique dans impr_fonction_ops)
      if args.get('TITRE'):            graph.Titre=args['TITRE']
      if args.get('BORNE_X'):
                                       graph.Min_X=args['BORNE_X'][0]
                                       graph.Max_X=args['BORNE_X'][1]
      if args.get('BORNE_Y'):
                                       graph.Min_Y=args['BORNE_Y'][0]
                                       graph.Max_Y=args['BORNE_Y'][1]
      if args.get('LEGENDE_X'):        graph.Legende_X=args['LEGENDE_X']
      if args.get('LEGENDE_Y'):        graph.Legende_Y=args['LEGENDE_Y']
      if args.get('ECHELLE_X'):        graph.Echelle_X=args['ECHELLE_X']
      if args.get('ECHELLE_Y'):        graph.Echelle_Y=args['ECHELLE_Y']
      if args.get('GRILLE_X'):         graph.Grille_X=args['GRILLE_X']
      if args.get('GRILLE_Y'):         graph.Grille_Y=args['GRILLE_Y']
      
      try:
         graph.Trace(**args)
      except TypeError:
         UTMESS('A','Table','Les cellules ne doivent contenir que des nombres r�els')

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
class Table(TableBase):
   """Une table est construite comme une liste de lignes, chaque ligne est
   un dictionnaire.
   On cr�e puis on ajoute les lignes avec la m�thode append :
      t=Table()
      t.append(dict(a=1,b=2))
      t.append(dict(a=3,b=4))
   La m�thode __iter__ d�finit un it�rateur sur les lignes de la table,
   __repr__ retourne une repr�sentation de la table, utilis�e par "print t".
   Grace � la classe Colonne et � sa m�thode _extract, il est possible
   de construire une sous-table qui satisfait un crit�re donn�.
   Le crit�re est donn� par une fonction Python qui retourne vrai
   ou faux si la valeur d'une colonne respecte le crit�re ou non.
   Exemple:
     def critere(valeur):
         return valeur < 10
     soustable = t.a._extract(critere)
   t.a retourne un objet interm�diaire de la classe Colonne qui m�morise
   le nom de la colonne demand�e (a, ici).
   """
   def __init__(self, rows=[], para=[], typ=[], titr=''):
      """Constructeur de la Table :
         rows : liste des lignes (dict)
         para : liste des param�tres
         type : liste des types des param�tres
         titr : titre de la table
      """
      self.rows=[r for r in rows if r.values()<>[None]*len(r.values())]
      self.para=list(para)
      if len(typ)==len(self.para):
         self.type=list(typ)
      else:
         self.type=[None]*len(self.para)
      self.titr=titr

   def append(self, obj):
      """Ajoute une ligne (type dict) � la Table"""
      self.rows.append(obj)

   def __iter__(self):
      """It�re sur les lignes de la Table"""
      return iter(self.rows)

   def __getattr__(self, column):
      """Construit un objet intermediaire (couple table, colonne)"""
      typ=None
      if not column in self.para:
         column=''
      else:
         typ=self.type[self.para.index(column)]
      return Colonne(self, column, typ)

   def sort(self, CLES=None, ORDRE='CROISSANT'):
      """Tri de la table.
         CLES  : liste des cl�s de tri
         ORDRE : CROISSANT ou DECROISSANT (de longueur 1 ou len(keys))
      """
      # par d�faut, on prend tous les param�tres
      if CLES==None:
         CLES=self.para[:]
      if not type(CLES) in EnumTypes:
         CLES=[CLES,]
      else:
         CLES=list(CLES)
      self.rows=sort_table(self.rows, self.para, CLES, (ORDRE=='DECROISSANT'))
#       if not type(order) in EnumTypes:
#          order=[order,]
#       print 'TRI cl�s=%s, order=%s' % (keys,order)
#       # on ne garde que le premier si les longueurs sont diff�rentes
#       if len(order)<>len(keys):
#          order=[order[0],]
#       else:
#          # si toutes les valeurs sont identiques, on peut ne garder que la 1�re
#          d={}
#          for o in order: d[o]=None
#          if len(order)<>len(keys) or len(d.keys())==1:
#             order=[order[0],]
#       if len(order)==1:
#          self.rows=sort_table(self.rows, self.para, keys, (order[0]=='DECROISSANT'))
#       else:
#          # de la derni�re cl� � la premi�re
#          for k,o in [(keys[i],order[i]) for i in range(len(keys)-1,-1,-1)]:
#             print 'TRI : cl�=%s, order=%s' % (k,o)
#             self.rows=sort_table(self.rows, self.para, [k], (o=='DECROISSANT'))

   def __delitem__(self, args):
      """Supprime les colonnes correspondantes aux �l�ments de args """
      if not type(args) in EnumTypes:
         args=[args,]
      new_rows=self.rows
      new_para=self.para
      new_type=self.type
      for item in args:
         del new_type[new_para.index(item)]
         new_para.remove(item)
         for line in new_rows : del line[item] 
      return Table(new_rows, new_para, new_type, self.titr)

   def __getitem__(self, args):
      """Extrait la sous table compos�e des colonnes dont les param�tres sont dans args """
      if not type(args) in EnumTypes:
         args=[args,]
      else:
         args=list(args)
      #print '<getitem> args=',args
      new_rows=[]
      new_para=args
      new_type=[]
      for item in new_para:
         if not item in self.para:
            return Table()
         new_type.append(self.type[self.para.index(item)])
      for line in self:
         new_line={}
         for item in new_para:
            new_line[item]=line.get(item)
         new_rows.append(new_line)
      return Table(new_rows, new_para, new_type, self.titr)

   def __and__(self, other):
      """Intersection de deux tables (op�rateur &)"""
      if other.para<>self.para:
         UTMESS('A','Table','Les param�tres sont diff�rents')
         return Table()
      else:
         tmp = [ r for r in self if r in other.rows ]
         return Table(tmp, self.para, self.type, self.titr)

   def __or__(self, other):
      """Union de deux tables (op�rateur |)"""
      if other.para<>self.para:
         UTMESS('A','Table','Les param�tres sont diff�rents')
         return Table()
      else:
         tmp = self.rows[:]
         tmp.extend([ r for r in other if r not in self ])
         return Table(tmp, self.para, self.type[:], self.titr)

   def values(self):
      """Renvoie la table sous la forme d'un dictionnaire de listes dont les
      cl�s sont les param�tres.
      """
      dico={}
      for column in self.para:
         dico[column]=Colonne(self, column).values()
      return dico

   def Croise(self):
      """Retourne un tableau crois� P3(P1,P2) � partir d'une table ayant
      trois param�tres (P1, P2, P3).
      """
      if len(self.para)<>3:
         UTMESS('A','Table','La table doit avoir exactement trois param�tres.')
         return Table()
      py, px, pz = self.para
      ly, lx, lz = [getattr(self,p).values() for p in self.para]
      new_rows=[]
      #lpz='%s=f(%s,%s)' % (pz,px,py)
      lpz='%s/%s' % (px,py)
      new_para=[lpz,]
      # attention aux doublons dans ly
      for it in ly:
         if it<>None and new_para.count(it)==0:
            new_para.append(it)
      x0=None
      for x in lx:
         if x<>None and x<>x0:
            d={ lpz : x, }
            taux = (getattr(self,px)==x)
            for dz in taux.rows:
               d[dz[py]]=dz[pz]
            new_rows.append(d)
         x0=x
      new_type=[self.type[0],] + [self.type[2]]*len(ly)
      new_titr=self.titr
      if new_titr<>'': new_titr+='\n'
      new_titr+=pz + ' FONCTION DE ' + px + ' ET ' + py
      return Table(new_rows, new_para, new_type, new_titr)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
class Colonne(TableBase):
   """Classe interm�diaire pour m�moriser un couple (table, nom de colonne)
   et exprimer les crit�res d'extraction sous une forme naturelle en python
   en surchargeant les operateurs <, >, <> et =.
   Alors on peut �crire la requete simple :
     soustable=t.a<10
   Ainsi que des requetes plus complexes :
     soustable=t.a<10 & t.b <4
   ou
     soustable=t.a<10 | t.b <4
   Les "alias" EQ, NE, LE, LT, GE, GT permettent � la macro IMPR_TABLE
   d'utiliser directement le mot-cl� utilisateur CRIT_COMP d�fini dans le
   catalogue : getattr(Table,CRIT_COMP).
   """
   def __init__(self, table, column, typ=None):
      """Constructeur (objet Table associ�, param�tre de la colonne, type du
      param�tre).
      """
      self.Table=table
      self.rows=self.Table.rows
      self.para=column
      self.type=typ
      self.titr=''

   def _extract(self, fun):
      """Construit une table avec les lignes de self.Table 
         dont l'�l�ment de nom self.para satisfait le crit�re fun,
         fun est une fonction qui retourne vrai ou faux
      """
      return Table([row for row in self.Table if fun(row.get(self.para))], self.Table.para, self.Table.type, self.Table.titr)

   def __le__(self, VALE):
      return self._extract(lambda v: v<>None and v<=VALE)

   def __lt__(self, VALE):
      return self._extract(lambda v: v<>None and v<VALE)

   def __ge__(self, VALE):
      return self._extract(lambda v: v<>None and v>=VALE)

   def __gt__(self, VALE):
      return self._extract(lambda v: v<>None and v>VALE)

   def __eq__(self, VALE, CRITERE='RELATIF', PRECISION=0.):
      if PRECISION==0. or not type(VALE) in NumberTypes:
         if type(VALE) in StringTypes:
            return self._extract(lambda v: v<>None and str(v).strip()==VALE.strip())
         else:
            return self._extract(lambda v: v==VALE)
      else:
         if CRITERE=='ABSOLU':
            vmin=VALE-PRECISION
            vmax=VALE+PRECISION
         else:
            vmin=(1.-PRECISION)*VALE
            vmax=(1.+PRECISION)*VALE
         return self._extract(lambda v: v<>None and vmin<v<vmax)

   def __ne__(self, VALE, CRITERE='RELATIF', PRECISION=0.):
      if PRECISION==0. or not type(VALE) in NumberTypes:
         if type(VALE) in StringTypes:
            return self._extract(lambda v: v<>None and str(v).strip()<>VALE.strip())
         else:
            return self._extract(lambda v: v<>VALE)
      else:
         if CRITERE=='ABSOLU':
            vmin=VALE-PRECISION
            vmax=VALE+PRECISION
         else:
            vmin=(1.-PRECISION)*VALE
            vmax=(1.+PRECISION)*VALE
         return self._extract(lambda v: v<>None and (v<vmin or vmax<v))

   def MAXI(self):
      # important pour les performances de r�cup�rer le max une fois pour toutes
      maxi=max(self)
      return self._extract(lambda v: v==maxi)

   def MINI(self):
      # important pour les performances de r�cup�rer le min une fois pour toutes
      mini=min(self)
      return self._extract(lambda v: v==mini)

   def ABS_MAXI(self):
      # important pour les performances de r�cup�rer le max une fois pour toutes
      abs_maxi=max([abs(v) for v in self.values() if type(v) in NumberTypes])
      return self._extract(lambda v: v==abs_maxi or v==-abs_maxi)

   def ABS_MINI(self):
      # important pour les performances de r�cup�rer le min une fois pour toutes
      abs_mini=min([abs(v) for v in self.values() if type(v) in NumberTypes])
      # tester le type de v est trop long donc pas de abs(v)
      return self._extract(lambda v: v==abs_mini or v==-abs_mini)

   def __iter__(self):
      """It�re sur les �l�ments de la colonne"""
      for row in self.Table:
         # si l'�l�ment n'est pas pr�sent on retourne None
         yield row.get(self.para)
         #yield row[self.para]

   def __getitem__(self, i):
      """Retourne la i�me valeur d'une colonne"""
      return self.values()[i]

   def values(self):
      """Renvoie la liste des valeurs"""
      return [r[self.para] for r in self.Table]

   # �quivalences avec les op�rateurs dans Aster
   LE=__le__
   LT=__lt__
   GE=__ge__
   GT=__gt__
   EQ=__eq__
   NE=__ne__
   def VIDE(self)    : return self.__eq__(None)
   def NON_VIDE(self): return self.__ne__(None)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
def sort_table(rows,l_para,w_para,reverse=False):
   """Sort list of dict.
      rows     : list of dict
      l_para   : list of the keys of dict
      w_para   : keys of the sort
   """
   c_para=[i for i in l_para if i not in w_para]
   new_rows=rows
   for i in w_para :
      new_key= '__'+str(w_para.index(i))+i
      for row in new_rows :
         row[new_key]=row[i]
         del row[i]
   for i in c_para :
      new_key= '___'+i
      for row in new_rows :
         row[new_key]=row[i]
         del row[i]
   new_rows.sort()
   if reverse:
      new_rows.reverse()
   for i in w_para :
      old_key= '__'+str(w_para.index(i))+i
      for row in new_rows :
         row[i]=row[old_key]
         del row[old_key]
   for i in c_para :
      old_key= '___'+i
      for row in new_rows :
         row[i]=row[old_key]
         del row[old_key]
   return new_rows

# ------------------------------------------------------------------------------
def FMT(dform, nform, typAster=None, larg=0, val=''):
   """Retourne un format d'impression Python � partir d'un type Aster ('R','I',
   'K8', 'K16'...). Si typAster==None, retourne dform[nform].
      larg : largeur minimale du format (val permet de ne pas ajouter des blancs
      si la chaine � afficher est plus longue que le format, on prend le partie
      de ne pas tronquer les chaines)
   """
   if typAster==None:
      fmt=dform[nform]
   elif typAster in ('I', 'R'):
      if nform=='formK':
         # convertit %12.5E en %-12s
         fmt=re.sub('([0-9]+)[\.0-9]*[diueEfFgG]+','-\g<1>s',dform['form'+typAster])
         #print nform, typAster, fmt
      else:
         fmt=dform[nform]
   else:
      # typAster = Kn
      fmt='%-'+typAster[1:]+'s'
   # on ajoute �ventuellement des blancs pour atteindre la largeur demand�e
   if larg<>0:
      fmt=' '*max(min(larg-len(val),larg-len(fmt % 0)),0) + fmt
   return fmt

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
if __name__ == "__main__":
   listdic = [
   {'NOEUD': 'N1' ,'NUME_ORDRE': 1 ,'INST': 0.5, 'DX': -0.00233, 'COOR_Y': 0.53033,},
   {'NOEUD': 'N1' ,'NUME_ORDRE': 2 ,'INST': 1.0, 'DX': -0.00467, 'COOR_Y': 0.53033,},
   {'NOEUD': 'N1' ,'NUME_ORDRE': 3 ,'INST': 1.5, 'DX': -0.00701, 'COOR_Y': 0.53033,},
   {'NOEUD': 'N1' ,'NUME_ORDRE': 4 ,'INST': 2.0, 'DX': -0.00934, 'COOR_Y': 0.53033,},
   {'NOEUD': 'N1' ,'NUME_ORDRE': 5 ,'INST': 2.5, 'DX': -0.01168, 'COOR_Y': 0.53033,},
   {'NOEUD': 'N2' ,'NUME_ORDRE': 11,'INST': 5.5, 'DX': -0.00233, 'COOR_Y': 0.53033,},
   {'NOEUD': 'N2' ,'NUME_ORDRE': 12,'INST': 6.0, 'DX': -0.00467, 'COOR_Y': 0.53033,},
   {'NOEUD': 'N2' ,'NUME_ORDRE': 13,'INST': 6.5, 'DX': -0.00701, 'COOR_Y': 0.53033,},
   {'NOEUD': 'N2' ,'NUME_ORDRE': 14,'INST': 7.0, 'DX': -0.00934, 'COOR_Y': 0.53033,},
   {'NOEUD': 'N2' ,'NUME_ORDRE': 15,'INST': 7.5, 'DX': -0.01168, 'COOR_Y': 0.53033,},
   ]
   import random
   random.shuffle(listdic)
   listpara=['NOEUD','NUME_ORDRE','INST','COOR_Y','DX']
   listtype=['K8','I','R','R','R']
   t=Table(listdic,listpara,listtype)
   
   tb=t[('NOEUD','DX')]
   print tb.para
   print tb.type
   
   print
   print "------Table initiale----"
   print t
   print
   print "--------- CRIT --------"
   print t.NUME_ORDRE <=5
   print
   print "------- CRIT & CRIT -----"
   print (t.NUME_ORDRE < 10) & (t.INST >=1.5)
   print
   print "----- EQ maxi / min(col), max(col) ------"
   print t.DX == max(t.DX)
   print min(t.DX)
   print max(t.DX)
   print "------ getitem sur 2 param�tres ------"
   print t.NUME_ORDRE
   print t.DX
   print t['DX','NUME_ORDRE']
   print "------ sort sur INST ------"
   t.sort('INST')
   print t

   print "------- TABLEAU_CROISE ------"
   tabc=t['NOEUD','INST','DX'] 
   tabc.Impr(FORMAT='TABLEAU_CROISE')

   N=5
   ldic=[]
   for i in range(N):
      ldic.append({'IND':float(i), 'VAL' : random.random()*i})
   para=['IND','VAL']
   t3=Table(ldic, para, titr='Table al�atoire')
   col=t3.VAL.ABS_MAXI()
   col=t3.VAL.MINI()
   
   t3.sort('VAL','IND')
   
   tg=tabc['INST','DX'].DX.NON_VIDE()
   #tg.Impr(FORMAT='XMGRACE')
   
   g=Graph.Graph()
   g.Titre="Trac� d'une fonction au format TABLEAU"
   g.AjoutCourbe(Val=[tg.INST.values(), tg.DX.values()], Lab=['INST','DX'])
   g.Trace(FORMAT='TABLEAU')
   
#   t.Impr(PAGINATION='NOEUD')
   t.Impr(PAGINATION=('NOEUD','INST'))
   
