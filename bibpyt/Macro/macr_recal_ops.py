#@ MODIF macr_recal_ops Macro  DATE 31/01/2003   AUTEUR PABHHHH N.TARDIEU 
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
# ======================================================================

def macr_recal_ops(self,UNITE_ESCL, RESU_EXP, LIST_PARA, RESU_CALC, 
                        ITER_MAXI, RESI_GLOB_RELA,UNITE_RESU,PARA_DIFF_FINI,
                        GRAPHIQUE, **args ):
   """Macro commande r�alisant le recalage de mod�les Aster""",
   # Initialisation du compteur d'erreurs
   ier=0
   # On essaie d'importer Numeric -> ERREUR FATALE
   try:
     import Numeric
   except ImportError:
     ier=ier+1
     self.cr.fatal("Le module Numeric de Python n'a pu etre charg�")
     return ier
   # On essaie d'importer Gnuplot -> PAS DE GRAPHIQUE
   try:
     import Gnuplot
     gnuplot=1
   except ImportError:
     gnuplot=0
   import string
   import copy
   import types
   import Macro
   import Cata
   from Cata import cata
   from Macro.recal import gestion,transforme_list_Num,EXTRACT,calcul_F
   from Macro.reca_message import *
   from Macro.reca_algo    import *
   from Macro.reca_interp  import *
   # La macro compte pour 1 dans l'execution des commandes
   #self.icmd=1
   self.set_icmd(1)

   self.DeclareOut('nomres',self.sd)

   #_____________________________________________
   #
   # GESTION DES ERREURS DE SYNTAXE
   #_____________________________________________
   texte_erreur = gestion(UNITE_ESCL,LIST_PARA,RESU_CALC,RESU_EXP,GRAPHIQUE,UNITE_RESU)
   if (texte_erreur != ""):
      ier=ier+1
      self.cr.fatal(texte_erreur)
      return ier

   #_____________________________________________
   #
   # DECLARATION DE TOUTES LES COMMANDES ASTER
   #_____________________________________________
   for k,v in cata.__dict__.items() :
     if type(v)==types.InstanceType:
        if v.__class__.__name__ in ('OPER','MACRO'):
           self.current_context[k]= v
   self.current_context['_F']=cata.__dict__['_F']
   self.g_context['EXTRACT']=EXTRACT

   #_____________________________________________
   #
   # INITIALISATIONS
   #_____________________________________________
   iter = 0
   restant,temps_iter=0.,0.
   restant,temps_iter,err=temps_CPU(self,restant,temps_iter)
   para,val,borne_inf,borne_sup = transforme_list_Num(LIST_PARA,RESU_EXP)
   val_init = copy.copy(val)
   L_init = calcul_F(self,UNITE_ESCL,para,val,RESU_CALC)
   #instance de la classe g�rant l'affichage des resultats du calcul de l'optimisation
   Mess = Message(para,RESU_EXP,copy.copy(val_init),UNITE_RESU) 
   #instances des classes pour le calcul de l'erreur et le dimensionnemnt/adim
   Simul = Sim_exp(RESU_EXP)
   Dim = Dimension(copy.copy(val_init),para)
   L_J_init,erreur = Simul.multi_interpole(L_init, RESU_CALC)
   J_init = Simul.norme_J(copy.copy(L_J_init),copy.copy(L_J_init),UNITE_RESU)
   J = J_init
   A = Simul.sensibilite(self,UNITE_ESCL,L_init,val,para,RESU_CALC,PARA_DIFF_FINI,UNITE_RESU)
   A = Dim.adim_sensi(A)
   l = lambda_init(Numeric.matrixmultiply(Numeric.transpose(A),A))
   gradient_init =calcul_gradient(A,erreur)  #utile pour le test de convergence, on prend les valeurs dimensionn�es
   residu = test_convergence(gradient_init,erreur,A,Numeric.zeros(len(gradient_init),Numeric.Float))
   Mess.affiche_result_iter(iter,J,val,residu,Numeric.array([]),UNITE_RESU)
   # On teste un manque de temps CPU
   restant,temps_iter,err=temps_CPU(self,restant,temps_iter)
   if (err==1):
      ier=ier+1
      return ier
   
   #_____________________________________________
   #
   # BOUCLE PRINCIPALE DE L'ALGORITHME
   #_____________________________________________
   epsilon = 10.*RESI_GLOB_RELA
   while((residu > RESI_GLOB_RELA) & (iter<ITER_MAXI)):  
      iter = iter +1
      new_val, s, l, Act = Levenberg_bornes(self,val,Dim,val_init,borne_inf,borne_sup,A,erreur,l,UNITE_RESU) 
      L_F = calcul_F(self,UNITE_ESCL,para,new_val,RESU_CALC)
      new_L_J,new_erreur = Simul.multi_interpole(L_F, RESU_CALC)
      new_J = Simul.norme_J(L_J_init,new_L_J,UNITE_RESU)
      l = actualise_lambda(l,Dim.adim(val),Dim.adim(new_val),A,erreur,new_J,J)
      val = copy.copy(new_val)
      erreur = copy.copy(new_erreur)
      J = new_J
      A = Simul.sensibilite(self,UNITE_ESCL,L_F,val,para,RESU_CALC,PARA_DIFF_FINI,UNITE_RESU)
      A = Dim.adim_sensi(A)
      residu = test_convergence(gradient_init,erreur,A,s)
      Mess.affiche_result_iter(iter,J,val,residu,Act,UNITE_RESU)
      if (gnuplot):
         if (GRAPHIQUE):
            GRAPHE_UL_OUT=GRAPHIQUE['UNITE']
            interactif=(GRAPHIQUE['INTERACTIF']=='OUI')
            graphique(L_F,RESU_EXP,RESU_CALC,iter,GRAPHE_UL_OUT,interactif)
      # On teste un manque de temps CPU
      restant,temps_iter,err=temps_CPU(self,restant,temps_iter)
      if (err==1):
         ier=ier+1
         return ier
   #_____________________________________________
   #
   # FIN DES ITERATIONS
   # CONVERGENCE OU ECHEC
   #_____________________________________________
   Mess.affiche_etat_final_convergence(iter,ITER_MAXI,RESI_GLOB_RELA,residu,Act,UNITE_RESU)
   calcul_etat_final(para,A,iter,ITER_MAXI,RESI_GLOB_RELA,residu,Mess,UNITE_RESU)
   #_____________________________________________
   #
   # CREATIONS DE LA LISTE DE REELS CONTENANT 
   # LES VALEURS DES PARAMETRES A CONVERGENCE
   #_____________________________________________
   lival=[]
   for i in range(len(val)):
       lival.append(val[i])
   nomres=DEFI_LIST_REEL(VALE=lival)
   return 
