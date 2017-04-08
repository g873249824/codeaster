# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: mathieu.courtois at edf.fr

"""Commande CALC_FONCTION"""

import os
import traceback
import math

import numpy as NP

from Noyau.N_types import force_list
from Noyau.N_utils import AsType
from code_aster.Cata.Syntax import _F
from code_aster.Cata.DataStructure import fonction_sdaster, fonction_c, nappe_sdaster

from Cata_Utils.t_fonction import (
    t_fonction, t_nappe,
    homo_support_nappe, enveloppe, fractile, moyenne,
    FonctionError, ParametreError, InterpolationError, ProlongementError,
)
from Utilitai import liss_enveloppe as LISS
from Utilitai.calc_coherency import calc_cohefromdata
from Utilitai.random_signal_utils import (ACCE2SRO, DSP2SRO, SRO2DSP,
                                acce_filtre_CP, f_phase_forte)

from Utilitai.Utmess import UTMESS, ASSERT
from Macro.defi_inte_spec_ops import tocomplex

def calc_fonction_ops(self, **args):
    """Corps de la macro CALC_FONCTION"""
    self.set_icmd(1)
    # éléments de contexte
    ctxt = Context()

    operation = CalcFonctionOper.factory(self, ctxt, args)
    try:
        operation.run()
    except InterpolationError, msg:
        UTMESS('F', 'FONCT0_27', valk=(ctxt.f, str(msg)))
    except ParametreError, msg:
        UTMESS('F', 'FONCT0_28', valk=(ctxt.f, str(msg)))
    except ProlongementError, msg:
        UTMESS('F', 'FONCT0_29', valk=(ctxt.f, str(msg)))
    except FonctionError, msg:
        UTMESS('F', 'FONCT0_30',
               valk=(ctxt.f, str(msg), traceback.format_exc()))

class CalcFonctionOper(object):
    """Base of all CALC_FONCTION operations.

    Subclasses must implement the '_run' method and, if necessary, may
    overload the '_build_data' method.
    """

    @staticmethod
    def factory(macro, ctxt, kwargs):
        """Factory that returns the operation object
        Subclasses must be named 'CalcFonction_KEYWORD'
        """
        types = CalcFonctionOper.__subclasses__()
        try:
            for class_ in types:
                keyw = class_.__name__.replace('CalcFonction_', '')
                if kwargs[keyw]:
                    return class_(macro, keyw, ctxt, kwargs)
        except KeyError:
            UTMESS('F', 'DVP_1')

    def __init__(self, macro, oper, ctxt, kwargs):
        """Initialization"""
        self.macro = macro
        self.oper = oper
        self.ctxt = ctxt
        self.args = kwargs
        self.kw = self.args[self.oper]
        self.resu = None
        self._lf = []
        self._dat = None
        self.typres = AsType(macro.sd)

    def _build_data(self):
        """Read keywords to build the data"""
        self._build_list_fonc()

    def _run(self):
        """Use the input functions from 'self._lf' and the data from
        'self._dat' to compute the result function 'self.resu'."""
        raise NotImplementedError('must be defined in a subclass')

    def run(self):
        """Run the operator"""
        self._build_data()
        self.ctxt.f = [func.nom for func in self._lf]
        self._run()
        self.build_result()

    def build_result(self):
        """Create the result function"""
        macr = self.macro
        DEFI_FONCTION = macr.get_cmd('DEFI_FONCTION')
        IMPR_FONCTION = macr.get_cmd('IMPR_FONCTION')
        DEFI_NAPPE = macr.get_cmd('DEFI_NAPPE')
        macr.DeclareOut('result', macr.sd)
        # common keywords to DEFI_FONCTION & DEFI_NAPPE
        para = self.resu.para
        for p in ('NOM_PARA', 'NOM_RESU', 'PROL_DROITE', 'PROL_GAUCHE',
                  'INTERPOL'):
            if self.args[p] is not None:
                para[p] = self.args[p]

        if self.typres is not nappe_sdaster:
            if self.typres is fonction_c:
                mcval = 'VALE_C'
            else:
                mcval = 'VALE'
            para[mcval] = self.resu.tabul()
            result = DEFI_FONCTION(**para)
        else:
            intf = self.args['INTERPOL_FONC']
            prdf = self.args['PROL_DROITE_FONC']
            prgf = self.args['PROL_GAUCHE_FONC']
            def_fonc = []
            for f_i in self.resu.l_fonc :
                def_fonc.append(_F(VALE=f_i.tabul(),
                                   INTERPOL=intf or f_i.para['INTERPOL'],
                                   PROL_DROITE=prdf or f_i.para['PROL_DROITE'],
                                   PROL_GAUCHE=prgf or f_i.para['PROL_GAUCHE'],))
            npf = 'NOM_PARA_FONC'
            if self.args[npf] is not None:
                para[npf] = self.args[npf]
            result = DEFI_NAPPE(PARA=self.resu.vale_para.tolist(),
                                DEFI_FONCTION=def_fonc,
                                **para)
        if self.args['INFO'] > 1:
            IMPR_FONCTION(FORMAT='TABLEAU', UNITE=6,
                          COURBE=_F(FONCTION=result),)

    # utilities
    def _use_list_para(self):
        """Interpolate using LIST_PARA."""
        if self.args['LIST_PARA'] is not None:
            self.resu = self.resu.evalfonc(self.args['LIST_PARA'].Valeurs())

    def _get_mcsimp(self, mcsimp):
        """Return the list of mcsimp values for all occurrences of mcfact."""
        # only one occurrence of MCFACT or only one value in MCSIMP
        value = []
        try:
            nbmf = len(self.kw)
        except AttributeError:
            nbmf = 1
        for mcf in self.kw:
            val = force_list(mcf[mcsimp])
            assert nbmf == 1 or len(val) == 1, (nbmf, val)
            value.extend(val)
        return value

    def _build_list_fonc(self, arg='real', mcsimp='FONCTION'):
        """Return the list of functions under mcfact/mcsimp converted
        as t_fonction objects.
        nappe_sdaster objects are interpolated on the same abscissa."""
        lf_in = self._get_mcsimp(mcsimp)
        all_nap = min([int(AsType(i) is nappe_sdaster) for i in lf_in]) == 1
        if all_nap:
            list_fonc = [tf.convert() for tf in lf_in]
            list_fonc = homo_support_nappe(list_fonc)
        else:
            list_fonc = [tf.convert(arg) for tf in lf_in]
        self._lf = list_fonc


