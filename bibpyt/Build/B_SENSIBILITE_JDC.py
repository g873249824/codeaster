#@ MODIF B_SENSIBILITE_JDC Build  DATE 18/12/2007   AUTEUR COURTOIS M.COURTOIS 
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
from B_SENSIBILITE_COMMANDES_SENSIBLES import SENSIBILITE_COMMANDES_SENSIBLES

class SENSIBILITE_JDC :
   """
   """
   def __init__(self,jdc):
      self.jdc = jdc
      self.commandes_sensibles = SENSIBILITE_COMMANDES_SENSIBLES()
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

      memo_sensi = self.jdc.memo_sensi
      if self.DEBUG :
        prbanner("Recherche de la sensibilit� du JDC : " + self.jdc.nom)

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

      # 2. Analyse des �tapes du jdc
      est_sensible = 0
      erreur = 0

      for etape in self.jdc.etapes:
        if self.DEBUG:
           print "\n. Etape : ",etape.nom

        # 2.1. L'�tape est une d�finition de param�tre sensible
        #      On m�morise la classe correspondant � la sd produite.
        if etape.nom is commande_memo_nom_sensi :
          print "La commande ",commande_memo_nom_sensi," est interdite dans un jeu de commandes."
          erreur = 1

        # 2.2. L'�tape est une d�finition de param�tre sensible
        elif etape.nom in l_commandes_defi_para_sensi :
          # on ajoute le para_sensi dans la sd de m�morisation
          memo_sensi.add_para_sensi(etape.sd)

        # 2.3. L'�tape est une commande qui r�alise un calcul de sensibilit�
        #      On parcourt tous les mots-cl�s qui sont renseign�s dans le jdc en examen
        #      Tant que ce n'est pas le mot-cl� de la sensibilit�, on ne fait rien.
        elif etape.nom in l_commandes_sensibles :
          # cherche le mot-cl� SENSIBILITE dans la liste des mots-cl�s et
          # m�morise le para_sensi ou para_autre utilis�
          est_sensible = memo_sensi.memo_para_sensi(etape.mc_liste, mot_cle) or est_sensible
          if self.DEBUG :
             print ".. Rep�rage de sensibilit� dans la commande ",etape.nom

      self.l_param_sensible = memo_sensi.get_l_para_sensi()
      self.l_param_autres   = memo_sensi.get_l_para_autre()

      if self.DEBUG :
        if est_sensible :
          print "\nR�capitulatif :"  
          for l_param in [self.l_param_sensible, self.l_param_autres] :
            liste = []
            for param in l_param :
              liste.append((param.nom,param))
            if l_param is self.l_param_sensible :
              txt = "sensibles"
            else :
              txt = "autres"
            print "Liste des param�tres "+txt+" : ",liste  
          texte = "est"
        else :
          texte = "n'est pas"
        prbanner("Le JDC "+texte+" concern� par la sensibilit�.")
        print "\nCode de retour : ",erreur 

      return erreur, est_sensible


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
      # 1. Pr�paration
      if self.DEBUG :
        print ". 1. Pr�paration"
      erreur = 0

      # 1.1. R�cup�ration des diff�rentes listes de commandes impliqu�es dans la d�rivation
      # l_commandes_a_deriver = liste des commandes � d�river si un de leurs arguments l'a �t�
      l_commandes_a_deriver = self.commandes_sensibles.get_l_commandes_a_deriver()
      # l_commandes_a_deriver_ensemble = liste des commandes � d�river dans tous les cas
      l_commandes_a_deriver_ensemble = self.commandes_sensibles.get_l_commandes_a_deriver_ensemble()
      # l_commandes_sensibles = liste des commandes qui pilotent la sensibilit�
      l_commandes_sensibles = self.commandes_sensibles.get_l_commandes_sensibles()
      # l_commandes_sensibles_princ = liste des commandes principales
      l_commandes_sensibles_princ = self.commandes_sensibles.get_l_commandes_sensibles_princ()
      # l_commandes_poursuite = liste des commandes qui pilotent une reprise de calcul
      l_commandes_poursuite = self.commandes_sensibles.get_l_commandes_poursuite()
      # commande m�morisant les noms pour la sensibilit�
      commande_memo_nom_sensi = self.commandes_sensibles.memo_nom_sensi

      mot_cle = self.commandes_sensibles.mot_cle

      # 1.2. Cr�ation de la classe qui m�morisera les noms des diff�rentes sd impliqu�es
      #      dans la sensibilit�. Elle est initialis�e avec la liste des sd par rapport auxquelles
      #      on d�rive.
      memo_sensi = self.jdc.memo_sensi
      if self.DEBUG :
        print "memo_sensi.get_l_para_sensi() = ", memo_sensi.get_l_para_sensi()

      # 1.3. Cr�ation de la classe qui contiendra les m�thodes des d�rivations du jdc
      #
      if self.DEBUG :
        print ".. Cr�ation d'une instance de la classe SENSIBILITE_DERIVATION"
      derivation = SENSIBILITE_DERIVATION(self.jdc,memo_sensi,commande_memo_nom_sensi,self.DEBUG)

      # 1.4. Certaines commandes, DEFI_MATERIAU par exemple, peuvent apparaitre plusieurs fois dans le jdc.
      #      Si l'une est concern�e par un param�tre sensible, toutes doivent etre d�riv�es
      #      par rapport � ce param�tre.
      #      On indique ici pour chaque param�tre quelles commandes sont � d�river d'office.
      if len (self.l_param_sensible) != 0 :
        for etape in self.jdc.etapes:
          if etape.isactif() :
            if etape.nom in l_commandes_a_deriver_ensemble :
              on_derive = 0
              l_sd_utilisees = etape.get_sd_utilisees()
              for param in self.l_param_sensible :
                for sd_u in l_sd_utilisees :
                  if sd_u is param :
                    memo_sensi.add_commande(param,etape.nom)

      # 1.5. Le calcul est-il une reprise depuis un calcul pr�c�dent ?
      #      Il suffit d'analyser la premi�re commande active.
      if not erreur :
        poursuite = 0
        for etape in self.jdc.etapes:
          print etape.nom
          if etape.isactif() :
            if etape.nom in l_commandes_poursuite :
              poursuite = 1
            break

        if self.DEBUG :
          print "Poursuite : ",poursuite

      # 2. Cr�ation du nouveau JDC
      #     Elle se fait avec les principaux arguments du jdc � modifier, en particulier le catalogue des commandes
      #     En cas de poursuite, il faut charger le contexte pour connaitre les objets d�ja construits.
      if not erreur :
        if self.DEBUG :
          print ". 2. Cr�ation du nouveau JDC"

        if poursuite :
          context_ini = self.jdc.g_context
        else :
          context_ini = None

        new_jdc = self.jdc.definition(cata=self.jdc.cata,appli=self.jdc.appli,procedure="#\n",context_ini=context_ini)
        new_jdc.actif_status=1

        # Le timer �tant initialis� dans E_SUPERV, on le transmet au nouveau jdc
        # (sinon il faudrait passer par N_JDC.JDC.__init__)
        new_jdc.timer = self.jdc.timer
        # idem memo_sensi
        new_jdc.memo_sensi = memo_sensi
        memo_sensi.reparent(new_jdc)
        
        new_jdc.compile()
        if not new_jdc.cr.estvide(): 
          self.MESSAGE("ERREUR DE COMPILATION DANS ACCAS - INTERRUPTION")
          print ">> JDC.py : DEBUT RAPPORT"
          print new_jdc.cr
          print ">> JDC.py : FIN RAPPORT"
          new_jdc.supprime()
          return 1, None

        new_jdc.exec_compile()
        if not new_jdc.cr.estvide(): 
          self.MESSAGE("ERREUR A L'INTERPRETATION DANS ACCAS - INTERRUPTION")
          print ">> JDC.py : DEBUT RAPPORT"
          print new_jdc.cr
          print ">> JDC.py : FIN RAPPORT"
          new_jdc.supprime()
          return 1, None

        CONTEXT.set_current_step(new_jdc)
        # Update du contexte : n�cessaire pour avoir les constantes (parameters)
        #                      dans le new_jdc
        new_jdc.const_context=self.jdc.const_context
        if self.DEBUG :
          print "Le nouveau JDC est cr�� en tant qu'objet : ",new_jdc

      # 3. On parcourt toutes les �tapes du JDC initial
      #    On ne s'occupe que des �tapes actives et qui ne sont pas des commentaires
      if ( not erreur and self.DEBUG ) :
        print ". 3. On parcourt toutes les �tapes du JDC initial"

      for etape in self.jdc.etapes :
        if self.DEBUG :
           print "\nAAAAAAAAAAAAAAAAA TRAITEMENT DE ",etape.nom," AAAAAAAAAAAAAAAAA"
        if etape.isactif() :
          if hasattr(etape,'sd') :
            # 3.1. Copie telle quelle de l'�tape initiale
            # on ne recopie pas l'etape (il ne faut oublier de lui donner comme parent le nouveau jdc : new_jdc)
            # new_etape = etape.full_copy(parent=new_jdc)
            new_etape = etape
            if self.DEBUG :
              print ".. L'�tape a �t� recopi�e � l'identique."

            # en cas de POURSUITE, la sd �tait dans jdc.g_context donc dans context_ini
            # et donc new_jdc.exec_compile l'a mise dans new_jdc.sds_dict ce qui empechera
            # l'enregistrement de new_etape (via append_reset)
            if etape.sd and poursuite and new_jdc.sds_dict.has_key(etape.sd.nom):
               del new_jdc.sds_dict[etape.sd.nom]

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
              new_jdc.append_reset(new_etape)

            # 3.3. Si l'�tape produit une sd, on va la d�river dans chacun des cas suivants :
            #        . C'est la d�finition d'un param�tre sensible stricto sensu
            #        . C'est la d�finition d'un param�tre sensible d'un autre type
            #        . La commande est � d�river obligatoirement ou car un de ses arguments
            #          est lui-meme issu d'une d�rivation par rapport � un param�tre sensible
            #        On remarque que ces cas sont exclusifs, d'o� un filtrage avec la variable a_faire.
            if etape.sd :
              a_faire = 1

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
                    # 3.3.3.1. R�cup�ration du dictionnaire des couples (nom simple,nom compos�)
                    # existant pour ce param�tre
                    d_nom_s_c = memo_sensi.get_d_nom_s_c(param)

                    # 3.3.3.2. Doit-on effectivement d�river par rapport au param�tre param ?
                    #         . Pour une commande du type '� d�river ensemble', on ne le fait
                    #           que si l'une d'entre elles est impliqu�e par le param�tre sensible.
                    #         . Pour une commande non n�cessairement � d�river, on recherche si
                    #           parmi les sd utilis�es par la commande, il y en a au moins une qui
                    #           a �t� d�riv�e par rapport � param
                    #           Remarque : plusieurs sd peuvent r�pondre � cela ; il suffit de d�crocher d�s
                    #           qu'une a �t� trouv�e car la d�rivation les prendra toutes en compte
                    on_derive = 0
                    if etape.nom in l_commandes_a_deriver_ensemble :
                      l_commandes = memo_sensi.get_l_commandes(param)
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

                    # 3.3.3.4. On doit d�river par rapport au param�tre param ; alors on y va ...
                    if on_derive :
                      # 3.3.3.4.1. Si la commande en elle-meme est � d�river, on y va
                      if etape.nom in l_commandes_a_deriver + l_commandes_a_deriver_ensemble :
                        if self.DEBUG :
                          print ".. Lancement de la d�rivation par derivation_commande"
                        erreur = derivation.derivation_commande(etape,param,new_jdc,d_nom_s_c)
                        if erreur : break
                      else :   
                        # 3.3.3.4.2. Sinon, il sufit de cr�er et de m�moriser un nouveau nom de sd.
                        #   On commence par v�rifier que cela n'a pas d�j� �t� fait. Cela arrive
                        #   quand un op�rateur est appel� plusieurs fois de suite.
                        if self.DEBUG :
                          print ".. Recherche d'un nouveau nom compos�"
                        nom_sd_derivee = memo_sensi.get_nom_compose(etape.sd,param)
                        if nom_sd_derivee is None:
                          nom_sd_derivee = derivation.get_nouveau_nom_sd()
                          memo_sensi.register(etape.sd, param, nom_sd_derivee, None, new_etape)

            # 3.3.4. Enregistrement final si cela n'a pas �t� fait
            if enregistrement_tardif :
                new_jdc.append_reset(new_etape)

          # 3.4. Message �ventuel
          if erreur :
            print ".. Probleme dans la d�rivation de ",etape.nom
            break
          if self.DEBUG :
            print ".. Fin du traitement avec erreur = ", erreur

      # 4. Dans le cas de poursuite, il faut dire que les bases ont d�j� �t� ouvertes
      if not erreur :
        if self.DEBUG :
          print ". 4. Cas de poursuite"

        if poursuite :
          new_jdc.ini = 1

        CONTEXT.unset_current_step()            

      # 5. Fin
      if self.DEBUG :
        print "\n. 5. Nouveau JDC"
        for etape in new_jdc.etapes:
          print "Etape : ",etape.nom
        print "\n. "
        print "\nCode de retour : ",erreur 
        prbanner("Fin de la cr�ation du JDC d�riv�.")
        # Affichage du contenu de la sd de m�morisation
        memo_sensi.print_memo()

      return erreur, new_jdc

