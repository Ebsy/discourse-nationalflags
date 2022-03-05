desc "create users and generate random reactions on a post"
task "nationalflags:assign" => :environment do
  if !SiteSetting.abstract_api_key_for_bulk_assign
    raise "Please provide an API KEY from https://www.abstractapi.com to bulk assign National flags"
  end

  Geocoder.configure(
    ip_lookup: :abstract_api,
    api_key: SiteSetting.abstract_api_key_for_bulk_assign
  )

  user_ids = UserCustomField.where(name: 'nationalflag_iso').pluck(:user_id)
  flags = YAML.safe_load(File.read(File.join(Rails.root, 'plugins', 'discourse-nationalflags', 'config', 'flags.yml')))
  User.where.not(id: user_ids).where(id: 1..).each do |user|
    puts "Username: #{user.username}"
    puts "IP: #{user.ip_address}"

    if user.ip_address
      geocoder_result = Geocoder.search(user.ip_address.to_s)
      country = geocoder_result.first.data["country_code"] if geocoder_result.first

      if !country
        puts "Country name not found"
        next
      end

      puts "Country name from IP address: #{country}"
      if country && flags[country.downcase]
        puts "Username: #{user.username} National Flag is #{country}"
        user.custom_fields['nationalflag_iso'] = country.downcase
        user.save_custom_fields
      end
    end
  end
end
