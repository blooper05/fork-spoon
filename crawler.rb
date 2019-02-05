# frozen_string_literal: true

require 'bundler'
Bundler.require

DOMAIN = 'https://github.com'
SUFFIX = 'network/members'

OPTS = {
  delay:       1,
  depth_limit: 1,
  # obey_robots_txt: true
}.freeze

(ACCOUNT    = Readline.readline('Account: ')).empty?    && raise
(REPOSITORY = Readline.readline('Repository: ')).empty? && raise

ORIGINAL = "#{DOMAIN}/#{ACCOUNT}/#{REPOSITORY}/#{SUFFIX}"
FORKS    = %r{\A#{DOMAIN}/[a-zA-Z0-9-]+/#{REPOSITORY}\z}.freeze

XPATH = '//a[contains(./@href, "/stargazers")]'

Anemone.crawl(ORIGINAL, OPTS) do |anemone|
  anemone.on_pages_like(FORKS) do |page|
    stars = page.doc.at_xpath(XPATH).text.strip
    url   = page.url
    puts "#{stars} #{url}"
  end
end
