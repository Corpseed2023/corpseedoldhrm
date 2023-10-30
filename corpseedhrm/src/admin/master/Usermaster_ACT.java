package admin.master;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Date;

import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import commons.DbCon;

public class Usermaster_ACT {
	private static Logger log = Logger.getLogger(LoginAction.class);
	

	public static void sendRegistrationSms(String loginpassword, String addedby, String mobile) {
		if(addedby==null||addedby=="") addedby="NA";
		try {
			String authkeyv = "219681AYZmvD2rNXgK5b1bb229";
			String routeno = "4";
			String sendername = "WDONEI";
			String monum = "91"+mobile;
			StringBuffer sf = new StringBuffer("Congratulations. Your user account has been created with Username : "+mobile+" and Password : "+loginpassword+"");
			if(!addedby.equals("NA")) sf.append(" by "+addedby);
			sf.append(" Wdone.in");
			String msg = sf.toString();

			String url="http://api.msg91.com/api/sendhttp.php?"+
					"authkey="+URLEncoder.encode(authkeyv,"UTF-8")+
					"&route="+URLEncoder.encode(routeno,"UTF-8")+
					"&sender="+URLEncoder.encode(sendername,"UTF-8")+
					"&mobiles="+URLEncoder.encode(monum, "UTF-8")+
					"&message="+URLEncoder.encode(msg, "UTF-8");
			URL requrl = new URL(url.trim());
			HttpURLConnection conn = (HttpURLConnection) requrl.openConnection();
			conn.setRequestMethod("GET");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.connect();
			BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			StringBuffer buffer = new StringBuffer();
			while((line = rd.readLine()) != null){
				buffer.append(line).append("\n");
			}
			rd.close();
			conn.disconnect();
		}
		catch (Exception e){e.printStackTrace();}
	}
	
