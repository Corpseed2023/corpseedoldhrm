<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage Guide</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>  
	<%if(!MG00){%><jsp:forward page="/login.html" /><%} 
	String token=(String)session.getAttribute("uavalidtokenno");
	Properties properties = new Properties();
	properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
	String azure_path=properties.getProperty("azure_path");
	String domain=properties.getProperty("domain");
	
	String guideDateRangeAction=(String)session.getAttribute("guideDateRangeAction");
	if(guideDateRangeAction==null||guideDateRangeAction.length()<=0)guideDateRangeAction="NA";
	
	String guideProductAction=(String)session.getAttribute("guideProductAction");
	if(guideProductAction==null||guideProductAction.length()<=0)guideProductAction="NA";
	 
	String guideProductKeyAction=(String)session.getAttribute("guideProductKeyAction");
	if(guideProductKeyAction==null||guideProductKeyAction.length()<=0)guideProductKeyAction="NA";
	
	String guideMilestoneAction=(String)session.getAttribute("guideMilestoneAction");
	if(guideMilestoneAction==null||guideMilestoneAction.length()<=0)guideMilestoneAction="NA";
	
// 	System.out.println(guideProductAction+"/"+guideProductKeyAction);
	long totalProduct=TaskMaster_ACT.getTotalProducts("NA","NA","NA",token);
	long guide=TaskMaster_ACT.getTotalGuide(guideProductKeyAction,guideMilestoneAction,guideDateRangeAction,token);
	long completed=TaskMaster_ACT.getCompletedGuide(token);
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

	String sort_url=domain+"manageguide.html?page="+pageNo+"&rows="+rows;

	//pagination end
	%>
	<div id="content">
		
		<div class="main-content">
			<div class="container">
				
				<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30">
                        <div class="clearfix dashboard_info">
                          
                          <div class="pad0 col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fas fa-cart-plus"></i>
                            <%=CommonHelper.formatValue(totalProduct) %> </h3>
							<span>Total Product</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fab fa-glide-g"></i>
                            <%=CommonHelper.formatValue(guide) %></h3>
							<span>Guide</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fas fa-clipboard-list"></i>
                            <%=CommonHelper.formatValue(completed) %></h3>
							<span>Completed</span>
                           </div>
						  </div>
						  <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
						  <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fas fa-list-ol"></i>
                            <%=CommonHelper.formatValue((totalProduct-completed)) %></h3>
							<span> Incomplete</span>
						   </div>
                          </div>
                        </div> 
				</div>
				
