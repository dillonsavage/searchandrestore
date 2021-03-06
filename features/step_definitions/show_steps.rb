Given /^I create a show$/ do
  Then %{I go to the new admin show page}
  And  %{I fill in the new show form with valid attributes}
  And  %{I press "Create Show"}
end

Then /^I click the featured checkboxes for the shows$/ do
  Show.all.each do |show|
    page.find("#edit_show_#{show.id} > #show_featured").click
  end
end

Then /^I click the search and restore checkboxes for the shows$/ do
  Show.all.each do |show|
    page.find("#edit_show_#{show.id} > #show_search_and_restore").click
  end
end

Then /^the show should be a search and restore show$/ do
  the.show.search_and_restore?.should be_true
end

Then /^the show should be featured$/ do
  the.show.featured.should be_true
end

Then /^the shows should be search and restore shows$/ do
  Show.all.each do |show|
    the.show = show
    Then %{the show should be a search and restore show}
  end
end

Then /^the shows should be featured shows$/ do
  Show.all.each do |show|
    the.show = show
    Then %{the show should be featured}
  end
end

Given /^I fill in the new show form with valid attributes$/ do
  Then %{I select "#{the.venue.name}" from "Venue"}
  Then %{I fill in "Group name" with "#{Faker::Lorem.words.join(' ')}"}
  Then %{I fill in "Description" with "#{Faker::Lorem.paragraphs.join("\n")}"}
end

Then /^the show should have one performance for the artist(?: "([^"]+)")? and the instrument(?: "([^"]+)")?$/ do |artist_name, instrument_name|
  the.show.should have(1).performance

  performance = the.show.performances.first

  if artist_name.present?
    performance.artist.name.should == artist_name
  else
    performance.artist.should == the.artist
  end

  if instrument_name.present?
    performance.instrument.name.should == instrument_name
  else
    performance.instrument.should == the.instrument
  end
end

Given /^the( last)? show has an additional video$/ do |last|
  Factory(:video, :show => (last ? Show.last : the.show))
end

Then /^I should see the show$/ do
  Then %{I should see "#{the.show.group_name}"}
  And  %{I should see a link to "#{url_for(the.show.venue)}" with the text "#{the.show.venue.name}"}

  the.show.performances.each do |performance|
    And  %{I should see a link to "#{url_for(performance.artist)}" with the text "#{performance.artist.name}(#{performance.instrument.name})"}
  end

  the.show.description.split(/\n+/).each do |fragment|
    Then %{I should see "#{fragment}"}
  end if the.show.description.present?
end

Then /^I should not see the show$/ do
  page.should have_no_css("[id=show_#{the.show.id}]")
end

Then /^I should( not)? see the shows( not)? happening today$/ do |should_see, today|
  today = today.blank?

  (today ? Show.today : Show.not_today).each do |show|
    the.show = show
    Then %{I should#{should_see} see the show}
  end
end

Then /^I should( not)? see the shows with a when of "([^"]+)"$/ do |should_i, day|
  Show.for_day(day).each do |show|
    the.show = show
    Then %{I should#{should_i} see the show}
  end
end

Then /^I should see the upcoming search and restore shows section$/ do
  within('#upcoming-search-and-restore') do
    Then %{I should see the search and restore shows}
    And  %{I should see a link to "#{shows_path(:search => { :search_and_restore_is_true => 1 })}"}
  end
end

Then /^I should see the search and restore shows$/ do
  Show.all.each do |show|
    the.show = show
    Then %{I should#{show.search_and_restore? ? '' : ' not'} see the show}
  end
end

Then /^I should only see the shows for the artist with name "([^"]+)"$/ do |name|
  the.artist = Artist.find_by_name(name)

  Show.all.each do |show|
    the.show = show
    Then %{I should#{show.artists.include?(the.artist) ? '' : ' not'} see the show}
  end
end

Then /^I should only see the shows for the venue with name "([^"]+)"$/ do |name|
  the.venue = Venue.find_by_name(name)

  Show.all.each do |show|
    the.show = show
    Then %{I should#{show.venue == the.venue ? '' : ' not'} see the show}
  end
end
