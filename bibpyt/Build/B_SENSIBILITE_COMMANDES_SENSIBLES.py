#@ MODIF B_SENSIBILITE_COMMANDES_SENSIBLES Build  DATE 10/04/2006   AUTEUR MCOURTOI M.COURTOIS 
# -*- coding: iso-8859-1 -*-
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


# RESPONSABLE GNICOLAS G.NICOLAS
"""
Classe des commandes particuli�res pour la sensibilit�
"""
#
class SENSIBILITE_COMMANDES_SENSIBLES :
   """
   Attributs :
   . Un dictionnaire contenant les listes de commandes suivantes :
     l_commandes_defi_para_sensi = liste des commandes de d�finition des param�tres sensibles
     l_commandes_sensibles = liste des commandes qui pilotent la sensibilit�
                             ce sont les commandes principales de calcul thermique ou m�canique
     l_commandes_a_deriver = liste des commandes � d�river quand un des arguments est d�riv�
     l_commandes_a_deriver_ensemble = liste des commandes � d�river d�s que l'une est concern�e
                                      par un param�tre sensible
     l_commandes_poursuite = liste des commandes activant une reprise de calcul
     Une commande n'est pr�sente qu'une seule fois dans chaque liste.
   . Le mot cl� pilotant le calcul de sensibilit�. C'est sa pr�sence dans les commandes
     "sensibles" qui caract�risera un calcul avec sensibilit�.
   . La commande m�morisant les noms pour la sensibilit�.
   . La liste des classe de param�tres sensibles d�finis dans le jdc.

   """
   defi_para_sensi     = "defi_para_sensi"
   sensible            = "sensible"
   sensible_princ      = "sensible_princ"
   sensible_post       = "sensible_post"
   sensible_all        = "sensible_all"
   a_deriver           = "a_deriver"
   a_deriver_ensemble  = "a_deriver_ensemble"    
   poursuite           = "poursuite"    
#
# ---------- D�but du constructeur ----------
#
   def __init__(self,
                mot_cle = 'SENSIBILITE',
                memo_nom_sensi = 'MEMO_NOM_SENSI',
                DEBUG=None,
                ) :
       self.d_cmd = {
         self.defi_para_sensi     : ['DEFI_PARA_SENSI'],
         # commandes qui cr�ent le concept nominal ET le(s) concept(s) d�riv�(s)
         self.sensible_princ      : ['DYNA_LINE_HARM',
                                     'DYNA_LINE_TRAN',
                                     'DYNA_NON_LINE',
                                     'MECA_STATIQUE',
                                     'MODE_ITER_INV',
                                     'MODE_ITER_SIMULT',
                                     'STAT_NON_LINE',
                                     'THER_LINEAIRE',
                                     'THER_NON_LINE',],
         # commandes qui cr�ent le concept nominal OU le(s) concept(s) d�riv�(s)
         self.sensible_post       : ['CALC_ELEM',
                                     'CALC_G_THETA_T',
                                     'CALC_NO',
                                     #'CALC_TABLE',
                                     'CREA_CHAMP',
                                     'CREA_TABLE',
                                     'EXTR_RESU',
                                     'NORM_MODE',
                                     'POST_RELEVE_T',
                                     'PROJ_CHAMP',
                                     'RECU_FONCTION',],
         # celles qui ne cr�ent rien ne sont pas ici, of course ! (IMPR_xxxx, TEST_xxxx)
         # commandes dupliqu�es pour chaque param�tre sensible
         self.a_deriver_ensemble  : ['DEFI_MATERIAU',],
         # commandes � dupliquer en fonction des concepts sensibles pr�sents en argument
         self.a_deriver           : ['AFFE_MATERIAU',
                                     'AFFE_CHAR_MECA_F',
                                     'AFFE_CHAR_THER_F',
                                     #'CALC_MATR_ELEM',
                                     ],
         self.poursuite           : ['POURSUITE',],
       }
       self.d_cmd[self.sensible]     = self.d_cmd[self.sensible_princ] \
                                     + self.d_cmd[self.sensible_post]
       all = []
       for liste in self.d_cmd.values():
          all.extend(liste)
       self.d_cmd[self.sensible_all] = all
       DEBUG_defaut = 0
       self.DEBUG = DEBUG or DEBUG_defaut
       self.mot_cle = mot_cle
       self.memo_nom_sensi = memo_nom_sensi
       self.classe_para_sensi = []
# ---------- Fin du constructeur ----------
#
   def add_classe_para_sensi(self,classe) :
       """
       Ajoute une classe de param�tre sensible � la liste
       Code de retour :  0, tout va bien
                         1, la classe est d�j� dans la liste
       """
       if classe in self.classe_para_sensi :
         codret = 1
       else :
         codret = 0
         self.classe_para_sensi.append(classe)
       return codret
