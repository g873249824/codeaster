#@ MODIF meidee_fludela Meidee  DATE 21/10/2008   AUTEUR NISTOR I.NISTOR 
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


__docformat__ = "restructuredtext fr"


import sys
import string
from Utilitai.Utmess import UTMESS

from Cata.cata import MAC_MODES
import aster
import Numeric
from Numeric import zeros, size, Float, pi, sqrt, array
from Meidee.meidee_calcul_correlation import extract_mac_array
from Tkinter import Frame, Menubutton, Menu, StringVar, IntVar, Listbox
from Tkinter import Scrollbar, Label, Radiobutton, Button, Entry
from Tkinter import Checkbutton, DoubleVar
from Tkinter import Toplevel
from Meidee.meidee_iface import MyMenu, LabelArray, MenuArray, EntryArray, ModeList
from Meidee.meidee_iface import VLabelledItem, HLabelledItem, MacWindow, XmgrManager, PlotXMGrace
from Meidee.meidee_calcul_fludela import MeideeFludela, MeideeTurbMonomod
from Meidee.modes import OptionFrame
from Meidee.meidee_cata import Resultat, InterSpectre
from Meidee.meidee_cata import MeideeObjects, CreaTable


######################
#                    #
# CLASSES GRAPHIQUES #
#                    #
######################

## param�tres par d�faut pour la cr�ation des Frame qui servent de cadre
DEFAULT_FRAME_ARGS = {
    "relief" : 'ridge',
    "borderwidth" : 4,
    }
    

#-----------------------------------------------------------------------------

class InterfaceLongeq(Frame):
    """!Interface de param�trage du calcul de la longueur �quivalente

    """
    def __init__(self, parent, objects, fludela, mess ):
        """!Constructeur

        Construit l'interface de selection et calcul des longueurs �quivalentes

        \param parent La Frame parente
        \param objects Une instance de MeideeObjects
        \param fludela Une instance de MeideeFludela
        
        """
        Frame.__init__(self, parent, **DEFAULT_FRAME_ARGS)
        self.parent = parent
        self.objects = objects
##        assert isinstance( parent, InterfaceFludela)
        # Menu choix du resultat numerique
        Label(self, text="Choisissez un resultat pour le calcul" \
              " de la longeur equivalente ").grid(row=0, column=0, columnspan=3)

        Label(self, text="Resultat").grid(row=1,column=0)
        self.modes_num = StringVar()
        self.menu_modes = MyMenu( self,
                                  objects.get_resultats_num(),
                                  self.modes_num,
                                  self.change_mode )
        self.menu_modes.grid(row=2, column=0)


        Label(self, text="Cara Elem").grid(row=1, column=1)
        self.cara_num = StringVar()
        self.menu_cara = MyMenu( self,
                                 objects.get_cara_elem(),
                                 self.cara_num,
                                 self.compute_leq )

        self.menu_cara.grid(row=2, column=1)

        Label(self, text="Champ Materiau").grid(row=1, column=2)
        self.cham_num = StringVar()
        self.menu_cham = MyMenu( self,
                                 objects.get_cham_mater(),
                                 self.cham_num,
                                 self.compute_leq )

        self.menu_cham.grid(row=2, column=2)


        self.long_eq_array = ModeList( self, 'Longeur equivalente' )
        self.long_eq_array.grid(row=3,column=0)
        self.long_eq_values = zeros( (1,1), )
        self.fludela = fludela
        self.fludela.register_longeq( self.notify )
        self.mess = mess

    def refresh(self):
##        self.objects.recup_objects()

        results_num = self.objects.get_resultats_num()
        old_result = self.modes_num.get()
        self.menu_modes.update( results_num, self.modes_num, self.change_mode )
        self.modes_num.set(old_result)

        self.change_mode()


    def change_mode(self):
        mode = self.modes_num.get()
        if mode=="Choisir":
            mode = None
        # Selection des cara_elem
        cara_elems = self.objects.get_cara_elem(mode)
        old_cara = self.cara_num.get()
        #self.menu_cara.update( cara_elems, self.cara_num, self.compute_leq )
        if old_cara in cara_elems:
            self.cara_num.set(old_cara)
        elif len(cara_elems)==1:
            self.cara_num.set(cara_elems[0])
        else:
            self.cara_num.set("Choisir")


        # Selection des cham_mater
        cham_maters = self.objects.get_cham_mater(mode)
        old_cara = self.cham_num.get()
        self.menu_cham.update( cham_maters, self.cham_num, self.compute_leq )
        if old_cara in cham_maters:
            self.cham_num.set(old_cara)
        elif len(cham_maters)==1:
            self.cham_num.set(cham_maters[0])
        else:
            self.cham_num.set("Choisir")

        self.compute_leq()

    def compute_leq(self):
        """!Si possible calcule la longueur equivalente"""
        try:
            self.resu = self.objects.get_resu( self.modes_num.get() )
        except KeyError:
            return
        self.mess.disp_mess( (  " Calcul de la longueur �quivalente" ) )
        self.mess.disp_mess( (  self.resu.modele_name ) )
        self.mess.disp_mess( (  self.resu.nom ) )
        self.mess.disp_mess( ( "  " ) ) 

        self.fludela.set_res_longeq( self.resu )
        self.fludela.compute()

    def notify(self):
        leq = self.fludela.long_eq
        nume_modes = self.resu.get_modes()[3]
        self.long_eq_array.fill_modes( leq, nume_modes, format = '%13.5E' )


#-----------------------------------------------------------------------------


