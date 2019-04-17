classdef localServer
    %LOCALSERVER Summary of this class goes here
    %   This class instance runs docker-compose on class instance 
    %   initialisation and shuts down on class instance deletion.
    
    properties
        status
        cmdout
    end
    
    methods
        function obj = localServer()
            %LOCALSERVER Construct an instance of this class
            %   Start local server using docker-compose
            fprintf("Starting local server...\n");
            command = 'docker-compose up -d --force-recreate';
            [obj.status, obj.cmdout] = obj.runCommandHere(command);
            % [obj.status, obj.cmdout] = runDockerCompose()
        end       
        function delete(obj)
            % Stop local server
            fprintf("Stopping local server...\n");
            command = 'docker-compose down';
            [del_status,del_cmdout] = obj.runCommandHere(command);
            fprintf("Status: "+int2str(del_status)+"\n");
            fprintf(del_cmdout);
        end
    end
    methods(Static)
        function [status, cmdout] = runCommandHere(command)
            % Runs command from the directory, where this file is
            initialFolder = pwd;
            filename = mfilename('fullpath');
            [filepath,~,~] = fileparts(filename);
            cd(filepath);
            [status,cmdout] = system(command);
            cd(initialFolder);
        end
    end
end

