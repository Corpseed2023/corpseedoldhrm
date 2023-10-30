package admin.master;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import commons.DbCon;
public class Viewuserdetails_ACT
{
	private static Logger log = Logger.getLogger(LoginAction.class);
	
public static String[][] getnews(String tokenid)
{
PreparedStatement ps = null;
ResultSet rsGCD=null;
Connection con = DbCon.getCon("","","");
String[][] newsdata = null;
try{
	String query="select distinct uaid,	uacid,ualoginid,uaname,uapass,uastatus,	uamobileno,uaemailid,uadistrict,ualocation from user_account where uavalidtokenno = '"+tokenid+"' ";	
ps=con.prepareStatement(query);
rsGCD=ps.executeQuery();
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
{log.info("Error in getnews() method \n"+e.getMessage());}
finally{
try{
if(ps!=null) {ps.close();}
if(rsGCD!=null) {rsGCD.close();}
if(con!=null) {con.close();}
}catch(SQLException sqle){
	log.info("Error in getnews() method \n"+sqle.getMessage());
}
}
return newsdata;
}

public static String[][] getuserprofile(String loginid,String token)
{
PreparedStatement ps = null;
ResultSet rsGCD=null;
Connection con = DbCon.getCon("","","");
String[][] newsdata = null;
try{
String query="select uaid, uaempid, uaname, uamobileno, uaemailid, uastate, uacity, uacurrentadd, uapermanentadd, uajoiningdate from user_account where ualoginid='"+loginid+"' and uavalidtokenno='"+token+"'";
ps=con.prepareStatement(query);
rsGCD=ps.executeQuery();
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
{log.info("Error in getuserprofile() method \n"+e.getMessage());}
finally{
try{
if(ps!=null) {ps.close();}
if(rsGCD!=null) {rsGCD.close();}
if(con!=null) {con.close();}

}catch(SQLException sqle){
	log.info("Error in getuserprofile() method \n"+sqle.getMessage());
}
}
return newsdata;
}
}
