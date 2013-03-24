#@ MODIF outils_ihm Calc_essai  DATE 19/03/2013   AUTEUR BRIE N.BRIE 
# -*- coding: iso-8859-1 -*-
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

# RESPONSABLE BODEL C.BODEL

from Tkinter import *

import aster_core
import aster
import string
import os

import tkFont

from Stanley.xmgrace import Xmgr
from Stanley.as_courbes import Courbe
from Accas import _F, ASSD
from popen2 import Popen3

from numpy import minimum, maximum, array, arange, log
from Utilitai.Utmess import UTMESS, MESSAGE_LOGGER
from Calc_essai.cata_ce import DynaHarmo,ModeMeca
##from Calc_essai.ce_ihm_parametres import CalcEssaiSalome

palette = [ "#%02x%02x%02x" % (255-i, 255-i, 255-i) for i in range(256) ]
# MESSAGE_LOGGER = classe permettant de formatter et d'afficher les messages d'erreur
mess = MESSAGE_LOGGER()

class TabbedWindow(Frame):
    """!Objet de gestion de `tabs` avec Tk
    """
    def __init__(self, root, tablabels,**args):
        """!Constructeur

        Ce widget est une Frame qui contient les boutons de selection (tabs)
        et une fenetre principale
        
        \param root La fenetre parente
        \param tablabels Une liste des labels de tab

        attributs
        - `main`: La `Frame` qui contient le contenu d'un tab :see: root
        - `tabnum`: Une `StringVar` Tk qui contient le num�ro du tab s�lectionn�
        - `labels: Un dictionnaire nom -> [ button, frame ] o� le nom est le label du tab
          `b` est le RadioButton qui controle l'affichage du tab et
          `frame` est la Frame Tk � afficher
        """
        Frame.__init__(self,root,**args)
        self.labels = {}
        self.main = None
        self.canvas = root
        self.objects = None
        self.tabnum = StringVar()
        f = Frame(self,borderwidth=0,relief='flat')
        for i, name in enumerate(tablabels):
            b = Radiobutton(f, text=name, value=name, relief='solid',
                            variable=self.tabnum, indicatoron=0, borderwidth=1,
                            bg='#a0a0a0',padx=30,
                            command=self.switch_tab).pack(side='left')
            self.labels[name] = [ b, None ]
        f.grid(row=0,column=0)

        self.rowconfigure(1, weight=1)
        self.columnconfigure(0, weight=1)

        self.create_canvas()

    def create_canvas(self):
        self.vsb = Scrollbar(self,orient='vertical')
        self.vsb.grid(row=1, column=1, sticky='nse')
        self.main = Canvas(self,yscrollcommand=self.vsb.set,
                           height=700,width=1000)
        self.main.grid(row=1, column=0, sticky="nswe")
        self.main.rowconfigure(1, weight=1)
        self.main.columnconfigure(0, weight=1)
        self.vsb.config(command=self.main.yview)
                                                                                                    

    def set_objects(self, objects):
        self.objects = objects

    def root(self):
        """!Renvoie la Frame qui recoit le tab courant """
        return self.main

    def set_tab(self, name, w):
        """Associe un objet Frame (onglet) � son nom"""
        self.labels[name][1] = w


    def set_current_tab(self, name):
        """!Change le tab courant"""
        b,f = self.labels.get(name, (None,None))
        if f is not None:
            self.main.delete('all')
            self.main.create_window(500,0,window=f,anchor='center')
            f.update_idletasks()
            self.main.config(scrollregion=self.main.bbox("all"))
            self.main.yview('moveto',0.0)
            self.main.bind("<MouseWheel>", self.main.yview)

            f.setup()
            self.tabnum.set(name)

    def switch_tab(self, *args):
        """!Affiche le tab choisit par l'utilisateur (callback Tk)"""
        self.objects.recup_objects()
        self.set_current_tab(self.tabnum.get())


class MessageBoxInteractif(Frame):
    """!Classe dans laquelle on stocke la fentre de message (string)
    et qui permet d'ecrire dans un .mess separe si l'utilisateur en a fait
    la demande"""

    def __init__(self, root):
        Frame.__init__(self, root, borderwidth=0,relief='flat',width=1000,height=200)
        titre = Label(self, text='Fenetre de messages' )
        titre.grid(row=0,column=0,columnspan=2)
        self.columnconfigure(0,weight=1)
        self.rowconfigure(1,weight=1)
        affich = Frame(self, relief='flat', borderwidth=0)
        affich.grid(row=1,sticky='news')
        affich.columnconfigure(0,weight=1)
        affich.rowconfigure(0,weight=1)
        scroll = Scrollbar ( affich, orient='vertical' )
        scroll.grid ( row=0, column=1, sticky='ns' )
        self.txt = Text(affich,yscrollcommand=scroll.set,background='white',height=5)
        self.txt = Text(affich,background='white',height=5)
        scroll["command"] = self.txt.yview
        self.txt.grid( row=0, column=0, sticky='news')



    def disp_mess(self, new_mess):
        """!Ecriture des messages dans le fichier sortie
        s'il existe et dans la fenetre de message"""
        if new_mess[-1:]!="\n":
            new_mess += "\n"
        self.txt.insert(END, new_mess)
        self.txt.see(END)


class MyMenu(Menubutton):
    """!Combobox

    Simplifie la cr�ation de bouton `Menu` du style *Combobox*
    """
    def __init__(self, root, options, var, cmd=None, default_var=None):
        """!Constructeur

        \param root Le widget parent
        \param options une liste des choix du menu
        \param var La variable de selection associ�e
        \param cmd Le callback associ� (si diff�rent de ``None``)
        """
        Menubutton.__init__( self, root, textvariable=var, relief='raised' )
        var.set(default_var or "   Choisir   ")
        self.menu = Menu( self, tearoff=0 )
        self["menu"] = self.menu
        for opt in options:
            self.menu.add_radiobutton( label=opt, variable=var, command=cmd )

    def update(self, options, var, cmd=None ):
        """!Mise � jour des options du menu

        \see __init__
        """
        self.menu.delete(0, 'end')
        for opt in options:
            self.menu.add_radiobutton( label=opt, variable=var, command=cmd )

# ------------------------------------------------ #
# Classes pour la visualisation de listes d'objets
# ------------------------------------------------ #

class ScrollList(Frame):
    """Interface liste � choix multiples + scroll bar.
       Plusieurs options selon utilisation (annuler/valider, tout/rien)
    """
    def __init__(self, root, title,**args):
        Frame.__init__(self, root)
        self.title = title
        self.resu = None # la sd resultat s�lectionn�e
        self.modes = []  # la liste de modes
        self.rowconfigure(1,weight=1)
        self.titre = Label(self, text=title, bg="#f0f0f0")
        self.titre.grid(column=0,row=0,columnspan=2,sticky="ew")
        scroll = Scrollbar ( self, orient='vertical' )
        scroll.grid ( row=1, column=1, sticky='ns' )
        self.liste = Listbox(self,
                             selectmode='extended',
                             yscrollcommand=scroll.set,
                             exportselection=False,
                             background='white')
        self.liste.grid(column=0, row=1, sticky='sn')
        self.columnconfigure(0,weight=0)
        scroll["command"] = self.liste.yview


    def set_values(self, valeurs ):
        """Remplit la liste avec des valeurs"""
        self.liste.delete(0,END)
        self.values = valeurs
        for val in valeurs:
            self.liste.insert( END,val )

    def delete(self):
        self.liste.delete(0,END)

    def get_selection(self):
        """retourne la liste des indices entiers selectionnes et la liste des valeurs
           liste = [[int1, value1], [int2,value2], [int3,vlue3]]"""
        return [[int(v),self.values[int(v)]] for v in self.liste.curselection() ]



class ModeList(ScrollList):
    """ Customisation de la ScrollList pour afficher des couples
       numeros d'ordre/frequence. Ajout d'une ligne pour tout/rien selectionner"""
    def __init__(self, parent, title,**args):
        ScrollList.__init__(self, parent, title,**args)
        buttonbar = Frame(self,bg='blue')
        buttonbar.grid(row=2,column=0,columnspan=2)
        Button(buttonbar, text="Tout", command=self.select_all).grid(row=0,column=0)
        Button(buttonbar, text="Rien", command=self.deselect_all).grid(row=0,column=1)

    def set_values(self, modes ):
        """Ecrase la set_values de ScrollList.
           Remplit une liste de modes de la forme
           modes = [('indice1','vale1'),('indice2','vale2')]
        """
        self.liste.delete(0,END)
        self.modes = modes
        self.values = []
        for val, label in modes:
            self.liste.insert( END, val +" "+ label )
            self.values.append( val )
    
    def select_all(self):
        self.liste.selection_set(0,END)

    def deselect_all(self):
        self.liste.selection_clear(0,END)

    def get_selection(self):
        """retourne la liste des NUME_ORDRE selectionnes"""
        return [int(self.values[int(v)]) for v in self.liste.curselection() ]
    

class ModeFreqList(ModeList):
    """!Permet de cr�er une liste de modes contenues dans un sd_resultat.
        indexes par leur frequence (modes dynamiques ou leur noeud_cmp
        (modes statiques)"""
    def __init__(self, root, title=None):
        if title is None:
            title="Choisissez les modes"
        ModeList.__init__(self, root, title)

    def set_resu(self, resu):
        cara_mod = resu.get_modes_data()
        freq = cara_mod['FREQ']
        nume_ordr = cara_mod['NUME_ORDRE']
        noeud_cmp = cara_mod['NOEUD_CMP']
        for ind_ordr in range(len(freq)):
            if not freq[ind_ordr]: freq[ind_ordr] = noeud_cmp[ind_ordr]
        self.set_values( [ ('%3i' % n, self.set_display(f)) for n,f in zip(nume_ordr,freq) ] )

    def set_display(self,data):
        """ determine l'affichage des caras selon que l'on ait des modes stat ou dyn"""
        if isinstance(data,str): return data
        elif isinstance(data,float): return '%8.2f Hz' % data


class StudyList(ScrollList):
    """!Liste permettant de choisir l'�tude Salom� pour l'affichage des
        donn�es.
    """
    def __init__(self, parent,param_visu, title):
        self.param_visu = param_visu
        
        ScrollList.__init__(self, parent,title)
        buttonbar = Frame(self,bg='blue')
        buttonbar.grid(row=2,column=0,columnspan=2)
        Button(buttonbar, text="Actualiser", command=self.actualiser).grid(row=0,column=0)
        Button(buttonbar, text="Valider", command=self.valider).grid(row=0,column=1)

    
    def actualiser(self):
        param_visu = self.param_visu
        self.studylist = param_visu.visu_studylist()
        self.liste.delete(0,END)
        self.values = []
        for val in self.studylist:
            self.liste.insert( END, val)
            self.values.append( val )

    def valider(self):
        num_std = int(self.liste.curselection()[0])
        study = self.studylist[num_std]
        self.param_visu.set_study(study)



