package admin.seo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.http.HttpServlet;

import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import admin.task.TaskMaster_ACT;
import commons.DbCon;


public class SeoOnPage_ACT extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(LoginAction.class);
	
	
	public static boolean removeFile(String skey,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;		
		Connection con = DbCon.getCon("","","");
		boolean flag=false;
		try{
			ps=con.prepareStatement("update salesdocumentctrl set sdstatus='2' where sdrefid='"+skey+"' and sdtokenno='"+token+"'");
			int k=ps.executeUpdate();
			if(k>0)flag=true;
		}
		catch (Exception e) {
			log.info("removeFile()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects removeFile()\n"+sqle.getMessage());
			}
		}
		return flag;
	}
	
	public static String getDeliveryDate(String str_date,String delivery_time)
	{
		String deliveryDate="";
		
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		    Calendar c1 = Calendar.getInstance();
			 if(delivery_time!=null&&!delivery_time.equalsIgnoreCase("NA")){
			    	
				    String x[]=str_date.split("-");
				    int syy=Integer.parseInt(x[2]);
				    int smm=Integer.parseInt(x[1]);
				    int sdd=Integer.parseInt(x[0]);
				    
				    String y[]=delivery_time.split(":");
				    int dyy=Integer.parseInt(y[0]);
				    int dmm=Integer.parseInt(y[1]);
				    int ddd=Integer.parseInt(y[2]);
				    int dhh=Integer.parseInt(y[3]);
				    
				    if(dhh>7){
				    	int h=dhh/8;
				    	dhh=dhh-(h*8);
				    	ddd+=h;
				    }		    
				    c1.set((syy+dyy), (smm+dmm)-1 , (sdd+ddd)); 		    
				    deliveryDate=sdf.format(c1.getTime());
				    int sunday=TaskMaster_ACT.getSunday(str_date,deliveryDate);
				    		    
				    c1.set((syy+dyy), (smm+dmm)-1 , (sdd+ddd+sunday)); 		    
				    deliveryDate=sdf.format(c1.getTime());
				    
				    boolean flag=TaskMaster_ACT.isSunday(deliveryDate);
				    if(flag){
				    	c1.set((syy+dyy), (smm+dmm)-1 , (sdd+ddd+sunday+1)); 		    
					    deliveryDate=sdf.format(c1.getTime());
				    }
				    
				    String tt=null;
				    int time=9+dhh;
				    if(time>=12){
				    	int t=time-12;
				    	int z=t-10;
				    	if(z<0)
				    	tt="0"+t+":"+"30 pm";
				    	else
				    		tt=t+":"+"30 pm";	
				    }else{
				    	int z=time-10;
				    	if(z<0)
				    	tt="0"+time+":"+"30 am";
				    	else
				    		tt=time+":"+"30 am";
				    }
				    deliveryDate=deliveryDate+"  "+tt;
				    }
			
		}
		catch (Exception e) {
			log.info("getDeliveryDate()"+e.getMessage());
		}		
		return deliveryDate;
	}
	
	
	public static String getBuildingTime(String pid,String mid,String token)
	{
		PreparedStatement ps = null;
		ResultSet rs=null;
		String result=null;
		int year=0;
		int month=0;
		int day=0;
		int hour=0;
		Connection con = DbCon.getCon("","","");
		try{
			String x[]=mid.split(",");
			StringBuffer query =new StringBuffer("select duration,unittime from project_milestone where preguid='"+pid+"' and tokenno='"+token+"'");
			for(int i=0;i<x.length;i++){
				if(i==0)
				query.append(" and id='"+x[i]+"'");
				else
					query.append(" or id='"+x[i]+"'");
			}
			ps = con.prepareStatement(query.toString());
			rs=ps.executeQuery();
			while(rs.next()){
				if(rs.getString(2).equalsIgnoreCase("Year")) year+=Integer.parseInt(rs.getString(1));
				if(rs.getString(2).equalsIgnoreCase("Month")) month+=Integer.parseInt(rs.getString(1));
				if(rs.getString(2).equalsIgnoreCase("Day")) day+=Integer.parseInt(rs.getString(1));
				if(rs.getString(2).equalsIgnoreCase("Hour")) hour+=Integer.parseInt(rs.getString(1));
			}
			result=year+":"+month+":"+day+":"+hour;
		}
		catch (Exception e) {
			log.info("getBuildingTime()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getBuildingTime()\n"+sqle.getMessage());
			}
		}
		return result;
	}
	/*For counting all files of a particular folder*/
	public static String getStatus(String uid,String refid,String token)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		String result="NA";
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select fpid from folder_permission where fp_frefid='"+refid+"' and fp_uid='"+uid+"' and fptoken='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getString(1);			
		}
		catch (Exception e) {
			log.info("getStatus()"+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getStatus()\n"+sqle.getMessage());
			}
		}
		return result;
	}
	public static int countAllFolders(String refid,String token)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		int result=0;
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select count(fid) from folder_master where frefid='"+refid+"' and ftokenno='"+token+"' and ffcategory='Sub' and ftype='Sales'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getInt(1);			
		}
		catch (Exception e) {
			log.info("countAllFolders()"+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects countAllFolders()\n"+sqle.getMessage());
			}
		}
		return result;
	}
	/*For counting all files of a particular folder*/
	public static int countAllFiles(String refid,String token)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		int result=0;
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select count(sdid) from salesdocumentctrl where sdsalesrefid='"+refid+"' and sdtokenno='"+token+"' and sdstatus='1'");
//			System.out.println("select count(sdid) from salesdocumentctrl where sdsalesrefid='"+refid+"' and sdtokenno='"+token+"' and sdstatus='1'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getInt(1);			
		}
		catch (Exception e) {
			log.info("countAllFiles()"+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects countAllFiles()\n"+sqle.getMessage());
			}
		}
		return result;
	}
	
	/*For updating project's delivery date*/
	public static String getTaskDetails(String aid,String token)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		String result="";
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select aassigndate,adeliverydate,aremarks from assigntask where aid='"+aid+"' and atokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next())
				result=rs.getString(1)+"@"+rs.getString(2)+"@"+rs.getString(3);			
		}
		catch (Exception e) {
			log.info("getTaskDetails()"+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects getTaskDetails()\n"+sqle.getMessage());
			}
		}
		return result;
	}
	/*For updating project's delivery date*/
	@SuppressWarnings("resource")
	public static void updteProjectDeliveryDate(String ptstid,String token)
	{		
		PreparedStatement ps = null;
		ResultSet rs=null;
		String projectno=null;
		Connection con = DbCon.getCon("","","");
		try{	
			ps = con.prepareStatement("select ptlto from projecttask_list where ptluid='"+ptstid+"' and ptltokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) projectno=rs.getString(1);
			if(projectno!=null){
			ps = con.prepareStatement("update hrmproject_reg set pregddate=(select max(ptlddate) from projecttask_list where ptlto=? and ptltokenno=?) where pregpuno=? and pregtokenno=?");
			ps.setString(1,projectno );
			ps.setString(2,token );
			ps.setString(3,projectno );
			ps.setString(4,token );
			ps.execute();
			}
		}
		catch (Exception e) {
			log.info("updteProjectDeliveryDate()"+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updteProjectDeliveryDate()\n"+sqle.getMessage());
			}
		}
	}
	
	/*For saving the offpageseo jsp details*/
	public static boolean updateDeliveryDate(String ptstid,String mid,String deliverydate,String token,String emproleid,String loginuaid)
	{
		boolean status = false;
		PreparedStatement ps = null;
		String query =null;
		Connection con = DbCon.getCon("","","");
		try{		
			if(!emproleid.equalsIgnoreCase("Administrator"))
			query = "update assigntask set adeliverydate='"+deliverydate+"' where ataskid='"+ptstid+"' and amilestoneid='"+mid+"' and aassignedtoid='"+loginuaid+"' and atokenno='"+token+"'";
			else
				query = "update assigntask set adeliverydate='"+deliverydate+"' where ataskid='"+ptstid+"' and amilestoneid='"+mid+"' and atokenno='"+token+"'";	
				
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		}
		catch (Exception e) {
			log.info("updateDeliveryDate()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateDeliveryDate()\n"+sqle.getMessage());
			}
		}
		return status;
	}
	public static String getClientId(String folder,String token){
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		ResultSet rs=null;
		String data="NA";
		try{
			if(folder!="NA"||folder!=null){
				String x[]=folder.split("#");
			ps=con.prepareStatement("select fclientid from folder_master where frefid='"+x[0]+"' and fname='"+x[1]+"' and ftokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next())data=rs.getString(1);			
			}
		}catch(Exception e){
			log.info("getClientId()"+e.getMessage());
		}finally{
			try{
				if(ps!=null)ps.close();
				if(con!=null)con.close();
				if(rs!=null)rs.close();
			}catch(Exception sqle){
				log.info("Error Closing SQL Objects getClientId()\n"+sqle.getMessage());
			}
		}
		return data;
	}
	/*For adding folder*/
	public static void saveDocument(String refid,String fname,String imgname,String fpath,String token,String loginid,String doctype,String docname,String clientid,String today)
	{
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into document_master(dmrefno,dmfolder_name,dmdocument_name,dmdocumentpath,dmstatus,dmaddedby,dmtokenno,dmdoctype,dmdocname,dmclientid,dmdate)values(?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);		
			ps.setString(1,refid );
			ps.setString(2,fname );
			ps.setString(3,imgname );
			ps.setString(4,fpath );
			ps.setString(5,"1" );
			ps.setString(6,loginid );
			ps.setString(7,token );
			ps.setString(8,doctype );
			ps.setString(9,docname );
			ps.setString(10, clientid);
			ps.setString(11, today);
			
			ps.executeUpdate();
		}
		catch (Exception e) {
			log.info("saveDocument()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveDocument()\n"+sqle.getMessage());
			}
		}	
	}
	/*For adding folder*/
	public static void addPermissions(String userId,String frefid,String token,String loginid,String fcategory)
	{		
		PreparedStatement ps1 = null;
		Connection con = DbCon.getCon("","","");
		try{	
			
				ps1=con.prepareStatement("insert into folder_permission(fp_frefid,fp_uid,fpstatus,fpaddedby,fptoken,fpcategory) values(?,?,?,?,?,?)");
				ps1.setString(1,frefid );
				ps1.setString(2,userId );
				ps1.setString(3,"1" );
				ps1.setString(4,loginid );
				ps1.setString(5,token );
				ps1.setString(6,fcategory );
				ps1.execute();
			
			
		}
		catch (Exception e) {
			log.info("addPermissions()"+e.getMessage());
		}
		finally{
			try{
				if(ps1!=null) {ps1.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addPermissions()\n"+sqle.getMessage());
			}
		}	
	}
	/*For adding folder*/
	public static boolean addFolder(String fkey,String fsaleskey,String folder_name,String loginid,String token,String clientId,String loginuaid,String category,String ftype)
	{
		boolean status = false;
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into folder_master(frefid,fname,fstatus,faddedby,ftokenno,fclientid,floginuaid,ffcategory,ftype,fsalesrefid)values(?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);		
			ps.setString(1,fkey );
			ps.setString(2,folder_name );
			ps.setString(3,"1" );
			ps.setString(4,loginid );
			ps.setString(5,token );
			ps.setString(6,clientId );
			ps.setString(7,loginuaid );
			ps.setString(8,category );
			ps.setString(9,ftype );
			ps.setString(10,fsaleskey );
			
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}
		catch (Exception e) {
			log.info("addFolder()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addFolder\n"+sqle.getMessage());
			}
		}
		return status;
	}
	/*For saving the offpageseo jsp details*/
	public static boolean saveSeoDetail(String amopscontent,String amonpstuid,String amopstwurl,String amonpstatype,String amonpsturl,String amopskeyw,String amopssourl,String amopsseng,String amonpsstatus,String amonpststatus,String amonpsaddedby, String amonpspuid, String websitenature)
	{
		boolean status = false;
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into amonpage_seo(amopscontent,amonpstuid,amopstwurl,amonpstatype,amonpsturl,amopskeyw,amopssourl,amopsseng,amonpsstatus,amonpststatus,amonpsaddedby,amonpspuid, websitenature)values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);		
			ps.setString(1,amopscontent );
			ps.setString(2,amonpstuid );
			ps.setString(3,amopstwurl );
			ps.setString(4,amonpstatype );
			ps.setString(5,amonpsturl );
			ps.setString(6,amopskeyw );
			ps.setString(7,amopssourl );
			ps.setString(8,amopsseng );
			ps.setString(9,amonpsstatus );
			ps.setString(10,amonpststatus );
			ps.setString(11,amonpsaddedby );
			ps.setString(12,amonpspuid );
			ps.setString(13,websitenature );
			ps.executeUpdate();
			status = true;
		}
		catch (Exception e) {
			log.info("saveSeoDetail()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveSeoDetail()\n"+sqle.getMessage());
			}
		}
		return status;
	}
	/*For all sub-folder*/
	public static String[][] getAllSubFolder(String refid,String token,String role,String uaid,int page,int rows) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			if(role.equalsIgnoreCase("Administrator"))
				VCQUERY=new StringBuffer("SELECT fid,frefid,fname,fsfrefid,fsalesrefid FROM folder_master where frefid='"+refid+"' and ftokenno='"+token+"' and ffcategory='Sub' and ftype='Sales'");
			else
				VCQUERY=new StringBuffer("SELECT fid,frefid,fname,fsfrefid,fsalesrefid FROM folder_master where exists(select fpid from folder_permission where fp_frefid=fsfrefid and fp_uid='"+uaid+"' and fpcategory='sub-folder') and frefid='"+refid+"' and ftokenno='"+token+"' and ffcategory='Sub'");
			VCQUERY.append(" order by fid desc limit "+((page-1)*rows)+','+rows);
