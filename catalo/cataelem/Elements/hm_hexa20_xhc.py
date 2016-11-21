# coding=utf-8
# person_in_charge: daniele.colombo at ifpen.fr
# CATALOGUE DES ELEMENTS 2D HM-X-FEM CONTACT

# ======================================================================
# COPYRIGHT (C) 1991 - 2016  EDF R&D                  WWW.CODE-ASTER.ORG
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

from cataelem.Tools.base_objects import LocatedComponents, ArrayOfComponents, SetOfNodes, ElrefeLoc
from cataelem.Tools.base_objects import Calcul, Element
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.located_components as LC
import cataelem.Commons.parameters as SP
import cataelem.Commons.mesh_types as MT
from cataelem.Options.options import OP

#----------------
# Modes locaux :
#----------------


CCAMASS  = LocatedComponents(phys=PHY.CAMASS, type='ELEM',
    components=('C','ALPHA','BETA','KAPPA','X',
          'Y','Z',))


CCARCRI  = LocatedComponents(phys=PHY.CARCRI, type='ELEM',
    components=('ITECREL','MACOMP','RESCREL','THETA','ITEDEC',
          'INTLOC','PERTURB','TOLDEBO','ITEDEBO','TSSEUIL',
          'TSAMPL','TSRETOUR','POSTITER','LC_EXT[3]','MODECALC',
          'ALPHA','LC_EXT2[2]',))


CCOMPOR  = LocatedComponents(phys=PHY.COMPOR, type='ELEM',
    components=('RELCOM','NBVARI','DEFORM','INCELA','C_PLAN',
          'NUME_LC','SD_COMP','KIT[9]','NVI_C','NVI_T',
          'NVI_H','NVI_M',))


DDL_MECA = LocatedComponents(phys=PHY.DEPL_R, type='ELNO', diff=True,
    components=(
    ('EN1',('DX','DY','DZ','PRE1','H1X',
          'H1Y','H1Z','H1PRE1','PRE_FLU',
          'LAG_FLI','LAG_FLS','LAGS_C',
          'LAGS_F1','LAGS_F2')),
    ('EN2',('DX','DY','DZ','H1X','H1Y',
          'H1Z',)),
    ('EN3',('DX','DY','DZ','PRE1','H1X',
          'H1Y','H1Z','H1PRE1','PRE_FLU',
          'LAG_FLI','LAG_FLS','LAGS_C',
          'LAGS_F1','LAGS_F2','LAG2_C',
          'LAG2_F1','LAG2_F2','LAG3_C',
          'LAG3_F1','LAG3_F2')),))


EDEFONC  = LocatedComponents(phys=PHY.EPSI_C, type='ELNO',
    components=('EPXX','EPYY','EPZZ','EPXY','EPXZ',
          'EPYZ',))


EDEFOPG  = LocatedComponents(phys=PHY.EPSI_R, type='ELGA', location='RIGI',
    components=('EPXX','EPYY','EPZZ','EPXY','EPXZ',
          'EPYZ',))


EDEFONO  = LocatedComponents(phys=PHY.EPSI_R, type='ELNO',
    components=('EPXX','EPYY','EPZZ','EPXY','EPXZ',
          'EPYZ',))


EDFEQPG  = LocatedComponents(phys=PHY.EPSI_R, type='ELGA', location='RIGI',
    components=('INVA_2','PRIN_[3]','INVA_2SG','VECT_1_X','VECT_1_Y',
          'VECT_1_Z','VECT_2_X','VECT_2_Y','VECT_2_Z','VECT_3_X',
          'VECT_3_Y','VECT_3_Z',))


NGEOMER  = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


EGGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELGA', location='XFEM',
    components=('X','Y','Z',))


ENGEOM_R = LocatedComponents(phys=PHY.GEOM_R, type='ELNO',
    components=('X','Y','Z',))


CTEMPSR  = LocatedComponents(phys=PHY.INST_R, type='ELEM',
    components=('INST',))


CTEMPSC  = LocatedComponents(phys=PHY.INST_R, type='ELEM',
    components=('INST','DELTAT'))


STANO_I  = LocatedComponents(phys=PHY.N120_I, type='ELNO',
    components=('X1',))


E33NEUTR = LocatedComponents(phys=PHY.N132_R, type='ELEM',
    components=('X[33]',))


EGNEUT_F = LocatedComponents(phys=PHY.NEUT_F, type='ELGA', location='XFEM',
    components=('X[30]',))


E1NEUTK  = LocatedComponents(phys=PHY.NEUT_K24, type='ELEM',
    components=('Z1',))


E2NEUTK  = LocatedComponents(phys=PHY.NEUT_K8, type='ELEM',
    components=('Z1',))


EGNEUT_R = LocatedComponents(phys=PHY.NEUT_R, type='ELGA', location='XFEM',
    components=('X[30]',))


ESIGMPC  = LocatedComponents(phys=PHY.SIEF_C, type='ELGA', location='RIGI',
    components=('SIXX','SIYY','SIZZ','SIXY','SIXZ',
          'SIYZ',))


