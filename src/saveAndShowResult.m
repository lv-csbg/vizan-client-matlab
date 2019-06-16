function saveAndShowResult(response, outputFile, show)
fid = fopen(outputFile,'w');
fwrite(fid, response.Body.Data);
fclose(fid);
if show
    if ismac
        % Code to run on Mac platform
        web(outputFile);
    elseif isunix
        % Code to run on Linux platform
    elseif ispc
        % Code to run on Windows platform
        web(outputFile);
    else
        disp('Platform not supported')
    end
    web(outputFile, '-browser');
end
end