class CalcFonction_ABS(CalcFonctionOper):
    """Return absolute value"""
    def _run(self):
        """ABS"""
        self.resu = self._lf[0].abs()

class CalcFonction_ASSE(CalcFonctionOper):
    """Concatenate two functions"""
    def _run(self):
        """ASSE"""
        assert len(self._lf) == 2, 'exactly 2 functions required'
        fo0, fo1 = self._lf
        self.resu = fo0.cat(fo1, self.kw['SURCHARGE'])

class CalcFonction_COMB(CalcFonctionOper):
    """Combinate real functions."""
    def _run(self):
        """COMB_C"""
        coef = self._get_mcsimp('COEF')
        self.resu = 0.
        for item, cfr in zip(self._lf, coef):
            self.ctxt.f = item.nom
            self.resu = item * cfr + self.resu
        # take the parameters of the first function
        self.resu.para = self._lf[0].para.copy()
        self._use_list_para()

class CalcFonction_COMB_C(CalcFonctionOper):
    """Combinate complex functions."""
    def _build_data(self):
        """Read keywords to build the data"""
        self._build_list_fonc(arg='complex')
        coefr = self._get_mcsimp('COEF_R')
        coefc = self._get_mcsimp('COEF_C')
        self._dat = { 'R' : coefr, 'C' : coefc }

    def _run(self):
        """COMB_C"""
        self.resu = 0.
        for item, cfr, cfc in zip(self._lf, self._dat['R'], self._dat['C']):
            coef = 1.
            if cfr is not None:
                coef = complex(cfr)
            elif cfc is not None:
                coef = cfc
                if type(cfc) in (list, tuple):
                    coef = tocomplex(cfc)
            self.ctxt.f = item.nom
            self.resu = item * coef + self.resu
        # take the parameters of the first function
        self.resu.para = self._lf[0].para.copy()
        self._use_list_para()

