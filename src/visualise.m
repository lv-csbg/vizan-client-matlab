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

if verLessThan('matlab','9.1')
    error('Matlab 9.1 (R2016b) or higher is required.');
elseif verLessThan('matlab','9.4')
    % -- Code to run in MATLAB R2016b - R2017b --
    response = visualiseInR2016b(p.Results.modelFile, p.Results.svgFile, p.Results.outputFile, p.Results.analysisType, p.Results.url, p.Results.show);
else
    % -- Code to run in MATLAB R2018a (9.4) and later here --
    response = visualiseInR2018a(p.Results.modelFile, p.Results.svgFile, p.Results.outputFile, p.Results.analysisType, p.Results.url, p.Results.show);
end
end