<div class="clearfix"> 
<form name="RefineSearchenqu" action="return false" method="Post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="col-md-5 col-sm-5 col-xs-9"> 
<div class="box-width8 dropdown"> 
<button type="button" class="filtermenu dropbtn" data-toggle="modal" data-target="#productModal" onclick="$('.cke_top').hide();" style="font-weight: 600;">Add&nbsp;+/&nbsp;Update</button> 
</div>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="clearfix flex_box justify_end"> 
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12">
<p><input type="search" name="productName" id="Search_Product_Name" autocomplete="off" <%if(!guideProductAction.equalsIgnoreCase("NA")){%>onsearch="clearSession('guideProductAction');clearSession('guideProductKeyAction');location.reload();" value="<%=guideProductAction %>"<%} %>  placeholder="Product Name.." class="form-control"/>
<input type="hidden" id="ProductNameKey" <%if(!guideProductKeyAction.equalsIgnoreCase("NA")){ %>value="<%=guideProductKeyAction %>" <%} %>>
</p>
</div>
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12">
<p><input type="search" name="milestonename" id="Search_Milestone_Name" autocomplete="off" <%if(!guideMilestoneAction.equalsIgnoreCase("NA")){%>onsearch="clearSession('guideMilestoneAction');location.reload();" value="<%=guideMilestoneAction %>"<%} %>  placeholder="Milestone name.." class="form-control"/></p>
</div> 
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12 has-clear">
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!guideDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('guideDateRangeAction');location.reload();"></span>
</div>
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
						            <th><span class="hashico">#</span><input type="checkbox" class="pointers noDisplay" id="CheckAll"></th>
						            <th width="100" class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
						            <th>Product Name</th>
						            <th>Jurisdiction</th>
						            <th class="sorting <%if(sort.equals("milestone")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','milestone','<%=order%>')">Milestone Name</th>
						            <th width="200">Action</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    int ssn=0;
						    int showing=0; 
						    int startRange=pageNo-2;
						    int endRange=pageNo+2;
						    int totalPages=1;
						    String stepGuide[][]=TaskMaster_ACT.getAllstepGuide(guideProductKeyAction,guideMilestoneAction,guideDateRangeAction,token,pageNo,rows,sort,order);
	                        int totalGuide=TaskMaster_ACT.countAllstepGuide(guideProductKeyAction,guideMilestoneAction,guideDateRangeAction,token);   
						    if(stepGuide!=null&&stepGuide.length>0){ 
	                        	   ssn=rows*(pageNo-1);
	                        		  totalPages=(totalGuide/rows);
	                        			if((totalGuide%rows)!=0)totalPages+=1;
	                        		  showing=ssn+1;
	                        		  if (totalPages > 1) {     	 
	                        			  if((endRange-2)==totalPages)startRange=pageNo-4;        
	                        	          if(startRange==pageNo)endRange=pageNo+4;
	                        	          if(startRange<1) {startRange=1;endRange=startRange+4;}
	                        	          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
	                        	          if(startRange<1)startRange=1;
	                        	     }else{startRange=0;endRange=0;}
	                        	   for(int i=0;i<stepGuide.length;i++){
	                        		   String prodName=TaskMaster_ACT.getProductName(stepGuide[i][1],token);
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
						        <tr>
						            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked"></td>
						            <td><%=stepGuide[i][4] %></td>
						            <td><%=prodName %></td>
						            <td><%=stepGuide[i][5] %></td>
						            <td><%=stepGuide[i][3] %></td>
						            <td>
						            <a href="javascript:void(0)" onclick="guideAction('<%=stepGuide[i][2]%>')"><i class="fas fa-trash"></i>&nbsp;Delete</a>						            
						            </td>									
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table>
						</div>
						<div class="filtertable">
						  <span>Showing <%=showing %> to <%=ssn+stepGuide.length %> of <%=totalGuide %> entries</span>
						  <div class="pagination">
						    <ul> <%if(pageNo>1){ %>
						      <li class="page-item">	                     
						      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manageguide.html?page=1&rows=<%=rows%>">First</a>
						   </li><%} %>
						    <li class="page-item">					      
						      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manageguide.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
						    </li>  
						      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
							    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
							    <a class="page-link" href="<%=request.getContextPath()%>/manageguide.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
							    </li>   
							  <%} %>
							   <li class="page-item">						      
							      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manageguide.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
							   </li><%if(pageNo<=(totalPages-1)){ %>
							   <li class="page-item">
							      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manageguide.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
							   </li><%} %>
							</ul>
							</div>
							<select class="select2" onchange="changeRows(this.value,'manageguide.html?page=1','<%=domain%>')">
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

<div class="productModal modal fade" id="productModal">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h3 class="modal-title"><i class="fas fa-info-circle" style="color: #4ac4f3;"></i>Steps Guide </h3>
        </div>
        <div class="modal-body">
          <div class="clearfix">
<form onsubmit="return false" method="post" class="stepGuideForm">
<div class="marg-05 row">
<div class="pad05 col-md-4 col-sm-6 col-xs-12">
<div class="form-group">
<div class="input-group">
<input type="text" name="product_Name" id="Product_Name" placeholder="Product name.." class="form-control">
<input type="hidden" id="productKey" name="product_key">
</div>
</div>
</div>
<div class="pad05 col-md-4 col-sm-6 col-xs-12">
<div class="form-group">
<div class="input-group">
<select name="milestone" id="Product_Milestone" class="form-control"> 
<option value="">Select Milestone</option>
</select>
</div>
</div>
</div>
<div class="pad05 col-md-4 col-sm-6 col-xs-12">
<div class="form-group">
<div class="input-group">
<select name="jurisdiction" id="Product_Jurisdiction" class="form-control" onchange="showAllStepGuide(this.value)"> 
<option value="">Select Jurisdiction</option>
</select>
</div>
</div>
</div>
</div>
<div class="clearfix box_shadow1 bt-radius pad_box4 form-group toggle_box" id="ShowStepGuideBox">
<div class="add_prod_step">
<div class="inner_step">
<a class="step_list active" id="StepClassActive1">Step I</a>
<div class="inner_step_content box_shadow1" id="StepListToggle1"> 
<div class="text-editor">
<textarea class="clearfix" row="3" id="GuideStepId1" name="GuideStepId1"> 
<p>1. Add Document list to the MCA portal while keeping in mind to check type of activity.</p>
<p>2. For referral play the <a href="#">video.</a></p>
<p>3. For referral see the <a href="#">filed document.</a></p>
</textarea>
</div>
<div class="inner_attachment text-right">
<a class="txt_style" onclick="showEditor()">T</a>
<span class="attachment">
<div class="file-upload-box DispNone" id="StepGuideFileNameShow1"> 
<i class="far fa-file"></i>
<span id="StepGuideFileName1">File name.jpg</span>
<div class="action-btn"><a  id="StepGuideFileDownload1" download>
<i class="far fa-arrow-alt-circle-down"></i></a>
<span class="close-btn"  id="StepGuideFileDelete1">
<i class="far fa-times-circle" title="Delete"></i>
</span>
</div>
</div>
<div class="clearfix" id="StepGuideFileSelectShow1">
<i class="fa fa-paperclip" aria-hidden="true"></i> 
<input type="file" name="attachment1" id="Attachment1">
</div>
</span>
</div>
</div>
</div>
<div class="clearfix" id="AppendStepGuideId"></div>
<div class="inner_step">
<a class="addStep_btn" onclick="addNewStepGuide()">+New Step</a>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-loadmore disableButton" type="submit" onclick="return validateStepGuide()">Save</button>
</div>
</div>
</div>
</form>
</div>
        </div>
      </div>
    </div>
  </div>

<div class="modal fade" id="warningAction" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span>
        <span class="text-danger">Are you sure want to delete this step guide ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <input type="hidden" id="StepGuideMilestoneId" value="NA"/>      
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-danger" style="width: 15%;" onclick="deleteStepGuide()">Delete</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="ExportData" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fas fa-file-export text-primary" style="margin-right: 10px;"> </span><span class="text-primary">Export</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false" id="sendEmailInvoice">
       <div class="modal-body">       
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">FROM :</label>
            <input type="text" autocomplete="off" class="form-control searchdate pointers" name="from-date" id="From-Date" placeholder="FROM-DATE" readonly="readonly">
          </div>        
        <div class="form-group">
            <label for="recipient-name" class="col-form-label">TO :</label>
            <input type="text" autocomplete="off" class="form-control searchdate pointers" name="to-date" id="To-Date" placeholder="TO-DATE" readonly="readonly">
          </div> 
          <div class="form-group">
            <label for="recipient-name" class="col-form-label">Columns :</label>
            <select class="form-control" name="exportColumn" id="ExportColumn" multiple="multiple">
            	<option value="sgdate">Date</option>
            	<option value="sgprodkey">Product Name</option>
            	<option value="sgmilestonename">Milestone Name</option>
            </select>            
          </div>
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Formate :</label>
            <select class="form-control" name="file-formate" id="File-Formate">
            	<option value="csv">CSV</option>
            	<option value="xlsx" selected>XLS</option>
            </select>
          </div>   
          <div class="form-group noDisplay">
            <label for="recipient-name" class="col-form-label">Password Protected :</label>
            <input type="checkbox" name="protected" id="Protected" value="2">&nbsp;&nbsp;
            <input type="password" class="noDisplay form-control" name="filePassword" id="FilePassword" placeholder="Enter password.."> 
          </div>      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="return validateExport()">Submit</button>
      </div></form>
    </div>
  </div>
</div>
  <input type="hidden" id="StepGuideCountId" value="1">
  <div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/ckeditor/ckeditor.js"></script>
<script type="text/javascript">
function guideAction(milestoneId){
	$("#StepGuideMilestoneId").val(milestoneId);
	$("#warningAction").modal("show");
}
function deleteStepGuide(){
	var milestoneId=$("#StepGuideMilestoneId").val();
	if(milestoneId==null||milestoneId==""){
		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
		$('.alert-show').show().delay(3000).fadeOut();
	}else{
		showLoader();
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/RemoveStepGuide111",
		    data:  { 
		    	milestoneId : milestoneId
		    },
		    success: function (response) {
	        	if(response=="pass"){
	        		$("#RowNo"+milestoneId).remove();
	        		$("#warningAction").modal("hide");	        		
        			document.getElementById('errorMsg1').innerHTML = 'Successfully deleted!!';
        			$('.alert-show1').show().delay(2000).fadeOut();	        		
	        	}else{
	        		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
	        		$('.alert-show').show().delay(3000).fadeOut();
	        	}
	        },
	    	complete : function(data){
	    		hideLoader();
	    	}
		});
	}
}
function showAllStepGuide(jurisdiction){
	var mdata=$("#Product_Milestone").val();
	if(mdata!=""){
		var x=mdata.split("#");
		var milestoneId=x[0];
		//get previous step guide data and set StepGuideCountId value
		showLoader();
		$.ajax({
		type : "POST",
		url : "GetMilestonesStepGuide111",
		dataType : "HTML",
		data : {
			milestoneId : milestoneId,
			jurisdiction : jurisdiction
		},
		success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;	
			 $(".removeStepGuide").remove();
			 var path="<%=azure_path%>";			 
			for(var i=0;i<len;i++){
				var key = response[i]['key'];
				var stepno = response[i]['stepno'];
				var contents = response[i]['contents'];
				var document = response[i]['document'];
				var docName="NA";
				if(document!=null&&document!="NA"){
					docName=document.substring(21);
				}				
				
				if(Number(stepno)==1&&document!="NA"){					
					$("#StepGuideFileSelectShow1").addClass("DispNone");
					$("#StepGuideFileNameShow1").removeClass("DispNone");
					$("#StepGuideFileName1").html(docName);
					$("#StepGuideFileDownload1").attr("href",""+path+document+"");
					$("#StepGuideFileDelete1").attr("onclick","deleteFile('"+key+"','"+document+"','"+stepno+"')");
					CKEDITOR.instances['GuideStepId1'].setData(contents);
				}else if(Number(stepno)==1&&document=="NA"){
					$("#StepGuideFileSelectShow1").removeClass("DispNone");
					$("#StepGuideFileNameShow1").addClass("DispNone");
					$("#StepGuideFileName1").html("File Name");
					$("#StepGuideFileDownload1").removeAttr("href");
					$("#StepGuideFileDelete1").attr("onclick","");
					CKEDITOR.instances['GuideStepId1'].setData(contents);
				}
				if(Number(stepno)>1){
					$('.step_list').removeClass("active");
					$('.step_list').removeClass("remove");
					var stepName=integer_to_roman(Number(stepno));
					$('.inner_step_content').slideUp();
					var uploadFile="DispNone";
					var showFile="DispNone";
					if(document!="NA"){
						showFile="";
					}else{
						uploadFile="";
					}
					var downloadFile="<%=azure_path%>"+document;
					$(''+
					'<div class="inner_step removeStepGuide" id="StepGuideCount'+stepno+'">'+
					'<a class="step_list active remove" onclick="openStepBox(\''+stepno+'\')" id="StepClassActive'+stepno+'">Step '+stepName+'</a>'+
					'<span class="fas fa-times mlft20 text-danger toggle_box pointers" onclick="removeAddedGuideStep(\''+stepno+'\',\''+key+'\',\''+document+'\')"></span>'+ 
					'<div class="inner_step_content box_shadow1" id="StepListToggle'+stepno+'" style="display:none;">'+ 
					'<div class="text-editor">'+
					'<textarea class="clearfix" row="3" id="GuideStepId'+stepno+'" name="GuideStepId'+stepno+'">'+ 
					'</textarea>'+
					'</div>'+
					'<div class="inner_attachment text-right">'+
					'<a class="txt_style" onclick="showEditor()">T</a>'+
					'<span class="attachment">'+
					'<div class="file-upload-box '+showFile+'" id="StepGuideFileNameShow'+stepno+'"> '+
					'<i class="far fa-file"></i>'+
					'<span id="StepGuideFileName'+stepno+'">'+docName+'</span>'+
					'<div class="action-btn">'+ 
					'<a href="'+downloadFile+'" download><i class="far fa-arrow-alt-circle-down"></i></a>'+
					'<span class="close-btn" onclick="deleteFile(\''+key+'\',\''+document+'\',\''+stepno+'\')" id="StepGuideFileDelete'+stepno+'">'+
					'<i class="far fa-times-circle" title="Delete"></i>'+
					'</span>'+
					'</div>'+
					'</div>'+
					'<div class="clearfix '+uploadFile+'" id="StepGuideFileSelectShow'+stepno+'">'+	
					'<i class="fa fa-paperclip" aria-hidden="true"></i> '+
					'<input type="file" name="attachment'+stepno+'" id="Attachment'+stepno+'">'+
					'</div>'+
					'</span>'+
					'</div>'+
					'</div>'+
					'</div>').insertBefore("#AppendStepGuideId");
					CKEDITOR.replace('GuideStepId'+stepno);	
					$("#StepListToggle"+stepno).slideDown();
					setTimeout(() => {
						$(".cke_top").hide();
					}, 100);				
					CKEDITOR.instances['GuideStepId'+stepno].setData(contents);
				}
				$("#StepGuideCountId").val(stepno);
			}
			}else{
				$("#StepGuideFileSelectShow1").removeClass("DispNone");
				$("#StepGuideFileNameShow1").addClass("DispNone");
				$("#StepGuideFileName1").html("File Name");
				$("#StepGuideFileDownload1").removeAttr("href");
				$("#StepGuideFileDelete1").prop("onclick",null);
// 				remove other steps and step no value 1
				$("#StepGuideCountId").val("1");
				$(".removeStepGuide").remove();
				$("#StepClassActive1").addClass("active");
				$("#StepListToggle1").slideDown();
				CKEDITOR.instances['GuideStepId1'].setData('<p>1. Add Document list to the MCA portal while keeping in mind to check type of activity.</p>'+
				'<p>2. For referral play the <a href="#">video.</a></p>'+
				'<p>3. For referral see the <a href="#">filed document.</a></p>');
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
		
		$("#ShowStepGuideBox").removeClass("toggle_box");
	}else{
		$("#ShowStepGuideBox").addClass("toggle_box");
	}	
}
function deleteFile(key,docName,stepno){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/RemoveStepGuideDocument111",
	    data:  { 
	    	key : key,
	    	docName : docName
	    },
	    success: function (response) {
	       	if(response=="pass"){       
	   			document.getElementById('errorMsg1').innerHTML = 'Document removed !!';
	   			$("#StepGuideFileSelectShow"+stepno).removeClass("DispNone");
				$("#StepGuideFileNameShow"+stepno).addClass("DispNone");
				$("#StepGuideFileName"+stepno).html("File Name");
				$("#StepGuideFileDownload"+stepno).removeAttr("href");
				$("#StepGuideFileDelete"+stepno).prop("onclick",null);
	   			$('.alert-show1').show().delay(2000).fadeOut();	        		
	       	}else{
	       		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
	       		$('.alert-show').show().delay(3000).fadeOut();
	       	}
	       },
	   	complete : function(data){
			hideLoader();
		}
	});
}
function validateStepGuide(){
	var count=$("#StepGuideCountId").val();
	var prodName=$("#Product_Name").val();
	var milestone=$("#Product_Milestone").val();
	var jurisdiction=$("#Product_Jurisdiction").val();
	if(prodName==null||prodName==""){
		document.getElementById('errorMsg').innerHTML ="Please enter product name !!";					
	    $('.alert-show').show().delay(3000).fadeOut();
	    return false;
	}
	if(milestone==null||milestone==""){
		document.getElementById('errorMsg').innerHTML ="Please select milestone !!";					
	    $('.alert-show').show().delay(3000).fadeOut();
	    return false;
	}
	if(jurisdiction==null||jurisdiction==""){
		document.getElementById('errorMsg').innerHTML ="Please select jurisdiction !!";					
	    $('.alert-show').show().delay(3000).fadeOut();
	    return false;
	}
	for(var i=1;i<=Number(count);i++){
		var textArea="GuideStepId"+i;
		var boxContent=CKEDITOR.instances[textArea].getData();
		if(boxContent==null||boxContent==""){
			document.getElementById('errorMsg').innerHTML ="Please enter Step - "+(i+1)+" contents !!";					
 		    $('.alert-show').show().delay(3000).fadeOut();
 		    return false;
		}
	}
	var form = $(".stepGuideForm")[0]; 
    var data = new FormData(form);
    data.append("count", count);
    
    for(var i=1;i<=Number(count);i++){
		var textArea="GuideStepId"+i;
		var boxContent=CKEDITOR.instances[textArea].getData();
		data.append("GuideStepContentId"+i, boxContent);
	}
    showLoader();
	$.ajax({
        type : "POST",
        encType : "multipart/form-data",
        url : "<%=request.getContextPath()%>/SubmitStepGuide111",
        cache : false,
        processData : false,
        contentType : false,
        data : data,
        success : function(msg) {
        	if(msg=="pass"){
        		$("#productModal").modal("hide");
        		document.getElementById('errorMsg1').innerHTML ="Successfully Submitted !!";
        		setTimeout(() => {
					location.reload();
				}, 2000);
	    		$('.alert-show1').show().delay(2000).fadeOut();
    		}else{
    			document.getElementById('errorMsg').innerHTML ="Something Went wrong ,try-again later !!";
	    		$('.alert-show').show().delay(3000).fadeOut();
    		}
        },
        error : function(msg) {
            alert("Couldn't upload file");
        },
    	complete : function(data){
    		hideLoader();
    	}
    });
}

