$('.form .stages label').click(function() {
	var radioButtons = $('.form input:radio');
	var selectedIndex = radioButtons.index(radioButtons.filter(':checked'));
	selectedIndex = selectedIndex + 1;
});

$('.form .button').click(function() {
	var radioButtons = $('.form input:radio');
	var selectedIndex = radioButtons.index(radioButtons.filter(':checked'));

	selectedIndex = selectedIndex + 2;

	$('.form input[type="radio"]:nth-of-type(' + selectedIndex + ')').prop('checked', true);

});
////////////////////////////////////////////////////////////////////////////////////

$(function () {
  var $sections = $('.form-section');

  function navigateTo(index) {
    // Mark the current section with the class 'current'
    $sections
      .removeClass('current')
      .eq(index)
        .addClass('current');

    // Show only the navigation buttons that make sense for the current section:
    $('.form-navigation .previous').toggle(index > 0);
    var atTheEnd = index >= $sections.length - 1;
    $('.form-navigation .next').toggle(!atTheEnd);
    $('.form-navigation [type=submit]').toggle(atTheEnd);
  }

  function curIndex() {
    // Return the current index by looking at which section has the class 'current'
    return $sections.index($sections.filter('.current'));
  }

  // Previous button is easy, just go back
  $('.form-navigation .previous').click(function() {
    navigateTo(curIndex() - 1);
		selectedIndex = selectedIndex - 1;
  });

  // Next button goes forward iff current block validates
  $('.form-navigation .next').click(function() {
    $('form').parsley().whenValidate({
      group: 'block-' + curIndex()
    }).done(function() {
      navigateTo(curIndex() + 1);
			selectedIndex = selectedIndex + 1;
    });
  });

  // Prepare sections by setting the `data-parsley-group` attribute to 'block-0', 'block-1', etc.
  $sections.each(function(index, section) {
    $(section).find(':input').attr('data-parsley-group', 'block-' + index);
  });
  navigateTo(0); // Start at the beginning
});
