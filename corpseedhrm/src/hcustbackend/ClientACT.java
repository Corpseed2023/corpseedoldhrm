package hcustbackend;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.apache.log4j.Logger;

import commons.DbCon;
import salary_master.SalaryStr_ACT;

public class ClientACT {

	private static Logger log = Logger.getLogger(SalaryStr_ACT.class);
	
	public static String[][] getAllClientNotifications(String token, String creguid,String searchFromToDate) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate="NA";
		String toDate="NA";
		try {
			if(!searchFromToDate.equalsIgnoreCase("NA")) {
				fromDate=searchFromToDate.substring(0,10).trim();
				fromDate=fromDate.substring(6,10)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=searchFromToDate.substring(13).trim();
				toDate=toDate.substring(6,10)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
//				System.out.println(fromDate+"/"+toDate);
			}
			
			StringBuffer query =new StringBuffer("SELECT nKey,nDate,nRedirectPage,nSeenStatus,nMessage FROM notifications where nShowUid='"
					+ creguid + "' and nToken='" + token + "' and nShowClient='1'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA"))
				query.append(" and str_to_date(nDate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(nDate,'%d-%m-%Y')>='"+fromDate+"'");
			
			query.append(" order by nId desc ");
			
			stmnt = con.prepareStatement(query.toString());
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
			log.info("getAllClientNotifications" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllClientNotifications" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static boolean updateFollowUpUnread(String salesKey,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmproject_followup SET pfunreadstatus=? WHERE pfsaleskey=? and pfunreadstatus=? and pftokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,"1");
			ps.setString(2,salesKey );
			ps.setString(3,"2" );	
			ps.setString(4,token );	
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateFollowUpUnread"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateFollowUpUnread:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateUnseenStatus(String salesKey,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE managesalesctrl SET msunseenchat=? WHERE msrefid=? and mstoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1,"0");
			ps.setString(2,salesKey );	
			ps.setString(3,token );	
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateUnseenStatus"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateUnseenStatus:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateChatUnseenStatus(String salesKey,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE managesalesctrl SET msunseenchatadmin=msunseenchatadmin+"+1+",mschatnotreplied='0',msunseenchat='0' WHERE msrefid=? and mstoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1,salesKey );	
			ps.setString(2,token );	
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateChatUnseenStatus"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateChatUnseenStatus:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateMilestonesStatusOpen(String maid,String token,String date,String time) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE manage_assignctrl SET maworkstatus=?,madate=?,matime=? WHERE maid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,"Open");
			ps.setString(2, date);
			ps.setString(3, time);
			ps.setString(4,maid );
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateMilestonesStatusOpen"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateMilestonesStatusOpen:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateUserAccount(String clientno,String bussPhone,String bussEmail,String oldname,String bussName,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET uamobileno=?,uaemailid=?,uaname=? WHERE uaempid=? and uavalidtokenno=? and uaname=?";
			ps = con.prepareStatement(query);
			ps.setString(1,bussPhone);
			ps.setString(2,bussEmail );	
			ps.setString(3,bussName );	
			ps.setString(4,clientno );	
			ps.setString(5,token );	
			ps.setString(6,oldname );	
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateUserAccount"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateUserAccount:\n"+sqle);
			}
		}
		return status;
	}

	public static boolean updateLedgerStatement(String ledgerkey,String invoice,String bussName,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String remarks="#"+invoice+" - "+bussName;
			String query = "UPDATE managetransactionctrl SET mtaccounts=?,mtremarks=? WHERE mtrefid=? and mttokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,bussName);
			ps.setString(2,remarks);
			ps.setString(3,ledgerkey);
			ps.setString(4,token );	
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			e.printStackTrace();
			log.info("updateLedgerStatement"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateLedgerStatement:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateClientContactBox(String clientrefid,String bussName,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE clientcontactbox SET cccompanyname=? WHERE ccbclientrefid=? and cctokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,bussName);
			ps.setString(2,clientrefid);
			ps.setString(3,token );	
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateClientContactBox"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateClientContactBox:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateFolder(String clientid,String bussName,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE folder_master SET fname=? WHERE fclientid=? and ftokenno=? and ffcategory=?";
			ps = con.prepareStatement(query);
			ps.setString(1,bussName);
			ps.setString(2,clientid);
			ps.setString(3,token );	
			ps.setString(4,"Main" );
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateFolder"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateFolder:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateBillingData(String clientrefid,String bussName,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmclient_billing SET cbcompanyname=? WHERE cbclientrefid=? and cbtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,bussName);
			ps.setString(2,clientrefid);
			ps.setString(3,token );	
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateBillingData"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateBillingData:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateEstimateSale(String clientrefid,String bussName,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE estimatesalectrl SET escompany=? WHERE esclientrefid=? and estoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1,bussName);
			ps.setString(2,clientrefid);
			ps.setString(3,token );	
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateEstimateSale"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateEstimateSale:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateManageSale(String clientrefid,String bussName,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE managesalesctrl SET mscompany=? WHERE msclientrefid=? and mstoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1,bussName);
			ps.setString(2,clientrefid);
			ps.setString(3,token );	
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateManageSale"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateManageSale:\n"+sqle);
			}
		}
		return status;
	}
																							
	public static boolean updateClientPersonalDetails(String clientrefid,String firstName,String lastName,String Email,String mobile,String City,String State,String Address,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmclient_reg SET cregcontfirstname=?,cregcontlastname=?,cregcontemailid=?,cregcontmobile=?,cregcontcity=?,cregcontstate=?,cregcontaddress=? WHERE cregclientrefid=? and cregtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,firstName);
			ps.setString(2,lastName);
			ps.setString(3,Email );	
			ps.setString(4,mobile );	
			ps.setString(5,City );	
			ps.setString(6,State );	
			ps.setString(7,Address );	
			ps.setString(8,clientrefid );	
			ps.setString(9,token );	
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateClientPersonalDetails"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateClientPersonalDetails:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateDynamicFormData(String fKey,String formData,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmproject_followup SET pfdynamicform=?,pfformsubmitstatus=? WHERE pfkey=? and pftokenno=?";
			
			ps = con.prepareStatement(query);
			ps.setString(1,formData);
			ps.setString(2,"1");
			ps.setString(3,fKey);
			ps.setString(4,token );	
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			e.printStackTrace();
			log.info("updateDynamicFormData"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateDynamicFormData:\n"+sqle);
			}
		}
		return status;
	}
	
	public static boolean updateClientDetails(String clientrefid,String bussName,String bussPhone,String bussEmail,
			String industryType,String bussCity,String bussState,String bussAddress,String token,String bussCountry,
			String stateCode,String bussPan,String bussGst,String company_age) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmclient_reg SET cregname=?,cregmob=?,cregemailid=?,cregindustry=?,creglocation=?,"
					+ "cregstate=?,cregaddress=?,cregcountry=?,cregstatecode=?,cregpan=?,creggstin=?,cregcompanyage=?"
					+ " WHERE cregclientrefid=? and cregtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,bussName);
			ps.setString(2,bussPhone);
			ps.setString(3,bussEmail );	
			ps.setString(4,industryType );	
			ps.setString(5,bussCity );	
			ps.setString(6,bussState );	
			ps.setString(7,bussAddress );
			ps.setString(8,bussCountry);
			ps.setString(9,stateCode );
			ps.setString(10,bussPan );
			ps.setString(11,bussGst );
			ps.setString(12,company_age );			
			ps.setString(13,clientrefid );	
			ps.setString(14,token );	
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateClientDetails"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateClientDetails:\n"+sqle);
			}
		}
		return status;
	}
	
	/*For update on editjsp page*/
	public static boolean markAsRead(String refid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE notifications SET notclientseenstatus=? WHERE notrefid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,"0" );
			ps.setString(2,refid );					
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("markAsRead"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects markAsRead:\n"+sqle);
			}
		}
		return status;
	}

	public static String getEstimateKey(String estNo,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		String data="NA";
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("select esrefid from estimatesalectrl where essaleno='"+estNo+"' and estoken='"+token+"' limit 1");
			rs=stmnt.executeQuery();
			
			if(rs.next())data=rs.getString(1);
			
		}catch(Exception e)
		{log.info("getEstimateKey"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getEstimateKey:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String getProductName(String pregno,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		String data="NA";
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("select msproductname from managesalesctrl where msprojectnumber='"+pregno+"' and mstoken='"+token+"' limit 1");
			rs=stmnt.executeQuery();
			
			if(rs.next())data=rs.getString(1);
			
		}catch(Exception e)
		{log.info("getProductName"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProductName:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	
	//getting project folder refid
		public static String getSubFolderRefrence(String pregno,String clid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rs=null;
			String data="NA";
			try{
				getacces_con=DbCon.getCon("","","");		
				stmnt=getacces_con.prepareStatement("select fsfrefid from folder_master where fprojectno='"+pregno+"' and fclientid='"+clid+"' and ftokenno='"+token+"' and ffcategory='folsubcategory'");
				rs=stmnt.executeQuery();
				
				if(rs.next())data=rs.getString(1);
				
			}catch(Exception e)
			{log.info("getSubFolderRefrence"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getSubFolderRefrence:\n"+sqle.getMessage());
				}
			}
			return data;
		}
	
	//getting project no
	public static String getProjectNo(String preguid,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		String data="NA";
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("select pregpuno from hrmproject_reg where preguid='"+preguid+"' and pregtokenno='"+token+"'");
			rs=stmnt.executeQuery();
			
			if(rs.next())data=rs.getString(1);
			
		}catch(Exception e)
		{log.info("getProjectNo"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectNo:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	
	//checking multiple project price exist or not
	public static boolean isMultipleProjectsItem(String type,String token,String cuid) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		String data="NA";
		boolean flag=false;
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("select vpreguid from virtual_project_price where vtokenno='"+token+"' and vpricefrom='"+type+"' and vclientid='"+cuid+"'");
			rs=stmnt.executeQuery();
			int i=1;
			while(rs.next()){
				if(i==1){data=rs.getString(1);i++;}
				if(!data.equalsIgnoreCase(rs.getString(1)))flag=true;
			}
			
		}catch(Exception e)
		{log.info("isMultipleProjectsItem"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects isMultipleProjectsItem:\n"+sqle.getMessage());
			}
		}
		return flag;
	}
	
	//checking project's payment done or not
	@SuppressWarnings("resource")
	public static boolean isPaymentDone(String preguid,String token,String type) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		int data=0;
		boolean flag=false;
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("select count(id) from project_price where EXISTS(select cbmid from clientbillingmapping where cbmppid=id and cbmcategory='"+type+"' and cbmpaymentstatus='1' and cbmstatus='1' and cbmtoken='"+token+"') and preguid='"+preguid+"' and tokenno='"+token+"'");
			rs=stmnt.executeQuery();
//					System.out.println("select id from project_price where EXISTS(select cbmid from clientbillingmapping where cbmppid=id and cbmcategory='"+type+"' and cbmpaymentstatus='1' and cbmstatus='1' and cbmtoken='"+token+"') and preguid='"+preguid+"' and tokenno='"+token+"'");
			if(rs.next())data=rs.getInt(1);
			
			stmnt=getacces_con.prepareStatement("select count(id) from project_price where preguid='"+preguid+"' and tokenno='"+token+"' and status='1'");
			rs=stmnt.executeQuery();
			if(rs.next()){
				if(data==rs.getInt(1))flag=true;
			}
			
		}catch(Exception e)
		{log.info("isPaymentDone"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects isPaymentDone:\n"+sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean markAsRead(String clientid,String token,String page) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE notifications SET nSeenStatus='2' WHERE nShowUid='"+clientid+"' "
					+ "and nShowClient='1' and nRedirectPage like '"+page+"%' and nToken='"+token+"'";
//			System.out.println(query);
			ps = con.prepareStatement(query);			
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("markAsRead"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects markAsRead:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	/*mark all notification as read*/
	public static boolean markAllAsRead(String clientid,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE notifications SET nSeenStatus='2' WHERE nShowUid='"+clientid+"' and nShowClient='1' and nToken='"+token+"'";
//			System.out.println(query);
			ps = con.prepareStatement(query);			
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("markAllAsRead"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects markAllAsRead:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	public static String[][] getAllNotification(String token,String loginuaid,String clientid) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select notid,notrefid,notuid,notmessage,notclientpage,CONCAT_WS('-', SUBSTRING(`notdate`, 9, 2), SUBSTRING(`notdate`, 6, 2), SUBSTRING(`notdate`, 1, 4)) from notifications where nottokenno='"+token+"' and notstatus='1' and notcomentedbyid!='"+loginuaid+"' and notshowclient='1' and notcliientid='"+clientid+"' order by notid desc");
			
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {	log.info("getAllNotification"+e.getMessage());
//			log.info("getUserDetails");
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getAllNotification"+sqle.getMessage());
			}
		}
		return data;
	}

	public static String[][] getAllClientNotification(String token,String loginuaid) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select nKey,nDate,nRedirectPage,nMessage,nicon from notifications where nToken='"+token+"' and nJobStatus='1' and nShowClient='1' and nShowUid='"+loginuaid+"' order by nId desc");
			
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getAllClientNotification"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getAllClientNotification"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getAllNotification(String token,String loginuaid) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select nKey,nDate,nRedirectPage,nMessage,nicon from notifications where nToken='"+token+"' and nJobStatus='1' and nShowClient='2' and nShowUid='"+loginuaid+"' order by nId desc limit 30");
			
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getAllNotification"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getAllNotification"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static int getTotalMilestones(String salesrefid,String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int data = 0;
		try {
			con =DbCon.getCon("", "", "");
						
			String query ="select count(smid) from salesmilestonectrl where smsalesrefid = '"+salesrefid+"' and smtoken='"+token+"'";
			
//			System.out.println(query);
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			
			if (rs != null && rs.next()) {
				data=rs.getInt(1);
			}
		} catch (Exception e) {
			log.info("getTotalMilestones"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getTotalMilestones"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static int getMilestonesWorkPercentage(String salesrefid,String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int data = 0;
		try {
			con =DbCon.getCon("", "", "");
						
			String query ="select sum(maworkpercentage) from manage_assignctrl where masalesrefid = '"+salesrefid+"' and matokenno='"+token+"'";
			
//			System.out.println(query);
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			
			if (rs != null && rs.next()) {
				data=rs.getInt(1);
			}
		} catch (Exception e) {
			log.info("getMilestonesWorkPercentage"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getMilestonesWorkPercentage"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static double getDueAmount(String invoice,String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		double data = 0;
		try {
			con =DbCon.getCon("", "", "");
						
			String query ="select cbdueamount from hrmclient_billing where cbinvoiceno = '"+invoice+"' and cbtokenno='"+token+"'";
			
//			System.out.println(query);
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			
			if (rs != null && rs.next()) {
				data=rs.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getDueAmount"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getDueAmount"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static double getProjectsTotalPrice(String salesrefid,String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		double data = 0;
		try {
			con =DbCon.getCon("", "", "");
						
			String query ="select sum(sptotalprice) from salespricectrl where spsalesrefid = '"+salesrefid+"' and sptokenno='"+token+"'";
			
//			System.out.println(query);
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			
			if (rs != null && rs.next()) {
				data=rs.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getProjectsTotalPrice"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getProjectsTotalPrice"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getLedgerData(String clientNo,String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
						
			StringBuffer query =new StringBuffer("select mtrefid,mtinvoice from managetransactionctrl where mtaccounts = '"+clientNo+"' and mttokenno='"+token+"'");
			
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getLedgerData"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getLedgerData"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getAllProjectsById(String loginuaid,String token,String doAction,String searchDoAction,
			String searchFromToDate,String sortBy,long limit,long pageStart,String userRole) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			String projectNo="NA";
			String projectName="NA";
			String fromDate="NA";
			String toDate="NA";
			if(!searchDoAction.equalsIgnoreCase("NA")) {
				int index=searchDoAction.indexOf(":");
				projectNo=searchDoAction.substring(0,index).trim();
				projectName=searchDoAction.substring(index+1).trim();
//				System.out.println(projectNo+"/"+projectName);
			}
			if(!searchFromToDate.equalsIgnoreCase("NA")) {
				fromDate=searchFromToDate.substring(0,10).trim();
				fromDate=fromDate.substring(6,10)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=searchFromToDate.substring(13).trim();
				toDate=toDate.substring(6,10)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
//				System.out.println(fromDate+"/"+toDate);
			}
			if(pageStart==1)pageStart=0;
			StringBuffer query =new StringBuffer("select m.msrefid,m.mscontactrefid,m.msprojectnumber,m.msinvoiceno,m.msestimateno,m.mscompany,"
					+ "m.msproducttype,m.msproductname,m.msproductplan,m.msplanperiod,m.msplantime,m.msremarks,m.mssolddate,m.msworkpercent,"
					+ "m.msunseenchat,m.project_close_date,m.msworkstatus,m.sales_type from managesalesctrl m left join ");
				if(userRole.equalsIgnoreCase("SUPER_USER"))
					query.append("hrmclient_reg h on m.msclientrefid=h.cregclientrefid where h.super_user_uaid='"+loginuaid+"'");
				else
					query.append("user_sales_info u on m.msid=u.sales_id where u.user_id = '"+loginuaid+"'");
			
			if(!doAction.equalsIgnoreCase("NA")&&doAction.equalsIgnoreCase("In Progress"))query.append(" and m.msworkpercent!='100'");
			if(!doAction.equalsIgnoreCase("NA")&&doAction.equalsIgnoreCase("Completed"))query.append(" and m.msworkpercent='100'");
			if(!doAction.equalsIgnoreCase("NA")&&doAction.equalsIgnoreCase("Unread"))query.append(" and m.msunseenchat!='0'");
			if(!projectNo.equalsIgnoreCase("NA")&&!projectName.equalsIgnoreCase("NA"))query.append(" and m.msprojectnumber='"+projectNo+"' and m.msproductname='"+projectName+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA"))query.append(" and str_to_date(m.mssolddate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(m.mssolddate,'%d-%m-%Y')>='"+fromDate+"'");
			query.append(" and mstoken='"+token+"' order by m.msid "+sortBy);
			if(limit>0)query.append(" limit "+pageStart+","+limit);
//			System.out.println(query);
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.info("getAllProjectsById"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getAllProjectsById"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getAllDocuments(String frefid,String token,String clientdocfrom,String clientdocto) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con = DbCon.getCon("", "", "");
			if(clientdocfrom==""||clientdocfrom==null||clientdocfrom.length()<0)clientdocfrom="NA";
			if(clientdocto==""||clientdocto==null||clientdocto.length()<0)clientdocto="NA";
			StringBuffer query =new StringBuffer("select dmuid,dmfolder_name,dmdocument_name,dmdocumentpath,dmaddedon,dmdocname,dmdoctype from document_master WHERE dmrefno='"+frefid+"' and dmtokenno='"+token+"'");
			if(!clientdocfrom.equalsIgnoreCase("NA")&&!clientdocto.equalsIgnoreCase("NA")){
				query.append(" and dmaddedon between '"+clientdocfrom+"' and '"+clientdocto+"'");
			}
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getAllDocuments"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getAllDocuments"+sqle.getMessage());
			}
		}
		return data;
	}
	/*For all document files details*/
	public static String[][] getAllFiles(String salesrefid,String token,String type,long limit,long pageStart) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			if(pageStart==1)pageStart=0;
			VCQUERY=new StringBuffer("SELECT sdrefid,sduploaddocname,sddescription,sddocname,sduploadedby,sduploaddate,sdmilestoneworkpercentage,sdmilestoneuuid FROM salesdocumentctrl where sdsalesrefid='"+salesrefid+"' and sdtokenno='"+token+"' and sdstatus='1' and sdvisibility='1'");
			if(type.equalsIgnoreCase("Client")){
				VCQUERY.append(" and sduploadby='"+type+"'");
			}else if(type.equalsIgnoreCase("Agent")){
				VCQUERY.append(" and sduploadby='"+type+"'");
			}
			VCQUERY.append(" order by sdid desc");
			if(limit>0)VCQUERY.append(" limit "+pageStart+","+limit);
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
		{log.info("error in getAllFiles : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllFiles:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static boolean isUnseenNotification(String token,String clintUaid,String page){		
		PreparedStatement ps = null;
		ResultSet rs=null;
		boolean result=false;
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select nId from notifications where "
					+ "nRedirectPage like '"+page+"%' and nToken='"+token+"' "
							+ "and nShowClient='1' and nShowUid='"+clintUaid+"' "
									+ "and nSeenStatus='1' limit 1");
//			System.out.println("select count(nId) from notifications where nToken='"+token+"' and nShowClient='1' and nShowUid='"+clintUaid+"'");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next())
				result=true;			
		}
		catch (Exception e) {
			log.info("error in isUnseenNotification : "+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects isUnseenNotification:\n"+sqle.getMessage());
			}
		}
		return result;
	}
	//counting total unseen notification
	public static int getTotalUnseenNotification(String token,String clintUaid){		
		PreparedStatement ps = null;
		ResultSet rs=null;
		int result=0;
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select count(nId) from notifications where nToken='"+token+"' and nShowClient='1' and nShowUid='"+clintUaid+"' and nSeenStatus='1'");
//			System.out.println("select count(nId) from notifications where nToken='"+token+"' and nShowClient='1' and nShowUid='"+clintUaid+"'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getInt(1);			
		}
		catch (Exception e) {
			log.info("error in getTotalUnseenNotification : "+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getTotalUnseenNotification:\n"+sqle.getMessage());
			}
		}
		return result;
	}
	//counting total unseen notification
	public static long getTotalUnseenNotificationAdmin(String token,String loginuaid)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		long data=0;
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select count(nId) from notifications where nToken='"+token+"' and nSeenStatus='1' and nShowUid='"+loginuaid+"' and nShowClient='2'");
			rs=ps.executeQuery();
			
			if (rs != null && rs.next()) {
				data=rs.getLong(1);
			}
		}
		catch (Exception e) {
			log.info("error in getTotalUnseenNotification : "+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getTotalUnseenNotification:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String getProjectId(String fno,String token,String clientid)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		String result="NA";
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select preguid from hrmproject_reg where pregpuno='"+fno+"' and pregtokenno='"+token+"' and pregcuid='"+clientid+"'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getString(1);			
		}
		catch (Exception e) {
			log.info("error in getProjectId : "+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getProjectId:\n"+sqle.getMessage());
			}
		}
		return result;
	}
	
	/*For counting all types of billing items of a project*/
	public static int countAllProjectsBillingPriceType(String preguid,String tablefrom,String token)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		int result=0;
		Connection con = DbCon.getCon("","","");
		try{
			ps = con.prepareStatement("select count(pp.id) from project_price pp join clientbillingmapping cb on cb.cbmppid=pp.id  where pp.enq='NA' and pp.preguid='"+preguid+"' and cb.cbmpaymentstatus='1' and pp.tokenno='"+token+"' and cb.cbmcategory='"+tablefrom+"'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getInt(1);			
		}
		catch (Exception e) {
			log.info("error in countAllProjectsBillingPriceType : "+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects countAllProjectsBillingPriceType:\n"+sqle.getMessage());
			}
		}
		return result;
	}
	
	/*For counting all types of project price*/
	public static int countAllProjectPriceType(String preguid,String token)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		int result=0;
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select count(id) from project_price where preguid='"+preguid+"' and tokenno='"+token+"' and enq='NA'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getInt(1);			
		}
		catch (Exception e) {
			log.info("error in countAllProjectPriceType : "+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects countAllProjectPriceType:\n"+sqle.getMessage());
			}
		}
		return result;
	}
	public static int countUploadFiles(String refid,String token)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		int result=0;
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select count(sdid) from salesdocumentctrl where sdsalesrefid='"+refid+"' and sdtokenno='"+token+"' and sdstatus='1' and sdvisibility='1'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getInt(1);			
		}
		catch (Exception e) {
			log.info("error in countUploadFiles : "+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects countUploadFiles:\n"+sqle.getMessage());
			}
		}
		return result;
	}
	/*For counting all files of a particular folder*/
	public static int countAllFiles(String refid,String token,String clientid)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		int result=0;
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select count(dmuid) from document_master where dmrefno='"+refid+"' and dmtokenno='"+token+"' and dmclientid='"+clientid+"'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getInt(1);			
		}
		catch (Exception e) {
			log.info("error in countAllFiles : "+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects countAllFiles:\n"+sqle.getMessage());
			}
		}
		return result;
	}
	public static String[][] getAllFolders(String loginUaid,String token,String fname,String ftype,String dateRange,
			String sorting,long limit,long pageStart,String userRole) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			con = DbCon.getCon("", "", "");
			String fcategory="Sub";
			if(ftype.equalsIgnoreCase("Projects"))ftype="Sales";
			//else if(ftype.equalsIgnoreCase("Personal")){fcategory="Main";ftype="Personal";}
			if(pageStart==1)pageStart=0;
			StringBuffer query =new StringBuffer("select f.fid,f.fsfrefid,f.fname,f.fprojectno,f.fsalesrefid,f.faddedon from folder_master f left join ");
			
			if(userRole.equalsIgnoreCase("SUPER_USER"))query.append("hrmclient_reg h on f.fclientid=h.creguid where h.super_user_uaid='"+loginUaid+"'");
			else query.append("managesalesctrl m on f.fsalesrefid=m.msrefid left join user_sales_info u on m.msid=u.sales_id where u.user_id='"+loginUaid+"'");
			
			if(!fname.equalsIgnoreCase("NA"))query.append(" and f.fname='"+fname+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				query.append(" and str_to_date(f.faddedon,'%Y-%m-%d')<='"+toDate+"' and str_to_date(f.faddedon,'%Y-%m-%d')>='"+fromDate+"'");
			}
			query.append(" and f.ftokenno='"+token+"' and f.ffcategory='"+fcategory+"' and f.ftype='"+ftype+"' order by f.fid "+sorting+" limit "+pageStart+","+limit);
//			System.out.println(query);
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getUserDetails"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getUserDetails"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getClientAccountStatement(String accid) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con = DbCon.getCon("", "", "");
			String query = "select accbuid,accbdescription,accbdate,accbdebit,accbcredit,accprojectId from client_accounts_statement where accbmuid = '"+accid+"'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getClientAccountStatement"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getUserDetails"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getAllChats(String preguid) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con = DbCon.getCon("", "", "");
			String query = "select pfuid,pfupid,pfustatus,pfudate,pfuremark,followupby from hrmproject_followup where pfupid = '"+preguid+"' and showclient='1'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getAllChats"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getAllChats"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getClientBilling(String loginUaid,String sortBy,String dateRange,String searchData,
			String token,long limit,long pageStart,String userRole) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			con = DbCon.getCon("", "", "");
			if(pageStart==1)pageStart=0;
			StringBuffer query =new StringBuffer("select b.cbuid,b.cbrefid,b.cbestimateno,b.cbinvoiceno,b.cbcompanyname,"
					+ "b.cborderamount,b.cbpaidamount,b.cbdueamount,b.cbdate from hrmclient_billing b left join "
					+ "hrmclient_reg h on b.cbclientrefid=h.cregclientrefid ");
			if(userRole.equalsIgnoreCase("SUPER_USER"))
				query.append("where h.super_user_uaid='"+loginUaid+"' ");
			else
				query.append("left join client_user_info c on h.creguid=c.client_id where c.user_id='"+loginUaid+"'");
			
			if(!searchData.equalsIgnoreCase("NA"))query.append(" and (b.cbinvoiceno='"+searchData+"' or b.cbestimateno='"+searchData+"')");
			else query.append(" and b.cbinvoiceno!='NA'");
			if(!dateRange.equalsIgnoreCase("NA"))query.append(" and str_to_date(b.cbaddedon,'%Y-%m-%d')<='"+toDate+"' and str_to_date(b.cbaddedon,'%Y-%m-%d')>='"+fromDate+"'");
			
			query.append(" and b.cbtokenno='"+token+"' order by b.cbuid "+sortBy);
			if(limit>0)query.append(" limit "+pageStart+","+limit);
//			System.out.println(query);
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getClientBilling"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getClientBilling"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[] getbillingPaymentDetails(String billrefid,String token,String billtype) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[] data =new String[6];
		try {
			con = DbCon.getCon("", "", "");
			String query = "select bpmrefid,bpmcbcuid,bpmpmtdate,bpmpmtamount,bpmpayoption,bpmtransactionid from billpaymenthistory where bpmcbrefid = '"+billrefid+"' and bpmtokenno='"+token+"' and bpmcbtype='"+billtype+"' and bpmstatus='1' order by bpmid limit 1";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();			
			while (rs != null && rs.next()) {
				data[0]=rs.getString(1);
				data[1]=rs.getString(2);
				data[2]=rs.getString(3);
				data[3]=rs.getString(4);
				data[4]=rs.getString(5);
				data[5]=rs.getString(6);
			}
		} catch (Exception e) {
			log.info("getbillingPaymentDetails"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {sqle.printStackTrace();
				log.info("getbillingPaymentDetails"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[] getbillingDetails(String billrefid,String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[] data =new String[7];
		try {
			con = DbCon.getCon("", "", "");
			String query = "select cbinvno,cbcuid,cbtype,cbdate,cbfinalamount,cddueamount,cbprojectid from hrmclient_billing where cbrefid = '"+billrefid+"' and cbtokenno='"+token+"'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();			
			while (rs != null && rs.next()) {
				data[0]=rs.getString(1);
				data[1]=rs.getString(2);
				data[2]=rs.getString(3);
				data[3]=rs.getString(4);
				data[4]=rs.getString(5);
				data[5]=rs.getString(6);
				data[6]=rs.getString(7);
			}
		} catch (Exception e) {
			log.info("getbillingDetails"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getbillingDetails"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] findContactById(int contactId,String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con = DbCon.getCon("", "", "");
			String query = "select ccbclientrefid,cccontactfirstname,cccontactlastname,ccemailfirst,cccompanyname,ccemailsecond,ccworkphone,ccmobilephone,"
					+ "ccaddresstype,cccity,ccstate,ccaddress,cccountry,ccpan from clientcontactbox where ccbid = '"+contactId+"' and ccbid!='0' and cctokenno='"+token+"'";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("findContactById"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("findContactById"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getClientByNo(String clientrefid,String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con = DbCon.getCon("", "", "");
			String query = "select creguid,cregmob,cregaddress,cregucid,cregname,cregemailid,creglocation,cregindustry,cregstate,cregcontfirstname,cregcontlastname,cregcontemailid,cregcontmobile,cregcontcity,cregcontstate,cregcontaddress from hrmclient_reg where cregclientrefid = '"+clientrefid+"' and cregtokenno='"+token+"'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getClientByNo"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getClientByNo"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String getAccountId(String clientid,String token){
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select caid from client_accounts where cacid='"+clientid+"' and catokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) data=rs.getString(1);
		} catch (Exception e) {
			log.info("getAccountId"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getAccountId"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static String getLastProjectFollowupStatus(String preguid,String token){
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select pfustatus from hrmproject_followup where pfupid='"+preguid+"' and pftokenno='"+token+"' order by pfuid desc limit 1");
			rs=ps.executeQuery();
			if(rs.next()) data=rs.getString(1);
		} catch (Exception e) {
			log.info("getLastProjectFollowupStatus"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {sqle.printStackTrace();
				log.info("getLastProjectFollowupStatus"+sqle.getMessage());
			}
		}
		
		return data;
	}													
	
	public static boolean addNotification(String uuid,String billrefid,String msg,String pagename,String from,String showclient,String clientid,String seenstatus,String status,String addedby,String token,String clientpage,String loginuaid,String accesscode,String empseenstatus,String clientseenstatus){
		boolean data=false;
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {	
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			Calendar calobj = Calendar.getInstance();
			String today = df.format(calobj.getTime());
			
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("insert into notifications (notrefid,notuid,notmessage,notpage,notfrom,notshowclient,notcliientid,notseenstatus,notstatus,notaddedby,nottokenno,notdate,notclientpage,notcomentedbyid,notpermissioncode,notemployeeseenstatus,notclientseenstatus) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1, uuid);
			ps.setString(2, billrefid);
			ps.setString(3, msg);
			ps.setString(4, pagename);
			ps.setString(5, from);
			ps.setString(6, showclient);
			ps.setString(7, clientid);
			ps.setString(8, seenstatus);
			ps.setString(9, status);
			ps.setString(10, addedby);
			ps.setString(11, token);
			ps.setString(12, today);
			ps.setString(13, clientpage);
			ps.setString(14, loginuaid);
			ps.setString(15, accesscode);
			ps.setString(16, empseenstatus);
			ps.setString(17, clientseenstatus);
			ps.execute();
			
		} catch (Exception e) {
			log.info("addNotification"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {	
				log.info("addNotification"+sqle.getMessage());
			}
		}
		
		return data;
	}	
	
	public static boolean saveDocument(String clientid,String path,String token,String documentname,String documenttype,String folderdetails,String addedby,String imgname){
		boolean data=false;
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			if(!folderdetails.equalsIgnoreCase("NA")&&folderdetails!=null&&folderdetails.length()>0){
			String folder[]=folderdetails.split("#");
			
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("insert into document_master (dmrefno,dmfolder_name,dmdocument_name,dmdocumentpath,dmstatus,dmaddedby,dmtokenno,dmdocname,dmdoctype,dmclientid) values(?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1, folder[0]);
			ps.setString(2, folder[1]);
			ps.setString(3, imgname);
			ps.setString(4, path);
			ps.setString(5, "1");
			ps.setString(6, addedby);
			ps.setString(7, token);
			ps.setString(8, documentname);
			ps.setString(9, documenttype);
			ps.setString(10, clientid);
			ps.execute();
			}
		} catch (Exception e) {
			log.info("saveDocument"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("saveDocument"+sqle.getMessage());
			}
		}
		
		return data;
	}	
	public static boolean updateAmcBillingMappingStatus(String preguid,String token){
		boolean data=false;
		Connection con=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("update clientbillingmapping set cbmpaymentstatus=? where cbmcategory=? and cbmtoken=? and cbmpreguid=? and cbmpaymentstatus=?");
			ps.setString(1, "2");
			ps.setString(2, "amc");
			ps.setString(3, token);
			ps.setString(4, preguid);
			ps.setString(5, "1");
			ps.execute();
			data=true;
		} catch (Exception e) {
			log.info("updateAmcBillingMappingStatus"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateAmcBillingMappingStatus"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static boolean updateBillingMappingStatus(String brefid,String token){
		boolean data=false;
		Connection con=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("update clientbillingmapping set cbmpaymentstatus=? where cbmbillrefid=? and cbmtoken=?");
			ps.setString(1, "1");
			ps.setString(2, brefid);
			ps.setString(3, token);
			ps.execute();
			data=true;
		} catch (Exception e) {
			log.info("updateBillingMappingStatus"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateBillingMappingStatus"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static boolean updateBilling(String brefid,String pymtstatus,double dueamt){
		boolean data=false;
		Connection con=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("update hrmclient_billing set cbpaymentstatus=?,cddueamount=? where cbrefid=?");
			ps.setString(1, pymtstatus);
			ps.setDouble(2, dueamt);
			ps.setString(3, brefid);			
			ps.execute();
			data=true;
		} catch (Exception e) {
			log.info("updateBilling"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateBilling"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static boolean updateBillingPayment(String payoption,String pdate,String transid,String transamt,String brefid,String pymtrefid,String token,String typefrom){
		boolean data=false;
		Connection con=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("update billpaymenthistory set bpmpmtdate=?,bpmpmtamount=?,bpmstatus=?,bpmpayoption=?,bpmtransactionid=? where bpmrefid=? and bpmcbrefid=? and bpmtokenno=? and bpmcbtype=?");
			ps.setString(1, pdate);
			ps.setString(2, transamt);
			ps.setString(3, "0");
			ps.setString(4, payoption);
			ps.setString(5, transid);
			ps.setString(6, pymtrefid);
			ps.setString(7, brefid);
			ps.setString(8, token);
			ps.setString(9, typefrom);
			ps.execute();
			data=true;
		} catch (Exception e) {
			log.info("updateBillingPayment"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateBillingPayment"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static boolean addBillPayment(String cbinvno,String cbcuid,String cbtype,String token,String addedby,String payoption,String pdate,String transid,String transamt,String billrefid,String key){
		boolean data=false;
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("insert into billpaymenthistory (bpmrefid,bpmcbinvno,bpmcbrefid,bpmcbcuid,bpmcbtype,bpmpmtdate,bpmpmtamount,bpmtokenno,bpmstatus,bpmaddedby,bpmpayoption,bpmtransactionid) values(?,?,?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1, key);
			ps.setString(2, cbinvno);
			ps.setString(3, billrefid);
			ps.setString(4, cbcuid);
			ps.setString(5, cbtype);
			ps.setString(6, pdate);
			ps.setString(7, transamt);
			ps.setString(8, token);
			ps.setString(9, "1");
			ps.setString(10, addedby);
			ps.setString(11, payoption);
			ps.setString(12, transid);
			ps.execute();
		} catch (Exception e) {
			log.info("addBillPayment"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("addBillPayment"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static boolean addTaskFollowUp(String key,String salesrefId,String milestoneKey,String milestoneName,String clientrefId,String content,String imgname,String today,String time,String submitStatus,String uaid,String userName,String loginuID,String uavalidtokenno,String formDataJson,String msgForUid,String msgForName) {
		PreparedStatement ps = null;				
		Connection con = DbCon.getCon("","","");
		boolean flag=false;
		try{
			String query = "insert into hrmproject_followup(pfkey,pfsaleskey,pfmilestonekey,pfmilestonename,pfclientkey,pfdynamicform,pfcontent,pffilename,pfdate,pftime,pfsubmitstatus,pfaddedbyuid,pfaddedbyname,pfaddedby,pftokenno,pfmsgforuid,pfmsgforname)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);			
			ps.setString(1,key);
			ps.setString(2,salesrefId);
			ps.setString(3,milestoneKey);
			ps.setString(4,milestoneName);
			ps.setString(5,clientrefId);
			ps.setString(6,formDataJson);
			ps.setString(7,content);
			ps.setString(8,imgname);
			ps.setString(9,today);
			ps.setString(10,time);
			ps.setString(11,submitStatus);
			ps.setString(12,uaid);
			ps.setString(13,userName);
			ps.setString(14,loginuID);
			ps.setString(15,uavalidtokenno);
			ps.setString(16,msgForUid);
			ps.setString(17,msgForName);
			
			int k=ps.executeUpdate();
			if(k>0)flag=true;
		}
		catch (Exception e) {
			log.info("ClientACT : addTaskFollowUp()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}				
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects ClientACT :  addTaskFollowUp:\n"+sqle.getMessage());
			}
		}	
		return flag;
	}
	
		
	public static String getClientName(String clientid,String token){
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select cregname from hrmclient_reg where creguid='"+clientid+"' and cregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) data=rs.getString(1);
		} catch (Exception e) {
			log.info("getClientName"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getClientName"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static String getClientDataByKey(String clientKey,String token){
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select cregstatecode from hrmclient_reg where cregclientrefid='"+clientKey+"' and cregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) data=rs.getString(1);
		} catch (Exception e) {
			log.info("getClientDataByKey"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getClientDataByKey"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static String getClientIdByKey(String cregucid,String token){
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select creguid from hrmclient_reg where cregclientrefid='"+cregucid+"' and cregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) data=rs.getString(1);
		} catch (Exception e) {
			log.info("getClientIdByKey"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getClientIdByKey"+sqle.getMessage());
			}
		}
		
		return data;
	}
	public static String getClientId(String cregucid,String token){
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select creguid from hrmclient_reg where cregucid='"+cregucid+"' and cregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) data=rs.getString(1);
		} catch (Exception e) {
			log.info("getClientId"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getClientId"+sqle.getMessage());
			}
		}
		
		return data;
	}
	public static String getClientRefId(String cregucid,String token){
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select cregclientrefid from hrmclient_reg where cregucid='"+cregucid+"' and cregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) data=rs.getString(1);
		} catch (Exception e) {
			log.info("getClientRefId"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getClientRefId"+sqle.getMessage());
			}
		}
		
		return data;
	}

	public static boolean isColumnValueExist(String colname, String value,String clientId,String token,String loginuaid) {
		boolean flag=false;
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;		
		try {
			con = DbCon.getCon("", "", "");
			String query="";
			if(colname.equalsIgnoreCase("cregcontemailid"))
				query="select creguid from hrmclient_reg where (cregemailid='"+value+"' or cregcontemailid='"+value+"') and cregtokenno='"+token+"' and creguid!='"+clientId+"'";
			else if(colname.equalsIgnoreCase("cregcontmobile"))
				query="select creguid from hrmclient_reg where (cregmob='"+value+"' or cregcontmobile='"+value+"') and cregtokenno='"+token+"' and creguid!='"+clientId+"'";
			else if(colname.equalsIgnoreCase("profileemail"))
				query="select c.ccbid from clientcontactbox c join user_account u on u.contact_id=c.ccbid where u.uaid!='"+loginuaid+"' and (ccemailfirst='"+value+"' or ccemailsecond='"+value+"') and cctokenno='"+token+"'";
			else if(colname.equalsIgnoreCase("profilemobile"))
				query="select c.ccbid from clientcontactbox c join user_account u on u.contact_id=c.ccbid where u.uaid!='"+loginuaid+"' and (ccworkphone='"+value+"' or ccmobilephone='"+value+"') and cctokenno='"+token+"'";
			else if(colname.equalsIgnoreCase("profilepan"))
				query="select c.ccbid from clientcontactbox c join user_account u on u.contact_id=c.ccbid where u.uaid!='"+loginuaid+"' and ccpan='"+value+"' and cctokenno='"+token+"'";
			else
				query="select creguid from hrmclient_reg where "+colname+"='"+value+"' and cregtokenno='"+token+"' and creguid!='"+clientId+"'";
			
//			System.out.println(query);
			ps=con.prepareStatement(query);
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) flag=true;
		} catch (Exception e) {
			log.info("isColumnValueExist"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("isColumnValueExist"+sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveTxnDetails(String uuid, String salesKey, String oRDER_ID, String txn_amount,
			String loginuaid, String token, String today) {
		PreparedStatement ps = null;				
		Connection con = DbCon.getCon("","","");
		boolean flag=false;
		try{
			String query = "insert into client_txn_details(uuid,sales_key,order_id,txn_amount,addedby_id,token,pay_date)values(?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);			
			ps.setString(1,uuid);
			ps.setString(2,salesKey);
			ps.setString(3,oRDER_ID);
			ps.setString(4,txn_amount);
			ps.setString(5,loginuaid);
			ps.setString(6,token);
			ps.setString(7,today);
			
			int k=ps.executeUpdate();
			if(k>0)flag=true;
		}
		catch (Exception e) {
			log.info("ClientACT : saveTxnDetails()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}				
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects ClientACT :  saveTxnDetails:\n"+sqle.getMessage());
			}
		}	
		return flag;
		
	}

	public static boolean updateTxnDetails(String orderId, String bankTxnId, String txnId, String status,String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE client_txn_details SET banktxnid=?,txn_id=?,status=? WHERE order_id=? and token=?";
			ps = con.prepareStatement(query);
			ps.setString(1,bankTxnId);
			ps.setString(2,txnId );	
			ps.setString(3,status );	
			ps.setString(4,orderId );
			ps.setString(5,token );
						
			int k=ps.executeUpdate();
			if(k>0)flag = true;
		}catch (Exception e) {
			log.info("updateTxnDetails"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateTxnDetails:\n"+sqle);
			}
		}
		return flag;
	}

	public static String[] getPaymentdata(String orderId,String token) {
		String[] data=new String[3];
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select sales_key,txn_amount,addedby_id from client_txn_details where order_id='"+orderId+"'");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) {
				data[0]=rs.getString(1);
				data[1]=rs.getString(2);
				data[2]=rs.getString(3);
			}
		} catch (Exception e) {
			log.info("getPaymentdata"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getPaymentdata"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static String getEstimateSalesKey(String orderId,String token) {
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select sales_key from client_txn_details where order_id='"+orderId+"' and token='"+token+"'");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) {
				data=getEstimateSalesKeyBySalesKey(rs.getString(1),token);
			}
		} catch (Exception e) {
			log.info("getEstimateSalesKey"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getEstimateSalesKey"+sqle.getMessage());
			}
		}
		
		return data;
	}

	private static String getEstimateSalesKeyBySalesKey(String salesKey,String token) {
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select msestimateno from managesalesctrl where msrefid='"+salesKey+"' and mstoken='"+token+"'");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) {
				data=getEstimateSalesKeyByEstimateNo(rs.getString(1),token);
			}
		} catch (Exception e) {
			log.info("getEstimateSalesKeyBySalesKey"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getEstimateSalesKeyBySalesKey"+sqle.getMessage());
			}
		}
		
		return data;
	}

	public static String getEstimateSalesKeyByEstimateNo(String salesNO,String token) {
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select esrefid from estimatesalectrl where essaleno='"+salesNO+"' and estoken='"+token+"' limit 1");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) {
				data=rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateSalesKeyByEstimateNo"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getEstimateSalesKeyByEstimateNo"+sqle.getMessage());
			}
		}
		
		return data;
	}

	public static String getTokenNo(String orderId) {
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select token from client_txn_details where order_id='"+orderId+"'");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) {
				data=rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getTokenNo"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getTokenNo"+sqle.getMessage());
			}
		}
		
		return data;
	}

	public static boolean isTxnExist(String txnId) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		boolean flag=false;
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("select sid from salesestimatepayment where stransactionid='"+txnId+"'");
			rs=stmnt.executeQuery();
			
			if(rs!=null&&rs.next()){
				flag=true;
			}
			
		}catch(Exception e)
		{log.info("isTxnExist"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects isTxnExist:\n"+sqle.getMessage());
			}
		}
		return flag;
	}

	public static String getProductKey(String salesKey, String token) {
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select smprodrefid from salesmilestonectrl where smsalesrefid='"+salesKey+"' and smtoken='"+token+"' limit 1");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) {
				data=rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getProductKey"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getProductKey"+sqle.getMessage());
			}
		}
		
		return data;
	}

	public static boolean saveServiceRating(String serviceRatingKey, String salesKey, String productKey, String ratingValue,
			String ratingComment, String today, String clientKey, String token) {
		boolean data=false;
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {	
			
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("insert into service_rating (uuid,sales_key,product_key,rating_value,comment,date,client_key,token) values(?,?,?,?,?,?,?,?)");
			ps.setString(1, serviceRatingKey);
			ps.setString(2, salesKey);
			ps.setString(3, productKey);
			ps.setString(4, ratingValue);
			ps.setString(5, ratingComment);
			ps.setString(6, today);
			ps.setString(7, clientKey);
			ps.setString(8, token);
			int k=ps.executeUpdate();
			if(k>0)data=true;
			
		} catch (Exception e) {e.printStackTrace();
			log.info("saveServiceRating"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {	sqle.printStackTrace();
				log.info("saveServiceRating"+sqle.getMessage());
			}
		}
		
		return data;
	}

	public static boolean updateServiceRating(String serviceRatingKey,String ratingValue,
			String ratingComment,String token) {
		boolean data=false;
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {	
			
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("update service_rating set rating_value=?,comment=? where uuid=? and token=?");
			ps.setString(1, ratingValue);
			ps.setString(2, ratingComment);
			ps.setString(3, serviceRatingKey);
			ps.setString(4, token);
			
			int k=ps.executeUpdate();
			if(k>0)data=true;
			
		} catch (Exception e) {e.printStackTrace();
			log.info("updateServiceRating"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {	sqle.printStackTrace();
				log.info("updateServiceRating"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static boolean saveAboutRating(String type, String serviceRatingKey, String value, String today,
			String token,String uaid) {
		boolean data=false;
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {	
			
			con = DbCon.getCon("", "", "");
			String sql="insert into rating_about(type,ref_uuid,value,date,token,uaid) values('"+type+"','"+serviceRatingKey+"','"+value+"','"+today+"','"+token+"','"+uaid+"')";
//			System.out.println(sql);
			ps=con.prepareStatement(sql);
			
			int k=ps.executeUpdate();
			if(k>0)
			data=true;
//			System.out.println("query executed=="+type+"/"+serviceRatingKey+"/"+value+"/"+today+"/"+token+"/"+uaid);
			
		} catch (Exception e) {e.printStackTrace();
			log.info("saveAboutRating"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {	sqle.printStackTrace();
				log.info("saveAboutRating"+sqle.getMessage());
			}
		}
		
		return data;
	}

	public static boolean saveExecutiveRating(String executiveKey, String uaid, String ratingValue, String today,
			String token, String serviceRatingKey) {
		boolean data=false;
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {	
			
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("insert into executive_rating (uuid,uaid,rating_value,date,token,service_rating_uuid) values(?,?,?,?,?,?)");
			ps.setString(1, executiveKey);
			ps.setString(2, uaid);
			ps.setString(3, ratingValue);
			ps.setString(4, today);
			ps.setString(5, token);
			ps.setString(6, serviceRatingKey);
			int k=ps.executeUpdate();
			if(k>0)data=true;
			
		} catch (Exception e) {e.printStackTrace();
			log.info("saveExecutiveRating"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {sqle.printStackTrace();	
				log.info("saveExecutiveRating"+sqle.getMessage());
				
			}
		}
		
		return data;
	}

	public static boolean updateExecutiveRating(String executiveKey,String uaid,String ratingValue,String token) {
		boolean data=false;
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {	
			
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("update executive_rating set rating_value=? where uuid=? and token=? and uaid=?");
			
			ps.setString(1, ratingValue);
			ps.setString(2, executiveKey);
			ps.setString(3, token);
			ps.setString(4, uaid);
			
			int k=ps.executeUpdate();
			if(k>0)data=true;
			
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateExecutiveRating"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {	sqle.printStackTrace();
				log.info("updateExecutiveRating"+sqle.getMessage());
				
			}
		}
		
		return data;
	}
	
	public static void removeAboutRating(String sRatingKey, String token) {
		Connection con=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("delete from rating_about where ref_uuid='"+sRatingKey+"' and token='"+token+"'");
			ps.execute();			
		} catch (Exception e) {e.printStackTrace();
			log.info("removeAboutRating"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("removeAboutRating"+sqle.getMessage());
			}
		}
		
	}

	public static String getExecutiveUuid(String serviceRatingKey, String token) {
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select uuid from executive_rating where service_rating_uuid='"+serviceRatingKey+"' and token='"+token+"' limit 1");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) {
				data=rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getExecutiveUuid"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getExecutiveUuid"+sqle.getMessage());
			}
		}
		
		return data;
	}
	
	public static String getExecutiveKey(String uaid, String serviceRatingKey, String token) {
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select uuid from executive_rating where uaid='"+uaid+"' and token='"+token+"' and service_rating_uuid='"+serviceRatingKey+"'");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) {
				data=rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getExecutiveKey"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getExecutiveKey"+sqle.getMessage());
			}
		}
		
		return data;
	}

	public static String getServiceRatingExist(String salesKey, String productKey, String clientKey, String token) {
		String data="NA";
		Connection con=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		
		try {
			con = DbCon.getCon("", "", "");
			ps=con.prepareStatement("select uuid from service_rating where sales_key='"+salesKey+"' and product_key='"+productKey+"' and client_key='"+clientKey+"' and token='"+token+"'");
			rs=ps.executeQuery();
			if(rs!=null&&rs.next()) {
				data=rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getServiceRatingExist"+e.getMessage());
		}finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getServiceRatingExist"+sqle.getMessage());
			}
		}
		
		return data;
	}

	public static String[][] getServiceRatingAbout(String type,String serviceRatingKey, String token,String uaid) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select value from rating_about where type='"+type+"' and ref_uuid='"+serviceRatingKey+"' and token='"+token+"'");
			if(type.equalsIgnoreCase("Executive"))query.append(" and uaid='"+uaid+"'");
//System.out.println(query);
			
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {	e.printStackTrace();
			log.info("getServiceRatingAbout"+e.getMessage());
//			log.info("getUserDetails");
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getServiceRatingAbout"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getExecutiveRating(String serviceRatingKey, String token,String uaid) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select uuid,rating_value,uaid from executive_rating where service_rating_uuid='"+serviceRatingKey+"' and token='"+token+"' and uaid='"+uaid+"'");
//			System.out.println(query);
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {	e.printStackTrace();
			log.info("getExecutiveRating"+e.getMessage());
//			log.info("getUserDetails");
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getExecutiveRating"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] getServiceRating(String salesKey, String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select * from service_rating where token='"+token+"' and sales_key='"+salesKey+"'");
//			System.out.println(query);
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {	e.printStackTrace();
			log.info("getServiceRating"+e.getMessage());
//			log.info("getUserDetails");
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("getServiceRating"+sqle.getMessage());
			}
		}
		return data;
	}

	public static boolean updateClientPassword(String loginuaid, String crpass, String nwpass) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET uapass=? WHERE uaid=? and uapass=?";
			ps = con.prepareStatement(query);
			ps.setString(1,nwpass);
			ps.setString(2,loginuaid );
			ps.setString(3,crpass);	
						
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateClientPassword"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateClientPassword:\n"+sqle);
			}
		}
		return status;
	}

	public static String[][] getServiceByName(String name, String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select service,url from services where token='"+token+"' and status='1' and service like '%"+name+"%' limit 0,10");
//			System.out.println(query);
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
			
		} catch (Exception e) {	e.printStackTrace();
			log.info("getServiceByName"+e.getMessage());
//			log.info("getUserDetails");
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}				
			} catch (SQLException sqle) {
				log.info("getServiceByName"+sqle.getMessage());
			}
		}
		return data;
	}

	public static String[][] getClientDetails(String token, String client_id) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select cregname,cregaddress,creglocation,cregcontfirstname,cregcontlastname,cregcontemailid,cregcontmobile from hrmclient_reg where cregtokenno='"+token+"' and creguid='"+client_id+"' ");