class VisuSpectre(Frame):
    """!Cr�e une frame de nb_col colonnes pour afficher les num�ros d'ordre
        d'un inter-spectre, les s�lectionner et les afficher"""

    def __init__(self,parent,nb_col=1,
                 choix=None,export=None,
                 type_data='C',label_visu=None,
                 **args):
        
        self.font1 = tkFont.Font( family="Helvetica", size=16 )
        self.font2 = tkFont.Font( family="Helvetica", size=14 )
        self.parent = parent
        self.menu_list = [None]*nb_col
        self.var_export = [StringVar()]*nb_col        

        
        Frame.__init__(self,parent,args)
        r1 = 0
        
        Label(self, text=u"Visualisation des r�sultats",
              font=self.font2).grid(row=r1, padx=50, pady=3)
        r1+=1

        box_1 = Frame(self,relief='flat')    
        for ind_col in range(nb_col):
            r2 = 0
            if choix:
                # possibilite de choisir entre plusieurs spectres a visualiser
                if isinstance(self.parent.var_visu_resu,list):
                    var_visu_resu = self.parent.var_visu_resu[ind_col]
                else: var_visu_resu = self.parent.var_visu_resu

                self.menu_list[ind_col] = MyMenu(box_1,choix,
                                                 var_visu_resu,
                                                 self.parent.get_list)
                self.menu_list[ind_col].grid(row=r2,column=ind_col)
                r2+=1
                
            if isinstance(self.parent.var_visu_resu,list):
                label = self.parent.label_visu[ind_col].get()
            else:
                label = self.parent.label_visu.get()

            curve_list = ScrollList(box_1,title=label,**args)
            curve_list.grid(row=r2,column=ind_col)
            
            if isinstance(self.parent.var_visu_resu,list):
                self.parent.curve_list[ind_col] = curve_list
            else: self.parent.curve_list = curve_list
            
            r2+=1
    
            if export:
                # possibilite d'exporter le spectre
                if isinstance(self.parent.var_export,list):
                    var_export = self.parent.var_export[ind_col]
                else: var_export = self.parent.var_visu_resu
                Entry(box_1, textvariable=var_export).grid(row=r2, column=ind_col, sticky='we')
                r2+=1
                fonc="export_inte_spec" + str(ind_col+1)
                Button(box_1, text="Exporter Spectre",
                       command=getattr(self.parent,fonc)).grid(row=r2, column=ind_col)

        box_1.grid(row=r1,column=0)
        r1+=1

        box_2 = Frame(self,relief='flat')  
        rc_r=[0,0,1,1]
        rc_c=[1,2,1,2]
        r2 = 0

        if type_data=='C' : #donnees complexes a visualiser
            donnees=["Reel ","Abs.","Imag.","Pha."]
            Label(box_2,text=u"Donn�es :",pady=5).grid(row=r2,column=0)
            for lon in range(len(donnees)) :
               Radiobutton(box_2, text=donnees[lon],
                           variable=self.parent.radio_donnees,
                           value=lon).grid(row=r2+rc_r[lon],column=rc_c[lon])

            r2+=2
        else :
            donnees=["Reel ","Abs."]
            Label(box_2,text=u"Donn�es :",pady=5).grid(row=r2,column=0)
            for lon in range(2) :
               Radiobutton(box_2, text=donnees[lon],
                           variable=self.parent.radio_donnees,
                           value=lon).grid(row=r2+rc_r[lon],column=rc_c[lon])
            r2+=1

        Label(box_2,text="Echelle X :",pady=5).grid(row=r2,column=0)
        ech=[u"Lin�aire","Logarithmique"]
        for lon in range(len(ech)) :
           Radiobutton(box_2, text=ech[lon],
                       variable=self.parent.xlinlog, value=lon
                       ).grid(row=r2,column=lon+1)

        r2+=1
        Label(box_2,text="Echelle Y :",pady=5).grid(row=r2,column=0)
        for lon in range(len(ech)) :
           Radiobutton(box_2, text=ech[lon],
                       variable=self.parent.ylinlog, value=lon
                       ).grid(row=r2,column=lon+1)

        r2+=1
        self.disp_mes = Button(box_2, text="Visualiser", command=self.parent.display_curve)
        self.disp_mes.grid(row=r2,column=1)
        
        box_2.grid(row=r1,column=0)
        r1+=1



class ModeHarmoList(ModeList):
    """!liste de numeros d'ordre plutot pour les dyna_harmo"""
    pass


class MultiList(Frame):
    """!Widget permettant de g�rer plusieurs listes (colonnes) synchronis�e
    sur la meme barre de d�filement
    """
    def __init__(self, root, labels, format = None,**args ):
        """!Constructeur

        \param root Fenetre parente
        \param labels Les titres des colonnes
        \param format Chaines de formattage
               pour les valeurs des listes (%s par d�faut)
        """
        Frame.__init__(self, root)
        self.labels = labels
        self.lists = []
        self.scroll = Scrollbar( self, orient='vertical' )
        for i, l in enumerate(labels):
            Label(self, text=l).grid(row=0, column=i)
            lb = Listbox( self,yscrollcommand=self.scroll.set,
                          **args )
            lb.grid(row=1, column=i)
            self.lists.append( lb )
        i+=1
        self.scroll["command"] = self.yview
        self.scroll.grid(row=1,column=i, sticky='n'+'s')
        if format:
            assert len(format) == len(labels)
            self.format = format
        else:
            self.format = ["%s"] * len(labels)

    def yview(self, *args):
        """!Callback du Scrollbar pour le d�filement des listes"""
        for lb in self.lists:
            lb.yview(*args)

    def set_values(self, values):
        """!Remplissage des colonnes"""
        for lst in self.lists:
            lst.delete(0, 'end')
        for row in values:
            for v,lst,fmt in zip(row,self.lists,self.format):
                lst.insert( 'end', fmt % v )

    def get_selected(self):
        """!Renvoie la selection courante"""
        for lst in self.lists:
            return lst.curselection()

    def delete(self):
        for lst in self.lists:
            lst.delete(0,'end')



class GroupNoList(ModeList):
    """!Cr�e une liste de groupe de noeuds � partir d'un maillage"""
    def __init__(self, root):
        if title is None:
            title="Choisissez les groupes de noeuds"
        ModeList.__init__(self, root, title)

    def set_mesh(self, mail):
        groupno = mail.sdj.GROUPENO.get()
        self.set_values( zip( groupno.keys(), groupno.keys() ) )



class GroupMaList(ModeList):
    """!Cr�e une liste de groupe de noeuds � partir d'un maillage"""
    def __init__(self, root):
        ModeList.__init__(self, root, "Choisissez les groupes de mailles")

    def set_mesh(self, mail):
        groupno = mail.sdj.GROUPEMA.get()
        self.set_values( zip( groupno.keys(), groupno.keys() ) )




class OptionFrame(Frame):
    def __init__(self, root, title, desc):
        Frame.__init__(self, root, relief=GROOVE,bd=2)
        r=0
        self.widgets = []
        if title:
            Label(self, text=title).grid(row=r,column=0,columnspan=2)
            r+=1
        for label, typ, extra in desc:
            Label(self, text=label).grid(row=r,column=0,sticky='w')
            w=typ(self, **extra)
            w.grid(row=r, column=1,sticky='ew')
            self.widgets.append(w)
            r+=1



class ParamModeIterSimult(Frame):
    """Un panneau pour sp�cifier les param�tres de r�solution
    de MODE_ITER_SIMULT
    """
    # Note: r�utiliser la partie g�n�rique d'Eficas est plutot
    # compliqu� et donne des interfaces peu 'intuitives'...

    # On ne traite que SORENSEN pour l'instant
    # (JACOBI et TRI_DIAG ont peu d'avantages d'apr�s U4.52.03-H
    def __init__(self, root, title, **kwargs):
        Frame.__init__(self, root, **kwargs)
        Label(self, text=title).grid(row=0, column=0, columnspan=1)


        self.precision = DoubleVar()
        self.iter = IntVar()
        self.para_ortho = DoubleVar()
        self.precision.set(0.0)
        self.iter.set(20)
        self.para_ortho.set(0.717)
        self.sorensen = OptionFrame(self, "Methode SORENSEN",
                                    [ ("Precision (SORENSEN)",Entry,
                                       { 'textvariable':self.precision } ),
                                      ("Nbmax iterations",Entry,
                                       { 'textvariable':self.iter } ),
                                      ("Coef d'orthogonalisation",Entry,
                                       { 'textvariable':self.para_ortho } ),
                                      ])


        self.sorensen.grid(row=1,column=0,sticky="WE",columnspan=2)
        Label(self,text="Option").grid(row=2,column=0)
        self.opt_option = StringVar()
        # variables for the different panels
        #self.opt_centre_amor_reduit = DoubleVar() # utile?
        self.opt_nmax_freq = IntVar() # PLUS_PETITE, BANDE
        self.opt_nmax_freq.set( 10 )
        self.opt_freq1 = DoubleVar() # CENTRE, BANDE
        self.opt_freq2 = DoubleVar() # BANDE

        self.option = MyMenu(self, ("CENTRE","BANDE","PLUS_PETITE"),
                             self.opt_option, self.select_option )
        self.option.grid(row=2,column=1)
        self.opt_option.set("PLUS_PETITE")
        self.opt_panel = None
        self.select_option()
        # Post traitement
        self.opt_seuil_freq = DoubleVar()
        self.opt_seuil_freq.set( 1e-4 )
        self.post = OptionFrame(self, "Post traitement",
                                [("Seuil freq.",Entry,
                                  {'textvariable':self.opt_seuil_freq}),
                                 ])

    def select_option(self, *args):
        opt = self.opt_option.get()
        if self.opt_panel:
            self.opt_panel.destroy()
        if opt == "CENTRE":
            panel = OptionFrame(self, None, [
                (u"Fr�quence",Entry,{'textvariable':self.opt_freq1}),
                ("NMax (-1 pour tout)",Entry,{'textvariable':self.opt_nmax_freq}),
                ])
        elif opt == "BANDE":
            panel = OptionFrame(self, None, [
                (u"Fr�quence min",Entry,{'textvariable':self.opt_freq1}),
                (u"Fr�quence max",Entry,{'textvariable':self.opt_freq2}),
                ])
        elif opt == "PLUS_PETITE":
            panel = OptionFrame(self, None, [
                ("Nmax",Entry,{'textvariable':self.opt_nmax_freq}),
                ])
        else:
            raise RuntimeError("Unknown option '%s'" % opt)
        self.opt_panel = panel
        panel.grid(row=3,column=0,columnspan=2,sticky="WE")


    def get_calc_freq(self):
        opt = self.opt_option.get()
        mc = _F(OPTION=opt)
        mc['SEUIL_FREQ']=self.opt_seuil_freq.get()
        if opt=="PLUS_PETITE":
            mc['NMAX_FREQ']=self.opt_nmax_freq.get()
        elif opt=="BANDE":
            mc['FREQ']=(self.opt_freq1.get(),self.opt_freq2.get())
        elif opt=="CENTRE":
            mc['FREQ']=self.opt_freq1.get()
            mc['NMAX_FREQ']=self.opt_nmax_freq.get()


        return mc