class InterfaceDisplayModes(Frame):
    """!Interface affichant le tableau de s�lection des modes pour Massamor

    On pr�sente un tableau contenant un nombre de lignes correspondant aux
    modes sur lesquels effectuer les calculs. Les trois premi�res colonnes
    sont �ditables et permettent de choisir les num�ros des modes qui sont
    en correspondance pour les �tudes en air, en eau et en �coulement.

    Les colonnes suivantes permettent d'afficher certains des r�sultats de
    calcul et l'entete de chaque colonne permet de pr�ciser quel est le
    r�sultat � afficher
    """
    def __init__(self, parent, objects, fludela, mess, rows = 8, cols = 5 ):
        """!Constructeur

        \param parent La frame Tkinter.Frame parente
        \param objects Une instance de MeideeObjects permettant d'acc�der
               � la liste des objets Aster disponibles
        \param fludela Une instance de la classe MeideeFludela

        L'attribut fields fournit une correspondance entre la liste
        des choix possibles comme entete de colonne (la clef sert de
        label) et la source de donn�e.

        La source de donn�es est d�crite comme un tuple (nom de champ, index)
        o� l'index d�signe si le num�ro du mode est relatif ou absolu (si le
        mode d�signe un mode extrait ou un mode d'origine)
        """
        Frame.__init__(self, parent)
        self.mess = mess
        self.objects=objects
        self.rows = rows
        self.cols = cols
        self.fields =  { "      F 1      " : ('freq_eq_a',0),
                         "      F 2      " : ('freq_eq_e',0),
                         "      F 3      " : ('freq_eq_v',0),
                         "      M 1      " : ('mass_a', 1),
                         "      M 2      " : ('mass_e', 2),
                         "      M 3      " : ('mass_v', 3),
                         "     Xsi 1     ":  ("xsi_a",1),
                         "     Xsi 2     " : ("xsi_e",2),
                         "     Xsi 3     " : ("xsi_v",3),
                         "Ma rep dim  mod" : ('mass_ajou_dim_mod',0),
                         "Ma rep dim  lin" : ('mass_ajou_dim_lin',0),
                         "Ma rep adim lin" : ('mass_ajou_adim_lin',0),
                         "Ca rep dim  mod"  : ('amor_ajou_rep_dim_mod',0),
                         "Ca rep dim  lin"  : ('amor_ajou_rep_dim_lin',0),
                         "Ca vit dim  mod"  : ('amor_ajou_vit_dim_mod',0),
                         "Ca vit dim  lin"  : ('amor_ajou_vit_dim_lin',0),
                         "Ca vit adim lin" : ('amor_ajou_vit_adim_lin',0),
                         "   Xsia rep    " : ('xsi_rep_ajou',0),
                         "   Xsia vit    " : ('xsi_vit_ajou',0),
                         "Ka vit dim  mod"  : ('raid_ajou_dim_mod',0),
                         "Ka vit dim  lin"  : ('raid_ajou_dim_lin',0),
                         "Ka vit adim lin"  : ('raid_ajou_adim_lin',0),
                         "      K 1      " : ("raid_a",1),
                         "      K 2      " : ("raid_e",2),
                         "      K 3      " : ("raid_v",3),
                         " Mint dim mod  " : ("xmi",1),
                         }

        
        frame = Frame(self)
        frame.grid( row=1, column=0, columnspan=4 )
        self.modes_array = EntryArray(self, 2, 0, self.rows, 3, cb=self.update, width=[6,8,8] )
        self.value_array = LabelArray(self, 2, 3, self.rows, self.cols )
        options = self.fields.keys()
        options.sort()
        self.menu_array = MenuArray(self, 1, 3, 1, self.cols, options, cb=self.notify )
        Label(self,text="Air (1)").grid(row=1,column=0)
        Label(self,text="Eau (2)").grid(row=1,column=1)
        Label(self,text="Ecoul (3)").grid(row=1,column=2)
        for n in range(self.rows):
            self.modes_array.set( n, 0, 0)
            self.modes_array.set( n, 1, 0)
            self.modes_array.set( n, 2, 0)
        k = self.fields.keys()
        k.sort()
        for col in range(min(self.cols,len(k))):
            self.menu_array.set(0,col,k[col])
        self.fludela = fludela
        self.fludela.register_massam( self.notify )
        self.update()
        

    def update_ind_mod(self, res_air, res_eau, res_vit):
        self.ind_air = self.ind_eau = self.ind_vit = [0]*self.rows
        try:
            self.ind_air = res_air.get_modes()[3][:,1]
            self.ind_eau = res_eau.get_modes()[3][:,1]
            self.ind_vit = res_vit.get_modes()[3][:,1]
        except AttributeError:
            pass
        for n in range(self.rows):
            try:
                self.modes_array.set( n, 0, int(self.ind_air[n]))
                self.modes_array.set( n, 1, int(self.ind_eau[n]))
                self.modes_array.set( n, 2, int(self.ind_vit[n]))
            except IndexError:
                #cas ou il y a plus de lignes que de modes
                pass

    def add_line(self):
        """!Ajoute une ligne au tableau des r�sultats"""
        state = self.save_state()
        self.rows += 1
        self.reinit( state )

    def rem_line(self):
        """!Supprime une ligne du tableau des r�sultats"""
        state = self.save_state()
        self.rows -= 1
        self.reinit( state )

    def save_state(self):
        """!Sauvegarde l'�tat du tableau"""
        pass

    def reinit(self, state):
        """R�initialise le tableau en essayant de restaurer l'�tat"""
        self.update()

    def update(self, event=None):
        """!Notifie l'objet massamor des changements de modes"""
        modes = []
        for i, (m1, m2, m3) in enumerate(self.modes_array.rows_value()):
            # on recupere les numero de mode (1 ou plusieurs)
            err = False
            try:
                m1 = [ int(m) for m in m1.split(",") ]
            except ValueError:
                self.show_err( i,0 )
                err = True
            try:
                m2 = [ int(m) for m in m2.split(",") ]
            except ValueError:
                self.show_err( i,1 )
                err = True
            try:
                m3 = [ int(m) for m in m3.split(",") ]
            except ValueError:
                self.show_err( i,2 )
                err = True
            if err:
                continue
            self.show_ok( i )
            # pour l'instant un seul mode
            modes.append( (m1, m2, m3) )

        return modes

    def notify( self, event=None ):
        """!Callback de notification

        est appel� par CalcFludela lorsque le calcul a �t� effectu�
        """
        self.mess.disp_mess( (  "NOTIFY" ) ) 
        modes = self.fludela.pairs
        self.mess.disp_mess( (  'modes = ' + str(modes) ) )
        data = self.fludela.calc
        self.mess.disp_mess( ( 'data = ' + str(data) ) ) 
        for i,(m1,m2,m3) in enumerate(modes):
            P = (i,m1,m2,m3)
            # TODO probablement un recalc de massamor pour obtenir les
            # resu pour la frequence equivalente
            for c in range(self.cols):
                choice = self.menu_array.get(0,c)
                field, p = self.fields[choice]
                data_field = data[field]
                if p == 0:
                    value1 = data_field[P[p]]
                else:
                    modes = P[p]
                    res = []
                    for m in modes:
                        res.append( str(data_field[m]) )
                    value1 = ",".join( res )
                self.value_array.set( P[0], c, value1 )

    def show_err( self, i, k ):
        """!Indique une erreur de saisie dans la cellule"""
        t1, w1 = self.modes_array.getw( i, k )
        w1['background']='red'


    def show_ok( self, i ):
        """!Indique que les choix d'une ligne sont valides"""
        for k in range(3):
            t1, w1 = self.modes_array.getw( i, k )
            w1['background']='green'


#-----------------------------------------------------------------------------

