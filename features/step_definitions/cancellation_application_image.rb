
Given(/^I have selected to view a specific record on the cancellation application list the individual record is display$/) do
  puts('help1')
  $regnote = create_registration
  puts('help')
  visit('http://localhost:5010')
  page.driver.browser.manage.window.maximize
  visit( "http://localhost:5010/get_list?appn=cancel" )
    find(:xpath,'/html/body/div/div/div/div[3]/div/table/tbody/tr[1]/td[1]/a').click
                
end 

When(/^I am on the request original documents  screen  the accompanying evidence is visible as thumbnails$/) do 
 page.should have_xpath('/html/body/form/div/div/div/div[2]/div[1]/div[1]/img')
end 

When(/^I click on a thumbnail the image is expanded to large image$/) do 
  find(:id, 'thumbnails').click
  find(:xpath, '/html/body/form/div/div/div/div[2]/div[1]/div[2]/div/div/div/img[1]').click
end 

When(/^I am on a Large image I can zoom in$/) do 
sleep(1)
                 
  find(:xpath, '//*[@id="container0"]/img[2]').click 
  #container0>div
  #all('.zoomcontrols')[0].click
 thing = find(:csspath, '#container0 > div:nth-child(2)')
 expect(thing.text).to eq "2x Magnify"
end 

When(/^I am on a Large image I can zoom out$/) do 

  find(:xpath, '//*[@id="container0"]/img[3]').click
   
  #container0>div
  #all('.zoomcontrols')[0].click
  #container0 > div:nth-child(2)
   
 thing = find(:csspath, '#container0 > div:nth-child(2)')
  expect(thing.text).to eq "1x Magnify"
end 

When(/^I must have a registration number value before the continue button can be clicked$/) do 
  fill_in('reg_no', :with => $regnote)
 
end

Then(/^I can click the continue button to go to the next screen$/) do 
  click_button('continue')
end 

Given(/^I am on the Application details screen$/) do 
 sleep(10)
  page.has_content?('Application details')
end 

When(/^the application details become visible they must be the correct ones for the registration number detailed on the previous screen$/) do 
  #database check
end 

When(/^I can click the continue button the system will go next screen$/) do 
  click_button('continue')
end 

Then(/^the next screen will be the confirmation screen$/) do
  page.has_content?('Application Complete')
  
end

Given(/^the  confirmation screen is visible$/) do 
  #not needed just a place marker
end 

When(/^the cancellation application has been submitted the unique identifier is displayed to the user on the screen$/) do 
  page.has_content?('Your application reference number is:')
  page.has_content?('Registered on') 
  require 'Date'
  current_date = Date.today
  date_format = current_date.strftime('%d.%m.%Y')
  registerdate = find(:id, 'registereddate').text
  puts(registerdate)
  expect(registerdate).to eq 'Registered on '+ date_format
end 

When(/^I can click the reject button the system will go next screen$/) do 
  pending # Write code here that turns the phrase above into concrete actions 
end 

Then(/^the next screen will be the rejection screen$/) do 
  pending # Write code here that turns the phrase above into concrete actions 
end 

Given(/^the application has been cancelled$/) do 
  pending # Write code here that turns the phrase above into concrete actions 
end 

When(/^we check the bankruptcy database record there must be a indicator for cancelled$/) do 
  pending # Write code here that turns the phrase above into concrete actions 
end 

Then(/^the indicator must be Y for cancelled$/) do 
  pending # Write code here that turns the phrase above into concrete actions 
end 