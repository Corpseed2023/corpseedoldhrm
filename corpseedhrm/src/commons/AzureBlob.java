package commons;

//import com.amazonaws.services.s3.model.Region;
import com.azure.storage.blob.BlobClientBuilder;

//import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
//import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
//import com.amazonaws.regions.Regions;

//import software.amazon.awssdk.services.s3.S3Client;

public class AzureBlob {

	private static BlobClientBuilder client;
	
//    private static S3Client awsS3Client;

	
	public static BlobClientBuilder getBlobClient(String azure_key,String azure_container){
		if(client==null) {
			client=new BlobClientBuilder()
					.connectionString(azure_key)
					.containerName(azure_container);
		}		
		return client;
	}

//	public static S3Client getAwsS3Client(String accessKey, String secretKey) {
//		if (awsS3Client == null) {
//			AwsBasicCredentials awsCredentials = AwsBasicCredentials.create(accessKey, secretKey);
//			awsS3Client = S3Client.builder()
//					.region(Region.AP_SOUTH_1)
//					.credentialsProvider(StaticCredentialsProvider.create(awsCredentials))
//					.build();
//		}
//		return awsS3Client;
//	}


}
 