class InterfaceChoixModes(Frame):
    """!Panneau de s�lection des modes et des �coulements"""
    def __init__(self, parent, objects, paramphy, longeq, fimens, mess, fludela ):
        """!Constructeur

          - \param parent: La Frame parente
          - \param objects: Le repository d'objets aster
          - \param paramphy: Interface des param�tres physiques
          - \param longeq: Interface pour le calcul de la longueur �quivalente
          - \param fimens: Fichiers fimen � utiliser
          - \param fludela: instance de MeideeFludela

        :type objects: MeideeObjects
        :type paramphy: InterfaceParamPhys
        :type longeq: InterfaceLongeq
        :type fludela: MeideeFludela
        :type fimens: ( fd, nom de fichier )
        """
        Frame.__init__(self, parent, **DEFAULT_FRAME_ARGS)
        self.mess = mess
        Label(self, text="Choix des �coulements").grid(columnspan=3, sticky='n')
        self.objects = objects
        self.longeq_obj = longeq
        self.paramphy_obj = paramphy
        self.fludela = fludela
        self.parent = parent
        self.mess = mess

        # Choix des �coulements

        self.modes_air = StringVar()
        itm = HLabelledItem( self, "Air                            :",
                             MyMenu,
                             objects.get_resultats_num(),
                             self.modes_air,
                             cmd = self.update
                             )
        self.menu_air = itm.itm
        itm.grid(row=1,column=1,sticky='w')


        self.modes_eau = StringVar()
        itm = HLabelledItem( self, "Eau                           :",
                             MyMenu,
                             objects.get_resultats_num(),
                             self.modes_eau,
                             self.update
                             )
        self.menu_eau = itm.itm
        itm.grid(row=2,column=1,sticky='w')



        self.modes_vit = StringVar()
        itm = HLabelledItem( self, "Ecoulement               :",
                             MyMenu,
                             objects.get_resultats_num(),
                             self.modes_vit,
                             cmd = self.update2
                             )
        self.menu_vit = itm.itm
        itm.grid(row=3,column=1,sticky='w')

        self.vitesse = StringVar()
        itm = HLabelledItem( self, "Vitesse                :",
                             Entry,
                             textvariable=self.vitesse )
        self.vitesse_entry = itm.itm
        itm.itm.bind("<Return>", self.change_vitesse )
        itm.grid(row=3, column=2,sticky='w' )

        # Choix des fichiers FIMEN
        self.fimens = {}
        for u,m in fimens:
            self.fimens[m] = u
        self.fimen_name = StringVar()
        self.menu_fimen = MyMenu( self, self.fimens.keys(),
                                  self.fimen_name )
        self.fimen_name.set("Fichier FIMEN")
        self.menu_fimen.grid(row=2, column=2,sticky='w')

        self.methode = StringVar()
        itm = HLabelledItem(self, "Methode multimodale :",
                      MyMenu,
                      fludela.methodes_globales, self.methode, self.update )
        itm.grid(row=4,column=1,sticky='w')
        Button(self, text="Calculer !", command=self.calcul ).grid(row=5, column=1,sticky='w')

        # Tableau de donn�es
        plusmoins1 = Frame(self)
        Button(plusmoins1, text="+", command=self.add_row ).grid(row=0, column=0)
        Button(plusmoins1, text="-", command=self.rem_row ).grid(row=1, column=0)
        plusmoins1.grid(row=8,column=0)
        plusmoins2 = Frame(self)
        Button(plusmoins2, text="+", command=self.add_col ).grid(row=0, column=0)
        Button(plusmoins2, text="-", command=self.rem_col ).grid(row=0, column=1)
        plusmoins2.grid(row=7,column=1, columnspan = 3)
        
        self.multi = InterfaceDisplayModes( self, self.objects, fludela, mess )
        self.multi.grid(row=8,column=1,columnspan=3)
        self.rowconfigure(8,weight=1)
        
        mac_frame = Frame(self)
        mac_frame.grid( row=6, column=0, columnspan=3)
        
        Button(mac_frame, text="Mac Air-Eau", command=self.show_mac_air_eau ).grid(row=0, column=1)
        Button(mac_frame, text="Mac Eau-Ecoulement", command=self.show_mac_eau_ecoul ).grid(row=0, column=2)
        Button(mac_frame, text="Mac Air-Ecoulement", command=self.show_mac_air_ecoul ).grid(row=0, column=3)
        Button(self, text="Sauver", command=self.save_calc ).grid(row=9, column=0)
        Button(self, text="Exporter ", command=self.impr_resu ).grid(row=9, column=1)
        self.export_name = StringVar()
        Entry(self, textvariable=self.export_name).grid(row=9, column=2)


    def add_row(self):
        self.change_interface_display_modes(1,0)
        
    def add_col(self):
        self.change_interface_display_modes(0,1)

    def rem_row(self):
        self.change_interface_display_modes(-1,0)

    def rem_col(self):
        self.change_interface_display_modes(0,-1)

    def change_interface_display_modes(self,r,c):
        nb_rows = self.multi.rows + r
        nb_cols =self.multi.cols + c
        self.multi.grid_remove()
        self.multi = InterfaceDisplayModes( self, self.objects, self.fludela,
                                            self.mess, rows=nb_rows, cols=nb_cols )
        self.multi.grid(row=8,column=1,columnspan=3)
        self.update()

        
        pass

    def refresh(self):
##        self.objects.recup_objects()
        results_num = self.objects.get_resultats_num()
        self.menu_air.update( results_num, self.modes_air, self.update )
        self.menu_eau.update( results_num, self.modes_eau,  self.update)
        self.menu_vit.update( results_num, self.modes_vit, self.update2 )
        

    def mode_valid( self, mode_ ):
        """!D�termine si un objet r�sultat s�lectionn� est valide."""
        try:
            obj = self.objects.get_resu( mode_ )
        except KeyError:
            return False
        return True
    

    def update(self):
        """! Affiche les nume_ordr des mode dans le tableau � trois
             colonnes de l'interface InterfaceDisplayModes dans
             laquelle on affiche les r�sultats (en envoyant update_ind_mod)
        """
        res_air = res_eau = res_vit = None
        try:
            res_air = self.objects.get_resu( self.modes_air.get() )
            res_eau = self.objects.get_resu( self.modes_eau.get() )
            res_vit = self.objects.get_resu( self.modes_vit.get() )
        except KeyError:
            pass
        self.multi.update_ind_mod(res_air, res_eau, res_vit)
        self.multi.update()


    def update2(self):
        self.update()
        self.update_vit()

    def calcul(self):
        """!Relance les calculs en cas de changement de param�trage"""
        res_vit = res_air = res_eau = None
        if self.mode_valid( self.modes_air.get() ):
            res_air = self.objects.get_resu( self.modes_air.get() )
        if self.mode_valid( self.modes_eau.get() ):
            res_eau = self.objects.get_resu( self.modes_eau.get() )
        if self.mode_valid( self.modes_vit.get() ):
            res_vit = self.objects.get_resu( self.modes_vit.get() )
            
        liste_para = [list.get() for list in self.paramphy_obj.param_phys]
        self.fludela.set_param_phy( rho_int = liste_para[0],
                                    rho_ext = liste_para[1],
                                    diam_int = liste_para[2],
                                    diam_ext = liste_para[3])
        
        self.fludela.set_results( res_air, res_eau, res_vit )
        modes = self.multi.update()              # Update des "accouplements de modes"
        self.fludela.set_modes_pairs( modes )
        if self.fimen_name.get() != 'Fichier FIMEN':
            self.fludela.set_fimen(self.fimen_name.get())
        self.fludela.prep_massamor()
        self.fludela.methode_globale = self.methode.get()
        self.fludela.compute()

        
    def update_vit(self):
        """!Change la couleur de la vitesse pour que l'utilisateur
        pense � la re-pr�ciser si n�cessaire"""
        self.refresh()
        self.vitesse_entry["background"] = "red"


    def show_mac_air_eau(self):
        """!Affichage de la matrice MAC air - eau"""
        mode1 = self.modes_air.get()
        mode2 = self.modes_eau.get()
        titre = "MAC AIR - EAU"
        self.show_mac( titre, mode1, mode2 )

    def show_mac_eau_ecoul(self):
        """!Affichage de la matrice MAC eau - �coulement"""
        mode1 = self.modes_eau.get()
        mode2 = self.modes_vit.get()
        titre = "MAC EAU - ECOULEMENT"
        self.show_mac( titre, mode1, mode2 )

    def show_mac_air_ecoul(self):
        """!Affichage de la matrice MAC air - �coulement"""
        mode1 = self.modes_air.get()
        mode2 = self.modes_vit.get()
        titre = "MAC AIR - ECOULEMENT"
        self.show_mac( titre, mode1, mode2 )
    
    def show_mac(self, titre, mode1, mode2 ):
        """!Affichage d'une matrice de MAC

        utilis�e par show_mac_air_eau, show_mac_eau_ecoul, show_mac_air_ecoul
        pour afficher la fenetre d'affichage de la matrice de MAC

        \param titre le titre de la fenetre
        \param mode1 le nom de l'objet mode_meca pour la base 1
        \param mode2 le nom de l'objet mode_meca pour la base 2
        """
        print "modes1-2 = ", mode1, mode2
        if ( not self.mode_valid( mode1 ) or
             not self.mode_valid( mode2 ) ):
            return
        res_1 = self.objects.get_resu( mode1 )
        res_2 = self.objects.get_resu( mode2 )
        try:
            __MAC = MAC_MODES( BASE_1=res_1.obj,
                               BASE_2=res_2.obj )
        except aster.FatalError:
            self.mess.disp_mess("!! Calcul de MAC impossible : bases incompatibles !!")
            UTMESS('A','MEIDEE0_3')
            return
        nom_table = 'MAC'
        mat = extract_mac_array( __MAC,nom_table)
        mac_win = MacWindow( self, titre, mode1, mode2, mat, resu1=res_1, resu2=res_2 )

    def save_calc(self):
        """!Sauvegarde un r�sultat de calcul dans un fichier
            Important : on ne sauve que les param�tres affich�s dans l'IHM.
        """        
        name = self.vitesse.get()
        self.mess.disp_mess('name = ' + str(name))
        data_tmp = self.fludela.save_data()
        data = {}
        for col in range(self.multi.cols):
            key = self.multi.menu_array.get(0,col)
            obj = self.multi.fields[key][0]
            data[key] = data_tmp[obj]
        self.mess.disp_mess("Ecriture dans le fichier resultat")
        self.mess.disp_mess("des donn�es affich�es dans l'IHM")
        self.mess.disp_mess(" ")
        self.fludela.saved_data[name] = data
        self.fludela.save_to_file(name, data)

    def impr_resu(self):
        """!Impression dans une table aster de tous les r�sultats
            obtenus avec les diff�rents calculs"""
        data_fin = self.fludela.saved_data
        nom = self.export_name.get()
        if len(nom) > 8:
            self.mess.disp_mess("!! Nom de concept d�fini trop long !!")
            self.mess.disp_mess("  ")
        self.fludela.save_to_table(data_fin, nom)
        

    def change_vitesse(self, event):
        """!Callback appel� lors d'un changement du param�tre vitesse"""
        try:
            vit = float(self.vitesse.get())
        except ValueError:
            self.mess.disp_mess( (  "Vitesse invalide" ) )
            self.mess.disp_mess( ( " " ) ) 
            self.vitesse_entry['background'] = "red"
            return
        except TypeError:
            self.mess.disp_mess( (  "Rentrer une vitesse d'�coulement" ) )
            self.mess.disp_mess( ( " " ) )
            return
        self.vitesse_entry['background'] = "green"
        self.fludela.set_speed( vit )
    
    def destroy_mac_window( self, win ):
        # inutile ?
        pass


