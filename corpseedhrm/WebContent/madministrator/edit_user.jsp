<%@page import="admin.master.Usermaster_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>User Registration</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>


</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %> 
<%if(!ACU02){%><jsp:forward page="/login.html" /><%} %>
<%
String addedby= (String)session.getAttribute("loginuID");
String userrole= (String)session.getAttribute("emproleid");
String uid=(String) session.getAttribute("passid");
 
 boolean CLA001=false;
 boolean RD001=false;
 boolean ADM001=false;
 boolean AMU021=false;
 boolean ACU011=false;
 boolean ACU021=false;
 boolean ACU031=false;
 boolean ACU041=false;
 boolean ACU051=false;
 boolean LTH001=false;
 boolean MC001=false;
 boolean RC001=false;
 boolean MC011=false;
 boolean MC021=false;            
 boolean MC031=false;
 boolean MC041=false;
 boolean ME001=false;
 boolean RE001=false;
 boolean ME011=false;
 boolean ME021=false; 
 boolean ME031=false;
 boolean ME041=false;
 boolean ATT031=false;
 boolean ATT021=false; 
 boolean SAL041=false;
 boolean SAL001=false;            
 boolean SAL011=false;
 boolean SAL021=false;
 boolean SAL031=false;
 boolean SAL051=false; 
 boolean SAL061=false;
 boolean MSL001=false;
 boolean MSL011=false;
 boolean MSL021=false;
 boolean MSL031=false;
 boolean MSL041=false;
 boolean MTH001=false;
 boolean MTH011=false;            
 boolean MTH021=false;
 boolean MTH031=false;
 boolean MTH041=false;
 boolean MMH001=false;
 boolean MMH011=false;
 boolean MMH021=false;
 boolean MMH031=false;
 boolean MMH041=false; 
 boolean EQ001=false;
 boolean EQ011=false;
 boolean EQ021=false;              
 boolean MAS001=false;
 boolean MAS011=false;
 boolean EM021=false;
 boolean EM011=false;
 boolean EM031=false; 
 boolean EM041=false;
 boolean EM051=false;
 boolean EM061=false;
 boolean CL001=false;
 boolean CPR031=false;
 boolean CR011=false;
 boolean CR021=false;
 boolean CR031=false; 
 boolean CR041=false;             
 boolean CR051=false;
 boolean MT001=false;
 boolean MT011=false;
 boolean TN021=false;
 boolean MS081=false; 
 boolean MS071=false;
 boolean MNT001=false;
 boolean MNT011=false;
 boolean MNT021=false;
 boolean MS041=false;
 boolean MS031=false;
 boolean MST001=false;
 boolean MST011=false;
 boolean MST021=false;            
 boolean MS091=false;
 boolean SUC001=false;
 boolean SUC011=false;
 boolean SUC021=false; 
 boolean MS061=false;
 boolean MS051=false;
 boolean MCV001=false;
 boolean MCV011=false;
 boolean MCV021=false; 
 boolean SR011=false;
 boolean SR021=false;              
 boolean ACC001=false;
 boolean AC001=false;
 boolean ACC011=false;
 boolean ACC021=false;
 boolean ACC031=false;
 boolean MB071=false;
 boolean CB061=false; 
 boolean MB001=false;
 boolean MB091=false;
 boolean MB081=false;
 boolean MIN001=false;
 boolean MIN011=false;              
 boolean MIN021=false; 
 boolean MIN031=false;
 boolean GH001=false;
 boolean GH011=false;
 boolean MP021=false;
 boolean MP011=false; 
 boolean MP031=false;
 boolean MP041=false;
 boolean MP051=false;
 boolean TM001=false; 
 boolean MPP001=false;
 boolean MPP011=false;
 boolean MTT001=false; 
 boolean MTT011=false;
 boolean MTT021=false;
 boolean MTT031=false;
 boolean MTT041=false;
 boolean MTT051=false;      
 boolean MA001=false;
 boolean MMP001=false;
 boolean MMP011=false;
 boolean MMP021=false;
 boolean MMP031=false;
 boolean MMP041=false;
 boolean AMC001=false;
 boolean EST001=false;
 boolean EST011=false;
 boolean MD001=false;
 boolean MDC01=false;
 boolean MCC01=false;
 
 boolean MG001=false;
 boolean MTR01=false;
 boolean MTX01=false;
 boolean MTM01=false;
 boolean MCO01=false;
 
 boolean MX000=false;
 boolean CH000=false;
 boolean MCP00=false;
 boolean DH000=false;
 boolean EH000=false;
 boolean MCR01=false;
 boolean MTR11=false;
 boolean UBL00=false;
 boolean INV00=false;
 boolean DC001=false;
 boolean DOC001=false;
 boolean DTR001=false;
 boolean GI000=false;

