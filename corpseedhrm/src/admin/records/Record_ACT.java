package admin.records;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import admin.enquiry.Enquiry_ACT;
import commons.DbCon;

public class Record_ACT {
	private static Logger log = Logger.getLogger(Enquiry_ACT.class);

	public static String[][] getAllExportedRecords(String page,String token,String dateRange,int pageNo,int rows,String sort,String order) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
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
			StringBuffer VCQUERY=new StringBuffer("SELECT * FROM download_export_history where token= '"+token+"' and type='Exported'");
			
			if(page!=null&&!page.equalsIgnoreCase("All"))VCQUERY.append(" and page='"+page+"'");
			
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and date<='"+toDate+"' and date>='"+fromDate+"'");
			}
			if(sort.length()<=0)			
				VCQUERY.append("order by id desc limit "+((pageNo-1)*rows)+","+rows);
				else if(sort.equals("id"))VCQUERY.append("order by id "+order+" limit "+((pageNo-1)*rows)+","+rows);
				else if(sort.equals("date"))VCQUERY.append("order by date "+order+" limit "+((pageNo-1)*rows)+","+rows);
				else if(sort.equals("from_to"))VCQUERY.append("order by export_from_to "+order+" limit "+((pageNo-1)*rows)+","+rows);
				
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
		{log.info("Error in Record_ACT.getAllExportedRecords method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects Record_ACT.getAllExportedRecords:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static int countAllExportedRecords(String page,String token,String dateRange) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
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
			StringBuffer VCQUERY=new StringBuffer("SELECT count(id) FROM download_export_history where token= '"+token+"' and type='Exported'");
			
			if(page!=null&&!page.equalsIgnoreCase("All"))VCQUERY.append(" and page='"+page+"'");
			
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and date<='"+toDate+"' and date>='"+fromDate+"'");
			}
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			
			if(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{log.info("Error in Record_ACT.countAllExportedRecords method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects Record_ACT.countAllExportedRecords:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] getAllRecords(String page,String token,String dateRange,int pageNo,int rows,String sort,String order) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
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
			StringBuffer VCQUERY=new StringBuffer("SELECT * FROM download_export_history where token= '"+token+"' and type='Invoice download'");
			
			if(page!=null&&!page.equalsIgnoreCase("All"))VCQUERY.append(" and page='"+page+"'");
			
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and date<='"+toDate+"' and date>='"+fromDate+"'");
			}
			if(sort.length()<=0)			
				VCQUERY.append("order by id desc limit "+((pageNo-1)*rows)+","+rows);
				else if(sort.equals("id"))VCQUERY.append("order by id "+order+" limit "+((pageNo-1)*rows)+","+rows);
				else if(sort.equals("date"))VCQUERY.append("order by date "+order+" limit "+((pageNo-1)*rows)+","+rows);
				else if(sort.equals("invoice"))VCQUERY.append("order by invoice "+order+" limit "+((pageNo-1)*rows)+","+rows);
					
				
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
		{log.info("Error in Record_ACT.getAllRecords method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects Record_ACT.getAllRecords:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static int countAllRecords(String page,String token,String dateRange) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
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
			StringBuffer VCQUERY=new StringBuffer("SELECT count(id) FROM download_export_history where token= '"+token+"' and type='Invoice download'");
			
			if(page!=null&&!page.equalsIgnoreCase("All"))VCQUERY.append(" and page='"+page+"'");
			
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and date<='"+toDate+"' and date>='"+fromDate+"'");
			}
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			
			if(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{log.info("Error in Record_ACT.countAllRecords method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects Record_ACT.countAllRecords:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
}
