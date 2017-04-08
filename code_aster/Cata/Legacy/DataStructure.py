# coding=utf-8

"""
Module cata
-----------

All the objects needed by the legacy supervisor.
"""


from .co_cham_gd_sdaster import (cham_gd_sdaster, carte_sdaster, cham_elem,
    cham_no_sdaster, post_comp_cham_no, post_comp_cham_el)
from .co_char_meca import char_meca
from .co_mater_sdaster import mater_sdaster
from .co_matr_asse import (matr_asse, matr_asse_gd, matr_asse_depl_c,
                           matr_asse_depl_r, matr_asse_pres_c, matr_asse_pres_r,
                           matr_asse_temp_c, matr_asse_temp_r)
from .co_spectre_sdaster import spectre_sdaster
from .co_fonction_class import (fonction_class, fonction_sdaster, fonction_c,
                                nappe_sdaster)
from .co_nume_ddl_gene import nume_ddl_gene
from .co_macr_elem_dyna import macr_elem_dyna
from .co_matr_asse_gene import matr_asse_gene, matr_asse_gene_r, matr_asse_gene_c
from .co_char_acou import char_acou
from .co_maillage_sdaster import maillage_sdaster, grille_sdaster, squelette
from .co_listis_sdaster import listis_sdaster
from .co_type_flui_stru import type_flui_stru
from .co_matr_elem import (matr_elem, matr_elem_depl_c, matr_elem_depl_r,
                           matr_elem_pres_c, matr_elem_temp_r)
from .co_char_contact import char_contact
from .co_macr_elem_stat import macr_elem_stat
from .co_interspectre import interspectre
from .co_fond_fiss import fond_fiss
from .co_char_cine_meca import char_cine_meca
from .co_resultat_sdaster import (resultat_sdaster, comb_fourier, fourier_elas,
                                  fourier_ther, mult_elas, mode_empi,
                                  evol_sdaster, evol_char, evol_elas,
                                  evol_noli, evol_ther, evol_varc)
from .co_listr8_sdaster import listr8_sdaster
from .co_cara_elem import cara_elem
from .co_entier import entier
from .co_modele_sdaster import modele_sdaster
from .co_sd_dyna import (dyna_gene, dyna_phys, harm_gene, tran_gene, acou_harmo,
                         dyna_harmo, dyna_trans, mode_acou, mode_flamb, mode_meca,
                         mode_meca_c, mode_gene)
from .co_melasflu_sdaster import melasflu_sdaster
from .co_modele_gene import modele_gene
from .co_vect_elem import vect_elem, vect_elem_depl_r, vect_elem_pres_c, vect_elem_temp_r
from .co_cabl_precont import cabl_precont
from .co_char_cine_ther import char_cine_ther
from .co_nume_ddl_sdaster import nume_ddl_sdaster
from .co_cham_mater import cham_mater
from .co_char_cine_acou import char_cine_acou
from .co_gfibre_sdaster import gfibre_sdaster
from .co_list_inst import list_inst
from .co_mode_cycl import mode_cycl
from .co_corresp_2_mailla import corresp_2_mailla
from .co_fiss_xfem import fiss_xfem
from .co_table_sdaster import table_sdaster, table_fonction, table_fonction, table_container
from .co_interf_dyna_clas import interf_dyna_clas
from .co_char_ther import char_ther
from .co_compor_sdaster import compor_sdaster
from .co_vect_asse_gene import vect_asse_gene
from .co_reel import reel