	/*For Saving create user details*/
	public static boolean saveUserDetail(String tokenno,String ualoginid,String uapassword,String name,
			String mobile,String emailid,String access,String addeduser,String uaaip,String uaabname, 
			String uaroletype, String emuid, String uacompany,String key,String department,String role,
			String ipAddress,String ip_status,int super_user_id,int contactId) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into user_account(uavalidtokenno,ualoginid,uapass,uaname,uamobileno,uaemailid,"
					+ "uamprivilege,uastatus,uaaddedby,uaaip,uaabname,uaroletype, uaempid, uacompany,uarefid,"
					+ "uadepartment,uarole,ua_ip_allow,ua_ip_allow_status,super_user_uaid,contact_id) "
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1,tokenno );
			ps.setString(2,ualoginid );
			ps.setString(3,uapassword );
			ps.setString(4,name );
			ps.setString(5,mobile );
			ps.setString(6,emailid );
			ps.setString(7,access );
			ps.setString(8,"1" );
			ps.setString(9,addeduser );
			ps.setString(10,uaaip );
			ps.setString(11,uaabname );
			ps.setString(12,uaroletype );
			ps.setString(13,emuid );
			ps.setString(14,uacompany );
			ps.setString(15, key);
			ps.setString(16, department);
			ps.setString(17, role);
			ps.setString(18, ipAddress);
			ps.setString(19, ip_status);
			ps.setInt(20, super_user_id);
			ps.setInt(21, contactId);
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			e.printStackTrace();
			log.info("saveUserDetail"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing saveUserDetail() SQL Objects \n"+sqle);
			}
		}
		return status;
	}
	
	
	
	public static boolean isThisClient(String uaid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		boolean getinfo=false;
		try{
			String query="SELECT uaroletype FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+token+"'";
			ps=con.prepareStatement(query);
//			System.out.println(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()){ if(rset.getString(1).equalsIgnoreCase("Client")){
				getinfo=true;
			}}

		}catch (Exception e) {
			log.info("isThisClient"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("isThisClient"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static boolean isClientSuperUser(int userUaid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		boolean getinfo=false;
		try{
			String query="SELECT uaid FROM user_account WHERE uaid='"+userUaid+"' and uaroletype='Client' and uarole='SUPER_USER' and uavalidtokenno='"+token+"'";
			ps=con.prepareStatement(query);
//			System.out.println(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()){ getinfo=true;}

		}catch (Exception e) {
			log.info("isClientSuperUser"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("isClientSuperUser"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static boolean isClientsLoginId(String clientMobile,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		boolean getinfo=false;
		try{
			String mobile="NA";
			if(clientMobile.length()>10)mobile=clientMobile.substring(clientMobile.length()-10);
			StringBuffer query=new StringBuffer("SELECT uaid FROM user_account WHERE (ualoginid='"+clientMobile+"' ");
				if(!mobile.equalsIgnoreCase("NA"))query.append(" or ualoginid='"+mobile+"'");
				query.append(") and uaroletype='Client' and uavalidtokenno='"+token+"'");
			ps=con.prepareStatement(query.toString());
//			System.out.println(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()){ getinfo=true;}

		}catch (Exception e) {
			log.info("isClientsLoginId"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("isClientsLoginId"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static boolean isPermissionGranted(String permission,String uaid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		boolean getinfo=false;
		try{
			String query="SELECT uaid FROM user_account WHERE uaid='"+uaid+"' and uamprivilege like '%"+permission+"%'";
			ps=con.prepareStatement(query);
//			System.out.println(query);
			rset=ps.executeQuery();
			if(rset.next()){if(rset.getString(1).equalsIgnoreCase(uaid)) getinfo=true;}

		}catch (Exception e) {
			log.info("isPermissionGranted"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("isPermissionGranted"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getUserDepartment(String uaid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String query="SELECT uadepartment FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+token+"'";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) {				
					getinfo=rset.getString(1);				
			}

		}catch (Exception e) {
			log.info("getUserDepartment"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getUserDepartment"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getUserEmail(String uaid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String query="SELECT uaemailid FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+token+"'";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) {				
					getinfo=rset.getString(1);				
			}

		}catch (Exception e) {
			log.info("getUserEmail"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getUserEmail"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static int findUserUaidByMobileAndEmail(String mobile,String email,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		int getinfo=0;
		try{
			String mobile1="NA";
			if(mobile.length()>10)mobile1=mobile.substring(mobile.length()-10);			
			StringBuffer query=new StringBuffer("SELECT uaid FROM user_account WHERE (uamobileno='"+mobile+"'");
			if(!mobile1.equalsIgnoreCase("NA"))query.append(" or uamobileno='"+mobile1+"'");			
			query.append(") and uaemailid='"+email+"' and uavalidtokenno='"+token+"' limit 1");
			System.out.println(query);
			ps=con.prepareStatement(query.toString());
			rset=ps.executeQuery();
			if(rset.next()) {				
					getinfo=rset.getInt(1);				
			}

		}catch (Exception e) {
			log.info("findUserUaidByMobileAndEmail"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("findUserUaidByMobileAndEmail"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static int findUserUaidByMobile(String loginMob,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		int getinfo=0;
		try{
			String mobile="NA";
			if(loginMob.length()>10)mobile=loginMob.substring(loginMob.length()-10);
			StringBuffer query=new StringBuffer("SELECT uaid FROM user_account WHERE (ualoginid='"+loginMob+"'");
			if(!mobile.equalsIgnoreCase("NA"))query.append(" or ualoginid='"+mobile+"'");
			query.append(") and uavalidtokenno='"+token+"' limit 1");
			
			ps=con.prepareStatement(query.toString());
			rset=ps.executeQuery();
			if(rset.next()) {				
					getinfo=rset.getInt(1);				
			}

		}catch (Exception e) {
			log.info("findUserUaidByMobile"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("findUserUaidByMobile"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getUserMobile(String uaid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String query="SELECT uamobileno FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+token+"'";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) {				
					getinfo=rset.getString(1);				
			}

		}catch (Exception e) {
			log.info("getUserMobile"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getUserMobile"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getDeliveryManagerUid(String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String query="SELECT uaid FROM user_account WHERE uadepartment='Delivery' and uarole='Manager' and uavalidtokenno='"+token+"' order by uaid limit 1";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) {				
					getinfo=rset.getString(1);				
			}

		}catch (Exception e) {
			log.info("getDeliveryManagerUid"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getDeliveryManagerUid"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getUserPost(String uaid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String query="SELECT uarole FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+token+"'";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) {
				if(rset.getString(1).equalsIgnoreCase("Manager")) {
					getinfo="Delivery manager";
				}else{
					getinfo=rset.getString(1);
				}
				
			}

		}catch (Exception e) {
			log.info("getUserPost"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getUserPost"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getUserType(String uaid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String query="SELECT uaroletype FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+token+"'";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) getinfo=rset.getString(1);

		}catch (Exception e) {
			log.info("getUserType"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getUserType"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getLoginedUserName(String uarefid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String query="SELECT uaname FROM user_account WHERE uarefid='"+uarefid+"' and uavalidtokenno='"+token+"'";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) getinfo=rset.getString(1);

		}catch (Exception e) {
			log.info("getLoginedUserName"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getLoginedUserName"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getClientNumber(String uaid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String query="SELECT uaempid FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+token+"'";
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) getinfo=rset.getString(1);

		}catch (Exception e) {
			log.info("getClientNumber"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getClientNumber"+e.getMessage());
			}}
		return getinfo;
	}

	public static String getLoginStatus(String uaid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="2";
		try{
				String query="SELECT ualoginstatus FROM user_account WHERE uaid='"+uaid+"'";
				ps=con.prepareStatement(query);
				rset=ps.executeQuery();
				if(rset.next()) getinfo=rset.getString(1);
			
		}catch (Exception e) {
			log.info("getLoginStatus"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e){
				log.info("getLoginStatus"+e.getMessage());
			}}
		return getinfo;
	}	
	
	public static int findContactIdByUaid(String uaid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		int getinfo=0;
		try{
				String query="SELECT contact_id FROM user_account WHERE uaid='"+uaid+"' and uaroletype='Client' and uavalidtokenno='"+token+"'";
//				System.out.println(query);
				ps=con.prepareStatement(query);
				rset=ps.executeQuery();
				if(rset.next()) getinfo=rset.getInt(1);
			
		}catch (Exception e) {
			log.info("findContactIdByUaid"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e){
				log.info("findContactIdByUaid"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static int getLoginStatus(String clientNo,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		int getinfo=2;
		try{
				String query="SELECT ualoginstatus FROM user_account WHERE uaempid='"+clientNo+"' and uaroletype='Client' and uavalidtokenno='"+token+"'";
//				System.out.println(query);
				ps=con.prepareStatement(query);
				rset=ps.executeQuery();
				if(rset.next()) getinfo=rset.getInt(1);
			
		}catch (Exception e) {
			log.info("getLoginStatus"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e){
				log.info("getLoginStatus"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getLoginUserName(String uid,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			if(uid!=null&&!uid.equalsIgnoreCase("NA")&&uid.length()>0) {
				String query="SELECT uaname FROM user_account WHERE uaid='"+uid+"' and uavalidtokenno='"+token+"'";
				ps=con.prepareStatement(query);
				rset=ps.executeQuery();
				if(rset.next()) getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("getLoginUserName"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getLoginUserName"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String gettoken(String company) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String query="SELECT uavalidtokenno FROM user_account WHERE uacompany='"+company+"'";
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) getinfo=rset.getString(1);

		}catch (Exception e) {
			log.info("getLoginUserName"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getLoginUserName"+e.getMessage());
			}}
		return getinfo;
	}


	public static String getlasttoken() {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT comptokenno FROM company_master ORDER BY compid DESC LIMIT 0, 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}

		}catch (Exception e) {
			log.info("getlasttoken"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getlasttoken"+e.getMessage());
			}}
		return getinfo;
	}

	public static String[][] getAllConsultant(String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		StringBuffer query=null;
		try{
			getacces_con=DbCon.getCon("","","");
			query= new StringBuffer("SELECT uaid,uaname FROM user_account where uavalidtokenno='"+token+"' "
					+ "and uastatus='1' and uaroletype!='Client' and uaroletype!='super admin' and uaroletype!='Administrator' and uadepartment!='HR'");
				query.append(" order by uaname");
			
//			System.out.println(query+"/"+teamkey);
			if(query!=null) {
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
			}}
		}catch(Exception e)
		{log.info("getAllConsultant"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getAllConsultant()\n"+sqle);
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllSalesEmployee(String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		StringBuffer query=null;
		try{
			getacces_con=DbCon.getCon("","","");
			query= new StringBuffer("SELECT uaid,uaname FROM user_account where uavalidtokenno='"+token+"' and uastatus='1' and uadepartment='Sales'");
				query.append(" order by uaname");
			
//			System.out.println(query+"/"+teamkey);
			if(query!=null) {
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
			}}
		}catch(Exception e)
		{log.info("getAllSalesEmployee"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getAllSalesEmployee()\n"+sqle);
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllUserByDepartment(String department,String token,String userroll,String teamkey,String uaid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		StringBuffer query=null;
		try{
			getacces_con=DbCon.getCon("","","");
			if(!userroll.equals("Assistant")) {
				query= new StringBuffer("SELECT uaid,uaname FROM user_account where uavalidtokenno='"+token+"' and uadepartment='"+department+"' and uastatus='1'");
				query.append(" order by uaid");
			}else if(userroll.equals("Assistant")&&teamkey!=null&&!teamkey.equalsIgnoreCase("NA")) {
				query= new StringBuffer("SELECT uaid,uaname FROM user_account where uavalidtokenno='"+token+"' and uadepartment='"+department+"' and uastatus='1' and exists(select tmid from manageteammemberctrl where tmteamrefid='"+teamkey+"' and tmuseruid=uaid) or uaid='"+uaid+"'");
				query.append(" order by uaid");
			}
//			System.out.println(query+"/"+teamkey);
			if(query!=null) {
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
			}}
		}catch(Exception e)
		{log.info("getAllUserByDepartment"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getAllUserByDepartment()\n"+sqle);
			}
		}
		return newsdata;
	}
	
	public static String[][] findAllUserByDepartmentAndRole(String department,String role) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		StringBuffer query=null;
		try{
			getacces_con=DbCon.getCon("","","");
			query= new StringBuffer("SELECT uaid,uaname,uaemailid,uavalidtokenno FROM user_account where uadepartment='"+department+"' "
					+ "and uarole='"+role+"' and uastatus='1'");
							
//			System.out.println(query+"/"+teamkey);
			if(query!=null) {
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
			}}
		}catch(Exception e)
		{log.info("findAllUserByDepartmentAndRole"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects findAllUserByDepartmentAndRole()\n"+sqle);
			}
		}
		return newsdata;
	}
	
	/*For manage user */
	public static String[][] getAllAccountant(String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer query= new StringBuffer("SELECT uaid,uaname,uaemailid FROM user_account where uaemailid='praveen.kumar@corpseed.com' and uavalidtokenno='"+token+"' and uarole='Accountant' and uastatus='1'");
			query.append(" order by uaid desc limit 1");
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
		{log.info("getAlluser"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getAlluser()\n"+sqle);
			}
		}
		return newsdata;
	}
	
	public static String[][] fetchAllSuperUser(String token, String name, String mobile,int page,int rows,String sort,
			String order) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			if(name==null || name.equalsIgnoreCase("null") || name.length() <= 0){ name ="NA";}
			if(mobile==null || mobile.equalsIgnoreCase("null") || mobile.length() <= 0){ mobile ="NA";}
			
			StringBuffer query= new StringBuffer("SELECT uaid,uaname,uamobileno,uaemailid,ualoginid FROM user_account "
					+ "where uavalidtokenno='"+token+"' and uarole='SUPER_USER'");
			
			if(name!="NA") query.append(" and uaname like '"+name+"'");
			if(mobile!="NA") query.append(" and uamobileno = '"+mobile+"'");
			if(sort.length()<=0)			
				query.append(" order by uaid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("id"))query.append("order by uaid "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("name"))query.append("order by uaname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("mobile"))query.append("order by uamobileno "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("email"))query.append("order by uaemailid "+order+" limit "+((page-1)*rows)+","+rows);				
				else query.append(" order by uaid desc");
//					System.out.println(query);
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
		}catch(Exception e){log.info("fetchAllSuperUser"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects fetchAllSuperUser()\n"+sqle);
			}
		}
		return newsdata;
	}
	
	public static int countAllSuperUser(String token, String name, String mobile) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		try{
			getacces_con=DbCon.getCon("","","");
			if(name==null || name.equalsIgnoreCase("null") || name.length() <= 0){ name ="NA";}
			if(mobile==null || mobile.equalsIgnoreCase("null") || mobile.length() <= 0){ mobile ="NA";}
			
			StringBuffer query= new StringBuffer("SELECT count(uaid) FROM user_account "
					+ "where uavalidtokenno='"+token+"' and uarole='SUPER_USER'");
			
			if(name!="NA") query.append(" and uaname like '"+name+"'");
			if(mobile!="NA") query.append(" and uamobileno = '"+mobile+"'");
			
			stmnt=getacces_con.prepareStatement(query.toString());
			rsGCD=stmnt.executeQuery();
			
			if(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{log.info("countAllSuperUser"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects countAllSuperUser()\n"+sqle);
			}
		}
		return newsdata;
	}
	
	/*For manage user */
	public static String[][] getAlluser(String token, String name, String mobile, String type,
			String userroll,String addedby,int page,int rows,String sort,String order) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			if(name==null || name.equalsIgnoreCase("null") || name.length() <= 0){ name ="NA";}
			if(mobile==null || mobile.equalsIgnoreCase("null") || mobile.length() <= 0){ mobile ="NA";}
			if(type==null || type.equalsIgnoreCase("null") || type.length() <= 0){ type ="NA";}
			StringBuffer query= new StringBuffer("SELECT uaid, uaempid, ualoginid, uavalidtokenno, uapass, uaname, uamobileno, uaemailid, uamprivilege, uastatus, uaaddedby, uaaddedon, uaaip, uaabname,uaroletype,uadepartment,uarole,ua_ip_allow,ua_ip_allow_status FROM user_account where uastatus!='NA'");
			if(!userroll.equalsIgnoreCase("super admin")) {
				if(userroll.equalsIgnoreCase("Administrator"))query.append(" and uavalidtokenno='"+token+"'");
				else
				query.append(" and uavalidtokenno='"+token+"' and uaaddedby='"+addedby+"'");
			}
			if(name!="NA") query.append(" and uaname like '"+name+"%'");
			if(mobile!="NA") query.append(" and uamobileno = '"+mobile+"'");
			if(type!="NA") query.append(" and uaroletype = '"+type+"'");
			if(sort.length()<=0)			
				query.append(" order by uaid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("id"))query.append("order by uaid "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("name"))query.append("order by uaname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("role_type"))query.append("order by uaroletype "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("department"))query.append("order by uadepartment "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("role"))query.append("order by uarole "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("user_id"))query.append("order by ualoginid "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("password"))query.append("order by uapass "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("ip"))query.append("order by ua_ip_allow "+order+" limit "+((page-1)*rows)+","+rows);
				else query.append(" order by uaid desc");
//					System.out.println(query);
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
		}catch(Exception e){log.info("getAlluser"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getAlluser()\n"+sqle);
			}
		}
		return newsdata;
	}
	public static int countAlluser(String token, String name, String mobile, String type,String userroll,String addedby) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		try{
			getacces_con=DbCon.getCon("","","");
			if(name==null || name.equalsIgnoreCase("null") || name.length() <= 0){ name ="NA";}
			if(mobile==null || mobile.equalsIgnoreCase("null") || mobile.length() <= 0){ mobile ="NA";}
			if(type==null || type.equalsIgnoreCase("null") || type.length() <= 0){ type ="NA";}
			StringBuffer query= new StringBuffer("SELECT count(uaid) FROM user_account where uastatus!='NA'");
			if(!userroll.equalsIgnoreCase("super admin")) {
				if(userroll.equalsIgnoreCase("Administrator"))query.append(" and uavalidtokenno='"+token+"'");
				else
				query.append(" and uavalidtokenno='"+token+"' and uaaddedby='"+addedby+"'");
			}
			if(name!="NA") query.append(" and uaname like '"+name+"%'");
			if(mobile!="NA") query.append(" and uamobileno = '"+mobile+"'");
			if(type!="NA") query.append(" and uaroletype = '"+type+"'");
			query.append(" order by uaroletype desc");
			stmnt=getacces_con.prepareStatement(query.toString());
			rsGCD=stmnt.executeQuery();
			
			if(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{log.info("countAlluser"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects countAlluser()\n"+sqle);
			}
		}
		return newsdata;
	}
	/*For edit-user jsp fetching data by id*/
	public static String[][] getUserByID(String uid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT uaid, uaempid, ualoginid, uavalidtokenno, uapass, uaname, uamobileno, uaemailid, uamprivilege, uastatus, uaaddedby, uaaddedon, uaaip, uaabname,uaroletype,uacompany,uadepartment,uarole FROM user_account where uaid='"+uid+"' ";
//			System.out.println(query);
			stmnt=getacces_con.prepareStatement(query);
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
		{log.info("getUserByID"+e.getMessage());}
		finally{

			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getUserByID()\n"+sqle);
			}
		}
		return newsdata;
	}

	/*mark all notification as read*/
	public static boolean markAllAsRead(String loginuaid,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE notifications SET nSeenStatus='2' WHERE nShowUid='"+loginuaid+"' and nShowClient='2' and nToken='"+token+"'";
			ps = con.prepareStatement(query);
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("markAllAsRead"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects markAllAsRead()\n"+sqle);
			}
		}
		return status;
	}
	
	/*For update on editjsp page*/
	public static boolean markAsRead(String refid,String role) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String column="NA";
			if(role.equalsIgnoreCase("Administrator"))column="notseenstatus";
			else if(role.equalsIgnoreCase("Employee"))column="notemployeeseenstatus";
			
			String query = "UPDATE notifications SET "+column+"=? WHERE notrefid=?";
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
				log.info("Error Closing SQL Objects markAsRead\n"+sqle);
			}
		}
		return status;
	}

	
	/*For update on editjsp page*/
	public static boolean updateUser(String uid,String ualoginid,String uapassword,String access,String addeduser,String uaaip,String uaabname,String department,String role) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET ualoginid=?,uapass=?,uamprivilege=?,uaaddedby=?,uaaip=?,uaabname=?,uadepartment=?,uarole=? WHERE uaid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,ualoginid );
			ps.setString(2,uapassword );
			ps.setString(3,access );
			ps.setString(4,addeduser );
			ps.setString(5,uaaip );
			ps.setString(6,uaabname );
			ps.setString(7,department );
			ps.setString(8,role );
			ps.setString(9,uid );			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateUser"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateUser\n"+sqle);
			}
		}
		return status;
	}

	public static boolean updateUserLoginStatus(String uaid,int login_status) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update user_account set ualoginstatus=? where uaid=?";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.setInt(1, login_status);
			ps.setString(2, uaid);
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateUserLoginStatus"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateUserLoginStatus\n"+sqle);
			}
		}
		return status;
	}
	
	/*For Activate/deactivate company/employee/client*/

	@SuppressWarnings("resource")
	public static void deleteRelatedUser(String uid,String value) {
		PreparedStatement ps = null;
		ResultSet rs=null;
		
		String name=null;
		String mobile=null;
		String email=null;
		String role=null;
		String query=null;
		Connection con = DbCon.getCon("","","");
		try{
			query = "select uaname,uamobileno,uaemailid,uaroletype from user_account WHERE uaid='"+uid+"'";
			ps = con.prepareStatement(query);
			rs=ps.executeQuery();
			if(rs.next()) {
				name=rs.getString(1);
				mobile=rs.getString(2);
				email=rs.getString(3);
				role=rs.getString(4);
			}
			if(role.equalsIgnoreCase("Administrator"))
				query="update company_master set compstatus=? where compname=? and compmobile=? and compemail=?";
			if(role.equalsIgnoreCase("Employee"))
				query="update employee_master set emstatus=? where emname=? and emmobile=? and ememail=?";
			if(role.equalsIgnoreCase("Client"))
				query="update hrmclient_reg set cregstatus=? where cregname=? and cregmob=? and cregemailid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,value );
			ps.setString(2,name );
			ps.setString(3,mobile );
			ps.setString(4,email );
			ps.execute();
			
		}catch (Exception e) {
			log.info("deleteRelatedUser"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects deleteRelatedUser()\n"+sqle);
			}
		}
	
	}
	
	
	/*For delete on manage page*/

	public static boolean deleteUser(String uid,String value) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET uastatus=? WHERE uaid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,value );
			ps.setString(2,uid );
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("deleteUser"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects deleteUser()\n"+sqle);
			}
		}
		return status;
	}

	/*For getting profile by id */

	public static String[][] getUserProfile(String ualoginid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT uaid,uaname, uamobileno, uaemailid, uaempid  FROM user_account where ualoginid='"+ualoginid+"' ";
//			System.out.println(query);
			stmnt=getacces_con.prepareStatement(query);
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
		{log.info("getUserProfile"+e.getMessage());}
		finally{

			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getUserProfile()\n"+sqle);
			}
		}
		return newsdata;
	}

	/*For updating profile in editprofile jsp*/

	public static boolean updateUserProfile(String userName,String userMobile,String userEmail,String loginid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET uaname=?, uamobileno=?,uaemailid=? WHERE ualoginid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,userName );
			ps.setString(2,userMobile );
			ps.setString(3,userEmail );
			ps.setString(4,loginid );
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("updateUserProfile"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateUserProfile()\n"+sqle);
			}
		}
		return status;
	}

	public static String getStartingCode(String token,String attribute) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = "";
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT "+attribute+" FROM initial_master where imtokenno = '"+token+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error in getStartingCode() method \n"+e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				log.info("Error Inside finally block of getStartingCode() method of UserData Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public static String[][] getDocuments(String type, String fileid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="select * from document_master where dmtype='"+type+"' and dmfileid='"+fileid+"' and dmstatus='1'";
			stmnt=getacces_con.prepareStatement(query);
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
		{log.info("Error in getDocuments() method \n"+e.getMessage());}
		finally{

			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD != null){rsGCD.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getDocuments()\n"+sqle);
			}
		}
		return newsdata;
	}



	public static void SaveDocument(String dmtype, String passid, String imagename, String imageurl, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into document_master (dmtype, dmfileid, dmfilename, dmfileurl, dmstatus, dmaddedby) values (?,?,?,?,?,?)";
			ps = con.prepareStatement(query);			
			ps.setString(1,dmtype );
			ps.setString(2,passid );
			ps.setString(3,imagename );
			ps.setString(4,imageurl );
			ps.setString(5,"1" );
			ps.setString(6,addedby );
			ps.executeUpdate();
		}catch (Exception e) {
			log.info("Error in SaveDocument() method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects SaveDocument()\n"+sqle);
			}
		}
	}



	public static void deleteDocument(String id) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update document_master set dmstatus='0' where dmuid='"+id+"'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
		}catch (Exception e) {
			log.info("Error in deleteDocument() method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects deleteDocument()\n"+sqle);
			}
		}
	}

	public static boolean updateUserIp(String ip, String uaid, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET ua_ip_allow=? WHERE uaid=? and uavalidtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, ip);
			ps.setString(2, uaid);
			ps.setString(3, token);
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			e.printStackTrace();
			log.info("updateUserIp"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateUserIp()\n"+sqle);
			}
		}
		return status;
	}
	public static boolean updateUserIpStatus(String ip_status, String uaid, String token,String loginuaid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET ua_ip_allow_status=?,ua_ip_action_date=?,ua_ip_action_uaid=? WHERE uaid=? and uavalidtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, ip_status);
			ps.setString(2, new Date().toString());
			ps.setString(3, loginuaid);
			ps.setString(4, uaid);
			ps.setString(5, token);
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			e.printStackTrace();
			log.info("updateUserIpStatus"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateUserIpStatus()\n"+sqle);
			}
		}
		return status;
	}

	public static String[] getLoginInformation(String creguid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] =new String[2];
		try {
			String queryselect = "SELECT ualoginid,uapass FROM user_account where uaempid='"+creguid+"' and uaroletype='Client' and uavalidtokenno='"+token+"' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("getLoginInformation"+e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rset!=null) rset.close();
			} catch (SQLException e) {
				log.info("getLoginInformation"+e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean updateUserLoginStatus1(String loginuaid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update user_account set ualoginstatus='1' where uaid='"+loginuaid+"'";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			int k=ps.executeUpdate();
			if(k>0)status = true;
			
		}catch (Exception e) {e.printStackTrace();
			log.info("updateUserLoginStatus"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateUserLoginStatus()\n"+sqle);
			}
		}
		return status;
	}

	public static String getClientUserName(String clientNumber, String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String query="SELECT ualoginid FROM user_account WHERE uaempid='"+clientNumber+"' and uaroletype='Client' and uavalidtokenno='"+token+"'";
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) getinfo=rset.getString(1);

		}catch (Exception e) {
			log.info("getClientUserName"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getClientUserName"+e.getMessage());
			}}
		return getinfo;
	}

	public static boolean updateClientUsername(int uaid, String mobile, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET ualoginid=? WHERE uaid=? and uavalidtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,mobile );
			ps.setInt(2,uaid);
			ps.setString(3,token);			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateClientUsername"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("updateClientUsername"+e.getMessage());
			}}
		return status;
	}

	public static String[] isValidUser(String username) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo[]=new String[4];
		try{
			String query="SELECT uaemailid,uaname,uavalidtokenno,uarefid FROM user_account WHERE ualoginid='"+username+"' limit 1";
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()) {
				getinfo[0]=rset.getString(1);
				getinfo[1]=rset.getString(2);
				getinfo[2]=rset.getString(3);
				getinfo[3]=rset.getString(4);
			}

		}catch (Exception e) {
			log.info("getClientUserName"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getClientUserName"+e.getMessage());
			}}
		return getinfo;
	}

	public static boolean updateUserPassword(String user_uuid, String confirmPassword) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET uapass=? WHERE uarefid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,confirmPassword );
			ps.setString(2,user_uuid );	
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("updateUserPassword"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("updateUserPassword"+e.getMessage());
			}}
		return status;
	}

	public static boolean inactivePasswordLink(String forget_key) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE forget_password SET status=? WHERE uuid=?";
			ps = con.prepareStatement(query);
			ps.setInt(1,2);
			ps.setString(2,forget_key);		
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			log.info("inactivePasswordLink"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("inactivePasswordLink"+e.getMessage());
			}}
		return status;
	}

	public static String[] getUserByClientNo(String clientNo, String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo[]=new String[4];
		try{
			String query="SELECT uaemailid,uaname FROM user_account WHERE uaempid='"+clientNo+"' limit 1";
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()) {
				getinfo[0]=rset.getString(1);
				getinfo[1]=rset.getString(2);
			}

		}catch (Exception e) {
			log.info("getUserByClientNo"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getUserByClientNo"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getUserByUaid(String uaid, String uavalidtokenno) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="";
		try{
			String query="SELECT uaname FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+uavalidtokenno+"'";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()) {
				getinfo="<option value='"+uaid+"'>"+rset.getString(1)+"</option>";
			}

		}catch (Exception e) {
			log.info("getUserByUaid"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getUserByUaid"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String findUserEmailByUaid(int uaid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="";
		try{
			String query="SELECT uaemailid FROM user_account WHERE uaid='"+uaid+"'";
//			System.out.println(query);
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()) {
				getinfo=rset.getString(1);
			}

		}catch (Exception e) {
			log.info("findUserEmailByUaid"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("findUserEmailByUaid"+e.getMessage());
			}}
		return getinfo;
	}
	
//	public static String findUsernameByUaid(String uaid,String token) {
//		Connection con = DbCon.getCon("","","");
//		PreparedStatement ps = null;
//		ResultSet rset=null;
//		String getinfo="";
//		try{
//			String query="SELECT ualoginid FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+token+"'";
////			System.out.println(query);
//			ps=con.prepareStatement(query);
//			rset=ps.executeQuery();
//			if(rset!=null&&rset.next()) {
//				getinfo=rset.getString(1);
//			}
//
//		}catch (Exception e) {
//			log.info("findUsernameByUaid"+e.getMessage());
//		}finally {
//			try {
//				//closing sql objects
//				if(ps!=null) {ps.close();}
//				if(con!=null) {con.close();}
//				if(rset!=null) {rset.close();}
//			} catch (SQLException e)
//			{
//				log.info("findUsernameByUaid"+e.getMessage());
//			}}
//		return getinfo;
//	}
	
	public static String findUserByUaid(String uaid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="";
		try{
			String query="SELECT uaname FROM user_account WHERE uaid='"+uaid+"'";
//			System.out.println(query);
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()) {
				getinfo=rset.getString(1);
			}

		}catch (Exception e) {
			log.info("findUserByUaid"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("findUserByUaid"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String[] findUserDataByUaid(String uaid, String uavalidtokenno) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo[]=new String[5];
		try{
			String query="SELECT uaname,uaemailid,ualoginid,uapass,uamobileno FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+uavalidtokenno+"'";
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()) {
				getinfo[0]=rset.getString(1);
				getinfo[1]=rset.getString(2);
				getinfo[2]=rset.getString(3);
				getinfo[3]=rset.getString(4);
				getinfo[4]=rset.getString(5);
			}

		}catch (Exception e) {
			log.info("findUserDataByUaid"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("findUserDataByUaid"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String[] findUserByUaid(int uaid, String uavalidtokenno) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo[]=new String[2];
		try{
			String query="SELECT uaname,uaemailid FROM user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+uavalidtokenno+"'";
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()) {
				getinfo[0]=rset.getString(1);
				getinfo[1]=rset.getString(2);
			}

		}catch (Exception e) {
			log.info("getUserByUaid"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getUserByUaid"+e.getMessage());
			}}
		return getinfo;
	}

	public static String[] findUserDetailsByUaid(String uaid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo[]=new String[2];
		try{
			String query="SELECT uaname,uaemailid FROM user_account WHERE uaid='"+uaid+"'";
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()) {
				getinfo[0]=rset.getString(1);
				getinfo[1]=rset.getString(2);
			}

		}catch (Exception e) {
			log.info("findUserDetailsByUaid"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("findUserDetailsByUaid"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getAllDeliveryManager(String uavalidtokenno) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="";
		try{
			String query="SELECT uaid,uaname FROM user_account WHERE uadepartment='Delivery' and uarole='Manager' and uavalidtokenno='"+uavalidtokenno+"'";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			while(rset!=null&&rset.next()) {
				getinfo+="<option value='"+rset.getString(1)+"'>"+rset.getString(2)+"</option>";
			}

		}catch (Exception e) {
			log.info("getAllDeliveryManager"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("getAllDeliveryManager"+e.getMessage());
			}}
		return getinfo;
	}

	public static boolean findUserByMobileOrEmail(String super_mobile, String super_email) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		boolean getinfo=false;
		try{
			String query="SELECT uaid FROM user_account WHERE (uamobileno='"+super_mobile+"' or uaemailid='"+super_email+"') limit 1";
//			System.out.println(query);
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next())getinfo=true;
		}catch (Exception e) {
			log.info("findUserByMobileOrEmail"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("findUserByMobileOrEmail"+e.getMessage());
			}}
		return getinfo;
	}

	public static boolean saveClientSuperUser(String uaempid, String super_mobile, String token, String password,
			String super_name,String super_email,String addedby, String company, String userKey) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into user_account(uaempid,ualoginid,uavalidtokenno,uapass,uaname,uamobileno,"
					+ "uaemailid,uamprivilege,uastatus,uaaddedby,uaroletype,uadepartment,uarole,uaaip,uaabname,"
					+ "uacompany,uarefid,ua_ip_allow,ua_ip_allow_status,ualoginstatus) "
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1,uaempid );
			ps.setString(2,super_mobile );
			ps.setString(3,token );
			ps.setString(4,password );
			ps.setString(5,super_name );
			ps.setString(6,super_mobile );
			ps.setString(7,super_email );
			ps.setString(8,"NA" );
			ps.setString(9,"1" );
			ps.setString(10,addedby );
			ps.setString(11,"Client" );
			ps.setString(12,"NA" );
			ps.setString(13,"SUPER_USER" );
			ps.setString(14,"0.0.0" );
			ps.setString(15, "NA");
			ps.setString(16, company);
			ps.setString(17, userKey);
			ps.setString(18, "0.0.0");
			ps.setString(19, "2");
			ps.setString(20, "2");
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			e.printStackTrace();
			log.info("saveClientSuperUser"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing saveClientSuperUser() SQL Objects \n"+sqle);
			}
		}
		return status;
	}

	public static String[][] findAllClientSuperUser(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT uaid,uaname,uamobileno,uaemailid FROM user_account where uaroletype='Client' "
					+ "and uastatus='1' and uarole='SUPER_USER' and uavalidtokenno='"+token+"' order by trim(uaname)";
//			System.out.println(query);
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
			log.info("findAllClientSuperUser" + e.getMessage());
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
				log.info("findAllClientSuperUser" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findAllUserBySuperUser(int superUserId,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT uaid,uaname,uaemailid,uamobileno FROM user_account where super_user_uaid='"+superUserId+"' and uavalidtokenno='"+token+"'";
//			System.out.println(query);
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
			log.info("findAllUserBySuperUser" + e.getMessage());
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
				log.info("findAllUserBySuperUser" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateUserMobileAndEmail(String email, String workphone,int contactId,String token,String name) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET uaname=?,uamobileno=?,uaemailid=? WHERE contact_id=? and uavalidtokenno=?";
//			System.out.println(query+"#"+contactId);
			ps = con.prepareStatement(query);
			ps.setString(1,name );
			ps.setString(2,workphone );
			ps.setString(3,email );
			ps.setInt(4,contactId );
			ps.setString(5,token);
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}catch (Exception e) {
			e.printStackTrace();
			log.info("updateUserMobileAndEmail"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateUserMobileAndEmail\n"+sqle);
			}
		}
		return status;
	}

	public static boolean findUserByMobileOrEmailAndIdNot(String super_mobile, String super_email, String uaid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		boolean getinfo=false;
		try{
			String query="SELECT uaid FROM user_account WHERE (uamobileno='"+super_mobile+"' or uaemailid='"+super_email+"') and uaid!='"+uaid+"' limit 1";
//			System.out.println(query);
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next())getinfo=true;
		}catch (Exception e) {
			log.info("findUserByMobileOrEmailAndIdNot"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("findUserByMobileOrEmailAndIdNot"+e.getMessage());
			}}
		return getinfo;
	}

	public static boolean updateClientSuperUser(String super_mobile, String token, String super_name,
			String super_email, String uaid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE user_account SET uaname=?, uamobileno=?,uaemailid=? WHERE uaid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,super_name );
			ps.setString(2,super_mobile );
			ps.setString(3,super_email );
			ps.setString(4,uaid );
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("updateClientSuperUser"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects updateClientSuperUser()\n"+sqle);
			}
		}
		return status;
	}

	public static boolean deleteSuperUser(String uaid, String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		boolean getinfo=false;
		try{
			String query="delete from user_account WHERE uaid='"+uaid+"' and uavalidtokenno='"+token+"'";
//			System.out.println(query);
			ps=con.prepareStatement(query);
			ps.execute();
			getinfo=true;
		}catch (Exception e) {
			log.info("deleteSuperUser"+e.getMessage());
			e.printStackTrace();
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e){
				e.printStackTrace();
				log.info("deleteSuperUser"+e.getMessage());
			}}
		return getinfo;
	}

	public static String fetchSuperUserByUserId(String id, String uavalidtokenno) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String query="SELECT super_user_uaid FROM user_account WHERE uaid='"+id+"' and uavalidtokenno='"+uavalidtokenno+"'";
			
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset!=null&&rset.next()) {
				getinfo=rset.getString(1);
			}

		}catch (Exception e) {
			log.info("fetchSuperUserByUserId"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e)
			{
				log.info("fetchSuperUserByUserId"+e.getMessage());
			}}
		return getinfo;
	}

}