#@ MODIF lire_fonction_ops Macro  DATE 30/11/2004   AUTEUR MCOURTOI M.COURTOIS 
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

import string,os,Numeric

# ------------------------------------------------------------------------------
def m_format_libre(texte,INDIC_PARA,INDIC_RESU,SEPAR):
  """M�thode de construction du VALE pour le format libre
  format LIBRE
  Les lignes contenant autre chose que des s�quences de nombres
  r�els et de s�parateurs sont consid�r�es comme d�limitant deux
  fonctions diff�rentes. Cette situation correspond � l exception
  ValueError lev�e par le map de float. Le deuxieme indice de
  INDIC_PARA et INDIC_RESU est l indice permettant de pointer sur la
  fonction voulue, au sens de ce d�coupage.
  """

  from Utilitai.transpose import transpose
  l_fonc=[]
  fonc  =[]
  ier   =0
  if SEPAR=='None' : SEPAR=None
  for line in texte :
     try :
            if string.strip(line)=='' : raise ValueError
            fonc.append(map(float,string.split(line,SEPAR)))
     except ValueError:
            if fonc==[] : pass  # dans ce cas, on a plusieurs lignes d�limitant 2 fonctions
            else        :
                          l_fonc.append(Numeric.array(fonc))
                          fonc=[]
  if fonc!=[] :
     l_fonc.append(Numeric.array(fonc))

  # v�rifications de coh�rences lignes et colonnes
  ind_para=[INDIC_PARA[0]-1,INDIC_PARA[1]-1]
  ind_resu=[INDIC_RESU[0]-1,INDIC_RESU[1]-1]
  if INDIC_PARA[0]>len(l_fonc) :
     ier=ier+1
     message=        "<F> <LIRE_FONCTION> INDIC_PARA :le nombre de blocs de fonctions dans "
     message=message+"le fichier est inf�rieur � "+str(INDIC_PARA[0])
     return ier,message,[]
  if INDIC_RESU[0]>len(l_fonc) :
     ier=ier+1
     message=        "<F> <LIRE_FONCTION> INDIC_RESU :le nombre de blocs de fonctions dans "
     message=message+"le fichier est inf�rieur � "+str(INDIC_RESU[0])
     return ier,message,[]
  if INDIC_PARA[1]>len(l_fonc[ind_para[0]]) :
     ier=ier+1
     message=        "<F> <LIRE_FONCTION> INDIC_PARA :la fonction num�ro "
     message=message+str(INDIC_PARA[0])
     message=message+" ne comporte que "+str(l_fonc[INDIC_PARA[0]])+" colonnes"
     return ier,message,[]
  if INDIC_RESU[1]>len(l_fonc[ind_resu[0]]) :
     ier=ier+1
     message=        "<F> <LIRE_FONCTION> INDIC_RESU :la fonction num�ro "
     message=message+str(INDIC_RESU[0])
     message=message+" ne comporte que "+str(l_fonc[INDIC_RESU[0]])+" colonnes"
     return ier,message,[]

  # construction du VALE de la fonction par recherche des indices
  # de colonnes et de fonctions dans le tableau l_fonc
  vale_1=l_fonc[ind_para[0]][:,ind_para[1]]
  vale_2=l_fonc[ind_resu[0]][:,ind_resu[1]]
  if len(vale_1)!=len(vale_2) :
     ier=ier+1
     message=        "<F> <LIRE_FONCTION> INDIC_RESU :les deux colonnes demand�es "
     message=message+" pour INDIC_PARA et INDIC_RESU n ont pas la meme longueur :"
     message=message+str(len(vale_1))+" et "+str(len(vale_2))
     return ier,message,[]
  liste_vale=transpose([vale_1,vale_2])
  def add(x,y):return x+y
  liste_vale=reduce(add,liste_vale)
  return ier,'',liste_vale

# ------------------------------------------------------------------------------
def liste_simple(texte,INDIC_PARA,SEPAR):
  """recherche d'une liste simple
  """
  # format LIBRE
  # liste simple

  l_fonc=[]
  fonc  =[]
  ier   =0
  if SEPAR=='None' : SEPAR=None
  for line in texte :
     try :
            if string.strip(line)=='' : raise ValueError
            fonc.append(map(float,string.split(line,SEPAR)))
     except ValueError:
            if fonc==[] : pass  # dans ce cas, on a plusieurs lignes d�limitant 2 fonctions
            else        :
                          l_fonc.append(Numeric.array(fonc))
                          fonc=[]
  if fonc!=[] :
     l_fonc.append(Numeric.array(fonc))

  # v�rifications de coh�rences lignes et colonnes
  ind_para=[INDIC_PARA[0]-1,INDIC_PARA[1]-1]
  if INDIC_PARA[0]>len(l_fonc) :
     ier=ier+1
     message=        "<F> <LIRE_FONCTION> INDIC_PARA :le nombre de blocs de fonctions dans "
     message=message+"le fichier est inf�rieur � "+str(INDIC_PARA[0])
     return ier,message,[]
  if INDIC_PARA[1]>len(l_fonc[ind_para[0]]) :
     ier=ier+1
     message=        "<F> <LIRE_FONCTION> INDIC_PARA :la fonction num�ro "
     message=message+str(INDIC_PARA[0])
     message=message+" ne comporte que "+str(l_fonc[INDIC_PARA[0]])+" colonnes"
     self.cr.fatal(message)
     return ier,message,[]

  # construction du VALE de la fonction par recherche des indices
  # de colonnes et de fonctions dans le tableau l_fonc
  vale_1=l_fonc[ind_para[0]][:,ind_para[1]]
  return ier,'',vale_1.tolist()

