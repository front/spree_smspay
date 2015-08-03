// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/frontend/all.js'

SpreeSmspay = {
  updateCouponAndSaveVisibility: function() {
    if (this.isButtonHidden()) {
      $(this).trigger('hideCouponAndSave');
    } else {
      $(this).trigger('showCouponAndSave');
    }
  },
  isButtonHidden: function() {
    paymentMethod = this.checkedPaymentMethod();
    return (!$('#user_existing_card_yes:checked').length && SpreeSmspay.paymentMethodID && paymentMethod.val() == SpreeSmspay.paymentMethodID);
  },
  checkedPaymentMethod: function() {
    return $('div[data-hook="checkout_payment_step"] input[type="radio"][name="order[payments_attributes][][payment_method_id]"]:checked');
  },
  hideCouponAndSave: function() {
    $("#checkout_form_payment [data-hook=buttons]").hide();
    $("#checkout_form_payment [data-hook=coupon_code]").hide();
    $("#checkout_form_payment").on('submit.smspay', function(e) {
      $('#smspay_confirm').click();
      return false;
    });
  },
  showCouponAndSave: function() {
    $("#checkout_form_payment [data-hook=buttons]").show();
    $("#checkout_form_payment [data-hook=coupon_code]").show();
    $("#checkout_form_payment").off('submit.smspay');
  }
};

$(document).ready(function(){
  // SpreeSmspay.updateCouponAndSaveVisibility();
  // paymentMethods = $('div[data-hook="checkout_payment_step"] input[type="radio"]').click(function(e) {
  //   SpreeSmspay.updateCouponAndSaveVisibility();
  // });
  
  // $('#smspay_confirm').click(function(e){
  //   var $this = $(this);
  //   var $phoneCode = $('#payment_source_'+SpreeSmspay.paymentMethodID+'_phone_code');
  //   var $phoneNumber = $('#payment_source_'+SpreeSmspay.paymentMethodID+'_phone_number');
  //   var href = $this.attr('href');

  //   href += '&phone_code='+$phoneCode.val()+'&phone_number='+$phoneNumber.val();
  //   $this.attr('href', href);
  // });

});
