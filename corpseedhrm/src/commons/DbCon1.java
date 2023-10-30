package commons;
import java.sql.Connection;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DbCon1{
	private static HikariDataSource dataSource;
	private static Connection con=null;
	private static Logger log = Logger.getLogger(DbCon.class);
public static HikariDataSource getConnection() {
	try {
	HikariConfig config = new HikariConfig();
    // This property is optional now 
    config.setDriverClassName("com.mysql.cj.jdbc.Driver");
//    config.setJdbcUrl("jdbc:mysql://corpseedweb.mysql.database.azure.com:3306/corpseedhrmdmng?useSSL=true");
//    config.setUsername("corpseedweb");
//    config.setPassword("Corp@418K#");
      config.setJdbcUrl("jdbc:mysql://localhost/corpseedhrmdmng?useSSL=false");
      config.setUsername("root");
      config.setPassword("root");
    
    config.setMaximumPoolSize(20);
    //add new config start
    config.setMinimumIdle(1);
    config.setIdleTimeout(10000);
    config.setMaxLifetime(60000);
    //stop
    config.addDataSourceProperty("cachePrepStmts", "true");
    config.addDataSourceProperty("prepStmtCacheSize", "250");
    config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
    // Create DataSource
    dataSource=new HikariDataSource(config);    
    return dataSource;
	}catch (Exception e) {
		log.info("Connection error:-"+e.getMessage());
		e.printStackTrace();
		return null;
	}
}
public static Connection getCon(String dsn, String user1, String pwd) {
	if(con==null) {
		if(dataSource==null)
			dataSource=getConnection();
		else
			try {
				con=dataSource.getConnection();
			} catch (SQLException e) {
				log.info("Connection error:-"+e.getMessage());
				e.printStackTrace();
			}
	return con;	
	}else {
		return con;
	}
	
}

}

//public class DbCon{
//  private static Connection con=null;
//  private static DataSource dataSource;
//  
//  public static Connection getCon(String dsn, String user1, String pwd) {
//  try {
//    if(dataSource==null) {
//    
//    HikariConfig hikariConfig = new HikariConfig();
//    hikariConfig.setJdbcUrl("jdbc:mysql://corpseedweb.mysql.database.azure.com:3306/corpseed_hrm_test?useSSL=true&serverTimezone=IST");
//    hikariConfig.setUsername("Ajay");
//    hikariConfig.setPassword("corp@123");
//    hikariConfig.setDriverClassName("com.mysql.cj.jdbc.Driver");
//    hikariConfig.setPoolName("MysqlPool-1");
//    hikariConfig.setMaximumPoolSize(10);
//    
//    hikariConfig.setConnectionTimeout(Duration.ofSeconds(30).toMillis());
//    hikariConfig.setIdleTimeout(Duration.ofMinutes(2).toMillis());
//    HikariDataSource hikariDataSource = new HikariDataSource(hikariConfig);
//    dataSource = hikariDataSource;
//    con=dataSource.getConnection();
//    }else {
//      con=dataSource.getConnection();
//    }
//  } catch (Exception e) {
//    e.printStackTrace();
//  }
////  System.out.println("datasource=="+datasource);
//  return con; 
//} 
//}

//public class DbCon{
//
////	jdbc:mysql://corpseedweb.mysql.database.azure.com:3306/corpseed_hrm_test
////	jdbc:mysql://localhost/corpseedhrmdmng
//////corpseedhrmdmng corpseedweb Corp@418K#
//////corpseed_hrm_test Ajay corp@123
//	private static HikariDataSource datasource;
//    public static Connection getCon(String dsn, String user, String pwd) {
//    	if(datasource == null)
//        {
//    		try {
//		    	datasource = new HikariDataSource();
//		    	datasource.setDriverClassName("com.mysql.cj.jdbc.Driver");         
//		    	datasource.setJdbcUrl("jdbc:mysql://corpseedweb.mysql.database.azure.com:3306/corpseedhrmdmng?useSSL=true&serverTimezone=IST");
//		    	datasource.setUsername("corpseedweb");
//		    	datasource.setPassword("Corp@418K#");
//		
////		    	datasource.setJdbcUrl("jdbc:mysql://localhost/corpseedhrmdmng?useSSL=false&serverTimezone=IST");
////		    	datasource.setUsername("root");
////		    	datasource.setPassword("root");
//		    	
//		    	datasource.setConnectionTimeout(30000);
//		    	datasource.setIdleTimeout(30000);
//		    	datasource.setMaxLifetime(60000);
//		    	datasource.setMinimumIdle(5);
//		    	datasource.setMaximumPoolSize(20);
//		    	datasource.setLeakDetectionThreshold(30000);
//		    	datasource.setLoginTimeout(3);
//		    	datasource.setAutoCommit(true);
//		    	datasource.addDataSourceProperty("cachePrepStmts", "true");
//		    	datasource.addDataSourceProperty("prepStmtCacheSize", "250");
//		    	datasource.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
//		    	datasource.addDataSourceProperty("useServerPrepStmts", "true");
//		    	datasource.addDataSourceProperty("useLocalSessionState", "true");
//		    	datasource.addDataSourceProperty("rewriteBatchedStatements", "true");
//		    	datasource.addDataSourceProperty("cacheResultSetMetadata", "true");
//		    	datasource.addDataSourceProperty("cacheServerConfiguration", "true");
//		    	datasource.addDataSourceProperty("elideSetAutoCommits", "true");
//		    	datasource.addDataSourceProperty("maintainTimeStats", "false");
//		    	
//    		}catch(IOException | SQLException e) {
//    			e.printStackTrace();
//    		}
//        }
//        try {
//			return datasource.getConnection();
//		} catch (SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//			return null;
//		}
//    }
//}
