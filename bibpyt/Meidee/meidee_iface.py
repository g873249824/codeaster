#@ MODIF meidee_iface Meidee  DATE 21/10/2008   AUTEUR NISTOR I.NISTOR 
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


## \package meidee_iface Classe de support pour l'interface graphique
#
# Ce module contient des classes d'assistance � la cr�ation
# d'interface graphiques, pouvant etre utillis�es par plusieurs
# interfaces


import os
from popen2 import Popen3

from Numeric import minimum, maximum, array, arange, log
from Tkinter import Frame, Label, Menubutton, Menu, StringVar, IntVar, Listbox
from Tkinter import Toplevel, Scrollbar, Radiobutton, Button, Entry
from Tkinter import Checkbutton, Canvas, Text, END

import aster
from Utilitai.Utmess import UTMESS
from Stanley.xmgrace import Xmgr
from Stanley.as_courbes import Courbe

palette = [ "#%02x%02x%02x" % (i, 255-i, 0) for i in range(256) ]


class GroupFrame(Frame):
    def __init__(self, root, title, **kwargs):
        kwargs.setdefault('relief', 'ridge')
        kwargs.setdefault('borderwidth', 1)
        Frame.__init__(self, **kwargs)
        Label(self,text=title,background="#a0a0a0").grid(row=0,column=0,sticky='ew')
        self.inner = Frame(self, borderwidth=0, relief='flat')
        self.inner.grid(row=1,column=0,sticky='nsew')
        self.rowconfigure(0,weight=0)
        self.rowconfigure(1,weight=1)
        self.columnconfigure(0,weight=1)


class TabbedWindow(Frame):
    """!Objet de gestion de `tabs` avec Tk
    """
    def __init__(self, root, tablabels):
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
        Frame.__init__(self,root,relief='flat',borderwidth=0)
        self.labels = {}
        self.objects = None
        #root.grid_propagate(0)
        self.tabnum = StringVar()
        f = Frame(self,borderwidth=0,relief='flat')
        for i, name in enumerate(tablabels):
            b = Radiobutton(f, text=name, value=name, relief='solid',
                            variable=self.tabnum, indicatoron=0, borderwidth=1,
                            bg='#a0a0a0', # selectcolor='#907070',
                            command=self.switch_tab).pack(side='left')
            self.labels[name] = [ b, None ]
        f.grid(row=0,column=0,sticky='w')
        self.columnconfigure(0,weight=1)

        self.rowconfigure(0, weight=0)
        self.rowconfigure(1, weight=1)

        self.main = Frame(self, relief='ridge', borderwidth=4)
        self.main.rowconfigure(0, weight=1 )
        self.main.columnconfigure(0, weight=1 )
        self.main.grid(row=1, column=0, sticky='w'+'e'+'s'+'n')
        self.current_tab = None
        self.current_tab_frame = None

    def set_objects(self, objects):
        self.objects = objects

    def root(self):
        """!Renvoie la Frame qui recoit le tab courant
        """
        return self.main

    def set_tab(self, name, w):
        """!Associe un contenu de tab

        \param name Le nom du tab
        \param w Le Frame � associer
        """
        current_tab = self.current_tab
        if current_tab == name:
            self.hide_current_tab()
        self.labels[name][1] = w
        if current_tab == name:
            self.set_current_tab(name)

    def hide_current_tab(self):
        """!Masque le contenu du tab courant"""
        b,f = self.labels.get(self.current_tab, (None,None))
        if f is not None:
            f.teardown()
            f.grid_remove()
        self.current_tab == None

    def set_current_tab(self, name):
        """!Change le tab courant"""
        b,f = self.labels.get(name, (None,None))
        if f is not None:
            f.grid(sticky='w'+'e'+'s'+'n')
            self.current_tab = name
            self.current_tab_frame = f
            f.setup()
            self.tabnum.set(name)

    def switch_tab(self, *args):
        """!Affiche le tab choisit par l'utilisateur (callback Tk)"""
        self.objects.recup_objects()
##        self.objects.new_objects() # = recup_object en + light. aucun int�r�t ?
        self.hide_current_tab()
        self.set_current_tab(self.tabnum.get())


