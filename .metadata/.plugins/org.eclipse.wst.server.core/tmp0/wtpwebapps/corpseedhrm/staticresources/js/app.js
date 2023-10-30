var userName = null;
var sendTo=null;
var websocket = null;
var currentdate = new Date(); 
var date =currentdate.getDate() + "-"
                + (currentdate.getMonth()+1)  + "-" 
                + currentdate.getFullYear();

function init(userName1,sendTo1) {
	userName=userName1;
	sendTo=sendTo1;
	if ("WebSocket" in window) {
//		while (userName === null) {
//			userName = prompt("Enter user name");
//		}

		websocket = new WebSocket('wss://crm.corpseed.com:443/client_inbox.html/'+sendTo+'/'+userName);
//		websocket.onopen = function(data) {
//			document.getElementById("main").style.display = "block";
//		};

		websocket.onmessage = function(data) {
			setMessage(JSON.parse(data.data));
		};

		websocket.onerror = function(e) {
			console.log('An error occured, closing application');
			
			cleanUp();
		};

		websocket.onclose = function(data) {
			cleanUp();
		
			var reason = (data.reason && data.reason !== null) ? data.reason : 'Goodbye';
			console.log(reason);
		};
	} else {
		console.log("Websockets not supported");
	}
}

function cleanUp() {
	userName = null;
	sendTo=null;
	websocket = null;
}
function sendMessageClient(messageContent,sendTo,type,client,docpath,docsize,docextension,docname) {
	
	var message = buildMessage(userName,sendTo, messageContent,type,client,docpath,docsize,docextension,docname,"NA","NA");
	setMessageClient(message);
	websocket.send(JSON.stringify(message));
	
}
function sendMessage(messageContent,sendTo,type,client,docpath,docsize,docextension,docname,dformkey,formName) {
	var message = buildMessage(userName,sendTo, messageContent,type,client,docpath,docsize,docextension,docname,dformkey,formName);
	
	setMessage(message);
	websocket.send(JSON.stringify(message));
	
}

