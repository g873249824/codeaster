'''Catalogue des champs de resultats Aster'''

from Cata.cata import *


class CHAMP :

  '''Informations sur les champs'''
   

  def Calc_no(champ, contexte, numeros) :

    para = {
      'reuse'	   : contexte.resultat,
      'RESULTAT'   : contexte.resultat,
      'MODELE'     : contexte.modele,
      'OPTION'     : champ.nom,
      'CHAM_MATER' : contexte.cham_mater,
      'NUME_ORDRE' : tuple(numeros)
      }
    
    if contexte.cara_elem :
      para['CARA_ELEM'] = contexte.cara_elem
  
    apply(CALC_NO,(),para)


  def Calc_elem(champ, contexte, numeros) :

    para = {
      'reuse'	   : contexte.resultat,
      'RESULTAT'   : contexte.resultat,
      'MODELE'     : contexte.modele,
      'OPTION'     : champ.nom,
      'CHAM_MATER' : contexte.cham_mater,
      'NUME_ORDRE' : tuple(numeros)
      }
    
    if contexte.cara_elem :
      para['CARA_ELEM'] = contexte.cara_elem
  
    apply(CALC_ELEM,(),para)


  def __init__(self, nom_cham, type_cham, heredite, comment, fonc) :
   
    assert type_cham in ['ELNO','ELGA','NOEU']

    self.nom      = nom_cham
    self.type     = type_cham 
    self.heredite = heredite
    self.comment  = comment

    if fonc :
      self.fonc = fonc
    else : 
      if type_cham == 'NOEU' :  self.fonc = CHAMP.Calc_no
      if type_cham == 'ELNO' :  self.fonc = CHAMP.Calc_elem
      if type_cham == 'ELGA' :  self.fonc = CHAMP.Calc_elem
        

  def Evalue(self, contexte, numeros) :
  
    self.fonc(self, contexte, numeros)
    

    	
# ----------------------------------------------------------------------


class CATA_CHAMPS :

  '''Base de connaissance sur les champs traitables'''
  
  
  def __init__(self) :
  
    self.cata = {}
    self('DEPL'          , 'NOEU',[],                            "Deplacements aux noeuds")
    self('TEMP'          , 'NOEU',[],                            "Temperature aux noeuds")
    self('SIEF_ELGA'     , 'ELGA',[],                            "Contraintes aux points de Gauss")
    self('VARI_ELGA'     , 'ELGA',[],                            "Variables internes aux points de Gauss")
    self('SIEF_ELNO_ELGA', 'ELNO',['SIEF_ELGA','SIEF_ELGA_DEPL'],"Contraintes aux noeuds par element")
    self('FLUX_ELNO_TEMP', 'ELNO',['TEMP']                      ,"Flux thermique aux noeuds par element")
    self('VARI_ELNO_ELGA', 'ELNO',['VARI_ELGA'],                 "Variables internes aux noeuds par element")
    self('EQUI_ELGA_SIGM', 'ELGA',['SIEF_ELGA'],	             "Invariants des contraintes aux points de Gauss")
    self('EQUI_ELNO_SIGM', 'ELNO',['SIEF_ELNO_ELGA'],            "Invariants des contraintes aux noeuds par element")
    self('EPSI_ELGA_DEPL', 'ELGA',['DEPL'],	                     "Deformations aux points de Gauss")
    self('EPSI_ELNO_DEPL', 'ELNO',['DEPL'],	                     "Deformations aux noeuds par elements")
    self('EPSG_ELGA_DEPL', 'ELGA',['DEPL'],	                     "Deformations de Green aux points de Gauss")
    self('EPSG_ELNO_DEPL', 'ELNO',['DEPL'],	                     "Deformations de Green aux noeuds par elements")
    self('EPME_ELNO_DEPL', 'ELNO',['DEPL'],	                     "Deformations mecaniques aux noeuds par elements")
    self('EQUI_ELGA_EPSI', 'ELGA',['EPSI_ELGA_DEPL'],            "Invariants des deformations aux points de Gauss")
    self('EQUI_ELNO_EPSI', 'ELNO',['EPSI_ELNO_DEPL'],            "Invariants des deformations aux noeuds par element")
    self('ERRE_ELGA_NORE', 'ELGA',['SIEF_ELNO_ELGA'],            "Indicateurs d'erreur en residu aux points de Gauss")
    self('ERRE_ELNO_ELGA', 'ELNO',['ERRE_ELGA_NORE'],            "Indicateurs d'erreur en residu aux noeuds par element")
    self('FORC_NODA'     , 'NOEU',['SIEF_ELGA'],                 "Forces nodales")
    
     
  def __getitem__(self, nom_cham) :
       
    return self.cata[nom_cham]
  
  
  def __call__(self,nom_cham,type_cham,heredite, comment, fonc = None) :
      
    self.cata[nom_cham] = CHAMP(nom_cham, type_cham, heredite, comment, fonc)
  
  
  def Champs_presents(self) :
    
    return self.cata.keys()




