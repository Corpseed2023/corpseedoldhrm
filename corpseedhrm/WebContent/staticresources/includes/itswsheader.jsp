<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="hcustbackend.ClientACT"%>
<%@ page autoFlush="true" buffer="1094kb"%>
<%@ include file="../../madministrator/checkvalid_user.jsp" %>
<%
boolean CLA00=false;
boolean ADM00=false;
boolean ACU01=false;
boolean ACU02=false;
boolean ACU03=false;
boolean ACU04=false;
boolean ACU05=false;
boolean AMU02=false;
boolean ATT03=false;
boolean ATT02=false;
boolean SAL04=false;
boolean SAL00=false;
boolean SAL01=false;
boolean SAL02=false;
boolean SAL03=false;
boolean SAL05=false;
boolean SAL06=false;
boolean DEX00=false;
boolean DEX01=false;
boolean DEX02=false;
boolean DEX03=false;
boolean DEX05=false;
boolean CL00=false;
boolean CR01=false;
boolean CR02=false;
boolean CR03=false;
boolean CR04=false;
boolean CR05=false;
boolean CPR03=false;
boolean CB06=false;
boolean MB07=false;
boolean MB08=false;
boolean MB09=false;
boolean UBL0=false;
boolean TM00=false;
boolean MT00=false;
boolean MT01=false;
boolean TN02=false;
boolean MS03=false;
boolean MS04=false;
boolean MS05=false;
boolean MS06=false;
boolean MA00=false;
boolean MP01=false;
boolean MP02=false;
boolean EQ00=false;
boolean EQ01=false;
boolean EQ02=false;
boolean EM01=false;
boolean EM02=false;
boolean EM03=false;
boolean EM04=false;
boolean SR01=false;
boolean SR02=false;
boolean RC00=false;
boolean MC00=false;
boolean MC01=false;
boolean MC02=false;
boolean MC03=false;
boolean MC04=false;
boolean RE00=false;
boolean ME00=false;
boolean ME01=false;
boolean ME02=false;
boolean ME03=false;
boolean ME04=false;
boolean AC00=false;
boolean MS09=false;
boolean LTH00=false;
boolean EM05=false;
boolean EM06=false;
boolean MSL00=false;
boolean MSL01=false;
boolean MSL02=false;
boolean MSL03=false;
boolean MSL04=false;
boolean MTH00=false;
boolean MTH01=false;
boolean MTH02=false;
boolean MTH03=false;
boolean MTH04=false;
boolean MMH00=false;
boolean MMH01=false;
boolean MMH02=false;
boolean MMH03=false;
boolean MMH04=false;
boolean MAS00=false;
boolean MAS01=false;
boolean MST00=false;
boolean MST01=false;
boolean MST02=false;
boolean SUC00=false;
boolean SUC01=false;
boolean SUC02=false;
boolean MCV00=false;
boolean MCV01=false;
boolean MCV02=false;
boolean ACC00=false;
boolean ACC01=false;
boolean ACC02=false;
boolean ACC03=false;
boolean MB00=false;
boolean MB01=false;
boolean MB02=false;
boolean MIN00=false;
boolean MIN01=false;
boolean MIN02=false;
boolean MIN03=false;
boolean GH00=false;
boolean GH01=false;
boolean MP03=false;
boolean MP04=false;
boolean MPP00=false;
boolean MPP01=false;
boolean MTT00=false;
boolean MTT01=false;
boolean MTT02=false;
boolean MTT03=false;
boolean MTT04=false;
boolean MTT05=false;
boolean MMP00=false;
boolean MMP01=false;
boolean MMP02=false;
boolean MMP03=false;
boolean MMP04=false;
boolean MP05=false;
boolean AMC00=false;
boolean EST00=false;
boolean EST01=false;
boolean MD00=false;
boolean MDC0=false;
boolean MCC0=false;
boolean MG00=false;
boolean MTR0=false;
boolean MTX0=false;
boolean MTM0=false;
boolean MCO0=false;
boolean MX00=false;
boolean CH00=false;
boolean GI00=false;
boolean MCP0=false;
boolean RD00=false;
boolean DH00=false; 
boolean EH00=false;
boolean MCR0=false;
boolean MTR1=false;
boolean INV0=false;
boolean DC00=false;
boolean DOC00=false;
boolean DTR00=false;
   
