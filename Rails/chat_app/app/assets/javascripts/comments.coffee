
jQuery ->
  client.subscribe '/comments', (payload) ->
    console.log("/comments")
    $('#comments').find('.media-list').prepend(payload.message) if payload.message
 
    
  $('#new_comment').submit -> $(this).find("input[type='submit']").val('Sending...').prop('disabled', true)



jQuery ->
  client.subscribe '/comments/broadcast', (payload) ->
    eval(payload.message) if payload.message
