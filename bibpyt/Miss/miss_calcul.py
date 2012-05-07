#@ MODIF miss_calcul Miss  DATE 07/05/2012   AUTEUR GREFFET N.GREFFET 
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
# RESPONSABLE COURTOIS M.COURTOIS

"""Module permettant le lancement d'un calcul MISS3D

Les classes d�finies sont :
    CALCUL_MISS      : classe g�n�rique d'un appel � MISS3D
    CALCUL_MISS_IMPE : sp�cialisation au calcul d'imp�dance
"""

import os
import re
import shutil
import traceback
import os.path as osp

from math import cos, sin, pi

import aster_core
import aster
from Cata.cata import MACR_ELEM_DYNA, IMPR_MACR_ELEM

from Utilitai.Utmess          import UTMESS
from Utilitai.System          import ExecCommand
from Utilitai.UniteAster      import UniteAster
from Utilitai.utils           import set_debug, _print, _printDBG
from Miss.miss_fichier_sol    import fichier_sol
from Miss.miss_fichier_option import fichier_option
from Miss.miss_resu_aster     import lire_resultat_aster
from Miss.miss_fichier_interf import fichier_mvol, fichier_chp, fichier_cmde 
from Miss.miss_fichier_interf import fichier_cmde_inci
from Miss.miss_post           import PostMissFactory, info_freq


