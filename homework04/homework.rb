require 'json'

RESPONSE='{"person":{ "personal_data":{"name": "John Smith", "gender":"male", "age":56, "residence":"Gibraltar"},
                  "social_profiles":["http://facebook....","http://twitter...","http://instagram.com", "http://linkedin.com"],
                      "additional_info":{"hobby":["pubsurfing","drinking","hiking","biking","travelling"],
                  "pets":[{"name":"Mittens","species":"Felis silvestris catus"}],"languages":["english", "french", "spanish"]}}}'
response = JSON.parse(RESPONSE)

Person = Struct.new(*response["person"].keys.collect(&:to_sym)) do

  def adult?
    is_adult = false
    personal_data.each do |key, value|
      if key=="age" && !(value.nil?)
        if value>=0
          value < 18 ? is_adult = false : is_adult = true
        end
      end
    end
    is_adult
  end

  def twitter_account?
    has_twitter = false
    social_profiles.each do |profile|
      if profile.scan(/twitter/).length > 0
        has_twitter = true
      end
    end
    has_twitter
  end

  def has_hobbies?
    hobbies = ""
    if additional_info['hobby']
      hobby_list = additional_info['hobby']
      hobbies = hobby_list.join ", "
    else hobbies="no"
    end
    hobbies
  end

  def languages?
    if additional_info['languages']
      languages = additional_info['languages']
      lang_list=languages.join ", "
    else lang_list = "not_presented"
    end
    lang_list
  end

  def show_person_info
    puts "Person info:"
    self.each_pair do |key, data|
      p "Part #{key} :"
      if data.is_a?(Hash)
        data.each_pair do |data_key, data_value|
          p "#{data_key} : #{data_value}"
          end
          end
      if data.is_a?(Array)
        p data.join ", "
      end
    end
  end
end

person = Person.new(*response["person"].values)

person.show_person_info
puts "Additional info:"
puts "Is adult?"
p person.adult?
puts "Has Twitter account?"
p person.twitter_account?
puts "Has Hobbies?"
p person.has_hobbies?
puts "Knows languages?"
p person.languages?