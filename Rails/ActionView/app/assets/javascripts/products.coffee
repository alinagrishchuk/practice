$(document).on 'ready page:load', ->
  console.log "products fire"
  $("#product_category_name").autocomplete { source: $("#product_category_name").data("autocomplete-source") }
  
