(function($){

"use strict"; // Start of use strict

//Document Ready

jQuery(document).ready(function(){

	//Select UI

	$('.orderby').selectmenu();	

	//Button Mobile

	if($(window).width()<768){

		$('.language-link,.currency-link,.account-link,.icon-search,.icon-user,.icon-cart').click(function(event){

			event.preventDefault();

			$(this).next().slideToggle();

		});

	}

	//Fixed Latest News 

	if($(window).width()>768){

		$('.item-home-latest-news').click(function(){

			if($(this).hasClass('active')){

				$(this).removeClass('active');

			}else{

				$(this).addClass('active');

			}

		});

	}

	//Product Load More

	$('.list-product-loadmore').each(function(){

		var size_li = $(this).find(".list-product li").size();

		var x=$(this).find('.btn-link-loadmore').attr('data-num');

		var y=parseInt($(this).find('.btn-link-loadmore').attr('data-num'))-1;

		$(this).find('.list-product li:lt('+x+')').show();

		$(this).find('.list-product li:gt('+y+')').hide();

		$(this).find('.btn-link-loadmore').click(function () {

			var size_li = $(this).prev().find("li").size();

			var x=$(this).attr('data-num');

			var x=parseInt($(this).attr('data-num'));

			$(this).attr('data-num',x+4);

			var x=$(this).attr('data-num');

			$(this).prev().find('li:lt('+x+')').show();

			if($(this).attr('data-num')>size_li){

				$(this).hide();

			}

		});

	});

	

	//End

	//Box Filter

	$('body').click(function(){

		$('.box-attr-filter').slideUp();

	});

	$('.btn-filter').click(function(event){

		event.preventDefault();

		event.stopPropagation();

		$('.box-attr-filter').slideToggle();

	});

	$(".datepicker").datepicker({

		changeMonth: true,

		changeYear: true,

		dateFormat: 'dd-mm-yy'

	});
	
	// Both date and time picker
	/*--
	$('.datetimepicker').datetimepicker({
        weekStart: 1,
        todayBtn:  1,
		autoclose: 1,
		todayHighlight: 1,
		startView: 2,
		forceParse: 0,
        showMeridian: 1,
		
    });
--*/
	// Date picker
	/*--
	$('.datepicker1').datetimepicker({
        weekStart: 1,
        todayBtn:  1,
		autoclose: 1,
		todayHighlight: 1,
		startView: 2,
		minView: 2,
		forceParse: 0
    });
--*/
	// Time picker
	/*--
	$('.timepicker').datetimepicker({
        weekStart: 1,
        todayBtn:  1,
		autoclose: 1,
		todayHighlight: 1,
		startView: 1,
		minView: 0,
		maxView: 1,
		forceParse: 0,
		showMeridian: 1,
    });
    --*/

	// Quick View

	$('.quick-view').each(function(){

		$(this).fancybox();

	});

	//Accordions

	if($('.accordion-box').length >0){

		$('.accordion-box').each(function(){

			$('.title-accordion').click(function(){

				$(this).parent().parent().find('.item-accordion').removeClass('active');

				$(this).parent().addClass('active');

				$(this).parent().parent().find('.desc-accordion').stop(true,true).slideUp();

				$(this).next().stop(true,true).slideDown();

			});

		});

	}

	//Menu Responsive

	/*if($(window).width()<768){*/

		/*$('body').click(function(){

			$('.main-menu').removeClass('active');

		});*/

		$('.show-menu').click(function(event){

			event.preventDefault();

			event.stopPropagation();

			$(this).hide();

			$(this).next().show();

			$('.main-menu').addClass('active');

		});

		$('.hide-menu').click(function(event){

			event.preventDefault();

			event.stopPropagation();

			$(this).hide();

			$(this).prev().show();

			$('.main-menu').removeClass('active');

		});	
		/*$('.main-nav li.menu-item-has-childrent>a').click(function(event){
			$('.sub-menu').slideToggle('');
			});*/

		/*$('.main-nav li.menu-item-has-childrent>a').click(function(event){ 

			event.stopPropagation();

			$(this).toggleClass('active');

			if($(this).hasClass('active')){

				event.preventDefault();

				$('.sub-menu').fadeOut(400);

				$(this).next().stop(true,true).fadeIn(400);

			}else{

				$('.sub-menu').fadeOut(400);

				$(this).next().stop(true,true).fadeOut(400);

			}

		});*/

	/*}*/

	//Post Gallery

	$('.item-post-gallery .fancybox').fancybox();
	$('.item-team-gallery .fancybox').fancybox();

	$('.team-gallery-thumb').each(function(){

		$(this).fancybox();

	});


	//Toggle Search

	$('body').click(function(){

		$('.select-category').slideUp();

	});

	$('.toggle-category').click(function(event){

		event.preventDefault();

		event.stopPropagation();

		$(this).next().slideToggle();

	});
	$(document).ready(function () {
    $('.toggle_btn').click(function (e) {
        $('.notification_box ').stop(true).slideToggle();
    });
    $(document).click(function (e) {
        if (!$(e.target).closest('.toggle_btn, .notification_box ').length) {
            $('.notification_box ').stop(true).slideUp();
        }
    });
});
	/*$('.toggle_btn').click(function(event){
		event.preventDefault();
		event.stopPropagation();
		$(this).next().slideToggle();
	});*/
	
	$('.add_follow_title').click(function(event){
		event.preventDefault();
		event.stopPropagation();
		$(this).toggleClass("active");
		$(this).next().slideToggle();
	});
	
	$('.access_point_icon').click(function(event){
		event.preventDefault();
		event.stopPropagation();
		$(this).toggleClass("active");
		$(this).parent().next().slideToggle();
	});

	//Change Grid-List

	$('.product-sort a').click(function(event){

		//event.preventDefault();

		$('.product-sort a').removeClass('active');

		$(this).addClass('active');

	});

	

	//Select Size

	$('.selected-attr-size	span').text($('.select-attr-size li').first().find('a').text());

	$('body').click(function(){

		$('.select-attr-size').slideUp();

	});

	$('.selected-attr-size').click(function(event){

		event.preventDefault();

		event.stopPropagation();

		$('.select-attr-size').slideToggle();

	});

	$('.select-attr-size a').click(function(event){

		event.preventDefault();

		$('.select-attr-size a').removeClass('selected');

		$(this).addClass('selected');

		$('.selected-attr-size span').text($(this).text());

	});

	//Sort By

	$('body').click(function(){

		$('.filter-type').slideUp();

	});

	$('.filter-selected').click(function(event){

		event.preventDefault();

		event.stopPropagation();

		$('.filter-type').slideToggle();

	});

	$('.filter-type a').click(function(event){

		event.preventDefault();

		$('.filter-type a').removeClass('selected');

		$(this).addClass('selected');

		$('.filter-selected').text($(this).text());

	});

	//Select Color

	$('.attr-color li a').click(function(event){

		event.preventDefault();

		$('.attr-color li a').removeClass('selected');

		$(this).addClass('selected');

	});

	//Qty Up-Down

	$('.info-qty').each(function(){

		var qtyval = parseInt($(this).find('.qty-val').text());

		$('.qty-up').click(function(event){

			event.preventDefault();

			qtyval=qtyval+1;

			$('.qty-val').text(qtyval);

		});

		$('.qty-down').click(function(event){

			event.preventDefault();

			qtyval=qtyval-1;

			if(qtyval>0){

				$('.qty-val').text(qtyval);

			}else{

				qtyval=0;

				$('.qty-val').text(qtyval);

			}

		});

	});

	//Latest News Scroll

	if($('.list-latest-news9').length>0){

		$(".list-latest-news9").mCustomScrollbar();

	}

	

	$(function(){$(".searchdate").datepicker({changeMonth:true,changeYear:true,dateFormat:'yy-mm-dd'});});

	

});



})(jQuery); // End of use strict

//$(document).ready(function() {$("input").blur(function() {if(this.value == "") $("[id='" + this.id + "']").css('border-color', '#ff0000');else $("[id='" + this.id + "']").css('border-color', '#ccc');});});