String[][] userdata=Usermaster_ACT.getUserByID(uid); 
String euaValidAccess= userdata[0][8];
if(euaValidAccess!=null){
String[] getempaccessesL=euaValidAccess.split("#");
for(int ur=0;ur<getempaccessesL.length;ur++)
{           
	if(getempaccessesL[ur].equalsIgnoreCase("ADM00")){ADM001=true;}	
	else if(getempaccessesL[ur].equalsIgnoreCase("RD00")){RD001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MCP0")){MCP00=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("DH00")){DH000=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EH00")){EH000=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MG00")){MG001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTR0")){MTR01=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTX0")){MTX01=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTM0")){MTM01=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MCO0")){MCO01=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("DC00")){DC001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("DOC00")){DOC001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("DTR00")){DTR001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MDC0")){MDC01=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MCC0")){MCC01=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MD00")){MD001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EST00")){EST001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EST01")){EST011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("CLA00")){CLA001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("AMU02")){AMU021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ACU01")){ACU011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ACU02")){ACU021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ACU03")){ACU031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ACU04")){ACU041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ACU05")){ACU051=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("LTH00")){LTH001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MC00")){MC001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("RC00")){RC001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MC01")){MC011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MC02")){MC021=true;}	           
	else if(getempaccessesL[ur].equalsIgnoreCase("MC03")){MC031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MC04")){MC041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ME00")){ME001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("RE00")){RE001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ME01")){ME011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ME02")){ME021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ME03")){ME031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ME04")){ME041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ATT03")){ATT031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ATT02")){ATT021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SAL04")){SAL041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SAL00")){SAL001=true;}	           
	else if(getempaccessesL[ur].equalsIgnoreCase("SAL01")){SAL011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SAL02")){SAL021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SAL03")){SAL031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SAL05")){SAL051=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SAL06")){SAL061=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MSL00")){MSL001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MSL01")){MSL011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MSL03")){MSL031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MSL04")){MSL041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTH00")){MTH001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTH01")){MTH011=true;}	          
	else if(getempaccessesL[ur].equalsIgnoreCase("MTH02")){MTH021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTH03")){MTH031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTH04")){MTH041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMH00")){MMH001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMH01")){MMH011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMH02")){MMH021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMH03")){MMH031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMH04")){MMH041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EQ00")){EQ001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EQ02")){EQ021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EQ01")){EQ011=true;}	             
	else if(getempaccessesL[ur].equalsIgnoreCase("MAS00")){MAS001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MAS01")){MAS011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EM02")){EM021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EM01")){EM011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EM03")){EM031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EM04")){EM041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EM05")){EM051=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("EM06")){EM061=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("CL00")){CL001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("CPR03")){CPR031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("CR01")){CR011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("CR02")){CR021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("CR03")){CR031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("CR04")){CR041=true;}	            
	else if(getempaccessesL[ur].equalsIgnoreCase("CR05")){CR051=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MT00")){MT001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MT01")){MT011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("TN02")){TN021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MS08")){MS081=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MS07")){MS071=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MNT00")){MNT001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MNT01")){MNT011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MNT02")){MNT021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MS04")){MS041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MS03")){MS031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MST00")){MST001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MST01")){MST011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MST02")){MST021=true;}	          
	else if(getempaccessesL[ur].equalsIgnoreCase("MS09")){MS091=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SUC00")){SUC001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SUC01")){SUC011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SUC02")){SUC021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MS06")){MS061=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MS05")){MS051=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MCV00")){MCV001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MCV01")){MCV011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MCV02")){MCV021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SR01")){SR011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("SR02")){SR021=true;}	             
	else if(getempaccessesL[ur].equalsIgnoreCase("ACC00")){ACC001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("AC00")){AC001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ACC01")){ACC011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ACC02")){ACC021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("ACC03")){ACC031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MB07")){MB071=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("CB06")){CB061=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MB00")){MB001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MB09")){MB091=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MB08")){MB081=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MIN00")){MIN001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MIN01")){MIN011=true;}	             
	else if(getempaccessesL[ur].equalsIgnoreCase("MIN02")){MIN021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MIN03")){MIN031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("GH00")){GH001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("GH01")){GH011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MP02")){MP021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MP01")){MP011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MP03")){MP031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MP04")){MP041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MP05")){MP051=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("TM00")){TM001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MPP00")){MPP001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MPP01")){MPP011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTT00")){MTT001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTT01")){MTT011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTT02")){MTT021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTT03")){MTT031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTT04")){MTT041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTT05")){MTT051=true;}	    
	else if(getempaccessesL[ur].equalsIgnoreCase("MA00")){MA001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMP00")){MMP001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMP01")){MMP011=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMP02")){MMP021=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMP03")){MMP031=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MMP04")){MMP041=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("AMC00")){AMC001=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MX00")){MX000=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("GI00")){GI000=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("CH00")){CH000=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MCR0")){MCR01=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("MTR1")){MTR11=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("UBL0")){UBL00=true;}
	else if(getempaccessesL[ur].equalsIgnoreCase("INV0")){INV00=true;}
}
}
%>
<div id="content">
	<div class="container">   
         <div class="bread-crumb">
           <div class="bd-breadcrumb bd-light">
           <a href="">Home</a>           
           <a>Edit User Registration</a>
           </div>
           <a href="<%=request.getContextPath()%>/managewebuser.html"><button class="bkbtn" style="float:right;">Back</button></a>
         </div>
       </div>

	<div class="main-content">
		<div class="container">
			<div class="row">
			<form action="<%=request.getContextPath() %>/updateuser.html" method="post" id="usercreate" name="usercreate">
