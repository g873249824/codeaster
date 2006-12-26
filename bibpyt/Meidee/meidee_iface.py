#@ MODIF meidee_iface Meidee  DATE 22/12/2006   AUTEUR BODEL C.BODEL 
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


from Tkinter import Frame, Label, Menubutton, Menu, StringVar, IntVar, Listbox
from Tkinter import Toplevel, Scrollbar, Radiobutton, Button, Entry
from Tkinter import Checkbutton, Canvas, Text
from Numeric import minimum, maximum, array, arange
from Cata.cata import IMPR_FONCTION, CREA_TABLE
from Accas import _F
import sys

palette = [ "#%02x%02x%02x" % (i, 255-i, 0) for i in range(256) ]




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
        Frame.__init__(self,root,relief='solid',borderwidth=4)
        self.labels = {}
        self.objects = None
        #root.grid_propagate(0)
        self.tabnum = StringVar()
        for i, name in enumerate(tablabels):
            self.columnconfigure(i,weight=1)
            b = Radiobutton(self, text=name, value=name, relief='solid',
                            variable=self.tabnum,
                            command=self.switch_tab).grid(row=0,column=i)
            self.labels[name] = [ b, None ]

        self.rowconfigure(0, weight=0)
        self.rowconfigure(1, weight=1)

        self.main = Frame(self, relief='ridge', borderwidth=4)
        self.main.rowconfigure(0, weight=1 )
        self.main.columnconfigure(0, weight=1 )
        self.main.grid(row=1, column=0, columnspan=i+1, sticky='w'+'e'+'s'+'n')
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
        self.objects.new_objects()
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

    def fill_modes(self, val, anum ):
        """!Remplit une liste de modes avec les num�ros/fr�quences pass�s en param�tres
        
        \param lst un objet ListBox
        \param afreq une liste extraite par un EXTR_TABLE (indice,valeur) des fr�quences
        \param anum une liste extraite par un EXTR_TABLE (indice,valeur) des num�ros de mode
        """
        self.modes_list.delete(0,'end')
        for i in xrange(val.shape[0]):
            s = "%3d - %.3f" % (anum[i,1], val[i,1])
            self.modes_list.insert( 'end', s )

#-------------------------------------------------------------------------------            
    