class CalcFonction_COMPOSE(CalcFonctionOper):
    """Compose two functions"""
    def _build_data(self):
        """Read keywords to build the data"""
        self._dat = (self.kw['FONC_RESU'].convert(),
                     self.kw['FONC_PARA'].convert())

    def _run(self):
        """COMPOSE"""
        fo1, fo2 = self._dat
        self.resu = fo1[fo2]
        self.resu.para['NOM_PARA'] = fo2.para['NOM_PARA']

class CalcFonction_CORR_ACCE(CalcFonctionOper):
    """CORR_ACCE"""
    def _run(self):
        """CORR_ACCE"""
        f_in = self._lf[0]
        kw = self.kw
        para = f_in.para.copy()
        assert kw['METHODE'] in ('FILTRAGE', 'POLYNOME')
        if kw['METHODE'] == 'POLYNOME':
            # suppression de la tendance de l accelero
            fres = f_in.suppr_tend()
            # calcul de la vitesse
            fres = fres.trapeze(0.)
            # calcul de la tendance de la vitesse : y = a1*x +a0
            fres = fres.suppr_tend()
            if self.kw['CORR_DEPL'] == 'OUI':
                # suppression de la tendance deplacement
                # calcul du deplacement : integration
                fres = fres.trapeze(0.)
                # calcul de la tendance du déplacement : y = a1*x +a0
                fres = fres.suppr_tend()
                # regeneration de la vitesse : derivation
                fres = fres.derive()
            # regeneration de l accelero : derivation
            self.resu = fres.derive()
            self.resu.para = para
        elif kw['METHODE'] == 'FILTRAGE':
            dt=f_in.vale_x[1]-f_in.vale_x[0]
            acce_filtre = acce_filtre_CP(f_in.vale_y, dt, kw['FREQ_FILTRE'],)
            self.resu = t_fonction(f_in.vale_x, acce_filtre, para)


class CalcFonction_DERIVE(CalcFonctionOper):
    """Derivation"""
    def _run(self):
        """DERIVE"""
        self.resu = self._lf[0].derive()

class CalcFonction_ENVELOPPE(CalcFonctionOper):
    """Return the envelop function"""
    def _run(self):
        """ENVELOPPE"""
        crit = self.kw['CRITERE']
        if self.typres is nappe_sdaster:
            nap0 = self._lf[0]
            vale_para = nap0.vale_para
            para = nap0.para
            l_fonc_f = []
            for i in range(len(vale_para)):
                env = nap0.l_fonc[i]
                for nap in self._lf[1:]:
                    self.ctxt.f = nap.l_fonc[i].nom
                    env = enveloppe([env, nap.l_fonc[i]], crit)
                l_fonc_f.append(env)
            self.resu = t_nappe(vale_para, l_fonc_f, para)
        else:
            self.resu = enveloppe(self._lf, crit)

class CalcFonction_EXTRACTION(CalcFonctionOper):
    """Extract real/imaginary part"""
    def _build_data(self):
        dconv = { 'REEL' : 'real', 'IMAG' : 'imag',
                  'MODULE' : 'modul', 'PHASE' : 'phase' }
        arg = dconv[self.kw['PARTIE']]
        self._build_list_fonc(arg=arg)

    def _run(self):
        """EXTRACTION"""
        self.resu = self._lf[0]

class CalcFonction_FFT(CalcFonctionOper):
    """Fast Fourier Transform"""
    def _build_data(self):
        """Read keywords to build the data"""
        opts = {}
        if self.typres is fonction_sdaster:
            opts['arg'] = 'complex'
        self._build_list_fonc(**opts)

    def _run(self):
        """FFT"""
        kw = self.kw
        if self.typres is fonction_c:
            self.resu = self._lf[0].fft(kw['METHODE'])
        else:
            self.resu = self._lf[0].fft(kw['METHODE'], kw['SYME'])

