package admin.Login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;

import commons.DateUtil;
import commons.DbCon;
public class LoginAction {
	private static Logger log = Logger.getLogger(LoginAction.class);
	public boolean isValidUser(String userId, String pwd) {
		//Initialing Variables
		boolean validUser = false;
		Connection validuser_con=null;
		PreparedStatement stmnt=null;
		ResultSet rsInfo =null;
		String userName=null;
		String password=null;
		try {
			validuser_con= DbCon.getCon("","","");
			stmnt = validuser_con.prepareStatement("SELECT ualoginid, uapass FROM user_account where uastatus=1 and ualoginid='"+userId+"' and uapass='"+pwd+"'");
//			System.out.println("SELECT ualoginid, uapass FROM user_account where uastatus=1 and ualoginid='"+userId+"' and uapass='"+pwd+"'");
			rsInfo = stmnt.executeQuery();
			while (rsInfo.next()) {
				userName = rsInfo.getString(1);
				password = rsInfo.getString(2);
				if ((userId.equals(userName)) && (pwd.equals(password))) {
					validUser = true;
					break;
				}
			}
		} catch (SQLException e) {

			log.info("Error at isValidUser()method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsInfo!=null) {rsInfo.close();}
				if(validuser_con!=null) {validuser_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing isValidUser() SQL Objects \n"+sqle.getMessage());
			}
		}
		return validUser;
	}

	public boolean isUserAccountVerification(String userId, String pwd) {
		boolean validUser = false;
		Connection validuser_con=null;
		PreparedStatement stmnt=null;
		ResultSet rsInfo =null;
		String userName=null;
		String password=null;
		try {
			//Creating Connection
			validuser_con= DbCon.getCon("","","");
			stmnt = validuser_con.prepareStatement("SELECT ualoginid, uapass FROM user_account where uastatus=1");
			rsInfo = stmnt.executeQuery();
			while (rsInfo.next()) {
				userName = rsInfo.getString(1);
				password = rsInfo.getString(2);
				if ((userId.equalsIgnoreCase(userName)) && (pwd.equals(password))) {
					validUser = true;
					break;
				}
			}
		} catch (SQLException e) {

			log.info("Error at isUserAccountVerification() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsInfo!=null) {rsInfo.close();}
				if(validuser_con!=null) {validuser_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing isUserAccountVerification SQL Objects \n"+sqle);
			}
		}
		return validUser;
	}

	public boolean isUserFinacialVerification(String userId, String pwd) {


		//Initialing Variables
		boolean validUser = false;
		Connection validuser_con=null;
		PreparedStatement stmnt=null;
		ResultSet rsInfo =null;
		String userName=null;
		String password=null;
		try {
			validuser_con= DbCon.getCon("","","");
			stmnt = validuser_con.prepareStatement("SELECT ualoginid, uapass FROM user_account where uastatus=1 ");
			rsInfo = stmnt.executeQuery();
			while (rsInfo.next()) {
				userName = rsInfo.getString(1);
				password = rsInfo.getString(2);
				if ((userId.equalsIgnoreCase(userName)) && (pwd.equals(password))) {
					validUser = true;
					break;
				}
			}
		} catch (SQLException e) {

			log.info("Error at isUserFinacialVerification() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsInfo!=null) {rsInfo.close();}
				if(validuser_con!=null) {validuser_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing isUserFinacialVerification() SQL Objects \n"+sqle);
			}
		}
		return validUser;
	}

	public String getClientName(String loginid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uaname FROM `user_account` where ualoginid = '"+loginid+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getClientName() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getClientName() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}
	
	public String getAccess(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uamprivilege FROM user_account where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getAccess() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getAccess() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public String getAccesssubmenu(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uamprivilege FROM user_account where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getAccesssubmenu() method in Class LoginAction \n "+ e.getMessage());
		}

		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getAccesssubmenu() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public String getEmptokenid(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uavalidtokenno FROM `user_account` where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getEmptokenid() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getEmptokenid() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public String getUserRefid(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uarefid FROM `user_account` where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getUserRefid() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getUserRefid() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}
	
	public String getLoginRefid(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uarefid FROM `user_account` where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getLoginRefid() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getLoginRefid() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public boolean isIpAllow(String ip,String uaid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		boolean status = false;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT ua_ip_allow,ua_ip_allow_status FROM `user_account` where uaid='"+uaid+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			if(rsGCD!=null && rsGCD.next()){
				if(rsGCD.getString(2).equalsIgnoreCase("2"))status=true;
				else if(rsGCD.getString(2).equalsIgnoreCase("1")&&rsGCD.getString(1).equalsIgnoreCase(ip))status=true;
				else status=false;
			}
		} catch (Exception e) {
			log.info("Error at isIpAllow() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of isIpAllow() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	public String getEmpCID(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uaid FROM `user_account` where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getEmpCID() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getEmpCID() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public String getEmpName(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uaname FROM `user_account` where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getEmpName() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getEmpName() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public String getEmpId(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uaempid FROM `user_account` where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getEmpId() method in Class LoginAction \n "+ e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getAccess() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public String getRole(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uarole FROM `user_account` where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at uarole() method in Class LoginAction \n "+ e.getMessage());
		}

		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of uarole() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public String getDepartment(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uadepartment FROM `user_account` where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getDepartment() method in Class LoginAction \n "+ e.getMessage());
		}

		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getDepartment() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}
	
	public String getRoleType(String userName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uaroletype FROM `user_account` where ualoginid = '"+userName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error at getRoleType() method in Class LoginAction \n "+ e.getMessage());
		}

		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getRoleType() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}


	public void storeLoginInformation(String loggedUser,String loggedUserSessionID,String ipaddress,String remotehostname,String uavalidtokenno){

		PreparedStatement SLIPS=null;
		Connection SLICON=null;
		ResultSet rs = null;
		int exists = 0;
		try{
			SLICON=DbCon.getCon("","","");
			SLIPS=SLICON.prepareStatement("select loginat from login_information where ualoginid='"+loggedUser+"' and loginon='"+DateUtil.getCurrentDateIndianFormat()+"'");
			rs=SLIPS.executeQuery();
			if(rs.next()) exists = 1;
			SLIPS.close();
			if(exists==0) {
				SLIPS = SLICON.prepareStatement("insert into login_information (ualoginid, loginon, loginat, loginusessid,loginbyip, loginbyhost,logtokenno) values(?,?,?,?,?,?,?)");
				SLIPS.setString(1,loggedUser );
				SLIPS.setString(2,DateUtil.getCurrentDateIndianFormat() );
				SLIPS.setString(3,DateUtil.getCurrentTime() );
				SLIPS.setString(4,loggedUserSessionID );
				SLIPS.setString(5,ipaddress );
				SLIPS.setString(6,remotehostname );
				SLIPS.setString(7,uavalidtokenno );
				SLIPS.execute();
			}
		}catch(Exception e){

			log.info("Error in  storeLoginInformation() LoginAction.java \n"+e.getMessage());
		}
		finally{

			try{
				if(SLIPS != null){SLIPS.close();}
				if(SLICON != null){SLICON.close();}
				if(rs != null){rs.close();}
			}catch(Exception e){

				log.info("Error in  storeLoginInformation() on closing  SQL Objects \n"+e.getMessage());
			}
		}
	}
	
	public static boolean getTodayTaskNotification(String taskno,String today,String token){

		PreparedStatement SLIPS=null;
		Connection SLICON=null;
		ResultSet rs=null;
		boolean data=false;
		try{
			SLICON=DbCon.getCon("","","");
			SLIPS=SLICON.prepareStatement("select notid from notifications WHERE notuid='"+taskno+"' and notfrom ='login' and notdate='"+today+"' and nottokenno='"+token+"'");
			rs=SLIPS.executeQuery();
//			System.out.println("select notid from notifications WHERE notuid='"+taskno+"' and notfrom ='login' and notdate='"+today+"' and nottokenno='"+token+"'");
			if(rs.next())if(rs.getString(1)!=null)data=true;
		}catch(Exception e){
			e.printStackTrace();
			log.info("Error in  getTodayTaskNotification() LoginAction.java \n"+e.getMessage());
		}
		finally{

			try{
				if(SLIPS != null){SLIPS.close();}
				if(SLICON != null){SLICON.close();}
				if(rs!=null)rs.close();

			}catch(Exception e){

				log.info("Error in  getTodayTaskNotification() on closing  SQL Objects \n"+e.getMessage());
			}
		}
		return data;
	}
	
	public static void updateLogoutInformation(String loggedUser,String sessionID){

		PreparedStatement SLIPS=null;
		Connection SLICON=null;

		try{
			SLICON=DbCon.getCon("","","");
			SLIPS=SLICON.prepareStatement("UPDATE login_information SET logoutat='"+DateUtil.getCurrentTime()+"' WHERE ualoginid='"+loggedUser+"' and loginusessid ='"+sessionID+"' and logoutat='NA'");
			SLIPS.execute();
		}catch(Exception e){
			e.printStackTrace();
			log.info("Error in  updateLogoutInformation() LoginAction.java \n"+e.getMessage());
		}
		finally{

			try{
				if(SLIPS != null){SLIPS.close();}
				if(SLICON != null){SLICON.close();}

			}catch(Exception e){

				log.info("Error in  updateLogoutInformation() on closing  SQL Objects \n"+e.getMessage());
			}
		}
	}

	@SuppressWarnings("resource")
	public static void addAttendance(String uaempid, String addedby,String token) {
		 
		DateFormat df = new SimpleDateFormat("HH:mm:ss");
		Calendar calobj = Calendar.getInstance();		
		   String intime=df.format(calobj.getTime()).toString();		  
		   String status=null;   
		PreparedStatement ps=null;
		Connection con=null;
		ResultSet rs = null;
		int exists = 0;
		try{
			con=DbCon.getCon("","","");
			ps=con.prepareStatement("select amuid from attendance_master where amuserid='"+uaempid+"' and amdate=date_format(now(),'%d-%m-%Y') and amtokenno='"+token+"'");
			rs = ps.executeQuery();
			if(rs.next()) {
				exists = 1;
			}	
			if(exists==0) {				
				String a[]=intime.split(":");
				if(Integer.parseInt(a[0])>=11)
					status="Half Day";
				else
					status="Present";
				
				ps=con.prepareStatement("insert into attendance_master (amdate, amuserid, amattendance, amintime, amaddedby,amtokenno) values (date_format(now(),'%d-%m-%Y'),'"+uaempid+"','"+status+"','"+intime+"','"+addedby+"','"+token+"')");
			    ps.execute();
			}
		}catch(Exception e){
			log.info("Error in  addAttendance() LoginAction.java \n"+e.getMessage());
		}
		finally{
			try{
				if(ps != null){ps.close();}
				if(con != null){con.close();}
				if(rs != null){rs.close();}
			}catch(Exception e){
				log.info("Error in  addAttendance() on closing  SQL Objects \n"+e.getMessage());
			}
		}
	}

	public static void updateAttendance(String uaempid, String today) {
		PreparedStatement SLIPS=null;
		Connection SLICON=null;

		try{
			SLICON=DbCon.getCon("","","");			
			SLIPS=SLICON.prepareStatement("UPDATE attendance_master SET amouttime=? WHERE amuserid=? and amdate =?");
			SLIPS.setString(1,DateUtil.getCurrentTime());
			SLIPS.setString(2,uaempid);
			SLIPS.setString(3,today);
			SLIPS.execute();
		}catch(Exception e){

			log.info("Error in  updateAttendance() LoginAction.java \n"+e.getMessage());
		}
		finally{

			try{
				if(SLIPS != null){SLIPS.close();}
				if(SLICON != null){SLICON.close();}

			}catch(Exception e){

				log.info("Error in  updateAttendance() on closing  SQL Objects \n"+e.getMessage());
			}
		}
	}
	//getting task details
	public static String[] getTaskDetails(String taskid) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String data[] =new String[2];
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT ptlto,ptltuid FROM `projecttask_list` where ptluid = '"+taskid+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			if(rsGCD!=null && rsGCD.next()){
				data[0]=rsGCD.getString(1);
				data[1]=rsGCD.getString(2);
			}
		} catch (Exception e) {
			log.info("Error in  getTaskDetails() LoginAction.java \n"+e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getTaskDetails() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return data;
	}
	
//getting company name of logged in user
	public String getCompany(String loginuID) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uacompany FROM `user_account` where ualoginid = '"+loginuID+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error in  getCompany() LoginAction.java \n"+e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getCompany() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}
	
	
//	public String getToken(String loginuID) {
//		Connection getacces_con = null;
//		PreparedStatement stmnt=null;
//		ResultSet rsGCD=null;
//		String alap = null;
//		try {
//			//Creating Connection
//			getacces_con = DbCon.getCon("","","");
//			String query = "SELECT uavalidtokenno FROM `user_account` where ualoginid = '"+loginuID+"'";
//			stmnt = getacces_con.prepareStatement(query);
//			rsGCD = stmnt.executeQuery();
//			while(rsGCD!=null && rsGCD.next()){
//				alap=rsGCD.getString(1);
//			}
//		} catch (Exception e) {
//		}
//		finally{
//			try{
//				if(stmnt!=null) {stmnt.close();}
//				if(rsGCD!=null) {rsGCD.close();}
//				if(getacces_con!=null) {getacces_con.close();}
//			}catch(SQLException sqle){
//				sqle.printStackTrace();
//				log.info("Error Inside finally block of getAccess() method of LoginAction Class \n"+sqle.getMessage());
//			}
//		}
//		return alap;
//	}

	public static void TrafficControl(String host, String referrer, String useragent, String userip, String sessionid) {
		PreparedStatement SLIPS = null;
		Connection SLICON = null;
		try {
			SLICON = DbCon.getCon("", "", "");
//			System.out.println("Connection is="+SLICON);
			SLIPS = SLICON.prepareStatement("insert into traffic_control (host, referrer, useragent, userip, sessionid) values (?,?,?,?,?)");
			SLIPS.setString(1,host);
			SLIPS.setString(2,referrer);
			SLIPS.setString(3,useragent);
			SLIPS.setString(4,userip);
			SLIPS.setString(5,sessionid);
			SLIPS.execute();
		} catch (Exception e) {
			log.info("Error in  TrafficControl() LoginAction.java \n" + e.getMessage());
		} finally {
			try {
				if (SLIPS != null) {
					SLIPS.close();
				}
				if (SLICON != null) {
					SLICON.close();
				}
			} catch (Exception e) {
				log.info("Error in  TrafficControl() on closing  SQL Objects \n" + e.getMessage());
			}
		}
	}

	public boolean checkLastUpdateYear() {
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		boolean isupdated = false;
		Connection con = DbCon.getCon("","","");
		try{
			VCQUERY=new StringBuffer("select imlastupdatedon from initial_master where imupdateyear='1'");
			psGCD=con.prepareStatement(VCQUERY.toString());
			rsGCD=psGCD.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int r=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++){
					newsdata[r][i]=rsGCD.getString(i+1);
				}
				r++;
			}
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			sdf.setLenient(false);
			Date d1 = sdf.parse("01-04-"+Calendar.getInstance().get(Calendar.YEAR));
			Date d2 = sdf.parse("07-04-"+Calendar.getInstance().get(Calendar.YEAR));
			for(int i=0;i<newsdata.length;i++){
				Date d3 = sdf.parse(newsdata[i][0]);
				if (d1.compareTo(d3) <= 0 && d2.compareTo(d3) >= 0) {
					isupdated = true;
				}
				else {
					isupdated = false;
					break;
				}
			}
		}catch(Exception e)
		{log.info("checkLastUpdateYear"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("checkLastUpdateYear"+e.getMessage());
			}
		}
		return isupdated;
	}

	public static String[][] getInitialDetails(String uacompany){
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		Connection con = DbCon.getCon("","","");
		try{
			VCQUERY=new StringBuffer("select imid,imcompany,imemployeekey,imgstkey,imclientkey,improjectkey,imbillingkey,imtaskkey,imenquirykey,imnongstkey,imstatus,imaddedby,imaddedon,imlastupdatedon,imtokenno from initial_master where imupdateyear='1' and imstatus='1' and imcompany='"+uacompany+"'");
			psGCD=con.prepareStatement(VCQUERY.toString());
			rsGCD=psGCD.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();

			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];

			int r=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++){
					newsdata[r][i]=rsGCD.getString(i+1);
				}
				r++;
			}
		}catch(Exception e)
		{log.info("getInitialDetails"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("getInitialDetails"+e.getMessage());
			}
		}
		return newsdata;
	}