class MultiList(Frame):
    """!Widget permettant de g�rer plusieurs listes (colonnes) synchronis�e
    sur la meme barre de d�filement
    """
    def __init__(self, root, labels, format = None ):
        """!Constructeur

        \param root Fenetre parente
        \param labels Les titres des colonnes
        \param format Chaines de formattage pour les valeurs des listes (%s par d�faut)
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
    def __init__(self, root, options, var, cmd=None ):
        """!Constructeur

        \param root Le widget parent
        \param options une liste des choix du menu
        \param var La variable de selection associ�e
        \param cmd Le callback associ� (si diff�rent de ``None``)
        """
        Menubutton.__init__( self, root, textvariable=var, relief='raised' )
        var.set("Choisir")
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


class HLabelledItem(Frame):
    """!Classe helper permettant de cr�er un widget et son label horizontalement"""
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

def PlotXMGrace(abscisse, ordonnees, couleur, legende):
    """!Sortie des donn�es sur une courbe XMGrace

    \param abscisse abscisses du graphe
    \param ordonnees tableau de valeurs
    """
    _tmp = []
    for i in range(len(ordonnees)):
        _tmp.append( { 'ABSCISSE': abscisse,
                       'ORDONNEE': tuple(ordonnees[i].tolist()),
                       'LEGENDE':legende[i],
                       'COULEUR': couleur[i] } )

    motscle= {'COURBE': _tmp}

    
    IMPR_FONCTION(FORMAT='XMGRACE',
                  PILOTE='INTERACTIF',
                  TITRE='Courbe',
                  SOUS_TITRE='Sous-titre',
                  LEGENDE_X='Fr�quence',
                  LEGENDE_Y='Amplitude',
                  **motscle
                  );


def CreaTable(mcfact, titre, paras_out, mess):
    """!Sortie des donn�es sous forme de sd_table"""
    num = Compteur()
    TablesOut = paras_out["TablesOut"]
    TypeTable = paras_out["TypeTables"]
    DeclareOut = paras_out["DeclareOut"]
    
    if not TablesOut[num.cpt]:
        mess.disp_mess("!! Il n'y a plus de noms de concepts     !!")
        mess.disp_mess("!! disponibles pour sortir des r�sultats !!")
        mess.disp_mess(" ")
        return
    DeclareOut('__TAB', TablesOut[num.cpt])
    
    __TAB = CREA_TABLE(LISTE=mcfact,
                       TITRE = titre,
                       TYPE_TABLE=TypeTable[num.cpt])

    mess.disp_mess("Les r�sultats sont sauv�s dans la table " + TablesOut[num.cpt].nom)
    mess.disp_mess("Cette table porte pour titre : " + titre)
    mess.disp_mess(" ")

    return __TAB


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
        if unite:
            self.unite = unite #unite d'ecriture
            self.mess_file = open('fort.'+str(unite),'w')
##            sys.stdout = self.mess_file
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
        
class MacMode:
    """!Trac� d'une matrice de MAC

    Cet objet accepte un canvas produit par Tk. sa m�thode
    display permet de redessiner une matrice sur ce canvas

    Cette classe est destin�e � etre utilis�e par meidee_help.MacWindow
    
    """
    def __init__(self, canvas):
        """!Constructeur

        \param canvas l'objet canvas Tkinter
        
         - items la liste des labels
         - mat la matrice des valeurs � repr�senter
        """
        # l'objet canvas que l'on controle
        self.canvas=canvas
        # la liste des labels
        self.items = {}
        # la matrice des valeurs � repr�senter
        self.mat = None
        
    def show_mat(self, mat):
        """!Change la matrice � afficher"""
        self.mat = mat
        self.display()

    def display(self):
        """!Redessine le contenu de la matrice"""
        self.clear()
        mat = self.mat
        n,m = mat.shape
        width = self.canvas.winfo_width()
        height = self.canvas.winfo_height()
        xc = width*arange(0., n+1, 1.)/(n+1)
        yc = height*arange(0., m+1, 1.)/(m+1)
        _min = minimum.reduce
        _max = maximum.reduce
        cmin = _min(mat.flat)
        cmax = _max(mat.flat)
        for i in range(n):
            for j in range(m):
                v = int(255*(mat[i,j]-cmin)/(cmax-cmin))
                col = palette[v]
                rid=self.canvas.create_rectangle( xc[i], yc[j], xc[i+1], yc[j+1], fill=col )
                self.items[rid] = (i,j)

    def clear(self):
        """!Efface les �l�ments du canvas (les cases)"""
        for i in self.items:
            self.canvas.delete(i)
        self.items = {}

    def resize_ok(self):
        """!Attache l'�v�nement "<Configure>" qui permet d'etre pr�venu d'un redimensionnement
        de la fenetre"""
        self.canvas.bind("<Configure>", self.configure )

    def configure(self, event):
        """!Callback appel� lors du redimensionnement
        
        dans ce cas on recr�e le canvas en prenant en compte les nouvelles
        dimensions
        """
        if self.mat:
            self.display()            

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
    def __init__(self, root, label, modes1, modes2, mat, name1=None, name2=None ):
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
         - `top`: la fenetre toplevel qui contient l'interface
        """
        from Tkinter import Canvas
        self.root = root
        self.mat = mat
        top = self.top = Toplevel()
        top.rowconfigure(1, weight=1)
        top.columnconfigure(0, weight=1)

        # Titre
        titre = Label( top, text=label )
        titre.grid(row=0, column=0, columnspan=4, sticky='n' )

        # Graphique
        canvas = Canvas( top )
        canvas.grid( row=2, column=0, sticky='w'+'e'+'s'+'n' )
        self.modes1 = modes1
        self.modes2 = modes2

        # Label abcisse/ordonn�e
        if not name1:
            name1 = "1"
        if not name2:
            name2 = "2"
        Label(top,text=name1).grid(row=1, column=0, sticky='e')
        Label(top,text=name2).grid(row=3, column=1)

        # Tableau de modes
        text1 = self.build_modes(top,modes1)
        text1.grid( row=2, column=1 )
        text2 = self.build_modes(top,modes2)
        text2.grid( row=2, column=2 )

        # Switch log/lin
        self.logvar = IntVar()
        logmode = Checkbutton(top,text="Log",variable=self.logvar, command=self.setlog )
        logmode.grid( row=4,column=0,columnspan=4)
        self.mac = MacMode( canvas )
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

    def build_modes(self, top, modes):
        """!Construit la liste des modes dans une boite texte"""
        text = Text( top, width=max( [len(m) for m in modes[1] ] )+1 )
        text.insert('end', "\n".join( modes[1] ) )
        return text

    def mode_info(self, event):
        """!R�cup�re la valeur MAC de la case sous le curseur"""
        oid = self.mac.canvas.find_closest( event.x, event.y )
        if oid:
            i,j = self.mac.items.get(oid[0], (None,None) )
        else:
            return
        if i is None or i<0 or i>=len(self.modes1[0]):
            return
        if j is None or j<0 or j>=len(self.modes2[0]):
            return
        mode1 = self.modes1[0][i]
        txt1 = self.modes1[1][i]
        mode2 = self.modes2[0][j]
        txt2 = self.modes2[1][j]
        v = self.mac.mat[i,j]
        self.displayvar1.set("( %d - %s ) / ( %d - %s )" % (mode1,txt1,mode2,txt2) )
        self.displayvar2.set("%.5g" % (v) )

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


    
