#@ MODIF lire_inte_spec_ops Macro  DATE 20/09/2004   AUTEUR DURAND C.DURAND 
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

def lire_inte_spec_ops(self,UNITE,FORMAT,NOM_PARA,NOM_RESU,INTERPOL,
                            PROL_DROITE,PROL_GAUCHE,TITRE,INFO,**args):
  ier=0

  from Accas import _F
  import os
  from math import cos,sin
  # On importe les definitions des commandes a utiliser dans la macro
  DEFI_FONCTION  =self.get_cmd('DEFI_FONCTION')
  CREA_TABLE     =self.get_cmd('CREA_TABLE')

  # La macro compte pour 1 dans la numerotation des commandes
  self.set_icmd(1)

  # Lecture de la fonction dans un fichier d unit� logique UNITE
  
  file="./fort."+str(UNITE)
  if not os.path.isfile(file) :
     ier=ier+1
     self.cr.fatal("<F> <LIRE_INTE_SPEC> le fichier d unit� logique "+str(UNITE)+" est introuvable")
     return ier
  file=open(file,'r')
  texte=file.read()
  file.close()
  
  list_fonc=texte.split('FONCTION_C')
  entete=list_fonc.pop(0)
  try : 
    entete=entete[entete.index('DIM'):]
    dim=int(entete[entete.index('=')+1:entete.index('\n')])
  except ValueError : 
    ier=ier+1
    self.cr.fatal("<F> <LIRE_INTE_SPEC> la dimension DIM n est pas pr�cis�e dans le fichier lu")
    return ier

  if len(list_fonc)!=(dim*(dim+1)/2):
    ier=ier+1
    self.cr.fatal("<F> <LIRE_INTE_SPEC> nombre de fonctions incorrect")
    return ier

  nume_i=[]
  nume_j=[]
  l_fonc=[]
  for i in range(dim*(dim+1)/2):
    numi=list_fonc[i][list_fonc[i].index('I =')+3:]
    numi=numi[:numi.index('\n')]
    nume_i.append(int(numi))
    numj=list_fonc[i][list_fonc[i].index('J =')+3:]
    numj=numj[:numj.index('\n')]
    nume_j.append(int(numj))
    try : 
      vale_fonc=list_fonc[i][list_fonc[i].index('VALEUR =\n')+9:list_fonc[i].index('FINSF\n')]
      vale_fonc=vale_fonc.replace('\n',' ')
      vale_fonc=map(float,vale_fonc.split())
    except ValueError : 
      ier=ier+1
      self.cr.fatal("<F> <LIRE_INTE_SPEC> erreur dans les donn�es de fonctions")
      return ier

    liste=[]
    if   FORMAT=='REEL_IMAG':
      liste=vale_fonc
    elif FORMAT=='MODULE_PHASE':
      for i in range(len(vale_fonc)/3) :
        module=vale_fonc[3*i+1]
        phase =vale_fonc[3*i+2]
        liste=liste+[vale_fonc[3*i],module*cos(phase),module*sin(phase)]

    # cr�ation de la fonction ASTER :
    _fonc=DEFI_FONCTION( NOM_PARA   =NOM_PARA,
                         NOM_RESU   =NOM_RESU,
                         PROL_DROITE=PROL_DROITE,
                         PROL_GAUCHE=PROL_GAUCHE,
                         INTERPOL   =INTERPOL,
                         INFO       =INFO,
                         TITRE      =TITRE,
                         VALE_C     =liste,)
    l_fonc.append(_fonc.nom)

  nume_ib=[]
  nume_jb=[]
  for i in range(dim):
    for j in range(i,dim):
      nume_ib.append(i+1)
      nume_jb.append(j+1)
  if nume_i!=nume_ib or nume_j!=nume_jb : 
      ier=ier+1
      self.cr.fatal("<F> <LIRE_INTE_SPEC> erreur dans les indices")
      return ier
  mcfact=[]
  mcfact.append(_F(PARA='NOM_CHAM'    ,LISTE_K=(NOM_RESU),NUME_LIGN=(1,)))
  mcfact.append(_F(PARA='OPTION'      ,LISTE_K=('TOUT',) ,NUME_LIGN=(1,)))
  mcfact.append(_F(PARA='DIMENSION'   ,LISTE_I=(dim,)    ,NUME_LIGN=(1,)))
  mcfact.append(_F(PARA='NUME_ORDRE_I',LISTE_I=nume_i    ,NUME_LIGN=range(2,len(nume_i)+2)))
  mcfact.append(_F(PARA='NUME_ORDRE_J',LISTE_I=nume_j    ,NUME_LIGN=range(2,len(nume_j)+2)))
  mcfact.append(_F(PARA='FONCTION'    ,LISTE_K=l_fonc    ,NUME_LIGN=range(2,len(list_fonc)+2)))
  self.DeclareOut('tab_inte',self.sd)
  tab_inte=CREA_TABLE(TYPE_TABLE='TABL_INTE_SPEC',
                      LISTE=mcfact,
                      TITRE=TITRE,)

  return ier
