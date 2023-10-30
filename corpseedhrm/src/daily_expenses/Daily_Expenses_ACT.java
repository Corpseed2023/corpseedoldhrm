package daily_expenses;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;
import company_master.CompanyMaster_ACT;

public class Daily_Expenses_ACT {
	
	private static Logger log = Logger.getLogger(CompanyMaster_ACT.class);
	
//updating daily expenses													
public static boolean updateDailyExpenses(String Amount,String PaidTo, String ExpensesCategory,String Description, String PaymentMode, String ApprovedBy, String PaidDate, String addeduser, String token, String invoiceno, String place, String servicecode, String gstcategory, String gsttax, String gstvalue, String totalinvoiceamount, String gst,String custid) {
	boolean status = false;
	PreparedStatement ps = null;
	Connection con = DbCon.getCon("","","");
	try{
		String query = "update daily_expenses_master set demamount='"+Amount+"', dempaidto='"+PaidTo+"', dexpensescategory='"+ExpensesCategory+"', demdescription='"+Description+"', dempaymentmode='"+PaymentMode+"', demapprovedby='"+ApprovedBy+"', dempaiddate='"+PaidDate+"',deminvoiceno='"+invoiceno+"', demplace='"+place+"', demservicecode='"+servicecode+"', demgstcategory='"+gstcategory+"', demgsttax='"+gsttax+"', demgstvalue='"+gstvalue+"', demtotalinvoiceamount='"+totalinvoiceamount+"', demgst='"+gst+"' where detokenno='"+token+"' and demuid='"+custid+"'";
		ps = con.prepareStatement(query);
		int k=ps.executeUpdate();
		if(k>0)
		status = true;
	}catch (Exception e) {
		log.info("updateDailyExpenses"+e.getMessage());
	}
	finally{
		try{
			if(ps!=null) {ps.close();}
			if(con!=null) {con.close();}
		}catch(SQLException sqle){
			log.info("updateDailyExpenses"+sqle.getMessage());
		}
	}
	return status;
}
//deleting daily expenses 
public static void deleteExpense(String id) {
	PreparedStatement ps = null;
	Connection con = DbCon.getCon("","","");
	try{
		String query = "delete from daily_expenses_master where demuid='"+id+"'";
		ps = con.prepareStatement(query);
		ps.executeUpdate();
				
	}catch (Exception e) {
		log.info("deleteExpense"+e.getMessage());
	}
	finally{
		try{
			if(ps!=null) {ps.close();}
			if(con!=null) {con.close();}
		}catch(SQLException sqle){
			log.info("deleteExpense"+sqle.getMessage());
		}
	}

}
	//inserting daily expenses
	public static boolean saveDailyExpenses(String Amount,String PaidTo, String ExpensesCategory,String Description, String PaymentMode, String ApprovedBy, String PaidDate, String addeduser, String token, String invoiceno, String place, String servicecode, String gstcategory, String gsttax, String gstvalue, String totalinvoiceamount, String gst) {
		boolean status = false;
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "INSERT INTO daily_expenses_master(demamount, dempaidto, dexpensescategory, demdescription, dempaymentmode, demapprovedby, dempaiddate, demaddedby, detokenno, deminvoiceno, demplace, demservicecode, demgstcategory, demgsttax, demgstvalue, demtotalinvoiceamount, demgst) VALUES ('"+Amount+"','"+PaidTo+"','"+ExpensesCategory+"','"+Description+"','"+PaymentMode+"','"+ApprovedBy+"','"+PaidDate+"','"+addeduser+"','"+token+"','"+invoiceno+"','"+place+"','"+servicecode+"','"+gstcategory+"','"+gsttax+"','"+gstvalue+"','"+totalinvoiceamount+"','"+gst+"')";
			ps = con.prepareStatement(query);
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}catch (Exception e) {
			log.info("saveDailyExpenses"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("saveDailyExpenses"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getallExpensesById(String id,String token)
	{
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		Connection con = DbCon.getCon("","","");
		try {
			
			VCQUERY=new StringBuffer("SELECT * FROM daily_expenses_master WHERE demuid='"+id+"' and detokenno='"+token+"' ");
			
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
			log.info("getallExpensesById"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("getallExpensesById"+e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getallExpensesdata(String date, String month, String monthdate, String token, String to, String gst)
	{
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		Connection con = DbCon.getCon("","","");
		try {
			if(date==null || date.equalsIgnoreCase("Any") || date.length() <= 0){ date ="NA";}
			if(month==null || month.equalsIgnoreCase("Any") || month.length() <= 0){ month ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			if(gst==null || gst.equalsIgnoreCase("Any") || gst.length() <= 0){ gst ="NA";}
			VCQUERY=new StringBuffer("SELECT demuid, demamount, dempaidto, dexpensescategory, demdescription, dempaymentmode, demapprovedby, dempaiddate, demaddedby, demstatus, demgst FROM daily_expenses_master WHERE demstatus='1' and detokenno='"+token+"' ");
			if(date!="NA"&&to=="NA")
			{
				VCQUERY.append(" and dempaiddate = '"+date+"'");
			}
			if(date!="NA"&&to!="NA") {
				VCQUERY.append(" and str_to_date(dempaiddate,'%d-%m-%y') between str_to_date('"+date+"','%d-%m-%y') and str_to_date('"+to+"','%d-%m-%y')");
			}
			if(month!="NA")
			{
				VCQUERY.append(" and dempaiddate like '%"+month+"'");
			}
			if(gst!="NA")
			{
				VCQUERY.append(" and demgst = '"+gst+"'");
			}
			if(month=="NA"&&date=="NA"&&to=="NA")
			{
				VCQUERY.append(" and demaddedon like '"+monthdate+"%'");
			}
			VCQUERY.append(" ORDER BY demuid DESC");
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
			log.info("getallExpensesdata"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("getallExpensesdata"+e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllEmployee() {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		StringBuffer VCQUERY=null;
		String[][] newsdata = null;
		try {
			getacces_con=DbCon.getCon("","","");
			VCQUERY=new StringBuffer("SELECT ualoginid,uaname FROM user_account WHERE uastatus='1' ");
			String query=VCQUERY.toString();
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
		{log.info("getAllEmployee"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				log.info("getAllEmployee"+sqle.getMessage());
			}
		}
		return newsdata;
	}
}