#------------------------------------------------------------------------------

class InterfaceParamPhys(Frame):
    """!Interface de lecture des param�tres physiques"""
    
    def __init__(self, parent, fludela, turbmonomod, mess):
        """!Constructeur
        \param parent l'objet parent d�rivant de Tkinter.Frame
        \param fludela une instance de MeideeFludela
        """
        Frame.__init__(self, parent, **DEFAULT_FRAME_ARGS)
        Label(self, text="Parametre physiques").grid(columnspan=2)
        self.mess = mess
        self.diam_ext = DoubleVar()
        self.diam_int = DoubleVar()
        self.diam_ext.set(fludela.diam_ext)
        self.diam_int.set(fludela.diam_int)        
        self.rho_flu_int = DoubleVar()
        self.rho_flu_ext = DoubleVar()
        self.rho_flu_int.set(fludela.rho_flu_int)
        self.rho_flu_ext.set(fludela.rho_flu_ext)
        e0 = VLabelledItem( self, "Diametre ext. du tube",
                            Entry,
                            textvariable=self.diam_ext )
        e0.grid( row=1, column=0 )
        e1 = VLabelledItem( self, "Diametre int. du tube",
                            Entry,
                            textvariable=self.diam_int )
        e1.grid( row=1, column=1 )
        e2 = VLabelledItem( self, "Masse vol fluide interne",
                            Entry,
                            textvariable=self.rho_flu_int )
        e2.grid( row=1, column=2 )

        e3 = VLabelledItem( self, "Masse vol fluide externe",
                            Entry,
                            textvariable=self.rho_flu_ext )
        e3.grid( row=1, column=3 )
        self.param_phys = (self.rho_flu_int,self.rho_flu_ext,self.diam_int,self.diam_ext)
        
        self.fludela = fludela


    def update(self, event):
        """!Callback appel� lors du changement d'un des param�tres physiques

        on notifie l'objet fludela du changement et on relance le calcul
        """
        self.mess.disp_mess( ( "Update, relancement du calcul " ) ) 
        rho_int = self.rho_flu_int.get()
        rho_ext = self.rho_flu_ext.get()
        if rho_ext == 0:
            self.mess.disp_mess("!! Calcul impossible : la masse volumique !!")
            self.mess.disp_mess("!!     doit etre diff�rente de zero       !!")
        diam = self.diam_ext.get()
        if diam == 0:
            self.mess.disp_mess("!! Calcul impossible : la le diam�tre ext !!")
            self.mess.disp_mess("!!     doit etre diff�rent de zero        !!")
        liste_para = [list.get() for list in self.param_phys]
        self.fludela.set_param_phy( rho_int = liste_para[0],
                                    rho_ext = liste_para[1],
                                    diam_int = liste_para[2],
                                    diam_ext = liste_para[3])
        self.fludela.compute()


#-------------------------------------------------------------------------------

class InterfaceFludela(Frame):
    """!Classe qui cr�e les diff�rents panneaux d'interface du tab fludela"""
    
    def __init__(self, parent, aster_objects, fimens, mess, out, param_visu ):
        """!Constructeur

        :IVariable:
         - `parent`: fenetre parente
         - `aster_objects`: concepts aster dans jeveux
         - `fimens`: UL des fichiers fimen2x
         - `mess` : fenetre message
         - `obj_out`: concepts aster "table_sdaster" dans lesquelles on va ranger
            les r�sultats que l'utilisateur voudra sauver
         - `declout`: la fonction self.DeclareOut
        """

        Frame.__init__(self, parent, **DEFAULT_FRAME_ARGS )
        self.mess = mess
        self.objects = aster_objects
##        self.objects.recup_objects()
        self.param_visu = param_visu
        self.columnconfigure(0, weight=1)
        self.rowconfigure(3, weight=1)
        self.mess.disp_mess( (  "FIC fimens:" + str(fimens) ) ) 
        self.fimens = fimens

        self.fludela = MeideeFludela(mess, out)
        self.turbmonomod = MeideeTurbMonomod(aster_objects,mess,out)

        Label(self, text="MeideeFludela - Fludela").grid(row=0, column=0, sticky='n')
        self.longeq = InterfaceLongeq(self, aster_objects, self.fludela, mess)
        self.param_phys = InterfaceParamPhys(self, self.fludela, self.turbmonomod, mess )
        self.choix_modes = InterfaceChoixModes(self, aster_objects, self.param_phys,
                                               self.longeq, fimens, mess, self.fludela )

        self.longeq.grid( row=1, column=0, sticky='n'+'e'+'w'+'s' )
        self.param_phys.grid( row=2, column=0, sticky='n'+'e'+'w'+'s' )
        self.choix_modes.grid( row=4, column=0, sticky='n'+'e'+'w'+'s' )

        ##self.saved_data = {}


    def setup(self):
##        self.objects.recup_objects()
        self.longeq.refresh()
        self.choix_modes.refresh()
        
    def teardown(self):
        # XXX : sauvegarde des donnees
        pass


#-------------------------------------------------------------------------------

