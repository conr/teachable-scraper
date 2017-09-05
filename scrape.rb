require 'mechanize'
require 'pry'
require_relative 'secrets'

# Create new agent
mech = Mechanize.new

# Init File I/O
file = open('results.txt', 'w')

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

course_links = page.links
# Loop through all courses
for course_link in course_links
  if course_link.text.length < 100 || course_link.text.split(" ").join(" ") == "Prometheus Fundamentals"
    next
  end
  course_title = course_link.text.split(" ").join(" ")
  puts "Getting next course.....#{course_title}"
  file.write("*******************************\n")
  file.write("///////////////////////////////\n")
  file.write(course_title + "\n")
  file.write("///////////////////////////////\n")
  file.write("*******************************\n\n")
  page = course_link.click
  lecture_links = page.links

  # Loop through all lectures in given course
  for lecture_link in lecture_links
    if lecture_link.text.length < 100
      next
    end
    page = lecture_link.click

    # Get lecture title
    title = page.at("h2#lecture_heading.section-title").children.last.text.split(" ").join(" ")

    # Get lecture content
    content = ""

    unless page.at("div.lecture-text-container").nil?
      page.at("div.lecture-text-container").children.children.each do |p|
        content <<  p
      end

      puts "Scraping next lecture........#{title}"

      # Write results to file
      file.write("/////\n")
      file.write(title + "\n")
      file.write("/////\n\n")
      file.write(content + "\n")
    end
  end
end

file.close

puts "Finished! Check results.txt for all courses and their text content :)"