<div class="col-md-4 col-sm-4 col-xs-12">
       <div class="menuDv  post-slider">
             <div class="row">
               <div class="col-md-12 col-sm-12 col-xs-12">
               <div class="form-group">
                 <div class="input-group">
                <select name="uaroletype" id="Role_Type" class="form-control">
				<option value="<%=userdata[0][14] %>"><%=userdata[0][14] %></option>
 				</select>
 </div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12" id="DepartmentDivBoxId">
<div class="form-group">
<div class="input-group">
<select id="Department" name="department" class="form-control" onchange="setUserRole(this.value)">
	<option value="<%=userdata[0][16] %>"><%=userdata[0][16] %></option>
	<option value="Sales">Sales</option>
	<option value="Delivery">Delivery</option>
	<option value="Account">Account</option>
	<option value="HR">HR</option>
	<option value="Document">Document</option>
</select>
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12" id="RoleDivBoxId">
<div class="form-group">
<div class="input-group">
<select id="UserRegRole" name="UserRegRole" class="form-control" onchange="setPermissions(this.value)">
	<option value="<%=userdata[0][17] %>"><%=userdata[0][17] %></option>
</select>
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
 <input type="hidden" name="addedbyuser" value="<%=addedby%>">
<input type="hidden" name="uid" value="<%=uid%>">
<div class="input-group">
<input readonly type="text" name="userName" id="User_Name" placeholder="Name !!" autocomplete="off" value="<%=userdata[0][5] %>" class="form-control">
<input type="hidden" name="emuid" id="emuid" value="NA">
</div>
<div id="UserNameEerorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <div class="input-group">
<input type="text" name="userId" id="UsernameID" value="<%=userdata[0][2] %>" placeholder="Username !!" onchange="isExistValue('UsernameID','<%=userdata[0][0] %>');" onblur="validateUserNamePopup('UsernameID')" class="form-control">
  </div>
   </div>
  </div>
  <div class="col-md-12 col-sm-12 col-xs-12">
  <div class="form-group">
    <label>Password :<span style="color: red;">*</span></label>
    <div class="input-group">
    <span class="input-group-addon"><i class="form-icon sprite password"></i></span>
