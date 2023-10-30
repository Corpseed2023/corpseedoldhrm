package invoice_master;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;

public class GST_ACT {

	private static Logger log = Logger.getLogger(GST_ACT.class);

	
	public static String[][] getGSTData(String ghmonth, String ghcategory, String token, String from, String to) {
		ResultSet rsGCD = null;
		PreparedStatement psGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			if (ghmonth == null || ghmonth.equalsIgnoreCase("Any") || ghmonth.length() <= 0) {
				ghmonth = "NA";
			}
			if (ghcategory == null || ghcategory.equalsIgnoreCase("Any") || ghcategory.length() <= 0) {
				ghcategory = "NA";
			}
			if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			VCQUERY = new StringBuffer("SELECT * from gst_history where ghtokenno='"+token+"'");
			if (ghmonth != "NA") {
				VCQUERY.append(" and ghmonth = '" + ghmonth + "'");
			}
			if (ghcategory != "NA") {
				VCQUERY.append(" and ghcategory = '" + ghcategory + "'");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and ghaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and ghaddedon between '"+from+"%' and '"+to+"%'");
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
			log.info("getGSTData"+e.getMessage());
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
				log.info("getGSTData"+e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean saveGstData(String gibmonth, String gicategory, String gigst, String gigstamt, String gicuid, String gipuid, String billingamount, String giinvamt, String giinvno, String uacompany) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into gst_history (ghmonth,ghcategory,ghtax,ghvalue,ghpaidon, ghcuid, ghpuid, ghbillamt, ghinvamt, ghinvno, ghcompany) values ('" + gibmonth + "','"
					+ gicategory + "','" + gigst + "','" + gigstamt + "','Not Paid','"+gicuid+"','"+gipuid+"','"+billingamount+"','"+giinvamt+"','"+giinvno+"','"+uacompany+"')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("saveGstData"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveGstData"+sqle.getMessage());
			}
		}
		return status;
	}

	public static void updateGstData(String ghid, String ghpaidon, String ghremarks) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "UPDATE gst_history SET ghpaidon='" + ghpaidon + "', ghremarks='"+ghremarks+"' WHERE ghid='" + ghid + "'";
			ps = con.prepareStatement(query);

			ps.executeUpdate();
		} catch (Exception e) {
			log.info("updateGstData"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateGstData"+sqle.getMessage());
			}
		}
	}

}
