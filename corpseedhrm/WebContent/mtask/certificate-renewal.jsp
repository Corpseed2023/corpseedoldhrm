<%@page import="java.util.Properties"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Certificate renewal</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%if(!MCR0){%><jsp:forward page="/login.html" /><%} %>
	<%
	String token= (String)session.getAttribute("uavalidtokenno");
	
	Properties properties = new Properties();
	properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));		
	String docBasePath=properties.getProperty("docBasePath");
	String domain=properties.getProperty("domain");
	
	//pagination start
	int pageNo=1;
	int rows=10;
	String sort="";
	String sorting_order="sorting_desc";
	String order=request.getParameter("ord");
	if(order==null)order="desc";
	else if(order.equalsIgnoreCase("asc")){order="desc";sorting_order="sorting_desc";}
	else if(order.equalsIgnoreCase("desc")){order="asc";sorting_order="sorting_asc";}

	if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
	if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

	if(request.getParameter("sort")!=null)sort=request.getParameter("sort");

	String sort_url=domain+"certificates-renewal.html?page="+pageNo+"&rows="+rows;

	//pagination end
	
	String certRenewalTaskDateRange = (String) session.getAttribute("certRenewalTaskDateRange");
	if(certRenewalTaskDateRange==null||certRenewalTaskDateRange.length()<=0)certRenewalTaskDateRange="NA";
	
	String renewals[][]=TaskMaster_ACT.getAllRenewals(token,certRenewalTaskDateRange,pageNo,rows,sort,order);
	int totalRenewal=TaskMaster_ACT.countAllRenewals(token,certRenewalTaskDateRange);
	%>
	<div id="content">		
		<div class="main-content">
			<div class="container">
				<div class="clearfix"> 
				<form name="RefineSearchenqu" onsubmit="return false;">
				<div class="bg_wht clearfix mb10" id="SearchOptions">  
				<div class="row">
				
				<div class="col-md-12 col-sm-12 col-xs-12">
				<div class="clearfix flex_box justify_end">				
				<div class="item-bestsell col-md-3 col-sm-3 col-xs-12 has-clear"> 
				<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!certRenewalTaskDateRange.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly"/>
				<span class="form-control-clear form-control-feedback" onclick="clearSession('certRenewalTaskDateRange');location.reload();"></span>
				</p>
				</div>
				</div>
				</div>
				</div>
				</div>
				<!-- search option 2 -->
				<div class="row noDisplay" id="SearchOptions1">
				<div class="col-md-5 col-sm-5 col-xs-12"> 
				<div class="col-md-3">
				<button type="button" class="filtermenu dropbtn" style="width: 90px;" data-toggle="modal" data-target="#ExportData">&nbsp;Export</button>
				</div>
				</div>
				<div class="col-md-7 col-sm-7 col-xs-12 min-height50">
				<div class="clearfix flex_box justify_end">  
				
				</div>
				</div>
				</div>
				</form>
				</div>
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                	<div class="table-responsive">
                        <table class="ctable">
						    <thead>
						     <tr class="tg" style="position:absolute;width:100%;display:inline-table">
    <th class="tg-cly1">  
        <div class="line"></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
  </tr>
						        <tr>
						            <th  class="sorting <%if(sort.equals("id")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','id','<%=order%>')">#</th>
						            <th width="100" class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
						            <th class="sorting <%if(sort.equals("project")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','project','<%=order%>')">Project</th>
						            <th>Document</th>
						            <th class="sorting <%if(sort.equals("approval_date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','approval_date','<%=order%>')">Approval Date</th>
						            <th class="sorting <%if(sort.equals("renewal_date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','renewal_date','<%=order%>')">Renewal Date</th>
						            <th class="sorting <%if(sort.equals("status")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','status','<%=order%>')">Status</th>
						            <th class="sorting <%if(sort.equals("employee")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','employee','<%=order%>')">Employee</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    int ssn=0;
						    int showing=0;
						    int startRange=pageNo-2;
						    int endRange=pageNo+2;
						    int totalPages=1;
						    if(renewals!=null&&renewals.length>0){
						    	  ssn=rows*(pageNo-1);
						    	  totalPages=(totalRenewal/rows);
						    	  if((totalRenewal%rows)!=0)totalPages+=1;
						    	  showing=ssn+1;
						    	  if (totalPages > 1) {     	 
						    		  if((endRange-2)==totalPages)startRange=pageNo-4;        
						              if(startRange==pageNo)endRange=pageNo+4;
						              if(startRange<1) {startRange=1;endRange=startRange+4;}
						              if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
						              if(startRange<1)startRange=1;
						         }else{startRange=0;endRange=0;}
						    	  
                        	   for(int i=0;i<renewals.length;i++){
                        		   String docName="";
                        		   int certificates=TaskMaster_ACT.countUploadedDoc(renewals[i][8],token);
                        		   if(certificates==1)
                        			   docName=TaskMaster_ACT.getUploadedDocName(renewals[i][8],token);
                           %>
                           <tr class="tg" style="position:absolute;width:100%;display:inline-table">
    <td class="tg-cly1">
      <div class="line"></div>
    </td>
    <td class="tg-cly1">
      <div class="line"></div>
    </td>
    <td class="tg-cly1">
      <div class="line"></div>
    </td>
    <td class="tg-cly1">
      <div class="line"></div>
    </td>
    <td class="tg-cly1">
      <div class="line"></div>
    </td>
    <td class="tg-cly1">
      <div class="line"></div>
    </td>
   
  </tr>
						        <tr id="Row<%=(ssn+1+i)%>">
						            <td><%=i+1%></td>
						            <td><%=renewals[i][0] %></td>
						            <td><%=renewals[i][1] %> : <%=renewals[i][2] %></td>
						            <td>
						            <%if(certificates>0){ %>
									<a <%if(certificates==1){ %>href="<%=docBasePath%><%=docName%>" target="_blank"<%}else{ %>href="#" onclick="showAllCertificates('<%=renewals[i][8]%>')"<%} %>><i class="fas fa-file-alt"></i>
									<%if(certificates>1){ %><span class="plusNo">+<%=certificates %></span><%} %></a><%}else{ %>
									<span class="text-danger">No Document</span>
									<%} %>
						            </td>
						            <td><%=renewals[i][3] %></td>
						            <td><%=renewals[i][4] %></td>
						            <td id="RStatus<%=i %>" onclick="openRenewalBox('<%=renewals[i][3] %>','<%=renewals[i][4] %>','<%=renewals[i][7] %>','<%=i%>')">
						            <%if(renewals[i][5].equals("1")){ %><span class="text-success clickeble">Approved</span><%}else{ %><span class="text-warning clickeble">Pending</span><%} %>
						            </td>
						            <td><%=renewals[i][6] %></td>
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table> 
						</div>
						  <div class="filtertable">
						  <span>Showing <%=showing %> to <%=ssn+renewals.length %> of <%=totalRenewal %> entries</span>
						  <div class="pagination">
						    <ul> <%if(pageNo>1){ %>
						      <li class="page-item">	                     
						      <a class="page-link text-primary" href="<%=request.getContextPath()%>/certificates-renewal.html?page=1&rows=<%=rows%>">First</a>
						   </li><%} %>
						    <li class="page-item">					      
						      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/certificates-renewal.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
						    </li>  
						      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
							    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
							    <a class="page-link" href="<%=request.getContextPath()%>/certificates-renewal.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
							    </li>   
							  <%} %>
							   <li class="page-item">						      
							      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/certificates-renewal.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
							   </li><%if(pageNo<=(totalPages-1)){ %>
							   <li class="page-item">
							      <a class="page-link text-primary" href="<%=request.getContextPath()%>/certificates-renewal.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
							   </li><%} %>
							</ul>
							</div>
							<select class="select2" onchange="changeRows(this.value,'certificates-renewal.html?page=1','<%=domain%>')">
							<option value="10" <%if(rows==10){ %>selected="selected"<%} %>>Rows 10</option>
							<option value="20" <%if(rows==20){ %>selected="selected"<%} %>>Rows 20</option>
							<option value="40" <%if(rows==40){ %>selected="selected"<%} %>>Rows 40</option>
							<option value="80" <%if(rows==80){ %>selected="selected"<%} %>>Rows 80</option>
							<option value="100" <%if(rows==100){ %>selected="selected"<%} %>>Rows 100</option>
							<option value="200" <%if(rows==200){ %>selected="selected"<%} %>>Rows 200</option>
							</select>
							</div>
						   	
				</div>
			</div>
		</div>
	</div>
	<p id="end" style="display:none;"></p>
</div>

<!-- Modal -->
<div class="modal fade" id="UpdateRenewal" tabindex="-1" role="dialog" aria-labelledby="RenewalModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false" class="upload-box">
  <div class="modal-content">
  	 <div class="modal-header">
        <h5 class="modal-title" >+&nbsp;Update Renewal</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
		<div class="col-md-12 pad05 pad-top5">
		<div class="row location_box">
			<div class="col-md-6">
			<label>Approval date</label>
				<input type="date" name="ApprovalDate" id="ApprovalDate" class="form-control">
			</div>						
			<div class="col-md-6">
			<label>Renewal date</label>
				<input type="date" name="RenewalDate" id="RenewalDate" class="form-control">
			</div>
		</div>			
		</div>
		</div>
		 <div class="modal-footer">
		 <input type="hidden" name="UpdateRenewalKey" id="UpdateRenewalKey">
		 <input type="hidden" name="UpdateRenewalIndex" id="UpdateRenewalIndex">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-warning" onclick="preverifyRenewal('2')">Delete</button>
        <button type="button" class="btn btn-primary" onclick="preverifyRenewal('1')">Verify</button>
      </div> 
      </div>
	</form>  
  </div>
</div>
<div class="modal fade" id="certificatesModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Renewal Documents</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
      </div>
      <div class="modal-body">
       <div id="rDocAppendId"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>        
      </div>
    </div>
  </div>
</div>

<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

<script type="text/javascript">

function openRenewalBox(approvalDate,renewalDate,uuid,i){
	$("#ApprovalDate").val(approvalDate);
	$("#RenewalDate").val(renewalDate);
	$("#UpdateRenewalKey").val(uuid);
	$("#UpdateRenewalIndex").val(i);
	$("#UpdateRenewal").modal("show");
}
function preverifyRenewal(action){
	if(action=="2"){
		if (confirm('Are you sure you want to delete this licence renewal date ?')) {
			verifyRenewal(action);
		}
	}else if(action=="1"){
		verifyRenewal(action);
	}
}

function verifyRenewal(action){
	var approvalDate=$("#ApprovalDate").val();
	var renewalDate=$("#RenewalDate").val();
	var uuid=$("#UpdateRenewalKey").val();
	var i=$("#UpdateRenewalIndex").val();
	showLoader();	
	$.ajax({
		type : "POST",
		url : "VerifyRenewalDate111",
		dataType : "HTML",
		data : {				
			approvalDate : approvalDate,
			renewalDate : renewalDate,
			uuid : uuid,
			action : action
		},
		success : function(data){
			$("#UpdateRenewal").modal("hide");
			if(data=="pass"){				
				if(action=="1"){
					$("#RStatus"+i).html("<span class='text-success clickeble'>Approved</span>");
				}else if(action=="2"){
					$("#Row"+i).remove();
				}
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}

function showAllCertificates(milestoneuuid){
	var path="<%=docBasePath%>";
	$(".pad0").remove();
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetRenewalDocuments111",
		dataType : "HTML",
		data : {				
			milestoneuuid : milestoneuuid
		},
		success : function(response){
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);			
				 var len = response.length;
				 console.log("renewal document length="+len);
				 if(len>0){
					 for(var i=0;i<len;i++){
						 var name=response[0]["name"];
						 $(''+
							'<div class="col-md-2 pad0">'+
						 	'<a href="'+path+''+name+'" target="_blank">'+
						 	'<img alt="document" src="'+path+''+name+'">'+
						 	'</a></div>').insertBefore("#rDocAppendId");      
					     
					 }
				 }
			}	
			
		},
		complete : function(data){
			hideLoader();
		}
	});
// 	rDocAppendId
	$("#certificatesModal").modal("show");
}
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"certRenewalTaskDateRange");
	location.reload();
});
$('input[name="date_range"]').daterangepicker({
	  autoUpdateInput: false,
	  autoApply: true,
	  showDropdowns: true,
	}, function(start_date, end_date) {
	  $('input[name="date_range"]').val(start_date.format('DD-MM-YYYY')+' - '+end_date.format('DD-MM-YYYY'));
	});
function doAction(data,name){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetDataToSession111",
	    data:  { 
	    	data : data,
	    	name : name
	    },
	    success: function (response) {
      },
		complete : function(data){
			hideLoader();
		}
	});
}
function clearSession(data){
	if(data!=null){
		showLoader();
	   $.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/ClearSessionData111",
		    data:  { 		    	
		    	data : data
		    },
		    success: function (response) {       	  
	        },
			complete : function(data){
				hideLoader();
			}
		});
	}
}
$( document ).ready(function() {
	   var dateRangeDoAction="<%=certRenewalTaskDateRange%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});
</script>
</body>
</html>