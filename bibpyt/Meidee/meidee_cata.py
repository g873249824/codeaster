#@ MODIF meidee_cata Meidee  DATE 12/07/2010   AUTEUR BERARD A.BERARD 
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

# RESPONSABLE BODEL C.BODEL

##On definit dans ce module python des classes associ�es � des objets aster,
##permettant leur manipulation en python (pour le calcul num�rique).
## - Classe Resultat : regroupe tous les objets sd_resultat. Elle est d�vou�e
##   mode_meca, grace � des m�thodes telles get_modes() qui r�cup�re les
##   caract�ristiques modales
## - CaraElem
## - ChampMateriau
## - InterSpectre : regroupe les matrices python et l'objet Aster. Les calculs inverses
##   d'effort sont faits sur des matrices python. Les concepts Aster sont cr��s par d�faut.
##   TODO : la cr�ation des objets Aster �tant assez longue, ne les cr�er que lorsque
##   demande explicitement de les saver

import numpy

import aster
from Utilitai.Utmess import UTMESS
from Cata.cata import modele_sdaster , mode_meca, matr_asse_depl_r, maillage_sdaster
from Cata.cata import cara_elem, cham_mater, table_sdaster, table_fonction
from Cata.cata import nume_ddl_sdaster, dyna_harmo, matr_asse_gene_r
from Accas import _F



aster.onFatalError("EXCEPTION")

#---------------------------------------------------------------------------------

class Resultat:
    """ Classe chapeau a toutes les sd_resultat traitees dans CALC_ESSAI"""
    ##TODO : mettre ici les attributs et procedures communs a tous les resus
    def __init__(self,objects,nom,obj_ast,mess):
        self.objects = objects
        self.nom = nom.strip()
        self.obj = obj_ast
        self.mess = mess
        self.cara_mod = None




class ModeMeca(Resultat):
    """!Gestion des sd_resultat d'aster

    Permet de conserver une r�f�rence sur un objet aster sd_resultat
    et permet aussi de r�cup�rer facilement les concepts aster associ�s
    tels le mod�le, le maillage, la num�rotation, matrices de masse et raideur
    """
    def __init__(self,
                 objects   = None,    # macro MeideeObjects parente
                 nom       = None,    # nom du concept aster
                 obj_ast   = None,    # concept Aster
                 mess      = None,    # fenetre de messages
                 ):
        """Constructeur"""
        Resultat.__init__(self,objects,nom,obj_ast,mess)
        self.modele_name = ""
        self.modele = None
        self.maya_name = ""
        self.maya = None
        self.nume_name = ""
        self.nume = None
        self.mass_name = ""
        self.mass = None
        self.kass_name = ""
        self.kass = None
        self.cass_name = ""
        self.cass = None
        self.nom_cham = None

        try:
            self.get_nom_cham()
        except AttributeError:
            pass

        #self.show_linked_concepts()


    def get_matrices(self):
        """ recuperation des matrices du REFD et du nume_ddl"""
        refd = aster.getvectjev( self.nom.ljust(19)+'.REFD' )
        if refd:
            self.kass_name = refd[0].strip()
            self.mass_name = refd[1].strip()
            self.cass_name = refd[2].strip()
            try:
                self.kass = self.objects.matrices[self.kass_name]
                self.mass = self.objects.matrices[self.mass_name]
                self.cass = self.objects.matrices[self.cass_name]
            except KeyError:
                pass


    def get_nume(self):
        """Recuperation de la numerotation et du nume_ddl"""
        refd = aster.getvectjev( self.nom.ljust(19)+'.REFD' )
        if refd :
          toto = refd[3][0:8]
          self.nume_name = toto.strip()
          if self.nume_name:
            self.nume = self.objects.nume_ddl[self.nume_name]



    def get_maillage(self):
        """Recherche du maillage associe au resultat"""
        if not self.nume_name:
            self.get_nume()
        if self.nume_name: # methode 1
            maillage = aster.getvectjev( self.nume_name[0:8].ljust(14)+".NUME.REFN")
            self.maya_name = maillage[0].strip()
            self.maya = self.objects.maillages[self.maya_name]
        else: # methode 2
            resu = self.nom
            liste_ordre=aster.getvectjev(resu.ljust(19)+'.ORDR')
            if not liste_ordre:
                return
            for j in liste_ordre:
                if j==0:
                    continue
                ordr = "%s.001.%06d" % (resu.ljust(8),j)
                info = aster.getvectjev(ordr.ljust(19)+".REFE")
                #print ".ORDR.REFE", info
                if info is not None:
                    if info[1].strip():
                        nom = info[1][0:8].strip()
                        self.maya_name = info[0].strip()
                        self.maya = self.objects.maillages[self.maya_name]
             

    def get_modele(self):
        """Recherche le modele associe au resultat"""
        if not self.modele:
            if aster.jeveux_exists(self.nom.ljust(19)+'.NOVA'):
                iret,ibid,modele_name = aster.dismoi('F','MODELE',self.nom,'RESULTAT')
                modele_name=modele_name.rstrip()
                if modele_name[0:1] != "#" :
                    self.modele_name = modele_name
                    self.modele = self.objects.modeles[self.modele_name]
                    return

        # Si cela ne marche pas, on passe par le maillage
        if not self.modele:
            self.get_maillage()
            for m, _mod in self.objects.modeles.items():
                if not _mod.maya_name:
                    _mod.get_maillage()
                if _mod.maya_name == self.maya_name:
                    self.modele_name = m
                    self.modele = _mod

        if not self.modele:
            UTMESS('A','MEIDEE0_8',valk=(self.nom))

    def show_linked_concepts(self):
        """!Affichage du concept r�sultats et des concepts li�s"""
        self.mess.disp_mess( ( self.nom + " : " ) )
        self.mess.disp_mess( ( ".modele" + self.modele_name ) )
        self.mess.disp_mess( ( ".maillage" +  self.maya_name ) )
        self.mess.disp_mess( ( ".nume" + self.nume_name ) )
        self.mess.disp_mess( ( ".mass" + self.mass_name ) )
        self.mess.disp_mess( ( ".kass" + self.kass_name ) )
        self.mess.disp_mess( ( " " ) )

    def get_modes_data(self):
        """ retourne pour tout type de mode_meca les caras
            dynamiques (frequences, amor...) et les nom_cmp pour
            les modes statiques quand ils le sont"""
        cara_mod = {'NUME_ORDRE':[],
                    'FREQ':[],
                    'AMOR_REDUIT':[],
                    'AMOR_GENE':[],
                    'RIGI_GENE':[],
                    'MASS_GENE':[],
                    'NUME_MODE':[], #VOIR SI ON A VRAIMENT BESOIN DE CELUI-LA. SIMPLIFIER AU MAX
                    'NOEUD_CMP':[]
                    }
        resu_stat = self.obj.LIST_PARA()['NOEUD_CMP']
        nume_ordr = self.obj.LIST_PARA()['NUME_ORDRE']
        cara_mod['NUME_MODE'] = self.obj.LIST_PARA()['NUME_MODE']
        cara_mod['NUME_ORDRE'] = self.obj.LIST_PARA()['NUME_ORDRE']

        # Rangement des donnees modales selon le type : statique ou dynamique
        # Si une donnee est incompatible avec le type (exemple : la frequence d'un mode statique), on remplit par None
        #XXX depuis issue15113, le "if/else" n'est peut-etre plus n�cessaire.
        for ind_ordr in range(len(nume_ordr)):
            liste = ['FREQ','AMOR_REDUIT','AMOR_GENE','RIGI_GENE','MASS_GENE']
            if resu_stat[ind_ordr] is not None: # mode statique
                for ind_list in liste:
                    cara_mod[ind_list].append(None)
                cara_mod['NOEUD_CMP'].append(resu_stat[ind_ordr])
            else: # mode dynamique
                for ind_list in liste:
                    cara_mod[ind_list].append(self.obj.LIST_PARA()[ind_list][ind_ordr])
                cara_mod['NOEUD_CMP'].append(None)

        self.cara_mod = cara_mod
        return cara_mod

            
            

    def extr_matr(self, extract_ddl):
        """ Extrait les champs de deformees contenus dans le resultat"""

        self.nume_phy, self.nume_mat, all_ddls = nume_ddl_phy(self, extract_ddl)

        if not self.cara_mod:
            self.cara_mod = self.get_modes_data()
        nb_mod = len(self.cara_mod['NUME_MODE']) # nb de modes

        matrice = []
        for ind_mod in range(1, nb_mod +1):
            defo  = []
            champ = crea_champ(self.obj, ind_mod, all_ddls)
            # champ est un dictionnaire avec les ddl en cl�s et les valeurs associees
            for ddl in self.nume_phy:
                defo.append(champ[ddl])
            matrice.append(defo)

        matrice = numpy.transpose(numpy.array(matrice))

        return matrice



    def show_cara_mod(self):
        cara_mod = self.get_cara_mod()
        self.mess.disp_mess(self.nom)
        self.mess.disp_mess("caracteristiques modales de" + self.nom)
        self.mess.disp_mess("NUME_ORDRE  FREQUENCE  MASS_GENE  AMOR_REDUIT  NUME_MODE")
        for ind in range(numpy.size(cara_mod,0)):
            self.mess.disp_mess("%3i        %7.5g    %7.5g        %7.5g      %3i" %tuple(cara_mod[ind,:])  )


    def get_nom_cham(self):
        """ Recherche le type de champ rempli dans la sd ('ACCE', 'DEPL'...)"""
        desc = self.obj.DESC.get()
        if desc :
          for ind_cham in range(len(desc)):
            tach = self.obj.TACH.get()[ind_cham+1]
            if tach[0].strip():
                self.nom_cham = desc[ind_cham].strip()
                return
        # cette m�thode sert a PROJ_MESUR_MODAL dans MACRO_EXPANS : on ne garde
        # donc qu'un seul nom symbolique. Par ordre d�croissant de priorit� :
        # 'DEPL', 'VITE', 'ACCE', etc...


