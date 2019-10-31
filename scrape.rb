require "mechanize"
require_relative "secrets"

class TeachableScraper
  attr_reader :target_title

  def initialize(target_title:)
    @target_title = target_title
  end

  def perform
    course_page = login
    course_links = get_course_links(course_page)
    scrape_courses(course_links)

    puts "Finished! Check results.txt for all courses and their text content :)"
  end

  private

  # Return links of all courses.
  def get_course_links(page)
    page.links.each do |link|
      return link.click.links if link.href == "/courses"
    end
  end

  # Login and return admin homepage.
  def login
    mech = Mechanize.new
    page = mech.get(LOGIN_URL)
    username_field = page.form.field_with(id: "user_email")
    username_field.value = USER
    password_field = page.form.field_with(id: "user_password")
    password_field.value = PASS
    page.form.submit
  end

  # Scrape all courses.
  def scrape_courses(course_links)
    file = open("results.txt", "w")
    # Loop through all courses.
    course_links.each do |course_link|
      # Hack to differentiate course links from other links on the page.
      next if course_link.text.length < 100 || course_link.text.split(" ").join(" ") == target_title

      course_title = course_link.text.split(" ").join(" ")
      write_course_title(file, course_title)
      puts "Getting next course.....#{course_title}"
      scrape_lectures(file, course_link.click.links)
    end
    file.close
  end

  # Scrape all lectures of given course.
  def scrape_lectures(file, lecture_links)
    # Loop through all lectures in given course.
    lecture_links.each do |lecture_link|
      # Hack to differentiate lecture links from other links on the page.
      next if lecture_link.text.length < 100

      page = lecture_link.click

      # Get lecture title.
      title = get_lecture_title(page)
      puts "Scraping next lecture........#{title}"

      # Hack to skip over quizes.
      next if page.at("div.lecture-text-container").nil?

      # Get lecture content.
      content = ""
      page.at("div.lecture-text-container").children.children.each do |p|
        content << p
      end
      write_lecture_content(file, title, content)
    end
  end

  def get_lecture_title(page)
    page.at("h2#lecture_heading.section-title").children.last.text.split(" ").join(" ")
  end

  def write_course_title(file, course_title)
    file.write("*******************************\n")
    file.write("///////////////////////////////\n")
    file.write(course_title + "\n")
    file.write("///////////////////////////////\n")
    file.write("*******************************\n\n")
  end

  def write_lecture_content(file, title, content)
    # Write scraped results to file.
    file.write("/////\n")
    file.write(title + "\n")
    file.write("/////\n\n")
    file.write(content + "\n")
  end
end
