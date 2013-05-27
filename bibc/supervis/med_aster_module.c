/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF med_aster_module supervis  DATE 02/04/2013   AUTEUR LEFEBVRE J-P.LEFEBVRE */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2013  EDF R&D              WWW.CODE-ASTER.ORG */
/*                                                                    */
/* THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR      */
/* MODIFY IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS     */
/* PUBLISHED BY THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE */
/* LICENSE, OR (AT YOUR OPTION) ANY LATER VERSION.                    */
/* THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL,    */
/* BUT WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF     */
/* MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU   */
/* GENERAL PUBLIC LICENSE FOR MORE DETAILS.                           */
/*                                                                    */
/* YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE  */
/* ALONG WITH THIS PROGRAM; IF NOT, WRITE TO : EDF R&D CODE_ASTER,    */
/*    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.     */
/* ================================================================== */
/* person_in_charge: nicolas.sellenet at edf.fr */
#include "Python.h"

#include "aster_utils.h"

#ifndef _DISABLE_MED
#include "med.h"

/* ---------------------------------------------------------------------- */
static PyObject * aster_nom_ch_med(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    PyObject *dic_champ_comp = (PyObject*)0;
    PyObject *tupstr;
    char* nomFichierMed;
    int nbChamps;
    char* nomChamp;
    char* nomMaillage;
    char* dtUnit;
    int iChamp;
    int nbComp;
    char* nomsComp;
    char* unitesComp;
    med_idt numFichier = 0;
    med_bool mailLoc;
    med_field_type typeChamp;
    med_int nbCstp;

    if (!PyArg_ParseTuple(args, "s", &nomFichierMed)) return NULL;

    numFichier = MEDfileOpen(nomFichierMed,MED_ACC_RDONLY);
    if ( numFichier <= 0 ) return PyList_New(0);

    nbChamps = (int)MEDnField(numFichier);

    nomChamp = MakeBlankFStr(MED_NAME_SIZE);
    nomMaillage = MakeBlankFStr(MED_NAME_SIZE);
    dtUnit = MakeBlankFStr(MED_NAME_SIZE);
    dic_champ_comp = PyDict_New();
    for (iChamp = 1; iChamp <= nbChamps; ++iChamp) {
        nbComp = (int)MEDfieldnComponent(numFichier,iChamp);
        nomsComp = MakeBlankFStr(nbComp*MED_SNAME_SIZE);
        unitesComp = MakeBlankFStr(nbComp*MED_SNAME_SIZE);

        MEDfieldInfo(numFichier, iChamp, nomChamp, nomMaillage, &mailLoc, &typeChamp,
                     nomsComp, unitesComp, dtUnit, &nbCstp);
        tupstr = MakeTupleString((long)nbComp, nomsComp, (STRING_SIZE)MED_SNAME_SIZE, NULL);

        PyDict_SetItem(dic_champ_comp, PyString_FromString(nomChamp), tupstr);
        FreeStr(nomsComp);
        FreeStr(unitesComp);
    }
    MEDfileClose(numFichier);

    FreeStr(nomChamp);
    FreeStr(nomMaillage);
    FreeStr(dtUnit);

    return dic_champ_comp;
}

#ifndef _WITHOUT_PYMOD_
static PyMethodDef methods[] = {
    {"get_nom_champ_med", aster_nom_ch_med, METH_VARARGS},
    { NULL, NULL, 0, NULL }
};


PyMODINIT_FUNC initmed_fonctions(void)
{
    Py_InitModule("med_aster", methods);
}
#endif
#endif