#-----------------------------------------------------------------------------------------

class DynaHarmo(Resultat):
    """ pour les resultats de type dyna_harmo"""

    def __init__(self,                objects = None,    # macro MeideeObjects parente
                 nom     = None,    # nom du concept aster
                 obj_ast = None,    # concept Aster
                 mess    = None,    # fenetre de messages
                 ):
        Resultat.__init__(self,objects,nom,obj_ast,mess)
        """Constructeur"""
        self.cara_mod = None
        self.modele_name = ""
        self.modele = None
        self.maya_name = ""
        self.maya = None
        self.nume_name = ""
        self.nume = None
        self.mass_name = ""
        self.mass = None
        self.kass_name = ""
        self.kass = None
        self.mess = mess
        self.nom_cham = None
        self.nume_ddl = None

        try:
            self.get_nom_cham()
        except AttributeError:
            pass

    def extr_freq(self):
        vari_acces = zip(self.obj.LIST_VARI_ACCES()['NUME_ORDRE'],
                         self.obj.LIST_VARI_ACCES()['FREQ'])
        return vari_acces

    def get_modele(self):
        """ Recherche du modele associe au resultat harmonique"""
        if not self.modele:
          if aster.getvectjev(self.nom.ljust(19) + '.MODL') :
            self.modele_name = aster.getvectjev(self.nom.ljust(19) + '.MODL')[0].strip()
            if len(self.modele_name) > 0:
                self.modele = self.objects.modeles[self.modele_name]

        # TODO : cas ou le resultat dyn n'a pas ete cree avec l'info sur
        # le modele (exemple : LIRE_RESU, avec mot-cle MAILLAGE). Dans ce cas
        # il faut aller chercher la nom du maillage dans
        # 'nom      .00X.000001.REFE', et aller chercher le modele avec le nom
        # du maillage.

    def get_maillage(self):
        desc = self.obj.DESC.get()
        for ind_cham in range(3):
            # on ne s'interesse qu'aux champ 'DEPL','VITE' et 'ACCE' pour gagner du temps
          if self.obj.TACH.get() :
            tach = self.obj.TACH.get()[ind_cham+1][0]
            if tach.strip():
               refe = self.nom.ljust(8)+".%03i.000001.REFE" %(ind_cham+1)
               if aster.getvectjev(refe):
                   self.maya_name = aster.getvectjev(refe)[0].strip()
               self.maya = self.objects.maillages[self.maya_name]

    def get_nume(self):
        """ Recherche d'un nume_ddl. Le pb est qu'il n'est pas n�cessaire
            d'avoir un nume_ddl pour faire un dyna_harmo. On cherche donc
            le maillage associ� au resultat et on regarde quel nume
            poss�de ce meme maillage"""

        self.get_maillage()
        for nume in self.objects.nume_ddl.keys():
            refe = nume.ljust(14)+'.NUME.REFN'
            if aster.getvectjev(refe):
                nom_maya = aster.getvectjev(refe)[0].strip() # maillage associe au nume_ddl
                if nom_maya == self.maya_name:
                    self.nume_ddl_name = nume
                    self.nume_ddl = self.objects.nume_ddl[nume]
        return self.nume_ddl
            
    def get_nom_cham(self):
        """ Recherche le type de champ rempli dans la sd ('ACCE', 'DEPL'...)"""
        desc = self.obj.DESC.get()
        if desc :
          for ind_cham in range(len(desc)):
            tach = self.obj.TACH.get()[ind_cham+1]
            if tach[0].strip():
                self.nom_cham = desc[ind_cham].strip()
                return self.nom_cham
        # cette m�thode sert a PROJ_MESU_MODAL dans MACRO_EXPANS : on ne garde
        # donc qu'un seul nom symbolique. Par ordre d�croissant de priorit� :
        # 'DEPL', 'VITE', 'ACCE', etc...
            
        


