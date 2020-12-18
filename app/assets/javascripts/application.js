// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootbox
//= require select2
//= require datatable
//= require nested_form_fields
//= require jquery-validate
//= require jquery.remotipart
//= require activestorage
//= require turbolinks
//= require_tree .


// for form functionalities.
$(document).on('turbolinks:load', ()=> {

  let ajax_error = () => {
    bootbox.alert('Something went wrong. Please try again some other time.');
  }

  let ajax_complete = () => {
    $('.loader_holder').addClass('hidden');
  }

  let ajax_success = (success) => {
    $('.edit_holder').addClass('hidden');
    $('.form_holder').removeClass('hidden');
  }

  let ajax_request = (url, method='GET', success=true) => {
    $.ajax({
      url: url,
      type: method,
      success: ()=> {
        if(success) {
          ajax_success();
        }
      },
      error: ajax_error,
      complete: ajax_complete
    })
  }

  $('.tool_tip').tooltip();
  $(document).on('click', '.btn_start', () => {
    $('.details_holder, .edit_holder').addClass('hidden');
    $('.form_holder').removeClass('hidden');
  });

  $(document).on('click', '.btn_back', () => {
    $('.edit_holder').addClass('hidden');
    $('.details_holder').removeClass('hidden');
  });

  $(document).on('click', '.btn_edit', () => {
    $('.edit_holder').removeClass('hidden');
    $('.details_holder').addClass('hidden');
  });

  $(document).on('keyup paste', '.questionnaire_uuid', () => {
    let $btn = $('.btn_find');
    if ($('.questionnaire_uuid').val().length > 0) {
      $btn.removeClass('disabled');
      $btn.prop('disabled', false);
    }
    else {
      $btn.prop('disabled', true);
      $btn.addClass('disabled');
    }
  });

  $(document).on('click', '.btn_find', () => {
    let uuid = $('.questionnaire_uuid').val();
    let $loader_holder = $('.loader_holder');
    let url = window.location.origin;

    url += `?questionnaire_uuid=${uuid}`;
    ajax_request(url);
  });

  $(document).on('click', '.btn_remove', (e) => {
    e.preventDefault();
    let url = window.location.origin + $(e.target).attr('href');
    let $loader_holder = $('.loader_holder');
    $loader_holder.removeClass('hidden');
    ajax_request(url, 'DELETE', false);
  });

  $(document).on('keypress', '.other_processing_level', (event)=> {
    let $other_processing_level = $('.other_processing_level');
    let $processing_level_select = $('.processing_level_select');
    if ( event.which == 13 ) {
       event.preventDefault();
    }
    if($other_processing_level.val().length > 0) {
      $('.other_processing_level').attr('name', 'dataset[processing_level]');
      $processing_level_select.attr('name', 'dummy');
      $processing_level_select.val('').change();
    }
  });

  $(document).on('change', '.people_holder input, .organization_holder input', (event)=> {
    let $people_inputs = $('.people_holder .req_input');
    let $organizations_inputs = $('.organization_holder .req_input');
    let current_element_id = event.currentTarget.id;
    let $current_elem = $(`#${current_element_id}`);
    let people_flag = current_element_id.includes('people');
    let org_flag = current_element_id.includes('organization');
    if($current_elem.val() == '') {
      people_flag = !people_flag;
      org_flag = !org_flag;
    }
    $people_inputs.attr('aria-required', people_flag);
    $people_inputs.attr('required', people_flag);
    $organizations_inputs.attr('aria-required', org_flag);
    $organizations_inputs.attr('required', org_flag);
    if(people_flag) {
      $people_inputs.addClass('required');
      $organizations_inputs.removeClass('required');
    }
    else {
      $people_inputs.removeClass('required');
      $organizations_inputs.addClass('required');
    }
  });

  $(document).on('click', '.previous_btn', (event)=> {
    event.preventDefault();
    let url = window.location.origin;
    let $current_element = $('.previous_btn');
    let questionnaire_id = $current_element.data('questionnaire_id');
    let previous_partial = $current_element.data('previous_partial');
    let $loader_holder = $('.loader_holder');
    url += `?questionnaire_id=${questionnaire_id}&previous_partial=${previous_partial}`;
    $loader_holder.removeClass('hidden');
    $.ajax({
      url: url,
      success: (data)=> {
        $loader_holder.addClass('hidden');
      },
      fail: ()=> {
        bootbox.alert('Something went wrong. Please try again some other time.');
      },
      complete: () => {
        $loader_holder.addClass('hidden');
      }
    });
  });

  $(document).on('click', '.next_btn', () => {
    if($('form').valid()) {
      $('body').removeClass('modal-open');
      $('.modal-backdrop').remove();
      $('.loader_holder').removeClass('hidden');
      $('.step-trigger').removeAttr('disabled').removeClass('active');
    }
  });

  $(document).on('select2:select', '.processing_level_select', (event)=> {
    let $processing_level_select = $(this);
    let $other_processing_level = $('.other_processing_level');
    if ( event.which == 13 ) {
       event.preventDefault();
    }
    $processing_level_select.attr('name', 'dataset[processing_level]');
    $other_processing_level.attr('name', 'dummy');
    $other_processing_level.val('');
  });

  $(document).on('change', '.ongoing_checkbox', () => {
    let $ongoing_checkbox = $('.ongoing_checkbox');
    $('.end_date_prompt').attr('disabled', $ongoing_checkbox.is(':checked'));
  });

  $(document).on('cocoon:after-insert', (e, item) => {
    let $curr_elem = $(item);
    $('.tool_tip').tooltip();
    if($curr_elem.hasClass('instrument_fields')) {
      let $instrument_fields = $curr_elem.parent().find('.instrument_fields');
      $instrument_fields.children('.remove_fields').show();
      $instrument_fields.first().children('.remove_fields').hide();
    }
  });
});