class ParamModeIterInv(Frame):
    """Un panneau pour sp�cifier les param�tres de r�solution
    de MODE_ITER_INV (type_resu='dynamique')
    """
    def __init__(self, root, title, **kwargs):
        Frame.__init__(self, root, **kwargs)
        Label(self, text=title).grid(row=0, column=0, columnspan=1)

        self.frequences = []
        self.opt_option = StringVar()
        self.nmax_freq = IntVar()
        self.nmax_freq.set( 0 )
        self.freq = StringVar()
        self.nmax_iter_separe = IntVar()    # SEPARE ou AJUSTE
        self.nmax_iter_separe.set( 30 )
        self.prec_separe = DoubleVar()
        self.prec_separe.set( 1e-4 )
        self.nmax_iter_ajuste = IntVar()    # AJUSTE
        self.nmax_iter_ajuste.set( 15 )
        self.prec_ajuste = DoubleVar()
        self.prec_ajuste.set( 1e-4 )
        self.opt_freq1 = DoubleVar() # SEPARE, AJUSTE
        self.opt_freq2 = DoubleVar()


        Label(self,text="Option").grid(row=2,column=0)
        self.option = MyMenu(self, ("PROCHE","SEPARE","AJUSTE"),
                             self.opt_option, self.select_option )
        self.opt_option.set("AJUSTE")
        self.option.grid(row=2,column=1)
        Label(self,text="NMAX_FREQ").grid(row=3,column=0)
        Entry(self,textvariable=self.nmax_freq).grid(row=3,column=1)

        self.opt_panel = None
        self.select_option()


    def select_option(self, *args):
        opt = self.opt_option.get()
        if self.opt_panel:
            self.opt_panel.destroy()
        if opt == "PROCHE":
            panel = ModeList(self, u"Fr�quences proches")
            panel.set_values( [ (f, "% 6.2f Hz"%f) for f in self.frequences ] )
        elif opt == "SEPARE":
            panel = OptionFrame(self, None, [
                (u"Fr�quence min",Entry,{'textvariable':self.opt_freq1}),
                (u"Fr�quence max",Entry,{'textvariable':self.opt_freq2}),
                ("NMAX iter separe",Entry,{'textvariable':self.nmax_iter_separe}),
                ("Precision separe",Entry,{'textvariable':self.prec_separe}),
                ])
        elif opt == "AJUSTE":
            panel = OptionFrame(self, None, [
                (u"Fr�quence min",Entry,{'textvariable':self.opt_freq1}),
                (u"Fr�quence max",Entry,{'textvariable':self.opt_freq2}),
                ("NMAX iter separe",Entry,{'textvariable':self.nmax_iter_separe}),
                ("Precision separe",Entry,{'textvariable':self.prec_separe}),
                ("NMAX iter ajuste",Entry,{'textvariable':self.nmax_iter_ajuste}),
                ("Precision ajuste",Entry,{'textvariable':self.prec_ajuste}),
                ])
        else:
            raise RuntimeError("Unknown option '%s'" % opt)
        self.opt_panel = panel
        panel.grid(row=4,column=0,columnspan=2,sticky="WE")


    def get_calc_freq(self):
        opt = self.opt_option.get()
        mc = _F(OPTION=opt)
        mc['NMAX_FREQ']=self.nmax_freq.get()
        if opt=="PROCHE":
            mc['FREQ']=self.panel.selection()
        elif opt=="SEPARE":
            mc['FREQ']=(self.opt_freq1.get(),self.opt_freq2.get())
            mc['NMAX_ITER_SEPARE'] = self.nmax_iter_separe.get()
            mc['PREC_SEPARE'] = self.prec_separe.get()
        elif opt=="AJUSTE":
            mc['FREQ']=(self.opt_freq1.get(),self.opt_freq2.get())
            mc['NMAX_ITER_SEPARE'] = self.nmax_iter_separe.get()
            mc['PREC_SEPARE'] = self.prec_separe.get()
            mc['NMAX_ITER_AJUSTE'] = self.nmax_iter_ajuste.get()
            mc['PREC_AJUSTE'] = self.prec_ajuste.get()
        return mc


class ParamProjMesuModal(Frame):
    """Un panneau pour sp�cifier les param�tres de r�solution
    de PROJ_MESU_MODAL
    """

    def __init__(self, root, title, **kwargs):
        Frame.__init__(self, root, **kwargs)
        Label(self, text=title).grid(row=0, column=0, columnspan=1)


        self.methode = StringVar()
        self.regul_meth = StringVar()
        self.eps = DoubleVar()
        self.regul = DoubleVar()

        Label(self,text="Option").grid(row=2,column=0)

        self.option = MyMenu(self, ("SVD","LU"),
                             self.methode, self.select_option )
        self.set_option({'METHODE':'SVD','REGUL':'NON',
                            'EPS':0.0,'COEF_PONDER':0.0})
        self.option.grid(row=2,column=1)
        self.opt_panel = None
        self.select_option()

    def select_option(self, *args):
        opt = self.methode.get()
        if self.opt_panel:
            self.opt_panel.destroy()
        if opt == "SVD":
            regul_opt = ['NON','NORM_MIN','TIK_RELA']
            panel = OptionFrame(self, None, [
                ("eps",Entry,{'textvariable':self.eps}),
                ("regularisation",MyMenu,{'var':self.regul_meth,
                                          'options':regul_opt}),
                ("ponderation",Entry,{'textvariable':self.regul}),
                ])
            self.regul_meth.set('NON')
        elif opt == "LU":
            panel = Label(self,text=u"Pas de param�trage")
        else:
            raise RuntimeError("Unknown option '%s'" % opt)
        self.opt_panel = panel
        panel.grid(row=3,column=0,columnspan=2,sticky="WE")

    def get_option(self):
        return {'METHODE':self.methode.get(),'REGUL':self.regul_meth.get(),
                'COEF_PONDER':self.regul.get(),'EPS':self.eps.get()}

    def set_option(self,options):
        self.methode.set(options['METHODE'])
        self.regul_meth.set(options['REGUL'])
        self.regul.set(options['COEF_PONDER'])
        self.eps.set(options['EPS'])


    def get_resolution(self):
        mc = {}
        opt = self.methode.get()
        if opt == 'LU':
            mc['METHODE'] = 'LU'
        elif opt == 'SVD':
            mc['METHODE'] = 'SVD'
            mc['EPS'] = self.eps.get()
            mc['REGUL'] = self.regul_meth.get()
            if mc['REGUL'] != 'NON':
                mc['COEF_PONDER'] = self.regul.get()

        return mc




class RowDict(dict):
    """Un dictionaire utilis� pour d�crire
    chaque group de DDL.
    """

    def __init__(self, *args, **kargs):
        dict.__init__(self, *args, **kargs)
        self.chgt_repere_choix = StringVar()
        self.chgt_repere_choix.set("AUCUN")

    def set_chgt_rep(self, chgt_rep):
        """Garde en r�f�rence une instance de `ChgtRepereDialogue'."""
        self.chgt_rep = chgt_rep

    def affiche_chgt_rep(self):
        """Affiche l'interface de changement de rep�re."""
        self.chgt_rep.affiche(self)