#-----------------------------------------------------------------------------------------

class CaraElem:
    """!Gestions des cara modales"""
    CARTES = [
        "CARARCPO",
        "CARCABLE",
        "CARCOQUE",
        "CARDISCA",
        "CARDISCK",
        "CARDISCM",
        "CARGENBA",
        "CARGENPO",
        "CARGEOBA",
        "CARGEOPO",
        "CARMASSI",
        "CARORIEN",
        "CARPOUFL",
        ]

    def __init__(self, nom, obj, mess ):
        self.nom = nom
        self.obj = obj
        self.mess = mess

    def maillages(self):
        maillages = []
        for carte in CaraElem.CARTES:
            ncham = self.nom.ljust(8)+"."+carte.ljust(10)+".NOMA"
            maill = aster.getvectjev( ncham.ljust(32) )
            if maill:
                for m in maill:
                    if m not in maillages:
                        maillages.append(m)
        return maillages


#-------------------------------------------------------------------------------------

class ChampMateriau:
    """!Gestion d'un concept champ_mater"""
    def __init__(self, nom, obj, mess):
        self.nom = nom
        self.obj = obj
        self.mess = mess

    def maillage(self):
        ncham = self.nom.ljust(8)+".CHAMP_MAT .NOMA        "
        maill = aster.getvectjev( ncham.ljust(32) )
        if maill is not None:
            return maill[0]
        return ""

#--------------------------------------------------------------------------------------

class InterSpectre:
    """!Gestion des concepts de type table interspectrale

    Regroupe les concepts aster de type table interspectrale :
    - Diff�rencie les tabl_instp des autres tables tabl_sdaster,
    - Extrait les tabl_intsp sous forme d'une matrice python interspectrale
    - Cr�e un lien entre les num�rotations des ddl de cette matrice
      avec les num�rotations d'un mod�le EF. ex : la ligne/colonne 3 de la
      matrice interspectrale correspond au noeud 1DZ du mod�le
    - Cr�e une table inter-spectrale sd_aster � partir d'une matrice python
         - Cr�e une table inter-spectrale sd_aster � partir d'une matrice python
        On peut cr�er une table avec le nom, la table format aster (obj_ast) ou la matrice
        format python (mat)
    """
    def __init__(self,
                 nom        = None,
                 obj_ast    = None,
                 mat        = None,
                 frequences = [],
                 mess       = None,
                 var_opt    = None
                 ):
        self.nom = nom.strip()                # nom aster de la sd
        self.obj = obj_ast                    # objet aster (� remplir ou � fabriquer)
        self.matr_inte_spec = mat             # matrice inter-spectrale format python
        self.intsp = 0                        # vaut 1 si la table est un intsp, 0 sinon
        self.var_opt(var_opt)                 # definit self.opt : vaut 1 si les modeles sont d�finis
        self.f = frequences
        self.resu_name = ""
        self.resu = None
        self.maya_name = ""
        self.maya = None
        self.nume_name = ""
        self.nume_phy = None
        self.nume_gene = None
        self.mass_name = ""
        self.mass = None
        self.kass_name = ""
        self.kass = None
        self.options_meth = ["Efforts discrets localises",
                             "Efforts et moments discrets"]
        self.mess = mess

        #-- genere une erreur si pas OK -> on passe par Tempo

        if len(self.f) == 0:
            self.extr_freq()
        self.intsp = 1