class LabelArray(object):
    """!Un tableau de widget \a Label"""
    def __init__(self, parent, l0, c0, nrows, ncols ):
        """!Constructeur

        \param parent Le widget parent
        \param l0 indice de la premi�re ligne � utiliser pour le positionnement
            dans le widget parent
        \param c0 indice de la premi�re colonne � utiliser pour le positionnement
            dans le widget parent
        \param nrows nombre de lignes du tableau
        \param ncols nombre de colonnes du tableau
        """
        self.parent = parent
        self.c0 = c0
        self.l0 = l0
        self.cells = [] # liste de liste de couple (var,widget)
        self.nrows = 0
        self.ncols = 0
        self.setup( nrows, ncols )

    def cleanup(self):
        """!D�truit tous les widgets du tableau"""
        for rows in self.cells:
            for var, widget in rows:
                widget.destroy()
        del self.cells[:]

    def setup( self, nrows, ncols ):
        """!Pr�pare et redimmensionne le tableau

        \param nrows Le nombre de lignes
        \param ncols Le nombre de colonnes
        """
        self.cleanup()
        self.cells = [[None]*ncols for i in range(nrows)]
        for r in range(nrows):
            for c in range(ncols):
                var, w = self.cell(r,c)
                self.cells[r][c] = var, w
                w.grid( column=c+self.c0, row=r+self.l0 )

    def cell( self, r, c ):
        """!Factory pour une cellule

        \param r la rang�e de la cellule
        \param c la colonne de la cellule

        \return Un couple (variable, widget) de type (StringVar,Label) qui correspond au widget et � sa
                 variable de controle
        """
        var = StringVar()
        l = Label(self.parent,textvariable=var)
        return var,l

    def set( self, x, y, value ):
        """!Change la valeur d'une cellule

        \param x abcisse de la cellule
        \param y ordonn�e de la cellule
        \param value nouvelle valeur
        """
        var, w = self.cells[x][y]
        var.set( str(value) )

    def get( self, x, y ):
        """!Renvoie le contenu d'une cellule

        \param x abcisse de la cellule
        \param y ordonn�e de la cellule

        \return La valeur associ�e � la variable de controle
        """
        var, w = self.cells[x][y]
        return var.get( )

    def getw( self, x, y ):
        """!Renvoie le widget d'une cellule

        \param x abcisse de la cellule
        \param y ordonn�e de la cellule

        \return Une instance de type Frame ou d�riv�e qui repr�sente le contenu de la cellule
        """
        var, w = self.cells[x][y]
        return var.get( ), w

    def rows_value( self ):
        """!Renvoie le contenu de toutes les cellules

        \return le tableau des valeurs des cellules sous forme de
                liste de liste indexable par \a [x][y]
        """
        rows = []
        for row in self.cells:
            r = []
            for var, w in row:
                r.append( var.get() )
            rows.append(r)
        return rows


class EntryArray(LabelArray):
    """!Un tableau de widget \a Entry"""
    def __init__(self, parent, l0, c0, nrows, ncols, cb=None, width=20 ):
        """!Constructeur

        \param parent Le widget parent
        \param l0 indice de la premi�re ligne � utiliser pour le positionnement
            dans le widget parent
        \param c0 indice de la premi�re colonne � utiliser pour le positionnement
            dans le widget parent
        \param nrows nombre de lignes du tableau
        \param ncols nombre de colonnes du tableau
        \param cb callback pour l'�v�nement <Return> (si diff�rent de ``None``)
        """
        self.cb = cb
        if isinstance(width, list):
            self.width = width
        else:
            self.width = [width]*ncols
        LabelArray.__init__(self, parent, l0, c0, nrows, ncols )

    def cell( self, r, c ):
        """!Factory pour une cellule

        \param r la rang�e de la cellule
        \param c la colonne de la cellule

        \return Un couple (variable, widget) de type (StringVar,Entry)
                qui correspond au widget et � sa variable de contrle
        """
        var = StringVar()
        e = Entry(self.parent, textvariable=var, width=self.width[c] )
        if self.cb:
            e.bind("<Return>", self.cb)
        return var, e


