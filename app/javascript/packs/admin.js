import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'bootstrap'

global.$ = require('jquery')
require('select2')
global.toastr = require('toastr')

Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).ready(function () {
  $('#sidebarCollapse').on('click', function () {
      $('#sidebar').toggleClass('active');
  });

  $('.select2-form').select2();
});
