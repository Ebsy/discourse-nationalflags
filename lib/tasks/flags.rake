desc "create users and generate random reactions on a post"
task "nationalflags:assign" => :environment do
  user_ids = UserCustomField.where(name: 'nationalflag_iso').pluck(:user_id)
  flags = YAML.safe_load(File.read(File.join(Rails.root, 'plugins', 'discourse-nationalflags', 'config', 'flags.yml')))
  User.where.not(id: user_ids).where(id: 1..).each do |user|
    puts "Username: #{user.name}"
    puts "IP: #{user.ip_address}"

    if user.ip_address
      geocoder_result = Geocoder.search(user.ip_address.to_s)
      country = geocoder_result.first.data["country"] if geocoder_result.first
      puts "Country name from IP address: #{country}"
      if country && flags[country.downcase]
        user.custom_fields['nationalflag_iso'] = country.downcase
        user.save_custom_fields
      end
    end
  end
end