function addNewStepGuide(){
	showLoader();
	var count=$("#StepGuideCountId").val();
	count=Number(count)+1;
	var stepName=integer_to_roman(Number(count));
	$('.step_list').removeClass("active");
	$('.step_list').removeClass("remove");
	$('.inner_step_content').slideUp();
	$(''+
	'<div class="inner_step removeStepGuide" id="StepGuideCount'+count+'">'+
	'<a class="step_list active remove" onclick="openStepBox(\''+count+'\')" id="StepClassActive'+count+'">Step '+stepName+'</a>'+
	'<span class="fas fa-times mlft20 text-danger toggle_box pointers" onclick="removeGuideStep(\''+count+'\')"></span>'+ 
	'<div class="inner_step_content box_shadow1" id="StepListToggle'+count+'" style="display:none;">'+ 
	'<div class="text-editor">'+
	'<textarea class="clearfix" row="3" id="GuideStepId'+count+'" name="GuideStepId'+count+'">'+ 
	'<p>1. Add Document list to the MCA portal while keeping in mind to check type of activity.</p>'+
	'<p>2. For referral play the <a href="#">video.</a></p>'+
	'<p>3. For referral see the <a href="#">filed document.</a></p>'+
	'</textarea>'+
	'</div>'+
	'<div class="inner_attachment text-right">'+
	'<a class="txt_style" onclick="showEditor()">T</a>'+
	'<span class="attachment">'+
	'<div class="file-upload-box DispNone"> '+
	'<i class="far fa-file"></i>'+
	'<span>File name.jpg</span>'+
	'<div class="action-btn">'+
	'<i class="far fa-arrow-alt-circle-down "></i>'+
	'<span class="close-btn">'+
	'<i class="far fa-times-circle" title="Delete"></i>'+
	'</span>'+
	'</div>'+
	'</div>'+
	'<div class="clearfix">'+	
	'<i class="fa fa-paperclip" aria-hidden="true"></i> '+
	'<input type="file" name="attachment'+count+'" id="Attachment'+count+'">'+
	'</div>'+
	'</span>'+
	'</div>'+
	'</div>'+
	'</div>').insertBefore("#AppendStepGuideId");
	CKEDITOR.replace('GuideStepId'+count);	
	$("#StepListToggle"+count).slideDown();
	setTimeout(() => {
		$(".cke_top").hide();
	}, 100);
	$("#StepGuideCountId").val(Number(count));
	hideLoader();
}

