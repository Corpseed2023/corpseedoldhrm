
<script type="text/javascript">
function isUpdateDuplicateMobilePhone(phoneid){
	var contkey=document.getElementById("UpdateContactKey").value.trim();
	var val=document.getElementById(phoneid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"updatecontactmobilephone","id":contkey},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Mobile Phone.";
			document.getElementById(phoneid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}
function isUpdateDuplicateEmail(emailid){
	var contkey=document.getElementById("UpdateContactKey").value.trim();
	var val=document.getElementById(emailid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"updatecontactemail","id":contkey},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Email-Id.";
			document.getElementById(emailid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}
$(function() {
	$("#EstimateNo").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('EstimateNo').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "estimateNumber"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value
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
            	
            }
            else{
            	doAction(ui.item.value,'estimateNoDoAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#ClientName").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('ClientName').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "estimateclientname"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
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
            	
            }
            else{
            	doAction(ui.item.value,'ClientNameDoAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});


function isValidAmount(){
	var dueAmt=$("#TotalDueAmountId").html();
	var tranAmt=$("#TransactionAmount").val();
	if(Number(tranAmt)>Number(dueAmt)){
		$("#TransactionAmount").val('');
		document.getElementById('errorMsg').innerHTML ="Maximum amount should be  "+dueAmt;
		$('.alert-show').show().delay(4000).fadeOut();
	}
	
}

function hideTaskDetails(milestone_pay_box){
	if ($("."+milestone_pay_box).is(':visible')){
		$("."+milestone_pay_box).slideUp();
	}
}
function showTaskDetails(milestone_pay_box){
	$("."+milestone_pay_box).slideDown();
}

function selectMode(value){
// 	cash_online txid paymentUpload paymentUploadDesc
// 	(Select Transaction Receipt To Upload <span class="txt_red">(Max Size 48MB)</span>)
	
	if(value=="Cash"){
		$(".cash_online").show();
		$("#TransactionId").attr("placeholder","Transaction id");
		$("#txid").html("Transaction Id");
		$("#paymentUpload").html("Upload Receipt");
		$("#paymentUploadDesc").html("Select Transaction Receipt To Upload <span class='txt_red'>(Max Size 48MB)</span>");
		$("#TransactionId").val("NA");
		$("#TransactionId").prop("readonly",true);
	}else if(value=="Online"){
		$(".cash_online").show();
		$("#TransactionId").attr("placeholder","Transaction id");
		$("#txid").html("Transaction Id");
		$("#paymentUpload").html("Upload Receipt");
		$("#paymentUploadDesc").html("Select Transaction Receipt To Upload <span class='txt_red'>(Max Size 48MB)</span>");
		$("#TransactionId").val("");
		$("#TransactionId").prop("readonly",false);		
	}else if(value=="PO"){
		$("#TransactionId").val("");
		$("#TransactionId").attr("placeholder","Purchase Order number");
		$("#TransactionId").prop("readonly",false);
		$(".cash_online").hide();
		$("#txid").html("PO Number");
		$("#paymentUpload").html("Upload PO Receipt");
		$("#paymentUploadDesc").html("Select PO Receipt To Upload <span class='txt_red'>(Max Size 48MB)</span>");	
		$("#paymentModePo").val(1);
		changePayTypePo();
	}
	
	let po=$("#paymentModePo").val();
	if(po==1&&value!="PO"){
		console.log("going to fetch Pay type...")
		$("#paymentModePo").val(0);
		let estimateno=$("#ConvertInvoiceSaleNo").val();
		getPayType("NA",estimateno);
	}
	
	
}

function changePayTypePo(){
	var estimateno=$("#ConvertInvoiceSaleNo").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetPayTypePo111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){
			$("#paymentTable  tbody").empty();	
		    $("#paymentTable  tbody").append(response);		
		},
		complete : function(data){
			hideLoader();
		}
	});
	console.log("Going to change pay type and disable : "+estimateno);
}

function updatePricePercentage(refKey,value){
	showLoader();
	if(Number(value)>0){
	$.ajax({
			type : "POST",
			url : "UpdatePricePercentage111",
			dataType : "HTML",
			data : {				
				refKey : refKey,	
				value : value
			},
			success : function(data){				
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML ='Updated';
					$('.alert-show1').show().delay(400).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML ='Something went wrong ! Try-again later !!';
					$('.alert-show').show().delay(3000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}else{
		document.getElementById('errorMsg').innerHTML ='Minimum 1% price percentage required !!';
		$('.alert-show').show().delay(4000).fadeOut();
		hideLoader();
	}
}
function updatePayType(payType,salesKey){
// 	var salesKey=$("#ConvertEstimateRefKey").val();
showLoader();
	 $.ajax({
			type : "POST",
			url : "UpdatePayType111",
			dataType : "HTML",
			data : {				
				salesKey : salesKey,	
				payType : payType
			},
			success : function(data){				
				if(data=="fail"){
					document.getElementById('errorMsg').innerHTML ='Either Estimate converted or something went wrong !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
}
function fileSize(file){
	const fi=document.getElementById('ChooseFile');
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        // The size of the file. 
        if (file >= 1024) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, please select a file less than 1mb';
            document.getElementById("ChooseFile").value="";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }		
	}	
}
function validatePayType(){
	var estimateno=$("#WhichPaymentFor").val();	
	$(".removeLiId").remove();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetAllSalesProduct111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){		
		if(Object.keys(response).length!=0){	
		response = JSON.parse(response);			
		 var len = response.length;			 
		 if(Number(len)>0){			
			 var style="style='margin-top:10px;color: #337ab7;'";
		var minimumPay=0;
		for(var i=0;i<len;i++){		   
			var name = response[i]['name'];	
			var notes = response[i]['notes'];
			var minPay= response[i]['minPay'];
			minimumPay=Number(minimumPay)+Number(minPay);
			$(''+
					'<li class="removeLiId" '+style+'>'+name+'<small>'+notes+'</small></li>'
					).insertBefore("#IncludedProjectsId");
			style="style='color: #337ab7;'";
			
		}
		$("#minimumTotalPay").html("Minimum Pay : "+Math.ceil(Number(minimumPay)));
		$("#payTypeWarning").modal("show");
		 }}},
			complete : function(data){
				hideLoader();
			}
	});
		
}
function validateGeneratePayment(){
	var products=$("#selectProduct").val();
	var profFee=$("#Professional_Fee1").val();
	var govFee=$("#Government_Fee1").val();
	var serviceCharge=$("#service_Charges1").val();
	var otherFee=$("#Other_Fee1").val();
	var otherRemark=$("#Other_Fee_remark1").val();
	var gstApply=$("#GSTApplied1").val();
	var estimateNotes=$("#estimateNotes").val();
	
	var totalAmount=Number(profFee)+Number(govFee)+Number(otherFee);
	
	if(products==null||products==""){
		document.getElementById('errorMsg').innerHTML ="Please select product !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(estimateNotes==null||estimateNotes==""){
		document.getElementById('errorMsg').innerHTML ="Please enter invoice notes !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(totalAmount<=0){
		document.getElementById('errorMsg').innerHTML ="Please enter minimum one amount !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(Number(otherFee)>0&&(otherRemark==null||otherRemark=="")){
		document.getElementById('errorMsg').innerHTML ="Enter other fee remarks !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(profFee==null||profFee=="")profFee="0";
	if(govFee==null||govFee=="")govFee="0";
	if(serviceCharge==null||serviceCharge=="")serviceCharge="0";
	if(otherFee==null||profFee=="")otherFee="0";
	if(otherRemark==null||otherRemark=="")otherRemark="NA";
	var pffCgst=$("#ProfessionalCgst").val();
	var pffSgst=$("#ProfessionalSgst").val();
	var pffIgst=$("#ProfessionalIgst").val();
	var govtCgst=$("#GovernmentCgst").val();
	var govtSgst=$("#GovernmentSgst").val();
	var govtIgst=$("#GovernmentIgst").val();
	var serviceCgst=$("#ServiceChargeCgst").val();
	var serviceSgst=$("#ServiceChargeSgst").val();
	var serviceIgst=$("#ServiceChargeIgst").val();
	var OtherCgst=$("#OtherCgst").val();
	var OtherSgst=$("#OtherSgst").val();
	var OtherIgst=$("#OtherIgst").val();
	var pymtamount=$("#TotalPaymentId1").val();
	var estKey=$("#ConvertEstimateRefKey").val();
	var product=products+"";
	showLoader();
	$.ajax({
		type : "POST",
		url : "GenerateEstimate111",
		dataType : "HTML",
		data : {				
			product:product,
			profFee:profFee,
			serviceCharge:serviceCharge,
			govFee:govFee,
			otherFee:otherFee,
			otherRemark:otherRemark,
			gstApply:gstApply,
			pffCgst:pffCgst,
			pffSgst:pffSgst,
			pffIgst:pffIgst,
			govtCgst:govtCgst,
			govtSgst:govtSgst,
			govtIgst:govtIgst,
			serviceCgst:serviceCgst,
			serviceSgst:serviceSgst,
			serviceIgst:serviceIgst,
			OtherCgst:OtherCgst,
			OtherSgst:OtherSgst,
			OtherIgst:OtherIgst,
			pymtamount:pymtamount,
			estKey:estKey,
			estimateNotes : estimateNotes
		},
		success : function(data){
			if(data=="pass"){
	        	   $("#GenerateReceiptForm").trigger('reset');
	        	    
	               document.getElementById('errorMsg1').innerHTML ="Successfully estimate generated.";
	               
	               $("#Professional_Fee_GST1").html($("#ProfessionalFeeTax").val()+"%");
	               $("#Government_Fee_GST1").html($("#GovernmentFeeTax").val()+"%");
	               $("#Other_Fee_GST1").html($("#OtherFeeTax").val()+"%");
	               $("#GSTApplied1").val("1");	               
	               $('.alert-show1').show().delay(3000).fadeOut();
	               
// 	       		fillAllSalesPayment(salesno);	       		   
     	   }else{
     		   document.getElementById('errorMsg').innerHTML ="Something Went Wrong, Try-Again later.";
	       		   $('.alert-show').show().delay(4000).fadeOut();
     	   }
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function validatePayment(event){
	var salesno=document.getElementById("WhichPaymentFor").value.trim();
	var company=document.getElementById("CompanyPaymentFor").value.trim();
	var clientrefid=document.getElementById("ClientPaymentFor").value.trim();
	var contactrefid=document.getElementById("ContactPaymentFor").value.trim();
	var pymtmode=document.getElementById("PaymentMode").value.trim();
	var pymtdate=document.getElementById("PaymentDate").value.trim();
	var pymttransid=document.getElementById("TransactionId").value.trim();	
	
	let serviceQty=$("#serviceQty").val();
	var remarks=$("#remarks").val().trim();
	
// 	Other_Fee_remark_Div,TotalPaymentId,GSTApplyId
	var service_Name=$("#Service_Name").val();	
	var professional_Fee=$("#Professional_Fee").val();
	var government_Fee=$("#Government_Fee").val();
	var service_Charges=$("#service_Charges").val();
	var other_Fee=$("#Other_Fee").val();
	var other_Fee_remark=$("#Other_Fee_remark").val();
	
	if(professional_Fee==null||professional_Fee=="")professional_Fee=0;
	if(government_Fee==null||government_Fee=="")government_Fee=0;
	if(service_Charges==null||service_Charges=="")service_Charges=0;
	if(other_Fee==null||other_Fee=="")other_Fee=0;	
	
	var txnAmount=Number(professional_Fee)+Number(government_Fee)+Number(service_Charges)+Number(other_Fee);
	
	if(pymtmode==null||pymtmode==""){
		document.getElementById('errorMsg').innerHTML ="Select Payment Mode !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(pymtdate==null||pymtdate==""){
		document.getElementById('errorMsg').innerHTML ="Select Payment Date !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(pymtmode=="Online"){
		if(pymttransid==""){
			document.getElementById('errorMsg').innerHTML ="Enter Transaction Id !!.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}else if(pymtmode=="PO"){
		if(pymttransid==""){
			document.getElementById('errorMsg').innerHTML ="Enter PO Number !!.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}else{
		$("#TransactionId").val("NA");
	}
	if(service_Name==null||service_Name==""){
		document.getElementById('errorMsg').innerHTML ="Enter Service Name !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(Number(txnAmount)<=0&&pymtmode!="PO"){
		document.getElementById('errorMsg').innerHTML ="Enter Service Amount (Professional or government or service or other fee) !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}	
	if(Number(other_Fee)>0&&(other_Fee_remark==null||other_Fee_remark=="")){
		document.getElementById('errorMsg').innerHTML ="Enter Other Fee Remarks !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(pymtmode=="PO"&&($("#ChooseFile").val()==null||$("#ChooseFile").val()=="")){
		document.getElementById('errorMsg').innerHTML ="Upload Purchase Order Receipt !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if(remarks==null||remarks==""){
		document.getElementById('errorMsg').innerHTML ="Enter remarks !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if(serviceQty==null||serviceQty==""||serviceQty=="0"){
		document.getElementById('errorMsg').innerHTML ="Enter service quantity !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	var pymtamount=$("#TotalPaymentId").val();
	
       //stop submit the form, we will post it manually.
       event.preventDefault();   
    var orderAmount=$("#TotalOrderAmountId").html();
    
    var fromYear=document.getElementById("fromYear").value.trim();
	var toYear=document.getElementById("toYear").value.trim();
	var portalNumber=document.getElementById("portalNumber").value.trim();
	var piboCategory=document.getElementById("piboCategory").value.trim();
	var creditType=document.getElementById("creditType").value.trim();
	var productCategory=document.getElementById("productCategory").value.trim();
	var quantity=document.getElementById("quantity").value.trim();
	var comment=document.getElementById("comment").value.trim();
    
    
    showLoader();
    $.ajax({
		type : "POST",
		url : "IsThisPaymentValid111",
		dataType : "HTML",
		data : {				
			pymtamount : pymtamount,
			orderAmount : orderAmount,
			salesno : salesno,
			pymtmode : pymtmode
		},
		success : function(response){			
		if(response=="pass"){       
		       // Get form
		       var form = $('#UploadFormdata')[0];
			// Create an FormData object
		       var data = new FormData(form);	
			   data.append("services",service_Name);
			   data.append("serviceQty",serviceQty);
			// disabled the submit button
		       $("#btnSubmit").prop("disabled", true);
			
		       $.ajax({
		           type: "POST",
		           enctype: 'multipart/form-data',
		           url: "RegisterPayment111",
		           data: data,
		           processData: false,
		           contentType: false,
		           cache: false,
		           timeout: 600000,
		           success: function (data) {
		        	   $("#btnSubmit").prop("disabled", false);
		        	   
		        	   if(data=="pass"){
			        	   $("#UploadFormdata").trigger('reset'); 
			               document.getElementById('errorMsg1').innerHTML ="Successfully payment added.";
			               
			               $("#Professional_Fee_GST").html($("#ProfessionalFeeTax").val()+"%");
			               $("#Government_Fee_GST").html($("#GovernmentFeeTax").val()+"%");
			               $("#Other_Fee_GST").html($("#OtherFeeTax").val()+"%");
			               $("#GSTApplied").val("1");
			               
			               $('#WhichPaymentFor').val(salesno);	 
			               $('#CompanyPaymentFor').val(company);	 
			               $('#ClientPaymentFor').val(clientrefid);	 
			               $('#ContactPaymentFor').val(contactrefid);	 
			       		   $('.alert-show1').show().delay(3000).fadeOut();
			               $(".EstimatePaymentInnerId").remove();	
			       		fillAllSalesPayment(salesno);	 
		        	   }else if(data=="moreDetailsRequred"){
		        		   document.getElementById('errorMsg').innerHTML ="More dedails required!";
			       		   $('.alert-show').show().delay(4000).fadeOut();		        	   
		        	   }else{
		        		   document.getElementById('errorMsg').innerHTML ="Something Went Wrong, Try-Again later.";
			       		   $('.alert-show').show().delay(4000).fadeOut();
		        	   }
		
		           },
		           error: function (e) {
		               $("#btnSubmit").prop("disabled", false);
		           }
		       });
		}else if(response=="poExist"){
			document.getElementById('errorMsg').innerHTML ="You already uploaded purchase order.";
    		$('.alert-show').show().delay(4000).fadeOut();
		}else{
			document.getElementById('errorMsg').innerHTML ="You don't have permission to add more than sales amount.";
    		$('.alert-show').show().delay(4000).fadeOut();
		}
		},
		complete : function(msg) {
            hideLoader();
        }
	});    
     
       
}

function addMainNewProduct(esrefid,prodtype,prodrefid,prodname,p,central,state,global,jurisdiction){		
	var prodnam=prodname+"#"+prodrefid;
	var a=document.getElementById("NewProductIdUid").value.trim();
	var i=Number(a)+1;	
	var crossbtn="CloseBtn"+i;
	var producttype="Product_Type"+i;
	var productprice="productPrice"+i;
	var productname="Product_Name"+i;
	var multiprod="MultiProd"+i;
	var onetimeterm="onetime"+i;
	var rentimeterm="renewal"+i;
	var service="timetype"+i;
	var period="ProductPeriod"+i;
	var periodtime="ProductPeriodTime"+i;
	var gstprice="GstPrice"+i;
	var totalprice="TotalPrice"+i;
	var newproductid="NewProductBtn"+i;
	var removeicon="RemoveIcon"+i;
	var PriceDropBox="PriceDropBox"+i;
	var PriceGroupId="PriceGroupId"+i;
	var ProductPriceDiv="ProductPriceDiv"+i;
	var TotalPriceProduct="TotalPriceProduct"+i;
	var PriceProduct="PriceProduct"+i;
	var ProductPlan="ProductPlan"+i;
	var TimelineBox="TimelineBox"+i;
	var SaleProdQty="SaleProdQty"+i;
	var ProdGroupRefid="ProdGroupRefid"+i;
	var CurrentProdrefid="CurrentProdrefid"+i;
	var PriceDropBoxSubAmount="PriceDropBoxSubAmount"+i;
	var jurisdictionId="jurisdiction"+i;
	
	document.getElementById("NewProductIdUid").value=i;
	
	$(''+
	'<div class="row EstimateList1" id="'+multiprod+'">'+							
	'<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group">'+
       '<div class="clearfix text-right mb10" style="margin-top: 5px;" id="'+removeicon+'">'+
		'<button class="addbtn pointers" type="button" onclick="removeCurrentProduct(\''+multiprod+'\',\''+productprice+'\')">- Remove</button>'+
       '</div>'+
        '<div class="input-group">'+       
        '<select id="'+producttype+'" name="productType" class="form-control" onchange="getProducts(this.value,\''+productname+'\');">'+
            '<option value="">Product Type</option>'+
            '<%for(int i=0;i<servicetype.length;i++){ %>'+
            '<option value="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></option>'+
            '<%} %>'+                                       
       '</select>'+
       '<input type="hidden" name="pid" id="pid">'+
        '</div>'+
        '<div id="productTypeErrorMSGdiv" class="errormsg"></div>'+
       '</div>'+
      '</div>'+
      '<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group relative_box">'+
       '<div class="clearfix text-right">'+
		 '<button class="addbtn pointers " type="button" data-related="add_contact" id="'+newproductid+'" onclick="addNewProduct()" style="display: none;float:right;margin-bottom: 10px;">+ New Product</button>'+
		'</div>'+
        '<div class="input-group">'+     
        '<input type="hidden" id="'+ProdGroupRefid+'" value="NA">'+
        '<select name="product_name" id="'+productname+'" onchange="setProductPrice(\''+productname+'\',\''+crossbtn+'\',\''+producttype+'\',\''+productprice+'\',\''+productname+'\',\''+newproductid+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+ProdGroupRefid+'\',\''+removeicon+'\',\''+CurrentProdrefid+'\',\'NA\')" class="form-control">'+
        '<option value="">Select Product</option>'+           
        '<option value="'+prodnam+'" selected>'+prodname+'</option>'+    
         '</select>'+
        '</div>'+
        '<div id="product_nameErrorMSGdiv" class="errormsg"></div>'+																												
        '<button class="addbtn pointers close_icon3 del_icon" id="'+crossbtn+'" type="button" style="display: none;" onclick="activeDisplay(\''+productname+'\',\''+producttype+'\',\''+crossbtn+'\',\''+productprice+'\',\''+ProductPriceDiv+'\',\''+newproductid+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\');showRemove(\''+removeicon+'\');"><i class="fas fa-times" style="font-size: 21px;"></i></button>'+
       
       '</div>'+
      '</div>'+
	  '</div>'+
	  '<div class="clearfix EstimateList2" id="'+ProductPriceDiv+'">'+
	  '<div class="clearfix inner_box_bg form-group" id="'+productprice+'" style="display: none;">'+
    '<div class="mb10 flex_box align_center relative_box">'+
    '<span class="input_radio bg_wht pad_box2 pad_box3 s_head">'+ 
	'<select class="s_type" name="'+jurisdictionId+'" id="'+jurisdictionId+'" onchange="updatePlan(\''+CurrentProdrefid+'\',this.value,\'esjurisdiction\');" required="required">'+
	'<option value="">Select Jurisdiction</option>'+																	
	'</select></span>'+    
	'<span class="input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+onetimeterm+'" checked="checked" onclick="hideTime(\''+period+'\',\''+TimelineBox+'\',\''+ProductPlan+'\');updatePlan(\''+CurrentProdrefid+'\',\'OneTime\',\'esprodplan\');">'+
	'<span>One time</span>'+
	'</span>'+
	'<span class="mlft10 input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+rentimeterm+'" onclick="askTime(\''+period+'\',\''+ProductPlan+'\',\''+periodtime+'\');updatePlan(\''+CurrentProdrefid+'\',\'Renewal\',\'esprodplan\');">'+
	'<span>Renewal</span>'+																																																						
	'</span>'+	
	
	'<span class="mlft10 RenBox1" id="'+period+'" style="width: 100px;">'+
	'<input type="text" name="'+ProductPlan+'" autocomplete="off"  onclick="showTimelineBox(\''+TimelineBox+'\')" onchange="updatePlan(\''+CurrentProdrefid+'\',this.value,\'esplantime\');" id="'+ProductPlan+'" class="form-control bdrnone text-right" placeholder="Timeline" style="width: 55%;">'+
    '<input type="text" name="'+periodtime+'" autocomplete="off" id="'+periodtime+'" class="form-control bdrnone pointers" readonly="readonly" style="width: 11%;position: absolute;margin-left: 50px;margin-top: -37px;">'+
	'</span>'+
	'<div class="timelineproduct_box" id="'+TimelineBox+'">'+
	'<div class="timelineproduct_inner">'+
	'<span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Day\',\'esplanperiod\')">Day</span> <span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Week\',\'esplanperiod\')">Week</span ><span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Month\',\'esplanperiod\')">Month</span><span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Year\',\'esplanperiod\')">Year</span></div>'+
	'</div>'+		
	'<input type="hidden" id="'+CurrentProdrefid+'"/>'+
	'<span class="bg_wht pad_box3 qtyBtn">'+																																																																																																																																						
	'<span class="fa fa-minus pointers" onclick="updateMainProductQty(\''+SaleProdQty+'\',\'minus\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\' )"></span>'+
	'<input type="text" id="'+SaleProdQty+'" value="1" onchange="updateMainProdQty(\''+SaleProdQty+'\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')" onkeypress="return isNumber(event)">'+
	'<span class="fa fa-plus pointers" onclick="updateMainProductQty(\''+SaleProdQty+'\',\'plus\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')"></span>'+									
	'</span>'+
	'</div>'+
     '<div class="row mb10">'+
       '<div class="col-md-12 col-sm-12 col-xs-12">'+
       
       '<div class="clearfix" id="'+PriceDropBox+'"></div>'+
       '<input type="hidden" name="'+PriceGroupId+'" id="'+PriceGroupId+'"/>'+
       '<div class="clearfix" id="'+PriceDropBoxSubAmount+'"></div>'+    
       
      '</div>'+
      '</div>'+	  
    '</div>'+
    '</div>'+
 '</div>'+
 '</div>'+
 '</div>').insertBefore('.MultipleProduct');	
	$("#"+producttype).val(prodtype);
	appendJurisdiction(global,central,state,jurisdictionId,jurisdiction);
	setTimeout(function(){
	setMainProductPrice(esrefid,SaleProdQty,rentimeterm,onetimeterm,ProductPlan,periodtime,period,CurrentProdrefid,productprice,PriceDropBox,PriceGroupId,PriceDropBoxSubAmount,removeicon,productname,crossbtn,producttype,newproductid,p,ProdGroupRefid,PriceProduct,TotalPriceProduct);
	},50*p);
}

function setMainProductPrice(pricerefid,SaleProdQtyId,renewalId,onetimeId,MainTimelineValueId,MainTimelineUnitId,ProductPeriodId,CurrentProdrefid,productprice,PriceDropBox,PriceGroupId,PriceDropBoxSubAmount,removeiconid,productname,crossbtn,producttype,newproductbtnid,p,ProdGroupRefid,PriceProduct,TotalPriceProduct){
	fillTimePlan(pricerefid,SaleProdQtyId,renewalId,onetimeId,MainTimelineValueId,MainTimelineUnitId,ProductPeriodId);
	$.ajax({
			type : "POST",
			url : "SetProductPriceList111",
			dataType : "HTML",
			data : {				
				pricerefid : pricerefid
			},
			success : function(response){
			if(Object.keys(response).length!=0){				
			$("#"+CurrentProdrefid).val(pricerefid);
			response = JSON.parse(response);
			 var len = response.length;	
			 if(removeiconid!="NA"){
				 hideRemove(removeiconid);}								 	
				 $("#"+crossbtn).show();
				 $('#'+producttype).hide();	 
				 $("#"+newproductbtnid).show();
				 $("#"+productprice).show();
				 $('#'+productname).attr('disabled','disabled');
				 $('#'+productname).css('appearance','none');				 
			 var subamount=0;	
			 var key="NA";
			for(var i=0;i<len;i++){
				var refid = response[i]['refid'];
				var pricetype = response[i]['pricetype'];
				var price = response[i]['price'];
				var minprice = response[i]['minprice'];
				var hsncode = response[i]['hsncode'];
				var cgstpercent = response[i]['cgstpercent'];
				var sgstpercent = response[i]['sgstpercent'];
				var igstpercent = response[i]['igstpercent'];
				var taxprice = response[i]['tax'];
				var totalprice = response[i]['totalprice'];
				var gstpercent=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);
				var sn=$("#SalesProductIdQty").val();
				sn=Number(sn)+Number(1);
				var TaxId="TaxPId"+sn;
				var PriceId="PricePId"+sn;
				var TotalPrice="TotalPricePId"+sn;
				var gstPriceId="GstPricePId"+sn;
				$("#SalesProductIdQty").val(sn);
				if(key=="NA")key=refid;
				subamount=Number(subamount)+Number(totalprice);
				$(''+
				'<div class="clearfix bg_wht link-style12 Estpricelist2 '+PriceProduct+'">'+
             '<div class="box-width25 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border">'+(i+1)+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width19 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border" title='+pricetype+'>'+pricetype+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" style="height: 38px;margin-left: 2px;" value="'+price+'" id="'+PriceId+'" onchange="updatePrice(\''+refid+'\',\''+TotalPrice+'\',\''+PriceId+'\',\''+minprice+'\',\''+cgstpercent+'\',\''+sgstpercent+'\',\''+igstpercent+'\',\''+pricerefid+'\',\''+gstPriceId+'\',\''+SaleProdQtyId+'\',\''+key+'\')" onkeypress="return isNumberKey(event)"/></p>'+
                  '</div>'+
              '</div>'+    
              '<div class="box-width3 col-xs-1 box-intro-background">'+
              '<input type="text" name="'+TaxId+'" id="'+TaxId+'" value="'+gstpercent+' %'+'" class="form-control bdrnone" autocomplete="off" placeholder="Tax %" readonly="readonly">'+
				      '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><input type="text" class="form-control BrdNone" id="'+gstPriceId+'" style="height: 38px;margin-left: 2px;" value="'+taxprice+'" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+TotalPrice+'" value="'+totalprice+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+ 
           '</div>').insertBefore('#'+PriceDropBox);				
			}
			$(''+
			'<div class="clearfix Estpricelist3 '+TotalPriceProduct+'">'+
         '<div class="box-width59 col-xs-6 box-intro-background">'+
             '<div class="clearfix mt-10"><a href="javascript:void(0)" onclick="addNewPriceType(\''+ProdGroupRefid+'\')"><u>+ Add Price</u></a></div>'+
         '</div>'+
			 '<div class="box-width26 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border justify_end">Total:</p>'+
             '</div>'+
         '</div>'+
         '<div class="box-width14 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+key+'" value="'+subamount.toFixed(2)+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
             '</div>'+
         '</div>'+ 
      '</div>').insertBefore('#'+PriceDropBoxSubAmount);		
			$("#"+ProdGroupRefid).val(pricerefid);	
			$("#"+PriceGroupId).val(pricerefid);	
			 }else{
				 document.getElementById('errorMsg').innerHTML ='Price not Listed , Please set price.';					
		 		    $('.alert-show').show().delay(4000).fadeOut();
			 }
			}
		});
}

function addNewProduct(){
	showLoader();
	var a=document.getElementById("NewProductIdUid").value.trim();
	var i=Number(a)+1;
	var crossbtn="CloseBtn"+i;
	var producttype="Product_Type"+i;
	var productprice="productPrice"+i;
	var productname="Product_Name"+i;
	var multiprod="MultiProd"+i;
	var onetimeterm="onetime"+i;
	var rentimeterm="renewal"+i;
	var service="timetype"+i;
	var period="ProductPeriod"+i;
	var periodtime="ProductPeriodTime"+i;
	var gstprice="GstPrice"+i;
	var totalprice="TotalPrice"+i;
	var newproductid="NewProductBtn"+i;
	var removeicon="RemoveIcon"+i;
	var PriceDropBox="PriceDropBox"+i;
	var PriceGroupId="PriceGroupId"+i;
	var ProductPriceDiv="ProductPriceDiv"+i;
	var TotalPriceProduct="TotalPriceProduct"+i;
	var PriceProduct="PriceProduct"+i;
	var ProductPlan="ProductPlan"+i;
	var TimelineBox="TimelineBox"+i;
	var SaleProdQty="SaleProdQty"+i;
	var ProdGroupRefid="ProdGroupRefid"+i;
	var CurrentProdrefid="CurrentProdrefid"+i;
	var PriceDropBoxSubAmount="PriceDropBoxSubAmount"+i;
	var jurisdictionId="jurisdiction"+i;
	document.getElementById("NewProductIdUid").value=i;
	
	$(''+
	'<div class="row EstimateList1" id="'+multiprod+'">'+							
	'<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group">'+
       '<div class="clearfix text-right mb10" style="margin-top: 5px;" id="'+removeicon+'">'+
		'<button class="addbtn pointers" type="button" onclick="removeCurrentProduct(\''+multiprod+'\',\''+productprice+'\')">- Remove</button>'+
       '</div>'+
        '<div class="input-group">'+       
        '<select id="'+producttype+'" name="productType" class="form-control" onchange="getProducts(this.value,\''+productname+'\');">'+
            '<option value="">Product Type</option>'+
            '<%for(int i=0;i<servicetype.length;i++){ %>'+
            '<option value="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></option>'+
            '<%} %>'+                                       
       '</select>'+
       '<input type="hidden" name="pid" id="pid">'+
        '</div>'+
        '<div id="productTypeErrorMSGdiv" class="errormsg"></div>'+
       '</div>'+
      '</div>'+
      '<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group relative_box">'+
       '<div class="clearfix text-right">'+
		 '<button class="addbtn pointers " type="button" data-related="add_contact" id="'+newproductid+'" onclick="addNewProduct()" style="display: none;float:right;margin-bottom: 10px;">+ New Product</button>'+
		'</div>'+
        '<div class="input-group">'+     
        '<input type="hidden" id="'+ProdGroupRefid+'" value="NA">'+
        '<select name="product_name" id="'+productname+'" onchange="setProductPrice(\''+productname+'\',\''+crossbtn+'\',\''+producttype+'\',\''+productprice+'\',\''+productname+'\',\''+newproductid+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+ProdGroupRefid+'\',\''+removeicon+'\',\''+CurrentProdrefid+'\',\''+SaleProdQty+'\',\''+jurisdictionId+'\')" class="form-control">'+
          '<option value="">Product Name</option>'+                                  
         '</select>'+
        '</div>'+
        '<div id="product_nameErrorMSGdiv" class="errormsg"></div>'+																	                  
        '<button class="addbtn pointers close_icon3 del_icon" id="'+crossbtn+'" type="button" style="display: none;" onclick="activeDisplay(\''+productname+'\',\''+producttype+'\',\''+crossbtn+'\',\''+productprice+'\',\''+ProductPriceDiv+'\',\''+newproductid+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\');showRemove(\''+removeicon+'\');"><i class="fas fa-times" style="font-size: 21px;"></i></button>'+
       
       '</div>'+
      '</div>'+
	  '</div>'+
	  '<div class="clearfix EstimateList2" id="'+ProductPriceDiv+'">'+
	  '<div class="clearfix inner_box_bg form-group" id="'+productprice+'" style="display: none;">'+
    '<div class="mb10 flex_box align_center relative_box">'+
    '<span class="input_radio bg_wht pad_box2 pad_box3 s_head">'+ 
	'<select class="s_type" name="'+jurisdictionId+'" id="'+jurisdictionId+'" onchange="updatePlan(\''+CurrentProdrefid+'\',this.value,\'esjurisdiction\');" required="required">'+
	'<option value="">Select Jurisdiction</option>'+																	
	'</select></span>'+
	'<span class="input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+onetimeterm+'" checked="checked" onclick="hideTime(\''+period+'\',\''+TimelineBox+'\',\''+ProductPlan+'\');updatePlan(\''+CurrentProdrefid+'\',\'OneTime\',\'esprodplan\');">'+
	'<span>One time</span>'+
	'</span>'+
	'<span class="mlft10 input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+rentimeterm+'" onclick="askTime(\''+period+'\',\''+PriceGroupId+'\',\''+periodtime+'\');updatePlan(\''+CurrentProdrefid+'\',\'Renewal\',\'esprodplan\');">'+
	'<span>Renewal</span>'+
	'</span>'+	
	'<span class="mlft10 RenBox1" id="'+period+'" style="width: 100px;">'+
	'<input type="text" name="'+ProductPlan+'" autocomplete="off"  onclick="showTimelineBox(\''+TimelineBox+'\')" onchange="updatePlan(\''+CurrentProdrefid+'\',this.value,\'esplantime\');" id="'+ProductPlan+'" class="form-control bdrnone text-right" placeholder="Timeline" style="width: 55%;">'+
    '<input type="text" name="'+periodtime+'" autocomplete="off" id="'+periodtime+'" class="form-control bdrnone pointers" readonly="readonly" style="width: 11%;position: absolute;margin-left: 50px;margin-top: -37px;">'+
	'</span>'+
	'<div class="timelineproduct_box" id="'+TimelineBox+'">'+
	'<div class="timelineproduct_inner">'+
	'<span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Day\',\'esplanperiod\')">Day</span> <span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Week\',\'esplanperiod\')">Week</span ><span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Month\',\'esplanperiod\')">Month</span><span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Year\',\'esplanperiod\')">Year</span></div>'+
	'</div>'+		
	'<input type="hidden" id="'+CurrentProdrefid+'"/>'+
	'<span class="bg_wht pad_box3 qtyBtn">'+
	'<span class="fa fa-minus pointers" onclick="updateMainProductQty(\''+SaleProdQty+'\',\'minus\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')"></span>'+
	'<input type="text" id="'+SaleProdQty+'" value="1" onchange="updateMainProdQty(\''+SaleProdQty+'\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')" onkeypress="return isNumber(event)">'+
	'<span class="fa fa-plus pointers" onclick="updateMainProductQty(\''+SaleProdQty+'\',\'plus\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')"></span>'+									
	'</span>'+
	'</div>'+
     '<div class="row mb10">'+
       '<div class="col-md-12 col-sm-12 col-xs-12">'+       
       '<div class="clearfix" id="'+PriceDropBox+'"></div>'+
       '<input type="hidden" name="'+PriceGroupId+'" id="'+PriceGroupId+'"/>'+
       '<div class="clearfix" id="'+PriceDropBoxSubAmount+'"></div>'+    
       
      '</div>'+
      '</div>'+	  
    '</div>'+
    '</div>'+
 '</div>'+
 '</div>'+
 '</div>').insertBefore('.MultipleProduct');	
	$('#edit_estimate').animate({scrollTop: $("#"+multiprod).offset().top},'slow');
	hideLoader();
}

function setProductPrice(prodid,crossbtn,producttype,productprice,productname,
		newproductbtn,pricedropbox,pricedropboxsubamount,pricedivid,PriceProduct,
		TotalPriceProduct,ProdGroupRefid,removeiconid,CurrentProdrefid,
		SaleProdQtyId,jurisdictionId){
	 var prod=$("#"+prodid).val();
	 var x=prod.split("#");
	 var prodrefid=x[1];
	 var salesno=$("#ConvertInvoiceSaleNo").val();
	 showLoader();
	 $.ajax({
			type : "POST",
			url : "IsProductInOrder111",
			dataType : "HTML",
			data : {				
				prodrefid : prodrefid,	
				salesno : salesno
			},
			success : function(data){	
				if(data=="fail"){					
					var company=$("#ConvertInvoiceCompany").val();
					var contactrefid=$("#ConvertInvoiceContactrefid").val();
					var clientrefid=$("#ConvertInvoiceClientrefid").val();
					var servicetype=$("#"+producttype).val();
					var prodname=x[0];
					var esrefid=makeid(40);	
					showLoader();
						 $.ajax({
								type : "POST",
								url : "SetProductInOrder111",
								dataType : "HTML",
								data : {				
									prodrefid : prodrefid,
									salesno : salesno,
									company : company,
									contactrefid : contactrefid,
									clientrefid : clientrefid,
									servicetype : servicetype,
									prodname : prodname,
									esrefid : esrefid
								},
								success : function(response){
								if(Object.keys(response).length!=0){
								response = JSON.parse(response);
								 var len = response.length;	
								 if(removeiconid!="NA"){
									 hideRemove(removeiconid);}								 	
									 $("#"+crossbtn).css('display','block');
									 $('#'+producttype).css('display','none');	 
									 $("#"+newproductbtn).css('display','block');
									 $("#"+productprice).css('display','block');
									 $('#'+productname).attr('disabled','disabled');
									 $('#'+productname).css('appearance','none');		
									 $('#'+CurrentProdrefid).val(esrefid);
								 var subamount=0;
								 var key="NA";
								for(var i=0;i<len;i++){									
									var groupkey = response[i]['salekey'];
									var pricetype = response[i]['pricetype'];
									var price = response[i]['price'];
									var minprice=Number(price);
									var hsn = response[i]['hsn'];
									var cgstpercent = response[i]['cgstpercent'];
									var sgstpercent = response[i]['sgstpercent'];
									var igstpercent = response[i]['igstpercent'];
									var totalprice = response[i]['totalprice'];
									var pricerefid = response[i]['pricerefid'];
									var taxprice = response[i]['taxprice'];
									var gstpercent=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);									
									var sn=$("#SalesProductIdQty").val();
									sn=Number(sn)+Number(1);
									var TaxId="TaxId"+sn;
									var PriceId="PriceId"+sn;
									var TotalPrice="TotalPrice"+sn;									
									var gstPriceId="gstPriceId"+sn;
									$("#SalesProductIdQty").val(sn);
									key=groupkey;
									subamount=Number(subamount)+Number(totalprice);
									$(''+
											'<div class="clearfix bg_wht link-style12 '+PriceProduct+'">'+
							             '<div class="box-width25 col-xs-1 box-intro-background">'+
							                  '<div class="clearfix">'+
							                  '<p class="news-border">'+(i+1)+'</p>'+
							                  '</div>'+
							              '</div>'+
							              '<div class="box-width19 col-xs-1 box-intro-background">'+
							                  '<div class="clearfix">'+
							                  '<p class="news-border" title='+pricetype+'>'+pricetype+'</p>'+
							                  '</div>'+
							              '</div>'+
							              '<div class="box-width14 col-xs-1 box-intro-background">'+
							                  '<div class="clearfix">'+																																																																																																					                                                                                            
							                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" style="height: 38px;margin-left: 2px;" value="'+price+'" id="'+PriceId+'" onchange="updatePrice(\''+pricerefid+'\',\''+TotalPrice+'\',\''+PriceId+'\',\''+minprice+'\',\''+cgstpercent+'\',\''+sgstpercent+'\',\''+igstpercent+'\',\''+esrefid+'\',\''+gstPriceId+'\',\''+SaleProdQtyId+'\',\''+key+'\')" onkeypress="return isNumberKey(event)"/></p>'+
							                  '</div>'+
							              '</div>'+    
							              '<div class="box-width3 col-xs-1 box-intro-background">'+
							              '<input type="text" name="'+TaxId+'" id="'+TaxId+'" value="'+gstpercent+' %'+'" class="form-control bdrnone" autocomplete="off" placeholder="Tax %" readonly="readonly">'+
											      '</div>'+
							              '<div class="box-width14 col-xs-6 box-intro-background">'+
							                  '<div class="clearfix">'+
							                  '<p class="news-border"><input type="text" class="form-control BrdNone" id="'+gstPriceId+'" style="height: 38px;margin-left: 2px;" value="'+taxprice+'" readonly="readonly"/></p>'+
							                  '</div>'+
							              '</div>'+
							              '<div class="box-width14 col-xs-6 box-intro-background">'+
							                  '<div class="clearfix">'+
							                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+TotalPrice+'" value="'+totalprice+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
							                  '</div>'+
							              '</div>'+ 
							           '</div>').insertBefore('#'+pricedropbox);
								}
								$(''+
										'<div class="clearfix '+TotalPriceProduct+'">'+
							         '<div class="box-width59 col-xs-6 box-intro-background">'+
							             '<div class="clearfix"><a href="javascript:void(0)" onclick="addNewPriceType(\''+ProdGroupRefid+'\')"><u>+ Add Price</u></a></div>'+
							         '</div>'+
										 '<div class="box-width26 col-xs-6 box-intro-background">'+
							             '<div class="clearfix">'+
							             '<p class="news-border justify_end">Total:</p>'+
							             '</div>'+
							         '</div>'+
							         '<div class="box-width14 col-xs-6 box-intro-background">'+
							             '<div class="clearfix">'+
							             '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+key+'" value="'+Number(subamount).toFixed(2)+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
							             '</div>'+
							         '</div>'+ 
							      '</div>').insertBefore('#'+pricedropboxsubamount);
								
								 $("#"+ProdGroupRefid).val(key);
								$("#"+productprice).css('display','block');
								document.getElementById(pricedivid).value=key;			
								 }else{
									 document.getElementById('errorMsg').innerHTML ='Price not Listed , Please set price.';	
									 $("#"+prodid).val('');
							 		    $('.alert-show').show().delay(4000).fadeOut();
								 }
								},
								complete : function(data){
									hideLoader();
								}
							});	
			if(jurisdictionId!="NA")
			appendNewProductJurisdiction(prodrefid,jurisdictionId);
			}else{
				document.getElementById('errorMsg').innerHTML ='Product already in your cart. Increase quantity !!';	
				$("#"+prodid).val('');
				 $('.alert-show').show().delay(4000).fadeOut();
			}},
			complete : function(data){
				hideLoader();
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
function activeDisplay(prodname,prodtype,crossbtn,productprice,parendpricediv,newproductid,pricedivrefid,PriceProduct,TotalPriceProduct){
	 $('#'+prodname).removeAttr('style');
	 $('#'+prodname).removeAttr('disabled');	 
	 $('#'+prodtype).show();
	 $('#'+newproductid).hide();
	 $('#'+prodname).val('');
	 $('#'+crossbtn).hide();	 
	 removeProductPrice(pricedivrefid,productprice,parendpricediv,PriceProduct,TotalPriceProduct);
} 
function removeProductPrice(pricedivid,productprice,parendpricediv,PriceProduct,TotalPriceProduct){
	 var salesrefidrefid=document.getElementById(pricedivid).value.trim();
	 showLoader();
	 $.ajax({
			type : "POST",
			url : "RemoveSalesProductPrices111",
			dataType : "HTML",
			data : {				
				salesrefidrefid : salesrefidrefid,				
			},
			success : function(data){				
					$('#'+productprice).css('display','none');
					$("."+PriceProduct).remove();
					$("."+TotalPriceProduct).remove();			
				
			},
			complete : function(data){
				hideLoader();
			}
		});	 
}
function hideRemove(removeid){
	 $('#'+removeid).css('display','none');
}
function showRemove(removeid){
	 $('#'+removeid).css('display','block');
}
function getProducts(servicetype,productDiv){
	if(servicetype!=""){
		showLoader();
		$.ajax({
		type : "POST",
		url : "GetServiceType111",
		dataType : "HTML",
		data : {				
			"servicetype":servicetype,
		},
		success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;
			 
			$("#"+productDiv).empty();
		    $("#"+productDiv).append("<option value=''>"+"Product Name"+"</option>");		    
			for(var i=0;i<len;i++){
				var prodrefid = response[i]['prodrefid'];
				var pname = response[i]['pname'];
				$("#"+productDiv).append("<option value='"+pname+"#"+prodrefid+"'>"+pname+"</option>");
			}
			}
		},
		complete : function(data){
			hideLoader();
		}
	});}else{
		$("#"+productDiv).empty();
	    $("#"+productDiv).append("<option value=''>"+"Product Name"+"</option>");	   
	}
}
function removeCurrentProduct(ProdBoxId,ProdPriceBox){
	$('#'+ProdBoxId).remove();
	$('#'+ProdPriceBox).remove();
}
function updateProdQty(InputBoxId,ProdGroupRefId){
	var prodrefid=$("#"+ProdGroupRefId).val();
	var prodqty=$("#"+InputBoxId).val();		
	if(prodrefid!="NA"&&prodrefid!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesProductsQtyDirect111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			prodqty : prodqty
			},
		success : function(data){
			var x=data.split("#");
			if(x[0]=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated Successfully.";				
				$("#"+InputBoxId).val(prodqty);		
				$("#ConvertedPriceListId").remove();
				var b=$('#Convert_Product_Name').val();
				var c=b.split("#");
				setProduct(c[1],prodrefid);
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(x[0]=="Not"){	
				document.getElementById("errorMsg").innerHTML="Invalid Input.";		
				$("#"+InputBoxId).val(x[1]);	
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";		
				$("#"+InputBoxId).val(x[1]);	
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
}																															
function updateMainProductQty(InputBoxId,action,ProdGroupRefid,rentimeterm,onetimeterm,ProductPlan,periodtime,periodproductprice,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount){
	var prodrefid=$("#"+ProdGroupRefid).val();
	
	var prodqty=$("#"+InputBoxId).val();	
	if(prodrefid!="NA"&&prodrefid!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesProductsQty111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			prodqty : prodqty,
			action : action
			},
		success : function(data){
			if(data=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated.";
				if(action=="plus"){prodqty=Number(prodqty)+Number(1);}
				else if(action=="minus"){prodqty=Number(prodqty)-Number(1);}
				$("#"+InputBoxId).val(prodqty);
				
				setMainProduct(prodrefid,InputBoxId,rentimeterm,onetimeterm,ProductPlan,periodtime,periodproductprice,ProdGroupRefid,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount);
				
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(data=="Not"){				
				document.getElementById("errorMsg").innerHTML="Invalid Input.";				
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
}				
function updateMainProdQty(InputBoxId,ProdGroupRefId,rentimeterm,onetimeterm,ProductPlan,periodtime,periodproductprice,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount){
	
	var prodrefid=$("#"+ProdGroupRefId).val();
	var prodqty=$("#"+InputBoxId).val();		
	
	if(prodrefid!="NA"&&prodrefid!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesProductsQtyDirect111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			prodqty : prodqty
			},
		success : function(data){
			var x=data.split("#");
			if(x[0]=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated.";				
				$("#"+InputBoxId).val(prodqty);	
				setMainProduct(prodrefid,InputBoxId,rentimeterm,onetimeterm,ProductPlan,periodtime,periodproductprice,ProdGroupRefId,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount);
				
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(x[0]=="Not"){	
				document.getElementById("errorMsg").innerHTML="Invalid Input.";		
				$("#"+InputBoxId).val(x[1]);	
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";		
				$("#"+InputBoxId).val(x[1]);	
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
}											
function setMainProduct(pricerefid,SaleProdQty,renewal,onetime,MainTimelineValue,MainTimelineUnit,ProductPeriod,CurrentProdrefid,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount){
	showLoader();
	fillTimePlan(pricerefid,SaleProdQty,renewal,onetime,MainTimelineValue,MainTimelineUnit,ProductPeriod);	
	
		$.ajax({
			type : "POST",
			url : "SetProductPriceList111",
			dataType : "HTML",
			data : {				
				pricerefid : pricerefid
			},
			success : function(response){
			if(Object.keys(response).length!=0){				
			$("#"+CurrentProdrefid).val(pricerefid);
			response = JSON.parse(response);
			 var len = response.length;						
				 $("."+PriceProduct).remove();
				 $("."+TotalPriceProduct).remove();
			 var subamount=0;			 
			for(var i=0;i<len;i++){
				var refid = response[i]['refid'];
				var pricetype = response[i]['pricetype'];
				var price = response[i]['price'];
				var minprice = response[i]['minprice'];
				var hsncode = response[i]['hsncode'];
				var cgstpercent = response[i]['cgstpercent'];
				var sgstpercent = response[i]['sgstpercent'];
				var igstpercent = response[i]['igstpercent'];
				var taxprice = response[i]['tax'];
				var totalprice = response[i]['totalprice'];
				var gstpercent=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);
				var sn=$("#SalesProductIdQty").val();
				sn=Number(sn)+Number(1);
				var TaxId="TaxUId"+sn;
				var PriceId="PriceUId"+sn;
				var TotalPrice="TotalPriceUId"+sn;
				var gstPriceId="GstPriceUId"+sn;
				$("#SalesProductIdQty").val(sn);
				subamount=Number(subamount)+Number(totalprice);
				$(''+
				'<div class="clearfix bg_wht link-style12 Estpricelist2 '+PriceProduct+'">'+
             '<div class="box-width25 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border">'+(i+1)+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width19 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border" title='+pricetype+'>'+pricetype+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+																																																																																																			
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" style="height: 38px;margin-left: 2px;" value="'+price+'" id="'+PriceId+'" onchange="updatePrice(\''+refid+'\',\''+TotalPrice+'\',\''+PriceId+'\',\''+minprice+'\',\''+cgstpercent+'\',\''+sgstpercent+'\',\''+igstpercent+'\',\''+pricerefid+'\',\''+gstPriceId+'\',\''+SaleProdQty+'\',\''+pricerefid+'\')" onkeypress="return isNumberKey(event)"/></p>'+
                  '</div>'+
              '</div>'+    
              '<div class="box-width3 col-xs-1 box-intro-background">'+
              '<input type="text" name="'+TaxId+'" id="'+TaxId+'" value="'+gstpercent+' %'+'" class="form-control bdrnone" autocomplete="off" placeholder="Tax %" readonly="readonly">'+
				      '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><input type="text" class="form-control BrdNone" id="'+gstPriceId+'" style="height: 38px;margin-left: 2px;" value="'+taxprice+'" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+TotalPrice+'" value="'+totalprice+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+ 
           '</div>').insertBefore('#'+PriceDropBox);				
			}
			$(''+
			'<div class="clearfix Estpricelist3 '+TotalPriceProduct+'">'+
         '<div class="box-width59 col-xs-6 box-intro-background">'+
             '<div class="clearfix"><a href="javascript:void(0)" onclick="addNewPriceType(\''+CurrentProdrefid+'\')"><u>+ Add Price</u></a></div>'+
         '</div>'+
			 '<div class="box-width26 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border justify_end">Total:</p>'+
             '</div>'+
         '</div>'+
         '<div class="box-width14 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+pricerefid+'" value="'+subamount.toFixed(2)+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
             '</div>'+
         '</div>'+ 
      '</div>').insertBefore('#'+PriceDropBoxSubAmount);			 	
			 }else{
				 document.getElementById('errorMsg').innerHTML ='Price not Listed , Please set price.';					
		 		    $('.alert-show').show().delay(4000).fadeOut();
			 }
			},
			complete : function(data){
				hideLoader();
			}
		});
}

function updateProductQty(InputBoxId,action,ProdGroupRefid){
	var prodrefid=$("#"+ProdGroupRefid).val();
	var prodqty=$("#"+InputBoxId).val();	
	if(prodrefid!="NA"&&prodrefid!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesProductsQty111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			prodqty : prodqty,
			action : action
			},
		success : function(data){
			if(data=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated Successfully.";
				if(action=="plus"){prodqty=Number(prodqty)+Number(1);}
				else if(action=="minus"){prodqty=Number(prodqty)-Number(1);}
				$("#"+InputBoxId).val(prodqty);		
				$("#ConvertedPriceListId").remove();
				var a=$('#Convert_Product_Name').val();
				var b=a.split("#");
				setProduct(b[1],prodrefid);
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(data=="Not"){				
				document.getElementById("errorMsg").innerHTML="Invalid Input.";				
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
}

	function updatePlan(prodid,value,colname){
		var prodrefid=$("#"+prodid).val();
		showLoader();
		$.ajax({
			type : "POST",
			url : "UpdateSalesProductPlan111",
			dataType : "HTML",
			data : {	
				prodrefid : prodrefid,
				value : value,
				colname : colname
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML ="Updated";
					$('.alert-show1').show().delay(500).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}
	function hideTime(ProductPeriod,Timelinebox,MainTimelineValueId){
		$("#"+MainTimelineValueId).prop('readonly',true);
		$("#"+ProductPeriod).hide();
		$("#"+Timelinebox).hide();
	}
	function askTime(ProductPeriod,TimelineValueId,TimeLineUnitId){
		$("#"+TimelineValueId).val('');
		$("#"+TimeLineUnitId).val('');
		$("#"+ProductPeriod).css('display','block');
		
	}
	function showTimelineBox(TimelineBoxId){
		if($('#'+TimelineBoxId).css('display') == 'none')
		{
			$("#"+TimelineBoxId).css('display','block');
		}	
	}
	
	function validateUpdateCompany(){	       
		if($("#UpdateCompanyName").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Company Name is mandatory.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateIndustry_Type").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Industry type is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if($("#Update_Super_User").val()==null||$("#Update_Super_User").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Select Super User";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if($("#UpdatePanNumber").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Pan Number is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateGSTNumber").val().trim()==""){
			$("#UpdateGSTNumber").val("NA");
		}
		
		if($("#Edit_Company_age").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Company age is mandatory !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if($("#UpdateCity").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="City is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateState").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="State is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateCountry").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Country is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateAddress").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Address is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		var industrytype=$("#UpdateIndustry_Type").val();
		let superUser=$("#Update_Super_User").val();
		var pan=$("#UpdatePanNumber").val();
		var gstin=$("#UpdateGSTNumber").val();
		var city=$("#UpdateCity").val();
		var state=$("#UpdateState").val();
		var stateCode="";
		var x=state.split("#");
		state=x[2];
		stateCode=x[1];
		var country=$("#UpdateCountry").val();
		if(country.includes("#")){
			var x=country.split("#");
			country=x[1];
		}
		var address=$("#UpdateAddress").val();
		var companyAge=$("#Edit_Company_age").val();
		var companykey=$("#UpdateCompanyKey").val();
		var companyName=$("#UpdateCompanyName").val();
		showLoader();
		$.ajax({
			type : "POST",
			url : "UpdateNewCompany777",
			dataType : "HTML",
			data : {				
				industrytype : industrytype,
				pan : pan,
				gstin : gstin,
				city : city,
				state : state,
				country : country,
				address : address,
				companykey : companykey,
				companyAge : companyAge,
				stateCode : stateCode,
				companyName: companyName,
				superUser : superUser
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';
					$('#UpdateRegCompany').trigger("reset");
					
					$('.fixed_right_box').removeClass('active');
					$('.addnew').show();
									
					$('.alert-show1').show().delay(4000).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}
	function addSuperUser(selectId){
		$("#add_super_user_id").val(selectId);
		$("#add_super_user").modal("show");	
	}
	function validateSuperUser(){
		let super_name=$("#super_name").val();
		let super_email=$("#super_email").val();
		let super_mobile=$("#super_mobile").val();
		if(super_name==null||super_name==""){
			document.getElementById('errorMsg').innerHTML ="Please enter name !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(super_email==null||super_email==""){
			document.getElementById('errorMsg').innerHTML ="Please enter email !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(super_mobile==null||super_mobile==""){
			document.getElementById('errorMsg').innerHTML ="Please enter mobile !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		$.ajax({
			type : "POST",
			url : "SaveClientSuperUser111",
			dataType : "HTML",
			data : {				
				super_name : super_name,
				super_email : super_email,
				super_mobile : super_mobile
			},
			success : function(data){
// 				console.log(data);
				if(data=="exist"){
					document.getElementById('errorMsg').innerHTML = 'Either mobile or email already exist !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}else if(data=="pass"){
					let selectId=$("#add_super_user_id").val();
					setClientSuperUser(selectId); 
					$("#super_user_form")[0].reset();
					$("#add_super_user").modal("hide");
					document.getElementById('errorMsg1').innerHTML = 'Super User Registered Successfully !!';
					$('.alert-show1').show().delay(4000).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(msg) {
	            hideLoader();
	        }
		});
		
	}
	function setClientSuperUser(selectId){
		$.ajax({
			type : "GET",
			url : "GetClientSuperUser111",
			dataType : "HTML",
			data : {},
			success : function(response){	
				/* console.log(response); */
				$("#"+selectId).empty();
				$("#"+selectId).append(response).trigger('change');
			}
		});
	}
	
	function validateUpdateContact(){
		if(document.getElementById("UpdateContactFirstName").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="First name is mandatory.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(document.getElementById("UpdateContactLastName").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="Last name is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(document.getElementById("UpdateContactEmail_Id").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="Email is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(document.getElementById("UpdateContactEmailId2").value.trim()==""){
			document.getElementById("UpdateContactEmailId2").value="NA";
		}
		if(document.getElementById("UpdateContPan").value.trim()==""){
			document.getElementById("UpdateContPan").value="NA";
		}
		if(document.getElementById("UpdateContactWorkPhone").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="Work phone is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(document.getElementById("UpdateContactMobilePhone").value.trim()==""){
			document.getElementById("UpdateContactMobilePhone").value="NA";
		}
		
		if($('#UpdateContactperAddress').prop('checked')){
			if(document.getElementById("UpdateContCountry").value.trim()==""){
				document.getElementById('errorMsg').innerHTML ="Country is mandatory";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}			
			if(document.getElementById("UpdateContState").value.trim()==""){
				document.getElementById('errorMsg').innerHTML ="State is mandatory";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if(document.getElementById("UpdateContCity").value.trim()==""){
				document.getElementById('errorMsg').innerHTML ="City is mandatory";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if(document.getElementById("UpdateContAddress").value.trim()==""){
				document.getElementById('errorMsg').innerHTML ="Address is mandatory";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
		}
		var firstname=document.getElementById("UpdateContactFirstName").value.trim();
		var lastname=document.getElementById("UpdateContactLastName").value.trim();
		var email=document.getElementById("UpdateContactEmail_Id").value.trim();
		var email2=document.getElementById("UpdateContactEmailId2").value.trim();
		var workphone=document.getElementById("UpdateContactWorkPhone").value.trim();
		var mobile=document.getElementById("UpdateContactMobilePhone").value.trim();
		var pan=$("#UpdateContPan").val();
		var country="NA";
		var city="NA";
	    var state="NA";
	    var stateCode="NA";
	    var address="NA";
	    var companyaddress="NA";
	    var addresstype="Personal";
	    if($('#UpdateContactperAddress').prop('checked')){
	    	country=$("#UpdateContCountry").val();
	    	var x=country.split("#");
	    	country=x[1];
	    	state=document.getElementById("UpdateContState").value.trim();
	    	x=state.split("#");
	    	stateCode=x[1];
	    	state=x[2];
	    	city=document.getElementById("UpdateContCity").value.trim();	    	
	    	address=document.getElementById("UpdateContAddress").value.trim();
	    }
	    if($('#UpdateContactcomAddress').prop('checked')){
			companyaddress=document.getElementById("UpdateEnqCompAddress").value.trim();
			addresstype="Company";
	    }
	   
	   var contkey=document.getElementById("UpdateContactKey").value.trim(); 
	   var stbid=document.getElementById("UpdateContactSalesKey").value.trim(); 
	   
	   showLoader(); 
	   $("#ValidateUpdateContact").attr("disabled","disabled");   
		 $.ajax({
			type : "POST",
			url : "UpdateContactDetails111",
			dataType : "HTML",
			data : {				
				firstname : firstname,
				lastname : lastname,
				email : email,
				email2 : email2,
				workphone : workphone,
				mobile : mobile,
				city : city,
				state : state,
				country : country,
				address : address,
				companyaddress : companyaddress,
				addresstype : addresstype,
				contkey : contkey,
				pan : pan,
				stateCode : stateCode
			},
			success : function(data){
				$("#ValidateUpdateContact").removeAttr("disabled");
				if(data=="pass"){					
					 $('#FormUpdateContactBox').trigger("reset");
					$('.fixed_right_box').removeClass('active');
					$('.addnew').show();
					
					updateSalesContact(stbid,firstname,lastname,email,email2,workphone,mobile);									
				}else if(data=="invalid"){
					document.getElementById('errorMsg').innerHTML = 'Please enter a valid email-address !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(msg) {
	            hideLoader();
	        }
		}); 
	}
	
	function updateSalesContact(stbid,firstname,lastname,email,email2,workphone,mobile){
	    showLoader();
		$.ajax({
			type : "POST",
			url : "UpdateSalesContactDetails111",
			dataType : "HTML",
			data : {	
				stbid : stbid,
				firstname : firstname,
				lastname : lastname,
				email : email,
				email2 : email2,
				workphone : workphone,
				mobile : mobile,
				salesKey : "NA"
			},
			success : function(data){
				if(data=="pass"){
					
					var rowdivid=document.getElementById("ManageEstimateUpdateContactId").value;
					$("#"+rowdivid).html(firstname+" "+lastname);
					
					document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';				  
					$('.alert-show1').show().delay(4000).fadeOut();	
					
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}
	
	function isExistEditPan(valueid){
		var val=document.getElementById(valueid).value.trim();
		var key=$("#UpdateContactKey").val();
		if(val!=""&&val!="NA"&&key!=""&&key!="NA")
		$.ajax({
			type : "POST",
			url : "ExistEditValue111",
			dataType : "HTML",
			data : {"val":val,"field":"isEditPanContact","id":key},
			success : function(data){
				if(data=="pass"){
				document.getElementById("errorMsg").innerHTML=val +" is already existed.";
				document.getElementById(valueid).value="";
				$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
	}

	
	function fillCompanyDetails(clientkey){		
		showLoader();
		$.ajax({
			type : "POST",
			url : "GetCompanyByRefid111",
			dataType : "HTML",
			data : {				
				clientkey : clientkey
			},
			success : function(response){
				if(Object.keys(response).length!=0){	
			response = JSON.parse(response);			
			 var len = response.length;		 
			 if(len>0){ 
			 	var clientkey=response[0]["clientkey"];
				var name=response[0]["name"];
				var industry=response[0]["industry"];
				var pan=response[0]["pan"];
				var gst=response[0]["gst"];
				var city=response[0]["city"];
				var state=response[0]["state"];
				var country=response[0]["country"];
				var address=response[0]["address"];
				var compAge=response[0]["compAge"];
				var stateCode=response[0]["stateCode"];
				var superUserUaid=response[0]["superUserUaid"];		
				
				$("#UpdateCompanyKey").val(clientkey);
				$("#UpdateCompanyName").val(name);
				$("#UpdateIndustry_Type").val(industry);
				$("#UpdatePanNumber").val(pan);
				$("#Edit_Company_age").val(compAge);
				$("#Update_Super_User").val(superUserUaid).trigger('change');
				if(gst!="NA"&&gst!=""){
					$("#UpdateGSTNumber").val(gst);
					document.getElementById("CompanyGstDivId").style.display="block";
				}			
				$("#UpdateCity").empty();
				$("#UpdateCity").append("<option value='"+city+"' selected='selected'>"+city+"</option>");
				$("#UpdateState").empty();
				$("#UpdateState").append("<option value='0#"+stateCode+"#"+state+"' selected='selected'>"+state+"</option>");
				$("#UpdateCountry").val(country);
				$("#UpdateAddress").val(address);
				
			 }
			}},
			complete : function(data){
				hideLoader();
			}
		});
	}
	function openCompanyBox(comprefid){
		$("#UpdateRegCompany").trigger('reset');
		if(comprefid!="NA"){
		fillCompanyDetails(comprefid);	
		var id = $(".companybox").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
		}else{
			document.getElementById('errorMsg').innerHTML ="Client Doesn't exist, After converted sale it will register !!!.";
			$('.alert-show').show().delay(4000).fadeOut();
		}
		setClientSuperUser("Update_Super_User"); 
	}
	$('.add_new').on( "click", function(e) {
		$(this).parent().next().show();	
		});	
	$('.del_icon').on( "click", function(e) {
		$('.new_field').hide();	
		});
	$('#UpdateContactcomAddress').on( "click", function(e) {
		$('.UpdateAddress_box').hide();
		$('.UpdateCompany_box').show();	
		});
		$('#UpdateContactperAddress').on( "click", function(e) {
		$('.UpdateAddress_box').show();
		$('.UpdateCompany_box').hide();	
		});
	function openContactBox(contctref,cboxid,boxid,compaddId){
		var address=$("#"+compaddId).val();
		$("#ManageSalesCompAddress").val(address);
		$('#FormUpdateContactBox').trigger("reset");
		fillContactUpdateForm(contctref,cboxid);
		$("#ManageEstimateUpdateContactId").val(boxid);
		var id = $(".contactbox").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
	}
	function fillContactUpdateForm(key,cboxid){
		showLoader();
		$.ajax({
			type : "POST",
			url : "GetContactByRefid111",
			dataType : "HTML",
			data : {				
				key : key
			},
			success : function(response){
				if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;		 
			 if(len>0){
			 	var contkey=response[0]["key"];
				var firstname=response[0]["firstname"];
				var lastname=response[0]["lastname"];
				var email1=response[0]["email1"];
				var email2=response[0]["email2"];
				var workphone=response[0]["workphone"];
				var mobilephone=response[0]["mobilephone"];
				var addresstype=response[0]["addresstype"];
				var city=response[0]["city"];
				var state=response[0]["state"];
				var country=response[0]["country"];
				var address=response[0]["address"];
				var pan=response[0]["pan"];
				var stateCode=response[0]["stateCode"];
								
				$("#UpdateContactKey").val(contkey);$("#UpdateContactSalesKey").val(cboxid);$("#UpdateContactFirstName").val(firstname);$("#UpdateContactLastName").val(lastname);$("#UpdateContactEmail_Id").val(email1);
				if(email2!=="NA"){
					$("#UpdateContactEmailId2").val(email2);
					document.getElementById("UpdateContactDivId").style.display="block";
				}			
				$("#UpdateContactWorkPhone").val(workphone);$("#UpdateContactMobilePhone").val(mobilephone);
				if(addresstype=="Personal"){
					$("#UpdateContCity").empty();
					$("#UpdateContCity").append("<option value='"+city+"' selected='selected'>"+city+"</option>");
					$("#UpdateContState").empty();
					$("#UpdateContState").append("<option value='0#"+stateCode+"#"+state+"' selected='selected'>"+state+"</option>");
					
					$("#UpdateContCountry").val(country);
					$("#UpdateContPan").val(pan);
					$("#UpdateContAddress").val(address);	
					$("#UpdateContactperAddress").attr('checked',true);
					$("#UpdateContactcomAddress").attr('checked',false);
					$(".UpdateAddress_box").show();
					$(".UpdateCompany_box").hide();
				}else{
					$("#UpdateContactcomAddress").attr('checked',true);
					$("#UpdateContactperAddress").attr('checked',false);
					$("#UpdateEnqCompAddress").val(address);
					$(".UpdateAddress_box").hide();
					$(".UpdateCompany_box").show();
				}			
				
			 }
			}},
			complete : function(data){
				hideLoader();
			}
		});
	}
	function getUpdateCompanyAddress(){
		var compaddress=document.getElementById("ManageSalesCompAddress").value.trim();
		document.getElementById("UpdateEnqCompAddress").value=compaddress;
	}
	function showAllContact(event,id1,id2){
		event.stopPropagation();
		 	$('.name_action_box').removeClass("active");
		 	$('.dropdown_list').removeClass("show");
		 	$('#'+id1).addClass("active");
		 	$('#'+id2).addClass("show");
		
	}
	function minusAllContact(event){
		event.stopPropagation();
		$('.name_action_box').removeClass("active");
		$('.dropdown_list').removeClass("show");
	}
	
function showPayments(PymtSubDiv,PymtIconRight,PymtIconDown){
	if($('#'+PymtIconDown).css('display') == 'none'){
		$('#'+PymtIconRight).css('display','none');
		$('#'+PymtIconDown).css('display','block');
		$('#'+PymtSubDiv).css('display','block');
	}else{
		$('#'+PymtIconRight).css('display','block');
		$('#'+PymtIconDown).css('display','none');
		$('#'+PymtSubDiv).css('display','none');
	}
}	
function backEstimate(){
	var saleno=$("#ConvertInvoiceSaleNo").val();
	showLoader();
	 fillEstimateInvoiceDetails(saleno);
	  var id = $(".estimatebox").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
	hideLoader();
}
   function openEstimateBox(saleno,companyname,contactrefid,clientrefid,estrefKey,
		   discount,clientEmail,clientName,totalAmount,date,salesType,status){
	   showLoader();
	   $("#taskNotesProduct").html('Notes : '+saleno);
	   $("#ConvertInvoiceSaleNo").val(saleno);
	   $("#ConvertInvoiceCompany").val(companyname);
		$("#ConvertInvoiceContactrefid").val(contactrefid);
		$("#ConvertInvoiceClientrefid").val(clientrefid);
		$("#ConvertEstimateRefKey").val(estrefKey);
		$("#ConvertEstimateSalesType").val(salesType);
		$("#SendEmailClientEmail").val(clientEmail);
		$("#SendEmailClientName").val(clientName);
		$("#ConvertEstimateDiscount").val(discount);
	   $('#EstimateBillNo').html("#"+saleno);
	   $("#CopyLinkUrl").removeClass('textCopied');
	   $("#ConvertEstimateStatus").val(status);
	   
	   fillEstimateInvoiceDetails(saleno);
	   isInvoiceEditable(saleno);
	   openInvoiceSummary(saleno,0);
	  
	   var id = $(".estimatebox").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
		$("#EmailSendedId").attr("onclick","openSendEmailBox(\""+date+"\",\""+totalAmount+"\")");
		 hideLoader();
   }  
   function uploadDocument(){
	   var estkey=$("#estimateDocList").val();
		$("#ConvertEstimateDocRefKey").val(estkey);
	    setClientDocuments();
		 var id = $(".upload_documents").attr('data-related'); 
			$('.fixed_right_box').addClass('active');
			    $("div.add_inner_box").each(function(){
			        $(this).hide();
			        if($(this).attr('id') == id) {
			            $(this).show();
			        }
			    });	
	 }
   function generateEstimate(){
	   var saleno=$("#ConvertInvoiceSaleNo").val();
	   getOrderAndDueAmount1(saleno);
	   setTotalSalesProduct(saleno);
	   setGeneratedEstimate();
		 var id = $(".generate_estimate").attr('data-related'); 
			$('.fixed_right_box').addClass('active');
			    $("div.add_inner_box").each(function(){
			        $(this).hide();
			        if($(this).attr('id') == id) {
			            $(this).show();
			        }
			    });	
	 }
function setTotalSalesProduct(saleno){
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetEstimateSalesProducts111",
		dataType : "HTML",
		data : {				
			saleno : saleno,						
		},
		success : function(data){	
		if(Object.keys(data).length!=0){
			data = JSON.parse(data);			
		 var len = data.length;
		 if(Number(len)>0){	
			$("#selectProduct").empty(); 
			var options="";			 
		 for(var j=0;j<len;j++){ 			
		 	var name=data[j]["name"];
		 	options+="<option value='"+name+"'>"+name+"</option>";	 
		 }
		 $("#selectProduct").append(options);
		 }}
	},
	complete : function(data){
		hideLoader();
	}});
}
   function  getOrderAndDueAmount1(estimateno){
	   showLoader();
		$.ajax({
			type : "POST",
			url : "GetOrderAndDueAmount111",
			dataType : "HTML",
			data : {				
				estimateno : estimateno
			},
			success : function(response){		
			var x=response.split("#"); 
			var pffcgst=Number(x[2]);
			var pffsgst=Number(x[3]);
			var pffigst=Number(x[4]);
			var pfftax=pffcgst+pffsgst+pffigst;		
			
			$("#ProfessionalCgst").val(pffcgst);
			$("#ProfessionalSgst").val(pffsgst);
			$("#ProfessionalIgst").val(pffigst);
			
			var govcgst=Number(x[5]);
			var govsgst=Number(x[6]);
			var govigst=Number(x[7]);
			var govtax=govcgst+govsgst+govigst;
			
			$("#GovernmentCgst").val(govcgst);
			$("#GovernmentSgst").val(govsgst);
			$("#GovernmentIgst").val(govigst);
			
			var othercgst=Number(x[8]);
			var othersgst=Number(x[9]);
			var otherigst=Number(x[10]);
			var otrtax=othercgst+othersgst+otherigst;
			
			$("#OtherCgst").val(othercgst);
			$("#OtherSgst").val(othersgst);
			$("#OtherIgst").val(otherigst);
			
			var servicecgst=Number(x[11]);
			var servicesgst=Number(x[12]);
			var serviceigst=Number(x[13]);
			var servicetax=servicecgst+servicesgst+serviceigst;
			
			$("#ServiceChargeCgst").val(servicecgst);
			$("#ServiceChargeSgst").val(servicesgst);
			$("#ServiceChargeIgst").val(serviceigst);
			
			$("#ProfessionalFeeTax").val(pfftax);
			$("#GovernmentFeeTax").val(govtax);
			$("#ServiceChargeTax").val(servicetax);
			$("#OtherFeeTax").val(otrtax);
			
			$("#Professional_Fee_GST1").html(pfftax+"%");
			$("#Government_Fee_GST1").html(govtax+"%");
			$("#service_Charges_GST1").html(servicetax+"%");
			$("#Other_Fee_GST1").html(otrtax+"%");
			
			},
			complete : function(data){
				hideLoader();
			}
		});
	}
 function fillEstimateInvoiceDetails(saleno){
	 $(".ItemDetailList").remove();	
	 $("#TotalPriceWithoutGst").html('');
	 $("#TotalGstAmount").html('');
	 $("#TotalAmountWithGST").html('');
	 var discount=$("#ConvertEstimateDiscount").val();
	 $("#estimateDocList").empty();
	 $("#notesestimate").empty();
	 $("#notesestimate").append("<option value=''>Select Service</option>");
	 $.ajax({
			type : "POST",
			url : "GetEstimatePriceList111",
			dataType : "HTML",
			data : {				
				saleno : saleno
			},
			success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;
			 if(Number(len)>0){	
				 var k=1;		
				 var qtyborder="";
				 var totalProdQty=0; 
			 for(var i=0;i<len;i++){ 			
			 	var refid=response[i]["refid"];
				var name=response[i]["name"];		
				var date=response[i]["date"];
				var qty=response[i]["qty"];				
				
				var subitemdetails="subitemdetails"+i;
				totalProdQty=Number(totalProdQty)+Number(qty);
				
				if(k==1){
					var cregname=response[i]["cregname"];
					var cregaddress=response[i]["cregaddress"];
					var cregstate=response[i]["cregstate"];
					var cregstatecode=response[i]["cregstatecode"];
					var cregistin=response[i]["cregistin"];
					var subtotalprice=response[i]["subtotalprice"];
					var orderNo=response[i]["orderNo"];
					var purchaseDate=response[i]["purchaseDate"];
					
					if(orderNo!=null&&orderNo!="NA"&&orderNo!=""){$("#orderNo").html("#"+orderNo);$("#orderNoMain").show();
					}else $("#orderNoMain").hide();
					
					if(purchaseDate!=null&&purchaseDate!="NA"&&purchaseDate!=""){$("#PurchaseDate").html(purchaseDate);$("#purchaseDateMain").show();
					}else $("#purchaseDateMain").hide();
					
					if(cregname!=null&&cregname!="NA"&&cregname!=""){$("#BillToId").html(cregname);} 
					if(cregistin!=null&&cregistin!="NA"&&cregistin!=""){
						$("#BillToGSTINId").html("GSTIN "+cregistin);$("#BillToGSTINId").show();
					}else{
						$("#BillToGSTINId").hide();
						}
					
					if(cregname!=null&&cregname!="NA"&&cregname!=""){ $("#ShipToId").html(cregname);}
					if(cregname!=null&&cregname!="NA"&&cregname!=""){ $("#ShipToAddressId").html(cregaddress);}
					if(cregname!=null&&cregname!="NA"&&cregname!=""){ $("#ShipToStateCode").html(cregstate+'('+cregstatecode+')');}
					$("#EstimateDate").html(date); k++;
// 					$("#EstimateSubTotal").val(Number(subtotalprice).toFixed(2));
					numberToWords("EstimateRupeesInWord",Math.round((Number(subtotalprice)-Number(discount))));					
				
					var invoiceNotes=response[i]["invoiceNotes"];
					if(invoiceNotes!=null&&invoiceNotes!="NA"){
						$("#invoiceNotes").html(invoiceNotes);
					}
					
				}else{
						qtyborder="border-top: 1px solid #ccc;";
					}
				
				$("#notesestimate").append("<option value='"+refid+"'>"+name+"</option>");
				
				$(''+
						'<div class="clearfix ItemDetailList" style="width:100%;">'+
						'<div class="clearfix" style="font-weight: 600;width:100%;display: flex;'+qtyborder+'padding: 4px 0px 4px 0px;">'+
						'<div style="width:4%;">'+
						'<p style="margin: 0; font-size: 11px;">'+(i+1)+'</p>'+
						'</div>'+
						'<div style="width:96%;">'+
						'<p style="margin: 0; font-size: 11px;">'+name+' ('+qty+')</p>'+
						'</div>'+
						'</div>'+				
						'<div class="clearfix" id="'+subitemdetails+'"></div>'+				
						
						'<div class="clear">'+
						'</div>'+
						'</div>').insertBefore('#ItemListDetailsId');
				
				$("#estimateDocList").append("<option value='"+refid+"'>"+name+"</option>");
				appendPriceList(refid,subitemdetails,i,discount);
				
			 }	 
			 
			 $("#TotalProductQuty").html(totalProdQty);
			 showAllTaxData(saleno);
			 setTimeout(function(){
			 	getDueAmount(saleno);
// 			 	var totalRate=Number($("#TotalPriceWithoutGst").html());
// 				 var totalGST=Number($("#TotalGstAmount").html());
// 				 var totalAmount=Number($("#TotalAmountWithGST").html());
				 var discount=Number($("#TotalAmountDiscount").html());
				 
// 				 $("#TotalPriceWithoutGst").html(numberWithCommas(totalRate));
// 				 $("#TotalGstAmount").html(numberWithCommas(totalGST));
// 				 $("#TotalAmountWithGST").html(numberWithCommas(totalAmount));
// 				 if(discount>0){
// 					 $("#TotalAmountDiscount").html(numberWithCommas(discount));
// 					 $(".totalDiscount").show();
// 				 }else{
// 					 $(".totalDiscount").hide();
// 				 }
				 
			 },1000);
			 
				}}
			}});	
 } 
function getDueAmount(saleno){
	$.ajax({
			type : "GET",
			url : "GetEstimateDueAmount111",
			dataType : "HTML",
			data : {				
				saleno : saleno,						
			},
			success : function(data){
				var x=data.split("#");
				 $("#TotalPriceWithoutGst").html(x[1]);
				 $("#TotalGstAmount").html(x[2]);
				 $("#TotalAmountWithGST").html(x[3]);
				 var discount=x[4];
				 if(Number(discount)>0){
					 $("#TotalAmountDiscount").html(numberWithCommas(discount));
					 $(".totalDiscount").show();
				 }else{
					 $(".totalDiscount").hide();
				 }
				if(x[0]!="fail"&&x[0]!=x[3]){					
					if(Number(x[0])<=0){						
						$("#PaymentPaidOrPartial").html("Paid");
						$( "#PaymentPaidOrPartial" ).css('margin-left','-43px');
						$("#BalanceDueAmount").hide();
					}else{
						$("#PaymentPaidOrPartial").html("Partial");
						$("#PaymentPaidOrPartial" ).css('margin-left','-48px');
						$("#BalanceDueAmount").show();
						$("#InvoivePaymentDue").html(numberWithCommas(x[0]));
					} 					
				}else{
					$("#PaymentPaidOrPartial").html("Due");
					$( "#PaymentPaidOrPartial" ).css('margin-left','-43px');
					var totalAmount=$("#TotalAmountWithGST").html();
					$("#InvoivePaymentDue").html(totalAmount);
				}
			}
		}); 
 }
 
function showAllTaxData(salesNo){
	$(".taxRemoveBox").remove();	
	 $.ajax({
			type : "POST",
			url : "GetEstimateTaxList111",
			dataType : "HTML",
			data : {				
				salesNo : salesNo,						
			},
			success : function(data){	
			if(Object.keys(data).length!=0){
				data = JSON.parse(data);			
			 var plen = data.length;
			 if(Number(plen)>0){				 
			 for(var j=0;j<plen;j++){ 			
			 	var hsn=data[j]["hsn"];
				var cgst=data[j]["cgst"];
				var sgst=data[j]["sgst"];
				var igst=data[j]["igst"];
				
				var taxBorder="border-top: 1px dotted #ccc;";
				if(j==0){taxBorder="";}
				$(''+
			    '<div class="clearfix taxRemoveBox" style="width: 100%;text-align: center;padding: 5px 0 5px 0px;font-size: 10px;display: flex;'+taxBorder+'">'+
			    	'<div style="width: 25%">'+hsn+'</div>'+
			    	'<div style="width: 25%">'+sgst+'</div>'+
			    	'<div style="width: 25%">'+cgst+'</div>'+
			    	'<div style="width: 25%">'+igst+'</div>'+
			    '</div>').insertBefore("#GSTTaxAppendBoxId");
							 
			 }}
			 $("#DisplayTaxData").show(); 
			}else{
				 $("#DisplayTaxData").hide();
			 }
	}});
}
function appendPriceList(refid,subitemdetails,i,discount){
	setTimeout(function(){
		if(i==0)i=1;
	  $.ajax({
					type : "POST",
					url : "GetEstimateSubPriceList111",
					dataType : "HTML",
					data : {				
						refid : refid,						
					},
					success : function(data){
					if(Object.keys(data).length!=0){
						data = JSON.parse(data);			
					 var plen = data.length;
					 if(Number(plen)>0){	
// 						 var totalRate=Number($("#TotalPriceWithoutGst").html());
// 						 var totalGST=Number($("#TotalGstAmount").html());
// 						 var totalAmount=Number($("#TotalAmountWithGST").html());
						 
					 for(var j=0;j<plen;j++){ 			
					 	var prefid=data[j]["prefid"];
						var pricetype=data[j]["pricetype"];
						var price=Math.round(Number(data[j]["price"]));
						var hsncode=data[j]["hsncode"];						
						var cgstpercent=data[j]["cgstpercent"];				
						var sgstpercent=data[j]["sgstpercent"];				
						var igstpercent=data[j]["igstpercent"];				
						var cgstprice=data[j]["cgstprice"];	
						cgstprice=Number(cgstprice).toFixed(2);
						var sgstprice=data[j]["sgstprice"];	
						sgstprice=Number(sgstprice).toFixed(2);
						var igstprice=data[j]["igstprice"];		
						igstprice=Number(igstprice).toFixed(2);
						var totalprice=data[j]["totalprice"];	
						
						totalprice=Math.round(Number(totalprice));
						var tax=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);
						var taxamt=Math.round(Number(cgstprice)+Number(sgstprice)+Number(igstprice));
						
												
// 						totalRate=Number(totalRate)+Number(price);
// 						totalGST=Number(totalGST)+Number(taxamt);
// 						totalAmount=Number(totalAmount)+Number(totalprice);				 
						$(''+
								'<div class="clearfix" style="border-top: 1px solid #ccc;padding: 4px 0px 4px 0px;width:100%;display: flex;font-size: 10px;">'+
							    '<div style="margin-bottom: 0;padding-left: 16px; width: 34%;">'+
							    '<i class="" style="padding-right: 10px;color: #999;"></i>'+pricetype+'</div>'+							    
							    '<div style="width:13%;">'+
								'<p style="margin:0;text-align: right;">'+hsncode+'</p>'+
								'</div>'+
								'<div style="width:15%;">'+
								'<p style="margin:0;text-align: right;">'+numberWithCommas(price)+'</p>'+
								'</div>'+								
								'<div style="width:8%;">'+
								'<p style="margin:0;text-align: right;">'+tax+' %</p>'+
								'</div>'+
								'<div style="width:12%;">'+
								'<p style="margin:0;text-align: right;">'+numberWithCommas(taxamt)+'</p>'+
								'</div>'+
								'<div style="width:18%;">'+
								'<p style="margin:0;text-align: right;">'+numberWithCommas(totalprice)+'</p>'+
								'</div>'+
								'</div>').insertBefore("#"+subitemdetails);
					 }
					 
// 					 $("#TotalPriceWithoutGst").html(totalRate.toFixed(2));
// 					 $("#TotalGstAmount").html(totalGST.toFixed(2));
// 					 $("#TotalAmountDiscount").html("- "+Number(discount).toFixed(2));
// 					 $("#TotalAmountWithGST").html((totalAmount-Number(discount)).toFixed(2));
					 }}
			}
			});		  
	},200*i);	
 }
 function editEstimateBox(){
	 showLoader();
	 $(".EstimateList1").remove();
	 $(".EstimateList2").remove();
	   fillAllEstimateProduct();
	   var id = $(".editinvconvt").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
	hideLoader();
 }
 
   function convertInvoiceBox(){
	   $(".EstimatePaymentInnerId").remove();	
	   var estimateno=$("#ConvertInvoiceSaleNo").val();
	   var companyname=$("#ConvertInvoiceCompany").val();
       var clientrefid=$("#ConvertInvoiceClientrefid").val();
       var contactrefid=$("#ConvertInvoiceContactrefid").val();
       var estimateRefKey=$("#ConvertEstimateRefKey").val();
       let salesType=$("#ConvertEstimateSalesType").val();
       let status=$("#ConvertEstimateStatus").val();
       $("#UploadFormdata")[0].reset();
       if(status=="Invoiced"){
    	   let option="<option value=\"\">Payment Mode</option>"+
    		   "<option value=\"Online\" selected=\"selected\">Online</option>"+
    		   "<option value=\"Cash\">Cash</option>";
    	   $('#PaymentMode').empty();
    	   $('#PaymentMode').append(option);
       }else{
    	   let option="<option value=\"\">Payment Mode</option>"+
		   "<option value=\"Online\" selected=\"selected\">Online</option>"+
		   "<option value=\"Cash\">Cash</option>"+
		   "<option value=\"PO\">Purchase Order</option>";
	   $('#PaymentMode').empty();
	   $('#PaymentMode').append(option);
       }
       
       
	   $(".btnpay").show();
	   $("#AddPaymentModeuleId").show();
	   $(".hpayment").hide();
	   $(".btnclose").hide();
		  
	   $("#WhichPaymentFor").val(estimateno); 
	   $("#CompanyPaymentFor").val(companyname);
	   $("#ClientPaymentFor").val(clientrefid);
	   $("#ContactPaymentFor").val(contactrefid);
	   
	   getOrderAndDueAmount(estimateno);
	   fillAllSalesPayment(estimateno);	   
	   getPayType(estimateRefKey,estimateno);	   
	   setTotalSalesService(estimateno);
	   var id = $(".invconvt").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });
	   $("#TransactionId").focus();		    
   }	

   function updatePrice(refid,TotalPriceId,PriceId,minprice,cgstpercent,sgstpercent,igstpercent,pricerefid,gstPriceId,
		   SaleProdQtyId,SubTotalPriceId){
		var price=$("#"+PriceId).val();
		var qty=$("#"+SaleProdQtyId).val();
		minprice=Number(minprice)*Number(qty);
		if(Number(price)>=Number(minprice)){
			var cgstprice=(Number(price)*Number(cgstpercent))/100;	
			cgstprice=Math.round(Number(cgstprice));
			var sgstprice=(Number(price)*Number(sgstpercent))/100;	
			sgstprice=Math.round(Number(sgstprice));
			var igstprice=(Number(price)*Number(igstpercent))/100;	
			igstprice=Math.round(Number(igstprice));
			price=Math.round(Number(price));
			showLoader();
		$.ajax({
			type : "POST",
			url : "UpdatePriceOfSalesProduct111",
			dataType : "HTML",
			data : {
				price : price,
				refid : refid,
				cgstprice : cgstprice,
				sgstprice : sgstprice,
				igstprice : igstprice,
				pricerefid : pricerefid
				},
			success : function(data){
				var x=data.split("#");
				if(x[0]=="pass"){
					document.getElementById("errorMsg1").innerHTML="Updated.";
					var taxamount=Math.round(Number(cgstprice)+Number(sgstprice)+Number(igstprice));
					$("#"+gstPriceId).val(taxamount);
					$("#"+TotalPriceId).val(Math.round(Number(price)+(Number(taxamount))));				
					$("#"+SubTotalPriceId).val(x[1]);	
				    $('.alert-show1').show().delay(3000).fadeOut();
				}else{
					document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
					$('.alert-show').show().delay(4000).fadeOut();
				}
				
			},
			complete : function(data){
				hideLoader();
			}
		});
		}else{
			document.getElementById("errorMsg").innerHTML="Not Permission to reduce price, You may only increase price !!";		
			$("#"+PriceId).val(minprice);	
			$('.alert-show').show().delay(3000).fadeOut();		
			setTimeout(function(){
			updatePriceRollback(refid,TotalPriceId,minprice,cgstpercent,sgstpercent,igstpercent,pricerefid,gstPriceId,SubTotalPriceId);
			},3000);	
		}
	}
 
   function updatePriceRollback(refid,TotalPriceId,price,cgstpercent,sgstpercent,igstpercent,pricerefid,gstPriceId,SubTotalPriceId){
		
			var cgstprice=(Number(price)*Number(cgstpercent))/100;	
			cgstprice=Number(cgstprice).toFixed(2);
			var sgstprice=(Number(price)*Number(sgstpercent))/100;	
			sgstprice=Number(sgstprice).toFixed(2);
			var igstprice=(Number(price)*Number(igstpercent))/100;	
			igstprice=Number(igstprice).toFixed(2);
		showLoader();	
		$.ajax({
			type : "POST",
			url : "UpdatePriceOfSalesProduct111",
			dataType : "HTML",
			data : {
				price : price,
				refid : refid,
				cgstprice : cgstprice,
				sgstprice : sgstprice,
				igstprice : igstprice,
				pricerefid : pricerefid
				},
			success : function(data){
				var x=data.split("#");
				if(x[0]=="pass"){					
					document.getElementById("errorMsg1").innerHTML="Payment Rollback successfully.";
					var taxamount=Number(cgstprice)+Number(sgstprice)+Number(igstprice);
					$("#"+gstPriceId).val(taxamount);
					$("#"+TotalPriceId).val(Number(price)+(Number(taxamount)));				
					$("#"+SubTotalPriceId).val(x[1]);	
				$('.alert-show1').show().delay(3000).fadeOut();
				}else{
					document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
					$('.alert-show').show().delay(4000).fadeOut();
				}				
			},
			complete : function(data){
				hideLoader();
			}
		});
		
	}
   
  function fillAllEstimateProduct(){	 
	  var estimateno=$("#ConvertInvoiceSaleNo").val();
	  $.ajax({
			type : "POST",
			url : "GetEstimateProductList111",
			dataType : "HTML",
			data : {				
				estimateno : estimateno,
			},
			success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;			 
			 if(Number(len)>0){	
				 $("#Convert_Product_Name").empty();	 
			 for(var i=0;i<len;i++){ 	
				var esrefid=response[i]["esrefid"];
				var prodname=response[i]["prodname"];	
				var prodrefid=response[i]["prodrefid"];	
				var prodtype=response[i]["prodtype"];
				var jurisdiction=response[i]["jurisdiction"];
				var central=response[i]["central"];
				var state=response[i]["state"];
				var global=response[i]["global"];
// 				console.log("prodname="+prodname);
				if(i==0){
					if(prodname=="Consultation Service"){
						$("#NewProductBtn").hide();
						$("#consultingTypeSales").hide();						
					}else{
						$("#NewProductBtn").show();
						$("#consultingTypeSales").show();
					}
					if(prodrefid!=null&&prodrefid!="NA")	
					appendJurisdiction(global,central,state,"Jurisdiction",jurisdiction);
					
					$("#Convert_Product_Name").append("<option value='"+prodname+"#"+esrefid+"'>"+prodname+"</option>");
					
					setProduct(esrefid,prodrefid);						
				}else{
					addMainNewProduct(esrefid,prodtype,prodrefid,prodname,i,central,state,global,jurisdiction);
				}
			 }
			 
			}}}
		});
  } 

 function openBackEditPage(){
	 var estimateno=$("#ConvertInvoiceSaleNo").val();
	 isInvoiceEditable(estimateno);	
 }
 function isInvoiceEditable(estimateno){
	 $(".EditEstimateButtonRemoveClass").remove();
	 $.ajax({
			type : "POST",
			url : "ShowAllRegPayment111",
			dataType : "HTML",
			data : {				
				estimateno : estimateno
			},
			success : function(response){		
			if(Object.keys(response).length!=0){	
			response = JSON.parse(response);			
			 var len = response.length;	
			 if(Number(len)>0){			   
				 $(".EditEstimateButtonRemoveClass").remove();
				 $("#Full_PayId").prop("disabled",true);
				 $("#Partial_PayId").prop("disabled",true);
				 $("#Milestone_PayId").prop("disabled",true);
				 $("#ManageEstimatePayTypeId").val("No");
				 $("#btnSubmit").attr("onclick","validatePayment(event)");
			 }}else{
				 $(''+
				 '<button type="button" class="editinvconvt EditEstimateButtonRemoveClass" data-related="edit_estimate" onclick="editEstimateBox()" style="margin-right: 1rem;">Edit Estimate</button>'
				 ).insertBefore('#EditEstimateButtonId');
				 $("#Full_PayId").prop("disabled",false);
				 $("#Partial_PayId").prop("disabled",false);
				 $("#Milestone_PayId").prop("disabled",false);
				 $("#ManageEstimatePayTypeId").val("Yes");						
				 $("#btnSubmit").attr("onclick","validatePayType()");
			 }	}			
		});
 }
 function confirmCheck(){
	$("#payTypeWarning").modal("hide"); 
	 $("#btnSubmit").attr("onclick","validatePayment(event)");
	 setTimeout(() => {
		 $("#btnSubmit").click(); 
	}, 100);
	 
 }
function  getOrderAndDueAmount(estimateno){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetOrderAndDueAmount111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){		
		var x=response.split("#"); 
		$("#TotalOrderAmountId").html(Number(x[0]).toFixed(2));
		$("#TotalDueAmountId").html(Number(x[1]).toFixed(2));	
// 		var pff=Number(x[2]).toFixed(2);
// 		var pffgst=Number(x[3]).toFixed(2);
// 		var gov=Number(x[4]).toFixed(2);
// 		var govgst=Number(x[5]).toFixed(2);
// 		var otr=Number(x[6]).toFixed(2);
// 		var otrgst=Number(x[7]).toFixed(2);
		
		var pffcgst=Number(x[2]);
		var pffsgst=Number(x[3]);
		var pffigst=Number(x[4]);
		var pfftax=pffcgst+pffsgst+pffigst;		
		
		$("#ProfessionalCgst").val(pffcgst);
		$("#ProfessionalSgst").val(pffsgst);
		$("#ProfessionalIgst").val(pffigst);
		
		var govcgst=Number(x[5]);
		var govsgst=Number(x[6]);
		var govigst=Number(x[7]);
		var govtax=govcgst+govsgst+govigst;
		
		$("#GovernmentCgst").val(govcgst);
		$("#GovernmentSgst").val(govsgst);
		$("#GovernmentIgst").val(govigst);
		
		var othercgst=Number(x[8]);
		var othersgst=Number(x[9]);
		var otherigst=Number(x[10]);
		var otrtax=othercgst+othersgst+otherigst;
		
		$("#OtherCgst").val(othercgst);
		$("#OtherSgst").val(othersgst);
		$("#OtherIgst").val(otherigst);
		
		var servicecgst=Number(x[11]);
		var servicesgst=Number(x[12]);
		var serviceigst=Number(x[13]);
		var servicetax=servicecgst+servicesgst+serviceigst;
		
		$("#ServiceChargeCgst").val(servicecgst);
		$("#ServiceChargeSgst").val(servicesgst);
		$("#ServiceChargeIgst").val(serviceigst);
		
		$("#ProfessionalFeeTax").val(pfftax);
		$("#GovernmentFeeTax").val(govtax);
		$("#ServiceChargeTax").val(servicetax);
		$("#OtherFeeTax").val(otrtax);
		
		$("#Professional_Fee_GST").html(pfftax+"%");
		$("#Government_Fee_GST").html(govtax+"%");
		$("#service_Charges_GST").html(servicetax+"%");
		$("#Other_Fee_GST").html(otrtax+"%");
		
		if(Number(x[1])<=0){
			//hide add payment option
			$("#AddPaymentModeuleId,.btnpay").hide();
			$(".hpayment").show();
		}else{
			$("#AddPaymentModeuleId").show();
		}
		},
		complete : function(data){
			hideLoader();
		}
	});
}

function getAllSalesProduct(estimateno,estRefKey){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetAllSalesProduct111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){		
		if(Object.keys(response).length!=0){	
		response = JSON.parse(response);			
		 var len = response.length;			 
		 if(Number(len)>0){		
			 $("#EstimateProductName").empty();
		for(var i=0;i<len;i++){		   
			var refKey = response[i]['refKey'];
			var name = response[i]['name'];		
			if(refKey==estRefKey){
				$("#EstimateProductName").append("<option value='"+refKey+"' selected='selected'>"+name+"</option>");
			}else{$("#EstimateProductName").append("<option value='"+refKey+"'>"+name+"</option>");}			
		}}}},
		complete : function(data){
			hideLoader();
		}
	});
}
function emiStatus(types){
	showLoader();
	 $.ajax({
		  method: "GET",
		  url: "/admin/emi-status",
		  data: {types:types}
		}).done(function( data ) {	
			hideLoader();
			$("#homeTable  tbody").empty();	
		    $("#homeTable  tbody").append(data);
	  }).fail(function(data){
		  hideLoader();
	  });
	}
function getPayType(estRefKey,estimateno){
// 	$(".payTypeRemove").remove();
// 	getAllSalesProduct(estimateno,estRefKey);
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetPayType111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){
			$("#paymentTable  tbody").empty();	
		    $("#paymentTable  tbody").append(response);		
		},
		complete : function(data){
			hideLoader();
		}
	});
}
		
function setClientDocuments(){
	var estKey=$("#ConvertEstimateDocRefKey").val();
	$(".documentInnerId").remove();
	showLoader();
	var path="<%=azurePath%>";
	$.ajax({
		type : "GET",
		url : "GetEstimateDocument111",
		dataType : "HTML",
		data : {				
			estKey : estKey,						
		},
		success : function(data){	
		if(Object.keys(data).length!=0){
			data = JSON.parse(data);			
		 var len = data.length;
		 if(Number(len)>0){		 
		 for(var j=0;j<len;j++){ 			
		 	var date=data[j]["date"];
		 	var uploaddocname=data[j]["uploaddocname"];
		 	var docname=data[j]["docname"];
		 	var key=data[j]["key"];
		 	var fileInput="fileInputDoc"+(j+1);
		 	var download="";
		 	if(docname!="NA"&&docname!="")
		 		download='<a href="'+path+''+docname+'" download><i class="fas fa-download pointers" title="Download"></i></a>';
			
		 	$(''+
					  '<tr class="documentInnerId">'+
						 '<td>'+date+'</td>'+
						 '<td>'+uploaddocname+'</td>'+
						'<td>'+download+'<input id="'+fileInput+'" name="'+fileInput+'" type="file" onchange="uploadFile(\''+key+'\',\''+fileInput+'\')" style="display:none;" />'+
					       '<button onclick="openFileInput(\''+fileInput+'\');" style="border: none;background: #ffff;font-size: 14px;"><i class="fas fa-upload" title="Upload"></i></button>'+
					     '</td>'+
					  '</tr>'			 
					 ).insertBefore("#DocumentListAppendId");
	 		 
		 }
		 }}
	},
	complete : function(data){
		fillDocumentUploadHistory(estKey);
		hideLoader();
	}});
	
}

function setGeneratedEstimate(){
	var estKey=$("#ConvertEstimateRefKey").val();
	var path="<%=request.getContextPath()%>";
	$(".EstimatePaymentInnerId").remove();
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetGeneratedEstimate111",
		dataType : "HTML",
		data : {				
			estKey : estKey,						
		},
		success : function(data){	
		if(Object.keys(data).length!=0){
			data = JSON.parse(data);			
		 var len = data.length;
		 if(Number(len)>0){		 
		 for(var j=0;j<len;j++){ 			
		 	var date=data[j]["date"];
		 	var uuid=data[j]["uuid"];
		 	var amount=data[j]["amount"];
		 	var invoice=data[j]["invoice"];
			
		 	$(''+
					  '<tr class="EstimatePaymentInnerId">'+
						 '<td>'+date+'</td>'+
						 '<td>'+invoice+'</td>'+
						 '<td>'+amount+'</td>'+
						'<td><a href="'+path+'/estimatereceipt-'+uuid+'.html" target="_blank"><i class="fa fa-file-text-o pointers" title="Invoice"></i></a></td>'+
					  '</tr>'			 
					 ).insertBefore("#GeneratedEstimate");
	 		 
		 }
		 }}
	},
	complete : function(data){
		hideLoader();
	}});
}

function fillAllSalesPayment(estimateno){
	//getting all sales payment details
	$.ajax({
		type : "POST",
		url : "ShowAllRegPayment111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){		
		if(Object.keys(response).length!=0){	
		response = JSON.parse(response);			
		 var len = response.length;	
		 if(Number(len)>0){
		var path="<%=domain%>";		
		for(var i=0;i<len;i++){		
			var srefid = response[i]['srefid'];
			var date = response[i]['date'];
			var saleno = response[i]['saleno'];
			var mode = response[i]['mode'];
			var transactionid = response[i]['transactionid'];
			var amount = response[i]['amount'];
			var status = response[i]['status'];
			var docname = response[i]['docname'];		
			var comment = response[i]['comment'];	
			var holdcomment = response[i]['holdcomment'];		
			var pymtstatusicon="fa fa-circle-o-notch";
			var pymttitle="Processing..";
			var pymtcolor="#42b0da;";
			if(status=="1"){
				comment="";
				pymtstatusicon="fa fa-check-circle-o";
				pymttitle="Approved";
				pymtcolor="#29ba29;";
			}else if(status=="3"){
				pymtstatusicon="fa fa-times-circle-o";
				pymttitle="Declined Reason : "+comment;
				pymtcolor="#d91f16;";
			}else if(status=="4"){
				pymtstatusicon="fa fa-stop-circle";
				pymttitle="Hold Reason : "+holdcomment;
				pymtcolor="#808080;";
			}
			var color="text-primary";
			if(docname==null||docname=="NA")color="text-danger";			
		 $(''+
				  '<tr class="EstimatePaymentInnerId">'+
					 '<td><i class="'+pymtstatusicon+'" style="color:'+pymtcolor+'" title="'+pymttitle+'"></i></td>'+
					 '<td>'+date+'</td>'+
					 '<td>'+saleno+'</td>'+
					 '<td>'+mode+'</td>'+
					 '<td>'+transactionid+'</td>'+
					 '<td>'+amount+'</td>'+
					 '<td><i class="far fa-file-alt '+color+' pointers" onclick="openReceipt(\''+path+'\',\''+docname+'\')"></i></td>'+
					 '<td><i class="fa fa-envelope-o pointers" title="Send Invoice" onclick="sendSlip(\''+path+'\',\''+srefid+'\',\''+saleno+'\',\''+amount+'\',\''+date+'\')"></i></td>'+
				  '</tr>'			 
				 ).insertBefore("#EstimatePaymentListId");
		}}}else{
			$(''+
					'<tr class="EstimatePaymentInnerId"><td class="text-center noDataFound text-danger">No Data Found</td></tr>'
		    ).insertBefore('#EstimatePaymentListId');
			}
		}
	});
}
function showTimelineBox(TimelineBoxId){
	if($('#'+TimelineBoxId).css('display') == 'none')
	{
		$("#"+TimelineBoxId).css('display','block');
	}	
}

function addInput(MainTimelineUnitId,TimelineBoxId,MainTimelineValueId,CurrentProdrefid,val,colname){
	$('#'+MainTimelineUnitId).val(val);
	$("#"+TimelineBoxId).hide();
	$("#"+MainTimelineValueId).prop('readonly',false);	
	$("#"+MainTimelineValueId).focus();
	updatePlan(CurrentProdrefid,val,colname);
}

function openReceipt(mainfolder,docname){
	if(docname.toLowerCase()=="na"){
		$("#warningDocument").modal("show");
	}else{
		window.open("<%=azurePath%>"+docname);
		}
}

function sendSlip(path,key,salesno,amount,date){
	showLoader(); 
	$.ajax({
			type : "POST",
			url : "IsSalesInvoiced111",
			dataType : "HTML",
			data : {				
				salesno : salesno
			},
			success : function(response){
				if(response=="pass"){
					var url=path+"slip-"+key+".html";
					openSendEmailBoxSlip(url,amount,date);
				}else{
					$("#warningPayment").modal("show");
				}
			},
			complete : function(data){
				hideLoader();
			}
	 });
}

function setProduct(pricerefid,prodrefid){
	fillTimePlan(pricerefid,"SaleProdQty","renewal","onetime","MainTimelineValue","MainTimelineUnit","ProductPeriod");		
	
	let priceStyle="";
	if(typeof prodrefid === "undefined"){
		priceStyle="style='display:none'"
	}
	$.ajax({
			type : "POST",
			url : "SetProductPriceList111",
			dataType : "HTML",
			data : {				
				pricerefid : pricerefid
			},
			success : function(response){
			if(Object.keys(response).length!=0){				
			$("#CurrentProdrefid").val(pricerefid);
			response = JSON.parse(response);
			 var len = response.length;		
				 $("#EstimateProductPrice").show();
				 $(".Estpricelist").remove();
				 $(".Estpricelist1").remove();
			 var subamount=0;			 
			for(var i=0;i<len;i++){
				var refid = response[i]['refid'];
				var pricetype = response[i]['pricetype'];
				var price = response[i]['price'];
				var minprice = response[i]['minprice'];
				var hsncode = response[i]['hsncode'];
				var cgstpercent = response[i]['cgstpercent'];
				var sgstpercent = response[i]['sgstpercent'];
				var igstpercent = response[i]['igstpercent'];
				var taxprice = response[i]['tax'];
				var totalprice = response[i]['totalprice'];
				var gstpercent=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);
				var sn=$("#SalesProductIdQty").val();
				sn=Number(sn)+Number(1);
				var TaxId="TaxUId"+sn;
				var PriceId="PriceUId"+sn;
				var TotalPrice="TotalPriceUId"+sn;
				var gstPriceId="GstPriceUId"+sn;
				$("#SalesProductIdQty").val(sn);
				subamount=Number(subamount)+Number(totalprice);
				$(''+
				'<div class="clearfix bg_wht link-style12 Estpricelist" id="ConvertedPriceListId">'+
             '<div class="box-width25 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border">'+(i+1)+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width19 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border" title='+pricetype+'>'+pricetype+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+																																																																																																	                                          
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" style="height: 38px;margin-left: 2px;" value="'+price+'" id="'+PriceId+'" onchange="updatePrice(\''+refid+'\',\''+TotalPrice+'\',\''+PriceId+'\',\''+minprice+'\',\''+cgstpercent+'\',\''+sgstpercent+'\',\''+igstpercent+'\',\''+pricerefid+'\',\''+gstPriceId+'\',\'SaleProdQty\',\'SubTotalPriceId\')" onkeypress="return isNumberKey(event)"/></p>'+
                  '</div>'+
              '</div>'+    
              '<div class="box-width3 col-xs-1 box-intro-background">'+
              '<input type="text" name="'+TaxId+'" id="'+TaxId+'" value="'+gstpercent+' %'+'" class="form-control bdrnone" autocomplete="off" placeholder="Tax %" readonly="readonly">'+
				      '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><input type="text" class="form-control BrdNone" id="'+gstPriceId+'" style="height: 38px;margin-left: 2px;" value="'+taxprice+'" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+TotalPrice+'" value="'+totalprice+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+ 
           '</div>').insertBefore('#PriceDropBox');				
			}
			$(''+
			'<div class="clearfix Estpricelist1">'+
         '<div class="box-width59 col-xs-6 box-intro-background">'+
             '<div class="clearfix" '+priceStyle+'><a href="javascript:void(0)" onclick="addNewPriceType(\'CurrentProdrefid\')"><u>+ Add Price</u></a></div>'+
         '</div>'+
			 '<div class="box-width26 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border justify_end">Total:</p>'+
             '</div>'+
         '</div>'+
         '<div class="box-width14 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="SubTotalPriceId" value="'+subamount.toFixed(2)+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
             '</div>'+
         '</div>'+ 
      '</div>').insertBefore('#PriceDropBoxSubAmount');			 	
			 }else{
				 document.getElementById('errorMsg').innerHTML ='Price not Listed , Please set price.';					
		 		    $('.alert-show').show().delay(4000).fadeOut();
			 }
			}
		});
}

function fillTimePlan(pricerefid,SaleProdQtyId,renewalid,onetimeid,MainTimelineValueId,MainTimelineUnitId,ProductPeriodId){	 
	$.ajax({
			type : "POST",
			url : "SetProductTimePlan111",
			dataType : "HTML",
			data : {				
				pricerefid : pricerefid
			},
			success : function(response){
				if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;			 
			 if(Number(len)>0){	
			 for(var i=0;i<len;i++){ 	
				var qty=response[i]["qty"];
				var plan=response[i]["plan"];
				var period=response[i]["period"];
				var time=response[i]["time"];
				if(period.toLowerCase()=="na")period="";
				if(time.toLowerCase()=="na")time="";
				$("#"+SaleProdQtyId).val(qty);
				if(plan=="OneTime"){$("#"+renewalid).prop('checked',false);$("#"+onetimeid).prop('checked',true);
				$("#"+MainTimelineValueId).val("");$("#"+MainTimelineUnitId).val("");
				}else if(plan=="Renewal"){
					$("#"+onetimeid).prop('checked',false);$("#"+renewalid).prop('checked',true);
					$("#"+MainTimelineValueId).val(time);$("#"+MainTimelineUnitId).val(period);$("#"+ProductPeriodId).show();
				}			
			 }
			}}}
		});
} 

/* $('.view_more').click(function(){
	$(this).addClass("active");
    $("#View_More_History1").slideToggle();
});*/

function openInvoiceSummary(salesNo,pageNo){
	$(".removeMainSummary").remove();
	  $.ajax({
			type : "POST",
			url : "GetEstimateSummary111",
			dataType : "HTML",
			data : {				
				salesNo : salesNo,
				pageNo : pageNo
			},
			success : function(response){
				if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;	
			 
			 if(Number(len)>0){					 
			 for(var i=0;i<len;i++){ 	
				var date=response[i]["date"];
				var remarks=response[i]["remarks"];
				var margin="style='margin-bottom: 10px;'";
				if(len==1){margin="";}
				$(''+
					'<div class="clearfix removeMainSummary" '+margin+'>'+
					'<span style="color: #aaa;">'+date+'</span><span style="margin-left: 65px;color: #aaa;">'+remarks+'</span>'+
					'</div>').insertBefore("#AppendMainEstimateSumary");
								
			 }
			}if(len!=3){
				$("#MoreViewButton").hide();
			}
			 
			}}
		});
}

function showEstimateSummary(){
	showLoader();
	var salesNo=$("#ConvertInvoiceSaleNo").val();
	
	var summaryId=$("#View_More_History").val();
	var pageNo=Number(summaryId)*3;
	
	 $.ajax({
			type : "POST",
			url : "GetEstimateSummary111",
			dataType : "HTML",
			data : {				
				salesNo : salesNo,
				pageNo : pageNo
			},
			success : function(response){	
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;	
			 
			 if(Number(len)>0){	
				 $('<div class="clearfix" id="View_More_History'+summaryId+'" style="display: none;"><div class="clearfix" id="AppendEstimateSumary'+summaryId+'"></div></div>').insertBefore("#AppendEstimateSumaryDynamic");
			 for(var i=0;i<len;i++){ 	
				var date=response[i]["date"];
				var remarks=response[i]["remarks"];
				
				$(''+
					'<div class="clearfix" style="margin-bottom: 12px;">'+
					'<span style="color: #aaa;">'+date+'</span><span style="margin-left: 65px;color: #aaa;">'+remarks+'</span>'+
					'</div>').insertBefore("#AppendEstimateSumary"+summaryId);
				
				
			 }			 
			 
			 $("#View_More_History").val(Number(summaryId)+1);
				$("#View_More_History"+summaryId).slideDown();
				if($("#MinimizeViewButton").is(":hidden")){
				$("#MinimizeViewButton").show();}
							 
			}if(len!=3){
				$("#MoreViewButton").hide();
				$("#MinimizeViewButton").css('margin-left','0px');
			}
			}else{
				$("#MoreViewButton").hide();			
				$("#MinimizeViewButton").css('margin-left','0px');			
			}
			},
			complete : function(msg) {
	            hideLoader();
	        }
		});	
	
	
}
function hideEstimateSummary(){
	showLoader();
	var summaryId=$("#View_More_History").val();
	summaryId=Number(summaryId)-1;
	$("#View_More_History"+summaryId).slideUp();
	setTimeout(function() { 
		$("#View_More_History"+summaryId).remove();
    }, 500); 
	$("#View_More_History").val(Number(summaryId));
	
	if(summaryId==1){
		$("#MinimizeViewButton").hide();
	}
	$("#MinimizeViewButton").css('margin-left','64px');
	$("#MoreViewButton").show();
	hideLoader();
}

$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 

$('.close_icon_btn').click(function(){
	$('.notify_box').hide();
});
$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"dateRangeDoAction");
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

$( document ).ready(function() {
   var dateRangeDoAction="<%=dateRangeDoAction%>";
   if(dateRangeDoAction!="NA"){	  
	   $('input[name="date_range"]').val(dateRangeDoAction);
   }
});

function copyInvoiceLink(){
	showLoader();
	var estimateKey=$("#ConvertEstimateRefKey").val();

	var url = $(location).attr('href');
	var name="<%=domain%>";
	var index=url.indexOf(name);
	var domain=url.substring(0,Number(index));
	var urlText=$("#InvoiceUrl").val();
	var input=domain+name+"invoice-"+estimateKey+".html";
	$("#InvoiceUrl").val(input);
	  var copyText = document.getElementById("InvoiceUrl");
	  copyText.select();
	  copyText.setSelectionRange(0, 99999)
	  document.execCommand("copy");
	  $("#CopyLinkUrl").addClass('textCopied');
	  hideLoader();
}
function sendEstimateInvoice(){	
	var date="<%=today%>";
	var emailTo=$("#EmailTo").val();
	var emailCC=$("#EmailCC").val();
	var emailSubject=$("#EmailSubject").val();
	var emailBody=CKEDITOR.instances.EmailBody.getData();
	
	
	if(emailTo==null||emailTo==""){
		 document.getElementById('errorMsg').innerHTML ='Send email to is required..';					
		 $('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
	if(emailSubject==null||emailSubject==""){
		 document.getElementById('errorMsg').innerHTML ='Email Subject is required..';					
		 $('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
	if(emailBody==null||emailBody==""){
		 document.getElementById('errorMsg').innerHTML ='Email Body is required..';					
		 $('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
	if(emailCC==null||emailCC==""){
		$("#EmailCC").val("NA");
	}
	var salesNo=$("#ConvertInvoiceSaleNo").val();
	var CC=emailCC;
	
	if(CC==null)CC="empty";
	CC+="";
	showLoader();
	$.ajax({
		type : "POST",
		url : "SendEstimateInvoice111",
		dataType : "HTML",
		data : {				
			emailTo : emailTo,
			CC : CC,
			emailSubject : emailSubject,
			emailBody : emailBody,
			salesNo : salesNo
		},
		success : function(response){		
			if(response=="pass"){
				document.getElementById('errorMsg1').innerHTML ='Invoice sent !!';					
				$('.alert-show1').show().delay(4000).fadeOut();
				
				$("#SendEmailWarning").modal("hide");
				$("#EmailSendedId").addClass('textCopied');
				$(''+
					'<div class="clearfix removeMainSummary">'+
					'<span style="color: #aaa;">'+date+'</span><span style="margin-left: 65px;color: #5757ea;">Invoive sended</span>'+
					'</div>').insertBefore("#AppendMainEstimateSumary");
			}else{
				document.getElementById('errorMsg').innerHTML ='Something went wrong, Please try again later !!';					
	 		    $('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});	
}
$(document).ready(function(){
	CKEDITOR.replace('EmailBody',{
	     height: 200
	});
	CKEDITOR.replace('ChatTextareaBoxReply',{
		   height:150
	   });
	CKEDITOR.replace('ChatTextareaBoxReply1',{
		   height:150
	   });
	$('#userInChat').select2({
		  placeholder: 'Select user to send notes..',
		  allowClear: true
	});
	
	$("#notesestimate").change(function(){
		$("#userInChat").empty();
		var estkey=$(this).val();
		if(estkey!=null&&estkey!="")
		$.ajax({
			type : "GET",
			url : "GetEstimateWorkingUser111",
			dataType : "HTML",
			data : {				
				estkey : estkey
			},
			success : function(response){
				$("#userInChat").append(response);	
			},
			complete : function(msg) {
	            hideLoader();
	            fillSalesTaskKey(estkey);
	        }
		});
	})
});
function fillSalesTaskKey(estkey){
	$(".contentInnerBox").remove();
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetSalesTaskNotes111",
		dataType : "HTML",
		data : {
			salesKey : "NA",
			estkey : estkey
		},
		success : function(response){	
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;	
		 
		 if(len>0){
			 for(var i=0;i<Number(len);i++){	
				 var type=response[i]["type"];
				 var addedby=response[i]["addedby"];
			 	 var time=response[i]["time"];
				 var description=response[i]["description"];
				
				 var content='<div class="contentInnerBox box_shadow1 relative_box mb10 mtop10">'
						+'<div class="sms_head note_box">'
						+'<div class="note_box_inner">'
						+''+description+''
						+'</div>'
						+'<span class="icon_box1 text-center" title="'+addedby+'">'+addedby.substring(0,2)+'</span>'
						+'</div>'	
						+'<div class="sms_title">' 
						+'<label class="pad-rt10"><img src="/corpseedhrm/staticresources/images/long_arrow_down.png" alt="">&nbsp; Notes Written</label>'  
						+'<span class="gray_txt bdr_bt pad-rt10">'+time+'</span>'
						+'</div>'
						+'</div>';				 
				 if(type=="Team"){
				 $(".communication_history").append(content);
				 }else{
					 $(".cmhistscrollInternal").append(content);
				 }
			}
			  $(".cmhistscroll").scrollTop($(".cmhistscroll")[0].scrollHeight);
		 }
		}},
		complete : function(data){
			hideLoader();
		}
	});
}
function openSendEmailBoxSlip(url,amount,date){
	loadMultipleEmail();
	var clientEmail=$("#SendEmailClientEmail").val();
	$("#EmailTo").val(clientEmail);
	$("#EmailSubject").val("Payment Invoice");
	var clientName=$("#SendEmailClientName").val();
	var saleNo=$("#ConvertInvoiceSaleNo").val();
	var estimateKey=$("#ConvertEstimateRefKey").val();
	var domainName="<%=domain%>";
	$("#sendEmailInvoiceHtml").html("Send Payment Invoice");
	
// 	var message="<p>Dear "+clientName+"</p><p>Download invoice of Estimate No.:"+saleNo+" by clicking <a href='"+url+"' target='_blank'>link</a></p><p>Thanks & Regard</p><p>Sales Team</p>";
	
	var message='<table border="0" style="margin:0 auto;min-width:700px;width:700px;font-size:15px;line-height: 20px;border-spacing: 0;font-family: sans-serif;">'
	+'<tr><td style="text-align: left ;background-color: #fff; padding: 15px 0; width: 50px">'
		+'<a href="#" target="_blank"><img src="https://www.corpseed.com/assets/img/logo.png"></a>'
		+'</td></tr>'
		+'<tr>'
		+'<td style="text-align: center;">'
		+'<h1>'+saleNo+'</h1>'
		+'<tr>'
		+'<td style="padding:70px 0 20px;color: #353637;">'
		+'Hi '+clientName+',</td></tr>'
		+'<tr>'
		+'<td style="padding: 10px 0;color: #353637;">' 
		+'<p>Thank you for contacting us. Your Estimate can be Viewed, Printed and Downloaded as PDF from the link below.' 
		+'</p>'
		+'</td></tr><tr>'
		+'<td style="padding: 15px 50px 30px;border: 15px solid #e5e5e5;text-align: center;">' 
		+'<h2 style="text-align: center;">Payment Updates</h2>'
		+'<p style="text-align:center">Rs. '+amount+'' 
		+'</p>'
		+'<p style="text-align:center">Estimate No. : '+saleNo+'' 
		+'</p>'
		+'<p style="text-align:center">Estimate Date : '+date+'' 
		+'</p>'
		+'<p style="margin-top:20px;"><a href="'+url+'" target="_blank" style="background-color: #2b63f9 ;text-decoration: none;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px">View Invoice</a>'
		+'</td></tr>'
		+'<tr ><td style="text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;">'
		+'<b>Order no #547659906099</b><br>'
		+'<p>Address : Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>'
		+'</td></tr>' 
		+'</table>';
	
	CKEDITOR.instances.EmailBody.setData(message);
	$("#SendEmailWarning").modal("show");
}
function openSendEmailBox(date,amount){
	loadMultipleEmail();
	var clientEmail=$("#SendEmailClientEmail").val();
	$("#EmailTo").val(clientEmail);
	$("#EmailSubject").val("Estimate Invoice");
	var clientName=$("#SendEmailClientName").val();
	var saleNo=$("#ConvertInvoiceSaleNo").val();
	var estimateKey=$("#ConvertEstimateRefKey").val();
	var domainName="<%=domain%>";
	var url=domainName+"invoice-"+estimateKey+".html";
	$("#sendEmailInvoiceHtml").html("Send Estimate Invoice");
// 	var message="<p>Dear "+clientName+"</p><p>Download invoice of Estimate No.:"+saleNo+" by clicking <a href='"+url+"' target='_blank'>link</a></p><p>Thanks & Regard</p><p>Sales Team</p>";
	var message='<table border="0" style="margin:0 auto;min-width:700px;width:700px;font-size:15px;line-height: 20px;border-spacing: 0;font-family: sans-serif;">'
	+'<tr><td style="text-align: left ;background-color: #fff; padding: 15px 0; width: 50px">'
		+'<a href="#" target="_blank"><img src="https://www.corpseed.com/assets/img/logo.png"></a>'
		+'</td></tr>'
		+'<tr>'
		+'<td style="text-align: center;">'
		+'<h1>'+saleNo+'</h1>'
		+'<tr>'
		+'<td style="padding:70px 0 20px;color: #353637;">'
		+'Hi '+clientName+',</td></tr>'
		+'<tr>'
		+'<td style="padding: 10px 0;color: #353637;">' 
		+'<p>Thank you for contacting us. Your Estimate can be Viewed, Printed and Downloaded as PDF from the link below.' 
		+'</p>'
		+'</td></tr><tr>'
		+'<td style="padding: 15px 50px 30px;border: 15px solid #e5e5e5;text-align: center;">' 
		+'<h2 style="text-align: center;">Estimate Amount</h2>'
		+'<p style="text-align:center">Rs. '+amount+'' 
		+'</p>'
		+'<p style="text-align:center">Estimate No. : '+saleNo+'' 
		+'</p>'
		+'<p style="text-align:center">Estimate Date : '+date+'' 
		+'</p>'
		+'<p style="margin-top:20px;"><a href="'+url+'" target="_blank" style="background-color: #2b63f9 ;text-decoration: none;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px">View Invoice</a>'
		+'</td></tr>'
		+'<tr ><td style="text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;">'
		+'<b>Order no #547659906099</b><br>'
		+'<p>Address : Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>'
		+'</td></tr>' 
		+'</table>';
	CKEDITOR.instances.EmailBody.setData(message);
	$("#SendEmailWarning").modal("show");
}


function loadMultipleEmail(){	
	var contactKey=$("#ConvertInvoiceContactrefid").val();
	$("#EmailCC").empty();		
	
	var value=[];	

	$.ajax({
		type : "POST",
		url : "GetSalesContactDetails111",
		dataType : "HTML",
		data : {				
			contactKey : contactKey
		},
		success : function(response){
		if(Object.keys(response).length!=0){	
			response = JSON.parse(response);			
			 var len = response.length;			 
			 if(Number(len)>0){	
			for(var i=0;i<len;i++){		   
				var email = response[i]['email'];	
				$("#EmailCC").append('<option value="'+email+'">'+email+'</option>');
				value.push(email);
			}
			$('#EmailCC').val(value); 
			$('#EmailCC').trigger('change'); 			
			 }}			
		},
		complete : function(msg) {
            hideLoader();
        }
	});	
	
	
}
  $(document).ready(function($){
	  $('#EmailCC').select2({
		  placeholder: 'Enter email and press enter',
		  tags: true
// 		  allowClear: true
		});
	  $('#Update_Super_User').select2({
	        placeholder: 'Select Super User',
	        allowClear: true
	    });
 });
 

 
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
		document.getElementById('errorMsg').innerHTML ="Choose formate option !!";					
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
	var baseName="<%=azurePath%>";
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
			type : "estimate"
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
		complete : function(msg) {
            hideLoader();
        }
	});	
	
}
function downloadInvoices(){
	showLoader();
	var estimateKey=[];
	$(".checked:checked").each(function(){
		estimateKey.push($(this).val());
	});
	estimateKey+="";
	$.ajax({
		type : "POST",
		url : "<%=request.getContextPath()%>/download-estimate-invoices.html",
		dataType : "HTML",
		data : {estimateKey:estimateKey},
		success : function(response){
			if(response=="pass"){
				$("#DownloadExportedInvoices").click();
			}else{
				document.getElementById('errorMsg').innerHTML ='Something went wrong, Please try-again later !!';					
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
$(".btnpay").click(function(){
	 $(".btnpay").hide();
	  $("#AddPaymentModeuleId").hide();
	  $(".hpayment").show();
	  $(".btnclose").show();
	});
$(".btnclose").click(function(){
	 $(".btnclose").hide();
	  $(".hpayment").hide();
	  $("#AddPaymentModeuleId").show();
	  $(".btnpay").show();
	});
$("#GSTApplyId").click(function(){
	if($(this).prop('checked') == true){		
		$("#Professional_Fee_GST").html($("#ProfessionalFeeTax").val()+"%");
		$("#Government_Fee_GST").html($("#GovernmentFeeTax").val()+"%");
		$("#Other_Fee_GST").html($("#OtherFeeTax").val()+"%");
		$("#GSTApplied").val("1");
	}else{
		$("#Professional_Fee_GST").html("0%");
		$("#Government_Fee_GST").html("0%");
		$("#Other_Fee_GST").html("0%");
		$("#GSTApplied").val("0");
	}
	calculateTotalPayment('Professional_Fee','Government_Fee','Other_Fee','GSTApplyId','TotalPaymentId','service_Charges');
});	
$("#GSTApplyId1").click(function(){
	if($(this).prop('checked') == true){		
		$("#Professional_Fee_GST1").html($("#ProfessionalFeeTax").val()+"%");
		$("#Government_Fee_GST1").html($("#GovernmentFeeTax").val()+"%");
		$("#Other_Fee_GST1").html($("#OtherFeeTax").val()+"%");
		$("#GSTApplied").val("1");
	}else{
		$("#Professional_Fee_GST1").html("0%");
		$("#Government_Fee_GST1").html("0%");
		$("#Other_Fee_GST1").html("0%");
		$("#GSTApplied").val("0");
	}
	calculateTotalPayment('Professional_Fee1','Government_Fee1','Other_Fee1','GSTApplyId1','TotalPaymentId1','service_Charges1');
});
function calculateTotalPayment(Professional_Fee,Government_Fee,Other_Fee,GSTApplyId,TotalPaymentId,serviceChargeId){
	var pff=$("#"+Professional_Fee).val();
	var gov=$("#"+Government_Fee).val();
	var service=$("#"+serviceChargeId).val();
	var other=$("#"+Other_Fee).val();
		
	if($("#"+GSTApplyId).prop('checked') == true){
		var pfftax=$("#ProfessionalFeeTax").val();
		var govtax=$("#GovernmentFeeTax").val();
		var servicetax=$("#ServiceChargeTax").val();
// 		console.log("servicetax="+servicetax);
		var othertax=$("#OtherFeeTax").val();
		
		pff=Number(pff)+((Number(pff)*Number(pfftax))/100);
		gov=Number(gov)+((Number(gov)*Number(govtax))/100);
		service=Number(service)+((Number(service)*Number(servicetax))/100);
		other=Number(other)+((Number(other)*Number(othertax))/100);		
	}
	
	var totalAmount=Number(pff)+Number(gov)+Number(other)+Number(service);
	
	$("#"+TotalPaymentId).val(Math.round(Number(totalAmount)));
}
function showRemark(otherFee,Other_Fee_remark_Div){	
	if(otherFee!=null&&otherFee!=""&&Number(otherFee)>0){
		$("#"+Other_Fee_remark_Div).show();
	}else $("#"+Other_Fee_remark_Div).hide();
}
$("#selectProduct,#Service_Name").select2({
	placeholder:"Select Product"
});
function updateState(data,stateId){
	var x=data.split("#");
	var id=x[0];
	$.ajax({
		type : "POST",
		url : "GetStateCity111",
		dataType : "HTML",
		data : {				
			id : id,
			fetch : "state"
		},
		success : function(response){	
			$("#"+stateId).empty();
			$("#"+stateId).append(response);	
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function updateCity(data,cityId){
	var x=data.split("#");
	var id=x[0];
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetStateCity111",
		dataType : "HTML",
		data : {				
			id : id,
			fetch : "city"
		},
		success : function(response){	
			$("#"+cityId).empty();
			$("#"+cityId).append(response);	
		},
		complete : function(data){
			hideLoader();
		}
	});
}
$(function() {
	$("#ContactName").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('ContactName').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "estimatecontactname"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,	
							key :	item.key,
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
            	
            }
            else{
            	doAction(ui.item.value,'estimateContactAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function appendJurisdiction(global,central,state,jurisdiction,jurisdictionData){
	 $("#"+jurisdiction).empty();
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
				$("#"+jurisdiction).val(jurisdictionData);
			}
		});		 
}
function appendNewProductJurisdiction(prodrefid,jurisdictionId){
	$("#"+jurisdictionId).empty();
	showLoader();
	 $.ajax({
			type : "GET",
			url : "GetJurisdiction111",
			dataType : "HTML",
			data : {
				prodrefid : prodrefid,
				global : "NA",
				central : "NA",
				state : "NA"
			},
			success : function(data){	
				$("#"+jurisdictionId).append(data);
			},
			complete : function(data){
				hideLoader();
			}
		});		
}
function openFileInput(InputId){
	$("#"+InputId).click();
}
function uploadFile(docrefid,fileboxid){
	const fi=document.getElementById(fileboxid);
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        
        // The size of the file. 
        if (file >= 49152) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, Max File Size 48 MB !!';
            document.getElementById(fileboxid).value="";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }else{
        	uploadFile1(docrefid,fileboxid);
        }	
	}	 
}
function uploadFile1(docrefid,fileboxid){
	var path=$("#"+fileboxid).val();
	var x=path.split(".");
	var len=x.length;	
	var i=Number(len)-1;

	var form = $(".upload-box")[0];
    var data = new FormData(form);
    data.append("docrefid",docrefid);
    data.append("docfileInputBoxId",fileboxid);
    showLoader();
	$.ajax({
        type : "POST",
        encType : "multipart/form-data",
        url : "<%=request.getContextPath()%>/UploadSalesDocumentList111",
        cache : false,
        processData : false,
        contentType : false,
        data : data,
        success : function(msg) {
        	if(msg=="success"){
        	document.getElementById('errorMsg1').innerHTML ="Uploaded"; 
        	setClientDocuments();
    		$('.alert-show1').show().delay(3000).fadeOut();
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
function openDocument(evt, cityName) {
	  var i, tabcontent, tablinks;
	  tabcontent = document.getElementsByClassName("tabcontent");
	  for (i = 0; i < tabcontent.length; i++) {
	    tabcontent[i].style.display = "none";
	  }
	  tablinks = document.getElementsByClassName("tablinks");
	  for (i = 0; i < tablinks.length; i++) {
	    tablinks[i].className = tablinks[i].className.replace(" active", "");
	  }
	  document.getElementById(cityName).style.display = "block";
	  evt.currentTarget.className += " active";
}
function uploadNewDocument(){	
	$('#AddNewDocumentListForm').trigger('reset')
	$("#AddNewDocumentList").modal("show");
}
function validateDocumentList()	{  
	var docname=$("#NewDocumentName").val().trim();
	var UploadBy=$("#DocumentUploadBy").val().trim();
	var Remarks=$("#DocumentUploadRemarks").val().trim();

	if(docname==null||docname==""){
		document.getElementById('errorMsg').innerHTML ="Please enter document name !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(UploadBy==null||UploadBy==""){
		document.getElementById('errorMsg').innerHTML ="Please select document upload by !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(Remarks==null||Remarks==""){
		document.getElementById('errorMsg').innerHTML ="Please write about this document !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	var estKey=$("#ConvertEstimateDocRefKey").val();
	var key=getKey(40);
	showLoader();
	$.ajax({
		type : "POST",
		url : "AddNewDocumentList111",
		dataType : "HTML",
		data : {				
			key : key,
			salesrefid : "NA",
			docname : docname,
			UploadBy : UploadBy,
			Remarks : Remarks,
			estKey : estKey
		},
		success : function(data){
			if(data=="pass"){
				$("#AddNewDocumentList").modal("hide");
				setClientDocuments();
				
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function fillDocumentUploadHistory(estkey){
	$(".docHistory").remove();
	$.ajax({
		type : "POST",
		url : "GetDocumenHistoryByKey111",
		dataType : "HTML",
		data : {				
			salesrefid : "NA",
			estkey : estkey
		},
		success : function(response){	
			if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		
		 var role="<%=userRole%>";
		 if(len>0){ 	
			 for(var i=0;i<Number(len);i++){
				 var id=response[i]["id"];
				var date=response[i]["date"];
				var name=response[i]["name"];
				var type=response[i]["type"];
				var actionby=response[i]["actionby"];
				var exist=response[i]["exist"];
				var docName=response[i]["docName"];
				var remarks=name;
				if(type=="Upload")remarks+=" uploaded by "+actionby;
				else if(type=="Create")remarks+=" created by "+actionby;
				
				var action='<a href="#" data-toggle="modal" data-target="#PermissionNot"><i class="fas fa-arrow-down text-muted"></i></a>'+
				'<a href="#" data-toggle="modal" data-target="#PermissionNot"><i class="fas fa-trash text-muted"></i></a>';
				
				var docLink="<%=azurePath%>"+docName;
				
				if(Number(exist)==1 && role=="Admin"){
					action='<a id="Download'+id+'" href="'+docLink+'" download><i class="fas fa-arrow-down"></i></a>'+
					'<a href="#" id="Delete'+id+'" onclick="deleteDocument(\''+id+'\',\''+docName+'\')"><i class="fas fa-trash text-danger"></i></a>';
				}
				
				$(''+
					'<div class="clearfix bg_wht link-style12 docHistory">'+
					   '<div class="col-xs-2 box-intro-background">'+
					       '<div class="clearfix">'+
					       '<p class="news-border" id="'+date+'">'+date+'</p>'+
					       '</div>'+
					   '</div>'+
					   '<div class="col-xs-9 box-intro-background">'+
					       '<div class="clearfix">'+
					       '<p class="news-border" title="'+remarks+'">'+remarks+'</p>'+
					       '</div>'+
					   '</div>'+					   
					   '<div class="col-xs-1 box-intro-background">'+
					      '<div class="clearfix">'+
					       '<p class="news-border">'+action+'</p>'+
					       '</div>'+
					   '</div>'+                                         
					'</div>').insertBefore("#DocumentHistoryAppendId");				
			}
		 }
		}else{
			$('<div class="text-center text-danger noDataFound docHistory"> No. Data Found</div>').insertBefore("#DocumentHistoryAppendId");
		}}
	});
}
function deleteDocument(docId,docName){
	if(docId!="NA"){
		$("#SalesDocumentId").val(docId);
		$("#SalesDocumentName").val(docName);
		$("#warningDeleteFile").modal("show");
	}else{
		$("#warningDeleteFile").modal("hide");
		docId=$("#SalesDocumentId").val();
		docName=$("#SalesDocumentName").val();
		showLoader();
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/deleteSalesHistoryDocument111",
		    data:  { 
		    	docId : docId,
		    	docName : docName
		    },
		    success: function (response) {
		    	if(response=="pass"){
		    		$("#Delete"+docId).hide();
		    		$("#Download"+docId).hide();
		    	}
	        },
			complete : function(data){
				hideLoader();
			}
		});
	}
}
function updateDocuments(data){
	$("#ConvertEstimateDocRefKey").val(data);
	setClientDocuments();
}
function showGstBox(){
	$("#showGSTModel").modal("show");
}   
function calculateGstAmount(){
	var originalCost=$("#gstAmount").val();
	var gst=$("#GstPercent").val();
// 	console.log("originalCost="+originalCost+"/gst="+gst);
	if(originalCost!=null&&originalCost!=""&&gst!=null&&gst!=""){
		var gstAmount=Number(originalCost)-(Number(originalCost)*(100/(100+Number(gst))));
		var netPrice=Math.round(Number(originalCost)-Number(gstAmount));
		
		$("#amountWithoutGst").val(netPrice);
	}
}
function copyGstAmount(){
	showLoader();
	var urlText=$("#amountWithoutGst").val();	
	var copyText = document.getElementById("amountWithoutGst");
	copyText.select();
	copyText.setSelectionRange(0, 99999)
	document.execCommand("copy");	 
	$("#showGSTModel").modal("hide");
	hideLoader();
	document.getElementById('errorMsg1').innerHTML = 'Copied !!';
	$('.alert-show1').show().delay(2000).fadeOut();
}
function isExistEditGST(valueid){
	var val=document.getElementById(valueid).value.trim();
	var key=$("#UpdateCompanyKey").val().trim();
	if(val!=""&&val!="NA"&&key!=""&&key!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"isEditGST","id":key},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(valueid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}
function addNewPriceType(prodRefId){
	if(prodRefId!="NA"){
		var estKey=$("#"+prodRefId).val();
		 $.ajax({
			type : "GET",
			url : "GetPriceType111",
			dataType : "HTML",
			data : {
				estKey : estKey
			},
			success : function(data){
				$("#priceType").empty();
				$("#priceType").append(data);				
				
				$("#AddNewPriceEstKey").val(estKey);
				$("#addNewPriceType").modal("show");
			}
		});	//AddNewPriceEstKey	
		
	}else{
		var estKey=$("#AddNewPriceEstKey").val();  
		var priceType=$("#priceType").val();
	    var typePrice=$("#typePrice").val();
	    var typePriceHsn=$("#typePriceHsn").val();
		if(priceType==null||priceType==""){
			document.getElementById("errorMsg").innerHTML="Please select price type.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(typePrice==null||typePrice==""){
			document.getElementById("errorMsg").innerHTML="Please enter price.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		$.ajax({
			type : "POST",
			url : "AddPriceType111",
			dataType : "HTML",
			data : {
				priceType : priceType,
				typePrice : typePrice,
				typePriceHsn : typePriceHsn,
				estKey : estKey
			},
			success : function(data){
				if(data=="pass"){
					$("#addNewPriceType").modal("hide");
					editEstimateBox();
				}else{
					document.getElementById("errorMsg").innerHTML="Something went wrong, Please try-again later !!";
					$('.alert-show').show().delay(4000).fadeOut();
					return false;
				}
			}
		});
	}
}
function searchHSNCode(BoxId){
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
// 	            	$("#"+GstBoxId).val(""); 
	            }
	            else{              	
	            	$("#"+BoxId).val(ui.item.hsn);
// 	            	$("#"+GstBoxId).val(ui.item.igst+" %");
	            }
	        },
	        error : function(error){
				alert('error: ' + error.responseText);
			},
		});
	});
	}
function setTotalSalesService(saleno){
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetEstimateSalesProducts111",
		dataType : "HTML",
		data : {				
			saleno : saleno,						
		},
		success : function(data){	
		if(Object.keys(data).length!=0){
			data = JSON.parse(data);			
		 var len = data.length;
		 if(Number(len)>0){	
			$("#Service_Name").empty(); 
			var options="";			 
		 for(var j=0;j<len;j++){ 			
		 	var name=data[j]["name"];
		 	options+="<option value='"+name+"' selected>"+name+"</option>";	 
		 }
		 $("#serviceQty").val(Number(len));
		 $("#Service_Name").append(options);
		 }}
	},
	complete : function(data){
		hideLoader();
	}});
}
function openTaskNotesBox(){
	$("#PublicSalesTaskFormId")[0].reset();
	$(".contentInnerBox").remove();
	var id = $(".estnotes").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });
}

function showTeamNotes(PublicreplyLi,InternalreplyLi,ReplyNotesBoxId,InternalNotesBoxId){
	$("#"+PublicreplyLi).addClass("active");
	$("#"+InternalreplyLi).removeClass("active");
	$("#"+ReplyNotesBoxId).show();
	$("#"+InternalNotesBoxId).hide();
	$(".communication_history").show();
	$(".communication_history1").show();
	$(".internalNotes").addClass("toggle_box");
	$(".cmhistscroll").scrollTop($(".cmhistscroll")[0].scrollHeight);
}
function showPersonalNotes(PublicreplyLi,InternalreplyLi,ReplyNotesBoxId,InternalNotesBoxId){
	$("#"+PublicreplyLi).removeClass("active");
	$("#"+InternalreplyLi).addClass("active");
	$("#"+ReplyNotesBoxId).hide();
	$("#"+InternalNotesBoxId).show();
	$(".communication_history").hide();
	$(".communication_history1").hide();
	$(".internalNotes").removeClass("toggle_box");
}
function validateTeamNotes(){
	var notes=CKEDITOR.instances.ChatTextareaBoxReply.getData();
	var estrefid=$("#notesestimate").val();
	var userInChat=$("#userInChat").val();
	
	if(userInChat!=null&&userInChat.length>0){
		userInChat=$("#userInChat").val()+"";
	}
	
	if(estrefid==null||estrefid==""){
		alert("Please select service..");
		return false;
	}
	
	if(notes==null||notes.length<=0){
		alert("Please enter text..");
		return false;
	}
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveEstimateTaskNotes111",
		dataType : "HTML",
		data : {				
			estrefid : estrefid,
			notes : notes,
			type:"Team",
			userInChat:userInChat
		},
		success : function(data){
			$("#PublicSalesTaskFormId")[0].reset();
			$("#userInChat").empty();
			$(".communication_history").append(data);			
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function validatePersonalNotes(){
	var notes=CKEDITOR.instances.ChatTextareaBoxReply1.getData();
	var estrefid=$("#notesestimate").val();
	if(estrefid==null||estrefid==""){
		alert("Please select service..");
		return false;
	}
	if(notes==null||notes.length<=0){
		alert("Please enter text..");
		return false;
	}
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveEstimateTaskNotes111",
		dataType : "HTML",
		data : {				
			estrefid : estrefid,
			notes : notes,
			type:"Personal",
			"userInChat":""
		},
		success : function(data){	
			CKEDITOR.instances.ChatTextareaBoxReply1.setData('')
			$(".cmhistscrollInternal").append(data);			
		},
		complete : function(data){
			hideLoader();
		}
	});
}

$(document).ready(function(){
	$("#estimateStatus").change(function(){
		var action=$(this).val();
		if(action!=null&&action!=""){
			$("#salesReasonHead").html("Estimate "+action+" Reason");
			$("#cancelSaleModal").modal("show");			
		}		
	})
})

function cancelSale(){
	var description=$("#cancelDescription").val();
	
	if(description==null||description==""){
		alert("Please enter text..");
		return false;
	}
	
	var action=$("#estimateStatus").val();
	
	var array = [];
	$("input:checkbox[id=checkbox]:checked").each(function(){
		array.push($(this).val());
	});
	
	$.ajax({
		type : "POST",
		url : "UpdateEstimateStatus111",
		dataType : "HTML",
		data : {	
			action:action,
			array:array+"",
			description:description
		},
		success : function(data){	
			location.reload();		
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function showCancelReason(invoice){
	
	$.ajax({
		type : "GET",
		url : "GetEstimateCancelReason111",
		dataType : "HTML",
		data : {	
			invoice:invoice,
			"type":"estimate"
		},
		success : function(data){
			var x=data.split("#");
			var heading=x[0];
			var content=x[1];
			$("#estimateCancelLabel").html(heading);
			$("#estimateCancelBody").html(content);
			$("#estimateCancelModal").modal("show");
								
		},
		complete : function(data){
			hideLoader();
		}
	});
	
}
</script>