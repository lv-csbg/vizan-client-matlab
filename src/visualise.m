function response = visualise(modelFile, svgFile, outputFile, varargin)
import matlab.net.http.io.FileProvider

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

modelProvider = FileProvider(p.Results.modelFile);
svgProvider = FileProvider(p.Results.svgFile);

    function [response,completedrequest,history] = sendForm(modelProvider, svgProvider, analysisType, url)
        import matlab.net.http.io.MultipartFormProvider
        import matlab.net.http.HTTPOptions
        
        formProvider = MultipartFormProvider("model",modelProvider,"svg",svgProvider, "analysis_type", analysisType);
        options = HTTPOptions('CertificateFilename','', 'ConnectTimeout', 60);
        method = matlab.net.http.RequestMethod.POST;
        request = matlab.net.http.RequestMessage(method,[],formProvider);
        [response,completedrequest,history] = send(request, url, options);
    end
[response,~,~] = sendForm(modelProvider, svgProvider, p.Results.analysisType, p.Results.url);

if response.StatusCode == 200
    fid = fopen(p.Results.outputFile,'w');
    fwrite(fid, response.Body.Data);
    fclose(fid);
    if p.Results.show
        web(p.Results.outputFile, '-browser');
    end
else
    error("Status code is not 200");
end
end

