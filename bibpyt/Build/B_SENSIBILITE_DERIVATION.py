#@ MODIF B_SENSIBILITE_DERIVATION Build  DATE 01/07/2003   AUTEUR GNICOLAS G.NICOLAS 
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
import types

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
   """
#
# ---------- D�but du constructeur ----------
#
   def __init__(self,jdc,memo_nom_sensi,commande_memo_nom_sensi,DEBUG=None) :
#
       DEBUG_defaut = 0
       self.jdc = jdc
       self.memo_nom_sensi = memo_nom_sensi
       self.commande_memo_nom_sensi = commande_memo_nom_sensi
       self.DEBUG = DEBUG or DEBUG_defaut
#
       self.reel = None
       self.l_nom_sd_prod = []
       if jdc :
         for sd in self.jdc.sds :
           self.l_nom_sd_prod.append(sd.nom)
       self.l_nouveaux_noms = []
       self.definition_param_sensi = 0
       self.fonction_0 = None
       self.fonction_1 = None
#
# ---------- Fin du constructeur ----------
#
   def get_jdc(self) :
       """
       R�cup�re le jdc associ�
       """
       return self.jdc
#
   def get_l_nouveaux_noms(self) :
       """
       R�cup�re la liste des nouveaux noms d�j� cr��s
       """
       return self.l_nouveaux_noms
#
   def get_l_nom_sd_prod(self) :
       """
       R�cup�re la liste des noms des sd produites par le jdc � la cr�ation de la classe
       """
       return self.l_nom_sd_prod
#
   def put_fonction_0(self,fonction_0) :
       """
       Enregistre la fonction nulle
       Code de retour :  0, tout va bien
             1, la fonction nulle est d�j� enregistr�e
       """
       if self.fonction_0 :
         codret = 1
       else :
         codret = 0
         self.fonction_0 = fonction_0
       return codret
#
   def get_fonction_0(self) :
       """
       R�cup�re la fonction nulle associ�e
       """
       return self.fonction_0
#
   def put_fonction_1(self,fonction_1) :
       """
       Enregistre la fonction unit�
       Code de retour :  0, tout va bien
                         1, la fonction nulle est d�j� enregistr�e
       """
       if self.fonction_1 :
         codret = 1
       else :
         codret = 0
         self.fonction_1 = fonction_1
       return codret
#
   def get_fonction_1(self) :
       """
       R�cup�re la fonction unit� associ�e
       """
       return self.fonction_1
#
   def derivation_para_sensi(self,etape,param,new_jdc) :
       """
       D�rive une �tape de d�finition d'un param�tre sensible
       Au tout appel � ce traitement :
        . On dupliquera deux fois la commande :
          . la premi�re fois, c'est pour lui mettre une d�riv�e nulle ; pour cela, on simule
            une d�rivation par rapport � n'importe quoi
          . la seconde fois, on obtient la d�riv�e par rapport � lui-meme, c'est-�-dire 1.
        . On m�morise les noms de ces nouvelles fonctions comme �tant des
          fonctions nulle et unit�.
       Aux appels suivants, on ne fait que la d�rivation du param�tre par rapport � lui-meme.
       """

       if not self.definition_param_sensi :
         for nrpass in range(2) :
#        Cr�ation et enregistrement de la commande d�riv�e
           reel = float(nrpass)
           etape_derivee, l_mc_derives = self.derivation(etape,reel,None,new_jdc)
           new_jdc.register(etape_derivee)
           if nrpass == 1 :
             # Au 2nd passage :
             # . m�morisation du nom de la structure d�riv�e : d�rivation du param�tre par lui-meme
             codret = self.memo_nom_sensi.add_nom_compose(etape.sd,param,etape_derivee.sd)
             txt = self.get_texte_memo_nom_sensi_compose(etape.sd.nom,param.nom,etape_derivee.sd.nom,l_mc_derives)
             exec txt in new_jdc.g_context
#          M�morisation des deux fonctions d�riv�es cr��es, en tant que fonction nulle et fonction unit�.
           if nrpass == 0 :
           # Au 1er passage :
           # . m�morisation de la fonction en tant que fonction nulle
             codret = self.put_fonction_0(etape_derivee.sd)
#             txt = self.get_texte_memo_nom_sensi_zero(etape_derivee.sd.nom)
#             print txt
#             exec txt in new_jdc.g_context
           else :
             # Au 2nd passage :
             # . m�morisation de la fonction en tant que fonction unite
              codret = self.put_fonction_1(etape_derivee.sd)
#              txt = self.get_texte_memo_nom_sensi_un(etape_derivee.sd.nom)
#             print txt
#             exec txt in new_jdc.g_context
         self.definition_param_sensi = 1

       else :
         fonction_1 = self.get_fonction_1()
         codret = self.memo_nom_sensi.add_nom_compose(etape.sd,param,fonction_1)
         txt = self.get_texte_memo_nom_sensi_compose(etape.sd.nom,param.nom,fonction_1.nom,None)
         exec txt in new_jdc.g_context

       codret = 0
       return codret
#
   def derivation_commande(self,etape,param,new_jdc,d_nom_s_c) :
       """
       D�rive une �tape de commande autre que la d�finition de param�tre sensible
       """
#       Cr�ation et enregistrement de la commande d�riv�e
       reel = 0.
       etape_derivee, l_mc_derives = self.derivation(etape,reel,d_nom_s_c,new_jdc)
       new_jdc.register(etape_derivee)
       codret = self.memo_nom_sensi.add_nom_compose(etape.sd,param,etape_derivee.sd)
       if codret == 0 :
         txt = self.get_texte_memo_nom_sensi_compose(etape.sd.nom,param.nom,etape_derivee.sd.nom,l_mc_derives)
         exec txt in new_jdc.g_context
       codret = 0
       return codret
#
   def derivation(self,etape,reel,d_nom_s_c,new_jdc) :
       """
       Cr�e l'�tape d�riv�e de l'�tape pass�e en argument
       Retourne l'�tape d�riv�e et la liste des mot-cl�s concern�s
       par la d�rivation de leur valeur
       """
#       print ".... Appel de derivation avec ",etape,reel,d_nom_s_c
       if self.DEBUG :
         print ".... Lancement de la copie pour d�rivation de ",etape.nom
       etape_derivee = etape.copy()
       etape_derivee.reparent(new_jdc)
#       print "...... Fin de la copie pour d�rivation de ",etape.nom
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
       l_mc_derives = self.derive_etape(etape_derivee,new_jdc)
       return etape_derivee, l_mc_derives
#
#  ========== ========== ========== D�but ========== ========== ==========
#  Les m�thodes qui suivent servent � modifier les arguments de la commande
#  en cours de d�rivation selon qu'ils sont r�els, d�riv�s ou autre
#
   def derive_etape(self,etape,new_jdc) :
       """
       R�alise la d�rivation des arguments de l'�tape pass�e en argument
         - remplace tous les r�els par reel (prudence !!!)
         - quand un argument poss�de une d�riv�e, on la met � la place
         - remplace toutes les autres fonctions par fonction_nulle
       Retourne la liste des mots-cl�s concern�s par la d�rivation de leur valeur 
       """
       liste = []
       mc_derive = None
       for child in etape.mc_liste :
         if child.nature == 'MCSIMP' :
           mc_derive = self.derive_mcsimp(None,child,new_jdc)
           if mc_derive :
             liste.append(mc_derive)
         elif child.nature in ('MCFACT','MCBLOC') :
           liste = liste + self.derive_mccompo(child,new_jdc)
         elif child.nature == 'MCList' :
           liste = liste + self.derive_mcliste(child,new_jdc)

       l_mc_derives = []
       for mc in liste :
         if mc not in l_mc_derives :
           l_mc_derives.append(mc)
       return l_mc_derives       
#
   def derive_mccompo(self,mc,new_jdc) :
       """
       D�rive en place le mccompo pass� en argument 
       Retourne la liste des mots_cl�s concern�s par la d�rivation de leur valeur
       """
       liste = []
       for child in mc.mc_liste :
         if child.nature == 'MCSIMP' :
           mc_derive = self.derive_mcsimp(mc,child,new_jdc)
           if mc_derive :
             liste.append(mc_derive)
         elif child.nature == 'MCBLOC' :
           liste = liste + self.derive_mccompo(child,new_jdc)
#
       return liste
#
   def derive_mcliste(self,mc,new_jdc) :
       """
       D�rive en place la MCList pass�e en argument
       Retourne la liste des mots_cl�s concern�s par la d�rivation de leur valeur
       """
       liste = []
       for child in mc.data :
         liste = liste + self.derive_mccompo(child,new_jdc)
       return liste 
   
   def derive_mcsimp(self,mcfact,mcsimp,new_jdc) :
       """
       D�rive le mcsimp pass� en argument
       Retourne None ou le tuple (mot-cl� facteur, mot-cl� simple, valeur) concern�
       par la d�rivation
       """ 
       assert type(mcsimp.valeur) not in (types.ListType,types.TupleType), "Cas non trait� : MCSIMP avec valeur == liste"
#       print 'Ancien :',mcsimp.valeur,' de type ',type(mcsimp.valeur)
       mc_derive = None
       if type(mcsimp.valeur) == types.FloatType :
         mcsimp.valeur = self.reel
       elif mcsimp.valeur in self.d_nom_s_c.keys() :
         mc_derive = (mcfact,mcsimp,mcsimp.valeur)
         mcsimp.valeur = self.d_nom_s_c[mcsimp.valeur]
       elif type(mcsimp.valeur) == types.InstanceType :
         if isinstance(mcsimp.valeur,new_jdc.g_context['fonction']) :
           mcsimp.valeur = self.fonction_0
#       print 'Nouveau :',mcsimp.valeur,' et mc_derive = ',mc_derive
       return mc_derive       
#
#  ========== ========== ========== Fin ========== ========== ==========
#  ========== ========== ========== D�but ========== ========== ==========
#  Les m�thodes qui suivent servent � m�moriser les correspondances entre
#  les noms simples et les noms compos�s
#
#
   def get_texte_memo_nom_sensi_compose(self,nom_simple,param_sensi,nom_compose,l_mc_derives) :
       """
       R�cup�re le texte de la commande ASTER pour l'enregistrement du nom
       compos� associ� � un nom simple et � un param�tre sensible
       On ajoute la liste des mots-cl�s correspondant � la d�rivation.
       """
       if self.DEBUG :
         print ".... Commande de m�morisation des noms :"
       texte = self.commande_memo_nom_sensi+"(NOM=_F(NOM_SD='%s',PARA_SENSI=%s,NOM_COMPOSE='%s'"%(nom_simple,param_sensi,nom_compose)
       if l_mc_derives :
         texte_mc = ",MOT_CLE=("
         texte_va = ",VALEUR=("
         texte_mf = ",MOT_FACT=("
         for mot_cle in l_mc_derives :
           if mot_cle[0] :
             aux = mot_cle[0].nom
           else :
             aux = " "
           texte_mf = texte_mf + "'%s',"%(aux)
           texte_mc = texte_mc + "'%s',"%(mot_cle[1].nom)
           texte_va = texte_va + "'%s',"%(mot_cle[2].nom)
         texte_mf = texte_mf + ")\n"
         texte_mc = texte_mc + ")\n"
         texte_va = texte_va + ")\n"
         texte = texte + texte_mf + texte_mc + texte_va
       texte = texte + "));\n"
       if self.DEBUG :
         print ".... ", texte
       return texte
#
   def get_texte_memo_nom_sensi_zero(self,nom_fonction) :
       """
       R�cup�re le texte de la commande ASTER pour l'enregistrement du nom
       de la fonction nulle
       """
       texte = self.commande_memo_nom_sensi+"(NOM_ZERO = %s);\n" %(nom_fonction)
       return texte
#
   def get_texte_memo_nom_sensi_un(self,nom_fonction) :
       """
       R�cup�re le texte de la commande ASTER pour l'enregistrement du nom
       de la fonction unite
       """
       texte = self.commande_memo_nom_sensi+"(NOM_UN = %s);\n" %(nom_fonction)
       return texte
#
#  ========== ========== ========== Fin ========== ========== ==========
#
   def get_nouveau_nom_sd(self) :
       """
       Retourne un nom de sd jamais utilis�
       Ajoute ce nom � la liste des noms de sd utilis�es par le jdc en cours
       """
#       print "self.l_nom_sd_prod   = ",self.l_nom_sd_prod
#       print "self.l_nouveaux_noms = ",self.l_nouveaux_noms
       i = 9999999
       nouveau_nom_sd = 'S' + str(i)
       while nouveau_nom_sd in self.l_nom_sd_prod + self.l_nouveaux_noms :
         i = i - 1
         nouveau_nom_sd = 'S' + str(i)
       self.l_nouveaux_noms.append(nouveau_nom_sd)
       return nouveau_nom_sd         
#
#
if __name__ == "__main__" :
#
#
  derivation = SENSIBILITE_DERIVATION(None,None,"MEMO_NOM_SENSI",1)
  print "\n",derivation
  print "jdc        : ", derivation.get_jdc()
  print "l_nouveaux_noms      : ", derivation.get_l_nouveaux_noms()
  print "l_nom_sd_prod : ", derivation.get_l_nom_sd_prod()
  print "fonction_0 : ", derivation.get_fonction_0()
  fonction_0 = "f_0"
  print derivation.put_fonction_0(fonction_0)
  print "fonction_0 : ", derivation.get_fonction_0()
  fonction_0 = "f_0_bis"
  print derivation.put_fonction_0(fonction_0)
  print "fonction_0 : ", derivation.get_fonction_0()
  d_param = {}
  d_param ['PS1'] = None
  d_param ['PS2'] = ['LAMBDA']
  d_param ['PS3'] = ['E_L','E_T']
#  for param in d_param.keys() :
#    print "Commande ASTER pour 'CH1' + ",param," = 'gabuzome : \n",derivation.get_texte_memo_nom_sensi_compose('CH1',param,'gabuzome',d_param[param])
  print "Commande ASTER pour ZERO : ", derivation.get_texte_memo_nom_sensi_zero('fonc_0')
  print "Commande ASTER pour UN   : ", derivation.get_texte_memo_nom_sensi_un('fonc_1')
