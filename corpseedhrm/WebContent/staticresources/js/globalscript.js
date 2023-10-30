function blank(a) { if(a.value == a.defaultValue) a.value = ""; }

function unblank(a) { if(a.value == "") a.value = a.defaultValue; }



function SelectedURL(A){location.href=A;}
//convert 24 hours time into 12 hours format
function tConvert (time) {
	  // Check correct time format and split into components
	  time = time.toString ().match (/^([01]\d|2[0-3])(:)([0-5]\d)(:[0-5]\d)?$/) || [time];

	  if (time.length > 1) { // If time format correct
	    time = time.slice (1);  // Remove full string match value
	    time[5] = +time[0] < 12 ? ' AM' : ' PM'; // Set AM/PM
	    time[0] = +time[0] % 12 || 12; // Adjust hours
	  }
	  return time.join (''); // return adjusted time or original string
}

//random String key
function getKey(length) {
	   var result           = '';
	   var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	   var charactersLength = characters.length;
	   for ( var i = 0; i < length; i++ ) {
	      result += characters.charAt(Math.floor(Math.random() * charactersLength));
	   }
	   return result;
	}
//validate url

function isurl(id,err)

{

	var str=document.getElementById(id).value.trim();

  regexp =  /^(?:(?:https?|ftp):\/\/)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/\S*)?$/;

        if (regexp.test(str))

        {

          return true;

        }else

        {  document.getElementById(err).innerHTML="Enter Correct Url.";

        	document.getElementById(err).style.color="#333";

        	document.getElementById(id).value="";

          return false;

        }

}



//loginValidation

function loginValidation()

{

if(document.getElementById('Login Email ID').value=="")

{

leerrorMSGdiv.innerHTML="Login is required.";

leerrorMSGdiv.style.color="#333";

return false;

}



if(document.getElementById('Login Password').value=="")

{

lpeerrorMSGdiv.innerHTML="Login Password is required.";

lpeerrorMSGdiv.style.color="#333";

return false;

}

document.exitinguserLoginCheck.actiontype.value="CheckisValidUser";



document.exitinguserLoginCheck.submit();

}



//requiredFieldValidation

function requiredFieldValidation(fieldid,errorMSGdiv)

{

var MSG=fieldid + " is required.";

var fieldValue=document.getElementById(fieldid).value.trim();

var divId=document.getElementById(errorMSGdiv);

if(fieldValue=="")

{

divId.innerHTML=MSG;

divId.style.color="#333";

return false;

}

else

{

divId.innerHTML="";

return true;

}

}

//checking entered character is number or not.

function isNumberKey(evt)

{

   var charCode = (evt.which) ? evt.which : evt.keyCode;

   if (charCode != 46 && charCode > 31 

     && (charCode < 48 || charCode > 57))

      return false;



   return true;

}

//only digit allow

function isNumber(evt)

{

	evt = (evt) ? evt : window.event;

	var charCode = (evt.which) ? evt.which : evt.keyCode;

	if (charCode > 31 && (charCode < 48 || charCode > 57)) {

	    return false;

	}

	return true;

}
function validateCityPopup(fieldid){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var iChars = "!@#$%^&*()+=[]\'.;,/{}|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Only -_ alphabet and digit allowed.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);

	document.getElementById('errorMsg').innerHTML =MSG;

	document.getElementById(fieldid).value="";

	$('.alert-show').show().delay(3000).fadeOut();

	return false;

	}
	}   

	}

	}
//New Folder Validation

function validateFolderName(fieldid,errorMSGdiv){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var divId=document.getElementById(errorMSGdiv);

	var iChars = "!@#$%^&*()+=[]\'.;,/{}|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Only -_ alphabet and digit allowed.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);

	divId.innerHTML=MSG;

	document.getElementById(fieldid).value="";

	divId.style.color="#333";

	return false;

	}

	else

		divId.innerHTML="";

	}   

	}

	}

//validate company name

