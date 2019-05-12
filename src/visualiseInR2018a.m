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