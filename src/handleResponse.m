function handleResponse(response, outputFile, show)
import matlab.net.http.StatusCode

sc = response.StatusCode;
if sc ~= matlab.net.http.StatusCode.OK
    disp([getReasonPhrase(getClass(sc)),': ',getReasonPhrase(sc)]);
    disp(response.StatusLine.ReasonPhrase);
    disp(response.Body.Data);
else
    saveAndShowResult(response, outputFile, show)
end
end
