var doc = new jsPDF();

 function saveDiv(divId, titleId) {
	 var title=document.getElementById(titleId).innerHTML;
 doc.fromHTML('<html><head><title>'+title.substring(1)+'</title></head><body>' + document.getElementById(divId).innerHTML + '</body></html>');
// document.getElementById("testinvoiceprint").innerHTML=document.getElementById(divId).innerHTML;
doc.save('div.pdf');
}

function printDiv(divId,titleId) {
showLoader();
var title=document.getElementById(titleId).innerHTML;
  let mywindow = window.open('', 'PRINT', 'height=650,width=900,top=100,left=150');

  mywindow.document.write('<html><head><title>'+title.substring(1)+'</title>');
  mywindow.document.write('</head><body >');
  mywindow.document.write(document.getElementById(divId).innerHTML);
  mywindow.document.write('</body></html>');

  mywindow.document.close(); // necessary for IE >= 10
  mywindow.focus(); // necessary for IE >= 10*/

  mywindow.print();
  mywindow.close();
hideLoader();
  return true;
}

function convertHTMLToPdf(divId, titleId){
showLoader();
	var title=document.getElementById(titleId).innerHTML;
	const invoice=document.getElementById(divId);
//	console.log(invoice);
	var opt = {
			  margin:       .5,
			  filename:     title.substring(1),
			  image:        { type: 'jpeg', quality: 0.98 },
			  html2canvas:  { scale: 2 },
			  jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait'}
			};
	html2pdf().from(invoice).set(opt).save();
hideLoader();	
}

//var doc = new jsPDF();
//var specialElementHandlers = {
//    '#endContentId': function (element, renderer) {
//        return true;
//    }
//};
//
//$('#printCMD').click(function () {   
//    doc.fromHTML($('#invoicecontent').html(), 15, 15, {
//        'width': 170,
//            'elementHandlers': specialElementHandlers
//    });
//    doc.save('sample-file.pdf');
//});