function buildMessage(userName,sendTo,message,type,client,docpath,docsize,docextension,docname,formKey,formName) {
	return {
		username : userName,
		sendTo : sendTo,
		message : message,
		type : type,
		client : client,
		docpath : docpath,
		docsize : docsize,
		docextension : docextension,
		docname : docname,
		formKey : formKey,
		formName : formName
	};
}
function setMessageClient(msg) {
	var currentHTML = document.getElementById('scrolling-messages').innerHTML;
	var newElem;
	if (msg.username === userName) {
		newElem = '<div class="clearfix pro_box text-right mb-3 RefreshDiv"><div class="clearfix icon_box"><img src="/hcustfrontend/fntdimages/male_icon2.png" alt=""></div> <div class="clearfix pro_info"><h6><strong>'+msg.client+'</strong><span>' + msg.message + '</span>';
		if(msg.docname!="NA"){
			newElem+='<div class="clearfix download_file"><div class="download_box"><span><img src="/staticresources/images/file.png"><span title="'+msg.docname+'">'+msg.docname+'</span></span><a href="'+msg.docpath+'" download=""><img src="/staticresources/images/download.png" alt=""></a></div><div class="download_size"><span>'+msg.docsize+'  '+msg.docextension+'</span><span>'+new Date().toLocaleTimeString()+'</span></div></div>';
		}		
		newElem+='</h6><div class="clearfix date_box"><span>'+date+' '+new Date().toLocaleTimeString()+'</span></div></div></div>';		
	} else {
		newElem = '<div class="communication_item clearfix">'
					+'<div class="communication_item_lft">'
					+'<span class="communication_icon">'
					+'<img src="/staticresources/images/male_icon1.png"></span>'
					+'<div class="clearfix communication_info">'
					+'<span class="cmhistname">Corpseed&nbsp;&nbsp;<i class="fa fa-caret-right"></i>&nbsp;'+ msg.username + '</span>'
					+'<span class="clearfix cmhistmsg">'
					+'<span>'+msg.message+'</span></span></div></div></div>';		
	}
	$("#NoDataFoundMsg").hide();
	document.getElementById('scrolling-messages').innerHTML = currentHTML
			+ newElem;	
}
function setMessage(msg) {	
	var currentHTML = document.getElementById('scrolling-messages').innerHTML;
	var newElem;
	var receiver=msg.username;	
		receiver=receiver.substring(0,receiver.indexOf('-'));
	if (msg.username === userName) {		
			newElem='<div class="communication_item_rt clearfix">'
					+'<div class="clearfix communication_info"><span class="cmhistname">'+receiver+'</span>'
					+'<span class="clearfix cmhistmsg">'
					+'<span><p>' + msg.message + '</p>';
		if(msg.formName!="NA"){
			newElem+='<a class="setData" onclick="setFollowUpId(\''+msg.formKey+'\',\''+msg.formName+'\')" style="color:#fff;"><u>'+msg.formName+'</u>'
					+'&nbsp;&nbsp;<i class="fa fa-check-circle"></i></a>';
		}			
					
		newElem+='</span></span>';
					
		if(msg.docname!="NA"){		
		newElem+='<div class="clearfix download_file">'
				+'<div class="download_box"><span><img src="/staticresources/images/file.png" alt=""><span title="'+msg.docname+'">'+msg.docname+'</span></span>'
				+'<a href="'+msg.docpath+'" download=""><img src="/staticresources/images/download.png" alt=""></a></div>'
				+'<div class="download_size"><span>'+msg.docsize+'  '+msg.docextension+'</span><span>'+new Date().toLocaleTimeString()+'</span></div></div>';
	    }				
					
		newElem+='</div><span class="communication_icon">'
					+'<img src="/staticresources/images/male_icon2.png"></span></div>';	

				
	} else if(msg.type=="client"){
		var receiver1=msg.sendTo;	
		receiver1=receiver1.substring(0,receiver1.indexOf('-'));
		
		newElem = '<div class="communication_item clearfix">'
					+'<div class="communication_item_lft">'
					+'<span class="communication_icon">'
					+'<img src="/staticresources/images/male_icon1.png"></span>'
					+'<div class="clearfix communication_info">'
					+'<span class="cmhistname">'+ msg.client + '&nbsp;&nbsp;<i class="fa fa-caret-right"></i>&nbsp;'+ receiver1 + '</span>'
					+'<span class="clearfix cmhistmsg">'
					+'<span>'+msg.message+'</span></span>';
		if(msg.docname!="NA"){
			newElem+='<div class="clearfix download_file">'
					+'<div class="download_box"><span><img src="/staticresources/images/file.png" alt=""><span title="'+msg.docname+'">'+msg.docname+'</span></span>'
					+'<a href="'+msg.docpath+'" download><img src="/staticresources/images/download.png" alt=""></a></div>'
					+'<div class="download_size"><span>'+msg.docsize+'  '+msg.docextension+'</span><span>'+new Date().toLocaleTimeString()+'</span></div>'
					+'</div>';
		}			
					
		newElem+='</div></div></div>';
		
	}else{
		var activePrj=$("#ActiveProjectNo").val();
		if(activePrj===msg.sendTo){		
				newElem='<div class="clearfix pro_box text-left mb-3 RefreshDiv"><div class="clearfix icon_box"><img src="/hcustfrontend/fntdimages/male_icon1.png" alt=""></div><div class="clearfix pro_info"><h6><strong>'+ receiver + '</strong> <span><p>'+msg.message+'</p>';
		          if(msg.formName!="NA"){
						newElem+='<p><a class="setData pointers" onclick="setFollowUpId(\''+msg.formKey+'\',\''+msg.formKey+'\')" style="color: #4285f4;"><u title="'+msg.formName+'">'+msg.formName+'</u>&nbsp;&nbsp;<i id="'+msg.formKey+'" aria-hidden="true"></i></a></p>';
					}     
		
						newElem+='</span>';
			if(msg.docname!="NA"){
				newElem+='<div class="clearfix download_file"><div class="download_box"><span><img src="/staticresources/images/file.png" alt=""><span title="'+msg.docname+'">'+msg.docname+'</span></span><a href="'+msg.docpath+'" download=""><img src="/staticresources/images/download.png" alt=""></a></div><div class="download_size"><span>'+msg.docsize+'  '+msg.docextension+'</span><span>'+new Date().toLocaleTimeString()+'</span></div></div>';
			    }
		
				newElem+='</h6><div class="clearfix date_box"><span>'+date+' '+new Date().toLocaleTimeString()+'</span></div></div></div>';
		}else{
			var clientKeyapp=$("#ProjectSalesClientKey").val();
			getProjectList('',clientKeyapp);
		}
	}
	$("#NoDataFoundMsg").hide();
	if(newElem!=null&&newElem!="undefined")
	document.getElementById('scrolling-messages').innerHTML = currentHTML
			+ newElem;
	$(".cmhistscroll,.message-details").scrollTop($(".cmhistscroll,.message-details")[0].scrollHeight);
//	$(".message-details").scrollTop($(".message-details")[0].scrollHeight);	
}