class ChgtRepereDialogue(Toplevel):
    """L'interface offrant un changement de rep�re.
    """

    def __init__(self, mess, type_sel=None):
        Toplevel.__init__(self)
        self.withdraw()
        self.protocol("WM_DELETE_WINDOW", self.hide)
        self.dialog_titre = StringVar()
        self._build_interface()

        self.mess = mess
        self.type_sel = type_sel

        self.is_active  = False
        self.row_dict = {}
        self.tmp_widgets = {"labels" : [], "values" : []}
        self._param_key = {
            "UTILISATEUR" :  ["ANGL_NAUT"],
            "CYLINDRIQUE" : ["ORIGINE", "AXE_Z"],
            # Seulement VECT_X ou VECT_Y est utilis� pour NORMALE
            "NORMALE" : ["VECT_X", "VECT_Y"]
            }
        self.normale_vector_choix = None
        self.normale_vector_choix_lst = ["Vecteur x", "Vecteur y"]
        self._update_interface = {
            "AUCUN" : self._update_aucun,
            "UTILISATEUR" : self._update_utilisateur,
            "CYLINDRIQUE" : self._update_cylindrique,
            "NORMALE" : self._update_normale
            }

    def set_type_sel(self, type_sel):
        """Place le titre d�crivant le changement de rep�re."""
        self.type_sel = type_sel

    def _build_interface(self):
        """Construit l'interface de dialogue."""
        fra = Frame(self, relief="groove", borderwidth=4)
        fra.grid(row=0)
        self._build_selection(fra)

        but = Button(fra, text="OK", width=10,
                     command=self.validate_data, default=ACTIVE)
        but.grid(row=1, column=0, padx=4, pady=5)
        but = Button(fra, text="Cancel",
                     width=10, command=self.hide)
        but.grid(row=1, column=1, padx=4, pady=5)

        self.bind("&lt;Return>", self.validate_data)
        self.bind("&lt;Escape>", self.hide)

    def _build_selection(self, root):
        """Construit la s�l�ction du type de changement de rep�re."""
        fra = Frame(root, relief="flat", borderwidth=4)
        fra.grid(row=0, column=0, columnspan=2, padx=4, pady=5)
        self.fra = fra

        Label(fra, textvariable=self.dialog_titre,
              font=("Arial", "16")).grid(row=0, padx=4,
                                         pady=2, sticky='w' + 'e')

        lab = Label(fra, text="Type de changement de rep�re: ")
        lab.grid(row=1, column=0, padx=4, pady=2)

        self.chgt_repere_choix = StringVar()
        menu = MyMenu(fra,
                      ["AUCUN", "UTILISATEUR", "CYLINDRIQUE", "NORMALE"],
                      self.chgt_repere_choix,
                      self.chgt_repere_changed)
        menu.grid(row=1, column=1, padx=4, pady=2)

    def _set_interface(self):
        """Construit le dialogue � son ouverture. Les choix courants
        de l'utilsateur sont affich�s."""
        self.dialog_titre.set(self.type_sel % self.row_dict["NOM"])

        ancien_row_choix = self.row_dict.chgt_repere_choix.get()
        self.chgt_repere_choix.set(ancien_row_choix)
        self.chgt_repere_changed()

    def chgt_repere_changed(self):
        """Construit l'interface pour le type de changement de rep�re
        selectionn�."""
        for wid in self.tmp_widgets["labels"] + self.tmp_widgets["values"]:
            wid.destroy()
        self.tmp_widgets = {"labels" : [], "values" : []}
        choix = self.chgt_repere_choix.get()
        self._update_interface[choix]()

    def _insert_vector(self, param_key, row_offset=0):
        """Place un vecteur dans l'interface."""
        if param_key in self.row_dict["CHGT_REP"]:
            default_values = self.row_dict["CHGT_REP"][param_key]
        else:
            default_values = (0.0, 0.0, 0.0)
        vec = VecteurEntry(self.fra, default_values, self.mess)
        vec.grid(init_col=1, row=2 + row_offset)
        self.tmp_widgets["values"].append(vec)

    def _update_utilisateur(self):
        """Reconstruit l'interface pour le changement
        de rep�re UTILISATEUR"""
        lab = Label(self.fra, text="Angle nautique :")
        lab.grid(row=2, column=0,
                 padx=4, pady=2, sticky='w'+'e')
        self.tmp_widgets["labels"].append(lab)

        self._insert_vector("ANGL_NAUT")

    def _update_cylindrique(self):
        """Reconstruit l'interface pour le changement
        de rep�re CYLINDRIQUE"""
        data = zip(self._param_key["CYLINDRIQUE"],
                   ["Origine", "Axe z"])
        for row_offset, (param_key, text) in enumerate(data):
            lab = Label(self.fra, text=text + " :")
            lab.grid(row=2 + row_offset, column=0,
                     padx=4, pady=2, sticky='w'+'e')
            self.tmp_widgets["labels"].append(lab)

            self._insert_vector(param_key, row_offset)

    def _update_aucun(self):
        """Aucune interface n'est � constuire si AUCUN changement
        de rep�re n'est appliqu�."""
        pass

    def _update_normale(self):
        """Reconstruit l'interface pour le changement
        de rep�re NORMALE"""
        self.normale_vector_choix = StringVar()
        menu = MyMenu(self.fra,
                      self.normale_vector_choix_lst,
                      self.normale_vector_choix,
                      default_var=self.normale_vector_choix_lst[0])
        menu.grid(row=2, column=0,
                  padx=4, pady=2, sticky='w' + 'e')
        self.tmp_widgets["labels"].append(menu)

        has_old_value = False
        for idx, veckey in enumerate(["VECT_X", "VECT_Y"]):
            if veckey in self.row_dict["CHGT_REP"]:
                vectext = self.normale_vector_choix_lst[idx]
                self.normale_vector_choix.set(vectext)
                self._insert_vector(veckey)
                has_old_value = True
        if not has_old_value:
            vectext = self.normale_vector_choix_lst[0]
            self.normale_vector_choix.set(vectext)
            self._insert_vector("VECT_X")

    def validate_data(self):
        """Valide les donn�es entr�es et les place sur le dictionaire
        de r�sultat."""
        choix = self.chgt_repere_choix.get()

        if  choix == "AUCUN":
            param_res = {}
        else:
            param_res = {"REPERE" : choix}
            if choix == "NORMALE":
                res = self.normale_vector_choix.get()
                idx = self.normale_vector_choix_lst.index(res)
                param_key = [self._param_key["NORMALE"][idx]]
            else:
                param_key = self._param_key[choix]

            for key, wid in zip(param_key, self.tmp_widgets["values"]):
                values = wid.get()
                if values:
                    param_res[key] = values
                else:
                    return

        self.row_dict["CHGT_REP"] = param_res
        self.row_dict.chgt_repere_choix.set(choix)

        self.hide()

    def hide(self):
        """Annulation du dialogue"""
        self.withdraw()

    def affiche(self, row_dict):
        """Lance l'interface de dialogue pour entrer un changement
        de rep�re."""
        if not self.is_active:
            self.row_dict = row_dict
            self.is_active = True
            self._set_interface()
            self.deiconify()
            self.is_active = False
        else:
            self.mess.disp_mess(
                u"Un dialogue pour le groupe '%s' " \
                u"est d�j� ouvert. " % self.row_dict["NOM"])
            self.mess.disp_mess(
                u"Il doit d'abord �tre ferm� pour pouvoir lancer " \
                u"un autre changement de rep�re."
                )
        


class GroupNoWidget(Frame):
    """La grille permettant la s�l�ction des DDL.
    Un label identifiant le groupe de DDL et un boutton
    pour ajouter un changement de rep�re peuvent y �tre
    ajoutes.
    """

    def __init__(self, root, nlines, **kwargs):
        Frame.__init__(self, root, **kwargs)
        self.root = root
        self.nlines = nlines
        self.kwargs = kwargs

        self.data = []
        self.widgets = []
        self.ypos = 0
        self.scroll = None
        self.chgt_rep = None
        self.BTNSTYLE = {'indicatoron':0,
                         'borderwidth':1,
                         'relief':GROOVE}

    def set_chgt_rep(self, chgt_rep):
        self.chgt_rep = chgt_rep

    def yview(self, *args):
        IDX = { 'pages' : self.nlines-1, 'units' :1 }
        if args[0]=='moveto':
            _,pos = args
            self.ypos=int(len(self.data)*float(pos))
        elif args[0]=='scroll':
            _,pos,unit = args
            self.ypos += int(pos) * IDX[unit]
        if self.ypos<0:
            self.ypos = 0
        if self.ypos>len(self.data)-self.nlines:
            self.ypos=len(self.data)-self.nlines
        self.redraw()


    def set_data(self, user_data):
        """Place les DDL � s�l�ctioner dans la grille.
        Chaque ligne est represent�e par un dictionaire
        ayant la structure::
            {"NOM" : le nom du groupe DDL (optionel),
             "NOM_CMP" : la liste des DDL � afficher}

        :param user_data: la structure de la grille.
        :type user_data: une liste de dictionaires.
        """
        for wlist in self.widgets:
            for wid in wlist:
                wid.destroy()

        self.data = []
        self.widgets = []
        STYLE = self.BTNSTYLE.copy()
        STYLE.update(self.kwargs)

        for row_user_dict in user_data:
            row_dict = RowDict(row_user_dict.items())
            row_widgets = []
            row_ddl_vars = []

            if "NOM" in row_dict:
                lab =  Label(self, text=row_dict["NOM"], **self.kwargs)
                row_widgets.append(lab)
            else:
                row_dict["NOM"] = None

            for ddl_key in row_dict["NOM_CMP"]:
                var = IntVar()
                but = Checkbutton(self, text=ddl_key,
                                        command=self.toggled,
                                        variable=var, **STYLE)
                row_ddl_vars.append(var)
                row_widgets.append(but)

            row_dict["DDL_VARS"] = row_ddl_vars

            if self.chgt_rep:
                row_dict["CHGT_REP"] = {}
                row_dict.set_chgt_rep(self.chgt_rep)
                but = Button(self,
                             textvariable=row_dict.chgt_repere_choix,
                             command=row_dict.affiche_chgt_rep)
                row_widgets.append(but)

            self.data.append(row_dict)
            self.widgets.append(row_widgets)

        self.redraw()

    def redraw(self):
        for i,r in enumerate(self.widgets):
            for j,o in enumerate(r):
                if i<self.ypos or i>=self.ypos+self.nlines:
                    o.grid_forget()
                else:
                    o.grid(row=i-self.ypos,column=j,sticky='w')
        if self.scroll:
            N = float(len(self.data))
            p0 = self.ypos/N
            p1 = (self.ypos+self.nlines)/N
            self.scroll.set(p0,p1)

    def get_selected(self):
        """Retourne la liste des groupes de DDL
        selection�s.

        Exemple de resultat retourne [{'NOM_CMP': ['DZ'], 'NOM': 'GRNO1   ','CHGT_REP': {'VECT_Y': (0.0, 1.0, 0.0), 'REPERE': 'NORMALE'}},
                                      {'NOM_CMP': ['DX', 'DY', 'DZ'], 'NOM': 'SUP_NO  ', 'CHGT_REP': {}}]"""
        resu_lst = []
        for row_dict in self.data:
            res = []
            for ddl_key, int_widget in zip(row_dict["NOM_CMP"],
                                           row_dict["DDL_VARS"]):
                if int_widget.get():
                    res.append(ddl_key.strip())
            if res:
                resdict = {"NOM" : row_dict["NOM"],
                           "NOM_CMP" : res}
                if self.chgt_rep:
                    resdict["CHGT_REP"] = row_dict["CHGT_REP"]
                resu_lst.append(resdict)
        return resu_lst


    def set_selected(self,valeur_etape):
        """Si le concept a ete cree ac OBSERVATION, remplit le self.data
           et met a jour l'interface.
        """
        message = u"La macro OBSERVATION a �t� utilis�e avec le \
                    mot-cl� NOEUD ou MAILLE. On ne peut pas traiter \
                    ce cas dans la fen�tre d'Observation"

##        print "  "
##        print "self.data = "
##        print self.data
##        print "  "
        if valeur_etape.has_key('FILTRE'):
            filtres = valeur_etape['FILTRE']
            if not isinstance(filtres,list) and not isinstance(filtres,tuple):
                filtres=[filtres]

            for filtre in filtres:
                if filtre.has_key('GROUP_NO'):
                    grnos = filtre['GROUP_NO']
                elif filtre.has_key('GROUP_MA'):
                    grnos = filtre['GROUP_MA']
                else:
                    # cas ou les filtres ont ete definis par les mc NOEUD ou MAILLE : non traite
                    self.mess.disp_mess(message)

                if type(grnos)==str:grnos=[grnos]
                ddls = filtre['DDL_ACTIF']
                for grno in grnos:
                    for row_dict in self.data:
                        if row_dict['NOM'].split()==grno.split():
                            for ddl in ddls:
                                for ddl_key, int_widget in zip(row_dict["NOM_CMP"],row_dict["DDL_VARS"]):
                                    if ddl_key.split() == ddl.split():
                                        int_widget.set(1)

                    

        if valeur_etape.has_key('MODI_REPERE'):
            modis_reperes = valeur_etape['MODI_REPERE']
            if not isinstance(modis_reperes,list) and not isinstance(modis_reperes,tuple):
                modis_reperes=[modis_reperes]
            self.set_chgt_rep(self.root.chgt_rep)


            for modi_repere in modis_reperes:
                if filtre.has_key('GROUP_NO'):
                    grnos = filtre['GROUP_NO']
                elif filtre.has_key('GROUP_MA'):
                    grnos = filtre['GROUP_MA']
                else:
                    # cas ou les filtres ont ete definis par les mc NOEUD ou MAILLE : non traite
                    self.mess.disp_mess(message)
                if isinstance(grnos,str):grnos = [grnos]
                for grno in grnos:
                    for row_dict in self.data:
                        if row_dict['NOM'].split()==grno.split():
                            row_dict.chgt_repere_choix.set(modi_repere['REPERE'])
                            row_dict['CHGT_REP'] = modi_repere
                            # le mot-cle GROUP_NO est deja dans le row_dict : on l'enleve
                            row_dict['CHGT_REP'].pop('GROUP_NO')
                            row_dict.set_chgt_rep(self.chgt_rep)
                            


    def toggled(self):
        self.root.notify()



