/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF fonctions_module supervis  DATE 12/05/2005   AUTEUR DURAND C.DURAND */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2005  EDF R&D              WWW.CODE-ASTER.ORG */
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
#include <Python.h>
#include <Numeric/arrayobject.h>

/*
#define __DEBUG__
*/

void calc_SPEC_OSCI( int nbpts, double* vale_x, double* vale_y,
                     int len_f, double* l_freq, int len_a, double* l_amor,
                     double* spectr );


PyObject* SPEC_OSCI( PyObject* self, PyObject* args )
{
   PyObject *OX, *OY, *OF, *OA;
   PyArrayObject *Vx, *Vy, *Vf, *Va, *Sp;
   int dims[3];
   int nbpts, len_f, len_a;

   if (!PyArg_ParseTuple(args,"OOOO:SPEC_OSCI",&OX,&OY,&OF,&OA))
      return NULL;

   Vx=(PyArrayObject*)PyArray_ContiguousFromObject(OX,PyArray_DOUBLE,1,1);
   Vy=(PyArrayObject*)PyArray_ContiguousFromObject(OY,PyArray_DOUBLE,1,1);
   Vf=(PyArrayObject*)PyArray_ContiguousFromObject(OF,PyArray_DOUBLE,1,1);
   Va=(PyArrayObject*)PyArray_ContiguousFromObject(OA,PyArray_DOUBLE,1,1);

   /* verification des arguments */
   if ( ! ( Vx && Vy && Va && Vf ))
      return NULL;
   if ( ! (Vx->nd==1 && Vy->nd==1 && Vf->nd==1 && Va->nd==1 )) {
      PyErr_SetString(PyExc_TypeError,"On attend des objets de dimension 1");
      return NULL;
   }
   if ( Vx->dimensions[0] != Vy->dimensions[0] ) {
      PyErr_SetString(PyExc_TypeError,"Vx et Vy n'ont pas le meme cardinal");
      return NULL;
   }
   if ( Vx->dimensions[0] <= 1 ) {
      PyErr_SetString(PyExc_TypeError,"Vx et Vy n'ont pas assez de valeurs");
      return NULL;
   }

   nbpts = Vx->dimensions[0];
   len_f = Vf->dimensions[0];
   len_a = Va->dimensions[0];
#ifdef __DEBUG__
   printf("<SPEC_OSCI> Nombre de points de la fonction : %d\n", nbpts);
   printf("<SPEC_OSCI> Nombre de frequences            : %d\n", len_f);
   printf("<SPEC_OSCI> Nombre d'amortissements         : %d\n", len_a);
#endif

   dims[0]=len_a;
   dims[1]=3;
   dims[2]=len_f;

   Sp = (PyArrayObject*)PyArray_FromDims(3,dims,PyArray_DOUBLE);
   calc_SPEC_OSCI( nbpts, (double*)Vx->data, (double*)Vy->data,
                   len_f, (double*)Vf->data, len_a, (double*)Va->data,
                   (double*)Sp->data );

   Py_DECREF(Vx);
   Py_DECREF(Vy);
   Py_DECREF(Vf);
   Py_DECREF(Va);
   
   return PyArray_Return(Sp);
}


#ifdef __DEBUG__
/* utile pour le remplissage des contiguous array */
PyObject* _INFO( PyObject* self, PyObject* args )
{
   PyObject *OX;
   PyArrayObject *Vx;
   int ndim, i, j, k, sum, ind;
   double* val;

   if (!PyArg_ParseTuple(args,"O:_INFO",&OX))
      return NULL;

   Vx=(PyArrayObject*)PyArray_ContiguousFromObject(OX,PyArray_DOUBLE,3,3);

   if ( ! Vx )
      return NULL;

   ndim  = Vx->nd;
   printf("Tableau de dimension : %d\n", ndim);
   sum=1;
   for (i=0; i<ndim; i++) {
      printf("dimensions[%d]=%d        strides[%d]=%d\n",
         i, Vx->dimensions[i], i, Vx->strides[i]);
      sum = sum * Vx->dimensions[i];
   }

   if (ndim==3) {
      printf("DUMP du tableau :\n-----------------\n");
      for (i=0; i<Vx->dimensions[0]; i++) {
         for (j=0; j<Vx->dimensions[1]; j++) {
            for (k=0; k<Vx->dimensions[2]; k++) {
               val=(double*)(Vx->data+i*Vx->strides[0]+j*Vx->strides[1]+k*Vx->strides[2]);
               printf("Vx[%d,%d,%d]=%lf\n",i,j,k,*val);
            }
         }
      }
      printf("\nDUMP du data :\n--------------\n");
      val = Vx->data;
      for (i=0; i<Vx->dimensions[0]; i++) {
         for (j=0; j<Vx->dimensions[1]; j++) {
            for (k=0; k<Vx->dimensions[2]; k++) {
               ind=i*Vx->dimensions[1]*Vx->dimensions[2] + j*Vx->dimensions[2] + k;
               printf("Vx[%d,%d,%d / %d]=%lf\n",i,j,k,ind,val[ind]);
            }
         }
      }
   }

   Py_DECREF(Vx);
   Py_INCREF(Py_None);
   return Py_None;
}
#endif



static PyMethodDef methods[] = {
   { "SPEC_OSCI", SPEC_OSCI, METH_VARARGS, "Operation SPEC_OSCI de CALC_FONCTION" },
#ifdef __DEBUG__
   { "_INFO",     _INFO,     METH_VARARGS, "Just for test !" },
#endif
   { NULL, NULL, 0, NULL }
};


void initaster_fonctions(void)
{
   Py_InitModule("aster_fonctions", methods);
   import_array();
}
