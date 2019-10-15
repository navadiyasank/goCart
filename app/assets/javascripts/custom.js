$("body").on("change",".Polaris-Checkbox__Input",function(){
	$(this).toggleClass('Polaris-Checkbox__Input--checked');
});

$(document).ready(function($) {
  $('.mini-color').minicolors({
    format: 'rgb',
    control: 'hue',
    opacity: true
  })
});
$(document).on('click', '#btnSubmit', function(event) {
  if(validateForm()){
    console.log("form submit")
  	$("#btnSubmit").attr("disabled", true);
  	$("#btnSubmit").addClass('Polaris-Button--disabled')
    $("#settingForm").submit();
  }
  // Polaris-Button--disabled
});
function validate(str, min, max) {
  n = parseFloat(str);
  return (!isNaN(n) && n >= min && n <= max);
}
function validateForm()
{
  if(!validate($('#shop_blink_speed').val(), 0.5, 3.0)) {
    $('#shop_blink_speed').parent().find('.Polaris-TextField__Backdrop').css('border-color', 'red');
    return false;
  }
  return true
}
$(document).on('change', '#shop_blink_speed, #shop_blink_color, #shop_blink_wider', function(event) {
  $.ajax({
    url: '/home/change_settings',
    dataType: 'script',
    data: {blink_speed: $('#shop_blink_speed').val(),blink_color: $('#shop_blink_color').val(),blink_width: $('#shop_blink_wider').val()},
  })
  .done(function() {
    console.log("success");
  })
  .fail(function() {
    console.log("error");
  })
  .always(function() {
    console.log("complete");
  });
  
});