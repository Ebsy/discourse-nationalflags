# frozen_string_literal: true
class ::DiscourseNationalFlags::FlagList
  def self.list
    raw_flags = YAML.safe_load(File.read(File.join(Rails.root, 'plugins', 'discourse-nationalflags', 'config', 'flags.yml')))
    flagscollection = raw_flags.map do |code, pic|
      ::DiscourseNationalFlags::Flag.new(code, pic)
    end

    flagscollection
  end
end
