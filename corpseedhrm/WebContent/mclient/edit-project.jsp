<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Project Registration</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%	
	String token=(String)session.getAttribute("uavalidtokenno");
String addedby= (String)session.getAttribute("loginuID");
String uid=(String) session.getAttribute("passid");
String[][] projectdata=Clientmaster_ACT.getProjectByID(uid,token);
String[][] servicetype=TaskMaster_ACT.getAllServiceType(token);
%>
<%-- <%if(!CM07){%><jsp:forward page="/login.html" /><%} %> --%>
    
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Project Registration</a>
            </div><a href="<%=request.getContextPath()%>/manage-project.html"><button class="bkbtn" style="margin-left:879px;">Back</button></a>
          </div>
        </div>
		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv  post-slider">
                            <form action="update-project.html" method="post" id="RegisteruserProject" name="RegisteruserProject">
                              <div class="row">
                              <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Project's No. :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite fa fa-chrome"></i></span>
                                  <input type="text" name="ProjectNo" id="Project No"value="<%=projectdata[0][6]%>" readonly placeholder="Enter Project No" onblur="requiredFieldValidation('Project No','ProjectNoEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ProjectNoEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>                              
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <input type="hidden" name="addedbyuser" value="<%=addedby%>">
                                 <input type="hidden" name="uid" value="<%=uid%>">
                                 <input type="hidden" readonly name="cid" id="cid" value="<%=projectdata[0][7]%>">
                                  <label>Client's Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" name="clientName" id="Client_Name" autocomplete="off" value="<%=projectdata[0][1]%>" placeholder="Enter Client Name" onblur="requiredFieldValidation('Client_Name','ClientNameEerorMSGdiv');" class="form-control" readonly="readonly">
                                  </div>
                                  <div id="ClientNameEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>                              
                                 <div class="col-md-3 col-sm-3 col-xs-12">
                     <div class="form-group">
                      <label>Product Type :<span style="color: red;">*</span></label>
                  <div class="input-group">
                  <span class="input-group-addon"><i class="form-icon sprite checked"></i></span>
                  <select id="Service_Type" name="serviceType" class="form-control" onchange="getProducts(this.value)">
                  <option value="<%=projectdata[0][11]%>"><%=projectdata[0][11]%></option>
                    <option value="">Select Product Type</option>
                    <%for(int i=0;i<servicetype.length;i++){ %>
                       <option value="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></option>
                    <%} %>
					</select>
				</div>
   <div id="serviceTypeErrorMSGdiv" class="errormsg"></div>
  </div>
 </div>
                                   <%
                                String[][] projects=Clientmaster_ACT.getProjects(projectdata[0][11],token);
                               
                                %>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Product :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite list"></i></span>
								<select id="Project_Type" name="ProjectType" class="form-control" onblur="requiredFieldValidation('Project_Type','ProjectTypeEerorMSGdiv');" onchange="getRemarks(this.value);getBuildingTime();">
          								<option value="<%=projectdata[0][3]%>"><%=projectdata[0][3]%></option>
          								<option value="">Select Product</option>    
          								<%if(projects.length>0){ for(int i=0;i<projects.length;i++){%>
							            <option value="<%=projects[i]%>"><%=projects[i]%></option><%}} %>
							            <option value="Customize" style="color: blue;">Customize</option>   							                                           
								</select>
								<input type="hidden" name="pid" id="pid" value="NA">
								<input type="hidden" name="buildingtime" id="buildingtime" value="<%=projectdata[0][10]%>">
                                  </div>
                                  <div id="ProjectTypeEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                
                                </div>
                              <div class="row">
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Project's Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" name="ProjectName" id="Project Name"value="<%=projectdata[0][2]%>" placeholder="Enter Project Name" onblur="requiredFieldValidation('Project Name','ProjectNameEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ProjectNameEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Starting Date :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="StartingDate" value="<%=projectdata[0][4]%>"id="StartingDate" placeholder="DD-MM-YYYY" onchange="getDeliveryDate(this.value)" class="form-control readonlyAllow" readonly="readonly">
                                  </div>
                                  <div id="StartingDateErrorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12" id="Delivery_Date">
                                <div class="form-group">
                                  <label>Delivery Date/Time :<span style="color: red;">*</span></label>
                                  <div class="clearfix">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
                                  <input type="text" name="DeliveryDate" id="DeliveryDate" value="<%=projectdata[0][5]%>" placeholder="Delivery Date" class="datetimepicker form-control readonlyAllow" data-date-format="dd-mm-yyyy  HH:ii p" readonly="readonly">
                                  </div>
                                  <div id="DeliveryDateErrorMSGdiv" class="errormsg"></div>
                                  </div>
                                </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12" style="margin-top: 27px;">
								   <input type="checkbox" style="width: 20px;height: 20px;cursor: pointer;"<%if(projectdata[0][13].equalsIgnoreCase("1")){ %> checked="checked"<%} %> id="CheckedBox"><span style="margin-top: 4px;position: absolute;font-size: 13px;margin-left: 8px;width: 151px;color: #4ac4f3;">Work Based On Payment</span>
								   <input type="hidden" name="paymentbased" id="PaymentBased" value="0"/>
								</div>
                             </div>                             
                                <div class="row">
                             <div class="col-md-12 col-sm-12 col-xs-12">
                                <div class="form-group">
                                  <label>Remarks :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <textarea name="Remarks" id="Remarks" onblur="requiredFieldValidation('Remarks','RemarksEerorMSGdiv');" class="form-control"><%=projectdata[0][9]%></textarea>
                                  </div>
                                  <div id="RemarksErrorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                </div>
                              <div class="row">
                                <div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
                                <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return registerProject();" >Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
                                </div>
                              </div>
                            </form>
                        </div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
    <script>
    $( function() {
		$( "#StartingDate" ).datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: 'dd-mm-yy'
		});
    });
 </script>
 <script type="text/javascript">
 function getProducts(servicetype){
		if(servicetype!="")
		$.ajax({
			type : "POST",
			url : "GetServiceType111",
			dataType : "HTML",
			data : {				
				"servicetype":servicetype,
			},
			success : function(data){
				$("#Project_Type").empty();
			    $("#Project_Type").append("<option value=''>"+"Select Product"+"</option>");		    
				var x=data.split("@");			
				for(var i=0;i<x.length;i++){
					$("#Project_Type").append("<option value='"+x[i]+"'>"+x[i]+"</option>");
				}
				$("#Project_Type").append("<option value='Customize'>"+"Customize"+"</option>");
			}
		});else{
			$("#Project_Type").empty();
		    $("#Project_Type").append("<option value=''>"+"Select Product"+"</option>");	   
		}
	}
 
 
