# frozen_string_literal: true
class ::DiscourseNationalFlags::FlagsController < ::ApplicationController
  def flags
    flag_list = ::DiscourseNationalFlags::FlagList.list
    render json: flag_list
  end
end
