package attendance_master;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;

public class Attendance_ACT {
	
	private static Logger log = Logger.getLogger(Attendance_ACT.class);
	public static boolean updatepunchDetail(String uid1111,String custname,String custemaiid,String mobileno,String altmobileno,String postaddre,String distname,String kva,String phase,String ratequote,String enqby,String gdeexpecteddate,String status111,String segment,String uastokenvalue,String uaaddedon,String addeduser,String enquerybyname,String enqcylender,String remark) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("UPDATE `enqiry_master` SET `custname`=?,`custmobileno`=?,`custaltmobileno`=?,`custemailid`=?,`custpostadd`=?,`custdistname`=?,`enqpkva`=?,`enqpphase`=?,`enqratequote`=?,`enqstatus`=?,`enqenquirybyid`=?,`enqsegment`=?,`propexpecteddate`=?,`enqenquirybyname`=?,`enqtransfertoname`=?,`enqcylender`=?,`enqremark`=?, enqtransferto=?  WHERE enqid=? and enqvstatus='1' ");
			ps.setString(1,custname );
			ps.setString(2,mobileno );
			ps.setString(3,altmobileno );
			ps.setString(4,custemaiid );
			ps.setString(5,postaddre );
			ps.setString(6,distname );
			ps.setString(7,kva );
			ps.setString(8,phase );
			ps.setString(9,ratequote );
			ps.setString(10,status111 );
			ps.setString(11,enqby );
			ps.setString(12,segment );
			ps.setString(13,gdeexpecteddate );
			ps.setString(14,enquerybyname );
			ps.setString(15,enquerybyname );
			ps.setString(16,enqcylender );
			ps.setString(17,remark );
			ps.setString(18,enqby );
			ps.setString(19,uid1111 );			
			ps.execute();
			status = true;
		}catch (Exception e) {
			log.info("Error in Attendance_ACT method updatepunchDetail:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error in Attendance_ACT method updatepunchDetail:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean changeAttendanceStatus(String id,String atten, String date, String loginuser, String intime, String outtime)
	{
		PreparedStatement psGCD=null;
		StringBuffer VCQUERY=null;
		PreparedStatement stmnt=null;
		ResultSet rsInfo =null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			stmnt = con.prepareStatement("SELECT amuid FROM attendance_master where amstatus=1 and amuserid='"+id+"' and amdate='"+date+"' ");
			rsInfo = stmnt.executeQuery();
			if (rsInfo.next()) {
				VCQUERY=new StringBuffer("UPDATE attendance_master SET amattendance='"+atten+"',amintime='"+intime+"',amouttime='"+outtime+"' WHERE amuserid='"+id+"' and amdate='"+date+"'");
			}
			else {
				VCQUERY=new StringBuffer("INSERT INTO attendance_master(amdate, amuserid, amattendance, amaddedby,amintime,amouttime) VALUES ('"+date+"','"+id+"','"+atten+"','"+loginuser+"','"+intime+"','"+outtime+"')");
			}
			//System.out.println("VCQUERY.toString()>>>>>"+VCQUERY.toString());
			psGCD=con.prepareStatement(VCQUERY.toString());
			psGCD.executeUpdate();
			status=true;
		}catch(Exception e)
		{log.info("Error in Attendance_ACT method changeAttendanceStatus:\n"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(con!=null) {con.close();}
				if(rsInfo!=null) rsInfo.close();
			} catch (SQLException e)
			{

				log.info("Error in Attendance_ACT method changeAttendanceStatus:\n"+e.getMessage());
			}
		}
		return status;
	}

	public static boolean changeAttendanceintime(String userid,String value, String date, String loginuser)
	{
		PreparedStatement psGCD=null;
		StringBuffer VCQUERY=null;
		PreparedStatement stmnt=null;
		ResultSet rsInfo =null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			stmnt = con.prepareStatement("SELECT amuid FROM attendance_master where amstatus=1 and amuserid='"+userid+"' and amdate='"+date+"' ");
			//System.out.println("SELECT amuid FROM attendance_master where amstatus=1 and amuserid='"+userid+"' and amdate='"+date+"' ");
			rsInfo = stmnt.executeQuery();
			if (rsInfo.next()) {
				VCQUERY=new StringBuffer("UPDATE attendance_master SET amintime='"+value+"' WHERE amuserid='"+userid+"' and amdate='"+date+"'");
			}
			else {
				VCQUERY=new StringBuffer("INSERT INTO attendance_master(amdate, amuserid, amintime, amaddedby) VALUES ('"+date+"','"+userid+"', '"+value+"', '"+loginuser+"') ");
			}
			//System.out.println("VCQUERY.toString()>>>>>"+VCQUERY.toString());
			psGCD=con.prepareStatement(VCQUERY.toString());
			psGCD.executeUpdate();
			status=true;
		}catch(Exception e)
		{log.info("Error in Attendance_ACT method changeAttendanceintime:\n"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(con!=null) {con.close();}
				if(rsInfo!=null) rsInfo.close();
			} catch (SQLException e)
			{

				log.info("Error in Attendance_ACT method changeAttendanceintime:\n"+e.getMessage());
			}
		}
		return status;
	}

	public static boolean changeAttendanceouttime(String userid,String value, String date, String loginuser)
	{
		PreparedStatement psGCD=null;
		StringBuffer VCQUERY=null;
		PreparedStatement stmnt=null;
		ResultSet rsInfo =null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			stmnt = con.prepareStatement("SELECT amuid FROM attendance_master where amstatus=1 and amuserid='"+userid+"' and amdate='"+date+"' ");
			//System.out.println("SELECT amuid FROM attendance_master where amstatus=1 and amuserid='"+userid+"' and amdate='"+date+"' ");
			rsInfo = stmnt.executeQuery();
			if (rsInfo.next()) {
				VCQUERY=new StringBuffer("UPDATE attendance_master SET amouttime='"+value+"' WHERE amuserid='"+userid+"' and amdate='"+date+"'");
			}
			else {
				VCQUERY=new StringBuffer("INSERT INTO attendance_master(amdate, amuserid, amouttime, amaddedby) VALUES ('"+date+"','"+userid+"', '"+value+"', '"+loginuser+"') ");
			}
			//System.out.println("VCQUERY.toString()>>>>>"+VCQUERY.toString());
			psGCD=con.prepareStatement(VCQUERY.toString());
			psGCD.executeUpdate();
			status=true;
		}catch(Exception e)
		{log.info("Error in Attendance_ACT method changeAttendanceouttime:\n"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(con!=null) {con.close();}
				if(rsInfo!=null) rsInfo.close();
			} catch (SQLException e)
			{

				log.info("Error in Attendance_ACT method changeAttendanceouttime:\n"+e.getMessage());
			}
		}
		return status;
	}

	public static String[][] getAttendance(String date, String userid){
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo[][]=null;
		try{
			String queryselect="SELECT amuid, amdate, amuserid, amattendance, amintime, amouttime FROM attendance_master where amstatus=1 and amuserid='"+userid+"' and amdate='"+date+"'";
			//System.out.println("queryselect>>>>>"+queryselect);
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();

			rset.last();
			int row=rset.getRow();
			rset.beforeFirst();

			ResultSetMetaData rsmd=rset.getMetaData();
			int col=rsmd.getColumnCount();
			getinfo=new String[row][col];

			int r=0;
			while(rset!=null && rset.next()){
				for(int i=0;i<col;i++){
					getinfo[r][i]=rset.getString(i+1);
				}
				r++;
			}
		}catch (Exception e) {
			log.info("Error in Attendance_ACT method getAttendance:\n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in Attendance_ACT method getAttendance:\n"+e.getMessage());
			}}
		return getinfo;
	}

	public static String[][] getAllEmployee(String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con=DbCon.getCon("","","");
			VCQUERY=new StringBuffer("SELECT emuid,emname,emid FROM employee_master where emtokenno='"+token+"'");			String query=VCQUERY.toString();
			//System.out.println(query);
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
					//System.out.println("fff"+newsdata[rr][i]);
				}
				//System.out.println(count);
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Attendance_ACT method getAllEmployee:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				log.info("Error in Attendance_ACT method getAllEmployee:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int  getCountAttendance(String userid,String date, String from, String to)
	{
		int count=0;
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		Connection con = DbCon.getCon("","","");
		try{
			if(userid==null || userid.equalsIgnoreCase("Any") || userid.length() <= 0){ userid ="NA";}
			if(date==null || date.equalsIgnoreCase("Any") || date.length() <= 0){ date ="NA";}
			if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			VCQUERY=new StringBuffer("SELECT amuid, amdate, amuserid, amattendance, amintime, amouttime, uaname FROM attendance_master LEFT JOIN user_account ON amuserid = ualoginid where amstatus=1");
			if(userid!="NA")
			{
				VCQUERY.append(" and amuserid like '"+userid+"'");
			}
			if(date!="NA")
			{
				VCQUERY.append(" and amdate like '%___"+date+"' ");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and amaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and amaddedon between '"+from+"%' and '"+to+"%'");
			VCQUERY.append(" ORDER BY amdate DESC");
			psGCD=con.prepareStatement(VCQUERY.toString());
			rsGCD=psGCD.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int r=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++){
					newsdata[r][i]=rsGCD.getString(i+1);
				}
				count++;
			}
		}catch(Exception e)
		{log.info("Error in Attendance_ACT method getCountAttendance:\n"+e.getMessage());}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("Error in Attendance_ACT method getCountAttendance:\n"+e.getMessage());
			}
		}
		return count;
	}

	public static String[][] getallenqcountersaledata(String monthdate,String userid,String date, String token, String from, String to)
	{
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		Connection con = DbCon.getCon("","","");
		try {
			if(userid==null || userid.equalsIgnoreCase("null") || userid.length() <= 0){ userid ="NA";}
			if(date==null || date.equalsIgnoreCase("null") || date.length() <= 0){ date ="NA";}
			if(from==null || from.equalsIgnoreCase("null") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("null") || to.length() <= 0){ to ="NA";}
			VCQUERY=new StringBuffer("SELECT amuid, amdate, amuserid, amattendance, amintime, amouttime, emname FROM attendance_master JOIN employee_master ON amuserid = emuid where amstatus=1 and emtokenno='"+token+"' ");
			if(userid!="NA")
			{
				VCQUERY.append(" and amuserid like '"+userid+"'");
			}
			if(date!="NA")
			{
				VCQUERY.append(" and amdate like '%___"+date+"' ");
			}			
			if(from!="NA"&&to=="NA") VCQUERY.append(" and amaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and amaddedon between '"+from+"%' and '"+to+"%'");
			if(from=="NA"&&to=="NA"&&date=="NA" ) VCQUERY.append(" and amaddedon like '"+monthdate+"%'");
			VCQUERY.append(" ORDER BY str_to_date(amdate,'%d-%m-%Y') DESC ");
			psGCD=con.prepareStatement(VCQUERY.toString());
			rsGCD=psGCD.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int r=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++){
					newsdata[r][i]=rsGCD.getString(i+1);
				}
				r++;
			}
		}catch(Exception e)
		{
			log.info("Error in Attendance_ACT method getallenqcountersaledata:\n"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("Error in Attendance_ACT method getallenqcountersaledata:\n"+e.getMessage());
			}
		}
		return newsdata;
	}

}