class InterfaceDisplay(Frame):
    """!Classe (Tab) d'affichage des r�sultats de calcul
    sous forme de trac� de courbes
    """

    def __init__(self, parent, fludela, mess):
        """!Constructeur

        \param parent Frame parente
        \param fludela interface fludela (InterfaceFludela)

        """
        Frame.__init__(self, parent,  **DEFAULT_FRAME_ARGS)
        self.mess = mess
        self.parent = parent
        self.fludela = fludela
        ##self.resultat = fludela.saved_data

        Label(self, text="Visualisation").grid(row=0, column=0, columnspan=3, sticky='n')

        self.plot = PlotCanvas( self, "300", "300", relief=SUNKEN, border=2,
                                zoom = 1, select = self.display)
        self.plot.grid(row=1, column=0)
        self.curves = {}
        curveframe = Frame(self)
        curveframe.grid(row=1, column=1)
        
        self.scroll = Scrollbar( curveframe, orient=VERTICAL )
        Label(curveframe, text="Trac�s").grid(row=0, column=0, columnspan=2)
        self.curvelist = Listbox( curveframe,
                                  yscrollcommand=self.scroll.set,
                                  exportselection=False )
        self.curvelist.grid(row=1, column=0)
        self.scroll.grid(row=1, column=1)


        # Ajout d'un trac�
        editframe = Frame(self)
        editframe.grid(row=2, column=0)
        options = []
        self.field = StringVar()
        self.fieldchoice = MyMenu( editframe,
                                   options,
                                   self.field,
                                  )
        self.fieldchoice.grid(row=0, column=0)
        self.curvename = StringVar()
        self.modenum = StringVar()
        HLabelledItem( editframe, "Nom :", Entry, textvariable=self.curvename ).grid(row=0,column=1)
        HLabelledItem( editframe, "Mode :", Entry, textvariable=self.modenum ).grid(row=1,column=1)
        Button(editframe, text="Ajouter", command=self.add_curve ).grid(row=2, column=1)

    def refresh(self):
        """!Raffraichit l'interface lorsqu'on affiche le panneau"""
        self.mess.disp_mess( (  "InterfaceDisplay:refresh" +
                                str(self.fludela.saved_data) ) ) 
        self.resultat = self.fludela.saved_data
        k = self.resultat.keys()
        if k:
            data = self.resultat[k[0]]
            self.fieldchoice.update( data.keys(), self.field )
        self.curvelist.delete(0,END)
        for c in self.curves:
            self.curvelist.insert(END, c )

    def setup(self):
        self.refresh()

    def teardown(self):
        pass

    def read_results(self):
        """!Lecture du fichier contenant les r�sultats"""
        pass

    def draw(self):
        return
        self.mess.disp_mess( ( "Drawing..." ) ) 
        try:
            self.plot.clear()
            for curve in self.curves:
                self.plot.draw( curve.get_curve(), 'automatic', 'automatic' )

        except Exception, e:
            import traceback
            import sys
            traceback.print_exc(file=sys.stdout)
            self.mess.disp_mess( (  "Erreur dans draw (methode de InterfaceDisplay)" ) ) 

    def display(self, value):
        self.plot.select( value )

    def add_curve( self ):
        name = self.curvename.get()
        mode = int(self.modenum.get())
        field = self.field.get()
        if not name:
            name = "%s - %d" % (field,mode)
        self.curves[name] = Curve( name, self.resultat, field, mode )
        self.curvename.set("")
        self.refresh()


#-------------------------------------------------------------------------------

class InterfaceTurbMonomod(Frame):
    """!Classe qui cr�e les diff�rents panneaux d'interface du tab fludela"""
    
    def __init__(self, parent, aster_objects, fimens, mess, out ,param_visu ):
        """!Constructeur

        :IVariable:
         - `parent`: fenetre parente
         - `aster_objects`: concepts aster dans jeveux
         - `fimens`: UL des fichiers fimen2x
         - `mess` : fenetre message
         - `obj_out`: concepts aster "table_sdaster" dans lesquelles on va ranger
            les r�sultats que l'utilisateur voudra sauver
         - `declout`: la fonction self.DeclareOut
        """

        Frame.__init__(self, parent, **DEFAULT_FRAME_ARGS )
        self.mess = mess
        self.objects = aster_objects
        self.fimens = fimens
        self.param_visu = param_visu
        
##        self.objects.recup_objects()
        self.columnconfigure(0, weight=1)
        self.rowconfigure(4, weight=1)

        # appel des classes de meidee_calcul_fludela.py
        self.fludela = MeideeFludela(mess,out)
        self.turbmonomod = MeideeTurbMonomod(aster_objects,mess,out)

        Label(self, text="MeideeFludela - Fludela").grid(row=0, column=0, sticky='n')
        self.donnees = InterfaceDonnees(self, aster_objects, self.turbmonomod, mess)
        self.param_phys = InterfaceParamPhys(self, self.fludela, self.turbmonomod, mess )
        self.select_mesures = InterfaceSelectMesures(self,aster_objects,self.turbmonomod,fimens, mess)
        self.longeq_turb = InterfaceLongeqTurb(self,aster_objects,self.turbmonomod,self.fludela,self.donnees,self.select_mesures,mess)

        self.donnees.grid( row=1, column=0, sticky='n'+'e'+'w'+'s' )
        self.param_phys.grid( row=2, column=0, sticky='n'+'e'+'w'+'s' )
        self.select_mesures.grid(row=3, column=0, sticky='n'+'e'+'w'+'s' )
        self.longeq_turb.grid( row=4, column=0, sticky='n'+'e'+'w'+'s' )


    def setup(self):
####        self.objects.recup_objects()
        self.longeq_turb.refresh()
        self.donnees.refresh()
        self.select_mesures.refresh()
        
    def teardown(self):
        # XXX : sauvegarde des donnees
        pass


#-------------------------------------------------------------------------------

class InterfaceDonnees(Frame):
    """!Interface de param�trage du calcul de la longueur �quivalente, 
        (resultat, fonction de corr�lation, modes retenus) pour la m�thode 
        turbulente mono-modale     

    """
    def __init__(self, parent, objects, turbmonomod, mess ):
        """!Constructeur

        Construit l'interface de selection et calcul des longueurs �quivalentes,
        et des fonctions de corr�lation

        \param parent La Frame parente
        \param objects Une instance de MeideeObjects
        \param turbmonomod Une instance de MeideeTurbMonomod
        
        """
        Frame.__init__(self, parent, **DEFAULT_FRAME_ARGS)
        self.parent = parent
        self.objects = objects
        self.turbmonomod = turbmonomod
        self.mess = mess

#       Param�tres de calcul
        self.ld = DoubleVar()
        self.lambdac = DoubleVar()
        self.gammac = IntVar()

        
#       Num�ro des modes retenus dans le sd_resultat
        self.liste_modes_deconv=[]
        self.liste_modes_EML=[]
        
        
##        assert isinstance( parent, InterfaceFludela)
        # Menu choix du resultat numerique
        Label(self, text="Choisissez un RESULTAT et une fonction de corr�lation" \
              " pour le calcul de la longeur de corr�lation g�n�ralis�e ").grid(
                  row=0, column=0, columnspan=5)

        Label(self, text="R�sultat").grid(row=1,column=1)
        self.modes_name = StringVar()
        self.menu_modes = MyMenu( self,
                                  objects.get_resultats_num(),
                                  self.modes_name,
                                  self.update 
                                 )
        self.menu_modes.grid(row=2, column=1)
        
             

        Label(self, text="Fonction de corr�lation").grid(row=1, column=2)
        self.var_fonc_correl = StringVar()
        self.menu_correl = MyMenu( self,
                                   ['MODELE GAMMA','CORCOS'],
                                   self.var_fonc_correl,
                                   self.choix_modele_correl )

        self.menu_correl.grid(row=2, column=2)

        Label(self, text="Param�tres suppl�mentaires").grid(row=2, column=3)
        
        self.var_fcorrel_param_frame_visible = IntVar()
        Checkbutton (self, text="D�finition",
                     command=self.display_fcorrel_param_frame,
                     variable=self.var_fcorrel_param_frame_visible,
                     indicatoron=0).grid(row=3,column=3)    
        
        self.fcorrel_param_frame = frm1 = Toplevel()
        frm1.rowconfigure(0,weight=1)
        frm1.columnconfigure(0,weight=1)
        
        self.param_gamma = ParamModeleGamma(frm1, "Param�tres du mod�le Gamma")
        self.param_gamma.grid(row=0,column=0,sticky='nsew')
        
        Liste_ParamGamma = self.param_gamma.update_param()
        
        self.ld = Liste_ParamGamma[0]
        self.lambdac = Liste_ParamGamma[1]
        self.gammac = Liste_ParamGamma[2]
        
        self.param_corcos = ParamCorcos(frm1, "Param�tres du mod�le de Corcos")
        self.param_corcos.grid(row=0,column=0,sticky='nsew')
        
        frm1.protocol("WM_DELETE_WINDOW", self.hide_fcorrel_param_frame)
        Button(frm1,text="OK",command=self.hide_fcorrel_param_frame).grid(row=1,column=0)
        frm1.withdraw()