class CALCUL_MISS(object):
    """D�finition d'un calcul MISS3D.
    """
    option_calcul = None

    def __init__(self, parent, parameters):
        """Initialisations"""
        if not self.option_calcul:
            raise NotImplementedError, "option_calcul non d�fini"
        self.parent = parent
        self.param = parameters
        self.data = None
        self.verbose = parameters['INFO'] >= 2
        self.debug = self.verbose
        if self.verbose:
            _print('Param�tres du calcul', self.param)
        if self.debug:
            from Utilitai.as_timer import ASTER_TIMER
            self.timer = ASTER_TIMER()
            set_debug(True)


    def prepare_donnees(self):
        """Pr�paration des donn�es
        """
        self.cree_reptrav()
        self.cree_resultat_aster()
        self.cree_fichier_mvol()
        self.cree_fichier_chp()
        self.cree_fichier_sol()
        self.cree_commande_miss()
        self.cree_fichier_option()
        # lib�rer la structure contenant les donn�es num�riques
        self.init_data()

    def init_data(self):
        """Lib�rer la structure contenant les donn�es num�riques
        """
        self.data = None


    def execute(self):
        """Ex�cute MISS3D.
        """
        self._dbg_trace("Start")
        
        copie_fichier(self._fichier_tmp("in"), osp.join(self.param['_WRKDIR'], "MISS.IN"))
        cmd = osp.join(aster_core.get_option('repout'), "run_miss3d") + " " + self.param['VERSION']
        
        try:
            os.chdir(self.param['_WRKDIR'])
            if self.verbose:
                _print("Ex�cution de MISS3D dans :", self.param['_WRKDIR'])
                os.system('ls -la')
            comment = "Lancement de la commande :\n%s" % cmd
            if self.verbose:
                aster.affiche("MESSAGE", comment)
            iret, output, error = ExecCommand(cmd, alt_comment=comment,
                                              verbose=False, separated_stderr=True)
            if self.verbose:
                _print("Contenu du r�pertoire apr�s l'ex�cution de MISS3D :")
                os.system('ls -la')
        finally:
            os.chdir(self.param['_INIDIR'])
        UTMESS('I', 'EXECLOGICIEL0_9',  valk=output)
        miss_out = ""
        if osp.exists(self._fichier_tmp("OUT")):
            miss_out = open(self._fichier_tmp("OUT"), "r").read()
        is_ok = iret == 0 and miss_out.find("INSUFFISAN") < 0
        if not is_ok:
            aster.affiche("MESSAGE", miss_out)
        if not is_ok:
            UTMESS('I', 'EXECLOGICIEL0_10', valk=error, print_as='E')
            raise aster.error('EXECLOGICIEL0_3', vali=[0, iret])
        self._dbg_trace("Stop")


    def post_traitement(self):
        """Op�rations de post-traitement.
        """
        self._dbg_trace("Start")
        self.fichier_resultat()

        post = PostMissFactory(self.param['TYPE_RESU'], self.parent, self.param)
        post.argument()
        post.execute()
        post.sortie()
        # n�cessaire s'il y a deux ex�cutions Miss dans le m�me calcul Aster
        self.menage()
        self._dbg_trace("Stop")
        if self.debug:
            print self.timer


    def fichier_resultat(self):
        """Copie les fichiers r�sultats dans les unit�s logiques."""
        if self.param['UNITE_IMPR_ASTER'] and osp.exists(self._fichier_tmp("aster")):
            copie_fichier(self._fichier_tmp("aster"),
                          self._fichier_aster(self.param['UNITE_IMPR_ASTER']))
        if osp.exists(self._fichier_tmp("resu_impe")):
            copie_fichier(self._fichier_tmp("resu_impe"),
                          self._fichier_aster(self.param['UNITE_RESU_IMPE']))
        if osp.exists(self._fichier_tmp("resu_forc")):
            copie_fichier(self._fichier_tmp("resu_forc"),
                          self._fichier_aster(self.param['UNITE_RESU_FORC']))


    def cree_reptrav(self):
        """Cr�ation du r�pertoire d'ex�cution de MISS.
        """
        if not osp.exists(self.param['_WRKDIR']):
            os.makedirs(self.param['_WRKDIR'])


    def menage(self):
        """Suppression des fichiers/r�pertoires de travail.
        """
        if osp.exists(self.param['_WRKDIR']) and self.param['REPERTOIRE'] is None:
            shutil.rmtree(self.param['_WRKDIR'])


    def cree_resultat_aster(self):
        """Produit le(s) fichier(s) issu(s) d'Aster."""
        self._dbg_trace("Start")
        UL = UniteAster()
        ulaster = UL.Libre(action='ASSOCIER')
        mael = self.param['MACR_ELEM_DYNA']
        if mael is None:
            opts = {}
            if self.param['MATR_RIGI']:
                opts['MATR_RIGI'] = self.param['MATR_RIGI']
            if self.param['MATR_MASS']:
                opts['MATR_MASS'] = self.param['MATR_MASS']
            __mael = MACR_ELEM_DYNA(BASE_MODALE=self.param['BASE_MODALE'],
                                    **opts)
            mael = __mael
        IMPR_MACR_ELEM(MACR_ELEM_DYNA=mael,
                       FORMAT='MISS_3D',
                       GROUP_MA_INTERF=self.param['GROUP_MA_INTERF'],
                       SOUS_TITRE='PRODUIT PAR CALC_MISS',
                       UNITE=ulaster,)
        UL.EtatInit()
        copie_fichier(self.param.UL.Nom(ulaster), self._fichier_tmp("aster"))

        self.data = lire_resultat_aster(self._fichier_tmp("aster"))
        self._dbg_trace("Stop")


    def cree_fichier_mvol(self):
        """Produit le fichier de maillage.
        """
        self._dbg_trace("Start")
        content = fichier_mvol(self.data)
        open(self._fichier_tmp("mvol"), "w").write(content)
        self._dbg_trace("Stop")


    def cree_fichier_chp(self):
        """Produit le fichier chp (modes statiques, dynamiques...).
        """
        self._dbg_trace("Start")
        content = fichier_chp(self.data)
        open(self._fichier_tmp("chp"), "w").write(content)
        self._dbg_trace("Stop")


    def cree_fichier_sol(self):
        """Ecrit le fichier de sol.
        """
        self._dbg_trace("Stop")
        if self.param['TABLE_SOL'] is not None:
            tabsol = self.param['TABLE_SOL'].EXTR_TABLE()
            sol_content = fichier_sol(tabsol, self.param)
            if self.verbose:
                _print('Fichier de sol', sol_content)
            open(self._fichier_tmp("sol"), 'w').write(sol_content)
        self._dbg_trace("Stop")


    def cree_commande_miss(self):
        """Produit le fichier de commandes Miss.
        """
        self._dbg_trace("Start")
        lfich = ("mvol", "chp", "sol", "resu_impe", "resu_forc")
        lfich = map(self._fichier_tmp, lfich)
        # chemins relatifs au _WRKDIR sinon trop longs pour Miss
        lfich = map(osp.basename, lfich)
       
        content = fichier_cmde(self.param, self.data, *lfich)
        open(self._fichier_tmp("in"), "w").write(content)
        self._dbg_trace("Stop")


    def cree_fichier_option(self):
        """Ecrit le fichier OPTMIS."""
        self._dbg_trace("Start")
        option_content = fichier_option(self.param)
        if self.verbose:
            _print("Fichier d'option", option_content)
        open(self._fichier_tmp("optmis"), 'w').write(option_content)
        self._dbg_trace("Stop")


    # --- utilitaires internes
    def _fichier_tmp(self, ext):
        """Retourne le nom d'un fichier MISS dans WRKDIR.
        """
        fich = '%s.%s' % (self.param['PROJET'], ext)
        return osp.join(self.param['_WRKDIR'], fich)

    def _fichier_tmp_local(self, ext):
        """Retourne le nom d'un fichier MISS en local.
        """
        fich = '%s.%s' % (self.param['PROJET'], ext)
        return osp.join('./', fich)


    def _fichier_aster(self, unite):
        """Nom du fichier d'unit� logique unite dans le r�pertoire d'ex�cution de Code_Aster.
        """
        return osp.join(self.param['_INIDIR'], "fort.%d" % unite)


    def _dbg_trace(self, on_off):
        if not self.debug:
            return
        stack = traceback.format_stack(limit=5)[-2]
        mat = re.search('File [\'\"]*(.*?)[\'\"]*, *line ([0-9]+), *in (.*)', stack)
        getattr(self.timer, on_off)("CALC_MISS." + mat.group(3))