bkLib.onDomLoaded(function() {
    nicEditors.editors.push(
        new nicEditor().panelInstance(
            document.getElementById('Remarks')
        )
    );
});
</script>
<script type="text/javascript"> 
function getDeliveryDate(date){
	if(document.getElementById("Project_Type").value.trim()==""){
		ProjectTypeEerorMSGdiv.innerHTML="Select Project Type First !!";
		ProjectTypeEerorMSGdiv.style.color="red";		
		document.getElementById("StartingDate").value="";
	}else{
		var buildingtime=document.getElementById("buildingtime").value.trim();
		ProjectTypeEerorMSGdiv.innerHTML="";
		var pname=document.getElementById("Project_Type").value.trim();		
		if(pname!="Customize")
		$.ajax({
			type : "POST",
			url : "DeliveryDateTime111",
			dataType : "HTML",
			data : {
				"date" : date,
				"pname":pname,
				"btime":"Find",
				"buildingtime":buildingtime,				
			},
			success : function(data){
				if(data=="pass"){
				document.getElementById("StartingDateErrorMSGdiv").innerHTML="Set Milestone First.";
				document.getElementById("StartingDateErrorMSGdiv").style.color="red";				
				}else{
					document.getElementById("DeliveryDate").value=data;
				}
				
			}
		});
	}
}
function getBuildingTime(){
	var pname=document.getElementById("Project_Type").value.trim();		
	var uid="<%=uid%>";
	if(pname!="Customize"){		
			$.ajax({
				type : "POST",
				url : "GetBuildingTime111",
				dataType : "HTML",
				data : {				
					"pname":pname,
					"uid":uid,
				},
				success : function(data){
					document.getElementById('buildingtime').value=data;
				}
			});
	}
}
function getRemarks(value){
	if(value!="Customize")
	document.getElementById('Project Name').value=value;
	else
		document.getElementById('Project Name').value="";
	document.getElementById('StartingDate').value='';
	 document.getElementById('DeliveryDate').value='';
	 if(value!="Customize"&&value!=""){	
		 document.getElementById('Delivery_Date').style.display="block";
		$.ajax({
			type : "POST",
			url : "GetRemarks111",
			dataType : "HTML",
			data : {				
				"pname":value,
			},
			success : function(data){
				var x=data.split("@");
				nicEditors.findEditor( "Remarks" ).setContent(x[0]);
				document.getElementById('pid').value=x[1];
			}
		});}else {document.getElementById('Delivery_Date').style.display="none";
		document.getElementById('DeliveryDate').value="NA";
		document.getElementById('pid').value="NA";
	 nicEditors.findEditor( "Remarks" ).setContent("");
	 }
}

function registerProject() {
	
	if(document.getElementById('Client_Name').value.trim()=="" ) {
		ClientNameEerorMSGdiv.innerHTML="Client Name is required.";
		ClientNameEerorMSGdiv.style.color="#800606";
		return false;
	    }
	if(document.getElementById('Service_Type').value.trim()=="" )
	{
		serviceTypeErrorMSGdiv.innerHTML="Service Type is required.";
		serviceTypeErrorMSGdiv.style.color="#800606";
		return false;
	}
		if(document.getElementById('Project No').value.trim()=="")  {
	    ProjectNoEerorMSGdiv.innerHTML="Project No  is required.";
		ProjectNoEerorMSGdiv.style.color="#800606";
		return false;
		}
		if(document.getElementById('Project_Type').value.trim()=="") {
		ProjectTypeEerorMSGdiv.innerHTML="Project Type is required.";
		ProjectTypeEerorMSGdiv.style.color="#800606";
			return false;
		}
		if(document.getElementById('Project Name').value.trim()==""){
		ProjectNameEerorMSGdiv.innerHTML="Project Name is required.";
		ProjectNameEerorMSGdiv.style.color="#800606";
		return false;
	    }
		if(document.getElementById('StartingDate').value.trim()==""){
		StartingDateErrorMSGdiv.innerHTML="Starting Date is required.";
		StartingDateErrorMSGdiv.style.color="#800606";
		return false; 
	    }
		if(document.getElementById('DeliveryDate').value.trim()==""){
		DeliveryDateErrorMSGdiv.innerHTML="Delivery Date is required.";
		DeliveryDateErrorMSGdiv.style.color="#800606";
		return false;
		}
		
		var chk=0;
		if($('#CheckedBox').is(':checked'))chk=1;			
		document.getElementById("PaymentBased").value=chk;
	}


</script>
</body>
</html>