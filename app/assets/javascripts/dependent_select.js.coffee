# Unobtrusive RESTful dynamic/dependent select menus for Ruby on Rails 3 and jQuery
#
# USAGE (with Formtastic):
#
# match   = form.object
# seasons = Season.all
# rounds  = match.season.nil? ? Array.new : match.season.rounds
#
# form.input :season, :as => :select, :collection => seasons, :include_blank => false, :prompt => true, :input_html => { :id => :season_id }
# form.input :round,  :as => :select, :collection => rounds,  :include_blank => false, :prompt => true, :input_html => { :id => :round_id,
  # "data-option-dependent"    => true,
  # "data-option-observed"     => "season_id",
  # "data-option-url"          => "/seasons/:season_id:/rounds.json",
  # "data-option-key-method"   => :id,
  # "data-option-value-method" => :name
# }
# 
# JSON response example:
# [{"end_date":"2011-10-29","name":"First","start_date":"2011-10-01","state":"opened"},
# {"end_date":"2011-09-30","name":"Second","start_date":"2011-09-03","state":"opened"}]
 
jQuery(document).ready ->
  $("select[data-option-dependent=true]").each (i) ->  
    observer_dom_id = $(this).attr("id")
    observed_dom_id = $(this).data("option-observed")
    url_mask = $(this).data("option-url")
    key_method = $(this).data("option-key-method")    
    value_method = $(this).data("option-value-method")
    prompt = (if $(this).val() then $(this).val() else $("").text(""))
    regexp = /:[0-9a-zA-Z_]+:/g
    observer = $("select#" + observer_dom_id)
    observed = $("select#" + observed_dom_id)
    observer.attr "disabled", true  if not observer.val() and observed.size() > 1
    $(document).on "click", "select#" + observed_dom_id, ->
      url = url_mask.replace(regexp, (submask) ->
        dom_id = submask.substring(1, submask.length - 1)
        $("select#" + dom_id).val()
      )
      observer.empty().append prompt
      $.getJSON url, (data) ->
        $.each data, (i, object) ->
          observer.append $("<option>").attr("value", object[key_method]).text(object[value_method])
          observer.attr "disabled", false