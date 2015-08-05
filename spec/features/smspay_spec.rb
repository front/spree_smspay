describe "Smspay", :js => true do
  let!(:product) { FactoryGirl.create(:product, :name => 'iPad') }
  before do
    @gateway = Spree::Gateway::Smspay.create!({
      :preferred_title => 'Smspay',
      :preferred_description => 'Pay with Smspay',
      :preferred_merchant_user => 'spree',
      :preferred_merchant_password => 'spree',
      :preferred_success_url => 'http://example.com/smspay/success',
      :preferred_failure_url => 'http://example.com/smspay/failure',
      :name => 'Smspay',
      :active => true,
      :environment => Rails.env
    })
    FactoryGirl.create(:shipping_method)
    FactoryGirl.create(:country)
    FactoryGirl.create(:state)
  end

  def fill_in_billing
    within('#billing') do
      fill_in "First Name", :with => "Test"
      fill_in "Last Name", :with => "User"
      fill_in "Street Address", :with => "1 User Lane"
      fill_in "City", :with => "Adamsville"
      select "United States of America", :from => "order_bill_address_attributes_country_id"
      # select "Alabama", :from => "order_bill_address_attributes_state_id"
      fill_in "Zip", :with => "35005"
      fill_in "Phone", :with => "555-123-4567"
    end
  end

  it "pays for an order successfully" do
    visit spree.root_path
    click_link 'iPad'
    click_button 'Add To Cart'
    click_button 'Checkout'
    within('#guest_checkout') do
      fill_in "Email", :with => "test@example.com"
      click_button 'Continue'
    end
    screenshot_and_save_page
    fill_in_billing
    click_button "Save and Continue"
    click_button "Save and Continue"
    within('[data-hook="smspay_phone_number"]') do
      find(:css, 'select').set("47")
      find(:css, 'input').set("12345678910")
    end
    click_button "Save and Continue"
    click_button "Place Order"
  end
end