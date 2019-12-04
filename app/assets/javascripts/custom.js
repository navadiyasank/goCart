var timer;
$("body").on("change",".Polaris-Checkbox__Input",function(){
	$(this).toggleClass('Polaris-Checkbox__Input--checked');
});

$(document).ready(function($) {
  $('.mini-color').minicolors({
    format: 'rgb',
    control: 'hue',
    opacity: true
  })

  $(function() {
    // Initializes and creates emoji set from sprite sheet
    window.emojiPicker = new EmojiPicker({
      emojiable_selector: '[data-emojiable=true]',
      assetsPath: '/images/',
      popupButtonClasses: 'fa fa-smile-o'
    });
    // Finds all elements with `emojiable_selector` and converts them to rich emoji input fields
    // You may want to delay this step if you have dynamically created input fields that appear later in the loading process
    // It can be called as many times as necessary; previously converted input fields will not be converted again
    window.emojiPicker.discover();
  });

  change_animation();
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

$(document).on('change', 'input[name="shop[title_animation_type]"]', function(event) {
  change_animation();
});

function change_animation(){
  page_title = $('#shop_title_text').val();
  page_title = page_title.replace('{cart_items}', '2');
  defaultTitle = '&nbsp;&nbsp;';position = 0;
  title_animation_type = $("input[name='shop[title_animation_type]']:checked").val();
  title = $('.advance-preview');
  clearInterval(timer);
  if(title_animation_type == 'blink'){
    timer = setInterval(function() {
      if(title.html() == defaultTitle)
        title.html(page_title);
      else
        title.html(defaultTitle);
    }, 1000);
  }
  else if(title_animation_type == 'scroll'){
    timer = setInterval(function() {
      title.text(page_title.substring(position, page_title.length) + page_title.substring(0, position)); 
      position = position + 2;
      if (position > page_title.length) position = 0
    }, 1000)
  }
}