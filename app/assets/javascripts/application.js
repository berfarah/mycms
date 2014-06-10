// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require moment
//= require bootstrap-datetimepicker
//= require select2
//= require ckeditor/override
//= require ckeditor/init
//= require_tree
ready = function(){
	$('.date.input-group').datetimepicker({
		pickTime: false
	});
	$('.time.input-group').datetimepicker({
		pickDate: false,
		pick12HourFormat: false
	});

	$('.select2').each(function(i, e){
		var $select = $(e)
		options = {
			dropdownCssClass: "bigdrop",
			multiple: true,
			tags: true,
			tokenSeparators: [","],
			minimumInputLength: "2",
			placeholder: "Tags",
			createSearchChoice: function(term, data) {
				if ($(data).filter(function() {
					return this.text.localeCompare(term) === 0;
				}).length === 0) {
					return {
						id: "<<" + term + ">>",
						text: term
					};
				}
			}
		};

		if ( existing = $select.val() ){
			options.initSelection = function(element, callback){
				var data = [];
				$(existing.split(',')).each(function(){
					$.ajax('/tags.json', {
						data: { id: this },
						datatype: 'json'
					}).done(function(d){ data.push(d); callback(data); });
				});
			}
		}

		if ($select.hasClass('ajax')){
			options.ajax = {
				url: $select.data('source'),
				dataType: 'json',
				data: function(term, page) {
					return {
						q: term,
						per: 10
					}
				},
				results: function(data, page) {
					return {
						results: data
					}
				}
			}
		}
		$select.select2(options);
	});
}

$(document).ready(ready);
$(document).on('page:load', ready);