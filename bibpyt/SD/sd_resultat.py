# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
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

from SD import *
from SD.sd_titre import sd_titre

from SD.sd_l_table import sd_l_table
from SD.sd_champ import sd_champ
from SD.sd_l_charges import sd_l_charges
from SD.sd_util import *


class sd_resultat(sd_titre):
#---------------------------------------
    nomj = SDNom(fin=8)
    TAVA = AsColl(SDNom(debut=19), acces='NU',
                  stockage='CONTIG', modelong='CONSTANT', type='K', ltyp=8, )
    NOVA = AsObject(SDNom(debut=19), genr='N', xous='S', type='K', ltyp=16, )
    TACH = AsColl(SDNom(debut=19), acces='NU',
                  stockage='CONTIG', modelong='CONSTANT', type='K', ltyp=24, )
    ORDR = AsVI(SDNom(debut=19), )
    DESC = AsObject(SDNom(debut=19), genr='N', xous='S', type='K', ltyp=16, )

    # la déclaration suivante simplifie la fonction check_resultat_i_char
    CHAR = Facultatif(AsVK24(SDNom(debut=19),))

    sd_l_table = Facultatif(sd_l_table(SDNom(nomj='')))

    # existence de la SD :
    def exists(self):
        return self.ORDR.exists

    # indirection vers les champs de .TACH :
    def check_resultat_i_TACH(self, checker):
        tach = self.TACH.get()
        for nosym in tach.keys():
            for kordr in range(len(tach[nosym])):
                nom = tach[nosym][kordr]
                if not nom.strip():
                    continue

                # on vérifie la règle de nommage des champs (numéro de
                # rangement)
                assert int(nom[13:19]) == kordr, nom

                sd2 = sd_champ(nom)
                sd2.check(checker)

    # indirection vers les objets de .TAVA :
    def check_resultat_i_TAVA(self, checker):
        tava = self.TAVA.get()
        S1 = set()
        for knova in tava.keys():
            suffix = tava[knova][0][:5]
            if not suffix.strip():
                continue       # JP : est-ce possible ?
            S1.add(suffix)
        for suffix in S1:
            nom = self.nomj()[:19] + suffix
            sd2 = AsObject(
                SDNom(nomj=nom, debut=0), xous='S', genr='V', type=Parmi('I', 'R', 'C', 'K'),
                ltyp=Parmi(4, 8, 16, 24),)
            sd2.check(checker)

    # indirection vers les sd_l_charges stockées comme paramètres sous le nom
    # EXCIT :
    def check_resultat_i_EXCIT(self, checker):
        lnom = self.CHAR.get()
        if not lnom:
            return
        S1 = set()
        for nom in lnom:
            if not nom.strip():
                continue
            S1.add(nom)
        for nom in S1:
            sd2 = sd_l_charges(nomj=nom)
            sd2.check(checker)

    # vérification de .ORDR :
    def check_ORDR(self, checker):
        V = self.ORDR
        nuti = V.lonuti
        nmax = V.lonmax
        sdu_compare(V, checker, nuti, '> ', 0, comment='nuti > 0')
        sdu_compare(V, checker, nuti, '<=', nmax, comment='nuti <= nmax')

        # les numeros d'ordre doivent etre tous différents :
        sdu_tous_differents(V, checker, V.get()[:nuti], '1:NUTI')

        # les numeros d'ordre doivent etre croissants (voir rsutrg.f)
        if nuti > 1:
            assert sdu_monotone(V.get()[:nuti]) in (1,)

    # vérification des longueurs des différents objets :
    def check_LONGUEURS(self, checker):
        ordr = self.ORDR.get()
        tach = self.TACH.get()
        nova = self.NOVA.get()
        tava = self.TAVA.get()
        desc = self.DESC.get()

        nbmax_ordr = len(ordr)
                         # la SD est concue pour stocker jusqu'à nbmax_ordr
                         # nume_ordre
        nbmax_para = len(nova)
                         # la SD est concue pour stocker jusqu'à nbmax_para
                         # paramètres
        nbmax_nosym = len(desc)
                          # la SD est concue pour stocker jusqu'à nbmax_nosym
                          # nom_cham

        sdu_compare(self.TACH, checker, len(tach),
                    '==', nbmax_nosym, 'Incohérence TACH/DESC')
        sdu_compare(self.TAVA, checker, len(tava),
                    '==', nbmax_para, 'Incohérence TAVA/NOVA')

        # .TACH
        for ksym in tach.keys():
            nosym = desc[ksym - 1].strip()
            sdu_compare(self.TACH, checker, len(
                tach[ksym]), '==', nbmax_ordr, nosym + ' LONMAX(.TACH) != LONMAX(.ORDR)')

        # objets trouvés dans .TAVA
        for knova in tava.keys():
            sdu_compare(
                tava, checker, len(tava[knova]), '==', 4, 'LONMAX(TAVA[ksym]==4')
            suffix = tava[knova][0][:5]
            npara = int(tava[knova][2])
            if not suffix.strip():
                continue
            nom = self.nomj()[:19] + suffix
            sd2 = AsObject(
                SDNom(nomj=nom, debut=0), xous='S', genr='V', type=Parmi('I', 'R', 'C', 'K'),
                ltyp=Parmi(4, 8, 16, 24),)
            sdu_compare(sd2, checker, len(sd2.get()), '==',
                        npara * nbmax_ordr, 'Incohérence LONMAX / LONMAX(.ORDR)')

    # vérifications supplémentaires :
    def check_veri1(self, checker):
        ordr = self.ORDR.get()
        nova = self.NOVA.get()
        tava = self.TAVA.get()

        nbmax_ordr = len(ordr)
                         # la SD est concue pour stocker jusqu'à nbmax_ordr
                         # nume_ordre
        nbuti_ordr = self.ORDR.lonuti  # la SD contient réellement nbuti_ordr nume_ordre

        # objets trouvés dans .TAVA
        for knova in tava.keys():
            nova1 = nova[knova - 1].strip()
            suffix = tava[knova][0][:5]
            if not suffix.strip():
                continue

            nupara = int(tava[knova][1])
            nbpara = int(tava[knova][2])
            assert nupara <= nbpara, (nupara, nbpara)
            acces = tava[knova][3].strip()
            assert acces in ('PARA', 'ACCES'), acces

            # on vérifie que les variables d'accès sont toutes différentes :
            if acces == 'ACCES':
                # pour l'instant, on ne vérifie que 'INST' car 'FREQ',
                # 'NUME_MODE', 'NOEUD_CMP' ne semblent pas tous différents ...
                if nova1 != 'INST':
                    continue

                nom = self.nomj()[:19] + suffix
                sd2 = AsObject(SDNom(nomj=nom, debut=0),)
                vect = sd2.get()
                seq = []
                for k in range(nbuti_ordr):
                    seq.append(vect[k * nbpara + nupara - 1])

                sdu_tous_differents(sd2, checker, seq, nova1)

            # on vérifie les éventuelles sd_l_charge (EXCIT) :
            if nova1 == "EXCIT":
                nom = self.nomj()[:19] + suffix
                sd2 = AsObject(SDNom(nomj=nom, debut=0),)
                vect = sd2.get()
                S1 = set()
                for k in range(nbuti_ordr):
                    S1.add(vect[k * nbpara + nupara - 1])
                for nom in S1:
                    if nom.strip() != '':
                        sd2 = sd_l_charges(nomj=nom)
                        sd2.check(checker)
