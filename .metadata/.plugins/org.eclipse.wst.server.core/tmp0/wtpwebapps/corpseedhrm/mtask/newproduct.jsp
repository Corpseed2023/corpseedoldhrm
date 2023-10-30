<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="admin.enquiry.Enquiry_ACT"%> 
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>New product</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %> 
</head>
<body class="add_enquery">
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %> 
	<%if(!MPP01){%><jsp:forward page="/login.html" /><%} %>
	<%	
	String addedby= (String)session.getAttribute("loginuID");
	String token= (String)session.getAttribute("uavalidtokenno");
	String start=Usermaster_ACT.getStartingCode(token,"improductskey");
	String prodkey="NA";
	prodkey=TaskMaster_ACT.getuniquecode(token);
	
	if (prodkey==null||prodkey.equalsIgnoreCase("NA")) {	
		prodkey=start+"1";
	}
	else {
		String c=prodkey.substring(start.length());
	int j=Integer.parseInt(c)+1;
	prodkey=start+Integer.toString(j);
	}
	
	//empty virtual price table
		TaskMaster_ACT.emptyPriceVirtualTable(token,addedby); 
	//empty virtual milestone table
		TaskMaster_ACT.emptyMilestoneVirtualTable(token,addedby);  
	//empty virtual milestone table
		TaskMaster_ACT.emptyDocumentVirtualTable(token,addedby);  
	
%>
<%-- <jsp:forward page="/login.html" /> --%>

	<div id="content">
		<div class="main-content">
			<div class="container">
              <div class="row mb10">
               <div class="col-md-6 col-sm-6 col-xs-12 sale_id">
               <label>Product ID :</label><output name="enquid" id="enquid" class="" title="<%=prodkey%>"><%=prodkey%></output>
               </div>
               <div class="col-md-6 col-sm-6 col-xs-12 text-right">
                <a onclick="$('#warningBack').modal('show');" style="display: none;" id="BackBtnIdHide"><button class="bkbtn">Back</button></a>
                <a onclick="goBack()" id="BackBtnIdShow"><button class="bkbtn">Back</button></a>
               </div>
              </div>
				<div class="row">
                	<div class="col-xs-12">
                        <div class="menuDv post-slider">
                            <form action="<%=request.getContextPath() %>/registerproduct.html" method="post" name="addenq" id="AddNewProductForm">
                             <div class="row">
                             <div class="col-md-9 col-sm-10 col-xs-12">
                               <div class="row">
                                  <div class="col-md-12 col-sm-12 col-xs-12">
                                   <div class="clearfix">
                                    <div class="clearfix text-right mb10">
                                      <button class="addbtn pointers flort" id="NewProductBtnHide" style="display: none;" type="button" onclick="$('#warningSubmit').modal('show');">+ New Product</button>
                                      <button class="addbtn pointers flort" id="NewProductBtnShow" type="button" data-related="add_product" onclick="openProductBox()">+ New Product</button>
                                    </div>
                                    <div class="input-group">
                                    <a onclick="openUpdateWarning('Product_Name')"><input type="text" placeholder="Fill Product name" id="Product_Name" name="product_name" onclick="showHideChangePopUp('div_change_qty1')" onmouseleave="hideMouseMove('div_change_qty1')" class="form-control pointers"></a>
									<div id='div_change_qty1' style='display:none;width:100%;height:29px;position:absolute;z-index:10;background:rgb(239 239 239);padding-left: 13px;padding-top: 4px;border-radius: 4px;' >
									  <span style="color: #4ac4f3;font-size: 14px;">Type to search product name</span>									    
									</div>
                                    </div>
                                    <div id="companyErrorMSGdiv" class="errormsg"></div>
                                    <button class="addbtn pointers new_con_add close_icon3" autocomplete="off" type="button" id="MainProductCloseBtn" onclick="$('#warningModal').modal('show');" style="margin-right: 18px;display: none;"><i class="fa fa-times" style="font-size: 21px;"></i></button>
                                   </div>
                                  </div>
								  </div>
								  <div class="clearfix inner_box_bg showDiv" id="MainSubDivCont" style="display: none;"> 
								 <div class="row">
								 <div class="col-md-6 col-sm-6 col-xs-12">
                                 <div class="mb10">
                                  <div class="input-group bdlftnone">
                                  <input type="text" name="subproducttype" autocomplete="off" id="SubProductType" class="form-control pdl6 " value="" placeholder="Product Type" readonly="readonly">
                                  </div>
                                 </div>
                                </div>
                                <input type="hidden" id="productregrefid" name="productregrefid">
								<div class="col-md-6 col-sm-6 col-xs-12">
                                 <div class="mb10">
                                  <div class="input-group bdlftnone">
                                  <input type="text" name="subproductname" autocomplete="off" id="SubProductName" style="border-radius: 2px;" class="form-control pdl6" value="" placeholder="Product Name" readonly="readonly">
                                  </div>
                                 </div>
                                </div>
							    </div>
								</div>                              
								<div class="clearfix" id="RefreshAllDiv">
								<div class="clearfix" id="RefreshAllDiv1">
	<!-- 	price  start-->
								<div class="clearfix" id="ProductPriceDivSpace" style="display: none;">							
								<div class="row">
                                  <div class="col-md-12 col-sm-12 col-xs-12">
                                   <div class="clearfix">                                    
                                    <div class="input-group">
                                    <input type="text" placeholder="Product price" autocomplete="off" id="Product_Price" name="product_price" class="form-control" readonly="readonly">
									</div>
                                    </div>
                                  </div>
								  </div>
								  <div class="clearfix inner_box_bg showDiv" id="MainSubDivCont" style="display: block;"> 
								 <div class="mb10 flex_box align_center relative_box">
									<span class="input_radio bg_wht pad_box2 pad_box3"> 
									<input type="checkbox" name="globalType" id="Global" value="1">
									<span>Global</span>
									</span>
									<span class="mlft10 input_radio bg_wht pad_box2 pad_box3"> 
									<input type="checkbox" name="centralType" id="Central" value="1">
									<span>Central</span>
									</span>
									<span class="mlft10 input_radio bg_wht pad_box2 pad_box3">
									<input type="checkbox" name="stateType" id="State" value="1">
									<span>State</span>
									</span>									
									</div>								 
								 <div class="clearfix  clerrow link-style12">
								 
								 <div class="row" id="PriceRow">
								 <div class="col-md-3 col-sm-3 col-xs-12">                               
                                  <input type="text" name="addservicename" value="Professional fees" autocomplete="off" id="AddServiceName" class="form-control bdrnone" placeholder="Add Service" readonly="readonly">
                                 </div>
								<div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" name="addproductprice" autocomplete="off" id="AddProductPrice" onchange="updatePriceList('AddProductPrice','ppvprice','PriceRow','ProductTotalPrice');"  class="form-control bdrnone" value="" placeholder="Price" onkeypress="return isNumberKey(event)">
                                 </div>                                 
                                <div class="col-md-2 col-sm-2 col-xs-12">  
                                <div class="clearfix relative_box" onmouseover="showOptions('SmallBtnEdit','SmallBtnPlus')" onmouseout="hideOptions('SmallBtnEdit','SmallBtnPlus')">
                                 <div class="fa fa-pencil smallBtnEdit pointers" id="SmallBtnEdit" title="Edit" onclick="setDivId('HSNCode','AppliedTax','PriceRow')"></div>
  								 <div class="fa fa-plus-circle smallBtnPlus pointers" data-toggle="modal" data-target="#TaxModal" id="SmallBtnPlus" title="Add" onclick="setActions('HSNCode','AppliedTax','PriceRow')"></div>
                                <input type="text" id="HSNCode" onkeypress="searchHSNCode('HSNCode','AppliedTax')" onchange="updatePriceList('HSNCode','ppvhsncode','PriceRow','NA');" class="form-control bdrnone" autocomplete="off" placeholder="HSN for tax">
                                </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" name="appliedtax" autocomplete="off"  id="AppliedTax" class="form-control bdrnone" placeholder="Tax" readonly="readonly">
                                 </div>
                                <div class="col-md-3 col-sm-2 col-xs-12">                                                     
                                  <input type="text" name="producttotalprince" autocomplete="off" id="ProductTotalPrice" class="form-control bdrnone" value="" placeholder="Total Price" onkeypress="return isNumberKey(event)" readonly="readonly">
                                 </div>
                                 
                                </div>                                
<!--second row -->
                  				<div class="row" id="Price1Row">
								 <div class="col-md-3 col-sm-3 col-xs-12">                               
                                  <input type="text" name="addservice1name" value="Government fees" autocomplete="off" id="AddService1Name" class="form-control bdrnone" placeholder="Add Service" readonly="readonly">
                                 </div>
								<div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" name="addproduct1price" autocomplete="off" id="AddProduct1Price" onchange="updatePriceList('AddProduct1Price','ppvprice','Price1Row','Product1TotalPrice');"  class="form-control bdrnone" placeholder="Price" onkeypress="return isNumberKey(event)">
                                 </div>                                 
                                <div class="col-md-2 col-sm-2 col-xs-12">  
                                <div class="clearfix relative_box" onmouseover="showOptions('SmallBtn1Edit','SmallBtn1Plus')" onmouseout="hideOptions('SmallBtn1Edit','SmallBtn1Plus')">
                                 <div class="fa fa-pencil smallBtnEdit pointers" id="SmallBtn1Edit" title="Edit" onclick="setDivId('HSN1Code','Applied1Tax','Price1Row')"></div>
  								 <div class="fa fa-plus-circle smallBtnPlus pointers" data-toggle="modal" data-target="#TaxModal" id="SmallBtn1Plus" title="Add" onclick="setActions('HSN1Code','Applied1Tax','Price1Row')"></div>
                                <input type="text" id="HSN1Code" onkeypress="searchHSNCode('HSN1Code','Applied1Tax')" onchange="updatePriceList('HSN1Code','ppvhsncode','Price1Row','NA');" class="form-control bdrnone" autocomplete="off" placeholder="HSN for tax">
                                </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" name="applied1tax" autocomplete="off"  id="Applied1Tax" class="form-control bdrnone" placeholder="Tax" readonly="readonly">
                                 </div>
                                <div class="col-md-3 col-sm-2 col-xs-12">                                                     
                                  <input type="text" name="product1totalprince" autocomplete="off" id="Product1TotalPrice" class="form-control bdrnone" value="" placeholder="Total Price" onkeypress="return isNumberKey(event)" readonly="readonly">
                                 </div>
                                 
                                </div>
<!--                                 third row               -->
								<div class="row" id="Price2Row">
								 <div class="col-md-3 col-sm-3 col-xs-12">                               
                                  <input type="text" name="addservice2name" value="Service charges" autocomplete="off" id="AddService2Name" class="form-control bdrnone" placeholder="Add Service" readonly="readonly">
                                 </div>
								<div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" name="addproduct2price" autocomplete="off" id="AddProduct2Price" onchange="updatePriceList('AddProduct2Price','ppvprice','Price2Row','Product2TotalPrice');"  class="form-control bdrnone" value="" placeholder="Price" onkeypress="return isNumberKey(event)">
                                 </div>                                 
                                <div class="col-md-2 col-sm-2 col-xs-12">  
                                <div class="clearfix relative_box" onmouseover="showOptions('SmallBtn2Edit','SmallBtn2Plus')" onmouseout="hideOptions('SmallBtn2Edit','SmallBtn2Plus')">
                                 <div class="fa fa-pencil smallBtnEdit pointers" id="SmallBtn2Edit" title="Edit" onclick="setDivId('HSN2Code','Applied2Tax','Price2Row')"></div>
  								 <div class="fa fa-plus-circle smallBtnPlus pointers" data-toggle="modal" data-target="#TaxModal" id="SmallBtn2Plus" title="Add" onclick="setActions('HSN2Code','Applied2Tax','Price2Row')"></div>
                                <input type="text" id="HSN2Code" onkeypress="searchHSNCode('HSN2Code','Applied2Tax')" onchange="updatePriceList('HSN2Code','ppvhsncode','Price2Row','NA');" class="form-control bdrnone" autocomplete="off" placeholder="HSN for tax">
                                </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" name="applied2tax" autocomplete="off"  id="Applied2Tax" class="form-control bdrnone" placeholder="Tax" readonly="readonly">
                                 </div>
                                <div class="col-md-3 col-sm-2 col-xs-12">                                                     
                                  <input type="text" name="product2totalprince" autocomplete="off" id="Product2TotalPrice" class="form-control bdrnone" value="" placeholder="Total Price" onkeypress="return isNumberKey(event)" readonly="readonly">
                                 </div>                                
                                </div>