#        try:
#            if len(self.f) == 0:
#                self.extr_freq()
#            self.intsp = 1
#
#        except KeyError:
#            print "test NOOK"
#            # Cas o� la table_sdaster n'est pas une tabl_intsp
#            #pass # TODO : faire en sorte que cette table ne soit pas visible

    def make_inte_spec(self, titre, paras_out):
        """
        Fabrique un objet aster de type table inter-spectre :
         - Creation de n(n+1)/2 fonctions, o� n = dim(matrice interspectrale)
         - Creation d'une table
        """
        from Cata.cata import DEFI_FONCTION
        dim = self.matr_inte_spec.shape[1]
        nb_freq = len(self.f)
        l_fonc = []
        nume_ordr = []
        for i in range(dim):
            for j in range(i,dim):
                fonc = []
                for ind_freq in range(nb_freq):
                    fonc.append(self.f[ind_freq])
                    fonc.append(self.matr_inte_spec[ind_freq,i,j].real)
                    fonc.append(self.matr_inte_spec[ind_freq,i,j].imag)
                nume_ordr.append([int(i),int(j)])

                _fonc=DEFI_FONCTION( NOM_PARA   ="FREQ",
                                     NOM_RESU   ="DSP",
                                     INTERPOL   ="NON",
                                     INFO       =1,
                                     VALE_C     =fonc,)
                l_fonc.append(_fonc.nom)

        nume_ordr = numpy.array(nume_ordr)
        nume_i = nume_ordr[:,0]
        nume_j = nume_ordr[:,1]
        mcfact=[]
        mcfact.append(_F(PARA='NOM_CHAM'    ,LISTE_K=('DSP')   ,NUME_LIGN=(1,)))
        mcfact.append(_F(PARA='OPTION'      ,LISTE_K=('TOUT',) ,NUME_LIGN=(1,)))
        mcfact.append(_F(PARA='DIMENSION'   ,LISTE_I=(dim,)    ,NUME_LIGN=(1,)))
        if isinstance(self.resu, Resultat):
            # Si on associe l'inter-spectre � un r�sultat,
            # on range les fonctions par rapport aux noeuds et composantes
            if not self.nume_phy:
                self.nume_phy, self.nume_mat, bid = nume_ddl_phy(self.resu)
            ddl = self.nume_phy
            noeu_i = []
            noeu_j = []
            cmp_i = []
            cmp_j = []
            for ind in range(len(nume_i)):
                li = ddl[nume_i[ind]].split("_")
                lj = ddl[nume_j[ind]].split("_")
                noeu_i.append(li[0])
                noeu_j.append(lj[0])
                cmp_i.append(li[1])
                cmp_j.append(lj[1])
            mcfact.append(_F(PARA='NOEUD_I',LISTE_K=noeu_i  ,NUME_LIGN=range(2,len(nume_i)+2)))
            mcfact.append(_F(PARA='NOEUD_J',LISTE_K=noeu_j  ,NUME_LIGN=range(2,len(nume_j)+2)))
            mcfact.append(_F(PARA='NOM_CMP_I',LISTE_K=cmp_i   ,NUME_LIGN=range(2,len(nume_i)+2)))
            mcfact.append(_F(PARA='NOM_CMP_J',LISTE_K=cmp_j   ,NUME_LIGN=range(2,len(nume_j)+2)))
        else:
            mcfact.append(_F(PARA='NUME_ORDRE_I',LISTE_I=(1+nume_i).tolist()    ,NUME_LIGN=range(2,len(nume_i)+2)))
            mcfact.append(_F(PARA='NUME_ORDRE_J',LISTE_I=(1+nume_j).tolist()    ,NUME_LIGN=range(2,len(nume_j)+2)))
        mcfact.append(_F(PARA='FONCTION_C'  ,LISTE_K=l_fonc             ,NUME_LIGN=range(2,len(l_fonc)+2)))

        self.obj = CreaTable(mcfact, titre,
                             paras_out,
                             self.mess,
                            )

    def def_inte_spec(self, intsp):
        """ Associe une table intsp aster � l'instance de InterSpectre"""
        self.obj = intsp

    def def_nom(self, nom):
        """ Associe un nom (self.nom) � l'InterSpectre"""
        self.nom = nom

    def var_opt(self, opt):
        if opt =='Efforts discrets localises':
            self.opt = 0
        elif opt =='Efforts et moments discrets':
            self.opt = 1
        else:
            self.opt = 0



    def set_model(self, resu):
        """Lie l'inter-spectre au concept mode_meca OBS. Permet de lier les
        lignes et colonnes de l'inter-spectre aux DDL des deformees modales
        et de tout ranger dans le bon ordre. Si l'inter-spectre est defini
        avec des numeros d'ordre, alors on suppose qu'ils sont rang�s dans le bon
        ordre.
        """
        self.resu = resu


    def extr_inte_spec(self, resu, extract_ddl):
        """!Extraction d'une matrice inter-spectrale � partir d'une tabl_insp"""
        from Cata.cata import RECU_FONCTION
        from Cata.cata import DETRUIRE
        self.mess.disp_mess("Extraction de l'inter-spectre " + self.nom)
        self.mess.disp_mess(" ")
        tabl_py = self.obj.EXTR_TABLE()
        nom_fonc= tabl_py['FONCTION_C'].values()['FONCTION_C']
        nb_freq = len(self.f)

        self.set_model(resu)
        self.nume_phy, self.nume_mat, bid = nume_ddl_phy(resu, extract_ddl)
        nb_mes = len(self.nume_phy)

        # il doit y avoir coherence de longueur entre taille de l'inter-spectre et le nombre de DDL du resu
        if nb_mes*(nb_mes+1)/2 != len(nom_fonc):
            nb_mes_intsp = 0.5*(-1+numpy.sqrt(1+8*len(nom_fonc)))
            self.mess.disp_mess(" Nombre de mesures de CPhi : " + str(int(nb_mes)))
            self.mess.disp_mess(" Nombre de mesures de l'inter-spectre : "
                                + str(int(nb_mes_intsp)))
            self.mess.disp_mess(" ")
            raise TypeError

        self.matr_inte_spec = numpy.zeros((nb_freq, nb_mes, nb_mes), complex)

        coupl_ddl = []
        try:
            # Cas ou l'inter-spectre est defini par ses noeuds et composantes
            noeudi  = tabl_py['NOEUD_I'].values()['NOEUD_I']
            noeudj  = tabl_py['NOEUD_J'].values()['NOEUD_J']
            cmpi    = tabl_py['NOM_CMP_I'].values()['NOM_CMP_I']
            cmpj    = tabl_py['NOM_CMP_J'].values()['NOM_CMP_J']
            ddli = []
            ddlj = []
            for ind in range(len(cmpi)):
                coupl_ddl.append( (noeudi[ind].split()[0] + '_' + cmpi[ind].split()[0],
                                   noeudj[ind].split()[0] + '_' + cmpj[ind].split()[0]) )
            isnume = 1
        except KeyError:
            # l'inter-spectre n'est d�fini qu'avec des num�ros d'ordre ind�pendants du mod�le
            numi  = tabl_py['NUME_ORDRE_I'].values()['NUME_ORDRE_I']
            numj  = tabl_py['NUME_ORDRE_J'].values()['NUME_ORDRE_J']
            coupl_ddl.append((numi,numj))
            isnume = 0


        try:
            # Methode de recherche rapide des fonctions
            ctx = CONTEXT.get_current_step().get_contexte_courant()
            fonc_py = [ ctx[fonc].convert('complex') for fonc in nom_fonc ]
        except KeyError:
            fonc_py = []
            ind_fonc = 0
            nb_fonc = nb_mes*(nb_mes+1)/2
            for ind_fonc in range(nb_fonc):
                __FONC = RECU_FONCTION( TABLE = self.obj,
                                        NOM_PARA_TABL = 'FONCTION_C',
                                        FILTRE = _F(NOM_PARA='FONCTION_C',VALE_K=nom_fonc[ind_fonc])
                                       )
                fonc_py.append( __FONC.convert('complex'))
                DETRUIRE( CONCEPT = _F( NOM = __FONC ),INFO=1 )
                ind_fonc = ind_fonc + 1

        # Rangement dans l'ordre des fonctions (par rapport � la num�rotation du self.resu)
        nume = self.nume_phy
        for ind_coupl in range(len(coupl_ddl)):
            try:
                ind_l = nume.index(coupl_ddl[ind_coupl][0])
                ind_c = nume.index(coupl_ddl[ind_coupl][1])
            except ValueError:

                raise TypeError
            for ind_freq in range(nb_freq):
                self.matr_inte_spec[ind_freq,ind_l,ind_c] = fonc_py[ind_coupl].vale_y[ind_freq]
                if ind_l != ind_c:
                    self.matr_inte_spec[ind_freq,ind_c,ind_l] = numpy.conjugate(self.matr_inte_spec[ind_freq,ind_l,ind_c])



    def extr_freq(self):
        """Extraction des fr�quences d'�tude dans la tabl_intsp qui contient
        les inter-spectres mesur�s"""
        from Cata.cata import RECU_FONCTION
        from Cata.cata import DETRUIRE
        tabl_py=self.obj.EXTR_TABLE()
        toto=tabl_py['FONCTION_C']
        nom_fonc = toto.values()['FONCTION_C'][0]
        __FONC = RECU_FONCTION(TABLE = self.obj,
                               NOM_PARA_TABL = 'FONCTION_C',
                               FILTRE = _F(NOM_PARA='FONCTION_C',VALE_K=nom_fonc)
                               )
        freq=__FONC.Absc()
        DETRUIRE(CONCEPT=_F(NOM=__FONC),INFO=1)
        self.f = freq
        self.intsp = 1

