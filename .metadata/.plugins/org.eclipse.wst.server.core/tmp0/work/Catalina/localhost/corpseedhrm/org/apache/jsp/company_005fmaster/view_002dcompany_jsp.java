/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/9.0.76
 * Generated at: 2023-09-22 13:56:49 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.company_005fmaster;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import admin.Login.LoginAction;
import company_master.CompanyMaster_ACT;

public final class view_002dcompany_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(3);
    _jspx_dependants.put("/company_master/../staticresources/includes/itswsscripts.jsp", Long.valueOf(1637404914000L));
    _jspx_dependants.put("/company_master/../staticresources/includes/itswsstyles.jsp", Long.valueOf(1637404914000L));
    _jspx_dependants.put("/company_master/../../madministrator/checkvalid_user.jsp", Long.valueOf(1648627112000L));
  }

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = new java.util.HashSet<>();
    _jspx_imports_classes.add("company_master.CompanyMaster_ACT");
    _jspx_imports_classes.add("admin.Login.LoginAction");
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
      throws java.io.IOException, javax.servlet.ServletException {

    if (!javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      final java.lang.String _jspx_method = request.getMethod();
      if ("OPTIONS".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        return;
      }
      if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET, POST or HEAD. Jasper also permits OPTIONS");
        return;
      }
    }

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("<!DOCTYPE HTML>\r\n");
      out.write('\r');
      out.write('\n');

response.addHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.addHeader("Cache-Control", "pre-check=0, post-check=0");
response.setDateHeader("Expires", 0);

String uavalidtokenno1111= (String)session.getAttribute("uavalidtokenno");
String uaIsValid1= (String)session.getAttribute("loginuID");

String sessionid = (String) session.getAttribute("sessionID");
String euaValidForAccess =  LoginAction.getPermissions(uaIsValid1, sessionid);
if(uaIsValid1== null || uaIsValid1.equals("") || uavalidtokenno1111== null || uavalidtokenno1111.equals("")||euaValidForAccess==null){	

      out.write('\r');
      out.write('\n');
      if (true) {
        _jspx_page_context.forward("/login.html");
        return;
      }
      out.write('\r');
      out.write('\n');
}
      out.write("\r\n");
      out.write("\r\n");
      out.write("<html lang=\"en-US\">\r\n");
      out.write("<head>\r\n");
      out.write("<meta charset=\"UTF-8\">\r\n");
      out.write("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/>\r\n");
      out.write("<title>Edit Company</title>\r\n");
      out.write("<META NAME=\"ROBOTS\" CONTENT=\"NOINDEX, NOFOLLOW\"></META>\r\n");
      out.write("<link rel=\"shortcut icon\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/images/favicon.png\" type=\"image/ico\"/>\r\n");
      out.write("<link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,700' rel='stylesheet' type='text/css'>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/font-awesome.min.css\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/bootstrap.min.css\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/jquery.fancybox.css\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/jquery-ui.css\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/bootstrap-datetimepicker.css\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/error.css\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/daterangepicker.css\" media=\"all\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/select2.min.css\" media=\"all\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/mdtimepicker.css\" media=\"all\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/theme.css\" media=\"all\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/responsive.css\" media=\"all\"/>\r\n");
      out.write("\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/jquery.dataTables.css\" media=\"all\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/buttons.dataTables.min.css\" media=\"all\"/>\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/css/responsive.dataTables.min.css\" media=\"all\"/>\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<div class=\"wrap\">\r\n");
      out.write("\r\n");

