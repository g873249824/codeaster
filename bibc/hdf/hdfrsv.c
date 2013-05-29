/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2012  EDF R&D              WWW.CODE-ASTER.ORG */
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
/* ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,      */
/*    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.     */
/* ================================================================== */
#include "aster.h"
#include "aster_fort.h"
/*-----------------------------------------------------------------------------/
/ Lecture sur un fichier HDF d'un segment de valeur associé à un objet JEVEUX
/  Paramètres : 
/   - in  idfic  : identificateur du dataset (hid_t)
/   - out  sv    : valeurs associées 
/   - in  lsv    : nombre de valeurs 
/   - in  icv    : active ou non la conversion Integer*8/integer*4
/  Résultats :
/     =0 OK, -1 sinon 
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif

INTEGER DEFPPPP(HDFRSV, hdfrsv, INTEGER *idat, INTEGER *lsv, void *sv, INTEGER *icv)
{
  INTEGER iret=-1;
#ifndef _DISABLE_HDF5
  hid_t ida,datatype,dasp,bidon=0;
  herr_t ier;
  hsize_t dims[1];
  int rank,status;

  ida = (hid_t) *idat;
  rank = 1;
  if ((datatype = H5Dget_type(ida))>=0 ) {     
    if ((dasp = H5Dget_space(ida))>=0 ) { 
      if ((rank = H5Sget_simple_extent_ndims(dasp))==1) {
        status = H5Sget_simple_extent_dims(dasp, dims, NULL);
      }
      if (*lsv >= (long) dims[0]) {
        if ((ier = H5Dread(ida, datatype, H5S_ALL, H5S_ALL, H5P_DEFAULT, sv))>=0 ) {
          if ( H5Tequal(H5T_STD_I32LE,datatype)>0 || H5Tequal(H5T_STD_I64LE,datatype)>0  ||
               H5Tequal(H5T_STD_I32BE,datatype)>0 || H5Tequal(H5T_STD_I64BE,datatype)>0 ) {
            if (*icv != 0) { 
          if ((H5Tconvert(datatype,H5T_NATIVE_LONG,*lsv,sv,NULL,bidon)) >= 0) {
                iret = 0;
              }
            } else { iret = 0; }
          } else { iret = 0; }
          H5Tclose(datatype);
        }
      }   
      H5Sclose(dasp);
    }
  }
#else
  CALL_U2MESS("F", "FERMETUR_3");
#endif
  return iret ; 
}