<!--                                 fourth row -->
								<div class="row" id="Price3Row">
								 <div class="col-md-3 col-sm-3 col-xs-12">                               
                                  <input type="text" name="addservice3name" value="Other fees" autocomplete="off" id="AddService3Name" class="form-control bdrnone" placeholder="Add Service" readonly="readonly">
                                 </div>
								<div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" name="addproduct3price" autocomplete="off" id="AddProduct3Price" onchange="updatePriceList('AddProduct3Price','ppvprice','Price3Row','Product3TotalPrice');"  class="form-control bdrnone" value="" placeholder="Price" onkeypress="return isNumberKey(event)">
                                 </div>                                 
                                <div class="col-md-2 col-sm-2 col-xs-12">  
                                <div class="clearfix relative_box" onmouseover="showOptions('SmallBtn3Edit','SmallBtn3Plus')" onmouseout="hideOptions('SmallBtn3Edit','SmallBtn3Plus')">
                                 <div class="fa fa-pencil smallBtnEdit pointers" id="SmallBtn3Edit" title="Edit" onclick="setDivId('HSN3Code','Applied3Tax','Price3Row')"></div>
  								 <div class="fa fa-plus-circle smallBtnPlus pointers" data-toggle="modal" data-target="#TaxModal" id="SmallBtn3Plus" title="Add" onclick="setActions('HSN3Code','Applied3Tax','Price3Row')"></div>
                                <input type="text" id="HSN3Code" onkeypress="searchHSNCode('HSN3Code','Applied3Tax')" onchange="updatePriceList('HSN3Code','ppvhsncode','Price3Row','NA');" class="form-control bdrnone" autocomplete="off" placeholder="HSN for tax">
                                </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" name="applied3tax" autocomplete="off"  id="Applied3Tax" class="form-control bdrnone" placeholder="Tax" readonly="readonly">
                                 </div>
                                <div class="col-md-3 col-sm-2 col-xs-12">                                                     
                                  <input type="text" name="producttotal3prince" autocomplete="off" id="Product3TotalPrice" class="form-control bdrnone" value="" placeholder="Total Price" onkeypress="return isNumberKey(event)" readonly="readonly">
                                 </div>
                                </div>
							    </div>  
							    
							    <div class="clearfix" id="NewProductPriceLine"></div>
							    
							    <div class="row" style="margin-top: 3px;"> 
							    <div class="col-md-6">
							    <button class="addbtn pointers" type="button" onclick="addNewLinePrice('NewProductPriceLine')">+ New Line</button>
							    </div>
							     <div class="col-md-6" style="padding-left: 170px;">
								<div class="box-width26 col-xs-6 box-intro-background"><div class="clearfix"><p class="news-border justify_end">Total:</p></div></div>
							    <div class="box-width50 col-xs-6 box-intro-background"><div class="clearfix"><p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i>
							    <input type="text" class="form-control BrdNone" id="ji9Mnh87x5I1CWn" value="00.00" style="height: 38px;margin-left: 2px;" readonly="readonly"></p></div></div>
							    </div>							    
							    </div>
								</div>
								</div>
<!-- 	price  end-->
<!-- 	milestone  start-->
							<div class="clearfix" id="ProductMilestoneDivSpace" style="display: none;">	
								<div class="row">
                                  <div class="col-md-12 col-sm-12 col-xs-12">
                                   <div class="clearfix">                                    
                                    <div class="input-group">
                                    <input type="text" placeholder="Product Milestone" autocomplete="off" id="Product_Milestone" name="product_milestone" class="form-control" readonly="readonly">
									</div>
                                    </div>
                                  </div>
								  </div>
								  <div class="clearfix inner_box_bg showDiv" id="MainSubDivCont" style="display: block;"> 
								 
								 
								 <div class="clearfix  clerrow link-style12" id="ProductMilestoneDivId">
								 <div class="row" id="MilestoneRowId">
								 <div class="col-md-4 col-sm-4 col-xs-12">                               
                                  <input type="text" name="addmilestonename" onchange="updateMilestoneList('AddMilestoneName','mvmilestonename','MilestoneRowId')" autocomplete="off" id="AddMilestoneName" class="form-control bdrnone" value="" placeholder="Milestone Name" onblur="validCompanyNamePopup('AddMilestoneName')">
                                 </div>
								<div class="col-md-2 col-sm-3 col-xs-12">                                                                   
                                  <input type="text" name="addtimelinevalue" onchange="updateMilestoneList('MainTimelineValue','mvtimelinevalue','MilestoneRowId')" autocomplete="off"  onclick="showTimelineBox('TimelineBox')" id="MainTimelineValue" class="form-control bdrnone text-right pointers" placeholder="Timeline" style="width: 50%;" readonly="readonly" onkeypress="return isNumber(event)">
                                 <input type="text" name="addtimelineunit" autocomplete="off" id="MainTimelineUnit" class="form-control bdrnone pointers" readonly="readonly" style="width: 50%;position: absolute;top: 0px;right: 10px;">
                                 <div class="timeline_box" id="TimelineBox">
							    <div class="timeline_inner">
							    	<span id="MilestoneInputDiv4" onclick="addInput('TimelineBox','MainTimelineUnit','Minute','MainTimelineValue','mvtimelineunit','MilestoneRowId')">Minute</span>
							    	<span id="MilestoneInputDiv5" onclick="addInput('TimelineBox','MainTimelineUnit','Hour','MainTimelineValue','mvtimelineunit','MilestoneRowId')">Hour</span>
								    <span id="MilestoneInputDiv" onclick="addInput('TimelineBox','MainTimelineUnit','Day','MainTimelineValue','mvtimelineunit','MilestoneRowId')">Day</span>
								    <span id="MilestoneInputDiv1" onclick="addInput('TimelineBox','MainTimelineUnit','Week','MainTimelineValue','mvtimelineunit','MilestoneRowId')">Week</span >
								    <span id="MilestoneInputDiv2" onclick="addInput('TimelineBox','MainTimelineUnit','Month','MainTimelineValue','mvtimelineunit','MilestoneRowId')">Month</span>
								    <span id="MilestoneInputDiv3" onclick="addInput('TimelineBox','MainTimelineUnit','Year','MainTimelineValue','mvtimelineunit','MilestoneRowId')">Year</span>
							    </div>
							     </div>
                                 </div>
                                <div class="box-width16 col-md-1 col-sm-2 col-xs-12">                                                                 
                                  <input type="text" title="Step No." name="Steps" autocomplete="off" onchange="updateMilestoneList('Steps','mvstep','MilestoneRowId')" id="Steps" class="form-control bdrnone" placeholder="Steps" onkeypress="return isNumber(event)">
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" title="Next Milestone assign percentage" name="Assign" autocomplete="off" onchange="updateMilestoneList('Assign','mvassign','MilestoneRowId')"  id="Assign" class="form-control bdrnone" placeholder="Assign %" onkeypress="return isNumberKey(event)">
                                 </div>  
                                 <div class="box-width8 col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" title="Work Price Percentage" name="pricePercent" autocomplete="off" onchange="validateNumber(this.value,'PricePercent');updateMilestoneList('PricePercent','mvpricepercent','MilestoneRowId');"  id="PricePercent" class="form-control bdrnone" placeholder="price %" onkeypress="return isNumber(event)">
                                 </div>                               
                                 <div class="col-md-1 col-sm-1 col-xs-12">
                                 <div class="delIcon">                                  
                                  <i class="fa fa-trash cursor_not" title="delete"></i>
                                  </div>
                                </div>
                                </div>
							    </div>
							    
							    <div class="clearfix" id="NewProductMilestoneLine"></div>
							    
							    <div class="clearfix" style="margin-top: 3px;"> 
							    <button class="addbtn pointers" type="button" onclick="addNewLineMilestone('NewProductMilestoneLine')">+ New Line</button>
							    </div>
								</div>
								</div>
<!-- 	milestone  end-->	
<!-- 	document  start-->
							<div class="clearfix" id="ProductDocumentDivSpace" style="display: none;">		
								<div class="row">
                                  <div class="col-md-12 col-sm-12 col-xs-12">
                                   <div class="clearfix">                                    
                                    <div class="input-group">
                                    <input type="text" placeholder="Documents" autocomplete="off" id="Product_Documents" name="product_documents" class="form-control" readonly="readonly">
									</div>
                                    </div>
                                  </div>
								  </div>
								  <div class="clearfix inner_box_bg showDiv" id="MainSubDivCont"> 
								 
								 <div class="clearfix  clerrow link-style12" id="DocumentDivId">
								 <div class="row" id="DocumentRow">
								 <div class="col-md-4 col-sm-4 col-xs-12">                               
                                  <input type="text" name="productdocumentname" onchange="updateDocumentList('ProductDocumentName','dvdocname','DocumentRow')" autocomplete="off" id="ProductDocumentName" class="form-control bdrnone" value="" placeholder="Document Name" onblur="validCompanyNamePopup('ProductDocumentName')">
                                 </div>
								<div class="col-md-4 col-sm-5 col-xs-12">                                                                   
                                  <input type="text" name="documentdescription" onchange="updateDocumentList('DocumentDescription','dvdescription','DocumentRow')" autocomplete="off" id="DocumentDescription" class="form-control bdrnone" value="" placeholder="Description">
                                 </div>               
                                 <div class="col-md-2 col-sm-2 col-xs-12">                                                                   
                                  <input type="text" name="UploadTo" onclick="showTimelineBox('UploadToDoc')" autocomplete="off" id="UploadTo" class="form-control bdrnone pointers" value="Agent" readonly="readonly">
                                 <div class="documentfor_box" id="UploadToDoc">
							    <div class="timeline_inner">
							    <span id="UploadByDiv" onclick="addInputDocFor('UploadToDoc','UploadTo','Agent','dvuploadfrom','DocumentRow')">Agent</span> <span id="UploadByDiv1" onclick="addInputDocFor('UploadToDoc','UploadTo','Client','dvuploadfrom','DocumentRow')">Client</span ></div>
							    </div>
                                 </div>                                               
                                 <div class="col-md-2 col-sm-1 col-xs-12">
                                 <div class="delIcon">  
                                 <span class="" id="documentVisibility" onclick="documentVisibility('documentVisibility','dvvisibilitystatus','DocumentRow','new')">
									<i class="pointers" id="documentVisibilityClass" title="Visibility" style="font-size:20px;"></i>
								 </span>                                
                                  <i class="fa fa-trash cursor_not" title="delete"></i>
                                  </div>
                                </div>
                                </div>
							    </div>
							   
							    <div class="clearfix" id="NewProductDocumentLine"></div>
							    
							    <div class="clearfix" style="margin-top: 3px;"> 
							    <button class="addbtn pointers" type="button" onclick="addNewLineDocument('NewProductDocumentLine')">+ New Line</button>
							    </div>
								</div>
								</div>
