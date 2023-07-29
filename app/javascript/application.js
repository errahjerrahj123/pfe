// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap';
//= require flatpickr


$(document).ready(function() {
  $('select#user_type').change(function(e) {
    e.preventDefault(); // Prevent form submission
    // Your code to handle the selected option
  });
});
$(document).on('change', '#role', function() {
  var role = $(this).val();
  $.ajax({
    url: '/users/listuser',
    type: 'POST',
    data: { role: role },
    success: function(response) {
      $('#users').html(response);
    },
    error: function(xhr, status, error) {
      console.log(error);
    }
  });
  document.addEventListener('DOMContentLoaded', function() {
  flatpickr('.datepicker', {
    dateFormat: 'Y-m-d',
    // Add any additional options as needed
  });
});

});

document.addEventListener('DOMContentLoaded', function() {
  flatpickr('.datepicker', {
    dateFormat: 'Y-m-d',
    // Additional configuration options can be added here
  });
});