if(euaValidForAccess!=null){    
String[] getempaccessesL=euaValidForAccess.split("#");
for(int ur=0;ur<getempaccessesL.length;ur++) {
if(getempaccessesL[ur].equals("ADM00")){ADM00=true;}
else if(getempaccessesL[ur].equals("CLA00")){CLA00=true;}
else if(getempaccessesL[ur].equals("MG00")){MG00=true;}
else if(getempaccessesL[ur].equals("MTR0")){MTR0=true;}
else if(getempaccessesL[ur].equals("MTX0")){MTX0=true;}
else if(getempaccessesL[ur].equals("MTM0")){MTM0=true;}
else if(getempaccessesL[ur].equals("MCO0")){MCO0=true;}
else if(getempaccessesL[ur].equals("MDC0")){MDC0=true;}
else if(getempaccessesL[ur].equals("MCC0")){MCC0=true;}
else if(getempaccessesL[ur].equals("MD00")){MD00=true;}
else if(getempaccessesL[ur].equals("EST00")){EST00=true;}
else if(getempaccessesL[ur].equals("EST01")){EST01=true;}
else if(getempaccessesL[ur].equals("ACU01")){ACU01=true;}
else if(getempaccessesL[ur].equals("ACU02")){ACU02=true;}
else if(getempaccessesL[ur].equals("ACU03")){ACU03=true;}
else if(getempaccessesL[ur].equals("ACU04")){ACU04=true;}
else if(getempaccessesL[ur].equals("ACU05")){ACU05=true;}
else if(getempaccessesL[ur].equals("AMU02")){AMU02=true;}
else if(getempaccessesL[ur].equals("ATT02")){ATT02=true;}
else if(getempaccessesL[ur].equals("ATT03")){ATT03=true;}
else if(getempaccessesL[ur].equals("SAL04")){SAL04=true;}
else if(getempaccessesL[ur].equals("SAL00")){SAL00=true;}
else if(getempaccessesL[ur].equals("SAL01")){SAL01=true;}
else if(getempaccessesL[ur].equals("SAL02")){SAL02=true;}
else if(getempaccessesL[ur].equals("SAL03")){SAL03=true;}
else if(getempaccessesL[ur].equals("SAL05")){SAL05=true;}
else if(getempaccessesL[ur].equals("SAL06")){SAL06=true;}
else if(getempaccessesL[ur].equals("DEX00")) {DEX00=true;}
else if(getempaccessesL[ur].equals("DEX01")) {DEX01=true;}
else if(getempaccessesL[ur].equals("DEX02")) {DEX02=true;}
else if(getempaccessesL[ur].equals("DEX03")) {DEX03=true;}
else if(getempaccessesL[ur].equals("DEX05")) {DEX05=true;}
else if(getempaccessesL[ur].equals("CL00")){CL00=true;}
else if(getempaccessesL[ur].equals("CR01")){CR01=true;}
else if(getempaccessesL[ur].equals("CR02")){CR02=true;}
else if(getempaccessesL[ur].equals("CR03")){CR03=true;}
else if(getempaccessesL[ur].equals("CR04")){CR04=true;}
else if(getempaccessesL[ur].equals("CR05")){CR05=true;}
else if(getempaccessesL[ur].equals("CPR03")){CPR03=true;}
else if(getempaccessesL[ur].equals("CB06")){CB06=true;}
else if(getempaccessesL[ur].equals("MB07")){MB07=true;}
else if(getempaccessesL[ur].equals("MB08")){MB08=true;}
else if(getempaccessesL[ur].equals("UBL0")){UBL0=true;}
else if(getempaccessesL[ur].equals("MB09")){MB09=true;}
else if(getempaccessesL[ur].equals("TM00")){TM00=true;}
else if(getempaccessesL[ur].equals("MT00")){MT00=true;}
else if(getempaccessesL[ur].equals("MT01")){MT01=true;}
else if(getempaccessesL[ur].equals("TN02")){TN02=true;}
else if(getempaccessesL[ur].equals("MS03")){MS03=true;}
else if(getempaccessesL[ur].equals("MS04")){MS04=true;}
else if(getempaccessesL[ur].equals("MS05")){MS05=true;}
else if(getempaccessesL[ur].equals("MS06")){MS06=true;}
else if(getempaccessesL[ur].equals("MA00")){MA00=true;}
else if(getempaccessesL[ur].equals("MP01")){MP01=true;}
else if(getempaccessesL[ur].equals("MP02")){MP02=true;}
else if(getempaccessesL[ur].equals("EQ00")){EQ00=true;}
else if(getempaccessesL[ur].equals("EQ01")){EQ01=true;}
else if(getempaccessesL[ur].equals("EQ02")){EQ02=true;}
else if(getempaccessesL[ur].equals("EM01")){EM01=true;}
else if(getempaccessesL[ur].equals("EM02")){EM02=true;}
else if(getempaccessesL[ur].equals("EM03")){EM03=true;}
else if(getempaccessesL[ur].equals("EM04")){EM04=true;}
else if(getempaccessesL[ur].equals("SR01")){SR01=true;}
else if(getempaccessesL[ur].equals("SR02")){SR02=true;}
else if(getempaccessesL[ur].equals("RC00")){RC00=true;}
else if(getempaccessesL[ur].equals("MC00")){MC00=true;}
else if(getempaccessesL[ur].equals("MC01")){MC01=true;}
else if(getempaccessesL[ur].equals("MC02")){MC02=true;}
else if(getempaccessesL[ur].equals("MC03")){MC03=true;}
else if(getempaccessesL[ur].equals("MC04")){MC04=true;}
else if(getempaccessesL[ur].equals("RE00")){RE00=true;}
else if(getempaccessesL[ur].equals("ME00")){ME00=true;}
else if(getempaccessesL[ur].equals("ME01")){ME01=true;}
else if(getempaccessesL[ur].equals("ME02")){ME02=true;}
else if(getempaccessesL[ur].equals("ME03")){ME03=true;}
else if(getempaccessesL[ur].equals("ME04")){ME04=true;}
else if(getempaccessesL[ur].equals("AC00")){AC00=true;}
else if(getempaccessesL[ur].equals("MS09")){MS09=true;}
else if(getempaccessesL[ur].equals("LTH00")){LTH00=true;}
else if(getempaccessesL[ur].equals("EM05")){EM05=true;}
else if(getempaccessesL[ur].equals("EM06")){EM06=true;}
else if(getempaccessesL[ur].equals("MSL00")){MSL00=true;}
else if(getempaccessesL[ur].equals("MSL01")){MSL01=true;}
else if(getempaccessesL[ur].equals("MSL02")){MSL02=true;}
else if(getempaccessesL[ur].equals("MSL03")){MSL03=true;}
else if(getempaccessesL[ur].equals("MSL04")){MSL04=true;}
else if(getempaccessesL[ur].equals("MTH00")){MTH00=true;}
else if(getempaccessesL[ur].equals("MTH01")){MTH01=true;}
else if(getempaccessesL[ur].equals("MTH02")){MTH02=true;}
else if(getempaccessesL[ur].equals("MTH03")){MTH03=true;}
else if(getempaccessesL[ur].equals("MTH04")){MTH04=true;}
else if(getempaccessesL[ur].equals("MMH00")){MMH00=true;}
else if(getempaccessesL[ur].equals("MMH01")){MMH01=true;}
else if(getempaccessesL[ur].equals("MMH02")){MMH02=true;}
else if(getempaccessesL[ur].equals("MMH03")){MMH03=true;}
else if(getempaccessesL[ur].equals("MMH04")){MMH04=true;}
else if(getempaccessesL[ur].equals("MAS00")){MAS00=true;}
else if(getempaccessesL[ur].equals("MAS01")){MAS01=true;}
else if(getempaccessesL[ur].equals("MST00")){MST00=true;}
else if(getempaccessesL[ur].equals("MST01")){MST01=true;}
else if(getempaccessesL[ur].equals("MST02")){MST02=true;}
else if(getempaccessesL[ur].equals("SUC00")){SUC00=true;}
else if(getempaccessesL[ur].equals("SUC01")){SUC01=true;}
else if(getempaccessesL[ur].equals("SUC02")){SUC02=true;}
else if(getempaccessesL[ur].equals("MCV00")){MCV00=true;}
else if(getempaccessesL[ur].equals("MCV01")){MCV01=true;}
else if(getempaccessesL[ur].equals("MCV02")){MCV02=true;}
else if(getempaccessesL[ur].equals("ACC00")){ACC00=true;}
else if(getempaccessesL[ur].equals("ACC01")){ACC01=true;}
else if(getempaccessesL[ur].equals("ACC02")){ACC02=true;}
else if(getempaccessesL[ur].equals("ACC03")){ACC03=true;}
else if(getempaccessesL[ur].equals("MB00")){MB00=true;}
else if(getempaccessesL[ur].equals("MB01")){MB01=true;}
else if(getempaccessesL[ur].equals("MB02")){MB02=true;}
else if(getempaccessesL[ur].equals("MIN00")){MIN00=true;}
else if(getempaccessesL[ur].equals("MIN01")){MIN01=true;}
else if(getempaccessesL[ur].equals("MIN02")){MIN02=true;}
else if(getempaccessesL[ur].equals("MIN03")){MIN03=true;}
else if(getempaccessesL[ur].equals("GH00")){GH00=true;}
else if(getempaccessesL[ur].equals("GH01")){GH01=true;}
else if(getempaccessesL[ur].equals("MP03")){MP03=true;}
else if(getempaccessesL[ur].equals("MP04")){MP04=true;}
else if(getempaccessesL[ur].equals("MPP00")){MPP00=true;}
else if(getempaccessesL[ur].equals("MPP01")){MPP01=true;}
else if(getempaccessesL[ur].equals("MTT00")){MTT00=true;}
else if(getempaccessesL[ur].equals("MTT01")){MTT01=true;}
else if(getempaccessesL[ur].equals("MTT02")){MTT02=true;}
else if(getempaccessesL[ur].equals("MTT03")){MTT03=true;}
else if(getempaccessesL[ur].equals("MTT04")){MTT04=true;}
else if(getempaccessesL[ur].equals("MTT05")){MTT05=true;}
else if(getempaccessesL[ur].equals("MMP00")){MMP00=true;}
else if(getempaccessesL[ur].equals("MMP01")){MMP01=true;}
else if(getempaccessesL[ur].equals("MMP02")){MMP02=true;}
else if(getempaccessesL[ur].equals("MMP03")){MMP03=true;}
else if(getempaccessesL[ur].equals("MMP04")){MMP04=true;}
else if(getempaccessesL[ur].equals("MP05")){MP05=true;}
else if(getempaccessesL[ur].equals("AMC00")){AMC00=true;}
else if(getempaccessesL[ur].equals("MX00")){MX00=true;}
else if(getempaccessesL[ur].equals("CH00")){CH00=true;}
else if(getempaccessesL[ur].equals("GI00")){GI00=true;}
else if(getempaccessesL[ur].equals("MCP0")){MCP0=true;}
else if(getempaccessesL[ur].equals("RD00")){RD00=true;}
else if(getempaccessesL[ur].equals("DH00")){DH00=true;}
else if(getempaccessesL[ur].equals("EH00")){EH00=true;}
else if(getempaccessesL[ur].equals("MCR0")){MCR0=true;}
else if(getempaccessesL[ur].equals("MTR1")){MTR1=true;}
else if(getempaccessesL[ur].equals("INV0")){INV0=true;}
else if(getempaccessesL[ur].equals("DC00")){DC00=true;}
else if(getempaccessesL[ur].equals("DOC00")){DOC00=true;}
else if(getempaccessesL[ur].equals("DTR00")){DTR00=true;}
}    
}
%>
<div id="header">
<div class="header">
<div class="row">
<div class="col-md-2 col-sm-2 col-xs-12">
<div class="logo1">
<a href="<%=request.getContextPath()%>/dashboard.html"><img src="<%=request.getContextPath() %>/staticresources/images/corpseed-logo.png"></a>
</div>
</div>
<div class="col-md-10 col-sm-10 col-xs-12">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="row">
<div class="header-nav">
<nav class="main-nav main-nav3">
<ul class="main-menu">
<li><a href="<%=request.getContextPath()%>/dashboard.html">Dashboard</a></li>
<%if(ADM00){ %>
<li class="menu-item-has-childrent">
<a href="javascript:void(0);" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">HR<span class="lnr lnr-chevron-down"></span></a>
<ul class="sub-menu">
<%if(AMU02){%><li><a href="<%=request.getContextPath() %>/managewebuser.html">Manage HRM Login</a></li><%}%>
<%if(ME00){%><li><a href="<%=request.getContextPath() %>/manage-employee.html">Manage Employee</a></li><%} %>
<%if(CLA00){ %><li><a href="<%=request.getContextPath() %>/clientadmin.html">Manage Client's Admin</a></li><%} %>
<%if(MC00){%><li><a href="<%=request.getContextPath() %>/manage-company.html">Manage Company</a></li><%} %>
<%if(ATT03){%><li><a href="<%=request.getContextPath() %>/Manage-Attendance.html">Manage Attendance</a></li><%} %>
<%if(LTH00){%><li><a href="<%=request.getContextPath() %>/logintraffic.html">Login & Traffic History</a></li><%}%>
<%-- <%if(SAL04){%> <li class="menu-item-has-childrent"><a href="javascript:void(0);" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">Salary</a>
<ul class="sub-menu">
<%if(SAL00){%><li><a href="<%=request.getContextPath() %>/Manage-Salary-Structure.html">Manage Salary Structure</a></li><%}%>
<%if(MSL00){%><li><a href="<%=request.getContextPath() %>/Manage-Monthly-Salary.html">Manage Salary</a></li><%}%>
<%if(MTH00){%><li><a href="<%=request.getContextPath() %>/TDS-details.html">Manage TDS History</a></li><%}%>
<%if(MMH00){%><li><a href="<%=request.getContextPath() %>/Med-details.html">Manage Medical History</a></li><%}%>
</ul></li><%}%> --%>
</ul>
</li>
<%} %>
<%if(EQ00){%>
<li class="menu-item-has-childrent">
<a href="javascript:void(0);" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">Sales<span class="lnr lnr-chevron-down"></span></a>
<ul class="sub-menu">
<%if(EST00){%><li><a href="<%=request.getContextPath() %>/manage-estimate.html">Manage Estimate</a></li><%} %>
<%if(EQ02){%><li><a href="<%=request.getContextPath() %>/manage-sales.html">Manage Sales</a></li><%} %>
<li><a href="<%=request.getContextPath() %>/compliance-check.html">Compliance Check</a></li>
</ul>
</li>
<%}if(DC00){%>
<li class="menu-item-has-childrent">
<a href="javascript:void(0);" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">Document<span class="lnr lnr-chevron-down"></span></a>
<ul class="sub-menu">
<%if(DOC00){%><li><a href="<%=request.getContextPath() %>/document-collection.html">Document Collection</a></li><%} %>
</ul>
</li>
<%}if(CL00){ %>
<li class="menu-item-has-childrent">
<a href="javascript:void(0);" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">Client<span class="lnr lnr-chevron-down"></span></a>
<ul class="sub-menu">
<%if(CPR03){%> <li><a href="<%=request.getContextPath() %>/manage-client.html">Manage Client</a></li><%}%>
<%-- <%if(CMP04){%> <li><a href="<%=request.getContextPath() %>/manage-project.html">Manage Project</a></li><%}%> --%>
</ul>
</li>
<%} %>
<%if(MT00){ %>
<li class="menu-item-has-childrent">
<a href="javascript:void(0);" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">My Task<span class="lnr lnr-chevron-down"></span></a>
<ul class="sub-menu">
<%if(MT01){%>  <li><a href="<%=request.getContextPath() %>/mytask.html">My Task Details</a></li><%} %>
<%if(MD00){%><li><a href="<%=request.getContextPath() %>/managedelivery.html">Manage Delivery</a></li><%} %>
<%if(MDC0){%><li><a href="<%=request.getContextPath() %>/mydocument.html">Manage Document</a></li><%} %>
<%if(MCC0){%><li><a href="<%=request.getContextPath() %>/calendar.html">Calendar</a></li><%} %>
<%if(MCR0){%><li><a href="<%=request.getContextPath() %>/certificates-renewal.html">Certificate renewal</a></li><%} %>
<%if(MTR1){%><li><a href="<%=request.getContextPath() %>/report.html">Manage Report</a></li><%} %>
<%if(TN02){%>
<li class="menu-item-has-childrent">
<!-- <a>SEO</a> -->
<ul class="sub-menu">
<%-- <%if(MS08){%><li><a href="<%=request.getContextPath() %>/nonseo-manage-task.html">Manage Non SEO Task</a></li><%} %> --%>
<%if(MS04){%><li><a href="<%=request.getContextPath() %>/manage-seo.html">Manage SEO OnPage</a></li><%} %>
<%if(MS09){%><li><a href="<%=request.getContextPath() %>/seo-url-collection.html">SEO URL Collection</a></li><%} %>
<%if(MS06){%><li><a href="<%=request.getContextPath() %>/manage-content.html">Manage Content</a></li><%} %>
<%if(SR01){%><li><a href="<%=request.getContextPath() %>/update-report.html">Update Report</a></li><%} %>
<%if(SR02){%><li><a href="<%=request.getContextPath() %>/seo-report.html">SEO Report</a></li><%} %>
</ul>
</li>
<%} %>

</ul>
</li>
<%}if(ACC00){ %>
<li class="menu-item-has-childrent">
<a href="javascript:void(0);" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">Account<span class="lnr lnr-chevron-down"></span></a>
<ul class="sub-menu">
<%if(AC00){%> <li><a href="<%=request.getContextPath() %>/manageaccount.html">Client Accounts</a></li><%}%>
<%-- <%if(ACC02){%><li><a href="<%=request.getContextPath() %>/employeeaccount.html">Employee Accounts</a></li><%}%> --%>
<%if(MB07){%> <li><a href="<%=request.getContextPath() %>/manage-billing.html">Projects Billing</a></li><%}%>
<%if(UBL0){%><li><a href="<%=request.getContextPath() %>/unbilled.html">Unbilled</a></li><%} %>
<%if(MB09){%><li><a href="<%=request.getContextPath() %>/openpayrollhistory.html">Payroll</a></li><%} %>
<%if(GH00){%><li><a href="<%=request.getContextPath() %>/managetransactions.html">Manage Transactions</a></li><%} %>
<%-- <%if(MP02){%><li><a href="<%=request.getContextPath() %>/managereport.html">Manage Report</a></li><%} %> --%>
<%if(MX00){%><li><a href="<%=request.getContextPath() %>/manageexpenses.html">Manage Expense</a></li><%} %>
<%if(CH00){%><li><a href="<%=request.getContextPath() %>/managecredit.html">Credit history</a></li><%} %>
<%if(GI00){%><li><a href="<%=request.getContextPath() %>/manageinvoice.html">Manage Invoice</a></li><%} %>
</ul>
</li>
<%}if(TM00){ %>
<li class="menu-item-has-childrent">
<a href="javascript:void(0);" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">Activity Master<span class="lnr lnr-chevron-down"></span></a>
<ul class="sub-menu">
<%-- <%if(MT02){%> <li><a href="<%=request.getContextPath() %>/manage-task.html">Manage Task</a></li><%}%> --%>
<%if(MPP00){ %><li><a href="<%=request.getContextPath() %>/manage-product.html">Manage Product</a></li><%}%>
<%if(MTT00){ %><li><a href="<%=request.getContextPath() %>/manage-template.html">Manage Template</a></li><%}%>
<%if(MG00){ %><li><a href="<%=request.getContextPath() %>/manageguide.html">Manage Guide</a></li><%}%>
<%if(MTR0){ %><li><a href="<%=request.getContextPath() %>/managetrigger.html">Manage Trigger</a></li><%}%>
<%if(MTX0){ %><li><a href="<%=request.getContextPath() %>/managetax.html">Manage Tax</a></li><%}%>
<%if(MTM0){ %><li><a href="<%=request.getContextPath() %>/manageteam.html">Manage Teams</a></li><%}%>
<%if(MCO0){ %><li><a href="<%=request.getContextPath() %>/managecontacts.html">Manage Contacts</a></li><%}%>
<%if(MCP0){ %><li><a href="<%=request.getContextPath() %>/managecoupon.html">Manage Coupon</a></li><%} %>
</ul>
</li>
<%}if(RD00){%>
<li class="menu-item-has-childrent">
<a href="javascript:void(0);" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">Records<span class="lnr lnr-chevron-down"></span></a>
<ul class="sub-menu">
<%if(DH00){ %><li><a href="<%=request.getContextPath() %>/download-history.html">Download History</a></li><%} %>
<%if(EH00){ %><li><a href="<%=request.getContextPath() %>/export-history.html">Export History</a></li><%} %>
</ul>
</li>
<%}if(MA00){%>
<li class="menu-item-has-childrent">
 <a href="javascript:void(0);" class="webhide" data-toggle="dropdown" aria-hidden="false" aria-expanded="false">Profile<span class="lnr lnr-chevron-down"></span></a>
<div class="welcomeBox"><i class="fas fa-user"></i>&nbsp;Hi, <%=session.getAttribute("uaname") %><span class="lnr lnr-chevron-down"></span></div>
<ul class="sub-menu">
<%if(MMP00){%><li><a href="javascript:void(0);" onclick="profilechapass('<%=uaIsValid1%>','profile');"><i class="fa fa-user"></i>My Profile</a></li><%} %>
<li><a href="<%=request.getContextPath() %>/track-invoice.html"><i class="fa fa-search"></i>Track Invoice</a></li>
<%if(MMP02){%><li><a href="javascript:void(0);" onclick="profilechapass('<%=uaIsValid1%>','chapass');"><i class="fa fa-lock"></i>Change Password</a></li><%} %>
<%if(MMP03){%><li><a href="<%=request.getContextPath() %>/logout.html"><i class="fa fa-sign-out"></i>Logout</a></li><%} %>
</ul>
<script type="text/javascript">
function profilechapass(id,page){$.ajax({type:"POST",url:"<%=request.getContextPath()%>/vieweditpage",data:{"uid":id},success:function(response){if(page=="profile")window.location="<%=request.getContextPath()%>/profile.html";else if(page=="chapass")window.location="<%=request.getContextPath()%>/changepassword.html";else if(page=="work")window.location="<%=request.getContextPath()%>/workscheduler.html";},});}
</script>
</li>
<%}
String notificationloginuaid = (String) session.getAttribute("loginuaid");
String notificationtoken=(String)session.getAttribute("uavalidtokenno");
long totalNotification=ClientACT.getTotalUnseenNotificationAdmin(notificationtoken,notificationloginuaid); 
// System.out.println(notificationloginuaid+"/"+notificationtoken+"/"+totalNotification);
String notifications[][]=ClientACT.getAllNotification(notificationtoken,notificationloginuaid);
%>
<li class="notification">
<a class="toggle_btn" onclick="markAllAsReadNotification('<%=totalNotification %>')"><i class="fa fa-bell"></i><span class="badge" id="totalNotification"><%if(totalNotification>0){%><%=totalNotification %><%} %></span></a>
<div class="notification_box pullDown">
<!--   <div class="text-right notification_txt"><a href="javascript:void(0)" onclick="markAllAsReadNotification()">Mark all as read</a></div> -->
  <div class="clearfix notification_inner_box">
 <%if(notifications!=null&&notifications.length>0){
	 for(int i=0;i<notifications.length;i++){
	 %>
      <div class="clearfix notification_inner">              	
        <a href="javascript:void(0)" onclick="markAsReadNotification('<%=notifications[i][2] %>')">
        <div class="clearfix pro_box">
            <div class="clearfix icon_box">
             <i class="<%=notifications[i][4] %> icon-circle" aria-hidden="true"></i>
            </div> 
            <div class="clearfix pro_info"> 
            <h6><%=notifications[i][3] %></h6>
            <div class="clearfix date_box1"><%=notifications[i][1] %></div>
            </div>
         </div>
        </a>
      </div>
      <%}}else{ %>
      <div class="text-center text-muted">No data found !!</div>
      <%} %>
  </div> 
  <div class="text-center notification_txt mtop10"><a href="<%=request.getContextPath()%>/notifications.html">View All &nbsp;<i class="fa fa-angle-right"></i></a></div> 
</div> 
</li>
<li class="mobilenoti" style="display:none">
<a href="<%=request.getContextPath()%>/notifications.html" onclick="markAllAsReadNotification('<%=totalNotification %>')"><span id="totalNotification">Notification<%if(totalNotification>0){%><small><%=totalNotification %></small><%} %></span></a>
</li>
</ul>
<div class="mobile-menu">
<a href="#" class="show-menu"><span class="lnr lnr-indent-decrease"></span></a>
<a href="#" class="hide-menu"><span class="lnr lnr-indent-increase"></span></a>
</div>
</nav>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<%
String urlpage = request.getParameter("uid");
if(urlpage==null||urlpage==""){
	urlpage=request.getParameter("page_no");
	if(urlpage==null||urlpage=="")urlpage="NA";
}
// System.out.println("pge=="+urlpage);
if(!urlpage.equalsIgnoreCase("managewebuser.html")&&!urlpage.equalsIgnoreCase("edituser.html")){
	session.removeAttribute("muname");
	session.removeAttribute("mumobile");
	session.removeAttribute("mutype");
}
if(!urlpage.equalsIgnoreCase("clientadmin.html")){
	session.removeAttribute("claname");
	session.removeAttribute("clamobile");
}
if(!urlpage.equalsIgnoreCase("manage-company.html")&&!urlpage.equalsIgnoreCase("editcompany.html")){
	session.removeAttribute("mcname");
	session.removeAttribute("mcfrom");
	session.removeAttribute("mcto");
}
if(!urlpage.equalsIgnoreCase("calendar.html")){
	session.removeAttribute("date_range_value");
}
if(!urlpage.equalsIgnoreCase("manage-employee.html")&&!urlpage.equalsIgnoreCase("editemployee.html")){
	session.removeAttribute("mename");
	session.removeAttribute("memobile");
	session.removeAttribute("meemail");
}
if(!urlpage.equalsIgnoreCase("Manage-Attendance.html")){
	session.removeAttribute("maEmpID");
	session.removeAttribute("maMonthDate");
	session.removeAttribute("mafrom");
	session.removeAttribute("mato");
}

if(!urlpage.equalsIgnoreCase("manage-billing.html")){
	session.removeAttribute("billingDateRangeAction");
	session.removeAttribute("billingClientName");
	session.removeAttribute("billingInvoiceNo");
	session.removeAttribute("billingDoAction");	
	session.removeAttribute("billingContactName");
}
if(!urlpage.equalsIgnoreCase("unbilled.html")){
	session.removeAttribute("unbillDateRangeAction");
	session.removeAttribute("unbill_no");
	session.removeAttribute("companyName");
	session.removeAttribute("unbillContactName");
	session.removeAttribute("archiveFilter");	
}
if(!urlpage.equalsIgnoreCase("all-invoice.html")){
	session.removeAttribute("invoiceDateRangeAction");
	session.removeAttribute("invoice_no");
	session.removeAttribute("invoicecompanyName");
	session.removeAttribute("invoicedContactName");
	session.removeAttribute("b2bb2c");
}
if(!urlpage.equalsIgnoreCase("manage-sales.html")){	        
	session.removeAttribute("salesInvoiceAction");
	session.removeAttribute("salesPhoneAction");
	session.removeAttribute("salesPhoneKeyAction");
	session.removeAttribute("salesProductAction");
	session.removeAttribute("salesClientAction");
	session.removeAttribute("salesContactAction");
	session.removeAttribute("salesSoldByAction");
	session.removeAttribute("salesSoldByUidAction");
	session.removeAttribute("salesDateRangeAction");
	session.removeAttribute("salesFilter");
}

if(!urlpage.equalsIgnoreCase("manage-template.html")){
	session.removeAttribute("templateDateRangeAction");
	session.removeAttribute("templateNameAction");
	session.removeAttribute("templateDoAction");
}
if(!urlpage.equalsIgnoreCase("manage-product.html")){
	session.removeAttribute("productDateRangeAction");
	session.removeAttribute("productIdAction");
	session.removeAttribute("productNameAction");
}
if(!urlpage.equalsIgnoreCase("manageteam.html")){
	session.removeAttribute("teamDateRangeAction");
	session.removeAttribute("teamNameDoAction");
	session.removeAttribute("teamDoAction");
}
if(!urlpage.equalsIgnoreCase("manage-client.html")&&!urlpage.equalsIgnoreCase("editclient.html")){
	session.removeAttribute("mclientname");
	session.removeAttribute("mclientmobile");
	session.removeAttribute("mclientlocation");
	session.removeAttribute("mclientfrom");
	session.removeAttribute("mclientto");
}

if(!urlpage.equalsIgnoreCase("manageaccount.html")&&!urlpage.equalsIgnoreCase("accountstatement.html")){
	session.removeAttribute("accountDateRangeAction");
	session.removeAttribute("accountSearchByClientName");
	session.removeAttribute("accountSearchByClientId");
}
if(!urlpage.equalsIgnoreCase("mytask.html")&&!urlpage.contains("edittask-")){
	session.removeAttribute("myTaskDateRange");
	session.removeAttribute("myTaskDoAction");
	session.removeAttribute("myTaskClientAction");
	session.removeAttribute("myTaskClientKeyAction");
	session.removeAttribute("myTaskContactAction");
	session.removeAttribute("myTaskServiceAction");
	session.removeAttribute("searchByActivity");
}
if(!urlpage.contains("edittask-")){
	session.removeAttribute("searchByActivity");
}
if(!urlpage.contains("assignmytask-")){
	session.removeAttribute("searchByActivity1");
}
if(!urlpage.equalsIgnoreCase("managedelivery.html")&&!urlpage.contains("assignmytask-")){
	session.removeAttribute("deliveryDateRangeAction");
	session.removeAttribute("deliveryDoAction");
	session.removeAttribute("deliveryInvoiceAction");
	session.removeAttribute("deliveryClientAction");
	session.removeAttribute("deliveryContactAction");
	session.removeAttribute("searchByActivity1");
}

if(!urlpage.equalsIgnoreCase("document-collection.html")){
	session.removeAttribute("collectionDateRangeAction");
	session.removeAttribute("collectionDoAction");
	session.removeAttribute("collectionInvoiceAction");
	session.removeAttribute("collectionClientAction");
	session.removeAttribute("collectionContactAction");
}

if(!urlpage.equalsIgnoreCase("manage-estimate.html")){
	session.removeAttribute("estimateContactAction");
	session.removeAttribute("estDoAction");
	session.removeAttribute("ClientNameDoAction");
	session.removeAttribute("estimateNoDoAction");
	session.removeAttribute("dateRangeDoAction");
}
if(!urlpage.equalsIgnoreCase("mydocument.html")&&!urlpage.contains("subdocuments-")&&!urlpage.contains("personalfiles-")){
	session.removeAttribute("mdclientname");
	session.removeAttribute("mdclientid");
	session.removeAttribute("mdfoldername");
	session.removeAttribute("mdprojectno");
	/* new */
	session.removeAttribute("doDocumentAction");
	session.removeAttribute("SearchByClientName");
	session.removeAttribute("SearchByClientId");
}
if(!urlpage.contains("personalfiles-")){
	session.removeAttribute("personalDoActionFiles");
	session.removeAttribute("pdocsortby_ord");
	session.removeAttribute("pdocsorting_order");
}
if(!urlpage.contains("documentfiles-")){
	session.removeAttribute("doActionFiles");
	session.removeAttribute("dcsortby_ord");
	session.removeAttribute("dcesorting_order");
}
if(!urlpage.equalsIgnoreCase("manageexpenses.html")){
	session.removeAttribute("expenseDateRangeAction");
	session.removeAttribute("expsortby_ord");
	session.removeAttribute("expClientName");
	session.removeAttribute("expContactMobile");
	session.removeAttribute("expsorting_order"); 
}
if(!urlpage.equalsIgnoreCase("download-history.html")){
	session.removeAttribute("history_page");
	session.removeAttribute("hisDateRangeDoAction");
}
if(!urlpage.equalsIgnoreCase("export-history.html")){
	session.removeAttribute("ex_history_page");
	session.removeAttribute("ex_hisDateRangeDoAction");
}
if(!urlpage.equalsIgnoreCase("manageguide.html")){
	session.removeAttribute("guideDateRangeAction");
	session.removeAttribute("guideProductAction");
	session.removeAttribute("guideProductKeyAction");
	session.removeAttribute("guideMilestoneAction");
}
if(!urlpage.equalsIgnoreCase("managetransactions.html")){
	session.removeAttribute("transactionDateRangeAction");
	session.removeAttribute("transactionClientNameAction");
	session.removeAttribute("transactionInvoiceAction");
	session.removeAttribute("transactionDoAction");
}
if(!urlpage.equalsIgnoreCase("managecredit.html")){
	session.removeAttribute("creditDateRangeAction");
}
if(!urlpage.equalsIgnoreCase("managetrigger.html")){
	session.removeAttribute("TriggerNameDoAction");
	session.removeAttribute("TriggerNoDoAction");
	session.removeAttribute("TriggerdateRangeDoAction");
}
if(!urlpage.equalsIgnoreCase("managecontacts.html")){
	session.removeAttribute("contactDateRangeAction");
	session.removeAttribute("contactCompanyNameAction");	
}
if(!urlpage.equalsIgnoreCase("certificates-renewal.html")){
	session.removeAttribute("certRenewalTaskDateRange");
}
if(!urlpage.equalsIgnoreCase("notifications.html")){
	session.removeAttribute("notificationPageLimit");
	session.removeAttribute("notificationPageStart");
	session.removeAttribute("notificationPageEnd");
	session.removeAttribute("notificationTaskDateRange");
}
if(!urlpage.equalsIgnoreCase("report.html")){
	session.removeAttribute("reportprojectNo");
	session.removeAttribute("reportAssigneeUid");
	session.removeAttribute("reportAssigneeName");
}
%>