class MenuArray(LabelArray):
    """!Un tableau de `MenuButton`"""
    def __init__(self, parent, c0, l0, nrows, ncols, options, cb ):
        """!Constructeur

        \param parent Le widget parent
        \param l0 indice de la premi�re ligne � utiliser pour le positionnement
            dans le widget parent
        \param c0 indice de la premi�re colonne � utiliser pour le positionnement
            dans le widget parent
        \param nrows nombre de lignes du tableau
        \param ncols nombre de colonnes du tableau
        \param option liste des choix possible du menu
        \param cb callback de s�lection (si diff�rent de ``None``)
        """
        self.options = options
        self.cb = cb
        LabelArray.__init__(self, parent, c0, l0, nrows, ncols )

    def cell( self, r, c ):
        """!Factory pour une cellule

        \param r la rang�e de la cellule
        \param c la colonne de la cellule

        \return Un couple (variable, widget) de type (StringVar, MyMenu) qui correspond au widget et � sa
                 variable de controle (\see MyMenu)
        """
        var = StringVar()
        e = MyMenu( self.parent, self.options, var, self.cb )
        return var, e


#-------------------------------------------------------------------------------

class ModeList:
    """!Cr��e une liste de modes"""

    def __init__(self, root, titre):
        self.modes = Frame( root )
        self.modes.rowconfigure(1,weight=1)
        num = Label(self.modes, text=titre )
        num.grid(row=0,column=0,columnspan=2)
        scroll = Scrollbar ( self.modes, orient='vertical' )
        scroll.grid ( row=1, column=1, sticky='n'+'s' )
        self.modes_list = Listbox( self.modes, selectmode='multiple',
                                   yscrollcommand=scroll.set,
                                   exportselection=False,
                                   background='white')
        scroll["command"] = self.modes_list.yview
        self.modes_list.grid( row=1, column=0, sticky='n'+'s')

    def grid(self, **args):
        self.modes.grid(**args)

    def return_list(self):
        return self.modes_list

    def fill_modes(self, val, anum, format = '%.3f' ):
        """!Remplit une liste de modes avec les num�ros/fr�quences pass�s en param�tres
        
        \param lst un objet ListBox
        \param afreq une liste extraite par un EXTR_TABLE (indice,valeur) des fr\351quences
        \param anum une liste extraite par un EXTR_TABLE (indice,valeur) des num\351ros de mode
        """
        self.modes_list.delete(0,'end')
        for i in xrange(val.shape[0]):
            s = "%3d - "+format
            s = s %(anum[i,1], val[i,1])
            self.modes_list.insert( 'end', s )

    def fill_vect_base(self, anum, val ):
        """!Remplit une liste de vecteurs avec les num�ros/types pass�s en param�tres
        
        \param anum une liste extraite par un EXTR_TABLE (indice,valeur) des num�ros de mode
        \param anum une liste extraite par un EXTR_TABLE (indice,valeur) des types
        """

        self.modes_list.delete(0,'end')

        for i in range(len(anum)) :
            s = "%3d - %12s" % (anum[i], val[i])
            self.modes_list.insert( 'end', s )

    def clear_list(self):
        """!Remise a zero de la liste de modes
        
        """
        self.modes_list.delete(0,'end')

#-------------------------------------------------------------------------------            
    
class MultiList(Frame):
    """!Widget permettant de g�rer plusieurs listes (colonnes) synchronis�e
    sur la meme barre de d�filement
    """
    def __init__(self, root, labels, format = None ):
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
            lb = Listbox( self, selectmode='multiple',
                          yscrollcommand=self.scroll.set,
                          exportselection=False )
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

#------------------------------------------------------------------------------
# PETITS UTILITAIRES GRAPHIQUES #

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
                    "Mauvaise entr�e: " \
                    "un des champs semble ne pas �tre un r�el."
                    )
                return None

        return tuple(res_values)

    def destroy(self):
        """D�truit l'object vecteur"""
        for wid in self.widgets:
            wid.destroy()