function validateKey(fieldid,errorMSGdiv){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var divId=document.getElementById(errorMSGdiv);

	var iChars = "!@#$%^&*()+=[]\';.-_,/{}|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Only alphabet and digit allowed.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);

	divId.innerHTML=MSG;

	document.getElementById(fieldid).value="";

	divId.style.color="#333";

	return false;

	}

	else

		divId.innerHTML="";

	}   

	}

	}

function validCompanyNamePopup(fieldid){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var iChars = "!@#$%^*+=[]\';,/{}|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Only .-_& ( ) alphabet and digit allowed.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);

	document.getElementById('errorMsg').innerHTML =MSG;

	document.getElementById(fieldid).value="";

	$('.alert-show').show().delay(3000).fadeOut();	

	return false;

	}
	}   

	}

	}

//validate company name

function validateCompanyName(fieldid,errorMSGdiv){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var divId=document.getElementById(errorMSGdiv);

	var iChars = "!@#$%^&*+=[]\';,/{}|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Only .-_ ( ) alphabet and digit allowed.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);

	divId.innerHTML=MSG;

	document.getElementById(fieldid).value="";

	divId.style.color="#333";

	return false;

	}

	else

		divId.innerHTML="";

	}   

	}

	}

//validate user Name

function validateUserName(fieldid,errorMSGdiv){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var divId=document.getElementById(errorMSGdiv);

	var iChars = "!@#$%^&*()+=-[]\';,./{}|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Only alphabet and digits allowed.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);

	divId.innerHTML=MSG;

	document.getElementById(fieldid).value="";

	divId.style.color="#333";

	return false;

	}

	else

		divId.innerHTML="";

	}   

	}

	}

function validateUserNamePopup(fieldid){
	var fieldValue=document.getElementById(fieldid).value.trim();
	if(fieldValue!=""){
	var iChars = "!@#$%^&*()+=-[]\';,./{}|\":<>?";
	for (var i = 0; i < fieldValue.length; i++) {
	if (iChars.indexOf(fieldValue.charAt(i)) != -1)
	{
	var MSG="Only alphabet and digits allowed.";
	var len =(fieldValue.length)-1;
	fieldValue=(fieldValue).substring(0,len);
	document.getElementById('errorMsg').innerHTML =MSG;
	document.getElementById(fieldid).value="";
	$('.alert-show').show().delay(3000).fadeOut();
	return false;
	}}}}
	//validatePan

function validatePanPopup(fieldid){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){


	var iChars = "!@#$%^&*()+=-[]\';,./{}|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Enter Valid Pan No.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);
	document.getElementById('errorMsg').innerHTML =MSG;
	document.getElementById(fieldid).value="";

	$('.alert-show').show().delay(3000).fadeOut();
	
	return false;

	}

	if(fieldValue.length<10){

		document.getElementById('errorMsg').innerHTML="Enter Valid Pan No.";

		document.getElementById(fieldid).value="";

		$('.alert-show').show().delay(3000).fadeOut();

		return false;	

	}
	}   

	}

	}

	function validatePan(fieldid,errorMSGdiv){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var divId=document.getElementById(errorMSGdiv);

	var iChars = "!@#$%^&*()+=-[]\';,./{}|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Enter Valid Pan No.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);

	divId.innerHTML=MSG;

	document.getElementById(fieldid).value="";

	divId.style.color="#333";

	return false;

	}

	if(fieldValue.length<10){

		divId.innerHTML="Enter Valid Pan No.";

		document.getElementById(fieldid).value="";

		divId.style.color="#333";

		return false;	

	}

	else

		divId.innerHTML="";

	}   

	}

	}