class CalcFonction_INTERPOL_FFT(CalcFonctionOper):
    """Zero padding method"""
    def _build_data(self):
        """Read keywords to build the data"""
        opts = {}
        #if self.typres is fonction_sdaster:
            #opts['arg'] = 'complex'
        self._build_list_fonc(**opts)

    def _run(self):
        """INTERPOL_FFT"""
        import copy
        kw = self.kw
        t0 = self._lf[0].vale_x[0]

        dt_init = self._lf[0].vale_x[1]-t0
        N_init = len(self._lf[0].vale_x)

        dt_cible = kw['PAS_INST']
        if dt_init < dt_cible:
            UTMESS('F','FONCT0_35')
        # nombre d'intervalles
        N_init-=1
        N_sortie=int((N_init)*dt_init/dt_cible)

        if N_init*dt_init/dt_cible - N_sortie >= 0.5:
            N_sortie+=1
        # retour au nombre de valeurs
        N_sortie+=1

        # FFT
        ft = self._lf[0].fft('COMPLET')

        # suppression de la partie symetrique du signal
        N = len(ft.vale_x)
        valex = list(ft.vale_x[:N/2+1])
        valey = list(ft.vale_y[:N/2+1])

        # zero padding
        dfreq = (valex[1]-valex[0]).real
        last_freq = valex[-1]
        N_pad = N_sortie/2+1-N/2-1
        for i in range(N_pad):
            freq = last_freq + (i+1)* dfreq
            valex.append(freq)
            valey.append(0.)
        ft.vale_x = NP.array(valex)
        ft.vale_y = NP.array(valey)

        # IFFT
        self.resu = ft.fft('COMPLET', 'NON')
        self.resu.vale_x = self.resu.vale_x + t0

        # dt fin reel
        dt_fin = self.resu.vale_x[1]-self.resu.vale_x[0]

        # normalisation
        coef_norm = dt_init/dt_fin
        self.resu.vale_y = self.resu.vale_y * coef_norm

        ecart = abs(dt_fin-kw['PAS_INST'])/kw['PAS_INST']
        if ecart > kw['PRECISION']:
            UTMESS('A','FONCT0_51', valr=[dt_fin, kw['PAS_INST'], 100*ecart])

class CalcFonction_FRACTILE(CalcFonctionOper):
    """Compute the fractile of functions"""
    def _run(self):
        """FRACTILE"""
        fract = self.kw['FRACT']
        if self.typres is nappe_sdaster:
            nap0 = self._lf[0]
            vale_para = nap0.vale_para
            para = nap0.para
            l_fonc_f = []
            for i in range(len(vale_para)):
                self.ctxt.f = [nap.l_fonc[i].nom for nap in self._lf]
                lfr = fractile([nap.l_fonc[i] for nap in self._lf], fract)
                l_fonc_f.append(lfr)
            self.resu = t_nappe(vale_para, l_fonc_f, para)

        else:
            self.resu = fractile(self._lf, fract)

class CalcFonction_MOYENNE(CalcFonctionOper):
    """Compute the mean of functions"""
    def _run(self):
        """MOYENNE"""
        if self.typres is nappe_sdaster:
            nap0 = self._lf[0]
            vale_para = nap0.vale_para
            para = nap0.para
            l_fonc_f = []
            for i in range(len(vale_para)):
                self.ctxt.f = [nap.l_fonc[i].nom for nap in self._lf]
                lfr = moyenne([nap.l_fonc[i] for nap in self._lf])
                l_fonc_f.append(lfr)
            self.resu = t_nappe(vale_para, l_fonc_f, para)
        else:
            self.resu = moyenne(self._lf)


