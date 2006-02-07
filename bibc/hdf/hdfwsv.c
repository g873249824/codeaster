/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF hdfwsv hdf  DATE 06/02/2006   AUTEUR ASSIRE A.ASSIRE */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2003  EDF R&D              WWW.CODE-ASTER.ORG */
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
/*-----------------------------------------------------------------------------/
/ Ecriture sur un fichier HDF d'un segment de valeur associ� � un objet JEVEUX
/  Param�tres : 
/   - in  idfic  : identificateur du fichier (hid_t)
/   - in  nomg   : nom du groupe (char *)
/   - in  nomdts : nom du dataset (char *)
/   - in  type   : type des valeurs stock�es (char *)
/   - in  sv     : valeurs associ�es 
/  R�sultats :
/     identificateur du fichier, -1 sinon (hid_t = int)
/-----------------------------------------------------------------------------*/
#include <hdf5.h>
#include <stdlib.h>
#if defined SOLARIS || IRIX || P_LINUX || TRU64 || SOLARIS64 
   long hdfwsv_( long *idf, char *nomg, char *nomdts, char *type, long *ltype, void *sv, long *lsv, long lg, long ln, long lt )
#elif defined HPUX
   long hdfwsv ( long *idf, char *nomg, char *nomdts, char *type, long *ltype, void *sv, long *lsv, long lg, long ln, long lt )
#elif defined PPRO_NT
  /* extern long __stdcall HDFWSV(long *idf, char *nomg, unsigned long lg, char *nomdts, unsigned long ln, char *type, long *ltype, unsigned long lt, void *sv, long *lsv ) */
   extern long __stdcall HDFWSV(long *idf, char *nomg, unsigned long lg, char *nomdts, unsigned long ln, char *type, unsigned long lt, long *ltype, char *sv, unsigned long toto, long *lsv )
#endif
{
  hid_t idfic,datatype,dataspace,dataset,type_id;
  herr_t iret;
  hsize_t dimsf[1];
  int istat,k,l,lg2,lmot;
  char *nomd,*vtype,*mot,*pmot;

  idfic=(hid_t) *idf;
  nomd = (char *) malloc((lg+ln+2) * sizeof(char));
  for (k=0;k<lg;k++) {
     nomd[k] = nomg[k];
  }
  k=lg-1;
  while (nomd[k] == ' ') { k--;}
  nomd[k+1] = '/';
  lg2=k+1+1;
  for (k=0;k<ln;k++) {
     nomd[lg2+k] = nomdts[k];
  }
  k=lg2+ln-1;
  while (nomd[k] == ' ') { k--;}
  nomd[k+1] = '\0';

  vtype = (char *) malloc((lt+1) * sizeof(char));
  for (k=0;k<lt;k++) {
     vtype[k] = type[k];
  }
  vtype[lt] = '\0';
/*
 *   Type � d�terminer en fonction de l'argument type 
*/
  dimsf[0] = *lsv;
  if        ((istat=strcmp(vtype,"R"))==0) {
    type_id = H5T_NATIVE_DOUBLE; 
  } else if ((istat=strcmp(vtype,"C"))==0) {    
    type_id = H5T_NATIVE_DOUBLE; 
    dimsf[0] = *lsv;
  } else if ((istat=strcmp(vtype,"I"))==0) {    
    type_id = H5T_NATIVE_LONG; 
  } else if ((istat=strcmp(vtype,"S"))==0) {    
    type_id = H5T_NATIVE_INT; 
  } else if ((istat=strcmp(vtype,"L"))==0) {    
    type_id = H5T_NATIVE_HBOOL; 
  } else if ((istat=strcmp(vtype,"K"))==0) {    
    type_id = H5T_FORTRAN_S1; 
    pmot = (char *) sv;
    lmot = *lsv*(*ltype);
    mot = (char *) malloc(lmot*sizeof(char));
    for (k=0;k<*lsv;k++) {
        mot[k] = *pmot;
        pmot = pmot+(*ltype);
    }
  } else {
    return -1 ;
  }     
  if ((istat=strcmp(vtype,"K"))==0) { 
    if ((datatype = H5Tcopy(type_id))<0 )   
      return -1 ;
    if ((istat=strcmp(vtype,"K"))==0) {
      if ((iret = H5Tset_size(datatype,*ltype)) <0 ) return -1; 
      if ((iret = H5Tset_strpad(datatype, H5T_STR_SPACEPAD)) <0 ) return -1;  
    }
  } else {
    datatype=type_id;
  }  

  if ((dataspace = H5Screate_simple(1, dimsf, NULL))<0 )
    return -1 ; 
  if ((dataset = H5Dcreate(idfic, nomd, datatype, dataspace, H5P_DEFAULT))<0 )
    return -1 ;
  if ((iret = H5Dwrite(dataset, datatype, H5S_ALL, H5S_ALL, H5P_DEFAULT, sv))<0 )
    return -1 ;
  if ((iret = H5Dclose(dataset))<0 )
    return -1 ;
  if ((iret = H5Sclose(dataspace))<0 )
    return -1 ;
  if ((istat=strcmp(vtype,"K"))==0) { 
    if ((iret = H5Tclose(datatype))<0 )
      return -1 ;
  }  

  free(nomd);
  free(vtype);
  if ((istat=strcmp(vtype,"K"))==0) { free(mot);}
  return 0 ; 
}
