#@ MODIF t_fonction Utilitai  DATE 09/02/2007   AUTEUR GREFFET N.GREFFET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
from Numeric import *
import copy
import types
from sets import Set

class FonctionError(Exception):
   pass

def interp(typ_i,val,x1,x2,y1,y2) :
  """Interpolation lin�aire/logarithmique entre un couple de valeurs
  """
  if typ_i==['LIN','LIN']: return y1+(y2-y1)*(val-x1)/(x2-x1)
  if typ_i==['LIN','LOG']: return exp(log(y1)+(val-x1)*(log(y2)-log(y1))/(x2-x1))
  if typ_i==['LOG','LOG']: return exp(log(y1)+(log(val)-log(x1))*(log(y2)-log(y1))/(log(x2)-log(x1)))
  if typ_i==['LOG','LIN']: return y1+(log(val)-log(x1))*(y2-y1)/(log(x2)-log(x1))
  if typ_i[0]=='NON'     : 
                           if   val==x1 : return y1
                           elif val==x2 : return y2
                           else         : raise FonctionError, 'fonction : interpolation NON'
def is_ordo(liste) :
  listb=list(Set(liste))
  listb.sort()
  return liste==listb

class t_fonction :
  """Classe pour fonctions r�elles, �quivalent au type aster = fonction_sdaster
  """
  def __init__(self,vale_x,vale_y,para) :
    """Cr�ation d'un objet fonction
    - vale_x et vale_y sont des listes de r�els de meme longueur
    - para est un dictionnaire contenant les entr�es PROL_DROITE, PROL_GAUCHE et INTERPOL (cf sd ASTER)
    """
    pk=para.keys()
    pk.sort()
    if pk!=['INTERPOL','NOM_PARA','NOM_RESU','PROL_DROITE','PROL_GAUCHE'] :
         raise FonctionError, 'fonction : parametres incorrects'
    if para['INTERPOL'] not in [['NON','NON'],['LIN','LIN'],['LIN','LOG'],['LOG','LOG'],['LOG','LIN'],] :
         raise FonctionError, 'fonction : parametre INTERPOL incorrect'
    if para['PROL_DROITE'] not in ['EXCLU','CONSTANT','LINEAIRE'] :
         raise FonctionError, 'fonction : parametre PROL_DROITE incorrect'
    if para['PROL_GAUCHE'] not in ['EXCLU','CONSTANT','LINEAIRE'] :
         raise FonctionError, 'fonction : parametre PROL_GAUCHE incorrect'
    self.vale_x    = array(vale_x)
    self.vale_y    = array(vale_y)
    self.para      = para
    if len(self.vale_x)!=len(self.vale_y) :
         raise FonctionError, 'fonction : longueur abscisse <> longueur ordonn�es'
    if not is_ordo(self.vale_x) :
         raise FonctionError, 'fonction : abscisses non strictement croissantes'

  def __add__(self,other) :
    """addition avec une autre fonction ou un nombre, par surcharge de l'op�rateur +
    """
    if   isinstance(other,t_fonction):
      para=copy.copy(self.para)
      vale_x,para['PROL_GAUCHE'],para['PROL_DROITE']=self.homo_support(other)
      fff=self.evalfonc(vale_x)
      ggg=other.evalfonc(vale_x)
      if   isinstance(self,t_fonction_c): return t_fonction_c(vale_x,fff.vale_y+ggg.vale_y,para)
      else                              : return t_fonction(vale_x,fff.vale_y+ggg.vale_y,para)
    elif type(other) in [types.FloatType,types.IntType,types.ComplexType] :
      if   isinstance(self,t_fonction_c): return t_fonction_c(self.vale_x,self.vale_y+other,self.para)
      else                              : return t_fonction(self.vale_x,self.vale_y+other,self.para)
    else:  raise FonctionError, 'fonctions : erreur de type dans __add__'

  def __mul__(self,other) :
    """multiplication avec une autre fonction ou un nombre, par surcharge de l'op�rateur *
    """
    if   isinstance(other,t_fonction):
      para=copy.copy(self.para)
      vale_x,para['PROL_GAUCHE'],para['PROL_DROITE']=self.homo_support(other)
      fff=self.evalfonc(vale_x)
      ggg=other.evalfonc(vale_x)
      if   isinstance(self,t_fonction_c): return t_fonction_c(vale_x,fff.vale_y*ggg.vale_y,para)
      else                              : return t_fonction(vale_x,fff.vale_y*ggg.vale_y,para)
    elif type(other) in [types.FloatType,types.IntType] :
      return t_fonction(self.vale_x,self.vale_y*other,self.para)
    elif type(other) ==types.ComplexType :
      return t_fonction_c(self.vale_x,self.vale_y*other,self.para)
    else:  raise FonctionError, 'fonctions : erreur de type dans __mul__'

  def __repr__(self) :
    """affichage de la fonction en double colonne
    """
    texte=[]
    for i in range(len(self.vale_x)) :
      texte.append('%f %f' % (self.vale_x[i],self.vale_y[i]))
    return '\n'.join(texte)

  def __getitem__(self,other) :
    """composition de deux fonction F[G]=FoG=F(G(x))
    """
    para=copy.copy(self.para)
    if other.para['NOM_RESU']!=self.para['NOM_PARA'] :
       raise FonctionError,'''composition de fonctions : NOM_RESU1 et NOM_PARA2 incoh�rents '''
    para['NOM_PARA']==other.para['NOM_PARA']
    return t_fonction(other.vale_x,map(self,other.vale_y),para)

  def __call__(self,val,tol=1.e-6):
    """m�thode pour �valuer f(x)
    - tol�rance, par d�faut 1.e-6 en relatif sur la longueur de l'intervalle
    - adjacent, pour capter les erreurs d'arrondi en cas de prolongement exclu
    """
    i=searchsorted(self.vale_x,val)
    n=len(self.vale_x)
    if i==0 :
      if self.para['PROL_GAUCHE']=='EXCLU'    :
         eps_g=(val-self.vale_x[0] )/(self.vale_x[1] -self.vale_x[0])
         if abs(eps_g)<=tol  : return self.vale_y[0]
         else                : raise FonctionError, 'fonction �valu�e hors du domaine de d�finition'
      else  : 
         if self.para['PROL_GAUCHE']=='CONSTANT' : return self.vale_y[0]
         if self.para['PROL_GAUCHE']=='LINEAIRE' : return interp(self.para['INTERPOL'],val,self.vale_x[0],
                                                                                           self.vale_x[1],
                                                                                           self.vale_y[0],
                                                                                           self.vale_y[1])
    elif i==n :
      if self.para['PROL_DROITE']=='EXCLU'    :
         eps_d=(val-self.vale_x[-1])/(self.vale_x[-1]-self.vale_x[-2])
         if abs(eps_d)<=tol  : return self.vale_y[-1]
         else                : raise FonctionError, 'fonction �valu�e hors du domaine de d�finition'
      else  : 
         if self.para['PROL_DROITE']=='CONSTANT' : return self.vale_y[-1]
         if self.para['PROL_DROITE']=='LINEAIRE' : return interp(self.para['INTERPOL'],val,self.vale_x[-1],
                                                                                           self.vale_x[-2],
                                                                                           self.vale_y[-1],
                                                                                           self.vale_y[-2])
    else :
      return interp(self.para['INTERPOL'],val,self.vale_x[i-1],
                                              self.vale_x[i],
                                              self.vale_y[i-1],
                                              self.vale_y[i])

  def homo_support(self,other) :
    """Renvoie le support d'abscisses homog�n�is� entre self et other
    i.e. si prolongement exclu, on retient plus grand min ou plus petit max, selon
    si prolongement autoris�, on conserve les abscisses d'une fonction, extrapolantes
    sur l'autre.
    Pour les points interm�diaires : union et tri des valeurs des vale_x r�unis.
    """
    if other.vale_x[0]>self.vale_x[0]:
       if other.para['PROL_GAUCHE']!='EXCLU' : f_g=self
       else                                  : f_g=other
    else :
       if self.para['PROL_GAUCHE'] !='EXCLU' : f_g=other
       else                                  : f_g=self
    val_min    =f_g.vale_x[0]
    prol_gauche=f_g.para['PROL_GAUCHE']
    if self.vale_x[-1]>other.vale_x[-1]:
       if other.para['PROL_DROITE']!='EXCLU' : f_d=self
       else                                  : f_d=other
    else :
       if self.para['PROL_DROITE'] !='EXCLU' : f_d=other
       else                                  : f_d=self
    val_max    =f_d.vale_x[-1]
    prol_droite=f_d.para['PROL_DROITE']
    vale_x=concatenate((self.vale_x,other.vale_x))
    vale_x=clip(vale_x,val_min,val_max)
    vale_x=sort(dict([(i,0) for i in vale_x]).keys())
    return vale_x,prol_gauche,prol_droite

  def cut(self,rinf,rsup,prec,crit='RELATIF') :
    """Renvoie la fonction self dont on a 'coup�' les extr�mit�s en x=rinf et x=rsup
    pour la recherche de rinf et rsup dans la liste d'abscisses :
       prec=precision crit='absolu' ou 'relatif'
    """
    para=copy.copy(self.para)
    para['PROL_GAUCHE']='EXCLU'
    para['PROL_DROITE']='EXCLU'
    if   crit=='ABSOLU' : rinf_tab=greater(abs(self.vale_x-rinf),prec)
    elif crit=='RELATIF': rinf_tab=greater(abs(self.vale_x-rinf),prec*rinf)
    else : raise FonctionError, 'fonction : cut : crit�re absolu ou relatif'
    if   crit=='ABSOLU' : rsup_tab=greater(abs(self.vale_x-rsup),prec)
    elif crit=='RELATIF': rsup_tab=greater(abs(self.vale_x-rsup),prec*rsup)
    else : raise FonctionError, 'fonction : cut : crit�re absolu ou relatif'
    if alltrue(rinf_tab) : i=searchsorted(self.vale_x,rinf)
    else                 : i=rinf_tab.tolist().index(0)+1
    if alltrue(rsup_tab) : j=searchsorted(self.vale_x,rsup)
    else                 : j=rsup_tab.tolist().index(0)
    vale_x=array([rinf,]+self.vale_x.tolist()[i:j]+[rsup,])
    vale_y=array([self(rinf),]+self.vale_y.tolist()[i:j]+[self(rsup),])
    return t_fonction(vale_x,vale_y,para)

  def cat(self,other,surcharge) :
    """renvoie une fonction concat�n�e avec une autre, avec r�gles de surcharge
    """
    para=copy.copy(self.para)
    if self.para['INTERPOL']!=other.para['INTERPOL'] : raise FonctionError, 'concat�nation de fonctions � interpolations diff�rentes'
    if min(self.vale_x)<min(other.vale_x) :
            f1=self
            f2=other
    else                                  :
            f1=other
            f2=self
    para['PROL_GAUCHE']=f1.para['PROL_GAUCHE']
    if   surcharge=='GAUCHE' :
       i=searchsorted(f2.vale_x,f1.vale_x[-1])
       if i!=len(f2.vale_x) : para['PROL_DROITE']=f2.para['PROL_DROITE']
       else                 : para['PROL_DROITE']=f1.para['PROL_DROITE']
       vale_x=array(f1.vale_x.tolist()+f2.vale_x[i:].tolist())
       vale_y=array(f1.vale_y.tolist()+f2.vale_y[i:].tolist())
    elif surcharge=='DROITE' :
       i=searchsorted(f1.vale_x,f2.vale_x[0])
       if i!=len(f1.vale_x) : para['PROL_DROITE']=f2.para['PROL_DROITE']
       else                 : para['PROL_DROITE']=f1.para['PROL_DROITE']
       vale_x=array(f1.vale_x[:i].tolist()+f2.vale_x.tolist())
       vale_y=array(f1.vale_y[:i].tolist()+f2.vale_y.tolist())
    return t_fonction(vale_x,vale_y,para)

  def tabul(self) :
    """mise en forme de la fonction selon un vecteur unique (x1,y1,x2,y2,...)
    """
    __tab=array([self.vale_x,self.vale_y])
    return ravel(transpose(__tab)).tolist()

  def extreme(self) :
    """renvoie un dictionnaire des valeurs d'ordonn�es min et max
    """
    val_min=min(self.vale_y)
    val_max=max(self.vale_y)
    vm={}
    vm['min']=[[self.vale_y[i],self.vale_x[i]] for i in range(len(self.vale_x))\
                                               if self.vale_y[i]==val_min]
    vm['max']=[[self.vale_y[i],self.vale_x[i]] for i in range(len(self.vale_x))\
                                               if self.vale_y[i]==val_max]
    vm['min'].sort()
    vm['max'].sort()
    for item in vm['min'] : item.reverse()
    for item in vm['max'] : item.reverse()
    return vm

  def trapeze(self,coef) :
    """renvoie la primitive de la fonction, calcul�e avec la constante d'int�gration 'coef'
    """
    trapz     = zeros(len(self.vale_y),Float)
    trapz[0]  = coef
    trapz[1:] = (self.vale_y[1:]+self.vale_y[:-1])/2*(self.vale_x[1:]-self.vale_x[:-1])
    prim_y=cumsum(trapz)
    para=copy.copy(self.para)
    para['PROL_GAUCHE']='EXCLU'
    para['PROL_DROITE']='EXCLU'
    if   para['NOM_RESU'][:4]=='VITE' : para['NOM_RESU']='DEPL'
    elif para['NOM_RESU'][:4]=='ACCE' : para['NOM_RESU']='VITE'
    return t_fonction(self.vale_x,prim_y,para)

  def simpson(self,coef) :
    """renvoie la primitive de la fonction, calcul�e avec la constante d'int�gration 'coef'
    """
    para=copy.copy(self.para)
    para['PROL_GAUCHE']='EXCLU'
    para['PROL_DROITE']='EXCLU'
    if   para['NOM_RESU'][:4]=='VITE' : para['NOM_RESU']='DEPL'
    elif para['NOM_RESU'][:4]=='ACCE' : para['NOM_RESU']='VITE'
    fm      = self.vale_y[0]
    fb      = self.vale_y[1]
    h2      = self.vale_x[1] - self.vale_x[0]
    tabl    = [coef,coef +(fb+fm)*h2/2.]
    prim_y  = copy.copy(tabl)
    iperm   = 0
    ip      = (1,0)
    eps     = 1.E-4
    for i in range(2,len(self.vale_x)) :
       h1  = h2
       h2  = self.vale_x[i] - self.vale_x[i-1]
       bma = h1 + h2
       fa  = fm
       fm  = fb
       fb  = self.vale_y[i]
       deltah = h2 - h1
       if h1==0. or h2==0. or abs( deltah / h1 ) <= eps :
          ct  = (1.,4.,1.)
       else :
          epsi = deltah / (h1*h2)
          ct   = (1.-epsi*h2,2.+epsi*deltah,1.+epsi*h1)
       tabl[iperm] = tabl[iperm] + (bma/6.)*(ct[0]*fa+ct[1]*fm+ct[2]*fb)
       prim_y.append(tabl[iperm])
       iperm       = ip[iperm]
    return t_fonction(self.vale_x,prim_y,para)

  def derive(self) :
    """renvoie la d�riv�e de la fonction
    """
    pas=self.vale_x[1:]-self.vale_x[:-1]
    pentes=(self.vale_y[1:]-self.vale_y[:-1])/(self.vale_x[1:]-self.vale_x[:-1])
    derive=(pentes[1:]*pas[1:]+pentes[:-1]*pas[:-1])/(pas[1:]+pas[:-1])
    derv_y=[pentes[0]]+derive.tolist()+[pentes[-1]]
    para=copy.copy(self.para)
    para['PROL_GAUCHE']='EXCLU'
    para['PROL_DROITE']='EXCLU'
    if   para['NOM_RESU'][:4]=='DEPL' : para['NOM_RESU']='VITE'
    elif para['NOM_RESU'][:4]=='VITE' : para['NOM_RESU']='ACCE'
    return t_fonction(self.vale_x,derv_y,para)

  def inverse(self) :
    """renvoie l'inverse de la fonction
    on intervertit vale_x et vale_y, on swape interpolation
    """
    para=copy.copy(self.para)
    para['NOM_RESU']='TOUTRESU'
    para['NOM_PARA']=self.para['NOM_PARA']
    para['INTERPOL'].reverse()
    if para['PROL_GAUCHE']=='CONSTANT' : para['PROL_GAUCHE']='EXCLU'
    if para['PROL_DROITE']=='CONSTANT' : para['PROL_DROITE']='EXCLU'
    vale_x=self.vale_y
    vale_y=self.vale_x
    if not is_ordo(vale_x) :
       vale_x=vale_x[::-1]
       vale_y=vale_y[::-1]
    return t_fonction(vale_x,vale_y,para)

  def abs(self) :
    """renvoie la mm fonction avec valeur absolue des ordonn�es
    """
    para=copy.copy(self.para)
    if para['PROL_GAUCHE']=='LINEAIRE' : para['PROL_GAUCHE']='EXCLU'
    if para['PROL_DROITE']=='LINEAIRE' : para['PROL_DROITE']='EXCLU'
    return t_fonction(self.vale_x,absolute(self.vale_y),para)

  def evalfonc(self,liste_val) :
    """renvoie la mm fonction interpol�e aux points d�finis par la liste 'liste_val'
    """
    return self.__class__(liste_val,map(self,liste_val),self.para)

  def sup(self,other) :
    """renvoie l'enveloppe sup�rieure de self et other
    """
    para=copy.copy(self.para)
    # commentaire : pour les prolongements et l'interpolation, c'est self
    # qui prime sur other
    vale_x=self.vale_x.tolist()+other.vale_x.tolist()
    # on ote les abscisses doublons
    vale_x=dict([(i,0) for i in vale_x]).keys()
    vale_x.sort()
    vale_x=array(vale_x)
    vale_y1=map(self, vale_x)
    vale_y2=map(other,vale_x)
    vale_y=map(max,vale_y1,vale_y2)
    return t_fonction(vale_x,vale_y,para)

  def inf(self,other) :
    """renvoie l'enveloppe inf�rieure de self et other
    """
    para=copy.copy(self.para)
    # commentaire : pour les prolongements et l'interpolation, c'est self
    # qui prime sur other
    vale_x=self.vale_x.tolist()+other.vale_x.tolist()
    # on ote les abscisses doublons
    vale_x=dict([(i,0) for i in vale_x]).keys()
    vale_x.sort()
    vale_x=array(vale_x)
    vale_y1=map(self, vale_x)
    vale_y2=map(other,vale_x)
    vale_y=map(min,vale_y1,vale_y2)
    return t_fonction(vale_x,vale_y,para)

  def suppr_tend(self) :
    """pour les corrections d'acc�l�rogrammes
    suppression de la tendance moyenne d'une fonction
    """
    para=copy.copy(self.para)
    xy=sum(self.vale_x*self.vale_y)
    x0=sum(self.vale_x)
    y0=sum(self.vale_y)
    xx=sum(self.vale_x*self.vale_x)
    n=len(self.vale_x)
    a1 = ( n*xy - x0*y0) / (n*xx - x0*x0)
    a0 = (xx*x0 - x0*xy) / (n*xx - x0*x0)
    return t_fonction(self.vale_x,self.vale_y-a1*self.vale_x-a0,self.para)

  def normel2(self) :
    """norme de la fonction
    """
    __ex=self*self
    __ex=__ex.trapeze(0.)
    return sqrt(__ex.vale_y[-1])

  def fft(self,methode) :
    """renvoie la transform�e de Fourier rapide FFT
    """
    import FFT
    para=copy.copy(self.para)
    para['NOM_PARA']='FREQ'
    if self.para['NOM_PARA']!='INST' :
       raise FonctionError, 'fonction r�elle : FFT : NOM_PARA=INST pour une transform�e directe'
    pas = self.vale_x[1]-self.vale_x[0]
    for i in range(1,len(self.vale_x)) :
        ecart = abs(((self.vale_x[i]-self.vale_x[i-1])-pas)/pas)
        if ecart>1.e-2 :
           raise FonctionError, 'fonction r�elle : FFT : la fonction doit etre � pas constant'
    n=int(log(len(self.vale_x))/log(2))
    if   methode=='TRONCATURE' :
       vale_y=self.vale_y[:2**n]
    elif methode=='PROL_ZERO'  :
       vale_y=self.vale_y.tolist()
       vale_y=vale_y+[0.]*(2**(n+1)-len(self.vale_x))
       vale_y=array(vale_y)
    elif   methode=='COMPLET'  : 
       vale_y=self.vale_y
    vect=FFT.fft(vale_y)
    pasfreq =1./(pas*(len(vect)-1))
    vale_x  =[pasfreq*i for i in range(len(vect))]
    vale_y  =vect*pas
    return t_fonction_c(vale_x,vale_y,para)