//validateName
	function validateNamePopup(fieldid){

		var fieldValue=document.getElementById(fieldid).value.trim();

		if(fieldValue!=""){

		var iChars = "!@#$%^&*()+=-[]\';,/{}|\":<>?0123456789";

		for (var i = 0; i < fieldValue.length; i++) {

		if (iChars.indexOf(fieldValue.charAt(i)) != -1)

		{

		var MSG="Only alphabet & '.' allowed.";

		var len =(fieldValue.length)-1;

		fieldValue=(fieldValue).substring(0,len);

		document.getElementById('errorMsg').innerHTML =MSG;

		document.getElementById(fieldid).value="";
		
		$('.alert-show').show().delay(3000).fadeOut();

		return false;

		}
		}   

		}

		}
	
	
function validateName(fieldid,errorMSGdiv){

var fieldValue=document.getElementById(fieldid).value.trim();

if(fieldValue!=""){

var divId=document.getElementById(errorMSGdiv);

var iChars = "!@#$%^&*()+=-[]\';,./{}|\":<>?0123456789";

for (var i = 0; i < fieldValue.length; i++) {

if (iChars.indexOf(fieldValue.charAt(i)) != -1)

{

var MSG="Only alphabet allowed.";

var len =(fieldValue.length)-1;

fieldValue=(fieldValue).substring(0,len);

divId.innerHTML=MSG;

document.getElementById(fieldid).value="";

divId.style.color="#333";

return false;

}

else

	divId.innerHTML="";

}   

}

}

function validateLocationPopup(fieldid){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var iChars = "!@#$%^&*+=[]\;{}'|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Alphabet & Digit and . , - /() allowed only.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);

	document.getElementById('errorMsg').innerHTML =MSG;

	document.getElementById(fieldid).value="";

	$('.alert-show').show().delay(3000).fadeOut();

	return false;

	}
	}}
}
//validateLocation

function validateLocation(fieldid,errorMSGdiv){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var divId=document.getElementById(errorMSGdiv);

	var iChars = "!@#$%^&*+=[]\;{}'|\":<>?";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) != -1)

	{

	var MSG="Alphabet & Digit and . , - /() allowed only.";

	var len =(fieldValue.length)-1;

	fieldValue=(fieldValue).substring(0,len);

	divId.innerHTML=MSG;

	document.getElementById(fieldid).value="";

	divId.style.color="#333";

	return false;

	}else

		divId.innerHTML="";

	}   

	}}

//MobileNotSameValidation

function MobileNotSameValidation(fieldid,sfieldid,errorMSGdiv) {

var fmobileno=document.getElementById(fieldid).value.trim();

var smobileno=document.getElementById(sfieldid).value.trim();

if(fmobileno!=""&&smobileno!=""){

var divId=document.getElementById(errorMSGdiv);	

if(fmobileno==smobileno)

{

divId.innerHTML="Alternate mobileno. must not be same.";	

divId.style.color="#333";

document.getElementById(sfieldid).value="";

return false;

}

else

	{

	divId.innerHTML="";

	return true;

	}

}  }

//toUpper

function toUpper(mystring) 

{

	var sp = mystring.split(' ');

	var wl=0;

	var f ,r;

	var word = new Array();

	for (i = 0 ; i < sp.length ; i ++ ) {

	f = sp[i].substring(0,1).toUpperCase();

	r = sp[i].substring(1);

	word[i] = f+r;

	}

	newstring = word.join(' ');

	document.getElementById('Employee Name').value = newstring;

	return true;

}

//verifyEmailId

function verifyEmailId(fieldid,errorMSGdiv) {

var fieldValue=document.getElementById(fieldid).value.trim();

if(fieldValue!=""){

var divId=document.getElementById(errorMSGdiv);

if (fieldValue.length > 0) {
const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
if (pattern.test(fieldValue)) {



	divId.innerHTML="";

	return true;

}

var MSG="Please Fill valid E-Mail Id";

divId.innerHTML=MSG;

document.getElementById(fieldid).value="";

divId.style.color="#333";

return false;

}

}}