class HLabelledItem(Frame):
    """!Classe helper permettant de cr�er
    un widget et son label horizontalement"""
    _pos = "left-right"
    def __init__(self, root, label, klass, *args, **kwargs ):
        Frame.__init__(self, root)
        self.lbl = Label(self, text=label)
        self.itm = klass(self, *args, **kwargs )
        self.lbl.grid(row=0, column=0, sticky = 'w'+'e')
        if self._pos == "left-right":
            self.itm.grid(row=0, column=1, sticky = 'e')
        else:
            self.itm.grid(row=1, column=0, sticky = 's')


class VLabelledItem(HLabelledItem):
    """!Classe helper permettant de cr�er un widget et son label verticalement"""
    _pos = "up-down"

#------------------------------------------------------------------------------

def PlotXMGrace(abscisse, ordonnee, couleur, legende, ech_x, ech_y):
    """!Sortie des donn�es sur une courbe XMGrace

    \param abscisse abscisses du graphe
#    \param ordonnees tableau de valeurs
    \param ordonnee ordonnees du graphe
    """
    from Cata.cata import IMPR_FONCTION
    _tmp = []
#    for i in range(len(ordonnees)):
    _tmp.append( { 'ABSCISSE': abscisse,
#                       'ORDONNEE': tuple(ordonnees[i].tolist()),
                   'ORDONNEE': ordonnee,
                   'LEGENDE':legende[0],
                   'COULEUR': couleur[0] } )

    motscle= {'COURBE': _tmp}

    
    IMPR_FONCTION(FORMAT='XMGRACE',
                  PILOTE='INTERACTIF',
                  TITRE='Courbe',
                  SOUS_TITRE='Sous-titre',
                  LEGENDE_X='Pulsation',
                  LEGENDE_Y='Amplitude',
                  ECHELLE_X=ech_x,
                  ECHELLE_Y=ech_y,
                  **motscle
                  );

class MeideeXmgr(Xmgr):
    """Une interface � Xmgrace pouvant �tre lanc�e 
    plusieur fois en m�me temps (l'unique diff�rence 
    avec la version Stanley)."""

    def __init__(self, xmgr_idx, gr_max = 10, options=None,
                       xmgrace=aster.repout() + '/xmgrace'):

        self.gr_max   = gr_max        # nombre de graphes 
        self.gr_act   = 0             # numero du graphe actif
        self.sets     = [0]*gr_max    # nombre de sets par graphe
        self.nom_pipe = 'xmgr%i.pipe' % xmgr_idx  # nom du pipe de communication
        if xmgrace == "/xmgrace":
            print "Pbl with atser repout ", aster.repout()
            print "Testt ", aster.repout() + '/xmgrace'
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
    """Garde en r�f�rence les instances de `MeideeXmgr'.
    """

    def __init__(self):
        self.xmgr_nb = 0
        self.xmgr_list = []
        self.echelle_dict = {'LIN' : 'NORMAL',
                             'LOG' : 'LOGARITHMIC'}

    def affiche(self, abscisse, ordonnees, couleur, legende, ech_x, ech_y):
        """!Sortie des donn�es sur une courbe XMGrace

        \param abscisse abscisses du graphe
        \param ordonnees tableau de valeurs
        """
        self.xmgr_nb += 1
        xmgr = MeideeXmgr(self.xmgr_nb)
        self.xmgr_list.append(xmgr)
        
        xmgr.Titre('Courbe', 'Sous_titre')
        xmgr.Axe_x('Fr�quence')
        xmgr.Axe_y('Amplitude')
        
        for ord, leg in zip(ordonnees, legende):
            cbr = Courbe(abscisse, ord)
            xmgr.Courbe(cbr, leg)
        
        xmgr.Ech_x(self.echelle_dict[ech_x])
        xmgr.Ech_y(self.echelle_dict[ech_y])
    
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

class MessageBox:
    """!Classe dans laquelle on stocke la fentre de message (string)
    et qui permet d'ecrire dans un .mess separe si l'utilisateur en a fait
    la demande"""
    
    def __init__(self, unite, interactif):
        self.interactif = interactif
        self.unite = None
