#@ MODIF B_SENSIBILITE_DERIVATION Build  DATE 11/05/2010   AUTEUR COURTOIS M.COURTOIS 
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

"""

from types import FunctionType
from Noyau.N_ASSD import ASSD
from Noyau.N_types import is_float, is_list, is_enum
from B_SENSIBILITE_COMMANDES_SENSIBLES import SENSIBILITE_COMMANDES_SENSIBLES


class SENSIBILITE_DERIVATION :
   """
   Classe des m�thodes li�es aux d�rivations des commandes d'un jdc
   jdc = jeu de commandes en cours de traitement. Il est inchang� ici.
   memo_nom_sensi = m�morisation des noms li�s � la sensibilit�
   commande_MEMO_NOM_SENSI = compmande de m�morisation des noms li�s � la sensibilit�
   reel = la valeur r�elle � sustituer aux r�els dans une d�rivation
   l_nom_sd_prod = liste des noms des sd produites par le jdc � la cr�ation
                   de la classe
   l_nouveaux_noms = liste des nouveaux noms d�j� cr��s
   definition_param_sensi = faux tant que l'on n'a pas examin� une commande
                            d�finissant un param�tre sensible
   definition_param_autre = faux tant que l'on n'a pas examin� une commande
                            d�finissant un param�tre autre
   """
#
# ---------- D�but du constructeur ----------
#
   def __init__(self,jdc,memo_sensi,commande_memo_nom_sensi,DEBUG=None) :
#
       DEBUG_defaut = 0
       self.jdc = jdc
       self.memo_sensi = memo_sensi
       self.commande_memo_nom_sensi = commande_memo_nom_sensi
       self.DEBUG = DEBUG or DEBUG_defaut
       commandes_sensibles = SENSIBILITE_COMMANDES_SENSIBLES()
       self.l_commandes_sensibles_princ = commandes_sensibles.get_l_commandes_sensibles_princ()
#
       self.reel = None
       self.l_nom_sd_prod = []
       if jdc :
         for sd in self.jdc.sds :
           self.l_nom_sd_prod.append(sd.nom)
       self.l_nouveaux_noms = []
       self.definition_param_sensi = 0
       self.definition_param_autre = 0
       d0 = {}
       d0["ps"] = None
       d0["pa"] = None
       self.fonction_0 = d0
       d1 = {}
       d1["ps"] = None
       d1["pa"] = None
       self.fonction_1 = d1
#
# ---------- Fin du constructeur ----------
#
   def get_jdc(self) :
       """
       R�cup�re le jdc associ�
       """
       return self.jdc


   def get_l_nouveaux_noms(self) :
       """
       R�cup�re la liste des nouveaux noms d�j� cr��s
       """
       return self.l_nouveaux_noms


   def get_l_nom_sd_prod(self) :
       """
       R�cup�re la liste des noms des sd produites par le jdc � la cr�ation de la classe
       """
       return self.l_nom_sd_prod


   def put_fonction_0(self,fonction_0,type_para) :
       """
       Enregistre la fonction nulle
       Code de retour :  0, tout va bien
             1, la fonction nulle est d�j� enregistr�e
       """
       if self.fonction_0[type_para] :
         codret = 1
       else :
         codret = 0
         self.fonction_0[type_para] = fonction_0
       return codret


   def get_fonction_0(self,type_para) :
       """
       R�cup�re la fonction nulle associ�e
       """
       return self.fonction_0[type_para]


   def put_fonction_1(self,fonction_1,type_para) :
       """
       Enregistre la fonction unit�
       Code de retour :  0, tout va bien
                         1, la fonction unit� est d�j� enregistr�e
       """
       if self.fonction_1[type_para] :
         codret = 1
       else :
         codret = 0
         self.fonction_1[type_para] = fonction_1
       return codret


   def get_fonction_1(self,type_para) :
       """
       R�cup�re la fonction unit� associ�e
       """
       return self.fonction_1[type_para]


   def derivation_para_sensi(self,etape,param,new_jdc) :
       """
       D�rive une �tape de d�finition d'un param�tre sensible
       Au premier appel � ce traitement :
        . On duplique deux fois la commande :
          . la premi�re fois, c'est pour lui mettre une d�riv�e nulle ; pour cela, on simule
            une d�rivation par rapport � n'importe quoi
          . la seconde fois, on obtient la d�riv�e par rapport � lui-meme, c'est-�-dire 1.
        . On m�morise les noms de ces nouvelles fonctions comme �tant des
          fonctions nulle et unit�.
       Aux appels suivants, on ne fait que la d�rivation du param�tre par rapport � lui-meme.
       """
       codret = 0
       if not self.definition_param_sensi :
         for nrpass in range(2) :
         # Cr�ation et enregistrement de la commande d�riv�e
           reel = float(nrpass)
           etape_derivee, l_mcf_mcs_val_derives = self.derivation(etape,reel,None,new_jdc)
           new_jdc.register(etape_derivee)
           if nrpass == 1 :
             # Au 2nd passage :
             # . m�morisation du nom de la structure d�riv�e : d�rivation du param�tre par lui-meme
             self.memo_sensi.register(etape.sd, param, etape_derivee.sd, l_mcf_mcs_val_derives)
             
           # M�morisation des deux fonctions d�riv�es cr��es, en tant que fonction nulle et fonction unit�.
           if nrpass == 0 :
           # Au 1er passage :
           # . m�morisation de la fonction en tant que fonction nulle
             codret = self.put_fonction_0(etape_derivee.sd,"ps")
             if ( codret ) : break
           else :
             # Au 2nd passage :
             # . m�morisation de la fonction en tant que fonction unite
             codret = self.put_fonction_1(etape_derivee.sd,"ps")
             if ( codret ) : break
         self.definition_param_sensi = 1

       else :
         fonction_1 = self.get_fonction_1("ps")
         self.memo_sensi.register(etape.sd, param, fonction_1, None)

       if ( codret ) : print ".... Probleme dans derivation_para_sensi pour ", etape.nom, " et ", param
       return codret


   def derivation_para_autre(self,etape,param,new_jdc) :
       """
       D�rive une �tape de d�finition d'un param�tre autre
       Au premier appel � ce traitement :
        . On duplique deux fois la commande :
          . la premi�re fois, c'est pour lui mettre une d�riv�e nulle ; pour cela, on simule
            une d�rivation par rapport � n'importe quoi
          . la seconde fois, on obtient la d�riv�e par rapport � lui-meme, c'est-�-dire 1.
          Dans les deux cas, rien n'est chang�.
        . On m�morise les noms de ces nouvelles fonctions comme �tant des
          fonctions nulle et unit�.
       Aux appels suivants, on ne fait que la d�rivation du param�tre par rapport � lui-meme.
       """
       codret = 0
       if not self.definition_param_autre :
         for nrpass in range(2) :
           # Cr�ation et enregistrement de la commande d�riv�e
           reel = None
           etape_derivee, l_mcf_mcs_val_derives = self.derivation(etape,reel,None,new_jdc)
           new_jdc.register(etape_derivee)
           if nrpass == 1 :
             # Au 2nd passage :
             # . m�morisation du nom de la structure d�riv�e : d�rivation du param�tre par lui-meme
             self.memo_sensi.register(etape.sd, param, etape_derivee.sd, l_mcf_mcs_val_derives)
             
           # M�morisation des deux fonctions d�riv�es cr��es, en tant que fonction nulle et fonction unit�.
           if nrpass == 0 :
           # Au 1er passage :
           # . m�morisation de la fonction en tant que fonction nulle
             codret = self.put_fonction_0(etape_derivee.sd,"pa")
             if ( codret ) : break
           else :
             # Au 2nd passage :
             # . m�morisation de la fonction en tant que fonction unite
             codret = self.put_fonction_1(etape_derivee.sd,"pa")
             if ( codret ) : break
         self.definition_param_autre = 1

       else :
         f_1 = self.get_fonction_1("pa")
         self.memo_sensi.register(etape.sd, param, f_1, None)

       if ( codret ) : print ".... Probleme dans derivation_para_autre pour ", etape.nom, " et ", param
       return codret


   def derivation_commande(self,etape,param,new_jdc,d_nom_s_c) :
       """
       D�rive une �tape de commande autre que la d�finition de param�tre sensible
       """
       # Cr�ation et enregistrement de la commande d�riv�e
       reel = 0.
       if self.DEBUG :
         print ".. Lancement de la d�rivation de ",etape.nom
       etape_derivee, l_mcf_mcs_val_derives = self.derivation(etape,reel,d_nom_s_c,new_jdc)
       new_jdc.register(etape_derivee)
       if self.DEBUG :
         print ".. Ajout d'un nom compos�"
       self.memo_sensi.register(etape.sd, param, etape_derivee.sd, l_mcf_mcs_val_derives)
       codret = 0
       return codret


   def derivation(self,etape,reel,d_nom_s_c,new_jdc) :
       """
       Cr�e l'�tape d�riv�e de l'�tape pass�e en argument
       Retourne l'�tape d�riv�e et la liste des mots-cl�s concern�s
       par la d�rivation de leur valeur
       """
       if self.DEBUG :
         print ".... Lancement de la copie pour d�rivation de ",etape.nom
       etape_derivee = etape.copy()
       etape_derivee.reparent(new_jdc)
       sd_derivee = etape.sd.__class__(etape=etape_derivee)
       nom_sd_derivee = self.get_nouveau_nom_sd()
       etape_derivee.sd = sd_derivee
       if etape_derivee.reuse == None :
         new_jdc.NommerSdprod(sd_derivee,nom_sd_derivee)
       else :
         sd_derivee.nom = nom_sd_derivee
       etape_derivee.sdnom = nom_sd_derivee
       self.reel = reel
       self.d_nom_s_c = d_nom_s_c
       l_mcf_mcs_val_derives = self.derive_etape(etape_derivee,new_jdc)
       if self.DEBUG :
         print ".... Fin de la copie pour d�rivation de ",etape.nom
         print "     avec l_mcf_mcs_val_derives = ", l_mcf_mcs_val_derives
       return etape_derivee, l_mcf_mcs_val_derives
#
#  ========== ========== ========== D�but ========== ========== ==========
#  Les m�thodes qui suivent servent � modifier les arguments de la commande
#  en cours de d�rivation selon qu'ils sont r�els, d�riv�s ou autre
#
   def derive_etape(self,etape,new_jdc) :
       """
       R�alise la d�rivation des arguments de l'�tape pass�e en argument
         - remplace tous les r�els par 'reel' (prudence !!!)
         - quand un argument poss�de une d�riv�e, on la met � la place
         - remplace toutes les autres fonctions par 'fonction_nulle'
       Retourne la liste des tuples (mot-cl� facteur, mot-cl� simple, valeur(s)) concern�s
       par la d�rivation de leur valeur.
       """
       liste = []
       mcf_mcs_val_derive = None
       for child in etape.mc_liste :
         if self.DEBUG :
           print "...... derive_etape : child.nom    = ",child.nom
           print "...... derive_etape : child.nature = ",child.nature
         if child.nature == 'MCSIMP' :
           mcf_mcs_val_derive = self.derive_mcsimp(None,child,new_jdc)
           if mcf_mcs_val_derive :
             liste.append(mcf_mcs_val_derive)
         elif child.nature in ('MCFACT','MCBLOC') :
           liste = liste + self.derive_mccompo(child,new_jdc)
         elif child.nature == 'MCList' :
           liste = liste + self.derive_mcliste(child,new_jdc)

       l_mcf_mcs_val_derives = []
       for mcf_mcs_val in liste :
         if mcf_mcs_val not in l_mcf_mcs_val_derives :
           l_mcf_mcs_val_derives.append(mcf_mcs_val)
       return l_mcf_mcs_val_derives       


   def derive_mccompo(self,mc,new_jdc) :
       """
       D�rive en place le mccompo pass� en argument 
       Retourne la liste des tuples (mot-cl� facteur, mot-cl� simple, valeur(s)) concern�s
       par la d�rivation de leur valeur.
       """
       liste = []
       for child in mc.mc_liste :
         if child.nature == 'MCSIMP' :
           mcf_mcs_val_derive = self.derive_mcsimp(mc,child,new_jdc)
           if mcf_mcs_val_derive :
             liste.append(mcf_mcs_val_derive)
         elif child.nature == 'MCBLOC' :
           liste = liste + self.derive_mccompo(child,new_jdc)
         elif child.nature == 'MCList' :
           liste = liste + self.derive_mcliste(child,new_jdc)
       return liste


   def derive_mcliste(self,mc,new_jdc) :
       """
       D�rive en place la MCList pass�e en argument
       Retourne la liste des tuples (mot-cl� facteur, mot-cl� simple, valeur(s)) concern�s
       par la d�rivation de leur valeur.
       """
       liste = []
       for child in mc.data :
         liste = liste + self.derive_mccompo(child,new_jdc)
       return liste 


   def derive_mcsimp(self,mcfact,mcsimp,new_jdc) :
       """
       D�rive le mcsimp pass� en argument. Ce mot-cl� simple est �ventuellement sous
       un mot-cl� facteur.
       Retourne None ou le tuple (mot-cl� facteur, mot-cl� simple, valeur(s)) concern�
       par la d�rivation.
       """ 
       mcf_mcs_val_derive = None

       # 0. Pr�alable pour g�rer l'enchainement des elif
       ok_objet = 0
       if self.d_nom_s_c is not None :
         if mcsimp.valeur in self.d_nom_s_c.keys() :
           ok_objet = 1

       # 1. La valeur est un reel isol� : sa d�riv�e est le r�el associ�
       if is_float(mcsimp.valeur):
         if self.reel is not None :
           mcsimp.valeur = self.reel

       # 2. La valeur est un objet qui poss�de un objet d�riv� : sa d�riv�e est connue
       elif ok_objet :
         mcf_mcs_val_derive = (mcfact,mcsimp,mcsimp.valeur)
         mcsimp.valeur = self.d_nom_s_c[mcsimp.valeur]

       # 3. La valeur est un objet : sa d�riv�e est la fonction nulle
       elif isinstance(mcsimp.valeur, ASSD):
         if isinstance(mcsimp.valeur,new_jdc.g_context['fonction_sdaster']) :
           mcsimp.valeur = self.fonction_0["ps"]

       # 4. La valeur est une liste ou un tuple : on applique les �tapes 1, 2 et 3 � chacun
       # de ses �l�ments et on reconstitue une liste ou un tuple avec les d�riv�s.
       elif is_enum(mcsimp.valeur):
         aux = [ ]
         for val in mcsimp.valeur :
           if is_enum(val):
             if self.reel is not None :
               val_nouv = self.reel
             else :
               val_nouv = val
           elif val in self.d_nom_s_c.keys() :
             mcf_mcs_val_derive = (mcfact,mcsimp,mcsimp.valeur)
             val_nouv = self.d_nom_s_c[val]
           elif isinstance(val, ASSD):
             if isinstance(val,new_jdc.g_context['fonction_sdaster']) :
               val_nouv = self.fonction_0["ps"]
             else :
               val_nouv = val
           else :
             val_nouv = val
           aux.append(val_nouv)
         if is_list(mcsimp.valeur):
           mcsimp.valeur = aux
         else :
           mcsimp.valeur = tuple(aux)
       return mcf_mcs_val_derive       


   def derivation_speciale(self,etape,d_mc) :
       """
       V�rifie si la commande doit vraiment etre d�riv�e, compte-tenu de ses param�tres.
       D�s que l'on trouve une cause de d�rivation, on le note et on sort.
       """
       on_derive = 0
       if self.DEBUG :
         print ".. Test de la d�rivation sp�ciale de ",etape.nom
         print ".. Dictionnaire des autorisations : ",d_mc
         print ".. Liste des mots-cl�s autoris�s  : ",d_mc.keys()
       for child in etape.mc_liste :
         if self.DEBUG :
           print " "
           print ".... derivation_speciale : child        = ",child
           print ".... derivation_speciale : child.nom    = ",child.nom
           print ".... derivation_speciale : child.nature = ",child.nature
         if child.nature == 'MCSIMP' :
           ok = self.derive_speciale_mcsimp(child,d_mc)
         elif child.nature in ('MCFACT','MCBLOC') :
           ok = self.derive_speciale_mccompo(child,d_mc)
         elif child.nature == 'MCList' :
           ok = self.derive_speciale_mcliste(child,d_mc)
         if ok :
           on_derive = 1
           break
       return on_derive

   
   def derive_speciale_mcsimp(self,mcsimp,d_mc) :
       """
       Cherche si le mcsimp pass� en argument a sa valeur dans la liste associ�e.
       """ 
       ok = 0
       if mcsimp.nom in d_mc.keys() :
         if mcsimp.valeur in d_mc[mcsimp.nom] :
           ok = 1
       return ok       


   def derive_speciale_mccompo(self,mc,d_mc) :
       """
       Cherche si le mc pass� en argument a sa valeur dans la liste associ�e.
       D�s que l'on trouve une cause de d�rivation, on le note et on sort.
       """
       ok = 0
       for child in mc.mc_liste :
         if child.nature == 'MCSIMP' :
           ok = self.derive_speciale_mcsimp(child,d_mc)
         elif child.nature == 'MCBLOC' :
           ok = self.derive_speciale_mccompo(child,d_mc)
         elif child.nature == 'MCList' :
           ok = self.derive_speciale_mcliste(child,d_mc)
         if ok :
            break
       return ok


   def derive_speciale_mcliste(self,mc,d_mc) :
       """
       Cherche si le mc pass� en argument a sa valeur dans la liste associ�e.
       D�s que l'on trouve une cause de d�rivation, on le note et on sort.
       """
       ok = 0
       for child in mc.data :
         ok = self.derive_speciale_mccompo(child,d_mc)
         if ok :
           break
       return ok
#
#  ========== ========== ========== Fin ========== ========== ==========


   def get_nouveau_nom_sd(self) :
       """
       Retourne un nom de sd jamais utilis�
       Ajoute ce nom � la liste des noms de sd utilis�es par le jdc en cours
       """
       i = 9999999
       nouveau_nom_sd = 'S' + str(i)
       while nouveau_nom_sd in self.l_nom_sd_prod + self.l_nouveaux_noms :
         i = i - 1
         nouveau_nom_sd = 'S' + str(i)
       self.l_nouveaux_noms.append(nouveau_nom_sd)
       return nouveau_nom_sd         