<input type="password" name="userPassword" id="User_Password" value="<%=userdata[0][4] %>" placeholder="Enter Password*" onblur="requiredFieldValidation('User_Password','pwdErrorMSGdiv');" class="form-control">
 <span class="show_psw" onclick="myFunction()">
<i class="fa fa-eye-slash" style="font-size:15px;color:#006080"></i>
</span>
 </div>
<div id="pwdErrorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12 advert text-center">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return addUser();">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
</div>
</div>
                      
</div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
<%if(!userdata[0][14].equalsIgnoreCase("Client")){ %>
<div class="menuDv clearfix">
    <fieldset>
<div class="box-intro">
<div class="allselect_checkbox txt_orange"><input type="checkbox" id="checkall1"/><span class="access-txt"><b>Select All</b></span></div>
<h2><span class="title">Access Permissions</span></h2>
</div>
<div class="clearfix">

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" onclick="selectAllPermissions('HRMainId','HRSubId')" id="HRMainId" value="ADM00"<%if(ADM001){%> checked<%}%>><span class="access-txt"><b>HR</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="HRSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="AMU02"<%if(AMU021){%> checked<%}%>><span class="access-txt">Manage HRM Login</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACU01"<%if(ACU01){%> checked<%}%>><span class="access-txt">Register HRM Login</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACU02"<%if(ACU021){%> checked<%}%>><span class="access-txt">Edit Login</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACU03"<%if(ACU031){%> checked<%}%>><span class="access-txt">Change Password</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="ACU04"<%if(ACU041){%> checked<%}%>><span class="access-txt">Activate/Deactivate</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="ACU05"<%if(ACU051){%> checked<%}%>><span class="access-txt">Delete Login's</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-6 col-sm-6 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="LTH00"<%if(LTH001){%> checked<%}%>> <span class="access-txt">Login & Traffic History</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MC00"<%if(MC001){%> checked<%}%>><span class="access-txt">Manage Company</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="RC00"<%if(RC001){%> checked<%}%>><span class="access-txt">Register Company</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MC01"<%if(MC011){%> checked<%}%>><span class="access-txt">View Company</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MC02"<%if(MC021){%> checked<%}%>><span class="access-txt">Edit Company</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MC03"<%if(MC031){%> checked<%}%>><span class="access-txt">Activate/Deactivate</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MC04"<%if(MC041){%> checked<%}%>><span class="access-txt">Delete Company</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ME00"<%if(ME001){%> checked<%}%>><span class="access-txt">Manage Employee</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="RE00"<%if(RE001){%> checked<%}%>><span class="access-txt">Register Employee</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ME01"<%if(ME011){%> checked<%}%>><span class="access-txt">View Employee</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ME02"<%if(ME021){%> checked<%}%>><span class="access-txt">Edit Employee</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="ME03"<%if(ME031){%> checked<%}%>><span class="access-txt">Activate/Deactivate</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="ME04"<%if(ME041){%> checked<%}%>><span class="access-txt">Delete Employee</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ATT03"<%if(ATT031){%> checked<%}%>> <span class="access-txt">Manage Attendance</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ATT02"<%if(ATT021){%> checked<%}%>> <span class="access-txt">Add Attendance</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-6 col-sm-6 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CLA00"<%if(CLA001){%> checked<%}%>> <span class="access-txt">Manage Client's Admin</span>
</div>
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" onclick="selectAllPermissions('SalesMainId','SalesSubId')" id="SalesMainId" value="EQ00" <%if(EQ001){%> checked<%}%>><span class="access-txt"><b>Manage Sales</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="SalesSubId" style="display: none;">
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="EST00" <%if(EST001){%> checked<%}%>><span class="access-txt">Manage Estimate</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="EST01" <%if(EST011){%> checked<%}%>><span class="access-txt">Add Estimate</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="EQ02"<%if(EQ021){%> checked<%}%>><span class="access-txt">Manage Sales</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="EQ01"<%if(EQ01){%> checked<%}%>><span class="access-txt">Register Payment</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MAS00"<%if(MAS001){%> checked<%}%>><span class="access-txt">Documents</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MAS01"<%if(MAS011){%> checked<%}%>><span class="access-txt">Task History</span>
</div>
<!-- <div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="EM02"<%if(EM021){%> checked<%}%>><span class="access-txt">Follow Up Sale</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="EM01"<%if(EM011){%> checked<%}%>><span class="access-txt">View Sale</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="EM03"<%if(EM031){%> checked<%}%>><span class="access-txt">Edit Sale</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="EM04"<%if(EM041){%> checked<%}%>><span class="access-txt">Delete Sale</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="EM05"<%if(EM051){%> checked<%}%>><span class="access-txt">Send SMS/Email</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="EM06"<%if(EM061){%> checked<%}%>><span class="access-txt">Show All Sales</span>
</div>-->
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" id="DocumentCollectionId" onclick="selectAllPermissions('DocumentCollectionId','CheckDocument')" name="privilege" value="DC00" <%if(DC001){%>checked<%}%>><span class="access-txt"><b>Document</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="CheckDocument" style="display: none;">
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="DOC00" <%if(DOC001){%> checked<%}%>><span class="access-txt">Document Collection</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="DTR00" <%if(DTR001){%> checked<%}%>><span class="access-txt">Track Service</span>
</div>
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" onclick="selectAllPermissions('ClientMainId','ClientSubId')" id="ClientMainId" value="CL00"<%if(CL001){%> checked<%}%>><span class="access-txt"><b>Client Master</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="ClientSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CPR03"<%if(CPR031){%> checked<%}%>><span class="access-txt">Manage Client</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CR01"<%if(CR011){%> checked<%}%>><span class="access-txt">Client Registration</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CR02"<%if(CR021){%> checked<%}%>><span class="access-txt">Upload Documents</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CR03"<%if(CR031){%> checked<%}%>><span class="access-txt">Edit Client</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="CR04"<%if(CR041){%> checked<%}%>><span class="access-txt">Activate/Deactivate</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="CR05"<%if(CR051){%> checked<%}%>><span class="access-txt">Delete Client</span>
</div>
</div>
<%-- <div class="clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CMP04"<%if(CMP041){%> checked<%}%>><span class="access-txt">Manage Project</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CM02"<%if(CM021){%> checked<%}%>><span class="access-txt">Project Registration</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CM03"<%if(CM031){%> checked<%}%>><span class="access-txt">Set Price</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CM04"<%if(CM041){%> checked<%}%>><span class="access-txt">Set Milestone</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="CM05"<%if(CM051){%> checked<%}%>><span class="access-txt">Assign Task</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="CM06"<%if(CM061){%> checked<%}%>><span class="access-txt">Follow Up Project</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="CM07"<%if(CM071){%> checked<%}%>><span class="access-txt">Edit Project</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="CM08"<%if(CM081){%> checked<%}%>><span class="access-txt">Activate/Deactivate</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="CM09"<%if(CM091){%> checked<%}%>><span class="access-txt">Delete Project</span>
</div>
</div> --%>
</div>


<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" onclick="selectAllPermissions('MyTaskMainId','MyTaskSubId')" id="MyTaskMainId" value="MT00"<%if(MT001){%> checked<%}%>><span class="access-txt"><b>My Task</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="MyTaskSubId" style="display: none;">
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="MyTaskDetails" value="MT01"<%if(MT011){%> checked<%}%>><span class="access-txt">My Task Details</span>
</div>
<%-- <div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MT03"<%if(MT031){%> checked<%}%>><span class="access-txt">Edit Task</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MT04"<%if(MT041){%> checked<%}%>><span class="access-txt">Follow-Up Task</span>
</div> --%>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="ManageDelivery" value="MD00"<%if(MD001){%> checked<%}%>><span class="access-txt">Manage Delivery</span>
</div>
</div>
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="ManageDocument" value="MDC0"<%if(MDC01){%> checked<%}%>><span class="access-txt">Manage Document</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="Calendar" value="MCC0"<%if(MCC01){%> checked<%}%>><span class="access-txt">Calendar</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="Calendar" value="MCR0"<%if(MCR01){%> checked<%}%>><span class="access-txt">Certificate renewal</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="Calendar" value="MTR1"<%if(MTR11){%> checked<%}%>><span class="access-txt">Manage Report</span>
</div>
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" onclick="selectAllPermissions('AccountMainId','AccountSubId')" id="AccountMainId" value="ACC00"<%if(ACC001){%> checked<%}%>><span class="access-txt"><b>Account</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>


<div class="clearfix access_box_info" id="AccountSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="AC00"<%if(AC001){%> checked<%}%>><span class="access-txt">Client's Account</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACC01"<%if(ACC011){%> checked<%}%>><span class="access-txt">View Statement</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACC02"<%if(ACC021){%> checked<%}%>><span class="access-txt">Employee's Account</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACC03"<%if(ACC031){%> checked<%}%>><span class="access-txt">View Statement</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MB07"<%if(MB071){%> checked<%}%>><span class="access-txt">Project Billing</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CB06"<%if(CB061){%> checked<%}%>><span class="access-txt">Mark As Paid</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MB00"<%if(MB001){%> checked<%}%>><span class="access-txt">Register Payment</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="AMC00"<%if(AMC001){%> checked<%}%>><span class="access-txt">Payment History</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MB09"<%if(MB091){%> checked<%}%>><span class="access-txt">Payroll</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="GH00"<%if(GH001){%> checked<%}%>><span class="access-txt">Manage Transactions</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="GI00"<%if(GI000){%> checked<%}%>><span class="access-txt">Manage Invoice</span>
</div>
</div>

<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MX00"<%if(MX000){%> checked<%}%>><span class="access-txt">Manage Expense</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CH00"<%if(CH000){%> checked<%}%>><span class="access-txt">Credit history</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="UBL0"<%if(UBL00){%> checked<%}%>><span class="access-txt">Unbilled</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="INV0"<%if(INV00){%> checked<%}%>><span class="access-txt">Invoiced</span>
</div>
</div>

</div>
<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" id="ActivityMasterId" onclick="selectAllPermissions('ActivityMasterId','ActivityMasterSubId')" value="TM00"<%if(TM001){%> checked<%}%>><span class="access-txt"><b>Activity Master</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="ActivityMasterSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MPP00"<%if(MPP001){%> checked<%}%>><span class="access-txt">Manage Product</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MPP01"<%if(MPP011){%> checked<%}%>><span class="access-txt">Add Product</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTT00"<%if(MTT001){%> checked<%}%>><span class="access-txt">Manage Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTT01"<%if(MTT011){%> checked<%}%>><span class="access-txt">Add SMS Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTT02"<%if(MTT021){%> checked<%}%>><span class="access-txt">Add Email Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTT03"<%if(MTT031){%> checked<%}%>><span class="access-txt">View Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MTT04"<%if(MTT041){%> checked<%}%>><span class="access-txt">Edit Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MTT05"<%if(MTT051){%> checked<%}%>><span class="access-txt">Delete Template</span>
</div>
</div>
	<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
			<div class="col-md-3 col-sm-3 col-xs-12">
			<input type="checkbox" name="privilege" id="privilege" value="MG00"<%if(MG001){%> checked<%}%>><span class="access-txt">Manage Guide</span>
			</div>
			<div class="col-md-3 col-sm-3 col-xs-12">
			<input type="checkbox" name="privilege" id="privilege" value="MTR0"<%if(MTR01){%> checked<%}%>><span class="access-txt">Manage Trigger</span>
			</div>
			<div class="col-md-3 col-sm-3 col-xs-12">
			<input type="checkbox" name="privilege" id="privilege" value="MTX0"<%if(MTX01){%> checked<%}%>><span class="access-txt">Manage Tax</span>
			</div>
			<div class="col-md-3 col-sm-3 col-xs-12">
			<input type="checkbox" name="privilege" id="privilege" value="MTM0"<%if(MTM01){%> checked<%}%>><span class="access-txt">Manage Teams</span>
			</div>    

    </div>
  <div class="clearfix advert">
		<div class="col-md-3 col-sm-3 col-xs-12">
		<input type="checkbox" name="privilege" id="privilege" value="MCO0"<%if(MCO01){%> checked<%}%>><span class="access-txt">Manage Contacts</span>
		</div> 
  		<div class="col-md-3 col-sm-3 col-xs-12">
		<input type="checkbox" name="privilege" id="privilege" value="MCP0"<%if(MCP00){%> checked<%}%>><span class="access-txt">Manage Coupon</span>
		</div> 
  </div>
</div>
<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" id="RecordsMasterId" onclick="selectAllPermissions('RecordsMasterId','RecordsMasterSubId')" value="RD00" <%if(RD001){%> checked<%}%>><span class="access-txt"><b>Records</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="RecordsMasterSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="DH00"<%if(DH000){%> checked<%}%>><span class="access-txt">Download History</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="EH00"<%if(EH000){%> checked<%}%>><span class="access-txt">Export History</span>
</div>
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" onclick="selectAllPermissions('ProfileMainId','ProfileSubId')" id="ProfileMainId" value="MA00" checked="checked"><span class="access-txt"><b>Profile</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="ProfileSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MMP00"<%if(MMP001){%> checked<%}%>><span class="access-txt">My Profile</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MMP04"<%if(MMP041){%> checked<%}%>><span class="access-txt">Edit Profile</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MMP01"<%if(MMP011){%> checked<%}%>><span class="access-txt">Work Scheduler</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MMP02"<%if(MMP021){%> checked<%}%>><span class="access-txt">Change Password</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MMP03" checked="checked"><span class="access-txt">LogOut</span>
</div>
</div>
</div>
</div>
</fieldset>
          </div>
          <%} %>
         </div>
        </form>
		</div>
	</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
	<script type="text/javascript">