#
   def get_classe_para_sensi(self) :
       """
       R�cup�re les classes des param�tres sensibles
       """
       return self.classe_para_sensi
#
   def add_commande(self,commande,type_commande) :
       """
       Ajoute une commande � la liste du type type_commande
       Code de retour :  0, tout va bien
                         1, la commande est d�j� dans la liste
       """
       liste = self.d_cmd[type_commande]
       if commande in liste :
         codret = 1
       else :
         codret = 0
         liste.append(commande)
       self.d_cmd[type_commande] = liste
       return codret
#
#
   def add_commande_defi_para_sensi(self,commande) :
       """
       Ajoute une commande de d�finition des param�tres sensibles � la liste
       Code de retour :  0, tout va bien
                         1, la commande est d�j� dans la liste
       """
       return self.add_commande(commande,self.defi_para_sensi)
#
   def get_l_commandes_defi_para_sensi(self) :
       """
       R�cup�re la liste des commandes de d�finition des param�tres sensibles
       """
       return self.d_cmd[self.defi_para_sensi]
#
   def add_commande_sensible(self,commande) :
       """
       Ajoute une commande sensible � la liste
       Code de retour :  0, tout va bien
                         1, la commande est d�j� dans la liste
       """
       return self.add_commande(commande,self.sensible)
#
   def get_l_commandes_sensibles(self) :
       """
       R�cup�re la liste des commandes sensibles
       """
       return self.d_cmd[self.sensible]
#
   def get_l_commandes_sensibles_all(self) :
       """
       R�cup�re la liste de toutes les commandes sensibles
       """
       return self.d_cmd[self.sensible_all]
#
   def add_commande_sensible_post(self,commande) :
       """
       Ajoute une commande sensible � la liste
       Code de retour :  0, tout va bien
                         1, la commande est d�j� dans la liste
       """
       return self.add_commande(commande,self.sensible_post)
#
   def get_l_commandes_sensibles_post(self) :
       """
       R�cup�re la liste des commandes sensibles de post
       """
       return self.d_cmd[self.sensible_post]
#
   def add_commande_a_deriver(self,commande) :
       """
       Ajoute une commande a d�river � la liste
       Code de retour :  0, tout va bien
                         1, la commande � d�river est d�j� dans la liste
       """
       return self.add_commande(commande,self.a_deriver)
# 
   def get_l_commandes_a_deriver(self) :
       """
       R�cup�re la liste des commandes � d�river
       """
       return self.d_cmd[self.a_deriver]
#
   def add_commande_a_deriver_ensemble(self,commande) :
       """
       Ajoute une commande a d�river � la liste
       Code de retour :  0, tout va bien
                         1, la commande � d�river est d�j� dans la liste
       """
       return self.add_commande(commande,self.a_deriver_ensemble)
# 
   def get_l_commandes_a_deriver_ensemble(self) :
       """
       R�cup�re la liste des commandes � d�river ensemble
       """
       return self.d_cmd[self.a_deriver_ensemble]
#
   def add_commande_poursuite(self,commande) :
       """
       Ajoute une commande a d�river � la liste
       Code de retour :  0, tout va bien
                         1, la commande de poursuite est d�j� dans la liste
       """
       return self.add_commande(commande,self.poursuite)
# 
   def get_l_commandes_poursuite(self) :
       """
       R�cup�re la liste des commandes de poursuite
       """
       return self.d_cmd[self.poursuite]
#
#
if __name__ == "__main__" :
#
#
  commandes_sensibles = SENSIBILITE_COMMANDES_SENSIBLES()
  print "\n",commandes_sensibles
  print "Commande de m�morisation : ",commandes_sensibles.memo_nom_sensi
  print "Mot cl� pilotant le calcul de sensibilit� : ",commandes_sensibles.mot_cle
  print "Classe des param�tres sensibles           : ",commandes_sensibles.get_classe_para_sensi()
  print "Liste des commandes de d�f des paras. sensibles : ",commandes_sensibles.get_l_commandes_defi_para_sensi()
  print "Liste des commandes sensibles          : ",commandes_sensibles.get_l_commandes_sensibles()
  print "Liste des commandes � d�river          : ",commandes_sensibles.get_l_commandes_a_deriver()
  print "Liste des commandes � d�river ensemble : ",commandes_sensibles.get_l_commandes_a_deriver_ensemble()
  print "Liste des commandes de poursuite       : ",commandes_sensibles.get_l_commandes_poursuite()
  print "Ajout de la commande � d�river 'GABUZOME' : ", commandes_sensibles.add_commande_a_deriver('GABUZOME')
  print "Ajout de la commande � d�river 'GABUZOME' : ", commandes_sensibles.add_commande_a_deriver('GABUZOME')
  print "Liste des commandes � d�river  : ", commandes_sensibles.get_l_commandes_a_deriver()
  print "\n"
  
  
  
