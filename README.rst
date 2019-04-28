vizan-client-matlab
===================
A Matlab client for VizAn REST server

.. contents:: **Table of Contents**
    :backlinks: none

Installation
------------

vizan-client-matlab is available on Linux/macOS and Windows and supports MATLAB R2018a but probably supports earlier versions too.

You can use  MATLAB toolbox file. It is found under Releases.

Or you can install toolbox manually. First, clone repo:

.. code-block:: bash

    $ git clone https://github.com/lv-csbg/vizan-client-matlab.git
    $ matlab -nodesktop -nojvm -r "addpath(genpath('vizan-client-matlab')); exit;"

Or in MATLAB change working directory to git directory and:

.. code-block:: matlab

    addpath(genpath(pwd))

Local Web server
________________

For local server you need to install `Docker <https://docs.docker.com/install/>`_ .
On Linux also you should perform `post-installation steps <https://docs.docker.com/install/linux/linux-postinstall/>`_ .
To download the needed docker image enter this command into Terminal:

.. code-block:: bash

    $ docker pull lvcsbg/tools:vizan-rest-server-slim

And to run local server directly from MATLAB:

.. code-block:: matlab

    % To start server
    server = initVizAnLocalServer
    % To stop server
    delete(server)

Usage
-------------

With local server running there is no need to provide url, so :

.. code-block:: matlab

    % To start server
    server = initVizAnLocalServer
    % When using local server 'url' parameter is not needed
    res1 = visualise('model.json','model_map.svg','fba_result.svg', 'FBA');
    res2 = visualise('iML1515.json','E_coli_source.svg','my_matlab_output_fba.svg', 'FBA');
    % To stop server
    delete(server)

Development
-----------

To install the development version from Github:

.. code-block:: bash

    git clone https://github.com/lv-csbg/vizan-client-matlab.git
    cd vizan-client-matlab

License
-------

vizan-client-matlab is distributed under the terms of `GPL v3 License <https://choosealicense.com/licenses/gpl-3.0/>`_

docker_server module is also distributed under the terms of `MIT License <https://choosealicense.com/licenses/mit/>`_
