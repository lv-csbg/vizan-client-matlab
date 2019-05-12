function saveAndShowResult(response, outputFile, show)
fid = fopen(outputFile,'w');
fwrite(fid, response.Body.Data);
fclose(fid);
if show
    web(outputFile, '-browser');
end
end
