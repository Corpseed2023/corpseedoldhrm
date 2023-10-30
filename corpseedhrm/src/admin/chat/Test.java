package admin.chat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import commons.DbCon;

public class Test {

	public static void main(String[] args) {
		
		updateClientKeyInEstimate();
		
		
	}
	
	public static boolean updateClientKeyInEstimate(){
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE task_notification SET tnaddedforid='211' WHERE tnaddedforid='207'";
			ps = con.prepareStatement(query);
			
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
			}
		}
		return status;
	}

}
