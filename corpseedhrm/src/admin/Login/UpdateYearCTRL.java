package admin.Login;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class UpdateYearCTRL extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		String uacompany = (String) session.getAttribute("uacompany");

		String[][] initials = LoginAction.getInitialDetails(uacompany);

		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		String today = sdf.format(cal.getTime());

		for(int i=0;i<initials.length;i++) {
			String test = initials[i][3];
			int year = Integer.parseInt(test.substring(Math.max(test.length() - 2, 0)));
			int nextyear = year+1;
			test = test.replace(Integer.toString(year), Integer.toString(nextyear));
			LoginAction.updateInitial(initials[i][0], test, today);
		}

		RequestDispatcher disp = request.getRequestDispatcher("/dashboard.html");
		disp.forward(request, response);
	}
}