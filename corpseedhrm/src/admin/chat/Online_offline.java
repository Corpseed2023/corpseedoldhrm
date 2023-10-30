package admin.chat;

import javax.websocket.Session;
import javax.websocket.server.PathParam;


public class Online_offline {

	
    public static boolean isOnline(@PathParam(Constants.USER_NAME_KEY) final String userName, final Session session) {
       
    	boolean flag=true;
    	
            session.getUserProperties().put(Constants.USER_NAME_KEY, userName);
            flag=ChatSessionManager.isOnline(session); 
            
            
       return flag; 
    }

}