#--------------------------------------------------------------------------------------

class Tempo:
    """!Gestion des concepts de type table_fonction contenant des temporels

    Regroupe les concepts aster de type table_fonction :
    - Diff�rencie les tabl_fonc des autres tables tabl_sdaster,
    - Extrait les tabl_fonc sous forme d'une matrice python de temporels
    - Cr�e un lien entre les num�rotations des ddl de cette matrice
      avec les num�rotations d'un mod�le EF. ex : la ligne/colonne 3 de la
      matrice interspectrale correspond au noeud 1DZ du mod�le
#    - Cr�e une table inter-spectrale sd_aster � partir d'une matrice python
#         - Cr�e une table inter-spectrale sd_aster � partir d'une matrice python
#        On peut cr�er une table avec le nom, la table format aster (obj_ast) ou la matrice
#        format python (mat)
    """
    def __init__(self,
                 nom        = None,
                 obj_ast    = None,
                 tempo      = None,
                 nume_ordr  = None,
                 nume_mes   = None,
                 temps      = [],
                 mess       = None,
                 var_opt    = None
                 ):
        self.nom = nom.strip()                # nom aster de la sd
        self.obj = obj_ast                    # objet aster (� remplir ou � fabriquer)
        self.list_tempo = tempo               # liste de liste de liste format python contenant les temporels
        self.nume_ordr  = nume_ordr           # liste contenant les numeros d'ordre auxquels sont rataches les tempo
        self.nume_mes   = nume_mes            # liste contenant les numeros de mesures pour chaque numero d'ordre
        self.tempo = 0                        # vaut 1 si la table est un tempo, 0 sinon
        self.var_opt(var_opt)                 # definit self.opt : vaut 1 si les modeles sont d�finis
        self.t = temps
        self.resu_name = ""
        self.resu = None
        self.maya_name = ""
        self.maya = None
        self.nume_name = ""
        self.nume_phy = None
        self.nume_gene = None
        self.mass_name = ""
        self.mass = None
        self.kass_name = ""
        self.kass = None
        self.options_meth = ["Efforts discrets localises",
                             "Efforts et moments discrets"]
        self.mess = mess


        try:
            if len(self.t) == 0:
                self.extr_temps()
            self.ech_t = 1  # self.intsp = 1
            
        except KeyError:
            # Cas o� la table_sdaster n'est pas un Tempo
            pass # TODO : faire en sorte que cette table ne soit pas visible



    def def_tempo(self, tempo):
        """ Associe une table intsp aster � l'instance de InterSpectre"""
        self.obj = tempo

    def def_nom(self, nom):
        """ Associe un nom (self.nom) � l'InterSpectre"""
        self.nom = nom

    def var_opt(self, opt):
        if opt =='Efforts discrets localises':
            self.opt = 0
        elif opt =='Efforts et moments discrets':
            self.opt = 1
        else:
            self.opt = 0



    def set_model(self, resu):
        """Lie le temporel au concept mode_meca OBS. Permet de lier les
        catalogues de temporels aux DDL des deformees modales
        et de tout ranger dans le bon ordre. Si les temporels sont definis
        avec des numeros d'ordre, alors on suppose qu'ils sont rang�s dans le bon
        ordre.
        """
        self.resu = resu


    def extr_tempo(self):
    
        """!Recuperation d'une table_fonction pour creer un catalogue de temporels"""
        from Cata.cata import RECU_FONCTION
        from Cata.cata import DETRUIRE
        self.mess.disp_mess("Recuperation des informations sur les temporels " + self.nom)
        self.mess.disp_mess(" ")
        tabl_py = self.obj.EXTR_TABLE()
        self.nom_fonc   = tabl_py['FONCTION'].values()['FONCTION']
        self.nume_ordr  = tabl_py['NUME_ORDRE_I'].values()['NUME_ORDRE_I']
        self.nume_mes   = tabl_py['NUME_MES'].values()['NUME_MES']



    def extr_temps(self):
        """Extraction des instants d'�tude dans la Tempo qui contient
        les temporels mesur�s"""
        from Cata.cata import RECU_FONCTION
        from Cata.cata import DETRUIRE
        tabl_py=self.obj.EXTR_TABLE()
        toto=tabl_py['FONCTION']
        nom_fonc = toto.values()['FONCTION'][0]
        __FONC = RECU_FONCTION(TABLE = self.obj,
                               NOM_PARA_TABL = 'FONCTION',
                               FILTRE = _F(NOM_PARA='FONCTION',VALE_K=nom_fonc)
                               )
        temps=__FONC.Absc()
        DETRUIRE(CONCEPT=_F(NOM=__FONC),INFO=1)
        self.t = temps
        self.tempo = 1