function verifyEmailIdPopup(fieldid) {

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	if (fieldValue.length > 0) {

	const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
//	if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(fieldValue)) {
//
//		return true;
//	}
if(pattern.test(fieldValue)){return true;}

	var MSG="Please Fill valid E-Mail Id";

	document.getElementById('errorMsg').innerHTML =MSG;

	document.getElementById(fieldid).value="";

	$('.alert-show').show().delay(4000).fadeOut();

	return false;

	}

	}}

//NA should be not accepted.

function validateValue(fieldid,errorMSGdiv){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var divId=document.getElementById(errorMSGdiv);

	if (fieldValue=="NA"||fieldValue=="na"||fieldValue=="Na"||fieldValue=="nA"||fieldValue=="null"||fieldValue=="NULL"||fieldValue=="Null" ) {

	

	var MSG="Invalid input. ";

	divId.innerHTML=MSG;

	document.getElementById(fieldid).value="";

	divId.style.color="#333";

	return false;

	}

	else{

		divId.innerHTML="";

		return true;}

}} 

function validateValuePopup(fieldid){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	if (fieldValue=="NA"||fieldValue=="na"||fieldValue=="Na"||fieldValue=="nA"||fieldValue=="null"||fieldValue=="NULL"||fieldValue=="Null" ) {

	var MSG="Invalid input. ";

	document.getElementById('errorMsg').innerHTML =MSG;

	document.getElementById(fieldid).value="";

	$('.alert-show').show().delay(3000).fadeOut();

	return false;

	}} 
}

//Number should be greater Than or equal to Zero.

function validateGreaterEqual(fieldid,errorMSGdiv){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var divId=document.getElementById(errorMSGdiv);

	if (fieldValue < 0 ) {

	

	var MSG=fieldid+" must be positive number or Zero.";

	divId.innerHTML=MSG;

	document.getElementById(fieldid).value="";

	divId.style.color="#333";

	return false;

	}

	else{

		divId.innerHTML="";

		return true;}

} }





//Number should be greater Than Zero.

function validateGreater(fieldid,errorMSGdiv){

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var divId=document.getElementById(errorMSGdiv);

	if (fieldValue <= 0 ) {

	

	var MSG=fieldid+" must be positive number.";

	divId.innerHTML=MSG;

	document.getElementById(fieldid).value="";

	divId.style.color="#333";

	return false;

	}

	else{

		divId.innerHTML="";

		return true;}

}  }

//validateMobileno

function validateMobileno(fieldid,errorMSGdiv) {

var fieldValue=document.getElementById(fieldid).value.trim();

if(fieldValue!=""){

var divId=document.getElementById(errorMSGdiv);

var iChars = "0123456789";

for (var i = 0; i < fieldValue.length; i++) {

if (iChars.indexOf(fieldValue.charAt(i)) == -1) {

var MSG=" Alphabets or special characters not allowed.";

var len = (fieldValue.length) - 1;

fieldValue = (fieldValue).substring(0, len);

divId.innerHTML=MSG;

document.getElementById(fieldid).value="";

divId.style.color="#333";

return false;

}

if (fieldValue.charAt(0) != "9" && fieldValue.charAt(0) != "8" && fieldValue.charAt(0) != "7" && fieldValue.charAt(0) != "6") {

var MSG="Mobile Number Should Be Start with 9,8,7 or 6";

divId.innerHTML=MSG;

document.getElementById(fieldid).value="";

divId.style.color="#333";

return false;

}

if(fieldValue.length > 10 || fieldValue.length < 10 )

{

var MSG="Please Fill 10 Digit Mobile Number";

divId.innerHTML=MSG;

document.getElementById(fieldid).value="";

divId.style.color="#333";

return false;

}else

	divId.innerHTML="";	

}

}}

