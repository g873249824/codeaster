#@ MODIF recal Macro  DATE 24/09/2002   AUTEUR PABHHHH N.TARDIEU 
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


import string
import copy
import Numeric
import types
import Gnuplot
import Cata
from Cata.cata import *
from Accas import _F

import os


#===========================================================================================
# DIVERS UTILITAIRES POUR LA MACRO

#transforme_list_Num tranforme transforme les donne�s entr�es par l'utilsateur en tableau Numeric
def transforme_list_Num(parametres,res_exp):
   dim_para = len(parametres)  #donne le nb de parametres
   val_para = Numeric.zeros(dim_para,Numeric.Float)
   borne_inf = Numeric.zeros(dim_para,Numeric.Float)
   borne_sup = Numeric.zeros(dim_para,Numeric.Float)
   para = []
   for i in range(dim_para):
      para.append(parametres[i][0])
      val_para[i] = parametres[i][1]
      borne_inf[i] = parametres[i][2]
      borne_sup[i] = parametres[i][3]
      
   return para,val_para,borne_inf,borne_sup

def mes_concepts(list_concepts=[],base=None):
  # Fonction qui liste les concepts cr��s
   for e in base.etapes:
      if e.__class__.__name__ == 'MACRO_ETAPE':
        list_concepts=list(mes_concepts(list_concepts=list_concepts,base=e))
      elif e.sd != None:
        nom_concept=e.sd.get_name()
        if not(nom_concept in list_concepts):
          list_concepts.append( nom_concept )
   return tuple(list_concepts)


def detr_concepts(objet):
     liste_concepts=mes_concepts(base=objet.parent)
     for e in liste_concepts:
        nom = string.strip(e)
        DETRUIRE( CONCEPT =objet.g_context['_F'](NOM = nom))
        if objet.jdc.g_context.has_key(nom) : del objet.jdc.g_context[nom]
     del(liste_concepts)


