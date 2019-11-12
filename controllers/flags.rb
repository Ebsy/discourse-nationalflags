class ::DiscourseNationalFlags::FlagsController < ::ApplicationController
    def flags
        raw_flags = YAML.safe_load(File.read(File.join(Rails.root, 'plugins', 'discourse-nationalflags', 'config', 'flags.yml')))

        flagscollection = []

        raw_flags.map do |code, pic| 
            flagscollection << DiscourseNationalFlags::Flag.new(code, pic)
        end

        render json: flagscollection
    end
end