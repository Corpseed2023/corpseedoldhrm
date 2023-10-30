package logger;

import org.apache.log4j.Logger;

import commons.DateUtil;


public class CommonLog {

	private static Logger log = Logger.getLogger(CommonLog.class);

	public static void comLog(String jspPage){

		log.info(jspPage+" Called on "+DateUtil.getCurrentDateIndianFormat()+" at "+DateUtil.getCurrentTime());
	}

	public static void perfectLog(String logdetail)
	{
		String fulllog=null;
		try
		{
			throw new Exception();
		} catch( Exception e )
		{
			fulllog="-------> Method '"+e.getStackTrace()[1].getMethodName()+"()' of class '"+e.getStackTrace()[1].getClassName()+"' having following error -------> "+logdetail;
		}
		log.info(fulllog);
	}


}