#        if unite:
#            self.unite = unite #unite d'ecriture
#            self.mess_file = open('fort.'+str(unite),'w')
        if self.interactif == 'oui':    
            self.window = Toplevel()
            titre = Label(self.window, text='Fenetre de messages' )
            titre.grid(row=0,column=0,columnspan=2)

            affich = Frame(self.window, relief='ridge', borderwidth=4, colormap="new")
            affich.grid(row=1,sticky='w'+'e'+'s'+'n')
            scroll = Scrollbar ( affich, orient='vertical' )
            scroll.grid ( row=0, column=1, sticky='n'+'s' )
            self.modes_list = Listbox( affich, selectmode='multiple',
                                       yscrollcommand=scroll.set,
                                       exportselection=False,
                                       font=("Courier","12"),
                                       width=80, height=20,
                                       background='white'
                                       )
            scroll["command"] = self.modes_list.yview
            self.modes_list.grid( row=0, column=0, sticky='w'+'e'+'s'+'n')
                          

    def disp_mess(self, new_mess):
        """!Ecriture des messages dans le fichier sortie
        s'il existe et dans la fenetre de message"""
        if self.interactif == 'oui':
            self.modes_list.insert('end', new_mess)
            self.modes_list.yview('scroll',1,'units')
        if self.unite:
            self.mess_file.writelines(new_mess + '\n')
            


    def close_file(self):
        """ Ferme le fichier de message a la fin de l'utilisation"""
        self.mess_file.close()


#------------------------------------------------------------------------------
        
class MacMode(Canvas):
    """!Trac� d'une matrice de MAC

    Cet objet accepte un canvas produit par Tk. sa m�thode
    display permet de redessiner une matrice sur ce canvas

    Cette classe est destin�e � etre utilis�e par meidee_help.MacWindow
    
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
        n,m = mat.shape
        width = self.winfo_width()
        height = self.winfo_height()
        xc = width*arange(0., n+1, 1.)/n
        yc = height*arange(0., m+1, 1.)/m
        _min = minimum.reduce
        _max = maximum.reduce
        cmin = _min(mat.flat)
        cmax = _max(mat.flat)
        for i in range(n):
            for j in range(m):
                v = int(255*(mat[i,j]-cmin)/(cmax-cmin))
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
        if self.mat:
            self.refresh_display()

#------------------------------------------------------------------------------


class MacWindow:
    """!Interface de la fenetre d'affichage des modes MAC

    contient:

     - un titre
     - la matrice de MAC
     - la liste des modes
     - les labels des lignes et colonnes de la matrice
     - un bouton (log) permettant de commuter l'affichage lin�aire et logarithmique

    """
    def __init__(self, root, label, modes1, modes2, mat, resu1=None, resu2=None, top=None ):
        """!Constructeur

        :IVariables:
         - `root`: la fenetre parente
         - `mat`: la matrice des valeurs � afficher
         - `modes1`: liste des modes en Y
         - `modes2`: liste des modes en X
         - `logvar`: variable Tk li�e au bouton radio indiquant la m�thode (log ou pas) d'affichage
         - `mac`: l'objet MacMode
         - `resu1`:nom de l'instance Resultat qui a servi pour le calcul des modes (idem 'resu2')
         - `diplayvar1`: variable li�e � un label pour permettre l'affichage de la valeur sous le curseur
         - `top`: la fenetre toplevel qui contient l'interface
        """
        self.root = root
        self.mat = mat
        if not top:
            top = self.top = Toplevel()
        top.rowconfigure(1, weight=1)
        top.columnconfigure(0, weight=1)

        # Titre
        titre = Label( top, text=label )
        titre.grid(row=0, column=0, columnspan=4, sticky='n' )

        # Graphique
        self.mac = MacMode( top,relief='flat' )
        self.mac.grid( row=2, column=1, sticky='w'+'e'+'s'+'n' )
        self.modes1 = modes1
        self.modes2 = modes2

        # Label abcisse/ordonn�e
        if not resu1 : name1 = "1"
        else :         name1 = resu1.nom
        if not resu2 : name2 = "2"
        else :         name2 = resu2.nom
        Label(top,text=name1).grid(row=2, column=0, sticky='e')
        Label(top,text=name2).grid(row=3, column=1)

        # Tableau de modes
        text1 = self.build_modes(top,resu1)
        text1.grid( row=2, column=2 )
        text2 = self.build_modes(top,resu2)
        text2.grid( row=2, column=3 )

        # Switch log/lin
        self.logvar = IntVar()
        logmode = Checkbutton(top,text="Log",variable=self.logvar, command=self.setlog )
        logmode.grid( row=4,column=0,columnspan=4)
        self.mac.show_mat( mat )
        self.mac.resize_ok()
        self.displayvar1 = StringVar()
        self.displayvar1.set("none")
        self.displayvar2 = StringVar()
        self.displayvar2.set("none")
        Label(top,textvariable=self.displayvar1).grid(row=5,column=0,columnspan=4)
        Label(top,textvariable=self.displayvar2).grid(row=6,column=0,columnspan=4)
        self.top.bind("<Destroy>", self.destroy_mac )
        self.top.bind("<Motion>",self.mode_info )

    def build_modes(self, top, resu):
        """!Construit la liste des modes dans une boite texte"""
        freqtmp = resu.get_modes()[0]
        freq = []
        for f in freqtmp[:,1].tolist():
            freq.append('%8.2f' % f)
        text = Text( top, width=max( [len(f) for f in freq] )+1 )
        text.insert('end', "\n".join( freq ) )
        return text

    def mode_info(self, event):
        """!R�cup�re la valeur MAC de la case sous le curseur"""
        oid = self.mac.find_closest( event.x, event.y )
        if oid:
            i,j = self.mac.items.get(oid[0], (None,None) )
        else:
            return
        if i is None or i<0 or i>=len(self.modes1):
            return
        if j is None or j<0 or j>=len(self.modes2):
            return
        mode1 = self.modes1[i]
        mode2 = self.modes2[j]
        v = self.mac.mat[i,j]
#        self.displayvar1.set("( %d - %s ) / ( %d - %s )" % (mode1,txt1,mode2,txt2) )
        self.displayvar2.set("Valeur : %.5g" % (v) )

    def setlog(self):
        """!Callback du bouton radio de s�lection (log/lin�aire)"""
        if self.logvar.get():
            self.mac.show_mat( log(self.mat) )
        else:
            self.mac.show_mat( self.mat )

    def destroy_mac(self, event):
        """!Callback appel� lors de la fermeture de la fenetre par l'utilisateur"""
        if "."+self.top.winfo_name()==event.widget:
            self.root.destroy_mac_window( self )

    def __del__(self):
        """!Pour verifier que la fenetre est bien liberee"""
        print "Bye"


    

