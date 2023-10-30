package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;

public class GetClientSuperUser_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			PrintWriter pw=response.getWriter();
			HttpSession session =request.getSession();
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String selectedId=request.getParameter("selectedId");
			if(selectedId==null||selectedId.equalsIgnoreCase("NA")||selectedId.length()<=0)selectedId="NA";
			
//			System.out.println("selected id==="+selectedId);
			
			String data="";
			
			String superUsers[][]=Usermaster_ACT.findAllClientSuperUser(token); 
			if(superUsers!=null&&superUsers.length>0) {
				data+="<option value=''>Select Super User</option>";
				
				for(int i=0;i<superUsers.length;i++) {
					String selected=" selected='selected'";
					if(!superUsers[i][0].equalsIgnoreCase(selectedId))selected="";
					data+="<option value='"+superUsers[i][0]+"'"+selected+">"+superUsers[i][1]+" : "+superUsers[i][2]+" / "+superUsers[i][3]+"</option>";
				}
			}
									
		pw.write(data);
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}