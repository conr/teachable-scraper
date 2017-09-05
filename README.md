# Teachable Scraper Script
Ruby script using [mechanize](https://github.com/sparklemotion/mechanize) to scrape and create backups of course and lecture text content from [teachable.com](https://teachable.com)

# Usage

Add secrets.rb file containing <code>USER</code>, <code>PASS</code>, and <code>LOGIN_URL</code> string constants in same directory as <code>scrape.rb</code> (see <code>secrets_example.rb</code> for example).

Note: <code>LOGIN_URL</code> must be the login page of the course <b>NOT</b> http://teachable.com/login

<code>$ gem install mechanize</code>

<code>$ ruby scraper.rb</code>

View results in <code>results.txt</code>