function validateMobilePopup(fieldid) {

	var fieldValue=document.getElementById(fieldid).value.trim();

	if(fieldValue!=""){

	var iChars = "0123456789";

	for (var i = 0; i < fieldValue.length; i++) {

	if (iChars.indexOf(fieldValue.charAt(i)) == -1) {

	var MSG=" Alphabets or special characters not allowed.";

	var len = (fieldValue.length) - 1;

	fieldValue = (fieldValue).substring(0, len);

	document.getElementById('errorMsg').innerHTML =MSG;

	document.getElementById(fieldid).value="";

	$('.alert-show').show().delay(4000).fadeOut();

	return false;

	}

	if (fieldValue.charAt(0) != "9" && fieldValue.charAt(0) != "8" && fieldValue.charAt(0) != "7" && fieldValue.charAt(0) != "6") {

	var MSG="Mobile Number Should Be Start with 9,8,7 or 6";

	document.getElementById('errorMsg').innerHTML =MSG;

	document.getElementById(fieldid).value="";

	$('.alert-show').show().delay(4000).fadeOut();

	return false;

	}

	if(fieldValue.length > 10 || fieldValue.length < 10 )

	{

	var MSG="Please Fill 10 Digit Mobile Number";

	document.getElementById('errorMsg').innerHTML =MSG;

	document.getElementById(fieldid).value="";

	$('.alert-show').show().delay(4000).fadeOut();

	return false;

	}
	}

	}}

//ResetPasswordValidation

function ResetPasswordValidation(newp,cnfp,err)

{

	var newpass=document.getElementById(newp).value.trim();

	var cnfpass=document.getElementById(cnfp).value.trim();

if(newpass!=""&&cnfpass!="")	

if(newpass!=cnfpass)

{	

	document.getElementById(err).innerHTML="Password doesn't matches.";

	document.getElementById(err).style.color="#333";	

	document.getElementById(cnfp).value="";

return false;

}

else{

	document.getElementById(err).innerHTML="Password matched.";

	document.getElementById(err).style.color="green";

return true;

}

}

//deleteSpecialChar

function deleteSpecialChar(txtName)

{

    if (txtName.value != '' && txtName.value.match(/^[\w ]+$/) == null) 

    {

        txtName.value = txtName.value.replace(/[\W]/g, '');

    }

}
//validate Number between 0-100
function validateNumber(number,id){
	var n=Number(number);
	if (n < 0) { 
        document.getElementById('errorMsg').innerHTML ="Type number between 0-100";
        $("#"+id).val(0);
        $('.alert-show').show().delay(4000).fadeOut();        
    } else if (n > 100) { 
    	 document.getElementById('errorMsg').innerHTML ="Type number between 0-100";
         $("#"+id).val(0);
         $('.alert-show').show().delay(4000).fadeOut();        
    }
}

function markAllAsReadNotification(count){
if(Number(count)>0){
		$.ajax({
		type : "GET",
		url : "markallasread.html",
		dataType : "HTML",
		data : {},
		success : function(data){
			if(data=="pass"){
				$("#totalNotification").html('');
			}
		}
	 });
}
}

function markAsReadNotification(page){
location.href=page;
//markasread.html
}


function integer_to_roman(num) {
	if (typeof num !== 'number') 
	return false; 

	var digits = String(+num).split(""),
	key = ["","C","CC","CCC","CD","D","DC","DCC","DCCC","CM",
	"","X","XX","XXX","XL","L","LX","LXX","LXXX","XC",
	"","I","II","III","IV","V","VI","VII","VIII","IX"],
	roman_num = "",
	i = 3;
	while (i--)
	roman_num = (key[+digits.pop() + (i * 10)] || "") + roman_num;
	return Array(+digits.join("") + 1).join("M") + roman_num;
}

$(window).load(function() {

	$('#loading').hide();

});

var validNumber = new RegExp(/^\d*\.?\d*$/);
var lastValid = $(".onlyDecimal").val();
function validateNumber(elem) {
	console.log(elem)
  if (validNumber.test(elem.value)) {
    lastValid = elem.value;
  } else {
    elem.value = lastValid;
  }
}

$(document).ready(function(){
	$('.no_copy_paste').bind('copy paste',function(e) {
    e.preventDefault(); return false; 
});
})