ESIGMNC  = LocatedComponents(phys=PHY.SIEF_C, type='ELNO',
    components=('SIXX','SIYY','SIZZ','SIXY','SIXZ',
          'SIYZ',))


ESIGMPG  = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
    components=('SIXX','SIYY','SIZZ','SIXY','SIXZ',
          'SIYZ',))


ESIGMNO  = LocatedComponents(phys=PHY.SIEF_R, type='ELNO',
    components=('SIXX','SIYY','SIZZ','SIXY','SIXZ',
          'SIYZ',))


ECONTPG  = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='XFEM',
    components=('SIXX','SIYY','SIZZ','SIXY','SIXZ',
          'SIYZ','SIPXX','SIPYY','SIPZZ','SIPXY',
          'SIPXZ','SIPYZ','M11','FH11X','FH11Y',
          'FH11Z',))


ECOEQPG  = LocatedComponents(phys=PHY.SIEF_R, type='ELGA', location='RIGI',
    components=('VMIS','TRESCA','PRIN_[3]','VMIS_SG','VECT_1_X',
          'VECT_1_Y','VECT_1_Z','VECT_2_X','VECT_2_Y','VECT_2_Z',
          'VECT_3_X','VECT_3_Y','VECT_3_Z','TRSIG','TRIAX',))


ZVARIPG  = LocatedComponents(phys=PHY.VARI_R, type='ELGA', location='XFEM',
    components=('VARI',))


CONTX_R  = LocatedComponents(phys=PHY.XCONTAC, type='ELEM',
    components=('RHON','MU','RHOTK','INTEG','COECH',
          'COSTCO','COSTFR','COPECO','COPEFR','RELA',))


CFLUXF   = LocatedComponents(phys=PHY.FTHM_F, type='ELEM',
    components=('PFLUF',))


MVECTUR = ArrayOfComponents(phys=PHY.VDEP_R, locatedComponents=DDL_MECA)

MMATUUR = ArrayOfComponents(
    phys=PHY.MDEP_R, locatedComponents=DDL_MECA)
 
MMATUNS = ArrayOfComponents(
    phys=PHY.MDNS_R, locatedComponents=DDL_MECA)


