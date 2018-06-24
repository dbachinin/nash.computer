/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "../src/application.scss";
import "bootstrap/dist/css/bootstrap.css";
import 'bootstrap/dist/js/bootstrap';
global.jQuery = require('jquery');
console.log('Hello World from Webpacker')

// $('.carousel').on('mouseenter',function(){ $( this ).carousel();})

// $(document).ready(function(e) {
//     $('#menu_icon').click(function(){
//         if($("#content_details").hasClass('drop_menu'))
// 		{
//         $("#content_details").addClass('drop_menu1').removeClass('drop_menu');
//     }
// 		else{
// 			$("#content_details").addClass('drop_menu').removeClass('drop_menu1');
// 			}
	
	
// 	});
	
// });