class CalcFonction_COHERENCE(CalcFonctionOper):
    """Compute the coherency function of two sets of signals"""
    def _build_data(self):
        """Read keywords to build the data"""
        self._build_list_fonc(mcsimp='NAPPE_1')
    def _run(self):
        """COHERENCE"""
        Mm = self.kw['NB_FREQ_LISS']
        FREQ_COUP  = self.kw['FREQ_COUP']
        para = {
            'INTERPOL': ['LIN', 'LIN'], 'NOM_PARA': 'FREQ',
            'PROL_DROITE': 'CONSTANT', 'PROL_GAUCHE': 'EXCLU',
            'NOM_RESU': 'ACCE'}
        nap1 = self._lf[0]
        assert nap1.para['NOM_PARA'] == 'NUME_ORDRE'
        vale_para1 = nap1.vale_para
        nap2 = self.kw['NAPPE_2']
        vale_para2, lfonc2 = nap2.Valeurs()
        assert len(vale_para1) == len(vale_para2), 'NAPPE_1 and NAPPE_2 must have same length.'
        assert set(vale_para2) == set(vale_para1), 'Data lists are not ordered as pairs.'

        acce1 = []
        acce2 = []
        for ii, fonc2 in enumerate(lfonc2):
            lt = nap1.l_fonc[ii].vale_x
            fonc1 = nap1.l_fonc[ii].vale_y
            assert len(lt) == len(fonc2[0]), 'Signals with same length required for NUME_ORDRE '+str(vale_para1[ii])
            assert (fonc2[0][1]-fonc2[0][0]) == (lt[1]-lt[0]), 'same time steps required'
            if self.kw['OPTION'] == "DUREE_PHASE_FORTE":
                if ii == 0:
                    p1 = self.kw['BORNE_INF']
                    p2 = self.kw['BORNE_SUP']
                    N1, N2 = f_phase_forte(lt, fonc1, p1, p2)
                    UTMESS('I', 'SEISME_79',  valr=(lt[N1], lt[N2]))
                acce2.append(fonc2[1][N1:N2])
                acce1.append(fonc1[N1:N2])
            else :
                acce2.append(fonc2[1])
                acce1.append(fonc1)
        acce1 = NP.array(acce1)
        acce2 = NP.array(acce2)
        dt = lt[1]-lt[0]
        lfreq, fcohe = calc_cohefromdata(acce1, acce2, dt, Mm)
        N1 = NP.searchsorted(lfreq, 0.0)
        N2 = len(lfreq)
        if FREQ_COUP != None:
            if lfreq[-1] > FREQ_COUP:
                N2 = NP.searchsorted(lfreq, FREQ_COUP)
                print self.kw['FREQ_COUP'], N2
        f_cohe = fcohe[N1:N2]
        l_freq = lfreq[N1:N2]
        self.resu = t_fonction(l_freq, f_cohe.real, para)

class CalcFonction_INTEGRE(CalcFonctionOper):
    """Integration"""
    def _run(self):
        """INTEGRE"""
        f_in = self._lf[0]
        kw = self.kw
        assert kw['METHODE'] in ('TRAPEZE', 'SIMPSON')
        if kw['METHODE'] == 'TRAPEZE':
            self.resu = f_in.trapeze(kw['COEF'])
        elif kw['METHODE'] == 'SIMPSON':
            self.resu = f_in.simpson(kw['COEF'])

class CalcFonction_INVERSE(CalcFonctionOper):
    """Reverse"""
    def _run(self):
        """INVERSE"""
        self.resu = self._lf[0].inverse()

class CalcFonction_MULT(CalcFonctionOper):
    """Multiply the given functions."""
    def _build_data(self):
        """Read keywords to build the data"""
        opts = {}
        if self.typres is fonction_c:
            opts['arg'] = 'complex'
        self._build_list_fonc(**opts)

    def _run(self):
        """MULT"""
        self.resu = 1.
        for item in self._lf:
            self.ctxt.f = item.nom
            self.resu = item * self.resu
        # take the parameters of the first function
        self.resu.para = self._lf[0].para.copy()
        self._use_list_para()

class CalcFonction_PUISSANCE(CalcFonctionOper):
    """Compute f^n"""
    def _run(self):
        """PUISSANCE"""
        self.resu = self._lf[0]
        for i in range(self.kw['EXPOSANT'] - 1):
            self.resu = self.resu * self._lf[0]