//			System.out.println(query);
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
			
		} catch (Exception e) {	e.printStackTrace();
			log.info("getClientDetails"+e.getMessage());
//			log.info("getUserDetails");
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}				
			} catch (SQLException sqle) {
				log.info("getClientDetails"+sqle.getMessage());
			}
		}
		return data;
	}

	public static String[][] getChat(String salesKey, String clientKey, int pageNumber, String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select pfkey,pfmilestonekey,pfmilestonename,pfdynamicform,pfcontent,pffilename,"
					+"pfdate,pftime,pfsubmitstatus,pfaddedbyuid,pfaddedbyname,pfformsubmitstatus,"
					+"pfdynamicformname,pfunreadstatus from hrmproject_followup where "
					+"pfsaleskey='"+salesKey+"' and pfclientkey='"+clientKey+"' and "
					+"pftokenno='"+token+"' and pfstatus='1' order by pfuid desc limit "+(pageNumber*10)+",10");
//			System.out.println(query);
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
			
		} catch (Exception e) {	e.printStackTrace();
			log.info("getClientDetails"+e.getMessage());
//			log.info("getUserDetails");
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}				
			} catch (SQLException sqle) {
				log.info("getClientDetails"+sqle.getMessage());
			}
		}
		return data;
	}

	public static String getLastAssignedMilestone(String salesKey, String msgForUid, String token) {
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			String query="SELECT m.maid from manage_assignctrl m left join "
					+ "salesmilestonectrl s on m.masalesrefid=s.smsalesrefid where "
					+ "s.smsalesrefid='"+salesKey+"' and "
					+ "m.mateammemberid='"+msgForUid+"' and m.maworkstarteddate!='00-00-0000' and "
					+ "m.masaleshierarchystatus='1' and m.mahierarchyactivestatus='1' and "
					+ "m.maapprovalstatus='1' and m.mastepstatus='1' group by m.maid order by s.smstep desc limit 1;";
			System.out.println(query);
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			
			if (rs != null && rs.next()) {
				data=rs.getString(1);
			}
			
		} catch (Exception e) {	e.printStackTrace();
			log.info("getLastAssignedMilestone"+e.getMessage());
//			log.info("getUserDetails");
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}				
			} catch (SQLException sqle) {
				log.info("getLastAssignedMilestone"+sqle.getMessage());
			}
		}
		return data;
	}
	
}
