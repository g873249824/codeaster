#@ MODIF reca_message Macro  DATE 16/05/2007   AUTEUR ASSIRE A.ASSIRE 
# -*- coding: iso-8859-1 -*-
# RESPONSABLE ASSIRE A.ASSIRE
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

import os, Numeric

try:
   import Utilitai.Utmess
   from Utilitai.Utmess import UTMESS
except:
   def UTMESS(code,sprg,texte):
      fmt='\n <%s> <%s> %s\n\n'
      print fmt % (code,sprg,texte)
      if code=='F': sys.exit()

#===========================================================================================


# AFFICHAGE DES MESSAGES

class Message :
   """classe g�rant l'affichage des messages concernant le d�roulement de l'optmisation """
   #Constructeur de la classe

# ------------------------------------------------------------------------------

   def __init__(self,para,val_init,resu_exp,ul_out):
      self.nom_para = para
      self.resu_exp = resu_exp
      self.val_init = val_init
      self.resu_exp = resu_exp
      self.ul_out = ul_out

# ------------------------------------------------------------------------------
   
   def initialise(self):
      res=open(os.getcwd()+'/fort.'+str(self.ul_out),'w')
      res.close()

      txt = ' <INFO>  MACR_RECAL\n\n'
      self.ecrire(txt)

# ------------------------------------------------------------------------------
   
   def ecrire(self,txt):
      res=open(os.getcwd()+'/fort.'+str(self.ul_out),'a')
      res.write(txt+'\n')
      res.flush()
      res.close()


# ------------------------------------------------------------------------------
   
   def affiche_valeurs(self,val):

      txt = '\n=> Param�tres    = '
      for i in range(len(val)):
         txt += '\n         '+ self.nom_para[i]+' = '+str(val[i])
      self.ecrire(txt)

# ------------------------------------------------------------------------------
   
   def affiche_fonctionnelle(self,J):

      txt = '\n=> Fonctionnelle = '+str(J)
      self.ecrire(txt)

# ------------------------------------------------------------------------------
   
   def affiche_result_iter(self,iter,J,val,residu,Act=[],):

      txt  = '\n=======================================================\n'
      txt += 'Iteration '+str(iter)+' :\n'
      txt += '\n=> Fonctionnelle = '+str(J)
      txt += '\n=> R�sidu        = '+str(residu)

      self.ecrire(txt)

      txt = ''
      self.affiche_valeurs(val)

      if (len(Act)!=0):
         if (len(Act)==1):
            txt += '\n\n Le param�tre '
         else:
            txt += '\n\n Les param�tres '
         for i in Act:
            txt += self.nom_para[i]+' '
         if (len(Act)==1):
            txt += '\n est en but�e sur un bord de leur domaine admissible.'
         else:
            txt += '\n sont en but�e sur un bord de leur domaine admissible.'
      txt += '\n=======================================================\n\n'
      self.ecrire(txt)


# ------------------------------------------------------------------------------

   def affiche_etat_final_convergence(self,iter,max_iter,iter_fonc,max_iter_fonc,prec,residu,Act=[]):

      txt = ''
      if ((iter <= max_iter) or (residu <= prec) or (iter_fonc <= max_iter_fonc) ):
        txt += '\n=======================================================\n'
        txt += '                   CONVERGENCE ATTEINTE                '
        if (len(Act)!=0):
           txt += "\n\n         ATTENTION : L'OPTIMUM EST ATTEINT AVEC      "
           txt += "\n           DES PARAMETRES EN BUTEE SUR LE BORD     "
           txt += "\n               DU DOMAINE ADMISSIBLE                 "
        txt += '\n=======================================================\n'
      else:
        txt += "\n=======================================================\n"
        txt += '               CONVERGENCE  NON ATTEINTE              '
        if (iter > max_iter):
          txt += "\n  Le nombre maximal  d'it�ration ("+str(max_iter)+") a �t� d�pass�"
        if (iter_fonc > max_iter_fonc):
          txt += "\n  Le nombre maximal  d'evaluation de la fonction ("+str(max_iter_fonc)+") a �t� d�pass�"
        txt += '\n=======================================================\n'
      self.ecrire(txt)


# ------------------------------------------------------------------------------

   def affiche_calcul_etat_final(self,para,Hessien,valeurs_propres,vecteurs_propres,sensible,insensible):

        txt  = '\n\nValeurs propres du Hessien:\n'
        txt += str( valeurs_propres)
        txt += '\n\nVecteurs propres associ�s:\n'
        txt += str( vecteurs_propres)
        txt += '\n\n              --------'
        txt += '\n\nOn peut en d�duire que :'
        # Param�tres sensibles
        if (len(sensible)!=0):
           txt += '\n\nLes combinaisons suivantes de param�tres sont pr�pond�rantes pour votre calcul :\n'
           k=0
           for i in sensible:
              k=k+1
              colonne=vecteurs_propres[:,i]
              numero=Numeric.nonzero(Numeric.greater(abs(colonne/max(abs(colonne))),1.E-1))
              txt += '\n   '+str(k)+') '
              for j in numero:
                 txt += '%+3.1E ' %colonne[j]+'* '+para[j]+' '
              txt += '\n      associ�e � la valeur propre %3.1E \n' %valeurs_propres[i]
        # Param�tres insensibles
        if (len(insensible)!=0):
           txt += '\n\nLes combinaisons suivantes de param�tres sont insensibles pour votre calcul :\n'
           k=0
           for i in insensible:
              k=k+1
              colonne=vecteurs_propres[:,i]
              numero=Numeric.nonzero(Numeric.greater(abs(colonne/max(abs(colonne))),1.E-1))
              txt += '\n   '+str(k)+') '
              for j in numero:
                 txt += '%+3.1E ' %colonne[j]+'* '+para[j]+' '
              txt += '\n      associ�e � la valeur propre %3.1E \n' %valeurs_propres[i]
      
        self.ecrire(txt)