class t_fonction_c(t_fonction) :
  """Classe pour fonctions complexes, �quivalent au type aster = fonction_c
  """
  def tabul(self) :
    """mise en forme de la fonction selon un vecteur unique (x1,yr1,yi1,x2,yr2,yr2,...)
    """
    __tab=array([self.vale_x,self.vale_y.real,self.vale_y.imag])
    return ravel(transpose(__tab)).tolist()

  def __repr__(self) :
    """affichage de la fonction en double colonne
    """
    texte=[]
    for i in range(len(self.vale_x)) :
      texte.append('%f %f + %f .j' % (self.vale_x[i],self.vale_y[i].real,self.vale_y[i].imag))
    return '\n'.join(texte)

  def fft(self,methode,syme) :
    """renvoie la transform�e de Fourier rapide FFT (sens inverse)
    """
    import FFT
    para=copy.copy(self.para)
    para['NOM_PARA']='INST'
    if self.para['NOM_PARA']!='FREQ' :
       raise FonctionError, 'fonction complexe : FFT : NOM_PARA=FREQ pour une transform�e directe'
    pas = self.vale_x[1]-self.vale_x[0]
    for i in range(1,len(self.vale_x)) :
        ecart = abs(((self.vale_x[i]-self.vale_x[i-1])-pas)/pas)
        if ecart>1.e-3 :
           raise FonctionError, 'fonction complexe : FFT : la fonction doit etre � pas constant'
    n=int(log(len(self.vale_x))/log(2))
    if   syme=='OUI' and len(self.vale_x)==2**n :
       vale_fonc=self.vale_y
    elif syme=='NON' and len(self.vale_x)==2**n :
       vale_fonc=self.vale_y.tolist()
       vale_fon1=vale_fonc[:]
       vale_fon1.reverse()
       vale_fonc=vale_fonc+vale_fon1
       vale_fonc=array(vale_fonc)
    elif syme=='NON' and len(self.vale_x)!=2**n and methode=='PROL_ZERO' :
       vale_fonc=self.vale_y.tolist()+[complex(0.)]*(2**(n+1)-len(self.vale_x))
       vale_fon1=vale_fonc[:]
       vale_fon1.reverse()
       vale_fonc=vale_fonc+vale_fon1
       vale_fonc=array(vale_fonc)
    elif syme=='NON' and len(self.vale_x)!=2**n and methode=='TRONCATURE' :
       vale_fonc=self.vale_y[:2**n]
       vale_fonc=vale_fonc.tolist()
       vale_fon1=vale_fonc[:]
       vale_fon1.reverse()
       vale_fonc=vale_fonc+vale_fon1
       vale_fonc=array(vale_fonc)
    if   syme=='OUI' and methode!='COMPLET' and  len(self.vale_x)!=2**n :
       raise FonctionError, 'fonction complexe : FFT : syme=OUI et nombre de points<>2**n'
    if  methode!='COMPLET' :
       part1=vale_fonc[:len(vale_fonc)/2+1]
       part2=vale_fonc[1:len(vale_fonc)/2]
    if methode=='COMPLET' :
       mil=int(len(self.vale_x)/2)
       mil2=int((len(self.vale_x)+1)/2)
       vale_fonc=self.vale_y
       if syme=='OUI' : 
          mil=int(len(self.vale_x)/2)
          mil2=int((len(self.vale_x)+1)/2)
       elif syme=='NON' : 
          part2=vale_fonc[1:-1]
          part2=part2.tolist()
          part2.reverse()
          vale_fonc=array(vale_fonc.tolist()+part2)
          mil=int(len(self.vale_x)/2)*2
          mil2=int((len(self.vale_x)+1)/2)*2-1
       part1=vale_fonc[:mil+1]
       part2=vale_fonc[1:mil2]
    part2=conjugate(part2)
    part2=part2.tolist()
    part2.reverse()
    vale_fonc=array(part1.tolist()+part2)
    vect=FFT.inverse_fft(vale_fonc)
    vect=vect.real
    pasfreq =1./(pas*(len(vect)-1))
    vale_x  =[pasfreq*i for i in range(len(vect))]
    pas2    =(1./self.vale_x[-1])*((len(self.vale_x))/float(len(vect)))
    vale_y  =vect/pas2
    return t_fonction(vale_x,vale_y,para)