#---------------------------------------------------------------------------------------------

class Modele:
    """!Gestion des concepts de type modele_sdaster
        Notamment une routine qui permet de fabriquer un nume_ddl
        a partir d'un modele pour les rojtines de type PROJ_CHAMP
    """
    def __init__(self,
                 objects    = None,
                 nom        = None,
                 obj_ast    = None,
                 mess       = None,
                 nume_ddl   = None,
                 ):
        self.objects = objects                # les concepts existants dans le jdc
        self.nom = nom.strip()                # nom aster de la sd
        self.obj = obj_ast                    # objet aster
        self.nume_ddl = nume_ddl              # Nom d'un nume_ddl associe au modele
        self.mess = mess                      # fenetre de messages
        self.maya = None
        self.maya_name = ""


    def get_maillage(self):
        if self.obj.MODELE.LGRF.exists:
            _maillag = self.obj.MODELE.LGRF.get()
            self.maya_name = _maillag[0].strip()
            self.maya = self.objects.maillages[self.maya_name]
        else:
            pass


    def get_nume(self):
        """Recherche des nume_ddl qui depend de ce modele
        """
        if self.nume_ddl == None:
            for nume_name, nume in self.objects.nume_ddl.items():
                model = aster.getvectjev(nume_name.ljust(14) + ".NUME.LILI")
                if not model:
                    pass
                elif model[1][:8] == self.nom:
                    self.nume_ddl = nume
                    self.nume_ddl_name = nume_name
                    return
            ## TODO : creation automatique d'un nume_ddl pour les resu exp
            ## avec des caras bidons.


    def make_nume(self):
        """Fabrication d'un nume ddl pour des modeles experimentaux
           avec des cara_elem et affe_materiau pipos
        """
        ## TODO : ce n'est pas tres simple : il faut aller chercher les modelisations
        ## de AFFE_MODELE, et associer les bons cara_elem : BARRE, DIS_T, DIS_TR...
        pass

    def set_extraction_ddl(self, ddls):
        self.extraction_ddl = ddls



#---------------------------------------------------------------------------------------------


