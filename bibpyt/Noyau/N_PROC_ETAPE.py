#@ MODIF N_PROC_ETAPE Noyau  DATE 20/01/2003   AUTEUR DURAND C.DURAND 
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
    Ce module contient la classe PROC_ETAPE qui sert � v�rifier et � ex�cuter
    une proc�dure
"""

# Modules Python
import types,sys,string
import traceback

# Modules EFICAS
import N_MCCOMPO, N_ETAPE
from N_Exception import AsException
import N_utils

class PROC_ETAPE(N_ETAPE.ETAPE):
   """
      Cette classe h�rite de ETAPE. La seule diff�rence porte sur le fait
      qu'une proc�dure n'a pas de concept produit

   """
   nature = "PROCEDURE"
   def __init__(self,oper=None,args={}):
      """
         Attributs :

          - definition : objet portant les attributs de d�finition d'une �tape de type op�rateur. Il
                         est initialis� par l'argument oper.

          - valeur : arguments d'entr�e de type mot-cl�=valeur. Initialis� avec l'argument args.

      """
      self.definition=oper
      self.valeur=args
      self.nettoiargs()
      self.parent=CONTEXT.get_current_step()
      self.etape = self
      self.nom=oper.nom
      self.idracine=oper.label
      self.appel=N_utils.callee_where()
      self.mc_globaux={}
      self.sd=None
      self.actif=1
      self.make_register()

   def make_register(self):
      """
         Initialise les attributs jdc, id, niveau et r�alise les enregistrements
         n�cessaires
      """
      if self.parent :
         self.jdc = self.parent.get_jdc_root()
         self.id=self.parent.register(self)
         self.niveau=None
      else:
         self.jdc = self.parent =None
         self.id=None
         self.niveau=None

   def McBuild(self):
      """
         Demande la construction des sous-objets et les stocke dans l'attribut
         mc_liste.
      """
      self.mc_liste=self.build_mc()

   def Build_sd(self):
      """
          Cette methode applique la fonction op_init au contexte du parent
          et lance l'ex�cution en cas de traitement commande par commande
          Elle doit retourner le concept produit qui pour une PROC est toujours None
          En cas d'erreur, elle leve une exception : AsException ou EOFError
      """
      if not self.isactif():return
      try:
         if self.parent:
            if type(self.definition.op_init) == types.FunctionType: 
               apply(self.definition.op_init,(self,self.parent.g_context))
         else:
            pass
         if self.jdc.par_lot == "NON" :
            self.Execute()
      except AsException,e:
        raise AsException("Etape ",self.nom,'ligne : ',self.appel[0],
                              'fichier : ',self.appel[1],e)
      except EOFError:
        raise
      except :
        l=traceback.format_exception(sys.exc_info()[0],sys.exc_info()[1],sys.exc_info()[2])
        raise AsException("Etape ",self.nom,'ligne : ',self.appel[0],
                          'fichier : ',self.appel[1]+'\n',
                          string.join(l))

   def supprime(self):
      """
         M�thode qui supprime toutes les r�f�rences arri�res afin que l'objet puisse
         etre correctement d�truit par le garbage collector
      """
      N_MCCOMPO.MCCOMPO.supprime(self)
      self.jdc=None
      self.appel=None

   def accept(self,visitor):
      """
         Cette methode permet de parcourir l'arborescence des objets
         en utilisant le pattern VISITEUR
      """
      visitor.visitPROC_ETAPE(self)

   def update_context(self,d):
      """
         Met � jour le contexte de l'appelant pass� en argument (d)
         Une PROC_ETAPE n ajoute pas directement de concept dans le contexte
         Seule une fonction enregistree dans op_init pourrait le faire
      """
      if type(self.definition.op_init) == types.FunctionType:
        apply(self.definition.op_init,(self,d))