//						System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error in getAllSubFolder : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static int countAllSubFolder(String refid,String token,String role,String uaid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			if(role.equalsIgnoreCase("Administrator"))
				VCQUERY=new StringBuffer("SELECT count(fid) FROM folder_master where frefid='"+refid+"' and ftokenno='"+token+"' and ffcategory='Sub' and ftype='Sales'");
			else
				VCQUERY=new StringBuffer("SELECT count(fid) FROM folder_master where exists(select fpid from folder_permission where fp_frefid=fsfrefid and fp_uid='"+uaid+"' and fpcategory='sub-folder') and frefid='"+refid+"' and ftokenno='"+token+"' and ffcategory='Sub'");
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			
			if(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{log.info("error in countAllSubFolder : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects  countAllSubFolder()\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	/*For all document files details*/
	public static String[][] getAllFiles(String refid,String token,String docActionFiles,int page,int rows,String sort,String order) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			
				VCQUERY=new StringBuffer("SELECT sdrefid,sduploaddocname,sddescription,sduploadby,sddocname,sduploadedby,sduploaddate FROM salesdocumentctrl where sdsalesrefid='"+refid+"' and sdtokenno='"+token+"' and sdstatus='1' and sduploadby='"+docActionFiles+"' ");
				
				if(sort.length()<=0)			
					VCQUERY.append("order by sdid desc limit "+((page-1)*rows)+","+rows);
					else if(sort.equals("id"))VCQUERY.append("order by sdid "+order+" limit "+((page-1)*rows)+","+rows);
					else if(sort.equals("name"))VCQUERY.append("order by sddocname "+order+" limit "+((page-1)*rows)+","+rows);
					else if(sort.equals("upload_date"))VCQUERY.append("order by sduploaddate "+order+" limit "+((page-1)*rows)+","+rows);
					else if(sort.equals("doc_name"))VCQUERY.append("order by sduploaddocname "+order+" limit "+((page-1)*rows)+","+rows);
				//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{e.printStackTrace();
			log.info("error in getAllFiles : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllFiles:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static int countAllFiles(String refid,String token,String docActionFiles) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			
				VCQUERY=new StringBuffer("SELECT count(sdid) FROM salesdocumentctrl where sdsalesrefid='"+refid+"' and sdtokenno='"+token+"' and sdstatus='1' and sduploadby='"+docActionFiles+"' ");
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			
			while(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{e.printStackTrace();
			log.info("error in countAllFiles : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects countAllFiles:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	/*For getting all users*/
	public static String[][] getAllUser(String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			
				VCQUERY=new StringBuffer("SELECT uaid,uaname,uaroletype FROM user_account where uavalidtokenno='"+token+"' and uaroletype!='Administrator'");
			
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error in getAllUser : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllUser:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	/*For folder name details*/
	public static String[][] getAllFolder(String token,String role,String uaid,String ClientId,String doDocumentAction,
			String dateRange,int page,int rows) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		StringBuffer sql=null;
		String fromDate="NA";
		String toDate="NA";
		try{
			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			String ftype="sales";
			if(doDocumentAction.equalsIgnoreCase("Personal"))ftype="Personal";
			if(role.equalsIgnoreCase("Administrator"))
			sql=new StringBuffer("SELECT fm.frefid,fm.fname,fm.ffcategory,fm.fclientid,fm.floginuaid,fm.fsalesrefid FROM folder_master fm where fm.ftokenno='"+token+"' and fm.ffcategory='Main' and fm.ftype='"+ftype+"'");
			else{
				sql=new StringBuffer("SELECT fm.frefid,fm.fname,fm.ffcategory,fm.fclientid,fm.floginuaid,fm.fsalesrefid FROM folder_master fm where exists(select fpid from folder_permission fp where fp.fp_frefid=fm.frefid and fp.fp_uid='"+uaid+"' and fp.fpcategory='folder') and fm.ftokenno='"+token+"' and fm.ffcategory='Main' and fm.ftype='"+ftype+"'");
			}
			if(!ClientId.equalsIgnoreCase("NA"))sql.append(" and fm.fclientid='"+ClientId+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				sql.append(" and str_to_date(faddedon,'%Y-%m-%d')<='"+toDate+"' and str_to_date(faddedon,'%Y-%m-%d')>='"+fromDate+"'");
			}		
			if(page>0)
		    sql.append("order by fid desc limit "+((page-1)*rows)+","+rows);
			else sql.append("order by fid desc");
//			System.out.println(sql);
			stmnt=getacces_con.prepareStatement(sql.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error in getAllFolder : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllFolder\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static int countAllFolder(String token,String role,String uaid,String ClientId,String doDocumentAction,String dateRange) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		StringBuffer sql=null;
		String fromDate="NA";
		String toDate="NA";
		try{
			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			String ftype="sales";
			if(doDocumentAction.equalsIgnoreCase("Personal"))ftype="Personal";
			if(role.equalsIgnoreCase("Administrator"))
			sql=new StringBuffer("SELECT count(fid) FROM folder_master fm where fm.ftokenno='"+token+"' and fm.ffcategory='Main' and fm.ftype='"+ftype+"'");
			else{
				sql=new StringBuffer("SELECT count(fid) FROM folder_master fm where exists(select fpid from folder_permission fp where fp.fp_frefid=fm.frefid and fp.fp_uid='"+uaid+"' and fp.fpcategory='folder') and fm.ftokenno='"+token+"' and fm.ffcategory='Main' and fm.ftype='"+ftype+"'");
			}
			if(!ClientId.equalsIgnoreCase("NA"))sql.append(" and fm.fclientid='"+ClientId+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				sql.append(" and str_to_date(faddedon,'%Y-%m-%d')<='"+toDate+"' and str_to_date(faddedon,'%Y-%m-%d')>='"+fromDate+"'");
			}
//			System.out.println(sql);
			stmnt=getacces_con.prepareStatement(sql.toString());
			rsGCD=stmnt.executeQuery();
			
			if(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{log.info("error in countAllFolder : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects countAllFolder\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	/*For manage-seo jsp details*/
	public static String[][] getAllCompletedTask(String loginuaid,String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			
				VCQUERY=new StringBuffer("SELECT ptluid,ptlname,pregpname,ptladate,ptlstatus,ptlddate,ptltuid,ptlpuid FROM projecttask_list join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where exists(select atid from assignedtaskid where attaskno=projecttask_list.ptltuid and atassignedid='"+loginuaid+"') and pregtokenno='"+token+"' and ptlstatus='Completed' ");
			
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error in getAllCompletedTask : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllCompletedTask:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	/*For manage-seo jsp details*/
	public static String[][] getAllseo(String loginuaid, String role, String limit, String projectname, String activitytype, String token, String from, String to, String nature, String keyword, String taskname) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			if(projectname==null || projectname.equalsIgnoreCase("null") || projectname.length() <= 0){ projectname ="NA";}
			if(activitytype==null || activitytype.equalsIgnoreCase("null") || activitytype.length() <= 0){ activitytype ="NA";}
			if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			if(nature==null || nature.equalsIgnoreCase("Any") || nature.length() <= 0){ nature ="NA";}
			if(keyword==null || keyword.equalsIgnoreCase("Any") || keyword.length() <= 0){ keyword ="NA";}
			if(taskname==null || taskname.equalsIgnoreCase("Any") || taskname.length() <= 0){ taskname ="NA";}
			if (role.equals("Administrator")) {
				VCQUERY=new StringBuffer("SELECT ptlname,amopsuid,amonpsturl,amopsseng,amonpstatype,amonpststatus, websitenature, amopssourl,amopskeyw,amonpstuid,amopsaddedon,pregpname FROM amonpage_seo LEFT Join projecttask_list on amonpage_seo.amonpspuid=projecttask_list.ptluid join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where pregtokenno='"+token+"'");
			}
			else if(role.equalsIgnoreCase("super admin")) {
				VCQUERY=new StringBuffer("SELECT ptlname,amopsuid,amonpsturl,amopsseng,amonpstatype,amonpststatus, websitenature, amopssourl,amopskeyw,amonpstuid,amopsaddedon,pregpname FROM amonpage_seo LEFT Join projecttask_list on amonpage_seo.amonpspuid=projecttask_list.ptluid join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where pregtokenno!='NA'");
			}
			else{
				VCQUERY=new StringBuffer("SELECT ptlname,amopsuid,amonpsturl,amopsseng,amonpstatype,amonpststatus, websitenature, amopssourl,amopskeyw,amonpstuid,amopsaddedon,pregpname FROM amonpage_seo LEFT Join projecttask_list on amonpage_seo.amonpspuid=projecttask_list.ptluid join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where exists(select atid from assignedtaskid where attaskno=projecttask_list.ptltuid and atassignedid='"+loginuaid+"') and pregtokenno='"+token+"'");
			}
			if(projectname!="NA")
			{
				VCQUERY.append(" and pregpname = '"+projectname+"'");
			}
			if(activitytype!="NA")
			{
				VCQUERY.append(" and amonpstatype = '"+activitytype+"'");
			}
			if(nature!="NA")
			{
				VCQUERY.append(" and websitenature = '"+nature+"'");
			}
			if(keyword!="NA")
			{
				VCQUERY.append(" and amopskeyw = '"+keyword+"'");
			}
			if(taskname!="NA")
			{
				VCQUERY.append(" and ptlname = '"+taskname+"'");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and amopsaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and amopsaddedon between '"+from+"%' and '"+to+"%'");
			VCQUERY.append(" order by amopsuid desc "+limit);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error in getallseo : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getallseo:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}


	/*For edit-seo jsp */
	public static String[][] getSeoByID(String uid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");

			String query="SELECT ptlname,amonpstuid,amopscontent,amopstwurl,amonpstatype,amonpsturl,amopskeyw,amopssourl,amopsseng,amonpsstatus,amonpststatus,websitenature,amonpspuid FROM projecttask_list LEFT join amonpage_seo on projecttask_list.ptluid=amonpage_seo.amonpspuid where amopsuid='"+uid+"' ";
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error in getSeoByID : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSeoByID:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
public static void deleteTaskStatus(String id,String loginuID,String emproleid,String token){
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			if(emproleid.equalsIgnoreCase("Administrator")){
			ps = con.prepareStatement("delete from projecttask_status where ptsid='"+id+"' and ptstokenno='"+token+"'");
			ps.execute();
			}else{
				ps = con.prepareStatement("delete from projecttask_status where ptsid='"+id+"' and ptstokenno='"+token+"' and ptsaddedby='"+loginuID+"'");
				ps.execute();
			}
			
		}catch (Exception e) {
			log.info("error in deleteTaskStatus : "+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteTaskStatus:\n"+sqle.getMessage());
			}
		}
	}
	
	/*For update in edit-seo jsp */
	public static boolean updateSeoDetail(String uid,String amopscontent,String amopstwurl,String amonpstatype,String amonpsturl,String amopskeyw,String amopssourl,String amopsseng,String amonpsstatus,String amonpststatus,String amonpsaddedby, String websitenature) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE amonpage_seo SET amopscontent=?,amopstwurl=?,amonpstatype=?,amonpsturl=?,amopskeyw=?,amopssourl=?,amopsseng=?,amonpsstatus=?,amonpststatus=?,amonpsaddedby=?, websitenature=? WHERE amopsuid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,amopscontent );
			ps.setString(2,amopstwurl );
			ps.setString(3,amonpstatype );
			ps.setString(4,amonpsturl );
			ps.setString(5,amopskeyw );
			ps.setString(6,amopssourl );
			ps.setString(7,amopsseng );
			ps.setString(8,amonpsstatus );
			ps.setString(9,amonpststatus );
			ps.setString(10,amonpsaddedby );
			ps.setString(11,websitenature );
			ps.setString(12,uid );
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("error in updateSeoDetail : "+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateSeoDetail:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	/*For delete in manage seo jsp */
	public static String getDates(String mid,String taskid,String loginuaid,String token,String emproleid) {
		PreparedStatement ps = null;
		ResultSet rs=null;		
		String result=null;
		String query =null;
		Connection con = DbCon.getCon("","","");
		try{
			if(!emproleid.equalsIgnoreCase("Administrator"))
			query = "select aassigndate,adeliverydate from assigntask where ataskid='"+taskid+"' and amilestoneid='"+mid+"' and aassignedtoid='"+loginuaid+"' and atokenno='"+token+"'";
			else
				query = "select aassigndate,adeliverydate from assigntask where ataskid='"+taskid+"' and amilestoneid='"+mid+"' and atokenno='"+token+"' order by aid desc limit 1";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			rs=ps.executeQuery();
			if(rs.next()){
				result=rs.getString(1)+"#"+rs.getString(2);
			}
			
		}catch (Exception e) {
			log.info("error in getDates : "+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getDates:\n"+sqle.getMessage());
			}
		}
		return result;
	}
	/*For delete folder */
	public static void deletePermission(String uid,String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
		
			String query = "DELETE FROM folder_permission WHERE fpid='"+uid+"' and fptoken='"+token+"'";
			ps = con.prepareStatement(query);
			ps.execute();
				
		}catch (Exception e) {
			log.info("error in deletePermission : "+e.getMessage());
		}
		finally{
			try{		
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deletePermission:\n"+sqle.getMessage());
			}
		}
	}
	
	/*For delete folder */
	@SuppressWarnings("resource")
	public static void deleteFolder(String uid,String refno,String token) {
		PreparedStatement ps = null;
		ResultSet rs=null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		int count=0;
		try{
			ps = con.prepareStatement("select dmuid from document_master where dmrefno='"+refno+"' and dmtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) status=true;
			ps = con.prepareStatement("select count(fid) from folder_master where frefid='"+refno+"' and ftokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next())count=rs.getInt(1);
			if(!status&&count==1){
			String query = "DELETE FROM folder_master WHERE fid='"+uid+"' and ftokenno='"+token+"'";
			ps = con.prepareStatement(query);
			ps.execute();
			}
			
		}catch (Exception e) {
			log.info("error in deleteFolder : "+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteFolder:\n"+sqle.getMessage());
			}
		}
	}
	/*For delete in manage seo jsp */
	public static boolean deleteSeo(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "DELETE FROM amonpage_seo WHERE amopsuid='"+uid+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("error in deleteSeo : "+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteSeo:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	/*For delete in manage-content jsp */
	public static boolean deleteContent(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "DELETE FROM content_seo WHERE wacuid='"+uid+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("error in deleteContent : "+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteContent:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	/*For getting the activity dynamically */
	public static String[][] getActivityByID() {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="Select atname,atvalue from hrmactivity_type";
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error Closing SQL Objects getActivityByID:\n"+e.getMessage());}
		finally{

			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	/*For saving content.jsp details */
	public static boolean saveContentDetail(String wacpuid,String wactuid, String wacactivity,String wacacontent,String wacastatus,String wacaddedby,String noofword) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into content_seo(wacpuid,wactuid, wacactivity,wacacontent,wacastatus,wacaddedby,noofword)values(?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);			
			ps.setString(1,wacpuid );
			ps.setString(2,wactuid );
			ps.setString(3,wacactivity );
			ps.setString(4,wacacontent );
			ps.setString(5,wacastatus );
			ps.setString(6,wacaddedby );
			ps.setString(7,noofword );
			ps.executeUpdate();
			status = true;
		}
		catch (Exception e) {
			log.info("Error Closing SQL Objects saveContentDetail:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}				
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveContentDetail\n"+sqle.getMessage());
			}
		}
		return status;
	}

	/*For manage-content jsp */
	public static String[][] getAllcontent(String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT pregpname,wacuid,wacactivity,wacastatus,wacaddedon FROM hrmproject_reg Join content_seo on hrmproject_reg.preguid = content_seo.wacpuid where pregtokenno='"+token+"' order by wacuid desc";
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error Closing SQL Objects getAllcontent:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllcontent\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	/*For  edit-content jsp */
	public static String[][] getContentByID(String uid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");

			String query="SELECT pregpname,wacpuid,wacactivity,wacacontent,wacastatus,noofword,wactuid FROM hrmproject_reg LEFT join content_seo on hrmproject_reg.preguid=content_seo.wacpuid where wacuid='"+uid+"' ";
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error Closing SQL Objects getContentByID:\n"+e.getMessage());}
		finally{

			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getContentByID\n"+sqle);
			}
		}
		return newsdata;
	}

	/*For update in edit-content jsp */
	public static boolean updateContentDetail(String uid,String wacactivity,String wacacontent,String wacastatus,String wacaddedby,String noofword) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE content_seo SET wacactivity=?,wacacontent=?,wacastatus=?,wacaddedby=?,noofword=? WHERE wacuid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,wacactivity );
			ps.setString(2,wacacontent );
			ps.setString(3,wacastatus );
			ps.setString(4,wacaddedby );
			ps.setString(5,noofword );
			ps.setString(6,uid );
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error Closing SQL Objects updateContentDetail:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateContentDetail:\n"+sqle);
			}
		}
		return status;
	}
/*For My task details if admin view all else by id */
	public static String[][] getAssignedProject(String loginuaid,String userroll,String token){
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;		
		
				VCQUERY=new StringBuffer("SELECT ptluid,pregpname,preguid FROM projecttask_list join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where exists(select atid from assignedtaskid where attaskno=projecttask_list.ptltuid and atassignedid='"+loginuaid+"') and pregtokenno='"+token+"' and ptlstatus!='Completed' ");
			
			VCQUERY.append(" order by ptluid desc ");
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error of get all project getAssignedProject()"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAssignedProject\n"+sqle);
			}
		}
		return newsdata;
	}
	/*For My task details if admin view all else by id */
	public static String[][] getAlltask(String loginuaid,String role, String limit, String projectname, String date, String tname, String ddate, String tstatus, String token, String from, String to) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			if(projectname==null || projectname.equalsIgnoreCase("null") || projectname.length() <= 0){ projectname ="NA";}
			if(date==null || date.equalsIgnoreCase("null") || date.length() <= 0){ date ="NA";}
			if(tname==null || tname.equalsIgnoreCase("null") || tname.length() <= 0){ tname ="NA";}
			if(ddate==null || ddate.equalsIgnoreCase("null") || ddate.length() <= 0){ ddate ="NA";}
			if(tstatus==null || tstatus.equalsIgnoreCase("null") || tstatus.length() <= 0){ tstatus ="NA";}
			if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			if (role.equals("Administrator")) {
				VCQUERY=new StringBuffer("SELECT ptluid,ptlname,pregpname,ptladate,ptlstatus,ptlddate,ptltuid,ptlpuid FROM projecttask_list join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where pregtokenno='"+token+"'");
			}
			else if(role.equalsIgnoreCase("super admin")){
				VCQUERY=new StringBuffer("SELECT ptluid,ptlname,pregpname,ptladate,ptlstatus,ptlddate,ptltuid,ptlpuid FROM projecttask_list join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where pregtokenno!='NA'");
			}
			else{
				VCQUERY=new StringBuffer("SELECT ptluid,ptlname,pregpname,ptladate,ptlstatus,ptlddate,ptltuid,ptlpuid FROM projecttask_list join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where exists(select atid from assignedtaskid where attaskno=projecttask_list.ptltuid and atassignedid='"+loginuaid+"') and pregtokenno='"+token+"' and ptlstatus!='Completed' ");
			}
			if(projectname!="NA")
			{
				VCQUERY.append(" and pregpname = '"+projectname+"'");
			}
			if(date!="NA")
			{
				VCQUERY.append(" and ptladate = '"+date+"'");
			}
			if(ddate!="NA")
			{
				VCQUERY.append(" and ptlddate = '"+ddate+"'");
			}
			if(tname!="NA")
			{
				VCQUERY.append(" and ptlname = '"+tname+"'");
			}
			if(tstatus!="NA")
			{
				VCQUERY.append(" and ptlstatus = '"+tstatus+"'");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and ptladdedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and ptladdedon between '"+from+"%' and '"+to+"%'");
			VCQUERY.append(" order by ptluid desc "+limit);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error of getAlltask for "+role+" = "+loginuaid+" : "+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAlltask\n"+sqle);
			}
		}
		return newsdata;
	}

	/*For My task details if admin view all else by id */
	public static String[][] getAlltask1(String loginuaid,String role, String limit, String projectname, String date, String tname, String ddate, String tstatus, String token, String from, String to) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			if(projectname==null || projectname.equalsIgnoreCase("Any") || projectname.length() <= 0){ projectname ="NA";}
			if(date==null || date.equalsIgnoreCase("Any") || date.length() <= 0){ date ="NA";}
			if(ddate==null || ddate.equalsIgnoreCase("Any") || ddate.length() <= 0){ ddate ="NA";}
			if(tname==null || tname.equalsIgnoreCase("Any") || tname.length() <= 0){ tname ="NA";}
			if(tstatus==null || tstatus.equalsIgnoreCase("Any") || tstatus.length() <= 0){ tstatus ="NA";}
			if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			if (role.equals("Administrator")) {
				VCQUERY=new StringBuffer("SELECT uaname FROM projecttask_list LEFT join user_account on projecttask_list.ptlby=user_account.uaid join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where pregtokenno='"+token+"'");
			}else
			{
				VCQUERY=new StringBuffer("SELECT uaname FROM projecttask_list LEFT join user_account on projecttask_list.ptlby=user_account.uaid join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where projecttask_list.ptlto='"+loginuaid+"' and pregtokenno='"+token+"' and ptlstatus!='Completed'");
			}
			if(projectname!="NA")
			{
				VCQUERY.append(" and pregpname = '"+projectname+"'");
			}
			if(date!="NA")
			{
				VCQUERY.append(" and ptladate = '"+date+"'");
			}
			if(ddate!="NA")
			{
				VCQUERY.append(" and ptlddate = '"+ddate+"'");
			}
			if(tname!="NA")
			{
				VCQUERY.append(" and ptlname = '"+tname+"'");
			}
			if(tstatus!="NA")
			{
				VCQUERY.append(" and ptlstatus = '"+tstatus+"'");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and ptladdedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and ptladdedon between '"+from+"%' and '"+to+"%'");
			VCQUERY.append(" order by ptluid desc "+limit);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error of get all project getAlltask1()"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAlltask1\n"+sqle);
			}
		}
		return newsdata;
	}

	/*For My task details if admin view all else by id */
	public static String[][] getAlltask2(String loginuaid,String role, String limit, String projectname, String date, String tname, String ddate, String tstatus, String token, String from, String to) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=null;
			if(projectname==null || projectname.equalsIgnoreCase("Any") || projectname.length() <= 0){ projectname ="NA";}
			if(date==null || date.equalsIgnoreCase("Any") || date.length() <= 0){ date ="NA";}
			if(ddate==null || ddate.equalsIgnoreCase("Any") || ddate.length() <= 0){ ddate ="NA";}
			if(tname==null || tname.equalsIgnoreCase("Any") || tname.length() <= 0){ tname ="NA";}
			if(tstatus==null || tstatus.equalsIgnoreCase("Any") || tstatus.length() <= 0){ tstatus ="NA";}
			if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			if(role.equals("Administrator")) {
				VCQUERY=new StringBuffer("SELECT uaname FROM projecttask_list LEFT join user_account on projecttask_list.ptlto=user_account.uaid join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where pregtokenno='"+token+"'");
			}
			else
			{
				VCQUERY=new StringBuffer("SELECT uaname FROM projecttask_list LEFT join user_account on projecttask_list.ptlto=user_account.uaid join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where projecttask_list.ptlto='"+loginuaid+"' and pregtokenno='"+token+"' and ptlstatus!='Completed'");

			}
			if(projectname!="NA")
			{
				VCQUERY.append(" and pregpname = '"+projectname+"'");
			}
			if(date!="NA")
			{
				VCQUERY.append(" and ptladate = '"+date+"'");
			}
			if(ddate!="NA")
			{
				VCQUERY.append(" and ptlddate = '"+ddate+"'");
			}
			if(tname!="NA")
			{
				VCQUERY.append(" and ptlname = '"+tname+"'");
			}
			if(tstatus!="NA")
			{
				VCQUERY.append(" and ptlstatus = '"+tstatus+"'");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and ptladdedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and ptladdedon between '"+from+"%' and '"+to+"%'");
			VCQUERY.append(" order by ptluid desc "+limit);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error of get all project getAlltask1()"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAlltask1\n"+sqle);
			}
		}
		return newsdata;
	}

	/*For displaying details on offpageseo jsp */
	public static String[][] getView(String amonpstuid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="select ptladate,ptlddate,ptlremark FROM projecttask_list where ptluid='"+amonpstuid+"'";
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error of get all project getView()"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getView:\n"+sqle);
			}
		}
		return newsdata;
	}

	/*For displaying details on content jsp */
	public static String[][] getView1(String amonpstuid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT ptladate,ptlddate,ptlremark FROM projecttask_list join amonpage_seo on projecttask_list.ptluid =amonpage_seo.amonpstuid where amonpstuid='"+amonpstuid+"'";
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error of get all project getView1()"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getView1\n"+sqle);
			}
		}
		return newsdata;
	}

	/*For  displaying content on seo jsp */
	public static String[][] getContentByTaskID(String taskid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="select wacacontent from content_seo where wactuid = '"+ taskid +"';";
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
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("error of get all project getContentByTaskID()"+e.getMessage());}
		finally{

			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getContentByTaskID\n"+sqle);
			}
		}
		return newsdata;
	}

	@SuppressWarnings("resource")
	public static boolean saveProjectStatus(String ptstid, String ptsremarks, String ptsstatus, String ptsaddedby,String mid,String token,String preguid,String loginname,String deliverydate,String showclient,String taskname,String imgname,String key) {
		PreparedStatement ps = null;
		boolean status = false;
		String query =null;
		Connection con = DbCon.getCon("","","");
		try{		
			DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
			Calendar calobj = Calendar.getInstance();
			String today = df.format(calobj.getTime());
			
			query = "insert into hrmproject_followup (pfupid,pfustatus,pfudate,pfuremark,pfuaddedby,followupby,deliverydate,showclient,pftokenno,pffromstatus,pfimgurl,pfmsgfor,pftaskname,ptstid,pts_taskid,pfuuserrefid) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);			
			ps.setString(1,preguid );
			ps.setString(2,ptsstatus );
			ps.setString(3,today );
			ps.setString(4,ptsremarks );
			ps.setString(5,ptsaddedby );
			ps.setString(6,loginname );
			ps.setString(7,deliverydate );
			ps.setString(8,showclient );
			ps.setString(9,token );
			ps.setString(10,"task" );
			ps.setString(11,imgname );
			ps.setString(12,"NA" );
			ps.setString(13,taskname );			
			ps.setString(14,ptstid );			
			ps.setString(15,mid );
			ps.setString(16,key );
			
			ps.execute();
			ps = con.prepareStatement("update assigntask set ataskstatus=? where ataskid=? and amilestoneid=? and atokenno=?");
			ps.setString(1,ptsstatus );
			ps.setString(2,ptstid );
			ps.setString(3,mid );
			ps.setString(4,token );
			ps.execute();
			status = true;
		}
		catch (Exception e) {
			log.info("error of get all project getContentByTaskID()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveProjectStatus\n"+sqle);
			}
		}
		return status;
	}
	@SuppressWarnings("resource")
	public static void updateTaskDeliveryDate(String ptstid, String date,String token) {
		PreparedStatement ps = null;
		ResultSet rs=null;
		String tdate=null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "select ptlddate from projecttask_list where ptluid = '"+ptstid+"' and ptltokenno='"+token+"'";
			ps = con.prepareStatement(query);
			rs=ps.executeQuery();
			if(rs.next()) tdate=rs.getString(1);
			String x[]=tdate.split(" ");
			String y[]=x[0].split("-");
			int tdd=Integer.parseInt(y[0]);
			int tmm=Integer.parseInt(y[1]);
			int tyy=Integer.parseInt(y[2]);
			
			String a[]=date.split(" ");
			String b[]=a[0].split("-");
			int ddd=Integer.parseInt(b[0]);
			int dmm=Integer.parseInt(b[1]);
			int dyy=Integer.parseInt(b[2]);
			int flag=0;
			if(dyy>tyy){
				flag=1;
			}else if(dyy==tyy&&dmm>tmm){
			flag=1;	
			}else if(dyy==tyy&&dmm==tmm&&ddd>tdd){
				flag=1;
			}
			if(flag==1){
				ps = con.prepareStatement("update projecttask_list set ptlddate=? where ptluid = ? and ptltokenno=?");
				ps.setString(1,date );
				ps.setString(2,ptstid );
				ps.setString(3,token );
				ps.execute();				
			}
			
		}
		catch (Exception e) {
			log.info("error of get all project updateTaskDeliveryDate()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTaskDeliveryDate\n"+sqle);
			}
		}		
	}
	@SuppressWarnings("resource")
	public static void updateProjectTaskStatus(String ptstid,String token) {
		PreparedStatement ps = null;
		ResultSet rs=null;
		boolean flag=false;
		Connection con = DbCon.getCon("","","");
		try{
			ps = con.prepareStatement("select ataskstatus from assigntask where ataskid='"+ptstid+"' and atokenno='"+token+"'");
			rs=ps.executeQuery();
			while(rs.next())
			{
				if(!rs.getString(1).equalsIgnoreCase("Completed")){
					flag=true;
					break;
				}
			}
			if(!flag){
			String query = "update projecttask_list set ptlstatus ='Completed' where ptluid =? and ptltokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,ptstid );
			ps.setString(2,token );
			ps.execute();
			}
		}
		catch (Exception e) {
			log.info("error of get all project updateProjectTaskStatus()"+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProjectTaskStatus\n"+sqle);
			}
		}
	}
	public static boolean updateProjectStatusList(String ptstid, String ptsstatus,String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update projecttask_list set ptlstatus =? where ptluid = ? and ptltokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,ptsstatus );
			ps.setString(2,ptstid );
			ps.setString(3,token );
			ps.executeUpdate();
			status = true;
		}
		catch (Exception e) {
			log.info("error of get all project updateProjectStatusList()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProjectStatusList:\n"+sqle);
			}
		}
		return status;
	}

	@SuppressWarnings("resource")
	public static void saveNewSEOURL(String newurl, String amonpstatype, String websitenature, String urlstatus, String amonpsaddedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		ResultSet rs = null;
		int sucid = 0;
		try{
			String sql = "select sucid from seourlcollection where sucsubmiturl = '"+newurl+"' and sucstatus='1'";
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()) sucid = rs.getInt(1);
			if(sucid==0) {
				String query = "insert into seourlcollection (sucsubmiturl, sucactivity, sucnature, sucurlstatus, sucstatus, sucaddedby) values (?,?,?,?,?,?)";
				ps = con.prepareStatement(query);			
				ps.setString(1,newurl );
				ps.setString(2,amonpstatype );
				ps.setString(3,websitenature );
				ps.setString(4,urlstatus );
				ps.setString(5,"1" );
				ps.setString(6,amonpsaddedby );
				ps.executeUpdate();
			}
		}
		catch (Exception e) {
			log.info("error of get all project saveNewSEOURL()"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) rs.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveNewSEOURL:\n"+sqle);
			}
		}
	}

}