def calcul_F(objet,UL,para,val,reponses):
      fic = open('fort.'+str(UL),'r')
      #On stocke le contenu de fort.UL dans la variable fichier qui est un string 
      fichier=fic.read()
      #On stocke le contenu initial de fort.UL dans la variable fichiersauv 
      fichiersauv=copy.copy(fichier)
      fic.close()

      #L est une liste ou l'on va stocker le fichier modifi�
      #id�e g�n�rale :on d�limite des 'blocs' dans fichier
      #on modifie ou non ces blocs suivant les besoins 
      #on ajoute ces blocs dans la liste L
      L=[]                      
      
      try: 
         #cherche l'indice de DEBUT()
         index_deb=string.index(fichier,'DEBUT(')
         while( fichier[index_deb]!='\012'):
            index_deb=index_deb+1
         fichier = fichier[index_deb+1:]   
                  #on restreind fichier en enlevant 'DEBUT();'
      except :
         #on va dans l'except si on a modifi� le fichier au moins une fois
         pass 
         
      try:
         #cherche l'indice de FIN()
         index_fin = string.index(fichier,'FIN(')
         fichier = fichier[:index_fin]   
                  #on restreind fichier en enlevant 'FIN();'
      except :
         #on va dans l'except si on a modifi� le fichier au moins une fois 
         index_retour = string.index(fichier,'RETOUR')
         fichier=fichier[:index_retour]
      #--------------------------------------------------------------------------------
      #on cherche � d�limiter le bloc des parametres dans le fichier
      #Tout d'abord on cherche les indices  d'apparition des paras dans le fichier 
      #en effet l'utilisateur n'est pas oblig� de rentrer les paras dans optimise
      #avec le meme ordre de son fichier de commande
      index_para = Numeric.zeros(len(para))
      for i in range(len(para)):
         index_para[i] = string.index(fichier,para[i])
      #On range les indices par ordre croissant afin de d�terminer
      #les indice_max et indice_min
      index_para = Numeric.sort(index_para)
      index_first_para = index_para[0]
      index_last_para = index_para[len(index_para)-1]
      
      
      #on va d�limiter les blocs interm�diaires entre chaque para "utiles" � l'optimsation
      bloc_inter ='\012'
      for i in range(len(para)-1):
         j = index_para[i]
         k = index_para[i+1]
         while(fichier[j]!= '\012'):
            j=j+1
         bloc_inter=bloc_inter + fichier[j:k] + '\012'
         
      #on veut se placer sur le premier retour chariot que l'on trouve sur la ligne du dernier para
      i = index_last_para 
      while(fichier[i] != '\012'):
         i = i + 1
      index_last_para  = i
      #on d�limite les blocs suivants:
      pre_bloc = fichier[:index_first_para]       #fichier avant premier parametre
      post_bloc = fichier[ index_last_para+ 1:]    #fichier apr�s dernier parametre
      
      #on ajoute dans L tous ce qui est avant le premier param�tre 
      L.append(pre_bloc)
      #On ajoute � L tous ce qui est entre les parametres
      L.append(bloc_inter)
      #On ajoute la nouvelle valeur des parametres
      dim_para=len(para)
      for j in range(dim_para):
         L.append(para[j]+'='+str(val[j]) + ';' + '\012')
      
      L.append(post_bloc)
      #--------------------------------------------------------------------------------
      #on va ajouter la fonction EXTRACT 
      #et on stocke les r�ponses calcul�es dans la liste Lrep
      #qui va etre retourn�e par la fonction calcul_F
      objet.g_context['Lrep'] = []
      L.append('Lrep=[]'+'\012')
      for i in range(len(reponses)):
         L.append('F = EXTRACT('+str(reponses[i][0])+','+"'"+str(reponses[i][1])+"'"+','+"'"+str(reponses[i][2])+"'"+')'+'\012')
         L.append('Lrep.append(F)'+'\012')
      #on ajoute � RETOUR
      L.append('RETOUR();\012')
      
      #ouverture du fichier fort.3 et mise a jour de celui ci
      x=open('fort.'+str(UL),'w')
      x.writelines('from Accas import _F \012from Cata.cata import * \012')
      x.writelines(L)
      x.close()
      del(L)
      del(pre_bloc)
      del(post_bloc)
      del(fichier)
      
      INCLUDE(UNITE = str(UL))
      detr_concepts(objet)
      # on remet le fichier dans son etat initial
      x=open('fort.'+str(UL),'w')
      x.writelines(fichiersauv)
      x.close()
      return objet.g_context['Lrep']

#----------------------------------------------------------


def EXTRACT(Table,Para,Champ):
# Definition des variables
  #Table = reponse[0]
  #Para = reponse[1]
  #Champ = reponse[2] 
  Result = [[None]*2]
  nb_temp = 0
# Boucle de lecture sur les temps
  while 1: 
#   Si on n'a pas lu tous les temps
    try:
#     alors on lit les 2 champs abscisse et ordonnee
        Result[nb_temp][0] = Table[Para,nb_temp+1]
        Result[nb_temp][1] = Table[Champ,nb_temp+1]
        nb_temp = nb_temp + 1  
#     on ajoute une dimension temporelle supplementaire au resultat
        Result.append([None]*2)
#   Si on a lu tous les temps alors on sort de la boucle
    except KeyError:
      break
# on renvoie le resultat en fin
  Rep = Result[0:nb_temp]
  F=Numeric.zeros((len(Rep),2),Numeric.Float)   #on transforme Rep en array Numeric
  for i in range(len(Rep)):
   for j in range(2) :
      F[i][j] = Rep[i][j]
  del(Rep)
  del(Result)
  return F
  

#-------------------------------------------
def graphique(L_F,res_exp,reponses,iter,UL_out,interactif):
   graphe=[]
   impr=Gnuplot.Gnuplot()
   Gnuplot.GnuplotOpts.prefer_inline_data=1
   impr('set data style linespoints')
   impr('set grid')
   impr('set pointsize 2.')
   impr('set terminal postscript color')
   impr('set output "fort.'+str(UL_out)+'"')
   for i in range(len(L_F)):
         if interactif:
            graphe.append(Gnuplot.Gnuplot(persist=0))
            graphe[i]('set data style linespoints')
            graphe[i]('set grid')
            graphe[i]('set pointsize 2.')
            graphe[i].xlabel(reponses[i][1])
            graphe[i].ylabel(reponses[i][2])
            graphe[i].title(reponses[i][0]+'  Iteration '+str(iter))
            graphe[i].plot(Gnuplot.Data(L_F[i],title='Calcul'),Gnuplot.Data(res_exp[i],title='Experimental'))
            graphe[i]('pause 5')