class MeideeObjects:
    """!Classe qui recupere les objets pouvant etre utilises par
    meidee dans le catalogue aster"""

    def __init__(self, macro, mess):
        """!Constructeur

        \param macro Le self de la macro qui utilise cet objet
        """
        self.mess = mess
        self.modeles = {}
        self.maillages = {}
        self.groupno = {}
        self.resultats = {}
        self.dyna_harmo = {}
        self.mode_meca = {}
        self.matrices = {}
        self.maillage_modeles = {}
        self.groupno_maillage = {}
        self.cara_elem = {}
        self.cham_mater = {}
        self.inter_spec = {}
        self.list_tempo = {}
        self.nume_ddl = {}
        self.macro = macro
        self.weakref = []
        self.recup_objects()
        self.grno = {}


    def recup_objects( self ):
        self.del_weakref()
        ctx = CONTEXT.get_current_step().get_contexte_courant()

        for i, v in ctx.items():
            if isinstance( v, modele_sdaster ):
                self.modeles[i] = Modele(objects=self,nom=i,obj_ast=v,mess=self.mess)
            elif isinstance( v, mode_meca ):
                self.mode_meca[i] = ModeMeca(objects=self,nom=i,obj_ast=v,mess=self.mess)
            elif isinstance( v, dyna_harmo ):
                self.dyna_harmo[i] = DynaHarmo(objects=self,nom=i,obj_ast=v,mess=self.mess)
            elif isinstance( v, matr_asse_depl_r ) or isinstance( v, matr_asse_gene_r ):
                self.matrices[i] = v
            elif isinstance( v, maillage_sdaster ):
                self.maillages[i] = v
            elif isinstance( v, cara_elem ):
                self.cara_elem[i] = v
            elif isinstance( v, cham_mater ):
                self.cham_mater[i] = v
            elif isinstance( v, table_sdaster ):
                try : # cas d'une table frequentielle (inter-spectre)
                    self.inter_spec[i] = InterSpectre(nom = i, obj_ast = v, mess = self.mess)
                except KeyError : # cas d'une table temporelle
                    self.list_tempo[i] = Tempo(nom = i, obj_ast = v, mess = self.mess)
            elif isinstance( v, nume_ddl_sdaster ):
                self.nume_ddl[i] = v

        self.resultats = self.mode_meca.copy()
        self.resultats.update(self.dyna_harmo)

        #self.debug()
        ## Liaison des concepts entre eux (resu <=> maillage <=> modele)
        for modes_name, modes in self.mode_meca.items():
            modes.get_nume()
            modes.get_modele()
            modes.get_matrices()
            modes.get_maillage()

        for modele_name, modele in self.modeles.items():
            modele.get_maillage()
            modele.get_nume()

        for dyna_name, dyna in self.dyna_harmo.items():
            dyna.get_nume()
            dyna.get_maillage()
            dyna.get_modele()



    def update( self, name, obj ):
        """ Ajout d'un nouvel objet dans self"""
        if isinstance( obj, modele_sdaster):
            self.modeles[name] = Modele(self,name,obj,self.mess)
        if isinstance( obj, nume_ddl_sdaster):
            self.nume_ddl[name] = obj
        if isinstance( obj, maillage_sdaster):
            self.maillages[name] = obj
        if isinstance( obj, mode_meca ):
            self.mode_meca[name] = ModeMeca(self,name,obj,self.mess)
            self.mode_meca[name].get_modele()
            self.mode_meca[name].get_matrices()
            self.mode_meca[name].get_nume()
            self.mode_meca[name].get_maillage()
        if isinstance( obj, dyna_harmo ):
            self.dyna_harmo[name] = DynaHarmo(self,name,obj,self.mess)
            self.dyna_harmo[name].get_modele()
            self.dyna_harmo[name].get_nume()
            self.dyna_harmo[name].get_maillage()
        if isinstance( obj, table_sdaster ):
            try :
                self.inter_spec[name] = InterSpectre(nom = name, obj_ast = obj, mess = self.mess)
            except KeyError :
                self.list_tempo[name] = Tempo(nom = name, obj_ast = obj, mess = self.mess)
        self.resultats = self.mode_meca.copy()
        self.resultats.update(self.dyna_harmo) # dict ou on met toutes les sd resu


    def debug(self):
        self.mess.disp_mess( ( "Modeles" + self.modeles ) )
        self.mess.disp_mess( ("Maillages" + self.maillages ) )
        self.mess.disp_mess( ("Matrices" + self.matrices ) )
        self.mess.disp_mess( ("Resultats" ) )
        self.mess.disp_mess( ( " " ) )
        for v in self.resultats.values():
            v.show_linked_concepts()



    def get_groupno(self):
        """!essaye de relier les concepts entre eux"""

        # recuperation des GROUP_NO associes aux maillages
        # et association des resultats a un modele/maillage (afaire)

        for m, _mail in self.maillages.items():
            dic_gpno=aster.getcolljev(m.ljust(8)+'.GROUPENO')
            for elem in dic_gpno.keys():
                self.groupno_maillage[elem] = m
            return dic_gpno.keys()

    def get_mode_meca_name(self):
        """!Liste des objets resultat"""
        return self.mode_meca.keys()

    def get_mode_meca(self, name):
        """!Renvoie un objet resultat identifie par son nom"""
        return self.mode_meca[name]

    def get_cara_elem(self, name):
        return self.cara_elem[name]

    def get_cham_mater(self, name):
        return self.cham_mater[name]

    def get_model_name(self):
        """!Renvoie les noms de modeles dispos"""
        return self.modeles.keys()

    def get_model(self, name):
        """!Renvoie un modele"""
        return self.modeles[name]

    def get_dyna_harmo_name(self):
        return self.dyna_harmo.keys()

    def get_dyna_harmo(self,name):
        return self.dyna_harmo[name]

    def get_inter_spec_name(self):
        inter_spec = []
        for i in self.inter_spec.keys():
            if self.inter_spec[i].intsp == 1:
                inter_spec.append(i)
        return inter_spec

    def get_inter_spec(self, name):
        return self.inter_spec[name]

    def get_matr(self, name):
        """!Renvoie une matrice de masse ou raideur ou None"""
        return self.matrices.get(name)

    def get_resultats_name(self):
        """recup des noms de toutes les sd resus : mode_meca, base_modale, dyna_harmo"""
        return self.resultats.keys()

    def get_resultats(self, name):
        """recup d'une sd resu dans la liste ci-dessus"""
        return self.resultats[name]

    def get_matr_norme(self):
        normes = self.matrices.keys()
        normes[0:0] = ["Aucune"]
        return normes

    def get_matr_name(self):
        return self.matrices.keys()

    def get_cara_elem_name(self):
        return self.cara_elem.keys()

    def get_cara_elem(self, name):
        """recup d'une sd resu dans la liste ci-dessus"""
        return self.cara_elem[name]

    def get_cham_mater_name(self):
        return self.cara_elem.keys()

    def get_cham_mater(self, name):
        """recup d'une sd resu dans la liste ci-dessus"""
        return self.cham_mater[name]

    def register_weakref(self,name):
        """ garde les NOMS des concepts destin�s � �tre supprim�s � chaque
            mise � jour de meidee_objects """
        
        self.weakref.append(name)

    def del_weakref(self):
        from Cata.cata import DETRUIRE
        liste = ""
        if len(self.weakref) != 0:
            for obj in self.weakref:
                DETRUIRE(CONCEPT = _F(NOM = obj), INFO=1)
                liste = liste + ", " + obj.nom
            self.weakref = []
            self.mess.disp_mess("Destruction des objects temporaires " + liste)



##############################################################################
#
#                          PETITS UTILITAIRES
#
##############################################################################

def compt_cmp(champ, ddl_test):
    """! Permet de compter le nombre de composantes
    d'un champ aux noeuds.

    :param ddl_test: un degr� de libert� existant pour le champ."""

    nbval = len(aster.getvectjev(champ.nom.ljust(19) + '.VALE'))
    champy  = champ.EXTR_COMP(ddl_test,[],1)
    nbno = len(champy.noeud)
    nbcmp = nbval/nbno

    return nbcmp

_DDL_CONV = {
    'DX' : .01,
    'DY' : .02,
    'DZ' : .03,
    'DRX' : .04,
    'DRY' : .05,
    'DRZ' : .06
    }

def tra_comp(nume):
    """! Transforme 'N23_DX' => 23.01 (float)"""
    tmp = nume.split('_')
    numno = int(tmp[0][1:])
    ddlno = tmp[1]

    return numno + _DDL_CONV[ddlno]


