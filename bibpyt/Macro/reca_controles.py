# -*- coding: iso-8859-1 -*-
# person_in_charge: aimery.assire at edf.fr
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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

import string
import copy
import types
import os
import sys
import pprint

# Nom de la routine
nompro = 'MACR_RECAL'

from Noyau.N_types import is_float, is_str, is_sequence


#_____________________________________________
#
# CONTROLE DES ENTREES UTILISATEUR
#_____________________________________________

# ------------------------------------------------------------------------------
def erreur_de_type(code_erreur,X):
   """
   code_erreur ==0 --> X est une liste
   code erreur ==1 --> X est un char
   code erreur ==2 --> X est un float
   test est un boolean (test = 0 d�faut et 1 si un test if est verifier
   """

   txt = ""
   if(code_erreur == 0 ):
      if not is_sequence(X):
         txt="\nCette entr�e: " +str(X)+" n'est pas une liste valide"
   if(code_erreur == 1 ):
      if not is_str(X):
         txt="\nCette entr�e: " +str(X)+" n'est pas une chaine de caract�re valide ; Veuillez la ressaisir en lui appliquant le type char de python"
   if(code_erreur == 2 ):
      if not is_float(X):
         txt="\nCette entr�e:  " +str(X)+" n'est pas une valeur float valide ; Veuillez la ressaisir en lui appliquant le type float de python"
   return txt
   

# ------------------------------------------------------------------------------
def erreur_dimension(PARAMETRES,REPONSES):
   """
   On verifie que la dimension de chaque sous_liste de parametre est 4
   et que la dimension de chaque sous_liste de REPONSES est 3
   """

   txt = ""
   for i in range(len(PARAMETRES)):
      if (len(PARAMETRES[i]) != 4):
         txt=txt + "\nLa sous-liste de la variable param�tre num�ro " + str(i+1)+" n'est pas de longueur 4"
   for i in range(len(REPONSES)):
      if (len(REPONSES[i]) != 3):
         txt=txt + "\nLa sous-liste de la variable r�ponse num�ro " + str(i+1)+" n'est pas de longueur 3"
   return txt


# ------------------------------------------------------------------------------
def compare__dim_rep__dim_RESU_EXP(REPONSES,RESU_EXP):
   """
   X et Y sont deux arguments qui doivent avoir la meme dimension
   pour �viter l'arret du programme
   """

   txt = ""
   if( len(REPONSES) != len(RESU_EXP)):
      txt="\nVous avez entr� " +str(len(REPONSES))+ " r�ponses et "+str(len(RESU_EXP))+ " exp�riences ; On doit avoir autant de r�ponses que de r�sultats exp�rimentaux"
   return txt


# ------------------------------------------------------------------------------
def compare__dim_poids__dim_RESU_EXP(POIDS,RESU_EXP):
   """
   POIDS et Y sont deux arguments qui doivent avoir la meme dimension
   pour �viter l'arret du programme
   """

   txt = ""
   if( len(POIDS) != len(RESU_EXP)):
      txt="\nVous avez entr� " +str(len(POIDS))+ " poids et "+str(len(RESU_EXP))+ " exp�riences ; On doit avoir autant de poids que de r�sultats exp�rimentaux"
   return txt


# ------------------------------------------------------------------------------
def verif_fichier(UL,PARAMETRES,REPONSES):
   """
   On verifie les occurences des noms des PARAMETRES et REPONSES 
   dans le fichier de commande ASTER
   """

   txt = ""
   txt_alarme = ""
   try:
      fichier = open('fort.'+str(UL),'r')
      fic=fichier.read()
   except:
      txt += "\nImpossible d'ouvrir le fichier esclave declare avec l'unite logique " + str(UL)
      return txt, txt_alarme
   for i in range(len(PARAMETRES)):
      if((string.find(fic,PARAMETRES[i][0])==-1) or ((string.find(fic,PARAMETRES[i][0]+'=')==-1) and (string.find(fic,PARAMETRES[i][0]+' ')==-1))):
         txt += "\nLe param�tre "+PARAMETRES[i][0]+" que vous avez entr� pour la phase d'optimisation n'a pas �t� trouv� dans votre fichier de commandes ASTER"
   for i in range(len(REPONSES)):
      if((string.find(fic,REPONSES[i][0])==-1) or ((string.find(fic,REPONSES[i][0]+'=')==-1) and (string.find(fic,REPONSES[i][0]+' ')==-1))):
         txt_alarme += "\nLa r�ponse  "+REPONSES[i][0]+" que vous avez entr�e pour la phase d'optimisation n'a pas �t� trouv�e dans votre fichier de commandes ASTER"
   return txt, txt_alarme


