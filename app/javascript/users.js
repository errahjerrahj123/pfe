$(document).on('change', '#role-select', function() {
  var role = $(this).val();
  $.ajax({
    url: '/users/listuser',
    method: 'GET',
    data: { role: role },
    dataType: 'script' // Specify the format as JavaScript
  });
});
