package commons;

public class Message {
	
	private String uid;
	private String client;
	private String salesKey;
	private String message;
	
	public Message(String uid, String client, String salesKey, String message) {
		super();
		this.uid = uid;
		this.client = client;
		this.salesKey = salesKey;
		this.message = message;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getClient() {
		return client;
	}

	public void setClient(String client) {
		this.client = client;
	}

	public String getSalesKey() {
		return salesKey;
	}

	public void setSalesKey(String salesKey) {
		this.salesKey = salesKey;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
