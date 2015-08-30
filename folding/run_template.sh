#!/usr/bin/env bash
#   file:   run_template.bash
#   author: Jess Robertson
#           CSIRO Mineral Resources Flagship
#   date:   Friday March 6, 2015
#
#   description: Bash template for generating Gerris runs. Don't modify this
#       script directly - there should be a Python script to generate an actual
#       bash script to run Gerris.
#
echo "Generating initial simulation file"
{gerris} -m \
{definitions}
    -s{num_split} -i {gfsfile} > {run_name}_mod.gfs

echo "Generating initial partition"
{gerris} -b{num_processors} {run_name}_mod.gfs \
	> {run_name}_parallel.gfs

echo "Running parallel simulation"
mpirun -np {num_processors} {gerris} {run_name}_parallel.gfs

echo "Finished parallel simulation"
