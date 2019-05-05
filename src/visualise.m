function response = visualise(modelFile, svgFile, outputFile, varargin)

defaultAnalysisType='FBA';
defaultUrl = 'https://localhost/2/';
defaultShow = true;

p = inputParser;
validText = @(x) (ischar(x) || isstring(x));
addRequired(p,'modelFile',validText);
addRequired(p,'svgFile',validText);
addRequired(p,'outputFile',validText);
addOptional(p,'analysisType',defaultAnalysisType,validText);
addOptional(p,'url',defaultUrl,validText);
addOptional(p,'show',defaultShow,@islogical);
parse(p,modelFile,svgFile,outputFile,varargin{:});

if verLessThan('matlab','9.4')
    % -- Code to run in MATLAB R2017b and earlier here --
    % error('Matlab 9.4 (R2018a) or higher is required.');
    response = visualiseInR2016b(p.Results.modelFile, p.Results.svgFile, p.Results.outputFile, p.Results.analysisType, p.Results.url, p.Results.show);
else
    % -- Code to run in MATLAB R2018a and later here --
    response = visualiseInR2018a(p.Results.modelFile, p.Results.svgFile, p.Results.outputFile, p.Results.analysisType, p.Results.url, p.Results.show);
end

end

function response = visualiseInR2018a(modelFile, svgFile, outputFile, analysisType, url, show)
import matlab.net.http.io.FileProvider

modelProvider = FileProvider(modelFile);
svgProvider = FileProvider(svgFile);

    function [response,completedrequest,history] = sendForm(modelProvider, svgProvider, analysisType, url)
        import matlab.net.http.io.MultipartFormProvider
        import matlab.net.http.HTTPOptions
        
        formProvider = MultipartFormProvider("model",modelProvider,"svg",svgProvider, "analysis_type", analysisType);
        options = HTTPOptions('CertificateFilename','', 'ConnectTimeout', 60);
        method = matlab.net.http.RequestMethod.POST;
        request = matlab.net.http.RequestMessage(method,[],formProvider);
        [response,completedrequest,history] = send(request, url, options);
    end
[response,~,~] = sendForm(modelProvider, svgProvider, analysisType, url);

if response.StatusCode == 200
    saveAndShowResult(response, outputFile, show)
else
    error("Status code is not 200");
end
end

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
        fullType = MediaType(type,"boundary",boundary)
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

function saveAndShowResult(response, outputFile, show)
fid = fopen(outputFile,'w');
fwrite(fid, response.Body.Data);
fclose(fid);
if show
    web(outputFile, '-browser');
end
end