#
        Label(self, text="Choisissez les MODES utilis�s pour la d�convolution unimodale"\
                    " et pour le calcul des EML").grid(row=5, column=0, columnspan=4)
        
        self.liste_mode_deconv = ModeList(self, "D�convolution unimodale")
        self.liste_mode_deconv.grid(row=6, column=1)
        
        self.liste_mode_EML = ModeList(self,"Excitations Modales Locales")
        self.liste_mode_EML.grid(row=6,column=3)
        
        Button (self,text='Selectionner',command=self.Select_deconv).grid(
            row=6, column=2)
        Button (self,text='Selectionner',command=self.Select_EML).grid(
            row=6, column=4)
        

    def update(self):
        """ Pour mise � jour de la liste des modes associ�s au choix RESULTAT"""
        nom=self.modes_name.get()
        mode=self.objects.get_resu(nom)
        print mode.nom
        self.freq_deconv,bid1,bid2,self.nume_deconv,bid3,bid4 = mode.get_modes()
        self.liste_mode_deconv.fill_modes(self.freq_deconv,self.nume_deconv)
        self.freq_EML,bid1,bid2,self.nume_EML,bid3,bid4 = mode.get_modes()
        self.liste_mode_EML.fill_modes(self.freq_EML,self.nume_EML)
        
    def Select_deconv(self):
        print "###############################"
        print " Choix du mode pour la deconvolution unimodale"
        self.mess.disp_mess ("Fr�quence du mode pour la deconvolution unimodale")
        liste_deconv = self.liste_mode_deconv.return_list()
        modes_deconv = liste_deconv.curselection()
        for i in modes_deconv:
            print int(self.nume_deconv[int(i)][1]),self.freq_deconv[int(i)][1]
            self.mess.disp_mess ( "%13.5E" %(self.freq_deconv[int(i)][1]) )
            self.liste_modes_deconv.append(self.nume_deconv[int(i)][1])
            
            
    def Select_EML(self):
        print "###############################"
        print " Choix du (des) mode(s) pour la m�thode des EML"
        self.mess.disp_mess ("Fr�quence(s) du (des) mode(s) pour la m�thode des EML")
        liste_EML = self.liste_mode_EML.return_list()
        modes_EML = liste_EML.curselection()
        for i in modes_EML:
            print int(self.nume_EML[int(i)][1]),self.freq_EML[int(i)][1]
            self.mess.disp_mess ( "%13.5E" %(self.freq_deconv[int(i)][1]) )
            self.liste_modes_EML.append(self.nume_EML[int(i)][1])
    

    def display_fcorrel_param_frame(self):
        state=self.var_fcorrel_param_frame_visible.get()
        if state:
                self.fcorrel_param_frame.deiconify()
        else:
                self.fcorrel_param_frame.withdraw()

    def hide_fcorrel_param_frame(self):
        self.var_fcorrel_param_frame_visible.set(0)
        self.fcorrel_param_frame.withdraw()
        
    def choix_modele_correl(self):
        choix = self.var_fonc_correl.get()
        if choix=='MODELE GAMMA':
            self.param_corcos.grid_remove()
            self.param_gamma.grid()
        else:
            self.param_gamma.grid_remove()
            self.param_corcos.grid()
         
    
    def refresh(self):
##        self.objects.recup_objects()

        results_num = self.objects.get_resultats_num()
        old_result = self.modes_name.get()
#        self.menu_modes.update( results_num, self.modes_num, self.compute_lcorr )
        self.modes_name.set(old_result)

        

#-------------------------------------------------------------------------------

class ParamModeleGamma(Frame):
    """Un panneau pour sp�cifier les param�tres adimensionnels de la fonction
       GAMMA : longueur de diffusion, longueur de corr�lation et vitesse de 
       convection 
    """
    def __init__(self, root, title, **kwargs):
        Frame.__init__(self, root, **kwargs)
        Label(self, text=title).grid(row=0, column=0, columnspan=1)
        
        self.ld = DoubleVar()
        self.lambdac = DoubleVar()
        self.gammac = IntVar()
        self.ld.set(3.0)
        self.lambdac.set(3.5)
        self.gammac.set(70)
        self.gamma = OptionFrame(self, "Mod�le GAMMA",
                                 [ ("longueur de diffusion",Entry,
                                   { 'textvariable':self.ld } ),
                                   ("longueur de corr�lation (nb.de diam�tre)",
                                    Entry,
                                   { 'textvariable':self.lambdac } ),
                                   ("vitesse de convection (% de la vitesse moyenne)",
                                     Entry,
                                   { 'textvariable':self.gammac } ),
                                 ])
        self.gamma.grid(row=1,column=0,sticky="WE",columnspan=2)
         
        
    def update_param(self):
        mc=[]
        mc.append(self.ld.get())
        mc.append(self.lambdac.get())
        mc.append(self.gammac.get())
        
        print "mc"
        print mc
        
        return mc
        
                              
#-------------------------------------------------------------------------------

class ParamCorcos(Frame):
    """Un panneau pour sp�cifier les param�tres adimensionnels de la fonction
       Corcos :  
    """
    def __init__(self, root, title, **kwargs):
        Frame.__init__(self, root, **kwargs)
        Label(self, text=title).grid(row=0, column=0, columnspan=1)
        
        self.param1 = DoubleVar()
        self.param2 = DoubleVar()
        self.param1.set(0.0)
        self.param2.set(0.0)
        
        self.corcos = OptionFrame(self, "Mod�le de CORCOS",
                                 [ ("param1",Entry,
                                    { 'textvariable':self.param1 } ),
                                   ("param2",Entry,
                                    { 'textvariable':self.param2 } ),
                                 ])
        self.corcos.grid(row=1,column=0,sticky="WE",columnspan=2)
