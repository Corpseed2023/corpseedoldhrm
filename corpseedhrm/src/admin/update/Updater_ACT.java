package admin.update;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import commons.DbCon;

public class Updater_ACT {

	public static void updateCompany() {
		// TODO Auto-generated method stub
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET uacompany='Corpseed ITES Pvt. Ltd.' where uacompany!='Corpseed ITES Pvt. Ltd.'";
			ps = con.prepareStatement(query);						
			ps.execute();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
	}

	public static void convertToSuperUser() {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET uarole='SUPER_USER' where uaroletype='Client'";
			ps = con.prepareStatement(query);						
			ps.execute();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
	}

	public static void updateClientsSuperUser(String superUserId,String cregucid) {
		// TODO Auto-generated method stub
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmclient_reg SET super_user_uaid='"+superUserId+"' where cregucid='"+cregucid+"'";
			ps = con.prepareStatement(query);						
			ps.execute();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
	}

	public static String[][] findUserByRole() {
		// TODO Auto-generated method stub
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer query= new StringBuffer("SELECT uaid,uaempid,uamobileno,uaemailid FROM user_account where uaroletype='Client' and uarole='SUPER_USER'");
			
			stmnt=getacces_con.prepareStatement(query.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{e.printStackTrace();}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
		return newsdata;
	}

	public static void updateDeliveryPerson() {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE managesalesctrl SET delivery_person_uid='214',delivery_person_name='Suneeta Tikoo',delivery_assign_status='1',delivery_assign_date='19-12-2022' where 1";
			ps = con.prepareStatement(query);						
			ps.execute();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
	}

	public static void updateMainContact(String superUserId,String mobile,String email) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			StringBuffer query =new StringBuffer("UPDATE clientcontactbox SET super_user_id='"+superUserId+"' where (ccmobilephone='"+mobile+"' or ccworkphone='"+mobile+"') ");
			if(!email.equalsIgnoreCase("NA"))		
				query.append("or ccemailfirst='"+email+"' or ccemailsecond='"+email+"'");
			ps = con.prepareStatement(query.toString());						
			ps.execute();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
	}

	public static String[][] findAllContacts() {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer query= new StringBuffer("SELECT ccbid,super_user_id,ccbrefid FROM clientcontactbox where super_user_id>0");
			
			stmnt=getacces_con.prepareStatement(query.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{e.printStackTrace();}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
		return newsdata;
	}

	public static void updateSalesContactId(String superUserId, String contactKey) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE contactboxctrl SET super_user_id='"+superUserId+"' where cbcontactrefid='"+contactKey+"' and super_user_id=0";
			ps = con.prepareStatement(query);						
			ps.execute();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
	}
	
	public static void updateUserContactId(String contactId, String superUserId) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET contact_id='"+contactId+"' where uaid='"+superUserId+"'";
			ps = con.prepareStatement(query);						
			ps.execute();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
	}

	public static String[][] fetchAllEstimateClient() {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer query= new StringBuffer("SELECT h.creguid,h.cregclientrefid,h.cregname FROM hrmclient_reg h join estimatesalectrl e on h.cregclientrefid=e.esclientrefid "
					+ "where h.super_user_uaid=0 group by h.creguid");
			
			stmnt=getacces_con.prepareStatement(query.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{e.printStackTrace();}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
		return newsdata;
	}
	
	public static String[][] fetchAllClientWithoutUser() {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer query= new StringBuffer("SELECT h.creguid,h.cregclientrefid,h.cregname FROM hrmclient_reg h join clientcontactbox c on h.cregclientrefid=c.ccbclientrefid WHERE h.super_user_uaid=0");
			
			stmnt=getacces_con.prepareStatement(query.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{e.printStackTrace();}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
		return newsdata;
	}
	
	public static String[][] findContactByKey(String clientkey,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT cccontactfirstname,cccontactlastname,ccemailfirst,ccworkphone,ccbid FROM clientcontactbox where ccbclientrefid='"+clientkey+"' and cctokenno='"+token+"'");
			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
			}
		}
		return newsdata;
	}

	public static void updateClientsSuperUser(int uaid, String cregucid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmclient_reg SET super_user_uaid='"+uaid+"' where creguid='"+cregucid+"'";
			ps = con.prepareStatement(query);						
			ps.execute();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
	}

	public static void updateMainContactSuperUser(int uaid, String ccbid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			StringBuffer query =new StringBuffer("UPDATE clientcontactbox SET super_user_id='"+uaid+"' where ccbid='"+ccbid+"' ");
			
			ps = con.prepareStatement(query.toString());						
			ps.execute();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
			}
		}
	}

}