class t_nappe :
  """Classe pour nappes, �quivalent au type aster = nappe_sdaster
  """
  def __init__(self,vale_para,l_fonc,para) :
    """Cr�ation d'un objet nappe
    - vale_para est la liste de valeur des parametres (mot cl� PARA dans DEFI_NAPPE)
    - para est un dictionnaire contenant les entr�es PROL_DROITE, PROL_GAUCHE et INTERPOL (cf sd ASTER)
    - l_fonc est la liste des fonctions, de cardinal �gal � celui de vale_para
    """
    pk=para.keys()
    pk.sort()
    if pk!=['INTERPOL','NOM_PARA','NOM_PARA_FONC','NOM_RESU','PROL_DROITE','PROL_GAUCHE'] :
         raise FonctionError, 'nappe : parametres incorrects'
    if para['INTERPOL'] not in [['NON','NON'],['LIN','LIN'],
                                ['LIN','LOG'],['LOG','LOG'],['LOG','LIN'],] :
         raise FonctionError, 'nappe : parametre INTERPOL incorrect'
    if para['PROL_DROITE'] not in ['EXCLU','CONSTANT','LINEAIRE'] :
         raise FonctionError, 'nappe : parametre PROL_DROITE incorrect'
    if para['PROL_GAUCHE'] not in ['EXCLU','CONSTANT','LINEAIRE'] :
         raise FonctionError, 'nappe : parametre PROL_GAUCHE incorrect'
    self.vale_para    = array(vale_para)
    if type(l_fonc) not in (types.ListType,types.TupleType) :
         raise FonctionError, 'nappe : la liste de fonctions fournie n est pas une liste'
    if len(l_fonc)!=len(vale_para) :
         raise FonctionError, 'nappe : nombre de fonctions diff�rent du nombre de valeurs du param�tre'
    for f in l_fonc :
      if not isinstance(f,t_fonction) and not isinstance(f,t_fonction_c) :
         raise FonctionError, 'nappe : les fonctions fournies ne sont pas du bon type'
    self.l_fonc       = l_fonc
    self.para         = para

  def __call__(self,val1,val2):
    """m�thode pour �valuer nappe(val1,val2)
    """
    i=searchsorted(self.vale_para,val1)
    n=len(self.vale_para)
    if i==0 :
      if val1==self.vale_para[0]  : return self.l_fonc[0](val2)
      if val1 <self.vale_para[0]  : 
         if self.para['PROL_GAUCHE']=='EXCLU'    : raise FonctionError, 'nappe �valu�e hors du domaine de d�finition'
         if self.para['PROL_GAUCHE']=='CONSTANT' : return self.l_fonc[0](val2)
         if self.para['PROL_GAUCHE']=='LINEAIRE' : return interp(self.para['INTERPOL'],val1,
                                                                 self.vale_para[0],
                                                                 self.vale_para[1],
                                                                 self.l_fonc[0](val2),
                                                                 self.l_fonc[1](val2))
    elif i==n :
      if val1==self.vale_para[-1] : return self.l_fonc[-1](val2)
      if val1 >self.vale_para[-1]  : 
         if self.para['PROL_DROITE']=='EXCLU'    : raise FonctionError, 'nappe �valu�e hors du domaine de d�finition'
         if self.para['PROL_DROITE']=='CONSTANT' : return self.l_fonc[-1](val2)
         if self.para['PROL_DROITE']=='LINEAIRE' : return interp(self.para['INTERPOL'],val1,
                                                                 self.vale_para[-1],
                                                                 self.vale_para[-2],
                                                                 self.l_fonc[-1](val2),
                                                                 self.l_fonc[-2](val2))
    else :
      return interp(self.para['INTERPOL'],val1,self.vale_para[i-1],
                                               self.vale_para[i],
                                               self.l_fonc[i-1](val2),
                                               self.l_fonc[i](val2))

  def evalfonc(self, liste_val) :
    """Renvoie la mm nappe dont les fonctions sont interpol�es aux points d�finis
    par la liste 'liste_val'.
    """
    l_fonc = []
    for f in self.l_fonc:
      f2 = f.evalfonc(liste_val)
      l_fonc.append(f2)
    return t_nappe(self.vale_para, l_fonc, self.para)

  def __add__(self,other) :
    """addition avec une autre nappe ou un nombre, par surcharge de l'op�rateur +
    """
    l_fonc=[]
    if   isinstance(other,t_nappe):
      if self.vale_para!=other.vale_para : raise FonctionError, 'nappes � valeurs de param�tres diff�rentes'
      for i in range(len(self.l_fonc)) : l_fonc.append(self.l_fonc[i]+other.l_fonc[i])
    elif type(other) in [types.FloatType,types.IntType] :
      for i in range(len(self.l_fonc)) : l_fonc.append(self.l_fonc[i]+other)
    else:  raise FonctionError, 't_nappe : erreur de type dans __add__'
    return t_nappe(self.vale_para,l_fonc,self.para)

  def __mul__(self,other) :
    """multiplication avec une autre fonction ou un nombre, par surcharge de l'op�rateur *
    """
    l_fonc=[]
    if   isinstance(other,t_nappe):
      if self.vale_para!=other.vale_para : raise FonctionError, 'nappes � valeurs de param�tres diff�rentes'
      for i in range(len(self.l_fonc)) : l_fonc.append(self.l_fonc[i]*other.l_fonc[i])
    elif type(other) in [types.FloatType,types.IntType] :
      for i in range(len(self.l_fonc)) : l_fonc.append(self.l_fonc[i]*other)
    else:  raise FonctionError, 't_nappe : erreur de type dans __mul__'
    return t_nappe(self.vale_para,l_fonc,self.para)

  def __repr__(self) :
    """affichage de la nappe en double colonne
    """
    texte=[]
    for i in range(len(self.vale_para)) :
      texte.append('param�tre : %f' % self.vale_para[i])
      texte.append(repr(self.l_fonc[i]))
    return '\n'.join(texte)

  def homo_support(self,other) :
    """Renvoie la nappe self avec un support union de celui de self et de other
    le support est la discr�tisation vale_para et les discr�tisations des fonctions
    """
    if self==other : return self
    if self.para!=other.para : raise FonctionError, 'combinaison de nappes � caract�ristiques interpolation et prolongement diff�rentes'
    vale_para=self.vale_para.tolist()+other.vale_para.tolist()
    vale_para=dict([(i,0) for i in vale_para]).keys()
    vale_para.sort()
    vale_para=array(vale_para)
    l_fonc=[]
    for val in vale_para :
        if   val in self.vale_para  : l_fonc.append(self.l_fonc[searchsorted(self.vale_para,val)])
        elif val in other.vale_para :
                                      other_fonc=other.l_fonc[searchsorted(other.vale_para,val)]
                                      new_vale_x=other_fonc.vale_x
                                      new_para  =other_fonc.para
                                      new_vale_y=[self(x) for x in new_vale_x]
                                      if isinstance(other_fonc,t_fonction)   :
                                               l_fonc.append(t_fonction(new_vale_x,new_vale_y,new_para))
                                      if isinstance(other_fonc,t_fonction_c) :
                                               l_fonc.append(t_fonction_c(new_vale_x,new_vale_y,new_para))
        else : raise FonctionError, 'combinaison de nappes : incoh�rence'
    return t_nappe(vale_para,l_fonc,self.para)

  def extreme(self) :
    """renvoie un dictionnaire des valeurs d'ordonn�es min et max
    """
    val_min=min([min(fonc.vale_y) for fonc in self.l_fonc])
    val_max=max([max(fonc.vale_y) for fonc in self.l_fonc])
    vm={'min':[],'max':[]}
    for i in range(len(self.vale_para)) :
        for j in range(len(self.l_fonc[i].vale_y)) :
          y = self.l_fonc[i].vale_y[j]
          if y==val_min : vm['min'].append([y,self.l_fonc[i].vale_x[j],self.vale_para[i]])
          if y==val_max : vm['max'].append([y,self.l_fonc[i].vale_x[j],self.vale_para[i]])
    vm['min'].sort()
    vm['max'].sort()
    for item in vm['min'] : item.reverse()
    for item in vm['max'] : item.reverse()
    return vm