def set_extraction_ddl(resu, ddls):
    """ cf utilisation de nume_ddl_phy ci-dessous"""
    maya = resu.maya
    all_ddls = []
    extraction_ddl = []
    for grp in ddls:
        # grp = {'GROUP_NO':'nom','DDL_ACTIF':['DX','DY']}
        list_no = find_no(maya,grp)
        for ddl in grp['DDL_ACTIF']:
            if ddl not in all_ddls:
                all_ddls.append(ddl)
        extraction_ddl.append({'NOEUD':list_no,
                               'DDL_ACTIF':grp['DDL_ACTIF']})

    return extraction_ddl, all_ddls

def crea_champ(resu, ind_mod, all_ddls):
    """!Extrait les champs de deplacement d'une sd_resultat aster
        a partir des DDL de mesure pour un mode donne.
        Ces DDL sont identiques a ceux de la macro OBSERVATION
        ayant servi a obtenir le resultat."""
    from Cata.cata import CREA_CHAMP
    from Cata.cata import DETRUIRE
    __CHANO = CREA_CHAMP( TYPE_CHAM = 'NOEU_DEPL_R',
                          OPERATION = 'EXTR',
                          RESULTAT = resu,
                          NOM_CHAM = 'DEPL',
                          NUME_ORDRE = ind_mod,
                        );

    champ = {}
    for ddl_key in all_ddls:
        champ_comp = __CHANO.EXTR_COMP(ddl_key, [], 1)
        noeud = champ_comp.noeud
        vale = champ_comp.valeurs
        for ind in range(len(champ_comp.noeud)):
            champ['N' + str(noeud[ind]) + '_' + ddl_key] = vale[ind]

    DETRUIRE(CONCEPT=_F(NOM=(__CHANO,),), INFO=1,)

    return champ


def nume_ddl_phy(resu, extract_ddl):
    """Fabrication de 2 numerotations liees au concept OBSERVATION cree
    pour le modele d'oservabilite. Les DDL a extraire sont donnes en entree
    sous la forme
    [{'GROUP_NO':'name1','DDL_ACTIF':['DX','DY']},{'GROUP_NO':'name2,...
    et sont changes en [{'NOEUD':('N1','N2'),'DDL_ACTIF':('DX','DY')...
    par la fonction set_extraction_ddl
    """
    nume = []
    nume_mat = []

    ddls, all_ddls = set_extraction_ddl( resu, extract_ddl )

    for ind1 in ddls:
        for noeud_id in ind1['NOEUD']:
            for ddl_key in ind1['DDL_ACTIF']:
                compo = noeud_id.strip() + "_" + ddl_key.strip()
                if compo not in nume:
                    nume.append(compo)
                    nume_mat.append(tra_comp(compo))
                else:
                    mess.disp_mess("Le concept observe possede"\
                                   "des noeuds en double. Calcul"\
                                   "impossible")
                    return

    return nume, nume_mat, all_ddls


def nume_ddl_gene(resu, extract_mode = None):
    """
    Cr�e le meme vecteur de num�rotation avec une num�rotation par modes.
    Retourne "MO"+#mode
    """
    modes = []
    nume_mode = resu.get_modes_data()['NUME_MODE']
    nb_mod = len(nume_mode)
    for mod in nume_mode:
        modes.append('MO'+str(int(mod)))
    return modes


def find_no(maya,mcsimp):
    """ mcsimp est de la forme :
        {'GROUP_MA': ('CAPTEUR1','CAPTEUR2'), 'DDL_ACTIF': ('DX', 'DRZ')}
        ou {'GROUP_NO': 'CAPTEUR1', 'DDL_ACTIF': ('DX', 'DRZ')}
    """


    if mcsimp.has_key('GROUP_NO') and type(mcsimp['GROUP_NO']) != list :
        mcsimp['GROUP_NO'] = [mcsimp['GROUP_NO']]
    if mcsimp.has_key('GROUP_MA') and type(mcsimp['GROUP_MA']) != list :
        mcsimp['GROUP_MA'] = [mcsimp['GROUP_MA']]


    list_no = []
    if mcsimp.has_key('GROUP_NO') :
        for group in mcsimp['GROUP_NO'] :
            list_ind_no = list(numpy.array(maya.GROUPENO.get()
                                             [group.ljust(8)]) - 1)
            for ind_no in list_ind_no :
                nomnoe = maya.NOMNOE.get()[ind_no]
                if nomnoe not in list_no :
                    list_no.append(nomnoe)

    elif mcsimp.has_key('GROUP_MA') :
        for group in mcsimp['GROUP_MA']:
            list_nu_ma = list(numpy.array(maya.GROUPEMA.get()
                                            [group.ljust(8)]) - 1)
            tmp = list(maya.NOMMAI.get())
            for nu_ma in list_nu_ma:
                maille = tmp[nu_ma]
                for ind_no in maya.CONNEX.get()[nu_ma +1 ]:
                    nomnoe = maya.NOMNOE.get()[ind_no - 1]
                    if nomnoe not in list_no:
                        list_no.append(nomnoe)

    return list_no


def CreaTable(mcfact, titre, paras_out, mess):
    """!Sortie des donn�es sous forme de sd_table"""
    from Cata.cata import CREA_TABLE
    TablesOut = paras_out["TablesOut"]
    TypeTable = paras_out["TypeTables"]
    DeclareOut = paras_out["DeclareOut"]
    compteur = paras_out["ComptTable"]
    paras_out["ComptTable"] = paras_out["ComptTable"] + 1

    if paras_out["ComptTable"] > len(paras_out["TablesOut"]):
        mess.disp_mess("!! Il n'y a plus de noms de concepts     !!")
        mess.disp_mess("!! disponibles pour sortir des r�sultats !!")
        mess.disp_mess(" ")
        return

    DeclareOut('__TAB', TablesOut[compteur])

    __TAB = CREA_TABLE(LISTE=mcfact,
                       TITRE = titre,
                       TYPE_TABLE=TypeTable)

    mess.disp_mess("Les r�sultats sont sauv�s dans la table "
                   + TablesOut[compteur].nom)
    mess.disp_mess("Cette table porte pour titre : " + titre)
    mess.disp_mess(" ")

    return paras_out