class DispFRFDialogue(Toplevel):
    """Interface permettant de fabriquer un resultat harmonique a partir d'une base de modes
       et d'une excitation de type marteau, et de visualiser les FRF
    """

    def __init__(self, mess, ce_objects, param_visu, resu1=None, resu2=None, sumail=None,modes_couple = None):
        Toplevel.__init__(self)


        self.mess = mess
        self.ce_objects = ce_objects
        self.param_visu = param_visu
        self.resu1 = resu1
        self.resu2 = resu2
        self.sumail = sumail
        self.modes_couple = modes_couple
        self.dyna = [None,None,None]               # self.dyna[2] est cree dans le cas ou on a une super maille
        self.ddls = [[],[]]
        self.resu = [None,None]
        self.var_type_resu = [StringVar(),StringVar()]
        self.var_resu = [StringVar(),StringVar()]
        self.exci_no = [StringVar(),StringVar()]   # 'N1','N2'...
        self.exci_ddl = [StringVar(),StringVar()]  # 'FX','FY','FZ'
        self.freq_min = [StringVar(),StringVar()]
        self.freq_max = [StringVar(),StringVar()]
        self.df = [StringVar(),StringVar()]
        self.param_calc = [{'noeud':self.exci_no[0],'ddl':self.exci_ddl[0],'freq_min':self.freq_min[0],
                            'freq_max':self.freq_max[0],'df':self.df[0]},
                           {'noeud':self.exci_no[1],'ddl':self.exci_ddl[1],'freq_min':self.freq_min[1],
                            'freq_max':self.freq_max[1],'df':self.df[1]}]
        self.visu_no = [StringVar(),StringVar()]  # 'N1','N2'...
        self.visu_ddl = [StringVar(),StringVar()]    # 'DX','DY','DZ','DRX',...
        self.champ_visu = [StringVar(),StringVar()]  # 'DEPL','VITE', ou 'ACCE
        self.champ_choisi = [None,None]
        self.param_disp = [{'champ':self.champ_visu[0],'noeud':self.visu_no[0],'ddl':self.visu_ddl[0]},
                           {'champ':self.champ_visu[1],'noeud':self.visu_no[1],'ddl':self.visu_ddl[1]}]
        self.errmess1 = " ERREUR : Donnees incompletes pour le calcul"


        self.var_champ = StringVar()
        self.visu_ddl = StringVar()
        self.visu_no = StringVar()

        self.protocol("WM_DELETE_WINDOW", self.hide)
        self.dialog_titre = StringVar()
        self._build_interface()

        self.is_active  = False
        self.row_dict = {}
        self.tmp_widgets = {"labels" : [], "values" : []}
        self.bind("&lt;Escape>", self.hide)

    def update(self):
        for ind in range(2):
            if self.var_resu[ind].get().split()[0] != 'Choisir':
                self.resu[ind] = self.ce_objects.get_resultats(self.var_resu[ind].get())
                if isinstance(self.resu[ind],ModeMeca):
                    self.var_type_resu[ind].set('mode')
                elif isinstance(self.resu[ind],DynaHarmo):
                    self.var_type_resu[ind].set('harmo')
                    self.dyna[ind] = self.resu[ind]

        self.f.grid_remove()
        self._build_interface()



    def _build_interface(self):
        """Construit l'interface de dialogue :
            - choix de 1 ou 2 concepts resultats (pour comparaison)
            - si les concepts sont des bases de modes, la boite 2 permet de simuler une FRF au marteau
              elle n'est affichee que si les concepts ont ete selectionnes et sont des mode_meca
            - la boite 3 permet de visualiser les FRF sur un DDL a selectionner
        """
        self.f = Frame(self)
        self.f.grid()
        mdo = self.ce_objects

        # boite 1 : choix de deux concepts resultats
        f1 = Frame(self.f, relief='sunken', borderwidth=1)
        f1.columnconfigure(0,weight=1)
        f1.columnconfigure(1,weight=1)

        Label(f1, text="Choix des concepts a visualiser").grid(row=0,column=0,columnspan = 2,pady=5)

        # Resultat 1
        f11 = self.choix_resu(f1,0)
        f11.grid(row=1,column=0,sticky='nsew')
        # Resultat 2
        f12 = self.choix_resu(f1,1)
        f12.grid(row=1,column=1,sticky='nsew')

        f1.grid(row=0,column=0)

        if self.dyna[0] or self.dyna[1]:
            Button(self.f,text='Afficher',command=self.affich_FRF).grid(row=1,column=0,sticky='e')


    def choix_resu(self,parent,num_resu):
        f1 = Frame(parent, relief='sunken', borderwidth=1)
        titre = "RESULTAT "+str(num_resu+1)
        Label(f1, text=titre).grid(row=0,column=0,columnspan=2,sticky='new')
        mdo = self.ce_objects
        if self.resu[num_resu]: default = self.resu[num_resu].nom
        else: default= None
        MyMenu( f1, options = mdo.get_resultats_name(),default_var = default,
                var = self.var_resu[num_resu], cmd = self.update).grid(row=1,column=0,sticky='new',columnspan=2,padx=10)
        # Type de resultat (dyna_harmo ou modes)
        Radiobutton(f1,text='dyna_harmo',value='harmo', variable=self.var_type_resu[num_resu]).grid(row=2,column=0)
        Radiobutton(f1,text='mode_meca',value='mode', variable=self.var_type_resu[num_resu]).grid(row=2,column=1)
        f1.grid(row=1,column=0)

        # si le concept est un mode_meca, calcul d'une FRF
        if isinstance(self.resu[num_resu],ModeMeca):
           f2 = self.frame_excit(f1,num_resu,self.resu[num_resu].nom,self.param_calc[num_resu])
           f2.grid(row=3,column=0,columnspan=2,sticky='nsew')

        # si c'est un dyna_harmo, ou si le dyna_harmo correspondant a ete calcule, on propose les param d'affichage
        if self.dyna[num_resu]:
           f3 = self.frame_disp(f1,num_resu,self.param_disp[num_resu])
           f3.grid(row=4,column=0,columnspan=2,sticky='nsew')

        return f1


    def frame_excit(self,parent,num_resu,nom_resu,param):
        f = Frame(parent, relief='sunken', borderwidth=1)

        texte = "Simulation du resultat harmonique pour " + nom_resu
        Label(f, text=texte).grid(row=0,column=0, columnspan = 2,pady=5)
        Label(f, text="Noeud d'excitation").grid(row=1, column=0, sticky='e')
        Entry(f, textvariable = param['noeud']).grid(row=1,column=1, sticky='ew')
        Label(f, text="Direction d'excitation").grid(row=2, column=0, sticky='e')
        ddls = ('FX','FY','FZ')
        MyMenu(f, var = param['ddl'],options = ddls).grid(row=2, column=1, sticky='ew')

        Label(f,text='Parametres de calcul').grid(row=3,column=0,columnspan=2,pady=5)
        Label(f,text='Frequence min').grid(row=4,column=0, sticky='e')
        Entry(f,textvariable = param['freq_min']).grid(row=4,column=1, sticky='we')
        Label(f,text='Frequence max').grid(row=5,column=0, sticky='e')
        Entry(f,textvariable = param['freq_max']).grid(row=5,column=1, sticky='we')
        Label(f,text='Resolution frequentielle').grid(row=6,column=0, sticky='e')
        Entry(f,textvariable = param['df']).grid(row=6,column=1, sticky='we')

        fonc = 'prep_calc'+str(num_resu+1)
        Button(f,text='Calculer',command=getattr(self,fonc)).grid(row=7,column=1,sticky='e')

        return f

    def frame_disp(self,parent,num_resu,param):
        f = Frame(parent, relief='sunken', borderwidth=1)

        Label(f, text="Affichage des FRF").grid(row=0,column=0, columnspan=2,pady=5)
        Label(f, text="Champ").grid(row=1, column=0, sticky='e')
        champs = self.choix_champ(self.dyna[num_resu])
        nom_fonc = 'choix_ddl'+str(num_resu+1)
        default = self.champ_choisi[num_resu]
        MyMenu( f, options = champs,default_var = default,
                var = param['champ'], cmd = getattr(self,nom_fonc)).grid(row=1,column=1,sticky='ew')
        Label(f, text="Noeud").grid(row=2, column=0, sticky='we')
        Entry(f,textvariable = param['noeud']).grid(row=2,column=1, sticky='e')
        Label(f, text="DDL").grid(row=3, column=0, sticky='we')
        MyMenu(f, var = param['ddl'],options = self.ddls[num_resu]).grid(row=3, column=1, sticky='ew')

        return f


    def prep_calc1(self):
        self.prep_calc(0,self.resu[0],self.param_calc[0])

    def prep_calc2(self):
        self.prep_calc(1,self.resu[1],self.param_calc[1])


    def prep_calc(self,num_resu,resu,param):
        """ Calcul des FRF associees a une base de mode et une excitation "marteau".
            Pour les calculs de modification structurale (sumail != None), calcul du depl interne"""
        from Cata.cata import DEPL_INTERNE
        mdo = self.ce_objects
        if isinstance(self.modes_couple,ModeMeca): nom = self.modes_couple
        else: nom = " "


        if isinstance(resu,ModeMeca):
            # le concept 1 est un mode_meca : verification de la presence des donnees d'entree pour le calcul :
            if not self.verif_param(param) :
                self.mess.disp_mess(self.errmess1)
                return

            if resu.obj.nom != nom:
                kass = resu.kass
                mass = resu.mass
                cass = resu.cass
                self.dyna[num_resu] = self.calc_dyna_line_harm(resu,mass,kass,cass,param)
            else:
                kass = self.modes_couple.kass
                mass = self.modes_couple.mass
                cass = self.modes_couple.cass
                self.dyna[num_resu] = self.calc_dyna_line_harm(resu,mass,kass,cass,param)
                # etape supplementaire pour les calculs de modif struct
                try:
                    __DYNAM = DEPL_INTERNE(DEPL_GLOBAL=self.dyna[num_resu].obj,SUPER_MAILLE=self.sumail)
                except aster.error,err:
                    message = "ERREUR ASTER : " + mess.GetText('I',err.id_message, err.valk, err.vali, err.valr)
                    self.mess.disp_mess( message)
                    return
                self.dyna[num_resu] = DynaHarmo( self.ce_objects, __DYNAM.nom, __DYNAM )
                self.ce_objects.update(__DYNAM.nom, __DYNAM )
            self.update()


    def verif_param(self,param):
        """ verification des parametres rentres par l'utilisateur (les parametres sont des StringVar)"""
        if isinstance(param,dict):
            liste =  [ kk[1].get() for kk in param.items()]
        elif isinstance(param,list):
            liste = [kk.get() for kk in param]
        for para in liste:
            if not para:return False                      # la case n'est pas remplie
            if para.split()[0] == 'Choisir':return False  # le menu est reste sur 'Choisir'
        return True


    def choix_champ(self,dyna):
        # la liste des champs non vides dans dyna
        champs = []
        desc = dyna.obj.sdj.DESC.get()
        for ind_cha in range(3): # On regarde uniquement la presence de DEPL, VITE et ACCE
            if dyna.obj.sdj.TACH.get()[ind_cha+1][0].split():
                champs.append(desc[ind_cha].split()[0])
        return champs

    def choix_ddl1(self):
        self.choix_ddl(0)#self.dyna[0],self.param_disp[0],self.champ_choisi[0])

    def choix_ddl2(self):
        self.choix_ddl(1)#self.dyna[1],self.param_disp[1],self.champ_choisi[1])

    def choix_ddl(self,num_resu):
        # la liste des ddls dispos pour le champ selectionne
        from Cata.cata import CREA_CHAMP, DETRUIRE
        ddls = []
        self.champ_choisi[num_resu] = self.param_disp[num_resu]['champ'].get()
        try:
            __PHI = CREA_CHAMP(RESULTAT=self.dyna[num_resu].obj,
                               OPERATION='EXTR',
                               NUME_ORDRE=1,
                               TYPE_CHAM='NOEU_DEPL_C',
                               NOM_CHAM=self.champ_choisi[num_resu])

            __PHI2 = CREA_CHAMP(CHAM_GD=__PHI,
                                OPERATION='C2R',
                                TYPE_CHAM='NOEU_DEPL_R',
                                PARTIE='REEL')

            phi = __PHI2.EXTR_COMP(' ',[],1)

            DETRUIRE(CONCEPT = _F(NOM=(__PHI,__PHI2)))
            comp = phi.comp

        except aster.error:
            message = "ERREUR ASTER : " + mess.GetText('I',err.id_message, err.valk, err.vali, err.valr)
            self.mess.disp_mess( message)
            self.ddls[num_resu] = []
            return


        for ddl in comp:
            if ddl not in ddls:
                ddls.append(ddl)
        self.ddls[num_resu] = ddls

        self.update()



    def calc_dyna_line_harm(self,resu,mass,kass,cass,param):
        """ Calcul harmonique sur base physique avec DYNA_LINE_HARM"""
        ## TODO :  rendre possible un calcul sur base modale, en fabriquant les
        ## matrices de mass et de raideur generalisees a partir des donnees mesurees
        from Cata.cata import DYNA_LINE_HARM, AFFE_CHAR_MECA, DEFI_FONCTION

        f_min = string.atof(param['freq_min'].get())
        f_max = string.atof(param['freq_max'].get())
        df = string.atof(param['df'].get())
        nb_freq = int((f_max-f_min)/df)
        freq = [f_min+df*kk for kk in range(nb_freq)]
        noeud = param['noeud'].get()
        ddl = param['ddl'].get()

        modele = resu.modele.obj

        mcfact = { 'NOEUD' : noeud, ddl : 1.0 }
        try:
            __char = AFFE_CHAR_MECA( MODELE = modele,
                                     FORCE_NODALE = mcfact )

            __dyna = DYNA_LINE_HARM( MATR_MASS = mass,
                                     MATR_RIGI = kass,
                                     MATR_AMOR = cass,
                                     NOM_CHAM = ('DEPL','VITE','ACCE'),
                                     FREQ = freq,
                                     MODELE = modele,
                                     EXCIT = _F( CHARGE = __char,
                                                 COEF_MULT_C=('RI',1.,0.) ))
        except aster.error,err:
            message = "ERREUR ASTER : " + mess.GetText('I',err.id_message, err.valk, err.vali, err.valr)
            self.mess.disp_mess( message)
            return

        dyna = DynaHarmo( self.ce_objects, __dyna.nom, __dyna )
        self.ce_objects.update(__dyna.nom, __dyna )
        self.update()

        return dyna


    def affich_FRF1(self):
        self.affich_FRF(0)

    def affich_FRF2(self):
        self.affich_FRF(1)


    def affich_FRF(self):
        from Cata.cata import RECU_FONCTION
        if self.sumail:
            dynas = [self.dyna[0],self.dyna[2]]
        else:
            dynas = [self.dyna[0],self.dyna[1]]
        param = self.param_disp

        freq = []
        ordo = []
        couleur = []
        l_legende = []
        for ind in range(2):
            if not dynas[ind]:
                pass
            else:
                if not self.verif_param(param[ind]):
                    self.mess.disp_mess(u"Il manque des donn�es pour afficher les FRF, colonne " +str(ind+1))
                    pass
                else:
                    champ = param[ind]['champ'].get()
                    noeud = param[ind]['noeud'].get()
                    ddl = param[ind]['ddl'].get()
                    try:
                        __fonc = RECU_FONCTION( RESULTAT = dynas[ind].obj,
                                            NOM_CHAM = champ,
                                            NOEUD = noeud,
                                            NOM_CMP = ddl )
                    except aster.error,err:
                        message = "ERREUR ASTER, COLONNE " +str(ind+1)+" : " + mess.GetText('I',err.id_message, err.valk, err.vali, err.valr)
                        self.mess.disp_mess( message)
                        return

                    fonc_py = __fonc.convert('complex')
                    ordo.append(fonc_py.vale_y)
                    freq = fonc_py.vale_x
                    l_legende.append("%s %s_%s" % (dynas[ind].nom,champ,ddl))
                    couleur.append(ind+1)

        module = [abs(kk) for kk in ordo]

        titre = "Visualisation des FRF"
        self.param_visu.visu_courbe(freq, module, couleur, titre, l_legende,
                                    'Frequence', 'FRF','Hz','unite/Hz')



    def hide(self):
        """Annulation du dialogue"""
        self.withdraw()


