# This solution meets the requirements of the challenge. It was made with readability and maintainability in mind, 
# with efficiency as less of a priority. By using a main class and different methods, the code is easier to read 
# and maintaing. Each method can be tested easier individually with different use cases.


require 'date'

class Photo
  attr_reader :city, :datetime, :file_extension, :original_position

  @@all_photos = []
  @@renamed_photos = []

  def initialize(city:, datetime:, file_extension:, original_position:)
    @city = city
    @datetime = datetime
    @file_extension = file_extension
    @original_position = original_position
    @@all_photos << self
  end

  # sort by city and datetime
  def self.sort_photos
    @@all_photos.sort_by! { |photo| [photo.city, photo.datetime] }
  end

  def self.rename_photos
    sort_photos
    name_lengths_by_city = find_name_lengths
    rename_photos_by_city(name_lengths_by_city)
  end
  
  def self.find_name_lengths
    numbering_by_city = Hash.new(0)
    name_length = Hash.new(0)
  
    @@all_photos.each { |photo| name_length[photo.city] = [name_length[photo.city], numbering_by_city[photo.city] += 1].max.to_s.length }
  
    name_length
  end
  
  def self.rename_photos_by_city(name_lengths_by_city)
    numbering_by_city = Hash.new(0)
    @@renamed_photos = []
  
    @@all_photos.each do |photo|
      index = numbering_by_city[photo.city] += 1
      number = index.to_s.rjust(name_lengths_by_city[photo.city], '0')
      new_name = "#{photo.city}#{number}.#{photo.file_extension}"
      @@renamed_photos[photo.original_position] = new_name
    end
    
    @@renamed_photos
  end

  def self.renamed_photos
    @@renamed_photos
  end
end

# Create Hash objects from string of photo names
# Input: <String>
# Format: "photo.jpg, Krakow, 2013-09-05 14:08:15 
# Mike.png, London, 2015-06-20 15:13:22
# ..."
def parse_input(str)
  photos = str.split("\n")
  
  photos.map do |line|
    parts = line.split(', ')
    city = parts[1]
    datetime = DateTime.strptime(parts[2], '%Y-%m-%d %H:%M:%S')
    extension = parts[0].split('.').last
    
    {
      city: city,
      datetime: datetime,
      file_extension: extension,
    }
  end
end

# Create Photo objects from arry of hashes containing photo attributes
# Input: [<Hash>]
# Format: [{
  # "city": "Krakow",
  # "datetime": "2013-09-05 14:08:15",
  # "file_extension": "jpg",
# } ... {}]
def add_photos(photo_arr)
  photo_arr.each_with_index do |photo, index|
    Photo.new(city: photo[:city], datetime: photo[:datetime], file_extension: photo[:file_extension], original_position: index)
  end
end

def solution(s)
  photos = parse_input(s)
  add_photos(photos)
  Photo.rename_photos
  Photo.renamed_photos.join("\n")
end

string = "photo.jpg, Krakow, 2013-09-05 14:08:15 
Mike.png, London, 2015-06-20 15:13:22 
myFriends.png, Krakow, 2013-09-05 14:07:13 
Eiffel.jpg, Florianopolis, 2015-07-23 08:03:02 
pisatower.jpg, Florianopolis, 2015-07-22 23:59:59 
BOB.jpg, London, 2015-08-05 00:02:03 
notredame.png, Florianopolis, 2015-09-01 12:00:00 
me.jpg, Krakow, 2013-09-06 15:40:22
a.png, Krakow, 2016-02-13 13:33:50
b.jpg, Krakow, 2016-01-02 15:12:22
c.jpg, Krakow, 2016-01-02 14:34:30
d.jpg, Krakow, 2016-01-02 15:15:01
e.png, Krakow, 2016-01-02 09:49:09
f.png, Krakow, 2016-01-02 10:55:32
g.jpg, Krakow, 2016-02-29 22:13:11"

new_names = solution(string)
puts new_names