class CalcFonction_SPEC_OSCI(CalcFonctionOper):
    """SPEC_OSCI"""
    def _build_data(self):
        """Read keywords to build the data"""
        CalcFonctionOper._build_list_fonc(self)
        kw = self.kw
        self._dat = {}
        # amor
        if kw['AMOR_REDUIT'] is None:
            l_amor = [0.02, 0.05, 0.1]
            UTMESS('I', 'FONCT0_31', valr=l_amor)
        else:
            l_amor = force_list(kw['AMOR_REDUIT'])
        eps = 1.e-6
        for amor in l_amor:
            if amor > (1 - eps):
                UTMESS('S', 'FONCT0_36')
        self._dat['AMOR'] = l_amor
        # freq
        if kw['LIST_FREQ'] is not None:
            l_freq = kw['LIST_FREQ'].Valeurs()
        elif kw['FREQ'] is not None:
            l_freq = force_list(kw['FREQ'])
        else:
            l_freq = []
            for i in range(56):
                l_freq.append(0.2 + 0.050 * i)
            for i in range(8):
                l_freq.append(3.0 + 0.075 * i)
            for i in range(14):
                l_freq.append(3.6 + 0.100 * i)
            for i in range(24):
                l_freq.append(5.0 + 0.125 * i)
            for i in range(28):
                l_freq.append(8.0 + 0.250 * i)
            for i in range(6):
                l_freq.append(15.0 + 0.500 * i)
            for i in range(4):
                l_freq.append(18.0 + 1.0 * i)
            for i in range(10):
                l_freq.append(22.0 + 1.500 * i)
            texte = []
            for i in range(len(l_freq) / 5):
                texte.append(' %f %f %f %f %f' % tuple(l_freq[i * 5:i * 5 + 5]))
            UTMESS('I', 'FONCT0_32', vali=len(l_freq), valk=os.linesep.join(texte))
        if min(l_freq) < 1.E-10:
            UTMESS('F', 'FONCT0_43')
        self._dat['FREQ'] = l_freq
        # check
        if abs(kw['NORME']) < 1.E-10:
            UTMESS('S', 'FONCT0_33')
        if kw['NATURE_FONC'] == 'DSP':
            ASSERT(kw['METHODE'] == 'RICE')

    def _run(self):
        """SPEC_OSCI"""
        import aster_fonctions
        f_in = self._lf[0]
        l_freq, l_amor = self._dat['FREQ'], self._dat['AMOR']
        kw = self.kw
        l_fonc_f = []
        # construction de la nappe
        vale_para = l_amor
        para = {
            'INTERPOL'      : ['LIN', 'LOG'],
            'NOM_PARA_FONC' : 'FREQ',
            'NOM_PARA'      : 'AMOR',
            'PROL_DROITE'   : 'EXCLU',
            'PROL_GAUCHE'   : 'EXCLU',
            'NOM_RESU'      : kw['NATURE'] }
        para_fonc = {
            'INTERPOL' : ['LOG', 'LOG'],
            'NOM_PARA'    : 'FREQ',
            'PROL_DROITE' : 'CONSTANT',
            'PROL_GAUCHE' : 'EXCLU',
            'NOM_RESU'    : kw['NATURE'] }
        if kw['NATURE'] == 'DEPL':
            ideb = 0
        elif kw['NATURE'] == 'VITE':
            ideb = 1
        else:
            ASSERT(kw['NATURE'] == 'ACCE')
            ideb = 2
        if kw['METHODE'] == 'RICE':
            # appel à DSP2SRO
            ASSERT(kw['NATURE_FONC'] == 'DSP')
            deuxpi = 2. * math.pi
            f_dsp = t_fonction(f_in.vale_x * deuxpi, f_in.vale_y / deuxpi, f_in.para)
            for iamor in l_amor:
                spectr = DSP2SRO(f_dsp, iamor, kw['DUREE'], l_freq, ideb)
                vale_y = spectr.vale_y / kw['NORME']
                l_fonc_f.append(t_fonction(l_freq, vale_y, para_fonc))
        elif kw['METHODE'] == 'NIGAM':
            # appel à SPEC_OSCI
            ASSERT(kw['NATURE_FONC'] == 'ACCE')
            spectr = aster_fonctions.SPEC_OSCI(f_in.vale_x, f_in.vale_y, l_freq, l_amor)
            for iamor in range(len(l_amor)):
                vale_y = spectr[iamor, ideb,:] / kw['NORME']
                l_fonc_f.append(t_fonction(l_freq, vale_y, para_fonc))
        elif kw['METHODE'] == 'HARMO':
            # appel à ACCE2DSP
            ASSERT(kw['NATURE_FONC'] == 'ACCE')
            for iamor in l_amor:
                spectr = ACCE2SRO(f_in, iamor, l_freq, ideb)
                vale_y = spectr.vale_y / kw['NORME']
                l_fonc_f.append(t_fonction(l_freq, vale_y, para_fonc))
        self.resu = t_nappe(vale_para, l_fonc_f, para)

