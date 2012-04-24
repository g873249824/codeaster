#@ MODIF ce_ihm_identification Calc_essai  DATE 23/04/2012   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

# RESPONSABLE BODEL C.BODEL

from numpy import array, zeros, conjugate, identity
from numpy import transpose, ones, arctan, pi, log

from Tkinter import Frame, Menubutton, Checkbutton, Menu, StringVar, IntVar
from Tkinter import Scrollbar, Label, Radiobutton, Button, Entry
from Tkinter import Checkbutton, Listbox

import tkFont

from Accas import _F
from Cata.cata import OBSERVATION, DETRUIRE, CO, IMPR_RESU
from Calc_essai.cata_ce import Resultat, ModeMeca, InterSpectre, CreaTable
from Calc_essai.cata_ce import nume_ddl_phy, nume_ddl_gene, CreaTable
from Calc_essai.ce_calcul_identification import CalcEssaiIdentification
from Calc_essai.outils_ihm import SelectionNoeuds, SelectionMailles
from Calc_essai.outils_ihm import Compteur, MyMenu, MultiList
from Calc_essai.outils_ihm import ChgtRepereDialogue


########################
#                      #
#  CLASSES GRAPHIQUES  #
#                      #
########################




class InterfaceIdentification(Frame):

    """
    Classe qui fabrique l'interface graphique permettant de r�aliser une identification
    d'efforts turbulents, et de controler les calculs. On y trouve les m�thodes suivantes :
     - choix_donnees, choix_projection, frame_meth, _choix_methode, visu_resu : d�finition
       frame d'interface graphique,
     - get_list, plot_curve : r�sultats � visualiser, affichage des courbes,
     - calculate_force : dirige les calculs (effectu�s dans la classe CalculInverse)
     - crea_champ, proj_champ : utilitaires utilisant les op aster du meme nom
    """

    
    def __init__(self, root, ce_objects, mess, out, param_visu):
        Frame.__init__(self, root, borderwidth=4)

        # Classe de calculs appelable ici, ou dans ce_test.py pour validation
        self.calcturb = CalcEssaiIdentification(ce_objects, mess)

        # Objets aster en memoire, et initialisation des noms generiques donnes
        self.objects = ce_objects                                                  # concepts aster dans le dictionnaire
        self.mess = mess                                                           # fichier de message en bs de la fenetre
        self.out = out                                                             # concepts sortants pre-declares a l'appel de la macro
        self.param_visu = param_visu                                               # parametre pour l'affichage des courbes

        self.opt_noms = []                                                         # ['Depl Phy', 'Eff Phy', Eff Mod'...]
        self.opt_data = {}                                                         # {'Depl Phy':{'function':self.calcul_depl_phy,'resultat_attr':'Syy','nume':'nume_phy'},'Eff Phy':{...},...}                            
        self._create_opt_data()

        self.font1 = tkFont.Font( family="Helvetica", size=16 )
        self.font2 = tkFont.Font( family="Helvetica", size=14 )

        # Initialisation des inter-spectres calcules (taille nulle a priori)
        nb_freq = nb_mod = nb_mes = nb_act = 0
        # nb_freq = nombre de frequences de discretisations
        # nb_mes = nombre de mesures
        # nb_act = nombre d'actionneurs
        # nb_mod : nombre de modes pour le modele modal
        self.Syy = zeros((nb_freq, nb_mes, nb_mes))
        self.Syy_R = zeros((nb_freq, nb_mes, nb_mes))
        self.Sqq = zeros((nb_freq, nb_mod, nb_mod))
        self.SQQ = zeros((nb_freq, nb_mod, nb_mod))
        self.SQQ_R = zeros((nb_freq, nb_mod, nb_mod))
        self.Sff = zeros((nb_freq, nb_act, nb_act))
        self.Syy_S = zeros((nb_freq, nb_mes, nb_mes))
       
        self.alpha = StringVar()                                                   # parametre de regularisation de Thikonov
        self.epsilon = StringVar()                                                 # regularisation par svd tronquee
        self.mcoeff = StringVar()                                                  # modulation de alpha selon la frequence

        self.chgt_rep = ChgtRepereDialogue(mess)
        self.obs_co = None                                                         # observabilite (base de modes projetee sur les capteurs
        self.com_co = None                                                         # commandabilite (bdm projetee sur les actionneurs)

        self.inter_spec = None

        self.base = None                                                           # base de mode dont on extrait les caracteristiques modales

        lab = Label(self,text="Identification de chargement",
                  pady=5, font=self.font1 )
        lab.grid(row=0, columnspan = 8)

        colonne_1 = self._construit_colonne_1()
        colonne_2 = self._construit_colonne_2()
        
        colonne_1.grid(row=1, column=0, rowspan=1, sticky='ew')
        colonne_2.grid(row=1, column=1, rowspan=1, sticky='new')
        self.columnconfigure(0, weight=1)
        self.columnconfigure(1, weight=1)

    def setup(self):
        "Utilis� par outils_ihm.TabbedWindow"
        mdo = self.objects
        self.menu_resu_fonc.update(mdo.get_inter_spec_name(),
                                   self.var_resu_fonc,self._get_inter_spec)
        self.menu_resu_mod.update(mdo.get_mode_meca_name(),
                                  self.var_resu_mod,self._get_base)
        self.menu_obs_resu.update(mdo.get_mode_meca_name(),
                                 self.nom_obs_resu,self._observabilite_changed)
        self.menu_com_resu.update(mdo.get_mode_meca_name(),
                                 self.nom_com_resu,self._commandabilite_changed)
        self.menu_com_modele.update(mdo.get_model_name(),
                                    self.nom_com_modele, self._commandabilite_changed)
        self.menu_obs_modele.update(mdo.get_model_name(),
                                    self.nom_obs_modele,self._observabilite_changed)

    def _create_opt_data(self):
        opt_res_definitions = [
            ("Depl phy", self.calcul_depl_phy, 'Syy', 'nume_phy'),
            ("Eff mod", self.calcul_eff_mod, 'SQQ', 'nume_gene'),
            ("Depl phy r", self.calcul_depl_phy, 'Syy_R', 'nume_phy'),
            ("Eff mod r", self.calcul_eff_mod, 'SQQ_R', 'nume_gene'),
            ("Eff phy", self.calcul_eff_phy, 'Sff', 'nume_phy'),
        
            ("Depl synt", self.calcul_depl_phy, 'Syy_S', 'nume_phy'),
            ("Valeurs sing", self.calcul_valeurs, 'val_sing', 'nume_gene'),
            ("regul", self.calcul_valeurs, 'regul', None),
            ]
        for nom, function, res_attr, num in opt_res_definitions:
            self.opt_data[nom] = {"function" : function,
                                  "resultat_attr" : res_attr,
                                  "nume" : num}
            self.opt_noms.append(nom)
        
    def _construit_colonne_1(self):
        col = Frame(self, relief = 'sunken', borderwidth=1)
        # Menu de choix des donnes de calcul en entree
        Label(col, text=u"Choix des donn�es de calcul",
              font=self.font2).grid(row=0, padx=50, pady=2)
        
        box_cd = self._choix_base_modale(col) 
        
        box_obs = self._definit_observabilite(col)
        
        box_cmd = self._definit_commandabilite(col)

        box_int = self._choix_interspectre(col)
    
        box_cm = self._choix_methode(col)
        
        for idx, box in enumerate([box_cd, box_obs, box_cmd, box_int, box_cm]):
            box.grid(row=idx + 1, sticky='w'+'e'+'n', padx=4, pady=2) 
        Button(col, text="Calculer",
               command=self.calculs).grid(row=6, sticky='s'+'e',
                                          padx=4, pady=2)

        return col

    def _choix_base_modale(self, root):
        """Choix des donn�es d'entr�e"""
        fra = Frame(root, relief='sunken', borderwidth=1)

        # Menu choix de la base modale
        Label(fra, text="Base modale").grid(row=1, column=0, sticky='w')
        
        options = self.objects.get_mode_meca_name()
        self.var_resu_mod = StringVar()
        self.menu_resu_mod = MyMenu(fra, options, self.var_resu_mod,
                                    self._get_base)
        self.menu_resu_mod.grid(row=1, column=1)

        return fra
   
    def _definit_observabilite(self, root):
        """D�finition du concept d'observabilit�."""
        fra = Frame(root, relief='sunken', borderwidth=1)

        Label(fra,
              text=u"D�finition du concept d'observabilit�",
              font=self.font2).grid(row=0, column=0, columnspan=3)   
        
        # Menu choix du modele experimental associ�
        # aux donnees en fonctionnement
        Label(fra, text=u"Mod�le exp�rimental").grid(row=1,column=0, sticky='ew')
        self.nom_obs_modele = StringVar()
        self.menu_obs_modele = MyMenu(fra,
                                      self.objects.get_model_name(),
                                      self.nom_obs_modele,
                                      self._observabilite_changed)
        self.menu_obs_modele.grid(row=2, column=0, sticky='we')

        Label(fra, text=u"Base de d�form�es").grid(row=1,column=1, sticky='ew')
        self.nom_obs_resu = StringVar()
        self.menu_obs_resu = MyMenu(fra,
                                    self.objects.get_mode_meca_name(),
                                    self.nom_obs_resu,
                                    self._observabilite_changed)
        self.menu_obs_resu.grid(row=2, column=1, sticky='we')
        
        no_title = "Groupe de noeuds et DDL des capteurs"
        self.obs_noeuds = SelectionNoeuds(fra, no_title, bg='#90a090',
                                          chgt_rep=self.chgt_rep)
        self.obs_noeuds.grid(row=3, column=0, sticky='we',
                             columnspan=3, pady=2, padx=2)
        
        ma_title = "Groupe de mailles et DDL des capteurs"
        self.obs_mailles = SelectionMailles(fra, ma_title, bg='#9090a0',
                                            chgt_rep=self.chgt_rep)
        self.obs_mailles.grid(row=4, column=0, sticky='we',
                              columnspan=3, pady=2, padx=2)
        
        but = Button(fra, text="Valider",
                     command=self._calculate_observabilite)
        but.grid(row=5, column=3, sticky='e', padx=2, pady=2)
        
        fra.columnconfigure(0, weight=1)
        fra.columnconfigure(1, weight=1)

        return fra

    def _definit_commandabilite(self, root):
        """D�finition du concept de commandabilit�."""
        fra = Frame(root, relief='sunken', borderwidth=1)
        
        Label(fra, text=u"D�finition du concept de commandabilit�",
              font=self.font2).grid(row=0, column=0, columnspan=3)
        
        Label(fra, text="Mod�le de controlabilite"
              ).grid(row=1, column=0, sticky='ew')
        self.nom_com_modele = StringVar()
        self.menu_com_modele = MyMenu(fra,
                                      self.objects.get_model_name(),
                                      self.nom_com_modele,
                                      self._commandabilite_changed)
        self.menu_com_modele.grid(row=2, column=0, sticky='ew')

        Label(fra, text="Base de d�form�es").grid(row=1,column=1, sticky='ew')
        self.nom_com_resu = StringVar()
        self.menu_com_resu = MyMenu(fra,
                                    self.objects.get_mode_meca_name(),
                                    self.nom_com_resu,
                                    self._commandabilite_changed)
        self.menu_com_resu.grid(row=2, column=1, sticky='we')
        
        no_title = "Groupe de noeuds et DDL des capteurs"
        self.com_noeuds = SelectionNoeuds(fra, no_title, bg='#90a090',
                                          chgt_rep=self.chgt_rep)
        self.com_noeuds.grid(row=3, column=0, sticky='w'+'e',
                             columnspan=2, pady=2, padx=2)
        
        ma_title = "Groupe de mailles et DDL des capteurs"
        self.com_mailles = SelectionMailles(fra, ma_title, bg='#9090a0',
                                            chgt_rep=self.chgt_rep)
        self.com_mailles.grid(row=4, column=0, sticky='w'+'e',
                              columnspan=2, pady=2, padx=2)
        
        but = Button(fra, text="Valider",
                     command=self._calculate_commandabilite)
        but.grid(row=5, column=3, sticky='e', padx=2, pady=2)
        
        fra.columnconfigure(0, weight=1)
        fra.columnconfigure(1, weight=1)

        return fra

    def _choix_interspectre(self, root):
        """ Choix de l'interspectre"""

        self.var_resu_fonc = StringVar() # le nom de l'interspectre
        self.typ_resu_fonc = StringVar() # le type de 'interspectre
        fra = Frame(root, relief='sunken', borderwidth=1)
        desc = "Interspectre en fonctionnement"
        Label(fra, text=desc).grid(row=1, column=0, sticky='w')
       
        options = self.objects.get_inter_spec_name()
        self.menu_resu_fonc = MyMenu(fra, options, self.var_resu_fonc,
                                     self._get_inter_spec)
        self.menu_resu_fonc.grid(row=1, column=1)
        Label(fra, text = "Type champ",).grid(row=1,column=2)
        opt_cham = ['DEPL','VITE','ACCE'] 
        typ_cham = MyMenu(fra,opt_cham,self.typ_resu_fonc)
        self.typ_resu_fonc.set('DEPL')
        typ_cham.grid(row=1, column=3, sticky='e')
        
        return fra

    def _choix_methode(self, root):
        """Choix de la m�thode de r�solution (techniques de r�gularisation)"""
        fra = Frame(root, relief='sunken', borderwidth=1 )

        # Menu de choix de la methode de calcul des efforts
        Label(fra, text="D�finition du calcul",
              font=self.font2).grid(row=0, column=0, columnspan=3)
               
        Label(fra, text="Tikhonov")
        Label(fra, text="Alpha =").grid(row=1,column=1)
        entree1 = Entry(fra, textvariable=self.alpha )
        entree1.grid(row=1,column=2)
        self.alpha.set(0.0)
                
        Label(fra, text="SVD tronqu�e").grid(row=2, column=0)
        Label(fra, text="Eps =").grid(row=2, column=1)
        entree2 = Entry(fra, textvariable=self.epsilon)
        entree2.grid(row=2, column=2)
        self.epsilon.set(0.0)

        Label(fra, text="puissance").grid(row=3, column=0)
        Label(fra, text="m =").grid(row=3, column=1)
        entree2 = Entry(fra, textvariable=self.mcoeff)
        entree2.grid(row=3, column=2)
        self.mcoeff.set(2.0)
        
        return fra

    def _construit_colonne_2(self):
        """ Affichage dans une fenetre des voies � afficher, possibilit�
        de visualiser les autospectres et les interspectres"""
        fra = Frame(self, relief='sunken', borderwidth=1)
        self.curve_color = StringVar()
        self.var_abs = StringVar()
        self.var_ord = StringVar()
        self.var_amp = StringVar()
        self.born_freq = StringVar()

        Label(fra, text="Visualisation des r�sultats",
              font=self.font2).grid(row=0, column=0,columnspan=3)
 
        Label(fra, text="Choix des donn�es � visualiser").grid(row=1,
                                                               column=0,
                                                               columnspan=3)

        self.var_visu_resu = [StringVar(), StringVar()]
        self.var_export = [StringVar(), StringVar()]
        self.menu_visu_resu = [None, None]
        self.menu_list = [None, None]

        for ind_tab in range(2):
            self.menu_visu_resu[ind_tab] = MyMenu(fra, self.opt_noms,
                                                  self.var_visu_resu[ind_tab])
            self.menu_visu_resu[ind_tab].grid(row=2, column=ind_tab,
                                              columnspan=5, sticky='w')
            self.menu_list[ind_tab] = MultiList(fra, ["indice mode/position"])
            self.menu_list[ind_tab].grid(row=3,column=ind_tab, sticky='wens')
            exportvar = Entry(fra, textvariable=self.var_export[ind_tab])
            exportvar.grid(row=4, column=ind_tab, sticky='we')
            fonc = "export_inte_spec" + str(ind_tab + 1)
            Button(fra, text="Exporter Inter-spectre",
                        command=getattr(self, fonc)).grid(row=5, column=ind_tab)
        Button(fra, text="Valider", command=self.get_list).grid(row=2, column=2)

        # Options de visualisation (�chelles)
        opt_box1 = Frame(fra)
        Label(opt_box1,
             text="Echelle Absisses").grid(row=0, column=0, sticky='w')
        Label(opt_box1,
              text="Echelle Ordonn�es").grid(row=1, column=0, sticky='w')
        Label(opt_box1, text="Amp/Phase").grid(row=2, column=0, sticky='w')
        self.amp_phas = ["Amplitude","Phase"]
        opt_trac = ["LIN","LOG"]
        self.menu_abs = MyMenu(opt_box1, opt_trac, self.var_abs)
        self.menu_abs.grid(row=0, column=1, columnspan=5, sticky='e')
        self.menu_ord = MyMenu(opt_box1, opt_trac, self.var_ord)
        self.menu_ord.grid(row=1, column=1, columnspan=5, sticky='e')
        self.menu_amp = MyMenu(opt_box1, self.amp_phas, self.var_amp)
        self.menu_amp.grid(row=2, column=1, columnspan=5, sticky='e')
        
        self.var_amp.set("Amplitude")
        self.var_abs.set("LIN")
        self.var_ord.set("LIN")
        opt_box1.grid(row=6, column=0, columnspan=2, sticky = 'e''w')
        
        opt_box2 = Frame(fra)
        Button(opt_box2, text="Afficher courbe",
               command=self.plot_curve).grid(row=0, column=0)
        Button(opt_box2, text="Crit�re d'erreur",
               command=self.plot_curve).grid(row=1, column=0)
        Entry(opt_box2, textvariable=self.born_freq).grid(row=2, column=0)
        opt_box2.grid(row=3, column=2, sticky = 'e''w')

        return fra
    
    def _observabilite_changed(self):
        nom_modele = self.nom_obs_modele.get()
        modele = self.objects.get_model(nom_modele)
        
        self.obs_noeuds.set_resultat(modele)
        self.obs_mailles.set_resultat(modele)

    def _commandabilite_changed(self):
        nom_modele = self.nom_com_modele.get()
        modele = self.objects.get_model(nom_modele)
        
        self.com_noeuds.set_resultat(modele)
        self.com_mailles.set_resultat(modele)


    def _get_base(self):
        """ Va chercher l'instance de la classe ModeMeca correspondant
        au nom de base choisi
        """
        nom_base = self.var_resu_mod.get()
        self.base = self.objects.resultats[nom_base] 


    def _get_inter_spec(self):
        """ Va chercher l'instance de la classe InteSpectre correspondant
        au nom de l'inter-spectre choisi
        """
        nom_intsp = self.var_resu_fonc.get()
        self.inter_spec = self.objects.inter_spec[nom_intsp]
        
    
    def _calculate_observabilite(self):
        if self.obs_co:
            DETRUIRE(CONCEPT=_F(NOM=self.obs_co.obj), INFO=1)
        self.obs_co = ModeMeca(self.objects,"__OBS",CO("__OBS"))

        message = "Pour definir l'observabilite, il faut une base"\
                  "de deformees ET un modele"
        nom_resu = self.nom_obs_resu.get()
        if nom_resu.strip() == 'Choisir':
            self.mess.disp_mess(message)
            return
        resu = self.objects.get_mode_meca(nom_resu)

        nom_modele = self.nom_obs_modele.get()
        if nom_modele.strip() == 'Choisir':
            self.mess.disp_mess(message)
            return

        grp_no = self.obs_noeuds.get_selected()
        grp_ma = self.obs_mailles.get_selected()
        if not (grp_no or grp_ma):
            self.mess.disp_mess("Aucun noeud n'est selctionne. Tous les noeuds"\
                                "du modele experimental")

        modele = self.objects.get_model(nom_modele)
        if modele.kass == None or modele.mass == None :
            modele.get_matrices()

        proj = 'OUI'
        if resu.modele_name == modele.nom:
            proj = 'NON'

        try:
            __OBS = OBSERVATION( RESULTAT = resu.obj,
                                 MODELE_1 = resu.modele.obj,
                                 MODELE_2  = modele.obj,
                                 PROJECTION  = proj,
                                 TOUT_ORDRE  = 'OUI',
                                 MATR_A = modele.kass,
                                 MATR_B = modele.mass,
                                 NOM_CHAM = 'DEPL',
                                 FILTRE   = get_filtres(grp_no, grp_ma),
                                 MODI_REPERE = get_chgt_repere(grp_no, grp_ma)
                               );
        except:
            self.mess.disp_mess("Le concept d'observabilit� " \
                                "n'a pas pu �tre calcul�.\n"\
                                "L'erreur est affich�e en console.")
            raise

        self.mess.disp_mess("Le concept d'observabilit� " \
                            "a �t� calcul�.")
        self.obs_co = ModeMeca(self.objects,__OBS.nom,__OBS,self.mess)
        self.obs_co.get_modele()
        self.obs_co.get_matrices()
        self.obs_co.get_nume()
        self.obs_co.get_maillage()


    def _calculate_commandabilite(self):
        if self.com_co:
            DETRUIRE(CONCEPT=_F(NOM=self.com_co.obj), INFO=1)
        self.com_co = ModeMeca(self.objects,"__COM",CO("__COM"))

        message = "Pour definir la commandabilite, il manque "
        nom_resu = self.nom_com_resu.get()
        if nom_resu.strip() == 'Choisir':
            self.mess.disp_mess(message)
            return
        resu = self.objects.get_mode_meca(nom_resu)

        nom_modele = self.nom_com_modele.get()        
        if nom_modele.strip() == 'Choisir':
            self.mess.disp_mess(message)
            return

        grp_no = self.com_noeuds.get_selected()
        grp_ma = self.com_mailles.get_selected()
        if not (grp_no or grp_ma):
            self.mess.disp_mess("Aucun noeud n'est selctionne. Tous les noeuds"\
                                "du modele experimental")

        modele = self.objects.get_model(nom_modele)
        if modele.kass == None or modele.mass == None:
            modele.get_matrices()

        proj = 'OUI'
        if resu.modele_name == modele.nom:
            proj = 'NON'

        try:
            __COM = OBSERVATION(RESULTAT = resu.obj,
                                MODELE_1 = resu.modele.obj,
                                MODELE_2 = modele.obj,
                                PROJECTION = proj,
                                TOUT_ORDRE = 'OUI',
                                MATR_A = modele.kass,
                                MATR_B = modele.mass,
                                NOM_CHAM = 'DEPL',
                                FILTRE   = get_filtres(grp_no, grp_ma),
                                MODI_REPERE = get_chgt_repere(grp_no, grp_ma)
                               )
        except:
            self.mess.disp_mess("Le concept de commandabilit� " \
                                "n'a pas pu �tre calcul�.\n" \
                                "L'erreur est affich�e en console.")
            raise

        self.mess.disp_mess("Le concept de commandabilit� " \
                            "a �t� calcul�.")
        self.com_co = ModeMeca(self.objects,__COM.nom,__COM,self.mess)
        self.com_co.get_modele()
        self.com_co.get_matrices()
        self.com_co.get_nume()
        self.com_co.get_maillage()
        

    def calculs(self):
        """!Lance la classe CalculAster, qui dirige toutes les routines
            Aster et python
        """
        if self.var_resu_fonc.get() == 'Choisir':
            self.mess.disp_mess("Il faut choisir la base modale")
            return
        self.calcturb.set_base(self.base)
        
        # Attention � rafra�chir la m�moire de CalcEssaiObjects
        self.objects.recup_objects()
        self.calcturb.set_observabilite(self.obs_co)
        self.calcturb.set_commandabilite(self.com_co)

        if self.var_resu_fonc.get() == 'Choisir':
            self.mess.disp_mess("Il faut choisir l'inter-spectre des mesures")
            return
        self.calcturb.set_interspectre(self.inter_spec)
        self.calcturb.set_type_intsp(self.typ_resu_fonc.get())

        self.calcturb.set_alpha(self.alpha.get())
        self.calcturb.set_epsilon(self.epsilon.get())
        self.calcturb.set_mcoeff(self.mcoeff.get())
        
        # Lancement des calculs
        self.calcturb.calculate_force()

        
        # Rafraichissement des donnees dans la classe InterfaceTurbulent
        self.Syy = self.Syy_R = self.Sqq = self.SQQ = None
        self.SQQ_R = self.Sff = self.Syy_S = None
        # self.calcturb.is_XX = 1 quand les calculs se sont bien passes
        if self.calcturb.is_Syy == 1:
            self.Syy   = self.calcturb.Syy
        if self.calcturb.is_SQQ == 1:
            self.SQQ   = self.calcturb.SQQ
            self.val_sing = self.calcturb.val_sing
            self.regul = self.calcturb.regul
        if self.calcturb.is_SQQ_R == 1:
            self.SQQ_R = self.calcturb.SQQ_R
        if self.calcturb.is_Sff == 1:
            self.Sff   = self.calcturb.Sff
        if self.calcturb.is_Syy_S == 1:
            self.Syy_S = self.calcturb.Syy_S
        if self.calcturb.is_Syy_R ==  1:
            self.Syy_R = self.calcturb.Syy_R

    def get_list(self):
        """Routine qui cr�e les liste de courbes � afficher.
        Choix de la donn�e � repr�senter:
            Depl phy <=> d�placements physiques,
            Eff mod <=> efforts modaux,
            Depl phy r <=>
            Eff mod r <=> efforts modaux reconstitu�s,
            Eff phy r <=> efforts physiques
            Depl synt <=> d�placements physiques resynth�tis�s
            Valeurs  synt <=> valeurs singulieres de la matrice C.phi.Zm1
            regul <=> parametres de regulation"""
        self.var_list = [[],[]]
        mess_err = "!! Impossible de cr�er la liste des courbes � afficher !!"
        self.mess.disp_mess(" ")
        for ind_tabl in range(2):
            opt_key = self.var_visu_resu[ind_tabl].get()
            if opt_key.split()[0] == "Choisir" :
                continue
            optdict = self.opt_data[opt_key]
            # R�cup�ration de la fonction � appeler
            calc_func = optdict["function"]
            calc_func(optdict["resultat_attr"], ind_tabl)

    def calcul_depl_phy(self, resultat_attr, ind_tabl):
        """Calcul les param�tres: 'Depl phy', 'Depl phy r','Depl synt'."""
        liste = nume_ddl_phy(self.obs_co)
        
        for ind in range(len(liste)):
            lst = crea_list_no(ind, liste)
            for ind in lst:
                self.var_list[ind_tabl].append([ind])
        self.menu_list[ind_tabl].set_values(self.var_list[ind_tabl])

    def calcul_eff_phy(self, resultat_attr, ind_tabl):
        """Calcul les param�tres: 'Eff Phy'."""
        liste = nume_ddl_phy(self.com_co)
        
        for ind in range(len(liste)):
            lst = crea_list_no(ind, liste)
            for ind in lst:
                self.var_list[ind_tabl].append([ind])
        self.menu_list[ind_tabl].set_values(self.var_list[ind_tabl])


    def calcul_eff_mod(self, resultat_attr, ind_tabl):
        """Calcul les param�tres: 'Eff mod', 'Eff mod r'."""
        liste = nume_ddl_gene(self.calcturb.res_base)
        
        for mode in range(len(liste)):
            lst = crea_list_mo(mode, liste)
            for ind in lst:
                self.var_list[ind_tabl].append([ind])
        self.menu_list[ind_tabl].set_values(self.var_list[ind_tabl])
    
    def calcul_valeurs(self, resultat_attr, ind_tabl):
        """Calcul les param�tres: 'Valeurs sing', 'regul'."""
        if not self.calcturb.inter_spec.nume_gene:
            liste = nume_ddl_gene(self.calcturb.res_base)
        for ind in liste:
            self.var_list[ind_tabl].append([ind])
        self.menu_list[ind_tabl].set_values(self.var_list[ind_tabl])

    def _get_selected_variables(self, ind_tab):
        """Retourne les variables selection�es dans une colonne
        affichant les r�sultats."""
        var_list = []
        liste = self.menu_list[ind_tab].get_selected()
        for idx in liste:
            var = self.var_list[ind_tab][int(idx)]
            var_list.append(var[0])
        return var_list

    def _get_graph_data(self):
        """Retourne les valeurs et les l�gendes pour
        les courbes de r�sultats."""
        # values = liste dont chaque elmt est une courbe
        values = []
        captions = []
        freq = []
        
        for ind_tab in range(2):
            opt_key = self.var_visu_resu[ind_tab].get()
            if opt_key.split()[0] == "Choisir" :
                continue
            
            optdict = self.opt_data[opt_key]
            res = getattr(self, optdict["resultat_attr"])
            num_option = self.opt_noms.index(opt_key)

            for var in self._get_selected_variables(ind_tab):
                vect = None
                # Type de resultat a representer
                if num_option <= 5:
                    num = getattr(res, optdict["nume"])
                    ikey, jkey = var.split(',')
                    iidx = num.index(ikey)
                    jidx = num.index(jkey)
                    vect = getattr(res, 'matr_inte_spec')[1:, iidx, jidx]
                elif num_option == 6 or num_option == 7:
                    idx = int(var[2:])
                    vect = res[idx - 1, 1:]
                absc = getattr(res, 'f')[1:]

                # Options de visualisation  
                if self.var_amp.get() == 'Amplitude':
                    vect = abs(vect)
                elif self.var_amp.get() == 'Phase':
                    vect = arctan(vect.imag / vect.real)
                if self.var_ord.get() != "Lin" and  \
                                            self.var_amp.get() == 'Phase':
                    self.mess.disp_mess("!! Impossible de repr�senter " \
                                        "la phase dans un !!")
                    self.mess.disp_mess("!!           diagramme " \
                                        "logarithmique          !!")

                values.append(vect)
                freq.append(array(absc))
                captions.append("%s %s" % (opt_key, var))
        
        return freq, values, captions

    def plot_curve(self):
        """Selection dans les interspectres disponibles des resultats
        s�lectionn�es dans les listes menu_list, et plot
        des courbes correspondantes"""       
        freq, values, caption = self._get_graph_data()
        
        self.param_visu.visu_courbe(freq, values, l_legende=caption,
                                    titre_x=self.var_abs.get(), titre_y=self.var_ord.get())
   
    def export_inte_spec1(self):
        option = self.var_visu_resu[0].get()
        titre = self.var_export[0].get()
        self.export_inte_spec(option, titre)

    def export_inte_spec2(self):
        option = self.var_visu_resu[1].get()
        titre = self.var_export[1].get()
        self.export_inte_spec(option, titre)
        
    def export_inte_spec(self, option, titre):
        out = self.out
        if option == self.opt_noms[0]:
            self.Syy.make_inte_spec(titre, out)
        elif option == self.opt_noms[1]:
            self.SQQ.make_inte_spec(titre, out)
        elif option == self.opt_noms[2]:
            self.Syy_R.make_inte_spec(titre, out)
        elif option == self.opt_noms[3]:
            self.SQQ_R.make_inte_spec(titre, out)
        elif option == self.opt_noms[4]:
            self.Sff.make_inte_spec(titre, out)
        elif option == self.opt_noms[5]:
            self.Syy_S.make_inte_spec(titre, out)
        else:
            self.mess.disp_mess("!! Il n'est pas possible " \
                                "d'exporter ces donn�es !!")
            self.mess.disp_mess("  ")
    

    def teardown(self):
        "Utilis� par outils_ihm.TabbedWindow"
        pass