#-----------------------------------------------------------------------------
class InterfaceSelectMesures(Frame):
    """ classe graphique pour la selection des mesures en fonctionnement
    """

    def __init__(self, parent, objects, turbmonomod, fimens, mess):
        """  \param fimens: Fichiers fimen � utiliser  
        """      
        self.turbmonomod = turbmonomod
        self.mess = mess
        self.parent = parent
        self.objects = objects

        Frame.__init__(self, parent, **DEFAULT_FRAME_ARGS)

        Label(self,text="Choix de l'interspectre en fonctionnement").grid(
                   row=0,column=0, columnspan = 3)
        
        self.inte_spec_name = StringVar()  #le nom de l'interspectre
        self.choix_inte_spec = MyMenu(self,
                                objects.get_inter_spec_name(),
                               self.inte_spec_name,
                               self._get_inter_spec
                                   )
        self.choix_inte_spec.grid(row=1,column=0)
        
        Label(self,text="Type de mesures").grid(row=2,column=0)
        
        self.typ_resu_fonc = StringVar() # le type de l'interspectre
        self.opt_cham = ['DEPL','VITE','ACCE'] 
        self.typ_cham = MyMenu(self,
                               self.opt_cham,
                               self.typ_resu_fonc)
        self.typ_resu_fonc.set('DEPL')
        self.typ_cham.grid(row=3, column=0)
        
        Label(self, text="Choix de la base modale exp�rimentale").grid(
                      row=0,column=3,columnspan = 2 )
        self.ModesExp_name = StringVar()
        self.menu_modes = MyMenu( self,
                                  objects.get_resultats_num(),
                                  self.ModesExp_name                                  
                                 )
        self.menu_modes.grid(row=1, column=3)
        
        self.vitesse = StringVar()
        itm = HLabelledItem(self, "Vitesse :",
                            Entry,
                            textvariable=self.vitesse)
        self.vitesse_entry = itm.itm
        itm.itm.bind("<Return>", self.change_vitesse)
        itm.grid(row=3, column=2,sticky='w')
                            
      # Choix des fichiers FIMEN
        self.fimens = {}
        for u,m in fimens:
            self.fimens[m] = u
        self.fimen_name = StringVar()
        self.menu_fimen = MyMenu( self, self.fimens.keys(),
                                  self.fimen_name )
        self.fimen_name.set("Fichier FIMEN")
        self.menu_fimen.grid(row=3, column=3,sticky='w')
    
    def change_vitesse(self, event):
        """!Callback appel� lors d'un changement du param�tre vitesse"""
        try:
            vit = float(self.vitesse.get())
        except ValueError:
            self.mess.disp_mess( (  "Vitesse invalide" ) )
            self.mess.disp_mess( ( " " ) ) 
            self.vitesse_entry['background'] = "red"
            return
        except TypeError:
            self.mess.disp_mess( (  "Rentrer une vitesse d'�coulement" ) )
            self.mess.disp_mess( ( " " ) )
            return
        self.vitesse_entry['background'] = "green"
        self.turbmonomod.set_speed( vit )
        
    def _get_inter_spec(self):
        """ Va chercher l'instance de la classe Interspectre correspondant 
        au nom de l'interspectre choisi"""
        nom_intsp = self.inte_spec_name.get()
        self.inter_spec = self.objects.inter_spec[nom_intsp]
    
    def refresh(self):
##        self.objects.recup_objects()

        results_num = self.objects.get_resultats_num()
        old_result = self.ModesExp_name.get()
#        self.menu_modes.update( results_num, self.modes_num, self.compute_lcorr )
        self.ModesExp_name.set(old_result)                
#-----------------------------------------------------------------------------
class InterfaceLongeqTurb(Frame):
    """classe graphique qui dirige les calculs des longueurs de correlation
        fluides, m�thode mono-modale"""

    def __init__(self, parent, objects, turbmonomod, fludela, donnees, select_mesures, mess):
        self.turbmonomod = turbmonomod
        self.mess = mess
        self.parent = parent
        self.objects = objects
        self.donnees = donnees
        self.select_mesures = select_mesures 
        self.fludela = fludela
        
        self.xmgr_manager = XmgrManager()

        Frame.__init__(self, parent, **DEFAULT_FRAME_ARGS) 
        
        Label(self, text="Calcul des longueurs de corr�lation g�n�ralis�e").grid(
                     row=0,column = 0,columnspan = 3 )
        Label(self, text="et des densit�s spectrales d'excitation").grid(
                     row=1,column = 0,columnspan = 3 )             
        
        Button(self, text="Calcul!", command=self.compute_lcorr_gene ).grid(
                      row=0, column=3,sticky='w')
        
        Label(self, text="Fonction Lc pour le mode fondamental").grid(
                     row=2,column=0)
        Button(self, text="Afficher", command = self.affich_fonc_lcorr).grid(
                     row=2, column=1)
                     
        
        self.lcorr_EML_array = ModeList(self,'Valeurs Lc des modes suppl�mentaires (EML)')
        self.lcorr_EML_array.grid(row=2, column=3)
        self.lcorr_EML_values =  zeros((1,1),)

        self.fludela.register_longeq( self.notify )
        
        Label(self, text="Fonction S0 pour le mode fondamental").grid(
                     row=4,column=0)
        Button(self, text="Afficher", command = self.affich_fonc_S0).grid(
                     row=4, column=1)
        
        Label(self, text="Recalage du spectre selon la forme analytique").grid(
                     row=5, column=0)
        Button(self, text="Calcul !", command = self.compute_interpolation).grid(
                     row=5, column=1)             
        
    def compute_lcorr_gene(self):
        """!Si possible calcule la longueur de corr�lation g�n�ralis�e"""
        try:
            self.resu = self.objects.get_resu( self.donnees.modes_name.get() )
            self.resu_exp = self.objects.get_resu( self.select_mesures.ModesExp_name.get())
        except KeyError:
            return
        self.mess.disp_mess( (  " Calcul de la longueur de corr�lation g�n�ralis�e" ) )
        self.mess.disp_mess( (  self.resu.modele_name ) )
        self.mess.disp_mess( (  self.resu.nom ) )
        self.mess.disp_mess( ( "  " ) ) 

        # Attention � rafra�chir la m�moire de MeideeObjects
        self.objects.recup_objects()
        
        nom_intsp=self.select_mesures.inte_spec_name.get()
        self.inter_spec = self.objects.inter_spec[nom_intsp]
        print "self.inter_spec"
        print self.inter_spec
        
        self.turbmonomod.set_ld(self.donnees.ld)
        self.turbmonomod.set_lambdac(self.donnees.lambdac)
        self.turbmonomod.set_gammac(self.donnees.gammac)
        print "self.donnees.ld"
        print self.donnees.ld
        
        self.turbmonomod.set_res_longcorr( self.resu )
        self.turbmonomod.set_resultat_exp(self.resu_exp)
        self.turbmonomod.set_nume_deconv(self.donnees.liste_modes_deconv)
        self.turbmonomod.set_nume_EML(self.donnees.liste_modes_EML)
        self.turbmonomod.set_interspectre(self.inter_spec)
        self.turbmonomod.set_type_intsp(self.select_mesures.typ_resu_fonc.get())
        if self.select_mesures.fimen_name.get() != 'Fichier FIMEN':
            self.turbmonomod.set_fimen(self.fimen_name.get())
        # Lancement des calculs
        self.turbmonomod.compute()
        lcorr = self.turbmonomod.long_corr
        nume_modes = self.resu.get_modes()[3]
        self.lcorr_EML_array.fill_modes( lcorr, nume_modes, format = '%13.5E' )
        
    def compute_interpolation(self):
        try:
            self.fonc_S0 = self.turbmonomod.fonc_ModulS0
        except KeyError:
            return
        self.mess.disp_mess( (  " Calcul des parametres de la forme analytique " ) )
        self.mess.disp_mess( (  "  attendue pour S0 " ) )
        self.turbmonomod.compute_interpolation()
        
    def affich_fonc_lcorr(self):
        """Lance l'affichage de la fonction Lc(omega) du mode fondamental
        """
        var_abs = StringVar()
        var_ord = StringVar()
        
        var_abs.set("LIN")
        var_ord.set("LIN")
        
        fonc_lcorr = self.turbmonomod.fonc_long_corr
        
        fonc_lcorr_py = fonc_lcorr.convert()        
        
        abscisse = fonc_lcorr_py.vale_x
        ordonnee = fonc_lcorr_py.vale_y
        
        print "abscisse dans affich_fonc_lcorr"
        print abscisse
        print "ordonnee dans affich_fonc_lcorr"
        print ordonnee
        
        print "longueurs des tableaux abs et ord de fonc_lcorr"
        print len(abscisse)
        print len(ordonnee)
        print "var_abs.get()"
        print var_abs.get()
        print ".var_ord.get()"
        print var_ord.get()
        
        color = [1]
        
        legende = [ "Longueur de correlation generalisee" ] 
        
        PlotXMGrace(abscisse, ordonnee, color, legende, var_abs.get(),var_ord.get())
                
    
    def affich_fonc_S0(self):
        """Lance l'affichage de la fonction S0(omega) du mode fondamental
        """
        var_abs = StringVar()
        var_ord = StringVar()
        
        var_abs.set("LOG")
        var_ord.set("LOG")
        
        self.fonc_S0 = self.turbmonomod.fonc_ModulS0
        
        ModS0_py = self.fonc_S0.convert()
        
        abscisse = ModS0_py.vale_x
        ordonnee = ModS0_py.vale_y
        
        print "abscisse dans affich_fonc_S0"
        print abscisse
        print "ordonnee dans affich_fonc_S0"
        print ordonnee
        
        print "var_abs.get()"
        print var_abs.get()
        print "var_ord.get()"
        print var_ord.get()
        
        color = [1]
        
        legende = [ "Spectre d'excitation S0" ] 
        
        PlotXMGrace(abscisse, ordonnee, color, legende, var_abs.get(),var_ord.get())
                
        
    def refresh(self):
