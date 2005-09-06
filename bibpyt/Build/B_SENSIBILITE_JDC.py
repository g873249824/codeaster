#@ MODIF B_SENSIBILITE_JDC Build  DATE 05/09/2005   AUTEUR DURAND C.DURAND 
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
Cette classe pilote les modifications de jdc dans le cas des calculs de sensibilit�.
Ces attributs sont :
jdc : le jdc � analyser. C'est l'objet obtenu apr�s les v�rifications d'usage et le
      traitement des macro-commandes �ventuelles. Il n'est modifi� par aucune des
      m�thodes de cette classe.
commandes_sensibles : classe SENSIBILITE_COMMANDES_SENSIBLES contenant toutes les
                      informations pour faire les modifications.
                      ce sont les listes des commandes d�clanchant le processus,
                      les commandes � d�river, etc.
Attention : aucun test n'a �t� fait quand une commande DETRUIRE est incluse dans le JDC.
Cela posera des probl�mes si c'est la destruction d'un concept impact� par la d�rivation.
"""
import copy

from Noyau.N_utils import prbanner
from B_SENSIBILITE_DERIVATION          import SENSIBILITE_DERIVATION
from B_SENSIBILITE_MEMO_NOM_SENSI      import SENSIBILITE_MEMO_NOM_SENSI
from B_SENSIBILITE_COMMANDES_SENSIBLES import SENSIBILITE_COMMANDES_SENSIBLES

class SENSIBILITE_JDC :
   """
   """
   def __init__(self,jdc):
      self.jdc = jdc
      self.commandes_sensibles = SENSIBILITE_COMMANDES_SENSIBLES()
#       print self.jdc
#       print self.commandes_sensibles
      if CONTEXT.debug :
        DEBUG = 1
      else :
        DEBUG = 0
      self.DEBUG = DEBUG
 
# ---------------------------------------------------------------------------
#           M�thodes li�es aux �tudes de sensibilit�
# ---------------------------------------------------------------------------

   def is_sensible(self) :
      """
      Retourne deux entiers :
      . erreur : 0 : tout s'est bien pass�
                 1 : une commande MEMO_NOM_SENSI est pr�sente dans le jdc
      . est_sensible : 1 : le jdc fait l'objet d'une �tude de sensibilit�
                       0 : pas de sensibilite dans ce jdc.
      Les param�tres concern�s sont m�moris�s. On a alors deux listes : les 'vrais' param�tres
      sensibles et les autres (champs theta par exemple)

      La technique est la suivante :
      . A priori, pas de sensibilit�.
      . On parcourt toutes les �tapes du jdc. Pour chacune d'elles :
       . Si l'�tape est une d�finition de param�tre sensible, on m�morise la sd produite.
       . Si l'�tape est une commande "sensible", on cherche dans ses donn�es la pr�sence d'une sd
         repr�sentant un param�tre sensible connu. Si oui, on d�clare qu'il y a de la sensibilit�
         et on m�morise la sd / param�tre sensible impliqu�e.
         
      """
#
      if self.DEBUG :
        prbanner("Recherche de la sensibilit� du JDC : " + self.jdc.nom)
#
# 1. R�cup�ration des caract�risations des commandes sensibles
# 1.1. mot cl� pilotant le calcul de sensibilit�. C'est sa pr�sence dans les commandes "sensibles"
#      qui caract�risera un calcul avec sensibilit�.
      mot_cle = self.commandes_sensibles.mot_cle
      if self.DEBUG :
        print "Mot cl� pilotant le calcul de sensibilit� = ", mot_cle

# 1.2. commande m�morisant les noms pour la sensibilit�
      commande_memo_nom_sensi = self.commandes_sensibles.memo_nom_sensi
      if self.DEBUG :
        print "Commande m�morisant les noms pour la sensibilit� = ", commande_memo_nom_sensi

# 1.3. liste des commandes de d�finition des param�tres sensibles
      l_commandes_defi_para_sensi = self.commandes_sensibles.get_l_commandes_defi_para_sensi()
      if self.DEBUG :
        print "Liste des commandes de d�finition des param�tres sensibles : ", l_commandes_defi_para_sensi

# 1.4. liste des commandes qui pilotent la sensibilit� (ce sont les commandes principales de calcul
#      thermique ou m�canique)
      l_commandes_sensibles = self.commandes_sensibles.get_l_commandes_sensibles()
      if self.DEBUG :
        print "Liste des commandes qui pilotent la sensibilit� : ", l_commandes_sensibles
#
# 2. Analyse des �tapes du jdc
#
      l_classe_para_sensi = []
      l_param_sensible = []
      l_param_autres = []
      est_sensible = 0
      erreur = 0
#
      for etape in self.jdc.etapes:
#        print "\n. Etape : ",etape.nom
#
# 2.1. L'�tape est une d�finition de param�tre sensible
#      On m�morise la classe correspondant � la sd produite.
#
        if etape.nom is commande_memo_nom_sensi :
          print "La commande ",commande_memo_nom_sensi," est interdite dans un jeu de commandes."
          erreur = 1
#
# 2.2. L'�tape est une d�finition de param�tre sensible
#      On m�morise la classe correspondant � la sd produite.
#
        elif etape.nom in l_commandes_defi_para_sensi :
          erreur0 = self.commandes_sensibles.add_classe_para_sensi(etape.sd.__class__)
          l_classe_para_sensi = self.commandes_sensibles.get_classe_para_sensi()
#
# 2.3. L'�tape est une commande qui r�alise un calcul de sensibilit�
#      On parcourt tous les mots-cl�s qui sont renseign�s dans le jdc en examen
#      Tant que ce n'est pas le mot-cl� de la sensibilit�, on ne fait rien.
#
        elif etape.nom in l_commandes_sensibles :
#
          for child in etape.mc_liste :

#           L'un des mots-cl�s renseign�s est celui de la sensibilit� : 
            if child.nom == mot_cle :
#             On d�clare etre en pr�sence d'un calcul sensible
              est_sensible = 1
              if self.DEBUG :
                print ".. Rep�rage de sensibilit� dans la commande ",etape.nom

#             On r�cup�re la liste des arguments associ�s � ce mot-cl�
              if type(child.valeur) in ( type(()),type([])):
                liste = child.valeur
              else:
                liste = [child.valeur]

#             Un argument peut etre de deux types :
#             . soit c'est un param�tre sensible stricto sensu ; on le sait en regardant
#               s'il fait partie des param�tres sensibles d�finis pr�c�demment dans le jdc
#             . soit c'est un autre type de param�tres de d�rivation (champ theta par exemple)
#             On parcourt donc tous les arguments pour faire le tri et les stocker dans
#             les 2 listes ad-hoc.
              for argu in liste :
                if self.DEBUG :
                  print ".... Param�tre sensible : ",argu.nom
                aux = 0
                for classe_para_sensi in l_classe_para_sensi :
                  if argu.__class__ is classe_para_sensi :
                    aux = 1
#
                if aux :
                  if argu not in l_param_sensible :
                    l_param_sensible.append(argu)
                else :  
                  if argu not in l_param_autres :
                    l_param_autres.append(argu)
#      
      self.l_param_sensible = l_param_sensible
      self.l_param_autres   = l_param_autres
#
      if self.DEBUG :
        if est_sensible :
          print "\nR�capitulatif :"  
          for l_param in [l_param_sensible,l_param_autres] :
            liste = []
            for param in l_param :
              liste.append((param.nom,param))
            if l_param is l_param_sensible :
              txt = "sensibles"
            else :
              txt = "autres"
            print "Liste des param�tres "+txt+" : ",liste  
          texte = "est"
        else :
          texte = "n'est pas"
        prbanner("Le JDC "+texte+" concern� par la sensibilit�.")
        print "\nCode de retour : ",erreur 
#
      return erreur, est_sensible
#
   def new_jdc(self) :
      """
      Construit un objet JDC copie de self augment�e des commandes de d�rivation
      Retourne :
      . erreur : ==0 : tout s'est bien pass�
                 !=0 : probl�me
      . le nouveau jdc
      """
      if self.DEBUG :
        prbanner("Cr�ation d'un JDC d�riv� � partir de : " + self.jdc.nom)
#
#      print "dans new_jdc : ",self.commandes_sensibles
#      print "l_param_sensible = ",self.l_param_sensible
#      print "l_param_autres = ",self.l_param_autres
# 1. Pr�paration
#
      if self.DEBUG :
        print ". 1. Pr�paration"
#
      erreur = 0
#
# 1.1. R�cup�ration des diff�rentes listes de commandes impliqu�es dans la d�rivation
#     l_commandes_a_deriver = liste des commandes � d�river si un de leurs arguments l'a �t�
      l_commandes_a_deriver = self.commandes_sensibles.get_l_commandes_a_deriver()
#     l_commandes_a_deriver_ensemble = liste des commandes � d�river dans tous les cas
      l_commandes_a_deriver_ensemble = self.commandes_sensibles.get_l_commandes_a_deriver_ensemble()
#     l_commandes_sensibles = liste des commandes qui pilotent la sensibilit�
      l_commandes_sensibles = self.commandes_sensibles.get_l_commandes_sensibles()
#     d_commandes_sensibles_speciales = dictionnaire des commandes � d�river selon les mots-cl�s
      d_commandes_sensibles_speciales = self.commandes_sensibles.get_d_commandes_sensibles_speciales()
#     l_commandes_poursuite = liste des commandes qui pilotent une reprise de calcul
      l_commandes_poursuite = self.commandes_sensibles.get_l_commandes_poursuite()
#     commande m�morisant les noms pour la sensibilit�
      commande_memo_nom_sensi = self.commandes_sensibles.memo_nom_sensi
#       print "Liste des commandes sensibles          : ", l_commandes_sensibles
#       print "Liste des commandes � d�river          : ", l_commandes_a_deriver
#       print "Liste des commandes � d�river ensemble : ", l_commandes_a_deriver_ensemble
#       print "Liste des commandes de poursuite       : ", l_commandes_poursuite
#       print "Commandes m�morisant des noms          : ", commande_memo_nom_sensi
#
      mot_cle = self.commandes_sensibles.mot_cle
#
# 1.2. Cr�ation de la classe qui m�morisera les noms des diff�rentes sd impliqu�es
#      dans la sensibilit�. Elle est initialis�e avec la liste des sd par rapport auxquelles
#      on d�rive.
#
      if self.DEBUG :
        print ".. Cr�ation d'une instance de la classe SENSIBILITE_MEMO_NOM_SENSI"
      memo_nom_sensi = SENSIBILITE_MEMO_NOM_SENSI(self.l_param_sensible+self.l_param_autres)
#       print "memo_nom_sensi.get_l_param_sensi() = ",memo_nom_sensi.get_l_param_sensi()

# 1.3. Cr�ation de la classe qui contiendra les m�thodes des d�rivations du jdc
#
      if self.DEBUG :
        print ".. Cr�ation d'une instance de la classe SENSIBILITE_DERIVATION"
      derivation = SENSIBILITE_DERIVATION(self.jdc,memo_nom_sensi,commande_memo_nom_sensi,self.DEBUG)

# 1.4. Certaines commandes, DEFI_MATERIAU par exemple, peuvent apparaitre plusieurs fois dans le jdc.
#      Si l'une est concern�e par un param�tre sensible, toutes doivent etre d�riv�es
#      par rapport � ce param�tre.
#      On indique ici pour chaque param�tre quelles commandes sont � d�river d'office.
#
      if len (self.l_param_sensible) != 0 :
        for etape in self.jdc.etapes:
          if etape.isactif() :
            if etape.nom in l_commandes_a_deriver_ensemble :
              on_derive = 0
              l_sd_utilisees = etape.get_sd_utilisees()
              for param in self.l_param_sensible :
                for sd_u in l_sd_utilisees :
                  if sd_u is param :
                    erreur = memo_nom_sensi.add_commande(param,etape.nom)
                    if erreur : break
#
# 1.5. Le calcul est-il une reprise depuis un calcul pr�c�dent ?
#      Il suffit d'analyser la premi�re commande active.
#
      if not erreur :
#
        poursuite = 0
        for etape in self.jdc.etapes:
          print etape.nom
          if etape.isactif() :
            if etape.nom in l_commandes_poursuite :
              poursuite = 1
            break
#
        if self.DEBUG :
          print "Poursuite : ",poursuite
#
# 2. Cr�ation du nouveau JDC
#     Elle se fait avec les principaux arguments du jdc � modifier, en particulier le catalogue des commandes
#     En cas de poursuite, il faut charger le contexte pour connaitre les objets d�ja construits.
#
      if not erreur :
#
        if self.DEBUG :
          print ". 2. Cr�ation du nouveau JDC"
#
        if poursuite :
          context_ini = self.jdc.g_context
        else :
          context_ini = None
#
        new_jdc = self.jdc.definition(cata=self.jdc.cata,appli=self.jdc.appli,procedure="#\n",context_ini=context_ini)
#
#### CD : Je suis oblige de reaffecter les attributs cpu au new_jdc. Ca ne me plait pas trop.
#### CD : il y aurait sans doute moyen de faire mieux (via __init__ du N_JDC)
        new_jdc.cpu_user=self.jdc.cpu_user
        new_jdc.cpu_syst=self.jdc.cpu_syst
#
        new_jdc.compile()
        if not new_jdc.cr.estvide(): 
          self.MESSAGE("ERREUR DE COMPILATION DANS ACCAS - INTERRUPTION")
          print ">> JDC.py : DEBUT RAPPORT"
          print new_jdc.cr
          print ">> JDC.py : FIN RAPPORT"
          new_jdc.supprime()
          sys.exit(0)
#
        new_jdc.exec_compile()
        if not new_jdc.cr.estvide(): 
          self.MESSAGE("ERREUR A L'INTERPRETATION DANS ACCAS - INTERRUPTION")
          print ">> JDC.py : DEBUT RAPPORT"
          print new_jdc.cr
          print ">> JDC.py : FIN RAPPORT"
          new_jdc.supprime()
          sys.exit(0)
#
        CONTEXT.set_current_step(new_jdc)
#
        if self.DEBUG :
          print "Le nouveau JDC est cr�� en tant qu'objet : ",new_jdc
#
# 3. On parcourt toutes les �tapes du JDC initial
#    On ne s'occupe que des �tapes actives et qui ne sont pas des commentaires
#
      if ( not erreur and self.DEBUG ) :
        print ". 3. On parcourt toutes les �tapes du JDC initial"
#
      for etape in self.jdc.etapes :
        if self.DEBUG :
           print "\nAAAAAAAAAAAAAAAAA TRAITEMENT DE ",etape.nom," AAAAAAAAAAAAAAAAA"
        if etape.isactif() :
          if hasattr(etape,'sd') :
        # 3.1. Copie telle quelle de l'�tape initiale
#            print "Lancement de la copie de ",etape.nom
            new_etape = etape.full_copy(parent=new_jdc)
#            print "Fin de la copie de ",etape.nom
            if self.DEBUG :
              print ".. L'�tape a �t� recopi�e � l'identique."

# 3.2. On rep�re si c'est une commande sensible ou non :
#        . Si c'est une commande sensible, elle va produire les sd d�riv�es en son sein. Ces
#          sd doivent avoir �t� d�clar�es dans MEMO_NOM_SENSI auparavant ; on
#          enregistrera donc la commande sensible apr�s.
#        . Sinon, il faut l'enregistrer tout de suite pour que la sd produite soit
#          connue avant l'appel � MEMO_NOM_SENSI
            if etape.nom in l_commandes_sensibles :
              enregistrement_tardif = 1
            else :
              enregistrement_tardif = 0
              new_jdc.register(new_etape)
#              print ". enregistrement immediat de  = ",etape.nom

# 3.3. Si l'�tape produit une sd, on va la d�river dans chacun des cas suivants :
#        . C'est la d�finition d'un param�tre sensible stricto sensu
#        . C'est la d�finition d'un param�tre sensible d'un autre type
#        . La commande est � d�river obligatoirement ou car un de ses arguments
#          est lui-meme issu d'une d�rivation par rapport � un param�tre sensible
#        On remarque que ces cas sont exclusifs, d'o� un filtrage avec la variable a_faire.
            if etape.sd :
              a_faire = 1
#              print "type(etape.definition.sd_prod) = ",type(etape.definition.sd_prod)

# 3.3.1. D�rivation d'une d�finition de param�tre sensible
#
              for param in self.l_param_sensible :
                if param is etape.sd :
                  if self.DEBUG :
                    print ".. Lancement de la d�rivation"
                  erreur = derivation.derivation_para_sensi(etape,param,new_jdc)
                  if erreur : break
                  a_faire = 0

# 3.3.2. D�rivation d'une d�finition de param�tre autre
#
              if a_faire :
                for param in self.l_param_autres :
                  if param is etape.sd :
                    if self.DEBUG :
                      print ".. Lancement de la d�rivation"
                    erreur = derivation.derivation_para_autre(etape,param,new_jdc)
                    if erreur : break
                    a_faire = 0

# 3.3.3. D�rivation d'un autre type de commande
#          Remarques :
#          . Les seules commandes concern�es sont les commandes sensibles ou � d�river
#          . On r�p�te l'op�ration pour chacun des param�tres de d�rivation effectifs
              if a_faire :
                if etape.nom in l_commandes_sensibles + l_commandes_a_deriver + l_commandes_a_deriver_ensemble :
                  for param in self.l_param_sensible + self.l_param_autres :

# 3.3.3.1. R�cup�ration du dictionnaire des couples (nom simple,nom compos�) existant pour ce param�tre
                    erreur,d_nom_s_c = memo_nom_sensi.get_d_nom_s_c(param)
                    if erreur : break
#
# 3.3.3.2. Doit-on effectivement d�river par rapport au param�tre param ?
#         . Pour une commande du type '� d�river ensemble', on ne le fait que si l'une d'entre
#           elles est impliqu�e par le param�tre sensible.
#         . Pour une commande non n�cessairement � d�river, on recherche si parmi les sd utilis�es
#           par la commande, il y en a au moins une qui a �t� d�riv�e par rapport � param
#           Remarque : plusieurs sd peuvent r�pondre � cela ; il suffit de d�crocher d�s
#           qu'une a �t� trouv�e car la d�rivation les prendra toutes en compte
#
                    on_derive = 0
                    if etape.nom in l_commandes_a_deriver_ensemble :
                      erreur, l_commandes = memo_nom_sensi.get_l_commandes(param)
                      if erreur : break
                      if etape.nom in l_commandes :
                        on_derive = 1
                    else :
                      l_sd_utilisees = etape.get_sd_utilisees()
                      for sd_u in l_sd_utilisees :
                        for sd_d in d_nom_s_c.keys() :
                          if sd_u is sd_d :
                            on_derive = 1
                      if on_derive :
                        if etape.nom not in l_commandes_sensibles :
                          daux = etape.get_sd_mcs_utilisees()
                          if self.DEBUG :
                            print ".. Dictionnaire des sd utilis�es : ", daux
                          if daux.has_key(mot_cle) : on_derive = 0
# 3.3.3.3. Remarque : certaines commandes, comme CREA_CHAMP par exemple, doivent etre trait�es
#          avec sagesse. En effet, soit elles sont utilis�es pour pr�parer le calcul et doivent
#          alors etre d�riv�es ; soit elles sont utilis�es en post-traitement et ne doivent pas
#          l'etre. Le tri se fait en fonction de valeurs de mot-cl�s renseign�s en dur.
                    if on_derive :
                      if d_commandes_sensibles_speciales.has_key(etape.nom) :
                        d_aux = d_commandes_sensibles_speciales[etape.nom]
                        on_derive = derivation.derivation_speciale(etape,d_aux)
# 3.3.3.4. On doit d�river par rapport au param�tre param ; alors on y va ...
                    if on_derive :
# 3.3.3.4.1. Si la commande en elle-meme est � d�river, on y va
                      if etape.nom in l_commandes_a_deriver + l_commandes_a_deriver_ensemble :
                        if self.DEBUG :
                          print ".. Lancement de la d�rivation par derivation_commande"
                        erreur = derivation.derivation_commande(etape,param,new_jdc,d_nom_s_c)
                        if erreur : break
                      else :   
# 3.3.3.4.2. Sinon, il sufit de cr�er et de m�moriser un nouveau nom de sd. On commence par v�rifier que cela
#            n'a pas d�j� �t� fait. Cela arrive quand un op�rateur est appel� plusieurs fois de suite.
#            Quand le nom est nouveau, il faut l'enregistrer dans le JDC via la commande MEM0_NON_SENSI
                        if self.DEBUG :
                          print ".. Recherche d'un nouveau nom compos�"
                        erreur, nom_sd_derivee = memo_nom_sensi.get_nom_compose(etape.sd,param)
                        if erreur == 2 : 
                          nom_sd_derivee = derivation.get_nouveau_nom_sd()
                          erreur = memo_nom_sensi.add_nom_compose(etape.sd,param,nom_sd_derivee)
                          if erreur : break
#                          print "... code de retour de memo_nom_sensi.add_nom_compose = ",erreur
                          if erreur == 0 : 
                            txt = derivation.get_texte_memo_nom_sensi_compose(etape.sd.nom,param.nom,nom_sd_derivee,None)
                            exec txt in new_jdc.g_context

# 3.3.4. Enregistrement final si cela n'a pas �t� fait
            if enregistrement_tardif :
               new_jdc.register(new_etape)
#               print ". enregistrement tardif de  = ",etape.nom
#
# 3.4. Message �ventuel
          if erreur :
            print ".. Probleme dans la d�rivation de ",etape.nom
            break
          if self.DEBUG :
            print ".. Fin du traitement avec erreur = ", erreur
#
# 4. Dans le cas de poursuite, il faut dire que les bases ont d�j� �t� ouvertes
#
      if not erreur :
#
        if self.DEBUG :
          print ". 4. Cas de poursuite"
#
        if poursuite :
          new_jdc.ini = 1
#
        CONTEXT.unset_current_step()            
#
# 5. Fin
#
      if self.DEBUG :
        print "\n. 5. Nouveau JDC"
        for etape in new_jdc.etapes:
          print "Etape : ",etape.nom
        print "\n. "
        print "\nCode de retour : ",erreur 
        prbanner("Fin de la cr�ation du JDC d�riv�.")
#
      return erreur, new_jdc
