package admin.task;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServlet;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import commons.CommonHelper;
import commons.DbCon;

public class TaskMaster_ACT extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(LoginAction.class);

	public static String[] getProjectsDeliveryDate(String salesKey, String token) {
		String projDeliveryDate = "00-00-0000";
		String deliveryData[]=new String[2];
		try {

			String milestones[][] = getSalesMilestoneByKey(salesKey, token);
			String workStartedDate = getProjectStartedDate(salesKey, token);
			long TotalDay = 0;
			int minutes=0;
			if (milestones != null && milestones.length > 0) {
				for (int i = 0; i < milestones.length; i++) {
					 int data[]=getEstimateDays(milestones[i][0], token);
					 TotalDay +=data[0];
					 minutes+=data[1];
				}
			}
//		System.out.println("days="+days+"/"+salesKey);
			if(minutes>480) {
				TotalDay+=minutes/480;
				minutes=minutes%480;
			}
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			Calendar c1 = Calendar.getInstance();
			int year = Integer.parseInt(workStartedDate.substring(6, 10));
//	  	System.out.println("year="+year);
			int month = Integer.parseInt(workStartedDate.substring(3, 5));
//	  	System.out.println("month="+month);
			
			c1.add(Calendar.MINUTE, minutes);
			int dhours=c1.get(Calendar.HOUR_OF_DAY);
			int dminutes=c1.get(Calendar.MINUTE);
			int extraminute=0;
		    
		    if(dhours>=18) {
		    	TotalDay+=1;
		    	c1.set(year, (month) - 1, 1, 9, 0);
		    	extraminute=((dhours-18)*60)+dminutes;
		    	c1.add(Calendar.MINUTE, extraminute);
		    	dhours=c1.get(Calendar.HOUR_OF_DAY);
				dminutes=c1.get(Calendar.MINUTE);
		    }
		    
		    String deliveryTime=dhours+ ":"+ dminutes;
		    c1 = Calendar.getInstance();			
			
			int days = Integer.parseInt(workStartedDate.substring(0, 2));
			days += TotalDay;
//	  	System.out.println("days="+days);
			c1.set(year, (month) - 1, (days));
			projDeliveryDate = sdf.format(c1.getTime());
//	    System.out.println("deliveryDate="+deliveryDate);
			boolean flag = isSunday(projDeliveryDate);
			if (flag) {
				year = Integer.parseInt(projDeliveryDate.substring(6, 10));
				month = Integer.parseInt(projDeliveryDate.substring(3, 5));
				days = Integer.parseInt(projDeliveryDate.substring(0, 2)) + 1;
//	    	System.out.println(year+"/"+month+"/"+days);
				c1.set(year, (month) - 1, (days));
				projDeliveryDate = sdf.format(c1.getTime());

			}		
			
		    deliveryData[0]=projDeliveryDate;
		    deliveryData[1]=deliveryTime;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return deliveryData;
	}
	
	public static String[] getProjectsDeliveryDate(String salesKey, String token, String today) {
		String projDeliveryDate = "00-00-0000";
		String deliveryData[]=new String[2];
		try {

			String milestones[][] = getSalesMilestoneByKey(salesKey, token);
			String workStartedDate = getProjectStartedDate(salesKey, token);
			long TotalDay = 0;
			int minutes=0;
			if (milestones != null && milestones.length > 0) {
				for (int i = 0; i < milestones.length; i++) {
					 int data[]=getTotalDays(milestones[i][0], token);
					 TotalDay +=data[0];
					 minutes+=data[1];
				}
			}
//		System.out.println("days="+days+"/"+salesKey);
			if(minutes>480) {
				TotalDay+=minutes/480;
				minutes=minutes%480;
			}
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			Calendar c1 = Calendar.getInstance();
			int year = Integer.parseInt(workStartedDate.substring(6, 10));
//	  	System.out.println("year="+year);
			int month = Integer.parseInt(workStartedDate.substring(3, 5));
//	  	System.out.println("month="+month);
			
			c1.add(Calendar.MINUTE, minutes);
			int dhours=c1.get(Calendar.HOUR_OF_DAY);
			int dminutes=c1.get(Calendar.MINUTE);
			int extraminute=0;
		    
		    if(dhours>=18) {
		    	TotalDay+=1;
		    	c1.set(year, (month) - 1, 1, 9, 0);
		    	extraminute=((dhours-18)*60)+dminutes;
		    	c1.add(Calendar.MINUTE, extraminute);
		    	dhours=c1.get(Calendar.HOUR_OF_DAY);
				dminutes=c1.get(Calendar.MINUTE);
		    }
		    
		    String deliveryTime=dhours+ ":"+ dminutes;
		    c1 = Calendar.getInstance();			
			
			int days = Integer.parseInt(workStartedDate.substring(0, 2));
			days += TotalDay;
//	  	System.out.println("days="+days);
			c1.set(year, (month) - 1, (days));
			projDeliveryDate = sdf.format(c1.getTime());
//	    System.out.println("deliveryDate="+deliveryDate);
			boolean flag = isSunday(projDeliveryDate);
			if (flag) {
				year = Integer.parseInt(projDeliveryDate.substring(6, 10));
				month = Integer.parseInt(projDeliveryDate.substring(3, 5));
				days = Integer.parseInt(projDeliveryDate.substring(0, 2)) + 1;
//	    	System.out.println(year+"/"+month+"/"+days);
				c1.set(year, (month) - 1, (days));
				projDeliveryDate = sdf.format(c1.getTime());

			}		
			
		    deliveryData[0]=projDeliveryDate;
		    deliveryData[1]=deliveryTime;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return deliveryData;
	}

	/*
	 * public static String getMilestoneDeliveryDate(String memberassigndate,String
	 * milestoneKey,String token) { String deliveryDate=""; try {
	 * 
	 * int TotalDay=getTotalDays(milestoneKey,token); SimpleDateFormat sdf = new
	 * SimpleDateFormat("dd-MM-yyyy"); Calendar c1 = Calendar.getInstance(); int
	 * year=Integer.parseInt(memberassigndate.substring(6, 10)); //
	 * System.out.println("year="+year); int
	 * month=Integer.parseInt(memberassigndate.substring(3, 5)); //
	 * System.out.println("month="+month); int
	 * days=Integer.parseInt(memberassigndate.substring(0, 2)); days+=TotalDay; //
	 * System.out.println("days="+days); c1.set(year, (month)-1 , (days));
	 * deliveryDate=sdf.format(c1.getTime()); //
	 * System.out.println("deliveryDate="+deliveryDate); boolean
	 * flag=isSunday(deliveryDate); if(flag){
	 * c1.set((Integer.parseInt(memberassigndate.substring(6, 10))),
	 * (Integer.parseInt(memberassigndate.substring(3, 5)))-1 ,
	 * (Integer.parseInt(memberassigndate.substring(0, 2)+TotalDay+1)));
	 * deliveryDate=sdf.format(c1.getTime()); }
	 * 
	 * 
	 * } catch (Exception e) { log.info("getMilestoneDeliveryDate"+e.getMessage());
	 * } return deliveryDate; }
	 */

	public static String[] getPrevCurrMilestoneDataByKey(String taskKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[12];
		try {
			String queryselect = "select maPrevParentTeamKey,maCurrentParentTeamKey,maPrevChildTeamKey,maCurrentChildTeamKey,maPrevTeamMemberUid,maCurrentTeamMemberUid,maPrevWorkStatus,maCurrentWorkStatus,maPervWorkPriority,maCurrentWorkPriority,maPrevUserPost,maCurrentUserPost from milestone_action_history where maTaskKey=? and maToken=? order by maId desc limit 1";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, taskKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
				data[3] = rs.getString(4);
				data[4] = rs.getString(5);
				data[5] = rs.getString(6);
				data[6] = rs.getString(7);
				data[7] = rs.getString(8);
				data[8] = rs.getString(9);
				data[9] = rs.getString(10);
				data[10] = rs.getString(11);
				data[11] = rs.getString(12);
			}
		} catch (Exception e) {
			log.info("getPrevCurrMilestoneDataByKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getPrevCurrMilestoneDataByKey" + e.getMessage());
			}
		}
		return data;
	}

	public static String[] getPrevCurrMilestoneData(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[12];
		try {
			String queryselect = "select maPrevParentTeamKey,maCurrentParentTeamKey,maPrevChildTeamKey,maCurrentChildTeamKey,maPrevTeamMemberUid,maCurrentTeamMemberUid,maPrevWorkStatus,maCurrentWorkStatus,maPervWorkPriority,maCurrentWorkPriority,maPrevUserPost,maCurrentUserPost from milestone_action_history where maSalesKey=? and maToken=? order by maId desc limit 1";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
				data[3] = rs.getString(4);
				data[4] = rs.getString(5);
				data[5] = rs.getString(6);
				data[6] = rs.getString(7);
				data[7] = rs.getString(8);
				data[8] = rs.getString(9);
				data[9] = rs.getString(10);
				data[10] = rs.getString(11);
				data[11] = rs.getString(12);
			}
		} catch (Exception e) {
			log.info("getPrevCurrMilestoneData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getPrevCurrMilestoneData" + e.getMessage());
			}
		}
		return data;
	}

	public static String[] getAssignedMilestoneData(String marefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[3];
		try {
			String queryselect = "select mamilestonename,maworkstarteddate,maworkpercentage from manage_assignctrl where marefid='"
					+ marefid + "' and matokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
			}
		} catch (Exception e) {
			log.info("getAssignedMilestoneData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getAssignedMilestoneData" + e.getMessage());
			}
		}
		return data;
	}

	public static String[] getAssignedTaskData(String assignKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[2];
		try {
			String queryselect = "select maparentteamrefid,mamilestonename from manage_assignctrl where marefid='"
					+ assignKey + "' and matokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
			}
		} catch (Exception e) {
			log.info("getAssignedMilestoneData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getAssignedMilestoneData" + e.getMessage());
			}
		}
		return data;
	}

	public static String[] getAssignedTaskDataByKey(String assignKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[2];
		try {
			String queryselect = "select masalesrefid,mamilestonerefid from manage_assignctrl where marefid='"
					+ assignKey + "' and matokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
			}
		} catch (Exception e) {
			log.info("getAssignedTaskDataByKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getAssignedTaskDataByKey" + e.getMessage());
			}
		}
		return data;
	}

	public static String[] getAssignedMilestoneData(String salesKey, String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[4];
		try {
			String queryselect = "select mamilestonename,mateammemberid,maworkstarteddate,marefid from manage_assignctrl where masalesrefid='"
					+ salesKey + "' and mamilestonerefid='" + milestoneKey + "' and matokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
				data[3] = rs.getString(4);
			}
		} catch (Exception e) {
			log.info("getAssignedMilestoneData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getAssignedMilestoneData" + e.getMessage());
			}
		}
		return data;
	}

	public static String[] getMilestoneData(String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[2];
		try {
			String queryselect = "select smprodrefid,smmilestonename from salesmilestonectrl where smrefid=? and smtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, milestoneKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
			}
		} catch (Exception e) {
			log.info("getMilestoneData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getMilestoneData" + e.getMessage());
			}
		}
		return data;
	}

	public static String[] getPreviousCurrentData(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[6];
		try {
			String queryselect = "select dhprevstatus,dhcurrentstatus,dhprevteamkey,dhcurrentteamkey,dhprevpriority,dhcurrentpriority from deliveryactionhistory where dhsaleskey=? and dhtoken=? order by dhid desc limit 1";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
				data[3] = rs.getString(4);
				data[4] = rs.getString(5);
				data[5] = rs.getString(6);
			}
		} catch (Exception e) {
			log.info("getPreviousData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getPreviousData" + e.getMessage());
			}
		}
		return data;
	}

	public static String getMilestoneDuration(String salesKey,String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select smtimelinevalue,smtimelineperiod from salesmilestonectrl where smrefid=? and smsalesrefid=? and smtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, milestoneKey);
			ps.setString(2, salesKey);
			ps.setString(3, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1)+" "+rs.getString(2);
			}
			
		} catch (Exception e) {
			log.info("getMilestoneDuration()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("getMilestoneDuration()" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String getProjectNoByKey(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select msprojectnumber from managesalesctrl where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getProjectNoByKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getProjectNoByKey" + e.getMessage());
			}
		}
		return data;
	}

	public static String getProductJurisdictionStatus(String prodKey, String token,String column) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select "+column+" from product_master where prefid=? and ptokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, prodKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getProductCentralStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getProductCentralStatus" + e.getMessage());
			}
		}
		return data;
	}

	public static String getProductNo(String prodKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select pprodid from product_master where prefid=? and ptokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, prodKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getProductNo" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getProductNo" + e.getMessage());
			}
		}
		return data;
	}

	
	public static String findEstimateByInvoice(String invoiceNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select msestimateno from managesalesctrl where msinvoiceno=? and mstoken=?";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			ps.setString(1, invoiceNo);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("findEstimateByInvoice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rs!=null)rs.close();
			} catch (SQLException e) {
				log.info("findEstimateByInvoice" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String getProjectStartedDate(String taskKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select mssolddate from managesalesctrl where msrefid=? and mstoken=?";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			ps.setString(1, taskKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getProjectStartedDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rs!=null)rs.close();
			} catch (SQLException e) {
				log.info("getProjectStartedDate" + e.getMessage());
			}
		}
		return data;
	}
	public static String[] getTaskDeliveryDate(String salesKey, String workStartDate, String milestoneKey,
			String token) {
		String deliveryData[]=new String[2];
		String deliveryDate = "";
		try {
			int TotalDay = 0;
			int minutes=0;
			int data[]=getTotalDays(milestoneKey, token);
			TotalDay=data[0];	
			minutes=data[1];
			
			if(minutes>480) {
				TotalDay+=minutes/480;
				minutes=minutes%480;
			}
			
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			Calendar c1 = Calendar.getInstance();
			
			int year = Integer.parseInt(workStartDate.substring(6, 10));
//		  	System.out.println("year="+year);
			int month = Integer.parseInt(workStartDate.substring(3, 5));
//		  	System.out.println("month="+month);
			
			
			c1.add(Calendar.MINUTE, minutes);
			int dhours=c1.get(Calendar.HOUR_OF_DAY);
			int dminutes=c1.get(Calendar.MINUTE);
			int extraminute=0;
		    
		    if(dhours>=18) {
		    	TotalDay+=1;
		    	c1.set(year, (month) - 1, 1, 9, 0);
		    	extraminute=((dhours-18)*60)+dminutes;
		    	c1.add(Calendar.MINUTE, extraminute);
		    	dhours=c1.get(Calendar.HOUR_OF_DAY);
				dminutes=c1.get(Calendar.MINUTE);
		    }
		    String hh=dhours+"";
		    String mm=dminutes+"";
		    if(hh.length()==1)hh="0"+hh;
		    if(mm.length()==1)mm="0"+mm;
		    
		    String deliveryTime=hh+":"+mm;
		    
		    
		    c1 = Calendar.getInstance();
			
			int days = Integer.parseInt(workStartDate.substring(0, 2));
			
			days +=TotalDay;
//		  	System.out.println("days="+days);
			c1.set(year, (month) - 1, (days));
			deliveryDate = sdf.format(c1.getTime());
//		    System.out.println("deliveryDate="+deliveryDate);
			boolean flag = isSunday(deliveryDate);
			if (flag) {
				year = Integer.parseInt(deliveryDate.substring(6, 10));
				month = Integer.parseInt(deliveryDate.substring(3, 5));
				days = Integer.parseInt(deliveryDate.substring(0, 2)) + 1;
//		    	System.out.println(year+"/"+month+"/"+days);
				c1.set(year, (month) - 1, (days));
				deliveryDate = sdf.format(c1.getTime());
			}
		    
		    
//		    System.out.println("Delivery Time==="+deliveryTime);
		    
		    deliveryData[0]=deliveryDate;
		    deliveryData[1]=deliveryTime;
			
			
		} catch (Exception e) {
			log.info("getTaskDeliveryDate" + e.getMessage());
		}
		return deliveryData;
	}
	public static String[] getMilestoneDeliveryDate(String salesKey, String memberassigndate, String milestoneKey,
			int step, String token) {
		String deliveryData[]=new String[2];
		String deliveryDate = "";
		try {
			int TotalDay = 0;
			int minutes=0;
			int data[]=new int[2];
			if (step == 1) {
				data = getTotalDays(milestoneKey, token);
				TotalDay=data[0];	
				minutes+=data[1];
			} else {
				String milestones[][] = getAllSalesMilestoneKey(salesKey, step, token);
				if (milestones != null && milestones.length > 0) {
					for (int i = 0; i < milestones.length; i++) {
						data= getTotalDays(milestones[i][0], token);
						TotalDay +=data[0];
						minutes+=data[1];
					}
				}
			}
			if(minutes>480) {
				TotalDay+=minutes/480;
				minutes=minutes%480;
			}
			
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			Calendar c1 = Calendar.getInstance();
			
			int year = Integer.parseInt(memberassigndate.substring(6, 10));
//		  	System.out.println("year="+year);
			int month = Integer.parseInt(memberassigndate.substring(3, 5));
//		  	System.out.println("month="+month);
			
			
			c1.add(Calendar.MINUTE, minutes);
			int dhours=c1.get(Calendar.HOUR_OF_DAY);
			int dminutes=c1.get(Calendar.MINUTE);
			int extraminute=0;
		    
		    if(dhours>=18) {
		    	TotalDay+=1;
		    	c1.set(year, (month) - 1, 1, 9, 0);
		    	extraminute=((dhours-18)*60)+dminutes;
		    	c1.add(Calendar.MINUTE, extraminute);
		    	dhours=c1.get(Calendar.HOUR_OF_DAY);
				dminutes=c1.get(Calendar.MINUTE);
		    }
		    
		    String hh=dhours+"";
		    String mm=dminutes+"";
		    if(hh.length()==1)hh="0"+hh;
		    if(mm.length()==1)mm="0"+mm;
		    
		    String deliveryTime=hh+":"+mm;
		    c1 = Calendar.getInstance();
			
			int days = Integer.parseInt(memberassigndate.substring(0, 2));
			days +=TotalDay;
//		  	System.out.println("days="+days);
			c1.set(year, (month) - 1, (days));
			deliveryDate = sdf.format(c1.getTime());
//		    System.out.println("deliveryDate="+deliveryDate);
			boolean flag = isSunday(deliveryDate);
			if (flag) {
				year = Integer.parseInt(deliveryDate.substring(6, 10));
				month = Integer.parseInt(deliveryDate.substring(3, 5));
				days = Integer.parseInt(deliveryDate.substring(0, 2)) + 1;
//		    	System.out.println(year+"/"+month+"/"+days);
				c1.set(year, (month) - 1, (days));
				deliveryDate = sdf.format(c1.getTime());
			}
		    
		    
//		    System.out.println("Delivery Time==="+deliveryTime);
		    
		    deliveryData[0]=deliveryDate;
		    deliveryData[1]=deliveryTime;
			
			
		} catch (Exception e) {e.printStackTrace();;
			log.info("getMilestoneDeliveryDate" + e.getMessage());
		}
		return deliveryData;
	}

	public static String[] getDeliveryDate(String memberassigndate, String milestoneKey, String token,String p) {

		String getinfo[] = new String[3];
		try {

			String deliveryDate = "";

			int TotalDay =0;
			
			int data[]=getTotalDays(milestoneKey, token);
			TotalDay=data[0];
			int minutes=data[1];
			
			if(minutes>480) {
				TotalDay+=minutes/480;
				minutes=minutes%480;
			}
			
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			Calendar c1 = Calendar.getInstance();
			int year = Integer.parseInt(memberassigndate.substring(6, 10));
//		  	System.out.println("year="+year);
			int month = Integer.parseInt(memberassigndate.substring(3, 5));
//		  	System.out.println("month="+month);
			int days = Integer.parseInt(memberassigndate.substring(0, 2));
			days +=TotalDay;
//		  	System.out.println("days="+days);
			c1.set(year, (month) - 1, (days));
			deliveryDate = sdf.format(c1.getTime());
//		    System.out.println("deliveryDate="+deliveryDate);
			boolean flag = isSunday(deliveryDate);
			if (flag) {
				c1.set((Integer.parseInt(memberassigndate.substring(6, 10))),
						(Integer.parseInt(memberassigndate.substring(3, 5))) - 1,
						(Integer.parseInt(memberassigndate.substring(0, 2) + TotalDay + 1)));
				deliveryDate = sdf.format(c1.getTime());
			}

			Date date = new SimpleDateFormat("d-M-yyyy").parse(deliveryDate);

			// Then get the day of week from the Date based on specific locale.
			String dayOfWeek = new SimpleDateFormat("EEEE", Locale.ENGLISH).format(date);
			c1.setTime(date);
			String monthName = new SimpleDateFormat("MMMM").format(c1.getTime());
			getinfo[0] = monthName;
			getinfo[1] = deliveryDate.substring(0, 2);
			getinfo[2] = dayOfWeek;
//		    System.out.println("dayOfWeek="+dayOfWeek+"/"+deliveryDate+"/"+monthName);

		} catch (Exception e) {
			log.info("getAllAssignments" + e.getMessage());
		}
		return getinfo;
	}
	
	public static String[] getMonthAndDay(String date) {
		String getinfo[] = new String[2];
		try {
		Date date1 = new SimpleDateFormat("dd-MM-yyyy").parse(date);
		Calendar c1 = Calendar.getInstance();
		
		// Then get the day of week from the Date based on specific locale.
		String dayOfWeek = new SimpleDateFormat("EEEE", Locale.ENGLISH).format(date1);
		c1.setTime(date1);
		String monthName = new SimpleDateFormat("MMMM").format(c1.getTime());
		
		getinfo[0] = monthName;
		getinfo[1] = dayOfWeek;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return getinfo;
	}
	
	public static int getAllAssignments(String uaid, String token, String date_range) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		String fromDate = "NA";
		String toDate = "NA";

		try {
			if (!date_range.equalsIgnoreCase("NA")) {
				fromDate = date_range.substring(0, 10);
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = date_range.substring(13);
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			StringBuffer queryselect = new StringBuffer(
					"SELECT count(maid) FROM manage_assignctrl where mateammemberid='" + uaid
							+ "' and maworkpercentage!='100' and maworkstarteddate!='00-00-0000' and matokenno='"
							+ token
							+ "' and masaleshierarchystatus='1' and mahierarchyactivestatus='1' and maapprovalstatus='1' and mastepstatus='1'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA"))
				queryselect.append(
						" and mamemberassigndate!='00-00-0000' and str_to_date(mamemberassigndate,'%d-%m-%Y')<='"
								+ toDate + "' and str_to_date(mamemberassigndate,'%d-%m-%Y')>='" + fromDate + "'");
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getAllAssignments" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getAllAssignments" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getProductWorkPercentage(String prodkey,String milestoneName,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 100;
		try {
			String queryselect = "SELECT pm_pricepercent FROM product_milestone WHERE pm_prodrefid='"+prodkey+"' and pm_milestonename='"+milestoneName+"' and pm_tokeno='"+token+"'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo=rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getProductWorkPercentage" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductWorkPercentage" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getAssignMileStoneName(String marefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT mamilestonename FROM manage_assignctrl WHERE marefid='"+marefid+"' and matokenno='"+token+"'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);				
			}
		} catch (Exception e) {
			log.info("getAssignMileStoneName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getAssignMileStoneName" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static String getMileStoneName(String marefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT smmilestonename FROM salesmilestonectrl s JOIN manage_assignctrl m on m.mamilestonerefid=s.smrefid WHERE m.marefid='"+marefid+"' and m.matokenno='"+token+"'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);				
			}
		} catch (Exception e) {
			log.info("getMileStoneName11" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getMileStoneName11" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static String[] getMileStoneData(String marefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[8];
		try {
			String queryselect = "SELECT mamilestonerefid,madeliverydate,madeliverytime,"
					+ "madelivereddate,madeliveredtime,maworkstarteddate,maworkstartedtime,"
					+ "maworkpercentage FROM manage_assignctrl"
					+ " WHERE marefid='"+marefid+"' and matokenno='"+token+"'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);			
				getinfo[1] = rset.getString(2);			
				getinfo[2] = rset.getString(3);			
				getinfo[3] = rset.getString(4);			
				getinfo[4] = rset.getString(5);	
				getinfo[5] = rset.getString(6);			
				getinfo[6] = rset.getString(7);	
				getinfo[7] = rset.getString(8);	
			}
		} catch (Exception e) {
			log.info("getMileStoneData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getMileStoneData" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static String getTeamKeyByTaskKey(String marefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT maparentteamrefid,machildteamrefid FROM manage_assignctrl where marefid='"
					+ marefid + "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				if (!rset.getString(2).equals("NA")) {
					getinfo = rset.getString(2);
				} else {
					getinfo = rset.getString(1);
				}
			}
		} catch (Exception e) {
			log.info("getTeamKeyByTaskKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTeamKeyByTaskKey" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getTaskAssignedDate(String salesKey, String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "00-00-0000";
		try {
			String queryselect = "SELECT mamemberassigndate,maassignDate FROM manage_assignctrl where masalesrefid='"
					+ salesKey + "' and mamilestonerefid='" + milestoneKey + "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
				if (getinfo.equalsIgnoreCase("00-00-0000"))
					getinfo = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("getTaskAssignedDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTaskAssignedDate" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getAssignedTaskDeliveryDate(String salesKey, String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "00-00-0000";
		try {
			String queryselect = "SELECT madeliverydate,madeliverytime FROM manage_assignctrl where masalesrefid='" + salesKey
					+ "' and mamilestonerefid='" + milestoneKey + "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1)+"#"+rset.getString(2);
			}
		} catch (Exception e) {
			log.info("getAssignedTaskDeliveryDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getAssignedTaskDeliveryDate" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getUploadedDocName(String taskKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "";
		try {
			String queryselect = "SELECT sddocname FROM salesdocumentctrl where sdmilestoneuuid!='NA' and sdmilestoneuuid='"+taskKey+"' and sdtokenno='"
					+ token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getUploadedDocName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getUploadedDocName" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static String findClientDocumentUploads(String salesKey,String token,int html) {
		PreparedStatement ps = null;
		ResultSet rs=null;
		int uploaded=0;
		int total=0;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "SELECT sddocname,sduploadedby,sduploaddate FROM salesdocumentctrl where "
					+ "sdsalesrefid='"+salesKey+"' and sduploadby='Client' and sdtokenno='"+token+"'";
			ps = con.prepareStatement(query);	
			rs=ps.executeQuery();
			while(rs.next()) {
				total++;
				if(!rs.getString(1).equals("NA")&&rs.getString(1)!=null&&
						!rs.getString(2).equals("NA")&&rs.getString(2)!=null
						&&!rs.getString(3).equals("00-00-0000")&&rs.getString(3)!=null)
					uploaded++;
			}
		}
		catch (Exception e) {
			log.info("Error in findClientDocumentUploads method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) rs.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findClientDocumentUploads:\n"+sqle.getMessage());
			}
		}
		if(html==1) {
			String data="";
			if(total==0&&uploaded==0)data="<span class='text-danger'>No Document</span>";
			else if(uploaded==0)data="<span class='text-danger'>"+uploaded+" Out Of "+total+"</span>";
			else if(uploaded<=(total/2))data="<span class='text-warning'>"+uploaded+" Out Of "+total+"</span>";
			else if(uploaded==total)data="<span class='text-success'>"+uploaded+" Out Of "+total+"</span>";
			else data=uploaded+" Out Of "+total;
			return data;
		}else {
			return uploaded+" Out Of "+total;
		}
		
	}
	
	public static int countSalesTask(String salesKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT count(smid) FROM salesmilestonectrl where smsalesrefid='"+salesKey+"' and smtoken='"
					+ token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("countSalesTask" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("countSalesTask" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static int countUnassignedTask(String salesKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT count(maid) FROM manage_assignctrl where mateammemberid='NA' and masalesrefid='"+salesKey+"' and matokenno='"
					+ token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("countUnassignedTask" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("countUnassignedTask" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static int countUploadedDoc(String taskKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT count(sdid) FROM salesdocumentctrl where sdmilestoneuuid!='NA' and sdmilestoneuuid='"+taskKey+"' and sdtokenno='"
					+ token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("countUploadedDoc" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("countUploadedDoc" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static int getAllApproval(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT count(maid) FROM manage_assignctrl where maapprovalstatus!='1' and matokenno='"
					+ token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getAllApproval" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getAllApproval" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static int getNextStepAssignPercentage(String salesKey, String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT manexttaskassignpercentage FROM manage_assignctrl where masalesrefid='"
					+ salesKey + "' and mamilestonerefid='" + milestoneKey + "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getNextStepAssignPercentage" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getNextStepAssignPercentage" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getTotalProfessionalFee(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(sptotalprice) FROM salespricectrl where sptokenno='" + token
					+ "' and sppricetype='Professional fees'";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getTotalProfessionalFee" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalProfessionalFee" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double sumDepartExpense(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(expamount) FROM expense_approval_ctrl where exptoken='" + token
					+ "' and (expcategory='Department Fees' or expcategory='Filing Fees')";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("sumDepartExpense" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("sumDepartExpense" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double sumDefaultFee(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(sptotalprice) FROM salespricectrl where sptokenno='" + token
					+ "' and (sppricetype='Professional fees' or sppricetype='Government fees' or sppricetype='Miscellaneous fees' or sppricetype='Other fees')";
//System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("sumDefaultFee" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("sumDefaultFee" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getDepartmentFeeExpense(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(expamount) FROM expense_approval_ctrl where exptoken='" + token
					+ "' and expcategory='Department Fees'";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getDepartmentFeeExpense" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getDepartmentFeeExpense" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getTotalGovernmentFee(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(sptotalprice) FROM salespricectrl where sptokenno='" + token
					+ "' and sppricetype='Government fees'";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getTotalGovernmentFee" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalGovernmentFee" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getWorkStartPercentage(String salesKey, String milestoneKey,
			String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT maworkstartpricepercentage FROM manage_assignctrl where masalesrefid='"
					+ salesKey + "' and mamilestonerefid='" + milestoneKey + "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getWorkStartPercentage" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getWorkStartPercentage" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getWorkStartPercentage(String assignKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT maworkstartpricepercentage FROM manage_assignctrl where marefid='" + assignKey
					+ "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getWorkStartPercentage" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getWorkStartPercentage" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getEachSalesAmount(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(sptotalprice) FROM salespricectrl where spsalesrefid='" + salesrefid
					+ "' and sptokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getEachSalesAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getEachSalesAmount" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static double getSalesAmount(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT smworderamount FROM salesmainworkpricectrl where smwsaleskey='" + salesrefid
					+ "' and smwtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String isStepGuideExist(String milestoneId, int stepNo, String token,String jurisdiction) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT sgkey FROM step_guide where sgmilestoneid='" + milestoneId + "' and sgjurisdiction='"+jurisdiction+"' and sgstepno='"
					+ stepNo + "' and sgtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("isStepGuideExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isStepGuideExist" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isTriggerActionExist(String triggerKey, int numbering, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT takey FROM trigger_action_virtual where taTriggerKey='" + triggerKey
					+ "' and taNumbering='" + numbering + "' and taToken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isTriggerActionExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isTriggerActionExist" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isTriggerConditionExist(String triggerKey, int numbering, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT tckey FROM trigger_condition_virtual where tcTriggerKey='" + triggerKey
					+ "' and tcNumbering='" + numbering + "' and tcToken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isTriggerConditionExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isTriggerConditionExist" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isUserTeamMember(String uaid, String teamKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT tmid FROM manageteammemberctrl where tmuseruid='" + uaid
					+ "' and tmteamrefid='" + teamKey + "' and tmtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isUserTeamMember" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isUserTeamMember" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isTaskStatusOk(String salesKey, String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT maid FROM manage_assignctrl where masalesrefid='" + salesKey
					+ "' and mamilestonerefid='" + milestoneKey + "' and matokenno='" + token
					+ "' and mateammemberid!='NA' and maworkstarteddate='00-00-0000' and masaleshierarchystatus='1' and mahierarchyactivestatus='1' and maapprovalstatus='1' and mastepstatus='1'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isTaskStatusOk" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isTaskStatusOk" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isTaskInProgress(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT maid FROM manage_assignctrl where masalesrefid='" + salesKey + "' and matokenno='"+ token
					+ "' and task_progress_status='3'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isTaskInProgress" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isTaskInProgress" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static boolean isTaskStatusOk(String assignKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT maid FROM manage_assignctrl where marefid='" + assignKey + "' and matokenno='"+ token
					+ "' and mateammemberid!='NA' and maworkstarteddate='00-00-0000' and masaleshierarchystatus='1' and mahierarchyactivestatus='1' and maapprovalstatus='1' and mastepstatus='1'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isTaskStatusOk" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isTaskStatusOk" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isDisperseExist(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT smwid FROM salesmainworkpricectrl where smwsaleskey='" + salesrefid
					+ "' and smwtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("getMainDispersedAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getMainDispersedAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getMainDispersedAmount(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT smwpricedispersed FROM salesmainworkpricectrl where smwsaleskey='" + salesrefid
					+ "' and smwtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getMainDispersedAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getMainDispersedAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getProductName(String prodKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT pname FROM product_master where prefid='" + prodKey + "' and ptokenno='"
					+ token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getProductName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductName" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getAssignedMilestoneName(String marefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT mamilestonename FROM manage_assignctrl where marefid='" + marefid
					+ "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getAssignedMilestoneName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getAssignedMilestoneName" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getAssignedMilestoneKey(String marefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT mamilestonerefid FROM manage_assignctrl where marefid='" + marefid
					+ "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getAssignedMilestoneKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getAssignedMilestoneKey" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[][] getAllCoupons(String token,int page,int rows,String sort,String order) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			StringBuffer queryselect =new StringBuffer("SELECT * FROM manage_coupon where token='" + token + "'");
			if(sort.length()<=0)			
				queryselect.append("order by id desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("title"))queryselect.append("order by title "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("value"))queryselect.append("order by value "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("type"))queryselect.append("order by type "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("validity"))queryselect.append("order by endDate "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("service_type"))queryselect.append("order by service_type "+order+" limit "+((page-1)*rows)+","+rows);
			stmnt = con.prepareStatement(queryselect.toString());
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
			log.info("getAllCoupons" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllCoupons" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllCoupons(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		try {
			String query = "SELECT count(id) FROM manage_coupon where token='" + token + "' order by id desc";
			stmnt = con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countAllCoupons" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllCoupons" + e.getMessage());
			}
		}
		return newsdata;
	}
		
	public static String[][] getAllNotifications(String token, String loginuaid,String dateRange,int page,int rows) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			
			StringBuffer query =new StringBuffer("SELECT nKey,nDate,nRedirectPage,nSeenStatus,nMessage,nicon FROM notifications where nShowUid='"
					+ loginuaid + "' and nToken='" + token + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(nDate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(nDate,'%d-%m-%Y')>='" + fromDate + "'");
			}
			query.append(" order by nId desc limit "+((page-1)*rows)+","+rows);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("getAllNotifications" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllNotifications" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllNotifications(String token, String loginuaid,String dateRange) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			
			StringBuffer query =new StringBuffer("SELECT count(nId) FROM notifications where nShowUid='"
					+ loginuaid + "' and nToken='" + token + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(nDate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(nDate,'%d-%m-%Y')>='" + fromDate + "'");
			}
			
			stmnt = con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countAllNotifications" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllNotifications" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllCountries() {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT name,id FROM countries where 1";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("getAllCountries" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllCountries" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getStatesByCountryCode(String countryCode) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT name,id,state_code FROM states where country_code='" + countryCode + "'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("getStatesByCountryCode" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getStatesByCountryCode" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getMilestoneKey(String salesrefid, int step, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT smrefid FROM salesmilestonectrl where smsalesrefid='" + salesrefid + "' and smstep='"
					+ step + "' and smtoken='" + token + "'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("getMilestoneKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getMilestoneKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int[] getTotalMilestoneDays(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		
		int getinfo[] = new int[2];
		
		try {
			String queryselect = "SELECT smtimelinevalue,smtimelineperiod,smtimelineextendeddays,smtimelineextendedminutes FROM salesmilestonectrl where smsalesrefid='"
					+ salesKey + "' and smtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset.next()) {
				if (rset.getString(2).equalsIgnoreCase("Week")) {
					getinfo[0] += (rset.getInt(1) * 7);
				} else if (rset.getString(2).equalsIgnoreCase("Month")) {
					getinfo[0] += (rset.getInt(1) * 30);
				} else if (rset.getString(2).equalsIgnoreCase("Day")) {
					getinfo[0] += rset.getInt(1);
				} else if (rset.getString(2).equalsIgnoreCase("Hour")) {
					getinfo[1] += (rset.getInt(1) * 60);
				} else if (rset.getString(2).equalsIgnoreCase("Minute")) {
					getinfo[1] += rset.getInt(1);
				}
				
				getinfo[0] += rset.getInt(3);
				getinfo[1] += rset.getInt(4);
			}
		} catch (Exception e) {
			log.info("getTotalMilestoneDays" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalMilestoneDays" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static int[] getEstimateDays(String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo[] =new int[2];
		try {
			String queryselect = "SELECT smtimelinevalue,smtimelineperiod FROM salesmilestonectrl where smrefid='"
					+ milestoneKey + "' and smtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				
				if (rset.getString(2).equalsIgnoreCase("Week")) {
					getinfo[0] += (rset.getInt(1) * 7);
				} else if (rset.getString(2).equalsIgnoreCase("Month")) {
					getinfo[0] += (rset.getInt(1) * 30);
				} else if (rset.getString(2).equalsIgnoreCase("Day")) {
					getinfo[0] += rset.getInt(1);
				} else if (rset.getString(2).equalsIgnoreCase("Hour")) {
					getinfo[1] += (rset.getInt(1) * 60);
				} else if (rset.getString(2).equalsIgnoreCase("Minute")) {
					getinfo[1] += rset.getInt(1);
				}
								
			}
		} catch (Exception e) {
			log.info("getEstimateDays" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getEstimateDays" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static int[] getTotalDays(String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo[] =new int[2];
		try {
			String queryselect = "SELECT smtimelinevalue,smtimelineperiod,smtimelineextendeddays,smtimelineextendedminutes FROM salesmilestonectrl where smrefid='"
					+ milestoneKey + "' and smtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				
				if (rset.getString(2).equalsIgnoreCase("Week")) {
					getinfo[0] += (rset.getInt(1) * 7);
				} else if (rset.getString(2).equalsIgnoreCase("Month")) {
					getinfo[0] += (rset.getInt(1) * 30);
				} else if (rset.getString(2).equalsIgnoreCase("Day")) {
					getinfo[0] += rset.getInt(1);
				} else if (rset.getString(2).equalsIgnoreCase("Hour")) {
					getinfo[1] += (rset.getInt(1) * 60);
				} else if (rset.getString(2).equalsIgnoreCase("Minute")) {
					getinfo[1] += rset.getInt(1);
				}
				
				getinfo[0] += rset.getInt(3);
				getinfo[1] += rset.getInt(4);
				
			}
		} catch (Exception e) {
			log.info("getTotalDays" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalDays" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static int getMilestoneStep(String salesrefid, String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT smstep FROM salesmilestonectrl where smsalesrefid='" + salesrefid
					+ "' and smrefid='" + milestoneKey + "' and smtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getMilestoneStep" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getMilestoneStep" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static int getPaymentStep(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT smwsteppayment FROM salesmainworkpricectrl where smwsaleskey='" + salesrefid
					+ "' and smwtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getPaymentStep" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getPaymentStep" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static int getTotalCompletedMilestones(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT count(maid) FROM manage_assignctrl where masalesrefid='" + salesrefid
					+ "' and matokenno='" + token + "' and maworkpercentage='100'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getTotalCompletedMilestones" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalCompletedMilestones" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static int getTotalMilestones(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT count(smid) FROM salesmilestonectrl where smsalesrefid='" + salesrefid
					+ "' and smtoken='" + token + "' and smstatus='1'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getTotalMilestones" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalMilestones" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getRelationType(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT shmhierarchytype FROM saleshierarchymanagectrl where shmsalesrefid='"
					+ salesKey + "' and shmtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getRelationType" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getRelationType" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getSalesInvoiceNumber(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT msinvoiceno FROM managesalesctrl where msrefid='" + salesKey
					+ "' and mstoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesInvoiceNumber" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesInvoiceNumber" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean disperseAmount(String salesKey, String invoiceno, String date, String uavalidtokenno,
			String addedby, String loginuaid) {
		boolean flag = false;
		try {
//		start
			double dueAmt[] = getOrderDueAmount(invoiceno, uavalidtokenno);
			double avlAmount = getTotalInvoicePaid(invoiceno, uavalidtokenno);
//			double orderAmount = TaskMaster_ACT.getOrderAmount(invoiceno, uavalidtokenno);
			String workPayType = getSalesWorkPayType(salesKey, uavalidtokenno);
//		System.out.println("avlAmount="+avlAmount);
			double dispersedAmt = 0;
			double workPricePercentage = 0;
			int step = 1;
			if(dueAmt[0]>0) {
//		System.out.println("workPayType="+workPayType);
				if (workPayType.equalsIgnoreCase("Milestone Pay")) {
					int count = getTotalMilestones(salesKey, uavalidtokenno);
					boolean isExist = true;
					while (isExist && step <= count) {
						isExist = getFirstStep(salesKey, step, uavalidtokenno);
						if (isExist)
							step += 1;
					}
					// getting this project's first milestone percentage
					workPricePercentage = getPricePercentage(salesKey, step, uavalidtokenno);
//			System.out.println("step="+step);
				} else if (workPayType.equalsIgnoreCase("Partial Pay")) {
					workPricePercentage = 50;
					step = 0;
				} else if (workPayType.equalsIgnoreCase("Full Pay")) {
					workPricePercentage = 100;
					step = 0;
				}
			}else workPricePercentage = 100;
			
//		System.out.println("workPricePercentage="+workPricePercentage);
			// getting each sales order amount
		double orderAmount=Enquiry_ACT.getProductAmount(salesKey,uavalidtokenno); 
//		System.out.println("Sales Amount="+salesAmount);
			// check if amount available then paid otherwise not
			double price = (orderAmount * workPricePercentage) / 100;
//		System.out.println("work start price="+price);
			double dAmount = TaskMaster_ACT.getMainDispersedAmount(salesKey, uavalidtokenno);
//		System.out.println("dAmount="+dAmount);
			
//		System.out.println("price="+price+"/avlAmount="+avlAmount);
//		System.out.println("Price="+price);
			boolean addPayment = true;
			if (workPayType.equalsIgnoreCase("Partial Pay")) {
				if (dAmount >= (orderAmount / 2))
					addPayment = false;
			}
			if (price > dAmount) {price = price - dAmount;
			if (price > 0 && avlAmount >= price) {
				avlAmount -= price;
				dispersedAmt += price;
				String key = RandomStringUtils.random(40, true, true);
				String salesDetails[] = getSalesData(salesKey, uavalidtokenno);
				String remarks = CommonHelper.withLargeIntegers(price) + "Rs. paid to Project : " + salesDetails[1] + " - " + salesDetails[0];
				// add in dispersed amount in salesworkpricectrl table projectNo projectName
				// invoice
				flag = saveDispersedAmount(key, salesKey, salesDetails[1], salesDetails[0], salesDetails[2], date,
						price, remarks, uavalidtokenno, addedby);
//			System.out.println("Disperced amount="+dispersedAmt);
				boolean isExist=TaskMaster_ACT.isThisSaleDispersed(salesKey,uavalidtokenno);
				if(isExist) {					
					//add each project's dispersed amount 
					TaskMaster_ACT.updateDisperseAmountOfSales(salesKey,price,uavalidtokenno,step);
				}else {
				// add each project's dispersed amount
				String smwkey = RandomStringUtils.random(40, true, true);
				flag = addDisperseAmountOfSales(smwkey, salesKey, salesDetails[1], salesDetails[2], price, orderAmount,
						uavalidtokenno, addedby, step);
				}

			} else if (dueAmt[0] != 0 && addPayment) {
				String accountant[][] = Usermaster_ACT.getAllAccountant(uavalidtokenno);
				if (accountant != null && accountant.length > 0) {
					for (int j = 0; j < accountant.length; j++) {
						String salesData[] = TaskMaster_ACT.getSalesData(salesKey, uavalidtokenno);
						// adding notification
						String nKey = RandomStringUtils.random(40, true, true);
						String message = "Project : <span class='text-info'>" + salesData[1] + "</span> :- Add rs. "
								+ (price - avlAmount) + " to re-start project's work.";
						TaskMaster_ACT.addNotification(nKey, date, accountant[j][0], "2", "manage-billing.html",
								message, uavalidtokenno, loginuaid,"fas fa-rupee-sign");
						// adding for sold person
						String userNKey = RandomStringUtils.random(40, true, true);
						String userMessage = "Estimate No. : <span class='text-info'>" + salesData[7]
								+ "</span> :- Add rs. " + (price - avlAmount) + " to re-start project's work.";
						TaskMaster_ACT.addNotification(userNKey, date, salesData[6], "2", "manage-estimate.html",
								userMessage, uavalidtokenno, loginuaid,"fas fa-rupee-sign");
					}
				}
			}
			}
			if (dispersedAmt > 0) {
				// update dispersed amount in billing table
				flag = updateDispersedAmount(invoiceno, dispersedAmt, uavalidtokenno);
//			System.out.println("disperse amount updated");
			}

//		end
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

	public static long getTotalGuide(String productKey, String milestoneName, String dateRange, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		long newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			queryselect = new StringBuffer(
					"SELECT sgid FROM step_guide where sgststus='1' and sgtoken='" + token + "'");
			if (!productKey.equalsIgnoreCase("NA"))
				queryselect.append(" and sgprodkey ='" + productKey + "'");
			if (!milestoneName.equalsIgnoreCase("NA"))
				queryselect.append(" and sgmilestonename ='" + milestoneName + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(sgaddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(sgaddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			queryselect.append(" group by sgprodkey");
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata++;
			}
		} catch (Exception e) {
			log.info("getTotalGuide" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getTotalGuide" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllstepGuide(String productKey, String milestoneName, String dateRange, String token
			,int page,int rows,String sort,String order) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			queryselect = new StringBuffer(
					"SELECT sgkey,sgprodkey,sgmilestoneid,sgmilestonename,sgdate,sgjurisdiction FROM step_guide where sgststus='1' and sgtoken='"
							+ token + "'");
			if (!productKey.equalsIgnoreCase("NA"))
				queryselect.append(" and sgprodkey ='" + productKey + "'");
			if (!milestoneName.equalsIgnoreCase("NA"))
				queryselect.append(" and sgmilestonename ='" + milestoneName + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(sgaddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(sgaddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			
			if(sort.length()<=0)			
				queryselect.append(" group by sgmilestoneid order by sgid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))queryselect.append(" group by sgmilestoneid order by sgaddedon "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("milestone"))queryselect.append(" group by sgmilestoneid order by sgmilestonename "+order+" limit "+((page-1)*rows)+","+rows);
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllstepGuide" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllstepGuide" + e.getMessage());
			}
		}
		return newsdata;
	}
	public static int countAllstepGuide(String productKey, String milestoneName, String dateRange, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			queryselect = new StringBuffer(
					"SELECT sgid FROM step_guide where sgststus='1' and sgtoken='"
							+ token + "'");
			if (!productKey.equalsIgnoreCase("NA"))
				queryselect.append(" and sgprodkey ='" + productKey + "'");
			if (!milestoneName.equalsIgnoreCase("NA"))
				queryselect.append(" and sgmilestonename ='" + milestoneName + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(sgaddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(sgaddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			queryselect.append(" group by sgmilestoneid");
			
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();
			
			while (rsGCD != null && rsGCD.next()) {
				newsdata+=1;
			}
		} catch (Exception e) {
			log.info("countAllstepGuide" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllstepGuide" + e.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] getAllUpcomingReminders(String today, String todayDate,String time) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer(
					"SELECT srrefid,sraddedbyuid,srcontent,srreminderdate,srremindertime,srtokenno,srsalestaskkey,srsaleskey FROM salesreminderctrl where srstatus='1' and srNotificationDate!='"
							+ todayDate + "' and str_to_date(srreminderdate,'%d-%m-%Y')<='" + today + "' and srremindertime='"+time+"'");

//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllUpcomingReminders" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllUpcomingReminders" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] get3DueProjects(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer("SELECT * FROM managesalesctrl where msworkpercent='100' and mstoken='"
					+ token
					+ "' and msstatus='1' and exists(select cbuid from hrmclient_billing where cbinvoiceno=msinvoiceno and cbdueamount>0 and mstoken=cbtokenno) order by msid desc limit 3");
//				System.out.println("SELECT * FROM managesalesctrl where msworkpercent='100' and mstoken='"+token+"' and msstatus='1' and exists(select cbuid from hrmclient_billing where cbinvoiceno=msinvoiceno and cbdueamount>0 and mstoken=cbtokenno) order by msid desc limit 5");
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("get3DueProjects" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("get3DueProjects" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] get5UpcomingTask(String role, String uaid, String teamKey, String token, String today) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = new StringBuffer(
						"SELECT mamilestonename,mateammemberid,madeliverydate FROM manage_assignctrl where matokenno='"
								+ token + "' and str_to_date(madeliverydate,'%d-%m-%Y')>='" + today
								+ "' ORDER BY str_to_date(madeliverydate,'%d-%m-%Y') limit 5");
			else if (role.equals("Assistant") && !teamKey.equals("NA"))
				queryselect = new StringBuffer(
						"SELECT mamilestonename,mateammemberid,madeliverydate FROM manage_assignctrl where matokenno='"
								+ token + "' and exists(select tmid from manageteammemberctrl where tmteamrefid='"
								+ teamKey + "' and tmuseruid=mateammemberid) or mateammemberid='" + uaid
								+ "' and str_to_date(madeliverydate,'%d-%m-%Y')>='" + today
								+ "' ORDER BY str_to_date(madeliverydate,'%d-%m-%Y') limit 5");
			else
				queryselect = new StringBuffer(
						"SELECT mamilestonename,mateammemberid,madeliverydate FROM manage_assignctrl where matokenno='"
								+ token + "' and mateammemberid='" + uaid
								+ "' and str_to_date(madeliverydate,'%d-%m-%Y')>='" + today
								+ "' ORDER BY str_to_date(madeliverydate,'%d-%m-%Y') limit 5");
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("get5UpcomingTask" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("get5UpcomingTask" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllStepGuide(String product_key, String milestoneName, String token,
			String jurisdiction) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer("SELECT sgcontents,sgdocument,sgstepno FROM step_guide where sgprodkey='"
					+ product_key + "' and sgmilestonename='" + milestoneName + "' and sgjurisdiction='"+jurisdiction+"' and sgtoken='" + token
					+ "' and sgststus='1' order by sgstepno");

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllStepGuide" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllStepGuide" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllFormTemplate(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer("SELECT tkey,tname FROM manage_template where ttype='form' and ttokenno='"
					+ token + "' and tstatus='1' ");

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllFormTemplate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllFormTemplate" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllVirtualActions(String triggerKey, String uaid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer(
					"SELECT taActionMain,taActionApply,taEmailSubject,taEmailSmsBody FROM trigger_action_virtual where taTriggerKey='"
							+ triggerKey + "' and taToken='" + token + "' and taUaid='" + uaid
							+ "' order by taNumbering");

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllVirtualActions" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllVirtualActions" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllVirtualConditions(String triggerKey, String uaid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer(
					"SELECT tcConditionMain,tcConditionSub,tcConditionChild FROM trigger_condition_virtual where tcTriggerKey='"
							+ triggerKey + "' and tcToken='" + token + "' and tcUaid='" + uaid
							+ "' order by tcNumbering");

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllVirtualConditions" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllVirtualConditions" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getExpenseData(String expKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer(
					"SELECT * FROM expense_approval_ctrl where expkey='" + expKey + "' and exptoken='" + token + "'");

//						System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getExpenseData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getExpenseData" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateTaskHold(String taskkey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update manage_assignctrl set maholdstatus='2' where marefid='" + taskkey
					+ "' and matokenno='" + token + "'");

			ps = con.prepareStatement(queryselect.toString());
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateTaskHold" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateTaskHold" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTaskApproval(String taskkey, String status, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update manage_assignctrl set maapprovalstatus='" + status
					+ "' where marefid='" + taskkey + "' and matokenno='" + token + "'");

			ps = con.prepareStatement(queryselect.toString());
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateTaskApproval" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateTaskApproval" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateReminderSendDate(String key, String today, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update salesreminderctrl set srNotificationDate='" + today
					+ "' where srrefid='" + key + "' and srtokenno='" + token + "'");

			ps = con.prepareStatement(queryselect.toString());
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateReminderSendDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateReminderSendDate" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateExpiryNotificationSendDate(String marefKey, String today, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update manage_assignctrl set maExpireNotificationSendDate='" + today
					+ "' where marefid='" + marefKey + "' and matokenno='" + token + "'");

			ps = con.prepareStatement(queryselect.toString());
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateExpiryNotificationSendDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateExpiryNotificationSendDate" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean enableDisableTrigger(String tKey, String status, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update triggers set tStatus='" + status + "' where tKey='" + tKey
					+ "' and tToken='" + token + "'");

			ps = con.prepareStatement(queryselect.toString());
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("enableDisableTrigger" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("enableDisableTrigger" + e.getMessage());
			}
		}
		return flag;
	}

	public static void updateExpiredToMilestones(String today,String time) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer("update manage_assignctrl set maworkstatus='Expired',"
					+ "madate='"+today+"',matime='"+time+"' where madeliverydate!='00-00-0000' "
							+ "and maworkstarteddate!='00-00-0000' and maworkstatus!='Completed' and maworkstatus!='Unassigned' and maworkstatus!='Expired' "
							+ "and (str_to_date(madeliverydate,'%d-%m-%Y')='"+ today +"' and madeliverytime<'"+time+"')");
			ps = con.prepareStatement(queryselect.toString());
			ps.execute();
//			System.out.println("updated------------------------"+k+"\n"+queryselect);

		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateExpiredToMilestones" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("updateExpiredToMilestones" + e.getMessage());
			}
		}
	}
	public static String[][] getAllToExpiredMilestones(String today,String currentTime) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer(
					"SELECT marefid,masalesrefid,maworkstatus,madate,matime,mateammemberid FROM manage_assignctrl where madeliverydate!='00-00-0000' and maworkstarteddate!='00-00-0000' "
					+ "and maworkstatus!='Completed' and maworkstatus!='Unassigned' and maworkstatus!='Expired' and (str_to_date(madeliverydate,'%d-%m-%Y')='"+ today +"' and madeliverytime<'"+currentTime+"')");
//System.out.println(queryselect);
//			SELECT marefid,masalesrefid,maworkstatus,madate,matime,mateammemberid,madeliverydate,madeliverytime FROM manage_assignctrl 
//			where madeliverydate!='00-00-0000' and (maworkstatus!='Completed' and maworkstatus!='Unassigned' and maworkstatus!='Expired') and (str_to_date(madeliverydate,'%d-%m-%Y')<='2021-12-04' and madeliverytime<='16:12') and madate!='2021-12-04'
			
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllToExpiredMilestones" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllToExpiredMilestones" + e.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] getAllExpiredMilestones(String today) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer(
					"SELECT masalesrefid,mamilestonename,maparentteamrefid,machildteamrefid,mateammemberid,matokenno,marefid FROM manage_assignctrl where maworkstatus='Expired' and maExpireNotificationSendDate!='"
							+ today + "'");

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllExpiredMilestones" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllExpiredMilestones" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAssignedSalesKey(String assignKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer(
					"SELECT marefid,masalesrefid,mateammemberid,mamilestonerefid,"
					+ "mamilestonename,maworkpercentage,maworkstatus,mamemberassigndate,"
					+ "maworkpriority,maworkstarteddate,maworkstartpricepercentage,"
					+ "maworkstartedtime,matransferstatus FROM manage_assignctrl "
					+ "where marefid='"	+ assignKey + "' and matokenno='" + token + "' ");

//						System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllDeliverySales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllDeliverySales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllActions(String actionKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {

			queryselect = new StringBuffer(
					"SELECT taActionMain,taActionApply,taEmailSubject,taEmailSmsBody,taId  FROM trigger_action where taKey='"
							+ actionKey + "'");
			queryselect.append(" order by taId");
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllActions" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllActions" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllConditions(String conditionKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {

			queryselect = new StringBuffer(
					"SELECT tcConditionMain,tcConditionSub,tcConditionChild FROM trigger_condition where tcKey='"
							+ conditionKey + "'");
			queryselect.append(" order by tcId");
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllConditions" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllConditions" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllActiveTriggers() {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {

			queryselect = new StringBuffer(
					"SELECT tKey,tModule,tConditionKey,tActionKey,tToken FROM triggers where tStatus='1'");
			queryselect.append(" order by tId");
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllActiveTriggers" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllActiveTriggers" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllTriggers(String token,String triggerName,String triggerNo, String date_range
			,int page,int rows,String sort,String order) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		String fromDate="NA";
		String toDate="NA";

		try {
			
			 if(!date_range.equalsIgnoreCase("NA")){ fromDate=date_range.substring(0,10);
			 fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.
			 substring(0,2); toDate=date_range.substring(13);
			 toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2
			 ); }
			 
			queryselect = new StringBuffer(
					"SELECT tKey,tTriggerNo,tModule,tName,tDescription,tConditionKey,tActionKey,tAddedByUid,tDate,tStatus FROM triggers where tToken='"
							+ token + "'");
			if(!triggerName.equalsIgnoreCase("NA"))queryselect.append(" and tName='"+triggerName+"'");
			if(!triggerNo.equalsIgnoreCase("NA"))queryselect.append(" and tTriggerNo='"+triggerNo+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA"))queryselect.append(" and str_to_date(tDate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(tDate,'%d-%m-%Y')>='"+fromDate+"'");
			
			if(sort.length()<=0)			
				queryselect.append("order by tId desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))queryselect.append("order by str_to_date(tDate,'%d-%m-%Y') "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("trigger_no"))queryselect.append("order by tTriggerNo "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("name"))queryselect.append("order by tName "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("description"))queryselect.append("order by tDescription "+order+" limit "+((page-1)*rows)+","+rows);	
				
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllTriggers" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllTriggers" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countTrigger(String token,String triggerName,String triggerNo, String date_range,int status) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate="NA";
		String toDate="NA";

		try {
			
			 if(!date_range.equalsIgnoreCase("NA")){ fromDate=date_range.substring(0,10);
			 fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.
			 substring(0,2); toDate=date_range.substring(13);
			 toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2
			 ); }
			 
			queryselect = new StringBuffer(
					"SELECT count(tId ) FROM triggers where tToken='"
							+ token + "' and tStatus='"+status+"'");
			if(!triggerName.equalsIgnoreCase("NA"))queryselect.append(" and tName='"+triggerName+"'");
			if(!triggerNo.equalsIgnoreCase("NA"))queryselect.append(" and tTriggerNo='"+triggerNo+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA"))queryselect.append(" and str_to_date(tDate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(tDate,'%d-%m-%Y')>='"+fromDate+"'");
			
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countTrigger" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countTrigger" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static int countAllTriggers(String token,String triggerName,String triggerNo, String date_range) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate="NA";
		String toDate="NA";

		try {
			
			 if(!date_range.equalsIgnoreCase("NA")){ fromDate=date_range.substring(0,10);
			 fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.
			 substring(0,2); toDate=date_range.substring(13);
			 toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2
			 ); }
			 
			queryselect = new StringBuffer(
					"SELECT count(tId ) FROM triggers where tToken='"
							+ token + "'");
			if(!triggerName.equalsIgnoreCase("NA"))queryselect.append(" and tName='"+triggerName+"'");
			if(!triggerNo.equalsIgnoreCase("NA"))queryselect.append(" and tTriggerNo='"+triggerNo+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA"))queryselect.append(" and str_to_date(tDate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(tDate,'%d-%m-%Y')>='"+fromDate+"'");
			
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countAllTriggers" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllTriggers" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllApprovalExpense(String token, String date_range,int page,
			int rows,String sort,String order,String expClientName,String expContactMobile) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";

		try {
			if (!date_range.equalsIgnoreCase("NA")) {
				fromDate = date_range.substring(0, 10);
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = date_range.substring(13);
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			queryselect = new StringBuffer(
					"SELECT expkey,expdate,expclientname,expclientmobile,expamount,expcategory,exphsn,expdepartment,expaccount,expnotes,expaddedbyuid,expapprovalstatus,expsaleskey,exptaskkey FROM expense_approval_ctrl where exptoken='"
							+ token + "'");
			if(!expClientName.equalsIgnoreCase("NA"))queryselect.append(" and expclientname='"+expClientName+"'");
			if(!expContactMobile.equalsIgnoreCase("NA"))queryselect.append(" and expclientmobile='"+expContactMobile+"'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA"))
				queryselect.append(" and str_to_date(expdate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(expdate,'%d-%m-%Y')>='" + fromDate + "'");
			if(sort.length()<=0)			
				queryselect.append(" order by expid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))queryselect.append(" order by str_to_date(expdate,'%d-%m-%Y') "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("client"))queryselect.append(" order by expclientname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("phone"))queryselect.append(" order by expclientmobile "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("amount"))queryselect.append(" order by expamount "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("category"))queryselect.append(" order by expcategory "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("department"))queryselect.append(" order by expdepartment "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("account"))queryselect.append(" order by expaccount "+order+" limit "+((page-1)*rows)+","+rows);	
				
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllApprovalExpense" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllApprovalExpense" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllApprovalExpense(String token, String date_range,String expClientName,String expContactMobile) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";

		try {
			if (!date_range.equalsIgnoreCase("NA")) {
				fromDate = date_range.substring(0, 10);
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = date_range.substring(13);
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			queryselect = new StringBuffer(
					"SELECT count(expid) FROM expense_approval_ctrl where exptoken='"
							+ token + "'");
			if(!expClientName.equalsIgnoreCase("NA"))queryselect.append(" and expclientname='"+expClientName+"'");
			if(!expContactMobile.equalsIgnoreCase("NA"))queryselect.append(" and expclientmobile='"+expContactMobile+"'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA"))
				queryselect.append(" and str_to_date(expdate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(expdate,'%d-%m-%Y')>='" + fromDate + "'");
			
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countAllApprovalExpense" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllApprovalExpense" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countPaymentApproval(String token, String date) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		
		try {
			
			queryselect = new StringBuffer(
					"SELECT count(sid) FROM salesestimatepayment where stokenno='"
							+ token + "' and stransactionstatus='2' and str_to_date(saddeddate,'%d-%m-%Y')<='"+date+"'");
			
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countPaymentApproval" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countPaymentApproval" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static int countApprovalExpense(String token, String date) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		
		try {
			
			queryselect = new StringBuffer(
					"SELECT count(expid) FROM expense_approval_ctrl where exptoken='"
							+ token + "' and expapprovalstatus='2' and str_to_date(expdate,'%d-%m-%Y')<='"+date+"'");
			
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countApprovalExpense" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countApprovalExpense" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllMilestones(String uaid, String token, String date_range) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";

		try {
			if (!date_range.equalsIgnoreCase("NA")) {
				fromDate = date_range.substring(0, 10);
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = date_range.substring(13);
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			queryselect = new StringBuffer(
					"SELECT marefid,masalesrefid,mamilestonerefid,mamilestonename,maworkpercentage,maworkstarteddate,maworkstatus,madeliverydate FROM manage_assignctrl where mateammemberid='"
							+ uaid + "' and maworkpercentage!='100' and maworkstarteddate!='00-00-0000' and matokenno='"
							+ token
							+ "' and masaleshierarchystatus='1' and mahierarchyactivestatus='1' and maapprovalstatus='1' and mastepstatus='1' and mamemberassigndate!='00-00-0000' ");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA"))
				queryselect.append(" and str_to_date(mamemberassigndate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(mamemberassigndate,'%d-%m-%Y')>='" + fromDate + "'");
			queryselect.append(" order by FIELD(maworkstatus,'New','Open','Pending','Expired','On-Hold','Completed')");
//						System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllDeliverySales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllDeliverySales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAssignedTask(String userRole, String loginuaid, String token, 
			String today,String myTaskDoAction, String myTaskClientKeyAction, 
			String dateRange,String contact_name,int page,int rows,String sort,	String order,String service) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			today = today.substring(6) + "-" + today.substring(3, 5) + "-" + today.substring(0, 2);
			if (userRole == null || userRole.equalsIgnoreCase("NA") || userRole.length() <= 0)
				userRole = "NA";
			queryselect = new StringBuffer(
					"SELECT ma.marefid,ma.masalesrefid,ma.mateammemberid,ma.mamilestonerefid,"
					+ "ma.mamilestonename,ma.maworkpercentage,ma.maworkstatus,"
					+ "ma.mamemberassigndate,ma.maworkpriority,ma.maworkstartpricepercentage,"
					+ "cb.cbname,ms.msinvoiceno,ms.mscompany,ms.msproductname FROM manage_assignctrl ma INNER JOIN managesalesctrl ms on "
					+ "ma.masalesrefid=ms.msrefid INNER JOIN contactboxctrl cb on "
					+ "ms.mscontactrefid=cb.cbrefid where ma.masaleshierarchystatus='1' "
					+ "and ma.mahierarchyactivestatus='1' and ma.maapprovalstatus='1' "
					+ "and ma.mastepstatus='1' and ma.mateammemberid!='NA' and ma.matokenno='"
					+ token + "' and ma.maworkstarteddate!='00-00-0000' ");
			if (!userRole.equalsIgnoreCase("NA") && (userRole.equalsIgnoreCase("Assistant")
					|| userRole.equalsIgnoreCase("Manager") || userRole.equalsIgnoreCase("Executive"))) {
				queryselect.append(" and ma.mateammemberid='" + loginuaid
						+ "' and ma.mamemberassigndate!='00-00-0000' and str_to_date(ma.mamemberassigndate,'%d-%m-%Y')<='"
						+ today + "' ");
			}
			if (!myTaskDoAction.equalsIgnoreCase("NA") && !myTaskDoAction.equalsIgnoreCase("All")) {
				queryselect.append(" and ma.maworkstatus='" + myTaskDoAction + "' ");
			}				
			if (!service.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msproductname='" + service + "' ");
			
			if (!myTaskClientKeyAction.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msclientrefid='" + myTaskClientKeyAction + "' ");
			if (!contact_name.equalsIgnoreCase("NA"))
				queryselect.append(" and cb.cbname='" + contact_name + "' ");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(
						" and ma.mamemberassigndate!='00-00-0000' and str_to_date(ma.mamemberassigndate,'%d-%m-%Y')<='"
								+ toDate + "' and str_to_date(ma.mamemberassigndate,'%d-%m-%Y')>='" + fromDate + "' ");
			}			
			queryselect.append("group by ma.maid ");
			
			if(!myTaskDoAction.equalsIgnoreCase("NA") && !myTaskDoAction.equalsIgnoreCase("All"))
				queryselect.append("order by ma.maworkstatus limit "+((page-1)*rows)+","+rows);
			else
				queryselect.append("order by FIELD(ma.maworkstatus,'New','Open','Pending','Expired','On-Hold','Completed') limit "+((page-1)*rows)+","+rows);
			
			if(sort.length()>0)				
				if(sort.equals("product"))queryselect.append("order by ms.msproductname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("status"))queryselect.append("order by ma.maworkstatus "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("task"))queryselect.append("order by ma.mamilestonename "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("assigned"))queryselect.append("order by str_to_date(ma.maworkstarteddate,'%d-%m-%Y') "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("priority"))queryselect.append("order by ma.maworkpriority "+order+" limit "+((page-1)*rows)+","+rows);	
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
		} catch (Exception e) {e.printStackTrace();
			log.info("getAllDeliverySales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllDeliverySales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAssignedTask(String userRole, String loginuaid, String token, String today,
			String myTaskDoAction, String myTaskClientKeyAction, String dateRange,String contact_name,String service) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			today = today.substring(6) + "-" + today.substring(3, 5) + "-" + today.substring(0, 2);
			if (userRole == null || userRole.equalsIgnoreCase("NA") || userRole.length() <= 0)
				userRole = "NA";
			queryselect = new StringBuffer(
					"SELECT ma.maid FROM manage_assignctrl ma INNER JOIN managesalesctrl ms on ma.masalesrefid=ms.msrefid "
					+ "INNER JOIN contactboxctrl cb on ms.mscontactrefid=cb.cbrefid where ma.masaleshierarchystatus='1' and "
					+ "ma.mahierarchyactivestatus='1' and ma.maapprovalstatus='1' and ma.mastepstatus='1' and ma.mateammemberid!='NA' and ma.matokenno='"
							+ token + "' and ma.maworkstarteddate!='00-00-0000' ");
			if (!userRole.equalsIgnoreCase("NA") && (userRole.equalsIgnoreCase("Assistant")
					|| userRole.equalsIgnoreCase("Manager") || userRole.equalsIgnoreCase("Executive"))) {
				queryselect.append(" and ma.mateammemberid='" + loginuaid
						+ "' and ma.mamemberassigndate!='00-00-0000' and str_to_date(ma.mamemberassigndate,'%d-%m-%Y')<='"
						+ today + "'");
			}
			if (!myTaskDoAction.equalsIgnoreCase("NA") && !myTaskDoAction.equalsIgnoreCase("All")) {
				queryselect.append(" and ma.maworkstatus='" + myTaskDoAction + "'");
			}
			
			if (!service.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msproductname='" + service + "' ");
			
			if (!myTaskClientKeyAction.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msclientrefid='" + myTaskClientKeyAction + "'");
			if (!contact_name.equalsIgnoreCase("NA"))
				queryselect.append(" and cb.cbname='" + contact_name + "' ");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(
						" and ma.mamemberassigndate!='00-00-0000' and str_to_date(ma.mamemberassigndate,'%d-%m-%Y')<='"
								+ toDate + "' and str_to_date(ma.mamemberassigndate,'%d-%m-%Y')>='" + fromDate + "'");
			}
			queryselect.append("group by ma.maid ");
			
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();
			
			while (rsGCD != null && rsGCD.next()) {
				newsdata+=1;
			}
		} catch (Exception e) {
			log.info("countAssignedTask" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAssignedTask" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static boolean deleteLicenceRenewal(String uuid,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from licence_renewal where uuid =? and token=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, uuid);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("deleteLicenceRenewal" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("deleteLicenceRenewal" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean removeTriggerCondition(String id) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from trigger_condition where tcId =?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, id);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("removeTriggerCondition" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeTriggerCondition" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeTriggerAction(String id) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from trigger_action where taId  =?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, id);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("removeTriggerAction" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeTriggerAction" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean deleteSalesHierarchy(String token, String addedby) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from saleshierarchy_virtual where shtoken=? and shaddedby=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, token);
			ps.setString(2, addedby);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("deleteSalesHierarchy" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("deleteSalesHierarchy" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean resetSalesHierarchy(String invoice,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from saleshierarchymanagectrl where shminvoice=? and shmtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, invoice);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("resetSalesHierarchy" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("resetSalesHierarchy" + e.getMessage());
			}
		}
		return flag;
	}
	public static boolean resetSalesWorkPrice(String invoice,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from salesworkpricectrl where swinvoiceno=? and swtokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, invoice);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("resetSalesWorkPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("resetSalesWorkPrice" + e.getMessage());
			}
		}
		return flag;
	}
	public static boolean resetMainSalesWorkPrice(String invoice,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from salesmainworkpricectrl where smwinvoice=? and smwtokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, invoice);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("resetMainSalesWorkPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("resetMainSalesWorkPrice" + e.getMessage());
			}
		}
		return flag;
	}
	public static boolean resetTaskNotification(String invoice,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from task_notification where tninvoiceno=? and tntokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, invoice);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("resetTaskNotification" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("resetTaskNotification" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean resetLicenceRenewal(String salesKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from licence_renewal where saleskey=? and token=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("resetLicenceRenewal" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("resetLicenceRenewal" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean removeFollowUp(String salesKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from hrmproject_followup where pfsaleskey=? and pftokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("removeFollowUp" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeFollowUp" + e.getMessage());
			}
		}
		return flag;
	}
	public static String getParentKey(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select shmparentrefid from saleshierarchymanagectrl where shmsalesrefid=? and shmtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getParentKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getParentKey" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isThisSaleParent(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean data = false;
		try {
			String queryselect = "SELECT shmhierarchytype FROM saleshierarchymanagectrl "
					+ "WHERE shmsalesrefid=?"
					+ " and shmtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				if(rs.getString(1).equalsIgnoreCase("parent"))
				data = true;
			}
		} catch (Exception e) {
			log.info("isThisSaleParent" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isThisSaleParent" + e.getMessage());
			}
		}
		return data;
	}
	
	public static boolean isThisSaleDispersed(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean data = false;
		try {
			String queryselect = "select smwid from salesmainworkpricectrl where smwsaleskey=? and smwtokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = true;
			}
		} catch (Exception e) {
			log.info("isThisSaleDispersed" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isThisSaleDispersed" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isSalesHierarchyDone(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean data = false;
		try {
			String queryselect = "select shmid from saleshierarchymanagectrl where shminvoice=? and shmtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, invoice);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = true;
			}
		} catch (Exception e) {
			log.info("isSalesHierarchyDone" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isSalesHierarchyDone" + e.getMessage());
			}
		}
		return data;
	}
	
	public static boolean isSalesHierarchyDoneBySalesKey(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean data = false;
		try {
			String queryselect = "select shmid from saleshierarchymanagectrl where shmsalesrefid=? and shmtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = true;
			}
		} catch (Exception e) {
			log.info("isSalesHierarchyDoneBySalesKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isSalesHierarchyDoneBySalesKey" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isProjectCompleted(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean data = false;
		try {
			String queryselect = "select msid from managesalesctrl where msworkpercent=? and mstoken=? and msrefid=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, "100");
			ps.setString(2, token);
			ps.setString(3, salesKey);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = true;
			}
		} catch (Exception e) {
			log.info("isProjectCompleted" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isProjectCompleted" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isAmountDispersed(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean data = false;
		try {
			String queryselect = "select swid from salesworkpricectrl where swsaleskey=? and swtokenno=? limit 1";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = true;
			}
		} catch (Exception e) {
			log.info("isAmountDispersed" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isAmountDispersed" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean getFirstStep(String salesKey, int step, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean data = false;
		try {
			String queryselect = "select smid from salesmilestonectrl where smsalesrefid=? and smstep=? and smtoken=? limit 1";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setInt(2, step);
			ps.setString(3, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = false;
			} else {
				data = true;
			}
		} catch (Exception e) {
			log.info("getFirstStep" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getFirstStep" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isHierarchySet(String invoiceno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean data = false;
		try {
			String queryselect = "select count(shmid) from saleshierarchymanagectrl where shminvoice=? and shmtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, invoiceno);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				int k = rs.getInt(1);
				if (k>0)
					data = true;
			}
		} catch (Exception e) {
			log.info("isHierarchySet" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isHierarchySet" + e.getMessage());
			}
		}
		return data;
	}

	public static String getSalesDependencyStatus(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "2#2";
		try {
			String queryselect = "select shmhierarchytype,shmhierarchyholdstatus from saleshierarchymanagectrl where shmsalesrefid=? and shmtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesrefid);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				if (rs.getString(1).equalsIgnoreCase("parent")) {
					data = "1#";
				} else if (rs.getString(1).equalsIgnoreCase("child")) {
					data = "2#";
				}
				data = data + rs.getString(2);
			}
		} catch (Exception e) {
			log.info("getSalesDependencyStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getSalesDependencyStatus" + e.getMessage());
			}
		}
		return data;
	}

	public static String getOldFileName(String fileKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select sddocname from salesdocumentctrl where sdrefid=? and sdtokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, fileKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getOldFileName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getOldFileName" + e.getMessage());
			}
		}
		return data;
	}

	public static String teamKeyByLeaderUaidAnddepartment(String uaid, String department, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select mtrefid from manageteamctrl where mtdepartment=? and mtadminid=? and mttoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, department);
			ps.setString(2, uaid);
			ps.setString(3, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("teamKeyByLeaderUaidAnddepartment" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("teamKeyByLeaderUaidAnddepartment" + e.getMessage());
			}
		}
		return data;
	}

	public static String getTeamKey(String groupName, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select mtrefid from manageteamctrl where mtteamname=? and mttoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, groupName);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getTeamKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getTeamKey" + e.getMessage());
			}
		}
		return data;
	}

	public static String getTeamName(String teamrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select mtteamname from manageteamctrl where mtrefid=? and mttoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, teamrefid);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getTeamName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getTeamName" + e.getMessage());
			}
		}
		return data;
	}

	public static String getSalesProductKey(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select smprodrefid from salesmilestonectrl where smsalesrefid=? and smtoken=? limit 1";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesrefid);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesProductKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getSalesProductKey" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String[] getProductNameAndKey(String product_key, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[2];
		try {
			String queryselect = "select smprodrefid,smmilestonename from salesmilestonectrl where smrefid=? and smtoken=?";
//			System.out.println(queryselect+"\n"+product_key);
			ps = con.prepareStatement(queryselect);
			ps.setString(1, product_key);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
			}
		} catch (Exception e) {
			log.info("getProductNameAndKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getProductNameAndKey" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String[] getSalesName(String estno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[2];
		try {
			String queryselect = "select esprodname,escompany from estimatesalectrl where essaleno=? and estoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, estno);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
			}
		} catch (Exception e) {
			log.info("getSalesName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getSalesName" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String getSalesPayType(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "100";
		try {
			String queryselect = "select smpaytype from salesmilestonectrl where smsalesrefid=? and smtoken=? limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesPayType" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getSalesPayType" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String getWorkPricePercentage(String product_key,String milestone, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "100";
		try {
			String queryselect = "select pm_pricepercent from product_milestone where pm_prodrefid=? and pm_milestonename=? and pm_tokeno=?";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			ps.setString(1, product_key);
			ps.setString(2, milestone);
			ps.setString(3, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getWorkPricePercentage" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getWorkPricePercentage" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String getSalesProductName(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select msproductname from managesalesctrl where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesrefid);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesProductName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getSalesProductName" + e.getMessage());
			}
		}
		return data;
	}

	public static String isHierarchyExist(String salesrefid, String token, String addedby) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select shrefid from saleshierarchy_virtual where shsalesrefid=? and shtoken=? and shaddedby=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesrefid);
			ps.setString(2, token);
			ps.setString(3, addedby);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("isHierarchyExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isHierarchyExist" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isMilestoneStepExist(String prodkey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			String queryselect = "select mvid from milestonevirtualctrl where mvprodrefid=? and mvtoken=? and mvstep='0' limit 1";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, prodkey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("isMilestoneStepExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isMilestoneStepExist" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean isProductDocumentExist(String prodkey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			String queryselect = "select pdid from product_documents where pd_prodrefid=? and pd_token=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, prodkey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("isProductDocumentExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isProductDocumentExist" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean isProductMilestoneExist(String prodkey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			String queryselect = "select pmid from product_milestone where pm_prodrefid=? and pm_tokeno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, prodkey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("isProductMilestoneExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isProductMilestoneExist" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean isMilestoneExist(String prodkey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			String queryselect = "select mvid from milestonevirtualctrl where mvprodrefid=? and mvtoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, prodkey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("isMilestoneExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isMilestoneExist" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean isEditTeamExist(String teamname, String teamrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			String queryselect = "select mtid from manageteamctrl where mtteamname=? and mttoken=? and mtrefid!=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, teamname);
			ps.setString(2, token);
			ps.setString(3, teamrefid);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("isEditTeamExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isEditTeamExist" + e.getMessage());
			}
		}
		return flag;
	}

	public static String getAssignedMemberId(String assignKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select mateammemberid from manage_assignctrl where marefid=? and matokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, assignKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getAssignedMemberId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getAssignedMemberId" + e.getMessage());
			}
		}
		return data;
	}

	public static String isTaskAlreadyAssigned(String assignKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select mateammemberid from manage_assignctrl where marefid=? and matokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, assignKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("isTaskAlreadyAssigned" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isTaskAlreadyAssigned" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isFolderExist(String name, String token, String loginuaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			String queryselect = "select fname from folder_master where ftokenno=? and fname=? and floginuaid='"
					+ loginuaid + "'";

			ps = con.prepareStatement(queryselect);
			ps.setString(1, token);
			ps.setString(2, name);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("isFolderExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isFolderExist" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean isTeamExist(String teamname, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			String queryselect = "select mtid from manageteamctrl where mtteamname=? and mttoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, teamname);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("isTeamExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isTeamExist" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean isProductTypeExist(String prodtype, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			String queryselect = "select sid from service_type where stypename=? and stokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, prodtype);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("isProductTypeExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isProductTypeExist" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeNotification(String notficationKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update notifications set nJobStatus='2' where nKey='" + notficationKey
					+ "' and nToken='" + token + "'";
			ps = con.prepareStatement(queryselect);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removeNotification" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeNotification" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateAssignStepStatus(String salesKey, String milestoneKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update manage_assignctrl set mastepstatus='1' where masalesrefid='" + salesKey
					+ "' and mamilestonerefid='" + milestoneKey + "' and matokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateAssignStepStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateAssignStepStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateDispersedAmount(String invoiceNo, double dispersedAmt, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update hrmclient_billing set cbsalesdispersedamt=cbsalesdispersedamt+" + dispersedAmt
					+ " where cbinvoiceno='" + invoiceNo + "' and cbtokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateDispersedAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateDispersedAmount" + e.getMessage());
			}
		}
		return flag;
	}
	public static boolean resetDispersedAmount(String invoice, double dispersedAmt, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update hrmclient_billing set cbsalesdispersedamt=? where cbinvoiceno=? and cbtokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, "0");
			ps.setString(2, invoice);
			ps.setString(3, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("resetDispersedAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("resetDispersedAmount" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean extendMilestoneDeliveryDate(long days, String milestoneKey, 
			String token,long totalMinutes) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update salesmilestonectrl set smtimelineextendeddays=smtimelineextendeddays+" + days
					+ ",smtimelineextendedminutes=smtimelineextendedminutes+"+totalMinutes
					+" where smrefid=? and smtoken=?";
//			System.out.println(queryselect);
			
			ps = con.prepareStatement(queryselect);
			ps.setString(1, milestoneKey);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("extendMilestoneDeliveryDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("extendMilestoneDeliveryDate" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean checkClientNotRepliedStatus(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		try {
			String queryselect = "select msid from managesalesctrl where msrefid=? and mschatnotreplied=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesrefid);
			ps.setString(2, "0");
			ps.setString(3, token);
			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("checkClientNotRepliedStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("checkClientNotRepliedStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static void closeProject(String salesrefId, String token, String closeDate) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		try {
			String queryselect = "update managesalesctrl set project_close_date=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, closeDate);
			ps.setString(2, salesrefId);
			ps.setString(3, token);

			ps.executeUpdate();

		} catch (Exception e) {
			log.info("closeProject" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("closeProject" + e.getMessage());
			}
		}

	}

	public static boolean updateChatNOtReply(String salesrefid, String today, String token,String time) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update managesalesctrl set mschatnotreplied=" + 1
					+ ",mschatnotreplydate=?,mschatnotreplytime=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, today);
			ps.setString(2, time);
			ps.setString(3, salesrefid);
			ps.setString(4, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateChatNOtReply" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateChatNOtReply" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateDocUploadStatus(String salesrefid, String token,String date,String time) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update managesalesctrl set doc_uploaded='1',"
					+ "document_uploaded_date=?,document_uploaded_time=?,document_status=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, date);
			ps.setString(2, time);
			ps.setInt(3, 4);
			ps.setString(4, salesrefid);
			ps.setString(5, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateDocUploadStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateDocUploadStatus" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateDocReUploadStatus(String salesrefid, String token,String reUploadStatus) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update managesalesctrl set doc_re_upload=?"
					+ " where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, reUploadStatus);
			ps.setString(2, salesrefid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateDocReUploadStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateDocReUploadStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateUnseenStatus(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update managesalesctrl set msunseenchat=msunseenchat+" + 1
					+ ",msunseenchatadmin='0' where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesrefid);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateUnseenStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateUnseenStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateMilestoneStatus(String salesrefid, String milestoneKey, String status, String token,String date,String time) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update manage_assignctrl set maworkstatus=?,madate=?,matime=? where masalesrefid=? and matokenno=? and mamilestonerefid=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, status);
			ps.setString(2, date);
			ps.setString(3, time);
			ps.setString(4, salesrefid);
			ps.setString(5, token);
			ps.setString(6, milestoneKey);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
//			System.out.println(queryselect+"\n"+flag);
		} catch (Exception e) {e.printStackTrace();
			log.info("updateMilestoneStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateMilestoneStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateMilestonePriorityByKey(String mrefid, String salesrefid, String Priority,
			String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update manage_assignctrl set maworkpriority=? where masalesrefid=? and matokenno=? and marefid=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, Priority);
			ps.setString(2, salesrefid);
			ps.setString(3, token);
			ps.setString(4, mrefid);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateMilestonePriorityByKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateMilestonePriorityByKey" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateMilestonePriority(String salesrefid, String Priority, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update manage_assignctrl set maworkpriority=? where masalesrefid=? and matokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, Priority);
			ps.setString(2, salesrefid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateMilestonePriority" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateMilestonePriority" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateSalesPriority(String salesrefid, String Priority, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update managesalesctrl set msworkpriority=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, Priority);
			ps.setString(2, salesrefid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateSalesPriority" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateSalesPriority" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateSalesDocument1(String docKey, String imgename, String today, String token,
			String loginuaid, String assignKey, String workStartPrice) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update salesdocumentctrl set sddocname=?,sduploaddate=?,sduploadedby=?,sdmilestoneuuid=?,sdmilestoneworkpercentage=? where sdrefid=? and sdtokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, imgename);
			ps.setString(2, today);
			ps.setString(3, loginuaid);
			ps.setString(4, assignKey);
			ps.setString(5, workStartPrice);
			ps.setString(6, docKey);
			ps.setString(7, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateSalesDocument" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateSalesDocument" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateAssigne(String salesrefid, String teamname, String teamrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update managesalesctrl set msassignedtoname=?,msassignedtorefid=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, teamname);
			ps.setString(2, teamrefid);
			ps.setString(3, salesrefid);
			ps.setString(4, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateAssigne" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateAssigne" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateAssignTaskDeliveryDate(String salesKey, String milestoneKey, String deliveryDate,
			String token,String deliveryTime) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update manage_assignctrl set madeliverydate=?,madeliverytime=? where masalesrefid=? and mamilestonerefid=? and matokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, deliveryDate);
			ps.setString(2, deliveryTime);
			ps.setString(3, salesKey);
			ps.setString(4, milestoneKey);
			ps.setString(5, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateAssignTaskDeliveryDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateAssignTaskDeliveryDate" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateAssignTaskHierarchyStatus(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update manage_assignctrl set masaleshierarchystatus=? where masalesrefid=? and matokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, "1");
			ps.setString(2, salesrefid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateAssignTaskHierarchyStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateAssignTaskHierarchyStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateAssignTaskHierarchyActiveStatus(String salesrefid, 
			String status, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update manage_assignctrl set mahierarchyactivestatus=? where masalesrefid=? and matokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, status);
			ps.setString(2, salesrefid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateAssignTaskHierarchyActiveStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateAssignTaskHierarchyActiveStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateSalesActiveStatus(String salesrefid, String status, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update managesalesctrl set msworkstatus=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, status);
			ps.setString(2, salesrefid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateSalesActiveStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateSalesActiveStatus" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateSalesDocumentStatus(String salesId, String status, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update managesalesctrl set document_status=? where msid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, status);
			ps.setString(2, salesId);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateSalesDocumentStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateSalesDocumentStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateSalesVirtualHierarchy(String refid, String salesrefid, String type, String numbering,
			String salesinvoice, String token, String addedby) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update saleshierarchy_virtual set shsalesrefid=?,shsalesinvoice=?,shtype=?,shnumbering=? where shrefid=? and shtoken=? and shaddedby=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesrefid);
			ps.setString(2, salesinvoice);
			ps.setString(3, type);
			ps.setString(4, numbering);
			ps.setString(5, refid);
			ps.setString(6, token);
			ps.setString(7, addedby);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateSalesVirtualHierarchy" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateSalesVirtualHierarchy" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateDescription(String prodrefid, String token, String remarks,
			String central,String state,String global,int tatValue,String tatType) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update product_master set pdescription=?,pcentral=?,pstate=?,pglobal=?,tat_value=?,tat_type=? "
					+ "where prefid=? and ptokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, remarks);
			ps.setString(2, central);
			ps.setString(3, state);
			ps.setString(4, global);
			ps.setInt(5, tatValue);
			ps.setString(6, tatType);
			ps.setString(7, prodrefid);
			ps.setString(8, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateDescription" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateDescription" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean clearTaxTotal(String uid, String val) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update product_price set pp_total_price='" + val + "' where ppid='" + uid + "' ";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("clearTaxTotal" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("clearTaxTotal" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateMainTaxDetails(String uid, String token, String hsn, String sgst, String cgst,
			String igst) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update product_price set pp_cgstpercent='" + cgst + "',pp_sgstpercent='" + sgst
					+ "',pp_igstpercent='" + igst + "',pp_hsncode='" + hsn + "' where ppid='" + uid
					+ "' and pp_tokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateMainTaxDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateMainTaxDetails" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTaxDetails(String prodrefid, String rowid, String token, String sgst, String cgst,
			String igst) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update productpricevirtual set ppvcgstpercent='" + cgst + "',ppvsgstpercent='" + sgst
					+ "',ppvigstpercent='" + igst + "' where ppvproductrefid='" + prodrefid + "' and ppvtextboxid='"
					+ rowid + "' and ppvtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateTaxDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateTaxDetails" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean clearTaxTotal(String prodrefid, String rowid, String token, String val) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "update productpricevirtual set ppvtotalprice='" + val + "' where ppvproductrefid='"
					+ prodrefid + "' and ppvtextboxid='" + rowid + "' and ppvtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("clearTaxTotal" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("clearTaxTotal" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean deleteVirtualMember(String memberrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM virtualteammemberctrl where vttoken='" + token + "' and vtrefid='"
					+ memberrefid + "' ";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("deleteVirtualMember" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("deleteVirtualMember" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean deleteMember(String memberrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM manageteammemberctrl where tmtoken='" + token + "' and tmrefid='"
					+ memberrefid + "' ";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("deleteMember" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("deleteMember" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean clearVirtualMemberTable(String token, String addedby) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM virtualteammemberctrl where vttoken='" + token + "' and vtaddedby='"
					+ addedby + "' ";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("clearVirtualMemberTable" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("clearVirtualMemberTable" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeMainDocumentRow(String uid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM product_documents where pdid='" + uid + "' ";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removeMainDocumentRow" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeMainDocumentRow" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeDocumentRow(String prodrefid, String rowid, String token, String addedby) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM documentvirtualctrl where dvprodrefid='" + prodrefid + "' and dvrowid='"
					+ rowid + "' and dvtoken='" + token + "' and dvaddedby='" + addedby + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removeDocumentRow" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeDocumentRow" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeMainMilestoneRow(String uid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM product_milestone where pmid='" + uid + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removeMainMilestoneRow" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeMainMilestoneRow" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeTaskChat(String TaskKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM task_notification where tnrefid='" + TaskKey + "' and tntokenno='" + token
					+ "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removeTaskChat" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeTaskChat" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeMilestoneRow(String prodrefid, String rowid, String token, String addedby) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM milestonevirtualctrl where mvprodrefid='" + prodrefid + "' and mvrowid='"
					+ rowid + "' and mvtoken='" + token + "' and mvaddedby='" + addedby + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removeMilestoneRow" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeMilestoneRow" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeMainPriceRow(String uid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM product_price where ppid='" + uid + "' and pp_tokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removeMainPriceRow" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeMainPriceRow" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removePriceRow(String prodrefid, String rowid, String token, String addedby) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete FROM productpricevirtual where ppvproductrefid='" + prodrefid
					+ "' and ppvtextboxid='" + rowid + "' and ppvtoken='" + token + "' and ppvaddedby='" + addedby
					+ "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removePriceRow" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removePriceRow" + e.getMessage());
			}
		}
		return flag;
	}

	public static String isDispersedDueAmountDue(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "Yes";
		try {
			String queryselect = "SELECT smworderamount,smwpricedispersed FROM salesmainworkpricectrl where smwsaleskey='"
					+ salesKey + "' and smwtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				if (rset.getDouble(1) - rset.getDouble(2) == 0) {
					getinfo = "No";
				}
			}
		} catch (Exception e) {
			log.info("isDispersedDueAmountDue" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isDispersedDueAmountDue" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getSalesDueAmount(String role, String uaid, String teamKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		String queryselect = "";
		try {

			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select h.cbdueamount from hrmclient_billing h join managesalesctrl s on s.msinvoiceno=h.cbinvoiceno where s.mstoken='"
						+ token + "' group by s.msinvoiceno";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "select h.cbdueamount from hrmclient_billing h join managesalesctrl s on s.msinvoiceno=h.cbinvoiceno where s.mstoken='"
						+ token + "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=s.mssoldbyuid) or s.mssoldbyuid='" + uaid + "' group by s.msinvoiceno";
			} else {
				queryselect = "select h.cbdueamount from hrmclient_billing h join managesalesctrl s on s.msinvoiceno=h.cbinvoiceno where s.mstoken='"
						+ token + "' and s.mssoldbyuid='" + uaid + "' group by s.msinvoiceno";
			}

//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo += rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesDueAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesDueAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double findSalesAmount(String invoiceNo,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(cborderamount) FROM hrmclient_billing where (cbinvoiceno='"+invoiceNo+"' "
					+ "or cbestimateno='"+invoiceNo+"') and cbtokenno='"+token+ "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("findSalesAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findSalesAmount" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static double getSalesDueAmount(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(cbdueamount) FROM hrmclient_billing where cbtokenno='" + token
					+ "' and cbinvoiceno!='NA'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesDueAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesDueAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getApprovalPayment(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(stransactionamount) FROM salesestimatepayment where stokenno='" + token
					+ "' and stransactionstatus='2'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getApprovalPayment" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getApprovalPayment" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getTotalWorkCompletedPercentage(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(maworkpercentage) FROM manage_assignctrl where masalesrefid='" + salesKey
					+ "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getTotalWorkCompletedPercentage" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalWorkCompletedPercentage" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getTotalWorkCompletedPercentageNotThis(String salesKey, String token, String marefid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(maworkpercentage) FROM manage_assignctrl where marefid!='" + marefid
					+ "' and masalesrefid='" + salesKey + "' and matokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getTotalWorkCompletedPercentageNotThis" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalWorkCompletedPercentageNotThis" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double[] getOrderDueAmount(String invoiceno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo[] = new double[3];
		try {
			String queryselect = "SELECT cborderamount,cbpaidamount,cbdiscount FROM hrmclient_billing where cbinvoiceno='"
					+ invoiceno + "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo[0] = rset.getDouble(1) - rset.getDouble(2);
				getinfo[1] = rset.getDouble(3);
				getinfo[2] = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getOrderDueAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getOrderDueAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getPaidAmount(String estimateNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT cbpaidamount FROM hrmclient_billing where cbestimateno='" + estimateNo
					+ "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getPaidAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getPaidAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getSalesDiscount(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT cbdiscount FROM hrmclient_billing where (cbinvoiceno='" + invoice
					+ "' or cbestimateno='"+invoice+"') and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesDiscount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesDiscount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getSalesPaidAmount(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT cbpaidamount FROM hrmclient_billing where cbinvoiceno='" + invoice
					+ "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesPaidAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesPaidAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double[] getSalesOrderAndPaidAmountByInvoice(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo[] =new double[2];
		try {
			String queryselect = "SELECT smworderamount,smwpricedispersed FROM salesmainworkpricectrl where smwinvoice='" + invoice
					+ "' and smwtokenno='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo[0] = rset.getDouble(1);
				getinfo[1] = rset.getDouble(2);
			}
		} catch (Exception e) {
			log.info("getSalesOrderAndPaidAmountByInvoice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesOrderAndPaidAmountByInvoice" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static double[] getSalesOrderAndPaidAmount(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo[] =new double[2];
		try {
			String queryselect = "SELECT smworderamount,smwpricedispersed FROM salesmainworkpricectrl where smwsaleskey='" + salesKey
					+ "' and smwtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo[0] = rset.getDouble(1);
				getinfo[1] = rset.getDouble(2);
			}
		} catch (Exception e) {
			log.info("getSalesOrderAndPaidAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesOrderAndPaidAmount" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static double findSalesOrderAmount(String salesKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(sptotalprice) FROM salespricectrl where spsalesrefid='" +salesKey+ "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("findSalesOrderAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findSalesOrderAmount" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static double getOrderAmount(String invoiceno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT cborderamount FROM hrmclient_billing where cbinvoiceno='" + invoiceno
					+ "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getOrderAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getOrderAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getSalesDueAmount(String invoiceno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT cbdueamount FROM hrmclient_billing where (cbestimateno='"+invoiceno+"' or cbinvoiceno='"+invoiceno+"') and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesDueAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesDueAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	
	public static double getTotalInvoicePaid(String invoiceno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT cbpaidamount,cbsalesdispersedamt FROM hrmclient_billing where cbinvoiceno='"
					+ invoiceno + "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1) - rset.getDouble(2);
			}
		} catch (Exception e) {
			log.info("getTotalInvoicePaid" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalInvoicePaid" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getProductPrice(String prodrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(pp_total_price) FROM product_price where pp_prodrefid='" + prodrefid
					+ "' and pp_tokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getProductPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductPrice" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static Double getVirtualProductSalePrice(String pricekey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(spvtotalprice) FROM salesproductvirtual where spvvirtualid='" + pricekey
					+ "' and spvtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getVirtualProductSalePrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getVirtualProductSalePrice" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static Double getVirtualProductPrice(String prodrefid, String token, String addedby) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(ppvtotalprice) FROM productpricevirtual where ppvproductrefid='"
					+ prodrefid + "' and ppvtoken='" + token + "' and ppvaddedby='" + addedby + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getVirtualProductPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getVirtualProductPrice" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getTriggerNo(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT tTriggerNo FROM triggers where tToken='" + token
					+ "' order by tId desc limit 1";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getTriggerNo" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTriggerNo" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* For providing uniqueid to employee */
	public static String getuniquecode(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT pprodid FROM product_master where ptokenno='" + token
					+ "' order by pid desc limit 1";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getuniquecode" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getuniquecode" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getPricePercentage(String salesKey, int step, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT MAX(CAST(smpricepercentage AS DECIMAL)) FROM salesmilestonectrl where smsalesrefid='"
					+ salesKey + "' and smstep='" + step + "' and smtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getPricePercentage" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getPricePercentage" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getSalesWorkPayType(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT smpaytype FROM salesmilestonectrl where smsalesrefid='" + salesKey
					+ "' and smtoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesWorkPayType" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesWorkPayType" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static String getSalesWorkPercentage(String estimateNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT msworkpercent FROM managesalesctrl where msestimateno='" + estimateNo
					+ "' and mstoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesWorkPercentage" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesWorkPercentage" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getTeamLeaderId(String teamKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT mtadminid FROM manageteamctrl where mtrefid='" + teamKey + "' and mttoken='"
					+ token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getTeamLeaderId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTeamLeaderId" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getProjectAssignedData(String salesKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select maparentteamrefid from manage_assignctrl where masalesrefid='" + salesKey
					+ "' and matokenno='" + token + "' limit 1";
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			if (rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error Closing SQL Objects getProjectAssignedData: \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectAssignedData :\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[] getSalesData(String salesKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[] newsdata = new String[10];
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select msproductname,msprojectnumber,msinvoiceno,mscontactrefid,mscompany,msworkpriority,mssoldbyuid,msestimateno,project_close_date,msestkey from managesalesctrl where msrefid='"
					+ salesKey + "' and mstoken='" + token + "'";
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			if (rsGCD.next()) {
				newsdata[0] = rsGCD.getString(1);
				newsdata[1] = rsGCD.getString(2);
				newsdata[2] = rsGCD.getString(3);
				newsdata[3] = rsGCD.getString(4);
				newsdata[4] = rsGCD.getString(5);
				newsdata[5] = rsGCD.getString(6);
				newsdata[6] = rsGCD.getString(7);
				newsdata[7] = rsGCD.getString(8);
				newsdata[8] = rsGCD.getString(9);
				newsdata[9] = rsGCD.getString(10);
			}
		} catch (Exception e) {
			log.info("Error Closing SQL Objects getSalesData: \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSalesData :\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting tax details
	public static String[] getTaxByHSN(String hsn, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[] newsdata = new String[3];
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select mtsgstpercent,mtcgstpercent,mtigstpercent from managetaxctrl where mthsncode='" + hsn
					+ "' and mttoken	='" + token + "'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			if (rsGCD.next()) {
				newsdata[0] = rsGCD.getString(1);
				newsdata[1] = rsGCD.getString(2);
				newsdata[2] = rsGCD.getString(3);
			}
		} catch (Exception e) {
			log.info("Error Closing SQL Objects getTaxByHSN: \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTaxByHSN :\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllReminders(String salesrefid, String uaid, String userRole, String teamLeaderUid,
			String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT srrefid,srcontent,srreminderdate,srremindertime,srstatus,sraddedbyuid FROM salesreminderctrl WHERE srsaleskey='"
							+ salesrefid + "' and srtokenno='" + token + "'");
			if (userRole.equalsIgnoreCase("Executive")
					|| (userRole.equalsIgnoreCase("Assistant") && !teamLeaderUid.equals(uaid)))
				query.append(" and sraddedbyuid='" + uaid + "'");
			query.append(" order by srreminderdate");

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
			log.info("getAllReminders()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllReminders:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllActiveProject(String invoice, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT shmrefid,shmsalesrefid,shmsalesrefid,shmhierarchytype FROM saleshierarchymanagectrl WHERE shminvoice='"
							+ invoice + "' and shmtoken='" + token + "' and shmhierarchyholdstatus='1' order by shmid");

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
			log.info("getAllActiveProject()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllActiveProject:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllChildActiveProject(String salesKey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT shmsalesrefid FROM saleshierarchymanagectrl WHERE shmhierarchytype='child' and shmparentrefid='"
							+ salesKey + "' and shmtoken='" + token
							+ "' and shmhierarchyholdstatus='1' order by shmid");
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
			log.info("getAllChildActiveProject()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllChildActiveProject:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllParentsActiveProject(String invoice, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT shmrefid,shmsalesrefid,shmsalesrefid FROM saleshierarchymanagectrl WHERE shminvoice='"
							+ invoice + "' and shmhierarchytype='parent' and shmtoken='" + token
							+ "' and shmhierarchyholdstatus='1' order by shmid");

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
			log.info("getAllParentsActiveProject()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllParentsActiveProject:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getDocumentActionHistoryByEstimate(String estkey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("SELECT * FROM salesdochistory WHERE estsaleKey='" + estkey
					+ "' and token='" + token + "' order by id desc");

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
			log.info("getDocumentActionHistoryByEstimate()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getDocumentActionHistoryByEstimate:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getDocumentActionHistory(String salesrefid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("SELECT * FROM salesdochistory WHERE salesKey='" + salesrefid
					+ "' and token='" + token + "' order by id desc");

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
			log.info("getDocumentActionHistory()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getDocumentActionHistory:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesDocumentList(String salesrefid, String token,String type) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT sdrefid,sduploaddocname,sddescription,sduploadby,sddocname,sduploaddate,sdmilestoneworkpercentage"
					+ ",reupload_status FROM salesdocumentctrl WHERE sdsalesrefid='"
							+ salesrefid + "' and sdtokenno='" + token + "' and sduploadby='"+type+"' and sdstatus='1' order by sdid");

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
			log.info("getSalesDocumentList()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getSalesDocumentList:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllTodaysChats(String date, String salesKey, String uaid, String userRole,
			String teamLeaderUid, String token,String taskKey) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT t.tnrefid,t.tntype,t.tntypeicon,t.tndatetime,t.tnheading,t.tncontent,t.tnaddedon,t.tncontactname,t.tncontactmobile,"
					+ "t.tncontactemail,t.tnaddedbyname,t.tnmsgforname,t.tnchatstatus FROM task_notification t WHERE t.tnsalesrefid='"
							+ salesKey + "' and t.tnstatus='1' and t.tntokenno='" + token
							+ "' and t.tntype='Public Reply' and t.tndatetime like '" + date + "%'");
			
			if(taskKey.equalsIgnoreCase("NA")) {
				if (userRole.equalsIgnoreCase("Executive")
						|| (userRole.equalsIgnoreCase("Assistant") && !teamLeaderUid.equals(uaid))) {
					query.append(" and (t.tnaddedbyid='" + uaid + "' or t.tnaddedforid='"+uaid+"')");
				}
			}else
				if (userRole.equalsIgnoreCase("Executive")
						|| (userRole.equalsIgnoreCase("Assistant") && !teamLeaderUid.equals(uaid))) {
					query.append(" and (t.tnaddedbyid='" + uaid + "' or t.tnaddedforid='"+uaid+"' or "
							+ "exists(select m.maId from milestone_action_history m where m.maSalesKey='"+salesKey+"'"
							+ " and m.maTaskKey='"+taskKey+"' and m.maPrevTeamMemberUid!='NA'"
							+ " and t.tnaddedbyid=m.maPrevTeamMemberUid))");
				}
			
			query.append(" group by t.tnid order by t.tnid desc");
//			System.out.println(query);
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
		} catch (Exception e) {e.printStackTrace();
			log.info("getAllTodaysChats()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllTodaysChats:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getProjectsInternalNotes(String salesKey, String uaid, String userRole,
			String teamLeaderUid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT tnrefid,tndatetime,tnheading,tncontent,tnaddedbyname FROM task_notification WHERE tnsalesrefid='"
							+ salesKey + "' and tnstatus='1' and tntokenno='" + token
							+ "' and tntype='Internal Notes'");
			if (userRole.equalsIgnoreCase("Executive")
					|| (userRole.equalsIgnoreCase("Assistant") && !teamLeaderUid.equals(uaid)))
				query.append(" and tnaddedbyid='" + uaid + "'");
			query.append(" order by tnid desc");
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
			log.info("getProjectsInternalNotes()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getProjectsInternalNotes:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getProjectsFollowUp(String salesKey, String uaid, String userRole, String teamLeaderUid,
			String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT pfkey,pfmilestonekey,pfmilestonename,pfclientkey,pfdynamicform,pfcontent,"
					+ "pffilename,pfdate,pftime,pfsubmitstatus,pfaddedbyuid,pfaddedbyname,pfmsgforname,"
					+ "pfformsubmitstatus,pfdynamicformname FROM hrmproject_followup WHERE pfsaleskey='"
							+ salesKey + "' and pfstatus='1' and pftokenno='" + token + "'");
			if (userRole.equalsIgnoreCase("Executive")|| (userRole.equalsIgnoreCase("Assistant") && !teamLeaderUid.equals(uaid)))
				query.append(" and (pfaddedbyuid='" + uaid + "' or pfmsgforuid='"+uaid+"')");
			query.append(" order by pfuid");
//			System.out.println(query);
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
			log.info("getProjectsFollowUp()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getProjectsFollowUp:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllThread(String salesKey, String uaid, String userRole, String teamLeaderUid,
			String token, String activityType,String taskKey) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT t.tnrefid,t.tntype,t.tntypeicon,t.tndatetime,t.tnheading,t.tncontent,t.tnaddedon,"
					+ "t.tncontactname,t.tncontactmobile,t.tncontactemail,t.tnaddedbyname,t.tnsales_notification_key,t.tnaddedbyid FROM "
					+ "task_notification t WHERE t.tnsalesrefid='"
							+ salesKey + "' and t.tnstatus='1' and t.tntokenno='" + token
							+ "' and t.tntype!='Internal Notes'");
			if(taskKey.equalsIgnoreCase("NA")) {
				if (userRole.equalsIgnoreCase("Executive")
						|| (userRole.equalsIgnoreCase("Assistant") && !teamLeaderUid.equals(uaid))) {
					query.append(" and (t.tnaddedbyid='" + uaid + "' or t.tnaddedforid='"+uaid+"' or t.tnsales_notification_key!='NA')");
				}
			}else
				if (userRole.equalsIgnoreCase("Executive")
						|| (userRole.equalsIgnoreCase("Assistant") && !teamLeaderUid.equals(uaid))) {
					query.append(" and (t.tnaddedbyid='" + uaid + "' or t.tnaddedforid='"+uaid+"' or t.tnsales_notification_key!='NA' or "
							+ "exists(select m.maId from milestone_action_history m where m.maSalesKey='"+salesKey+"'"
							+ " and m.maTaskKey='"+taskKey+"' and m.maPrevTeamMemberUid!='NA'"
							+ " and t.tnaddedbyid=m.maPrevTeamMemberUid))");
				}		
			
			if (!activityType.equals("NA"))
				query.append(" and t.tntype='" + activityType + "'");
			query.append(" group by t.tnid order by t.tnid desc");
//			System.out.println(query);
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
			log.info("getAllThread()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllThread:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllSalesContacts(String cbKey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {

			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT cbname,cbemail1st,cbmobile1st FROM contactboxctrl WHERE cbrefid='" + cbKey
							+ "' and cbtokenno='" + token + "' and cbstatus='1'");

			query.append(" order by cbid");
//			System.out.println(query);
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
			log.info("getAllSalesContacts()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllSalesContacts:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllContacts(String companyName, String dateRange, String token,int page,int rows,String sort,String order) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT ccbid,ccbrefid,cccompanyname,cccontactfirstname,cccontactlastname,ccemailfirst,ccemailsecond,ccworkphone,ccmobilephone,ccaddresstype,cccity,ccstate,ccaddress,ccbclientrefid,ccprimarystatus FROM clientcontactbox WHERE cctokenno='"
							+ token + "' and ccstatus='1'");
			if (!companyName.equalsIgnoreCase("NA"))
				query.append(" and cccompanyname='" + companyName + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(ccaddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(ccaddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			
			if(sort.length()<=0)			
				query.append("order by ccbid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("status"))query.append("order by ccaddedon "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("name"))query.append("order by cccontactfirstname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("mobile"))query.append("order by ccworkphone "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("email"))query.append("order by ccemailfirst "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("company"))query.append("order by cccompanyname "+order+" limit "+((page-1)*rows)+","+rows);
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
			log.info("getAllContacts()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllContacts:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllContacts(String companyName, String dateRange, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT count(ccbid) FROM clientcontactbox WHERE cctokenno='"
							+ token + "' and ccstatus='1'");
			if (!companyName.equalsIgnoreCase("NA"))
				query.append(" and cccompanyname='" + companyName + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(ccaddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(ccaddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			query.append("order by ccaddedon desc");
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countAllContacts()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects countAllContacts:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static void deleteDocumentData() {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("delete from document_master WHERE dmrefno='00000'");
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			stmnt.execute();

		} catch (Exception e) {
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
			} catch (SQLException sqle) {
			}
		}
	}

	public static String[][] getAllUploadedFiles() {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("SELECT dmdocument_name FROM document_master WHERE dmrefno='00000'");

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
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
			}
		}
		return newsdata;
	}

	public static String[][] getMilestonesStepGuide(String milestoneId, String token,String jurisdiction) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT sgkey,sgprodkey,sgmilestonename,sgstepno,sgcontents,sgdocument FROM step_guide WHERE sgmilestoneid='"
							+ milestoneId + "' and sgjurisdiction='"+jurisdiction+"' and sgtoken='" + token + "' and sgststus='1'");

			query.append(" order by sgstepno");
//			System.out.println(query);
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
			log.info("getMilestonesStepGuide()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getMilestonesStepGuide:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllMilestones(String pkey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT pmid,pm_milestonename FROM product_milestone WHERE pm_prodrefid='" + pkey
							+ "' and pm_tokeno='" + token + "' and pm_status='1' ");

			query.append(" order by pmid");
//			System.out.println(query);
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
			log.info("getAllMilestones()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllMilestones:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllTeams(String teamDoAction, String NameDoAction, String dateRange, String token
			,int page,int rows,String sort,String order) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT mtid,mtrefid,mtdate,mtdepartment,mtteamname,mtadminname,mtadmincode,mtadminid FROM manageteamctrl WHERE mttoken='"
							+ token + "' and mtstatus='1' ");
			if (!teamDoAction.equalsIgnoreCase("NA"))
				query.append(" and mtdepartment='" + teamDoAction + "'");
			if (!NameDoAction.equalsIgnoreCase("NA"))
				query.append(" and mtteamname='" + NameDoAction + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(mtdate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(mtdate,'%d-%m-%Y')>='" + fromDate + "'");
			}
			if(sort.length()<=0)			
				query.append("order by mtid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))query.append("order by str_to_date(mtdate,'%d-%m-%Y') "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("department"))query.append("order by mtdepartment "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("name"))query.append("order by mtteamname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("admin"))query.append("order by mtadminname "+order+" limit "+((page-1)*rows)+","+rows);	
				else query.append("order by mtid desc");
			
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
			log.info("getAllTeams()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllTeams:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllTeams(String teamDoAction, String NameDoAction, String dateRange, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT count(mtid) FROM manageteamctrl WHERE mttoken='"
							+ token + "' and mtstatus='1' ");
			if (!teamDoAction.equalsIgnoreCase("NA"))
				query.append(" and mtdepartment='" + teamDoAction + "'");
			if (!NameDoAction.equalsIgnoreCase("NA"))
				query.append(" and mtteamname='" + NameDoAction + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(mtdate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(mtdate,'%d-%m-%Y')>='" + fromDate + "'");
			}
						
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countAllTeams()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects countAllTeams:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllTeamMemberByRefid(String teamrefid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT tmid,tmrefid,tmdate,tmusercode,tmuseruid,tmusername FROM manageteammemberctrl WHERE tmtoken='"
							+ token + "' and tmteamrefid='" + teamrefid + "' order by tmid desc");

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
			log.info("getAllTeamMemberByRefid()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllTeamMemberByRefid:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllTeamMember(String token, String addedby) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT vtdate,vtuid,vtregcode,vtname FROM virtualteammemberctrl WHERE vttoken='" + token
							+ "' and vtaddedby='" + addedby + "'");

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
			log.info("getAllTeamMember()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllTeamMember:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllRenewals(String token,String dateRange,int page,int rows,String sort,String order) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			
			StringBuffer query = new StringBuffer(
					"SELECT l.`postdate`,s.msprojectnumber,t.mamilestonename,l.`approvaldate`,l.`renewaldate`,l.status,u.uaname,l.uuid,l.taskkey "
					+ "FROM `licence_renewal` l join managesalesctrl s on l.`saleskey`=s.msrefid JOIN manage_assignctrl"
					+ " t on l.`taskkey`=t.marefid join user_account u on l.`addedbyuid`=u.uaid WHERE l.token='"+ token + "'");
			
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and l.postdate<='"+ toDate + "' and l.postdate>='" + fromDate + "'");
			}			
			
			if(sort.length()<=0)			
				query.append(" order by l.id desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("id"))query.append("order by l.id "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))query.append("order by l.`postdate` "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("project"))query.append("order by s.msprojectnumber "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("approval_date"))query.append("order by l.`approvaldate` "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("renewal_date"))query.append("order by l.`renewaldate` "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("status"))query.append("order by l.status "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("employee"))query.append("order by u.uaname "+order+" limit "+((page-1)*rows)+","+rows);
//			System.out.println(query);
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
			log.info("getAllRenewals()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllRenewals:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllRenewals(String token,String dateRange) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			
			StringBuffer query = new StringBuffer(
					"SELECT count(l.id) FROM `licence_renewal` l join managesalesctrl s on l.`saleskey`=s.msrefid JOIN manage_assignctrl"
					+ " t on l.`taskkey`=t.marefid join user_account u on l.`addedbyuid`=u.uaid WHERE l.token='"+ token + "'");
			
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and l.postdate<='"+ toDate + "' and l.postdate>='" + fromDate + "'");
			}			
			
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			while (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countAllRenewals()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects countAllRenewals:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	// getting all tax
	public static String[][] getAllSaleTax(String token, String mtrefid,int page,int rows,String sort,String order) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			if (mtrefid == null || mtrefid.length() <= 0)
				mtrefid = "NA";

			getacces_con = DbCon.getCon("", "", "");
			
			StringBuffer query = new StringBuffer(
					"SELECT mtrefid,mthsncode,mtsgstpercent,mtcgstpercent,mtigstpercent,mttaxnotes FROM managetaxctrl WHERE mttoken='"
							+ token + "'");
			if (!mtrefid.equalsIgnoreCase("NA"))
				query.append(" and mtrefid='" + mtrefid + "'");

			if(sort.length()<=0)			
				query.append("order by mtid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("hsn"))query.append("order by mthsncode "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("cgst"))query.append("order by mtcgstpercent "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("sgst"))query.append("order by mtsgstpercent "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("igst"))query.append("order by mtigstpercent "+order+" limit "+((page-1)*rows)+","+rows);	
				
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
			log.info("getAllSaleTax()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllSaleTax:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllSaleTax(String token, String mtrefid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;

		try {
			if (mtrefid == null || mtrefid.length() <= 0)
				mtrefid = "NA";

			getacces_con = DbCon.getCon("", "", "");
			
			StringBuffer query = new StringBuffer(
					"SELECT count(mtid) FROM managetaxctrl WHERE mttoken='"
							+ token + "'");
			if (!mtrefid.equalsIgnoreCase("NA"))
				query.append(" and mtrefid='" + mtrefid + "'");
			
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countAllSaleTax()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects countAllSaleTax:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	// getting all virtual document
	public static String[][] getAllDocumentDetailsFromVirtual(String prodrefid, String token, String addedby) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			query = "SELECT dvdocname,dvdescription,dvuploadfrom,dvvisibilitystatus FROM documentvirtualctrl WHERE dvtoken='" + token
					+ "' and dvprodrefid='" + prodrefid + "' and dvaddedby='" + addedby + "' and dvdocname!='NA'";
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
			log.info("getAllDocumentDetailsFromVirtual()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllDocumentDetailsFromVirtual:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting all virtual milestone
	public static String[][] getAllMilestoneDetailsFromVirtual(String prodrefid, String token, String addedby) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			query = "SELECT mvmilestonename,mvtimelinevalue,mvtimelineunit,mvstep,mvassign,mvpricepercent FROM milestonevirtualctrl WHERE mvtoken='"
					+ token + "' and mvprodrefid='" + prodrefid + "' and mvaddedby='" + addedby + "'";
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
			log.info("getAllMilestoneDetailsFromVirtual()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllMilestoneDetailsFromVirtual:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting all virtual price
	public static String[][] getAllPriceDetailsFromVirtual(String prodrefid, String token, String addedby) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			query = "SELECT ppvservicename,ppvprice,ppvhsncode,ppvcgstpercent,ppvsgstpercent,ppvigstpercent,ppvtotalprice FROM productpricevirtual WHERE ppvtoken='"
					+ token + "' and ppvproductrefid='" + prodrefid + "' and ppvaddedby='" + addedby + "'";
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
			log.info("getAllPriceDetailsFromVirtual()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllPriceDetailsFromVirtual:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting all trigger Action
	public static String[][] getAllActions() {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			query = "SELECT mtconditionname FROM managetriggerctrl WHERE mtconditiontype='act_main'";
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
			log.info("getAllActions()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllActions:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting all trigger conditions
	public static String[][] getAllConditions() {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			query = "SELECT mtconditionname FROM managetriggerctrl WHERE mtconditiontype='con_main'";
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
			log.info("getAllConditions()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllConditions:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting all Folder
	public static String[][] getAllPermissions(String frefid, String token, String fcategory) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			query = "SELECT fpid,uaname FROM folder_permission join user_account on folder_permission.fp_uid=user_account.uaid WHERE fptoken='"
					+ token + "' and fp_frefid='" + frefid + "' and fpcategory='" + fcategory + "'";
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
			log.info("getAllPermissions()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllPermissions:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting all Folder
	public static String[][] getAllFolderName(String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			query = "SELECT fid,fname,frefid FROM folder_master WHERE ftokenno='" + token + "' order by fid desc";
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
			log.info("getAllFolderName()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllFolderName:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	// getting all service type
	public static String[][] getAllServiceType(String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			query = "SELECT sid,stypename FROM service_type WHERE stokenno='" + token + "' order by stypename";
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
			log.info("getAllServiceType()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects getAllServiceType\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] findMilestoneByCondition(String role, String uaid, String teamKey, String date,
			String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (role.equals("Admin") || role.equals("Manager"))
				query = "SELECT madeliverydate,madelivereddate FROM manage_assignctrl WHERE matokenno='" + token
						+ "' and (maworkpercentage='100' or str_to_date(madeliverydate,'%d-%m-%Y')<'" + date + "')";
			else if (role.equals("Assistant") && !teamKey.equals("NA"))
				query = "select madeliverydate,madelivereddate from manage_assignctrl where matokenno='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=mateammemberid) or mateammemberid='" + uaid
						+ "' and (maworkpercentage='100' or str_to_date(madeliverydate,'%d-%m-%Y')<'" + date + "')";
			else
				query = "select madeliverydate,madelivereddate from manage_assignctrl where matokenno='" + token
						+ "' and mateammemberid='" + uaid
						+ "' and (maworkpercentage='100' or str_to_date(madeliverydate,'%d-%m-%Y')<'" + date + "')";
//				System.out.println(query);
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
			log.info("findMilestoneByCondition()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findMilestoneByCondition\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting all completed milestone
	public static String[][] getCompletedMileStone(String id, String loginuaid, String token, String role) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (!role.equalsIgnoreCase("Administrator"))
				query = "SELECT aid,amilestoneid,aremarks,aassigndate,adeliverydate,aimageurl FROM assigntask WHERE ataskid='"
						+ id + "' and aassignedtoid='" + loginuaid + "' and atokenno='" + token
						+ "' and ataskstatus='Completed' order by aid desc";
			else
				query = "SELECT aid,amilestoneid,aremarks,aassigndate,adeliverydate,aimageurl FROM assigntask WHERE ataskid='"
						+ id + "' and aassignedtoid!='NA' and atokenno='" + token
						+ "' group by amilestoneid order by aid desc";

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
			log.info("getCompletedMileStone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getCompletedMileStone\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting all templates
	public static String[][] getAllMileStone(String id, String loginuaid, String token, String role) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (!role.equalsIgnoreCase("Administrator"))
				query = "SELECT aid,amilestoneid,aremarks,aassigndate,adeliverydate,aimageurl,ataskstatus FROM assigntask WHERE ataskid='"
						+ id + "' and aassignedtoid='" + loginuaid + "' and atokenno='" + token
						+ "' and ataskstatus!='Completed' order by aid desc";
			else
				query = "SELECT aid,amilestoneid,aremarks,aassigndate,adeliverydate,aimageurl,ataskstatus FROM assigntask WHERE ataskid='"
						+ id + "' and aassignedtoid!='NA' and atokenno='" + token
						+ "' group by amilestoneid order by aid desc";

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
			log.info("getAllMileStone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllMileStone\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	/* getting Task assigned name */
	@SuppressWarnings("resource")
	public static String getAssignName(String taskno, String token) {
		PreparedStatement ps = null;
		StringBuffer query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String uname = "";
		String uid = null;
		try {
			query = new StringBuffer("select atassignedid from assignedtaskid where attaskno='" + taskno
					+ "' and attokenno='" + token + "'");
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			query = new StringBuffer("select uaname from user_account where ");
			int i = 0;
			while (rs.next()) {
				if (i == 0) {
					query.append("(uaid='" + rs.getString(1) + "'");
					i++;
				} else {
					query.append(" or uaid='" + rs.getString(1) + "'");
				}
				uid = rs.getString(1);
			}
			query.append(") and uavalidtokenno='" + token + "'");
			if (uid != null) {
				ps = con.prepareStatement(query.toString());
				rs = ps.executeQuery();
				rs.last();
				int row = rs.getRow();
				rs.beforeFirst();

				while (rs.next()) {
					uname += rs.getString(1);
					if (row != 1)
						uname += ",";
					row--;
				}
			}
		} catch (Exception e) {
			log.info("getAssignName()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAssignName\n" + sqle.getMessage());
			}
		}
		return uname;
	}

	public static String getClientRefidBySalesrefid(String salesrefi, String token) {
		String data = "NA";
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		PreparedStatement ps = null;
		try {
			String query = "select msclientrefid from managesalesctrl where msrefid='" + salesrefi + "' and mstoken='"
					+ token + "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				data = rs.getString(1);

		} catch (Exception e) {
			log.info("getClientRefidBySalesrefid()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getClientRefidBySalesrefid:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	public static String getCompanyAddress(String salesrefi, String token) {
		PreparedStatement ps = null;
		String query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String data = "NA";
		try {
			String clientrefid = getClientRefidBySalesrefid(salesrefi, token);
			if (!clientrefid.equalsIgnoreCase("NA")) {
				query = "select cregaddress from hrmclient_reg where cregclientrefid='" + clientrefid
						+ "' and cregtokenno='" + token + "'";
				ps = con.prepareStatement(query);
				rs = ps.executeQuery();
				if (rs.next())
					data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getCompanyAddress()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getCompanyAddress:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	public static String getClientlocation(String clientKey, String token) {
		PreparedStatement ps = null;
		String query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String data = "NA";
		try {
			query = "select creglocation from hrmclient_reg where cregclientrefid='" + clientKey + "' and cregtokenno='"
					+ token + "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}

		} catch (Exception e) {
			log.info("getClientlocation()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getClientlocation:\n" + sqle.getMessage());
			}
		}
		return data;
	}	
	
	public static String getCompanyName(String salesrefi, String token) {
		PreparedStatement ps = null;
		String query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String data = "NA";
		try {
			query = "select mscompany,msprojectnumber,msproductname,msclientrefid,msassignedtorefid,msproducttype,"
					+ "msunseenchatadmin from managesalesctrl where msrefid='"
					+ salesrefi + "' and mstoken='" + token + "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				data = rs.getString(1) + "#" + rs.getString(2) + "#" + rs.getString(3) + "#" + rs.getString(4) + "#"
						+ rs.getString(5) + "#" + rs.getString(6) + "#" + rs.getString(7);

		} catch (Exception e) {
			log.info("getCompanyName()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getCompanyName:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	public static String getSalesJurisdiction(String salesrefi, String token) {
		PreparedStatement ps = null;
		String query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String data = "NA";
		try {
			query = "select msjurisdiction from managesalesctrl where msrefid='" + salesrefi + "' and mstoken='" + token
					+ "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				data = rs.getString(1);

		} catch (Exception e) {
			log.info("getSalesJurisdiction()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSalesJurisdiction:\n" + sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String getSalesContactrefid(String salesrefi, String token) {
		PreparedStatement ps = null;
		String query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String data = "NA";
		try {
			query = "select mscontactrefid from managesalesctrl where msrefid='" + salesrefi + "' and mstoken='" + token
					+ "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				data = rs.getString(1);

		} catch (Exception e) {
			log.info("getSalesContactrefid()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSalesContactrefid:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	/* getting client name */
	@SuppressWarnings("resource")
	public static String getClientName(String pid, String token) {
		PreparedStatement ps = null;
		String query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String clientid = null;
		String clientname = null;
		try {
			query = "select pregcuid from hrmproject_reg where preguid='" + pid + "' and pregtokenno='" + token + "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				clientid = rs.getString(1);
			query = "select cregname from hrmclient_reg where creguid='" + clientid + "' and cregtokenno='" + token
					+ "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				clientname = rs.getString(1);
			if (clientname == null || clientname == "")
				clientname = "Client Not Exist";
		} catch (Exception e) {
			log.info("getClientName()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getClientName:\n" + sqle.getMessage());
			}
		}
		return clientname;
	}

	/* For delete in manage-template */
	public static boolean deleteTemplate(String templateKey, String token) {
		PreparedStatement ps = null;

		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement(
					"delete from manage_template where tkey='" + templateKey + "' and ttokenno='" + token + "'");
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("deleteTemplate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteTemplate\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	/* For delete in milestone virtual table */
	public static void clearDocumentVirtualTable(String prodrefid, String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("delete from documentvirtualctrl where dvaddedby='" + addedby + "' and dvtoken='"
					+ token + "' and dvprodrefid='" + prodrefid + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("clearDocumentVirtualTable()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects clearDocumentVirtualTable:\n" + sqle.getMessage());
			}
		}
	}

	/* For delete in milestone virtual table */
	public static void emptyDocumentVirtualTable(String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"delete from documentvirtualctrl where dvaddedby='" + addedby + "' and dvtoken='" + token + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("emptyDocumentVirtualTable()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects emptyDocumentVirtualTable:\n" + sqle.getMessage());
			}
		}
	}

	/* For delete in milestone virtual table */
	public static void clearMilestoneVirtualTable(String prodrefid, String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("delete from milestonevirtualctrl where mvaddedby='" + addedby + "' and mvtoken='"
					+ token + "' and mvprodrefid='" + prodrefid + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("clearMilestoneVirtualTable()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects clearMilestoneVirtualTable:\n" + sqle.getMessage());
			}
		}
	}

	/* For delete in milestone virtual table */
	public static void emptyMilestoneVirtualTable(String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"delete from milestonevirtualctrl where mvaddedby='" + addedby + "' and mvtoken='" + token + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("emptyMilestoneVirtualTable()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects emptyMilestoneVirtualTable:\n" + sqle.getMessage());
			}
		}
	}

	/* For delete in price virtual table */
	public static void clearPriceVirtualTable(String prodrefid, String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("delete from productpricevirtual where ppvaddedby='" + addedby
					+ "' and ppvtoken='" + token + "' and ppvproductrefid='" + prodrefid + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("clearPriceVirtualTable()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects clearPriceVirtualTable:\n" + sqle.getMessage());
			}
		}
	}

	/* For delete in price virtual table */
	public static void emptyPriceVirtualTable(String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"delete from productpricevirtual where ppvaddedby='" + addedby + "' and ppvtoken='" + token + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("emptyPriceVirtualTable()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects emptyPriceVirtualTable:\n" + sqle.getMessage());
			}
		}
	}

	/* For delete in manage-product */
	public static void delServiceType(String uid, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("delete from service_type where sid='" + uid + "' and stokenno='" + token + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("delServiceType()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects delServiceType:\n" + sqle.getMessage());
			}
		}
	}

	/* For delete in manage-tax */
	public static boolean delRegisteredTax(String mtref, String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"delete from managetaxctrl where mtrefid='" + mtref + "' and mttoken='" + token + "'");
//			System.out.println("delete from managetaxctrl where mtrefid='"+mtref+"' and mttoken='"+token+"'");
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("delRegisteredTax()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects delRegisteredTax:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean deleteTeam(String teamId, String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"update manageteamctrl set mtstatus='2' where mtid='" + teamId + "' and mttoken='" + token + "'");
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("deleteTeam()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL Objects deleteTeam:\n" + sqle.getMessage());
			}
		}
		return flag;
	}
	
	public static void deleteProductDocument(String prodKey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"delete from product_documents where pd_prodrefid='" + prodKey + "' and pd_token='" + token + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("deleteProductDocument()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteProductDocument:\n" + sqle.getMessage());
			}
		}
	}

	public static void deleteProductPrice(String prodKey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"delete from product_price where pp_prodrefid='" + prodKey + "' and pp_tokenno='" + token + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("deleteProductPrice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteProductPrice:\n" + sqle.getMessage());
			}
		}
	}

	public static void deleteProductMilestones(String prodKey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"delete from product_milestone where pm_prodrefid='" + prodKey + "' and pm_tokeno='" + token + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("deleteProductMilestones()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteProductMilestones:\n" + sqle.getMessage());
			}
		}
	}

	/* For delete in manage-product */
	public static void deleleProduct(String prodKey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "delete from product_master where prefid='" + prodKey + "' and ptokenno='" + token + "'";
			ps = con.prepareStatement(query);
			ps.execute();
		} catch (Exception e) {
			log.info("deleleProduct()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleleProduct:\n" + sqle.getMessage());
			}
		}
	}

	/* For delete in manage-project */
	public static boolean updateMilestoneStep(String pmid, String val, String type) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String x = "NA";
			if (type.equalsIgnoreCase("step"))
				x = "pmsteps";
			else if (type.equalsIgnoreCase("percent"))
				x = "pmprevworkpercent";

			String query = "update product_milestone set " + x + "=? where pmid=? ";
			ps = con.prepareStatement(query);
			ps.setString(1, val);
			ps.setString(2, pmid);
			ps.execute();
			flag = true;
		} catch (Exception e) {
			log.info("updateMilestoneStep()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateMilestoneStep:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	/* For delete in manage-project */
	public static void deleteProduct(String uid, String status) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update product_master set pstatus=? where pid=? ";
			ps = con.prepareStatement(query);
			ps.setString(1, status);
			ps.setString(2, uid);
			ps.execute();
		} catch (Exception e) {
			log.info("deleteProduct()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteProduct:\n" + sqle.getMessage());
			}
		}
	}

	// getting project's building time
	public static String getUserName(String loginid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			ps = con.prepareStatement("select uaname from user_account where ualoginid='" + loginid
					+ "' and uavalidtokenno='" + token + "'");
			rset = ps.executeQuery();
			if (rset.next())
				getinfo = rset.getString(1);

		} catch (Exception e) {
			log.info("getUserName()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getUserName()" + e.getMessage());
			}
		}
		return getinfo;
	}

	// getting task name
	@SuppressWarnings("resource")
	public static String getTaskName(String id, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		String mid = null;
		try {
			ps = con.prepareStatement(
					"select amilestoneid from assigntask where aid='" + id + "' and atokenno='" + token + "'");
			rset = ps.executeQuery();
			if (rset.next())
				mid = rset.getString(1);

			ps = con.prepareStatement(
					"select worktype from project_milestone where id='" + mid + "' and tokenno='" + token + "'");
			rset = ps.executeQuery();
			if (rset.next())
				getinfo = rset.getString(1);

		} catch (Exception e) {
			log.info("getTaskName()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTaskName()" + e.getMessage());
			}
		}
		return getinfo;
	}

	// getting milestone name
	public static String getMilestoneName(String mid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			ps = con.prepareStatement(
					"select worktype from project_milestone where id='" + mid + "' and tokenno='" + token + "'");
			rset = ps.executeQuery();
			if (rset.next())
				getinfo = rset.getString(1);

		} catch (Exception e) {
			log.info("getMilestoneName()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getMilestoneName()" + e.getMessage());
			}
		}
		return getinfo;
	}

	// getting project's building time
	public static String getProjectBuildingTime(String pid, String table, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			ps = con.prepareStatement("select pregbuildingtime from " + table + " where preguid='" + pid
					+ "' and pregtokenno='" + token + "'");
			rset = ps.executeQuery();
			if (rset.next())
				getinfo = rset.getString(1);

		} catch (Exception e) {
			log.info("getProjectBuildingTime()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProjectBuildingTime()" + e.getMessage());
			}
		}
		return getinfo;
	}

	// getting project starting date
	public static String getProjectSDate(String pid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			ps = con.prepareStatement(
					"select pregsdate from hrmproject_reg where preguid='" + pid + "' and pregtokenno='" + token + "'");
			rset = ps.executeQuery();
			if (rset.next())
				getinfo = rset.getString(1);

		} catch (Exception e) {
			log.info("getProjectSDate()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProjectSDate()" + e.getMessage());
			}
		}
		return getinfo;
	}

	// getting project id
	public static String getProjectId(String pid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "select preguid from project_milestone where id='" + pid + "' and tokenno='" + token
					+ "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset.next())
				getinfo = rset.getString(1);
		} catch (Exception e) {
			log.info("getProjectId()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProjectId()" + e.getMessage());
			}
		}
		return getinfo;
	}

	// getting projectt id
	@SuppressWarnings("resource")
	public static String[] getProjectpreguid(String id, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String[] getinfo = new String[3];
		try {
			String queryselect = "select preguid from project_price where id='" + id + "' and tokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset.next())
				getinfo[0] = rset.getString(1);

			ps = con.prepareStatement("select pregpuno,pregpname from hrmproject_reg where preguid='" + getinfo[0]
					+ "' and pregtokenno='" + token + "'");
			rset = ps.executeQuery();
			if (rset.next()) {
				getinfo[1] = rset.getString(1);
				getinfo[2] = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("getProjectpreguid()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("getProjectpreguid()" + e.getMessage());
			}
		}
		return getinfo;
	}

	// getting product id
	public static String getProductId(String pid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "select 	pm_pid from product_milestone where pmid='" + pid + "' and pm_tokeno='"
					+ token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset.next())
				getinfo = rset.getString(1);
		} catch (Exception e) {
			log.info("getProductId()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("getProductId()" + e.getMessage());
			}
		}
		return getinfo;
	}

	// deleting record of all tables
	public static void deleteRecord(String id, String attribute, String tokenattribute, String table, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "delete from " + table + " where " + attribute + "='" + id + "' and  " + tokenattribute
					+ "='" + token + "'";
			ps = con.prepareStatement(query);
			ps.execute();
		} catch (Exception e) {
			log.info("deleteRecord()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteRecord:\n" + sqle.getMessage());
			}
		}
	}

	// getting templates name
	@SuppressWarnings("resource")
	public static String[] TaskMaster_ACTName(String smsid, String emailid, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[] data = new String[2];
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "select tname from manage_template  where tid='" + smsid + "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				data[0] = rs.getString(1);

			ps = con.prepareStatement("select tname from manage_template  where tid='" + emailid + "'");
			rs = ps.executeQuery();
			if (rs.next())
				data[1] = rs.getString(1);

		} catch (Exception e) {
			log.info("TaskMaster_ACTName()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects TaskMaster_ACTName:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	// checking row already existed or not
	public static boolean isRowExisted(String prodrefid, String rowid, String token, String id, String table,
			String cond1, String cond2, String cond3) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement("select " + id + " from " + table + " where " + cond1 + "='" + prodrefid
					+ "' and " + cond2 + "='" + rowid + "' and " + cond3 + "='" + token + "'");
//			System.out.println("select "+id+" from "+table+" where "+cond1+"='"+prodrefid+"' and "+cond2+"='"+rowid+"' and "+cond3+"='"+token+"'");
			rs = ps.executeQuery();
			if (rs.next())
				flag = true;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			log.info("isRowExisted()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects isRowExisted:\n" + sqle.getMessage());
			}
		}

		return flag;
	}

	// checking given date sunday or not
	public static boolean isProjectAssigned(String pregno, String token, String loginid) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement("select aid from assigntask where aprojectid='" + pregno + "' and aassignedtoid='"
					+ loginid + "' and atokenno='" + token + "' and ataskstatus!='Completed'");
			rs = ps.executeQuery();
//			System.out.println("select aid from assigntask where aprojectid='"+pregno+"' and aassignedtoid='"+loginid+"' and atokenno='"+token+"' and ataskstatus!='Completed'");
			if (rs.next())
				flag = true;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			log.info("isProjectAssigned()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects isProjectAssigned:\n" + sqle.getMessage());
			}
		}

		return flag;
	}

	// checking given date sunday or not
	public static boolean isSunday(String last_date) {
		boolean flag = false;
		SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
		try {
			Date d1 = formatter.parse(last_date);
			Calendar c1 = Calendar.getInstance();
			c1.setTime(d1);
			if (c1.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
				flag = true;
			}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			log.info("isSunday()" + e.getMessage());
		}

		return flag;
	}	

//getting sunday between two dates 
	public static int getSunday(String str_date, String last_date) {
		int sunday = 0;
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
			Date d1 = formatter.parse(str_date);
			Date d2 = formatter.parse(last_date);

			Calendar c1 = Calendar.getInstance();
			c1.setTime(d1);

			Calendar c2 = Calendar.getInstance();
			c2.setTime(d2);

			while (!c1.after(c2)) {
				if (c1.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
					sunday++;
				}
				c1.add(Calendar.DATE, 1);
			}
		} catch (Exception e) {
			// TODO: handle exception
			log.info("getSunday()" + e.getMessage());
		}
		return sunday;
	}

	// getting product building time
	public static String getTotalTime(String pname, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String buildingtime = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "select pbuldingtime from  product_master where pname='" + pname + "' and ptokenno='" + token
					+ "' ";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				buildingtime = rs.getString(1);
		} catch (Exception e) {
			log.info("getTotalTime()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null)
					rs.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalTime:\n" + sqle.getMessage());
			}
		}
		return buildingtime;
	}

	public static boolean updateSaleTags(String value, String salesrefid, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update managesalesctrl set msworktags=? where msrefid=? and mstoken=? ";
			ps = con.prepareStatement(query);
			ps.setString(1, value);
			ps.setString(2, salesrefid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateSaleTags()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateSaleTags:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateSalePriceVirtualTaxTotal(String refkey, String totaltax, String totalamt, String token,
			String select2val) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update salesproductvirtual set spvgst=?,spvgstprice=?,spvtotalprice=? where spvrefid=? and spvtokenno=?  ";
			ps = con.prepareStatement(query);
			ps.setString(1, select2val);
			ps.setString(2, totaltax);
			ps.setString(3, totalamt);
			ps.setString(4, refkey);
			ps.setString(5, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateSalePriceVirtualTaxTotal()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateSalePriceVirtualTaxTotal:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateProductPriceTaxTotal(String tableid, String totaltax, String totalamt,
			String select2val) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update product_price set pp_gst=?,pp_gst_price=?,pp_total_price=? where ppid=?  ";
			ps = con.prepareStatement(query);
			ps.setString(1, select2val);
			ps.setString(2, totaltax);
			ps.setString(3, totalamt);
			ps.setString(4, tableid);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateProductPriceTaxTotal()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductPriceTaxTotal:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// update product's documents
	public static boolean updateProductDocument(String colname, String val, String uid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update product_documents set " + colname + "=? where pdid=? ";
			ps = con.prepareStatement(query);
			ps.setString(1, val);
			ps.setString(2, uid);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateProductDocument()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductDocument:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// update product's documents
	public static boolean updateProductDocumentVirtual(String prodrefid, String colname, String val, String textboxid,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update documentvirtualctrl set " + colname
					+ "=? where dvprodrefid=? and dvrowid=? and dvtoken=? ";
			ps = con.prepareStatement(query);
			ps.setString(1, val);
			ps.setString(2, prodrefid);
			ps.setString(3, textboxid);
			ps.setString(4, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateProductDocumentVirtual()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductDocumentVirtual:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// update product's milestone
	public static boolean updateProductMilestone(String colname, String val, String uid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update product_milestone set " + colname + "=? where pmid=? ";
			ps = con.prepareStatement(query);
			ps.setString(1, val);
			ps.setString(2, uid);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateProductMilestone()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductMilestone:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// update product's milestone
	public static boolean updateProductMilestoneVirtual(String prodrefid, String colname, String val, String textboxid,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update milestonevirtualctrl set " + colname
					+ "=? where mvprodrefid=? and mvrowid=? and mvtoken=? ";
			ps = con.prepareStatement(query);
			ps.setString(1, val);
			ps.setString(2, prodrefid);
			ps.setString(3, textboxid);
			ps.setString(4, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateProductMilestoneVirtual()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductMilestoneVirtual:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// update product price
	public static boolean updateProductPrice(String colname, String val, String uid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update product_price set " + colname + "=? where ppid=? ";
			ps = con.prepareStatement(query);
			ps.setString(1, val);
			ps.setString(2, uid);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateProductPrice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductPrice:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// update product price
	public static boolean updateProductPriceVirtual(String prodrefid, String colname, String val, String textboxid,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update productpricevirtual set " + colname
					+ "=? where ppvproductrefid=? and ppvtextboxid=? and ppvtoken=? ";
			ps = con.prepareStatement(query);
			ps.setString(1, val);
			ps.setString(2, prodrefid);
			ps.setString(3, textboxid);
			ps.setString(4, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateProductPriceVirtual()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductPriceVirtual:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTaskNotification(String notificationKey, String contName, String contMobile,
			String contEmail, String userUid, String userName, String dateTime, String content, String addedby,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update task_notification set tncontactname=?,tncontactmobile=?,tncontactemail=?,tnaddedbyid=?,tnaddedbyname=?,tndatetime=?,tncontent=?,tnaddedby=? where tnrefid=? and tntokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, contName);
			ps.setString(2, contMobile);
			ps.setString(3, contEmail);
			ps.setString(4, userUid);
			ps.setString(5, userName);
			ps.setString(6, dateTime);
			ps.setString(7, content);
			ps.setString(8, addedby);
			ps.setString(9, notificationKey);
			ps.setString(10, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateTaskNotification()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTaskNotification:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateStepGuide(String sgKey, String contents, String imgname, 
			String uavalidtokenno) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			StringBuffer query = new StringBuffer("update step_guide set sgcontents=?");
			if (!imgname.equalsIgnoreCase("NA"))
				query.append(",sgdocument='" + imgname + "'");
			query.append(" where sgkey=? and sgtoken=?");
			ps = con.prepareStatement(query.toString());
			ps.setString(1, contents);
			ps.setString(2, sgKey);
			ps.setString(3, uavalidtokenno);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateStepGuide()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateStepGuide()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean addNotification(String nKey, String date, String showUid, String showClient,
			String redirectPage, String message, String token, String addedByUaid,String icon) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into notifications(nKey,nDate,nShowUid,nShowClient,nRedirectPage,nMessage,nToken,nAddedByUid,nicon)values(?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, nKey);
			ps.setString(2, date);
			ps.setString(3, showUid);
			ps.setString(4, showClient);
			ps.setString(5, redirectPage);
			ps.setString(6, message);
			ps.setString(7, token);
			ps.setString(8, addedByUaid);
			ps.setString(9, icon);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("addNotification()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("addNotification()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean addTriggerAction(String takey, String actionMain, String actionApply, String emailSubject,
			String emailSmsBody) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into trigger_action(taKey,taActionMain,taActionApply,taEmailSubject,taEmailSmsBody)values(?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, takey);
			ps.setString(2, actionMain);
			ps.setString(3, actionApply);
			ps.setString(4, emailSubject);
			ps.setString(5, emailSmsBody);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addTriggerAction()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("addTriggerAction()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean mapTriggerConditionActions(String tkey, String triggerNo, String module, String triggerName,
			String triggerDescription, String tckey, String takey, String loginuaid, String token, String today) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into triggers(tKey,tModule,tName,tDescription,tConditionKey,tActionKey,tAddedByUid,tToken,tTriggerNo,tDate)values(?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, tkey);
			ps.setString(2, module);
			ps.setString(3, triggerName);
			ps.setString(4, triggerDescription);
			ps.setString(5, tckey);
			ps.setString(6, takey);
			ps.setString(7, loginuaid);
			ps.setString(8, token);
			ps.setString(9, triggerNo);
			ps.setString(10, today);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("mapTriggerConditionActions()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("mapTriggerConditionActions()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean addTriggerCondition(String tckey, String conditionMain, String conditionSub,
			String conditionChild) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into trigger_condition(tcKey,tcConditionMain,tcConditionSub,tcConditionChild)values(?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, tckey);
			ps.setString(2, conditionMain);
			ps.setString(3, conditionSub);
			ps.setString(4, conditionChild);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addTriggerCondition()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("addTriggerCondition()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveDeliveryActionHistory(String dhKey, String saleskey, String deliveryDate,
			String prevWorkStatus, String currentWorkStatus, String prevTeamKey, String currentTeamKey,
			String prevPriority, String currentPriority, String today, String token, String loginuaid,String deliveryTime) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into deliveryactionhistory(dhkey,dhsaleskey,dhdeliverydate,dhprevstatus,dhcurrentstatus,dhprevteamkey,"
					+ "dhcurrentteamkey,dhprevpriority,dhcurrentpriority,dhdate,dhtoken,dhaddedbyid,dhdeliverytime)values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, dhKey);
			ps.setString(2, saleskey);
			ps.setString(3, deliveryDate);
			ps.setString(4, prevWorkStatus);
			ps.setString(5, currentWorkStatus);
			ps.setString(6, prevTeamKey);
			ps.setString(7, currentTeamKey);
			ps.setString(8, prevPriority);
			ps.setString(9, currentPriority);
			ps.setString(10, today);
			ps.setString(11, token);
			ps.setString(12, loginuaid);
			ps.setString(13, deliveryTime);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveDeliveryActionHistory()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveDeliveryActionHistory()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveStepGuide(String mKey, String milestoneId, String milestoneName, String contents,
			String imgname, String today, String uavalidtokenno, String uaid, int stepNo, 
			String productKey,String jurisdiction) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into step_guide(sgkey,sgmilestoneid,sgmilestonename,sgstepno,sgcontents,sgdocument,sgdate,sgtoken,sgaddedbyuid,sgprodkey,sgjurisdiction)values(?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, mKey);
			ps.setString(2, milestoneId);
			ps.setString(3, milestoneName);
			ps.setInt(4, stepNo);
			ps.setString(5, contents);
			ps.setString(6, imgname);
			ps.setString(7, today);
			ps.setString(8, uavalidtokenno);
			ps.setString(9, uaid);
			ps.setString(10, productKey);
			ps.setString(11, jurisdiction);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveStepGuide()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveStepGuide()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean addPersonalFiles(String key, String salesKey, String fileName, String description,
			String uploadBy, String docName, String uploadedById, String today, String loginuID,
			String uavalidtokenno) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into salesdocumentctrl(sdrefid,sdsalesrefid,sduploaddocname,sddescription,sduploadby,sddocname,sduploadedby,sduploaddate,adaddedby,sdtokenno)values(?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, key);
			ps.setString(2, salesKey);
			ps.setString(3, fileName);
			ps.setString(4, description);
			ps.setString(5, uploadBy);
			ps.setString(6, docName);
			ps.setString(7, uploadedById);
			ps.setString(8, today);
			ps.setString(9, loginuID);
			ps.setString(10, uavalidtokenno);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("addPersonalFiles()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addPersonalFiles:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean addTaskFollowUp(String key, String salesrefId, String milestoneKey, String milestoneName,
			String clientrefId, String content, String imgname, String today, String time, String submitStatus,
			String uaid, String userName, String loginuID, String uavalidtokenno, String formDataJson,
			String dynamicFormName) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into hrmproject_followup(pfkey,pfsaleskey,pfmilestonekey,pfmilestonename,pfclientkey,pfdynamicform,pfcontent,pffilename,pfdate,pftime,pfsubmitstatus,pfaddedbyuid,pfaddedbyname,pfaddedby,pftokenno,pfdynamicformname) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.setString(1, key);
			ps.setString(2, salesrefId);
			ps.setString(3, milestoneKey);
			ps.setString(4, milestoneName);
			ps.setString(5, clientrefId);
			ps.setString(6, formDataJson);
			ps.setString(7, content);
			ps.setString(8, imgname);
			ps.setString(9, today);
			ps.setString(10, time);
			ps.setString(11, submitStatus);
			ps.setString(12, uaid);
			ps.setString(13, userName);
			ps.setString(14, loginuID);
			ps.setString(15, uavalidtokenno);
			ps.setString(16, dynamicFormName);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {e.printStackTrace();
			log.info("addTaskFollowUp()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addTaskFollowUp:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean setTaskNotification(String taskKey, String salesrefid, String salesName, String projectNo,
			String invoiceNo, String type, String typeIcon, String contName, String contMobile, String contEmail,
			String userUid, String userName, String datTime, String subject, String content, String addedby,
			String token, String msgForUid, String msgfortype, String msgForName,String chatStatus,String salesNotificationKey) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into task_notification(tnrefid,tnsalesrefid,tnsalesname,"
					+ "tnprojectno,tninvoiceno,tntype,tntypeicon,tncontactname,tncontactmobile,"
					+ "tncontactemail,tnaddedbyid,tnaddedbyname,tndatetime,tnheading,tncontent,"
					+ "tnaddedby,tntokenno,tnaddedforid,tnaddedforidtype,tnmsgforname,tnchatstatus,"
					+ "tnsales_notification_key) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, taskKey);
			ps.setString(2, salesrefid);
			ps.setString(3, salesName);
			ps.setString(4, projectNo);
			ps.setString(5, invoiceNo);
			ps.setString(6, type);
			ps.setString(7, typeIcon);
			ps.setString(8, contName);
			ps.setString(9, contMobile);
			ps.setString(10, contEmail);
			ps.setString(11, userUid);
			ps.setString(12, userName);
			ps.setString(13, datTime);
			ps.setString(14, subject);
			ps.setString(15, content);
			ps.setString(16, addedby);
			ps.setString(17, token);
			ps.setString(18, msgForUid);
			ps.setString(19, msgfortype);
			ps.setString(20, msgForName);
			ps.setString(21, chatStatus);
			ps.setString(22, salesNotificationKey);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {e.printStackTrace();
			log.info("setTaskNotification()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects setTaskNotification:\n" + sqle.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateSalesCompleted(String salesKey, int percentage, String token, 
			String date) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update managesalesctrl set msworkpercent=?,msdeliveredon=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(query);
			ps.setInt(1, percentage);
			ps.setString(2, date);
			ps.setString(3, salesKey);
			ps.setString(4, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateSalesCompleted()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateSalesCompleted:\n" + sqle.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateSalesCompleted(String salesKey, int percentage, String token, 
			String date,String projectStatus) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update managesalesctrl set msworkpercent=?,msdeliveredon=?,msprojectstatus=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(query);
			ps.setInt(1, percentage);
			ps.setString(2, date);
			ps.setString(3, projectStatus);
			ps.setString(4, salesKey);
			ps.setString(5, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateSalesCompleted()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateSalesCompleted:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean assignWorkPercentage(String assignKey, int workpercent, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update manage_assignctrl set maworkpercentage=? where marefid=? and matokenno=?";
			ps = con.prepareStatement(query);
			ps.setInt(1, workpercent);
			ps.setString(2, assignKey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("assignWorkPercentage()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects assignWorkPercentage:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTaskCompletedDate(String assignKey, String date, String token,String time) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update manage_assignctrl set madelivereddate=?,madeliveredtime=?,task_progress_status=? where marefid=? and matokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, date);
			ps.setString(2, time);
			ps.setString(3, "2");
			ps.setString(4, assignKey);
			ps.setString(5, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateTaskCompletedDate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTaskCompletedDate:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateWorkStartedDate(String salesKey, String milestoneKey, String today, 
			String deliveryDate,String token,String deliveryTime,String startTime,String madate) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update manage_assignctrl set maworkstarteddate=?,madeliverydate=?,madeliverytime=?,maworkstartedtime=?,matime=?,madate=?,task_progress_status=? where masalesrefid=? and mamilestonerefid=? and matokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, today);
			ps.setString(2, deliveryDate);
			ps.setString(3, deliveryTime);
			ps.setString(4, startTime);
			ps.setString(5, startTime);
			ps.setString(6, madate);
			ps.setString(7, "3");
			ps.setString(8, salesKey);
			ps.setString(9, milestoneKey);
			ps.setString(10, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateWorkStartedDate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateWorkStartedDate:\n" + sqle.getMessage());
			}
		}
		return flag;
	}
	public static boolean updateTaskProgressStatus(String marefid,String status, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update manage_assignctrl set task_progress_status=? where marefid=? and matokenno=?";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.setString(1, status);
			ps.setString(2, marefid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateTaskProgressStatus()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTaskProgressStatus:\n" + sqle.getMessage());
			}
		}
		return flag;
	}
	public static boolean updateTaskProgressStatus(String salesKey, String milestoneKey, String status, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update manage_assignctrl set task_progress_status=? where masalesrefid=? and mamilestonerefid=? and matokenno=?";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.setString(1, status);
			ps.setString(2, salesKey);
			ps.setString(3, milestoneKey);
			ps.setString(4, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateTaskProgressStatus()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTaskProgressStatus:\n" + sqle.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateTaskWorkStartedDate(String assignKey, String today, String token,
			String startTime,String deliveryDate,String deliveryTime,String madate) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update manage_assignctrl set maworkstarteddate=?,maworkstartedtime=?,madate=?,matime=?,task_progress_status=? where marefid=? and matokenno=?";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.setString(1, today);
			ps.setString(2, startTime);
			ps.setString(3, madate);
			ps.setString(4, startTime);
			ps.setString(5, "3");
			ps.setString(6, assignKey);
			ps.setString(7, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateWorkStartedDate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateWorkStartedDate:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean assignThisMilestone(String assignKey, String memberId, String assignDate, String workStatus,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update manage_assignctrl set mateammemberid=?,mamemberassigndate=?,maworkstatus=?,maassignedbyuid=? where marefid=? and matokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, memberId);
			ps.setString(2, assignDate);
			ps.setString(3, workStatus);
			ps.setString(4, "NA");
			ps.setString(5, assignKey);
			ps.setString(6, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("assignThisMilestone()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects assignThisMilestone:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean assignThisMilestone(String assignKey, String milestoneName, String childTeamKey,
			String memberId, String assignDate, String workStatus, String loginUID, String managerApproval,
			String token,String time,String date,String deliveryDate,String deliveryTime) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update manage_assignctrl set mamilestonename=?,machildteamrefid=?,mateammemberid=?,"
					+ "mamemberassigndate=?,maapprovalstatus=?,maworkstatus=?,maassignedbyuid=?,matime=?,madate=?"
					+ ",madeliverydate=?,madeliverytime=? where marefid=? and matokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, milestoneName);
			ps.setString(2, childTeamKey);
			ps.setString(3, memberId);
			ps.setString(4, assignDate);
			ps.setString(5, managerApproval);
			ps.setString(6, workStatus);
			ps.setString(7, loginUID);
			ps.setString(8, time);
			ps.setString(9, date);
			ps.setString(10, deliveryDate);
			ps.setString(11, deliveryTime);
			ps.setString(12, assignKey);
			ps.setString(13, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("assignThisMilestone()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects assignThisMilestone:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveMilestoneActionHistory(String mKey, String assignKey, String salesrefid, String salesName,
			String prevTeamKey, String teamrefid, String prevChildTeamKey, String currentChildTeamKey, String prevUid,
			String currentUid, String prevWorkStatus, String currentWorkStatus, String prevWorkPriority,
			String currentWorkPriority, String deliveryDate, String today, String token, String prevUserPost,
			String currentUserPost,String deliverytime) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into milestone_action_history(maKey,maTaskKey,maSalesKey,maSalesName,"
					+ "maPrevParentTeamKey,maCurrentParentTeamKey,maPrevChildTeamKey,maCurrentChildTeamKey,"
					+ "maPrevTeamMemberUid,maCurrentTeamMemberUid,maPrevWorkStatus,maCurrentWorkStatus,"
					+ "maPervWorkPriority,maCurrentWorkPriority,maDeliveryDate,maDate,maToken,maPrevUserPost,"
					+ "maCurrentUserPost,maDeliveryTime)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, mKey);
			ps.setString(2, assignKey);
			ps.setString(3, salesrefid);
			ps.setString(4, salesName);
			ps.setString(5, prevTeamKey);
			ps.setString(6, teamrefid);
			ps.setString(7, prevChildTeamKey);
			ps.setString(8, currentChildTeamKey);
			ps.setString(9, prevUid);
			ps.setString(10, currentUid);
			ps.setString(11, prevWorkStatus);
			ps.setString(12, currentWorkStatus);
			ps.setString(13, prevWorkPriority);
			ps.setString(14, currentWorkPriority);
			ps.setString(15, deliveryDate);
			ps.setString(16, today);
			ps.setString(17, token);
			ps.setString(18, prevUserPost);
			ps.setString(19, currentUserPost);
			ps.setString(20, deliverytime);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveMilestoneActionHistory()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveMilestoneActionHistory:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean assignThisTask(String assignKey, String salesrefid, String milestonerefid, String teamrefid,
			String today, String hierarchyStatus, String hierarchyActiveStatus, String approvalStatus,
			String stepStatus, String addedby, String token, String milestoneName, String workStartPercentage,
			String nextTaskAssignPercentage, String priority, String deliveryDate,String deliveryTime) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into manage_assignctrl(marefid,masalesrefid,mamilestonerefid,maparentteamrefid,"
					+ "maassignDate,masaleshierarchystatus,mahierarchyactivestatus,maapprovalstatus,mastepstatus,"
					+ "maaddedby,matokenno,mamilestonename,maworkstartpricepercentage,manexttaskassignpercentage,"
					+ "maworkpriority,madeliverydate,madeliverytime)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, assignKey);
			ps.setString(2, salesrefid);
			ps.setString(3, milestonerefid);
			ps.setString(4, teamrefid);
			ps.setString(5, today);
			ps.setString(6, hierarchyStatus);
			ps.setString(7, hierarchyActiveStatus);
			ps.setString(8, approvalStatus);
			ps.setString(9, stepStatus);
			ps.setString(10, addedby);
			ps.setString(11, token);
			ps.setString(12, milestoneName);
			ps.setString(13, workStartPercentage);
			ps.setString(14, nextTaskAssignPercentage);
			ps.setString(15, priority);
			ps.setString(16, deliveryDate);
			ps.setString(17, deliveryTime);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("assignThisTask()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects assignThisTask:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateDisperseAmountOfSalesStep(String salesKey, 
			String token,int step) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update salesmainworkpricectrl set smwsteppayment='"+step+"' where smwsaleskey=? and smwtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateDisperseAmountOfSalesStep()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateDisperseAmountOfSalesStep:\n" + sqle.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateDisperseAmountOfSales(String salesKey, double price, 
			String token,int step) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update salesmainworkpricectrl set smwpricedispersed=smwpricedispersed+" + price
					+ ",smwsteppayment='"+step+"' where smwsaleskey=? and smwtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateDisperseAmountOfSales()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateDisperseAmountOfSales:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean addDisperseAmountOfSales(String smwkey, String salesKey, String projectNo, String invoice,
			double price, double salesAmount, String token, String addedby, int step) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into salesmainworkpricectrl(smwkey,smwsaleskey,smwprojectno,smwinvoice,smwpricedispersed,smwtokenno,smwaddedby,smworderamount,smwsteppayment)values(?,?,?,?,?,?,?,?,?)";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.setString(1, smwkey);
			ps.setString(2, salesKey);
			ps.setString(3, projectNo);
			ps.setString(4, invoice);
			ps.setDouble(5, price);
			ps.setString(6, token);
			ps.setString(7, addedby);
			ps.setDouble(8, salesAmount);
			ps.setInt(9, step);

			int k1 = ps.executeUpdate();
			if (k1 > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addDisperseAmountOfSales()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addDisperseAmountOfSales:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveDispersedAmount(String key, String salesKey, String projectNo, String projectName,
			String invoice, String date, double price, String remarks, String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into salesworkpricectrl(swkey,swsaleskey,swprojectno,swinvoiceno,swprojectname,swcreditdate,swdepositamt,swremarks,swtokenno,swaddedby)values(?,?,?,?,?,?,?,?,?,?)";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.setString(1, key);
			ps.setString(2, salesKey);
			ps.setString(3, projectNo);
			ps.setString(4, invoice);
			ps.setString(5, projectName);
			ps.setString(6, date);
			ps.setDouble(7, price);
			ps.setString(8, remarks);
			ps.setString(9, token);
			ps.setString(10, addedby);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveDispersedAmount()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveDispersedAmount:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveChildsHierarchy(String date, String hierarchykey, String invoiceno, String saleskey,
			String parentkey, String hierarchytype, String holdstatus, String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into saleshierarchymanagectrl(shmrefid,shmsalesrefid,shmparentrefid,shmhierarchytype,"
					+ "shmhierarchyholdstatus,shmtoken,shmaddedby,shminvoice,shmdate)values(?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, hierarchykey);
			ps.setString(2, saleskey);
			ps.setString(3, parentkey);
			ps.setString(4, hierarchytype);
			ps.setString(5, holdstatus);
			ps.setString(6, token);
			ps.setString(7, addedby);
			ps.setString(8, invoiceno);
			ps.setString(9, date);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveChildsHierarchy()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveChildsHierarchy:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveParentsHierarchy(String date, String hierarchykey, String invoiceno, String saleskey,
			String hierarchytype, String holdstatus, String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into saleshierarchymanagectrl(shmrefid,shmsalesrefid,shmparentrefid,shmhierarchytype,shmhierarchyholdstatus,shmtoken,shmaddedby,shminvoice,shmdate)values(?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, hierarchykey);
			ps.setString(2, saleskey);
			ps.setString(3, "NA");
			ps.setString(4, hierarchytype);
			ps.setString(5, holdstatus);
			ps.setString(6, token);
			ps.setString(7, addedby);
			ps.setString(8, invoiceno);
			ps.setString(9, date);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("saveParentsHierarchy()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveParentsHierarchy:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveSalesHierarchy(String virtualkey, String salesrefid, String type, String numbering,
			String salesinvoice, String token, String loginuID) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into saleshierarchy_virtual(shrefid,shsalesrefid,shsalesinvoice,shtype,shnumbering,shaddedby,shtoken)values(?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, virtualkey);
			ps.setString(2, salesrefid);
			ps.setString(3, salesinvoice);
			ps.setString(4, type);
			ps.setString(5, numbering);
			ps.setString(6, loginuID);
			ps.setString(7, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveSalesHierarchy()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveSalesHierarchy:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean addDocumentList(String key, String salesrefid, String docname, String UploadBy,
			String Remarks, String loginuID, String token,String estKey) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into salesdocumentctrl(sdrefid,sdsalesrefid,sduploaddocname,sddescription,sduploadby,adaddedby,sdtokenno,sdestkey)values(?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, key);
			ps.setString(2, salesrefid);
			ps.setString(3, docname);
			ps.setString(4, Remarks);
			ps.setString(5, UploadBy);
			ps.setString(6, loginuID);
			ps.setString(7, token);
			ps.setString(8, estKey);
			
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addTemplate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addTemplate:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// inserting templates into manage_template table
	public static void addTemplate(String name, String message, String type, String uavalidtokenno, String loginuID,
			String dateTime) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into manage_template(tname,tmessage,ttype,taddedby,ttokenno,taddedon,tstatus)values(?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, name);
			ps.setString(2, message);
			ps.setString(3, type);
			ps.setString(4, loginuID);
			ps.setString(5, uavalidtokenno);
			ps.setString(6, dateTime);
			ps.setString(7, "1");
			ps.execute();
		} catch (Exception e) {
			log.info("addTemplate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addTemplate:\n" + sqle.getMessage());
			}
		}
	}

	public static long getTotalSmsTemplates(String templatename, String templatetype, String dateRange, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		long newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT count(tid) FROM manage_template WHERE tstatus='1' and ttokenno='" + token + "'");
			if (!templatename.equalsIgnoreCase("NA"))
				query.append(" and tname like '" + templatename + "%'");
			query.append(" and ttype='sms'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(taddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(taddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();

			if (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getLong(1);
			}
		} catch (Exception e) {
			log.info("getTotalSmsTemplates()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalSmsTemplates:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static long getTotalEmailTemplates(String templatename, String templatetype, String dateRange,
			String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		long newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT count(tid) FROM manage_template WHERE tstatus='1' and ttokenno='" + token + "'");
			if (!templatename.equalsIgnoreCase("NA"))
				query.append(" and tname like '" + templatename + "%'");
			query.append(" and ttype='email'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(taddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(taddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();

			if (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getLong(1);
			}
		} catch (Exception e) {
			log.info("getTotalEmailTemplates()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalEmailTemplates:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static long getTotalFormTemplates(String templatename, String templatetype, String dateRange, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		long newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT count(tid) FROM manage_template WHERE tstatus='1' and ttokenno='" + token + "'");
			if (!templatename.equalsIgnoreCase("NA"))
				query.append(" and tname like '" + templatename + "%'");
			query.append(" and ttype='form'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(taddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(taddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();

			if (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getLong(1);
			}
		} catch (Exception e) {
			log.info("getTotalFormTemplates()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalFormTemplates:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int getTotalTemplates(String templatename, String templatetype, String dateRange, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT count(tid) FROM manage_template WHERE tstatus='1' and ttokenno='" + token + "'");
			if (!templatename.equalsIgnoreCase("NA"))
				query.append(" and tname like '" + templatename + "%'");
			if (!templatetype.equalsIgnoreCase("NA") && !templatetype.equalsIgnoreCase("All"))
				query.append(" and ttype like '" + templatetype + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(taddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(taddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("getTotalTemplates()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalTemplates:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting all templates
	public static String[][] getAllTemplates(String templatename, String templatetype, String dateRange, String token
			,int page,int rows,String sort,String order) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			
			StringBuffer query = new StringBuffer(
					"SELECT tkey,tdate,tname,ttype,tsubject FROM manage_template WHERE tstatus='1' and ttokenno='"
							+ token + "'");
			if (!templatename.equalsIgnoreCase("NA"))
				query.append(" and tname like '" + templatename + "%'");
			if (!templatetype.equalsIgnoreCase("NA") && !templatetype.equalsIgnoreCase("All"))
				query.append(" and ttype='" + templatetype + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(taddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(taddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			
			if(sort.length()<=0)			
				query.append("  order by tid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))query.append("order by taddedon "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("name"))query.append("order by tname "+order+" limit "+((page-1)*rows)+","+rows);
//			System.out.println(query);
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
			log.info("getAllTemplates()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllTemplates:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean doTriggerAction(String query) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		boolean flag = false;
		try {
			getacces_con = DbCon.getCon("", "", "");
			stmnt = getacces_con.prepareStatement(query);
//			System.out.println(query);
			int k = stmnt.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("doTriggerAction()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects doTriggerAction:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static String[][] getTriggerConditionsData(String query) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
//			System.out.println(query);
			getacces_con = DbCon.getCon("", "", "");
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
			log.info("getTriggerConditionsData()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTriggerConditionsData:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getTriggerConditions(String condKey) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			stmnt = getacces_con.prepareStatement("select * from trigger_condition where tcKey='" + condKey + "'");
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
			log.info("getTriggerConditionsData()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTriggerConditionsData:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllSalesHierarchy(String invoiceno, String token, String addedby) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT shrefid,shsalesrefid,shtype,shnumbering,shsalesstatus FROM saleshierarchy_virtual WHERE shsalesinvoice='"
					+ invoiceno + "' and shtoken='" + token + "' order by shnumbering";
//			System.out.println(query);
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
			e.printStackTrace();
			log.info("getAllSalesHierarchy()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllSalesHierarchy:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting project name and description
	public static String[][] getEnqMilestone(String pid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT id,worktype,unittime,duration,smsid,emailid FROM project_milestone WHERE preguid='"
					+ pid + "' and tokenno='" + token + "' and enq='enquiry' order by id desc";
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
			log.info("getEnqMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getEnqMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String getTaskNameById(String taskid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT worktype FROM project_milestone WHERE id='" + taskid + "' and tokenno='" + token
					+ "'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();

			if (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getTaskNameById()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTaskNameById:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting project name and description
	public static String[][] getMilestone(String pid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT id,worktype,unittime,duration,	smsid,emailid FROM project_milestone WHERE preguid='"
					+ pid + "' and tokenno='" + token + "' order by id desc";
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
			log.info("getMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllTeamMembers(String teamrefid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT tmuseruid,tmusername from manageteammemberctrl WHERE tmteamrefid='" + teamrefid
							+ "' and tmtoken='" + token + "' and tmstatus='1'");
			query.append(" order by tmusername");
//System.out.println(query);
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
			log.info("getAllTeamMembers()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllTeamMembers:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllFinalSalesHierarchyList(String salesinvoice, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT shmrefid,shmsalesrefid,shmhierarchytype,shmhierarchyholdstatus,shmdate from saleshierarchymanagectrl WHERE shminvoice='"
							+ salesinvoice + "' and shmtoken='" + token + "' order by shmid");
//System.out.println(query);
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
			log.info("getAllFinalSalesHierarchyList()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllFinalSalesHierarchyList:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findAllSalesListByEstimate(String estimateinvoice, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT msinvoiceno,msproductname,mssolddate,msworkpercent,msworkstatus,"
					+ "msassignedtoname,msdeliveredon,msprojectstatus,msdeliverydate,"
					+ "msdeliverytime,mscancelstatus,document_assign_uaid,document_status,"
					+ "delivery_assign_date,msworkpercent from managesalesctrl WHERE "
					+ "msestimateno='" + estimateinvoice+ "' and mstoken='" + token + "'");
//System.out.println(query.toString());
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
			log.info("findAllSalesListByEstimate()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findAllSalesListByEstimate:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllSalesList(String salesinvoice, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT msrefid,msproductname from managesalesctrl WHERE msinvoiceno='" + salesinvoice
							+ "' and mstoken='" + token + "'");
//System.out.println(query.toString());
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
			log.info("getAllSalesList()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllSalesList:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllAssignedSalesMilestone(String leaderUid, String salesrefid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT marefid,mamilestonename,mamemberassigndate,maworkpercentage,maworkstartpricepercentage,mamilestonerefid,mamilestonename from manage_assignctrl WHERE  masalesrefid='"
							+ salesrefid + "' and matokenno='" + token + "' and mateammemberid='" + leaderUid
							+ "' and masaleshierarchystatus='1' and mahierarchyactivestatus='1' and maapprovalstatus='1' and mastepstatus='1'");
			query.append(" order by maid");
//			System.out.println(query);
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
			log.info("getAllAssignedSalesMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllAssignedSalesMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAssignedSalesMilestone(String role, String uaid, String teamKey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = "";
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (role.equals("Admin") || role.equals("Manager"))
				query = "SELECT maworkstatus from manage_assignctrl WHERE matokenno='" + token + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				query = "SELECT maworkstatus from manage_assignctrl WHERE matokenno='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=mateammemberid) or mateammemberid='" + uaid + "'";
			} else {
				query = "SELECT maworkstatus from manage_assignctrl WHERE matokenno='" + token
						+ "' and mateammemberid='" + uaid + "'";
			}
//			System.out.println(query);
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
			log.info("getAllAssignedSalesMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllAssignedSalesMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getClientAssignedSalesMilestone(String maid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT mamilestonerefid,mamilestonename,mateammemberid,mamemberassigndate,maassignDate,marefid,"
					+ "machildteamrefid,mamemberassigndate,maworkpercentage,maworkstatus,maworkstartpricepercentage,"
					+ "maworkstarteddate,maworkpriority,maparentteamrefid,madeliverydate,madate,matime,madeliverytime from "
					+ "manage_assignctrl WHERE maid='"+ maid + "' and maworkstatus!='Completed'");

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
			log.info("getClientAssignedSalesMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getClientAssignedSalesMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAssignedSalesMilestone(String salesKey, String milestoneKey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT mamilestonerefid,mamilestonename,mateammemberid,mamemberassigndate,maassignDate,marefid,machildteamrefid,mamemberassigndate,maworkpercentage,maworkstatus,maworkstartpricepercentage,maworkstarteddate,maworkpriority,maparentteamrefid from manage_assignctrl WHERE  masalesrefid='"
							+ salesKey + "' and mamilestonerefid='" + milestoneKey + "' and matokenno='" + token + "'");

//			System.out.println(query);
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
			log.info("getAssignedSalesMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAssignedSalesMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAssignedSalesMilestone(String assignedKey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT mamilestonerefid,mamilestonename,mateammemberid,mamemberassigndate,maassignDate,marefid,machildteamrefid,mamemberassigndate,maworkpercentage,maworkstatus,maworkstartpricepercentage,maworkstarteddate,maworkpriority,maparentteamrefid from manage_assignctrl WHERE  marefid='"
							+ assignedKey + "' and matokenno='" + token + "'");

//			System.out.println(query);
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
			log.info("getAssignedSalesMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAssignedSalesMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllSalesMilestoneKeyData(String salesrefid, int stepNo, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT smrefid,smstep from salesmilestonectrl WHERE exists(select maid from manage_assignctrl where masalesrefid=smsalesrefid and mamilestonerefid=smrefid and maworkstarteddate='00-00-0000') and smsalesrefid='"
							+ salesrefid + "' and smtoken='" + token + "' and smstep>" + stepNo + "");

//			System.out.println(query);
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
			log.info("getAllSalesMilestoneKeyData()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllSalesMilestoneKeyData:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllSalesMilestoneKey(String salesrefid, int stepNo, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("SELECT smrefid from salesmilestonectrl WHERE  smsalesrefid='"
					+ salesrefid + "' and smtoken='" + token + "' and smstep<='" + stepNo + "'");
			query.append(" group by smstep");
//			System.out.println(query);
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
			log.info("getAllSalesMilestoneKey()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllSalesMilestoneKey:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesMilestoneByKey(String mrefId, String salesrefid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT mamilestonerefid,mamilestonename,mateammemberid,mamemberassigndate,maassignDate,marefid,machildteamrefid,mamemberassigndate,maworkpercentage,maworkstatus,maworkstartpricepercentage,maworkstarteddate,maworkpriority,maparentteamrefid from manage_assignctrl WHERE masalesrefid='"
							+ salesrefid + "' and marefid='" + mrefId + "' and matokenno='" + token + "'");
			query.append(" order by maid");
//			System.out.println(query);
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
			log.info("getSalesMilestoneByKey()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSalesMilestoneByKey:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] fetchSalesByName(String superUserId,String name,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT m.msid,m.msproductname from managesalesctrl m join hrmclient_reg h on h.cregclientrefid=m.msclientrefid "
					+ "where h.super_user_uaid='"+superUserId+"' and m.mstoken='" + token + "' and (m.msprojectnumber like '%"+name+"%' or "
							+ "m.msinvoiceno like '%"+name+"%' or m.msproductname like '%"+name+"%') order by m.msid desc");			
			
//			System.out.println(query);
			
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
			log.info("fetchSalesByName()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects fetchSalesByName:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllSalesTaskNotes(String salesKey,String role,String token
			,String addedByUid,String estKey) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT * from sales_notification WHERE token='" + token + "'");
			
			if(salesKey!=null&&!salesKey.equalsIgnoreCase("NA"))
				query.append(" and sales_key='"+ salesKey + "'");
			
			if(estKey!=null&&!estKey.equalsIgnoreCase("NA"))
				query.append(" and estimate_key='"+ estKey + "'");
			
			if(role.equalsIgnoreCase("Executive"))
			query.append(" and added_by_uid='"+addedByUid+"'");	
			
			query.append(" order by id");
//			System.out.println(query);
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
			log.info("getAllSalesMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllSalesMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllSalesMilestone(String name, String salesrefid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT ma.mamilestonerefid,ma.mamilestonename,ma.mateammemberid,ma.mamemberassigndate,"
					+ "ma.maassignDate,ma.marefid,ma.machildteamrefid,ma.mamemberassigndate,ma.maworkpercentage,"
					+ "ma.maworkstatus,ma.maworkstartpricepercentage,ma.maworkstarteddate,ma.maworkpriority,"
					+ "ma.maparentteamrefid,ma.maworkstartedtime,ma.task_progress_status,m.smtimelinevalue,"
					+ "m.smtimelineperiod,ma.madelivereddate,ma.madeliveredtime "
					+ "from manage_assignctrl ma inner join salesmilestonectrl m on ma.mamilestonerefid=m.smrefid"
					+ " WHERE ma.masalesrefid='"+ salesrefid + "' and ma.matokenno='" + token + "'");
			if (name != null && !name.equalsIgnoreCase("NA") && name.length() > 0)
				query.append(" and ma.mamilestonename like '" + name + "%'");
			query.append(" order by ma.maid");
//			System.out.println(query);
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
			log.info("getAllSalesMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllSalesMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting product name and description
	public static String[][] getAllMilestone(String pid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT pmid,pm_worktype,pm_unittime,pm_duration,pm_smsid,pm_emailid,pmsteps,pmprevworkpercent FROM product_milestone WHERE pm_pid='"
					+ pid + "' and pm_tokeno='" + token + "' order by pmid desc";
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
			log.info("getAllMilestone()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllMilestone:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting product name and description
	public static void addProductMilestone(String pid, String work_type, String Unit_Time, String Duration,
			String SMSID, String EmailId, String uavalidtokenno, String loginuID, String dateTime) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into product_milestone(pm_pid,pm_worktype,pm_unittime,pm_duration,pm_smsid,pm_emailid,pm_addedby,pm_status,	pm_tokeno,pm_addedon)"
					+ "values(?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, pid);
			ps.setString(2, work_type);
			ps.setString(3, Unit_Time);
			ps.setString(4, Duration);
			ps.setString(5, SMSID);
			ps.setString(6, EmailId);
			ps.setString(7, loginuID);
			ps.setString(8, "1");
			ps.setString(9, uavalidtokenno);
			ps.setString(10, dateTime);
			ps.execute();
		} catch (Exception e) {
			log.info("addProductMilestone()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addProductMilestone:\n" + sqle.getMessage());
			}
		}
	}

	// getting product name and description
	public static String[] getEnqProject(String id, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[] data = new String[3];
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "select enqproduct_type,enqproduct_name,enqRemarks from userenquiry where enqid='" + id
					+ "' and enqTokenNo='" + token + "' ";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
			}

		} catch (Exception e) {
			log.info("getEnqProject()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getEnqProject:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	// getting product name and description
	public static String[] getProject(String id, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[] data = new String[6];
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "select pregpuno,pregtype,pregpname,pregremarks,pregsdate,pregrunningstatus from hrmproject_reg where preguid='"
					+ id + "' and pregtokenno='" + token + "' and pregstatus='1' ";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
				data[3] = rs.getString(4);
				data[4] = rs.getString(5);
				data[5] = rs.getString(6);
			}

		} catch (Exception e) {
			log.info("getProject()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProject:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	// getting product name and description
	public static String[] getProduct(String id, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[] data = new String[3];
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "select pname,pdescription,ptype from product_master where pid='" + id + "' and ptokenno='"
					+ token + "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
			}

		} catch (Exception e) {
			log.info("getProduct()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProduct:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	// updating product timeline
	@SuppressWarnings("resource")
	public static void updateProductTimeline(String pid, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		int yy = 0;
		int mm = 0;
		int dd = 0;
		int hh = 0;

		try {
			String query = "select pm_unittime,pm_duration from product_milestone where pm_status='1' and pm_pid='"
					+ pid + "' and pm_tokeno='" + token + "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			while (rs.next()) {
				if (rs.getString(1).equalsIgnoreCase("Year"))
					yy += Integer.parseInt(rs.getString(2));
				if (rs.getString(1).equalsIgnoreCase("Month"))
					mm += Integer.parseInt(rs.getString(2));
				if (rs.getString(1).equalsIgnoreCase("Day"))
					dd += Integer.parseInt(rs.getString(2));
				if (rs.getString(1).equalsIgnoreCase("Hour"))
					hh += Integer.parseInt(rs.getString(2));
			}
			String time = yy + ":" + mm + ":" + dd + ":" + hh;
			ps = con.prepareStatement("update product_master set pbuldingtime=? where pid=? and ptokenno=?");
			ps.setString(1, time);
			ps.setString(2, pid);
			ps.setString(3, token);
			ps.execute();
		} catch (Exception e) {
			log.info("updateProductTimeline()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null)
					rs.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductTimeline:\n" + sqle.getMessage());
			}
		}
	}

	public static boolean clearTriggerActions(String uaid, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "delete from trigger_action_virtual where taUaid=? and taToken=?";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.setString(1, uaid);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("clearTriggerActions()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects clearTriggerActions:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean clearTriggerConditions(String uaid, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "delete from trigger_condition_virtual where tcUaid=? and tcToken=?";

			ps = con.prepareStatement(query);
			ps.setString(1, uaid);
			ps.setString(2, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("clearTriggerConditions()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects clearTriggerConditions:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeTriggerAction(String triggerKey, int numbering, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "delete from trigger_action_virtual where taTriggerKey=? and taNumbering=? and taToken=?";

			ps = con.prepareStatement(query);
			ps.setString(1, triggerKey);
			ps.setInt(2, numbering);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removeTriggerAction()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects removeTriggerAction:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeTriggerConditions(String triggerKey, int numbering, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "delete from trigger_condition_virtual where tcTriggerKey=? and tcNumbering=? and tcToken=?";

			ps = con.prepareStatement(query);
			ps.setString(1, triggerKey);
			ps.setInt(2, numbering);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("removeTriggerConditions()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects removeTriggerConditions:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTriggerActions(String triggerKey, String data, int numbering, String column,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update trigger_action_virtual set " + column
					+ "=? where taTriggerKey=? and taNumbering=? and taToken=?";

			ps = con.prepareStatement(query);
			ps.setString(1, data);
			ps.setString(2, triggerKey);
			ps.setInt(3, numbering);
			ps.setString(4, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateTriggerActions()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTriggerActions:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTriggerAction(String id, String data, String column) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update trigger_action set " + column + "=? where taId =?";

			ps = con.prepareStatement(query);
			ps.setString(1, data);
			ps.setString(2, id);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateTriggerAction()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTriggerAction:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTriggerConditions(String triggerKey, String data, int numbering, String column,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update trigger_condition_virtual set " + column
					+ "=? where tcTriggerKey=? and tcNumbering=? and tcToken=?";

			ps = con.prepareStatement(query);
			ps.setString(1, data);
			ps.setString(2, triggerKey);
			ps.setInt(3, numbering);
			ps.setString(4, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateTriggerConditions()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTriggerConditions:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTriggerCondition(String id, String data, String column) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update trigger_condition set " + column + "=? where tcId =?";

			ps = con.prepareStatement(query);
			ps.setString(1, data);
			ps.setString(2, id);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("updateTriggerCondition()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTriggerCondition:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveTriggerActions(String tckey, String triggerKey, String data, int numbering, String column,
			String token, String loginuaid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into trigger_action_virtual(takey ,taTriggerKey,taNumbering," + column
					+ ",taToken,taUaid) values (?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, tckey);
			ps.setString(2, triggerKey);
			ps.setInt(3, numbering);
			ps.setString(4, data);
			ps.setString(5, token);
			ps.setString(6, loginuaid);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveTriggerActions()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveTriggerActions:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveTriggerConditions(String tckey, String triggerKey, String data, int numbering,
			String column, String token, String loginuaid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into trigger_condition_virtual(tckey ,tcTriggerKey,tcNumbering," + column
					+ ",tcToken,tcUaid) values (?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, tckey);
			ps.setString(2, triggerKey);
			ps.setInt(3, numbering);
			ps.setString(4, data);
			ps.setString(5, token);
			ps.setString(6, loginuaid);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveTriggerConditions()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveTriggerConditions:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveTeamMember(String teamkey, String memberkey, String date, String uid, String regcode,
			String membername, String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into manageteammemberctrl(tmrefid,tmteamrefid,tmdate,tmusercode,tmuseruid,tmusername,tmtoken,tmaddedby) values (?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, memberkey);
			ps.setString(2, teamkey);
			ps.setString(3, date);
			ps.setString(4, regcode);
			ps.setString(5, uid);
			ps.setString(6, membername);
			ps.setString(7, token);
			ps.setString(8, addedby);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveTeamMember()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveTeamMember:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// inserting product's price
	public static boolean addProductPriceVirtualTaxTotal(String prodrefid, String tax, String amount, String textboxid,
			String token, String addedby, String select2val) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into productpricevirtual(ppvproductrefid,ppvtotaltax,ppvtotalprice,ppvtextboxid,ppvtoken,ppvaddedby,ppvgstpercent) values (?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, prodrefid);
			ps.setString(2, tax);
			ps.setString(3, amount);
			ps.setString(4, textboxid);
			ps.setString(5, token);
			ps.setString(6, addedby);
			ps.setString(7, select2val);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addProductPriceVirtualTaxTotal()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addProductPriceVirtualTaxTotal:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// inserting product's price
	public static boolean addProductDocumentVirtual(String prodrefid, String colname, String val, String textboxid,
			String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into documentvirtualctrl (dvprodrefid," + colname
					+ ",dvrowid,dvtoken,dvaddedby) values (?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, prodrefid);
			ps.setString(2, val);
			ps.setString(3, textboxid);
			ps.setString(4, token);
			ps.setString(5, addedby);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addProductDocumentVirtual()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addProductDocumentVirtual:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// inserting product's price
	public static boolean addProductMilestoneVirtual(String prodrefid, String colname, String val, String textboxid,
			String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into milestonevirtualctrl (mvprodrefid," + colname
					+ ",mvrowid,mvtoken,mvaddedby) values (?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, prodrefid);
			ps.setString(2, val);
			ps.setString(3, textboxid);
			ps.setString(4, token);
			ps.setString(5, addedby);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addProductMilestoneVirtual()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addProductMilestoneVirtual:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// inserting product's price
	public static boolean addProductPriceVirtual(String prodrefid, String colname, String val, String textboxid,
			String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into productpricevirtual (ppvproductrefid," + colname
					+ ",ppvtextboxid,ppvtoken,ppvaddedby) values (?,?,?,?,?)";
//			System.out.println("pp=="+query);
			ps = con.prepareStatement(query);
			ps.setString(1, prodrefid);
			ps.setString(2, val);
			ps.setString(3, textboxid);
			ps.setString(4, token);
			ps.setString(5, addedby);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addProductPrice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addProductPrice:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// inserting product's document
	public static void saveProductDocumentDetails(String prodrefid, String docname, String description,
			String uploadfrom, String uavalidtokenno, String loginuID,String visibility) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into product_documents(pd_prodrefid,pd_docname,pd_description,pd_uploadby,pd_token,pd_addedby,pd_visibility) values (?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, prodrefid);
			ps.setString(2, docname);
			ps.setString(3, description);
			ps.setString(4, uploadfrom);
			ps.setString(5, uavalidtokenno);
			ps.setString(6, loginuID);
			ps.setString(7, visibility);
			ps.execute();
		} catch (Exception e) {
			log.info("saveProductDocumentDetails()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveProductDocumentDetails:\n" + sqle.getMessage());
			}
		}

	}

	public static void saveDefaultDocuments(String prodrefid,String loginuID,String uavalidtokenno) {
		Statement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into product_documents(pd_prodrefid,pd_docname,pd_description,"
					+ "pd_uploadby,pd_token,pd_addedby,pd_visibility) "
					+ "values ('"+prodrefid+"','Certificate','Certificate','Agent','"+uavalidtokenno+"'"
							+ ",'"+loginuID+"','1')";
			ps = con.createStatement();
			
			ps.addBatch(query);
			
			query = "insert into product_documents(pd_prodrefid,pd_docname,pd_description,"
					+ "pd_uploadby,pd_token,pd_addedby,pd_visibility) "
					+ "values ('"+prodrefid+"','Acknowledgement','Acknowledgement','Agent','"+uavalidtokenno+"'"
							+ ",'"+loginuID+"','1')";
			ps.addBatch(query);
			
			ps.executeBatch();
			
		} catch (Exception e) {
			log.info("saveDefaultDocuments()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveDefaultDocuments:\n" + sqle.getMessage());
			}
		}

	}
	
	public static void saveDefaultMilestones(String prodrefid,String loginuID,String uavalidtokenno) {
		Statement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into product_milestone(pm_prodrefid,pm_milestonename,"
					+ "pm_timelinevalue,pm_timelineunit,pmsteps,pm_assign,pm_tokeno,pm_addedby,"
					+ "pm_pricepercent) values ('"+prodrefid+"','Documentation','2','Day','1','100'"
							+ ",'"+uavalidtokenno+"','"+loginuID+"','40')";
			ps = con.createStatement();			
			ps.addBatch(query);
			
			query = "insert into product_milestone(pm_prodrefid,pm_milestonename,"
					+ "pm_timelinevalue,pm_timelineunit,pmsteps,pm_assign,pm_tokeno,pm_addedby,"
					+ "pm_pricepercent) values ('"+prodrefid+"','Filing','5','Hour','2','100'"
							+ ",'"+uavalidtokenno+"','"+loginuID+"','40')";
			ps.addBatch(query);
			
			query = "insert into product_milestone(pm_prodrefid,pm_milestonename,"
					+ "pm_timelinevalue,pm_timelineunit,pmsteps,pm_assign,pm_tokeno,pm_addedby,"
					+ "pm_pricepercent) values ('"+prodrefid+"','Liasoning','15','Day','3','100'"
							+ ",'"+uavalidtokenno+"','"+loginuID+"','40')";
			
			ps.addBatch(query);
			
			query = "insert into product_milestone(pm_prodrefid,pm_milestonename,"
					+ "pm_timelinevalue,pm_timelineunit,pmsteps,pm_assign,pm_tokeno,pm_addedby,"
					+ "pm_pricepercent) values ('"+prodrefid+"','Certification','15','Day','4','100'"
							+ ",'"+uavalidtokenno+"','"+loginuID+"','100')";
			
			ps.addBatch(query);
			
			ps.executeBatch();
			
		} catch (Exception e) {
			log.info("saveProductMilestoneDetails()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveProductMilestoneDetails:\n" + sqle.getMessage());
			}
		}

	}
	
	// inserting product's price
	public static void saveProductMilestoneDetails(String prodrefid, String milestonename, String timelinevalue,
			String timelineunit, int step, String assign, String pricePercent, String uavalidtokenno, String loginuID) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into product_milestone(pm_prodrefid,pm_milestonename,pm_timelinevalue,pm_timelineunit,pmsteps,pm_assign,pm_tokeno,pm_addedby,pm_pricepercent) values (?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, prodrefid);
			ps.setString(2, milestonename);
			ps.setString(3, timelinevalue);
			ps.setString(4, timelineunit);
			ps.setInt(5, step);
			ps.setString(6, assign);
			ps.setString(7, uavalidtokenno);
			ps.setString(8, loginuID);
			ps.setString(9, pricePercent);
			ps.execute();
		} catch (Exception e) {
			log.info("saveProductMilestoneDetails()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveProductMilestoneDetails:\n" + sqle.getMessage());
			}
		}

	}

	// inserting product's
	public static void saveProductPriceDetails(String prodrefid, String servicename, String price, String hsn,
			String cgst, String sgst, String igst, String totalprice, String uavalidtokenno, String loginuID) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into product_price(pp_prodrefid,pp_service_type,pp_price,pp_hsncode,pp_cgstpercent,pp_sgstpercent,pp_igstpercent,pp_total_price,pp_status,pp_addedby,pp_tokenno) values (?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, prodrefid);
			ps.setString(2, servicename);
			ps.setString(3, price);
			ps.setString(4, hsn);
			ps.setString(5, cgst);
			ps.setString(6, sgst);
			ps.setString(7, igst);
			ps.setString(8, totalprice);
			ps.setString(9, "1");
			ps.setString(10, loginuID);
			ps.setString(11, uavalidtokenno);
			ps.execute();
		} catch (Exception e) {
			log.info("saveProductPriceDetails()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveProductPriceDetails:\n" + sqle.getMessage());
			}
		}

	}

	// inserting product's price
	public static void addProductPrice(String pid, String price_type, String Price, String Service_Type,
			String Term_Status, String Term_Time, String GST_Status, String Gst_Percent, String Gst_Price,
			String Total_Price, String uavalidtokenno, String loginuID, String dateTime) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into product_price(pp_pid,	pp_pricetype,pp_price,pp_service_type,pp_term,pp_term_time,pp_gst_status,pp_gst,pp_gst_price,pp_total_price,pp_status,pp_addedby,pp_tokenno,pp_addedon) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, pid);
			ps.setString(2, price_type);
			ps.setString(3, Price);
			ps.setString(4, Service_Type);
			ps.setString(5, Term_Status);
			ps.setString(6, Term_Time);
			ps.setString(7, GST_Status);
			ps.setString(8, Gst_Percent);
			ps.setString(9, Gst_Price);
			ps.setString(10, Total_Price);
			ps.setString(11, "1");
			ps.setString(12, loginuID);
			ps.setString(13, uavalidtokenno);
			ps.setString(14, dateTime);
			ps.execute();
		} catch (Exception e) {
			log.info("addProductPrice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addProductPrice:\n" + sqle.getMessage());
			}
		}

	}

	public static boolean reAssignThisTaskToNewTeam(String salesrefid, String teamrefid, String today, String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update manage_assignctrl set maparentteamrefid=?,machildteamrefid=?,mateammemberid=?,mareassigndate=?,maapprovalstatus=? where masalesrefid=? and matokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, teamrefid);
			ps.setString(2, "NA");
			ps.setString(3, "NA");
			ps.setString(4, today);
			ps.setString(5, "1");
			ps.setString(6, salesrefid);
			ps.setString(7, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("reAssignThisTaskToNewTeam()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects reAssignThisTaskToNewTeam:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateFinalSalesHierarchyBySalesKey(String salesKey, String status, String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update saleshierarchymanagectrl set shmhierarchyholdstatus=? where shmsalesrefid=? and shmtoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1, status);
			ps.setString(2, salesKey);
			ps.setString(3, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateFinalSalesHierarchyBySalesKey()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateFinalSalesHierarchyBySalesKey:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateFinalSalesHierarchy(String hrefid, String status, String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update saleshierarchymanagectrl set shmhierarchyholdstatus=? where shmrefid=? and shmtoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1, status);
			ps.setString(2, hrefid);
			ps.setString(3, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateFinalSalesHierarchy()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateFinalSalesHierarchy:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateVirtualSalesHierarchy(String salesrefid, String status, String token, String addedby) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update saleshierarchy_virtual set shsalesstatus=? where shsalesrefid=? and shtoken=? and shaddedby=?";
			ps = con.prepareStatement(query);
			ps.setString(1, status);
			ps.setString(2, salesrefid);
			ps.setString(3, token);
			ps.setString(4, addedby);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateVirtualSalesHierarchy()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateVirtualSalesHierarchy:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// updating product into product_master table
	public static boolean updateProduct(String prodrefid, String servicetype, String productname,
			String productremarks) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update product_master set ptype=?,pname=?,pdescription=? where prefid=?";
			ps = con.prepareStatement(query);
			ps.setString(1, servicetype);
			ps.setString(2, productname);
			ps.setString(3, productremarks);
			ps.setString(4, prodrefid);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateProduct()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProduct:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean closeSalesReminder(String remKey, String uavalidtokenno) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update salesreminderctrl set srstatus=? where srrefid=? and srtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, "2");
			ps.setString(2, remKey);
			ps.setString(3, uavalidtokenno);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("closeSalesReminder()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects closeSalesReminder:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateSalesReminder(String remKey, String taskName, String Date, String Time,
			String uavalidtokenno) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update salesreminderctrl set srcontent=?,srreminderdate=?,srremindertime=?,srstatus=? where srrefid=? and srtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, taskName);
			ps.setString(2, Date);
			ps.setString(3, Time);
			ps.setString(4, "1");
			ps.setString(5, remKey);
			ps.setString(6, uavalidtokenno);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateSalesReminder()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateSalesReminder:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateFormTemplate(String templateKey, String dynamicFormName, String formDataJson,
			String uavalidtokenno) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update manage_template set tname=?,tmcontent=? where tkey=? and ttokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, dynamicFormName);
			ps.setString(2, formDataJson);
			ps.setString(3, templateKey);
			ps.setString(4, uavalidtokenno);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateFormTemplate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateFormTemplate:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTemplate(String tKey, String templateName, String templateSubject,
			String templateDescription, String uavalidtokenno) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "UPDATE manage_template set tname=?,tmcontent=?,tsubject=? where tkey=? and ttokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, templateName);
			ps.setString(2, templateDescription);
			ps.setString(3, templateSubject);
			ps.setString(4, tKey);
			ps.setString(5, uavalidtokenno);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateTemplate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTemplate:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean setTemplate(String tKey, String today, String dynamicFormName, String formDataJson,
			String type, String uaid, String uavalidtokenno, String templateSubject) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into manage_template(tkey,tdate,tname,tmcontent,ttype,taddedbyuid,ttokenno,tsubject) values (?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, tKey);
			ps.setString(2, today);
			ps.setString(3, dynamicFormName);
			ps.setString(4, formDataJson);
			ps.setString(5, type);
			ps.setString(6, uaid);
			ps.setString(7, uavalidtokenno);
			ps.setString(8, templateSubject);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("setTemplate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects setTemplate:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean setSalesReminder(String reminderKey, String salesrefid, String uaid, String content,
			String Date, String Time, String loginuID, String uavalidtokenno,String taskKey) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into salesreminderctrl(srrefid,srsaleskey,sraddedbyuid,srcontent,srreminderdate,srremindertime,sraddedby,srtokenno,srsalestaskkey) values (?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, reminderKey);
			ps.setString(2, salesrefid);
			ps.setString(3, uaid);
			ps.setString(4, content);
			ps.setString(5, Date);
			ps.setString(6, Time);
			ps.setString(7, loginuID);
			ps.setString(8, uavalidtokenno);
			ps.setString(9, taskKey);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("setSalesReminder()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects setSalesReminder:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// Inserting service type
	public static void addServiceType(String stype, String uavalidtokenno, String loginuID) {
		PreparedStatement ps = null;

		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into service_type(stypename,sstatus,stokenno,saddedby) values (?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, stype);
			ps.setString(2, "1");
			ps.setString(3, uavalidtokenno);
			ps.setString(4, loginuID);
			ps.execute();

		} catch (Exception e) {
			log.info("addServiceType()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addServiceType:\n" + sqle.getMessage());
			}
		}

	}

	// Inserting new tax
	public static boolean updateProductPriceHsn(String hsn, String sgst, String cgst, String igst, String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update product_price set pp_cgstpercent=?,pp_sgstpercent=?,pp_igstpercent=? where pp_hsncode=? and pp_tokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, cgst);
			ps.setString(2, sgst);
			ps.setString(3, igst);
			ps.setString(4, hsn);
			ps.setString(5, token);
			ps.execute();
			flag = true;
		} catch (Exception e) {
			log.info("updateProductPriceHsn()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductPriceHsn:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// updating new tax
	public static boolean updateNewTax(String key, String cgst, String sgst, String igst, String notes, String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update managetaxctrl set mtsgstpercent=?,mtcgstpercent=?,mtigstpercent=?,mttaxnotes=? where mtrefid=? and mttoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1, sgst);
			ps.setString(2, cgst);
			ps.setString(3, igst);
			ps.setString(4, notes);
			ps.setString(5, key);
			ps.setString(6, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addNewTax()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addNewTax:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// Inserting new tax
	public static boolean addNewTax(String key, String hsn, String cgst, String sgst, String igst, String notes,
			String uavalidtokenno, String loginuID) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into managetaxctrl(mtrefid,mthsncode,mtsgstpercent,mtcgstpercent,mtigstpercent,mttaxnotes,mttoken,mtaddedby) values (?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, key);
			ps.setString(2, hsn);
			ps.setString(3, sgst);
			ps.setString(4, cgst);
			ps.setString(5, igst);
			ps.setString(6, notes);
			ps.setString(7, uavalidtokenno);
			ps.setString(8, loginuID);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addNewTax()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addNewTax:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateNewTeam(String teamkey, String deptname, String teamname, String leadername,
			String leadercode, String leaderid, String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update manageteamctrl set mtdepartment=?,mtteamname=?,mtadminname=?,mtadmincode=?,mtadminid=? where mtrefid=? and mttoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1, deptname);
			ps.setString(2, teamname);
			ps.setString(3, leadername);
			ps.setString(4, leadercode);
			ps.setString(5, leaderid);
			ps.setString(6, teamkey);
			ps.setString(7, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("updateNewTeam()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateNewTeam:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// creating new team
	public static boolean createNewTeam(String teamkey, String deptname, String teamname, String leadername,
			String leadercode, String leaderid, String date, String token, String addedby) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into manageteamctrl(mtrefid,mtdate,mtdepartment,mtteamname,mtadminname,mtadmincode,mtadminid,mttoken,mtaddedby) values (?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, teamkey);
			ps.setString(2, date);
			ps.setString(3, deptname);
			ps.setString(4, teamname);
			ps.setString(5, leadername);
			ps.setString(6, leadercode);
			ps.setString(7, leaderid);
			ps.setString(8, token);
			ps.setString(9, addedby);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("createNewTeam()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects createNewTeam:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// Inserting into virtual member
	public static boolean addMember(String key, String membername, String membercode, String memberuaid,
			String uavalidtokenno, String loginuID, String date) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into virtualteammemberctrl(vtrefid,vtdate,vtregcode,vtname,vttoken,vtaddedby,vtuid) values (?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, key);
			ps.setString(2, date);
			ps.setString(3, membercode);
			ps.setString(4, membername);
			ps.setString(5, uavalidtokenno);
			ps.setString(6, loginuID);
			ps.setString(7, memberuaid);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addMember()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addMember:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	// Inserting product into product_master table
	public static boolean addProduct(String pname, String premarks, String uavalidtokenno, String loginuID,
			String ptype, String prodkey, String key) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into product_master(pname,pdescription,pstatus,paddedby,ptokenno,ptype,pprodid,prefid) values (?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, pname);
			ps.setString(2, premarks);
			ps.setString(3, "1");
			ps.setString(4, loginuID);
			ps.setString(5, uavalidtokenno);
			ps.setString(6, ptype);
			ps.setString(7, prodkey);
			ps.setString(8, key);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("addProduct()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addProduct:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	/* For saving assigntask jsp details by submit */
	public static boolean saveTaskDetail(String ptltuid, String ptlpuid, String ptlby, String ptlto, String ptlname,
			String ptlremark, String ptladate, String ptlddate, String ptladdedby, String company) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into projecttask_list(ptltuid,ptlpuid,ptlby,ptlto,ptlname,ptlremark,ptladate,ptlddate,ptladdedby, ptlcompany) values ('"
					+ ptltuid + "','" + ptlpuid + "','" + ptlby + "','" + ptlto + "','" + ptlname + "','" + ptlremark
					+ "','" + ptladate + "','" + ptlddate + "','" + ptladdedby + "','" + company + "')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("saveTaskDetail()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveTaskDetail:\n" + sqle.getMessage());
			}
		}
		return status;
	}

	/* For providing uniqueid to taskid */
	public static String getmanifescode(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT ptltuid FROM projecttask_list where ptltokenno='" + token
					+ "' order by ptluid desc limit 1";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("Error in getmanifescode method \n" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("Error Closing SQL Objects getmanifescode:\n" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* For manage-task page */
	public static String[][] getAlltask(String pregpname, String taskname, String assignon, String deliveron,
			String token, String from, String to) {
		ResultSet rsGCD = null;
		PreparedStatement psGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			if (pregpname == null || pregpname.equalsIgnoreCase("Any") || pregpname.length() <= 0) {
				pregpname = "NA";
			}
			if (taskname == null || taskname.equalsIgnoreCase("Any") || taskname.length() <= 0) {
				taskname = "NA";
			}
			if (assignon == null || assignon.equalsIgnoreCase("Any") || assignon.length() <= 0) {
				assignon = "NA";
			}
			if (deliveron == null || deliveron.equalsIgnoreCase("Any") || deliveron.length() <= 0) {
				deliveron = "NA";
			}
			if (from == null || from.equalsIgnoreCase("Any") || from.length() <= 0) {
				from = "NA";
			}
			if (to == null || to.equalsIgnoreCase("Any") || to.length() <= 0) {
				to = "NA";
			}
			VCQUERY = new StringBuffer(
					"SELECT ptluid,ptlname,pregpname,ptlpuid,ptladate, ptlby, ptlto,ptlddate FROM projecttask_list join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where pregtokenno='"
							+ token + "'");
			if (pregpname != "NA") {
				VCQUERY.append(" and  pregpname = '" + pregpname + "'");
			}
			if (taskname != "NA") {
				VCQUERY.append(" and  ptlname = '" + taskname + "'");
			}
			if (assignon != "NA") {
				VCQUERY.append(" and  ptladate = '" + assignon + "'");
			}
			if (deliveron != "NA") {
				VCQUERY.append(" and  ptlddate = '" + deliveron + "'");
			}
			if (from != "NA" && to == "NA")
				VCQUERY.append(" and ptladdedon like '" + from + "%'");
			if (from != "NA" && to != "NA")
				VCQUERY.append(" and ptladdedon between '" + from + "%' and '" + to + "%'");
			VCQUERY.append(" order by ptluid desc limit 100");
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
			log.info("Error in getAlltask method \n" + e.getMessage());
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
				log.info("Error in getAlltask method \n" + e.getMessage());
			}
		}
		return newsdata;
	}

	// getting product_price details
	public static String[][] getEnqProductPrice(String id) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT id,pricetype,price,servicetype,term,termtime,gststatus,gst,gstprice,totalprice FROM project_price WHERE penqsale='1' and preguid='"
					+ id + "' order by id desc";
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
			log.info("Error in getEnqProductPrice method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getEnqProductPrice:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesMilestoneByKey(String salesrefid, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT smrefid,smstep,smmilestonename,smpricepercentage,smnextassignpercentage from salesmilestonectrl WHERE smsalesrefid='"
					+ salesrefid + "'  and smtoken='" + token + "' order by smid";
//			System.out.println(query);
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
			log.info("Error in getSalesMilestoneByKey method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSalesMilestoneByKey:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

//getting product_price details 
	public static String[][] getProductPrice(String id) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT ppid,pp_pricetype,pp_price,pp_service_type,	pp_term,pp_term_time,pp_gst_status,pp_gst,pp_gst_price,pp_total_price FROM product_price WHERE pp_pid='"
					+ id + "' order by ppid desc";
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
			log.info("Error in getProductPrice method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProductPrice:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	/* For manage-task page */
	public static String[][] getAlltask1(String uaid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT uaname FROM user_account WHERE uaid='" + uaid + "' ";
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
			log.info("Error in getAlltask1 method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAlltask1:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting product's Gst status
	public static String getGstStatus(String id) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String status = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "select pp_gst_status from product_price WHERE pp_pid='" + id + "' ";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			while (rs.next()) {
				if (rs.getString(1).equalsIgnoreCase("Included") || rs.getString(1).equalsIgnoreCase("Excluded")) {
					status = "Yes";
					break;
				} else {
					status = "No";
				}
			}
		} catch (Exception e) {
			log.info("Error in getGstStatus method \n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getGstStatus:\n" + sqle.getMessage());
			}
		}
		return status;
	}

	// getting product's total price
	public static String getTotalPrice(String id) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String status = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "select sum(pp_total_price) from product_price WHERE pp_pid='" + id + "' ";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				status = rs.getString(1);

		} catch (Exception e) {
			log.info("Error in getTotalPrice method \n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalPrice:\n" + sqle.getMessage());
			}
		}
		return status;
	}

	// getting product service type
	public static String getServiceType(String id) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String status = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "select pp_service_type from product_price WHERE pp_pid='" + id + "' ";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			while (rs.next()) {
				if (rs.getString(1).equalsIgnoreCase("Renewal")) {
					status = "Renewal";
					break;
				} else {
					status = "One Time";
				}
			}
		} catch (Exception e) {
			log.info("Error in getServiceType method \n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getServiceType:\n" + sqle.getMessage());
			}
		}
		return status;
	}

	// getting task details
	public static String[] getOldHsnDetails(String hsn, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[] newsdata = new String[3];
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select mtsgstpercent,mtcgstpercent,mtigstpercent from managetaxctrl where mthsncode='" + hsn
					+ "' and mttoken	='" + token + "'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			if (rsGCD.next()) {
				newsdata[0] = rsGCD.getString(1);
				newsdata[1] = rsGCD.getString(2);
				newsdata[2] = rsGCD.getString(3);
			}
		} catch (Exception e) {
			log.info("Error in getOldHsnDetails method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getOldHsnDetails:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting product's details
	public static String[] TaskMaster_ACT1(String token, String id) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[] newsdata = new String[3];
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select tname,tmessage,ttype from manage_template where tid='" + id + "' and ttokenno	='"
					+ token + "'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			if (rsGCD.next()) {
				newsdata[0] = rsGCD.getString(1);
				newsdata[1] = rsGCD.getString(2);
				newsdata[2] = rsGCD.getString(3);
			}
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects TaskMaster_ACT:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static double[] getTotalSalesAmountPercent(String token) {

		double[] newsdata = new double[2];
		try {
			double salesData[] = getTotalInvoiceData(token);
			if (salesData[0] > 0) {
				newsdata[0] = (100 * salesData[1]) / salesData[0];
				newsdata[1] = (100 * salesData[2]) / salesData[0];
			}

		} catch (Exception e) {
			e.printStackTrace();
			log.info("Error in TaskMaster_ACT method getTotalSalesAmountPercent:\n" + e.getMessage());
		}

		return newsdata;
	}

	public static double[] getTotalInvoiceData(String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		double[] newsdata = new double[3];
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select sum(cborderamount),sum(cbpaidamount),sum(cbdueamount) from hrmclient_billing where cbinvoiceno!='NA' and cbtokenno='"
					+ token + "'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			if (rsGCD.next()) {
				newsdata[0] = rsGCD.getDouble(1);
				newsdata[1] = rsGCD.getDouble(2);
				newsdata[2] = rsGCD.getDouble(3);
			}
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method getTotalInvoiceData:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalInvoiceData:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	// getting product's details
	public static double[] getProductDetails(String prodrefid, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		double[] newsdata = new double[3];
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select sum(pp_price),sum(pp_total_price) from product_price where pp_prodrefid='"
					+ prodrefid + "' and pp_tokenno='" + token + "'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			if (rsGCD.next())
				newsdata[0] = rsGCD.getDouble(1);
			newsdata[1] = rsGCD.getDouble(2);
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method getProductDetails:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProductDetails:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int getTotalProductType(String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		try {

			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("SELECT count(sid) FROM service_type WHERE stokenno='" + token + "'");

//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method getTotalProductType:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalProductType:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int getAllRecentlyAddedProduct(String fromDate, String toDate, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT count(pid) FROM product_master WHERE ptokenno='" + token + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(paddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(paddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method getTotalProducts:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalProducts:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int getCompletedGuide(String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT pid FROM product_master WHERE exists(select sgid from step_guide where sgprodkey=prefid and sgtoken='"
							+ token + "' group by sgprodkey) and ptokenno='" + token + "'");

//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata++;
			}
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method getTotalProducts:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalProducts:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static int getTotalProducts(String productname, String productId, String dateRange, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT count(pid) FROM product_master WHERE ptokenno='" + token + "'");
			if (!productname.equalsIgnoreCase("NA"))
				query.append(" and pname ='" + productname + "'");
			if (!productId.equalsIgnoreCase("NA"))
				query.append(" and pprodid = '" + productId + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(paddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(paddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method getTotalProducts:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalProducts:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getTopFiveServices(String role, String uaid, String teamKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = "";
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (role.equals("Admin") || role.equals("Manager"))
				query = "SELECT msproducttype,count(msproducttype) FROM managesalesctrl WHERE mstoken='" + token
						+ "' and msstatus='1' group by msproducttype order by count(msproducttype) desc limit 5";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				query = "SELECT msproducttype,count(msproducttype) FROM managesalesctrl WHERE mstoken='" + token
						+ "' and msstatus='1' and exists(select tmid from manageteammemberctrl where tmteamrefid='"
						+ teamKey + "' and tmuseruid=mssoldbyuid) or mssoldbyuid='" + uaid
						+ "' group by msproducttype order by count(msproducttype) desc limit 5";
			} else {
				query = "SELECT msproducttype,count(msproducttype) FROM managesalesctrl WHERE mstoken='" + token
						+ "' and msstatus='1' and mssoldbyuid='" + uaid
						+ "' group by msproducttype order by count(msproducttype) desc limit 5";
			}
//			System.out.println(query);
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
			log.info("Error in TaskMaster_ACT method getTopFiveServices:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTopFiveServices:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getTopFiveSalesProduct(String role, String uaid, String teamKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = "";
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (role.equals("Admin") || role.equals("Manager"))
				query = "SELECT msproductname,count(msproductname) FROM managesalesctrl WHERE mstoken='" + token
						+ "' and msstatus='1' group by msproductname order by count(msproductname) desc limit 5";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				query = "SELECT msproductname,count(msproductname) FROM managesalesctrl WHERE mstoken='" + token
						+ "' and msstatus='1' and exists(select tmid from manageteammemberctrl where tmteamrefid='"
						+ teamKey + "' and tmuseruid=mssoldbyuid) or mssoldbyuid='" + uaid
						+ "' group by msproductname order by count(msproductname) desc limit 5";
			} else {
				query = "SELECT msproductname,count(msproductname) FROM managesalesctrl WHERE mstoken='" + token
						+ "' and msstatus='1' and mssoldbyuid='" + uaid
						+ "' group by msproductname order by count(msproductname) desc limit 5";
			}
//			System.out.println(query);
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
			log.info("Error in TaskMaster_ACT method getTopFiveSalesProduct:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTopFiveSalesProduct:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getRenewalCertificates(String milestoneuuid, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT sddocname FROM salesdocumentctrl WHERE sdmilestoneuuid='"+milestoneuuid+"' and sdtokenno='" + token
							+ "'");
//			System.out.println(query);
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
			log.info("Error in TaskMaster_ACT method getRenewalCertificates:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getRenewalCertificates:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getRecentActiveProjects(String role,String teamKey,String uaid,
			String token, String status,String loginuaid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT msproductname,msassignedtoname,msrefid FROM managesalesctrl WHERE mstoken='" + token
							+ "' and msstatus='1' and msworkpercent!='100'");
			
				if(teamKey!=null&&!teamKey.equalsIgnoreCase("NA"))
					query.append(" and msassignedtorefid='"+teamKey+"'");
				
				if(uaid!=null&&uaid.length()>0)
					query.append(" and mssoldbyuid='"+uaid+"'");
			
				if(teamKey.equalsIgnoreCase("NA")&&(uaid==null||uaid.length()<=0)&&!role.equalsIgnoreCase("Admin"))
						query.append(" and mssoldbyuid='"+loginuaid+"'");
				
			if (!status.equalsIgnoreCase("NA"))
				query.append(" and msworkstatus='" + status + "'");
			
			query.append(" order by msid desc limit 5");
//			System.out.println(query);
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
			e.printStackTrace();
			log.info("Error in TaskMaster_ACT method getRecentActiveProjects:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getRecentActiveProjects:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getRecentCommunication(String role, String uaid, String teamKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = "";
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (role.equals("Admin") || role.equals("Manager"))
				query = "SELECT pfaddedbyname,pfdate,pftime FROM hrmproject_followup WHERE pftokenno='" + token
						+ "' group by pfaddedbyuid order by pfuid desc limit 4";
			else if (role.equals("Assistant") && !teamKey.equals("NA"))
				query = "SELECT pfaddedbyname,pfdate,pftime FROM hrmproject_followup WHERE pftokenno='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=pfaddedbyuid) or pfaddedbyuid='" + uaid
						+ "' group by pfaddedbyuid order by pfuid desc limit 4";
			else
				query = "SELECT pfaddedbyname,pfdate,pftime FROM hrmproject_followup WHERE pftokenno='" + token
						+ "' and pfaddedbyuid='" + uaid + "' group by pfaddedbyuid order by pfuid desc limit 4";
//			System.out.println(query);
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
			e.printStackTrace();
			log.info("Error in TaskMaster_ACT method getRecentCommunication:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getRecentCommunication:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getRecentActiveTask(String role, String uaid, String teamKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query = "";
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (role.equals("Admin") || role.equals("Manager"))
				query = "SELECT mamilestonename,maworkpercentage,mateammemberid,maworkstarteddate,mamilestonerefid,madeliverydate FROM manage_assignctrl WHERE matokenno='"
						+ token
						+ "' and mateammemberid!='NA' and maworkstarteddate!='00-00-0000' and maworkpercentage!='100' and masaleshierarchystatus='1' and mahierarchyactivestatus='1' and maapprovalstatus='1' and mastepstatus='1' order by maid desc limit 6";
			else if (role.equals("Assistant") && !teamKey.equals("NA"))
				query = "SELECT mamilestonename,maworkpercentage,mateammemberid,maworkstarteddate,mamilestonerefid,madeliverydate FROM manage_assignctrl WHERE matokenno='"
						+ token + "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=mateammemberid) or mateammemberid='" + uaid
						+ "' and mateammemberid!='NA' and maworkstarteddate!='00-00-0000' and maworkpercentage!='100' and masaleshierarchystatus='1' and mahierarchyactivestatus='1' and maapprovalstatus='1' and mastepstatus='1' order by maid desc limit 6";
			else
				query = "SELECT mamilestonename,maworkpercentage,mateammemberid,maworkstarteddate,mamilestonerefid,madeliverydate FROM manage_assignctrl WHERE matokenno='"
						+ token + "' and mateammemberid!='NA' and mateammemberid='" + uaid
						+ "' and maworkstarteddate!='00-00-0000' and maworkpercentage!='100' and masaleshierarchystatus='1' and mahierarchyactivestatus='1' and maapprovalstatus='1' and mastepstatus='1' order by maid desc limit 6";
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.info("Error in TaskMaster_ACT method getRecentActiveTask:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getRecentActiveTask:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllRecentProjectsCommunication(String role, String uaid, String teamKey,
			String projectNo, String dateRange, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
//		String fromDate="NA";
//		String toDate="NA";
		String queryselect = "";
		try {
			getacces_con = DbCon.getCon("", "", "");

			/*
			 * if(!dateRange.equalsIgnoreCase("NA")){
			 * fromDate=dateRange.substring(0,10).trim();
			 * fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.
			 * substring(0,2); toDate=dateRange.substring(13).trim();
			 * toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2
			 * ); } StringBuffer query=new
			 * StringBuffer("SELECT tnsalesrefid,tnsalesname,tnprojectno FROM task_notification WHERE tntokenno='"
			 * +token+"' and tnstatus='1' and tnheading='Public Reply'");
			 * if(!projectNo.equalsIgnoreCase("NA"))query.append(" and tnprojectno like '"
			 * +projectNo+"%'");
			 * if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
			 * query.append(" and str_to_date(tnaddedon,'%Y-%m-%d')<='"
			 * +toDate+"' and str_to_date(tnaddedon,'%Y-%m-%d')>='"+fromDate+"'"); }
			 * query.append(" group by tnprojectno order by tnid desc limit 2");
			 */

			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "SELECT tnsalesrefid,tnsalesname,tnprojectno FROM task_notification WHERE tntokenno='"
						+ token
						+ "' and tnstatus='1' and tnheading='Public Reply' group by tnprojectno order by tnid desc limit 3";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "SELECT tnsalesrefid,tnsalesname,tnprojectno FROM task_notification WHERE tntokenno='"
						+ token
						+ "' and tnstatus='1' and tnheading='Public Reply' and exists(select tmid from manageteammemberctrl where tmteamrefid='"
						+ teamKey + "' and tmuseruid=tnaddedbyid) or tnaddedbyid='" + uaid
						+ "' group by tnprojectno order by tnid desc limit 3";
			} else {
				queryselect = "SELECT tnsalesrefid,tnsalesname,tnprojectno FROM task_notification WHERE tntokenno='"
						+ token + "' and tnstatus='1' and tnheading='Public Reply' and tnaddedbyid='" + uaid
						+ "' group by tnprojectno order by tnid desc limit 3";
			}

//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(queryselect);
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
			log.info("Error in TaskMaster_ACT method getAllRecentProjectsCommunication:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllRecentProjectsCommunication:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllRecentProjects(String role, String uaid, String teamKey, String projectName,
			String dateRange, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		/*
		 * String fromDate="NA"; String toDate="NA";
		 */
		String queryselect = "";
		try {
			getacces_con = DbCon.getCon("", "", "");
			/*
			 * if(!dateRange.equalsIgnoreCase("NA")){
			 * fromDate=dateRange.substring(0,10).trim();
			 * fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.
			 * substring(0,2); toDate=dateRange.substring(13).trim();
			 * toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2
			 * ); } StringBuffer query=new
			 * StringBuffer("SELECT msrefid,msprojectnumber,msinvoiceno,mscompany,msproducttype,msproductname,mssoldbyuid,mssolddate,msworkpercent,msworkstatus,msassignedtoname,msworkpriority FROM managesalesctrl WHERE mstoken='"
			 * +token+"' and msstatus='1'"); if(!projectName.equalsIgnoreCase("NA"))query.
			 * append(" and msproductname like '"+projectName+"%'");
			 * if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
			 * query.append(" and str_to_date(msaddedon,'%Y-%m-%d')<='"
			 * +toDate+"' and str_to_date(msaddedon,'%Y-%m-%d')>='"+fromDate+"'"); }
			 * query.append(" order by msid desc limit 5");
			 */

			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "SELECT msrefid,msprojectnumber,msinvoiceno,mscompany,msproducttype,msproductname,mssoldbyuid,mssolddate,msworkpercent,msworkstatus,msassignedtoname,msworkpriority FROM managesalesctrl WHERE mstoken='"
						+ token + "' and msstatus='1' order by msid desc limit 5";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "SELECT msrefid,msprojectnumber,msinvoiceno,mscompany,msproducttype,msproductname,mssoldbyuid,mssolddate,msworkpercent,msworkstatus,msassignedtoname,msworkpriority FROM managesalesctrl WHERE mstoken='"
						+ token
						+ "' and msstatus='1' and exists(select tmid from manageteammemberctrl where tmteamrefid='"
						+ teamKey + "' and tmuseruid=mssoldbyuid) or mssoldbyuid='" + uaid
						+ "' order by msid desc limit 5";
			} else {
				queryselect = "SELECT msrefid,msprojectnumber,msinvoiceno,mscompany,msproducttype,msproductname,mssoldbyuid,mssolddate,msworkpercent,msworkstatus,msassignedtoname,msworkpriority FROM managesalesctrl WHERE mstoken='"
						+ token + "' and msstatus='1' and mssoldbyuid='" + uaid + "' order by msid desc limit 5";
			}

//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(queryselect);
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
			log.info("Error in TaskMaster_ACT method getAllRecentProjects:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllRecentProjects:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

//geting all product 
	public static String[][] getAllProducts(String productname, String productId, String dateRange, String token,int page,int rows,String sort,String order) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			getacces_con = DbCon.getCon("", "", "");
			
			StringBuffer query = new StringBuffer(
					"SELECT pname,pid,pstatus,pprodid,prefid,paddedon FROM product_master WHERE ptokenno='" + token + "'");
			if (!productname.equalsIgnoreCase("NA"))
				query.append(" and pname ='" + productname + "'");
			if (!productId.equalsIgnoreCase("NA"))
				query.append(" and pprodid = '" + productId + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				query.append(" and str_to_date(paddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(paddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			if(sort.length()<=0)			
				query.append("group by pid order by pid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))query.append("order by paddedon "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("product_no"))query.append("order by pprodid "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("name"))query.append("order by pname "+order+" limit "+((page-1)*rows)+","+rows);				
				
//			System.out.println(query);
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
			log.info("Error in TaskMaster_ACT method getAllProducts:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllProducts:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getCouponByKey(String uuid, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {

			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT * FROM manage_coupon WHERE token='" + token + "' and uuid='" + uuid + "'");

//			System.out.println(query);
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
			log.info("Error in TaskMaster_ACT method getCouponByKey:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getCouponByKey:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getProducts(String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {

			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer(
					"SELECT pprodid,pname FROM product_master WHERE ptokenno='" + token + "' and pstatus='1'");

//			System.out.println(query);
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
			log.info("Error in TaskMaster_ACT method getProducts:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProducts:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	/* For manage-task page */
	public static String[][] getAlltask2(String uaid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT uaname FROM user_account WHERE uaid='" + uaid + "' ";
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
			log.info("Error in TaskMaster_ACT method getAlltask2:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAlltask2:\n" + sqle);
			}
		}
		return newsdata;
	}

	public static boolean removeStepGuideStep(String key, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "delete from step_guide WHERE sgkey='" + key + "' and sgtoken='" + token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method removeStepGuideStep:\n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects removeStepGuideStep:\n" + sqle);
			}
		}
		return status;
	}

	public static boolean removeStepGuideDocument(String key, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update step_guide set sgdocument='NA' WHERE sgkey='" + key + "' and sgtoken='" + token
					+ "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method removeStepGuideDocument:\n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects removeStepGuideDocument:\n" + sqle);
			}
		}
		return status;
	}

	public static boolean deleteTriggerCondition(String tcKey) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM trigger_condition WHERE tcKey='" + tcKey + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method deleteTriggerCondition:\n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteTriggerCondition:\n" + sqle);
			}
		}
		return status;
	}

	public static boolean deleteTriggerAction(String taKey) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM trigger_action WHERE taKey='" + taKey + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method deleteTriggerAction:\n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteTriggerAction:\n" + sqle);
			}
		}
		return status;
	}

	public static boolean deleteTrigger(String tKey, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM triggers WHERE tKey='" + tKey + "' and tToken='" + token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method deleteTrigger:\n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteTrigger:\n" + sqle);
			}
		}
		return status;
	}

	public static boolean removeStepGuide(String milestoneId, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM step_guide WHERE sgmilestoneid='" + milestoneId + "' and sgtoken='" + token
					+ "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method removeStepGuide:\n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects removeStepGuide:\n" + sqle);
			}
		}
		return status;
	}

	/* For delete on assign-task jsp */
	public static boolean deleteAdd(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM projecttask_list WHERE ptluid='" + uid + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method deleteAdd:\n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteAdd:\n" + sqle);
			}
		}
		return status;
	}

	/* For delete on manage-task */
	public static boolean deleteTask(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM projecttask_list WHERE ptluid='" + uid + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method deleteTask:\n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteTask:\n" + sqle);
			}
		}
		return status;
	}

	public static boolean updateTaskDetail(String ptluid, String ptltuid, String ptlpuid, String ptlby, String ptlname,
			String ptlremark, String ptladate, String ptlddate, String ptladdedby) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "UPDATE projecttask_list SET ptltuid=?, ptlpuid=?,ptlby=?, ptlname=?,ptlremark=?, ptladate=?,ptlddate=?,ptladdedby=? WHERE ptluid=?";
			ps = con.prepareStatement(query);
			ps.setString(1, ptltuid);
			ps.setString(2, ptlpuid);
			ps.setString(3, ptlby);
			ps.setString(4, ptlname);
			ps.setString(5, ptlremark);
			ps.setString(6, ptladate);
			ps.setString(7, ptlddate);
			ps.setString(8, ptladdedby);
			ps.setString(9, ptluid);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method updateTaskDetail:\n" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTaskDetail:\n" + sqle);
			}
		}
		return status;
	}

	public static String[][] getAllAttachedFiles(String milestoneId, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT sgdocument FROM step_guide where sgmilestoneid='" + milestoneId + "' and sgtoken='"
					+ token + "' and sgdocument!='NA'";
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
			log.info("Error in TaskMaster_ACT method getAllAttachedFiles:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllAttachedFiles:\n" + sqle);
			}
		}
		return newsdata;
	}

	/* For edit-task jsp */
	public static String[][] getTaskByID(String uid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT ptltuid,ptlname,ptladate,ptlddate,ptlremark,pregpname,ptlpuid,ptlby,ptlto,pregtype,pregpuno,preguid,pregcuid FROM projecttask_list join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where ptluid='"
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
			log.info("Error in TaskMaster_ACT method getTaskByID:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTaskByID:\n" + sqle);
			}
		}
		return newsdata;
	}

	/* For edit-task jsp */
	public static String[][] getTaskByID1(String uid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT uaname FROM user_account join projecttask_list on user_account.uaid=projecttask_list.ptlby where ptluid='"
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
			log.info("Error in TaskMaster_ACT method getTaskByID1:\n" + e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTaskByID1:\n" + sqle);
			}
		}
		return newsdata;
	}

	/* For edit-task jsp */
	public static String[][] getTaskByID2(String uid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			String query = "SELECT uaname FROM user_account LEFT join projecttask_list on user_account.uaid=projecttask_list.ptlto where ptluid='"
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
			log.info("Error in TaskMaster_ACT method getTaskByID2:\n" + e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTaskByID2:\n" + sqle);
			}
		}
		return newsdata;
	}

	public static String[][] getAllTasksById(String uid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			String query = "SELECT amonpstatype, amonpststatus,amopsaddedon,amopssourl,amonpsturl,amopsseng, websitenature FROM amonpage_seo join projecttask_list on amonpstuid=ptluid where ptluid='"
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
			log.info("Error in TaskMaster_ACT method getAllTasksById:\n" + e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllTasksById:\n" + sqle);
			}
		}
		return newsdata;
	}

	public static String[][] getStatusReport(String uid, String token, String preguid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			String query = "SELECT pfuremark,pfustatus,pfudate,pfuid,pts_taskid,pfuaddedby,pftaskname,followupby,pfmsgfor,pfimgurl,pfuuserrefid FROM hrmproject_followup where pfupid='"
					+ preguid + "' and pftokenno='" + token + "' order by pfuid";
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
			log.info("Error in TaskMaster_ACT method getStatusReport:\n" + e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getStatusReport:\n" + sqle);
			}
		}
		return newsdata;
	}

	public static String checkTName(String tname) {
		Connection GDCON = null;
		ResultSet DRS = null;
		PreparedStatement GPS = null;
		String ex_user = null;
		String status = "10";
		try {
			GDCON = DbCon.getCon("", "", "");
			String query = "select ptlname from projecttask_list where ptlname='" + tname + "'";
			// System.out.println(query);
			GPS = GDCON.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			DRS = GPS.executeQuery();
			DRS.last();
			DRS.beforeFirst();
			while (DRS != null && DRS.next()) {
				ex_user = DRS.getString(1);
				if (ex_user.equalsIgnoreCase(tname)) {
					status = "20";
					break;
				}
			}
		} catch (Exception e) {
			log.info("Error in TaskMaster_ACT method checkTName:\n" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (GPS != null) {
					GPS.close();
				}
				if (DRS != null) {
					DRS.close();
				}
				if (GDCON != null) {
					GDCON.close();
				}
			} catch (SQLException e) {
				log.info("Error in TaskMaster_ACT method checkTName:\n" + e.getMessage());
			}
		}
		return status;
	}

	public static String getinvoiceNoByKey(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select msinvoiceno from managesalesctrl where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getinvoiceNoByKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getinvoiceNoByKey" + e.getMessage());
			}
		}
		return data;
	}

	public static String[][] getSalesDataFollowUp(String salesKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
//					String date=before2date.substring(6)+"-"+before2date.substring(3,5)+"-"+before2date.substring(0,2);
//					System.out.println("reverse todays date==="+before2date+"/today=="+today);
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT msclientrefid,mscontactrefid,msprojectnumber,mschatnotreplydate,msrefid,msproductname,project_close_date,msinvoiceno FROM managesalesctrl where msstatus='1' and msrefid='"+salesKey+"' and mstoken='"+token+"'";
//					System.out.println(query);
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
			log.info("Error in TaskMaster_ACT method getSalesDataFollowUp:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSalesDataFollowUp:\n" + sqle);
			}
		}
		return newsdata;
	}
	
	public static String[][] getSalesDataWhomNotRepliedFollowUp(String before1date,String before3date,String before7date,String today) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
//					String date=before2date.substring(6)+"-"+before2date.substring(3,5)+"-"+before2date.substring(0,2);
//					System.out.println("reverse todays date==="+before2date+"/today=="+today);
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT msclientrefid,mscontactrefid,msprojectnumber,mschatnotreplydate,"
					+ "msrefid,msproductname,project_close_date FROM managesalesctrl where msstatus='1' "
					+ "and mschatnotreplied!='0' and mschatnotreplydate!='NA' and "
					+ "(str_to_date(mschatnotreplydate,'%d-%m-%Y')='"+ before1date + "' or str_to_date(mschatnotreplydate,'%d-%m-%Y')='"+ before3date + "' or "
							+ "str_to_date(mschatnotreplydate,'%d-%m-%Y')='"+ before7date + "')"
					+ " and (mschatnotemaildate='NA' or str_to_date(mschatnotemaildate,'%d-%m-%Y')!='"+ today + "')";
//					System.out.println(query);
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
			log.info("Error in TaskMaster_ACT method getSalesDataWhomNotRepliedFollowUp:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSalesDataWhomNotRepliedFollowUp:\n" + sqle);
			}
		}
		return newsdata;
	}

	public static String getContactEmail(String contactKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select cbname,cbemail1st from contactboxctrl where cbrefid=? and cbstatus=? order by cbid limit 1";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, contactKey);
			ps.setString(2, "1");

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1) + "#" + rs.getString(2);
			}
		} catch (Exception e) {
			log.info("getContactEmail" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getContactEmail" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean updateSalesEmailSendDate(String salesKey, String todayDate) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update managesalesctrl set mschatnotemaildate='" + todayDate
					+ "' where msrefid='" + salesKey + "'");

			ps = con.prepareStatement(queryselect.toString());
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateSalesEmailSendDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateSalesEmailSendDate" + e.getMessage());
			}
		}
		return flag;
	}

	public static String[][] getTriggerData(String triggerKey, String uavalidtokenno) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT tName,tDescription,tConditionKey,tActionKey FROM triggers where tKey='" + triggerKey
					+ "' and tToken='" + uavalidtokenno + "'";
//			System.out.println(query);
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
			log.info("Error in TaskMaster_ACT method getTriggerDate:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTriggerDate:\n" + sqle);
			}
		}
		return newsdata;
	}

	public static boolean updateTrigger(String triggerKey, String triggerName, String triggerDescription,
			String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update triggers set tName=?,tDescription=? where tKey=? and tToken=?");

			ps = con.prepareStatement(queryselect.toString());
			ps.setString(1, triggerName);
			ps.setString(2, triggerDescription);
			ps.setString(3, triggerKey);
			ps.setString(4, uavalidtokenno);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateTrigger" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateTrigger" + e.getMessage());
			}
		}
		return flag;
	}

	public static String getHsnCode(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select mthsncode from managetaxctrl where mtsgstpercent='9' and mtcgstpercent='9' and mttoken='"
					+ token + "' order by mtid limit 1";
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getHsnCode" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getHsnCode" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isPaymentDone(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT cbdueamount FROM hrmclient_billing where cbinvoiceno='" + invoice
					+ "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				if (rset.getDouble(1) <= 0)
					getinfo = true;
			}
		} catch (Exception e) {
			log.info("isPaymentDone" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isPaymentDone" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static long countAllAheadTask(String startDate, String monthEndDate, String token, String role, String uaid,
			String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		long data = 0;
		String queryselect = "";
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and maworkstarteddate!='00-00-0000' and madelivereddate!='NA' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' and maworkpercentage='100' and str_to_date(madeliverydate,'%d-%m-%Y')>madelivereddate";
			else if (role.equals("Assistant") && !teamKey.equals("NA"))
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=mateammemberid) or mateammemberid='" + uaid
						+ "' and maworkstarteddate!='00-00-0000' and madelivereddate!='NA' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' and maworkpercentage='100' and str_to_date(madeliverydate,'%d-%m-%Y')>madelivereddate";
			else
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and mateammemberid='" + uaid
						+ "' and maworkstarteddate!='00-00-0000' and madelivereddate!='NA' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' and maworkpercentage='100' and str_to_date(madeliverydate,'%d-%m-%Y')>madelivereddate";

			// System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getLong(1);
			}
		} catch (Exception e) {
			log.info("countAllAheadTask" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("countAllAheadTask" + e.getMessage());
			}
		}
		return data;
	}

	public static long countAllOnTimeTask(String startDate, String monthEndDate, String token, String role, String uaid,
			String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		long data = 0;
		String queryselect = "";
		try {

			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and maworkstarteddate!='00-00-0000' and madelivereddate!='NA' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' and maworkpercentage='100' and str_to_date(madeliverydate,'%d-%m-%Y')=madelivereddate";
			else if (role.equals("Assistant") && !teamKey.equals("NA"))
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=mateammemberid) or mateammemberid='" + uaid
						+ "' and maworkstarteddate!='00-00-0000' and madelivereddate!='NA' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' and maworkpercentage='100' and str_to_date(madeliverydate,'%d-%m-%Y')=madelivereddate";
			else
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and mateammemberid='" + uaid
						+ "' and maworkstarteddate!='00-00-0000' and madelivereddate!='NA' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' and maworkpercentage='100' and str_to_date(madeliverydate,'%d-%m-%Y')=madelivereddate";

			// System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getLong(1);
			}
		} catch (Exception e) {
			log.info("countAllOnTimeTask" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("countAllOnTimeTask" + e.getMessage());
			}
		}
		return data;
	}

	public static long countAllBehindTask(String startDate, String monthEndDate, String date, String token, String role,
			String uaid, String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		long data = 0;
		String queryselect = "";
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and maworkstarteddate!='00-00-0000' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' and maworkpercentage!='100' and str_to_date(madeliverydate,'%d-%m-%Y')<'" + date + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA"))
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=mateammemberid) or mateammemberid='" + uaid
						+ "' and maworkstarteddate!='00-00-0000' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' and maworkpercentage!='100' and str_to_date(madeliverydate,'%d-%m-%Y')<'" + date + "'";
			else
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and mateammemberid='" + uaid
						+ "' and maworkstarteddate!='00-00-0000' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' and maworkpercentage!='100' and str_to_date(madeliverydate,'%d-%m-%Y')<'" + date + "'";

			// System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getLong(1);
			}
		} catch (Exception e) {
			log.info("countAllBehindTask" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("countAllBehindTask" + e.getMessage());
			}
		}
		return data;
	}

	public static double sumEstimateRevenue(String startDate, String monthEndDate, String token, String role,
			String uaid, String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		double data = 0;
		double data1 = 0;
		String queryselect = "";
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select h.cborderamount,h.cbdiscount from hrmclient_billing h join managesalesctrl s on s.msinvoiceno=h.cbinvoiceno where s.mstoken='"
						+ token + "' and str_to_date(s.mssolddate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(s.mssolddate,'%d-%m-%Y')<='" + monthEndDate + "' group by s.msinvoiceno";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "select h.cborderamount,h.cbdiscount from hrmclient_billing h join managesalesctrl s on s.msinvoiceno=h.cbinvoiceno where s.mstoken='"
						+ token + "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=s.mssoldbyuid) or s.mssoldbyuid='" + uaid
						+ "' and str_to_date(s.mssolddate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(s.mssolddate,'%d-%m-%Y')<='" + monthEndDate + "' group by s.msinvoiceno";
			} else {
				queryselect = "select h.cborderamount,h.cbdiscount from hrmclient_billing h join managesalesctrl s on s.msinvoiceno=h.cbinvoiceno where s.mstoken='"
						+ token + "' and s.mssoldbyuid='" + uaid + "' and str_to_date(s.mssolddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(s.mssolddate,'%d-%m-%Y')<='" + monthEndDate
						+ "' group by s.msinvoiceno";
			}

//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			while (rs != null && rs.next()) {
				data = rs.getDouble(1);
				data1 = rs.getDouble(2);
			}
			data -= data1;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("sumEstimateRevenue" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("sumEstimateRevenue" + e.getMessage());
			}
		}
		return data;
	}

	public static double sumTotalRevenueDiscount(String startDate, String monthEndDate, String token, String role,
			String uaid, String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		double data = 0;
		String queryselect = "";
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select sum(esdiscount) from estimatesalectrl where estoken='" + token
						+ "' and str_to_date(esregdate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(esregdate,'%d-%m-%Y')<='" + monthEndDate + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "select sum(esdiscount) from estimatesalectrl where estoken='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=essoldbyid) or essoldbyid='" + uaid
						+ "' and str_to_date(esregdate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(esregdate,'%d-%m-%Y')<='" + monthEndDate + "'";
			} else {
				queryselect = "select sum(esdiscount) from estimatesalectrl where estoken='" + token
						+ "' and essoldbyid='" + uaid + "' and str_to_date(esregdate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(esregdate,'%d-%m-%Y')<='" + monthEndDate + "'";
			}
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getDouble(1);
			}
		} catch (Exception e) {
			log.info("sumTotalRevenueDiscount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("sumTotalRevenueDiscount" + e.getMessage());
			}
		}
		return data;
	}

	public static double sumTotalRevenue(String startDate, String monthEndDate, String token, String role, String uaid,
			String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		double data = 0;
		String queryselect = "";
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select s.sptotalprice from salesproductprice s join estimatesalectrl e on s.spessalerefid=e.esrefid where s.sptokenno='"
						+ token + "' and str_to_date(e.esregdate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(e.esregdate,'%d-%m-%Y')<='" + monthEndDate + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "select s.sptotalprice from salesproductprice s join estimatesalectrl e on s.spessalerefid=e.esrefid where s.sptokenno='"
						+ token + "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=e.essoldbyid) or e.essoldbyid='" + uaid
						+ "' and str_to_date(e.esregdate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(e.esregdate,'%d-%m-%Y')<='" + monthEndDate + "'";
			} else {
				queryselect = "select s.sptotalprice from salesproductprice s join estimatesalectrl e on s.spessalerefid=e.esrefid where s.sptokenno='"
						+ token + "' and e.essoldbyid='" + uaid + "' and str_to_date(e.esregdate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(e.esregdate,'%d-%m-%Y')<='" + monthEndDate + "'";
			}
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			while (rs != null && rs.next()) {
				data += rs.getDouble(1);
			}
		} catch (Exception e) {
			log.info("sumTotalRevenue" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("sumTotalRevenue" + e.getMessage());
			}
		}
		return data;
	}

	public static long countAllDeliveredProject(String startDate, String monthEndDate, String token, String role,
			String uaid, String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		long data = 0;
		String queryselect = "";
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select count(msid) from managesalesctrl where mstoken='" + token
						+ "' and msdeliveredon!='NA' and msdeliveredon>='" + startDate + "' and msdeliveredon<='"
						+ monthEndDate + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "select count(msid) from managesalesctrl where mstoken='" + token
						+ "' and msdeliveredon!='NA' and exists(select tmid from manageteammemberctrl where tmteamrefid='"
						+ teamKey + "' and tmuseruid=mssoldbyuid) or mssoldbyuid='" + uaid + "' and msdeliveredon>='"
						+ startDate + "' and msdeliveredon<='" + monthEndDate + "'";
			} else {
				queryselect = "select count(msid) from managesalesctrl where mstoken='" + token
						+ "' and msdeliveredon!='NA' and mssoldbyuid='" + uaid + "' and msdeliveredon>='" + startDate
						+ "' and msdeliveredon<='" + monthEndDate + "'";
			}

//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getLong(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.info("countAllDeliveredProject" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("countAllDeliveredProject" + e.getMessage());
			}
		}
		return data;
	}

	public static long countAllCreatedProject(String startDate, String monthEndDate, String token, String role,
			String uaid, String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		long data = 0;
		String queryselect = "";
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select count(msid) from managesalesctrl where mstoken='" + token
						+ "' and str_to_date(mssolddate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(mssolddate,'%d-%m-%Y')<='" + monthEndDate + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "select count(msid) from managesalesctrl where mstoken='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=mssoldbyuid) or mssoldbyuid='" + uaid
						+ "' and str_to_date(mssolddate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(mssolddate,'%d-%m-%Y')<='" + monthEndDate + "'";
			} else {
				queryselect = "select count(msid) from managesalesctrl where mstoken='" + token + "' and mssoldbyuid='"
						+ uaid + "' and str_to_date(mssolddate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(mssolddate,'%d-%m-%Y')<='" + monthEndDate + "'";
			}
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getLong(1);
			}
		} catch (Exception e) {
			log.info("countAllCreatedProject" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("countAllCreatedProject" + e.getMessage());
			}
		}
		return data;
	}

	public static long countAllDeliveredMilestone(String startDate, String monthEndDate, String token, String role,
			String uaid, String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		long data = 0;
		String queryselect = "";
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and madeliverydate!='00-00-0000' and str_to_date(madeliverydate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(madeliverydate,'%d-%m-%Y')<='" + monthEndDate + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and madeliverydate!='00-00-0000' and exists(select tmid from manageteammemberctrl where tmteamrefid='"
						+ teamKey + "' and tmuseruid=mateammemberid) or mateammemberid='" + uaid
						+ "' and str_to_date(madeliverydate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(madeliverydate,'%d-%m-%Y')<='" + monthEndDate + "'";
			} else {
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and madeliverydate!='00-00-0000' and mateammemberid='" + uaid
						+ "' and str_to_date(madeliverydate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(madeliverydate,'%d-%m-%Y')<='" + monthEndDate + "'";
			}

//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getLong(1);
			}
		} catch (Exception e) {
			log.info("countAllDeliveredMilestone" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("countAllDeliveredMilestone" + e.getMessage());
			}
		}
		return data;
	}

	public static long countAllCreatedMilestone(String startDate, String monthEndDate, String token, String role,
			String uaid, String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		long data = 0;
		String queryselect = "";
		try {
			if (role.equals("Admin") || role.equals("Manager"))
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and maworkstarteddate!='00-00-0000' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=mateammemberid) or mateammemberid='" + uaid
						+ "' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='" + startDate
						+ "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate + "'";
			} else {
				queryselect = "select count(maid) from manage_assignctrl where matokenno='" + token
						+ "' and mateammemberid='" + uaid + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')>='"
						+ startDate + "' and str_to_date(maworkstarteddate,'%d-%m-%Y')<='" + monthEndDate + "'";
			}
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getLong(1);
			}
		} catch (Exception e) {
			log.info("countAllCreatedMilestone" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("countAllCreatedMilestone" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String[] findSalesDocDetails(String docKey, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] =new String[3];
		try {
			String queryselect = "select sduploaddocname,reupload_uaid,reupload_requested_url from salesdocumentctrl where sdrefid=? and sdtokenno=?";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			ps.setString(1, docKey);
			ps.setString(2, uavalidtokenno);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0]= rs.getString(1);
				data[1]= rs.getString(2);
				data[2]= rs.getString(3);
			}
		} catch (Exception e) {
			log.info("findSalesDocDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("findSalesDocDetails" + e.getMessage());
			}
		}
		return data;
	}

	public static String[] getSalesKeyByDocKey(String docKey, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[4];
		try {
			String queryselect = "select sduploaddocname,sdsalesrefid,sddocname,sdestkey from salesdocumentctrl where sdrefid=? and sdtokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, docKey);
			ps.setString(2, uavalidtokenno);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
				data[3] = rs.getString(4);
			}
		} catch (Exception e) {
			log.info("getSalesKeyByDocKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getSalesKeyByDocKey" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean saveDocumentActionHistory(String docName, String salesKey, String type, String loginuaid,
			String userName, String uavalidtokenno, String docKey, String today, String docFile,String estKey) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into salesdochistory(salesKey,document,type,actionbyuid,actionbyname,token,date,dockey,document_name,estsalekey)values(?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, salesKey);
			ps.setString(2, docName);
			ps.setString(3, type);
			ps.setString(4, loginuaid);
			ps.setString(5, userName);
			ps.setString(6, uavalidtokenno);
			ps.setString(7, today);
			ps.setString(8, docKey);
			ps.setString(9, docFile);
			ps.setString(10, estKey);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("saveDocumentActionHistory()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveDocumentActionHistory()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean isAllAgentDocuploaded(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT sdid FROM salesdocumentctrl where sduploadby='Agent' and (sddocname='NA' or sddocname='') and sdsalesrefid='"
					+ salesKey + "' and sdtokenno='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isAllAgentDocuploaded" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isAllAgentDocuploaded" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean saveLicenceRenewal(String renewalKey, String assignKey, String salesmilestonekey,
			String salesKey, String approvalDate, String renewalDate, String today, String uavalidtokenno,
			String uaid) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into licence_renewal(uuid,taskkey,milestonekey,saleskey,approvaldate,renewaldate,postdate,token,addedbyuid,modifydate) values (?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, renewalKey);
			ps.setString(2, assignKey);
			ps.setString(3, salesmilestonekey);
			ps.setString(4, salesKey);
			ps.setString(5, approvalDate);
			ps.setString(6, renewalDate);
			ps.setString(7, today);
			ps.setString(8, uavalidtokenno);
			ps.setString(9, uaid);
			ps.setString(10, today);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("saveLicenceRenewal()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveLicenceRenewal:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean verifyLicenceRenewal(String renewalKey,String approvalDate,String renewalDate,String status,String today,String token) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update licence_renewal set approvaldate=?,renewaldate=?,modifydate=?,status=? where uuid=? and token=?";
			ps = con.prepareStatement(query);
			ps.setString(1, approvalDate);
			ps.setString(2, renewalDate);
			ps.setString(3, today);
			ps.setString(4, status);
			ps.setString(5, renewalKey);
			ps.setString(6, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("verifyLicenceRenewal()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects verifyLicenceRenewal:\n" + sqle.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateLicenceRenewal(String renewalKey, String approvalDate, String renewalDate, String today,
			String uavalidtokenno, String uaid) {
		PreparedStatement ps = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update licence_renewal set approvaldate=?,renewaldate=?,addedbyuid=?,modifydate=? where uuid=? and token=?";
			ps = con.prepareStatement(query);
			ps.setString(1, approvalDate);
			ps.setString(2, renewalDate);
			ps.setString(3, uaid);
			ps.setString(4, today);
			ps.setString(5, renewalKey);
			ps.setString(6, uavalidtokenno);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateLicenceRenewal()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateLicenceRenewal:\n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static String isRenewalExist(String assignKey, String salesKey, String salesmilestonekey,
			String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select uuid from licence_renewal where taskkey=? and milestonekey=? and saleskey=? and token=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, assignKey);
			ps.setString(2, salesmilestonekey);
			ps.setString(3, salesKey);
			ps.setString(4, uavalidtokenno);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("isRenewalExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("isRenewalExist" + e.getMessage());
			}
		}
		return data;
	}

	public static double getSalesIncome(String startDate, String endDate, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(cborderamount) FROM hrmclient_billing where cbinvoiceno!='NA' and cbtokenno='"
					+ token + "' and str_to_date(cbdate,'%d-%m-%Y')>='" + startDate
					+ "' and str_to_date(cbdate,'%d-%m-%Y')<='" + endDate + "'";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesIncome" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesIncome" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getExpenseSpend(String startDate, String endDate, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(expamount) FROM expense_approval_ctrl where expapprovalstatus='1' and exptoken='"
					+ token + "' and str_to_date(expdate,'%d-%m-%Y')>='" + startDate
					+ "' and str_to_date(expdate,'%d-%m-%Y')<='" + endDate + "'";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getExpenseSpend" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getExpenseSpend" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getExpenseByDepartment(String department, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(expamount) FROM expense_approval_ctrl where expdepartment='" + department
					+ "' and exptoken='" + token + "'";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getExpenseByDepartment" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getExpenseByDepartment" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isAllTaskStatusCompleted(String salesrefId, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = true;
		try {
			String queryselect = "SELECT maid FROM manage_assignctrl where masalesrefid='" + salesrefId
					+ "' and matokenno='" + uavalidtokenno + "' and maworkstatus!='Completed'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = false;
			}
		} catch (Exception e) {
			log.info("isAllTaskStatusCompleted" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isAllTaskStatusCompleted" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static boolean updateAssignedTaskHierarchyStatus(String salesKey,String status,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update manage_assignctrl set mahierarchyactivestatus=?"
					+ " where masalesrefid=? and matokenno=?");

			ps = con.prepareStatement(queryselect.toString());
			ps.setString(1, status);
			ps.setString(2, salesKey);
			ps.setString(3, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateAssignedTaskHierarchyStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateAssignedTaskHierarchyStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateAssignedTask(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update manage_assignctrl set masaleshierarchystatus=?,mahierarchyactivestatus=?,maworkstarteddate=?"
					+ " where masalesrefid=? and matokenno=?");

			ps = con.prepareStatement(queryselect.toString());
			ps.setString(1, "2");
			ps.setString(2, "2");
			ps.setString(3, "00-00-0000");
			ps.setString(4, salesKey);
			ps.setString(5, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateAssignedTask" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateAssignedTask" + e.getMessage());
			}
		}
		return flag;
	}
	public static String[][] getAllApprovalExpense(String token,String date) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT expclientname,expamount,expcategory,expsaleskey FROM expense_approval_ctrl where exptoken='"
					+ token + "' and expapprovalstatus='2' and str_to_date(expdate,'%d-%m-%Y')<='"+date+"'";
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
			log.info("Error in TaskMaster_ACT method getAllApprovalExpense:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllApprovalExpense:\n" + sqle);
			}
		}
		return newsdata;
	}
	public static String[][] getAllApprovalPayment(String token,String date) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT sestsaleno,sinvoiceno,stransactionamount FROM salesestimatepayment where stokenno='"
					+ token + "' and stransactionstatus='2' and str_to_date(saddeddate,'%d-%m-%Y')<='"+date+"'";
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
			log.info("Error in TaskMaster_ACT method getAllApprovalPayment:\n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllApprovalPayment:\n" + sqle);
			}
		}
		return newsdata;
	}

	public static boolean isTaskProgressExist(String salesKey, String assignKey, String memberId, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT id FROM task_progress where sales_key='" + salesKey
					+ "' and task_Key='" + assignKey + "' and token='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isTaskProgressExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isTaskProgressExist" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean saveTaskProgress(String uid, String taskKey, String salesKey, String milestoneName,
			String memberId, String memberName, int task_new_hh,int task_new_mm, int task_open_hh,int task_open_mm, 
			int task_hold_hh,int task_hold_mm, int task_pending_hh,int task_pending_mm,int task_expired_hh,int task_expired_mm,     
			 String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into task_progress(uid,task_key,sales_key,task_name,assignee_uid,assignee_name,task_new_hh,task_new_mm"
					+ ",task_open_hh,task_open_mm,task_hold_hh,task_hold_mm,task_pending_hh,task_pending_mm,task_expired_hh,task_expired_mm,token)"
					+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, uid);
			ps.setString(2, taskKey);
			ps.setString(3, salesKey);
			ps.setString(4, milestoneName);
			ps.setString(5, memberId);
			ps.setString(6, memberName);
			ps.setInt(7, task_new_hh);
			ps.setInt(8, task_new_mm);
			ps.setInt(9, task_open_hh);
			ps.setInt(10, task_open_mm);
			ps.setInt(11, task_hold_hh);
			ps.setInt(12, task_hold_mm);
			ps.setInt(13, task_pending_hh);
			ps.setInt(14, task_pending_mm);
			ps.setInt(15, task_expired_hh);
			ps.setInt(16, task_expired_mm);
			ps.setString(17, token);

			int k = ps.executeUpdate();
			if (k > 0)flag = true;
			
		} catch (Exception e) {
			log.info("saveTaskProgress()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveTaskProgress()" + sqle.getMessage());
			}
		}	
		return flag;
	}

	public static String[] getTaskDateTime(String salesrefId, String milestoneKey, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[3];
		try {
			String queryselect = "select madate,matime,maworkstatus from manage_assignctrl where masalesrefid='"
					+ salesrefId + "' and mamilestonerefid='"+milestoneKey+"' and matokenno='" + uavalidtokenno + "'";
			ps = con.prepareStatement(queryselect);
			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
			}
		} catch (Exception e) {
			log.info("getTaskDateTime" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getTaskDateTime" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean updateTaskProgress(String column_hh,String column_mm,long hours, long minutes, String marefid, 
			String salesrefId, String assigneeUId,String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update task_progress set "+column_hh+"=?,"+column_mm+"=? where task_key=? and"
					+ " sales_key=? and assignee_uid=? and token=?");
			ps = con.prepareStatement(queryselect.toString());
			ps.setLong(1, hours);
			ps.setLong(2, minutes);
			ps.setString(3, marefid);
			ps.setString(4, salesrefId);
			ps.setString(5, assigneeUId);
			ps.setString(6, uavalidtokenno);
			
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateTaskProgress" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("updateTaskProgress" + e.getMessage());
			}
		}
		return flag;
	}

	public static long[] getTaskHHMM(String column_hh,String column_mm,String marefid, String salesrefId, String assigneeUId, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		long data[] = new long[2];
		try {
			String queryselect = "select "+column_hh+","+column_mm+" from task_progress where task_key='"
					+ marefid + "' and sales_key='"+salesrefId+"' and assignee_uid='"+assigneeUId+"' and token='" + uavalidtokenno + "'";
			
//			System.out.println(queryselect);
			
			ps = con.prepareStatement(queryselect);
			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getLong(1);
				data[1] = rs.getLong(2);
			}
		} catch (Exception e) {
			log.info("getTaskHHMM" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getTaskHHMM" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean saveTaskHoldData(String hkey, String marefid, String type, String date, String time,
			String reason, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into task_hold_details(uuid,taskkey,type,date,time,reason,token) values(?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, hkey);
			ps.setString(2, marefid);
			ps.setString(3, type);
			ps.setString(4, date);
			ps.setString(5, time);
			ps.setString(6, reason);
			ps.setString(7, token);

			int k = ps.executeUpdate();
			if (k > 0)flag = true;
			
		} catch (Exception e) {
			e.printStackTrace();
			log.info("saveTaskHoldData()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveTaskHoldData()" + sqle.getMessage());
			}
		}	
		return flag;
	}

	public static String getSalesStatus(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select msworkstatus from managesalesctrl where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesrefid);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("getSalesStatus" + e.getMessage());
			}
		}
		return data;
	}

	public static String[][] getUserPendingFollowUpSendData(String time,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT * FROM user_notification where "
					+ "time!='NA' and time<'"+time+"' and token='"+token+"'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("TaskMasterACT : getUserPendingFollowUpSendData()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("TaskMasterACT : getUserPendingFollowUpSendData()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getPendingFollowUpSendData(String today,String time,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,msprojectnumber,msproductname,project_close_date,msclientrefid FROM managesalesctrl where "
					+ "mschatnotreplied!='0' and (mschatnotreplydate!='NA' and "
					+ "str_to_date(mschatnotreplydate,'%d-%m-%Y')='"+today+"') and "
					+ "(mschatnotreplytime!='NA' and mschatnotreplytime<'"+time+"') and "
					+ "msnotificationdate!='"+today+"' and mstoken='"+token+"'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("TaskMasterACT : getPendingFollowUpSendData()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("TaskMasterACT : getPendingFollowUpSendData()" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static void updateNotificationDate(String salesKey, String today) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		
		try {
			queryselect = new StringBuffer("update managesalesctrl set msnotificationdate=? "
					+ "where msrefid=?");
			ps = con.prepareStatement(queryselect.toString());
			ps.setString(1, today);
			ps.setString(2, salesKey);
			ps.execute();

		} catch (Exception e) {
			log.info("updateNotificationDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateNotificationDate" + e.getMessage());
			}
		}
	}

	public static boolean saveUserNotification(String uKey, String today, String msgForUid, String redirectUrl, String icon,
			String loginuaid, String message, String token,String time,String salesKey) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into user_notification(uuid,date,time,user_uid,redirect_url,icon,addedbyuid,message,token,sales_key)values(?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, uKey);
			ps.setString(2, today);
			ps.setString(3, time);
			ps.setString(4, msgForUid);
			ps.setString(5, redirectUrl);
			ps.setString(6, icon);
			ps.setString(7, loginuaid);
			ps.setString(8, message);
			ps.setString(9, token);
			ps.setString(10, salesKey);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveUserNotification()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveUserNotification()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeUserNotification(String salesrefId, String uaid, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from user_notification where user_uid =? and sales_key=? and token=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, uaid);
			ps.setString(2, salesrefId);
			ps.setString(3, uavalidtokenno);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("removeUserNotification" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeUserNotification" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeUserNotificationById(String id) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from user_notification where id=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, id);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("removeUserNotificationById" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeUserNotificationById" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean updateTransferRetrieve(String taskKey, int status) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update manage_assignctrl set matransferstatus='"+status+"' where marefid='" + taskKey+ "'");

			ps = con.prepareStatement(queryselect.toString());
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateTransferRetrieve" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("updateTransferRetrieve" + e.getMessage());
			}
		}
		return flag;
	}

	public static String[][] getLastFiveFollowUp(String salesrefid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT pfcontent,pfaddedbyname,pfmsgforuid,pfmsgforname FROM hrmproject_followup where pfsaleskey='" + salesrefid + "' order by pfuid desc limit 5";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("getLastFiveFollowUp" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getLastFiveFollowUp" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getLastFiveFollowUp(String salesrefid,String msgForUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT pfcontent,pfaddedbyname,pfmsgforuid,pfmsgforname FROM hrmproject_followup where pfsaleskey='" + salesrefid + "' and (pfmsgforuid='"+msgForUid+"' or pfaddedbyuid='"+msgForUid+"') order by pfuid desc limit 5";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("getLastFiveFollowUp" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getLastFiveFollowUp" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static boolean saveSalesNotification(String salesTaskKey, String type, String userUid, String userName,
			String dateTime, String token,String salesKey,String notes,String estimateKey) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into sales_notification(uuid,type,added_by_uid,added_by_name,date_time,token,sales_key,description,estimate_key)"
					+ "values(?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, salesTaskKey);
			ps.setString(2, type);
			ps.setString(3, userUid);
			ps.setString(4, userName);
			ps.setString(5, dateTime);
			ps.setString(6, token);
			ps.setString(7, salesKey);
			ps.setString(8, notes);
			ps.setString(9, estimateKey);
			
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {e.printStackTrace();
			log.info("saveSalesNotification()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveSalesNotification:\n" + sqle.getMessage());
			}
		}
		return flag;
	}	
	
	public static String[][] getStateByCountryId(String id) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT id,name,state_code FROM states where country_id='" + id + "'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("getStateByCountryId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getStateByCountryId" + e.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] getCitiesByStateId(String id) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT id,name FROM cities where state_id='" + id + "'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("getCitiesByStateId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getCitiesByStateId" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getCountryByName(String name) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select id from countries where name=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, name);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1)+"#"+name;
			}
		} catch (Exception e) {
			log.info("getCountryByName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getCountryByName" + e.getMessage());
			}
		}
		return data;
	}

	public static String getExpenseApproveHead(String salesKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select msprojectnumber,msproductname from managesalesctrl where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data ="Expense : "+ rs.getString(1)+" - "+rs.getString(2);
			}
		} catch (Exception e) {
			log.info("getExpenseApproveHead" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getExpenseApproveHead" + e.getMessage());
			}
		}
		return data;
	}
	public static String[][] getPaymentComments(String invoice,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "select p.sapproveddate,p.service_name,p.scomment,u.uaname from salesestimatepayment p INNER JOIN user_account u on p.sapprovedby=u.uaid where p.stransactionstatus='1' and p.sinvoiceno=? and p.stokenno=?";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
			stmnt.setString(1, invoice);
			stmnt.setString(2, token);
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
			log.info("getPaymentComments" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getPaymentComments" + e.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] getExpenseComments(String expKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "select status,comment,addedby_name,datetime from expense_comment where expense_key=? and token=?";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
			stmnt.setString(1, expKey);
			stmnt.setString(2, token);
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
			log.info("getExpenseComments" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getExpenseComments" + e.getMessage());
			}
		}
		return newsdata;
	}
	public static String[] getExpenseComment(String expKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[4];
		try {
			String queryselect = "select status,comment,addedby_name,datetime from expense_comment where expense_key=? and token=?";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			ps.setString(1, expKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] =rs.getString(1);
				data[1] =rs.getString(2);
				data[2] =rs.getString(3);
				data[3] =rs.getString(4);
			}
		} catch (Exception e) {
			log.info("getExpenseComment" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getExpenseComment" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String getExpenseNotes(String taskKey,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select expnotes from expense_approval_ctrl where expkey=? and exptoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, taskKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data=rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getExpenseNotes" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getExpenseNotes" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean saveExpenseComment(String expKey, String comment,String status,
			String datetime,String token,String uaid,String userName) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into expense_comment(status,comment,datetime,token,expense_key,addedby_uid,addedby_name) "
					+ "values(?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, status);
			ps.setString(2, comment);
			ps.setString(3, datetime);
			ps.setString(4, token);
			ps.setString(5, expKey);
			ps.setString(6, uaid);
			ps.setString(7, userName);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveExpenseComment()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveExpenseComment()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static String[] getSalesPayment(String unbillno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[4];
		try {
			String queryselect = "select service_name,stransactionamount,srefid,service_qty from salesestimatepayment where sunbill_no=? and stokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, unbillno);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
				data[3] = rs.getString(4);
			}
		} catch (Exception e) {
			log.info("getSalesPayment" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getSalesPayment" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean saveInvoice(String uuid, String unbillno, String final_invoice, String today,
			String companyName,String gstin, String address,String serviceName, String txnAmount,
			String country,String state,String city,String state_code,String token,String loginuaid,
			String company_uuid,String contact_uuid,String invoiceType,String contactName,
			String contactPan,String contactCountry,String contactState,String contactCity,
			String contactAddress,String contactStateCode,int serviceQty) {
		
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into invoice(uuid,unbill_no,invoice_no,date,company,gstin"
					+ ",address,service_name,total_amount,country,state,city,state_code,"
					+ "user_uid,client_uuid,contact_uuid,token,contact_name,contact_pan,"
					+ "contact_country,contact_state,contact_city,contact_address,"
					+ "contact_state_code,invoice_type,service_qty) "
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, uuid);
			ps.setString(2, unbillno);
			ps.setString(3, final_invoice);
			ps.setString(4, today);
			ps.setString(5, companyName);
			ps.setString(6, gstin);
			ps.setString(7, address);
			ps.setString(8, serviceName);
			ps.setString(9, txnAmount);
			ps.setString(10, country);
			ps.setString(11, state);
			ps.setString(12, city);
			ps.setString(13, state_code);
			ps.setString(14, loginuaid);
			ps.setString(15, company_uuid);
			ps.setString(16, contact_uuid);
			ps.setString(17, token);
			ps.setString(18, contactName);
			ps.setString(19, contactPan);
			ps.setString(20, contactCountry);
			ps.setString(21, contactState);
			ps.setString(22, contactCity);
			ps.setString(23, contactAddress);
			ps.setString(24, contactStateCode);
			ps.setString(25, invoiceType);
			ps.setInt(26, serviceQty);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveInvoice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveInvoice()" + sqle.getMessage());
			}
		}
		return flag;
		
	}

	public static boolean saveInvoiceItems(String uuid, String final_invoice, String today, String type, String amount,
			String hsn,String cgst, String sgst, String igst,String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into invoice_items(uuid,invoice_no,date,type,amount,cgst"
					+ ",sgst,igst,token,hsn)values(?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, uuid);
			ps.setString(2, final_invoice);
			ps.setString(3, today);
			ps.setString(4, type);
			ps.setString(5, amount);
			ps.setString(6, cgst);
			ps.setString(7, sgst);
			ps.setString(8, igst);
			ps.setString(9, token);
			ps.setString(10, hsn);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("saveInvoiceItems()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveInvoiceItems()" + sqle.getMessage());
			}
		}
		return flag;
		
	}

	public static String getSalesPriceHsn(String sales_uuid, String type, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT sphsncode FROM salespricectrl where spsalesrefid='"+sales_uuid+"' "
					+ "and sppricetype='"+type+"' and sptokenno='" + token+ "'";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesPriceHsn" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesPriceHsn" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static void cancelInvoice(String invoice, String token,String uuid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		try {
			queryselect = new StringBuffer("update invoice set status='2' where invoice_no='" + invoice
					+ "' and token='" + token + "' and uuid!='"+uuid+"'");

			ps = con.prepareStatement(queryselect.toString());
			ps.execute();
			
		} catch (Exception e) {
			log.info("cancelInvoice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("cancelInvoice" + e.getMessage());
			}
		}
	}

	public static String getInvoiceUuid(String unbillno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT uuid FROM invoice where unbill_no='"+unbillno+"' and token='" +token+ "' and status='1' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getInvoiceUuid" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getInvoiceUuid" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean updateSalesHierarchyOfAssignedMilestone(String saleskey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update manage_assignctrl set masaleshierarchystatus='1' where masalesrefid='" + saleskey
					+ "' and matokenno='" + token + "'");
//System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateSalesHierarchyOfAssignedMilestone" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateSalesHierarchyOfAssignedMilestone" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean isInvoiceExist(String final_invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT invoice_no FROM invoice where invoice_no='"+final_invoice+"' and token='" +token+ "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isInvoiceExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isInvoiceExist" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static boolean updateUserCompany(String clientNumber, String companyName, String token) {
		// TODO Auto-generated method stub
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "update user_account set uaname=? WHERE uaempid=? and uavalidtokenno=?";
			ps = con.prepareStatement(query);	
			ps.setString(1, companyName);
			ps.setString(2, clientNumber);
			ps.setString(3, token);
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateUserCompany "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateUserCompany "+sqle.getMessage());
			}
		}
		return status;
	}
	
	public static boolean updateBillingCompany(String companykey, String companyName, String token) {
		// TODO Auto-generated method stub
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbcompanyname=? WHERE cbclientrefid=? and cbtokenno=?";
			ps = con.prepareStatement(query);	
			ps.setString(1, companyName);
			ps.setString(2, companykey);
			ps.setString(3, token);
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateBillingCompany "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateBillingCompany "+sqle.getMessage());
			}
		}
		return status;
	}
	
	public static boolean updateContactCompany(String companykey, String companyName, String token) {
		// TODO Auto-generated method stub
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE clientcontactbox SET cccompanyname=? WHERE ccbclientrefid=? and cctokenno=?";
			ps = con.prepareStatement(query);	
			ps.setString(1, companyName);
			ps.setString(2, companykey);
			ps.setString(3, token);
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateContactCompany "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateContactCompany "+sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateSalesCompany(String companykey, String companyName, String token) {
		// TODO Auto-generated method stub
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE managesalesctrl SET mscompany=? WHERE msclientrefid=? and mstoken=?";
			ps = con.prepareStatement(query);	
			ps.setString(1, companyName);
			ps.setString(2, companykey);
			ps.setString(3, token);
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateSalesCompany "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateSalesCompany "+sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean saveForgetPasswordLink(String uuid, String link, String date,String user_uid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into forget_password(uuid,link,date,user_uid)values(?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, uuid);
			ps.setString(2, link);
			ps.setString(3, date);
			ps.setString(4, user_uid);

			int k = ps.executeUpdate();
			if (k > 0)flag = true;
		} catch (Exception e) {
			log.info("saveForgetPasswordLink()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveForgetPasswordLink()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean isLinkExpired(String user_uid, String date) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = true;
		try {
			String queryselect = "SELECT id from forget_password where user_uid='"+user_uid+"' and date='" +date+ "' and status='1' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = false;
			}
		} catch (Exception e) {
			log.info("isLinkExpired" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isLinkExpired" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static void saveMilestoneExtendRecord(String marefid, String date,
			String extendComment, String uavalidtokenno,String uaid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into milestone_extend_history(marefid,user_uid,comment,token,post_date)values(?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, marefid);
			ps.setString(2, uaid);
			ps.setString(3, extendComment);
			ps.setString(4, uavalidtokenno);
			ps.setString(5, date);

			ps.executeUpdate();
			
		} catch (Exception e) {
			log.info("saveMilestoneExtendRecord()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveMilestoneExtendRecord()" + sqle.getMessage());
			}
		}
	}

	public static String getEstimateKey(String salesrefid, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT msestkey from managesalesctrl where msrefid='"+salesrefid+"' and mstoken='" +uavalidtokenno+ "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getEstimateKey" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static void updateProjectStatusByInvoice(String invoice,String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		try {
			String queryselect = "update managesalesctrl set msprojectstatus=? where (msinvoiceno=? or msestimateno=?) and msworkpercent=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, "2");
			ps.setString(2, invoice);
			ps.setString(3, invoice);
			ps.setString(4, "100");
			ps.setString(5, uavalidtokenno);

			ps.executeUpdate();

		} catch (Exception e) {
			log.info("updateProjectStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("updateProjectStatus" + e.getMessage());
			}
		}
	}
	
	public static void updateProjectStatus(String salesrefId, String salesStatus, 
			String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		try {
			String queryselect = "update managesalesctrl set msprojectstatus=? where msrefid=? and mstoken=?";
			
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesStatus);
			ps.setString(2, salesrefId);
			ps.setString(3, uavalidtokenno);

			ps.executeUpdate();

		} catch (Exception e) {
			log.info("updateProjectStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("updateProjectStatus" + e.getMessage());
			}
		}
	}
	public static void updateMilestone(int i) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		try {
			String queryselect ="";
//			if(i==1)
//			queryselect="update manage_assignctrl set task_progress_status='1' "
//					+ "where maworkstarteddate='00-00-0000' or "
//					+ "masaleshierarchystatus='2' or mahierarchyactivestatus='2' or maapprovalstatus='2' "
//					+ "or mastepstatus='2'";
			 
			if(i==2)
				queryselect="update manage_assignctrl set task_progress_status='2' "
						+ "where maworkpercentage='100'";
			else if(i==3)
				queryselect="update manage_assignctrl set task_progress_status='3' "
						+ "where mateammemberid!='NA' and maworkstarteddate!='00-00-0000' and maworkpercentage!='100' "
						+ "and masaleshierarchystatus='1' and mahierarchyactivestatus='1' and maapprovalstatus='1' "
						+ "and mastepstatus='1'";
			
			ps = con.prepareStatement(queryselect);
			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();				
			}
		}
	}
	public static void updateSales(int i) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		try {
			String queryselect ="";
//			if(i==1)
//			queryselect="update managesalesctrl set msprojectstatus='1' "
//					+ "where msworkstatus='Inactive' or "
//					+ "msassignedtoname='Unassigned' or mahierarchyactivestatus='2' or maapprovalstatus='2' "
//					+ "or mastepstatus='2'";
//			else 
			
			if(i==2)
				queryselect="update managesalesctrl m set m.msprojectstatus='2' "
						+ "where m.msworkpercent='100' and exists(select h.cbuid from hrmclient_billing h "
						+ "where h.cbinvoiceno=m.msinvoiceno and h.cbdueamount='0')";
			else if(i==3)
				queryselect="update managesalesctrl m set m.msprojectstatus='3' "
						+ "where exists(select a.maid from manage_assignctrl a where a.masalesrefid=m.msrefid and a.mateammemberid!='NA' and "
						+ "a.maworkstarteddate!='00-00-0000' and a.maworkpercentage!='100' "
						+ "and a.masaleshierarchystatus='1' and a.mahierarchyactivestatus='1' and a.maapprovalstatus='1' "
						+ "and a.mastepstatus='1')";
			
			ps = con.prepareStatement(queryselect);
			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();				
			}
		}
	}
	/*
	 * public static void updateQuery() throws InterruptedException { //
	 * System.out.println("executed................................."); //for
	 * milestones //update task progress status 1 updateMilestone(2);
	 * Thread.sleep(10000); updateMilestone(3); Thread.sleep(10000); //updating
	 * sales updateSales(2); Thread.sleep(10000); updateSales(3); }
	 */

	public static String[] getContactDetails(String contactKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data[] = new String[12];
		try {
			String queryselect = "select cbname,cbemail1st,cbemail2nd,cbmobile1st,cbmobile2nd from"
					+ " contactboxctrl where cbrefid=? and cbtokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, contactKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getString(1);
				data[1] = rs.getString(2);
				data[2] = rs.getString(3);
				data[3] = rs.getString(4);
				data[4] = rs.getString(5);
			}
		} catch (Exception e) {
			log.info("getContactDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("getContactDetails" + e.getMessage());
			}
		}
		return data;
	}

	public static String getSalesServices(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select msproductname from managesalesctrl where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			while (rs.next()) {
				data = rs.getString(1)+",";
			}
			
		} catch (Exception e) {
			log.info("getSalesServices()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("getSalesServices()" + e.getMessage());
			}
		}
		return data;
	}

	public static List<String> getSalesTaskUser(String salesKey, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<String> taskUser=new ArrayList<>();
		try {
			String queryselect = "select mateammemberid from manage_assignctrl where "
					+ "masalesrefid=? and matokenno=? and mateammemberid!=? group by mateammemberid";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, uavalidtokenno);
			ps.setString(3, "NA");

			rs = ps.executeQuery();
			while (rs.next()) {
				taskUser.add(rs.getString(1));
			}
			
		} catch (Exception e) {
			log.info("getSalesTaskUser()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("getSalesTaskUser()" + e.getMessage());
			}
		}
		return taskUser;
	}

	public static String getSalesKeyByEstimateKey(String estkey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select msrefid from managesalesctrl where msestkey=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, estkey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs.next()) {
				data = rs.getString(1);
			}
			
		} catch (Exception e) {
			log.info("getSalesServices()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("getSalesServices()" + e.getMessage());
			}
		}
		return data;
	}

	public static void updateSalesKeyInSalesNotification(String saleskey, String estimateKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		try {
			String queryselect = "update sales_notification set sales_key=? where estimate_key=? and token=?";
			
			ps = con.prepareStatement(queryselect);
			ps.setString(1, saleskey);
			ps.setString(2, estimateKey);
			ps.setString(3, token);

			ps.executeUpdate();

		} catch (Exception e) {
			log.info("updateSalesKeyInSalesNotification" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("updateSalesKeyInSalesNotification" + e.getMessage());
			}
		}
	}

	public static String getSalesTaskKey(String salesKey, String estimateKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select uuid from sales_notification where sales_key=? and estimate_key=? and token=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, estimateKey);
			ps.setString(3, token);

			rs = ps.executeQuery();
			if (rs.next()) {
				data = rs.getString(1);
			}
			
		} catch (Exception e) {
			log.info("getSalesTaskKey()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("getSalesTaskKey()" + e.getMessage());
			}
		}
		return data;
	}

	public static String getSellerManagerUaid(String uaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select t.mtadminid from manageteamctrl t left join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtdepartment='Sales' and m.tmuseruid='"+uaid+"'";
			ps = con.prepareStatement(queryselect);
			
			rs = ps.executeQuery();
			if (rs.next()) {
				data = rs.getString(1);
			}
			
		} catch (Exception e) {
			log.info("getSellerManagerUaid()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("getSellerManagerUaid()" + e.getMessage());
			}
		}
		return data;
	}

	public static String findMilestoneKey(String assignKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select mamilestonerefid from manage_assignctrl where marefid=? and matokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, assignKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs.next()) {
				data = rs.getString(1);
			}
			
		} catch (Exception e) {
			log.info("findMilestoneKey()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("findMilestoneKey()" + e.getMessage());
			}
		}
		return data;
	}

	public static String getLastMilestoneKey(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select smrefid from salesmilestonectrl where smsalesrefid=? and smtoken=? order by smstep desc limit 1";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs.next()) {
				data = rs.getString(1);
			}
			
		} catch (Exception e) {
			log.info("getLastMilestoneKey()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("getLastMilestoneKey()" + e.getMessage());
			}
		}
		return data;
	}

	public static void updateSalesDeliveryDateAndTime(String deliveryDate, String deliveryTime, String salesKey,
			String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		try {
			String queryselect = "update managesalesctrl set msdeliverydate=?,msdeliverytime=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, deliveryDate);
			ps.setString(2, deliveryTime);
			ps.setString(3, salesKey);
			ps.setString(4, token);

			ps.executeUpdate();

		} catch (Exception e) {
			log.info("updateSalesDeliveryDateAndTime" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("updateSalesDeliveryDateAndTime" + e.getMessage());
			}
		}
	}

	public static String[][] findSalesByDeliveryDateForManager(String dateAfterDays,String deliveryManagerUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,msdeliverydate,mstoken "
					+ "FROM managesalesctrl where msdeliverydate!='NA' and msdeliveredon='NA' and str_to_date(msdeliverydate,'%d-%m-%Y')='"+dateAfterDays+"'"
					+ " and mscancelstatus='2' and delivery_person_uid='"+deliveryManagerUid+"'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findSalesByDeliveryDateForManager()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesByDeliveryDateForManager()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findSalesByDeliveryDate(String dateAfterDays,String salesPersonUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,msdeliverydate,mstoken "
					+ "FROM managesalesctrl where msdeliverydate!='NA' and msdeliveredon='NA' and str_to_date(msdeliverydate,'%d-%m-%Y')='"+dateAfterDays+"'"
					+ " and mscancelstatus='2' and mssoldbyuid='"+salesPersonUid+"'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findSalesByDeliveryDate()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesByDeliveryDate()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findAllInactiveSale(String managerUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,msdeliverydate,mstoken "
					+ "FROM managesalesctrl where msdeliveredon='NA' and mscancelstatus='2'"
					+ " and msworkstatus='Inactive' and delivery_person_uid='"+managerUid+"'";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findAllInactiveSale()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findAllInactiveSale()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findExpiredSalesByDeliveryDateForManager(String dateBeforeDays,String managerUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,msdeliverydate,mstoken "
					+ "FROM managesalesctrl where msdeliverydate!='NA' and"
					+ " str_to_date(msdeliverydate,'%d-%m-%Y')<='"+dateBeforeDays+"' "
					+ "and delivery_person_uid='"+managerUid+"' and msdeliveredon='NA' and mscancelstatus='2'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findExpiredSalesByDeliveryDateForManager()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findExpiredSalesByDeliveryDateForManager()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findExpiredSalesByDeliveryDate(String dateBeforeDays,String soldByUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,msdeliverydate,mstoken "
					+ "FROM managesalesctrl where msdeliverydate!='NA' and"
					+ " str_to_date(msdeliverydate,'%d-%m-%Y')<='"+dateBeforeDays+"' "
					+ "and mssoldbyuid='"+soldByUid+"' and msdeliveredon='NA' and mscancelstatus='2'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findExpiredSalesByDeliveryDate()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findExpiredSalesByDeliveryDate()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findTeamDueSales(String teamKey,String leaderUaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "select m.msrefid,m.mssolddate,m.msinvoiceno,m.msprojectnumber"
					+ ",m.msproductname,m.mscontactrefid,m.mscompany,m.msworkpercent,"
					+ "m.mssoldbyuid,m.mscancelstatus,m.msworkstatus,m.msdeliverydate,"
					+ "m.mstoken,b.cbdueamount FROM hrmclient_billing b join "
					+ "managesalesctrl m on b.cbinvoiceno=m.msinvoiceno where exists(SELECT t.tmid FROM manageteammemberctrl t"
					+ " where t.tmteamrefid='"+teamKey+"' and "
					+ "t.tmuseruid=m.mssoldbyuid or m.mssoldbyuid='"+leaderUaid+"') and b.cbdueamount>0 and m.msworkpercent='100' "
					+ "and mscancelstatus='2'";			
			
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findTeamDueSales()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findTeamDueSales()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findDueSalesPerson() {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT m.mssoldbyuid,mstoken FROM hrmclient_billing b join "
					+ "managesalesctrl m on b.cbinvoiceno=m.msinvoiceno where "
					+ "b.cbdueamount>0 and m.msworkpercent='100' and mscancelstatus='2' group by mssoldbyuid";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findDueSales()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findDueSales()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findDueSales(String soldByUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			StringBuffer query =new StringBuffer("select m.msrefid,m.mssolddate,m.msinvoiceno,m.msprojectnumber"
					+ ",m.msproductname,m.mscontactrefid,m.mscompany,m.msworkpercent,"
					+ "m.mssoldbyuid,m.mscancelstatus,m.msworkstatus,m.msdeliverydate,"
					+ "m.mstoken,b.cbdueamount,m.sales_type FROM hrmclient_billing b join "
					+ "managesalesctrl m on b.cbinvoiceno=m.msinvoiceno where b.cbdueamount>0 and m.msworkpercent='100'"
					+ " and mscancelstatus='2'");
			if(!soldByUid.equalsIgnoreCase("NA"))query.append(" and m.mssoldbyuid='"+soldByUid+"'");
				
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findDueSales()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findDueSales()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findUpcomingDueSalesForClient(String dateAfter3Days) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "select m.msrefid,m.msinvoiceno,m.mscontactrefid,m.mssoldbyuid,m.mstoken,"
					+ "m.msdeliverydate,b.cbdueamount FROM hrmclient_billing b join "
					+ "managesalesctrl m on b.cbinvoiceno=m.msinvoiceno where b.cbdueamount>0 and m.msdeliverydate!='NA' "
					+ "and str_to_date(m.msdeliverydate,'%d-%m-%Y')='"+dateAfter3Days+"'"
					+ " and m.mscancelstatus='2' group by b.cbuid";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findUpcomingDueSalesForClient()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findUpcomingDueSalesForClient()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findPastDueSalesForClient(String today) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "select m.msrefid,m.msinvoiceno,m.mscontactrefid,m.mssoldbyuid,m.mstoken,"
					+ "m.msdeliverydate,b.cbdueamount FROM hrmclient_billing b join "
					+ "managesalesctrl m on b.cbinvoiceno=m.msinvoiceno where b.cbdueamount>0 "
					+ "and m.msworkpercent='100' and mscancelstatus='2' and m.auto_email='1' and m.msdeliverydate!='NA' "
					+ "and STR_TO_DATE(m.msdeliverydate,'%d-%m-%Y')<'"+today+"' "
					+ "AND STR_TO_DATE(m.msdeliverydate, '%d-%m-%Y') >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) group by b.cbuid";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findPastDueSalesForClient()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findPastDueSalesForClient()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findAllExpiredMilestoneByTeam(String teamkey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {			
			String query="select m.maworkstarteddate,m.masalesrefid,m.mamilestonename,m.maworkpercentage,"
					+ "m.madeliverydate,m.maworkstatus,m.matokenno,ms.mscompany,ms.msproductname,ms.msinvoiceno,m.mateammemberid "
					+ "from manage_assignctrl m join managesalesctrl ms on m.masalesrefid=ms.msrefid where "
					+ "m.maworkstatus='Expired' and m.mahierarchyactivestatus='1' and "
					+ "m.madelivereddate='NA' and m.masaleshierarchystatus='1' and m.maapprovalstatus='1'"
					+ " and m.mastepstatus='1' and m.maworkstarteddate!='00-00-0000' and m.maparentteamrefid='"+teamkey+"' "
							+ "group by m.maid order by m.maid";
			
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findAllExpiredMilestoneByTeam()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findAllExpiredMilestoneByTeam()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findAllExpiredMilestone(String uaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query="select m.maworkstarteddate,m.masalesrefid,m.mamilestonename,m.maworkpercentage,"
					+ "m.madeliverydate,m.maworkstatus,m.matokenno,ms.mscompany,ms.msproductname,ms.msinvoiceno "
					+ "from manage_assignctrl m join managesalesctrl ms on m.masalesrefid=ms.msrefid where "
					+ "m.maworkstatus='Expired' and m.mahierarchyactivestatus='1' and "
					+ "m.madelivereddate='NA' and m.masaleshierarchystatus='1' and m.maapprovalstatus='1'"
					+ " and m.mastepstatus='1' and m.maworkstarteddate!='00-00-0000' and m.mateammemberid='"+uaid+"' "
							+ "group by m.maid order by m.maid";			
			
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findAllExpiredMilestone()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findAllExpiredMilestone()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findTeamExpiredSalesByDeliveryDate(String dateBeforeDays,String teamKey,String teamLeaderUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "select msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,msdeliverydate,mstoken "
					+ "from managesalesctrl where exists("
					+ "SELECT tmid FROM manageteammemberctrl where "
					+ "tmteamrefid='"+teamKey+"' and tmuseruid=mssoldbyuid or mssoldbyuid='"+teamLeaderUid+"')"
					+ " and msdeliverydate!='NA' and str_to_date(msdeliverydate,'%d-%m-%Y')<='"+dateBeforeDays+"' and msdeliveredon='NA' and mscancelstatus='2'";
						
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findTeamSalesByDeliveryDate()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findTeamSalesByDeliveryDate()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findTeamSalesByDeliveryDate(String dateAfterDays,String teamKey,String teamLeaderUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "select msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,msdeliverydate,mstoken "
					+ " from managesalesctrl where exists("
					+ "SELECT tmid FROM manageteammemberctrl where "
					+ "tmteamrefid='"+teamKey+"' and tmuseruid=mssoldbyuid or mssoldbyuid='"+teamLeaderUid+"')"
					+ " and msdeliverydate!='NA' and msdeliveredon='NA' and str_to_date(msdeliverydate,'%d-%m-%Y')='"+dateAfterDays+"' and mscancelstatus='2'";
			
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findTeamSalesByDeliveryDate()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findTeamSalesByDeliveryDate()" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] findTeamByDepartment(String department) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT mtrefid,mtadminid,mtadminname,mttoken,mtteamname FROM manageteamctrl where mtdepartment='"+department+"' and mtstatus='1'";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findSalesByDeliveryDate()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesByDeliveryDate()" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] findAllTomorrowDeliveryMilestoneByTeam(String dateAfterDays,String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {			
			String query = "SELECT m.maworkstarteddate,m.masalesrefid,m.mamilestonename,m.maworkpercentage,"
					+ "m.madeliverydate,m.maworkstatus,m.matokenno,ms.mscompany,ms.msproductname,ms.msinvoiceno,m.mateammemberid FROM manage_assignctrl m "
					+ "join managesalesctrl ms on m.masalesrefid=ms.msrefid where m.maworkstarteddate!='00-00-0000' and"
					+ " str_to_date(m.madeliverydate,'%d-%m-%Y')='"+dateAfterDays+"' and "
							+ "m.maworkstatus!='Completed' and m.maparentteamrefid='"+teamKey+"' "
									+ "and m.mahierarchyactivestatus='1' group by m.maid order by m.maid";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findAllTomorrowDeliveryMilestone()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findAllTomorrowDeliveryMilestone()" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] findAllTomorrowDeliveryMilestoneAssignee(String dateAfterDays) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT mateammemberid,matokenno FROM manage_assignctrl where str_to_date(madeliverydate,'%d-%m-%Y')='"+dateAfterDays+"' and maworkstatus!='Completed' and mahierarchyactivestatus='1' group by mateammemberid";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findAllTomorrowDeliveryMilestoneAssignee()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findAllTomorrowDeliveryMilestoneAssignee()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findAllTomorrowDeliveryMilestone(String dateAfterDays,String agentUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT m.maworkstarteddate,m.masalesrefid,m.mamilestonename,m.maworkpercentage,"
					+ "m.madeliverydate,m.maworkstatus,m.matokenno,ms.mscompany,ms.msproductname,ms.msinvoiceno FROM manage_assignctrl m "
					+ "join managesalesctrl ms on m.masalesrefid=ms.msrefid where m.maworkstarteddate!='00-00-0000' and"
					+ " str_to_date(m.madeliverydate,'%d-%m-%Y')='"+dateAfterDays+"' and "
							+ "m.maworkstatus!='Completed' and m.mateammemberid='"+agentUid+"' "
									+ "and m.mahierarchyactivestatus='1' group by m.maid order by m.maid";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findAllTomorrowDeliveryMilestone()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findAllTomorrowDeliveryMilestone()" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static void updateHierarchyStatus(String invoice, String hstatus, String token) {
		PreparedStatement ps = null;
			Connection con = DbCon.getCon("", "", "");
			try {
				String query = "UPDATE saleshierarchymanagectrl SET shmhierarchyholdstatus='"+hstatus+"' WHERE shminvoice='"+invoice+"' and shmtoken='"+token+"'";
				ps = con.prepareStatement(query);						
				ps.execute();
			} catch (Exception e) {
				log.info("EnquiryACT.updateHierarchyStatus "+e.getMessage());
			} 
			finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateHierarchyStatus "+sqle.getMessage());
			}
		}
	}

	public static boolean updateSalesCancelStatus(String invoice, String status, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag=false;
		try {
			String query = "UPDATE managesalesctrl SET mscancelstatus='"+status+"',msworkstatus='Inactive' WHERE msinvoiceno='"+invoice+"' and mstoken='"+token+"'";
			ps = con.prepareStatement(query);						
			int k = ps.executeUpdate();
			if(k>0)flag=true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateSalesCancelStatus "+e.getMessage());
		} 
		finally {
		try {
			if (ps != null) {
				ps.close();
			}
			if (con != null) {
				con.close();
			}
		} catch (SQLException sqle) {
			log.info("EnquiryACT.updateSalesCancelStatus "+sqle.getMessage());
		}
	}
		return flag;
	}
	
	public static boolean updateSalesCancelStatus1(String invoice, String status, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag=false;
		try {
			String query = "UPDATE managesalesctrl SET mscancelstatus='"+status+"' WHERE msinvoiceno='"+invoice+"' and mstoken='"+token+"'";
			ps = con.prepareStatement(query);						
			int k = ps.executeUpdate();
			if(k>0)flag=true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateSalesCancelStatus1 "+e.getMessage());
		} 
		finally {
		try {
			if (ps != null) {
				ps.close();
			}
			if (con != null) {
				con.close();
			}
		} catch (SQLException sqle) {
			log.info("EnquiryACT.updateSalesCancelStatus1 "+sqle.getMessage());
		}
	}
		return flag;
	}

	public static boolean saveSaleCancelReason(String estSaleNo,String salesNo,String action, 
			String description, String loginuaid,String token,String postDate) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "insert into cancel_sale(estimate_invoice,sales_invoice,user_uaid,description,post_date,token,type)values(?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, estSaleNo);
			ps.setString(2, salesNo);
			ps.setString(3, loginuaid);
			ps.setString(4, description);
			ps.setString(5, postDate);
			ps.setString(6, token);
			ps.setString(7, action);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("addNotification()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("addNotification()" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static String[][] findWeeklySalesPerson(String date7DaysBefore, String today) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT mssoldbyuid FROM managesalesctrl "
					+ "where str_to_date(mssolddate,'%d-%m-%Y')>'"+date7DaysBefore+"' and "
					+ "str_to_date(mssolddate,'%d-%m-%Y')<'"+today+"' group by mssoldbyuid";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findWeeklySalesPerson()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findWeeklySalesPerson()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findWeeklyDocumentSales(String date7DaysBefore, String today,String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,msinvoiceno,msprojectnumber,msproductname,mscompany,mscancelstatus,"
					+ "msworkstatus,tat_value,tat_type,document_assign_uaid,document_assign_name,document_assign_date"
					+ ",document_assign_time,delivery_tat_date,delivery_tat_time,document_status,document_uploaded_date,"
					+ "document_uploaded_time,mstoken FROM managesalesctrl where document_assign_date!='NA' and "
					+ "document_team_key='"+teamKey+"' and str_to_date(document_assign_date,'%d-%m-%Y')>'"+date7DaysBefore+"'"
					+ " and str_to_date(document_assign_date,'%d-%m-%Y')<'"+today+"'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findWeeklyDocumentSales()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findWeeklyDocumentSales()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findSalesByBetweenDatesAndTeam(String date7DaysBefore, String today,
			String teamKey,String teamLeaderUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,mstoken FROM managesalesctrl where exists("
					+ "SELECT tmid FROM manageteammemberctrl where "
					+ "tmteamrefid='"+teamKey+"' and tmuseruid=mssoldbyuid or mssoldbyuid='"+teamLeaderUid+"')"
					+ " and str_to_date(mssolddate,'%d-%m-%Y')>'"+date7DaysBefore+"' and "
					+ "str_to_date(mssolddate,'%d-%m-%Y')<'"+today+"'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findSalesByBetweenDates()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesByBetweenDates()" + e.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] findSalesByBetweenDates(String startDate, String endDate) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,mssolddate,msinvoiceno,msprojectnumber,msproductname,mscontactrefid,mscompany,"
					+ "msworkpercent,mssoldbyuid,mscancelstatus,msworkstatus,mstoken,delivery_person_name,sales_type"
					+ " FROM managesalesctrl where str_to_date(mssolddate,'%d-%m-%Y')>='"+startDate+"' and "
					+ "str_to_date(mssolddate,'%d-%m-%Y')<='"+endDate+"'";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findSalesByBetweenDates()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesByBetweenDates()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findDeliverySalesByBetweenDates(String startDate, String endDate,String managerUaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,mstoken FROM managesalesctrl "
					+ "where str_to_date(mssolddate,'%d-%m-%Y')>='"+startDate+"' and "
					+ "str_to_date(mssolddate,'%d-%m-%Y')<='"+endDate+"' and delivery_person_uid='"+managerUaid+"'";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findDeliverySalesByBetweenDates()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findDeliverySalesByBetweenDates()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findSalesByBetweenDates(String date7DaysBefore, String today,String soldByUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msrefid,mssolddate,msinvoiceno,msprojectnumber"
					+ ",msproductname,mscontactrefid,mscompany,msworkpercent,"
					+ "mssoldbyuid,mscancelstatus,msworkstatus,mstoken FROM managesalesctrl "
					+ "where str_to_date(mssolddate,'%d-%m-%Y')>'"+date7DaysBefore+"' and "
					+ "str_to_date(mssolddate,'%d-%m-%Y')<'"+today+"' and mssoldbyuid='"+soldByUid+"'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findSalesByBetweenDates()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesByBetweenDates()" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesContactName(String contactKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select cbname from contactboxctrl where cbrefid=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, contactKey);

			rs = ps.executeQuery();
			if (rs.next()) {
				data = rs.getString(1);
			}
			
		} catch (Exception e) {
			log.info("getSalesContactName()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("getSalesContactName()" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String getSalesContactEmail(String contactKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select cbemail1st from contactboxctrl where cbrefid=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, contactKey);

			rs = ps.executeQuery();
			if (rs.next()) {
				data = rs.getString(1);
			}
			
		} catch (Exception e) {
			log.info("getSalesContactEmail()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {e.printStackTrace();
				log.info("getSalesContactEmail()" + e.getMessage());
			}
		}
		return data;
	}
	
	public static String[][] findSalesPersonByDeliveryDate(String deliveryDate) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT mssoldbyuid,mstoken FROM managesalesctrl where msdeliverydate!='NA' and msdeliveredon='NA' and str_to_date(msdeliverydate,'%d-%m-%Y')='"+deliveryDate+"' and mscancelstatus='2' group by mssoldbyuid";
//			System.out.println(query);
			
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findSalesPersonByDeliveryDate()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesPersonByDeliveryDate()" + e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findExpiredSalesPersonByDeliveryDate(String deliveryDate) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT mssoldbyuid,mstoken FROM managesalesctrl where msdeliverydate!='NA' and msdeliveredon='NA' and str_to_date(msdeliverydate,'%d-%m-%Y')<='"+deliveryDate+"' and mscancelstatus='2' group by mssoldbyuid";
//			System.out.println(query);
			
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findExpiredSalesPersonByDeliveryDate()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findExpiredSalesPersonByDeliveryDate()" + e.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] findAllExpiredTaskAssignee() {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "select mateammemberid,matokenno from manage_assignctrl where "
					+ "maworkstatus='Expired' and mahierarchyactivestatus='1' and "
					+ "madelivereddate='NA' and masaleshierarchystatus='1' and maapprovalstatus='1'"
					+ " and mastepstatus='1' and maworkstarteddate!='00-00-0000' group by mateammemberid";
			stmnt = con.prepareStatement(query.toString());
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
			log.info("findAllExpiredTaskAssignee()" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findAllExpiredTaskAssignee()" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateDeliveryAssignDetails(String salesrefid, String teamuaid, String teamname, String today,
			String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update managesalesctrl set delivery_person_uid=?,"
					+ "delivery_person_name=?,delivery_assign_status=?,delivery_assign_date=? where msrefid=?"
					+ " and mstoken=?");

			ps = con.prepareStatement(queryselect.toString());
			ps.setString(1, teamuaid);
			ps.setString(2, teamname);
			ps.setString(3, "1");
			ps.setString(4, today);
			ps.setString(5, salesrefid);
			ps.setString(6, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateDeliveryAssignDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateDeliveryAssignDetails" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateSalesDocumentAssignDetails(String salesrefid, String uaid, String name, String today,
			String token,String time,String tatDate,String tatTime,String teamKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer("update managesalesctrl set document_assign_uaid=?,"
					+ "document_assign_name=?,document_assign_date=?,document_status=?,document_assign_time=?"
					+ ",delivery_tat_date=?,delivery_tat_time=?,document_team_key=? where msrefid=? and mstoken=?");

			ps = con.prepareStatement(queryselect.toString());
			ps.setString(1, uaid);
			ps.setString(2, name);
			ps.setString(3, today);
			ps.setInt(4, 1);
			ps.setString(5, time);
			ps.setString(6, tatDate);
			ps.setString(7, tatTime);
			ps.setString(8, teamKey);
			ps.setString(9, salesrefid);
			ps.setString(10, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateSalesDocumentAssignDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateSalesDocumentAssignDetails" + e.getMessage());
			}
		}
		return flag;
	}

	public static String findAssignedManager(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select delivery_person_uid from managesalesctrl where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("findAssignedManager" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("findAssignedManager" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isAllReUploadDone(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String query = "SELECT sdid FROM salesdocumentctrl where sdsalesrefid='"+salesKey+"' and sduploadby='Client'"
					+ " and reupload_status='1' and sdtokenno='"+token+"'";
//			System.out.println(query);
			ps = con.prepareStatement(query);	
			rset=ps.executeQuery();
			if(rset.next())getinfo=true;
			
		} catch (Exception e) {
			log.info("isAllReUploadDone" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isAllReUploadDone" + e.getMessage());
			}
		}
		return getinfo;
	}
	
	public static boolean isAllClientDocumentUploaded(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		int total=0;
		int uploaded=0;
		try {
			String query = "SELECT sddocname,sduploadedby,sduploaddate FROM salesdocumentctrl where "
					+ "sdsalesrefid='"+salesKey+"' and sduploadby='Client' and sdtokenno='"+token+"'";
//			System.out.println(query);
			ps = con.prepareStatement(query);	
			rset=ps.executeQuery();
			while(rset.next()) {
				total++;
				if(!rset.getString(1).equals("NA")&&rset.getString(1)!=null&&
						!rset.getString(2).equals("NA")&&rset.getString(2)!=null
						&&!rset.getString(3).equals("00-00-0000")&&rset.getString(3)!=null)
					uploaded++;
			}
			
			if(total>0&&total==uploaded)getinfo=true;			
			
		} catch (Exception e) {
			log.info("isAllClientDocumentUploaded" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isAllClientDocumentUploaded" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean updateDocumentReUploadStatus(String docKey, String token,String userUaid,String today,String location) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag=false;
		try {
			String queryselect = "update salesdocumentctrl set reupload_status=?,reupload_uaid=?,reupload_date=?"
					+ ",reupload_requested_url=? where sdrefid=? and sdtokenno=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, "1");
			ps.setString(2, userUaid);
			ps.setString(3, today);
			ps.setString(4, location);
			ps.setString(5, docKey);
			ps.setString(6, token);

			int k = ps.executeUpdate();
			if(k>0)flag=true;

		} catch (Exception e) {
			log.info("updateDocumentReUploadStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("updateDocumentReUploadStatus" + e.getMessage());
			}
		}
		return flag;
	}
	
	public static boolean updateSalesReUploadStatus(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag=false;
		try {
			String queryselect = "update managesalesctrl set doc_re_upload=? where msrefid=? and mstoken=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, "1");
			ps.setString(2, salesKey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if(k>0)flag=true;

		} catch (Exception e) {
			log.info("updateSalesReUploadStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("updateSalesReUploadStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean findReUploadRequested(String docKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		
		try {
			String query = "SELECT sdid FROM salesdocumentctrl where sdrefid='"+docKey+"' "
					+ "and sduploadby='Client' and reupload_status='1' and sdtokenno='"+token+"'";
			
			ps = con.prepareStatement(query);	
			rset=ps.executeQuery();
			
			if(rset.next())getinfo=true;			
			
		} catch (Exception e) {
			log.info("findReUploadRequested" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findReUploadRequested" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static int findContactIdByKey(String contactKey,String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		int getinfo=0;
		try{
			String query="SELECT ccbid FROM clientcontactbox WHERE ccbrefid='"+contactKey+"' and cctokenno='"+token+"' limit 1";
//				System.out.println(query);
			ps=con.prepareStatement(query);
			rset=ps.executeQuery();
			if(rset.next()) getinfo=rset.getInt(1);
			
		}catch (Exception e) {
			log.info("findContactIdByKey"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) {rset.close();}
			} catch (SQLException e){
				log.info("findContactIdByKey"+e.getMessage());
			}}
		return getinfo;
	}

	public static boolean removeSalesPermission(String salesId, String uaid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from user_sales_info where user_id=? and sales_id=? and token=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, uaid);
			ps.setString(2, salesId);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("removeSalesPermission" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeSalesPermission" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean removeCompanyPermission(String companyId, String uaid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		boolean flag = false;
		try {
			String queryselect = "delete from client_user_info where user_id=? and client_id=? and token=?";
			ps = con.prepareStatement(queryselect);
			ps.setString(1, uaid);
			ps.setString(2, companyId);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("removeCompanyPermission" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("removeCompanyPermission" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean isServiceAssigned(String salesKey, String uaid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		
		try {
			String query = "SELECT msid FROM managesalesctrl where msrefid='"+salesKey+"' "
					+ "and document_assign_uaid='"+uaid+"' and mstoken='"+token+"' limit 1";
			
			ps = con.prepareStatement(query);	
			rset=ps.executeQuery();
			
			if(rset.next())getinfo=true;			
			
		} catch (Exception e) {
			log.info("isServiceAssigned" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isServiceAssigned" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[][] fetchDocumentExpired(String today, String time) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String query = "SELECT msid,msprojectnumber,msinvoiceno,msproductname,document_assign_uaid,document_assign_name,mstoken,"
					+ "document_team_key FROM managesalesctrl where doc_uploaded='2' and document_status!='3' and delivery_tat_date!='NA' and "
					+ "delivery_tat_time!='NA' and str_to_date(delivery_tat_date,'%d-%m-%Y')='"+today+"'"
							+ " and delivery_tat_time<'"+time+"'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
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
			log.info("fetchDocumentExpired" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("fetchDocumentExpired" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[] findHsnDetails(String hsn, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[] newsdata = new String[3];
		try {
			String query = "SELECT mtsgstpercent,mtcgstpercent,mtigstpercent FROM managetaxctrl where mthsncode='"+hsn+"' and mttoken='"+token+"'";
//			System.out.println(query);
			stmnt = con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			while (rsGCD != null && rsGCD.next()) {
				newsdata[0]=rsGCD.getString(1);
				newsdata[1]=rsGCD.getString(2);
				newsdata[2]=rsGCD.getString(3);
			}
		} catch (Exception e) {
			log.info("findHsnDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (stmnt != null) {
					stmnt.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findHsnDetails" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String findSalesRemarksBySalesKeyAndtoken(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rs = null;
		String data = "NA";
		try {
			String queryselect = "select msremarks from managesalesctrl where msrefid=? and mstoken=?";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			ps.setString(1, salesKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("findSalesRemarksBySalesKeyAndtoken" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rs!=null)rs.close();
			} catch (SQLException e) {
				log.info("findSalesRemarksBySalesKeyAndtoken" + e.getMessage());
			}
		}
		return data;
	}

	public static boolean isInvoiceConverted(String unbillno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT sid FROM salesestimatepayment where sunbill_no='" + unbillno + "' and sunbill_no='"+ token
					+ "' and sinvoice_status='1'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isInvoiceConverted" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isInvoiceConverted" + e.getMessage());
			}
		}
		return getinfo;
	}
	
}