	public static void updateInitial(String id, String value, String today) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try {
			String query = "update initial_master set imvalue=?, imlastupdatedon=? where imid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,value);
			ps.setString(2,today);
			ps.setString(3,id);
			ps.executeUpdate();
		}catch (Exception e) {
			log.info("updateInitial "+e.getLocalizedMessage());
		}
		finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("updateInitial"+e.getMessage());
			}
		}
	}

	public void updateUAwithSession(String loginuID, String sessionID,String ipAddress) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try {
			String query = "update user_account set uasessionid = ?,uaaip=? where ualoginid =?";
			ps = con.prepareStatement(query);
			ps.setString(1,sessionID);
			ps.setString(2,ipAddress);
			ps.setString(3,loginuID);
			ps.executeUpdate();
		}catch (Exception e) {
			log.info("updateUAwithSession"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("updateUAwithSession"+e.getMessage());
			}
		}
	}

	public static String getPermissions(String loginid, String sessionid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "SELECT uamprivilege FROM user_account where ualoginid ='"+loginid+"' and uasessionid ='"+sessionid+"'";
			stmnt = getacces_con.prepareStatement(query);
	
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getPermissions"+e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getPermissions() method of LoginAction Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}

	public static String[][] getLoginHistory(String token,String date,String role){
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		Connection con = DbCon.getCon("","","");
		try{
			if(!role.equalsIgnoreCase("super admin"))
			VCQUERY=new StringBuffer("select * from login_information where logtokenno ='"+token+"' and ualinfoaddedon like '"+date+"%' order by loginfoid desc");
			else
				VCQUERY=new StringBuffer("select * from login_information where  ualinfoaddedon like '"+date+"%' order by loginfoid desc");
			
			psGCD=con.prepareStatement(VCQUERY.toString());
			rsGCD=psGCD.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();

			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];

			int r=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++){
					newsdata[r][i]=rsGCD.getString(i+1);
				}
				r++;
			}
		}catch(Exception e)
		{log.info("getLoginHistory"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("getLoginHistory"+e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getTrafficHistory(String date){
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		Connection con = DbCon.getCon("","","");
		try{
			VCQUERY=new StringBuffer("select * from traffic_control where addedon like '"+date+"%' order by id desc");
			psGCD=con.prepareStatement(VCQUERY.toString());
			rsGCD=psGCD.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();

			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];

			int r=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++){
					newsdata[r][i]=rsGCD.getString(i+1);
				}
				r++;
			}
		}catch(Exception e)
		{log.info("getTrafficHistory"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("getTrafficHistory"+e.getMessage());
			}
		}
		return newsdata;
	}
}