#------------------------------------------------------------
class TemplateElement(Element):
    """Only a template to shared definitions of options"""
    calculs = (

        OP.CHAR_MECA_PESA_R(te=588,
            para_in=((OP.CHAR_MECA_PESA_R.PCNSETO, LC.E320NEUI), (SP.PGEOMER, NGEOMER),
                     (OP.CHAR_MECA_PESA_R.PHEAVTO, LC.E32NEUTI), (OP.CHAR_MECA_PESA_R.PHEA_NO, LC.N5NEUTI),
                     (OP.CHAR_MECA_PESA_R.PLONCHA, LC.E10NEUTI), (OP.CHAR_MECA_PESA_R.PLSN, LC.N1NEUT_R),
                     (OP.CHAR_MECA_PESA_R.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (SP.PPESANR, LC.CPESANR), (OP.CHAR_MECA_PESA_R.PPINTTO, E33NEUTR),
                     (OP.CHAR_MECA_PESA_R.PPMILTO, LC.E198NEUT), (OP.CHAR_MECA_PESA_R.PSTANO, STANO_I),
                     ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_FLUX_F(te=559,
            para_in=((SP.PFLUXF, CFLUXF), (SP.PGEOMER, NGEOMER),(SP.PTEMPSR, CTEMPSC),
                     (OP.CHAR_MECA_FLUX_F.PLST, LC.N1NEUT_R), (OP.CHAR_MECA_FLUX_F.PLSN, LC.N1NEUT_R),
                     ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.EPEQ_ELGA(te=335,
            para_in=((OP.EPEQ_ELGA.PDEFORR, EDEFOPG), ),
            para_out=((OP.EPEQ_ELGA.PDEFOEQ, EDFEQPG), ),
        ),

        OP.EPEQ_ELNO(te=335,
            para_in=((OP.EPEQ_ELNO.PDEFORR, EDEFONO), ),
            para_out=((OP.EPEQ_ELNO.PDEFOEQ, LC.EDFEQNO), ),
        ),

        OP.EPSI_ELNO(te=4,
            para_in=((OP.EPSI_ELNO.PDEFOPG, EDEFOPG), ),
            para_out=((SP.PDEFONC, EDEFONC), (SP.PDEFONO, EDEFONO),
                     ),
        ),

        OP.FORC_NODA(te=588,
            para_in=((OP.FORC_NODA.PBASLOR, LC.N9NEUT_R), (OP.FORC_NODA.PCNSETO, LC.E320NEUI),
                     (OP.FORC_NODA.PCONTMR, ECONTPG), (SP.PGEOMER, NGEOMER),
                     (OP.FORC_NODA.PHEAVTO, LC.E32NEUTI), (OP.FORC_NODA.PHEA_NO, LC.N5NEUTI),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (OP.FORC_NODA.PLONCHA, LC.E10NEUTI), (OP.FORC_NODA.PLSN, LC.N1NEUT_R),
                     (OP.FORC_NODA.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (OP.FORC_NODA.PPINTTO, E33NEUTR), (OP.FORC_NODA.PPMILTO, LC.E198NEUT),
                     (OP.FORC_NODA.PSTANO, STANO_I), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_CONT(te=557,
            para_in=((OP.CHAR_MECA_CONT.PAINTER, LC.E200NEUT), (OP.CHAR_MECA_CONT.PBASECO, LC.E360NEUT),
                     (OP.CHAR_MECA_CONT.PCFACE, LC.E90NEUTI), (SP.PCOHES, LC.E5NEUTR),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA), (SP.PDONCO, CONTX_R),
                     (SP.PGEOMER, NGEOMER), (OP.CHAR_MECA_CONT.PLONGCO, LC.E3NEUTI),
                     (SP.PINDCOI, LC.I1NEUT_I), (OP.CHAR_MECA_CONT.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.CHAR_MECA_CONT.PPINTER, LC.E120NEUT),
                     (OP.CHAR_MECA_CONT.PSEUIL, LC.E1NEUTR), (OP.CHAR_MECA_CONT.PSTANO, STANO_I),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR), (OP.CHAR_MECA_CONT.PCOMPOR, CCOMPOR),
                     (SP.PCARCRI, CCARCRI), (OP.CHAR_MECA_CONT.PHEA_NO, LC.N5NEUTI), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.CHAR_MECA_CONT_M(te=557,
            para_in=((OP.CHAR_MECA_CONT_M.PAINTER, LC.E200NEUT), (OP.CHAR_MECA_CONT_M.PBASECO, LC.E360NEUT),
                     (OP.CHAR_MECA_CONT_M.PCFACE, LC.E90NEUTI), (SP.PCOHES, LC.N5NEUTR),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA), (SP.PDONCO, CONTX_R),
                     (SP.PGEOMER, NGEOMER), (OP.CHAR_MECA_CONT_M.PLONGCO, LC.E3NEUTI),
                     (SP.PINDCOI, LC.I1NEUT_I), (OP.CHAR_MECA_CONT_M.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.CHAR_MECA_CONT_M.PPINTER, LC.E120NEUT),
                     (OP.CHAR_MECA_CONT_M.PSEUIL, LC.E1NEUTR), (OP.CHAR_MECA_CONT_M.PSTANO, STANO_I),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR), (OP.CHAR_MECA_CONT_M.PCOMPOR, CCOMPOR),
                     (SP.PCARCRI, CCARCRI), (OP.CHAR_MECA_CONT_M.PHEA_NO, LC.N5NEUTI), ),
            para_out=((SP.PVECTUR, MVECTUR), ),
        ),

        OP.FULL_MECA(te=588,
            para_in=((OP.FULL_MECA.PBASLOR, LC.N9NEUT_R), (SP.PCAMASS, CCAMASS),
                     (SP.PCARCRI, CCARCRI), (OP.FULL_MECA.PCNSETO, LC.E320NEUI),
                     (OP.FULL_MECA.PCOMPOR, CCOMPOR), (OP.FULL_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (OP.FULL_MECA.PHEAVTO, LC.E32NEUTI),
                     (OP.FULL_MECA.PHEA_NO, LC.N5NEUTI), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (OP.FULL_MECA.PLONCHA, LC.E10NEUTI),
                     (OP.FULL_MECA.PLSN, LC.N1NEUT_R), (OP.FULL_MECA.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.FULL_MECA.PPINTTO, E33NEUTR),
                     (OP.FULL_MECA.PPMILTO, LC.E198NEUT), (OP.FULL_MECA.PSTANO, STANO_I),
                     (SP.PVARCMR, LC.ZVARCPG), (OP.FULL_MECA.PVARCPR, LC.ZVARCPG),
                     (SP.PVARCRR, LC.ZVARCPG), (OP.FULL_MECA.PVARIMR, ZVARIPG),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.FULL_MECA.PCONTPR, ECONTPG),
                     (SP.PMATUNS, MMATUNS), (OP.FULL_MECA.PVARIPR, ZVARIPG),
                     (SP.PVECTUR, MVECTUR), ),
        ),

        OP.GEOM_FAC(te=519,
            para_in=((SP.NOMFIS, E2NEUTK), (SP.PDEPLA, DDL_MECA),
                     (OP.GEOM_FAC.PGESCLO, LC.E120NEUT), (OP.GEOM_FAC.PHEA_NO, LC.N5NEUTI),
                     (OP.GEOM_FAC.PLONGCO, LC.E3NEUTI), (OP.GEOM_FAC.PLST, LC.N1NEUT_R),
                     (OP.GEOM_FAC.PPINTER, LC.E120NEUT), ),
            para_out=((SP.PBASESC, LC.E360NEUT), (SP.PBASMAI, LC.E360NEUT),
                     (SP.PNEWGEM, LC.E120NEUT), (SP.PNEWGES, LC.E120NEUT),
                     ),
        ),

        OP.INIT_VARC(te=99,
            para_out=((OP.INIT_VARC.PVARCPR, LC.ZVARCPG), ),
        ),

        OP.INI_XFEM_ELNO(te=99,
            para_out=((OP.INI_XFEM_ELNO.PBASLOR, LC.N9NEUT_R), (OP.INI_XFEM_ELNO.PLSN, LC.N1NEUT_R),
                     (OP.INI_XFEM_ELNO.PLST, LC.N1NEUT_R), (OP.INI_XFEM_ELNO.PSTANO, STANO_I),
                     ),
        ),

        OP.NSPG_NBVA(te=496,
            para_in=((OP.NSPG_NBVA.PCOMPOR, LC.CCOMPO2), ),
            para_out=((SP.PDCEL_I, LC.EDCEL_I), ),
        ),

        OP.RAPH_MECA(te=588,
            para_in=((OP.RAPH_MECA.PBASLOR, LC.N9NEUT_R), (SP.PCAMASS, CCAMASS),
                     (SP.PCARCRI, CCARCRI), (OP.RAPH_MECA.PCNSETO, LC.E320NEUI),
                     (OP.RAPH_MECA.PCOMPOR, CCOMPOR), (OP.RAPH_MECA.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (OP.RAPH_MECA.PHEAVTO, LC.E32NEUTI),
                     (OP.RAPH_MECA.PHEA_NO, LC.N5NEUTI), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (OP.RAPH_MECA.PLONCHA, LC.E10NEUTI),
                     (OP.RAPH_MECA.PLSN, LC.N1NEUT_R), (OP.RAPH_MECA.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.RAPH_MECA.PPINTTO, E33NEUTR),
                     (OP.RAPH_MECA.PPMILTO, LC.E198NEUT), (OP.RAPH_MECA.PSTANO, STANO_I),
                     (SP.PVARCMR, LC.ZVARCPG), (OP.RAPH_MECA.PVARCPR, LC.ZVARCPG),
                     (SP.PVARCRR, LC.ZVARCPG), (OP.RAPH_MECA.PVARIMR, ZVARIPG),
                     ),
            para_out=((SP.PCODRET, LC.ECODRET), (OP.RAPH_MECA.PCONTPR, ECONTPG),
                     (OP.RAPH_MECA.PVARIPR, ZVARIPG), (SP.PVECTUR, MVECTUR),
                     ),
        ),

        OP.RIGI_MECA_TANG(te=588,
            para_in=((OP.RIGI_MECA_TANG.PBASLOR, LC.N9NEUT_R), (SP.PCAMASS, CCAMASS),
                     (SP.PCARCRI, CCARCRI), (OP.RIGI_MECA_TANG.PCNSETO, LC.E320NEUI),
                     (OP.RIGI_MECA_TANG.PCOMPOR, CCOMPOR), (OP.RIGI_MECA_TANG.PCONTMR, ECONTPG),
                     (SP.PDEPLMR, DDL_MECA), (SP.PDEPLPR, DDL_MECA),
                     (SP.PGEOMER, NGEOMER), (OP.RIGI_MECA_TANG.PHEAVTO, LC.E32NEUTI),
                     (OP.RIGI_MECA_TANG.PHEA_NO, LC.N5NEUTI), (SP.PINSTMR, CTEMPSR),
                     (SP.PINSTPR, CTEMPSR), (OP.RIGI_MECA_TANG.PLONCHA, LC.E10NEUTI),
                     (OP.RIGI_MECA_TANG.PLSN, LC.N1NEUT_R), (OP.RIGI_MECA_TANG.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.RIGI_MECA_TANG.PPINTTO, E33NEUTR),
                     (OP.RIGI_MECA_TANG.PPMILTO, LC.E198NEUT), (OP.RIGI_MECA_TANG.PSTANO, STANO_I),
                     (SP.PVARCMR, LC.ZVARCPG), (OP.RIGI_MECA_TANG.PVARCPR, LC.ZVARCPG),
                     (SP.PVARCRR, LC.ZVARCPG), (OP.RIGI_MECA_TANG.PVARIMR, ZVARIPG),
                     ),
            para_out=((SP.PMATUNS, MMATUNS), ),
        ),

        OP.RIGI_CONT(te=556,
            para_in=((OP.RIGI_CONT.PAINTER, LC.E200NEUT), (OP.RIGI_CONT.PBASECO, LC.E360NEUT),
                     (OP.RIGI_CONT.PCFACE, LC.E90NEUTI), (SP.PCOHES, LC.E5NEUTR),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PDONCO, CONTX_R), (SP.PGEOMER, NGEOMER),
                     (OP.RIGI_CONT.PHEA_NO, LC.N5NEUTI), (SP.PINDCOI, LC.I1NEUT_I),
                     (OP.RIGI_CONT.PLONGCO, LC.E3NEUTI), (OP.RIGI_CONT.PLSN, LC.N1NEUT_R),
                     (OP.RIGI_CONT.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (OP.RIGI_CONT.PPINTER, LC.E120NEUT),
                     (OP.RIGI_CONT.PCOMPOR, CCOMPOR), (SP.PCARCRI, CCARCRI),
                     (OP.RIGI_CONT.PSTANO, STANO_I), ),
            para_out=((OP.RIGI_CONT.PCOHESO, LC.E5NEUTR), (SP.PMATUNS, MMATUNS),
                     ),
        ),

        OP.RIGI_CONT_M(te=556,
            para_in=((OP.RIGI_CONT_M.PAINTER, LC.E200NEUT), (OP.RIGI_CONT_M.PBASECO, LC.E360NEUT),
                     (OP.RIGI_CONT_M.PCFACE, LC.E90NEUTI), (SP.PCOHES, LC.N5NEUTR),
                     (SP.PDEPL_M, DDL_MECA), (SP.PDEPL_P, DDL_MECA),
                     (SP.PDONCO, CONTX_R), (SP.PGEOMER, NGEOMER),
                     (OP.RIGI_CONT_M.PHEA_NO, LC.N5NEUTI), (SP.PINDCOI, LC.I1NEUT_I),
                     (OP.RIGI_CONT_M.PLONGCO, LC.E3NEUTI), (OP.RIGI_CONT_M.PLSN, LC.N1NEUT_R),
                     (OP.RIGI_CONT_M.PLST, LC.N1NEUT_R), (SP.PMATERC, LC.CMATERC),
                     (SP.PINSTMR, CTEMPSR), (SP.PINSTPR, CTEMPSR),
                     (OP.RIGI_CONT_M.PPINTER, LC.E120NEUT),
                     (OP.RIGI_CONT_M.PCOMPOR, CCOMPOR), (SP.PCARCRI, CCARCRI),
                     (OP.RIGI_CONT_M.PSTANO, STANO_I), ),
            para_out=((OP.RIGI_CONT_M.PCOHESO, LC.N5NEUTR), (SP.PMATUNS, MMATUNS),
                     ),
        ),

        OP.SIEQ_ELGA(te=335,
            para_in=((OP.SIEQ_ELGA.PCONTRR, ESIGMPG), ),
            para_out=((OP.SIEQ_ELGA.PCONTEQ, ECOEQPG), ),
        ),

        OP.SIEQ_ELNO(te=335,
            para_in=((OP.SIEQ_ELNO.PCONTRR, ESIGMNO), ),
            para_out=((OP.SIEQ_ELNO.PCONTEQ, LC.ECOEQNO), ),
        ),

        OP.SIGM_ELGA(te=546,
            para_in=((SP.PSIEFR, ESIGMPG), ),
            para_out=((SP.PSIGMC, ESIGMPC), (SP.PSIGMR, ESIGMPG),
                     ),
        ),

        OP.SIGM_ELNO(te=4,
            para_in=((OP.SIGM_ELNO.PCONTRR, ESIGMPG), ),
            para_out=((SP.PSIEFNOC, ESIGMNC), (OP.SIGM_ELNO.PSIEFNOR, ESIGMNO),
                     ),
        ),

        OP.TOPOFA(te=510,
            para_in=((OP.TOPOFA.PAINTTO, LC.E55NEUTR), (OP.TOPOFA.PCNSETO, LC.E320NEUI),
                     (SP.PDECOU, LC.E1NEUK8), (SP.PGEOMER, NGEOMER),
                     (SP.PGRADLN, LC.N3NEUT_R), (SP.PGRADLT, LC.N3NEUT_R),
                     (OP.TOPOFA.PHEAVTO, LC.E32NEUTI), (OP.TOPOFA.PLONCHA, LC.E10NEUTI),
                     (OP.TOPOFA.PLSN, LC.N1NEUT_R), (OP.TOPOFA.PLST, LC.N1NEUT_R),
                     (OP.TOPOFA.PPINTTO, E33NEUTR), (OP.TOPOFA.PPMILTO, LC.E198NEUT),
                     (SP.PTYPDIS, LC.E1NEUTI), ),
            para_out=((OP.TOPOFA.PAINTER, LC.E200NEUT), (OP.TOPOFA.PBASECO, LC.E360NEUT),
                     (OP.TOPOFA.PCFACE, LC.E90NEUTI), (SP.PGESCLA, LC.E120NEUT),
                     (OP.TOPOFA.PGESCLO, LC.E102NEUT), (SP.PGMAITR, LC.E120NEUT),
                     (OP.TOPOFA.PLONGCO, LC.E3NEUTI), (OP.TOPOFA.PPINTER, LC.E120NEUT),
                     ),
        ),

        OP.TOPONO(te=120,
            para_in=((OP.TOPONO.PCNSETO, LC.E320NEUI), (OP.TOPONO.PHEAVTO, LC.E32NEUTI),
                     (SP.PLEVSET, LC.N1NEUT_R), (OP.TOPONO.PLONCHA, LC.E10NEUTI),
                     ),
            para_out=((OP.TOPONO.PHEA_NO, LC.N5NEUTI), (OP.TOPONO.PHEA_SE, LC.E32NEUTI),
                     ),
        ),

        OP.TOPOSE(te=514,
            para_in=((SP.PGEOMER, NGEOMER), (SP.PLEVSET, LC.N1NEUT_R),
                     ),
            para_out=((OP.TOPOSE.PAINTTO, LC.E55NEUTR), (OP.TOPOSE.PCNSETO, LC.E320NEUI),
                     (OP.TOPOSE.PHEAVTO, LC.E32NEUTI), (OP.TOPOSE.PLONCHA, LC.E10NEUTI),
                     (OP.TOPOSE.PPINTTO, E33NEUTR), (OP.TOPOSE.PPMILTO, LC.E198NEUT),
                     ),
        ),

        OP.TOU_INI_ELGA(te=99,
            para_out=((OP.TOU_INI_ELGA.PGEOM_R, EGGEOM_R), (OP.TOU_INI_ELGA.PINST_R, LC.EGINST_R),
                     (OP.TOU_INI_ELGA.PNEUT_F, EGNEUT_F), (OP.TOU_INI_ELGA.PNEUT_R, EGNEUT_R),
                     (OP.TOU_INI_ELGA.PSIEF_R, ECONTPG), (OP.TOU_INI_ELGA.PVARI_R, ZVARIPG),
                     ),
        ),

        OP.TOU_INI_ELEM(te=99,
            para_out=((OP.TOU_INI_ELEM.PGEOM_R, LC.CGEOM3D), ),
        ),

        OP.TOU_INI_ELNO(te=99,
            para_out=((OP.TOU_INI_ELNO.PGEOM_R, ENGEOM_R), (OP.TOU_INI_ELNO.PINST_R, LC.ENINST_R),
                     (OP.TOU_INI_ELNO.PNEUT_F, LC.ENNEUT_F), (OP.TOU_INI_ELNO.PNEUT_R, LC.ENNEUT_R),
                     ),
        ),

        OP.XCVBCA(te=558,
            para_in=((OP.XCVBCA.PAINTER, LC.E200NEUT), (OP.XCVBCA.PBASECO, LC.E360NEUT),
                     (OP.XCVBCA.PCFACE, LC.E90NEUTI), (SP.PCOHES, LC.E5NEUTR),
                     (SP.PDEPL_P, DDL_MECA), (SP.PDONCO, CONTX_R),
                     (SP.PGEOMER, NGEOMER), (SP.PINDCOI, LC.I1NEUT_I),
                     (OP.XCVBCA.PLONGCO, LC.E3NEUTI), (OP.XCVBCA.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.XCVBCA.PPINTER, LC.E120NEUT),
                     (OP.XCVBCA.PCOMPOR, CCOMPOR), (OP.XCVBCA.PHEA_NO, LC.N5NEUTI),
                     (SP.PDEPL_M, DDL_MECA), (OP.XCVBCA.PSTANO, STANO_I),),
            para_out=((OP.XCVBCA.PCOHESO, LC.E5NEUTR), (SP.PINCOCA, LC.I1NEUT_I),
                     ),
        ),

        OP.XCVBCA_MORTAR(te=558,
            para_in=((OP.XCVBCA_MORTAR.PAINTER, LC.E200NEUT), (OP.XCVBCA_MORTAR.PBASECO, LC.E360NEUT),
                     (OP.XCVBCA_MORTAR.PCFACE, LC.E90NEUTI), (SP.PCOHES, LC.N5NEUTR),
                     (SP.PDEPL_P, DDL_MECA), (SP.PDONCO, CONTX_R),
                     (SP.PGEOMER, NGEOMER), (SP.PINDCOI, LC.I1NEUT_I),
                     (OP.XCVBCA_MORTAR.PLONGCO, LC.E3NEUTI), (OP.XCVBCA_MORTAR.PLST, LC.N1NEUT_R),
                     (SP.PMATERC, LC.CMATERC), (OP.XCVBCA_MORTAR.PPINTER, LC.E120NEUT),
                     (OP.XCVBCA_MORTAR.PCOMPOR, CCOMPOR), (OP.XCVBCA_MORTAR.PHEA_NO, LC.N5NEUTI),
                     (SP.PDEPL_M, DDL_MECA), (OP.XCVBCA_MORTAR.PSTANO, STANO_I),),
            para_out=((OP.XCVBCA_MORTAR.PCOHESO, LC.N5NEUTR), (SP.PINCOCA, LC.I1NEUT_I),
                     ),
        ),

        OP.VAEX_ELGA(te=549,
            para_in=((OP.VAEX_ELGA.PCOMPOR, CCOMPOR), (SP.PNOVARI, E1NEUTK),
                     (SP.PVARIGR, ZVARIPG), ),
            para_out=((SP.PVARIGS, LC.E1GNEUT), ),
        ),

        OP.VAEX_ELNO(te=549,
            para_in=((OP.VAEX_ELNO.PCOMPOR, CCOMPOR), (SP.PNOVARI, E1NEUTK),
                     (OP.VAEX_ELNO.PVARINR, LC.ZVARINO), ),
            para_out=((SP.PVARINS, LC.E1NNEUT), ),
        ),

    )


#------------------------------------------------------------
class HM_HEXA20_XHC(TemplateElement):
    """Please document this element"""
    meshType = MT.HEXA20
    nodes = (
            SetOfNodes('EN2', (9,10,11,12,13,14,15,16,17,18,19,20,)),
            SetOfNodes('EN1', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.H20, gauss = ('RIGI=FPG27','MASS=FPG27','XFEM=XFEM480','FPG1=FPG1',), mater=('XFEM',),),
            ElrefeLoc(MT.HE8, gauss = ('RIGI=FPG27','MASS=FPG27',),),
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','MASS=FPG9',),),
            ElrefeLoc(MT.T10, gauss = ('XINT=FPG15','NOEU=NOEU',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6','MASS=FPG6','FPG4=FPG4','FPG6=FPG6','FPG3=FPG3','XCON=FPG12',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12',),),
            ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4','MASS=FPG9',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','MASS=FPG4','FPG2=FPG2','FPG3=FPG3','FPG4=FPG4'),),
        )
    calculs = (
        OP.CHAR_MECA_CONT_M(te=-1),

        OP.RIGI_CONT_M(te=-1),

        OP.XCVBCA_MORTAR(te=-1),
    )


#------------------------------------------------------------
class HM_PENTA15_XHC(TemplateElement):
    """Please document this element"""
    meshType = MT.PENTA15
    nodes = (
            SetOfNodes('EN2', (7,8,9,10,11,12,13,14,15,)),
            SetOfNodes('EN1', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.P15, gauss = ('RIGI=FPG21','MASS=FPG21','XFEM=XFEM240','FPG1=FPG1',), mater=('XFEM',),),
            ElrefeLoc(MT.T10, gauss = ('XINT=FPG15','NOEU=NOEU',),),
            ElrefeLoc(MT.PE6, gauss = ('RIGI=FPG21','MASS=FPG21',),),
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','MASS=FPG9',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6','MASS=FPG6','FPG4=FPG4','FPG6=FPG6','FPG3=FPG3','XCON=FPG12',),),
            ElrefeLoc(MT.TR3, gauss = ('MASS=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','MASS=FPG4','FPG2=FPG2','FPG3=FPG3','FPG4=FPG4'),),
        )
    calculs = (
        OP.CHAR_MECA_CONT_M(te=-1),

        OP.RIGI_CONT_M(te=-1),

        OP.XCVBCA_MORTAR(te=-1),
    )


#------------------------------------------------------------
class HM_PYRAM13_XHC(TemplateElement):
    """Please document this element"""
    meshType = MT.PYRAM13
    nodes = (
            SetOfNodes('EN2', (6,7,8,9,10,11,12,13,)),
            SetOfNodes('EN1', (1,2,3,4,5,)),
        )
    elrefe =(
            ElrefeLoc(MT.P13, gauss = ('RIGI=FPG27','MASS=FPG27','XFEM=XFEM180','FPG1=FPG1',), mater=('XFEM',),),
            ElrefeLoc(MT.T10, gauss = ('XINT=FPG15','NOEU=NOEU',),),
            ElrefeLoc(MT.PY5, gauss = ('RIGI=FPG27','MASS=FPG27',),),
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','MASS=FPG9',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6','MASS=FPG6','FPG4=FPG4','FPG6=FPG6','FPG3=FPG3','XCON=FPG12',),),
            ElrefeLoc(MT.TR3, gauss = ('MASS=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','MASS=FPG4','FPG2=FPG2','FPG3=FPG3','FPG4=FPG4'),),
        )
    calculs = (
        OP.CHAR_MECA_CONT_M(te=-1),

        OP.RIGI_CONT_M(te=-1),

        OP.XCVBCA_MORTAR(te=-1),
    )


#------------------------------------------------------------
class HM_TETRA10_XHC(TemplateElement):
    """Please document this element"""
    meshType = MT.TETRA10
    nodes = (
            SetOfNodes('EN2', (5,6,7,8,9,10,)),
            SetOfNodes('EN1', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.T10, gauss = ('RIGI=FPG5','MASS=FPG5','XINT=FPG15','XFEM=XFEM90','FPG1=FPG1',), mater=('XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG15','MASS=FPG15',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6','MASS=FPG6','FPG4=FPG4','FPG6=FPG6','FPG3=FPG3','XCON=FPG12',),),
            ElrefeLoc(MT.TR3, gauss = ('MASS=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','MASS=FPG4','FPG2=FPG2','FPG3=FPG3','FPG4=FPG4'),),
        )
    calculs = (
        OP.CHAR_MECA_CONT_M(te=-1),

        OP.RIGI_CONT_M(te=-1),

        OP.XCVBCA_MORTAR(te=-1),
    )


#------------------------------------------------------------
class HM_HEXA20_XHC3(TemplateElement):
    """Please document this element"""
    meshType = MT.HEXA20
    nodes = (
            SetOfNodes('EN2', (9,10,11,12,13,14,15,16,17,18,19,20,)),
            SetOfNodes('EN3', (1,2,3,4,5,6,7,8,)),
        )
    elrefe =(
            ElrefeLoc(MT.H20, gauss = ('RIGI=FPG27','MASS=FPG27','XFEM=XFEM480','FPG1=FPG1',), mater=('XFEM',),),
            ElrefeLoc(MT.HE8, gauss = ('RIGI=FPG27','MASS=FPG27',),),
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','MASS=FPG9',),),
            ElrefeLoc(MT.T10, gauss = ('XINT=FPG15','NOEU=NOEU',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6','MASS=FPG6','FPG4=FPG4','FPG6=FPG6','FPG3=FPG3','XCON=FPG12',),),
            ElrefeLoc(MT.TR3, gauss = ('FPG4=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12',),),
            ElrefeLoc(MT.QU4, gauss = ('RIGI=FPG4','MASS=FPG9',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','MASS=FPG4','FPG2=FPG2','FPG3=FPG3','FPG4=FPG4'),),
        )
    calculs = (
        OP.CHAR_MECA_CONT(te=-1),

        OP.RIGI_CONT(te=-1),

        OP.XCVBCA(te=-1),
    )


#------------------------------------------------------------
class HM_PENTA15_XHC3(TemplateElement):
    """Please document this element"""
    meshType = MT.PENTA15
    nodes = (
            SetOfNodes('EN2', (7,8,9,10,11,12,13,14,15,)),
            SetOfNodes('EN3', (1,2,3,4,5,6,)),
        )
    elrefe =(
            ElrefeLoc(MT.P15, gauss = ('RIGI=FPG21','MASS=FPG21','XFEM=XFEM240','FPG1=FPG1',), mater=('XFEM',),),
            ElrefeLoc(MT.T10, gauss = ('XINT=FPG15','NOEU=NOEU',),),
            ElrefeLoc(MT.PE6, gauss = ('RIGI=FPG21','MASS=FPG21',),),
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','MASS=FPG9',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6','MASS=FPG6','FPG4=FPG4','FPG6=FPG6','FPG3=FPG3','XCON=FPG12',),),
            ElrefeLoc(MT.TR3, gauss = ('MASS=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','MASS=FPG4','FPG2=FPG2','FPG3=FPG3','FPG4=FPG4'),),
        )
    calculs = (
        OP.CHAR_MECA_CONT(te=-1),

        OP.RIGI_CONT(te=-1),

        OP.XCVBCA(te=-1),
    )


#------------------------------------------------------------
class HM_PYRAM13_XHC3(TemplateElement):
    """Please document this element"""
    meshType = MT.PYRAM13
    nodes = (
            SetOfNodes('EN2', (6,7,8,9,10,11,12,13,)),
            SetOfNodes('EN3', (1,2,3,4,5,)),
        )
    elrefe =(
            ElrefeLoc(MT.P13, gauss = ('RIGI=FPG27','MASS=FPG27','XFEM=XFEM180','FPG1=FPG1',), mater=('XFEM',),),
            ElrefeLoc(MT.T10, gauss = ('XINT=FPG15','NOEU=NOEU',),),
            ElrefeLoc(MT.PY5, gauss = ('RIGI=FPG27','MASS=FPG27',),),
            ElrefeLoc(MT.QU8, gauss = ('RIGI=FPG9','MASS=FPG9',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6','MASS=FPG6','FPG4=FPG4','FPG6=FPG6','FPG3=FPG3','XCON=FPG12',),),
            ElrefeLoc(MT.TR3, gauss = ('MASS=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','MASS=FPG4','FPG2=FPG2','FPG3=FPG3','FPG4=FPG4'),),
        )
    calculs = (
        OP.CHAR_MECA_CONT(te=-1),

        OP.RIGI_CONT(te=-1),

        OP.XCVBCA(te=-1),
    )


#------------------------------------------------------------
class HM_TETRA10_XHC3(TemplateElement):
    """Please document this element"""
    meshType = MT.TETRA10
    nodes = (
            SetOfNodes('EN2', (5,6,7,8,9,10,)),
            SetOfNodes('EN3', (1,2,3,4,)),
        )
    elrefe =(
            ElrefeLoc(MT.T10, gauss = ('RIGI=FPG5','MASS=FPG5','XINT=FPG15','XFEM=XFEM90','FPG1=FPG1',), mater=('XFEM',),),
            ElrefeLoc(MT.TE4, gauss = ('XINT=FPG15','MASS=FPG15',),),
            ElrefeLoc(MT.TR6, gauss = ('RIGI=FPG6','MASS=FPG6','FPG4=FPG4','FPG6=FPG6','FPG3=FPG3','XCON=FPG12',),),
            ElrefeLoc(MT.TR3, gauss = ('MASS=FPG4','NOEU=NOEU','FPG6=FPG6','FPG7=FPG7','XCON=FPG12',),),
            ElrefeLoc(MT.SE3, gauss = ('RIGI=FPG4','MASS=FPG4','FPG2=FPG2','FPG3=FPG3','FPG4=FPG4'),),
        )
    calculs = (
        OP.CHAR_MECA_CONT(te=-1),

        OP.RIGI_CONT(te=-1),

        OP.XCVBCA(te=-1),
    )

del TemplateElement
