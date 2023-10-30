package admin.chat;

import java.util.Objects;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

public final class Message {

    @JsonProperty("username")
    private final String userName;
    @JsonProperty("sendTo")
    private final String sendTo;
    @JsonProperty
    private final String message;
    @JsonProperty
    private final String type;
    @JsonProperty
    private final String client; 
    @JsonProperty
    private final String docpath; 
    @JsonProperty
    private final String docsize; 
    @JsonProperty
    private final String docextension; 
    @JsonProperty
    private final String docname; 
    @JsonProperty
    private final String formKey; 
    @JsonProperty
    private final String formName; 
    
    @JsonCreator
    public Message(@JsonProperty("username") final String userName,@JsonProperty("sendTo") final String sendTo, 
    		@JsonProperty("message") final String message,@JsonProperty("type") final String type,
    		@JsonProperty("client") final String client,@JsonProperty("docpath") final String docpath,
    		@JsonProperty("docsize") final String docsize,@JsonProperty("docextension") final String docextension,
    		@JsonProperty("docname") final String docname,@JsonProperty("formKey") final String formKey,
    		@JsonProperty("formName") final String formName) {
        Objects.requireNonNull(userName);
        Objects.requireNonNull(sendTo);
        Objects.requireNonNull(message);
        Objects.requireNonNull(type);
        Objects.requireNonNull(client);
        Objects.requireNonNull(docpath);
        Objects.requireNonNull(docsize);
        Objects.requireNonNull(docextension);
        Objects.requireNonNull(docname);
        Objects.requireNonNull(formKey);
        Objects.requireNonNull(formName);
        
        this.userName = userName;
        this.sendTo = sendTo;
        this.message = message;
        this.type = type;
        this.client = client;
        this.docpath = docpath;
        this.docsize = docsize;
        this.docextension = docextension;
        this.docname = docname;
        this.formKey = formKey;
        this.formName = formName;
    }

    String getUserName() {
        return this.userName;
    }
    String getSendTo() {
        return this.sendTo;
    }
    String getMessage() {
        return this.message;
    }
    String getType() {
        return this.type;
    }
    String getClient() {
        return this.client;
    }

	public String getDocpath() {
		return docpath;
	}

	public String getDocsize() {
		return docsize;
	}

	public String getDocextension() {
		return docextension;
	}

	public String getDocname() {
		return docname;
	}

	public String getFormKey() {
		return formKey;
	}

	public String getFormName() {
		return formName;
	}

	@Override
	public String toString() {
		return "Message [userName=" + userName + ", sendTo=" + sendTo + ", message=" + message + ", type=" + type + "]";
	}
    
	
    
}
