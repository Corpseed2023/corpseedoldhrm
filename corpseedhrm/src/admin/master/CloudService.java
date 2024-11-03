package admin.master;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.InputStreamEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

public class CloudService {
    
    private static final String UPLOAD_API_PATH = "http://localhost:9001/crm/uploadFile";

    public static void uploadDocument(File file, String fileName) {
        // Use try-with-resources to ensure proper resource management
        try (CloseableHttpClient httpClient = HttpClients.createDefault();
             InputStream fileContent = new FileInputStream(file)) {

            // Append fileName as a query parameter to the URL
            String urlWithParams = UPLOAD_API_PATH + "?fileName=" + URLEncoder.encode(fileName, StandardCharsets.UTF_8.name());
            HttpPost postRequest = new HttpPost(urlWithParams);

            // Set the InputStreamEntity to send the file content
            InputStreamEntity entity = new InputStreamEntity(fileContent, file.length());
            postRequest.setEntity(entity);

            // Execute the request
            try (CloseableHttpResponse apiResponse = httpClient.execute(postRequest)) {
                int statusCode = apiResponse.getStatusLine().getStatusCode();
                // Check the status code and process the API response
                if (statusCode != 200) {
                    throw new RuntimeException("Failed to upload document. HTTP error code: " + statusCode);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error during file upload: " + e.getMessage(), e);
        }
    }

	public static boolean deleteFileIfExist(String docName) {
		// TODO Auto-generated method stub
		return true;
	}

}