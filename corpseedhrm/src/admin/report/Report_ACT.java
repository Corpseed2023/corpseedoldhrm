package admin.report;

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

public class Report_ACT {

	private static Logger log = Logger.getLogger(Report_ACT.class);

	public static String[][] getKeywords(String pid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			String query = "select distinct amonpage_seo.amopskeyw,amonpsturl,amopsuid from amonpage_seo join projecttask_list on amonpage_seo.amonpstuid = projecttask_list.ptluid join hrmproject_reg on projecttask_list.ptlpuid = hrmproject_reg.preguid where hrmproject_reg.preguid = '" + pid + "' group by amonpage_seo.amopskeyw order by amonpage_seo.amopskeyw";
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
			log.info("getKeywords"+e.getMessage());
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
				log.info("getKeywords"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static void updateKeyword(String pid, String date, String google, String yahoo, String bing, String key, String target, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");

		try {
			String query = "insert into report_keywords (rkpuid,rkdate,rkgoogle,rkyahoo,rkbing,rkkey,rktarget, rkaddedby) values (?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1,pid );
			ps.setString(2,date );
			ps.setString(3,google );
			ps.setString(4,yahoo );
			ps.setString(5,bing );
			ps.setString(6,key );
			ps.setString(7,target );
			ps.setString(8,addedby );
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("updateKeyword"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateKeyword"+sqle.getMessage());
			}
		}
	}

	public static String[][] getAllReport(String pid, String datefrom, String limit) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if(datefrom==null || datefrom.length() <= 0){ datefrom ="NA";}
			if(limit==null || limit.length() <= 0){ limit ="NA";}
			VCQUERY=new StringBuffer("SELECT rkkey, rkgoogle, rkyahoo, rkbing,rktarget,rkuid from report_keywords WHERE rkpuid = '"+pid+"'");
			if(datefrom!="NA")
			{
				VCQUERY.append(" and rkdate = '"+datefrom+"' ");
			}
			if(limit!="NA")
			{
				VCQUERY.append(" limit "+limit);
			}
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
			log.info("getAllReport"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
			} catch (SQLException sqle) {
				log.info("getAllReport"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] moreReportData(String keyword) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String thirtydays = DateUtil.get30Date();
			String query = "SELECT amonpstatype,amopssourl,amopsseng,amonpsaddedby,amopsaddedon FROM amonpage_seo where amopskeyw = '"+keyword+"' and amopsaddedon>'"+thirtydays+"' order by amopsaddedon desc";
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
			log.info("moreReportData"+e.getMessage());
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
				log.info("moreReportData"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllClientReport(String pid, String l1, String l2, String l3) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			//VCQUERY=new StringBuffer("SELECT rkkey, rktarget, rkdate from report_keywords WHERE rkpuid = '"+pid+"' and (rkdate='"+l1+"' or rkdate='"+l2+"' or rkdate='"+l3+"') group by rkkey order by STR_TO_DATE(rkdate,'%d-%m-%Y') desc");
			VCQUERY=new StringBuffer("SELECT rkkey, rktarget, rkdate, rkuid from report_keywords WHERE rkuid in (select max(rkuid) from report_keywords group by rkkey) and rkpuid = '"+pid+"' group by rkkey order by rkkey");
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
			log.info("getAllClientReport"+e.getMessage());
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
				log.info("getAllClientReport"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllClientActivityReport(String pid, String datefrom, String dateto) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if(datefrom==null||datefrom=="") datefrom = "00-00-0000";
			if(dateto==null||dateto=="") dateto = "00-00-0000";
			SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
			Date convertedDate = dateFormat.parse(datefrom);
			Calendar c = Calendar.getInstance();
			c.setTime(convertedDate);
			Date convertedDate1 = dateFormat.parse(dateto);
			Calendar c1 = Calendar.getInstance();
			c1.setTime(convertedDate1);
			DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			VCQUERY=new StringBuffer("select amonpstatype, count(amonpstatype) from amonpage_seo WHERE amonpspuid = '"+pid+"' and amopsaddedon between '"+sdf.format(c1.getTime())+"' and '"+sdf.format(c.getTime())+"' group by amonpstatype");
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
			log.info("getAllClientActivityReport "+e.getMessage());
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
				log.info("getAllClientActivityReport"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getPrevDates(String pid, String datefrom) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			VCQUERY=new StringBuffer("SELECT distinct rkdate from report_keywords WHERE rkpuid = '"+pid+"' and STR_TO_DATE(rkdate,'%d-%m-%Y') < STR_TO_DATE('"+datefrom+"','%d-%m-%Y') order by STR_TO_DATE(rkdate,'%d-%m-%Y') desc limit 2");
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
			log.info("getPrevDates"+e.getMessage());
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
				log.info("getPrevDates"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static void updatePriority(String pid, String key, String target, String priority, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs=null;
		String query =null;
		String oldpriority=null;
		int status = 0;
		try {
			query="select kppriority from keyword_priority where kpkey='"+key+"' and kppuid='"+pid+"'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if(rs.next()) {
				oldpriority = rs.getString(1);
				status = 1;
			}
			ps.close();
			if(status == 0) query = "insert into keyword_priority (kppuid, kpkey,kptarget, kppriority, kpaddedby) values ('" + pid+ "','"+key+"','"+target+"','"+priority+"','"+addedby+"');";
			else query="update keyword_priority set kppriority='"+priority+"', kpaddedby='"+addedby+"' where kppuid='"+pid+"' and kpkey='"+key+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("updatePriority"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rs!=null) rs.close();
			} catch (SQLException sqle) {
				log.info("updatePriority"+sqle.getMessage());
			}
		}
	}

	public static String getPriority(String pid, String keyword) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT kppriority FROM keyword_priority WHERE kpkey = '"+keyword+"' and kppuid='"+pid+"'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("getPriority"+e.getMessage());
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
				log.info("getPriority"+e.getMessage());
			}
		}
		return getinfo;
	}

	public static void deleteActivity(String uid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM amonpage_seo WHERE amopsuid ='" + uid + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("deleteActivity"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("deleteActivity"+sqle.getMessage());
			}
		}
	}
	public static String[][] getl1(String pid, String keyword, String l1) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			VCQUERY=new StringBuffer("SELECT rkgoogle from report_keywords WHERE rkpuid = '"+pid+"' and rkkey='"+keyword+"' and rkdate = '"+l1+"' order by rkaddedon desc limit 1");
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
			log.info("getl1"+e.getMessage());
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
				log.info("getl1"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] getl2(String pid, String keyword, String l2) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			VCQUERY=new StringBuffer("SELECT rkgoogle from report_keywords WHERE rkpuid = '"+pid+"' and rkkey='"+keyword+"' and rkdate = '"+l2+"' order by rkaddedon desc limit 1");
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
			log.info("getl2"+e.getMessage());
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
				log.info("getl2"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] getl3(String pid, String keyword, String l3) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			VCQUERY=new StringBuffer("SELECT rkgoogle from report_keywords WHERE rkpuid = '"+pid+"' and rkkey='"+keyword+"' and rkdate = '"+l3+"' order by rkaddedon desc limit 1");
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
			log.info("getl3"+e.getMessage());
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
				log.info("getl3"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getActivityData(String pid, String date, String date2, String key) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
			Date convertedDate = dateFormat.parse(date);
			Date convertedDate2 = dateFormat.parse(date2);

			Calendar c = Calendar.getInstance();
			c.setTime(convertedDate);

			Calendar c1 = Calendar.getInstance();
			c1.setTime(convertedDate2);

			DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			VCQUERY=new StringBuffer("select amopsuid, amopskeyw, amonpsturl, amopssourl, amonpststatus from amonpage_seo where amonpspuid='"+pid+"' and amonpstatype='"+key+"' and amopsaddedon between '"+sdf.format(c1.getTime())+"' and '"+sdf.format(c.getTime())+"'");
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
			log.info("getActivityData"+e.getMessage());
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
				log.info("getActivityData"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static void updateReport(String type, String newvalue, String id) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update report_keywords set "+type+"=? where rkuid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,newvalue );
			ps.setString(2,id );
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("updateReport"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateReport"+sqle.getMessage());
			}
		}
	}
}