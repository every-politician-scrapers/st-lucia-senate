#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      noko.css('h3,strong').text.gsub('Senator ','').gsub('Hon. ', '').gsub(/,\s*$/,'').tidy
    end

    def filled?
      !name.to_s.empty?
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.map { |member| fragment(member => Member) }.select(&:filled?).map(&:to_h)
    end

    private

    def member_container
      noko.css('.mce-item-table').xpath('.//tr[td[@align="left"]]')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
