import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'bootstrap'

global.$ = require('jquery')
global.toastr = require('toastr')

Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).on('turbolinks:load', function(){
  $('#datetime_ida').on('change', function(){
    var dateObj = this.value;
    var url = $(location).attr("href");
    $.ajax({
      method: "GET", 
      url: url,
      data: {dateObj},
      success: function(){
        console.log(dateObj)
      }, error: function(){
        console.log("Can't update!")
      }
    }) 
  })
})
