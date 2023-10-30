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
public class GetDeliveryDate extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			boolean result=false;
			String deliveryDate="";
			PrintWriter p=response.getWriter();
			try{
			String token=(String)session.getAttribute("uavalidtokenno");
			String str_date=request.getParameter("date").trim();
			String pname=request.getParameter("pname").trim();
			String buldingtime=request.getParameter("btime").trim();
			String delivery_time="0:0:0:0";
			
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		    Calendar c1 = Calendar.getInstance();
		    
		    if(buldingtime.equalsIgnoreCase("NA"))	{	    	
		    delivery_time=TaskMaster_ACT.getTotalTime(pname,token);
		    } else{		    	
		    	delivery_time=request.getParameter("buildingtime").trim();
		    }
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
		    }else{
		    	result=true;
		    }
		    
			}catch(Exception e){
				e.printStackTrace();
			}		    
		    
			if(result) {
				p.write("pass");
			}else
				p.write(deliveryDate);
			
			
		}

		catch (Exception e) {
			
		}

	}

}