class MessageBoxInteractif(Frame):
    """!Classe dans laquelle on stocke la fentre de message (string)
    et qui permet d'ecrire dans un .mess separe si l'utilisateur en a fait
    la demande"""
    
    def __init__(self, root, unite):
        Frame.__init__(self, root, borderwidth=0,relief='flat')
        titre = Label(self, text='Fenetre de messages' )
        titre.grid(row=0,column=0,columnspan=2)
        self.columnconfigure(0,weight=1)
        self.rowconfigure(1,weight=1)
        affich = Frame(self, relief='flat', borderwidth=0)
        affich.grid(row=1,sticky='w'+'e'+'s'+'n')
        affich.columnconfigure(0,weight=1)
        affich.rowconfigure(0,weight=1)
        scroll = Scrollbar ( affich, orient='vertical' )
        scroll.grid ( row=0, column=1, sticky='n'+'s' )
        self.txt = Text(affich,yscrollcommand=scroll.set,background='white',height=5)
        scroll["command"] = self.txt.yview
        self.txt.grid( row=0, column=0, sticky='w'+'e'+'s'+'n')
        self.unite = unite
        if unite:
            self.mess_file = open('fort.'+str(unite),'w')
        else:
            self.mess_file = open('fort.'+str(98),'w') 
#            self.mess_file = StringIO.StringIO()


    def disp_mess(self, new_mess):
        """!Ecriture des messages dans le fichier sortie
        s'il existe et dans la fenetre de message"""
        if new_mess[-1:]!="\n":
            new_mess += "\n"
        self.txt.insert(END, new_mess)
        self.txt.see(END)
        self.mess_file.writelines( new_mess )

