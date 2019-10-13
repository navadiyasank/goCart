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
	$("#btnSubmit").attr("disabled", true);
	$("#btnSubmit").addClass('Polaris-Button--disabled')
  $("#settingForm").submit();
  // Polaris-Button--disabled
});