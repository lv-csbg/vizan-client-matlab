vizan-client-matlab
===================
A Matlab client for VizAn REST server

.. contents:: **Table of Contents**
    :backlinks: none

Installation
------------

vizan-client-matlab is distributed on ? MATLAB Central ? and is available on Linux/macOS and Windows and supports MATLAB R2018a.

Local Web server
________________

For local server you need to install `Docker <https://docs.docker.com/install/>`_ .
On Linux also you should perform `post-installation steps <https://docs.docker.com/install/linux/linux-postinstall/>`_ .

.. code-block:: bash

    $ docker pull lvcsbg/tools:vizan-webserver

And to run local server:

.. code-block:: matlab

    % To start server
    server = initVizAnLocalServer
    % To stop server
    delete(server)

Usage
-------------

With local server running no need to provide url, so :

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