# ------------------------------------------------------------------------------
def lire_fonction_ops(self,FORMAT,TYPE,SEPAR,INDIC_PARA,UNITE,
                      NOM_PARA,NOM_RESU,INTERPOL,PROL_DROITE,
                      PROL_GAUCHE,VERIF,INFO,TITRE,**args):
  """M�thode corps de la macro
  """
  ier=0

  from Accas import _F
# On recopie le mot cle defi_fonction pour le proteger
  if TYPE=='NAPPE' :
     mc_DEFI_FONCTION=args['DEFI_FONCTION']

  # On importe les definitions des commandes a utiliser dans la macro
  DEFI_FONCTION  =self.get_cmd('DEFI_FONCTION')
  DEFI_NAPPE     =self.get_cmd('DEFI_NAPPE')

  # La macro compte pour 1 dans la numerotation des commandes
  self.set_icmd(1)

  # Lecture de la fonction dans un fichier d unit� logique UNITE
  
  file="./fort."+str(UNITE)
  if not os.path.isfile(file) :
     ier=ier+1
     self.cr.fatal("<F> <LIRE_FONCTION> le fichier d unit� logique "+str(UNITE)+" est introuvable")
     return ier
  file=open(file,'r')
  texte=file.readlines()
  file.close()

  self.DeclareOut('ut_fonc',self.sd)

  if   TYPE=='FONCTION':
    # mise en forme de la liste de valeurs suivant le format choisi :
    ier,message,liste_vale=m_format_libre(texte,INDIC_PARA,args['INDIC_RESU'],SEPAR)
    if ier!=0 :
       self.cr.fatal(message)
       return ier

    # cr�ation de la fonction ASTER :
    ut_fonc=DEFI_FONCTION( NOM_PARA   =NOM_PARA,
                           NOM_RESU   =NOM_RESU,
                           PROL_DROITE=PROL_DROITE,
                           PROL_GAUCHE=PROL_GAUCHE,
                           INTERPOL   =INTERPOL,
                           INFO       =INFO,
                           TITRE      =TITRE,
                           VERIF      =VERIF,
                           VALE       =liste_vale,)

  elif TYPE=='FONCTION_C':
    # mise en forme de la liste de valeurs suivant le format choisi :
    if 'INDIC_REEL' in args :
                              indic1=args['INDIC_REEL']
                              indic2=args['INDIC_IMAG']
    if 'INDIC_MODU' in args :
                              indic1=args['INDIC_MODU']
                              indic2=args['INDIC_PHAS']
    ier,message,liste_vale_r=m_format_libre(texte,INDIC_PARA,indic1,SEPAR)
    if ier!=0 :
       self.cr.fatal(message)
       return ier
    ier,message,liste_vale_i=m_format_libre(texte,INDIC_PARA,indic2,SEPAR)
    if ier!=0 :
       self.cr.fatal(message)
       return ier
    liste=[]
    if   'INDIC_REEL' in args :
      for i in range(len(liste_vale_r)/2) :
        liste=liste+[liste_vale_r[2*i],liste_vale_r[2*i+1],liste_vale_i[2*i+1]]
    elif 'INDIC_MODU' in args :
      for i in range(len(liste_vale_r)/2) :
        module=liste_vale_r[2*i+1]
        phase =liste_vale_i[2*i+1]
        liste=liste+[liste_vale_r[2*i],module*cos(phase),module*sin(phase)]

    # cr�ation de la fonction ASTER :
    ut_fonc=DEFI_FONCTION( NOM_PARA   =NOM_PARA,
                           NOM_RESU   =NOM_RESU,
                           PROL_DROITE=PROL_DROITE,
                           PROL_GAUCHE=PROL_GAUCHE,
                           INTERPOL   =INTERPOL,
                           INFO       =INFO,
                           TITRE      =TITRE,
                           VERIF      =VERIF,
                           VALE_C     =liste,)

  elif TYPE=='NAPPE':

    # cr�ation de la nappe ASTER :
    motscles={}
    motscles['DEFI_FONCTION']=[]
    for elem in mc_DEFI_FONCTION:
       ier,message,liste_vale=m_format_libre(texte,args['INDIC_ABSCISSE'],elem['INDIC_RESU'],SEPAR)
       if ier!=0 :
          self.cr.fatal(message)
          return ier
       motscles['DEFI_FONCTION'].append( _F( VALE       =liste_vale,
                                             INTERPOL   =args['INTERPOL_FONC'],
                                             PROL_DROITE=args['PROL_DROITE_FONC'],
                                             PROL_GAUCHE=args['PROL_GAUCHE_FONC']  ) ) 
    ier,message,liste_para=liste_simple(texte,INDIC_PARA,SEPAR)
    if ier!=0 :
       self.cr.fatal(message)
       return ier
    ut_fonc=DEFI_NAPPE( PARA            =liste_para,
                        NOM_PARA        =NOM_PARA,
                        NOM_PARA_FONC   =args['NOM_PARA_FONC'],
                        NOM_RESU        =NOM_RESU,
                        PROL_DROITE     =PROL_DROITE,
                        PROL_GAUCHE     =PROL_GAUCHE,
                        INTERPOL        =INTERPOL,
                        INFO            =INFO,
                        TITRE           =TITRE,
                        VERIF           =VERIF,
                        **motscles)

  return ier
