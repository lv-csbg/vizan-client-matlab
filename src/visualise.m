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
    error('Matlab 9.4 (R2018a) or higher is required.');
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
    fid = fopen(outputFile,'w');
    fwrite(fid, response.Body.Data);
    fclose(fid);
    if show
        web(outputFile, '-browser');
    end
else
    error("Status code is not 200");
end
end