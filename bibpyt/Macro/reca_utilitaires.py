#@ MODIF reca_utilitaires Macro  DATE 25/07/2006   AUTEUR ASSIRE A.ASSIRE 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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


import Numeric, LinearAlgebra, copy, os, string, types, sys
from Numeric import take

from Cata.cata import INFO_EXEC_ASTER, DEFI_FICHIER, IMPR_FONCTION, DETRUIRE
from Accas import _F

try:    import Gnuplot
except: pass

try:
   from Utilitai.Utmess import UTMESS
except ImportError:
   def UTMESS(code,sprg,texte):
      fmt='\n <%s> <%s> %s\n\n'
      print fmt % (code,sprg,texte)
      if code=='F': sys.exit()



# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

#_____________________________________________
#
# DIVERS UTILITAIRES POUR LA MACRO
#_____________________________________________


def transforme_list_Num(parametres,res_exp):
   """
      Transforme les donn�es entr�es par l'utilisateur en tableau Numeric
   """

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


# ------------------------------------------------------------------------------

def mes_concepts(list_concepts=[],base=None):
   """
      Fonction qui liste les concepts cr��s
   """
   for e in base.etapes:
      if e.nom in ('INCLUDE','MACR_RECAL',) :
        list_concepts=list(mes_concepts(list_concepts=list_concepts,base=e))
      elif (e.sd != None) and (e.parent.nom=='INCLUDE') :
        nom_concept=e.sd.get_name()
        if not(nom_concept in list_concepts):
          list_concepts.append( nom_concept )
   return tuple(list_concepts)


# ------------------------------------------------------------------------------

def detr_concepts(self):
   """
      Fonction qui detruit les concepts cr��s
   """
   liste_concepts=mes_concepts(base=self.parent)
   for e in liste_concepts:
      nom = string.strip(e)
      DETRUIRE( CONCEPT =self.g_context['_F'](NOM = nom), INFO=1, ALARME='NON')
      if self.jdc.g_context.has_key(nom) : del self.jdc.g_context[nom]
   del(liste_concepts)


# ------------------------------------------------------------------------------








#_____________________________________________
#
# CALCUL DU TEMPS CPU RESTANT
#_____________________________________________


def temps_CPU(self,restant_old,temps_iter_old):
   """
      Fonction controlant le temps CPU restant
   """
   CPU=INFO_EXEC_ASTER(LISTE_INFO = ("CPU_RESTANT",))
   TEMPS=CPU['CPU_RESTANT',1]
   DETRUIRE(CONCEPT=_F(NOM='CPU'),INFO=1)
   err=0
   # Indique une execution interactive
   if (TEMPS>1.E+9):
     return 0.,0.,0
   # Indique une execution en batch
   else:
      restant=TEMPS
      # Initialisation
      if (restant_old==0.):
         temps_iter=-1.
      else:
         # Premi�re mesure
         if (temps_iter_old==-1.):
            temps_iter=(restant_old-restant)
         # Mesure courante
         else:
            temps_iter=(temps_iter_old + (restant_old-restant))/2.
         if ((temps_iter>0.96*restant)or(restant<0.)):
            err=1
            UTMESS('F','MACR_RECAL',"Arret de MACR_RECAL par manque de temps CPU.")

   return restant,temps_iter,err




#_____________________________________________
#
# IMPRESSIONS GRAPHIQUES
#_____________________________________________


def graphique(FORMAT, L_F, res_exp, reponses, iter, UL_out, interactif):

   if FORMAT=='XMGRACE':
       for i in range(len(L_F)):
           _tmp = []
           courbe1 = res_exp[i]
           _tmp.append( { 'ABSCISSE': courbe1[:,0].tolist(), 'ORDONNEE': courbe1[:,1].tolist(), 'COULEUR': 1 } )
           courbe2 = L_F[i]
           _tmp.append( { 'ABSCISSE': courbe2[:,0].tolist(), 'ORDONNEE': courbe2[:,1].tolist(), 'COULEUR': 2 } )

           motscle2= {'COURBE': _tmp }
           if interactif: motscle2['PILOTE']= 'INTERACTIF'
           else:          motscle2['PILOTE']= 'POSTSCRIPT'

#           DEFI_FICHIER(UNITE=int(UL_out), ACCES='NEW',)

           IMPR_FONCTION(FORMAT='XMGRACE',
                         UNITE=int(UL_out),
                         TITRE='Courbe de : ' + reponses[i][0],
                         SOUS_TITRE='Iteration : ' + str(iter),
                         LEGENDE_X=reponses[i][1],
                         LEGENDE_Y=reponses[i][2],
                         **motscle2
                         );
#           DEFI_FICHIER(ACTION='LIBERER',UNITE=int(UL_out),)

   elif FORMAT=='GNUPLOT':
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

             impr.xlabel(reponses[i][1])
             impr.ylabel(reponses[i][2])
             impr.title(reponses[i][0]+'  Iteration '+str(iter))
             impr.plot(Gnuplot.Data(L_F[i],title='Calcul'),Gnuplot.Data(res_exp[i],title='Experimental'))

   else:
     pass