class CalcFonction_DSP(CalcFonctionOper):
    """DSP"""
    def _run(self):
        """DSP"""
        kw = self.kw
        f_in = self._lf[0]
        vale_freq = f_in.vale_x
        vale_sro = f_in.vale_y
        f_min = f_in.vale_x[0]
        f_in = t_fonction(NP.insert(vale_freq, 0, 0.0),
                          NP.insert(vale_sro, 0, 0.0),
                          para=f_in.para)
        deuxpi = 2. * math.pi
        freq_coup = kw['FREQ_COUP']
        SRO_args = {
            'DUREE_PHASE_FORTE' : kw['DUREE'], 'FREQ_COUP' : freq_coup,
            'NORME' : kw['NORME'], 'AMORT' : kw['AMOR_REDUIT'],
            'FMIN' : f_min, 'FONC_SPEC':  f_in}
        if kw['FREQ_PAS'] != None:
            SRO_args['PAS'] = kw['FREQ_PAS']
        elif kw['LIST_FREQ'] != None:
            l_freq = kw['LIST_FREQ'].Valeurs()
            if l_freq[0] <= 0.0:
                UTMESS('F', 'FONCT0_43')
            SRO_args['LIST_FREQ'] = l_freq
            SRO_args['PAS'] = None
        f_dsp, f_sro_ref = SRO2DSP(**SRO_args)
        self.resu = t_fonction(f_dsp.vale_x / deuxpi, f_dsp.vale_y * deuxpi, para=f_in.para)


class CalcFonction_LISS_ENVELOP(CalcFonctionOper):
    """LISS_ENVELOP"""
    def _build_data(self):
        """Read keywords to build the data"""
        self._build_list_fonc(mcsimp='NAPPE')

    def _run(self):
        """LISS_ENVELOP"""
        f_in = self._lf[0]
        kw = self.kw
        sp_nappe = LISS.nappe(listFreq=f_in.l_fonc[0].vale_x,
                              listeTable=[f.vale_y for f in f_in.l_fonc],
                              listAmor=f_in.vale_para,
                              entete="")
        sp_lisse = LISS.lissage(nappe=sp_nappe,
                                fmin=kw['FREQ_MIN'],
                                fmax=kw['FREQ_MAX'],
                                elarg=kw['ELARG'],
                                tole_liss=kw['TOLE_LISS'])
        para_fonc = f_in.l_fonc[0].para
        l_fonc_f = []
        for val in sp_lisse.listTable:
            l_fonc_f.append(t_fonction(sp_lisse.listFreq, val, para_fonc))
        self.resu = t_nappe(sp_lisse.listAmor, l_fonc_f, f_in.para)

class CalcFonction_REGR_POLYNOMIALE(CalcFonctionOper):
    """Polynomial regression"""
    def _run(self):
        """REGR_POLYNOMIALE"""
        f_in = self._lf[0]
        deg = self.kw['DEGRE']
        coef = NP.polyfit(f_in.vale_x, f_in.vale_y, deg)
        if coef is None:
            raise FonctionError("La régression polynomiale n'a pas convergé.")
        # interpolation sur une liste d'abscisses
        absc = f_in.vale_x
        if self.args['LIST_PARA'] is not None:
            absc = self.args['LIST_PARA'].Valeurs()
        vale = NP.polyval(coef, absc)
        # paramètres
        para = f_in.para.copy()
        para['INTERPOL'] = ['LIN', 'LIN']
        self.resu = t_fonction(absc, vale, para)
        coef_as_str = os.linesep.join(['   a[%d] = %f' % (i, ci) \
                                       for i, ci in enumerate(coef)])
        UTMESS('I', 'FONCT0_57', coef_as_str)


class Context(object):
    """Permet de stocker des éléments de contexte pour aider au
    diagnostic lors de l'émission de message.
    usage :
       context = Context()
       context.f = 'nomfon'
       print context.f
    """
    def __init__(self):
        self.__nomf = None

    def get_val(self):
        """Retourne le texte formatté."""
        nomf = self.__nomf
        if type(nomf) not in (list, tuple):
            nomf = [nomf,]
        pluriel = ''
        if len(nomf) > 1:
            pluriel = 's'
        res = """Fonction%(s)s concernée%(s)s : %(nomf)s""" % {
            's': pluriel,
            'nomf': ', '.join(nomf),
        }
        return res

    def set_val(self, value):
        """Set function"""
        self.__nomf = value

    def del_val(self):
        """Remove value"""
        del self.__nomf
    f = property(get_val, set_val, del_val, "")
