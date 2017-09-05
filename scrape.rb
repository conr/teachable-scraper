require 'mechanize'
require 'pry'
require_relative "secrets"

# Create new agent
mech = Mechanize.new

# Init File I/O
file = open("results.txt", 'w')

# Login
page = mech.get(LOGIN_URL)
username_field = page.form.field_with(id: 'user_email')
username_field.value = USER
password_field = page.form.field_with(id: 'user_password')
password_field.value = PASS
page = page.form.submit

# Nav to all courses page
page.links.each { |link|
  if link.href == "/courses" 
	page = link.click
	break
  end
}

# Enter first course TODO: add loop through all courses
page = page.links[14].click

# Loop through all lectures in given course

lecture_links = page.links

for i in 10..lecture_links.count 
  page = lecture_links[i].click

  # Get lecture title
  title = page.at("h2#lecture_heading.section-title").children.last.text.gsub(/\s/,'')

  # Get lecture content
  content = ""

  unless page.at("div.lecture-text-container").nil?
    page.at("div.lecture-text-container").children.children.each do |p| 
      content <<  p
    end

    puts "Scraping........"

    # Write results to file
    file.write("/////\n")
    file.write(title + "\n")
    file.write("/////\n")
    file.write(content + "\n")
  end
end

  file.close

binding.pry
