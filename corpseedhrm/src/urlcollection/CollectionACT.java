package urlcollection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DateUtil;
import commons.DbCon;

public class CollectionACT {

	private static Logger log = Logger.getLogger(CollectionACT.class);

	public static String[][] getAllCollection(String submiturl, String activity, String nature, String from, String to) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if(submiturl==null || submiturl.equalsIgnoreCase("null") || submiturl.length() <= 0){ submiturl ="NA";}
			if(activity==null || activity.equalsIgnoreCase("null") || activity.length() <= 0){ activity ="NA";}
			if(nature==null || nature.equalsIgnoreCase("null") || nature.length() <= 0){ nature ="NA";}
			if(from==null || from.equalsIgnoreCase("null") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("null") || to.length() <= 0){ to ="NA";}
			VCQUERY = new StringBuffer("SELECT * FROM seourlcollection where sucstatus='1'");
			if(submiturl!="NA") VCQUERY.append(" and sucsubmiturl like '%"+submiturl+"%'");
			if(activity!="NA") VCQUERY.append(" and sucactivity = '"+activity+"'");
			if(nature!="NA") VCQUERY.append(" and sucnature = '"+nature+"'");
			if(from!="NA"&&to=="NA") VCQUERY.append(" and sucaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and sucaddedon between '"+from+"%' and '"+to+"%'");
			VCQUERY.append(" order by suclastupdateon limit 50");
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
			log.info("CollectionACT.getAllCollection "+e.getMessage());
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
				log.info("CollectionACT.getAllCollection "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static void updateURLData(String id, String submiturl, String activity, String nature, String status, String alexa, String da, String ipclass) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update seourlcollection set sucsubmiturl='"+submiturl+"', sucactivity='"+activity+"', sucnature='"+nature+"', sucurlstatus='"+status+"', sucalexa='"+alexa+"', sucdomainauth='"+da+"',sucipclass='"+ipclass+"' where sucid='"+id+"' ";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("CollectionACT.updateURLData "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("CollectionACT.updateURLData "+sqle.getMessage());
			}
		}
	}

	public static String getURL(int pk) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT sucsubmiturl from seourlcollection where sucid = '"+pk+"'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("CollectionACT.getURL " + e.getMessage());
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
				log.info("CollectionACT.getURL " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static void updateURLStatus(int pk, String status) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update seourlcollection set sucurlstatus='"+status+"', suclastcheckon='"+DateUtil.getCurrentDateTime()+"' where sucid='"+pk+"' ";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("CollectionACT.updateURLStatus "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("CollectionACT.updateURLStatus "+sqle.getMessage());
			}
		}
	}

	@SuppressWarnings("resource")
	public static String insertNewSEOURL(String newsubmiturl, String newactivity, String newnature, String newstatus,
			String newlastcheckedon, String newalexa, String newda, String newipclass, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String insertresult = "";
		int i=0;
		try {
			String sql = "select sucid from seourlcollection where sucsubmiturl = '"+newsubmiturl+"'";
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()) {
				i = rs.getInt(1);
				insertresult = "This SubmitURL already exists!";
			}
			if(i==0) {
				String query = "insert into seourlcollection (sucsubmiturl,sucactivity,sucnature,sucalexa,sucdomainauth,sucipclass,sucurlstatus,sucaddedby,suclastcheckon) values ('"+newsubmiturl+"','"+newactivity+"','"+newnature+"','"+newalexa+"','"+newda+"','"+newipclass+"','"+newstatus+"','"+addedby+"','"+newlastcheckedon+"')";
				ps = con.prepareStatement(query);
				ps.executeUpdate();
				insertresult="success";
			}
		} catch (Exception e) {
			log.info("CollectionACT.updateURLStatus "+e.getMessage());
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
				log.info("CollectionACT.updateURLStatus "+sqle.getMessage());
			}
		}
		return insertresult;
	}

}
