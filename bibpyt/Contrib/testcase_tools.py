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
Convenient tools for the testcases
"""

import sys
import os
import os.path as osp
import re
from glob import glob
import traceback

DELIMITER = '---delimiter---'


def testcase_post():
    """Post-run script"""
    change_test_resu()


def change_test_resu():
    """Fill the TEST_xxxx/VALE_CALC of the .comm file with the computed value"""
    print('try to add new values in the .comm file...')
    howto = os.linesep.join(['', 'HOWTO:', '',
                             'To extract automatically the new command files, use:',
                             '',
                             '   python bibpyt/Contrib/testcase_tools.py extract RESDIR NEWDIR "*.mess"',
                             '',
                             'Replace RESDIR by the directory containing the .mess files',
                             'and NEWDIR by a directory in which the new comm files will be written',
                             '("*.mess" may be omitted).'
                             '', ''])
    reval = re.compile('^ *(OK|NOOK|SKIP) +NON_REGRESSION +(?P<leg>.+?) +'
                       '(?P<refe>.+?) +(?P<calc>.+?) +(?P<err>.+?) +(?P<tole>.+?) *$', re.M)
    with open('fort.8', 'rb') as f:
        fort8 = f.read().decode()
    results = reval.findall(fort8)
    with open('fort.1', 'rb') as f:
        fort1 = f.read().decode()
    keywords = read_keyword_value('VALE_CALC(|_.)', fort1)
    for i, val in enumerate(results):
        print(i, val)
    for i, kw in enumerate(keywords):
        print(i, kw)
    if len(results) == 0:
        # suppose it's a validation testcase: set value to 1.0
        results = [["VALID"] * 4] * len(keywords)
    else:
        assert len(results) == len(keywords), (len(results), len(keywords))

    changed = fort1
    while len(results) > 0:
        dico = keywords.pop()
        start, end = dico['start'], dico['end']
        res = results.pop()
        newval = res[3]
        if newval == '-':   # null value skipped
            newval = '0.'
        elif newval == "VALID":
            if dico['key'] == 'VALE_CALC_I':
                newval = '1'
            elif dico['key'] == 'VALE_CALC_K':
                newval = 'IGNORE'
            else:
                newval = '1.0'
        changed = changed[:start] + dico['key'] + '=' + newval + changed[end:]
    append_to_file('fort.6', howto, stdout=True)
    append_to_file('fort.6', changed, delimiter=DELIMITER, stdout=True)


def append_to_file(fname, txt, delimiter=None, stdout=None):
    """Append a text at the end of a file"""
    if delimiter:
        txt = os.linesep.join([delimiter, txt, delimiter])
    with open(fname, 'ab') as f:
        f.write(txt.encode())
    if stdout:
        print(txt)


def read_keyword_value(kw, txt):
    """Read all values of a keyword
    Return a list of positions and a list of couples (keyword, value)."""
    re_vale = re.compile('(?P<key>%s) *= *(?P<val>[^, \)]+)' % kw, re.M)
    found = []
    for mat in re_vale.finditer(txt):
        found.append({
            'start': mat.start(),
            'end': mat.end(),
            'key': mat.group('key'),
            'val': mat.group('val'),
        })
    return found

_re_comm = re.compile('F +comm +(.*) +D', flags=re.M)


def get_dest_filename(fname, nb):
    """Return 'nb' destination filenames
    Try to use filename found in .export"""
    # search the export files locally (./astest and ../validation/astest)
    if nb < 1:
        return []
    dname, root = osp.split(osp.splitext(fname)[0])
    lexp = glob(osp.join('astest', root + '.export')) \
        + glob(osp.join('../validation/astest', root + '.export'))
    if lexp:
        with open(lexp[0], 'rb')as f:
            export = f.read()
        lres = _re_comm.findall(export)
        i = len(lres) + 100
    else:
        lres = [root + '.comm']
        i = 1
    while len(lres) < nb:
        lres.append(root + '.com%d' % i)
        i += 1
    assert len(lres) >= nb, lres
    return lres

# helper functions run manually


def extract_from(from_dir, to_dir, pattern='*.mess'):
    """Extract content from files matching 'pattern' in 'from_dir'
    and write the extracted text into 'to_dir'.

    Example:
    python bibpyt/Contrib/testcase_tools.py extract /path/to/resutest /path/to/changed '*.mess'
    """
    print('searching', osp.join(from_dir, pattern), '...', end=' ')
    lfiles = glob(osp.join(from_dir, pattern))
    print('%d found' % len(lfiles))
    if not osp.exists(to_dir):
        os.makedirs(to_dir)
    for fname in lfiles:
        with open(fname, 'rb') as f:
            txt = f.read()
        parts = txt.split(DELIMITER)
        if len(parts) % 2 != 1:
            print('%s: expected an odd number of delimiters' % fname)
            continue
        nbfile = (len(parts) - 1) / 2
        lres = get_dest_filename(fname, nbfile)
        for i in range(nbfile):
            resname = osp.join(to_dir, lres.pop(0))
            if osp.isfile(resname):
                resname += '.' + osp.basename(fname)
            print('write', resname)
            content = parts[2 * i + 1].strip() + os.linesep
            with open(resname, 'wb') as f:
                f.write(content)

if __name__ == '__main__':
    args = sys.argv[1:]
    try:
        assert len(args) >= 1, 'usage: testcase_tools.py action [args]'
        if args[0] == 'extract':
            assert 2 <= len(
                args[1:]) <= 3, 'invalid arguments for "testcase_tools.py extract"'
            extract_from(*args[1:])
        else:
            assert False, 'unsupported action: %s' % args[0]
    except AssertionError as exc:
        print(str(exc))
        traceback.print_exc()
        sys.exit(1)
