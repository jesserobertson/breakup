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
mpirun -np 1 --output-filename {run_name}_mod.gfs {gerris} -m \
{definitions}
    -s{num_split} -i {gfsfile}
mv {run_name}.gfs.1.0 {run_name}.gfs
rm -f {run_name}.gfs.*

echo "Generating initial partition"
mpirun -np 1 --output-filename {run_name}_parallel.gfs {gerris} \
    -b{num_processors} {run_name}_mod.gfs
mv {run_name}_parallel.gfs.1.0 {run_name}_parallel.gfs
rm -f {run_name}_parallel.gfs.*

echo "Running parallel simulation"
mpirun -np {num_processors} {gerris} {run_name}_parallel.gfs

cd ../../src
echo "Finished parallel simulation"