<!-- 	document  end-->	
								</div>
								</div>
								<div class="row info-extra">
								 <div class="col-md-6 col-sm-6 col-xs-6">
                                  <div class="form-group">
                                    <label>TAT Value : <span style="color: #4ac4f3;">*</span></label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="fa fa-clock-o" style="color: #4ac4f3;"></i></span>
                                    <input type="text" class="form-control" autocomplete="off" name="productTat"
                                     id="Product_TAT" placeholder="TAT Value !" onkeypress="return isNumber(event)" required="required">
                                    </div>
                                  </div>
                                  </div>
								 <div class="col-md-6 col-sm-6 col-xs-6">
                                   <div class="form-group">
                                    <label>TAT Type : <span style="color: #4ac4f3;">*</span></label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="fa fa-clock-o" style="color: #4ac4f3;"></i></span>
                                    <select name="tatType" id="tatType" class="form-control" required="required">
                                    	<option value="">Select Type</option>
                                    	<option value="Minute">Minute</option>
                                    	<option value="Hour">Hour</option>
                                    	<option value="Day">Day</option>
                                    	<option value="Week">Week</option>
                                    	<option value="Month">Month</option>
                                    	<option value="Year">Year</option>
                                    </select>
                                    </div>
                                  </div>
                                  </div>
								</div>
                                 <div class="row"> 
                                  <div class="col-md-12 col-sm-12 col-xs-12 info-extra">
                                  <div class="form-group">
                                    <label>Remarks : <span style="color: #4ac4f3;">*</span></label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="fa fa-comments-o" style="color: #4ac4f3;"></i></span>
                                    <textarea class="form-control" autocomplete="off" name="productRemarks" id="Product_Remarks" onblur="validateLocationPopup('Product_Remarks');validateValuePopup('Product_Remarks');" rows="3" placeholder="Remarks here !"></textarea>
                                    </div>
                                  </div>
                                  </div>
                                  <div class="col-md-12 col-sm-12 col-xs-12 mtop10">
                                  <button class="bt-link bt-radius bt-loadmore mrt10" type="button" onclick="location.reload(true)" style="background: none;color: #4ac4f3;">Reset</button>
                                  <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateProduct();">Submit</button>
                                  </div>
                               </div>
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

<!-- Start right side box -->

<div class="fixed_right_box">

<div class="clearfix add_inner_box pad_box4 addcompany" id="update_product">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-building-o"></i>Update Product</h3> 
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>
<form onsubmit="return false;" id="UpdateRegProduct">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="updatenewproducttype" id="UpdateNewProductType" onblur="validCompanyNamePopup('UpdateNewProductType');validateValuePopup('UpdateNewProductType');" placeholder="Product Type" class="form-control bdrd4">
 </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="updatenewproductname" id="UpdateNewProductName" onchange="isExistEditProduct('UpdateNewProductName','UpdateNewProductType','pname')" placeholder="Product Name" onblur="validCompanyNamePopup('UpdateNewProductName');validateValuePopup('UpdateNewProductName')" class="form-control bdrd4">
  </div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
  <label>Product Description :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" rows="4" name="updateproductdescription" id="UpdateProductDescription" placeholder="Product Description" onblur="validateLocationPopup('UpdateProductDescription');validateValuePopup('UpdateProductDescription');" ></textarea>
  </div>
</div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateUpdateProduct();">update</button>
</div>
</form>                                  
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="add_product">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-building-o"></i>New Product</h3> 
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>
<form onsubmit="return false;" id="RegNewProduct">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="newproducttype" id="NewProductType" onblur="validCompanyNamePopup('NewProductType');validateValuePopup('NewProductType');" placeholder="Product Type" class="form-control bdrd4">
 </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="newproductname" id="NewProductName" onchange="isExistProduct('NewProductName','pname','ptype','NewProductType')" placeholder="Product Name" onblur="validCompanyNamePopup('NewProductName');validateValuePopup('NewProductName')" class="form-control bdrd4">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
  <label>Product Description :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" rows="4" name="productdescription" id="ProductDescription" placeholder="Product Description" onblur="validateLocationPopup('ProductDescription');validateValuePopup('ProductDescription');" ></textarea>
  </div>
</div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateRegisterProduct();">Submit</button>
</div>
</form>                                  
</div>
</div>

<div class="modal fade" id="warningModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">Do you really want to discard this changes ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="clearMainProduct('MainProductCloseBtn','Product_Name');">Yes</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="warningSubmit" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">Do you really want to discard this changes ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary addnew" data-dismiss="modal" data-related="add_product" onclick="openProductBox()">Yes</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="warningUpdate" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">Do you really want to discard this changes ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary updateProduct" data-dismiss="modal" data-related="update_product" onclick="UpdateProductBox('Product_Name','productregrefid')">Yes</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="warningBack" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">Do you really want to discard this changes ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location='<%=request.getContextPath()%>/manage-product.html'">Yes</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="EditTaxModal" tabindex="-1" role="dialog" aria-labelledby="EditTaxModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false" id="RegisterEditTaxForm">
  <input type="hidden" id="KeyIdForm" value="NA"/>
    <input type="hidden" id="HsnEditTaxBoxId" value="NA"/>
  <input type="hidden" id="HsnEditTaxAppliedBoxId" value="NA"/>
  <input type="hidden" id="HsnEditTaxRowId" value="NA"/>
  <input type="hidden" id="HsnEditTaxUid" value="NA"/>
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Update this sale tax</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>HSN</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="EditHSNCode" placeholder="HSN Code" class="form-control" readonly="readonly">
		</div>
		</div>
		</div>
        <div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>CGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="EditCGSTRate" placeholder="CGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>SGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="EditSGSTRate" placeholder="CGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>IGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="EditIGSTRate" placeholder="IGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>Additional description</label>
		<div class="input-group">
		 <textarea class="form-control" autocomplete="off" rows="3" name="expensenote" id="EditTaxNote" placeholder="Additional description" onblur="validateValuePopup('TaxNote');"></textarea>
		</div>
		</div>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="return validateEditTax()">Update</button>
      </div>
    </div>
    </form>
  </div>
</div>
<div class="modal fade" id="TaxModal" tabindex="-1" role="dialog" aria-labelledby="TaxModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false" id="RegisterNewTaxForm">
  <input type="hidden" id="HsnTaxBoxId" value="NA"/>
  <input type="hidden" id="HsnTaxAppliedBoxId" value="NA"/>
  <input type="hidden" id="HsnTaxRowId" value="NA"/>
  <input type="hidden" id="HsnTaxUid" value="NA"/>
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Create a sale tax</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>HSN</label>
		<div class="input-group">
		<input type="text" onchange="isExistValue('HSNCodeNo')" autocomplete="off" id="HSNCodeNo" placeholder="HSN Code" class="form-control">
		</div>
		</div>
		</div>
        <div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>CGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="CGSTRate" placeholder="CGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>SGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="SGSTRate" placeholder="CGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>IGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="IGSTRate" placeholder="IGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>Additional description</label>
		<div class="input-group">
		 <textarea class="form-control" autocomplete="off" rows="3" name="expensenote" id="TaxNote" placeholder="Additional description" onblur="validateValuePopup('TaxNote');"></textarea>
		</div>
		</div>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="return validateTax()">Submit</button>
      </div>
    </div>
    </form>
  </div>
</div>
<!-- start --> 
<input type="hidden" id="AddMilestoneCount" value="0"/>
<input type="hidden" id="AddPriceCount" value="0"/>
<input type="hidden" id="AddDocumentCount" value="0"/>
<input type="hidden" id="AddProductMilestoneError" value="1"/>
<!-- end -->

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<div id="AddJavaScriptCode"></div>
<script type="text/javascript">
$(".fancybox").fancybox({
    'href' : '#addNewPopup', 
    'autoScale': true,
	'autoDimensions': true,
    'centerOnScroll': true,
    'afterClose': function() {
    	$("#RegisterNewTaxForm").trigger("reset");
    }
	});	
/* new */
</script>
<script type="text/javascript">

