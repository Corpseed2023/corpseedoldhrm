package Company_Login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;

public class CompanyLogin_ACT {

	private static Logger log = Logger.getLogger(CompanyLogin_ACT.class);

	public static String[][] getCompanyDetailsByLoginName(String uaname) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT creguid, cregucid, cregmob, cregname, cregemailid, cregaddress, creglocation, cregcontname, cregcontemailid,cregcontmobile , cregcontrole,cregpan,creggstin,cregstatecode FROM hrmclient_reg where cregname='"
					+ uaname + "' ";
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
			log.info("getCompanyDetailsByLoginName"+e.getMessage());
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
				log.info("getCompanyDetailsByLoginName"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getBillingsByCompany(String cbcuid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT giuid,giinvamt,gibmonth,gibdate,pregpname,cregname,girdate,cbstatus, gipaystatus, gitotal, giremark FROM generate_invoice join hrmproject_reg on gipuid = preguid join hrmclient_reg on gicuid = creguid join hrmclient_billing on gipuid=cbpuid where cbcuid='"+cbcuid+"' order by giaddedon desc";
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
			log.info("getBillingsByCompany"+e.getMessage());
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
				log.info("getBillingsByCompany"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String getprojectname(String pid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT pregpname FROM hrmproject_reg WHERE preguid = '"+pid+"'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("getprojectname"+e.getMessage());
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
				log.info("getprojectname"+e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[][] getProjectFollowUpById(String projectid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select fu.pfuid, fu.pfupid, fu.pfustatus, fu.pfudate, fu.deliverydate, fu.pfuremark from hrmproject_followup fu where showclient='1' and fu.pfupid = '"+projectid+"' order by fu.pfuaddedon desc";
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
			log.info("getProjectFollowUpById"+e.getMessage());
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
				log.info("getProjectFollowUpById"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getLastSeoReport(String clientid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select p.pregpname, r.rkdate from hrmproject_reg p join report_keywords r on p.preguid = r.rkpuid join hrmclient_reg c on p.pregcuid=c.creguid where c.creguid='"+clientid+"' and p.pregtype='SEO' and r.rkuid in (select max(k.rkuid) from report_keywords k group by k.rkpuid) group by p.pregpname order by str_to_date(r.rkdate,'%d-%m-%Y') desc";
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
			log.info("getLastSeoReport"+e.getMessage());
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
				log.info("getLastSeoReport"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String getDocumentNameForProjectFollowUp(String pfuid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "";
		try {
			String queryselect = "SELECT dmfileurl FROM document_master WHERE dmfileid = '"+pfuid+"' and dmtype='projectfollowup' and dmstatus='1'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("getprojectname"+e.getMessage());
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
				log.info("getprojectname"+e.getMessage());
			}
		}
		return getinfo;
	}
}