class ObservationWindow(Frame):

    def __init__(self,parent,root,mess,ce_objects,resu=None,
                 type_co=u"'observabilit�",close_widget=1,**args):
        Frame.__init__(self,parent,args)
        self.parent = parent
        self.root = root
        self.font2 = tkFont.Font( family="Helvetica", size=14 )
        self.objects = ce_objects 
        self.chgt_rep = ChgtRepereDialogue(mess)     
        self.mess = mess
        self.obs_co = None
        self.type_co = type_co
        self.close_widget = close_widget

        
        self.create_obsframe()

    def setup(self):
        mdo = self.objects
        self.menu_obs_resu.update(mdo.get_mode_meca_name(),
                                  self.nom_obs_resu,
                                  self._observabilite_changed)
        self.root.objects = mdo
        self.root.setup()

    def set_selected(self,valeur_etape):
        self.obs_noeuds.grp.set_selected(valeur_etape)
        self.obs_mailles.grp.set_selected(valeur_etape)
        

    def create_obsframe(self):
        Label(self,text=u"D�finition du concept d"+(self.type_co),
              font=self.font2).grid(row=0, column=0, columnspan=4)   


        # Menu choix des deformees a projeter
        Label(self, text=u"Base de d�form�es").grid(row=1,column=0, sticky='ew')
        self.nom_obs_resu = StringVar()
        self.menu_obs_resu = MyMenu(self,self.objects.get_mode_meca_name(),
                                    self.nom_obs_resu,
                                    self._observabilite_changed)
        self.menu_obs_resu.grid(row=2, column=0, sticky='we',pady=2, padx=20)

        # Menu choix du modele experimental associe
        Label(self, text=u"Mod�le exp�rimental").grid(row=1,column=1, sticky='ew')
        self.nom_obs_modele = StringVar()
        self.menu_obs_modele = MyMenu(self,self.objects.get_model_name(),
                                      self.nom_obs_modele,
                                      self._observabilite_changed)
        self.menu_obs_modele.grid(row=2, column=1, sticky='we',pady=2, padx=20)

        # Menu choix des DDL par groupe de mailles et de noeuds
        no_title = "Groupe de noeuds et DDL des capteurs"
        self.obs_noeuds = SelectionNoeuds(self, no_title, bg='#90a090',
                                          chgt_rep=self.chgt_rep)
        self.obs_noeuds.grid(row=3, column=0, sticky='we',
                             columnspan=3, pady=2, padx=2)
        
        ma_title = "Groupe de mailles et DDL des capteurs"
        self.obs_mailles = SelectionMailles(self, ma_title, bg='#9090a0',
                                            chgt_rep=self.chgt_rep)
        self.obs_mailles.grid(row=4, column=0, sticky='we',
                              columnspan=3, pady=2, padx=2)
       
        but = Button(self, text="Valider",
                     command=self._calculate_observabilite)
        but.grid(row=5, column=3, sticky='e', padx=2, pady=2)

        if self.close_widget:
            but = Button(self, text="Fermer",command=self.detruire)
            but.grid(row=5, column=2, sticky='e', padx=2, pady=2)



        self.columnconfigure(0, weight=1)
        self.columnconfigure(1, weight=1)
        self.grid(sticky='e')

    
    def _observabilite_changed(self):
        
        nom_resu = self.nom_obs_resu.get()
        if nom_resu.strip() !='Choisir':
            resu = self.objects.get_resultats(nom_resu)

        nom_modele = self.nom_obs_modele.get()
        if nom_modele.strip() != 'Choisir':
            modele = self.objects.get_model(nom_modele)
            self.obs_noeuds.set_resultat(modele)
            self.obs_mailles.set_resultat(modele)


    def _calculate_observabilite(self):

        from Cata.cata import CO,OBSERVATION, DETRUIRE

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
                                 MATR_RIGI = modele.kass,
                                 MATR_MASS = modele.mass,
                                 NOM_CHAM = 'DEPL',
                                 FILTRE   = get_filtres(grp_no, grp_ma),
                                 MODI_REPERE = get_chgt_repere(grp_no, grp_ma)
                               );
        except:
            self.mess.disp_mess(u"Le concept d"+self.type_co+ \
                                u"n'a pas pu �tre calcul�.\n"\
                                u"L'erreur est affich�e en console.")
            raise

        self.mess.disp_mess(u"Le concept d"+self.type_co+ \
                            u" a �t� calcul� et il porte le nom " + __OBS.nom)


        self.obs_co = ModeMeca(self.objects,__OBS.nom,__OBS,self.mess)
        self.obs_co.get_modele()
        self.obs_co.get_matrices()
        self.obs_co.get_nume()
        self.obs_co.get_maillage()
        self.objects.update(__OBS.nom,__OBS)
        self.setup()

    def detruire(self):
        self.parent.destroy()



