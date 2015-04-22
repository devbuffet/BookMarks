// slide toggles div
function toggleCategory(category, expand_collapse)
{
	// slide the div
	$('.' + category).slideToggle();

	var css_tx = $('#' + expand_collapse).attr('class');

	var arrOptions = ['glyphicon glyphicon-collapse-down','glyphicon glyphicon-collapse-up']

	$.each( arrOptions, function( k, v ) {
	  $('#' + expand_collapse).removeClass(v);
	});

	// remove class
	$('#' + expand_collapse).removeClass(arrOptions[1]);

	// toggle it
	if(css_tx == arrOptions[0])
	{
		$('#' + expand_collapse).addClass(arrOptions[1]);
	}
	else
	{
		$('#' + expand_collapse).addClass(arrOptions[0]);
	}
	
}