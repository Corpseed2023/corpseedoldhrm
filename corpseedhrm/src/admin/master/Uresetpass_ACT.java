package admin.master;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import commons.DbCon;

public class Uresetpass_ACT {
	private static Logger log = Logger.getLogger(LoginAction.class);
	

	@SuppressWarnings("resource")
	public static boolean updatepassDetail(String ualoginid, String userpass, String newuserpass,String renterpass) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		ResultSet rset=null;
		String pass="";
		boolean status = false;
		try{
			String query="SELECT uapass FROM user_account where ualoginid='"+ualoginid+"' ";
			ps = con.prepareStatement(query);
			rset = ps.executeQuery();

			if(rset.next())
			{
				pass=rset.getString("uapass");
			}
			if(newuserpass.equals(renterpass))
			{
				if(pass.equals(userpass))
				{
					ps = con.prepareStatement("update user_account set uapass=? where ualoginid=? ");
					ps.setString(1,newuserpass );
					ps.setString(2,ualoginid );
					int i=ps.executeUpdate();
					if (i==1) {
						status=true;
					}

				}
				else
					status=false;
			}
		}catch (Exception e) {
			log.info("updatepassDetail"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			}catch(SQLException sqle){
				log.info("Error Closing updatepassDetail() SQL Objects \n"+sqle);
			}
		}
		return status;
	}
	
	//updating user password by admin
	public static boolean updateUserPassword(String ualoginid,String newuserpass,String renterpass) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
				
		boolean status = false;
		try{
			if(newuserpass.equals(renterpass)) {
			ps = con.prepareStatement("update user_account set uapass=? where ualoginid=? ");
			ps.setString(1,newuserpass );
			ps.setString(2,ualoginid );
			int i=ps.executeUpdate();
			
			if(i>0)
				status=true;
			}
			
		}catch (Exception e) {
			log.info("updateUserPassword"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing updateUserPassword() SQL Objects \n"+sqle);
			}
		}
		return status;
	}
}