class DispObs(Toplevel):

    def __init__(self,parent,mess,ce_objects, resu=None):
        Toplevel.__init__(self)
        self.resu = resu
        self.objects = ce_objects 
        self.font2 = tkFont.Font( family="Helvetica", size=14 )
        self.obs_co = None                                                         
        self.mess = mess

        self.obs_window = ObservationWindow(self,parent,mess,ce_objects)
        self.obs_window.create_obsframe()
        self.obs_window.grid()

    def setup(self):
        self.obs_window.setup()

    def set_resu(self,nom_resu):
        self.obs_window.nom_obs_resu.set(nom_resu)
        
        ctx = CONTEXT.get_current_step().get_contexte_courant()
        # si nom_resu a ete cree par OBSERVATION
        for etape in CONTEXT.get_current_step().jdc.etapes:
            if etape.nom == 'OBSERVATION':
                if etape.get_created_sd()[0].nom == nom_resu:
                    nom_modele = etape.valeur['MODELE_2'].nom
                    self.set_modele(nom_modele)
                    self.set_selected(etape.valeur)
                    nom_resu = etape.valeur['RESULTAT'].nom
                    self.obs_window.nom_obs_resu.set(nom_resu)
        
##        self.obs_window._observabilite_changed()

    def set_modele(self,nom_modele):
        self.obs_window.nom_obs_modele.set(nom_modele)
        self.obs_window._observabilite_changed()
        
    def set_selected(self,valeur_etape):
        self.obs_window.set_selected(valeur_etape)
            
        
    def setup(self):
        self.obs_co = self.obs_window.obs_co

    def hide(self):
        """Annulation du dialogue"""
        self.withdraw()



# R�cup�ration du concept donnant la composante
# du d�placement (DX, DY...DRZ) � partir de l'indice
# du degr� de libert�
NOMCMP = aster.getcolljev('&CATA.GD.NOMCMP'.ljust(24))
DEPL_R = NOMCMP['DEPL_R  ']
ORDERED_DDL_PATTERN = ['DX', 'DY', 'DZ', 'DRX', 'DRY', 'DRZ']

def sort_compo_key(compo_key):
    """Retourne l'indice du DDL par rapport au mod�le."""
    return ORDERED_DDL_PATTERN.index(compo_key.strip())

def find_composantes(grp_noeuds, noeuds_def, nb_no, mess = None):
    """Retourne les composantes du d�placement (DX, DY...DRZ)
    pour chaque groupe de noeuds. Les noeuds sont d�finis par
    leur indice provenant du maillage."""
    composantes = {}

    if not grp_noeuds:
        return None

    # nb_ecod : nombre d'entier pour coder les DDL de deplacement.
    nb_ecod = len(noeuds_def)/nb_no
    for grp, noeud_idxs in grp_noeuds.items():
        grp_comp = set()
        for noeud_idx in noeud_idxs:
            k = (noeud_idx - 1) * 5
            for i in range(5):
                comp_bits = noeuds_def[k + i]
                for j in range(1, 31):
                    if comp_bits & 1<<j:
                        idx = 30*i + j - 1
                        grp_comp.add(DEPL_R[idx])
        composantes[grp] = grp_comp

    return composantes


class _SelectionBase(Frame):


    def __init__(self, root, title, **kwargs):
        self.cmd = None
        self.chgt_rep = None
        kwargs = self._parse_kwargs(kwargs)

        Frame.__init__(self, root, **kwargs)

        Label(self, text=title, **kwargs).grid(row=0, column=0, columnspan=2,padx=100)
        Label(self, text=' ', pady=30, **kwargs).grid(row=1, column=0, columnspan=2)
        self.grp = GroupNoWidget(self, 2, **kwargs)
        self.grp.grid(row=1,column=1)
        if self.chgt_rep:
            self.grp.set_chgt_rep(self.chgt_rep)

        scroll = Scrollbar(self, orient='vertical',
                           command=self.grp.yview, **kwargs)
        scroll.grid(row=1, column=2, sticky='nse')
        self.grp.scroll = scroll

    def _parse_kwargs(self, kwargs):
        if 'command' in kwargs:
            self.cmd = kwargs['command']
            del kwargs['command']

        if 'chgt_rep' in kwargs:
            self.chgt_rep = kwargs['chgt_rep']
            del kwargs['chgt_rep']

        return kwargs

    def set_modele_maillage(self, modl, maillage):
        pass

    def set_modele(self, modl, concepts):
        noma = modl.sdj.MODELE.LGRF.get()[0].strip()
        maillage = concepts[noma]
        self.set_modele_maillage(modl, maillage)

    def set_resultat(self, modele):
        """Place un concept de type `Resultat' pour
        la repr�sentation des groupe de noeuds ou de mailles
        dans l'interface Tk. Cette m�thode exploite le travail
        accomplit par `Resultat' qui recherche automatiquement
        le mod�le et le maillage lors de sa cr�ation."""
        self.set_modele_maillage(modele.obj, modele.maya)

    def display_comp(self, composantes,type_gr):
        data = []
        groupes = composantes.keys()
        groupes.sort()

        for grp in groupes:
            ddl_keys = list(composantes[grp])
            if len(ddl_keys) != 0:
                try:
                    ddl_keys.sort(key=sort_compo_key)
                except TypeError: # version de python < 2.4
                    ddl_keys.sort()
                data.append({"NOM": grp, "NOM_CMP" : ddl_keys,"TYPE":type_gr})

        self.grp.set_data(data)

    def get_selected(self):
        """retourne [{'NOM_CMP':['DX','DZ'], 'NOM': 'grno1   ',
                      'CHGT_REP': {'VECT_Y': (0.0, 1.0, 0.0), 'REPERE': 'NORMALE'}},
                      {'NOM_CMP': ['DY'], 'NOM': 'grno2   ', 'CHGT_REP': {}}]
        """
        return self.grp.get_selected()

    def notify(self):
        if self.cmd:
            self.cmd()


class SelectionNoeuds(_SelectionBase):

    def __init__(self, root, title, **kwargs):
        _SelectionBase.__init__(self, root, title, **kwargs)
        if self.chgt_rep:
            self.chgt_rep.set_type_sel("Groupe de noeuds: %s.")

    def set_modele_maillage(self, modl, maillage):
        """groupno = {'grno1':(1,3,4,5),'grno2':(2,6,7)...}
           PRNM decrit les ddl portes par les noeuds du modele
           (voir wiki aster pour plus de precisions)
        """
        noeuds_def = modl.sdj.MODELE.PRNM.get()
        groupno = maillage.sdj.GROUPENO.get()
        nos = maillage.sdj.NOMNOE.get()
        nb_no = len(nos)
        composantes = find_composantes(groupno, noeuds_def, nb_no)
        self.display_comp(composantes,'NOEUDS')


class SelectionMailles(_SelectionBase):

    def __init__(self, root, title, **kwargs):
        _SelectionBase.__init__(self, root, title, **kwargs)
        if self.chgt_rep:
            self.chgt_rep.set_type_sel("Groupe de mailles: %s.")

    def set_modele_maillage(self, modl, maillage):
        noeuds_def = modl.sdj.MODELE.PRNM.get()
        groupma = maillage.sdj.GROUPEMA.get()
        mailles_def = maillage.sdj.CONNEX.get()

        groupno = {}
        for grp, mailles in groupma.items():
            noeuds = []
            groupno[grp] = noeuds
            for maille in mailles:
                for nod in mailles_def[maille]:
                    if nod not in noeuds:
                        noeuds.append(nod)
        nos = maillage.sdj.NOMNOE.get()
        nb_no = len(nos)
        composantes = find_composantes(groupno, noeuds_def, nb_no)
        self.display_comp(composantes,'MAILLES')



class VecteurEntry:
    """Permet de rentrer les valeurs pour les 3 composantes
    d'un vecteur.
    """

    def __init__(self, root, default_values, mess):
        self.values = []
        self.widgets = []
        for def_val in default_values:
            val = StringVar()
            val.set(def_val)
            self.values.append(val)
            self.widgets.append(Entry(root, textvariable=val))
        self.mess = mess

    def grid(self, init_col, **kargs):
        """Place les 3 entr�es dans l'interface Tk"""
        for idx, wid in enumerate(self.widgets):
            wid.grid(column=init_col + idx, **kargs)

    def get(self):
        """Retourne les composantes du vecteur."""
        res_values = []
        for raw_val in self.values:
            try:
                val = float(raw_val.get())
                res_values.append(val)
            except ValueError:
                self.mess.disp_mess(
                    u"Mauvaise entr�e: " \
                    u"un des champs semble ne pas �tre un r�el."
                    )
                return None

        return tuple(res_values)

    def destroy(self):
        """D�truit l'object vecteur"""
        for wid in self.widgets:
            wid.destroy()


#-----------------------------------------------------------------------------