#
         impr.xlabel(reponses[i][1])
         impr.ylabel(reponses[i][2])
         impr.title(reponses[i][0]+'  Iteration '+str(iter))
         impr.plot(Gnuplot.Data(L_F[i],title='Calcul'),Gnuplot.Data(res_exp[i],title='Experimental'))


#===========================================================================================
# CONTROLE DES ENTREES UTILISATEUR

def erreur_de_type(code_erreur,X):
   #code_erreur ==0 --> X est une liste
   #code erreur ==1 --> X est un char
   #code erreur ==2 --> X est un float
   #test est un boolean (test = 0 d�faut et 1 si un test if est verifier
   txt=""
   if(code_erreur == 0 ):
      if type(X) is not types.ListType:
         txt="\012Cette entr�e: " +str(X)+" n'est pas une liste valide"
   if(code_erreur == 1 ):
      if type(X) is not types.StringType:
         txt="\012Cette entr�e: " +str(X)+" n'est pas une chaine de caract�re valide ; Veuillez la ressaisir en lui appliquant le type char de python"
   if(code_erreur == 2 ):
      if type(X) is not types.FloatType:
         txt="\012Cette entr�e:  " +str(X)+" n'est pas une valeur float valide ; Veuillez la ressaisir en lui appliquant le type float de python"
   return txt
   
   
def erreur_dimension(PARAMETRES,REPONSES):
#On verifie que la dimension de chaque sous_liste de parametre est 4
#et que la dimension de chaque sous_liste de REPONSES est 3
   txt=""
   for i in range(len(PARAMETRES)):
      if (len(PARAMETRES[i]) != 4):
         txt=txt + "\012La sous-liste de la variable param�tre num�ro " + str(i+1)+" n'est pas de longueur 4"
   for i in range(len(REPONSES)):
      if (len(REPONSES[i]) != 3):
         txt=txt + "\012La sous-liste de la variable r�ponse num�ro " + str(i+1)+" n'est pas de longueur 3"
   return txt


def compare__dim_rep__dim_RESU_EXP(REPONSES,RESU_EXP):
   # X et Y sont deux arguments qui doivent avoir la meme dimension
   # pour �viter l'arret du programme
   txt=""
   if( len(REPONSES) != len(RESU_EXP)):
      txt="\012Vous avez entr� " +str(len(REPONSES))+ " r�ponses et "+str(len(RESU_EXP))+ " exp�riences ; On doit avoir autant de r�ponses que de r�sultats exp�rimentaux"
   return txt


def verif_fichier(UL,PARAMETRES,REPONSES):
#On verifie les occurences des noms des PARAMETRES et REPONSES 
#dans le fichier de commande ASTER
   txt=""
   fichier = open('fort.'+str(UL),'r')
   fic=fichier.read()
   for i in range(len(PARAMETRES)):
      if((string.find(fic,PARAMETRES[i][0])==-1) or ((string.find(fic,PARAMETRES[i][0]+'=')==-1) and (string.find(fic,PARAMETRES[i][0]+' ')==-1))):
         txt=txt + "\012Le param�tre "+PARAMETRES[i][0]+" que vous avez entr� pour la phase d'optimisation n'a pas �t� trouv� dans votre fichier de commandes ASTER"
   for i in range(len(REPONSES)):
      if((string.find(fic,REPONSES[i][0])==-1) or ((string.find(fic,REPONSES[i][0]+'=')==-1) and (string.find(fic,REPONSES[i][0]+' ')==-1))):
         txt=txt + "\012La r�ponse  "+REPONSES[i][0]+" que vous avez entr�e pour la phase d optimisation n'a pas �t� trouv�e dans votre fichier de commandes ASTER"
   return txt


