package commons;
import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.SQLException;

import javax.sql.DataSource;

import org.apache.log4j.Logger;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
public class DbCon{
  private static Connection con=null;
  private static DataSource datasource;
  private static Logger log = Logger.getLogger(DbCon.class);
  public static Connection getCon(String dsn, String user1, String pwd) {
  try {
    if(datasource==null) {
    
      HikariConfig config = new HikariConfig();
      config.setDriverClassName("com.mysql.cj.jdbc.Driver");

//      corpseedhrmdmng corpseedweb Corp@418K#
//      corpseed_hrm_test Ajay corp@123
//      
//      config.setJdbcUrl("jdbc:mysql://corpseedweb.mysql.database.azure.com:3306/corpseedhrmdmng?useSSL=true");
//      config.setUsername("corpseedweb");
//      config.setPassword("Corp@418K#");
      
      config.setJdbcUrl("jdbc:mysql://localhost/corpseedcrm?useSSL=false");//corpseedhrmdmng
      config.setUsername("root");
	  config.setPassword("root");
      
      config.setConnectionTimeout(30000);
      config.setMinimumIdle(10);
      config.setMaximumPoolSize(150);
      config.setIdleTimeout(300000);
      
      config.addDataSourceProperty("cachePrepStmts", "true");
      config.addDataSourceProperty("prepStmtCacheSize", "250");
      config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            
      datasource=new HikariDataSource(config);
      
    }      
    con=datasource.getConnection();    
  } catch (Exception e) {
	  log.info("Connection error:-"+e.getMessage());
    e.printStackTrace();
  }
//  System.out.println("datasource=="+datasource); 
  return con; 
} 
}

//public class DbCon{
//  static {
//    try {
//      Class.forName("com.mysql.cj.jdbc.Driver");
//    } catch (Exception e) {
//
//    }
//  }
//
//  public static Connection getCon(String dsn, String user, String pwd) {
//
//    Connection con = null;
//
//    String ipAdrs = "localhost";
//    String dbName = "corpseedhrmdmng";
//    user = "root";
//    pwd = "root";
//    
//    String url = "jdbc:mysql://" + ipAdrs + "/" + dbName + "?user=" + user + "&password=" + pwd+"&useSSL=false";
//
//    try {
//
//      con = DriverManager.getConnection(url);
//
//    } catch (SQLException sqle) {
//      sqle.printStackTrace();
//    }
//
//    return con;
//
//  }
//
//}
