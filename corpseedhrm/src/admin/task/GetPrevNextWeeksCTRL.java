package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetPrevNextWeeksCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			request.getSession();
			
			String deliveryDate="";
			PrintWriter pw=response.getWriter();			
//				start
			String action=request.getParameter("data").trim();
			String currentDate=request.getParameter("currentDate").trim();		
			
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			int pyear=0;
			int pmonth=0;
			int pdays=0;
			int nyear=0;
			int nmonth=0;
			int ndays=0;
			
		    Calendar c1 = Calendar.getInstance();
		    if(action.equalsIgnoreCase("prev")){
			  	pyear=Integer.parseInt(currentDate.substring(6, 10));
	//		  	System.out.println("year="+year);
			  	pmonth=Integer.parseInt(currentDate.substring(3, 5));
	//		  	System.out.println("month="+month);
			  	pdays=Integer.parseInt(currentDate.substring(0, 2));
			  	pdays+=-6;
		    }else if(action.equalsIgnoreCase("next")){		
			  	nyear=Integer.parseInt(currentDate.substring(19));
	//		  	System.out.println("year="+year);
			  	nmonth=Integer.parseInt(currentDate.substring(16, 18));
	//		  	System.out.println("month="+month);
			  	ndays=Integer.parseInt(currentDate.substring(13, 15));
			  	ndays+=+6;
		    }
		    
//			end
		    if(action.equalsIgnoreCase("prev")){
//			  	System.out.println("days="+days);
			    c1.set(pyear, (pmonth)-1 , (pdays)); 		    
			    deliveryDate=sdf.format(c1.getTime());
		    	deliveryDate+=" - "+currentDate.substring(0,10);
		    }else if(action.equalsIgnoreCase("next")){	
		    	c1.set(nyear, (nmonth)-1 , (ndays)); 		    
			    deliveryDate=sdf.format(c1.getTime());
		    	deliveryDate=currentDate.substring(13)+" - "+deliveryDate;
		    }
		    
		pw.write(deliveryDate);		
		HttpSession session=request.getSession();
		
		session.setAttribute("date_range_value", deliveryDate);
		   
		}catch (Exception e) {
			e.printStackTrace();
		}
		}
}