function removeAddedGuideStep(count,key,document){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/RemoveStepGuideStep111",
	    data:  { 
	    	key : key,
	    	document : document
	    },
	    success: function (response) {
	       	if(response=="pass"){       
	       		$("#StepGuideCount"+count).remove();
	       		$("#StepGuideCountId").val((Number(count)-1));
	       		count=Number(count)-1;
	       		$("#StepClassActive"+count).addClass("active");
	       		if(Number(count)!=1){
	       			$("#StepClassActive"+count).addClass("remove");
	       		}
	       		$("#StepListToggle"+count).slideDown();
	       			        		
	       	}else{
	       		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
	       		$('.alert-show').show().delay(3000).fadeOut();
	       	}
	       },
	   	complete : function(data){
			hideLoader();
		}
	});	
}

function removeGuideStep(count){
	$("#StepGuideCount"+count).remove();
	$("#StepGuideCountId").val((Number(count)-1));
	count=Number(count)-1;
	$("#StepClassActive"+count).addClass("active");
	if(Number(count)!=1){
		$("#StepClassActive"+count).addClass("remove");
	}
	$("#StepListToggle"+count).slideDown();
}
$(document).ready(function(){
	CKEDITOR.replace('GuideStepId1');	
});
function showEditor(){
	if($(".cke_top").css('display') == 'none'){
		$(".cke_top").show();
	}else{
		$(".cke_top").hide();
	}
}

