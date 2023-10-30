package workscheduler;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;

public class WorkSchedulerACT {

	private static Logger log = Logger.getLogger(WorkSchedulerACT.class);

	public static String[][] getAllWorks(String addedby) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select * from workscheduler where wdaddedby='"+addedby+"'";
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
			log.info("getAllWorks"+e.getMessage());
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
				log.info("getAllWorks"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getFollowUpById(String workid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select * from workschedulerfollowup where wsfuwid='"+workid+"' order by wsfuuid desc";
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
			log.info("getFollowUpById"+e.getMessage());
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
				log.info("getFollowUpById"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean saveWorkSchedule(String today, String schedulefor, String type, String taskname,
			String remarks, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "insert into workscheduler (wddate, wddatefor, wdtype, wdtask, wdremark, wdaddedby) values ('"+today+"','"+schedulefor+"','"+type+"','"+taskname+"','"+remarks+"','"+addedby+"')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("saveWorkSchedule"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveWorkSchedule"+sqle.getMessage());
			}
		}
		return status;
	}

	public static void saveWorkScheduleFollowUp(String wsuid, String fstatus, String remarks, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into workschedulerfollowup (wsfuwid, wsfustatus, wsfuremarks, wsfuaddedby) values ('"+wsuid+"','"+fstatus+"','"+remarks+"','"+addedby+"')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("saveWorkScheduleFollowUp"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveWorkScheduleFollowUp"+sqle.getMessage());
			}
		}
	}
	public static String[][] getholidayscalendarlst() {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select * from holidayscalendar where 1";
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
			log.info("getholidayscalendar"+e.getMessage());
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
				log.info("getholidayscalendar"+sqle.getMessage());
			}
		}
		return newsdata;
	}
}
