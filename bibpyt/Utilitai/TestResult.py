# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

"""
This module defines objects for the testing feature.
"""

import re
from functools import partial
from glob import glob

from Noyau import N_utils

_trans = str.maketrans('e', 'E')


def _fortran(srepr):
    """for fortran look"""
    return srepr.translate(_trans)


class TestResult(metaclass=N_utils.Singleton):

    """This class provides the feature to print the testcase results.
    A singleton object is created to avoid to repeat some global tasks.
    """
    _singleton_id = 'Utilitai.TestResult'

    def __init__(self):
        """Initialization"""
        # TODO imported by code_aster < aster_core < here < Utmess < code_aster
        # to be solved!
        try:
            import aster
            from Utilitai.Utmess import UTMESS
            self._printLine = partial(aster.affiche, 'RESULTAT')
            self._utmess = UTMESS
        except ImportError:
            self._printLine = _internal_print
            self._utmess = _internal_mess
        self._isVerif = self._checkVerif()
        if not self._isVerif:
            self._utmess('I', 'TEST0_19')

    def isVerif(self):
        """Tell if the testcase is a verification one"""
        return self._isVerif

    def write(self, width, *args):
        """shortcut to print in the RESULTAT file"""
        fmtval = '%%-%ds' % width
        fmtcols = ['%-4s ', '%-16s', '%-16s', fmtval, fmtval, '%-16s', '%-16s']
        assert len(args) <= 7, args
        fmt = ' '.join(fmtcols[:len(args)])
        line = fmt % args
        self._printLine(line)
        return line

    def showResult(self, type_ref, legend, label, skip, relative,
                   tole, ref, val, compare=1.):
        """Print a table for TEST_RESU

        type_ref : ANALYTIQUE, NON_REGRESSION, AUTRE_ASTER...
        legend : component name or XXXX
        label : boolean to print or not the labels
        skip : boolean to skip the test and print an empty line
        relative : boolean, True if for relative, False for absolute comparison
        tole : maximum error tolerated
        ref : reference value (integer, real or complex)
        val : computed value (same type as ref)
        compare : order of magnitude
        """
        # ignore NON_REGRESSION tests for validation testcases
        isNonRegr = type_ref.strip() == "NON_REGRESSION"
        isValidIgn = isNonRegr and not self._isVerif
        lines = ['pass in showResult']
        # compute
        diag = 'SKIP'
        error = '-'
        if not skip:
            error = abs(1. * ref - val)
            tole = 1. * tole
            if relative:
                ok = error <= abs((tole * ref))
                tole = tole * 100.
                if ref != 0.:
                    error = error / abs(ref) * 100.
                elif ok:
                    error = 0.
                else:
                    error = 999.999999
            else:
                tole = abs(tole * compare)
                ok = error <= tole
            diag = ' OK ' if ok else 'NOOK'
        else:
            # do not warn if validation testcase
            if not isValidIgn:
                self._utmess('A', 'TEST0_12')
        # formatting
        sref = '%s' % ref
        sval = '%s' % val
        width = max([16, len(sref), len(sval)]) + 2
        serr = '%s' % error
        if len(serr) > 15:
            serr = '%13.6e' % error
        stol = '%s' % tole
        if relative:
            serr += '%'
            stol += '%'
        sref, sval, serr, stol = [_fortran(i) for i in [sref, sval, serr, stol]]
        if diag == 'SKIP':
            legend = sref = sval = serr = stol = '-'
        # printing
        if compare != 1.:
            lines.append(self.write(width, ' ', 'ORDRE DE GRANDEUR :', compare))
        if label:
            lines.append(self.write(width, ' ', 'REFERENCE', 'LEGENDE',
                                    'VALE_REFE', 'VALE_CALC', 'ERREUR', 'TOLE'))
        if isValidIgn:
            lines.append(self.write(width, "-", type_ref, legend, sref,
                                    sval, serr, "-"))
        else:
            lines.append(self.write(width, diag, type_ref, legend, sref,
                                    sval, serr, stol))
        return lines

    def _checkVerif(self):
        """Check if the current execution is for a verification testcase
        (and not a validation one)."""
        exports = glob("*.export")
        if not exports:
            # export file not found, return "verification" that is more strict!
            return True
        with open(exports[0], "r") as f:
            text = f.read()
        expr = re.compile("^P +testlist.*validation", re.M)
        isVerif = expr.search(text) is None
        return isVerif


def testresu_print(type_ref, legend, label, skip, relative,
                   tole, ref, val, compare=1.):
    """Print a table for TEST_RESU

    type_ref : ANALYTIQUE, NON_REGRESSION, AUTRE_ASTER...
    legend : component name or XXXX
    label : boolean to print or not the labels
    skip : boolean to skip the test and print an empty line
    relative : boolean, True if for relative, False for absolute comparison
    tole : maximum error tolerated
    ref : reference value (integer, real or complex)
    val : computed value (same type as ref)
    compare : order of magnitude
    """
    lines = TestResult().showResult(type_ref, legend, label, skip, relative,
                                    tole, ref, val, compare)
    return lines


def _internal_print(text):
    """Define a basic print function for unittest"""
    print(text)


def _internal_mess(a, b):
    """UTMESS replacement for unittest"""
    print('<{0}> message {1}'.format(a, b))


if __name__ == '__main__':
    testresu_print('NON_REGRESSION', 'DX', True, False, False,
                   1.e-6, 1.123e-6, 0.0, compare=275.0)
    testresu_print('AUTRE_ASTER', 'DX', False, False, False,
                   1.e-6, 1.123e-6, 0.0)
    print()

    testresu_print('NON_REGRESSION', 'DX', True, True, False,
                   1.e-6, 1.123e-6, 0.0)
    testresu_print('NON_REGRESSION', 'XXXXX', True, False, False,
                   1.e-6, 1.123e-3, 0.0, compare=275.0)
    print()

    testresu_print('NON_REGRESSION', 'XXXXX', True, False, True,
                   1.e-6, 1.123e-2, 0.0)
    print()

    testresu_print('NON_REGRESSION', 'XXXXX', True, False, True,
                   0.02, 456, 458)
    print()

    testresu_print('ANALYTIQUE', 'DEPL_C', True, False, True,
                   1.e-4, 1. + 1.j, -0.5 + 0.99j)
    print()
