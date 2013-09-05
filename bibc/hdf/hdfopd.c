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
/ Ouverture d'un dataset HDF, renvoie éventuellement une erreur  
/  Paramètres :
/   - in  idfic : identificateur du fichier hdf (hid_t = int)
/   - in  nomg : nom du groupe (char *)
/   - in  nomd : nom du dataset (char *)
/  Résultats :
/     identificateur du dataset, -1 sinon (hid_t = int)
/-----------------------------------------------------------------------------*/
#ifndef _DISABLE_HDF5
#include <hdf5.h>
#endif

INTEGER DEFPSS(HDFOPD, hdfopd, INTEGER *idf, char *nomg, STRING_SIZE lg, char *nomd, STRING_SIZE ln)
{
  INTEGER iret=-1;
#ifndef _DISABLE_HDF5
  hid_t id,idfic,dapl_id; 
  int k,lg2;
  char *nom;
  void *malloc(size_t size); 
  dapl_id=0;
  
  idfic=(hid_t) *idf;
  nom = (char *) malloc((lg+ln+2) * sizeof(char));
  for (k=0;k<lg;k++) {
     nom[k] = nomg[k];
  }
  k=lg-1;
  while (k>=0){
     if(nom[k] == ' ' || nom[k] == '/') { k--;}
     else break;
  }
  nom[k+1] = '/';
  lg2=k+2;
  for (k=0;k<ln;k++) {
     nom[lg2+k] = nomd[k];
  }
  k=lg2+ln-1;
  while (k>=0){
    if (nom[k] == ' ') { k--;}
    else break;
  }
  nom[k+1] = '\0';

  if ( (id = H5Dopen2(idfic,nom,dapl_id)) >= 0) 
    iret = (INTEGER) id;

  free (nom);
#else
  CALL_U2MESS("F", "FERMETUR_3");
#endif
  return iret;
}     
