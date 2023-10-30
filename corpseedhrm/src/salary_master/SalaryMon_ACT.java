package salary_master;

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

import commons.DbCon;

public class SalaryMon_ACT {

	private static Logger log = Logger.getLogger(SalaryMon_ACT.class);

	public static String[][] getAllEmployee(String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			VCQUERY = new StringBuffer("SELECT emname from employee_master where emtokenno='"+token+"'");
			String query = VCQUERY.toString();
			// System.out.println(query);
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
					// System.out.println("fff"+newsdata[rr][i]);
				}
				// System.out.println(count);
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

	public static String[][] getSalaryData(String userid, String date, String limit, String token, String from, String to) {
		ResultSet rsGCD = null;
		PreparedStatement psGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			if (userid == null || userid.equalsIgnoreCase("null") || userid.length() <= 0) {
				userid = "NA";
			}
			if (date == null || date.equalsIgnoreCase("null") || date.length() <= 0) {
				date = "NA";
			}
			if(from==null || from.equalsIgnoreCase("null") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("null") || to.length() <= 0){ to ="NA";}
			VCQUERY = new StringBuffer(
					"SELECT salmid, emname,salmgross,salmded,salmnet,salmmonth,salmdays,salmwday,salmleavesallowed,salmleavestaken,salmremark, salmpaiddate from salary_monthly join employee_master on salmemid=emid where emtokenno='"+token+"'");
			if (userid != "NA") {
				VCQUERY.append(" and emname = '" + userid + "'");
			}
			if (date != "NA") {
				VCQUERY.append(" and salmmonth = '" + date + "' ");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and salmaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and salmaddedon between '"+from+"%' and '"+to+"%'");
			VCQUERY.append(" order by str_to_date(salmmonth,'%m-%Y') desc limit "+limit);
			psGCD = con.prepareStatement(VCQUERY.toString());
			rsGCD = psGCD.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int r = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[r][i] = rsGCD.getString(i + 1);
				}
				r++;
			}
		} catch (Exception e) {
			log.info("getSalaryData "+e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (psGCD != null) {
					psGCD.close();
				}
				if (rsGCD != null) {
					rsGCD.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getSalaryData"+e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean deleteSalMon(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM salary_monthly WHERE salmid='" + uid + "'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("deleteSalMon"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("deleteSalMon"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getSalaryMonById(String salmid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			VCQUERY = new StringBuffer("SELECT salmid, salmemid, salmmonth, salmdays, salmleavesallowed, salmleavestaken, salmgross, salmbasic, salmda, salmhra, salmcon, salmmed, salmspecial, salmbonus, salmta, salmded, salmpf, salmptax, salmtds, salmnet, emname,emuid,emdept,emdesig,emid,salmwday,salmod,salmremark FROM salary_monthly join employee_master on salmemid=emid where salmid = '"
							+ salmid + "'");
			String query = VCQUERY.toString();
			// System.out.println(query);
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
					// System.out.println("fff"+newsdata[rr][i]);
				}
				// System.out.println(count);
				rr++;
			}
		} catch (Exception e) {
			log.info("getSalaryMonById"+e.getMessage());
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
				log.info("getSalaryMonById"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateSalMon(String salmid, String salmemid, String salmmonth, String salmdays,
			String salmleavesallowed, String salmleavestaken, String salmgross, String salmbasic, String salmda,
			String salmhra, String salmcon, String salmmed, String salmspecial, String salmbonus, String salmta,
			String salmded, String salmpf, String salmptax, String salmtds, String salmnet, String salmaddedby, String salmwday, String salmod,String salremark) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update salary_monthly set salmemid='" + salmemid + "', salmmonth='" + salmmonth
					+ "', salmdays = '" + salmdays + "', salmleavesallowed='" + salmleavesallowed
					+ "', salmleavestaken='" + salmleavestaken + "', salmgross='" + salmgross + "', salmbasic='"
					+ salmbasic + "', salmda='" + salmda + "', salmhra='" + salmhra + "', salmcon='" + salmcon
					+ "', salmmed='" + salmmed + "', salmspecial='" + salmspecial + "', salmbonus='" + salmbonus
					+ "', salmta='" + salmta + "', salmded='" + salmded + "', salmpf='" + salmpf + "', salmptax='"
					+ salmptax + "', salmtds='" + salmtds + "', salmnet='" + salmnet + "', salmaddedby='" + salmaddedby
					+ "',salmwday='"+salmwday+"',salmod='"+salmod+"',salmremark='"+salremark+"' where salmid = '" + salmid + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("updateSalMon "+e.getLocalizedMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateSalMon"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getTdsData(String userid, String date, String token, String from, String to) {
		ResultSet rsGCD = null;
		PreparedStatement psGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			if (userid == null || userid.equalsIgnoreCase("Any") || userid.length() <= 0) {
				userid = "NA";
			}
			if (date == null || date.equalsIgnoreCase("Any") || date.length() <= 0) {
				date = "NA";
			}
			if(from==null || from.equalsIgnoreCase("null") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("null") || to.length() <= 0){ to ="NA";}
			VCQUERY = new StringBuffer(
					"SELECT tdsid, emname, tdsamt,tdspaidon,tdsmonth from tds_history join employee_master on tdsemid=emid where emtokenno='"+token+"'");
			if (userid != "NA") {
				VCQUERY.append(" and emname = '" + userid + "'");
			}
			if (date != "NA") {
				VCQUERY.append(" and tdsmonth = '" + date + "' ");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and tdsaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and tdsaddedon between '"+from+"%' and '"+to+"%'");
			psGCD = con.prepareStatement(VCQUERY.toString());
			rsGCD = psGCD.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int r = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[r][i] = rsGCD.getString(i + 1);
				}
				r++;
			}
		} catch (Exception e) {
			log.info("getTdsData"+e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (psGCD != null) {
					psGCD.close();
				}
				if (rsGCD != null) {
					rsGCD.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getTdsData"+e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getMedData(String userid, String date, String token, String from, String to) {
		ResultSet rsGCD = null;
		PreparedStatement psGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			if (userid == null || userid.equalsIgnoreCase("Any") || userid.length() <= 0) {
				userid = "NA";
			}
			if (date == null || date.equalsIgnoreCase("Any") || date.length() <= 0) {
				date = "NA";
			}
			if(from==null || from.equalsIgnoreCase("null") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("null") || to.length() <= 0){ to ="NA";}
			VCQUERY = new StringBuffer(
					"SELECT medid, emname, medamt,medpaidon,medmonth from med_history join employee_master on medemid=emid where emtokenno='"+token+"'");
			if (userid != "NA") {
				VCQUERY.append(" and emname = '" + userid + "'");
			}
			if (date != "NA") {
				VCQUERY.append(" and medmonth = '" + date + "' ");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and medaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and medaddedon between '"+from+"%' and '"+to+"%'");
			psGCD = con.prepareStatement(VCQUERY.toString());
			rsGCD = psGCD.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int r = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[r][i] = rsGCD.getString(i + 1);
				}
				r++;
			}
		} catch (Exception e) {
			log.info("getMedData"+e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (psGCD != null) {
					psGCD.close();
				}
				if (rsGCD != null) {
					rsGCD.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getMedData"+e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean addTds(String tdsemid, String tdsamt, String tdsmonth, String tdspaidfrom, String tdspaidto,
			String tdspaidon, String tdsremarks) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "INSERT INTO tds_history (tdsemid, tdspaidfrom, tdspaidto, tdspaidon, tdsamt, tdsmonth, tdsremarks) VALUES ('"+tdsemid+"', '"+tdspaidfrom+"', '"+tdspaidto+"', '"+tdspaidon+"', '"+tdsamt+"', '"+tdsmonth+"', '"+tdsremarks+"');";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("addTds"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("addTds"+sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean addMed(String medemid, String medamt, String medmonth, String medpaidfrom, String medpaidto,
			String medpaidon, String medremarks) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "INSERT INTO med_history (medemid, medpaidfrom, medpaidto, medpaidon, medamt, medmonth, medremarks) VALUES ('"+medemid+"', '"+medpaidfrom+"', '"+medpaidto+"', '"+medpaidon+"', '"+medamt+"', '"+medmonth+"', '"+medremarks+"');";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("addMed"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("addMed"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getTdsById(String uid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			VCQUERY = new StringBuffer("SELECT tdsid,tdspaidfrom, tdspaidto, tdspaidon, tdsamt, tdsmonth, tdsremarks,emname,emuid,emdept,emdesig,emid FROM tds_history join employee_master on tdsemid=emid WHERE tdsid='"+uid+"'");
			String query = VCQUERY.toString();
			// System.out.println(query);
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
					// System.out.println("fff"+newsdata[rr][i]);
				}
				// System.out.println(count);
				rr++;
			}
		} catch (Exception e) {
			log.info("getTdsById"+e.getMessage());
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
				log.info("getTdsById"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getMedById(String uid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			VCQUERY = new StringBuffer("SELECT medid,medpaidfrom, medpaidto, medpaidon, medamt, medmonth, medremarks,emname,emuid,emdept,emdesig,emid FROM med_history join employee_master on medemid=emid WHERE medid='"+uid+"'");
			String query = VCQUERY.toString();
			// System.out.println(query);
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
					// System.out.println("fff"+newsdata[rr][i]);
				}
				// System.out.println(count);
				rr++;
			}
		} catch (Exception e) {
			log.info("getMedById"+e.getMessage());
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
				log.info("getMedById"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean deleteTds(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM tds_history WHERE tdsid='" + uid + "'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("deleteTds"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("deleteTds"+sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean deleteMed(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM med_history WHERE medid='" + uid + "'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("deleteMed"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("deleteMed"+sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateTds(String tdsid, String tdsemid, String tdsamt, String tdsmonth, String tdspaidfrom,
			String tdspaidto, String tdspaidon, String tdsremarks) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update tds_history set tdsemid='"+tdsemid+"',tdsamt='"+tdsamt+"',tdsmonth='"+tdsmonth+"', tdspaidfrom='"+tdspaidfrom+"', tdspaidto='"+tdspaidto+"', tdspaidon='"+tdspaidon+"', tdsremarks='"+tdsremarks+"' WHERE tdsid='" + tdsemid + "'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("updateTds"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateTds"+sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateMed(String medid, String medemid, String medamt, String medmonth, String medpaidfrom,
			String medpaidto, String medpaidon, String medremarks) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update med_history set medemid='"+medemid+"',medamt='"+medamt+"',medmonth='"+medmonth+"', medpaidfrom='"+medpaidfrom+"', medpaidto='"+medpaidto+"', medpaidon='"+medpaidon+"', medremarks='"+medremarks+"' WHERE medid='" + medemid + "'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("updateMed"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateMed"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getLeavesTaken(String month, String empid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			DateFormat df = new SimpleDateFormat("MM-yyyy");
			Date date1 = new Date();
			date1 = df.parse(month);
			SimpleDateFormat format1 = new SimpleDateFormat("MM-yyyy");
			Calendar cal = Calendar.getInstance();
			cal.setTime(date1);
			cal.add(Calendar.MONTH, -1);
			String prevmonth = format1.format(cal.getTime());
			VCQUERY = new StringBuffer("SELECT count(amattendance) FROM attendance_master WHERE amuserid ='"+empid+"' and str_to_date(amdate,'%d-%m-%y') between str_to_date('25-"+prevmonth+"','%d-%m-%y') and str_to_date('24-"+month+"','%d-%m-%y') and amattendance = 'Absent'");
			String query = VCQUERY.toString();
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
					// System.out.println("fff"+newsdata[rr][i]);
				}
				// System.out.println(count);
				rr++;
			}
		} catch (Exception e) {
			log.info("getLeavesTaken"+e.getMessage());
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
				log.info("getLeavesTaken"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getLeavesAllowed(String month, String empid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			VCQUERY = new StringBuffer("SELECT salmleavesallowed FROM salary_monthly WHERE salmemid ='"+empid+"' and salmmonth like '%"+month+"'");
			String query = VCQUERY.toString();
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
					// System.out.println("fff"+newsdata[rr][i]);
				}
				// System.out.println(count);
				rr++;
			}
		} catch (Exception e) {
			log.info("getLeavesAllowed"+e.getMessage());
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
				log.info("getLeavesAllowed"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static void updatePaidDate(String id, String value) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update salary_monthly set salmpaiddate='"+value+"' where salmid='"+id+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("updatePaidDate"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updatePaidDate"+sqle.getMessage());
			}
		}
	}

}