function setMainActions(HSNCode,AppliedTax,uid){
	$('#HsnTaxBoxId').val(HSNCode);
	$('#HsnTaxAppliedBoxId').val(AppliedTax);
	$('#HsnTaxRowId').val('NA');
	$('#HsnTaxUid').val(uid);
	$('#RegisterNewTaxForm').trigger('reset');
}
function setActions(HSNCode,AppliedTax,PriceRow){
	$('#HsnTaxBoxId').val(HSNCode);
	$('#HsnTaxAppliedBoxId').val(AppliedTax);
	$('#HsnTaxRowId').val(PriceRow);
	$('#HsnTaxUid').val('NA');
	$('#RegisterNewTaxForm').trigger('reset');
}
function validateEditTax(){  
	var key=$("#KeyIdForm").val().trim();
	var hsntextboxid=$("#HsnEditTaxBoxId").val().trim();
	var taxappliedid=$("#HsnEditTaxAppliedBoxId").val().trim();
	var rowid=$("#HsnEditTaxRowId").val().trim();
	var uid=$("#HsnEditTaxUid").val().trim();
	
	var hsn=$("#EditHSNCode").val().trim();
	var cgst=$("#EditCGSTRate").val().trim();
	var sgst=$("#EditSGSTRate").val().trim();
	var igst=$("#EditIGSTRate").val().trim();
	var taxnotes=$("#EditTaxNote").val().trim();
	if(hsn==""){
		document.getElementById('errorMsg').innerHTML ="Fill HSN CODE.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(cgst==""){
		document.getElementById('errorMsg').innerHTML ="Fill CGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(sgst==""){
		document.getElementById('errorMsg').innerHTML ="Fill SGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(igst==""){
		document.getElementById('errorMsg').innerHTML ="Fill IGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(taxnotes==""){
		document.getElementById('errorMsg').innerHTML ="Fill Description.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}	
	
	$.ajax({
		type : "POST",
		url : "RegisterEditTax111",
		dataType : "HTML",
		data : {				
			hsn : hsn,
			cgst : cgst,
			sgst : sgst,
			igst : igst,
			taxnotes : taxnotes,
			key : key
		},
		success : function(data){
			if(data=="pass"){	
				$("#"+hsntextboxid).val(hsn);
				$("#"+taxappliedid).val(igst+" %");
				$("#EditTaxModal").modal('hide');
				if(uid=="NA"){updatePriceList(hsntextboxid,'ppvhsncode',rowid,'NA');
				}else{updateMainPriceList(hsntextboxid,'pp_hsncode',uid,'NA');}
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		}
	});
}

function validateTax(){ 
	var hsntextboxid=$("#HsnTaxBoxId").val().trim();
	var taxappliedid=$("#HsnTaxAppliedBoxId").val().trim();
	var rowid=$("#HsnTaxRowId").val().trim();
	var uid=$("#HsnTaxUid").val().trim();
	    
	var hsn=$("#HSNCodeNo").val().trim();
	var cgst=$("#CGSTRate").val().trim();
	var sgst=$("#SGSTRate").val().trim();
	var igst=$("#IGSTRate").val().trim();
	var taxnotes=$("#TaxNote").val().trim();
	
	if(hsn==""){
		document.getElementById('errorMsg').innerHTML ="Fill HSN CODE.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(cgst==""){
		document.getElementById('errorMsg').innerHTML ="Fill CGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(sgst==""){
		document.getElementById('errorMsg').innerHTML ="Fill SGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(igst==""){
		document.getElementById('errorMsg').innerHTML ="Fill IGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(taxnotes==""){
		document.getElementById('errorMsg').innerHTML ="Fill Description.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
		
	var key=makeid(40);
	
	$.ajax({
		type : "POST",
		url : "RegisterNewTax111",
		dataType : "HTML",
		data : {				
			hsn : hsn,
			cgst : cgst,
			sgst : sgst,
			igst : igst,
			taxnotes : taxnotes,
			key : key
		},
		success : function(data){
			if(data=="pass"){	
				$("#"+hsntextboxid).val(hsn);
				$("#"+taxappliedid).val(igst+" %");
				$("#TaxModal").modal('hide');	
				if(uid=="NA"){updatePriceList(hsntextboxid,'ppvhsncode',rowid,'NA');
				}else{updateMainPriceList(hsntextboxid,'pp_hsncode',uid,'NA');}
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		}
	});
}
function searchHSNCode(BoxId,GstBoxId){
$(function() {
	$("#"+BoxId).autocomplete({
		source : function(request, response) {
			if(document.getElementById(BoxId).value.trim().length>=1)
			$.ajax({
				url : "<%=request.getContextPath()%>/getnewproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "salehsntax",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							hsn : item.hsn,							
							igst : item.igst
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
            	document.getElementById('errorMsg').innerHTML ="Select from tax list";
            	$('.alert-show').show().delay(2000).fadeOut();
            	$("#"+BoxId).val("");  
            	$("#"+GstBoxId).val(""); 
            }
            else{              	
            	$("#"+BoxId).val(ui.item.hsn);
            	$("#"+GstBoxId).val(ui.item.igst+" %");
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
}

function setMainDivId(HSNBoxId,AppliedTax,BoxUid){
	var hsn=$("#"+HSNBoxId).val();
	if(hsn!=null&&hsn!=""){
		$.ajax({
			type : "POST",
			url : "GetSaleHSN111",
			dataType : "HTML",
			data : {				
				hsn : hsn
			},
			success : function(response){
				response = JSON.parse(response);
				var len=response.length;	
				if(Number(len)>0){
					for(var j=0;j<len;j++){
						var refid=response[j]['refid'];
						var sgst=response[j]['sgst'];
						var cgst=response[j]['cgst'];
						var igst=response[j]['igst'];
						var notes=response[j]['notes'];
						$('#KeyIdForm').val(refid);
						$('#EditHSNCode').val(hsn);
						$('#EditCGSTRate').val(cgst);
						$('#EditSGSTRate').val(sgst);
						$('#EditIGSTRate').val(igst);
						$('#EditTaxNote').val(notes);
					}
					$('#HsnEditTaxBoxId').val(HSNBoxId);
					$('#HsnEditTaxAppliedBoxId').val(AppliedTax);
					$('#HsnEditTaxRowId').val('NA');
					$('#HsnEditTaxUid').val(BoxUid);
					$('#EditTaxModal').modal('show'); 
					
				}else{
					document.getElementById('errorMsg').innerHTML ='Please enter a valid HSN No. !!';		
					$("#"+HSNBoxId).val("");
					$('.alert-show').show().delay(3000).fadeOut();
				}
			}
		});	
	}else{
		document.getElementById('errorMsg').innerHTML ='Please enter a valid HSN No. !!';		
		$('.alert-show').show().delay(3000).fadeOut();
	}
}

function setDivId(HSNBoxId,AppliedTax,PriceRow){
	var hsn=$("#"+HSNBoxId).val();
	if(hsn!=null&&hsn!=""){
		$.ajax({
			type : "POST",
			url : "GetSaleHSN111",
			dataType : "HTML",
			data : {				
				hsn : hsn
			},
			success : function(response){
				response = JSON.parse(response);
				var len=response.length;	
				if(Number(len)>0){
					for(var j=0;j<len;j++){
						var refid=response[j]['refid'];
						var sgst=response[j]['sgst'];
						var cgst=response[j]['cgst'];
						var igst=response[j]['igst'];
						var notes=response[j]['notes'];
						$('#KeyIdForm').val(refid);
						$('#EditHSNCode').val(hsn);
						$('#EditCGSTRate').val(cgst);
						$('#EditSGSTRate').val(sgst);
						$('#EditIGSTRate').val(igst);
						$('#EditTaxNote').val(notes);
					}
					$('#HsnEditTaxBoxId').val(HSNBoxId);
					$('#HsnEditTaxAppliedBoxId').val(AppliedTax);
					$('#HsnEditTaxRowId').val(PriceRow);
					$('#HsnEditTaxUid').val('NA');
					$('#EditTaxModal').modal('show'); 
					
				}else{
					document.getElementById('errorMsg').innerHTML ='Please enter a valid HSN No. !!';		
					$("#"+HSNBoxId).val("");
					$('.alert-show').show().delay(3000).fadeOut();
				}
			}
		});	
	}else{
		document.getElementById('errorMsg').innerHTML ='Please enter a valid HSN No. !!';		
		$('.alert-show').show().delay(3000).fadeOut();
	}
}

function isExistValue(textboxid){
	var val=$("#"+textboxid).val();
	$.ajax({
		type : "GET",
		url : "IsExistSaleHSN111",
		dataType : "HTML",
		data : {				
			val : val
		},
		success : function(data){
			if(data=="pass"){	
				document.getElementById('errorMsg').innerHTML = val+' already existed !!';
				$("#"+textboxid).val("");
				$('.alert-show').show().delay(3000).fadeOut();
			}
		}
	});
}
function showOptions(SmallBtnEditid,SmallBtnPlusid){
	$("#"+SmallBtnEditid).show();
	$("#"+SmallBtnPlusid).show();
}
function hideOptions(SmallBtnEditid,SmallBtnPlusid){
	$("#"+SmallBtnEditid).hide();
	$("#"+SmallBtnPlusid).hide();
}
// start AppliedTax
function openUpdateWarning(productboxid){
	if(document.getElementById(productboxid).readOnly){
		$('#warningUpdate').modal('show');
	}
}

function setMainSubTotalPrice(){	
	var prodrefid=$("#productregrefid").val();
	$.ajax({
		type : "POST",
		url : "GetMainPriceSubTotal111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid
		},
		success : function(data){
			$("#ji9Mnh87x5I1CWn").val(data.trim());		
		}
	});	
}

function setSubTotalPrice(){
	var prodrefid=$("#productregrefid").val();
	$.ajax({
		type : "POST",
		url : "GetPriceSubTotal111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid			
		},
		success : function(data){	
			$("#ji9Mnh87x5I1CWn").val(data.trim());				
		}
	});	
}
function updateMainDocumentList(TextBoxId,column,uid){
	var val=$("#"+TextBoxId).val();
	$.ajax({
		type : "POST",
		url : "UpdateMainDocumentData111",
		dataType : "HTML",
		data : {
			column : column,
			val : val,
			uid : uid
		},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg1").innerHTML="Updated.";
			$('.alert-show1').show().delay(300).fadeOut();			
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try-Again Later.";
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function updateDocumentList(TextBoxId,colname,rowid){
	var prodrefid=$("#productregrefid").val();
	var val=$("#"+TextBoxId).val();
	
	$.ajax({
		type : "POST",
		url : "UpdateDocumentData111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			colname : colname,
			val : val,
			rowid : rowid
		},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg1").innerHTML="Updated.";
			$('.alert-show1').show().delay(300).fadeOut();			
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try-Again Later.";
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function updateMainMilestoneList(TextBoxId,colname,uid){
	var val=$("#"+TextBoxId).val();	
	$.ajax({
		type : "POST",
		url : "UpdateMainMilestoneData111",
		dataType : "HTML",
		data : {
			colname : colname,
			val : val,
			uid : uid
		},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg1").innerHTML="Updated.";
			$('.alert-show1').show().delay(300).fadeOut();			
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try-Again Later.";
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function updateMilestoneList(TextBoxId,colname,rowid){
	var prodrefid=$("#productregrefid").val();
	var val=$("#"+TextBoxId).val();
	
	$.ajax({
		type : "POST",
		url : "UpdateMilestoneData111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			colname : colname,
			val : val,
			rowid : rowid
		},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg1").innerHTML="Updated.";
			$('.alert-show1').show().delay(300).fadeOut();			
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try-Again Later.";
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function updateMainPriceList(TextBoxId,colname,uid,ProductTotalPriceId){
	var val=$("#"+TextBoxId).val();	
	$.ajax({
		type : "POST",
		url : "UpdateMainProductsPrice111",
		dataType : "HTML",
		data : {
			colname : colname,
			val : val,
			uid : uid
		},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg1").innerHTML="Updated.";
			$('.alert-show1').show().delay(300).fadeOut();
			
			if(colname=="pp_price"&&val==""||val=="0"){
				$("#"+ProductTotalPriceId).val(0);				
				setMainSubTotalPrice();	
			}else if(colname=="pp_price"&&val!=""){
				$("#"+ProductTotalPriceId).val(val);				
				setMainSubTotalPrice();	
			}
			
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try-Again Later.";
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function updatePriceList(TextBoxId,colname,rowid,ProductTotalPriceId){
	var prodrefid=$("#productregrefid").val();
	var val=$("#"+TextBoxId).val();
	
	$.ajax({
		type : "POST",
		url : "UpdateProductsPrice111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			colname : colname,
			val : val,
			rowid : rowid
		},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg1").innerHTML="Updated.";
			$('.alert-show1').show().delay(300).fadeOut();
			
			if(colname=="ppvprice"&&val==""||val=="0"){				
				$("#"+ProductTotalPriceId).val(0);		
				setSubTotalPrice();
			}else if(colname=="ppvprice"&&val!=""){			
				$("#"+ProductTotalPriceId).val(val);
				setSubTotalPrice();
			}			
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try-Again Later.";
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}
	function isExistEditProduct(textboxid,TextBoxserviceid,condcolumn){
		var prodrefid=$("#productregrefid").val();
		var val=document.getElementById(textboxid).value.trim();
		
		var servicetype=document.getElementById(TextBoxserviceid).value.trim();
		
		if(servicetype!=""&&servicetype!="NA"){
		if(val!=""&&val!="NA"){
			
		$.ajax({
			type : "POST",
			url : "IsExistEditProduct111",
			dataType : "HTML",
			data : {
				val : val,
				condcolumn : condcolumn,
				prodrefid : prodrefid,
				servicetype : servicetype
			},
			success : function(data){
				if(data=="pass"){
				document.getElementById("errorMsg").innerHTML=val +" is already existed.";
				document.getElementById(textboxid).value="";
				$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
	}else{
		document.getElementById("errorMsg").innerHTML=" Enter Valid Product Name.";
		$('.alert-show').show().delay(4000).fadeOut();
	}}else{
		document.getElementById("errorMsg").innerHTML=" Enter Product Type First.";
		document.getElementById(textboxid).value="";
		$('.alert-show').show().delay(4000).fadeOut();
	}
	}

function isExistProduct(textboxid,condcolumn,servicecol,TextBoxserviceid){
	var val=document.getElementById(textboxid).value.trim();
	var servicetype=document.getElementById(TextBoxserviceid).value.trim();
	
	var tokencol="ptokenno";
	var tablename="product_master";
	var tableid="pid";
	if(servicetype!=""&&servicetype!="NA"){
	if(val!=""&&val!="NA"){
		
	$.ajax({
		type : "POST",
		url : "IsExistProduct111",
		dataType : "HTML",
		data : {
			val : val,
			tablename : tablename,
			tableid : tableid,
			tokencol : tokencol,
			condcolumn : condcolumn,
			servicecol : servicecol,
			servicetype : servicetype
		},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(textboxid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}else{
	document.getElementById("errorMsg").innerHTML=" Enter Valid Product Name.";
	$('.alert-show').show().delay(4000).fadeOut();
}}else{
	document.getElementById("errorMsg").innerHTML=" Enter Product Type First.";
	document.getElementById(textboxid).value="";
	$('.alert-show').show().delay(4000).fadeOut();
}
}

function validateUpdateProduct(){  
	  
	
	var servicetype=$("#UpdateNewProductType").val().trim();
	var productname=$("#UpdateNewProductName").val().trim();
	var productremarks=$("#UpdateProductDescription").val().trim();
	
	if(servicetype==""){
		document.getElementById('errorMsg').innerHTML ="Fill Product Type.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(productname==""){
		document.getElementById('errorMsg').innerHTML ="Fill Product Name.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(productremarks==""){
		document.getElementById('errorMsg').innerHTML ="Fill Product description.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	var prodrefid=$("#productregrefid").val();
	
	$.ajax({
		type : "POST",
		url : "UpdateProduct111",
		dataType : "HTML",
		data : {				
			servicetype : servicetype,
			productname : productname,
			productremarks : productremarks,
			prodrefid : prodrefid
		},
		success : function(data){
			if(data=="pass"){				
				
				refreshUpdateContainer(productname,servicetype,productremarks);
				document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';				  
				
				$('.fixed_right_box').removeClass('active');											
				$('.alert-show1').show().delay(4000).fadeOut();
				
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		}
	});
	
}

function validateRegisterProduct(){   
	var servicetype=$("#NewProductType").val().trim();
	var productname=$("#NewProductName").val().trim();
	var productremarks=$("#ProductDescription").val().trim();
	
	if(servicetype==""){
		document.getElementById('errorMsg').innerHTML ="Fill Product Type.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(productname==""){
		document.getElementById('errorMsg').innerHTML ="Fill Product Name.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(productremarks==""){
		document.getElementById('errorMsg').innerHTML ="Fill Product description.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	var key=makeid(40);
	
	$.ajax({
		type : "POST",
		url : "add-ProductCTRL.html",
		dataType : "HTML",
		data : {				
			servicetype : servicetype,
			productname : productname,
			productremarks : productremarks,
			"prodno" : "<%=prodkey%>",
			key : key
		},
		success : function(data){
			if(data=="pass"){			
				$("#NewProductBtnHide").show();     
				$("#NewProductBtnShow").hide(); 					
				refreshContainer(productname,servicetype,productremarks,key);
				document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';				  
				
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();								
				$('.alert-show1').show().delay(4000).fadeOut();
			
				updatePriceList('AddServiceName','ppvservicename','PriceRow','NA');
            	updatePriceList('AddService1Name','ppvservicename','Price1Row','NA');
            	updatePriceList('AddService2Name','ppvservicename','Price2Row','NA');
            	updatePriceList('AddService3Name','ppvservicename','Price3Row','NA');
				
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		}
	});	
}

function refreshUpdateContainer(productname,servicetype,productremarks){			
		$("#Product_Name").val(productname);
    	$("#SubProductType").val(servicetype);
    	$("#SubProductName").val(productname);
    	$("#Product_Remarks").val(productremarks);
    	$("#Product_Price").val(productname+" - Price");
    	$("#Product_Milestone").val(productname+" - Milestone");
    	$("#Product_Documents").val(productname+" - Document");    	
}

function refreshContainer(productname,servicetype,productremarks,key){	
		$("#productregrefid").val(key);
		$("#Product_Name").val(productname);
    	$("#SubProductType").val(servicetype);
    	$("#SubProductName").val(productname);
    	$("#Product_Remarks").val(productremarks);
    	$("#Product_Price").val(productname+" - Price");
    	$("#Product_Milestone").val(productname+" - Milestone");
    	$("#Product_Documents").val(productname+" - Document");
    	$("#MainSubDivCont").css("display",'block');
    	$("#ProductPriceDivSpace").css("display",'block');
    	$("#ProductMilestoneDivSpace").css("display",'block');
    	$("#ProductDocumentDivSpace").css("display",'block');
    	$("#Product_Name").attr("readonly",true);
    	$("#MainProductCloseBtn").css("display",'block');	
}

$(function() {
	$("#UpdateNewProductType").autocomplete({
		source : function(request, response) {
			if(document.getElementById('UpdateNewProductType').value.trim().length>=2)
			$.ajax({
				url : "<%=request.getContextPath()%>/getnewproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "producttypename",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							sid : item.sid
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		change: function (event, ui) {
            if(!ui.item){  }
            else{  
            	$("#UpdateNewProductType").val(ui.item.value);   
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});   

 $(function() {
	$("#NewProductType").autocomplete({
		source : function(request, response) {
			if(document.getElementById('NewProductType').value.trim().length>=1)
			$.ajax({
				url : "<%=request.getContextPath()%>/getnewproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "producttypename",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							sid : item.sid
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		change: function (event, ui) {
            if(!ui.item){  }
            else{  
            	$("#NewProductType").val(ui.item.value);   
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
			if(document.getElementById('Product_Name').value.trim().length>=1)
			$.ajax({
				url : "<%=request.getContextPath()%>/getnewproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "productname",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							pid : item.pid,
							ptype  : item.ptype,
							prefid : item.prefid,
							pdesc : item.pdesc,
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
		select: function (event, ui) {
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML ="Select from list";
            	$('.alert-show').show().delay(2000).fadeOut();
            	$("#Product_Name").val("");  
            	$("#SubProductType").val("");
            	$("#SubProductName").val("");
            	$("#productregrefid").val("");
            	$("#Product_Remarks").val("");
            	$("#Central").prop("checked",false);
            	$("#State").prop("checked",false);
            	$("#Global").prop("checked",false);
            	$("#BackBtnIdHide").css("display",'none');     
            	$("#BackBtnIdShow").css("display",'block');    
            	$("#NewProductBtnHide").css("display",'none');     
            	$("#NewProductBtnShow").css("display",'block');    
            }
            else{ 
            	$("#Product_Name").val(ui.item.value);
            	$("#SubProductType").val(ui.item.ptype);
            	$("#SubProductName").val(ui.item.value);
            	$("#productregrefid").val(ui.item.prefid);
            	$("#Product_Remarks").val(ui.item.pdesc);
            	$("#Product_Price").val(ui.item.value+" - Price");
            	$("#Product_Milestone").val(ui.item.value+" - Milestone");
            	$("#Product_Documents").val(ui.item.value+" - Document");
            	$("#MainSubDivCont").css("display",'block');
            	$("#ProductPriceDivSpace").css("display",'block');
            	$("#ProductMilestoneDivSpace").css("display",'block');
            	$("#ProductDocumentDivSpace").css("display",'block');
            	$("#Product_Name").attr("readonly",true);
            	$("#MainProductCloseBtn").css("display",'block');         	
            	$("#BackBtnIdHide").css("display",'block');     
            	$("#BackBtnIdShow").css("display",'none');     
            	$("#NewProductBtnHide").css("display",'block');     
            	$("#NewProductBtnShow").css("display",'none'); 
            	if(ui.item.central=="1")
            	$("#Central").prop("checked",true);
            	if(ui.item.state=="1")
            	$("#State").prop("checked",true);
            	if(ui.item.global=="1")
                	$("#Global").prop("checked",true);
            	
            	fillProductPrice(ui.item.prefid);
            	fillProductMilestone(ui.item.prefid);
            	fillProductDocuments(ui.item.prefid);            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

function fillProductDocuments(prodrefid){
	$.ajax({
		type : "POST",
		url : "getnewproduct.html",
		dataType : "HTML",
		data : {
			name : prodrefid,
			"field" : "productdocument"
		},
		success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);
			var len=response.length;
			if(len>0){
			for(var j=0;j<len;j++){
				var id=response[j]['id'];
				var name=response[j]['name'];
				var description=response[j]['description'];
				var uploadby=response[j]['uploadby'];
				var visibility=response[j]['visibility'];
				var eyeClass="show_psww";
				var eyeClass1="fa fa-eye";
				if(visibility=="2"){
					eyeClass="show_psww1";
					eyeClass1="fa fa-eye-slash";
				}
				    
				if(Number(j)==0){     
					$("#ProductDocumentName").val(name);
					$("#DocumentDescription").val(description);
					$("#UploadTo").val(uploadby);
					$("#ProductDocumentName").attr('onChange', "updateMainDocumentList('ProductDocumentName','pd_docname',"+id+")");
					$("#DocumentDescription").attr('onChange', "updateMainDocumentList('DocumentDescription','pd_description',"+id+")");
					$("#UploadByDiv").attr('onClick', "addMainInputDocFor('UploadToDoc','UploadTo','Agent','pd_uploadby',"+id+")");
					$("#UploadByDiv1").attr('onClick', "addMainInputDocFor('UploadToDoc','UploadTo','Client','pd_uploadby',"+id+")");				
					$("#documentVisibility").attr('onClick', "documentVisibility('documentVisibility','pd_visibility',"+id+",'old')");
				    $("#documentVisibility").addClass(eyeClass);
				    $("#documentVisibilityClass").addClass(eyeClass1);
				}else{
					var a=document.getElementById("AddDocumentCount").value.trim();
					var i=Number(a)+1;
					var ProductDocumentName="ProductDocumentName"+i;	
					var DocumentDescription="DocumentDescription"+i;
					var UploadTo="UploadTo"+i;
					var UploadToDoc="UploadToDoc"+i;
					var ProductTotalPrice="ProductTotalPrice"+i;
					var DocumentDivId="DocumentDivId"+i;
					var DocumentRow="DocumentRow"+i;
					document.getElementById("AddDocumentCount").value=i;
					var documentVisibility="documentVisibility"+i;
					$(''+
					 '<div class="clearfix  clerrow link-style12" id="'+DocumentDivId+'">'+
					 '<div class="row" id="'+DocumentRow+'">'+
					 '<div class="col-md-4 col-sm-4 col-xs-12">'+                             
				      '<input type="text" name="'+ProductDocumentName+'" onchange="updateMainDocumentList(\''+ProductDocumentName+'\',\'pd_docname\',\''+id+'\')" autocomplete="off" id="'+ProductDocumentName+'" class="form-control bdrnone" value="'+name+'" placeholder="Document Name" onblur="validCompanyNamePopup(\''+ProductDocumentName+'\')">'+
				     '</div>'+
					'<div class="col-md-4 col-sm-5 col-xs-12">'+                                                                   
				      '<input type="text" name="'+DocumentDescription+'"  onchange="updateMainDocumentList(\''+DocumentDescription+'\',\'pd_description\',\''+id+'\')" autocomplete="off" id="'+DocumentDescription+'" class="form-control bdrnone" value="'+description+'" placeholder="Description">'+
				     '</div>'+           
				     '<div class="col-md-2 col-sm-2 col-xs-12"> '+                                                                  
				     '<input type="text" name="'+UploadTo+'" onclick="showTimelineBox(\''+UploadToDoc+'\')" autocomplete="off" id="'+UploadTo+'" class="form-control bdrnone pointers" value="'+uploadby+'" readonly="readonly">'+
				    '<div class="documentfor_box" id="'+UploadToDoc+'">'+
				   '<div class="timeline_inner">'+
				   '<span onclick="addMainInputDocFor(\''+UploadToDoc+'\',\''+UploadTo+'\',\'Agent\',\'pd_uploadby\',\''+id+'\')">Agent</span> <span onclick="addMainInputDocFor(\''+UploadToDoc+'\',\''+UploadTo+'\',\'Client\',\'pd_uploadby\',\''+id+'\')">Client</span ></div>'+
				   '</div>'+
				    '</div> '+
				     '<div class="col-md-2 col-sm-1 col-xs-12">'+
				     '<div class="delIcon">        '+   
				     '<span class="'+eyeClass+'" id="'+documentVisibility+'" onclick="documentVisibility(\''+documentVisibility+'\',\'pd_visibility\',\''+id+'\',\'old\')">'+
						'<i class="'+eyeClass1+' pointers" title="Visibility" style="font-size:20px;"></i>'+
					 '</span>  '+
				      '<i class="fa fa-trash pointers" title="delete" onclick="removeMainDiv2(\''+id+'\',\''+DocumentDivId+'\')"></i>'+
				      '</div>'+
				    '</div>'+
				    '</div>'+
				    '</div>').insertBefore('#NewProductDocumentLine');	
					
				}				
			}
		}else{
			$("#documentVisibility").addClass("show_psww");
		    $("#documentVisibilityClass").addClass("fa fa-eye");
		}}}
	});
}


function fillProductMilestone(prodrefid){
	$.ajax({
		type : "POST",
		url : "getnewproduct.html",
		dataType : "HTML",
		data : {
			name : prodrefid,
			"field" : "productmilestone"
		},
		success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);
			var len=response.length;	
			for(var j=0;j<len;j++){
				var id=response[j]['id'];
				var name=response[j]['name'];
				var timelinevalue=response[j]['timelinevalue'];
				var timelineunit=response[j]['timelineunit'];
				var step=response[j]['step'];
				var assign=response[j]['assign'];
				var pricePercentage=response[j]['pricePercent'];
				    
				if(Number(j)==0){   
					$("#AddMilestoneName").val(name);
					$("#MainTimelineValue").val(timelinevalue);
					$("#MainTimelineUnit").val(timelineunit);
					$("#Steps").val(step);
					$("#Assign").val(assign);
					$("#PricePercent").val(pricePercentage);
					$("#AddMilestoneName").attr('onChange', "updateMainMilestoneList('AddMilestoneName','pm_milestonename',"+id+")");
					$("#MainTimelineValue").attr('onChange', "updateMainMilestoneList('MainTimelineValue','pm_timelinevalue',"+id+")");
					$("#MilestoneInputDiv").attr('onClick', "addMainInput('TimelineBox','MainTimelineUnit','Day','MainTimelineValue','pm_timelineunit',"+id+")");
					$("#MilestoneInputDiv1").attr('onClick', "addMainInput('TimelineBox','MainTimelineUnit','Week','MainTimelineValue','pm_timelineunit',"+id+")");
					$("#MilestoneInputDiv2").attr('onClick', "addMainInput('TimelineBox','MainTimelineUnit','Month','MainTimelineValue','pm_timelineunit',"+id+")");
					$("#MilestoneInputDiv3").attr('onClick', "addMainInput('TimelineBox','MainTimelineUnit','Year','MainTimelineValue','pm_timelineunit',"+id+")");
					$("#Steps").attr('onChange', "updateMainMilestoneList('Steps','pmsteps',"+id+")");
					$("#Assign").attr('onChange', "updateMainMilestoneList('Assign','pm_assign',"+id+")");
					$("#PricePercent").attr('onChange', "validateNumber(this.value,'PricePercent');updateMainMilestoneList('PricePercent','pm_pricepercent',"+id+")");
					
				}else{
					var a=document.getElementById("AddMilestoneCount").value.trim();
					var i=Number(a)+1;
					var AddMilestoneName="AddMilestoneName"+i;	
					var MainTimelineValue="MainTimelineValue"+i;
					var MainTimelineUnit="MainTimelineUnit"+i;
					var TimelineBox="TimelineBox"+i;
					var Steps="Steps"+i;
					var Assign="Assign"+i;
					var PricePercent="PricePercent"+i;
					var MilestoneRowId="MilestoneRowId"+i;
					var MilestoneDivId="MilestoneDivId"+i;
					document.getElementById("AddMilestoneCount").value=i;
					$(''+
					 '<div class="clearfix clerrow link-style12" id="'+MilestoneDivId+'">'+
					 '<div class="row" id="'+MilestoneRowId+'">'+
					 '<div class="col-md-4 col-sm-4 col-xs-12">'+
				    '<input type="text" name="'+AddMilestoneName+'" value="'+name+'" onchange="updateMainMilestoneList(\''+AddMilestoneName+'\',\'pm_milestonename\',\''+id+'\')" id="'+AddMilestoneName+'" class="form-control bdrnone" autocomplete="off" placeholder="Milestone Name" onblur="validCompanyNamePopup(\''+AddMilestoneName+'\')">'+
				   '</div>'+
				   '<div class="col-md-2 col-sm-3 col-xs-12">'+                                                                   
				   '<input type="text" name="'+MainTimelineValue+'" value="'+timelinevalue+'" onchange="updateMainMilestoneList(\''+MainTimelineValue+'\',\'pm_timelinevalue\',\''+id+'\')" id="'+MainTimelineValue+'" class="form-control bdrnone text-right" onclick="showTimelineBox(\''+TimelineBox+'\')" placeholder="Timeline" autocomplete="off" style="width: 50%;" readonly="readonly" onkeypress="return isNumber(event)">'+
				  '<input type="text" name="'+MainTimelineUnit+'" value="'+timelineunit+'" id="'+MainTimelineUnit+'" autocomplete="off" class="form-control bdrnone pointers" readonly="readonly" style="width: 50%;position: absolute;top: 0px;right: 10px;">'+
				  '<div class="timeline_box" id="'+TimelineBox+'">'+  
				 '<div class="timeline_inner">'+
				 '<span onclick="addMainInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Minute\',\''+MainTimelineValue+'\',\'pm_timelineunit\',\''+id+'\')">Minute</span><span onclick="addMainInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Hour\',\''+MainTimelineValue+'\',\'pm_timelineunit\',\''+id+'\')">Hour</span><span onclick="addMainInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Day\',\''+MainTimelineValue+'\',\'pm_timelineunit\',\''+id+'\')">Day</span> <span onclick="addMainInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Week\',\''+MainTimelineValue+'\',\'pm_timelineunit\',\''+id+'\')">Week</span ><span onclick="addMainInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Month\',\''+MainTimelineValue+'\',\'pm_timelineunit\',\''+id+'\')">Month</span><span onclick="addMainInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Year\',\''+MainTimelineValue+'\',\'pm_timelineunit\',\''+id+'\')">Year</span></div>'+
				'</div>'+
				  '</div>'+
				   '<div class="box-width16 col-md-1 col-sm-2 col-xs-12">'+
				     '<input type="text" title="Step No." name="'+Steps+'" value="'+step+'" onchange="updateMainMilestoneList(\''+Steps+'\',\'pmsteps\',\''+id+'\')" id="'+Steps+'" class="form-control bdrnone" autocomplete="off" placeholder="Steps" onkeypress="return isNumber(event)">'+
				   '</div>'+
				   '<div class="col-md-2 col-sm-2 col-xs-12">'+
				     '<input type="text" title="Next Milestone Assign Percentage" name="'+Assign+'" value="'+assign+'" onchange="updateMainMilestoneList(\''+Assign+'\',\'pm_assign\',\''+id+'\')" id="'+Assign+'" class="form-control bdrnone" autocomplete="off" placeholder="Assign %" onkeypress="return isNumberKey(event)">'+
				    '</div>'+
				    '<div class="box-width8 col-md-2 col-sm-2 col-xs-12">'+                                                                   
                    '<input type="text" title="Work Price Percentage" name="pricePercent" autocomplete="off" onchange="validateNumber(this.value,\''+PricePercent+'\');updateMainMilestoneList(\''+PricePercent+'\',\'pm_pricepercent\',\''+id+'\');"  id="'+PricePercent+'" class="form-control bdrnone" value="'+pricePercentage+'" placeholder="price %" onkeypress="return isNumber(event)">'+
                   '</div> '+
				    '<div class="col-md-1 col-sm-1 col-xs-12">'+
				    '<div class="delIcon">'+                                  
				     '<i class="fa fa-trash pointers" title="delete" onclick="removeMainDiv1(\''+id+'\',\''+MilestoneDivId+'\')"></i>'+
				     '</div>'+
				   '</div>'+
				   '</div>'+
				   '</div>').insertBefore('#NewProductMilestoneLine');		
					
				}				
			}}
		}
	});
}

function fillProductPrice(prodrefid){
	$.ajax({
		type : "POST",
		url : "getnewproduct.html",
		dataType : "HTML",
		data : {
			name : prodrefid,
			"field" : "productprice"
		},
		success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);
			var len=response.length;	
			var subtotal=0;
			var k=1;
			var sn="";
			if(len>0){
			for(var j=0;j<Number(len);j++){
				var id=response[j]['id'];
				var service=response[j]['service'];
				var price=response[j]['price'];
				var hsn=response[j]['hsn'];
				var igst=response[j]['igst'];
				var total=response[j]['total'];
				var tax=igst+"%";
				subtotal=Number(subtotal)+Number(total);
				if(hsn==null||hsn=="NA"){
					hsn="";
					tax="";
				}
				if(service=="Professional fees"||service=="Government fees"||service=="Service charges"||service=="Other fees"){   
					
					$("#AddService"+sn+"Name").val(service);
					$("#AddProduct"+sn+"Price").val(price);
					$("#HSN"+sn+"Code").val(hsn);
					$("#Applied"+sn+"Tax").val(tax);
					$("#Product"+sn+"TotalPrice").val(total);
					$("#SmallBtn"+sn+"Edit").attr('onClick', "setMainDivId('HSN"+sn+"Code','Applied"+sn+"Tax',"+id+")");
					$("#SmallBtn"+sn+"Plus").attr('onClick', "setMainActions('HSN"+sn+"Code','Applied"+sn+"Tax',"+id+")");
					$("#AddService"+sn+"Name").attr('onChange', "updateMainPriceList('AddService"+sn+"Name','pp_service_type',"+id+",'Product"+sn+"TotalPrice')");
					$("#AddProduct"+sn+"Price").attr('onChange', "updateMainPriceList('AddProduct"+sn+"Price','pp_price',"+id+",'Product"+sn+"TotalPrice')");
					$("#HSN"+sn+"Code").attr('onChange', "updateMainPriceList('HSN"+sn+"Code','pp_hsncode','"+id+"','NA')");
					sn=Number(sn)+1;
					
				}else{
					var a=document.getElementById("AddPriceCount").value.trim();
					var i=Number(a)+1;
					var x="HSNCode"+i;	
					var AddServiceName="AddServiceName"+i;
					var AddProductPrice="AddProductPrice"+i;
					var AppliedTax="AppliedTax"+i;
					var PriceDivId="PriceDivId"+i;
					var PriceRow="PriceRow"+i;
					var smallBtnEdit="smallBtnEdit"+i;
					var smallBtnPlus="smallBtnPlus"+i;
					var ProductTotalPrice="ProductTotalPrice"+i;
					document.getElementById("AddPriceCount").value=i;
					$(''+
					 '<div class="clearfix  clerrow link-style12" id="'+PriceDivId+'">'+
					 '<div class="row" id="'+PriceRow+'">'+
					 '<div class="col-md-3 col-sm-3 col-xs-12">    '+   
				      '<input type="text" name="'+AddServiceName+'" onchange="updateMainPriceList(\''+AddServiceName+'\',\'pp_service_type\',\''+id+'\',\''+ProductTotalPrice+'\')" id="'+AddServiceName+'" autocomplete="off" class="form-control bdrnone" value="'+service+'" placeholder="Add Service" onblur="validateNamePopup(\''+AddServiceName+'\')">'+
				     '</div>'+
					'<div class="col-md-2 col-sm-2 col-xs-12">'+                                                                   
				     ' <input type="text" name="'+AddProductPrice+'" value="'+price+'" onchange="updateMainPriceList(\''+AddProductPrice+'\',\'pp_price\',\''+id+'\',\''+ProductTotalPrice+'\')" id="'+AddProductPrice+'" autocomplete="off" class="form-control bdrnone" placeholder="Price" onkeypress="return isNumberKey(event)">'+
				     '</div>'+
				   ' <div class="col-md-2 col-sm-2 col-xs-12 main">'+
				   '<div class="clearfix relative_box" onmouseover="showOptions(\''+smallBtnEdit+'\',\''+smallBtnPlus+'\')" onmouseout="hideOptions(\''+smallBtnEdit+'\',\''+smallBtnPlus+'\')">'+
				   '<div class="fa fa-pencil smallBtnEdit pointers" id="'+smallBtnEdit+'"  onclick="setMainDivId(\''+x+'\',\''+AppliedTax+'\',\''+id+'\')" title="Edit"></div>'+
				   '<div class="fa fa-plus-circle smallBtnPlus pointers" id="'+smallBtnPlus+'" onclick="setMainActions(\''+x+'\',\''+AppliedTax+'\',\''+id+'\')" data-toggle="modal" data-target="#TaxModal" id="SmallBtnPlus" title="Add"></div>'+
				   '<input type="text" name="'+x+'" id="'+x+'" value="'+hsn+'" onchange="updateMainPriceList(\''+x+'\',\'pp_hsncode\',\''+id+'\',\'NA\')" onkeypress="searchHSNCode(\''+x+'\',\''+AppliedTax+'\')" class="form-control bdrnone" autocomplete="off" placeholder="HSN for tax">'+
				      '</div>'+
				      '</div>'+
				      '<div class="col-md-2 col-sm-2 col-xs-12">'+                                                                   
				        '<input type="text" name="'+AppliedTax+'" id="'+AppliedTax+'" class="form-control bdrnone" autocomplete="off" value="'+tax+'" placeholder="Tax" readonly>'+
				       '</div>'+
				      '<div class="col-md-2 col-sm-2 col-xs-12">  '+                                                                
				       ' <input type="text" name="'+ProductTotalPrice+'" id="'+ProductTotalPrice+'" autocomplete="off" class="form-control bdrnone" value="'+total+'" placeholder="Total Price" readonly>'+
				       '</div>'+
				       '<div class="col-md-1 col-sm-1 col-xs-12">'+
				       '<div class="delIcon">'+                                  
				        '<i class="fa fa-trash pointers" title="delete" onclick="removeMainDiv(\''+id+'\',\''+PriceRow+'\')"></i>'+
				        '</div>'+
				      '</div>'+
				     ' </div>'+
				    '</div>').insertBefore('#NewProductPriceLine');				
				}				
			}}else{
				updatePriceList('AddServiceName','ppvservicename','PriceRow','NA');
            	updatePriceList('AddService1Name','ppvservicename','Price1Row','NA');
            	updatePriceList('AddService2Name','ppvservicename','Price2Row','NA');
            	updatePriceList('AddService3Name','ppvservicename','Price3Row','NA');
			}
			$("#ji9Mnh87x5I1CWn").val(subtotal);
			}else{
				updatePriceList('AddServiceName','ppvservicename','PriceRow','NA');
            	updatePriceList('AddService1Name','ppvservicename','Price1Row','NA');
            	updatePriceList('AddService2Name','ppvservicename','Price2Row','NA');
            	updatePriceList('AddService3Name','ppvservicename','Price3Row','NA');
			}
		}
	});
}


function addMainInputDocFor(TimelineBoxId,innerId,val,column,uid){
	$('#'+innerId).val(val);
	$("#"+TimelineBoxId).css('display','none');
	updateMainDocumentList(innerId,column,uid);
}

function addInputDocFor(TimelineBoxId,innerId,val,column,rowid){
	$('#'+innerId).val(val);
	$("#"+TimelineBoxId).css('display','none');
	updateDocumentList(innerId,column,rowid);
}

function addMainInput(TimelineBoxId,innerId,val,TextBoxId,colname,uid){
	$('#'+innerId).val(val);
	$("#"+TimelineBoxId).css('display','none');
	$("#"+TextBoxId).focus();
	$("#"+TextBoxId).prop("readonly",false);
	updateMainMilestoneList(innerId,colname,uid);
}

function addInput(TimelineBoxId,innerId,val,TextBoxId,colname,rowid){
	$('#'+innerId).val(val);
	$("#"+TimelineBoxId).css('display','none');
	$("#"+TextBoxId).focus();
	$("#"+TextBoxId).prop('readonly',false);
	updateMilestoneList(innerId,colname,rowid);
}
function showTimelineBox(TimelineBoxId){
	if($('#'+TimelineBoxId).css('display') == 'none')
	{
		$("#"+TimelineBoxId).css('display','block');
	}	
}
function addNewLineDocument(divid){
	var a=document.getElementById("AddDocumentCount").value.trim();
	var i=Number(a)+1;
	var ProductDocumentName="ProductDocumentName"+i;	
	var DocumentDescription="DocumentDescription"+i;
	var UploadTo="UploadTo"+i;
	var UploadToDoc="UploadToDoc"+i;
	var ProductTotalPrice="ProductTotalPrice"+i;
	var DocumentDivId="DocumentDivId"+i;
	var DocumentRow="DocumentRow"+i;
	document.getElementById("AddDocumentCount").value=i;
	var documentVisibility="documentVisibility"+i;
	$(''+
	 '<div class="clearfix  clerrow link-style12" id="'+DocumentDivId+'">'+
	 '<div class="row" id="'+DocumentRow+'">'+
	 '<div class="col-md-4 col-sm-4 col-xs-12">'+                               
      '<input type="text" name="'+ProductDocumentName+'" onchange="updateDocumentList(\''+ProductDocumentName+'\',\'dvdocname\',\''+DocumentRow+'\')" autocomplete="off" id="'+ProductDocumentName+'" class="form-control bdrnone" value="" placeholder="Document Name" onblur="validCompanyNamePopup(\''+ProductDocumentName+'\')">'+
     '</div>'+
	'<div class="col-md-4 col-sm-5 col-xs-12">'+                                                                   
      '<input type="text" name="'+DocumentDescription+'"  onchange="updateDocumentList(\''+DocumentDescription+'\',\'dvdescription\',\''+DocumentRow+'\')" autocomplete="off" id="'+DocumentDescription+'" class="form-control bdrnone" value="" placeholder="Description">'+
     '</div>'+           
     '<div class="col-md-2 col-sm-2 col-xs-12"> '+                                                                  
     '<input type="text" name="'+UploadTo+'" onclick="showTimelineBox(\''+UploadToDoc+'\')" autocomplete="off" id="'+UploadTo+'" class="form-control bdrnone pointers" value="Agent" readonly="readonly">'+
    '<div class="documentfor_box" id="'+UploadToDoc+'">'+
   '<div class="timeline_inner">'+
   '<span onclick="addInputDocFor(\''+UploadToDoc+'\',\''+UploadTo+'\',\'Agent\',\'dvuploadfrom\',\''+DocumentRow+'\')">Agent</span> <span onclick="addInputDocFor(\''+UploadToDoc+'\',\''+UploadTo+'\',\'Client\',\'dvuploadfrom\',\''+DocumentRow+'\')">Client</span ></div>'+
   '</div>'+
    '</div> '+
     '<div class="col-md-2 col-sm-1 col-xs-12">'+
     '<div class="delIcon">        '+   
     '<span class="show_psww" id="'+documentVisibility+'" onclick="documentVisibility(\''+documentVisibility+'\',\'dvvisibilitystatus\',\''+DocumentRow+'\',\'new\')">'+
		'<i class="fa fa-eye pointers" title="Visibility" style="font-size:20px;"></i>'+
	 '</span>  '+
      '<i class="fa fa-trash pointers" title="delete" onclick="removeDiv2(\''+DocumentRow+'\',\''+DocumentDivId+'\')"></i>'+
      '</div>'+
    '</div>'+
    '</div>'+
    '</div>').insertBefore('#'+divid);
}

function addNewLineMilestone(divid){
	var a=document.getElementById("AddMilestoneCount").value.trim();
	var i=Number(a)+1;
	var AddMilestoneName="AddMilestoneName"+i;	
	var MainTimelineValue="MainTimelineValue"+i;
	var MainTimelineUnit="MainTimelineUnit"+i;
	var TimelineBox="TimelineBox"+i;
	var Steps="Steps"+i;
	var Assign="Assign"+i;
	var PricePercent="PricePercent"+i;
	var MilestoneRowId="MilestoneRowId"+i;
	var MilestoneDivId="MilestoneDivId"+i;
	document.getElementById("AddMilestoneCount").value=i;
	$(''+
	 '<div class="clearfix clerrow link-style12" id="'+MilestoneDivId+'">'+
	 '<div class="row" id="'+MilestoneRowId+'">'+
	 '<div class="col-md-4 col-sm-4 col-xs-12">'+
    '<input type="text" name="'+AddMilestoneName+'" onchange="updateMilestoneList(\''+AddMilestoneName+'\',\'mvmilestonename\',\''+MilestoneRowId+'\')" id="'+AddMilestoneName+'" class="form-control bdrnone" autocomplete="off" placeholder="Milestone Name" onblur="validCompanyNamePopup(\''+AddMilestoneName+'\')">'+
   '</div>'+
   '<div class="col-md-2 col-sm-3 col-xs-12">'+                                                                   
   '<input type="text" name="'+MainTimelineValue+'" onchange="updateMilestoneList(\''+MainTimelineValue+'\',\'mvtimelinevalue\',\''+MilestoneRowId+'\')" id="'+MainTimelineValue+'" class="form-control bdrnone text-right" onclick="showTimelineBox(\''+TimelineBox+'\')" placeholder="Timeline" autocomplete="off" style="width: 50%;" readonly="readonly" onkeypress="return isNumber(event)">'+
  '<input type="text" name="'+MainTimelineUnit+'" id="'+MainTimelineUnit+'" autocomplete="off" class="form-control bdrnone pointers" readonly="readonly" style="width: 50%;position: absolute;top: 0px;right: 10px;">'+
  '<div class="timeline_box" id="'+TimelineBox+'">'+  
 '<div class="timeline_inner">'+
 '<span onclick="addInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Minute\',\''+MainTimelineValue+'\',\'mvtimelineunit\',\''+MilestoneRowId+'\')">Minute</span><span onclick="addInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Hour\',\''+MainTimelineValue+'\',\'mvtimelineunit\',\''+MilestoneRowId+'\')">Hour</span><span onclick="addInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Day\',\''+MainTimelineValue+'\',\'mvtimelineunit\',\''+MilestoneRowId+'\')">Day</span> <span onclick="addInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Week\',\''+MainTimelineValue+'\',\'mvtimelineunit\',\''+MilestoneRowId+'\')">Week</span ><span onclick="addInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Month\',\''+MainTimelineValue+'\',\'mvtimelineunit\',\''+MilestoneRowId+'\')">Month</span><span onclick="addInput(\''+TimelineBox+'\',\''+MainTimelineUnit+'\',\'Year\',\''+MainTimelineValue+'\',\'mvtimelineunit\',\''+MilestoneRowId+'\')">Year</span></div>'+
'</div>'+
  '</div>'+
   '<div class="box-width16 col-md-2 col-sm-2 col-xs-12">'+
     '<input type="text" title="Step No." name="'+Steps+'" onchange="updateMilestoneList(\''+Steps+'\',\'mvstep\',\''+MilestoneRowId+'\')" id="'+Steps+'" class="form-control bdrnone" autocomplete="off" placeholder="Steps" onkeypress="return isNumber(event)">'+
   '</div>'+
   '<div class="col-md-2 col-sm-2 col-xs-12">'+
     '<input type="text" title="Next milestone assign on percentage" name="'+Assign+'" onchange="updateMilestoneList(\''+Assign+'\',\'mvassign\',\''+MilestoneRowId+'\')" id="'+Assign+'" class="form-control bdrnone" autocomplete="off" placeholder="Assign %" onkeypress="return isNumberKey(event)">'+
    '</div>'+
    '<div class="box-width8 col-md-2 col-sm-2 col-xs-12"> '+                                                                  
    '<input type="text" title="Work Price Percentage" name="pricePercent" autocomplete="off" onchange="validateNumber(this.value,\''+PricePercent+'\');updateMilestoneList(\''+PricePercent+'\',\'mvpricepercent\',\''+MilestoneRowId+'\');"  id="'+PricePercent+'" class="form-control bdrnone" placeholder="price %" onkeypress="return isNumber(event)">'+
   '</div> '+
    '<div class="col-md-1 col-sm-1 col-xs-12">'+
    '<div class="delIcon">'+                                  
     '<i class="fa fa-trash pointers" title="delete" onclick="removeDiv1(\''+MilestoneRowId+'\',\''+MilestoneDivId+'\')"></i>'+
     '</div>'+
   '</div>'+
   '</div>'+
   '</div>').insertBefore('#'+divid);
}

function addNewLinePrice(divid){	
	
	var a=document.getElementById("AddPriceCount").value.trim();
	var i=Number(a)+1;
	var x="HSNCode"+i;	
	var AddServiceName="AddServiceName"+i;
	var AddProductPrice="AddProductPrice"+i;
	var AppliedTax="AppliedTax"+i;
	var PriceDivId="PriceDivId"+i;
	var PriceRow="PriceRow"+i;
	var smallBtnEdit="smallBtnEdit"+i;
	var smallBtnPlus="smallBtnPlus"+i;
	var ProductTotalPrice="ProductTotalPrice"+i;
	document.getElementById("AddPriceCount").value=i;
	$(''+
	 '<div class="clearfix  clerrow link-style12" id="'+PriceDivId+'">'+
	 '<div class="row" id="'+PriceRow+'">'+
	 '<div class="col-md-3 col-sm-3 col-xs-12">    '+                           
      '<input type="text" name="'+AddServiceName+'" onchange="updatePriceList(\''+AddServiceName+'\',\'ppvservicename\',\''+PriceRow+'\',\'NA\')" id="'+AddServiceName+'" autocomplete="off" class="form-control bdrnone" value="" placeholder="Add Service" onblur="validateNamePopup(\''+AddServiceName+'\')">'+
     '</div>'+
	'<div class="col-md-2 col-sm-2 col-xs-12">'+                                                                   
     ' <input type="text" name="'+AddProductPrice+'" onchange="updatePriceList(\''+AddProductPrice+'\',\'ppvprice\',\''+PriceRow+'\',\''+ProductTotalPrice+'\')" id="'+AddProductPrice+'" autocomplete="off" class="form-control bdrnone" placeholder="Price" onkeypress="return isNumberKey(event)">'+
     '</div>'+
   ' <div class="col-md-2 col-sm-2 col-xs-12 main">'+
   '<div class="clearfix relative_box" onmouseover="showOptions(\''+smallBtnEdit+'\',\''+smallBtnPlus+'\')" onmouseout="hideOptions(\''+smallBtnEdit+'\',\''+smallBtnPlus+'\')">'+
   '<div class="fa fa-pencil smallBtnEdit pointers" id="'+smallBtnEdit+'" onclick="setDivId(\''+x+'\',\''+AppliedTax+'\',\''+PriceRow+'\')" title="Edit"></div>'+
   '<div class="fa fa-plus-circle smallBtnPlus pointers" id="'+smallBtnPlus+'" data-toggle="modal" data-target="#TaxModal" id="SmallBtnPlus" title="Add" onclick="setActions(\''+x+'\',\''+AppliedTax+'\',\''+PriceRow+'\')"></div>'+
   '<input type="text" name="'+x+'" id="'+x+'" onkeypress="searchHSNCode(\''+x+'\',\''+AppliedTax+'\')" onchange="updatePriceList(\''+x+'\',\'ppvhsncode\',\''+PriceRow+'\',\'NA\')"" class="form-control bdrnone" autocomplete="off" placeholder="HSN for tax">'+    
      '</div>'+
      '</div>'+
      '<div class="col-md-2 col-sm-2 col-xs-12">'+                                                                   
        '<input type="text" name="'+AppliedTax+'" id="'+AppliedTax+'" class="form-control bdrnone" autocomplete="off" value="" placeholder="Tax" readonly>'+
       '</div>'+
      '<div class="col-md-2 col-sm-2 col-xs-12">  '+                                                                
       ' <input type="text" name="'+ProductTotalPrice+'" id="'+ProductTotalPrice+'" autocomplete="off" class="form-control bdrnone"  placeholder="Total Price" readonly>'+
       '</div>'+
       '<div class="col-md-1 col-sm-1 col-xs-12">'+
       '<div class="delIcon">'+                                  
        '<i class="fa fa-trash pointers" title="delete" onclick="removeDiv(\''+PriceDivId+'\',\''+PriceRow+'\')"></i>'+
        '</div>'+
      '</div>'+
     ' </div>'+
    '</div>').insertBefore('#'+divid);
	
	
}


function showHideChangePopUp(id){
	  var div= document.querySelector('#'+id);
	  div.style.display= 'block';
	  div.style.left='0px';
	  div.style.top='40px';
	}
function hideMouseMove(id){
	var div= document.querySelector('#'+id);
	div.style.display= 'none';
}

function clearMainProduct(closebtn,compid){
	$("#RefreshAllDiv").load(location.href + " #RefreshAllDiv1"); 
	$("#productregrefid").val("");
	$("#Product_Remarks").val("");
	$("#MainSubDivCont").css("display",'none');
	$("#ProductPriceDivSpace").css("display",'none');
	$("#ProductMilestoneDivSpace").css("display",'none');
	$("#ProductDocumentDivSpace").css("display",'none');
	$("#Product_Name").attr("readonly",false);	
	$("#"+closebtn).css("display","none");
	$("#"+compid).removeAttr('readonly',false);
	$("#"+compid).val('');
	$("#BackBtnIdHide").css("display",'none');     
	$("#BackBtnIdShow").css("display",'block');  
	$("#NewProductBtnHide").css("display",'none');     
	$("#NewProductBtnShow").css("display",'block'); 
}

function removeMainDiv(uid,DivId1){
	var prodrefid=$("#productregrefid").val();
	$.ajax({
		type : "POST",
		url : "RemoveMainProductPriceRow111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			uid : uid
		},
		success : function(data){
			var x=data.split("#");
			if(x[0]=="pass"){
				$("#ji9Mnh87x5I1CWn").val(x[1]);		
				$('#'+DivId1).remove();	
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		}
	});			
}

function removeDiv(DivId1,DivId){
	var prodrefid=$("#productregrefid").val();
	$.ajax({
		type : "POST",
		url : "RemoveProductPriceRow111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			DivId : DivId
		},
		success : function(data){	
			var x=data.split("#");
			if(x[0]=="pass"){$("#ji9Mnh87x5I1CWn").val(x[1]);		
			$('#'+DivId1).remove();	
			}else{
				$('#'+DivId1).remove();	
			}
		}
	});	
	
}

function removeMainDiv1(uid,DivId1){
	$.ajax({
		type : "POST",
		url : "RemoveMainProductMilestoneRow111",
		dataType : "HTML",
		data : {
			uid : uid
		},
		success : function(data){
			if(data=="pass"){
			$('#'+DivId1).remove();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		}
	});			
}

function removeDiv1(DivId,DivId1){
	var prodrefid=$("#productregrefid").val();
	$.ajax({
		type : "POST",
		url : "RemoveProductMilestoneRow111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			DivId : DivId
		},
		success : function(data){		
			$('#'+DivId1).remove();		
		}
	});			
}

function removeMainDiv2(uid,DivId1){
	$.ajax({
		type : "POST",
		url : "RemoveProductMainDocumentRow111",
		dataType : "HTML",
		data : {
			uid : uid
		},
		success : function(data){
			if(data=="pass"){
			$('#'+DivId1).remove();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		}
	});		
	
}

function removeDiv2(DivId,DivId1){
	var prodrefid=$("#productregrefid").val();
	$.ajax({
		type : "POST",
		url : "RemoveProductDocumentRow111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			DivId : DivId
		},
		success : function(data){			
			$('#'+DivId1).remove();			
		}
	});		
	
}
function makeid(length) {
	   var result           = '';
	   var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	   var charactersLength = characters.length;
	   for ( var i = 0; i < length; i++ ) {
	      result += characters.charAt(Math.floor(Math.random() * charactersLength));
	   }
	   return result;
	}

function validateProduct(){  
	if(document.getElementById("Product_Name").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Fill Product Name Or add New.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("Product_Remarks").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Remarks is required.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("AddServiceName").value.trim()==""||document.getElementById("AddService1Name").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Please add minimum one price details.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#Global").prop('checked') == false&&$("#Central").prop('checked') == false&&$("#State").prop('checked') == false){
		document.getElementById('errorMsg').innerHTML ="Please choose product global/central/state type or all.";
		$('.alert-show').show().delay(6000).fadeOut();
		return false;
	}
	
	if(document.getElementById("AddProductPrice").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Please add professional fee";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}	
// 	if(document.getElementById("AddMilestoneName").value.trim()==""){
// 		document.getElementById('errorMsg').innerHTML ="Please add minimum one milestone details.";
// 		$('.alert-show').show().delay(4000).fadeOut();
// 		return false;
// 	}
// 	if(document.getElementById("MainTimelineValue").value.trim()==""){
// 		document.getElementById('errorMsg').innerHTML ="Please add minimum one milestone details.";
// 		$('.alert-show').show().delay(4000).fadeOut();
// 		return false;
// 	}

}

function UpdateProductBox(productboxid,prodrefid){
	
	if(document.getElementById(productboxid).readOnly){
		$("#UpdateRegProduct").trigger('reset');
		
		fillProductDetails($("#"+prodrefid).val());
		
		var id = $(".updateProduct").attr('data-related'); 
		$(id).hide();
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
	}
}

function openProductBox(){
	$("#RegNewProduct").trigger("reset");
	$("#RefreshAllDiv").load(location.href + " #RefreshAllDiv1"); 
	$("#AddNewProductForm").trigger("reset");
	var id = $(".addnew").attr('data-related'); 
	$(id).hide();
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}


function fillProductDetails(prodrefid){
	$.ajax({
		type : "POST",
		url : "GetProductByRefid111",
		dataType : "HTML",
		data : {				
			"name" : prodrefid,
			"field" : "GetProductDetails"
		},
		success : function(response){	
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){ 
			var name=response[0]["name"];
			var type=response[0]["type"];
			var remarks=response[0]["remarks"];		
			
			$("#UpdateNewProductType").val(type);
			$("#UpdateNewProductName").val(name);
			$("#UpdateProductDescription").val(remarks);
			
		 }}
		}
	});
}


$('.close_box').on( "click", function(e) { 
$('.fixed_right_box').removeClass('active');
});
function documentVisibility(id,colname,rowid,type){
	$("#"+id).toggleClass('active');
	var className = $('#'+id).attr('class');
	var val="1";
	if(className=="show_psww1 active")val="1";
	else if(className=="show_psww1")val="2";
	else if(className=="show_psww active")val="2";
	else if(className=="show_psww")val="1";
	var prodrefid=$("#productregrefid").val();
	
	if(type=="new"){
		$.ajax({
			type : "POST",
			url : "UpdateDocumentData111",
			dataType : "HTML",
			data : {
				prodrefid : prodrefid,
				colname : colname,
				val : val,
				rowid : rowid
			},
			success : function(data){
				if(data=="pass"){
					if(val=="1")
					document.getElementById("errorMsg1").innerHTML="Visible.";
					else
						document.getElementById("errorMsg1").innerHTML="Not Visible.";
					
					$('.alert-show1').show().delay(300).fadeOut();			
				}else{
					document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try-Again Later.";
					$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
	}else if(type=="old"){
		var column=colname;
		var uid=rowid;
		$.ajax({
			type : "POST",
			url : "UpdateMainDocumentData111",
			dataType : "HTML",
			data : {
				column : column,
				val : val,
				uid : uid
			},
			success : function(data){
				if(data=="pass"){
					if(val=="1")
						document.getElementById("errorMsg1").innerHTML="Visible.";
						else
							document.getElementById("errorMsg1").innerHTML="Not Visible.";
						$('.alert-show1').show().delay(300).fadeOut();			
				}else{
					document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try-Again Later.";
					$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
	}
	
}
</script>

</body>
</html>