package employee_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class RegisterNewEmployee_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			boolean status = false;
			HttpSession session = request.getSession();

			String emuid = request.getParameter("EmployeeID").trim();
			String emprefix = request.getParameter("EmployeePrefix").trim();
			String emname = request.getParameter("EmployeeName").trim();
			String emdept = request.getParameter("EmployeeDepartment").trim();
			String emdesig = request.getParameter("EmployeeDesignation").trim();
			String emmobile = request.getParameter("EmployeeMobile").trim();
			String ememail = request.getParameter("EmployeeEmail").trim();
			String emaltmobile = request.getParameter("EmployeeAlternateMobile").trim();
			String emaltemail = request.getParameter("EmployeeAlternateEmail").trim();
			String emperaddress = request.getParameter("EmployeePermanentAddress").trim();
			String empreaddress = request.getParameter("EmployeePresentAddress").trim();
			String empan = request.getParameter("PAN").trim();
			String emaadhar = request.getParameter("Aadhar").trim();
			String embankname = request.getParameter("BankName").trim();
			String embankaccname = request.getParameter("AccountName").trim();
			String embankaccno = request.getParameter("BankACNo").trim();
			String embankifsc = request.getParameter("BankIFSCCode").trim();
			String embankaddress = request.getParameter("BankAddress").trim();
			String ememname = request.getParameter("EmergencyContactEmployeeName").trim();
			String ememmobile = request.getParameter("EmergencyContactEmployeeMobile").trim();
			String emememail = request.getParameter("EmergencyContactEmployeeEmail").trim();
			String ememrelation = request.getParameter("relation").trim();
			String emgender = request.getParameter("Gender").trim();
			String emdateofbirth = request.getParameter("DateOfBirth").trim();
			String DateOfJoining = request.getParameter("DateOfJoining").trim();
			String emmarriage = request.getParameter("DateofAnniversary").trim();
			String emaddedby = request.getParameter("addeduser").trim();
			String token= (String)session.getAttribute("uavalidtokenno");

			status = Employee_ACT.saveEmployee(emuid, emprefix, emname, emdept, emdesig, emmobile, ememail, emgender,
					emaltmobile, emaltemail, emdateofbirth, emmarriage, ememname, ememmobile, emememail, ememrelation,
					emperaddress, empreaddress, empan, emaadhar, embankname,embankaccname, embankaccno, embankifsc, embankaddress,
					emaddedby,token,DateOfJoining);
			Employee_ACT.openAccount(emuid, emname, emaddedby,token);
			if (status) {
//				session.setAttribute("ErrorMessage","Employee " + emprefix + " " + emname + " is Successfully registered!");
				response.sendRedirect(request.getContextPath() + "/manage-employee.html");
			} else {
				session.setAttribute("ErrorMessage",
						"Employee " + emprefix + " " + emname + " is not registered!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}