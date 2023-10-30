package admin.coupon;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;


import commons.DbCon;

public class Coupon_ACT {

	private static Logger log = Logger.getLogger(Coupon_ACT.class);
	
	
	public static String[][] getServicesByProductKey(String uuid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT * FROM coupon_service where coupon_uuid='"+uuid+"'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();
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
			log.info("getServicesByProductKey"+e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException e) {
				log.info("getServicesByProductKey"+e.getMessage());
			}
		}
		return newsdata;
	}
	public static boolean isCouponServiceExist(String prodNo,String prodUuid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo =false;
		try {
			String queryselect = "SELECT id FROM coupon_service where product_no='"+prodNo+"' and coupon_uuid='"+prodUuid+"'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;				
			}
		} catch (Exception e) {
			log.info("isCouponServiceExist"+e.getMessage());
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
				log.info("isCouponServiceExist"+e.getMessage());
			}
		}
		return getinfo;
	}
	public static boolean isCouponExist(String uuid,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo =false;
		try {
			String queryselect = "SELECT id FROM manage_coupon where uuid='"+uuid+"' and token='"+token+"'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;				
			}
		} catch (Exception e) {
			log.info("isCouponExist"+e.getMessage());
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
				log.info("isCouponExist"+e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isCouponTitleExist(String title,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo =false;
		try {
			String queryselect = "SELECT id FROM manage_coupon where title='"+title+"' and token='"+token+"'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;				
			}
		} catch (Exception e) {
			log.info("isCouponTitleExist"+e.getMessage());
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
				log.info("isCouponTitleExist"+e.getMessage());
			}
		}
		return getinfo;
	}
	public static boolean isCouponTitleExist(String title,String id,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo =false;
		try {
			String queryselect = "SELECT id FROM manage_coupon where title='"+title+"' and id!='"+id+"' and token='"+token+"'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;				
			}
		} catch (Exception e) {
			log.info("isCouponTitleExist"+e.getMessage());
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
				log.info("isCouponTitleExist"+e.getMessage());
			}
		}
		return getinfo;
	}
	public static boolean updateCoupon(String uuid, String title, String value, String type, String startDate,
			String endDate, String displayStatus, String addedByUUID,String modifyDate,
			String maximumDiscount, String token,String serviceType) {
		// TODO Auto-generated method stub
		PreparedStatement ps = null;
		boolean flag=false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "UPDATE manage_coupon SET title=?,value=?,type=?,startDate=?,endDate=?,displayStatus=?,addedByUUID=?,modifyDate=?,maximumDiscount=?,service_type=? WHERE uuid=? and token=?";
			ps = con.prepareStatement(query);	
			ps.setString(1, title);ps.setString(2, value);ps.setString(3, type);
			ps.setString(4, startDate);ps.setString(5, endDate);ps.setString(6, displayStatus);
			ps.setString(7, addedByUUID);ps.setString(8, modifyDate);ps.setString(9, maximumDiscount);
			ps.setString(10, serviceType);ps.setString(11, uuid);ps.setString(12, token);
			int k=ps.executeUpdate();
			if(k>0)flag=true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.updateClientKeyInEstimate "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateClientKeyInEstimate "+sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveCoupon(String uuid, String title, String value, String type, String startDate,
			String endDate, String displayStatus, String addedByUUID, String postDate, String modifyDate,
			String maximumDiscount, String token,String serviceType,String status) {
		// TODO Auto-generated method stub
		boolean flag=false;
		PreparedStatement ps = null;		
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			
			ps=con.prepareStatement("insert into manage_coupon(uuid,title,value,type,startDate,endDate,displayStatus,addedByUUID,postDate,modifyDate,maximumDiscount,token,service_type,data_from_status)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)");				
			ps.setString(1,uuid );
			ps.setString(2,title);
			ps.setString(3,value);
			ps.setString(4,type);
			ps.setString(5,startDate);
			ps.setString(6,endDate);
			ps.setString(7,displayStatus);
			ps.setString(8,addedByUUID );
			ps.setString(9,postDate );
			ps.setString(10,modifyDate );
			ps.setString(11,maximumDiscount );
			ps.setString(12,token );
			ps.setString(13, serviceType);
			ps.setString(14, status);
			
			int k=ps.executeUpdate();
			if(k>0)flag=true;
			
		}
		catch (Exception e) {
			e.printStackTrace();
			log.info("saveCoupon()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing saveCoupon() SQL Objects \n"+sqle.getMessage());
			}
		}	
		return flag;
	}

	public static void deleteCoupon(String uuid, String token) {
		Statement stmt = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{			
			stmt=con.createStatement();
			stmt.execute("delete from manage_coupon where uuid='"+uuid+"' and token='"+token+"'");
		}
		catch (Exception e) {e.printStackTrace();
			log.info("deleteCoupon()"+e.getMessage());
		}
		finally{
			try{
				if(stmt!=null) {stmt.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				log.info("Error Closing deleteCoupon() SQL Objects \n"+sqle.getMessage());
			}
		}	
	}

	public static void saveCouponServices(String uuid, String[] services, String token) {
		Statement st = null;		
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			st=con.createStatement();
			for (String prodNo : services) {
				String key=RandomStringUtils.random(40,true,true);
				st.addBatch("insert into coupon_service (uuid,coupon_uuid,product_no) values('"+key+"','"+uuid+"','"+prodNo+"')");
			}
			
			int[] executeBatch = st.executeBatch();
			
		}
		catch (Exception e) {
			log.info("saveCouponServices()"+e.getMessage());
		}
		finally{
			try{
				if(st!=null) {st.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing saveCouponServices() SQL Objects \n"+sqle.getMessage());
			}
		}
	}

	public static boolean removeAllCouponServices(String uuid) {
		Statement st = null;		
		ResultSet rs=null;
		boolean flag=false;
		Connection con = DbCon.getCon("","","");
		try{
			st=con.createStatement();
			st.execute("delete from coupon_service where coupon_uuid='"+uuid+"'");
			flag=true;
		}
		catch (Exception e) {
			log.info("removeAllCouponServices()"+e.getMessage());
		}
		finally{
			try{
				if(st!=null) {st.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing removeAllCouponServices() SQL Objects \n"+sqle.getMessage());
			}
		}
		return flag;
	}
	public static String[][] getCouponByTitle(String coupon,String today,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT * FROM manage_coupon where title='"+coupon+"' and token='"+token+"' and startDate<='"+today+"' and endDate>='"+today+"'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();
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
			log.info("getCouponByTitle"+e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException e) {
				log.info("getCouponByTitle"+e.getMessage());
			}
		}
		return newsdata;
	}

}