$('[id^=checkall]').click(
		function() {
			if (this.checked)
				$(this).closest('fieldset').find('input').prop('checked','checked');
			else
				$(this).closest('fieldset').find('input').prop('checked','');
		});
</script>
<script type="text/javascript">
function selectAllPermissions(permissionId,subpermissionid){
	if($("#"+permissionId).prop('checked') == true){
	    //remove all permissions
		$("#"+subpermissionid).find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}else{
		$("#"+subpermissionid).find('input[type=checkbox]').each(function () {
            this.checked = false;
       }); 
	}
}
function setUserRole(dept){
	if(dept==""){
		$("#UserRegRole").empty();
		$("#UserRegRole").append("<option value=''>"+"Select Role"+"</option>");
	}else{
		if(dept=="Account"){
			$("#UserRegRole").empty();
			$("#UserRegRole").append("<option value=''>"+"Select Role"+"</option>");
			$("#UserRegRole").append("<option value='Accountant'>"+"Accountant"+"</option>");
		}else if(dept=="Delivery"||dept=="Sales"){
			$("#UserRegRole").empty();
			$("#UserRegRole").append("<option value=''>"+"Select Role"+"</option>");
			$("#UserRegRole").append("<option value='Executive'>"+"Executive"+"</option>");
			$("#UserRegRole").append("<option value='Assistant'>"+"Assistant"+"</option>");
			$("#UserRegRole").append("<option value='Manager'>"+"Manager"+"</option>");
		}else if(dept=="HR"){
			$("#UserRegRole").empty();
			$("#UserRegRole").append("<option value=''>"+"Select Role"+"</option>");
			$("#UserRegRole").append("<option value='Executive'>"+"Executive"+"</option>");
		}else if(dept=="Document"){						
			$("#UserRegRole").append("<option value='Manager'>"+"Manager"+"</option>");
			$("#UserRegRole").append("<option value='Executive'>"+"Executive"+"</option>");
		}
	}
	
}
function setPermissions(role){
	var department=$("#Department").val();
	if(department!=""&&role!=""){
		//remove all checked permissions
		$('input:checkbox').removeAttr('checked');
		 //check profile section
	    $("#ProfileMainId").prop("checked",true);
	    $("#ProfileSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       });
	}else{
		//remove all checked permissions
		$('input:checkbox').removeAttr('checked');
	}
	if(department=="Sales"&&(role=="Executive"||role=="Assistant")){		
		//check sales section
		$("#SalesMainId").prop("checked",true);
	    $("#SalesSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       });	   
	}else if(department=="Sales"&&role=="Manager"){
		//check sales section
		$("#SalesMainId").prop("checked",true);
	    $("#SalesSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       });	   
	  //check client section
	    $("#ClientMainId").prop("checked",true);
	    $("#ClientSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}else if(department=="Delivery"&&(role=="Assistant"||role=="Manager")){
		//check my task section
		$("#MyTaskMainId").prop("checked",true);
	    $("#MyTaskSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       });	   
	}else if(department=="Delivery"&&role=="Executive"){
		//check my task section   
		$("#MyTaskMainId").prop("checked",true);
		$("#MyTaskDetails").prop("checked",true);
		$("#ManageDocument").prop("checked",true);
		$("#Calendar").prop("checked",true);
	}else if(department=="Account"&&role=="Accountant"){
		  //check account section
	    $("#AccountMainId").prop("checked",true);
	    $("#AccountSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}else if(department=="HR"&&role=="Executive"){
		  //check hr section
	    $("#HRMainId").prop("checked",true);
	    $("#HRSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}else if(department=="Document"&&(role=="Manager" || role=="Executive")){
		  //check hr section
	    $("#DocumentCollectionId").prop("checked",true);
	    $("#CheckDocument").find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}
}
function checkname(){
var role = document.getElementById("uaroletype").value;
if(role == "Client"){
$(function() {
$("#UserName").autocomplete({
source : function(request, response) {
$.ajax({
url : "getclientname.html",
type : "POST",
dataType : "json",
data : {
name : request.term
},
success : function(data) {
response($.map(data, function(item) {
return {
label: item.name,
value: item.value,
cid: item.cid,
};}));},
error: function (error) {
alert('error: ' + error);
}});},
select : function(e, ui) {
	$("#emuid").val(ui.item.cid);
}
});});}
else if(role=="Employee") {
$(function() {
$("#UserName").autocomplete({
source : function(request, response) {
$.ajax({
url : "get-employee.html",
type : "POST",
dataType : "json",
data : {
name : request.term
},
success : function(data) {
response($.map(data, function(item) {
return {
label : item.emname,
value : item.emname,
emuid : item.emuid,
};}));},
error : function(error) {
alert('error: ' + error);
}});},
select : function(e, ui) {
	$("#emuid").val(ui.item.emuid);
}
});});}
else if(role=="Super Admin"){
	document.getElementById("CompanyName").value="NA";
	$('#CompanyName').prop('readonly', true);
}
}
</script>
<script type="text/javascript">
	function addUser(){
		if($('#Role_Type').val().trim()=="") {
			document.getElementById("errorMsg").innerHTML="Please select Role Type.";				
			$('.alert-show').show().delay(2000).fadeOut();
		return false;
		}else if($('#Role_Type').val().trim()!="Client"){
			if($('#Department').val().trim()=="") {
				document.getElementById("errorMsg").innerHTML="Please  select department.";				
				$('.alert-show').show().delay(2000).fadeOut();
			return false;
			}
			if($('#UserRegRole').val().trim()=="") {
				document.getElementById("errorMsg").innerHTML="Please select role.";				
				$('.alert-show').show().delay(2000).fadeOut();
			return false;
			}		
		}
		if($('#UsernameID').val().trim()=="") {
			document.getElementById("errorMsg").innerHTML="Please enter username.";				
			$('.alert-show').show().delay(2000).fadeOut();
		return false;
		}	
		if($('#User_Password').val().trim()=="") {
			document.getElementById("errorMsg").innerHTML="Please enter a strong password.";				
			$('.alert-show').show().delay(2000).fadeOut();
		return false;
		}
		showLoader();
	/* 	var group = document.usercreate.privilege;
		for (var i=0; i<group.length; i++) {
		if (group[i].checked)
		break;
		}
		if (i==group.length){
			alert("No prevlage is checked");
		return false; 
		} */
}
	function isExistValue(value,id){
		var val=document.getElementById(value).value.trim();
		if(val!="")
		$.ajax({
			type : "POST",
			url : "ExistEditValue111",
			dataType : "HTML",
			data : {"val":val,"field":"ualoginid","id":id},
			success : function(data){
				if(data=="pass"){
					document.getElementById("errorMsg").innerHTML=val +" is already existed !! Please Login to access!!";		
					document.getElementById(value).value="";
					$('.alert-show').show().delay(3000).fadeOut();	
				}
				
			}
		});
	}
	
	
	
	function myFunction() {
		  var x = document.getElementById("User_Password");
		  if (x.type == "password") {
		    x.type = "text";
		  } else {
		    x.type = "password";
		    
		  }
		}
	$('.show_psw').click(function(event){
		//event.preventDefault();
		$(this).toggleClass('active');
	});
</script>
</body>
</html>