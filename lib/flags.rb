# module DiscourseNationalFlags
#     class ::Flag
#         attr_reader :id :name
#         def initialize(id, name)
#             @id = id
#             @name = name
#         end
#     end

#     class ::FlagsController < ::ApplicationController

#         def flags
#             raw_flags = YAML.safe_load(File.read(File.join(Rails.root, 'plugins', 'discourse-nationalflags', 'config', 'flags.yml')))

#             flagscollection = []

#             raw_flags.map do |name, pic| 
#                 # This is super hacky.  Adding the trailing space actually stops search breaking in the dropdown! (and doesn't compromise the view!)
#                 # Feeding just name, name will break search
#                 flagscollection << DiscourseNationalFlags::Flag.new(name, "#{name} ")
#             end

#             render flagscollection
#         end
#     end
# end
