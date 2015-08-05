

bob_howard = '{"key_number":"1479067","application_type":"PA(B)","application_ref":"9045789","date":"2014-10-28","debtor_name":{"forenames":["Bob","Oscar","Francis"],"surname":"Howard"},"debtor_alternative_name":[],"gender":"N/A","occupation":"Bookmaker","residence":[{"address_lines":["1940 Huels Fort","North Glennamouth","South Nonafort","West Yorkshire"],"postcode":"PA85 4RH"}],"residence_withheld":false,"business_address":{"address_lines":["831 Hailee Burg","Chasityborough","East Tamara","Northamptonshire"],"postcode":"IP81 2CM"},"date_of_birth":"1974-10-07","investment_property":[]}'

class AssertionFailure < RuntimeError
end

def assert( condition, message = nil )
    unless( condition )
        raise AssertionFailure, message
    end
end

class RestAPI
	attr_reader :response, :data

    def initialize(uri)
        @uri = URI(uri)
        @http = Net::HTTP.new(@uri.host, @uri.port)
    end

    def post_data(url, data)
        request = Net::HTTP::Post.new(url)
        request.body = data
        request["Content-Type"] = "application/json"
        @response = @http.request(request)
        if @response.body == ""
			nil
        else
			@data = JSON.parse(@response.body)
		end
    end

end

class PostgreSQL
	def self.connect(database)
		@@pg = PGconn.connect( 'localhost', 5432,  '', '', database, 'vagrant', 'vagrant')
	end

	def self.disconnect
		@@pg.close
	end

	def self.query(sql)
		@@pg.exec(sql)
	end

end

Before do |scenario|
end

After do |scenario|
    if scenario.name == "Auto update application totals"
        ids = `vagrant ssh -c "psql -d working -c \\"select id from pending_application where trim(both ' ' from forenames) = 'Bob Oscar Francis' and surname = 'Howard';\\""`.split(/\r?\n/)
        param = '(' + ids[2..-2].join(',') + ')'
        puts(param)

        `vagrant ssh -c "psql -d working -c \\"delete from pending_application where id in #{param}\\""`
    end
end

Given(/^I have selected to view the main worklist$/) do
  visit( 'http://localhost:5010')
end

When(/^I have selected to view specific the application list "(.*)"$/) do |type|
    visit( "http://localhost:5010/get_list?appn=#{type}" )
end

When(/^I can see the total PABS$/) do
    page.should have_css("div#pab_total", :text => '6')
end

When(/^I have submitted a new PAB$/) do
    registration_api = RestAPI.new("http://localhost:5006")
    registration_api.post_data("/lodge_manual", bob_howard)
end

When(/^I have waited (\d+) seconds$/) do |seconds|
    sleep(seconds.to_i)
end

Then(/^I see the totals refresh$/) do
    page.should have_css("div#pab_total", :text => '7')
end

Then (/^I see the pab application list page$/) do
    page.should have_content("PA Bankruptcy Registrations")
    page.should have_content("21 September 2014")
    page.should have_css('div#pab_total', :text => '6')
end

Then (/^I see the wob application list page$/) do
    page.should have_content("WO Bankruptcy Registrations")
    page.should have_content("30 August 2014")
end

Then (/^I see the application list page with no waiting apps$/) do
    page.should have_content("There are no waiting applications")
end

Then (/^I see the application totals$/) do
    page.should have_css("div#pab_total")
    page.should have_css("div#wob_total")
    page.should have_css("div#lcreg_total")
    page.should have_css("div#amend_total")
    page.should have_css("div#canc_total")
    page.should have_css("div#portal_total")
    page.should have_css("div#search_total")
    page.should have_css("div#oc_total")
end

When(/^I select a pab application$/) do
    visit( "http://localhost:5010/get_application/pab/8" )
end

Then (/^I see the application details page$/) do
    page.should have_content("Application details")
end

Then (/^I close browser$/) do
    page.driver.browser.close
end

Then (/^I open a new browser instance$/) do
    Capybara.send(:session_pool).delete_if { |key, value| key =~ /selenium/i }
end
