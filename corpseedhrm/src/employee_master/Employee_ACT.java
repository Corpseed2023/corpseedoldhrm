package employee_master;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;

public class Employee_ACT {

	private static Logger log = Logger.getLogger(Employee_ACT.class);

	public static void openAccount(String emuid, String emname, String emaddedby,String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into employee_accounts (empaceunqid,empacdescription,empacstatus,empacaddedby,empactokenno) values ((select emid from employee_master where emuid='"+emuid+"'),'Account of "+emname+" created.','1','"+emaddedby+"','"+token+"')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("openAccount"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("openAccount"+sqle.getMessage());
			}
		}
	}
	public static String[][] getAllAccounts(String clientId,String token, String dateRange,long limit,long pageStart) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con = DbCon.getCon("", "", "");
			if(pageStart==1)pageStart=0;
			StringBuffer query = new StringBuffer("select emid,emname,emmobile, ememail from employee_master join employee_accounts on employee_master.emid=employee_accounts.empaceunqid where empacstatus=1 and empactokenno='"+token+"'");
			if(!clientId.equalsIgnoreCase("NA")) query.append(" and empaceunqid  = '"+clientId+"'");
			if(!dateRange.equalsIgnoreCase("NA")) query.append(" and SUBSTRING(empacaddedon,1,10) between '"+fromDate+"' and '"+toDate+"'");
			query.append(" order by emname limit "+pageStart+","+limit);
			stmnt = getacces_con.prepareStatement(query.toString());
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
			log.info("getAllAccounts"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("getAllAccounts"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	/* For providing uniqueid to employee */
	public static String getuniquecode(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT emuid FROM employee_master where emtokenno='"+token+"' order by emid desc limit 1";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getuniquecode"+e.getMessage());
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
				log.info("getuniquecode"+e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean saveEmployee(String emuid, String emprefix, String emname, String emdept, String emdesig,
			String emmobile, String ememail, String emgender, String emaltmobile, String emaltemail,
			String emdateofbirth, String emmarriage, String ememname, String ememmobile, String emememail,
			String ememrelation, String emperaddress, String empreaddress, String empan, String emaadhar,
			String embankname, String embankaccname, String embankaccno, String embankifsc, String embankaddress, String emaddedby,String token,String dateofjoining) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "INSERT INTO employee_master (emuid, emprefix, emname, emdept, emdesig, emmobile, ememail, emgender, emaltmobile, emaltemail, emdateofbirth, emmarriage, ememname, ememmobile, emememail, ememrelation, emperaddress, empreaddress, empan, emaadhar, embankname, embankaccname, embankaccno, embankifsc, embankaddress, emaddedby,emstatus,emtokenno,	emdateofjoining) VALUES ('"
					+ emuid + "', '" + emprefix + "', '" + emname + "', '" + emdept + "', '" + emdesig + "', '"
					+ emmobile + "', '" + ememail + "', '" + emgender + "', '" + emaltmobile + "', '" + emaltemail
					+ "', '" + emdateofbirth + "', '" + emmarriage + "', '" + ememname + "', '" + ememmobile + "', '"
					+ emememail + "', '" + ememrelation + "', '" + emperaddress + "', '" + empreaddress + "', '" + empan
					+ "', '" + emaadhar + "', '" + embankname + "', '"+embankaccname+"' , '" + embankaccno + "', '" + embankifsc + "', '"
					+ embankaddress + "', '" + emaddedby + "','1','"+token+"','"+dateofjoining+"');";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("saveEmployee"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveEmployee"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getEmployeeById(String emid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT emuid, emprefix, emname, emdept, emdesig, emmobile, ememail, emgender, emaltmobile, emaltemail, emdateofbirth, emmarriage, ememname, ememmobile, emememail, ememrelation, emperaddress, empreaddress, empan, emaadhar, embankname, embankaccno, embankifsc, embankaddress, emid,embankaccname,emdateofjoining FROM employee_master WHERE emid = '"
					+ emid + "'";
			stmnt = getacces_con.prepareStatement(query);
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
			log.info("getEmployeeById"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("getEmployeeById"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllEmployee(String token,String name, String mobile, 
			String email,String role) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if(name==null || name.equalsIgnoreCase("null") || name.length() <= 0){ name ="NA";}
			if(mobile==null || mobile.equalsIgnoreCase("null") || mobile.length() <= 0){ mobile ="NA";}
			if(email==null || email.equalsIgnoreCase("null") || email.length() <= 0){ email ="NA";}			
			StringBuffer query = new StringBuffer("SELECT count(emid) FROM employee_master where emtokenno!='NA'");
			if(!role.equalsIgnoreCase("super admin"))
			query.append(" and emtokenno='"+token+"'");
				
			if(name!="NA") query.append(" and emname like '"+name+"'");
			if(mobile!="NA") query.append(" and emmobile = '"+mobile+"'");
			if(email!="NA") query.append(" and ememail = '"+email+"'");
//			if(from!="NA"&&to=="NA") query.append(" and emaddedon like '"+from+"%'");
//			if(from!="NA"&&to!="NA") query.append(" and emaddedon between '"+from+"%' and '"+to+"%'");
			
			
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countAllEmployee"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("countAllEmployee"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllEmployee(String token,String name, String mobile, 
			String email,String role,int page,int rows,
			String sort,String order) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if(name==null || name.equalsIgnoreCase("null") || name.length() <= 0){ name ="NA";}
			if(mobile==null || mobile.equalsIgnoreCase("null") || mobile.length() <= 0){ mobile ="NA";}
			if(email==null || email.equalsIgnoreCase("null") || email.length() <= 0){ email ="NA";}			
			StringBuffer query = new StringBuffer("SELECT emid, emname, emdesig, emmobile, ememail, emdateofbirth,emperaddress,emdateofjoining,emdept,emuid,emtokenno,emstatus FROM employee_master where emtokenno!='NA'");
			if(!role.equalsIgnoreCase("super admin"))
			query.append(" and emtokenno='"+token+"'");
				
			if(name!="NA") query.append(" and emname like '"+name+"'");
			if(mobile!="NA") query.append(" and emmobile = '"+mobile+"'");
			if(email!="NA") query.append(" and ememail = '"+email+"'");
//			if(from!="NA"&&to=="NA") query.append(" and emaddedon like '"+from+"%'");
//			if(from!="NA"&&to!="NA") query.append(" and emaddedon between '"+from+"%' and '"+to+"%'");
			
			if(sort.length()<=0)			
				query.append(" order by emid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("id"))query.append("order by emid "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("empid"))query.append("order by emuid "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("dept"))query.append("order by emdept "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("name"))query.append("order by emname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("joining"))query.append("order by emdateofjoining "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("address"))query.append("order by emperaddress "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("phone"))query.append("order by emmobile "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("email"))query.append("order by ememail "+order+" limit "+((page-1)*rows)+","+rows);
				else query.append(" order by emid desc");
			
			stmnt = getacces_con.prepareStatement(query.toString());
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
			log.info("getAllEmployee"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("getAllEmployee"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean UpdateEmployee(String emid, String DateOfJoining, String emprefix, String emname, String emdept,
			String emdesig, String emmobile, String ememail, String emgender, String emaltmobile, String emaltemail,
			String emdateofbirth, String emmarriage, String ememname, String ememmobile, String emememail,
			String ememrelation, String emperaddress, String empreaddress, String empan, String emaadhar,
			String embankname, String embankaccno, String embankifsc, String embankaddress, String emaddedby, String embankaccname) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update employee_master set emdateofjoining='" + DateOfJoining + "', emprefix='" + emprefix + "', emname='"
					+ emname + "', emdept='" + emdept + "', emdesig='" + emdesig + "', emmobile='" + emmobile
					+ "', ememail='" + ememail + "', emgender='" + emgender + "', emaltmobile='" + emaltmobile
					+ "', emaltemail='" + emaltemail + "', emdateofbirth='" + emdateofbirth + "', emmarriage='"
					+ emmarriage + "', ememname='" + ememname + "', ememmobile='" + ememmobile + "', emememail='"
					+ emememail + "', ememrelation='" + ememrelation + "', emperaddress='" + emperaddress
					+ "', empreaddress='" + empreaddress + "', empan='" + empan + "', emaadhar='" + emaadhar
					+ "', embankname='" + embankname + "', embankaccno='" + embankaccno + "', embankifsc='" + embankifsc
					+ "', embankaddress='" + embankaddress + "', emaddedby='" + emaddedby + "',embankaccname='"+embankaccname+"' where emid = '" + emid
					+ "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("UpdateEmployee"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("UpdateEmployee"+sqle.getMessage());
			}
		}
		return status;
	}

	public static void deleteEmployee(String uid,String status) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update employee_master set emstatus='"+status+"' WHERE emid='" + uid + "'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
			
		} catch (Exception e) {
			log.info("deleteEmployee"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("deleteEmployee"+sqle.getMessage());
			}
		}
		
	}
	//checking employee exists in user account or not
	public static boolean isExistEmployee(String emuid,String token) {
		PreparedStatement ps = null;
		ResultSet rs=null;
		boolean flag=false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "select uaid from user_account WHERE uaempid='" + emuid + "' and uavalidtokenno='"+token+"'";

			ps = con.prepareStatement(query);
			rs=ps.executeQuery();
			if(rs.next())flag=true;
			
		} catch (Exception e) {
			log.info("isExistEmployee"+e.getMessage());
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
				log.info("isExistEmployee"+sqle.getMessage());
			}
		}
	return flag;	
	}
	//updating user_account's record
		public static boolean updateUserAccount(String emuid,String token,String status) {
			PreparedStatement ps = null;
			boolean flag=false;
			Connection con = DbCon.getCon("", "", "");
			try {
				String query = "update user_account set uastatus='"+status+"' WHERE uaempid='" + emuid + "' and uavalidtokenno='"+token+"'";

				ps = con.prepareStatement(query);
				ps.execute();
				
			} catch (Exception e) {
				log.info("updateUserAccount"+e.getMessage());
			} finally {
				try {
					if (ps != null) {
						ps.close();
					}
					if (con != null) {
						con.close();
					}
					
				} catch (SQLException sqle) {
					log.info("updateUserAccount"+sqle.getMessage());
				}
			}
		return flag;	
		}	
}
