function server = initVizAnLocalServer()
fprintf("Initialising VizAn Local REST Server...\n");
addpath(genpath('docker_server'));
server = localServer;
end