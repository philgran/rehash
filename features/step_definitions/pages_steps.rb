Given /^I have pages (.+)$/ do |names|
  Page.destroy_all
  names.split(', ').each do |name|
    Page.create! :name => name, :body => 'body'
  end
end

Given /^I have no pages$/ do
  Page.destroy_all
end

Then /^I delete the page (.+)$/ do |name|
  page = Page.find_by_name(name)
  click_link "delete_page_#{page.id}"
end

Then /^I edit the page (.+)$/ do |name|
  page = Page.find_by_name(name)
  click_link "edit_page_#{page.id}"
end