def verif_valeurs_des_PARAMETRES(PARAMETRES):
#On verifie que pour chaque PARAMETRES de l'optimisation
# les valeurs entr�es par l'utilisateur sont telles que :
#              val_inf<val_sup
#              val_init appartient � [val_inf, val_sup] 
#              val_init!=0         
   #verification des bornes
   txt=""
   for i in range(len(PARAMETRES)):
      if( PARAMETRES[i][2] >PARAMETRES[i][3]):
         txt=txt + "\012La borne inf�rieure "+str(PARAMETRES[i][2])+" de  "+PARAMETRES[i][0]+ "est plus grande que sa borne sup�rieure"+str(PARAMETRES[i][3])
   #verification de l'encadrement de val_init 
   for i in range(len(PARAMETRES)):
      if( (PARAMETRES[i][1] < PARAMETRES[i][2]) or (PARAMETRES[i][1] > PARAMETRES[i][3])):
         txt=txt + "\012La valeur initiale "+str(PARAMETRES[i][1])+" de "+PARAMETRES[i][0]+ " n'est pas dans l'intervalle [borne_inf,born_inf]=["+str(PARAMETRES[i][2])+" , "+str(PARAMETRES[i][3])+"]"
   #verification que val_init !=0
   for  i in range(len(PARAMETRES)):
      if (PARAMETRES[i][1] == 0. ):
         txt=txt + "\012Probl�mes de valeurs initiales pour le param�tre "+PARAMETRES[i][0]+" : ne pas donner de valeur initiale nulle mais un ordre de grandeur."
   return txt




def gestion(UL,PARAMETRES,REPONSES,RESU_EXP):
   #Cette methode va utiliser les methodes de cette classe declar�e ci_dessus
   #test  est un boolean: test=0 -> pas d'erreur
   #                      test=1 -> erreur d�tect�e

   texte=""
   #On v�rifie d'abord si PARAMETRES, REPONSES, RESU_EXP sont bien des listes au sens python
   #test de PARAMETRES
   texte = texte + erreur_de_type(0,PARAMETRES)
   #test de REPONSES
   texte = texte + erreur_de_type(0,REPONSES)
   #test de RESU_EXP
   texte = texte + erreur_de_type(0,RESU_EXP) 
   
   #On v�rifie si chaque sous liste de PARAMETRES, REPONSES,  poss�de le type ad�quat
   #test des sous_listes de PARAMETRES
   for i in range(len(PARAMETRES)):
      texte = texte +  erreur_de_type(0,PARAMETRES[i]) 
   #test des sous_listes de REPONSES
   for i in range(len(REPONSES)):
      texte = texte + erreur_de_type(0,REPONSES[i])
 
   #On verifie si la dimension de chaque sous-liste de : PARAMETRES, REPONSES
   #il faut que:la dimension d'une sous-liste de PARAMETRES = 4
   #et   que    la dimension d'une sous liste de REPONSES   = 3
   texte = texte + erreur_dimension(PARAMETRES,REPONSES)

   #on verifie que l'on a autant de r�ponses que de r�sultats exp�rimentaux
   texte = texte + compare__dim_rep__dim_RESU_EXP(REPONSES,RESU_EXP)

   #on verifie les types des arguments de chaque sous liste de PARAMETRES et REPONSES
      #verification du type stringet type float des arguments de PARAMETRES
   for i in range(len(PARAMETRES)):
      texte = texte + erreur_de_type(1,PARAMETRES[i][0])
      for k in [1,2,3]:
         texte = texte + erreur_de_type(2,PARAMETRES[i][k])
         
   #verification du type string pour les arguments  de REPONSES
   for i in range(len(REPONSES)):
      for j in range(len(REPONSES[i])):
         texte = texte + erreur_de_type(1,REPONSES[i][j])
   
   #verification du fichier de commndes ASTER
   texte = texte + verif_fichier(UL,PARAMETRES,REPONSES)

   #verifiaction des valeurs des PARAMETRES entr�es par l'utilisteur 
   texte = texte + verif_valeurs_des_PARAMETRES(PARAMETRES)

   return texte
   

