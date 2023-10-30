package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang.RandomStringUtils;
import commons.DateUtil;


@SuppressWarnings("serial")
public class AddNewTeam_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		
		String deptname = request.getParameter("deptname").trim();
		String teamname = request.getParameter("teamname").trim();
		String leadername = request.getParameter("leadername").trim();
		String leadercode = request.getParameter("leadercode").trim();
		String leaderid = request.getParameter("leaderid").trim();
		
		String teamkey=RandomStringUtils.random(40,true,true);
		String date=DateUtil.getCurrentDateIndianFormat1();
		
		boolean flag=TaskMaster_ACT.createNewTeam(teamkey,deptname,teamname,leadername,leadercode,leaderid,date,uavalidtokenno,loginuID);		
		
		if(flag){
			String members[][]=TaskMaster_ACT.getAllTeamMember(uavalidtokenno,loginuID);
			if(members!=null&&members.length>0){
				for(int i=0;i<members.length;i++){
					String memkey=RandomStringUtils.random(40,true,true);
					flag=TaskMaster_ACT.saveTeamMember(teamkey,memkey,members[i][0],members[i][1],members[i][2],members[i][3],uavalidtokenno,loginuID);
				}
			}
		}
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}