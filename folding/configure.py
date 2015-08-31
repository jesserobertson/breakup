#!/usr/bin/env python
""" file: configure.py
    author: Jess Robertson (based on code from Gerris examples)
            CSIRO Mineral Resources Flagship
    date:   Friday March 6, 2015

    description: Python script to run turbulent breakup simulations
"""

import textwrap
import os

def make_definition_args(definitions):
    """ Constructs the relevant arguments for Gerris to apply definitions
    """
    skip = ('run_name', 'gerris', 'num_processors')
    return '\n'.join(('    -D{0}={1} \\'.format(*item)
                      for item in definitions.items()
                      if item[0] not in skip))

def main():
    """ Construct and run the simulation in parallel using MPI
    """
    # Configure current run
    configuration = dict(
        # Flow properties
        reynolds_number = 10,
        vortex_strength = 3.14159,
        offset = 0.25,
        period = 0.5,
        domain_radius = 0.5,

        # Droplet properties
        droplet_radius = 0.1,
        droplet_x = 0.1,
        droplet_y = 0.1,
        surface_tension = 0.01,
        viscosity_ratio = 0.01,

        # Simulation info
        run_name = 'folding',
        gerris = 'gerris2D',
        gfsfile = 'folding.gfs',
        num_processors = 8,
        num_split = 2,
        end_time = 5,
        min_level = 5,
        max_level = 8,
        simulation_output_times = 0.01
    )

    # Load up runinng template
    with open('run_template.sh', 'r') as source:
        template = source.read()
        output = 'run.sh'.format(configuration['run_name'])
        with open(output, 'w') as sink:
            sink.write(
                template.format(
                    definitions=make_definition_args(configuration),
                    **configuration))

    # Change permissions (does `chmod +x run.sh`)
    os.chmod(output, os.stat(output).st_mode | 0o111)

if __name__ == '__main__':
    main()