String url = request.getParameter("uid");
String[] a=url.split(".html");
String[] b=a[0].split("-");
String compuid=b[1];
String[][] getCompanyByID=CompanyMaster_ACT.getCompanyByID(compuid);
String[][] getKey=CompanyMaster_ACT.getKey(getCompanyByID[0][14]);

      out.write("\r\n");
      out.write("\r\n");
      out.write("<div id=\"content\">\r\n");
      out.write("\r\n");
      out.write("<div class=\"main-content\">\r\n");
      out.write("<div class=\"container\">\r\n");
      out.write("<div class=\"row\">\r\n");
      out.write("<div class=\"col-xs-12\">\r\n");
      out.write("<div class=\"menuDv  post-slider\">\r\n");
      out.write("<form action=\"update-company.html\" method=\"post\" name=\"registeruserClient\" id=\"registeruserClient\">\r\n");
      out.write("<div class=\"row\">\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Company ID :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"CompanyID\" id=\"Company ID\" title=\"");
      out.print(getCompanyByID[0][1]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][1]);
      out.write("\" readonly class=\"form-control\">\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Company Name:<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon fa fa-user\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"CompanyName\" id=\"Company Name\" title=\"");
      out.print(getCompanyByID[0][2]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][2]);
      out.write("\" placeholder=\"Enter Company Name\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"CompanyNameEerorMSGdiv\" class=\"errormsg\"></div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Mobile No. :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon fa fa-mobile\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"mobile\" id=\"Mobile\" placeholder=\"Enter Mobile No.\" title=\"");
      out.print(getCompanyByID[0][12]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][12]);
      out.write("\" maxlength=\"10\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"mobileEerorMSGdiv\" class=\"errormsg\"></div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Email Id :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon fa fa-at\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"email\" id=\"Email\" placeholder=\"Enter Email Id\" title=\"");
      out.print(getCompanyByID[0][13]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][13]);
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"emailEerorMSGdiv\" class=\"errormsg\"></div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"row\">\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Company's Address:<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"CompanyAddress\" id=\"Company Address\" title=\"");
      out.print(getCompanyByID[0][3]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][3]);
      out.write("\" placeholder=\"Enter Company Address\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"CompanyAddressEerorMSGdiv\" class=\"errormsg\"></div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>PAN:<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"PAN\" id=\"PAN\" placeholder=\"Enter PAN\" maxlength=\"10\" title=\"");
      out.print(getCompanyByID[0][4]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][4]);
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"PANEerorMSGdiv\" class=\"errormsg\"></div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>GSTIN:<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"GSTIN\" id=\"GSTIN\" placeholder=\"Enter GSTIN\" title=\"");
      out.print(getCompanyByID[0][5]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][5]);
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"GSTINEerorMSGdiv\" class=\"errormsg\"></div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>State Code:<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"statecode\" id=\"State Code\" placeholder=\"Enter State Code\" title=\"");
      out.print(getCompanyByID[0][6]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][6]);
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"StateCodeEerorMSGdiv\" class=\"errormsg\"></div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"row\">\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Bank's Name:<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon fa fa-bank\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"BankName\" id=\"Bank Name\" placeholder=\"Enter Bank Name\" title=\"");
      out.print(getCompanyByID[0][7]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][7]);
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"BankNameEerorMSGdiv\" class=\"errormsg\"></div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Account Holder's Name :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon fa fa-user\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"AccountName\" id=\"Account Name\" placeholder=\"Enter Account Name\" title=\"");
      out.print(getCompanyByID[0][11]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][11]);
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"AccountNameEerorMSGdiv\" class=\"errormsg\"></div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Bank A/C No:<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"BankACNo\" id=\"Bank AC No\" placeholder=\"Enter Bank Account Number\" title=\"");
      out.print(getCompanyByID[0][8]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][8]);
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>IFSC Code:<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"BankIFSCCode\" id=\"Bank IFSC Code\" placeholder=\"Enter Bank IFSC Code\" title=\"");
      out.print(getCompanyByID[0][9]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][9]);
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"row\">\r\n");
      out.write("<div class=\"col-md-12 col-sm-12 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Bank's Address:<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"BankAddress\" id=\"Bank Address\" placeholder=\"Enter Bank Address\" title=\"");
      out.print(getCompanyByID[0][10]);
      out.write("\" value=\"");
      out.print(getCompanyByID[0][10]);
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("<div class=\"row\">\r\n");
      out.write("<div class=\"col-md-12 col-sm-12 col-xs-12\">\r\n");
      out.write("<div class=\"form-group text-center\">\r\n");
      out.write("<h3><strong>Initial Codes of Table <span style=\"color: red;\">*</span></strong></h3>\r\n");
      out.write("<span style=\"font-size: 12px;color: red;\">(Max 2 Characters.)</span>\r\n");
      out.write("<hr>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("<div class=\"row\">\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Employee's Key :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"employeekey\" maxlength=\"2\" id=\"Employee Key\" value=\"");
      out.print(getKey[0][0] );
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>GST Invoice's Key :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"gstinvoice\" maxlength=\"2\" id=\"GST Invoice Key\" value=\"");
      out.print(getKey[0][1] );
      out.write("\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Client's Key :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"clientkey\" maxlength=\"2\" id=\"Client Key\" value=\"");
      out.print(getKey[0][2] );
      out.write("\" placeholder=\"Enter Client Table's key\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Project's Key :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"projectkey\" maxlength=\"2\" id=\"Project Key\" value=\"");
      out.print(getKey[0][3] );
      out.write("\" placeholder=\"Enter Project's Key\" class=\"form-control\"  readonly=\"readonly\">\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"row\">\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Billing's Key :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"billingkey\" maxlength=\"2\" id=\"Billing Key\" value=\"");
      out.print(getKey[0][4] );
      out.write("\" placeholder=\"Enter Billing Key\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Task's Key :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"taskkey\" maxlength=\"2\" id=\"Task Key\" value=\"");
      out.print(getKey[0][5] );
      out.write("\" placeholder=\"Enter Task key\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Enquiry's Key :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"enquirykey\" maxlength=\"2\" id=\"Enquiry Key\" value=\"");
      out.print(getKey[0][6] );
      out.write("\" placeholder=\"Enter Enquiry's Key\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"col-md-3 col-sm-3 col-xs-12\">\r\n");
      out.write("<div class=\"form-group\">\r\n");
      out.write("<label>Non GST Invoice Key :<span style=\"color: red;\">*</span></label>\r\n");
      out.write("<div class=\"input-group\">\r\n");
      out.write("<span class=\"input-group-addon\"><i class=\"form-icon sprite page\"></i></span>\r\n");
      out.write("<input type=\"text\" name=\"nongstinvoicekey\" maxlength=\"2\" id=\"Non GST Invoice Key\" value=\"");
      out.print(getKey[0][7] );
      out.write("\" placeholder=\"Enter Non GST Invoice Key\" class=\"form-control\" readonly>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</form>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("</div>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/jquery-1.12.4.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/bootstrap.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/jquery.fancybox.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/jquery-ui.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/bootstrap-datetimepicker.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/nicEdit.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/globalscript.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/select2.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/moment.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/daterangepicker.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/mdtimepicker.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/fontawsome.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/theme.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/custom.js\"></script>\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/jquery.dataTables.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/dataTables.buttons.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/jszip.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/pdfmake.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/vfs_fonts.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/buttons.html5.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/buttons.print.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/buttons.colVis.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/dataTables.select.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(request.getContextPath());
      out.write("/staticresources/js/dataTables.responsive.min.js\"></script>\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\r\n");
      out.write("$(document).ready( function () {\r\n");
      out.write("	var role=\"");
      out.print(session.getAttribute("emproleid"));
      out.write("\";\r\n");
      out.write("	$(\".checked\").click(function(){\r\n");
      out.write("		 if ($(\".checked\").is(\":checked\")){\r\n");
      out.write("			 $(\".hashico\").hide()\r\n");
      out.write("			 $(\"#CheckAll\").show();\r\n");
      out.write("			 $(\"#SearchOptions\").hide();\r\n");
      out.write("			 $(\"#SearchOptions1\").show();\r\n");
      out.write("	}else{\r\n");
      out.write("		 $(\"#CheckAll\").hide();\r\n");
      out.write("		 $(\".hashico\").show()\r\n");
      out.write("		 $(\"#SearchOptions\").show();\r\n");
      out.write("		 $(\"#SearchOptions1\").hide();\r\n");
      out.write("	}\r\n");
      out.write("		\r\n");
      out.write("		});\r\n");
      out.write("	$(\"#CheckAll\").click(function(){\r\n");
      out.write("	$('.checked').prop('checked', this.checked);\r\n");
      out.write("	if ($(\".checked\").is(\":checked\")){\r\n");
      out.write("		 	 $(\".hashico\").hide()\r\n");
      out.write("			 $(\"#CheckAll\").show();\r\n");
      out.write("			 $(\"#SearchOptions\").hide();\r\n");
      out.write("			 $(\"#SearchOptions1\").show();\r\n");
      out.write("	}else{\r\n");
      out.write("		 $(\".hashico\").show()\r\n");
      out.write("		 $(\"#CheckAll\").hide();\r\n");
      out.write("		 $(\"#SearchOptions\").show();\r\n");
      out.write("		 $(\"#SearchOptions1\").hide();\r\n");
      out.write("	}\r\n");
      out.write("		    \r\n");
      out.write("	});\r\n");
      out.write("} );\r\n");
      out.write("\r\n");
      out.write(" $(window).load(function() {\r\n");
      out.write("  $(\".processing_loader\").fadeOut();\r\n");
      out.write("}); \r\n");
      out.write("</script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write(" function showLoader(){\r\n");
      out.write("   $(\".processing_loader\").fadeIn(); \r\n");
      out.write("} \r\n");
      out.write("function hideLoader(){\r\n");
      out.write("   $(\".processing_loader\").fadeOut();  \r\n");
      out.write("}  \r\n");
      out.write("</script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("$('.timepicker').mdtimepicker();\r\n");
      out.write("function openClock(id){\r\n");
      out.write("$('#'+id).mdtimepicker();\r\n");
      out.write("}\r\n");
      out.write("function openCalendar(id){\r\n");
      out.write("	$(\"#\"+id).datepicker({changeMonth:true,changeYear:true,dateFormat:'yy-mm-dd'});\r\n");
      out.write("}\r\n");
      out.write("</script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("$('.has-clear input[type=\"text\"]').on('input propertychange', function() {\r\n");
      out.write("  var $this = $(this);\r\n");
      out.write("  var visible = Boolean($this.val());\r\n");
      out.write("  $this.siblings('.form-control-clear').toggleClass('hidden', !visible);\r\n");
      out.write("}).trigger('propertychange');\r\n");
      out.write("\r\n");
      out.write("$('.form-control-clear').click(function() {\r\n");
      out.write("  $(this).siblings('input[type=\"text\"]').val('')\r\n");
      out.write("    .trigger('propertychange').focus();\r\n");
      out.write("});\r\n");
      out.write("</script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("function goBack() {\r\n");
      out.write("  window.history.back();\r\n");
      out.write("}\r\n");
      out.write("</script>\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("</body>\r\n");
      out.write("</html>\r\n");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}