# frozen_string_literal: true
class ::DiscourseNationalFlags::Flag
  attr_reader :code, :pic
  def initialize(code, pic)
    @code = code
      @pic = pic
  end
end
