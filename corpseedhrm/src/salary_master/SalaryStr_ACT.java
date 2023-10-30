package salary_master;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;

public class SalaryStr_ACT {

	private static Logger log = Logger.getLogger(SalaryStr_ACT.class);

	
	public static boolean addSalStr(String salemid, String salctc, String salleaves, String salgross, String salbasic,
			String salda, String salhra, String salcon, String salmed, String salspecial, String salbonus, String salta,
			String salded, String salpf, String salptax, String saltds, String salnet, String saladdedby) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into salary_structure (salemid, salctc, salleaves, salgross, salbasic, salda, salhra, salcon, salmed, salspecial, salbonus, salta, salded, salpf, salptax, saltds, salnet, saladdedby,salstatus) values("
					+ "'" + salemid + "', '" + salctc + "', '" + salleaves + "', '" + salgross + "', '" + salbasic
					+ "', '" + salda + "', '" + salhra + "', '" + salcon + "', '" + salmed + "', '" + salspecial + "','"
					+ salbonus + "', '" + salta + "', '" + salded + "', '" + salpf + "', '" + salptax + "', '" + saltds
					+ "', '" + salnet + "', '" + saladdedby + "','1');";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("addSalStr"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("addSalStr"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] allSalStr(String token, String from, String to,String empid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if(from==null || from.equalsIgnoreCase("null") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("null") || to.length() <= 0){ to ="NA";}
			if(empid==null || empid.equalsIgnoreCase("null") || empid.length() <= 0){ to ="NA";}
			StringBuffer query = new StringBuffer("SELECT salid,emname,salctc,salleaves,salnet FROM salary_structure join employee_master on salemid=emid where emtokenno='"+token+"' and salstatus='1'");
			if(!empid.equalsIgnoreCase("NA")) query.append(" and salemid = '"+empid+"'");
			if(from!="NA"&&to=="NA") query.append(" and saladdedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") query.append(" and saladdedon between '"+from+"%' and '"+to+"%'");
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
			log.info("allSalStr"+e.getMessage());
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
				log.info("allSalStr"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalaryStrById(String salid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT salid, salctc, salleaves, salgross, salbasic, salda, salhra, salcon, salmed, salspecial, salbonus, salta, salded, salpf, salptax, saltds, salnet, emuid,emname,emdept,emdesig,emid FROM salary_structure join employee_master on salemid=emid WHERE salid = '"
					+ salid + "';";
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
			log.info("getSalaryStrById"+e.getMessage());
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
				log.info("getSalaryStrById"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean deleteSalStr(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM salary_structure WHERE salid='" + uid + "'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("deleteSalStr"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("deleteSalStr"+sqle.getMessage());
			}
		}
		return status;
	}
	//promoting Employee designation of employee
		public static void promoteEmployee(String id, String post) {
			PreparedStatement ps = null;
			
			Connection con = DbCon.getCon("", "", "");
			try {
				ps=con.prepareStatement("update employee_master set emdesig='"+post+"' where emid='"+Integer.parseInt(id)+"'");
				ps.execute();
				
			} catch (Exception e) {
				log.info("promoteEmployee"+e.getMessage());
			} finally {
				try {
					if (ps != null) {
						ps.close();
					}
					if (con != null) {
						con.close();
					}
				} catch (SQLException sqle) {
					log.info("promoteEmployee"+sqle.getMessage());
				}
			}
			
		}
	
//promoting salary structure of employee
	@SuppressWarnings("resource")
	public static boolean promoteSalStr(String salid, String salemid, String salctc, String salleaves, String salgross,
			String salbasic, String salda, String salhra, String salcon, String salmed, String salspecial,
			String salbonus, String salta, String salded, String salpf, String salptax, String saltds, String salnet,
			String saladdedby) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps=con.prepareStatement("update salary_structure set salstatus='0' where salemid='"+salemid+"'");
			ps.execute();
			String query = "insert into salary_structure (salemid,salctc,salleaves,salgross,salbasic,salda,salhra,salcon,salmed,salspecial,salbonus,salta,salded,salpf,salptax,saltds,salnet,saladdedby,salstatus) values('" + salemid + "','" + salctc + "','"+ salleaves + "','" + salgross + "','" + salbasic + "','" + salda+ "','" + salhra + "','" + salcon + "','" + salmed + "','"+ salspecial + "','" + salbonus + "','" + salta + "','" + salded+ "','" + salpf + "','" + salptax + "','" + saltds + "','" + salnet+ "','" + saladdedby + "','1')";
			ps = con.prepareStatement(query);System.out.println(query);
			ps.executeUpdate();
			
			status = true;
		} catch (Exception e) {
			log.info("promoteSalStr"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("promoteSalStr"+sqle.getMessage());
			}
		}
		return status;
	}
	
	public static boolean updateSalStr(String salid, String salemid, String salctc, String salleaves, String salgross,
			String salbasic, String salda, String salhra, String salcon, String salmed, String salspecial,
			String salbonus, String salta, String salded, String salpf, String salptax, String saltds, String salnet,
			String saladdedby) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update salary_structure set salemid='" + salemid + "', salctc='" + salctc + "', salleaves='"
					+ salleaves + "', salgross='" + salgross + "', salbasic='" + salbasic + "', salda='" + salda
					+ "', salhra='" + salhra + "', salcon='" + salcon + "', salmed='" + salmed + "', salspecial='"
					+ salspecial + "', salbonus='" + salbonus + "', salta='" + salta + "', salded='" + salded
					+ "', salpf='" + salpf + "', salptax='" + salptax + "', saltds='" + saltds + "', salnet='" + salnet
					+ "', saladdedby='" + saladdedby + "' where salid = '" + salid + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("updateSalStr"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateSalStr"+sqle.getMessage());
			}
		}
		return status;
	}
	
	//adding tds
		public static void addMedical(String emid, String monthfrom, String monthto, String paidon,String medamount,String medmonth, String remarks, String token) {
			PreparedStatement ps = null;
			
			Connection con = DbCon.getCon("", "", "");
			try {
				String query = "insert into med_history (medemid, medpaidfrom,medpaidto,medpaidon,medamt,medmonth,medremarks,medtokenno) values('" + emid + "', '" + monthfrom + "', '" + monthto + "','" + paidon + "','"+ medamount + "','"+medmonth+"' , '" + remarks + "', '" + token + "');";
				ps = con.prepareStatement(query);
				ps.executeUpdate();
				
			} catch (Exception e) {
				log.info("addMedical"+e.getMessage());
			} finally {
				try {
					if (ps != null) {
						ps.close();
					}
					if (con != null) {
						con.close();
					}
				} catch (SQLException sqle) {
					log.info("addMedical"+sqle.getMessage());
				}
			}
			
		}
			
	
//adding tds
	public static void addTDS(String emid, String monthfrom, String monthto, String paidon,String tdsamount,String tdsmonth, String remarks, String token) {
		PreparedStatement ps = null;
		
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into tds_history (tdsemid, tdspaidfrom, tdspaidto, tdspaidon, tdsamt, tdsmonth, tdsremarks, tdstokenno) values('" + emid + "', '" + monthfrom + "', '" + monthto + "','" + paidon + "','"+ tdsamount + "','"+tdsmonth+"' , '" + remarks + "', '" + token + "');";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			
		} catch (Exception e) {
			log.info("addTDS"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("addTDS"+sqle.getMessage());
			}
		}
		
	}
	
	
	public static boolean addSalMon(String salmemid, String salmmonth, String salmdays, String salmleavesallowed,
			String salmleavestaken,String salmwday, String salmgross, String salmbasic, String salmda, String salmhra, String salmcon,
			String salmmed, String salmspecial, String salmbonus, String salmta, String salmded, String salmpf,
			String salmptax, String salmtds, String salmnet, String salmaddedby, String salmod,String salremark) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into salary_monthly (salmemid, salmmonth, salmdays, salmleavesallowed, salmleavestaken, salmwday, salmgross, salmbasic, salmda, salmhra, salmcon, salmmed, salmspecial, salmbonus, salmta, salmded, salmpf, salmptax, salmtds, salmnet, salmaddedby, salmod,salmremark) values("
					+ "'" + salmemid + "', '" + salmmonth + "', '" + salmdays + "','" + salmleavesallowed + "','"
					+ salmleavestaken + "','"+salmwday+"' , '" + salmgross + "', '" + salmbasic + "', '" + salmda + "', '" + salmhra
					+ "', '" + salmcon + "', '" + salmmed + "', '" + salmspecial + "','" + salmbonus + "', '" + salmta
					+ "', '" + salmded + "', '" + salmpf + "', '" + salmptax + "', '" + salmtds + "', '" + salmnet
					+ "', '" + salmaddedby + "','"+salmod+"','"+salremark+"');";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("addSalMon"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("addSalMon"+sqle.getMessage());
			}
		}
		return status;
	}

}