class CalcEssaiXmgr(Xmgr):
    """Une interface � Xmgrace pouvant �tre lanc�e
    plusieurs fois en m�me temps (l'unique diff�rence
    avec la version Stanley)."""

    def __init__(self, xmgr_idx, gr_max = 10, options=None,
                       xmgrace=os.path.join(aster_core.get_option('repout'), 'xmgrace')):

        self.gr_max   = gr_max        # nombre de graphes
        self.gr_act   = 0             # numero du graphe actif
        self.sets     = [0]*gr_max    # nombre de sets par graphe
        self.nom_pipe = 'xmgr%i.pipe' % xmgr_idx  # nom du pipe de communication
        if xmgrace == "/xmgrace":
            print "Pbl with aster repout ", aster_core.get_option('repout')
            self.xmgrace = "/usr/bin/xmgrace"
        else:
            self.xmgrace  = xmgrace

        # Ouverture du pipe de communication avec xmgrace
        if os.path.exists(self.nom_pipe) :
          os.remove(self.nom_pipe)
        os.mkfifo(self.nom_pipe)
        self.pipe = open(self.nom_pipe,'a+')

        # Lancement de xmgrace
        shell = self.xmgrace + ' -noask '
        if options != None :
           shell += options
        shell +=' -graph ' + repr(gr_max-1) + ' -npipe ' + self.nom_pipe

        # Teste le DISPLAY avant de lancer xmgrace...
        if os.environ.has_key('DISPLAY'):
          UTMESS('I','STANLEY_9',valk=[shell])
          self.controle = Popen3(shell)

          # Mise a l'echelle des graphes
          for i in xrange(gr_max) :
            gr = 'G'+repr(i)
            self.Send('WITH ' + gr)
            self.Send('VIEW XMIN 0.10')
            self.Send('VIEW XMAX 0.95')
            self.Send('VIEW YMIN 0.10')
            self.Send('VIEW YMAX 0.95')

          # Activation du graphe G0
          self.Active(0)

        else:
          UTMESS('A','STANLEY_3',valk=['XMGRACE'])

    def Ech_x(self, ech_x) :
        """Place l'�chelle sur x � NORMAL, LOGARITHMIC ou RECIPROCAL"""
        if self.Terminal_ouvert() :
            self.Send('WITH G' + repr(self.gr_act))
            # XXX un probleme Xmgrace (� revoir)
            if ech_x == "LOGARITHMIC":
                self.Send('WORLD XMIN 0.1')
            self.Send('XAXES SCALE ' + ech_x)
            self.Send('REDRAW')

    def Ech_y(self, ech_y) :
        """Place l'�chelle sur y � NORMAL, LOGARITHMIC ou RECIPROCAL"""
        if self.Terminal_ouvert() :
            self.Send('WITH G' + repr(self.gr_act))
            # XXX un probleme Xmgrace (� revoir)
            if ech_y == "LOGARITHMIC":
                self.Send('WORLD YMIN 0.1')
            self.Send('YAXES SCALE ' + ech_y)
            self.Send('REDRAW')


class XmgrManager:
    """Garde en r�f�rence les instances de `CalcEssaiXmgr'.
    """

    def __init__(self):
        self.xmgr_nb = 0
        self.xmgr_list = []
        self.echelle_dict = {'LIN' : 'NORMAL',
                             'LOG' : 'LOGARITHMIC'}

    def affiche(self, abscisses, ordonnees, couleur, legende,
                ech_x, ech_y):
        """!Sortie des donn�es sur une courbe XMGrace

        \param abscisse abscisses du graphe
        \param ordonnees tableau de valeurs
        """
        self.xmgr_nb += 1
        xmgr = CalcEssaiXmgr(self.xmgr_nb)
        self.xmgr_list.append(xmgr)

        xmgr.Titre("Courbe", "Sous_titre")
        xmgr.Axe_x("Frequence")
        xmgr.Axe_y("Amplitude")

        for ordo, leg in zip(ordonnees, legende):
            cbr = Courbe(abscisses, ordo)
            xmgr.Courbe(cbr,leg)

        #xmgr.Ech_x(self.echelle_dict[ech_x])
        #xmgr.Ech_y(self.echelle_dict[ech_y])

    def fermer(self):
        """Enl�ve les fichiers temporaires utlis�s
        pour les graphiques et les pipe avec Xmgrace."""
        for xmgr in self.xmgr_list:
            xmgr.Fermer()



#-------------------------------------------------------------------------------

class Compteur:
    cpt=-1  # attribut de classe

    def __init__(self):
        Compteur.cpt = Compteur.cpt +1 # incr�mentation du compteur de classe
        self.cpt = Compteur.cpt  # affectation � l'attribut d'instance

    def __str__(self):
        return "Compteur n %d" %(self.cpt)

#------------------------------------------------------------------------------

class MacMode(Canvas):
    """!Trac� d'une matrice de MAC

    Cet objet accepte un canvas produit par Tk. sa m�thode
    display permet de redessiner une matrice sur ce canvas

    """
    def __init__(self, root, **kwargs):
        """!Constructeur

        \param canvas l'objet canvas Tkinter

         - items la liste des labels
         - mat la matrice des valeurs � repr�senter
        """
        Canvas.__init__(self, root, **kwargs)
        # la liste des labels
        self.items = {}
        # la matrice des valeurs � repr�senter
        self.mat = None

    def show_mat(self, mat):
        """!Change la matrice � afficher"""
        self.mat = mat
        self.refresh_display()

    def refresh_display(self):
        """!Redessine le contenu de la matrice"""
        self.clear()
        mat = self.mat
        try:
            n,m = mat.shape
        except AttributeError:
            return
        width = self.winfo_width()
        height = self.winfo_height()
        xc = width*arange(0., n+1, 1.)/n
        yc = height*arange(0., m+1, 1.)/m
        _min = minimum.reduce
        _max = maximum.reduce
        cmin = _min(mat.ravel())
        cmax = _max(mat.ravel())
        for i in range(n):
            for j in range(m):
                v = int(255*mat[i,j])
                # pour IERI ou mat[i,j] > 1, on met v au taquet
                if v > len(palette)-1:
                    v = len(palette)-1
                col = palette[v]
                rid=self.create_rectangle( xc[i], yc[j], xc[i+1], yc[j+1], fill=col )
                self.items[rid] = (i,j)

    def clear(self):
        """!Efface les �l�ments du canvas (les cases)"""
        for i in self.items:
            self.delete(i)
        self.items = {}

    def resize_ok(self):
        """!Attache l'�v�nement "<Configure>" qui permet d'etre pr�venu d'un redimensionnement
        de la fenetre"""
        self.bind("<Configure>", self.configure )

    def configure(self, event):
        """!Callback appel� lors du redimensionnement

        dans ce cas on recr�e le canvas en prenant en compte les nouvelles
        dimensions
        """
        if self.mat is not None:
            self.refresh_display()




class MacWindowFrame(Frame):
    """!Interface de la fenetre d'affichage des modes MAC

    contient:

     - un titre
     - la matrice de MAC
     - la liste des modes
     - les labels des lignes et colonnes de la matrice
     - un bouton (log) permettant de commuter l'affichage lin�aire et logarithmique

    """
    def __init__(self, root, label,  name1=None, name2=None, size=None ):
        """!Constructeur

        :IVariables:
         - `root`: la fenetre parente
         - `mat`: la matrice des valeurs � afficher
         - `modes1`: liste des modes en Y
         - `modes2`: liste des modes en X
         - `logvar`: variable Tk li�e au bouton radio indiquant la m�thode (log ou pas) d'affichage
         - `mac`: l'objet MacMode
         - `diplayvar1`: variable li�e � un label pour permettre l'affichage des coordonn�es de la valeur sous le curseur
         - `diplayvar2`: variable li�e � un label pour permettre l'affichage de la valeur sous le curseur
        """
        Frame.__init__(self, root)

        # Titre
        titre = Label( self, text=label )
        titre.grid(row=1, column=0, columnspan=4, sticky='n' )

        # Graphique
        if size == None:
            size = (10,100)
        self.mac = MacMode(self, height=size[0], width=size[1] )
        self.mac.grid( row=0, column=0, sticky="news" )
        self.modes1 = None
        self.modes2 = None

        # Label abcisse/ordonn�e

        # Tableau de modes
        tab = Frame( self )
        if not name1: name1 = "BASE 1"
        if not name2: name2 = "BASE 2"
        Label(tab,text="  lignes  ").grid(row=0, column=0, sticky='ew')
        Label(tab,text=" colonnes ").grid(row=0, column=1, sticky='ew')
        Label(tab,text=name1).grid(row=1, column=0)
        Label(tab,text=name2).grid(row=1, column=1)
        self.text_modes1 = Text(tab, width=20,height=size[0])
        self.text_modes1.grid( row=2, column=0,sticky='news' )
        self.text_modes2 = Text(tab, width=20,height=size[0])
        self.text_modes2.grid( row=2, column=1,sticky='news' )
        tab.grid(row=0,column=1,sticky="news")

        self.rowconfigure(0, weight=1)
        self.columnconfigure(0, weight=1)

        # Switch log/lin
        self.logvar = IntVar()
        self.mac.resize_ok()
        self.displayvar1 = StringVar()
        self.displayvar1.set("None")
        self.displayvar2 = StringVar()
        self.displayvar2.set("None")
        Label(self,textvariable=self.displayvar1).grid(row=5,column=0,columnspan=4)
        Label(self,textvariable=self.displayvar2).grid(row=6,column=0,columnspan=4)
        self.mac.bind("<Motion>", self.mode_info )


    def mode_info(self, event):
        """!R�cup�re la valeur MAC de la case sous le curseur"""
        oid = self.mac.find_closest( event.x, event.y )
        if oid:
            i,j = self.mac.items.get(oid[0], (None,None) )
        else:
            return
        if i is None or i<0 or i>=len(self.modes1[0]):
            return
        if j is None or j<0 or j>=len(self.modes2[0]):
            return
        txt1 = self.modes1[1][i]
        txt2 = self.modes2[1][j]
        v = self.mac.mat[i,j]
        self.displayvar1.set("%s / %s" % (txt1,txt2) )
        self.displayvar2.set("%.5g" % (v) )


    def build_modes(self, text, modes):
        """!Construit la liste des modes dans une boite texte"""
        text.configure( width=max( [len(m) for m in modes[1] ] )+1 )
        text.delete( '0.0', 'end' )
        text.insert('end', "\n".join( modes[1] ) )

    def set_modes(self, modes1, modes2, mat ):
        modes1 = (modes1, [self.display_modes(data) for data in modes1])
        modes2 = (modes2, [self.display_modes(data) for data in modes2])
        self.modes1 = modes1
        self.modes2 = modes2
        self.build_modes(self.text_modes1, modes1 )
        self.build_modes(self.text_modes2, modes2 )
        self.mat = mat
        self.mac.show_mat( self.mat )

    def clear_modes(self):
        self.modes1 = ( [], [] )
        self.modes2 = ( [], [] )
        self.text_modes1.delete( '0.0', 'end' )
        self.text_modes2.delete( '0.0', 'end' )
        self.mac.clear()

    def display_modes(self,mode_data):
        if isinstance(mode_data,str):
            return mode_data
        elif isinstance(mode_data,float):
            return "%8.2f Hz" % mode_data
        if mode_data is None:
            return "None"


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


