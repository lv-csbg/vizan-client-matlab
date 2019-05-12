function response = visualiseInR2016b(modelFile, svgFile, outputFile, analysisType, url, show)
% Check if input file exists
if ~exist(modelFile,'file')
    throw(MException('visualise:fileNotFound','modelFile was not found.'));
end
% Read file contents
try
    fid = fopen(modelFile, 'r');
    model_data = char(fread(fid)');
    fclose(fid);
catch someException
    throw(addCause(MException('visualise:unableToReadFile','Unable to read modelFile.'),someException));
end
% Check if input file exists
if ~exist(svgFile,'file')
    throw(MException('visualise:fileNotFound','svgFile was not found.'));
end
% Read file contents
try
    fid = fopen(svgFile, 'r');
    svg_data = char(fread(fid)');
    fclose(fid);
catch someException
    throw(addCause(MException('visualise:unableToReadFile','Unable to read svgFile.'),someException));
end

    function [response,completedrequest,history] = sendForm(modelData, svgData, analysisType, url)
        import matlab.net.http.HTTPOptions
        import matlab.net.http.MediaType
        import matlab.net.http.MessageBody
        import matlab.net.http.field.ContentTypeField
        import matlab.net.http.RequestMessage
        
        boundary = "2b56b9076aeea6194cf5a5906fded266";
        type='multipart/form-data';
        fullType = MediaType(type,"boundary",boundary);
        contentTypeFieldForForm = ContentTypeField(fullType);
        
        type_all = matlab.net.http.MediaType('*/*');
        acceptField = matlab.net.http.field.AcceptField(type_all);
        
        header = [contentTypeFieldForForm, acceptField];
        
        options = HTTPOptions('CertificateFilename','', 'ConnectTimeout', 60);
        method = matlab.net.http.RequestMethod.POST;
        eol = [char(13),newline];
        
        formDataStart = "--" + boundary + eol;
        formDataEnd = "--" + boundary + '--' + eol;
        analysis = sprintf('Content-Disposition: form-data; name="analysis_type"%2$s%2$s%1$s%2$s', analysisType, eol);
        model = sprintf('Content-Disposition: form-data; name="model"; filename="iML1515.json"%2$s%2$s%1$s%2$s', modelData, eol);
        svg = sprintf('Content-Disposition: form-data; name="svg"; filename="E_coli_source.svg"%2$s%2$s%1$s%2$s', svgData, eol);
        body_data = formDataStart + analysis + formDataStart + svg + formDataStart + model + formDataEnd;
        body = MessageBody(body_data);
        request = matlab.net.http.RequestMessage(method,header, body);
        [response,completedrequest,history] = send(request, url, options);
    end
[response,~,~] = sendForm(model_data, svg_data, analysisType, url);

if response.StatusCode == 200
    saveAndShowResult(response, outputFile, show)
else
    error("Status code is not 200");
end
end