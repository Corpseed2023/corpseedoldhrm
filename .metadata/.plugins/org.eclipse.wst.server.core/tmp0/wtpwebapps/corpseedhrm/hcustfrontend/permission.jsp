<!doctype html>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="hcustbackend.ClientACT"%> 
<html lang="en">
<head>  
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- for fakeloading -->
<%@ include file="includes/client-header-css.jsp" %>   
        
<title>Permissions</title>
</head>
<body id="mySite">
<!-- main content starts -->
<%@ include file="includes/checkvalid_client.jsp" %>
<%
//get token no from session 
String token=(String)session.getAttribute("uavalidtokenno");
String loginuaid = (String) session.getAttribute("loginuaid");
%>
<section class="main clearfix">
  <%@ include file="includes/client_header_menu.jsp" %>   
 <%if(userRole.equalsIgnoreCase("SUPER_USER")){  %>
  <section class=" payment clearfix">
    <div class="container-fluid">
      <div class="container">
       <div class="row">
        <div class="col-12 p-0">
          
          <div class="box_bg payment-box"> 
		  <div class="clearfix document_page">   
            
		  <div class="row mbt12 sticky_top">
		  <div class="col-lg-6 col-md-6 col-sm-12 col-12">
		
		  </div>
		  <div class="col-lg-6 col-md-6 col-sm-12 col-12">
          <div class="form-group-orders"> 
              <div class="m_width80 inbox_input">
              <input class="form-control-search" id="SearchOrder" type="search" placeholder="Search"  onsearch="removeSearchOption('ClientOrderSearchInvoice')"> 
              <i class="fa fa-search" aria-hidden="true"></i> 			
			  </div>
			  <i class="fas fa-long-arrow-alt-left" id="backico"></i>		  
			  
		  </div>
		  	<a href="javascript:void(0)" class="mobilesearchico"> <i class="fa fa-search " aria-hidden="true"></i> </a>
		  	<div class="pageheading">
          <h2>Payment</h2>
          </div>
		  </div>
		  </div>
		   <div class="row">
        <div class="col-sm-12 bg_whitee">
		<div class="row ">
		<div class="col-md-12">  
		<div class="table-responsive">
			<table class="ctable">
			    <thead>
			        <tr>
			            <th class="td_hide">S.No.</th>
			            <th>Name</th>
			            <th>Email</th>
			            <th>Mobile</th>
			            <th>Action</th>
			        </tr>
			    </thead>
			    <tbody>
			<%
			String[][] users=Usermaster_ACT.findAllUserBySuperUser(Integer.parseInt(loginuaid), token);
			if(users!=null&&users.length>0){
				for(int i=0;i<users.length;i++){
			%>    
			    <tr>
			    <td><%=(i+1) %></td>
			    <td><%=users[i][1] %></td>
			    <td><%=users[i][2] %></td>
			    <td><%=users[i][3] %></td>
			    <td class="list_action_box list_icon"><a href="#" class="icoo"><i class="fas fa-angle-down " aria-hidden="true"></i><i class="fa fa-angle-up "></i></a>
	            <ul class="dropdown_list">
	            <li><a class="pointers" href="">Edit</a></li>
	            <li><a class="pointers" href="">Permissions</a></li>
	            </ul>
			    </tr>
			<%}} %>    						                                    
			    </tbody>
			</table>
		</div>						
	  </div> 
	</div> 
	</div> 
		</div> 
        </div>
		</div>
	  </div>
	 </div>
    </div>
  </div>
</section> <%} %>
</section>
<%@ include file="includes/client-footer-js.jsp" %> 
</body>
<!-- body ends -->
</html>