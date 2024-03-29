#!/bin/bash
  
# Clone code bases

XIOS_DIR=$CODE_DIR/xios
svn checkout http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/branchs/xios-2.5 $XIOS_DIR

ERSEM_DIR=$CODE_DIR/ersem
git clone https://github.com/pmlmodelling/ersem.git $ERSEM_DIR
#git clone https://github.com/yutiPML/ersem-yuti.git $ERSEM_DIR

FABM_DIR=$CODE_DIR/fabm
git clone https://github.com/fabm-model/fabm.git $FABM_DIR

NEMO_DIR=$CODE_DIR/nemo
#git clone https://gitlab.ecosystem-modelling.pml.ac.uk/gle/nemo404.git $NEMO_DIR
git clone https://github.com/pmlmodelling/NEMO4.0-FABM.git $NEMO_DIR
