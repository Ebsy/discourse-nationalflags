# name: discourse-nationalflags
# about: Display National Flags from User's home countries.
# version: 1.0.0
# author: Neil Ebrey <neil.ebrey@gmail.com>
# url: https://github.com/Ebsy/discourse-nationalflags

enabled_site_setting :nationalflag_enabled

PLUGIN_NAME = "discourse-nationalflags"

DiscoursePluginRegistry.serialized_current_user_fields << "nationalflag_iso"

after_initialize do

  module ::DiscourseNationalFlags
    class Engine < ::Rails::Engine
      engine_name "discourse_national_flags"
      isolate_namespace DiscourseNationalFlags
    end
  end

  require_dependency 'about_controller'

  Discourse::Application.routes.append do
    mount ::DiscourseNationalFlags::Engine, at: 'natflags'
  end

  ::DiscourseNationalFlags::Engine.routes.draw do
    get "/flags" => "flags#flags"
  end

    class ::DiscourseNationalFlags::Flag
      attr_reader :code, :pic
      def initialize(code, pic)
          @code = code
          @pic = pic
      end
  end

class ::DiscourseNationalFlags::FlagsController < ::ApplicationController

    def flags
        raw_flags = YAML.safe_load(File.read(File.join(Rails.root, 'plugins', 'discourse-nationalflags', 'config', 'flags.yml')))

        flagscollection = []

        raw_flags.map do |code, pic| 
            # This is super hacky.  Adding the trailing space actually stops search breaking in the dropdown! (and doesn't compromise the view!)
            # Feeding just name, name will break search
            flagscollection << DiscourseNationalFlags::Flag.new(code, pic)
        end

        render json: flagscollection
    end
end


  public_user_custom_fields_setting = SiteSetting.public_user_custom_fields
  if public_user_custom_fields_setting.empty?
    SiteSetting.set("public_user_custom_fields", "nationalflag_iso")
  elsif public_user_custom_fields_setting !~ /nationalflag_iso/
    SiteSetting.set(
      "public_user_custom_fields",
      [SiteSetting.public_user_custom_fields, "nationalflag_iso"].join("|")
    )
  end

  User.register_custom_field_type('nationalflag_iso', :text)

  register_editable_user_custom_field :nationalflag_iso if defined? register_editable_user_custom_field
  
  if SiteSetting.nationalflag_enabled then
    add_to_serializer(:post, :user_signature, false) {
      object.user.custom_fields['nationalflag_iso']
    }

    # I guess this should be the default @ discourse. PR maybe?
    add_to_serializer(:user, :custom_fields, false) {
      if object.custom_fields == nil then
        {}
      else
        object.custom_fields
      end
    }
  end

  # Alternate 'routes' example. create route and serve JSON.
  # module ::DiscourseNationalFlags
  #   class Engine < ::Rails::Engine
  #     engine_name PLUGIN_NAME
  #     isolate_namespace DiscourseNationalFlags
  #   end
  # end
  #
  # require_dependency "application_controller"
  #
  # ::DiscourseNationalFlags::Engine.routes.draw do
  #   get "nationalflags" => "files#index"
  # end
  #
  # Discourse::Application.routes.append do
  #   mount ::DiscourseNationalFlags::Engine, at: "/"
  # end
  #
  # module ::DiscourseNationalFlags
  #   class FilesController < ApplicationController
  #     def index
  #       #include ActiveModel::Serialization
  #       path = "#{Rails.root}/plugins/discourse-nationalflags/public/images/nationalflags/*"
  #
  #       @files = []
  #
  #       Dir.glob(path).sort.each { |flag| @files << {:name => File.basename(flag, ".png"), :value => File.basename(flag)} }
  #
  #       logger.fatal @files
  #       render json: @files
  #     end
  #   end
  # end
end

register_asset "javascripts/discourse/templates/connectors/user-custom-preferences/user-nationalflags-preferences.hbs"
register_asset "javascripts/discourse/templates/connectors/user-profile-primary/show-user-card.hbs"
register_asset "stylesheets/nationalflags.scss"

DiscourseEvent.on(:custom_wizard_ready) do
  if defined?(CustomWizard) == 'constant' && CustomWizard.class == Module
    CustomWizard::Field.add_assets('national-flag', 'discourse-nationalflags', ['components', 'templates'])

    ## user.geo_location requires location['geo_location'] to be the value
    CustomWizard::Builder.add_field_validator('national-flag') do |field, updater, step_template|
      if step_template['actions'].present?
        step_template['actions'].each do |a|
          if a['type'] === 'update_profile'
            a['profile_updates'].each do |pu|
              if pu['key'] === field['id'] && pu['value_custom'] === 'nationalflag_iso'
                updater.fields[field['id']] = updater.fields[field['id']]['nationalflag_iso']
              end
            end
          end
        end
      end
    end
  end
end
