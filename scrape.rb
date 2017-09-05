require 'mechanize'
require_relative 'secrets'

# Login and return admin homepage.
def login
  mech = Mechanize.new
  page = mech.get(LOGIN_URL)
  username_field = page.form.field_with(id: 'user_email')
  username_field.value = USER
  password_field = page.form.field_with(id: 'user_password')
  password_field.value = PASS
  page.form.submit
end

# Return links of all courses.
def getCourseLinks(page)
  page.links.each { |link|
    if link.href == "/courses"
      return link.click.links
    end
  }
end

# Scrape all courses.
def scrapeCourses(course_links)
  # Init File I/O
  file = open('results.txt', 'w')
  # Loop through all courses.
  for course_link in course_links
    # Hack to differentiate course links from other links on the page.
    next if course_link.text.length < 100 || course_link.text.split(" ").join(" ") == "Prometheus Fundamentals"
    course_title = course_link.text.split(" ").join(" ")
    writeCourseTitle(file, course_title)
    puts "Getting next course.....#{course_title}"
    scrapeLectures(file, course_link.click.links)
  end
  file.close
end

# Scrape all lectures of given course.
def scrapeLectures(file, lecture_links)
  # Loop through all lectures in given course.
  for lecture_link in lecture_links
    # Hack to differentiate lecture links from other links on the page.
    next if lecture_link.text.length < 100
    page = lecture_link.click

    # Get lecture title.
    title = getLectureTitle(page)
    puts "Scraping next lecture........#{title}"

    # Hack to skip over quizes.
    next if page.at("div.lecture-text-container").nil?

    # Get lecture content.
    content = ""
    page.at("div.lecture-text-container").children.children.each do |p|
      content <<  p
    end
    writeLectureContent(file, title, content)
  end
end

def getLectureTitle(page)
  page.at("h2#lecture_heading.section-title").children.last.text.split(" ").join(" ")
end

def writeCourseTitle(file, course_title)
  file.write("*******************************\n")
  file.write("///////////////////////////////\n")
  file.write(course_title + "\n")
  file.write("///////////////////////////////\n")
  file.write("*******************************\n\n")
end

def writeLectureContent(file, title, content)
  # Write scraped results to file.
  file.write("/////\n")
  file.write(title + "\n")
  file.write("/////\n\n")
  file.write(content + "\n")
end

scrapeCourses(getCourseLinks(login))
puts "Finished! Check results.txt for all courses and their text content :)"