#------------------------------------------------------------------------------

########################
#                      #
#  PETITS UTILITAIRES  #
#                      #
########################

def crea_list_mo(x, list_in):
    liste = []
    for ind in range(x+1):
        liste.append(list_in[x]+','+list_in[ind])
    return liste

def crea_list_no(x,list_in):
    """
    Creation d'une liste de resultats visualisables sous la forme :
     < No #noeud ddl, No #noeud ddl>
    Liste est le resultat de crea_champ
    """
    list_out = []
    for ind in range(x+1):
        list_out.append(list_in[x]+','+list_in[ind])
    return list_out


def get_filtres(grp_no, grp_ma):
    filtres = []
    for grp in grp_no:
        filtres.append(_F(GROUP_NO=grp["NOM"],
                          DDL_ACTIF=grp["NOM_CMP"],
                          NOM_CHAM='DEPL'))
    for grp in grp_ma:
        filtres.append(_F(GROUP_MA=grp["NOM"],
                          DDL_ACTIF=grp["NOM_CMP"],
                          NOM_CHAM='DEPL'))
    return filtres

def get_chgt_repere(grp_no, grp_ma):
    chgt_reps = []
    for grp in grp_no:
        if grp["CHGT_REP"]:
            chgt_reps.append(_F(GROUP_NO=grp["NOM"],
                                **grp["CHGT_REP"]))
    for grp in grp_ma:
        if grp["CHGT_REP"]:
            chgt_reps.append(_F(GROUP_MA=grp["NOM"],
                                **grp["CHGT_REP"]))
    return chgt_reps




