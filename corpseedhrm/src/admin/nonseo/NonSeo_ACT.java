package admin.nonseo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;

public class NonSeo_ACT {

	
	private static Logger log = Logger.getLogger(NonSeo_ACT.class);

	// add a new non seo task
	public static boolean nonSeoTaskAdd(String dartuid, String darremarks, String darstatus, String daraddedby) {
		
		boolean status = false;
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");

		try {
			String query = "insert into darmaster (dartuid,darremarks,darstatus,daraddedby) values (?,?,?,?);";
			ps = con.prepareStatement(query);
			ps.setString(1,dartuid );
			ps.setString(2,darremarks );
			ps.setString(3,darstatus );
			ps.setString(4,daraddedby );
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("nonSeoTaskAdd "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("nonSeoTaskAdd "+sqle.getMessage());
			}
		}
		return status;
	}

	// get all non seo tasks
	public static String[][] getAllNonSeoTask(String loginid, String userroll, String pregpname, String limit, String token, String from, String to) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (pregpname == null || pregpname.equalsIgnoreCase("null") || pregpname.length() <= 0) { pregpname = "NA";	}
			if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			if (userroll.equals("Administrator")) {
				VCQUERY = new StringBuffer("select daruid, darstatus, ptlname,ptladate,ptlddate,DATE(ptladdedon) from darmaster join projecttask_list on dartuid=ptluid join hrmproject_reg on ptlpuid=preguid where pregtokenno='"+token+"'");
			}
			else{
				VCQUERY = new StringBuffer("select daruid, darstatus, ptlname,ptladate,ptlddate,DATE(ptladdedon) from darmaster join projecttask_list on dartuid=ptluid join hrmproject_reg on ptlpuid=preguid where ptlto = '"+loginid+"' and pregtokenno='"+token+"'");
			}
			if (pregpname != "NA") {
				VCQUERY.append(" and  pregpname = '" + pregpname + "'");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and daraddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and daraddedon between '"+from+"%' and '"+to+"%'");
			VCQUERY.append(" order by daruid desc limit "+limit);
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
			log.info("getAllNonSeoTask"+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD != null){rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("getAllNonSeoTask"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	// delete non seo task
	public static boolean nonSeoTaskDelete(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM darmaster WHERE daruid='" + uid + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("nonseotaskdelete"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("nonseotaskdelete"+sqle.getMessage());
			}
		}
		return status;
	}

	// get non seo task details by id
	public static String[][] getNonSeoTaskById(String uid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			String query = "SELECT ptlname,darremarks,darstatus,dartuid FROM darmaster join projecttask_list on dartuid=ptluid where daruid ='"
					+ uid + "' ";
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
			log.info("getNonSeoTaskById"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD != null){rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("getNonSeoTaskById"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean nonSeoTaskUpdate(String uid, String dartuid, String darremarks, String darstatus) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "UPDATE darmaster SET dartuid=?,darremarks=?,darstatus=? WHERE daruid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,dartuid );
			ps.setString(2,darremarks );
			ps.setString(3,darstatus );
			ps.setString(4,uid );
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("nonSeoTaskUpdate"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("nonSeoTaskUpdate"+sqle.getMessage());
			}
		}
		return status;
	}
}
