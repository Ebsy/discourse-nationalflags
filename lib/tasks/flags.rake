# frozen_string_literal: true

desc "Assign Country to existing users"
task "nationalflags:assign" => :environment do
  if !SiteSetting.abstract_api_key_for_bulk_assign
    raise "Please provide an API KEY from https://www.abstractapi.com to bulk assign National flags"
  end

  assign_country()
end

desc "Export Users in a CSV file"
task "nationalflags:users_csv_export" => :environment do
  assign_country()

  file = "#{Rails.root}/plugins/discourse-nationalflags/public/user_data#{(0...16).map { (65 + rand(26)).chr }.join}.csv"
  users = User.where(id: 1..).order(:username)
  headers = ["Username", "IP", "Register IP" "location", "Last Seen", "Latest Post", "Post Count", "Multiple Accounts"]

  CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
    users.each do |user|
      ip_addresses = User.where.not(id: 1).pluck(:ip_address, :registration_ip_address).flatten - [nil]
      multiple_accounts = ip_addresses.include?(user.ip_address)
      if user.posts.length > 0
        last_post_url = user.posts.order(created_at: :desc).first.full_url
      end

      writer << [user.username, user.ip_address, user.registration_ip_address, user.custom_fields['nationalflag_iso'], user.last_seen_at, last_post_url, user.post_count, multiple_accounts]
    end
  end

  puts "Users CSV can be found here: #{file}"
end

def assign_country
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

    sleep(1)
  end
end
