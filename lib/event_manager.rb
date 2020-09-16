require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

@hours = []
@days = []

def registration_hour(datetime)
  datetime_format = '%m/%d/%y %H:%M'
  datetime_object = DateTime.strptime(datetime, datetime_format)
  datetime_object.hour.to_s
end

def registration_day(datetime)
  datetime_format = '%m/%d/%y %H:%M'
  datetime_object = DateTime.strptime(datetime, datetime_format)
  datetime_object.wday.to_s
end

def popular_hours(hours)
  overnight = morning = afternoon = evening = 0
  integer_hours = hours.map(&:to_i)
  integer_hours.each do |hour|
    if hour > 0 && hour <= 6
      overnight += 1
    elsif hour > 6 && hour <= 12
      morning += 1
    elsif hour > 12 && hour <= 18
      afternoon += 1
    elsif hour > 18 && hour <= 24
      evening += 1
    end
  end
  display_popular_hours(overnight, morning, afternoon, evening)
end

def display_popular_hours(overnight, morning, afternoon, evening)
  puts 'Number of Registrations by Time of Day:'
  puts
  puts "Overnight (00:00 - 06:00): #{overnight}"
  puts "Morning (06:01 - 12:00): #{morning}"
  puts "Midday (12:01 - 18:00): #{afternoon}"
  puts "Evening (18:01 - 24:00): #{evening}"
  puts
end

def popular_days(days)
  sun = mon = tue = wed = thu = fri = sat = 0
  days.each do |wday|
    if wday == '0'
      sun += 1
    elsif wday == '1'
      mon += 1
    elsif wday == '2'
      tue += 1
    elsif wday == '3'
      wed += 1
    elsif wday == '4'
      thu += 1
    elsif wday == '5'
      fri += 1
    elsif wday == '6'
      sat += 1
    end
  end
  display_popular_days(sun, mon, tue, wed, thu, fri, sat)
end

def display_popular_days(sun, mon, tue, wed, thu, fri, sat)
  puts 'Registrations per day of the week: '
  puts
  puts "Sunday: #{sun}"
  puts "Monday: #{mon}"
  puts "Tuesday: #{tue}"
  puts "Wednesday: #{wed}"
  puts "Thursday: #{thu}"
  puts "Friday: #{fri}"
  puts "Saturday: #{sat}"
  puts
end

def clean_phonenumber(phonenumber)
  if phonenumber.length == 10
    phonenumber
  elsif phonenumber.length > 11
    ''
  elsif phonenumber.length < 10
    '' 
  elsif (phonenumber.length == 11) && (phonenumber[0] == '1')
    phonenumber[1..-1]
  elsif phonenumber.nil?
    ''
  end
end

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials    
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized!'

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read 'form_letter.erb'
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  phonenumber = clean_phonenumber(row[:homephone].gsub(/([-(). ])/, ''))
  
  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
  
  # Find the popular registration time targets
  hour = (registration_hour(row[:regdate]))
  @hours.push(hour)
  day = (registration_day(row[:regdate]))
  @days.push(day)
end

popular_hours(@hours)
popular_days(@days)