class CALCUL_MISS_IMPE(CALCUL_MISS):
    """D�finition d'un calcul MISS3D de type MISS_IMPE
    """
    option_calcul = 'MISS_IMPE'


class CALCUL_MISS_POST(CALCUL_MISS):
    """D�finition d'une ex�cution de CALC_MISS o� seul le
    post-traitement est demand�.
    """
    option_calcul = 'POST-TRAITEMENT'

    def prepare_donnees(self):
        """Pr�paration des donn�es."""


    def execute(self):
        """Ex�cute MISS3D."""


    def fichier_resultat(self):
        """Copie les fichiers r�sultats dans les unit�s logiques."""


class CALCUL_MISS_FICHIER_TEMPS(CALCUL_MISS):
    """D�finition d'une ex�cution de CALC_MISS dans le domaine de Laplace.
    """
    option_calcul = 'IMPE_LAPL'

    def init_attr(self):
        """Initialisations"""
        self.dt = self.param['PAS_INST']
        N_inst = int(self.param['INST_FIN']/self.param['PAS_INST'])
        if N_inst % 2 != 0 :
            UTMESS('F','MISS0_18')
        eps = self.param['PRECISION']
        self.rho = eps**(1./(2.*N_inst))
        factor = self.param['COEF_SURECH']
        self.L_points = factor*N_inst
        self.nbr_freq = self.L_points/2 + 1

        # Noms des fichiers � utiliser
        
        lfich = ( "impe_Laplace", "forc_Laplace" )
        lfich = map(self._fichier_tmp, lfich)
        # chemins relatifs au _WRKDIR sinon trop longs pour Miss
        lfich = map(osp.basename, lfich)
        
        self._fname = lfich[0]
        self._fname2 = lfich[1]
        
        lfich = ("resu_impe", "resu_forc")
        lfich = map(self._fichier_tmp, lfich)
        self._fichier_impe = lfich[0]
        self._fichier_forc = lfich[1]

        # Variables � rajouter dans 'param'
        self.param.set('LIST_FREQ', None)
        self.param.set('FREQ_IMAG', None)
        # Nombre de modes (dynamiques) d'interface
        modes_nb = self.data.mode_stat_nb 
        self.param.set('NB_MODE', modes_nb)
         
        # Creation du fichier sol 
        self.param.set('FICHIER_SOL_INCI', self._fichier_tmp_local("sol.inci"))
         
    
    def execute(self):
        """Ex�cute MISS3D : calcul du champ incident + boucle sur les fr�quences complexes"""
        self.init_attr()

        if self.param['EXCIT_SOL']:
            copie_fichier(self._fichier_tmp("inci"), self._fichier_tmp("in"))
            aster.affiche("MESSAGE",'LANCEMENT DU CALCUL DE LA FORCE SISMIQUE EN FREQUENCE')
            CALCUL_MISS.execute(self)
            copie_fichier(self._fichier_tmp("OUT"), self._fichier_tmp("OUT.inci"))
            copie_fichier(self._fichier_tmp("sol"), self._fichier_tmp("sol.inci"))
            fd = open(self._fname2, 'w')
            text = open(self._fichier_forc, 'r').read()
            fd.write(text)
            fd.close()
            copie_fichier(self._fichier_forc, self._fichier_aster(self.param['EXCIT_SOL']['UNITE_RESU_FORC']))
        
        fd = open(self._fname, 'w')
        CALCUL_MISS.cree_fichier_sol(self)
        aster.affiche("MESSAGE",'BOUCLE SUR LES FREQUENCES COMPLEXES')
        self._exec_boucle_lapl(fd)
        fd.close()                     

   
    def _exec_boucle_lapl(self,fd): 
        """Ex�cute MISS3D dans une boucle sur toutes les fr�quences complexes"""
        L_points = self.L_points
        dt = self.dt
        rho = self.rho

        for k in range(0, self.nbr_freq):
            if (k == 0) or (k == self.nbr_freq - 1):
                self.param.set('LIST_FREQ', (0.1E-4,) )
                self.param.set('FREQ_IMAG',(1.5-2.0*rho*cos(2*pi*k/L_points)+0.5*rho*rho*cos(4*pi*k/L_points) )/dt )         
                # 'sin','cos','pi' imported from MATH
            else:
                self.param.set('LIST_FREQ', (-(-2.0*rho*sin(2*pi*k/L_points)+0.5*rho*rho*sin(4*pi*k/L_points))/dt/(2*pi),) )
                # 'sin','cos','pi' imported from MATH
                self.param.set('FREQ_IMAG',(1.5-2.0*rho*cos(2*pi*k/L_points)+0.5*rho*rho*cos(4*pi*k/L_points) )/dt )
                # 'sin','cos','pi' imported from MATH

            CALCUL_MISS.cree_commande_miss(self)
            str00 = str(self.param['FREQ_IMAG'])+' + i . '+str(self.param['LIST_FREQ'][0])+' ('+str(k+1)+'/'+str(self.nbr_freq)+')'
            aster.affiche("MESSAGE",'FREQUENCE COMPLEXE COURANTE =  '+str00)
            CALCUL_MISS.execute(self)
            
            text = open(self._fichier_impe, 'r').read()
            fd.write(text)
            
        # lib�rer la structure contenant les donn�es num�riques
        CALCUL_MISS.init_data(self)


    def cree_commande_miss(self):
        """Produit le fichier de commandes Miss du champ incident (.inci)
        """
        self._dbg_trace("Start")
        lfich = ("mvol", "chp", "sol", "resu_impe", "resu_forc")
        lfich = map(self._fichier_tmp, lfich)
        # chemins relatifs au _WRKDIR sinon trop longs pour Miss
        lfich = map(osp.basename, lfich)
        # Execute m�thode associ�e au champ incident
        content = fichier_cmde_inci(self.param, self.data, *lfich)
        open(self._fichier_tmp("inci"), "w").write(content)
        self._dbg_trace("Stop")


    def fichier_resultat(self):
        """Lib�rer la structure contenant les donn�es num�riques
        """
        if self.param['UNITE_IMPR_ASTER'] and osp.exists(self._fichier_tmp("aster")):
            copie_fichier(self._fichier_tmp("aster"),
                          self._fichier_aster(self.param['UNITE_IMPR_ASTER']))


    def init_data(self):
        """Lib�rer la structure contenant les donn�es num�riques
        """
        pass


def CalculMissFactory(parent, param):
    """Cr�e l'objet CALCUL_MISS pour r�soudre l'option demand�e.
    """
    if param['TYPE_RESU'] == 'FICHIER_TEMPS':
        return CALCUL_MISS_FICHIER_TEMPS(parent, param)
    elif param['TYPE_RESU'] != 'FICHIER' \
        and not param['_exec_Miss']:
        return CALCUL_MISS_POST(parent, param)
    else:
        return CALCUL_MISS_IMPE(parent, param)


def copie_fichier(src, dst):
    """Copie d'un fichier.
    """
    if src and dst:
        try:
            shutil.copyfile(src, dst)
        except:
            raise aster.error('MISS0_6', valk=(src, dst))




