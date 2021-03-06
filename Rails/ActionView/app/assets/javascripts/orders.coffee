CreditCard =
  cleanNumber: (number) ->
    number.replace /[-]/g,""

  validCardNumber: (number) ->
    total = 0
    number = @cleanNumber(number)
    for i in [number.length-1..0]
      n = +number[i]
      if (i+number.length) % 2 == 0
        n = if n*2 > 9 then n*2 - 9 else n*2
      total += n
    total % 10 == 0

  validNumber: (number) ->
    nubmerPattern = /^\d+$/;
    nubmerPattern.test(number)

  validLastFourNumber: (number) ->
    nubmerPattern = /^\d\d\d\d$/;
    nubmerPattern.test(number)


jQuery ->
  console.log "orders fire!"
  
  $("#order_credit_card_number").blur ->
    if CreditCard.validCardNumber(@value)
      $("#credit_card_number_error").text("")
    else
      $("#credit_card_number_error").html("invalid card number!")

  $("#order_card_last_four").blur ->
    if CreditCard.validLastFourNumber(@value)
      $("#last_four_error").text("")
    else
      $("#last_four_error").html("invalid number!")

  $("#order_credit_card_expires_on").datepicker
    dateFormat: 'yy-mm-dd'

  container = $('#orders_chart')
  if container.length
    Morris.Line
      element: 'orders_chart'
      data: container.data('orders')
      xkey: 'purchased_at'
      ykeys: ['price', 'shipping_price', 'download_price']
      labels: ['Total Price', 'Shipping Price', 'Download Price']
      preUnits: '$'


 