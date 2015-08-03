//= require spree/backend

SpreeSmspay = {
  hideSettings: function(paymentMethod) {
    if (SpreeSmspay.paymentMethodID && paymentMethod.val() == SpreeSmspay.paymentMethodID) {
      $('#payment_amount').prop('disabled', 'disabled');
      $('button[type="submit"]').prop('disabled', 'disabled');
      $('#smspay-warning').show();
    } else if (SpreeSmspay.paymentMethodID) {
      $('#payment_amount').prop('disabled', '');
      $('button[type="submit"]').prop('disabled', '');
      $('#smspay-warning').hide();
    }
  }
};

$(document).ready(function() {
  checkedPaymentMethod = $('[data-hook="payment_method_field"] input[type="radio"]:checked');
  SpreeSmspay.hideSettings(checkedPaymentMethod);
  paymentMethods = $('[data-hook="payment_method_field"] input[type="radio"]').click(function(e) {
    SpreeSmspay.hideSettings($(e.target));
  });
});