#        inte_spec_name = self.objects.get_inter_spec_name()
        results_num = self.objects.get_resultats_num()
#        self.choix_inte_spec.update(inte_spec_name,self.inte_spec_name,self._get_inter_spec)
#        self.choix_deconvunimod.update(results_num,self.deconvunimod_name,self.update)
#        self.choix_EML.update(results_num,self.EML_name,self.update2)
        
    

    def notify(self):
        lcorr = self.turbmonomod.long_corr
        nume_modes = self.resu.get_modes()[3]
# retenir que les nume_mode deconv et EML ???
        self.lcorr_EML_array.fill_modes( lcorr, nume_modes, format = '%13.5E' )


        
#-------------------------------------------------------------------------------


class Curve:
    """!Encapsule une courbe pour TkPlotCanvas"""
    def __init__(self, name, data, field, mode, mess):
        self.mess = mess
        self.name = name
        self.data = data
        self.field = field
        self.mode = mode

    def get_curve(self):
        speed = [ float(v) for v in self.data.keys() ]
        speed.sort()
        return PolyMarker( values, color='blue', fillcolor='blue', marker='circle' )



#######################################################
#                                                     #
# CLASSES ET FONCTIONS UTILITAIRES (FIMEN, LONGEQ...) #
#                                                     #
#######################################################

class Fimen:
    """!Fimen

    classe permettant la manipulation de fichier au format Fimen
    On va chercher dans un fichier fimen, d�cod� en ascii avant le calcul Aster
    les donn�es modales � manipuler
    """

    def __init__(self, mess, name):
        self.mess = mess
        self.taue = 0.0
        self.nm = 0
        self.nbz = 0
        self.fzoom = 0.0   # fzoom
        self.nrf = 0       # nombre de references 
        self.n0rf = zeros( (self.nrf,), Int )
        self.freq = None
        self.xsi = 1.0*zeros( (self.nm,) )
        self.a = None
        self.b = None
        self.u = None
        self.v = None
        self.w = None
        self.mess.disp_mess( "on ouvre le fichier fimen suivant : ")
        self.mess.disp_mess( name )
        self.mess.disp_mess( "  " )
        self.fimen = open(name, 'r')

    def lec_fimen(self):
        """ !Lecture d'un fichier fimen donne par l'unite fortran
            Le fichier est ascii, d�cod� en amont du code"""
        fimen = self.fimen
        liste = []
        fimen.readline()
        for ind_l in range(5):
            line = fimen.readline()
            liste.append(string.split(line)[-1:][0])
        (self.taue, self.nm, self.nbz, self.fzoom, self.nrf) = (string.atof(liste[0]),string.atoi(liste[1]),
                                                                string.atoi(liste[2]),string.atof(liste[3]),
                                                                string.atoi(liste[4]))
                                                                     
        
        # Caras modales
        for ind_l in range(3):
            line = string.split(fimen.readline())
        self.freq = [float(k) for k in line]
        self.freq = array(self.freq)
        for ind_l in range(2):
            line = string.split(fimen.readline())
        self.xsi = [float(k) for k in line]
        
        # Coefficients de participation
        # Matrice A :
        fimen.readline()
        self.a = 1.0*zeros( (self.nm,self.nrf))
        for i in range(self.nm):
            line = [float(j) for j in string.split(fimen.readline())]
            for j in range(self.nrf):
                self.a[i,j] = line[j]        
        fimen.readline()
        
        # Matrice B :
        fimen.readline()
        self.b = 1.0*zeros( (self.nm,self.nrf))
        for i in range(self.nm):
            line = [float(j) for j in string.split(fimen.readline())]
            for j in range(self.nrf):
                self.b[i,j] = line[j]
        fimen.readline()

        # D�form�es modales complexes
        # Matrice U
        fimen.readline()
        self.u = 1.0*zeros( (self.nm,self.nbz))
        for i in range(self.nm):
            line = [float(j) for j in string.split(fimen.readline())]
            for j in range(self.nbz):
                self.u[i,j] = line[j]
        fimen.readline()        

        # Matrice V
        fimen.readline()
        self.v = 1.0*zeros( (self.nm,self.nbz))
        for i in range(self.nm):
            line = [float(j) for j in string.split(fimen.readline())]
            for j in range(self.nbz):
                self.v[i,j] = line[j]
        fimen.readline()         
                

    def global_granger( self, ind_ref=0, modes=None):
        """!Calcul de la frequence et de l'amortissement globaux pour un groupe de modes

        \return la fr�quence et l'amortissement globaux
        
        N�cessite la lecture pr�alable du fichier binaire Fimen par la m�thode
        lec_fimen.

        On utilise la formulation r�elle approchee (<> formulation complexe)
        
        Si il y a plusieurs voies de r�f�rence et/ou que la voie de r�f�rence
        n'est pas la voie 1, on le renseigne en entr�e de la fonction
        """
        nref = self.nrf
        freq, xsi = self.freq, self.xsi
        A,B,U,V = self.a, self.b, self.u, self.v

        if modes is None:
            modes = range(self.nm)
        freq = take( freq, modes )
        xsi = take( xsi, modes )
        f0 = 0.0
        xsi0 = 0.0
        for iref in range(nref):
            # Freq globale moyennee sur les voies de reference
            ponderation = A[:,iref]*U[:,iref] - B[:,iref]*V[:,iref]
            ponderation = take( ponderation, modes )
            f2 = sum( ponderation * freq**2 )/ sum( ponderation )
            if f2 < 0:
                self.mess.disp_mess("!!  Calcul global impossible par m�thode Granger  !!")
                self.mess.disp_mess("!!          Essayer par une autre m�thode         !!")
                self.mess.disp_mess("                                     ")
                return -1.0, -1.0
            f0 = f0 + sqrt( f2 )
            xsi0 = xsi0 + sum( ponderation * xsi) / sum( ponderation )

        f0 = f0/nref
        xsi0 = xsi0/nref

        return f0, xsi0  
        
#    def variance_granger(self, ind_ref=0, modes=None):
    def variance_granger(self,ind_ref=0):
         """!Calcul de la variance globale pour utilisation dans la m�thode des EML
         pour l'estimation des efforts turbulents """
         
#         from Cata.cata import CREA_CHAMP, DETRUIRE, CREA_TABLE
#         
         nref = self.nrf
         nm = self.nm
         A,B,U,V = self.a, self.b, self.u, self.v
         
         if modes is None:
             modes = range(self.nm)
             
         
         var0 = 1.0*zeros( (self.nm,self.nrf))
         
                  
         for imodes in range(nm):
             for iref in range(nref) :
                 ponderation = A[imodes,iref]*U[imodes,iref] - B[imodes,iref]*V[imodes,iref]
#             ponderation = take( ponderation, modes )  
                              
                 def2 = U[imodes,iref]*U[imodes,iref]+V[imodes,iref]*V[imodes,iref]
             
                 var = 2*(ponderation / def2)
             
                 var0[imodes,iref] = var
         
         return var0       
             
             
             

