module DateInquirer
  %w(sunday monday tuesday wednesday thursday friday saturday).each_with_index do |day, index|
    define_method("#{day}?") do
      wday == index
    end
  end
end