# ------------------------------------------------------------------------------
def verif_valeurs_des_PARAMETRES(PARAMETRES):
   """
   On verifie que pour chaque PARAMETRES de l'optimisation
   les valeurs entr�es par l'utilisateur sont telles que :
              val_inf<val_sup
              val_init appartient � [borne_inf, borne_sup] 
              val_init!=0         
              borne_sup!=0         
              borne_inf!=0         
   """

   txt = ""
   # verification des bornes
   for i in range(len(PARAMETRES)):
      if( PARAMETRES[i][2] >PARAMETRES[i][3]):
         txt=txt + "\nLa borne inf�rieure "+str(PARAMETRES[i][2])+" de  "+PARAMETRES[i][0]+ "est plus grande que sa borne sup�rieure"+str(PARAMETRES[i][3])
   # verification de l'encadrement de val_init 
   for i in range(len(PARAMETRES)):
      if( (PARAMETRES[i][1] < PARAMETRES[i][2]) or (PARAMETRES[i][1] > PARAMETRES[i][3])):
         txt=txt + "\nLa valeur initiale "+str(PARAMETRES[i][1])+" de "+PARAMETRES[i][0]+ " n'est pas dans l'intervalle [borne_inf,born_inf]=["+str(PARAMETRES[i][2])+" , "+str(PARAMETRES[i][3])+"]"
   # verification que val_init !=0
   for  i in range(len(PARAMETRES)):
      if (PARAMETRES[i][1] == 0. ):
         txt=txt + "\nProbl�me de valeurs initiales pour le param�tre "+PARAMETRES[i][0]+" : ne pas donner de valeur initiale nulle mais un ordre de grandeur."
   # verification que borne_sup !=0
   for  i in range(len(PARAMETRES)):
      if (PARAMETRES[i][3] == 0. ):
         txt=txt + "\nProbl�me de borne sup�rieure pour le param�tre "+PARAMETRES[i][0]+" : ne pas donner de valeur strictement nulle."
   # verification que borne_inf !=0
   for  i in range(len(PARAMETRES)):
      if (PARAMETRES[i][2] == 0. ):
         txt=txt + "\nProbl�me de borne inf�rieure pour le param�tre "+PARAMETRES[i][0]+" : ne pas donner de valeur strictement nulle."
   return txt


# ------------------------------------------------------------------------------
def verif_UNITE(GRAPHIQUE,UNITE_RESU):
   """
   On v�rifie que les unit�s de r�sultat et 
   de graphique sont diff�rentes
   """
   txt=""
   if GRAPHIQUE:
       try:
          GRAPHE_UL_OUT=GRAPHIQUE['UNITE']
          if (GRAPHE_UL_OUT==UNITE_RESU):
              txt=txt + "\nLes unit�s logiques des fichiers de r�sultats graphiques et de r�sultats d'optimisation sont les memes."
       except:
          pass
   return txt


# ------------------------------------------------------------------------------
def gestion(UL,PARAMETRES,REPONSES,RESU_EXP,POIDS,GRAPHIQUE,UNITE_RESU,METHODE):
   """
   Cette methode va utiliser les methodes de cette classe declar�e ci-dessus
   test  est un boolean: test=0 -> pas d'erreur
                         test=1 -> erreur d�tect�e
   """

   texte = ""
   texte_alarme = ""

   # On v�rifie d'abord si PARAMETRES, REPONSES, RESU_EXP sont bien des listes au sens python
   # test de PARAMETRES
   texte = texte + erreur_de_type(0,PARAMETRES)
   # test de REPONSES
   texte = texte + erreur_de_type(0,REPONSES)
   # test de RESU_EXP
   texte = texte + erreur_de_type(0,RESU_EXP) 
   
   # On v�rifie si chaque sous liste de PARAMETRES, REPONSES,  poss�de le type ad�quat
   # test des sous_listes de PARAMETRES
   for i in range(len(PARAMETRES)):
      texte = texte +  erreur_de_type(0,PARAMETRES[i]) 
   # test des sous_listes de REPONSES
   for i in range(len(REPONSES)):
      texte = texte + erreur_de_type(0,REPONSES[i])

   # On verifie si la dimension de chaque sous-liste de : PARAMETRES, REPONSES
   # il faut que: la dimension d'une sous-liste de PARAMETRES = 4
   # et   que     la dimension d'une sous liste de REPONSES   = 3
   texte = texte + erreur_dimension(PARAMETRES,REPONSES)

   # on verifie que l'on a autant de r�ponses que de r�sultats exp�rimentaux
   texte = texte + compare__dim_rep__dim_RESU_EXP(REPONSES,RESU_EXP)
   #on verifie que l'on a autant de poids que de r�sultats exp�rimentaux
   texte = texte + compare__dim_poids__dim_RESU_EXP(POIDS,RESU_EXP)

   # on verifie les types des arguments de chaque sous liste de PARAMETRES et REPONSES
      # verification du type stringet type float des arguments de PARAMETRES
   for i in range(len(PARAMETRES)):
      texte = texte + erreur_de_type(1,PARAMETRES[i][0])
      for k in [1,2,3]:
         texte = texte + erreur_de_type(2,PARAMETRES[i][k])

   # verification du type string pour les arguments  de REPONSES
   for i in range(len(REPONSES)):
      for j in range(len(REPONSES[i])):
         texte = texte + erreur_de_type(1,REPONSES[i][j])
   
   # verification du fichier de commandes Esclave ASTER
   if METHODE != 'EXTERNE': # pour celui-ci le fort.UL n'est pas l'esclave... voir comment faire
      texte_fatal, texte_alarme = verif_fichier(UL,PARAMETRES,REPONSES)
      texte += texte_fatal

   # verification des valeurs des PARAMETRES entr�es par l'utilisateur (pour fmin* les bornes ne sont pas prises en compte)
   if METHODE == 'LEVENBERG':
      texte = texte + verif_valeurs_des_PARAMETRES(PARAMETRES)

   # verification des unit�s logiques renseign�es par l'utilisateur
   if METHODE != 'EXTERNE':
      texte = texte + verif_UNITE(GRAPHIQUE,UNITE_RESU)

   return texte, texte_alarme
   