$(function() {
	$("#Search_Milestone_Name").autocomplete({
		source : function(request, response) {
			if(document.getElementById('Search_Milestone_Name').value.trim().length>=1)
			$.ajax({
				url : "<%=request.getContextPath()%>/getproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field : "product_milestone"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							value : item.value,							
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		select: function (event, ui) {
            if(!ui.item){  }
            else{ 
            	doAction(ui.item.value,"guideMilestoneAction");
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#Search_Product_Name").autocomplete({
		source : function(request, response) {
			if(document.getElementById('Search_Product_Name').value.trim().length>=1)
			$.ajax({
				url : "<%=request.getContextPath()%>/getproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field : "product_name"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							key : item.key,
							value : item.value,							
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		select: function (event, ui) {
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML ="Product doesn't exist !!";					
	 		    $('.alert-show').show().delay(4000).fadeOut();
            	$("#Search_Product_Name").val("");
            	$("#ProductNameKey").val("");
            }
            else{ 
            	doAction(ui.item.value,"guideProductAction");
            	doAction(ui.item.key,"guideProductKeyAction");
            	            	
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#Product_Name").autocomplete({
		source : function(request, response) {
			if(document.getElementById('Product_Name').value.trim().length>=2)
			$.ajax({
				url : "<%=request.getContextPath()%>/getproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field : "product_name"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							key : item.key,
							value : item.value,	
							central : item.central,
							state : item.state,
							global : item.global,
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		change: function (event, ui) {
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML ="Product doesn't exist !!";					
	 		    $('.alert-show').show().delay(4000).fadeOut();
            	$("#Product_Name").val("");
            	$("#productKey").val("");
            	setProductMilestones("NA");
            }
            else{
            	$("#productKey").val(ui.item.key);
            	setProductMilestones(ui.item.key);
            	appendJurisdiction(ui.item.global,ui.item.central,ui.item.state,"Product_Jurisdiction");
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function appendJurisdiction(global,central,state,jurisdiction){
	 $("#"+jurisdiction).empty();
	 showLoader();
	 $.ajax({
			type : "GET",
			url : "GetJurisdiction111",
			dataType : "HTML",
			data : {
				global : global,
				central : central,
				state : state
			},
			success : function(data){	
				$("#"+jurisdiction).append(data);	
			},
			complete : function(data){
				hideLoader();
			}
		});		 
}

function setProductMilestones(PKey){
	if(PKey=="NA"){
		$("#Product_Milestone").empty();
		$("#Product_Milestone").append("<option value=''>"+"Select Milestone"+"</option>");
	}else{
		showLoader();
		$.ajax({
			type : "POST",
			url : "GetProductMilestones111",
			dataType : "HTML",
			data : {
				PKey : PKey
			},
			success : function(response){
				if(Object.keys(response).length!=0){
				response = JSON.parse(response);			
				 var len = response.length;
				$("#Product_Milestone").empty();
			    $("#Product_Milestone").append("<option value=''>"+"Select Milestone"+"</option>");		    
				for(var i=0;i<len;i++){
					var id = response[i]['id'];
					var name = response[i]['name'];
					$("#Product_Milestone").append("<option value='"+id+"#"+name+"'>"+name+"</option>");
				}
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}
}
function vieweditpage(id,page){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	if(page=="followup") window.location = "<%=request.getContextPath()%>/follow-up-billing.html";  
        	else if(page=="billing") window.location = "<%=request.getContextPath() %>/billing.html";  
        },
	});
}
</script>
<script type="text/javascript">
function openStepBox(count){
	$('.step_list').removeClass("active");
	$('#StepClassActive'+count).addClass("active");
	$('.inner_step_content').slideUp();
	$('#StepListToggle'+count).slideDown(); 
}
$('.step_list').on( "click", function() { 
	$('.step_list').removeClass("active");
	$(this).toggleClass("active");
	$('.inner_step_content').slideUp();
	$(this).next().slideToggle(); 
}); 
</script>
<script type="text/javascript">
$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 
</script>
<script type="text/javascript">
$('.close_icon_btn').click(function(){
	$('.notify_box').hide();
});
$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});
	
$( document ).ready(function() {
	   var dateRangeDoAction="<%=guideDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"guideDateRangeAction");
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

$("#Protected").click(function(){
	 if ($("#Protected").is(":checked")){
		 $("#FilePassword").val("");
		 $("#FilePassword").show();		 
}else{
	 $("#FilePassword").hide();
	 $("#FilePassword").val("NA");    	 
}
});
$(function(){$(".searchdate").datepicker({changeMonth:true,changeYear:true,dateFormat:'yy-mm-dd'});});
$(document).ready(function(){
	$('#ExportColumn').select2({
		  placeholder: 'Select columns..',
		  allowClear: true,
		  dropdownParent: $("#ExportData")
		});
});

function validateExport(){
	var from=$("#From-Date").val();
	var to=$("#To-Date").val();
	var columns=$("#ExportColumn").val();
	var formate=$("#File-Formate").val();	
	var filePassword=$("#FilePassword").val();
		
	if(from==null||from==""){
		document.getElementById('errorMsg').innerHTML ='Select from-date !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(to==null||to==""){
		document.getElementById('errorMsg').innerHTML ='Select to-date !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(columns==null||columns==""){
		document.getElementById('errorMsg').innerHTML ='Select columns for export !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(formate==null||formate==""){
		document.getElementById('errorMsg').innerHTML ='Choose formate option !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if ($("#Protected").is(":checked")){
		if(filePassword==null||filePassword==""){
			document.getElementById('errorMsg').innerHTML ='Please enter export file password !!';					
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		$("#Protected").val("1")
	}else{
		$("#Protected").val("2")
		$("#FilePassword").val("NA");
	}
	var baseName="<%=azure_path%>";
	columns+="";
	showLoader();
	$.ajax({
		type : "POST",
		url : "ExportData111",
		dataType : "HTML",
		data : {				
			from : from,
			to : to,
			columns : columns,
			formate : formate,
			filePassword : filePassword,
			type : "Guide"
		},
		success : function(response){
			$("#ExportData").modal("hide");
			if(response=="Fail"){
				document.getElementById('errorMsg').innerHTML ='No. Data Found !!';					
				$('.alert-show').show().delay(4000).fadeOut();
			}else{ 
				setTimeout(() => {
					$("#DownloadExportedLink").attr("href", baseName+response);
					$("#DownloadExported").click();
				}, 500);
			}
		},
		complete : function(data){
			hideLoader();
		}
	});	
	
}
</script>
</body>
</html>