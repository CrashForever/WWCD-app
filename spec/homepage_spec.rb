# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Homepage' do
  before do
    unless @browser
      VideosPraise::ApiGateway.new.delete_all_videos
      @headless = Headless.new
      @browser = Watir::Browser.new
    end
  end

  after do
    @browser.close
    @headless.destroy
  end

  describe 'Empty Homepage' do
    it '(HAPPY) should see no content' do
      # GIVEN: user is on the home page without any projects
      @browser.goto homepage

      # THEN: user should see basic headers, no projects and a welcome message
      _(@browser.h1(id: 'main_header').text).must_equal 'VideosPraise'
      _(@browser.text_field(name: 'search_name').visible?).must_equal true
      _(@browser.text_field(id: 'search_input').visible?).must_equal true
      _(@browser.button(id: 'search_btn').visible?).must_equal true
      _(@browser.div(id: 'flash_bar_success').visible?).must_equal true
      _(@browser.div(id: 'flash_bar_success').text).must_include 'Search Some Recepts!'
    end
  end

  # describe 'Add new video' do
    it '(HAPPY) should add valid URL' do
      # GIVEN: user is on the home page
      @browser.goto homepage

      # WHEN: user enters a valid URL for a new repo
      @browser.text_field(id: 'search_input').set('tomato')
      @browser.button(id: 'search_btn').click
      _(@browser.div(id: 'flash_bar_success').text).must_include 'Search success!'
      _(@browser.div(id: 'flash_bar_danger').exists?).must_equal false

      # THEN: user should see their new repo listed in a table
  #     table = @browser.table(id: 'repos_table')
  #     _(@browser.table(id: 'repos_table').exists?).must_equal true
  #
  #     row = table.rows[1]
  #     _(table.rows.count).must_equal 2
  #     _(row.td(id: 'td_owner').text).must_equal 'soumyaray'
  #     _(row.td(id: 'td_repo_name').text).must_equal 'YPBT-app'
  #     _(row.td(id: 'td_link').text).include? 'https'
  #     _(row.td(id: 'td_contributors').text.split(', ').count).must_equal 3
    end
  #
  #   it '(BAD) should not accept incorrect URL' do
  #     # GIVEN: user is on the home page
  #     @browser.goto homepage
  #
  #     # WHEN: user enters an invalid URL
  #     @browser.text_field(id: 'url_input').set('http://bad_url')
  #     @browser.button(id: 'repo_form_submit').click
  #
  #     # THEN: user should see an error alert and no table of repos
  #     _(@browser.div(id: 'flash_bar_danger').text).must_include 'Invalid'
  #     _(@browser.table(id: 'repos_table').exists?).must_equal false
  #   end
  #
  #   it '(SAD) should not accept duplicate repo' do
  #     # GIVEN: user is on the home page
  #     @browser.goto homepage
  #
  #     # WHEN: user enters a URL that was previously loaded
  #     @browser.text_field(id: 'url_input').set('https://github.com/soumyaray/YPBT-app')
  #     @browser.button(id: 'repo_form_submit').click
  #     @browser.text_field(id: 'url_input').set('https://github.com/soumyaray/YPBT-app')
  #     @browser.button(id: 'repo_form_submit').click
  #
  #     # THEN: user should should see an error alert and the existing repo
  #     _(@browser.div(id: 'flash_bar_danger').text).must_include 'already loaded'
  #     _(@browser.table(id: 'repos_table').visible?).must_equal true
  #     _(@browser.table(id: 'repos_table').rows.count).must_equal 2
  #   end
  # end
end
