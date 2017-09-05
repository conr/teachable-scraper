# Teachable Scraper Script
Simple ruby script using [mechanize](https://github.com/sparklemotion/mechanize) to scrape and create backups of course and lecture text content from teachable.com

# Usage

Add secrets.rb file containing <code>USER</code>, <code>PASS</code>, and <code>LOGIN_URL</code> string constants in same directory as <code>scrape.rb</code>

Note: <code>LOGIN_URL</code> must the login page of the course <b>NOT</b> http://teachable.com/login

<code>$ gem install mechanize</code>

<code>$ ruby scraper.rb</code>

View results in <code>results.txt</code>

