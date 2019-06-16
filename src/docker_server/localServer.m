classdef localServer
    %LOCALSERVER Summary of this class goes here
    %   This class instance runs docker-compose on class instance 
    %   initialisation and shuts down on class instance deletion.
    
    properties
        status
        cmdout
    end
    
    methods
        function obj = localServer(path)
            %LOCALSERVER Construct an instance of this class
            %   Start local server using docker-compose
            fprintf("Starting local server...\n");
            command = 'docker-compose up -d --force-recreate';
            [obj.status, obj.cmdout] = obj.runCommandHere(command);
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
            exportPath = '';
            exportBashPath = "export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin;";
            exportCshPath = "set path = ($path /usr/local/bin /usr/bin /bin /usr/sbin /sbin);";
            if ismac
                % Code to run on Mac platform
                % Prepend the standard default path that Mac OS uses in the command line
                exportPath = exportBashPath;
            elseif isunix
                % Code to run on Linux platform
                shell = '';
                [shStatus, shCmdout] = system("echo $SHELL");
                if shStatus == 0
                    if isequal(shCmdout(1:9), '/bin/bash')
                        shell = 'bash';
                    elseif isequal(shCmdout(1:8), '/bin/csh')
                        shell = 'csh';
                    elseif isequal(shCmdout(1:9), '/bin/tcsh')
                        shell = 'tcsh';
                    end
                end
                if isequal(shell, 'bash')
                    exportPath = exportBashPath;
                elseif isequal(shell, 'csh') || isequal(shell, 'tcsh')
                    exportPath = exportCshPath;
                end
            elseif ispc
                % Code to run on Windows platform
            else
                disp('Platform not supported')
            end
            [status,cmdout] = system(exportPath+command);
            cd(initialFolder);
        end
    end
end

