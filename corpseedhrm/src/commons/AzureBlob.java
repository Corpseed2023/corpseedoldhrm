package commons;

import com.azure.storage.blob.BlobClientBuilder;

public class AzureBlob {

	private static BlobClientBuilder client;
	
	public static BlobClientBuilder getBlobClient(String azure_key,String azure_container){
		if(client==null) {
			client=new BlobClientBuilder()
					.connectionString(azure_key)
					.containerName(azure_container);
		}		
		return client;
	}
}
