package payment_master;

import invoice_master.GST_ACT;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;

public class GeneratePaymentACT {
	private static Logger log = Logger.getLogger(GST_ACT.class);
	
	public static String[][] getInvoiceDetails(String uid) {
		ResultSet rsGCD = null;
		PreparedStatement psGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			VCQUERY = new StringBuffer("SELECT giinvno, gicuid, gipuid, giinvamt FROM generate_invoice WHERE giuid= '"+uid+"'");
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
			log.info("getInvoiceDetails"+e.getMessage());
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
				log.info("getInvoiceDetails"+e.getMessage());
			}
		}
		return newsdata;
	}

}
